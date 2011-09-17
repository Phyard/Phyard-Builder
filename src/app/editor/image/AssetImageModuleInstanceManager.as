
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
      
      protected var mAssetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing;
      
      public function SetAssetImageModuleInstanceManagerForListing (assetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing):void
      {
         mAssetImageModuleInstanceManagerForListing = assetImageModuleInstanceManagerForListing;
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
         
         if (mAssetImageModuleInstanceManagerForListing != null)
         {
            mAssetImageModuleInstanceManagerForListing.CreateImageModuleInstanceForListing (module, selectIt);
         }

         return moduleInstane;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemCreateModuleInstance:ContextMenuItem = new ContextMenuItem("Create Model Instance From Current Module", true);
         
         menuItemCreateModuleInstance.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateImageModuleInstance);

         customMenuItemsStack.push (menuItemCreateModuleInstance);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_CreateImageModuleInstance (event:ContextMenuEvent):void
      {
         CreateImageModuleInstance (AssetImageModule.mCurrentAssetImageModule, true);
      }
   }
}
