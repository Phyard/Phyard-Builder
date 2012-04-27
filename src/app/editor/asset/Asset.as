
package editor.asset {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.system.Capabilities;
   
   import flash.events.Event;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.display.TextFieldEx;
   
   import editor.core.EditorObject;
   
   import editor.selection.SelectionProxy;
   
   import editor.EditorContext;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Transform2D;
   
   public class Asset extends EditorObject
   {
      protected var mAssetManager:AssetManager;
      protected var mCreationOrderId:int = -1; // to reduce random factors
      protected var mAppearanceLayerId:int = -1;
      public function get appearanceLayerId ():int // for MoveSelectedAssetsToTop/Bottom
      {
         return mAppearanceLayerId;
      }
            
      protected var mSelectionProxy:SelectionProxy = null;
      
      protected var mName:String = "";
      
      protected var mTransform:Transform2D = new Transform2D (); // don't change it directly
      
      //private var mPosX:Number = 0;
      //private var mPosY:Number = 0;
      //
      //private var mScale:Number = 1.0;
      //private var mRotation:Number = 0;
      //private var mFlipped:Boolean = false;
      
      private var mAlpha:Number = 1.0;
      private var mIsVisible:Boolean = true;
      
      public function Asset (assetManager:AssetManager)
      {
         mAssetManager = assetManager;
         
         if (mAssetManager != null) // at some special cases, mAssetManager is null
            mAssetManager.OnAssetCreated (this);
         
         //SetName (null);
         
         mouseChildren = false;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
      public function GetAssetManager ():AssetManager
      {
         return mAssetManager;
      }
      
      public function GetDefaultName ():String
      {
         return GetTypeName ();
      }
      
      public function ToCodeString ():String
      {
         return "Asset#" + mCreationOrderId;
      }
      
      public function GetTypeName ():String
      {
         return "Asset";
      }
      
      public function GetInfoText ():String
      {
         return     "x = " + ValueAdjuster.Number2Precision (mAssetManager.GetCoordinateSystem ().D2P_PositionX (mTransform.mOffsetX), 6) 
                + ", y = " + ValueAdjuster.Number2Precision (mAssetManager.GetCoordinateSystem ().D2P_PositionY (mTransform.mOffsetY), 6) ;
      }
      
//======================================================
// 
//======================================================
      
      public function SetAppearanceLayerId (index:int):void
      {
         mAppearanceLayerId = index;
      }
      
      public function GetAppearanceLayerId ():int
      {
         if (mAssetManager != null)
            mAssetManager.CorrectAssetAppearanceIds ();
         
         return mAppearanceLayerId;
      }
      
      public function SetCreationOrderId (index:int):void
      {
         mCreationOrderId = index;
      }
      
      public function GetCreationOrderId ():int
      {
         if (mAssetManager != null)
            mAssetManager.CorrectAssetCreationIds ();
         
         return mCreationOrderId;
      }
      
//======================================================
// 
//======================================================

      public function OnAddedToStage (event:Event):void
      {
         BuildContextMenu ();
      }
      
//======================================================
// 
//======================================================
      
      private var mIsDestroyed:Boolean = false;
      
      public function IsDestroyed ():Boolean
      {
         return mIsDestroyed;
      }
      
      public function Destroy ():void
      {
         mAppearanceLayerId = -1;
         mCreationOrderId = -1;
         mIsDestroyed = true;
         
         if (mSelectionProxy != null)
            mSelectionProxy.Destroy ();
         
         SetControlPointsVisible (false);
         
         mAssetManager.OnAssetDestroyed (this);
         
         UnreferAllReferings ();
         NotifyDestroyedForReferers ();
         if (Capabilities.isDebugger)
         {
            FinalAssertReferPairs ();
         }
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
      public function Update (escapedTime:Number):void
      {
      }
      
      public function UpdateAppearance ():void
      {
      }
      
      //public function SetSelectable (selectable:Boolean):void
      //{
      //   if (mSelectionProxy != null)
      //      mSelectionProxy.SetSelectable (selectable);
      //}
      
//====================================================================
//   main entity
//====================================================================
      
      // when clone and delete, we need the main entity.
      // after cloned, we need select new selectable sub entities
      
      // todo: the main asset should be learned from google bigtable entity group.
      // no SubEntity class is needed.
      
      public function GetMainAsset ():Asset
      {
         return this;
      }
      
      public function GetSubAssets ():Array
      {
         return [];
      }
      
      public function GetSubIndex ():int
      {
         return -1;
      }
      
      public function GetSelectableAssets ():Array
      {
         // currently, only joints have sub entities.
         
         // this is just an implementation satisfied current need.
         
         var selectableAssets:Array = GetSubAssets ();
         if (selectableAssets.length == 0)
         {
            selectableAssets.push (this);
         }
         
         return selectableAssets;
      }
      
//=================================================================================
//   asset space <-> manager space
//=================================================================================
      
      public function AssetToManager (pointOrVector:Point, isPoint:Boolean = true):Point
      {
         if (isPoint)
            return mTransform.TransformPointXY (pointOrVector.x, pointOrVector.y);
         else
            return mTransform.TransformVectorXY (pointOrVector.x, pointOrVector.y);
      }
      
      public function ManagerToAsset (pointOrVector:Point, isPoint:Boolean = true):Point
      {
         if (isPoint)
            return mTransform.InverseTransformPointXY (pointOrVector.x, pointOrVector.y);
         else
            return mTransform.InverseTransformVectorXY (pointOrVector.x, pointOrVector.y);
      }
      
//======================================================
// name, position
//======================================================
      
      public function SetName (name:String):void
      {
         //if (name == null)
         //   name = GetDefaultName ();
         
         mName = name;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetAlpha ():Number
      {
         return mAlpha;
      }
      
      public function SetAlpha (a:Number):void
      {
         if (a < 0.0)
            a = 0.0;
         
         if (a > 1.0)
            a = 1.0;
         
         mAlpha = a;
      }
      
      public function SetVisible (visible:Boolean):void
      {
         mIsVisible = visible;
      }
      
      public function IsVisible ():Boolean
      {
         return mIsVisible;
      }
      
      public function CloneTransform ():Transform2D
      {
         return mTransform.Clone ();
      }
      
      public function GetPositionX ():Number
      {
         return mTransform.mOffsetX;
      }
      
      public function GetPositionY ():Number
      {
         return mTransform.mOffsetY;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         mTransform.mOffsetX = posX;
         mTransform.mOffsetY = posY;
         
         x = posX;
         y = posY;
      }
      
      public function GetScale ():Number
      {
         return mTransform.mScale;
      }
      
      public function SetScale (s:Number):void
      {
         if (s < 0)
            s = - s;
         
         mTransform.mScale = s;
         
         UpdateDisplayObjectRotateScaleXY ();
      }
      
      public function GetRotation ():Number
      {
         return mTransform.mRotation;
      }
      
      public function IsFlipped ():Boolean
      {
         return mTransform.mFlipped;
      }
      
      public function SetFlipped (flipped:Boolean):void
      {
         mTransform.mFlipped = flipped;
         
         UpdateDisplayObjectRotateScaleXY ();
      }
      
      public function SetRotation (r:Number):void
      {
         mTransform.mRotation = r % Define.kPI_x_2;
         if (mTransform.mRotation < 0)
            mTransform.mRotation += Define.kPI_x_2;
         
         UpdateDisplayObjectRotateScaleXY ();
      }
      
      private function UpdateDisplayObjectRotateScaleXY ():void
      {
         if (mTransform.mFlipped)
         {
            scaleX = - mTransform.mScale;
            rotation = - mTransform.mRotation * 180.0 / Math.PI;
         }
         else
         {
            scaleX = mTransform.mScale;
            rotation = mTransform.mRotation * 180.0 / Math.PI;
         }
         
         scaleY = mTransform.mScale;
      }
      
//====================================================================
//   move / rotate / scale / flip
//====================================================================
      
      public function OnTransformIntentDone ():void
      {
         UpdateSelectionProxy ();
         UpdateControlPoints ();
      }
      
      final public function Move (offsetX:Number, offsetY:Number/*, intentionDone:Boolean = true*/):void
      {
         MoveTo (GetPositionX () + offsetX, GetPositionY () + offsetY/*, intentionDone*/);
      }
      
      public function MoveBodyTexture (offsetX:Number, offsetY:Number/*, intentionDone:Boolean = true*/):void
      {
         // to override
      }
      
      public function MoveTo (targetX:Number, targetY:Number/*, intentionDone:Boolean = true*/):void
      {
         SetPosition (targetX, targetY);
         
         /*
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
         */
      }
      
      final public function RotatePosition (centerX:Number, centerY:Number, deltaRotation:Number/*, intentionDone:Boolean = true*/):void
      {
         RotatePositionByCosSin (centerX, centerY, Math.cos (deltaRotation), Math.sin (deltaRotation)/*, intentionDone*/);
      }
      
      public function RotatePositionByCosSin (centerX:Number, centerY:Number, cos:Number, sin:Number/*, intentionDone:Boolean = true*/):void
      {
         var offsetX:Number = GetPositionX () - centerX;
         var offsetY:Number = GetPositionY () - centerY;
         var newOffsetX:Number = offsetX * cos - offsetY * sin;
         var newOffsetY:Number = offsetX * sin + offsetY * cos;
         SetPosition (centerX + newOffsetX, centerY + newOffsetY);
         
         /*
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
         */
      }
      
      public function RotateBodyTexturePositionByCosSin (centerX:Number, centerY:Number, cos:Number, sin:Number/*, intentionDone:Boolean = true*/):void
      {
         // to override
      }
      
      public function RotateSelf (deltaRotation:Number/*, intentionDone:Boolean = true*/):void
      {
         if (IsFlipped ())
            deltaRotation = - deltaRotation;
         
         SetRotation (GetRotation () + deltaRotation);
         
         /*
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
         */
      }
      
      //RotateSelfTo seems not essential
      
      public function RotateBodyTextureSelf (deltaRotation:Number/*, intentionDone:Boolean = true*/):void
      {
         // to override
      }
      
      public function ScalePosition (centerX:Number, centerY:Number, s:Number/*, intentionDone:Boolean = true*/):void
      {
         if (s < 0)
            s = -s;
         
         var offsetX:Number = GetPositionX () - centerX;
         var offsetY:Number = GetPositionY () - centerY;
         SetPosition (centerX + s * offsetX, centerY + s * offsetY);
         
         /*
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
         */
      }
      
      public function ScaleBodyTexturePosition (centerX:Number, centerY:Number, s:Number/*, intentionDone:Boolean = true*/):void
      {
         // to override
      }
      
      final public function ScaleSelf (s:Number/*, intentionDone:Boolean = true*/):void
      {  
         ScaleSelfTo (GetScale () * s/*, intentionDone*/);
      }
      
      public function ScaleBodyTextureSelf (s:Number/*, intentionDone:Boolean = true*/):void
      {
         // to override
      }
      
      public function ScaleSelfTo (targetScale:Number/*, intentionDone:Boolean = true*/):void
      {
         if (targetScale < 0)
            targetScale = - targetScale;
         
         SetScale (targetScale);
         
         /*
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
         */
      }
      
      public function FlipPosition (planeX:Number/*, intentionDone:Boolean = true*/):void
      {
         SetPosition (planeX + planeX - GetPositionX (), GetPositionY ());
         
         /*
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
         */
      }
      
      public function FlipBodyTexturePosition (planeX:Number/*, intentionDone:Boolean = true*/):void
      {
         // to override
      }
      
      public function FlipSelf (/*intentionDone:Boolean = true*/):void
      {
         SetFlipped (! IsFlipped ());
         
         /*
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
         */
      }
      
      public function FlipBodyTextureSelf (/*intentionDone:Boolean = true*/):void
      {
         // to override
      }
      
//====================================================================
//   Selection Proxy
//====================================================================
      
      public function UpdateSelectionProxy ():void
      {
      }
      
      public function ContainsPoint (pointX:Number, pointY:Number):Boolean
      {
         if (mSelectionProxy == null)
            return false;
         
         return mSelectionProxy.ContainsPoint (pointX, pointY);
      }
      
//======================================================
// 
//======================================================
      
      public function OnManagerScaleChanged ():void
      {
         UpdateControlPoints ();
      }
      
//======================================================
// 
//======================================================
      
      protected var mVisibleForEditing:Boolean = true;
      
      public function SetVisibleForEditing (visibleForEditing:Boolean):void
      {
         mVisibleForEditing = visibleForEditing;
         
         alpha = mVisibleForEditing ? GetVisibleAlphaForEditing () : GetInvisibleAlphaForEditing ();
      }
      
      public function IsVisibleForEditing ():Boolean
      {
         return mVisibleForEditing;
      }
      
      public function GetVisibleAlphaForEditing ():Number
      {
         return 1.0;
      }
      
      public function GetInvisibleAlphaForEditing ():Number
      {
         return 0.2;
      }
      
//====================================================================
//   brothers
//====================================================================
      
      private var mBrothers:Array = null;
      
      public function GetBrothers ():Array // used only by BorthersManager
      {
         return mBrothers;
      }
      
      internal function SetBrothers (brothers:Array):void // used only by BorthersManager
      {
         mBrothers = brothers;
      }
      
//====================================================================
//   selected
//====================================================================
      
      private var mSelected:Boolean = false;
      
      public function OnSelectedChanged (selected:Boolean):void
      {
         if (mSelected != selected)
         {
            mSelected = selected;
            
            UpdateAppearance ();
         }
      }
      
      public function IsSelected ():Boolean // used internally, for external, use world.IsAssetSelected instead
      {
         return mSelected;
      }
      
//====================================================================
//   control points
//====================================================================
      
      private var mControlPointsVisible:Boolean = false;
      
      public function AreControlPointsEnabled ():Boolean
      {
         return true;
      }
      
      final public function AreControlPointsVisible ():Boolean
      {
         return mControlPointsVisible;
      }
      
      public function SetControlPointsVisible (controlPointsVisible:Boolean):void
      {
         if (mControlPointsVisible != controlPointsVisible)
         {
            mControlPointsVisible = controlPointsVisible;
            
            if (mAssetManager != null)
               mAssetManager.UnregisterShownControlPointsOfAsset (this);
               
            if (mControlPointsVisible && AreControlPointsEnabled ())
            {
               RebuildControlPoints ();
            }
            else
            {
               DestroyControlPoints ();
            }
         }
      }
      
      public function GetControlPointContainer ():Sprite
      {
         return this; // to override
      }
      
      final public function UpdateControlPoints (forceRebuild:Boolean = false):void
      {
         if (AreControlPointsVisible ())
         {
            if (AreControlPointsEnabled ())
            {
               if (forceRebuild)
                  RebuildControlPoints ();
               else
                  UpdateControlPoints_Internal ();
            }
            else
            {
               DestroyControlPoints ();
            }
         }
      }
      
      protected function UpdateControlPoints_Internal ():void
      {
         // to override. This one should not call DestroyControlPoints.
      }
      
      protected function RebuildControlPoints ():void
      {
         // to override. This one will call DestroyControlPoints firstly.
      }
      
      protected function DestroyControlPoints ():void
      {
         // to override
      }
      
      public function OnSoloControlPointSelected (controlPoint:ControlPoint):void
      {
         controlPoint.SetSelectedLevel (ControlPoint.SelectedLevel_Primary);
      }

      public function MoveControlPoint (controlPoint:ControlPoint, dx:Number, dy:Number, done:Boolean):void
      {
      }

      public function DeleteControlPoint (controlPoint:ControlPoint):Boolean
      {
         return false;
      }

      public function InsertControlPointBefore (controlPoint:ControlPoint):Boolean
      {
         return false;
      }

//====================================================================
//   internal linkables
//====================================================================
      
      private var mInternalLinkablesVisible:Boolean = false;
      
      final public function AreInternalLinkablesVisible ():Boolean
      {
         return mInternalLinkablesVisible;
      }
      
      public function SetInternalLinkablesVisible (internalLinkablesVisible:Boolean):void
      {
         if (mInternalLinkablesVisible != internalLinkablesVisible)
         {
            mInternalLinkablesVisible = internalLinkablesVisible;
            
            if (mInternalLinkablesVisible)
            {
               RebuildInternalLinkables ();
            }
            else
            {
               DestroyInternalLinkables ();
            }
         }
      }
      
      protected function RebuildInternalLinkables ():void
      {
         // to override. This one will call DestroyInternalLinkables firstly.
      }
      
      protected function DestroyInternalLinkables ():void
      {
         // to override
      }
      
//====================================================================
//   draw entity links
//====================================================================
      
      public function GetLinkPointX ():Number
      {
         return mTransform.mOffsetX;
      }
      
      public function GetLinkPointY ():Number
      {
         return mTransform.mOffsetY;
      }
      
      public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         // to override
      }
      
//====================================================================
//   draw entity id
//====================================================================
      
      public function DrawAssetId (canvasSprite:Sprite):void
      {
         if (canvasSprite == null)
            return;
         
         var creationOrderId:int = GetCreationOrderId ();
         var idText:TextFieldEx = TextFieldEx.CreateTextField (creationOrderId.toString (), true, 0xFFFFFF, 0x0, false, 0, false, true, 0x0);
         
         canvasSprite.addChild (idText);
         
         idText.scaleX = 1.0 / mAssetManager.scaleX;
         idText.scaleY = 1.0 / mAssetManager.scaleY;
         idText.x = GetLinkPointX () - 0.5 * idText.width;
         idText.y = GetLinkPointY () - 0.5 * idText.height;
      }
      
//====================================================================
//   properties
//====================================================================
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
      
//=============================================================
//   context menu
//=============================================================
      
      final private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
         
         BuildContextMenuInternal (theContextMenu.customItems);
         
         theContextMenu.customItems.push (EditorContext.GetAboutContextMenuItem ());
      }
      
      protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
      }
      
//====================================================================
//   do convenience for some actions 
//====================================================================
      
      private var mActionId:int = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
      public function SetCurrentActionId (actionId:int):void
      {
         mActionId = actionId;
      }
      
      public function GetCurrentActionId ():int
      {
         return mActionId;
      }
   }
}