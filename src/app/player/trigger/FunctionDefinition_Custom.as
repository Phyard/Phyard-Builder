package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   import common.trigger.ValueTypeDefine;
   
   public class FunctionDefinition_Custom extends FunctionDefinition
   {
      protected var mPrimaryFunctionInstance:FunctionInstance;
      protected var mPrimaryCodeSnippet:CodeSnippet;
      
      protected var mFreeFunctionInstance:FunctionInstance = null;
      protected var mGeneralCodeSnippet:CodeSnippet;
      
      public function FunctionDefinition_Custom (functionDecl:FunctionDeclaration)
      {
         super (functionDecl);
         
         mPrimaryFunctionInstance = new FunctionInstance (this);
      }
      
      public function SetCodeSnippetDefine (codeSnippetDefine:CodeSnippetDefine):void
      {
         mLogicFunctionInstance = new FunctionInstance (this);
         mPrimaryCodeSnippet = TriggerFormatHelper2.CreateCodeSnippet (mLogicFunctionInstance, Global.GetCurrentWorld (), codeSnippetDefine);
      }
      
      override public function DoCall (inputValueSources:ValueSoure, returnValueTarget:ValueTarget):void
      {
      /*
         if (mPrimaryFunctionInstance.mIsFree)
         {
            mPrimaryFunctionInstance.mIsFree = false;
            
            mPrimaryFunctionInstance.mInputVariableSpace.GetValuesFrom (inputValueSources);
            mPrimaryCodeSnippet.Excute ();
            mPrimaryFunctionInstance.mReturnValueTargetList.SetValuesTo (returnValueTarget);
            
            mPrimaryFunctionInstance.mIsFree = true;
         }
         else
         {
            var func_instance:FunctionInstance = mFreeFunctionInstance;
            if (func_instance == null)
               func_instance = new FunctionInstance (this);
            else
               mFreeFunctionInstance = mFreeFunctionInstance.mNextFreeFunctionInstance;
            
            func_instance.mInputVariableSpace.GetValuesFrom (inputValueSources);
            mGeneralCodeSnippet.ExcuteGeneral (func_instance);
            func_instance.mReturnValueTargetList.SetValuesTo (returnValueTarget);
            
            func_instance.mNextFreeFunctionInstance = mFreeFunctionInstance;
            mFreeFunctionInstance = func_instance;
         }
      */
      }
      
   }
}