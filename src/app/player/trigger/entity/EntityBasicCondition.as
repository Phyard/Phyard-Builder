package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   
   import common.trigger.define.ConditionListDefine;
   import common.trigger.ValueDefine;
   
   public class EntityBasicCondition extends EntityCondition
   {
      public var mConditionFunctionDefinition:FunctionDefinition_Logic;
      
      public function EntityBasicCondition (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
          mConditionFunctionDefinition = new FunctionDefinition_Logic (TriggerEngine.GetVoidFunctionDeclaration  ());
      }
      
      public function SetConditionListDefine (conditionListDefine:ConditionListDefine):void
      {
         if (mConditionFunctionDefinition != null) // should not be null
            mConditionFunctionDefinition.SetConditionListDefine (conditionListDefine);
      }
      
      override public function Evaluate ():void
      {
         // if (mConditionListDefinition != null) // should not be null
            mEvaluatedValue = mConditionFunctionDefinition.EvaluateCondition () ? ValueDefine.BoolValue_True : ValueDefine.BoolValue_False;
      }
      
   }
}