
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
   import flash.utils.ByteArray;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.LocalImageLoader;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   
   import editor.image.vector.VectorShapeForEditing;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import common.Transform2D;
   
   import common.Define;
   
   public class AssetImageModuleInstance extends Asset
   {  
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      protected var mAssetImageModule:AssetImageModule = null; // must be null
      
      protected var mAssetImageModuleInstanceForListingPeer:AssetImageModuleInstanceForListing;
      
      public function AssetImageModuleInstance (assetImageModuleInstanceManager:AssetImageModuleInstanceManager, assetImageModule:AssetImageModule)
      {
         super (assetImageModuleInstanceManager);
         
         mAssetImageModuleInstanceManager = assetImageModuleInstanceManager;
         
         SetAssetImageModule (assetImageModule);
      }
      
      public function GetAssetImageModuleInstanceManager ():AssetImageModuleInstanceManager
      {
         return mAssetImageModuleInstanceManager;
      }
      
      public function GetAssetImageModule ():AssetImageModule
      {
         return mAssetImageModule;
      }
      
      public function GetModuleInstaneForListingPeer ():AssetImageModuleInstanceForListing
      {
         return mAssetImageModuleInstanceForListingPeer;
      }
      
      public function SetModuleInstaneForListingPeer (moduleInstacneForListing:AssetImageModuleInstanceForListing):void
      {
         mAssetImageModuleInstanceForListingPeer = moduleInstacneForListing;
      }
      
      public function SetAssetImageModule (assetImageModule:AssetImageModule):void
      {
         if (mReferPair != null)
         {
            mReferPair.Break ();
            mAssetImageModule = null;
         }
         
         if (assetImageModule != null)
         {
            mAssetImageModule = assetImageModule;
            mReferPair = ReferObject (mAssetImageModule);
         }
      } 
      
      override public function ToCodeString ():String
      {
         return mAssetImageModule == null ? "" : mAssetImageModule.ToCodeString ();
      }
      
      override public function GetTypeName ():String
      {
         return mAssetImageModule == null ? "" : mAssetImageModule.GetTypeName ();
      }
      
//=============================================================
//   
//=============================================================
      
      private var mReferPair:ReferPair;
      
      override public function OnReferingModified (referPair:ReferPair, info:Object = null):void
      {
         if (referPair == mReferPair)
         {
            UpdateAppearance ();
         }
      }

      override public function OnReferingDestroyed (referPair:ReferPair):void
      {
         if (referPair == mReferPair)
         {
            mAssetImageModuleInstanceManager.DestroyAsset (this);
            mReferPair = null;
            mAssetImageModule = null;
         }
      }
      
//=============================================================
//   
//=============================================================

      protected var mDuration:int = 6;
      
      public function GetDuration ():int
      {
         return mDuration;
      }
      
      public function SetDuration (duration:int):void
      {
         if (duration < 0)
            duration = 0;
         
         mDuration = duration;
      }

      public function SetTransformParameters (offsetX:Number, offsetY:Number, scale:Number, flipped:Boolean, angleDegrees:Number):void
      {
         SetPosition (offsetX, offsetY);
         SetScale (scale);
         SetFlipped (flipped);
         SetRotation (angleDegrees * Math.PI / 180.0);
      }
      
//=============================================================
//   
//=============================================================

      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         GraphicsUtil.Clear (this);
         
         mAssetImageModule.BuildImageModuleAppearance (this);
         alpha = 0.70;
         
         if (IsSelected ())
         {
            var shape:Shape = new Shape ();

            var rectangle:Rectangle = this.getBounds (this);
            GraphicsUtil.DrawRect (shape, rectangle.left, rectangle.top, rectangle.width, rectangle.height,
                                       0x0000FF, -1, true, 0xC0C0FF, false);
            
            addChild (shape);
         }
            
         if (AreControlPointsVisible ())
         {
            addChild (mControlPointsContainer);
         }
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyGeneral ();
            mSelectionProxy.SetUserData (this);
         }
         
         mSelectionProxy.Rebuild (GetPositionX (), GetPositionY (), 0.0);
         mAssetImageModule.BuildImageModuleSelectionProxy (mSelectionProxy, new Transform2D (0.0, 0.0, GetScale (), IsFlipped (), GetRotation ()));
         
         if (Compile::Is_Debugging)// && false)
         {
            if (mPhysicsShapesLayer == null)
            {
               mPhysicsShapesLayer = new Sprite ();
               addChild (mPhysicsShapesLayer);
            }
            while (mPhysicsShapesLayer.numChildren > 0)
               mPhysicsShapesLayer.removeChildAt (0);
            
            mSelectionProxy.AddPhysicsShapes (mPhysicsShapesLayer);
         }         
      }
      
      // for debug
      private var mPhysicsShapesLayer:Sprite = null;
      
