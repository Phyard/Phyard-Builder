package player.trigger
{
   import player.global.Global;
   
   import common.trigger.define.ConditionListDefine;
   import common.trigger.define.CommandListDefine;
   import common.trigger.FunctionDeclaration;
   import common.trigger.ValueTypeDefine;
   import common.TriggerFormatHelper2;
   
   // here, we treat the logic components (event handler, action, condition) not as common function, to optimize.
   // To make this optimizeation legal, some conditions must be satisfied:
   // - event handlers can only called by the game. Any other functions callings can't call event handler
   //   (event handlers must be the first functions to be called)
   // - no local variables can't be used in logic componenents..
   
   public class FunctionDefinition_Logic extends FunctionDefinition
   {
      protected var mConditionListDefinition:ConditionListDefinition;
      protected var mCommandListDefinition:CommandListDefinition;
      
      protected var mLogicFunctionInstance:FunctionInstance = null;
      
      public function FunctionDefinition_Logic(eventDecl:FunctionDeclaration, localVariableDefines:Array = null)
      {
         super (eventDecl);
         
         BuildNewFunctionInstance (localVariableDefines);
      }
      
      public function SetConditionListDefine (conditionListDefine:ConditionListDefine):void
      {
         mConditionListDefinition = TriggerFormatHelper2.ConditionListDefine2Definition (mLogicFunctionInstance, Global.GetCurrentWorld (), conditionListDefine);
      }
      
      public function SetCommandListDefine (commandListDefine:CommandListDefine):void
      {
         mCommandListDefinition = TriggerFormatHelper2.CommandListDefine2Definition (mLogicFunctionInstance, Global.GetCurrentWorld (), commandListDefine);
      }
      
      // as condition
      public function EvaluateCondition ():Boolean
      {
         //if (mConditionListDefinition == null)
         //   return false;
         
         return mConditionListDefinition.Evaluate ();
      }
      
      // as action
      public function ExcuteAction ():void
      {
         //if (mCommandListDefinition == null)
         //   return;
         
         mCommandListDefinition.Excute ();
      }
      
      // as event handler
      override public function DoCall (inputValueSources:ValueSource, returnValueTarget:ValueTarget):void
      {
         mLogicFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
         
         if (mConditionListDefinition.Evaluate ())
            mCommandListDefinition.Excute ();
         
         //mLogicFunctionInstance.mReturnValueTargetList.SetValuesTo (...);
      }
      
      protected function BuildNewFunctionInstance (localVariableDefines:Array):void
      {
         var fi:FunctionInstance = new FunctionInstance (this, localVariableDefines);
         
         mLogicFunctionInstance = fi;
      }
      
   }
}