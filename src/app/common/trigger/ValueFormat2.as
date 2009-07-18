
package common.trigger {
   
   import flash.utils.ByteArray;
   
   import common.ValueAdjuster;
   
   public class ValueFormat2
   {
      
      public static function ReadRawValueFromByteArray (valueType:int, byteArray:ByteArray):Object
      {
         switch (valueType)
         {
            case ValueDefine2.ValueType_String:
               return byteArray.readUTF ();
            case ValueDefine2.ValueType_Boolean:
               return byteArray.readByte () != 0;
            case ValueDefine2.ValueType_Numver:
               return byteArray.readFloat ();
            
            case ValueDefine2.ValueType_Entity:
               return byteArray.readShort ();
            default:
               trace ("ReadRawValueFromByteArray: Unknown type");
               return 0;
         }
      }
      
      public static function RawValue2String (valueType:int, value:Object):String
      {
         switch (valueType)
         {
            case ValueDefine2.ValueDefine.ValueType_String:
               return new String (value);
            case ValueDefine2.ValueDefine.ValueType_Boolean:
               return Boolean (value) ? "1" : "0";
            case ValueDefine2.ValueDefine.ValueType_Number:
               return String ( ValueAdjuster.Number2Precision (value, 6) );
            
            case ValueDefine2.ValueDefine.ValueType_Entity:
               return String ( int (value) );
            default:
               trace ("RawValue2String: Unknown type");
               return null;
         }
      }
      
      /*
      public static function ReadRawValuesFromXML (commandXML:XML):Array
      {
         var raw_values:Array = new Array (mParamDefines.length);
         var param_define:ParamDefine;
         var param_element:XML;
         
         var i:int = 0;
         for each (param_element in commandXML.Parameter)
         {
            //param_element.@name
            //param_element.@value
            
            param_define = mParamDefines [i];
            
            raw_values [i] = ValueDefine.String2RawValue (param_define.mValyeType, param_element.@value);
            ++ i;
         }
         
         return raw_values;
      }
      
      public static function WriteRawValuesToXML (rawValues:Array, commandXML:XML):void
      {
         var param_element:XML;
         
         var i:int;
         for (i = 0; i < rawValues.length; ++ i)
         {
            param_define = mParamDefines [i];
            
            param_element = <Parameter />;
            param_element.@name = param_define.mParamName;
            param_element.@value =  ValueDefine2.RawValue2String (param_define.mValyeType, rawValues [i]);
            
            commandXML.appendChild (param_element);
         }
      }
      
      public static function ReadRawValuesFromByteArray (byteArray:ByteArray):Array
      {
         var raw_values:Array = new Array (mParamDefines.length);
         var param_define:ParamDefine;
         
         for (var i:int = 0; i < mParamDefines.length; ++ i)
         {
            param_define = mParamDefines [i];
            
            raw_values [i] = ValueDefine2.ReadRawValueFromByteArray (param_define.mValyeType, byteArray);
         }
         
         return raw_values;
      }
      
      public static function WriteRawValuesToByteArray (rawValues:Array, byteArray:ByteArray):void
      {
         var param_define:ParamDefine;
         
         for (var i:int = 0; i < mParamDefines.length; ++ i)
         {
            param_define = mParamDefines [i];
            
            raw_values [i] = ValueDefine.WriteRawValueToByteArray (rawValues [i], param_define.mValyeType, byteArray);
         }
      }
      
      */
      
   }
}
