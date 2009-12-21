package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   import player.trigger.ValueTarget_BooleanReturn;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.ValueDefine;
   
   public class EntityBasicCondition extends EntityCondition
   {
      public var mConditionDefinition:FunctionDefinition_Logic;
      public var mName:String = null;
      
      protected var mBooleanReturnValueTarget:ValueTarget_BooleanReturn = null;
      
      public function EntityBasicCondition (world:World)
      {
         super (world);
         
         mConditionDefinition = new FunctionDefinition_Logic (TriggerEngine.GetBoolFunctionDeclaration  ());
         mBooleanReturnValueTarget = new ValueTarget_BooleanReturn ();
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mName != undefined)
               mName = entityDefine.mName;
            
            if (entityDefine.mCodeSnippetDefine != undefined)
            {
               var codeSnippetDefine:CodeSnippetDefine = entityDefine.mCodeSnippetDefine.Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
               mConditionDefinition.SetCodeSnippetDefine (codeSnippetDefine);
            }
         }
      }
            
//=============================================================
//   as condition
//=============================================================
      
      override public function Evaluate ():void
      {
         // if (mConditionListDefinition != null) // should not be null
         mConditionDefinition.EvaluateCondition (mBooleanReturnValueTarget);
         
         mEvaluatedValue = mBooleanReturnValueTarget.mBoolValue ? ValueDefine.BoolValue_True : ValueDefine.BoolValue_False;
      }
      
   }
}
