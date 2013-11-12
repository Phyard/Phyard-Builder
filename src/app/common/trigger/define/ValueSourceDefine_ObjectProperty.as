package common.trigger.define
{
   import common.trigger.ValueSourceTypeDefine;
   
   public class ValueSourceDefine_ObjectProperty extends ValueSourceDefine_Variable
   {
      public var mPropertyIndex:int = -1; // since v2.05, for 
      
      public function ValueSourceDefine_ObjectProperty (spaceType:int, variableIndex:int, propertyIndex:int)
      {
         super (spaceType, variableIndex);
         SetValueSourceType (ValueSourceTypeDefine.ValueSource_ObjectProperty);
         
         mPropertyIndex = propertyIndex;
      }
      
      override public function Clone ():ValueSourceDefine
      {
         return new ValueSourceDefine_ObjectProperty (mSpaceType, mVariableIndex, mPropertyIndex);
      }
   }
   
}