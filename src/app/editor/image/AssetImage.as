
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
   
   import editor.image.dialog.AssetImageDivideDialog;
   
   import common.Define;
   
   public class AssetImage extends AssetImageModule //Asset
   {
      protected var mAssetImageManager:AssetImageManager;
      
      protected var mAssetImageDivisionManager:AssetImageDivisionManager;
      
      private var mBitmapData:BitmapData = null;
      
      public function AssetImage (assetImageManager:AssetImageManager)
      {
         super (assetImageManager);
         
         mAssetImageManager = assetImageManager;
         
         mAssetImageDivisionManager = new AssetImageDivisionManager (this);
      }
      
      public function GetAssetImageManager ():AssetImageManager
      {
         return mAssetImageManager;
      }
      
      public function GetAssetImageDivisionManager ():AssetImageDivisionManager
      {
         return mAssetImageDivisionManager;
      }
      
      override public function ToCodeString ():String
      {
         return "Image#" + mCreationOrderId;
      }
      
      override public function GetTypeName ():String
      {
         return "Image";
      }
      
//=============================================================
//   
//=============================================================
      
      private var mFileData:ByteArray;
      
      public function SetBitmapFileData (fileData:ByteArray):void
      {
         mFileData = fileData;
         
         mBitmapData = null;
         
         //var loader:Loader = new Loader();
         var loader:LocalImageLoader = new LocalImageLoader ();
         loader.contentLoaderInfo.addEventListener (Event.COMPLETE, OnLoadImageComplete);
         loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, OnLoadImageError);
         loader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadImageError);
         loader.loadBytes (fileData);
      }
      
      private function OnLoadImageComplete (event:Event):void
      {
         //var newBitmap:Bitmap = event.target.content as Bitmap;
         var newBitmap:Bitmap = ((event.target.content.GetBitmap as Function) ()) as Bitmap;
         mBitmapData = newBitmap.bitmapData;
         
         UpdateAppearance ();
      }
      
      private function OnLoadImageError (event:Object):void
      {
         mFileData = null;
      }
      
      public function GetBitmapData ():BitmapData
      {
         return mBitmapData;
      }
      
//=============================================================
//   
//=============================================================
      
      override public function CreateModuleSprite ():DisplayObject
      {
         return mBitmapData == null ? null : new Bitmap (mBitmapData);
      }
      
      override public function GetModuleBoundingRectangle ():Rectangle
      {
         if (mBitmapData == null)
            return null;
         
         var rectangle:Rectangle = new Rectangle (0, 0, mBitmapData.width, mBitmapData.height);
         return rectangle;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      private var mMenuItemLoadImage:ContextMenuItem;
      private var mMenuItemDivideImage:ContextMenuItem;
      
      override protected function BuildContextMenuInternal ():void
      {
         mMenuItemLoadImage = new ContextMenuItem("(Re)load Local Image ...");
         mMenuItemDivideImage = new ContextMenuItem("Divide ...");
         
         mMenuItemLoadImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         mMenuItemDivideImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);

         contextMenu.customItems.push (mMenuItemLoadImage);
         contextMenu.customItems.push (mMenuItemDivideImage);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemLoadImage:
               OpenLocalImageFileDialog ();
               break;
            case mMenuItemDivideImage:
               AssetImageDivideDialog.ShowAssetImageDivideDialog (this);
               break;
            default:
               break;
         }
      }
      
      private var mAssetImageDivideDialog:AssetImageDivideDialog;
      
      public function SetAssetImageDivideDialog (assetImageDivideDialog:AssetImageDivideDialog):void
      {
         mAssetImageDivideDialog = assetImageDivideDialog;
      }
      
      public function GetAssetImageDivideDialog ():AssetImageDivideDialog
      {
         return mAssetImageDivideDialog;
      }
      
      private static const kFileFilter:Array = [new FileFilter("Image File", "*jpg;*.png;*.gif;")];
      
      private var fileReference:FileReference = null; // flash bug: DON'T use this variable as a local variable, otherwise, the complete event will not fire.
      
      private function OpenLocalImageFileDialog ():void
      {
         fileReference = new FileReference();
         fileReference.addEventListener(Event.SELECT, OnSelectFileToLoad);
         fileReference.browse (kFileFilter);
      }
         
      private function OnSelectFileToLoad (event:Event):void
      {
         fileReference.addEventListener(Event.COMPLETE, OnFileLoadComplete);
         fileReference.load();
      }    
      
      private function OnFileLoadComplete (event:Event):void
      {
         var fileReference:FileReference = (event.target as FileReference);
         try
         {
            var clonedImageData:ByteArray = new ByteArray ();
            clonedImageData.length = fileReference.data.length;
            
            //fileReference.data.position = 0;
            //clonedImageData.writeBytes (fileReference.data, 0, fileReference.data.length);
            
            var bytesValues:Array = new Array (fileReference.data.length);
            for (var i:int = 0; i < fileReference.data.length; ++ i)
            {
               var byte:int = fileReference.data [i];
               bytesValues [i] = byte;
            }
            
            for (var j:int = 0; j < fileReference.data.length; ++ j)
            {
               clonedImageData [j] = bytesValues [j];
            }
            
            OnLoadLocalImageFinished (clonedImageData, fileReference.name);
         }
         catch (e:Error)
         {
            trace ("local loading image error");
            trace (e.getStackTrace ());
         }
         fileReference.data.clear ();
      }
      
      private function OnLoadLocalImageFinished (imageData:ByteArray, imageFileName:String):void
      {
         SetBitmapFileData (imageData);
         if (mName == null || mName.length == 0)
         {
            SetName (imageFileName);
         }
      }

  }
}