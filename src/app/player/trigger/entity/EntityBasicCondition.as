package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   import player.trigger.VariableInstance;
   import player.trigger.Parameter_Variable;
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.ValueDefine;
   
   import common.TriggerFormatHelper2;
   
   public class EntityBasicCondition extends EntityCondition implements ScriptHolder
   {
      public var mConditionDefinition:FunctionDefinition_Custom;
      public var mName:String = null;
      
      public function EntityBasicCondition (world:World)
      {
         super (world);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mFunctionDefine != undefined)
            {
               mConditionDefinition = TriggerFormatHelper2.CreateFunctionDefinition (mWorld, entityDefine.mFunctionDefine, TriggerEngine.GetBoolFunctionDeclaration  ());
            }
         }
      }
            
//=============================================================
//   as condition
//=============================================================
      
      override public function Evaluate ():void
      {
         mEvaluatedValue = RunBoolFunction () ? ValueDefine.BoolValue_True : ValueDefine.BoolValue_False;
      }
      
//=============================================================
//   as ScriptHolder
//=============================================================
      
      public function RunScript ():void
      {
         Evaluate ();
      }
      
//=============================================================
//   as Bool Function
//=============================================================
      
      private var mBooleanReturnValueTarget:Parameter_Variable = new Parameter_Variable (new VariableInstance (false));
      
      public function RunBoolFunction ():Boolean
      {
         //mBooleanReturnValueTarget.AssignValueObject (false); // default value
         
         // if (mConditionListDefinition != null) // should not be null
         mConditionDefinition.EvaluateCondition (mBooleanReturnValueTarget);
         
         return mBooleanReturnValueTarget.EvaluateValueObject () as Boolean;
      }
      
   }
}
