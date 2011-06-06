package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   import player.trigger.VariableInstance;
   import player.trigger.Parameter_Direct;
   import player.trigger.Parameter_Variable;
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionDefine;
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
               var codeSnippetDefine:CodeSnippetDefine = ((entityDefine.mFunctionDefine as FunctionDefine).mCodeSnippetDefine as CodeSnippetDefine).Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
               
               mConditionDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (entityDefine.mFunctionDefine, TriggerEngine.GetBoolFunctionDeclaration ());
               mConditionDefinition.SetCodeSnippetDefine (codeSnippetDefine);
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
         RunBoolFunction ();
      }
      
//=============================================================
//   as Bool Function
//=============================================================
      
      // todo, seems it is ok to use parameters like that in contact event handling.
      // currently, ApplyNewDirectParameter and ReleaseDirectParameter are some not very efficient.
      
      public function RunBoolFunction ():Boolean
      {
         var outputValueTarget:Parameter_Direct = TriggerEngine.ApplyNewDirectParameter (false, null);
         
         // if (mConditionListDefinition != null) // should not be null
         mConditionDefinition.DoCall (null, outputValueTarget);
         
         return TriggerEngine.ReleaseDirectParameter_Target (outputValueTarget) as Boolean;
      }
      
   }
}
