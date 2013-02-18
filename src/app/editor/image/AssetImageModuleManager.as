
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
   
   public class AssetImageModuleManager extends AssetManager
   {
      public function GetModuleIconSize ():Number
      {
         return 86;
         
         mMenuItemDeleteSelecteds.enabled = false;
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      override public function OnAssetSelectionsChanged ():void
      {
         mMenuItemDeleteSelecteds.enabled = GetNumSelectedAssets () != 0;
      }
      
      private var mMenuItemDeleteSelecteds:ContextMenuItem = new ContextMenuItem("Delete Selected(s) ...", true);
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         mMenuItemDeleteSelecteds.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_DeleteSelectedAssets);

         customMenuItemsStack.push (mMenuItemDeleteSelecteds);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_DeleteSelectedAssets (event:ContextMenuEvent):void
      {
         DeleteSelectedAssets ();
      }
      
   }
}
