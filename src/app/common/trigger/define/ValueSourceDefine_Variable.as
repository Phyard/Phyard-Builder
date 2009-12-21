package common.trigger.define
{
   import flash.utils.ByteArray;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   public class ValueSourceDefine_Variable extends ValueSourceDefine
   {
      public var mSpaceType:int;
      public var mVariableIndex:int;
      
      public function ValueSourceDefine_Variable (spaceType:int, variableIndex:int)
      {
         super (ValueSourceTypeDefine.ValueSource_Variable);
         
         mSpaceType = spaceType;
         mVariableIndex = variableIndex;
      }
      
      override public function Clone ():ValueSourceDefine
      {
         return new ValueSourceDefine_Variable (mSpaceType, mSpaceType);
      }
   }
   
}