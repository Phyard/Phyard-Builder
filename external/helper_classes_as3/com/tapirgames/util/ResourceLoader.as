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
   
   public class ResourceLoader extends Loader
   {  
   // seed swf file
   
      [Embed(source="resource_seed.swf", mimeType="application/octet-stream")]
      private static var SwfFile:Class;
      
   // original data
   
      private var mOriginalData:ByteArray = null;
      
      private var mStartOffset_TagDefineBitsJPEG2:int = 0;
      private var mEndOffset_TagDefineBitsJPEG2:int;
      private var mCharacterID_TagDefineBitsJPEG2:int;
      
      private var mStartOffset_TagDefineSound:int = 0;
      private var mEndOffset_TagDefineSound:int;
      private var mCharacterID_TagDefineSound:int;
      
   // parse seed swf
      
      private function parseSeedSwf ():void
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
            
            mOriginalData.position = 0;
         }
      }
      
   // create new swf file
      
      private function createAndLoadNewSwf (newFileDataWithoutHeader:ByteArray, onCompleteListener:Function, context:LoaderContext):void
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
            
      // load new swf, now, no secure errors. Why adobe makes some troubles for developers?
            
         this.contentLoaderInfo.addEventListener (Event.COMPLETE, onCompleteListener);
         this.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, OnLoadImageError);
         this.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadImageError);
      
         super.loadBytes (newSwfFile, context);
      }
      
      private function OnLoadImageError (event:Event):void
      {
         dispatchEvent(event);
      }
      
   // load image
      
      public function loadImageFromByteArray (imageFileData:ByteArray, context:LoaderContext = null):void
      {
         try
         {
            parseSeedSwf ();
            
            if (mStartOffset_TagDefineBitsJPEG2 == 0)
               throw new Error ("Tag DefineBitsJPEG2 not found.");
            
         // build new swf data
            
            var newData:ByteArray = new ByteArray ();
            newData.endian = Endian.LITTLE_ENDIAN;
            newData.writeBytes (mOriginalData, 0, mStartOffset_TagDefineBitsJPEG2);
            
            newData.writeShort ((21 << 6) | 0x3f);
            newData.writeInt (2 + imageFileData.length); // 2 for CharacterID
            newData.writeShort (mCharacterID_TagDefineBitsJPEG2);
            if (imageFileData.length > 0)
            {
               imageFileData.position = 0;
               newData.writeBytes (imageFileData);
            }
            
            newData.writeBytes (mOriginalData, mEndOffset_TagDefineBitsJPEG2);
         
            createAndLoadNewSwf (newData, OnLoadImageComplete, context);
         }
         catch (error:Error)
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
         }
      }
      
      private function OnLoadImageComplete (event:Event):void
      {
         var bitmap:Bitmap = null;
         
         try
         {
            bitmap = event.target.content as Bitmap;
            if (bitmap == null)
               bitmap = ((event.target.content.GetBitmap as Function) ()) as Bitmap;
            
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
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Invalid image!"));
         else
         {
            var resEvent:ResourceLoadEvent = new ResourceLoadEvent (bitmap);
            dispatchEvent(resEvent);
         }
      }
      
   // load sound
      
      private static const SoundFormat_MP3:String = "mp3";
      private static const SoundFormatBits_MP3:int = 2 << 4;
      
      public function loadSoundFromByteArray (soundFileData:ByteArray, soundFormat:String, soundRate:int, soundSampleSize:int, isStereo:Boolean, numSamples:int, context:LoaderContext = null):void
      {
         try
         {
            var bitsSoundFormat:int;
            
            soundFormat = soundFormat.toLowerCase ();
            if (soundFormat == SoundFormat_MP3)
               bitsSoundFormat = SoundFormatBits_MP3;
            else
               throw new Error ("Only mp3 is supported now.");
            
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
               throw new Error ("Only 11kHz, 22kHz and 44kHz rates are supported: " + bitsSoundRate);
            
            var bitsSoundSize:int;
            
            if (soundSampleSize == 8)
               bitsSoundSize = 0 << 1;
            else if (soundSampleSize == 16)
               bitsSoundSize = 1 << 1;
            else
               throw new Error ("Only 8 and 16 bits sample sizes are supported.");
            
            var bitsSoundType:int;
            
            if (isStereo)
               bitsSoundType = 1 << 0;
            else
               bitsSoundType = 0 << 0;
            
            if (numSamples < 0)
               throw new Error ("numSamples < 0!");
            
         // ...
            
            parseSeedSwf ();
            
            if (mStartOffset_TagDefineSound == 0)
               throw new Error ("Tag DefineSound not found.");
            
         // build new swf data
            
            var newData:ByteArray = new ByteArray ();
            newData.endian = Endian.LITTLE_ENDIAN;
            newData.writeBytes (mOriginalData, 0, mStartOffset_TagDefineSound);
            
            newData.writeShort ((14 << 6) | 0x3f);
            newData.writeInt (7 + soundFileData.length); // 7 for sound infos
            newData.writeShort (mCharacterID_TagDefineSound);
            newData.writeByte (bitsSoundFormat | bitsSoundRate | bitsSoundSize | bitsSoundType);
            newData.writeUnsignedInt (numSamples);
            if (soundFileData.length > 0)
            {
               soundFileData.position = 0;
               newData.writeBytes (soundFileData);
            }
            
            newData.writeBytes (mOriginalData, mEndOffset_TagDefineSound);
         
            createAndLoadNewSwf (newData, OnLoadSoundComplete, context);
         }
         catch (error:Error)
         {
            trace (error.getStackTrace ());
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
         }
      }
      
      private function OnLoadSoundComplete (event:Event):void
      {
         var sound:Sound = null;
         
         try
         {
            sound = ((event.target.content.GetSound as Function) ()) as Sound;
         }
         catch (error:Error)
         {
            sound = null;
         }
         
         if (sound == null)
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Invalid sound!"));
         else
         {
            var resEvent:ResourceLoadEvent = new ResourceLoadEvent (sound);
            dispatchEvent(resEvent);
         }
      }
   }
}
