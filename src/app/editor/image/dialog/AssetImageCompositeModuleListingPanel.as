
package editor.image.dialog {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.asset.AssetManagerPanel;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   
   import editor.image.AssetImageCompositeModuleManager;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageCompositeModuleListingPanel extends AssetManagerPanel 
   {
      protected var mAssetImageCompositeModuleManager:AssetImageCompositeModuleManager;
      
      public function SetAssetImageCompositeModuleManager (assetImageCompositeModuleManager:AssetImageCompositeModuleManager):void
      {
         super.SetAssetManager (assetImageCompositeModuleManager);
          
         mAssetImageCompositeModuleManager = assetImageCompositeModuleManager;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      private var mMenuItemCreateTimeCompositeModule:ContextMenuItem;
      private var mMenuItemCreateSpaceCompositeModule:ContextMenuItem;
      
      override protected function BuildContextMenuInternal ():void
      {
         mMenuItemCreateTimeCompositeModule = new ContextMenuItem("Create New Time Composite Module ...");
         mMenuItemCreateSpaceCompositeModule = new ContextMenuItem("Create New Space Composite Module ...");
         
         mMenuItemCreateTimeCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         mMenuItemCreateSpaceCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);

         contextMenu.customItems.push (mMenuItemCreateTimeCompositeModule);
         contextMenu.customItems.push (mMenuItemCreateSpaceCompositeModule);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemCreateModule:
               mAssetImageCompositeModuleManager.CreateImageCompositeModule (true);
               break;
            default:
               break;
         }
      }
      
   }
}
