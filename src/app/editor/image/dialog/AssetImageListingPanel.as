
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
   
   import editor.image.AssetImageManager;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageListingPanel extends AssetManagerPanel 
   {
      protected var mAssetImageManager:AssetImageManager;
      
      public function SetAssetImageManager (assetImageManager:AssetImageManager):void
      {
         super.SetAssetManager (assetImageManager);
          
         mAssetImageManager = assetImageManager;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      private var mMenuItemCreateImage:ContextMenuItem;
      
      override protected function BuildContextMenuInternal ():void
      {
         mMenuItemCreateImage = new ContextMenuItem("Create New Image ...");
         
         mMenuItemCreateImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);

         contextMenu.customItems.push (mMenuItemCreateImage);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemCreateImage:
               mAssetImageManager.CreateImage (true);
               break;
            default:
               break;
         }
      }
      
   }
}
