
package common {
   
   import flash.utils.ByteArray;
   
   public class DataFormat3
   {
   
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
   
//==================================== hex string playcode ======================================================
      
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
            byteArray [index ++] = ParseByteFromHexString (hexString.substr (ci, 2));
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
      
//==================================== base64 playcode ======================================================
      
      public static const CompressFormat_Base64:String = "base64";
      
      //public static const Base64Chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        public static const Base64Chars:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,._";
        // here the chars (+/=) in standard base64 set has problems in url. So use another set instead.
        // it is possible use other 3 chars set for the last 3 chars with the current set simultaneously later.
      
      private static var Base64Char2Index:Array = null;
      private static function GetBase64Char2IndexTable ():Array
      {
         if (Base64Char2Index == null)
         {
            Base64Char2Index = new Array (128); // all char codes in Base64Chars are smaller than 128
            
            for (var i_char:int = Base64Chars.length - 2; i_char >= 0; -- i_char) // "Base64Chars.length - 2" is to ignore the "=" cahr 
            {
               Base64Char2Index [Base64Chars.charCodeAt (i_char)] = i_char;
            }
         }
         
         return Base64Char2Index;
      }
      
      public static function DecodeString2ByteArray (text:String):ByteArray
      {
         if (text == null) 
         {
            return null;
         }
         
         var num_chars:int = text.length;
         var num_triples:int = num_chars / 4;
         var num_extras:int = num_chars - num_triples * 4;
         
         if (num_extras != 0)
         {
            return null;
         }
         
         ////var num_bytes:int = num_bytes * 3;
         //var num_bytes:int = num_triples * 3;
         var data:ByteArray = new ByteArray ();
         //data.length = num_bytes;
         
         var b0:int, b1:int, b2:int, b3:int;
         
         var table_char2index:Array = GetBase64Char2IndexTable ();
         var i_char:int = 0;
         data.position = 0;
         
         while (i_char < num_chars)
         {
            b0 = table_char2index [text.charCodeAt (i_char ++)];
            b1 = table_char2index [text.charCodeAt (i_char ++)];
            b2 = table_char2index [text.charCodeAt (i_char ++)];
            b3 = table_char2index [text.charCodeAt (i_char ++)];
            
            data.writeByte ((b0 << 2) | ((b1 & 0x30) >> 4));
            data.writeByte (((b1 & 0x0f) << 4) | ((b2 & 0x3c) >> 2));
            data.writeByte (((b2 & 0x03) << 6) | b3);
         }
         
         data.position = 0;
         return data;
      }
      
      public static function EncodeByteArray2String(data:ByteArray):String
      {
         if (data == null) 
         {
            return null;
         }
         
         var num_triples:int = data.length / 3;
         var num_extras:int = data.length - num_triples * 3;
         
         var num_chars:int = (num_extras > 0 ? num_triples + 1 : num_triples) * 4;
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
            
            if (num_extras == 2)
            {
               b1 = data.readByte () & 0xFF; // "& 0xFF" is essential for negative values
               
               char_indexes.writeByte ((b0 & 0xFC) >> 2);
               char_indexes.writeByte (((b0 & 0x03) << 4) | (b1 >> 4));
               char_indexes.writeByte ((b1 & 0x0F) << 2);
               char_indexes.writeByte (64); // "="
            }
            else // num_extras == 1
            {
               char_indexes.writeByte ((b0 & 0xFC) >> 2);
               char_indexes.writeByte ((b0 & 0x03) << 4);
               char_indexes.writeByte (64); // "="
               char_indexes.writeByte (64); // "="
            }
         }
         
         var char_index:int;
         
         for (var i_char:int = 0; i_char < num_chars; ++ i_char)
         {
            char_index = char_indexes [i_char];
            char_indexes [i_char] = DataFormat3.Base64Chars.charCodeAt(char_index);
         }
         
         char_indexes.position = 0;
         return char_indexes.readUTFBytes (num_chars);
      }
      
   }
   
}
