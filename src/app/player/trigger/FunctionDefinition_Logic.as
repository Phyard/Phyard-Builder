package player.trigger
{
   import player.design.Global;
   
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
      
      public function FunctionDefinition_Logic(eventDecl:FunctionDeclaration)
      {
         super (eventDecl);
      }
      
      public function SetCodeSnippetDefine (codeSnippetDefine:CodeSnippetDefine):void
      {
         mLogicFunctionInstance = new FunctionInstance (this);
         mCodeSnippet = TriggerFormatHelper2.CreateCodeSnippet (mLogicFunctionInstance, Global.GetCurrentWorld (), codeSnippetDefine);
      }
      
      // as condition component, no inputs
      public function EvaluateCondition (returnValueTarget:ValueTarget):void
      {
         // no inputs
         //mLogicFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
         
         mCodeSnippet.Excute ();
         
         mLogicFunctionInstance.mReturnVariableSpace.SetValuesTo (returnValueTarget);
      }
      
      // as event handler, no returns
      public function ExcuteEventHandler (inputValueSources:ValueSource):void
      {
         mLogicFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
         
         mCodeSnippet.Excute ();
         
         // no returns
         //mLogicFunctionInstance.mReturnVariableSpace.SetValuesTo (returnValueTarget);
      }
      
      // as action, no inputs, returns
      public function ExcuteAction ():void
      {
         //mLogicFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
         
         mCodeSnippet.Excute ();
         
         // no returns
         //mLogicFunctionInstance.mReturnVariableSpace.SetValuesTo (returnValueTarget);
      }
   }
}