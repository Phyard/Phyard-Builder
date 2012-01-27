
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
   
   import editor.core.EditorObject;
   
   import editor.selection.SelectionProxy;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Transform2D;
   
   public class Asset extends EditorObject
   {
      protected var mAssetManager:AssetManager;
      protected var mAppearanceLayerId:int = -1;
      protected var mCreationOrderId:int = -1; // to reduce random factors
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      protected var mName:String = "";
      
      private var mTransform:Transform2D = new Transform2D ();
      
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
      
      public function SetSelectable (selectable:Boolean):void
      {
         if (mSelectionProxy != null)
            mSelectionProxy.SetSelectable (selectable);
      }
      
//====================================================================
//   main entity
//====================================================================
      
      // todo: the main asset should be learned from google bigtable entity group.
      // no SubEntity class is needed.
      
      public function GetMainAsset ():Asset
      {
         return this;
      }
      
      public function GetSelectableAssets ():Array
      {
         return [this];
      }
      
      public function GetSubAssets ():Array
      {
         return [];
      }
      
      public function GetSubIndex ():int
      {
         return -1;
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
      
      public function Move (offsetX:Number, offsetY:Number, intentionDone:Boolean = true):void
      {
         SetPosition (GetPositionX () + offsetX, GetPositionY () + offsetY);
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      public function MoveTo (targetX:Number, targetY:Number, intentionDone:Boolean = true):void
      {
         SetPosition (targetX, targetY);
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      public function RotatePosition (centerX:Number, centerY:Number, deltaRotation:Number, intentionDone:Boolean = true):void
      {
         RotatePositionByCosSin (centerX, centerY, Math.cos (deltaRotation), Math.sin (deltaRotation), intentionDone);
      }
      
      public function RotatePositionByCosSin (centerX:Number, centerY:Number, cos:Number, sin:Number, intentionDone:Boolean = true):void
      {
         var offsetX:Number = GetPositionX () - centerX;
         var offsetY:Number = GetPositionY () - centerY;
         var newOffsetX:Number = offsetX * cos - offsetY * sin;
         var newOffsetY:Number = offsetX * sin + offsetY * cos;
         SetPosition (centerX + newOffsetX, centerY + newOffsetY);
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      public function RotateSelf (deltaRotation:Number, intentionDone:Boolean = true):void
      {
         if (IsFlipped ())
            deltaRotation = - deltaRotation;
         
         SetRotation (GetRotation () + deltaRotation);
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      // generally, don't use this function
      //public function RotateSelfTo (targetRotation:Number, intentionDone:Boolean = true):void
      //{
      //   SetRotation (targetRotation);
      //   
      //   if (intentionDone)
      //   {
      //      UpdateSelectionProxy ();
      //      UpdateControlPoints ();
      //   }
      //}
      
      public function ScalePosition (centerX:Number, centerY:Number, s:Number, intentionDone:Boolean = true):void
      {
         if (s < 0)
            s = -s;
         
         var offsetX:Number = GetPositionX () - centerX;
         var offsetY:Number = GetPositionY () - centerY;
         SetPosition (centerX + s * offsetX, centerY + s * offsetY);
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      public function ScaleSelf (s:Number, intentionDone:Boolean = true):void
      {
         if (s < 0)
            s = -s;
         
         SetScale (GetScale () * s);
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      public function ScaleSelfTo (targetScale:Number, intentionDone:Boolean = true):void
      {
         SetScale (targetScale);
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      public function FlipPosition (planeX:Number, intentionDone:Boolean = true):void
      {
         SetPosition (planeX + planeX - GetPositionX (), GetPositionY ());
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
      }
      
      public function FlipSelf (intentionDone:Boolean = true):void
      {
         SetFlipped (! IsFlipped ());
         
         if (intentionDone)
         {
            UpdateSelectionProxy ();
            UpdateControlPoints ();
         }
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
         
         alpha = mVisibleForEditing ? 1.0 : 0.33;
      }
      
      public function IsVisibleForEditing ():Boolean
      {
         return mVisibleForEditing;
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
      
      final public function AreControlPointsVisible ():Boolean
      {
         return mControlPointsVisible;
      }
      
      final public function SetControlPointsVisible (controlPointsVisible:Boolean):void
      {
         if (mControlPointsVisible != controlPointsVisible)
         {
            mControlPointsVisible = controlPointsVisible;
            
            if (mControlPointsVisible)
            {
               RebuildControlPoints ();
            }
            else
            {
               if (mAssetManager != null)
                  mAssetManager.UnregisterShownControlPointsOfAsset (this);
               
               DestroyControlPoints ();
            }
         }
      }
      
      public function GetControlPointContainer ():Sprite
      {
         return this; // to override
      }
      
      final public function UpdateControlPoints ():void
      {
         if (AreControlPointsVisible ())
         {
            UpdateControlPoints_Internal ();
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

      public function DeleteControlPoint (controlPoint:ControlPoint):void
      {
      }

      public function InsertControlPointBefore (controlPoint:ControlPoint):void
      {
      }

//====================================================================
//   draw entity links
//====================================================================
      
      public static const DrawLinksOrder_Normal:int = 10;
      public static const DrawLinksOrder_Logic:int = 20;
      public static const DrawLinksOrder_Task:int = 30;
      public static const DrawLinksOrder_EventHandler:int = 50;
      
      public function GetDrawLinksOrder ():int
      {
         return DrawLinksOrder_Normal;
      }
      
      public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         // to override
      }
      
      public function GetLinkPointX ():Number
      {
         return mTransform.mOffsetX;
      }
      
      public function GetLinkPointY ():Number
      {
         return mTransform.mOffsetY;
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
         
         theContextMenu.customItems.push (Runtime.GetAboutContextMenuItem ());
      }
      
      protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
      }
      
//====================================================================
//   do convenience for some actions 
//====================================================================
      
      // another possible good mehtod: use bit masks to ...
      
      public static var mNextActionId:int = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
      
      public static function GetNextActionId ():int
      {
         return ++ mNextActionId;
      }
      
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