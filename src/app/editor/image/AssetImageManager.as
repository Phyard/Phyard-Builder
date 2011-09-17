
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
   
   public class AssetImageManager extends AssetImageModuleManager //AssetManager 
   {
//==========================================================      
// 
//==========================================================      
      
      override public function GetAssetSpriteSize ():Number
      {
         return 100;
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
         return 86;
      }
      
//==========================================================      
// 
//==========================================================      
      
      public function CreateImage (insertBeforeSelectedThenSelectNew:Boolean):AssetImage
      {
         var image:AssetImage = new AssetImage (this);
         image.UpdateAppearance ();
         image.UpdateSelectionProxy ();
         addChild (image);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (image);
         
         RearrangeAssetPositions (true);
         
         return image;
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemCreateImage:ContextMenuItem = new ContextMenuItem("Create New Image ...", true);
         
         menuItemCreateImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateImage);

         customMenuItemsStack.push (menuItemCreateImage);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_CreateImage (event:ContextMenuEvent):void
      {
         CreateImage (true);
      }
      
      
   }
}

