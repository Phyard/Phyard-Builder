
package editor.sound {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.media.SoundMixer;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   import flash.geom.Rectangle;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
         
   import flash.net.FileReference;
   import flash.net.FileFilter;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.ResourceLoader;
   import com.tapirgames.util.ResourceLoadEvent;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   
   import com.tapirgames.util.MPEGFrame;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import common.sound.SoundFile;
   
   import common.Transform2D;
   
   import common.Define;
   
   public class AssetSound extends Asset
   {
      protected var mAssetSoundManager:AssetSoundManager;
      
      public function AssetSound (assetSoundManager:AssetSoundManager)
      {
         super (assetSoundManager);
         
         mAssetSoundManager = assetSoundManager;
      }
      
      public function GetAssetSoundManager ():AssetSoundManager
      {
         return mAssetSoundManager;
      }
      
      override public function ToCodeString ():String
      {
         return "Sound#" + GetAppearanceLayerId ();
      }
      
      override public function GetTypeName ():String
      {
         return "Sound";
      }
      
//=============================================================
//   
//=============================================================
      
      private var mSoundInfo:SoundFile = new SoundFile ();
      
      private var _FileData_Temp:ByteArray;

      public function GetSoundAttributeBits ():int
      {
         return mSoundInfo.GetAttributeBits ();
      }
      
      public function SetSoundAttributeBits (bits:int):void
      {
         mSoundInfo.SetAttributeBits (bits);
      }
      
      public function GetSoundNumSamples ():int
      {
         return mSoundInfo.GetNumSamples ();
      }
      
      public function SetSoundNumSamples (numSamples:int):void
      {
         mSoundInfo.SetNumSamples (numSamples);
      }
      
      public function CloneSoundFileData ():ByteArray
      {
         var fileData:ByteArray = mSoundInfo.GetFileData ();
         if (fileData == null)
            return null;
         
         var newByteArray:ByteArray = new ByteArray (); 
         newByteArray.writeBytes (fileData, 0, fileData.length);
         
         newByteArray.position = 0;
         return newByteArray;
      }
      
      public function SetSoundFileData (fileData:ByteArray):void
      {
         mSound = null;
         mSoundInfo.SetFileData (null);
         _FileData_Temp = fileData;
         
         if (ParseSoundFile (fileData, mSoundInfo))
         {
            var loader:ResourceLoader = new ResourceLoader ();
            loader.addEventListener (IOErrorEvent.IO_ERROR, OnLoadSoundError);
            loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadSoundError);
            loader.addEventListener (ResourceLoadEvent.RESOURCE_LOADED, OnLoadSoundComplete);
            loader.loadSoundFromByteArray (fileData, mSoundInfo.GetFileFormat (), mSoundInfo.GetSamplingRate (), mSoundInfo.GetSampleSize (), mSoundInfo.IsStereo (), mSoundInfo.GetNumSamples ());
         }
         else
         {
            OnLoadSoundError (null);
         }
      }
      
      private function OnLoadSoundComplete (event:Event):void
      {
         mSound = (event as ResourceLoadEvent).resource as Sound;
      //trace ("OnLoadSoundComplete, mSound = " + mSound);
         
         mSoundInfo.SetFileData (_FileData_Temp);
         Stop ();
         mNameText.htmlText = "<b>" + GetName () + "</b>";
         mInfoText.htmlText = mSoundInfo.GetFileFormat () + ", " + mSoundInfo.GetSamplingRate () + "kHz, " + (mSoundInfo.IsStereo () ? "stereo" : "mono");
      }
      
      // !!! This function is not triggered even if there are some errors in loading.
      // It seems flash doesn't trigger some errors.
      private function OnLoadSoundError (event:Object):void
      {
      trace ("OnLoadSoundError: " + event);
         //event may be null
         
         _FileData_Temp = null;
         mSoundInfo.SetFileData (null);
         Stop ();
         mPlayButton.SetEnabled (false);
      }
      
//=============================================================
//   
//=============================================================
      
      // only mp3 is supported
      private static function ParseSoundFile (fileData:ByteArray, soundInfo:SoundFile):Boolean
      {
         if (fileData == null)
            return false;
         
         try
         {
            var dataStartIndex:int;
            var samplingRate:int;
            var isMono:Boolean;
            var numSamples:int = 0;

            var numDataFrames:int = 0;
            var frame:MPEGFrame = new MPEGFrame ();
            
            var i:int = 0;
            while (i < fileData.length)
            {
               var b0:int = fileData [i+0] & 0xff;
               var b1:int = fileData [i+1] & 0xff;
               
               if ((b0 == 0xFF) && ((b1 & 0xE0) == 0xE0)) // general frame sync
               {
                  if (numDataFrames == 0) {
                     dataStartIndex = i;
                  }
                  
                  frame.setHeaderByteAt(0, b0);
						frame.setHeaderByteAt(1, b1);
						i += 2;
						frame.setHeaderByteAt(2, fileData[i++]);
						frame.setHeaderByteAt(3, fileData[i++]);
						if (frame.hasCRC) {
							frame.setCRCByteAt(0, fileData[i++]);
							frame.setCRCByteAt(1, fileData[i++]);
						}
						if (numDataFrames == 0) {
							samplingRate = frame.samplingrate;
							isMono = frame.mono;
						}
						++ numDataFrames;
						
						numSamples += frame.samples;
						i += frame.size;
						
						//trace ("frame#" + (numDataFrames - 1) + ": " + frame);
               }
               else
               {
                  var b2:int = fileData [i+2] & 0xff;
                  if (b0 == 0x49 && b1 == 0x44&& b2 == 0x33) // "ID3" (id3v2 frame, must be the start frame)
                  {
                     i += 10 + ((fileData[i + 6] << 21) | (fileData[i + 7] << 14) | (fileData[i + 8] << 7) | fileData[i + 9]); // skip this frame
                  }
                  else if (b0 == 0x54 && b1== 0x41 && b2 == 0x47) // "TAG" (id3v1 frame, must be the end frame)
                  {
                     break;
                  }
                  else
                  {
                     ++ i;
                  }
               }
            }
            
            if (numDataFrames == 0)
            {
               trace ("No data frames are found.");
               return false;
            }
            else
            {
               var soundData:ByteArray = new ByteArray ();
               soundData.writeShort(0);
               soundData.writeBytes (fileData, dataStartIndex, i - dataStartIndex);
               
               soundInfo.SetFileData (soundData);
               soundInfo.SetFileFormat ("mp3");
               soundInfo.SetNumSamples (numSamples);
               soundInfo.SetStereo (! isMono);
               soundInfo.SetSamplingRate (samplingRate);
               soundInfo.SetSampleSize (16);
               
               trace (">>>>> numDataFrames = " + numDataFrames + ", soundInfo = " + soundInfo);
            }
            
            return true;
         }
         catch (error:Error)
         {
            trace (error.getStackTrace ());
         }
         
         return false;
      }
      
//=============================================================
//   
//=============================================================
      
      private var mSound:Sound = null;
      private var mSoundChannel:SoundChannel = null;
      
      private function SetSound (sound:Sound):void
      {
         Stop ();
         
         mSound = sound;
      }
      
      public function Play ():void
      {
         Stop ();
         
         if (mSound != null)
         {
            mSoundChannel = mSound.play ();
            mSoundChannel.addEventListener (Event.SOUND_COMPLETE, OnSoundPlayComplete);
            
            mPlayButton.visible = false;
            mStopButton.visible = true;
         }
      }
      
      public function Stop ():void
      {
         //SoundMixer.stopAll ();
         if (mSoundChannel != null)
         {
            mSoundChannel.removeEventListener (Event.SOUND_COMPLETE, OnSoundPlayComplete);
            mSoundChannel.stop ();
         }
         mSoundChannel = null;
         
         mPlayButton.visible = true;
         mStopButton.visible = false;
      }
      
      private function OnSoundPlayComplete (event:Event):void
      {
         Stop ();
      }
      
//=============================================================
//   
//=============================================================
      
      private var mNameText:TextFieldEx = TextFieldEx.CreateTextField ("<b> </b>");
      private var mInfoText:TextFieldEx = TextFieldEx.CreateTextField (" ");
      private var mPlayButton:TextButton = new TextButton ("<font size='10'>Play</font>", Play);
      private var mStopButton:TextButton = new TextButton ("<font size='10'>Stop</font>", Stop);
      
      override public function UpdateAppearance ():void
      {
         var cellWidth:int  = mAssetSoundManager.GetAssetSpriteWidth ();
         var cellHeight:int = mAssetSoundManager.GetAssetSpriteHeight ();
         
         GraphicsUtil.ClearAndDrawRect (this, 0, 0, cellWidth, cellHeight,
                                       IsSelected () ? 0x000066 : 0x006600, 0, true, IsSelected () ? 0xC0C0FF : 0xD0FFD0, false);
         
         if (numChildren == 0)
         {
            mouseChildren = true;
            
            addChild (mNameText);
            addChild (mInfoText);
            addChild (mPlayButton);
            addChild (mStopButton);
            
            mStopButton.visible = false;
         }
            
         var padding:Number = 3;
         
         mNameText.x = padding;
         mNameText.y = padding;
         mInfoText.x = padding;
         mInfoText.y = mNameText.y + mNameText.height;
         
         mPlayButton.x = cellWidth - mPlayButton.width - padding;
         mPlayButton.y = cellHeight - mPlayButton.height - padding;
         mStopButton.x = cellWidth - mStopButton.width - padding;
         mStopButton.y = cellHeight - mStopButton.height - padding;
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         var cellWidth:int  = mAssetSoundManager.GetAssetSpriteWidth ();
         var cellHeight:int = mAssetSoundManager.GetAssetSpriteHeight ();
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (GetPositionX () + 0.5 * cellWidth, GetPositionY () + 0.5 * cellHeight, 0.5 * cellWidth, 0.5 * cellHeight);
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemLoadSound:ContextMenuItem = new ContextMenuItem("(Re)load Local Sound ...");
         //var menuItemClearSound:ContextMenuItem = new ContextMenuItem("Clear Sound ...");
         
         menuItemLoadSound.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_LoadSound);

         customMenuItemsStack.push (menuItemLoadSound);
         //customMenuItemsStack.push (menuItemClearSound);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mAssetSoundManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_LoadSound (event:ContextMenuEvent):void
      {
         OpenLocalSoundFileDialog ();
      }
      
//=============================================================
//   
//=============================================================
      
      public static const kFileFilter:Array = [new FileFilter("Sound File (*.mp3)", "*.mp3")];
      
      private var mFileReference:FileReference = null; // flash bug: DON'T use this variable as a local variable, otherwise, the complete event will not fire.
      
      private function OpenLocalSoundFileDialog ():void
      {
         mFileReference = new FileReference();
         mFileReference.addEventListener(Event.SELECT, OnSelectFileToLoad);
         mFileReference.browse (kFileFilter);
      }
         
      private function OnSelectFileToLoad (event:Event):void
      {
         mFileReference.addEventListener(Event.COMPLETE, OnFileLoadComplete);
         mFileReference.load();
         mFileReference = null;
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
            
            OnLoadLocalSoundFinished (clonedSoundData, fileReference.name);
         }
         catch (e:Error)
         {
            trace ("local loading sound error");
            trace (e.getStackTrace ());
         }
         fileReference.data.clear ();
      }
      
      public function OnLoadLocalSoundFinished (soundData:ByteArray, soundFileName:String):void
      {
         SetSoundFileData (soundData);
         if (mName == null || mName.length == 0)
         {
            SetName (soundFileName);
         }
      }

  }
}
