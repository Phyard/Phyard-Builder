package com.tapirgames.util
{
   import flash.display.Bitmap;
   import flash.media.Sound;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.display.Loader;
   import flash.system.LoaderContext;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   public class ResourceLoader
   {
   
//===================================================================
// static data
//===================================================================

   // seed swf file
   
      [Embed(source="resource_seed.swf", mimeType="application/octet-stream")]
      private static var SwfFile:Class;
      
   // original data
   
      private static var mOriginalData:ByteArray = null;
      
      private static var mStartOffset_TagDefineBitsJPEG2:int = 0;
      private static var mEndOffset_TagDefineBitsJPEG2:int;
      private static var mCharacterID_TagDefineBitsJPEG2:int;
      
      private static var mStartOffset_TagDefineSound:int = 0;
      private static var mEndOffset_TagDefineSound:int;
      private static var mCharacterID_TagDefineSound:int;
      
   // parse seed swf
      
      private static function ParseSeedSwf ():void
      {
         if (mOriginalData == null)
         {
            var swfFile:ByteArray = new SwfFile ();
            swfFile.endian = Endian.LITTLE_ENDIAN;
            swfFile.position = 8;
            mOriginalData = new ByteArray ();
            mOriginalData.endian = Endian.LITTLE_ENDIAN;
            swfFile.readBytes (mOriginalData);
            mOriginalData.uncompress ();
            
            var numBits:int = (mOriginalData [0] & 0xFF) >> 3;
            mOriginalData.position = (((numBits << 2) + 5 + 7) >> 3) + 4;
            
            while (true)
            {
               var startOffset:int = mOriginalData.position;
               var tagTypeAndLength:int = mOriginalData.readUnsignedShort ();
               var tagType:int = tagTypeAndLength >> 6;
               if (tagType == 0) // end tag
                  break;
               
               var tagLength:int = tagTypeAndLength & 0x3f;
               if (tagLength == 0x3f)
               {
	               tagLength = mOriginalData.readInt ();
               }
               
               var endOffset:int = mOriginalData.position + tagLength;

               if (tagType == 21) // tag DefineBitsJPEG2
               {
                  mCharacterID_TagDefineBitsJPEG2 = mOriginalData.readShort ();
                  mStartOffset_TagDefineBitsJPEG2 = startOffset;
                  mEndOffset_TagDefineBitsJPEG2 = endOffset;
               }
               else if (tagType == 14) // tag DefineSound
               {
                  mCharacterID_TagDefineSound = mOriginalData.readShort ();
                  mStartOffset_TagDefineSound = startOffset;
                  mEndOffset_TagDefineSound = endOffset;
               }
            
               mOriginalData.position = endOffset;
            }
         }
         
         mOriginalData.position = 0;
      }
      
//===================================================================
// static data
//===================================================================

      protected var mResFileData:ByteArray;
      
      protected var mOnSucceededCallback:Function;
      protected var mOnFailedCallback:Function;
      
      // every params should not be null
      public function ResourceLoader (resFileData:ByteArray, onSucceeded:Function, onFailed:Function)
      {
         mResFileData = resFileData;
         
         mOnSucceededCallback = onSucceeded;
         mOnFailedCallback = onFailed;
      }
      
   // create new swf file
      
      private function CreateAndLoadNewSwf (newFileDataWithoutHeader:ByteArray, onCompleteListener:Function):void
      {
         var newFileLength:int = newFileDataWithoutHeader.length + 8;
         
         newFileDataWithoutHeader.compress ();
         
         var newSwfFile:ByteArray = new ByteArray ();
         newSwfFile.endian = Endian.LITTLE_ENDIAN;
         newSwfFile.writeByte (0x43);
         newSwfFile.writeByte (0x57);
         newSwfFile.writeByte (0x53);
         newSwfFile.writeByte (10);
         newSwfFile.writeUnsignedInt (newFileLength);
         newSwfFile.writeBytes (newFileDataWithoutHeader);
         newSwfFile.position = 0;
            
      // load new swf, now, no secure errors for local swf file on non-iOS platforms. Why adobe makes some troubles for developers?
         
         var loader:Loader = new Loader ();
         loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onCompleteListener);
         loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, OnLoadingError);
         loader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
         
         //>> for air app, not very secure
         var context:LoaderContext = new LoaderContext();
         if (context.hasOwnProperty ("allowCodeImport"))
            (context as Object).allowCodeImport = true;
         else if (context.hasOwnProperty ("allowLoadBytesCodeExecution"))
            (context as Object).allowLoadBytesCodeExecution = true;
         //<<
         
         loader.loadBytes (newSwfFile, context);
      }
      
      private function OnLoadingError (event:Event):void
      {
         mOnFailedCallback (event.toString ());
      }
      
   // load image
   
      // this loadBytes version will throw ioError on iOS, 
      // but it works well for local swf file.
      private function StartLoadingImage2 ():void
      {
         try
         {
            ParseSeedSwf ();
            
            if (mStartOffset_TagDefineBitsJPEG2 == 0)
               throw new Error ("Tag DefineBitsJPEG2 not found.");
            
         // replace swf tag data
            
            var newData:ByteArray = new ByteArray ();
            newData.endian = Endian.LITTLE_ENDIAN;
            newData.writeBytes (mOriginalData, 0, mStartOffset_TagDefineBitsJPEG2);
            
            newData.writeShort ((21 << 6) | 0x3f);
            newData.writeInt (2 + mResFileData.length); // 2 for CharacterID
            newData.writeShort (mCharacterID_TagDefineBitsJPEG2);
            if (mResFileData.length > 0)
            {
               mResFileData.position = 0;
               newData.writeBytes (mResFileData);
            }
            
            newData.writeBytes (mOriginalData, mEndOffset_TagDefineBitsJPEG2);
         
         // load new swf
         
            CreateAndLoadNewSwf (newData, OnLoadImageComplete2);
         }
         catch (error:Error)
         {
            mOnFailedCallback ("StartLoadingImageFromByteArray2: " + error.message);
         }
      }
      
      private function OnLoadImageComplete2 (event:Event):void
      {
         var bitmap:Bitmap = null;
         
         try
         {
            //bitmap = ((event.target.content.GetBitmap as Function) ()) as Bitmap;
            var bitmapClass:Class = (event.target.content as Object).BitmapClass as Class;
            bitmap = new bitmapClass ();
            
            if (bitmap == null || bitmap.bitmapData == null || bitmap.bitmapData.width == 0 || bitmap.bitmapData.height == 0)
            {
               bitmap = null;
            }
         }
         catch (error:Error)
         {
            bitmap = null;
         }
         
         if (bitmap == null)
         {
            mOnFailedCallback ("StartLoadingImageFromByteArray2: invalid image!");
         }
         else
         {
            mOnSucceededCallback (bitmap);
         }
      }
      
      // this version doesn't throw ioError on iOS
      // but it fails for local swf file.
      public function StartLoadingImage ():void
      {
         if (mResFileData == null)
         {
            mOnFailedCallback ("Image data is null!");
            return;
         }
           
         try
         {
            var loader:Loader = new Loader ();
            
            loader.contentLoaderInfo.addEventListener (Event.COMPLETE, OnLoadImageComplete);
            loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, OnLoadingError);
            loader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
            
            loader.loadBytes (mResFileData);
         }
         catch (error:Error)
         {
            mOnFailedCallback ("loadImageFromByteArray error: " + error.message);
         }
      }
      
      private function OnLoadImageComplete (event:Event):void
      {
         var bitmap:Bitmap = null;
         
         try
         {
            bitmap = event.target.content as Bitmap;
                     // bitmap is possible null for SecurityError: Error #2148
            
            if (bitmap == null || bitmap.bitmapData == null || bitmap.bitmapData.width == 0 || bitmap.bitmapData.height == 0)
            {
               bitmap = null;
            }
         }
         catch (error:Error)
         {
            // http://www.senocular.com/pub/adobe/Flash%20Player%20Security%20Basics.html
            // SecurityError: Error #2148
            // In fact, Adobe does it over-securely.
            // 
            // although event.target.content is a bitmap, if the swf file is running for a local disk (file:///),
            // SecurityError will be thrown.
            // fortunately, this only happens on PC, not on iOS.
            
            bitmap = null;
         }
         
         if (bitmap == null)
         {
            //dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Invalid image!"));
            
            event.target.removeEventListener (Event.COMPLETE, OnLoadImageComplete);
            event.target.removeEventListener (IOErrorEvent.IO_ERROR, OnLoadingError);
            event.target.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
            
            // try another method
            StartLoadingImage2 ();
         }
         else
         {
            mOnSucceededCallback (bitmap);
         }
      }
      
   // load sound
      
      private static const SoundFormat_MP3:String = "mp3";
      private static const SoundFormatBits_MP3:int = 2 << 4;
      
      // this loadBytes version will throw ioError on iOS, 
      // but it works well for local swf file.
      public function StartLoadingSound (soundFormat:String, soundRate:int, soundSampleSize:int, isStereo:Boolean, numSamples:int):void
      {
         if (mResFileData == null)
         {
            mOnFailedCallback ("Sound data is null!");
            return;
         }
          
         try
         {
            var bitsSoundFormat:int;
            
            soundFormat = soundFormat.toLowerCase ();
            if (soundFormat == SoundFormat_MP3)
               bitsSoundFormat = SoundFormatBits_MP3;
            else
               throw new Error ("Only mp3 is supported now: " + soundFormat);
            
            var bitsSoundRate:int;
            
            //if (soundRate == 5512)
            //{
            //   if (bitsSoundFormat == SoundFormatBits_MP3)
            //      throw new Error ("5.5kHz rate is not valid for mp3 format.");
            //   
            //   bitsSoundRate = 0 << 2;
            //}
            //else 
            if (soundRate == 11025)
               bitsSoundRate = 1 << 2;
            else if (soundRate == 22050)
               bitsSoundRate = 2 << 2;
            else if (soundRate == 44100)
               bitsSoundRate = 3 << 2;
            else
               throw new Error ("Only 11kHz, 22kHz and 44kHz rates are supported: " + soundRate);
            
            var bitsSoundSize:int;
            
            if (soundSampleSize == 8)
               bitsSoundSize = 0 << 1;
            else if (soundSampleSize == 16)
               bitsSoundSize = 1 << 1;
            else
               throw new Error ("Only 8 and 16 bits sample sizes are supported: " + soundSampleSize);
            
            var bitsSoundType:int;
            
            if (isStereo)
               bitsSoundType = 1 << 0;
            else
               bitsSoundType = 0 << 0;
            
            if (numSamples < 0)
               throw new Error ("numSamples must be larger than 0: " + numSamples);
            
         // ...
            
            ParseSeedSwf ();
            
            if (mStartOffset_TagDefineSound == 0)
               throw new Error ("Tag DefineSound not found.");
            
         // replace swf tag data
            
            var newData:ByteArray = new ByteArray ();
            newData.endian = Endian.LITTLE_ENDIAN;
            newData.writeBytes (mOriginalData, 0, mStartOffset_TagDefineSound);
            
            newData.writeShort ((14 << 6) | 0x3f);
            newData.writeInt (7 + mResFileData.length); // 7 for sound infos
            newData.writeShort (mCharacterID_TagDefineSound);
            newData.writeByte (bitsSoundFormat | bitsSoundRate | bitsSoundSize | bitsSoundType);
            newData.writeUnsignedInt (numSamples);
            // the sound data includes the num samples to skip (2 bytes at the beginning)
            if (mResFileData.length > 0)
            {
               mResFileData.position = 0;
               newData.writeBytes (mResFileData);
            }
            
            newData.writeBytes (mOriginalData, mEndOffset_TagDefineSound);
         
         // load new swf
         
            CreateAndLoadNewSwf (newData, OnLoadSoundComplete);
         }
         catch (error:Error)
         {
            mOnFailedCallback ("loadImageFromByteArray error: " + error.message);
         }
      }
      
      private function OnLoadSoundComplete (event:Event):void
      {
         var sound:Sound = null;
         
         try
         {
            //sound = ((event.target.content.GetSound as Function) ()) as Sound;
            var soundClass:Class = (event.target.content as Object).SoundClass as Class;
            sound = new soundClass ();
         }
         catch (error:Error)
         {
            sound = null;
         }
         
         if (sound == null)
         {
            mOnFailedCallback ("OnLoadSoundComplete: invalid sound!");
         }
         else
         {
            mOnSucceededCallback (sound);
         }
      }
   }
}
