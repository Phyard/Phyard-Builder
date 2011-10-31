
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
      protected var mIsSequencedModuleManager:Boolean;
      
      public function AssetImageCompositeModuleManager (sequencedModuleManager:Boolean)
      {
         super ();
         
         mIsSequencedModuleManager = sequencedModuleManager;
      }
      
      public function IsSequencedModuleManager ():Boolean
      {
         return mIsSequencedModuleManager;
      }
      
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

      public function CreateImageCompositeModule (insertBeforeSelectedThenSelectNew:Boolean = false):AssetImageCompositeModule
      {
         var module:AssetImageCompositeModule = new AssetImageCompositeModule (this, IsSequencedModuleManager ());
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
         var menuItemCreateCompositeModule:ContextMenuItem = new ContextMenuItem  (IsSequencedModuleManager () ? "Create New Sequenced Module" : "Create New Assembled Module", true);

         menuItemCreateCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateCompositeModule);

         customMenuItemsStack.push (menuItemCreateCompositeModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_CreateCompositeModule (event:ContextMenuEvent):void
      {
         var module:AssetImageCompositeModule = CreateImageCompositeModule (true);
      }
   }
}

