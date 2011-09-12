
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
         
   import flash.net.FileReference;
   import flash.net.FileFilter;
   import flash.events.IOErrorEvent;
   
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
   
   import editor.image.dialog.AssetImageCompositeModuleEditDialog;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageCompositeModule extends AssetImageModule
   {
      protected var mAssetImageCompositeModuleManager:AssetImageCompositeModuleManager;
      
      protected var mModuleInstanceManager:AssetImageModuleInstanceManager; // for internal module parts editing
      protected var mModuleInstanceManagerForListing:AssetImageModuleInstanceManager; // for internal module parts listing
      
      public function AssetImageCompositeModule (assetImageCompositeModuleManager:AssetImageCompositeModuleManager)
      {
         super (assetImageCompositeModuleManager);
         
         mAssetImageCompositeModuleManager = assetImageCompositeModuleManager;
         
         mModuleInstanceManager           = new AssetImageModuleInstanceManager (false);
         mModuleInstanceManagerForListing = new AssetImageModuleInstanceManager (true);
      }
      
      public function GetAssetImageCompositeModuleManager ():AssetImageCompositeModuleManager
      {
         return mAssetImageCompositeModuleManager;
      }
      
      public function GetModuleInstanceManager ():AssetImageModuleInstanceManager
      {
         return mModuleInstanceManager;
      }
      
      public function GetModuleInstanceManagerForListing ():AssetImageModuleInstanceManager
      {
         return mModuleInstanceManagerForListing;
      }
      
      override public function ToCodeString ():String
      {
         return "Composite Module#" + mCreationOrderId;
      }
      
      override public function GetTypeName ():String
      {
         return "Composite Module";
      }
      
//=============================================================
//   
//=============================================================
      
      override public function CreateModuleSprite ():DisplayObject
      {
         return null;
      }
      
      override public function GetModuleBoundingRectangle ():Array
      {
         return null;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      private var mMenuItemEditModule:ContextMenuItem;
      
      override protected function BuildContextMenuInternal ():void
      {
         mMenuItemEditModule = new ContextMenuItem("Edit ...");
         
         mMenuItemEditModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         contextMenu.customItems.push (mMenuItemEditModule);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemEditModule:
               AssetImageCompositeModuleEditDialog.ShowAssetImageCompositeModuleEditDialog (this);
               break;
            default:
               break;
         }
      }
      
      private var mAssetImageCompositeModuleEditDialog:AssetImageCompositeModuleEditDialog;
      public function SetAssetImageCompositeModuleEditDialog (assetImageCompositeModuleEditDialog:AssetImageCompositeModuleEditDialog):void
      {
         mAssetImageCompositeModuleEditDialog = assetImageCompositeModuleEditDialog;
      }
      
      public function GetAssetImageCompositeModuleEditDialog ():AssetImageCompositeModuleEditDialog
      {
         return mAssetImageCompositeModuleEditDialog;
      }
      
  }
}