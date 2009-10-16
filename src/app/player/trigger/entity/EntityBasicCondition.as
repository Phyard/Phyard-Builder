package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.ValueDefine;
   
   public class EntityBasicCondition extends EntityCondition
   {
      public var mConditionDefinition:FunctionDefinition_Logic;
      
      public function EntityBasicCondition (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
          mConditionDefinition = new FunctionDefinition_Logic (TriggerEngine.GetVoidFunctionDeclaration  ());
      }
      
      public function SetCommandListDefine (codeSnippetDefine:CodeSnippetDefine):void
      {
         if (mConditionDefinition != null) // should not be null
            mConditionDefinition.SetCodeSnippetDefine (codeSnippetDefine);
      }
      
      override public function Evaluate ():void
      {
         // if (mConditionListDefinition != null) // should not be null
            mEvaluatedValue = mConditionDefinition.EvaluateCondition () ? ValueDefine.BoolValue_True : ValueDefine.BoolValue_False;
      }
      
   }
}