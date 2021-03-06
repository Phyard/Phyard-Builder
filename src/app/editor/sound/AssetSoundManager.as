
package editor.sound {
   
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
   
   import flash.media.SoundMixer;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.core.EditorObject;
   
   import editor.asset.AssetManager;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetSoundManager extends AssetManager 
   {
      
//==========================================================      
// 
//==========================================================      
      
      public function CreateSound (key:String, insertBeforeSelectedThenSelectNew:Boolean = false):AssetSound
      {
         var soundAsset:AssetSound = new AssetSound (this, ValidateAssetKey (key));
         soundAsset.UpdateAppearance ();
         soundAsset.UpdateSelectionProxy ();
         addChild (soundAsset);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (soundAsset);
         
         UpdateLayout (true);
         
         return soundAsset;
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemLoadLocalSounds:ContextMenuItem = new ContextMenuItem("Load Local Sounds(s) ...", true);
         //var menuItemCreateSound:ContextMenuItem = new ContextMenuItem("Create Blank Sound ...");
         var menuItemDeleteSelecteds:ContextMenuItem = new ContextMenuItem("Delete Selected(s) ...", true);
         
         menuItemLoadLocalSounds.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_LocalSounds);
         //menuItemCreateSound.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateSound);
         menuItemDeleteSelecteds.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_DeleteSelectedAssets);

         customMenuItemsStack.push (menuItemLoadLocalSounds);
         //customMenuItemsStack.push (menuItemCreateSound);
         customMenuItemsStack.push (menuItemDeleteSelecteds);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      
      private function OnContextMenuEvent_CreateSound (event:ContextMenuEvent):void
      {
         CreateSound (null, true);
      }
      
      private function OnContextMenuEvent_LocalSounds (event:ContextMenuEvent):void
      {
         OpenLocalSoundFileDialog ();
      }
      
      private function OnContextMenuEvent_DeleteSelectedAssets (event:ContextMenuEvent):void
      {
         DeleteSelectedAssets ();
      }
      
//=====================================================================
// 
//=====================================================================

      public function StopAllSounds ():void
      {
         var numSounds:int = GetNumAssets ();
         for (var i:int = 0;i < numSounds; ++ i)
         {
            (GetAssetByAppearanceId (i) as AssetSound).Stop ();
         }
         
         SoundMixer.stopAll ();
      }
     
//=====================================================================
// 
//=====================================================================

      private var mFileReferenceList:FileReferenceList = null;
      
      private function OpenLocalSoundFileDialog ():void
      {
         mFileReferenceList = new FileReferenceList();
         mFileReferenceList.addEventListener(Event.SELECT, OnSelectFilesToLoad);
         mFileReferenceList.browse(AssetSound.kFileFilter);
      }
      
      private var mFileReferences:Array = null;
      private var mFileReferenceIndex:int = 0;
         
      private function OnSelectFilesToLoad (event:Event):void
      {
         mFileReferences = mFileReferenceList.fileList.concat (); // flash bug? must use concat
         mFileReferenceIndex = 0;
         
         if (mFileReferences.length == 0)
            return;
         
         // flash bug: must load sounds one by one
         LoadNextSound ();
      }
      
      private function LoadNextSound ():void
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
            var clonedSoundData:ByteArray = new ByteArray ();
            clonedSoundData.length = fileReference.data.length;
            
            fileReference.data.position = 0;
            clonedSoundData.writeBytes (fileReference.data, 0, fileReference.data.length);
            
            var soundAsset:AssetSound = CreateSound (null, true);
            soundAsset.OnLoadLocalSoundFinished (clonedSoundData, fileReference.name);
         }
         catch (e:Error)
         {
            trace ("local loading sound error");
            trace (e.getStackTrace ());
         }
         fileReference.data.clear ();
         
         LoadNextSound ();
      }
      
      private function OnFileLoadError (event:IOErrorEvent):void
      {
         LoadNextSound ();
         
         trace("ioErrorHandler: " + event);
      }
      
       private function OnSecurityError(event:Event):void
       {
         trace("OnSecurityError: " + event);
       }
   }
}

