
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
   
   import editor.image.dialog.AssetImageDivideDialog;
   
   import common.Transform2D;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImagePureModule extends AssetImageModule
   {
      protected var mAssetImagePureModuleManager:AssetImagePureModuleManager;
      protected var mImageDivisionPeer:AssetImageDivision;
      
      public function AssetImagePureModule (assetImagePureModuleManager:AssetImagePureModuleManager, imageDivision:AssetImageDivision)
      {
         super (assetImagePureModuleManager);
         
         mAssetImagePureModuleManager = assetImagePureModuleManager;
         mImageDivisionPeer = imageDivision;
         mImageDivisionPeer.SetImagePureModulePeer (this);
      }
      
      public function GetAssetImagePureModuleManager ():AssetImagePureModuleManager
      {
         return mAssetImagePureModuleManager;
      }
      
      override public function GetImageModuleType ():int
      {  
         return AssetImageModule.ImageModuleType_PureModule;
      }
      
      public function GetImageDivisionPeer ():AssetImageDivision
      {
         return mImageDivisionPeer;
      }
      
      override public function ToCodeString ():String
      {
         return "Division#" + GetAppearanceLayerId ();
      }
      
      override public function GetTypeName ():String
      {
         return "Image Module";
      }
      
//=============================================================
//   
//=============================================================
      
      public function OnDivisionChanged ():void
      {
         UpdateAppearance ();
         
         NotifyModifiedForReferers ();
      }
      
//=============================================================
//   
//=============================================================

      override public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         if (mImageDivisionPeer == null)
            return;
         
         var sprite:DisplayObject = mImageDivisionPeer.CreateSpriteForImagePureModule ();
         
         if (transform != null)
            transform.TransformUntransformedDisplayObject (sprite);
         
         container.addChild (sprite);
      }
      
      override public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
      }
      
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         if (mImageDivisionPeer == null)
            return;
         
         var rectangle:Rectangle = mImageDivisionPeer.GetBoundingRectangleForImagePureModule ();
         selectionProxy.AddRectangleShape (rectangle.left, rectangle.top, rectangle.width, rectangle.height, transform);
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemEditModule:ContextMenuItem = new ContextMenuItem("Edit ...");
         
         menuItemEditModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_EditModule);
         
         customMenuItemsStack.push (menuItemEditModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_EditModule (event:ContextMenuEvent):void
      {
         if (mImageDivisionPeer != null)
         {
            AssetImageDivideDialog.ShowAssetImageDivideDialog (mImageDivisionPeer.GetAssetImageDivisionManager ().GetAssetImage ());
            mImageDivisionPeer.GetAssetImageDivisionManager ().SetSelectedAsset (mImageDivisionPeer);
            mAssetImagePureModuleManager.SetSelectedAsset (this);
         }
      }
      
  }
}