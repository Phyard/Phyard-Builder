package player.trigger
{
   import player.global.Global;
   
   import common.trigger.define.CodeSnippetDefine;
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
      protected var mCodeSnippet:CodeSnippet;
      
      protected var mLogicFunctionInstance:FunctionInstance = null;
      
      public function FunctionDefinition_Logic(eventDecl:FunctionDeclaration, localVariableDefines:Array = null)
      {
         super (eventDecl);
         
         BuildNewFunctionInstance (localVariableDefines);
      }
      
      public function SetCodeSnippetDefine (codeSnippetDefine:CodeSnippetDefine):void
      {
         mCodeSnippet = TriggerFormatHelper2.CreateCodeSnippet (mLogicFunctionInstance, Global.GetCurrentWorld (), codeSnippetDefine);
      }
      
      // as normal function, this function will not be called
      override public function DoCall (inputValueSources:ValueSource, returnValueTarget:ValueTarget):void
      {
         mLogicFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
         
         mCodeSnippet.Excute ();
         
         // no return
         mLogicFunctionInstance.mReturnVariableSpace.SetValuesTo (returnValueTarget);
      }
      
      // as condition component, no inputs, no returns, the evaluation result must be put in mRegisterBooleanVariableSpace_0
      public function EvaluateCondition ():Boolean
      {
         // no inputs
         //mLogicFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
         
         Global.mBooleanRegister_0.mValueObject = false;
         
         mCodeSnippet.Excute ();
         
         return Global.mBooleanRegister_0.mValueObject;
         
         // no returns
         //mLogicFunctionInstance.mReturnVariableSpace.SetValuesTo (returnValueTarget);
      }
      
      // as event handler, no returns
      public function ExcuteEventHandler (inputValueSources:ValueSource):void
      {
         mLogicFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
         
         mCodeSnippet.Excute ();
         
         // no returns
         //mLogicFunctionInstance.mReturnVariableSpace.SetValuesTo (returnValueTarget);
      }
      
      protected function BuildNewFunctionInstance (localVariableDefines:Array):void
      {
         var fi:FunctionInstance = new FunctionInstance (this, localVariableDefines);
         
         mLogicFunctionInstance = fi;
      }
      
   }
}