package common.trigger {
   
   import flash.utils.ByteArray;
   
   import common.ValueAdjuster;
   
   public class ValueFormat
   {
      
      public static function WriteRawValueToByteArray (value:Object, valueType:int, byteArray:ByteArray):void
      {
         switch (valueType)
         {
            case ValueDefine2.ValueType_String:
               return byteArray.writeUTF (String (value));
            case ValueDefine2.ValueType_Boolean:
               return byteArray.writeByte (Boolean (value) ? 1 : 0);
            case ValueDefine2.ValueType_Number:
               return byteArray.writeFloat ();
            
            case ValueDefine2.ValueType_Entity:
               return byteArray.writeShort ();
            default:
               trace ("WriteRawValueToByteArray: Unknown type");
         }
      }
      
      public static function String2RawValue (valueType:int, str:String):Object
      {
         switch (valueType)
         {
            case ValueDefine2.ValueDefine.ValueType_String:
               return new String (str);
            case ValueDefine2.ValueDefine.ValueType_Boolean:
               return parseInt (str) != 0;
            case ValueDefine2.ValueDefine.ValueType_Number:
               return ValueAdjuster.Number2Precision (parseFloat (str), 6);
            
            case ValueDefine2.ValueDefine.ValueType_Entity:
               return parseInt (str);
            default:
               trace ("String2RawValue: Unknown type");
               return null;
         }
      }
      
      
      
   }
}
