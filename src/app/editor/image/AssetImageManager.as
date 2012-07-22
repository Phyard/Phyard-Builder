
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import flash.net.FileReferenceList;
   import flash.net.FileReference;
   import flash.net.FileFilter;
   
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
      
      override public function GetModuleIconSize ():Number
      {
         return 86;
      }
      
//==========================================================      
// 
//==========================================================      
      
      public function CreateImage (key:String, insertBeforeSelectedThenSelectNew:Boolean = false):AssetImage
      {
         var image:AssetImage = new AssetImage (this, ValidateAssetKey (key));
         image.UpdateAppearance ();
         image.UpdateSelectionProxy ();
         addChild (image);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (image);
         
         UpdateLayout (true);
         
         return image;
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemLoadLocalImages:ContextMenuItem = new ContextMenuItem("Load Local Image(s) ...", true);
         //var menuItemCreateImage:ContextMenuItem = new ContextMenuItem("Create Blank Image ...");
         
         menuItemLoadLocalImages.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_LoadLocalImages);
         //menuItemCreateImage.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateImage);

         customMenuItemsStack.push (menuItemLoadLocalImages);
         //customMenuItemsStack.push (menuItemCreateImage);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      //private function OnContextMenuEvent_CreateImage (event:ContextMenuEvent):void
      //{
      //   CreateImage (null, true);
      //}
      
      private function OnContextMenuEvent_LoadLocalImages (event:ContextMenuEvent):void
      {
         OpenLocalImageFileDialog ();
      }
      
//=====================================================================
// 
//=====================================================================

      private var mFileReferenceList:FileReferenceList = null;
      
      private function OpenLocalImageFileDialog ():void
      {
         mFileReferenceList = new FileReferenceList();
         mFileReferenceList.addEventListener(Event.SELECT, OnSelectFilesToLoad);
         mFileReferenceList.browse(AssetImage.kFileFilter);
      }
      
      private var mFileReferences:Array = null;
      private var mFileReferenceIndex:int = 0;
         
      private function OnSelectFilesToLoad (event:Event):void
      {
         mFileReferences = mFileReferenceList.fileList.concat (); // flash bug? must use concat
         mFileReferenceIndex = 0;
         
         if (mFileReferences.length == 0)
            return;
         
         // flash bug: must load images one by one
         LoadNextImage ();
      }
      
      private function LoadNextImage ():void
      {
         if (mFileReferenceIndex >= mFileReferences.length)
         {
            mFileReferences = null;
            return;
         }
         
         var fileReference:FileReference = mFileReferences [mFileReferenceIndex] as FileReference;
         fileReference.addEventListener(Event.COMPLETE, OnFileLoadComplete);
         fileReference.addEventListener(IOErrorEvent.IO_ERROR, OnFileLoadError);
         fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityError);
         fileReference.load ();

         mFileReferences [mFileReferenceIndex ++] = null;
      }
      
      public function OnFileLoadComplete (event:Event):void
      {  
         var fileReference:FileReference = (event.target as FileReference);
         try
         {
            var clonedImageData:ByteArray = new ByteArray ();
            clonedImageData.length = fileReference.data.length;
            
            fileReference.data.position = 0;
            clonedImageData.writeBytes (fileReference.data, 0, fileReference.data.length);
            
            var imageAsset:AssetImage = CreateImage (null, true);
            imageAsset.OnLoadLocalImageFinished (clonedImageData, fileReference.name);
         }
         catch (e:Error)
         {
            trace ("local loading image error");
            trace (e.getStackTrace ());
         }
         fileReference.data.clear ();
         
         LoadNextImage ();
      }
      
      private function OnFileLoadError (event:IOErrorEvent):void
      {
         LoadNextImage ();
         
         trace("ioErrorHandler: " + event);
      }
      
       private function OnSecurityError(event:Event):void
       {
         trace("OnSecurityError: " + event);
       }
   }
}

