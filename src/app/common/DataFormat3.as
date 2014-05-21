
package common {
   
   import flash.utils.ByteArray;
   
   public class DataFormat3
   {
      
//===============================================================================
   
      public static function CreateForumEmbedCode (fileVersionHexString:String, viewWidth:int, viewHeight:int, showPlayBar:Boolean, playcodeBase64:String):String
      {
         return "{@http://www.phyard.com/design?app=coin&fileversion=0x" + fileVersionHexString + "&viewsize=" + viewWidth + "x" + viewHeight + "&showplaybar=" + (showPlayBar ? "true" : "false") + "&compressformat=" + DataFormat3.CompressFormat_Base64 + "&playcode=" + playcodeBase64 + "@}";
      }
      
      public static function GetVersionHexString (version:int):String
      {
         var majorVersion:int = (version & 0xFF00) >> 8;
         var minorVersion:int = (version & 0xFF) >> 0;
         return (majorVersion < 16 ? "0" + majorVersion.toString (16) : majorVersion.toString (16)) + (minorVersion < 16 ? "0" + minorVersion.toString (16) : minorVersion.toString (16));
      }
      
      public static function GetVersionString (version:int):String
      {
         var majorVersion:int = (version & 0xFF00) >> 8;
         var minorVersion:int = (version & 0xFF) >> 0;
         return majorVersion.toString (16) + (minorVersion < 16 ? ".0" : ".") + minorVersion.toString (16);
      }
   
//==================================== hex string playcode (old, for compatibility) ======================================================
      
      public static function HexString2ByteArray (hexString:String):ByteArray
      {
         if (hexString == null)
            return null;
         
         hexString = De (hexString);
         
         var byteArray:ByteArray = new ByteArray ();
         byteArray.length = hexString.length / 2;
         
         var index:int = 0;
         
         for (var ci:int = 0; ci < hexString.length; ci += 2)
         {
            byteArray [index ++] = ParseByteFromHexString (hexString.substr (ci, 2)); // slow
         }
         
         return byteArray;
      }
      
      public static function ParseByteFromHexString (hexString:String):int
      {
         if (hexString == null || hexString.length != 2)
            return NaN;
         
         var byteValue:int = parseInt (hexString, 16);
         //if ( isNaN (byteValue))
         //{
         //   byteValue -= 128;
         //}
         
         return byteValue;
      }
      
      public static const Value2CharTable:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.";
      
      public static function Value2Char (value:int, num:uint = 1):String
      {
         if (value < 0 || value >= 16 || num > 4 || num <= 0)
            return "?";
         
         return Value2CharTable.charAt (value + (num - 1) * 16);
      }
      
      public static var Char2ValueTable:Array = null;
      
      public static function Char2Value (charCode:int):int
      {
         if (Char2ValueTable == null)
         {
            Char2ValueTable = new Array (128);
            for (var i:int = 0; i < Char2ValueTable.length; ++ i)
               Char2ValueTable [i] = -1;
            for (var k:int = 0; k < Value2CharTable.length; ++ k)
               Char2ValueTable [Value2CharTable.charCodeAt (k)] = k;
         }
         
         if (charCode < 0 || charCode >= Char2ValueTable.length)
            return -1;
         
         return Char2ValueTable [charCode];
      }
      
      public static function De (enStr:String):String
      {
         var str:String = "";
         
         var char:String;
         var value:int;
         var num:int;
         for (var i:int = 0; i < enStr.length; ++ i)
         {
            value = Char2Value (enStr.charCodeAt (i));
            
            if (value >= 0 && value < 64)
            {
               num = ( (value & 0x3F) >> 4 ) + 1;
               value = value & 0xF;
               
               char =  Value2Char (value);
               for (var k:int = 0; k < num; ++ k)
                  str = str + char;
            }
            else
            {
               trace ("De str error! pos = " + i + ", value = " + value + ", char = " +  enStr.charAt (i));
               break;
            }
         }
         
         return str;
      }

//==================================== ByteArray2HexString (not a counterpart of above HexString2ByteArray) ======================================================

      public static const HexChars:Array = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      public static function ByteArray2HexString (ba:ByteArray):String
      {
         if (ba == null)
            return "";
         
         var count:int = ba.length;
         
         var stream:ByteArray = new ByteArray ();
         stream.length = count + count;
         stream.position = 0;
         
         var index:int;
         for (var i:int = 0; i < count; ++ i)
         {
            stream [index ++] = (ba [i] & 0xF0) >> 4;
            stream [index ++] =  ba [i] & 0x0F;
         }
         
         stream.position = 0;
         return stream.readUTFBytes (stream.length);
      }
      
//==================================== readUTF/writeUTF ======================================================
      
      public static const Bit_IsNull:int = 1 << 7;
      public static const Shift_MoreBytes:int = 5;
      public static const Mask_NumMoreBytes:int = (1 << (Shift_MoreBytes + 1)) | (1 << Shift_MoreBytes);
      public static const Mask_LengthValueInFirstByte:int = (1 << Shift_MoreBytes) - 1;
      
      public static function WriteVaryLengthUTF (buffer:ByteArray, utfText:String):void
      {
         var stringBytes:ByteArray = null;
         
         if (utfText != null)
         {
            stringBytes = new ByteArray ();
            stringBytes.writeMultiByte (utfText, "utf-8");
            
            stringBytes.position = 0;
         }
         
         WriteVaryLengthData (buffer, stringBytes);
      }
      
      public static function WriteVaryLengthData (buffer:ByteArray, dataContent:ByteArray):void
      {
         if (dataContent == null)
         {
            buffer.writeByte (Bit_IsNull);
            return;
         }
         
         var length:int = dataContent.length;
         
         var b0:int = length & Mask_LengthValueInFirstByte;
         length >>= Mask_LengthValueInFirstByte;
         var b1:int = length & 0xFF;
         length >>= 8;
         var b2:int = length & 0xFF;
         length >>= 8;
         var b3:int = length & 0xFF;
         
         var numMoreBytes:int;
         if (b3 > 0) 
            numMoreBytes = 3;
         else if (b2 > 0)
            numMoreBytes = 2;
         else if (b1 > 0)
            numMoreBytes = 1;
         else
            numMoreBytes = 0;
         
         b0 |= (numMoreBytes << Shift_MoreBytes);
         buffer.writeByte (b0);
         if (numMoreBytes >= 1)
         {
            buffer.writeByte (b1);
            if (numMoreBytes >= 2)
            {
               buffer.writeByte (b2);
               if (numMoreBytes >= 3)
               {
                  buffer.writeByte (b3);
               }
            }
         }
         
//trace (">>> write, dataContent.length = " + dataContent.length + ", b0 = " + b0 + ", b1 = " + b1 + ", b2 = " + b2 + ", b3 = " + b3);
         
         buffer.writeBytes (dataContent, 0, dataContent.length);
      }
      
      public static function ReadVaryLengthUTF (buffer:ByteArray):String
      {
         if (buffer == null)
            return null;
         
         try
         {
            var dataContent:ByteArray = ReadVaryLengthData (buffer);
            dataContent.position = 0;
            return dataContent.readMultiByte (dataContent.length, "utf-8");
         }
         catch (error:Error)
         {
            trace (error.getStackTrace ());
         }
         
         return null;
      }
      
      public static function ReadVaryLengthData (buffer:ByteArray):ByteArray
      {
         var dataContent:ByteArray;
         
         try
         {
            var b0:int = buffer.readByte () & 0xFF;
            
            var isNull:Boolean = (b0 & Bit_IsNull) != 0;
            
            if (isNull)
               return null;
            
            var numMoreBytes:int = (b0 & Mask_NumMoreBytes) >> Shift_MoreBytes;
            var b1:int = 0xFF & (numMoreBytes >= 1 ? buffer.readByte () : 0);
            var b2:int = 0xFF & (numMoreBytes >= 2 ? buffer.readByte () : 0);
            var b3:int = 0xFF & (numMoreBytes >= 3 ? buffer.readByte () : 0);
            
            var length:int = (b0 & Mask_LengthValueInFirstByte) | (((((b3 << 8) | b2) << 8) | b1) << Shift_MoreBytes);
            
//trace ("<<<<<<< read length = " + length + ", b0 = " + b0 + ", b1 = " + b1 + ", b2 = " + b2 + ", b3 = " + b3);
            
            dataContent = new ByteArray ();
            buffer.readBytes (dataContent, 0, length);
         }
         catch (error:Error)
         {
            dataContent = null;
            trace (error.getStackTrace ());
         }
         
         return dataContent;
      }
      
//====================================  ======================================================
      
      public static function ByteArrayReadBytes (stream:ByteArray, count:int):ByteArray
      {
         var ba:ByteArray = new ByteArray (); 
         ba.length = count;
         stream.readBytes (ba, 0, count);
         
         return ba;
      }
      
      public static function CompareTwoByteArrays (ba1:ByteArray, ba2:ByteArray):Boolean
      {
         if (ba1 != ba2)
         {
            if (ba1 == null || ba2 == null)
               return false;
            var i:int = ba1.length;
            if (i != ba2.length)
               return false;
            
            while (-- i >= 0)
            {
               if (ba1 [i] != ba2 [i])
                  return false;
            }
         }
         
         return true;
      }
      
//==================================== base64 playcode ======================================================
      
      public static const Base64CharsRegExpStr:String = "0-9a-zA-Z=_,\\.\\+\\/";
      public static const Base64CharsRegExp:RegExp = new RegExp (Base64CharsRegExpStr, "g");
      
      public static const CompressFormat_Base64:String = "base64";
      
      //public static const Base64Chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="; // standard
        public static const Base64Chars_URL   :String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_,"; // standard url. Generally the last ',' is useless (mustBeAlign4 = false)
        public static const Base64Chars_Phyard:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,._"; // phyard special
        // here the chars (+/=) in standard base64 set has problems in url. So use another set instead.
        // it is possible use other 3 chars set for the last 3 chars with the current set simultaneously later.
      
      private static var Base64Char2Index_URL:Array = null;
      private static var Base64Char2Index_Phyard:Array = null;
      
      private static function GetBase64Char2IndexTable (isStandardUrlChars:Boolean):Array
      {
         var i_char:int;
         
         if (isStandardUrlChars)
         {
            if (Base64Char2Index_URL == null)
            {
               Base64Char2Index_URL = new Array (128); // all char codes in Base64Chars are smaller than 128
               
               for (i_char = Base64Chars_URL.length - 2; i_char >= 0; -- i_char) // "Base64Chars.length - 2" is to ignore the "=" cahr 
               {
                  Base64Char2Index_URL [Base64Chars_URL.charCodeAt (i_char)] = i_char;
               }
            }
            
            return Base64Char2Index_URL;
         }
         else
         {
            if (Base64Char2Index_Phyard == null)
            {
               Base64Char2Index_Phyard = new Array (128); // all char codes in Base64Chars are smaller than 128
               
               for (i_char = Base64Chars_Phyard.length - 2; i_char >= 0; -- i_char) // "Base64Chars.length - 2" is to ignore the "=" cahr 
               {
                  Base64Char2Index_Phyard [Base64Chars_Phyard.charCodeAt (i_char)] = i_char;
               }
            }
            
            return Base64Char2Index_Phyard;
         }
      }
      
      public static function DecodeString2ByteArray (text:String, isStandardUrlChars:Boolean = false):ByteArray
      {
         if (text == null) 
         {
            return null;
         }
         
         var num_chars:int = text.length;
         var num_triples:int = num_chars / 4;
         var num_triples_x_4:int = num_triples * 4;
         var num_extras:int = num_chars - num_triples_x_4;
         
         //if (num_extras != 0)
         //{
         //   return null;
         //}
         
         var num_triples_x_3:int = num_triples * 3;
         var num_bytes:int = num_triples_x_3;
         
         if (num_extras > 0)
         {
            num_bytes += (num_extras == 3 ? 2 : 1);
         }
         
         var data:ByteArray = new ByteArray ();
         data.length = num_bytes;
         
         var b0:int, b1:int, b2:int, b3:int;
         
         var table_char2index:Array = GetBase64Char2IndexTable (isStandardUrlChars);
         var i_char:int = 0;
         data.position = 0;
         
         //while (i_char < num_triples_x_3) // bug!
         while (i_char < num_triples_x_4)
         {
            b0 = table_char2index [text.charCodeAt (i_char ++)]; // char code may be larger than 127 or not a valid Base64 char. AS3 array return 0 for them.
            b1 = table_char2index [text.charCodeAt (i_char ++)];
            b2 = table_char2index [text.charCodeAt (i_char ++)];
            b3 = table_char2index [text.charCodeAt (i_char ++)];
            
            data.writeByte ((b0 << 2) | ((b1 & 0x30) >> 4));
            data.writeByte (((b1 & 0x0f) << 4) | ((b2 & 0x3c) >> 2));
            data.writeByte (((b2 & 0x03) << 6) | b3);
         }
         
         if (num_extras > 0)
         {
            b0 = table_char2index [text.charCodeAt (i_char ++)];
            
            if (num_extras == 1) // impossible
            {
               data.writeByte ((b0 << 2));
            }
            else // num_extras = 2,3
            {
               b1 = table_char2index [text.charCodeAt (i_char ++)];
               if (num_extras == 2)
               {
                  data.writeByte ((b0 << 2) | ((b1 & 0x30) >> 4));
               }
               else
               {
                  b2 = table_char2index [text.charCodeAt (i_char ++)];
                  
                  data.writeByte ((b0 << 2) | ((b1 & 0x30) >> 4));
                  data.writeByte (((b1 & 0x0f) << 4) | ((b2 & 0x3c) >> 2));
               }
            }
         }
         
         data.position = 0;
         return data;
      }
      
      public static function EncodeByteArray2String (data:ByteArray, useStandardUrlChars:Boolean = false, mustBeAlign4:Boolean = true):String
      {
         if (data == null) 
         {
            return null;
         }
         
         var num_triples:int = data.length / 3;
         var num_extras:int = data.length - num_triples * 3;
         
         var num_chars:int = num_triples * 4;
         if (num_extras > 0)
         {
            if (mustBeAlign4)
            {
               num_chars += 4;
            }
            else
            {
               num_chars += (num_extras == 1 ? 2 : 3);
            }
         }
         
         var char_indexes:ByteArray = new ByteArray ();
         char_indexes.length = num_chars;
         
         var b0:int, b1:int, b2:int;
         
         data.position = 0;
         char_indexes.length = 0;
         
         for (var i_triple:int = 0; i_triple < num_triples; ++ i_triple)
         {
            b0 = data.readByte () & 0xFF; // "& 0xFF" is essential for negative values
            b1 = data.readByte () & 0xFF;
            b2 = data.readByte () & 0xFF;
            
            char_indexes.writeByte ((b0 & 0xFC) >> 2);
            char_indexes.writeByte (((b0 & 0x03) << 4) | (b1 >> 4));
            char_indexes.writeByte (((b1 & 0x0F) << 2) | (b2 >> 6));
            char_indexes.writeByte (b2 & 0x3F);
         }
         
         if (num_extras > 0)
         {
            b0 = data.readByte () & 0xFF; // "& 0xFF" is essential for negative values
            
            if (num_extras == 1)
            {
               char_indexes.writeByte ((b0 & 0xFC) >> 2);
               char_indexes.writeByte ((b0 & 0x03) << 4);
               
               if (mustBeAlign4)
               {
                  char_indexes.writeByte (64); // "="
                  char_indexes.writeByte (64); // "="
               }
            }
            else // num_extras == 2
            {
               b1 = data.readByte () & 0xFF; // "& 0xFF" is essential for negative values
               
               char_indexes.writeByte ((b0 & 0xFC) >> 2);
               char_indexes.writeByte (((b0 & 0x03) << 4) | (b1 >> 4));
               char_indexes.writeByte ((b1 & 0x0F) << 2);
               
               if (mustBeAlign4)
               {
                  char_indexes.writeByte (64); // "="
               }
            }
         }
         
         var base64_chars:String = useStandardUrlChars ? Base64Chars_URL : Base64Chars_Phyard;
         
         var char_index:int;
         
         for (var i_char:int = 0; i_char < num_chars; ++ i_char)
         {
            char_index = char_indexes [i_char];
            char_indexes [i_char] = base64_chars.charCodeAt(char_index);
         }
         
         char_indexes.position = 0;
         return char_indexes.readUTFBytes (num_chars);
      }
      
   }
   
}
