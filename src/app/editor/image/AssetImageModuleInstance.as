
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.geom.Rectangle;
   
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
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import common.Define;
   
   public class AssetImageModuleInstance extends Asset
   {  
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      protected var mAssetImageModule:AssetImageModule = null;
      
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

      private function GetPhysicsBoundingRectangle ():Rectangle
      {
         var rectangle:Rectangle = null;
         if (mAssetImageModule != null)
         {
            rectangle = mAssetImageModule.GetImageModuleBoundingRectangle ();
         }
         
         if (rectangle == null)
         {
            if (mModuleSpriteForEditing != null)
            {
               rectangle = mModuleSpriteForEditing.getBounds (mModuleSpriteForEditing);
            }
            
            if (rectangle == null || rectangle.width <= 2 || rectangle.height <= 2)
            { 
               var moduleSize:Number = 50;
               var halfModuleSize:Number = 0.5 * moduleSize;
               rectangle = new Rectangle (-halfModuleSize, -halfModuleSize, moduleSize, moduleSize);
            }
         }
         
         return rectangle;
      }

      private var mModuleSpriteForEditing:DisplayObject = null;
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         GraphicsUtil.Clear (this);
         
         var moduleSize:Number = 50;
         var halfModuleSize:Number = 0.5 * moduleSize;
         
         var moduleSprite:DisplayObject = null;
         if (mAssetImageModule != null)
         {
            moduleSprite = mAssetImageModule.BuildImageModuleSprite ();
         }
         
         mModuleSpriteForEditing = null;

         var rectangle:Rectangle;
         if (moduleSprite == null)
         {
            rectangle = GetPhysicsBoundingRectangle ();
            
            var rectShape:Shape = new Shape ();
            addChild (rectShape);
            GraphicsUtil.DrawRect (rectShape, rectangle.left, rectangle.top, rectangle.width, rectangle.height,
                                          0x0000FF, -1, true, IsSelected () ? 0xC0C0FF : 0xD0FFD0, false);
            
            mModuleSpriteForEditing = rectShape;
         }
         else
         {
            mModuleSpriteForEditing = moduleSprite;
            
            addChild (moduleSprite);
            
            if (IsSelected ())// && (! mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ().IsSequenced ()))
            {
               var shape:Shape = new Shape ();
               shape.alpha = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ().IsSequenced () ? 0.50 : 0.67;

               rectangle = GetPhysicsBoundingRectangle ();
               GraphicsUtil.DrawRect (shape, rectangle.left, rectangle.top, rectangle.width, rectangle.height,
                                          0x0000FF, -1, true, 0xC0C0FF, false);
               
               addChild (shape);
            }
         } 
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         var rectangle:Rectangle = GetPhysicsBoundingRectangle ();

         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle2 (GetPositionX (), GetPositionY (), rectangle.left, rectangle.top, rectangle.width, rectangle.height, GetRotation (), IsFlipped (), GetScale ());
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