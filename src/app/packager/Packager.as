package packager
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class Packager
   {

      public function Packager ()
      {
         
      }

//=====================================================================================================
// 
//=====================================================================================================

   // file data
   
      private var mFileVersion:int;
      private var mOldFileLength:int;
	   private var mFrameRateX256:int;
	   private var mFrameCount:int;
   
      private var mOriginalGameFileWithoutHeader:ByteArray = null;
      
      private var mOffset_Tags:int = 0;
      
      private var mStartOffset_TagDefineBinaryAsset:int = 0;
      private var mEndOffset_TagDefineBinaryAsset:int;
      private var mCharacterID_TagDefineBinaryAsset:int;
      private var mReservedValue_TagDefineBinaryAsset:int;
      
   // level data
   
      private var mOriginalGameData:ByteArray = null;
      
   // parse seed swf
   
      public function SetSeedGameFileData (swfFile:ByteArray):void
      {
         mOriginalGameFileWithoutHeader = null;
         mOriginalGameData = null;
         
         mOffset_Tags = 0;
         mStartOffset_TagDefineBinaryAsset = 0;
         
         // ...
         
         swfFile.position = 0;
         swfFile.endian = Endian.LITTLE_ENDIAN;
         
         var b0:int = swfFile.readUnsignedByte ();
            // 0x43: data is compressed
            // 0x46: data is not compressed
         
         if (b0 != 0x43 && b0 != 0x46)
		      throw new Error ("the 1st byte should be 0x43 or 0x46");
	      
	      var b1:int = swfFile.readUnsignedByte ();
         if (b1 != 0x57)
            throw new Error ("the 2nd byte should be 0x57");
         
         var b2:int = swfFile.readUnsignedByte ();
         if (b2 != 0x53)
            throw new Error ("the 3rd byte should be 0x53");
         
         mFileVersion = swfFile.readUnsignedByte ();
         
         mOldFileLength = swfFile.readInt ();
         
         mOriginalGameFileWithoutHeader = new ByteArray ();
         mOriginalGameFileWithoutHeader.endian = Endian.LITTLE_ENDIAN;
         swfFile.readBytes (mOriginalGameFileWithoutHeader);
         
         if (b0 == 0x43) // compressed
         {
             mOriginalGameFileWithoutHeader.uncompress ();
         }
         
         mOriginalGameFileWithoutHeader.position = 0;
      
         var numSizeBits:int = (mOriginalGameFileWithoutHeader.readUnsignedByte () & 0xFF) >> 3;
         var numSkips:int = ((numSizeBits * 4 + 5) + 7) / 8 - 1;
         mOriginalGameFileWithoutHeader.position += numSkips;
         
         mFrameRateX256 = mOriginalGameFileWithoutHeader.readUnsignedShort ();
         mFrameCount = mOriginalGameFileWithoutHeader.readUnsignedShort ();
         
         mOffset_Tags = mOriginalGameFileWithoutHeader.position;
         
         while (true)
         {
            var startOffset:int = mOriginalGameFileWithoutHeader.position;
            var tagTypeAndLength:int = mOriginalGameFileWithoutHeader.readUnsignedShort ();
            var tagType:int = tagTypeAndLength >> 6;
            if (tagType == 0) // end tag
               break;
            
            var tagLength:int = tagTypeAndLength & 0x3f;
            if (tagLength == 0x3f)
            {
               tagLength = mOriginalGameFileWithoutHeader.readInt ();
            }
            
            var endOffset:int = mOriginalGameFileWithoutHeader.position + tagLength;

            if (tagType == 87) // tag DefineBinaryAsset
            {
               mCharacterID_TagDefineBinaryAsset = mOriginalGameFileWithoutHeader.readUnsignedShort ();
               mReservedValue_TagDefineBinaryAsset = mOriginalGameFileWithoutHeader.readUnsignedInt ();
               mStartOffset_TagDefineBinaryAsset = startOffset;
               mEndOffset_TagDefineBinaryAsset = endOffset;
               
               mOriginalGameData = new ByteArray ();
               //mOriginalGameData.endian = Endian.LITTLE_ENDIAN; // bug
               mOriginalGameFileWithoutHeader.readBytes (mOriginalGameData, 0, tagLength - 2 - 4); // 2 for CharacterID, 4 for Reserved Value
            }
         
            mOriginalGameFileWithoutHeader.position = endOffset;
         }
         
         mOriginalGameFileWithoutHeader.position = 0;
      }

//=====================================================================================================
// 
//=====================================================================================================
   
   // create new swf file
      
      public function PackageNewFileData (params:Object):ByteArray
      {
         SetSeedGameFileData (params.mSwfSeedFile);
         
         // ...
         
         var author:String = params.mAuthor;
         var slotId:int = int (params.mSlotId);
         var worldPluginFilename:String = params.mWorldPluginFilename;
         var worldDataFormatVersion:int = params.mWorldDataFormatVersion;
         var levelFileData:ByteArray = params.mWorldBinaryData;
         var viewportWidth:int = params.mViewportWidth;
         var viewportHeight:int = params.mViewportHeight;
         var showPlayBar:Boolean = params.mShowPlayBar;
         var viewerWidth:int = params.mViewerWidth;
         var viewerHeight:int = params.mViewerHeight;
         
         // ...
         
         var newGameFileWithoutHeader:ByteArray = new ByteArray ();
         newGameFileWithoutHeader.endian = Endian.LITTLE_ENDIAN;
         
         var numSizeBits:int = 20;
         viewerWidth *= 20; // pixel -> ?
         viewerHeight *= 20; // pixel -> ?
         var numPendingBits:int = 0;
         numPendingBits = WriteBits (newGameFileWithoutHeader, numSizeBits,  5,           numPendingBits);
         numPendingBits = WriteBits (newGameFileWithoutHeader, 0,            numSizeBits, numPendingBits);
         numPendingBits = WriteBits (newGameFileWithoutHeader, viewerWidth,  numSizeBits, numPendingBits);
         numPendingBits = WriteBits (newGameFileWithoutHeader, 0,            numSizeBits, numPendingBits);
         numPendingBits = WriteBits (newGameFileWithoutHeader, viewerHeight, numSizeBits, numPendingBits);
         
         newGameFileWithoutHeader.writeShort (mFrameRateX256);
         newGameFileWithoutHeader.writeShort (mFrameCount);
         
         // create new game data

         var newGameData:ByteArray = new ByteArray ();
         //newGameData.endian = Endian.LITTLE_ENDIAN; // bug
         
         mOriginalGameData.position = 0;
         newGameData.writeShort (mOriginalGameData.readShort ()); // game data format version
         newGameData.writeByte (showPlayBar ? 1 : 0); mOriginalGameData.readByte ();
         newGameData.writeShort (mOriginalGameData.readShort ());  // playbar height
         newGameData.writeShort (viewportWidth); mOriginalGameData.readShort ();
         newGameData.writeShort (viewportHeight); mOriginalGameData.readShort ();
         
         newGameData.writeBytes (mOriginalGameData, mOriginalGameData.position, mOriginalGameData.length - mOriginalGameData.position - 2);
         
         newGameData.writeShort (1); // one design
         
         // append the level data
         
         newGameData.writeUTF (author == null ? "" : author);
         newGameData.writeInt (isNaN (slotId) ? 0 : slotId);
         newGameData.writeUTF (worldPluginFilename);
         newGameData.writeShort (worldDataFormatVersion);
         newGameData.writeInt (levelFileData.length);
         newGameData.writeBytes (levelFileData, 0, levelFileData.length);
         
         // ...
         
         if (mStartOffset_TagDefineBinaryAsset > mOffset_Tags)
            newGameFileWithoutHeader.writeBytes (mOriginalGameFileWithoutHeader, mOffset_Tags, mStartOffset_TagDefineBinaryAsset - mOffset_Tags);
         
         newGameFileWithoutHeader.writeShort ((87 << 6) | 0x3f);
         newGameFileWithoutHeader.writeInt (2 + 4 + newGameData.length); // 2 for CharacterID, 4 for Reserved Value
         newGameFileWithoutHeader.writeShort (mCharacterID_TagDefineBinaryAsset);
         newGameFileWithoutHeader.writeInt (mReservedValue_TagDefineBinaryAsset);
         newGameFileWithoutHeader.writeBytes (newGameData);
         
         if (mEndOffset_TagDefineBinaryAsset < mOriginalGameFileWithoutHeader.length)
            newGameFileWithoutHeader.writeBytes (mOriginalGameFileWithoutHeader, mEndOffset_TagDefineBinaryAsset);
         
         // ...
         
         var newFileLength:int = mOldFileLength + (newGameFileWithoutHeader.length - mOriginalGameFileWithoutHeader.length)
         //var newFileLength:int = newGameFileWithoutHeader.length + 8;
         newGameFileWithoutHeader.compress ();
         
         var newGameSwfFile:ByteArray = new ByteArray ();
         newGameSwfFile.endian = Endian.LITTLE_ENDIAN;
         
         newGameSwfFile.writeByte (0x43);
         newGameSwfFile.writeByte (0x57);
         newGameSwfFile.writeByte (0x53);
         newGameSwfFile.writeByte (mFileVersion);
         newGameSwfFile.writeUnsignedInt (newFileLength);
         newGameSwfFile.writeBytes (newGameFileWithoutHeader);
         newGameSwfFile.position = 0;
         
         
         return newGameSwfFile;
      }
      
      // return num pending bits
      // numValueBits: [1, 32]
      private static function WriteBits (data:ByteArray, value:uint, numValueBits:int, numPendingBits:int = 0):int
      {
			value &= (0xffffffff >>> (32 - numValueBits));
			var bitsConsumed:uint;
			if (numPendingBits > 0) {
				if (numPendingBits > numValueBits) {
					data[data.position - 1] |= value << (numPendingBits - numValueBits);
					bitsConsumed = numValueBits;
					numPendingBits -= numValueBits;
				} else if (numPendingBits == numValueBits) {
					data[data.position - 1] |= value;
					bitsConsumed = numValueBits;
					numPendingBits = 0;
				} else {
					data[data.position - 1] |= value >> (numValueBits - numPendingBits);
					bitsConsumed = numPendingBits;
					numPendingBits = 0;
				}
			} else {
				bitsConsumed = Math.min(8, numValueBits);
				numPendingBits = 8 - bitsConsumed;
				data.writeByte((value >> (numValueBits - bitsConsumed)) << numPendingBits);
			}
			numValueBits -= bitsConsumed;
			if (numValueBits > 0) {
				return WriteBits(data, value, numValueBits, numPendingBits);
			}
			
			return numPendingBits;
		}

   }
}
