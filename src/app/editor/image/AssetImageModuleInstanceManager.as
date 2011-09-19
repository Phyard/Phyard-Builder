
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModuleInstanceManager extends AssetManager
   {
      protected var mAssetImageCompositeModule:AssetImageCompositeModule;
      
      public function AssetImageModuleInstanceManager (assetImageCompositeModule:AssetImageCompositeModule):void
      {
         mAssetImageCompositeModule = assetImageCompositeModule;
      }
      
      public function GetAssetImageCompositeModule ():AssetImageCompositeModule
      {
         return mAssetImageCompositeModule;
      }
      
      public function CreateImageModuleInstance (module:AssetImageModule, selectIt:Boolean = false):AssetImageModuleInstance
      {
         var moduleInstane:AssetImageModuleInstance = new AssetImageModuleInstance (this, module);
         
         if (selectIt) // in editing, not loading
         {
            moduleInstane.SetPosition (mouseX, mouseY);
            SetSelectedAsset (moduleInstane);
         }
         
         moduleInstane.UpdateAppearance ();
         moduleInstane.UpdateSelectionProxy ();
         addChild (moduleInstane);
         
         // create icon in list
         
         //if (mAssetImageModuleInstanceManagerForListing != null)
         //{
            var moduleInstaneForListing:AssetImageModuleInstanceForListing = mAssetImageCompositeModule.GetModuleInstanceManagerForListing ().CreateImageModuleInstanceForListing (module, selectIt);
            moduleInstaneForListing.SetModuleInstaneForEditingPeer (moduleInstane);
            moduleInstane.SetModuleInstaneForListingPeer (moduleInstaneForListing);
         //}

         return moduleInstane;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      public var mCallback_OnChangedForPanel:Function = null;
      
      protected function NotifyChangedForPanel ():void
      {
         if (mCallback_OnChangedForPanel != null)
         {
            mCallback_OnChangedForPanel ();
         }
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemChangeIntoTimeCompositeModule:ContextMenuItem = new ContextMenuItem("Change Into Time Composite Module", true);
         var menuItemChangeIntoSpaceCompositeModule:ContextMenuItem = new ContextMenuItem("Change Into Space Composite Module");
         var menuItemCreateModuleInstance:ContextMenuItem = new ContextMenuItem("Create Model Instance From Current Module", true);
         
         menuItemChangeIntoTimeCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeIntoTimeCompositeModule);
         menuItemChangeIntoSpaceCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeIntoSpaceCompositeModule);
         menuItemCreateModuleInstance.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateImageModuleInstance);

         customMenuItemsStack.push (menuItemChangeIntoTimeCompositeModule);
         customMenuItemsStack.push (menuItemChangeIntoSpaceCompositeModule);
         customMenuItemsStack.push (menuItemCreateModuleInstance);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_ChangeIntoTimeCompositeModule (event:ContextMenuEvent):void
      {
         mAssetImageCompositeModule.SetAnimated (true);
         NotifyChangedForPanel ();
      }
      
      private function OnContextMenuEvent_ChangeIntoSpaceCompositeModule (event:ContextMenuEvent):void
      {
         mAssetImageCompositeModule.SetAnimated (false);
         NotifyChangedForPanel ();
      }
      
      private function OnContextMenuEvent_CreateImageModuleInstance (event:ContextMenuEvent):void
      {
         CreateImageModuleInstance (AssetImageModule.mCurrentAssetImageModule, true);
         NotifyChangedForPanel ();
      }
   }
}
