
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
   
   public class AssetImageCompositeModuleManager extends AssetImageModuleManager
   {
//==========================================================      
// 
//==========================================================      
      
      override public function GetAssetSpriteSize ():Number
      {
         return 76;
      }

      override public function GetAssetSpriteGap ():Number
      {
         return 10;
      }
      
//==========================================================      
// 
//==========================================================      
      
      override public function GetModuleIconSize ():Number
      {
         return 66;
      }
      
//==========================================================      
// 
//========================================================== 

      public function CreateImageCompositeModule (insertBeforeSelectedThenSelectNew:Boolean):AssetImageCompositeModule
      {
         var module:AssetImageCompositeModule = new AssetImageCompositeModule (this);
         module.UpdateAppearance ();
         module.UpdateSelectionProxy ();
         addChild (module);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (module);
         
         RearrangeAssetPositions (true);
         
         return module;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemCreateTimeCompositeModule:ContextMenuItem = new ContextMenuItem  ("Create New Time Composite Module", true);
         var menuItemCreateSpaceCompositeModule:ContextMenuItem = new ContextMenuItem ("Create New Space Composite Module");
         
         menuItemCreateTimeCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateTimeCompositeModule);
         menuItemCreateSpaceCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateSpaceCompositeModule);

         customMenuItemsStack.push (menuItemCreateTimeCompositeModule);
         customMenuItemsStack.push (menuItemCreateSpaceCompositeModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_CreateTimeCompositeModule (event:ContextMenuEvent):void
      {
         var module:AssetImageCompositeModule = CreateImageCompositeModule (true);
         if (module != null)
         {
            module.SetAnimated (true);
         }
      }
      
      private function OnContextMenuEvent_CreateSpaceCompositeModule(event:ContextMenuEvent):void
      {
         var module:AssetImageCompositeModule = CreateImageCompositeModule (true);
         if (module != null)
         {
            module.SetAnimated (false);
         }
      }
   }
}

