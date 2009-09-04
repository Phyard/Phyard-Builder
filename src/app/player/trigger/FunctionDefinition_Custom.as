package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   import common.trigger.ValueTypeDefine;
   
   public class FunctionDefinition_Custom extends FunctionDefinition
   {
      //
      protected var mLocalVariableDefines:Array;
      
      public function FunctionDefinition_Custom (functionDecl:FunctionDeclaration, localVariableDefines:Array = null)
      {
         super (functionDecl);
         
         mLocalVariableDefines = localVariableDefines;
         
         BuildNewFunctionInstance (mLocalVariableDefines);
      }
      
      override public function DoCall (inputValueSources:ValueSoure, returnValueTarget:ValueTarget):void
      {
         if (mFreeFunctionInstance == null)
            BuildNewFunctionInstance ();
         
         
         var funcc_instance:FunctionInstance = mFreeFunctionInstance;
         mFreeFunctionInstance = mFreeFunctionInstance.mNextFreeFunctionInstance;
         
         funcc_instance.mInputVariableSpace.GetValuesFrom (mInputValueSourceList);
         
         // call ...
         
         funcc_instance.mReturnValueTargetList.SetValuesTo (mReturnValueTargetList);
         
         funcc_instance.mNextFreeFunctionInstance = mFreeFunctionInstance;
         mFreeFunctionInstance = funcc_instance;
      }
      
      protected function BuildNewFunctionInstance (localVariableDefines:Array):void
      {
         var fi:FunctionInstance = new FunctionInstance (this, localVariableDefines);
         
         fi.mNextFreeFunctionInstance = mFreeFunctionInstance;
         mFreeFunctionInstance = fi;
      }
      
   }
}