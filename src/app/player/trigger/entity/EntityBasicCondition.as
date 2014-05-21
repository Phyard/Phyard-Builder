package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   import player.trigger.Parameter_DirectMutable;
   import player.trigger.Parameter_Variable;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionDefine;
   import common.trigger.ValueDefine;
   import common.trigger.CoreClassIds;
   
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
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mFunctionDefine != undefined)
            {
               // ! clone is important
               var codeSnippetDefine:CodeSnippetDefine = ((entityDefine.mFunctionDefine as FunctionDefine).mCodeSnippetDefine as CodeSnippetDefine).Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
               
               mConditionDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (mWorld, entityDefine.mFunctionDefine, TriggerEngine.GetBoolFunctionDeclaration ());
               mConditionDefinition.SetCodeSnippetDefine (mWorld, codeSnippetDefine, extraInfos);
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
      
      private var mValueTarget:Parameter_DirectMutable = Parameter_DirectMutable.CreateCoreClassDirectMutable (
                                                            CoreClassIds.ValueType_Boolean,
                                                            false
                                                          ); 
                                                         //new Parameter_DirectMutable (null);
      
      public function RunBoolFunction ():Boolean
      {
         //var outputValueTarget:Parameter_Direct = TriggerEngine.ApplyNewDirectParameter (false, null);
         mValueTarget.mValueObject = false;
         
         // if (mConditionListDefinition != null) // should not be null
         mConditionDefinition.DoCall (mWorld.GetFunctionCallingContext (), null, mValueTarget); // outputValueTarget);
         
         //return TriggerEngine.ReleaseDirectParameter_Target (outputValueTarget) as Boolean;
         return Boolean (mValueTarget.EvaluateValueObject ());
      }
      
   }
}
