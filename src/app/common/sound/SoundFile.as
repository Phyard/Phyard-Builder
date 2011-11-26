package common.sound
{
   import flash.utils.ByteArray;

   public class SoundFile
   {
      public static const Flag_SoundIsStereo     :int = 1 << 31;
      public static const Mask_SoundRate         :int = 0x7FFFF000;
      public static const Shift_SoundRate        :int = 12;
      public static const Mask_SoundSampleSize   :int = 0x00000FC0;
      public static const Shift_SoundSampleSize  :int = 6;
      public static const Mask_SoundFileFormat   :int = 0x0000003F;
      public static const Shift_SoundFileFormat  :int = 0;
      
      public static const SoundFileFormat_Unknown:int = 0;
      public static const SoundFileFormat_MP3:int = 2; // jsut use flash convention
      
      public static const SoundFileFormatString_MP3:String = "mp3";
      
      //...
      
      private var mAttributeBits:int;
      private var mNumSamples:int;
      private var mFileData:ByteArray;
      
      //...
      
      public function SoundFile ()
      {
      }
      
      public function toString ():String
      {
         return "file type: " + GetFileFormat () + ", is stereo: " + IsStereo () + ", sample size: " + GetSampleSize () + ", sampling rate: " + GetSamplingRate () + ", number of samples: " + GetNumSamples () + ", data length: " + (mFileData == null ? 0 : mFileData.length);
      }
      
      private function SetInvalid ():void
      {
         SetFileData (null);
      }
      
      public function GetFileData ():ByteArray
      {
         return mFileData;
      }
      
      public function SetFileData (data:ByteArray):void
      {
         mFileData = data;
         
         if (mFileData == null)
         {
            SetStereo (false);
            SetSamplingRate (0);
            SetSampleSize (0);
            SetFileFormat (null);
            SetNumSamples (0);
         }
      }
      
      public function GetNumSamples ():int
      {
         return mNumSamples;
      }
      
      public function SetNumSamples (numSamples:int):void
      {
         mNumSamples = numSamples;
      }

      public function GetAttributeBits ():int
      {
         return mAttributeBits;
      }
      
      public function SetAttributeBits (bits:int):void
      {
         mAttributeBits = bits;
      }

      public function IsStereo ():Boolean
      {
         return (mAttributeBits & Flag_SoundIsStereo) != 0;
      }

      public function SetStereo (stereo:Boolean):void
      {
         if (stereo)
            mAttributeBits |= Flag_SoundIsStereo;
         else
            mAttributeBits &= ~Flag_SoundIsStereo;
      }
      
      public function GetSamplingRate ():int
      {
         return (mAttributeBits & Mask_SoundRate) >>> Shift_SoundRate;
      }

      public function SetSamplingRate (rate:int):void
      {
         mAttributeBits = (mAttributeBits & (~Mask_SoundRate)) | ((rate << Shift_SoundRate) & Mask_SoundRate);
      }
      
      public function GetSampleSize ():int
      {
         return (mAttributeBits & Mask_SoundSampleSize) >>> Shift_SoundSampleSize;
      }

      public function SetSampleSize (sampleSize:int):void
      {
         mAttributeBits = (mAttributeBits & (~Mask_SoundSampleSize)) | ((sampleSize << Shift_SoundSampleSize) & Mask_SoundSampleSize);
      }
      
      public function GetFileFormat ():String
      {
         var format:int = (mAttributeBits & Mask_SoundFileFormat) >>> Shift_SoundFileFormat;
         
         if (format == SoundFileFormat_MP3)
            return SoundFileFormatString_MP3;
         else
            return null;
      }

      public function SetFileFormat (formatStr:String):void
      {
         var format:int = SoundFileFormat_Unknown;
         if (formatStr != null)
         {
            formatStr = formatStr.toLowerCase ();
            if (formatStr === SoundFileFormatString_MP3) // == is also ok
               format = SoundFileFormat_MP3;
         }
            
         mAttributeBits = (mAttributeBits & (~Mask_SoundFileFormat)) | ((format << Shift_SoundFileFormat) & Mask_SoundFileFormat);
      }
   }
}
