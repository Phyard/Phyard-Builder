package common.trigger.define
{
   import flash.utils.ByteArray;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   public class ValueSourceDefine_Direct extends ValueSourceDefine
   {
      public var mValueType:int; //this value will not packaged
      public var mValueObject:Object;
      
      public function ValueSourceDefine_Direct (valueType:int, valueObject:Object)
      {
         super (ValueSourceTypeDefine.ValueSource_Direct);
         
         mValueType = valueType;
         mValueObject = valueObject;
      }
      
   }
   
}