package common.trigger.define
{
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   public class ValueTargetDefine_Variable extends ValueTargetDefine
   {
      public var mSpaceType:int;
      public var mVariableIndex:int;
      
      public function ValueTargetDefine_Variable (spaceType:int, variableIndex:int)
      {
         super (ValueTargetTypeDefine.ValueTarget_Variable);
         
         mSpaceType = spaceType;
         mVariableIndex = variableIndex;
      }
      
      override public function Clone ():ValueTargetDefine
      {
         return new ValueTargetDefine_Variable (mSpaceType, mVariableIndex);
      }
   }
   
}