//=============================================================
//   control points
//=============================================================
      
      protected var mControlPointsContainer:Sprite = new Sprite ();
      protected var mControlPoints:Array = null;
      
      override public function GetControlPointContainer ():Sprite
      {
         return mControlPointsContainer; // to override
      }
      
      override protected function RebuildControlPoints ():void
      {
         if (mControlPoints != null)
            DestroyControlPoints ();
         
         if (mAssetImageModule is AssetImageShapeModule)
         {
            addChild (mControlPointsContainer);
            mControlPoints = (mAssetImageModule as AssetImageShapeModule).GetVectorShape ().CreateControlPointsForAsset (this);
            
            mAssetManager.RegisterShownControlPoints (mControlPoints);
         }
      }
      
      override protected function DestroyControlPoints ():void
      {
         for (var i:int = mControlPoints.length - 1; i >= 0; -- i)
         {
            (mControlPoints [i] as ControlPoint).Destroy ();
         }
         
         mControlPoints = null;
         if (mControlPointsContainer.parent != null) // should be this
            mControlPointsContainer.parent.removeChild (mControlPointsContainer);
            
         mAssetManager.UnregisterShownControlPointsOfAsset (this);
      }
      
      override public function OnSoloControlPointSelected (controlPoint:ControlPoint):void
      {
         super.OnSoloControlPointSelected (controlPoint);
         
         if (mAssetImageModule is AssetImageShapeModule)
         {
            var secondarySelectedControlPointIndex:int = (mAssetImageModule as AssetImageShapeModule).GetVectorShape ().GetSecondarySelectedControlPointId (controlPoint);
            if (secondarySelectedControlPointIndex >= 0 && mControlPoints != null && secondarySelectedControlPointIndex < mControlPoints.length)
            {
               (mControlPoints [secondarySelectedControlPointIndex] as ControlPoint).SetSelectedLevel (ControlPoint.SelectedLevel_Secondary);
            }
         }
      }
      
      protected function OnControlPointsModified (infos:Array, actionDone:Boolean):void
      {
         if (infos != null)
         {
            var localAssetDisplayment:Point = new Point (infos [0], infos[1]);
            var globalAssetDisplayment:Point = AssetToManager (localAssetDisplayment, false);
            SetPosition (GetPositionX () + globalAssetDisplayment.x, GetPositionY () + globalAssetDisplayment.y);
            
            UpdateAppearance ();

            if (actionDone)
            {
               UpdateSelectionProxy ();
               RebuildControlPoints ();
               var selectedControlPointIndex:int = infos[2];
               if (selectedControlPointIndex >= 0 && selectedControlPointIndex < mControlPoints.length)
               {
                  OnSoloControlPointSelected (mControlPoints [selectedControlPointIndex] as ControlPoint);
               }
            }
         }
      }

      override public function MoveControlPoint (controlPoint:ControlPoint, dx:Number, dy:Number, done:Boolean):void
      {
         if (mAssetImageModule is AssetImageShapeModule)
         {
            var localDisplayment:Point = ManagerToAsset (new Point (dx, dy), false); 
            
            var returnInfos:Array = (mAssetImageModule as AssetImageShapeModule).GetVectorShape ().OnMoveControlPoint (mControlPoints, controlPoint.GetIndex (), localDisplayment.x, localDisplayment.y);
            OnControlPointsModified (returnInfos, done);
         }
      }

      override public function DeleteControlPoint (controlPoint:ControlPoint):void
      {
         if (mAssetImageModule is AssetImageShapeModule)
         {
            var returnIndex:int = (mAssetImageModule as AssetImageShapeModule).GetVectorShape ().DeleteControlPoint (controlPoint);
            if (returnIndex >= 0)
            {
               UpdateAppearance ();
               UpdateSelectionProxy ();
               
               RebuildControlPoints ();
            }
         }
      }

      override public function InsertControlPointBefore (controlPoint:ControlPoint):void
      {
         if (mAssetImageModule is AssetImageShapeModule)
         {
            var returnIndex:int = (mAssetImageModule as AssetImageShapeModule).GetVectorShape ().InsertControlPointBefore (controlPoint);
            if (returnIndex >= 0)
            {
               UpdateAppearance ();
               UpdateSelectionProxy ();
               
               RebuildControlPoints ();
               controlPoint = mControlPoints [returnIndex] as ControlPoint;
               controlPoint.SetSelectedLevel (ControlPoint.SelectedLevel_Primary);
               OnSoloControlPointSelected (controlPoint);
            }
         }
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemRebuildFromCurrentModule:ContextMenuItem = new ContextMenuItem("Rebuild From Current Module");
         var menuItemInsertBeforeFromCurrentModule:ContextMenuItem = new ContextMenuItem("Insert New Module Instance From Current Module Before This One", true);
         var menuItemInsertAfterFromCurrentModule:ContextMenuItem = new ContextMenuItem("Insert New Module Instance From Current Module After This One");
         
         menuItemRebuildFromCurrentModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_RebuildFromCurrentModule);
         menuItemInsertBeforeFromCurrentModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_InsertBeforeFromCurrentModule);
         menuItemInsertAfterFromCurrentModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_InsertAfterFromCurrentModule);
         
         customMenuItemsStack.push (menuItemRebuildFromCurrentModule);
         customMenuItemsStack.push (menuItemInsertBeforeFromCurrentModule);
         customMenuItemsStack.push (menuItemInsertAfterFromCurrentModule);
         
         mAssetImageModuleInstanceManager.BuildContextMenuInternal (customMenuItemsStack);
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_RebuildFromCurrentModule (event:ContextMenuEvent):void
      {
         SetAssetImageModule (AssetImageModule.mCurrentAssetImageModule);
         
         UpdateAppearance ();
         UpdateSelectionProxy ();
         
         // update icon in list
         
         //if (mAssetImageModuleInstanceForListingPeer != null)
         //{
            mAssetImageModuleInstanceForListingPeer.SetAssetImageModule (AssetImageModule.mCurrentAssetImageModule);
            
            mAssetImageModuleInstanceForListingPeer.UpdateAppearance ();
         //}
      }
      
      private function OnContextMenuEvent_InsertBeforeFromCurrentModule (event:ContextMenuEvent):void
      {
         mAssetImageModuleInstanceManager.OnContextMenuEvent_CreateImageModuleInstanceAtIndex (GetAppearanceLayerId ());
      }
      
      private function OnContextMenuEvent_InsertAfterFromCurrentModule (event:ContextMenuEvent):void
      {
         mAssetImageModuleInstanceManager.OnContextMenuEvent_CreateImageModuleInstanceAtIndex (GetAppearanceLayerId () + 1);
      }
  }
}