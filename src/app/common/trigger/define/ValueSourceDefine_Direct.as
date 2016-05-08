package common.trigger.define
{
   import common.trigger.ValueSourceTypeDefine;
   
   public class ValueSourceDefine_Direct extends ValueSourceDefine
   {
      //public var mValueType:int; //this value will not packaged. // edit: ValueSourceDefine_Direct was used in VariableDefine, ...
      public var mValueObject:Object;
      
      public function ValueSourceDefine_Direct (/*valueType:int, */valueObject:Object)
      {
         super (ValueSourceTypeDefine.ValueSource_Direct);
         
         //mValueType = valueType;
         mValueObject = valueObject;
      }
      
      override public function Clone ():ValueSourceDefine
      {
         return new ValueSourceDefine_Direct (/*mValueType, */mValueObject);
      }
   }
   
}