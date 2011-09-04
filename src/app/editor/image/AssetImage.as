
package editor.image {
   
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
   
   import editor.display.dialog.AssetImageDivideDialog;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImage extends Asset
   {
      public static const AssetSpriteSize:int = 120;
      public static const ImageIconSize:int = 100;
      
      protected var mAssetImageManager:AssetImageManager;
      
      protected var mAssetImageDivisionManager:AssetImageDivisionManager;
      
      private var mBitmap:Bitmap = null;
      
      public function AssetImage (assetImageManager:AssetImageManager)
      {
         super (assetImageManager);
         
         mAssetImageManager = assetImageManager;
         
         mAssetImageDivisionManager = new AssetImageDivisionManager (this);
         
         BuildContextMenu ();
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
         
         if (mBitmap != null && contains (mBitmap))
         {
            removeChild (mBitmap);
         }
         
         var loader:LocalImageLoader = new LocalImageLoader ();
         loader.contentLoaderInfo.addEventListener (Event.COMPLETE, OnLoadImageComplete);
         loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, OnLoadImageError);
         loader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadImageError);
         loader.loadBytes (fileData);
      }
      
      private function OnLoadImageComplete (event:Event):void
      {
         var newBitmap:Bitmap = ((event.target.content.GetBitmap as Function) ()) as Bitmap;
         mBitmap = new Bitmap (newBitmap.bitmapData);
         addChild (mBitmap);
         
         UpdateAppearance ();
      }
      
      private function OnLoadImageError (event:Object):void
      {
         mFileData = null;
      }
      
      public function GetBitmapData ():BitmapData
      {
         return mBitmap == null ? null : mBitmap.bitmapData;
      }
      
//=============================================================
//   
//=============================================================
      
      override public function UpdateAppearance ():void
      {
         var halfSpriteSize:int = AssetSpriteSize * 0.5;
         GraphicsUtil.ClearAndDrawRect (this, - halfSpriteSize, - halfSpriteSize, AssetSpriteSize, AssetSpriteSize,
                                       0x0, 0, true, IsSelected () ? 0xC0C0FF : 0xFFFFFF, false);
         
         if (mBitmap == null)
         {
            GraphicsUtil.DrawLine (this, - halfSpriteSize, - halfSpriteSize, halfSpriteSize, halfSpriteSize); 
            GraphicsUtil.DrawLine (this, halfSpriteSize, - halfSpriteSize,  -halfSpriteSize, halfSpriteSize); 
         }
         else
         {
            var bitmapData:BitmapData = mBitmap.bitmapData;
            var bitmapSize:int = bitmapData.width > bitmapData.height ? bitmapData.width : bitmapData.height;
            mBitmap.scaleX = mBitmap.scaleY = bitmapSize <= ImageIconSize ? 1.0 : Number (ImageIconSize) / Number (bitmapSize);
            mBitmap.x = - 0.5 * mBitmap.width;
            mBitmap.y = - 0.5 * mBitmap.height;
         }
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         var halfSpriteSize:int = AssetSpriteSize * 0.5;
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (0, GetPositionX (), GetPositionY (), halfSpriteSize, halfSpriteSize);
      }
      
//=============================================================
//   
//=============================================================
      
      private var mMenuItemLoadImage:ContextMenuItem;
      private var mMenuItemDivideImage:ContextMenuItem;
      
      final private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
         
         mMenuItemLoadImage = new ContextMenuItem("(Re)load Local Image ...");
         mMenuItemDivideImage = new ContextMenuItem("Divide ...");
         
         mMenuItemLoadImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         mMenuItemDivideImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);

         theContextMenu.customItems.push (mMenuItemLoadImage);
         theContextMenu.customItems.push (mMenuItemDivideImage);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemLoadImage:
               OpenLocalImageFileDialog ();
               break;
            case mMenuItemDivideImage:
               AssetImageDivideDialog.ShowAssetImageDivideDialog (mAssetImageDivisionManager);
               break;
            default:
               break;
         }
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