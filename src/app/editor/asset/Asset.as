
package editor.asset {
   
   import flash.display.Sprite;
   
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
   
   public class Asset extends EditorObject
   {
      protected var mAssetManager:AssetManager;
      protected var mAppearanceLayerId:int = -1;
      protected var mCreationOrderId:int = -1; // to reduce random factors
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      protected var mName:String = "";
      
      private var mPosX:Number = 0;
      private var mPosY:Number = 0;
      
      private var mScale:Number = 1.0;
      private var mRotation:Number = 0;
      private var mFlipped:Boolean = false;
      
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
         return     "x = " + ValueAdjuster.Number2Precision (mAssetManager.GetCoordinateSystem ().D2P_PositionX (mPosX), 6) 
                + ", y = " + ValueAdjuster.Number2Precision (mAssetManager.GetCoordinateSystem ().D2P_PositionY (mPosY), 6) ;
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
         mAssetManager.CorrectAssetAppearanceIds ();
         
         return mAppearanceLayerId;
      }
      
      public function SetCreationOrderId (index:int):void
      {
         mCreationOrderId = index;
      }
      
      public function GetCreationOrderId ():int
      {
         mAssetManager.CorrectAssetCreationIds ();
         
         return mCreationOrderId;
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
         if (Compile::Is_Debugging)
         {
            FinalAssertReferPairs ();
         }
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
      
      public function GetPositionX ():Number
      {
         return mPosX;
      }
      
      public function GetPositionY ():Number
      {
         return mPosY;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         mPosX = posX;
         mPosY = posY;
         
         x = mPosX;
         y = mPosY;
      }
      
      public function GetScale ():Number
      {
         return mScale;
      }
      
      public function SetScale (s:Number):void
      {
         if (s < 0)
            s = - s;
         
         mScale = s;
         
         UpdateDisplayObjectRotateScaleXY ();
      }
      
      public function GetRotation ():Number
      {
         return mRotation;
      }
      
      public function SetRotation (r:Number):void
      {
         mRotation = r % Define.kPI_x_2;
         
         UpdateDisplayObjectRotateScaleXY ();
      }
      
      public function IsFlipped ():Boolean
      {
         return mFlipped;
      }
      
      public function SetFlipped (flipped:Boolean):void
      {
         mFlipped = flipped;
         
         UpdateDisplayObjectRotateScaleXY ();
      }
      
      private function UpdateDisplayObjectRotateScaleXY ():void
      {
         if (mFlipped)
         {
            scaleX = - mScale;
            rotation = - mRotation * 180.0 / Math.PI;
         }
         else
         {
            scaleX = mScale;
            rotation = mRotation * 180.0 / Math.PI;;
         }
         
         scaleY = mScale;
      }
      
//====================================================================
//   move / rotate / scale / flip
//====================================================================
      
      public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         SetPosition (GetPositionX () + offsetX, GetPositionY () + offsetY);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function MoveTo (targetX:Number, targetY:Number, updateSelectionProxy:Boolean = true):void
      {
         SetPosition (targetX, targetY);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function RotatePosition (centerX:Number, centerY:Number, deltaRotation:Number, updateSelectionProxy:Boolean = true):void
      {
         RotatePositionByCosSin (centerX, centerY, Math.cos (deltaRotation), Math.sin (deltaRotation), updateSelectionProxy);
      }
      
      public function RotatePositionByCosSin (centerX:Number, centerY:Number, cos:Number, sin:Number, updateSelectionProxy:Boolean = true):void
      {
         var offsetX:Number = GetPositionX () - centerX;
         var offsetY:Number = GetPositionY () - centerY;
         var newOffsetX:Number = offsetX * cos - offsetY * sin;
         var newOffsetY:Number = offsetX * sin + offsetY * cos;
         SetPosition (centerX + newOffsetX, centerY + newOffsetY);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function RotateSelf (deltaRotation:Number, updateSelectionProxy:Boolean = true):void
      {
         if (IsFlipped ())
            deltaRotation = - deltaRotation;
         
         SetRotation (GetRotation () + deltaRotation);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      // generally, don't use this function
      //public function RotateSelfTo (targetRotation:Number, updateSelectionProxy:Boolean = true):void
      //{
      //   SetRotation (targetRotation);
      //   
      //   if (updateSelectionProxy)
      //   {
      //      UpdateSelectionProxy ();
      //   }
      //}
      
      public function ScalePosition (centerX:Number, centerY:Number, s:Number, updateSelectionProxy:Boolean = true):void
      {
         if (s < 0)
            s = -s;
         
         var offsetX:Number = GetPositionX () - centerX;
         var offsetY:Number = GetPositionY () - centerY;
         SetPosition (centerX + s * offsetX, centerY + s * offsetY);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function ScaleSelf (s:Number, updateSelectionProxy:Boolean = true):void
      {
         SetScale (GetScale () * s);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function ScaleSelfTo (targetScale:Number, updateSelectionProxy:Boolean = true):void
      {
         SetScale (targetScale);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function FlipPosition (planeX:Number, updateSelectionProxy:Boolean = true):void
      {
         SetPosition (planeX + planeX - GetPositionX (), GetPositionY ());
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function FlipSelf (updateSelectionProxy:Boolean = true):void
      {
         SetFlipped (! IsFlipped ());
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
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
      
      public function NotifySelectedChanged (selected:Boolean):void
      {
         var changed:Boolean =  mSelected != selected;
         
         mSelected = selected;
         
         if (changed)
         {
            UpdateAppearance ();
         }
      }
      
      public function IsSelected ():Boolean // used internally, for external, use world.IsAssetSelected instead
      {
         return mSelected;
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
         return mPosX;
      }
      
      public function GetLinkPointY ():Number
      {
         return mPosY;
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
      
      private function OnAddedToStage (event:Event):void 
      {
         BuildContextMenu ();
      }
      
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
   }
}