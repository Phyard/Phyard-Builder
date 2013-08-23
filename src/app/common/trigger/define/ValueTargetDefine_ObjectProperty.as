package common.trigger.define
{
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTargetDefine_ObjectProperty extends ValueTargetDefine_Variable
   {
      public var mPropertyIndex:int;
      
      public function ValueTargetDefine_ObjectProperty (spaceType:int, variableIndex:int, propertyIndex:int)
      {
         super (spaceType, variableIndex);
         SetValueTargetType (ValueTargetTypeDefine.ValueTarget_ObjectProperty);
         
         mPropertyIndex = propertyIndex;
      }
      
      override public function Clone ():ValueTargetDefine
      {
         return new ValueTargetDefine_ObjectProperty (mSpaceType, mVariableIndex, mPropertyIndex);
      }
   }
   
}