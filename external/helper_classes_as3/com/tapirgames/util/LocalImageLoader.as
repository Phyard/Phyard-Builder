package com.tapirgames.util
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.display.Loader;
   import flash.system.LoaderContext;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   public class LocalImageLoader extends Loader
   {
   // template swf file
   
      [Embed(source="template.swf", mimeType="application/octet-stream")]
      private static var SwfFile:Class;
      
   // original data
   
      private var mOriginalData:ByteArray = null;
      
      private var mStartOffset_TagDefineBitsJPEG2:int;
      private var mEndOffset_TagDefineBitsJPEG2:int;
      private var mCharacterID_TagDefineBitsJPEG2:int;
   
   // load
      
      override public function loadBytes (imageFileData:ByteArray, context:LoaderContext = null):void
      {
         try
         {
         
         // parse
         
            if (mOriginalData == null)
            {
               var swfFile:ByteArray = new SwfFile ();
               swfFile.endian = Endian.LITTLE_ENDIAN;
               swfFile.position = 8;
               var mOriginalData:ByteArray = new ByteArray ();
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
                  {
                     //break;
                     throw new Error ("DefineBitsJPEG2 tag is not found!");
                  }
                  
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
	                  
	                  break;
	               }
	               
	               mOriginalData.position = endOffset;
               }
            }
            
            mOriginalData.position = 0;
            
         // write
            
            var newData:ByteArray = new ByteArray ();
            newData.endian = Endian.LITTLE_ENDIAN;
            newData.writeBytes (mOriginalData, 0, mStartOffset_TagDefineBitsJPEG2);
            newData.writeShort ((21 << 6) | 0x3f);
            newData.writeInt (2 + imageFileData.length); // 2 for CharacterID
            newData.writeShort (mCharacterID_TagDefineBitsJPEG2);
            if (imageFileData.length > 0)
            {
               newData.writeBytes (imageFileData);
            }
            newData.writeBytes (mOriginalData, mEndOffset_TagDefineBitsJPEG2);
            var newFileLength:int = newData.length + 8;
            newData.compress ();
            
            var newSwfFile:ByteArray = new ByteArray ();
            newSwfFile.endian = Endian.LITTLE_ENDIAN;
            newSwfFile.writeByte (0x43);
            newSwfFile.writeByte (0x57);
            newSwfFile.writeByte (0x53);
            newSwfFile.writeByte (10);
            newSwfFile.writeUnsignedInt (newFileLength);
            newSwfFile.writeBytes (newData);
            newSwfFile.position = 0;
         }
         catch (error:Error)
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
         }
         
      // load, now, no secure errors. Why adobe makes some troubles for developers?
      
         super.loadBytes (newSwfFile, context);
      }
   }
}
