package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   // instance of custom functions
   public class FunctionInstance
   {
      internal var mPrevFunctionInstance:FunctionInstance = null;
      internal var mNextFunctionInstance:FunctionInstance = null;
      
      //
      protected var mCustomFunctionDefinition:FunctionDefinition_Custom;
      
      // to reduce the number of function callings, set the 3 variables public
      internal var mInputVariableSpace:VariableSpace;
      internal var mOutputVariableSpace:VariableSpace;
      internal var mLocalVariableSpace:VariableSpace;
      
      public function FunctionInstance (customFunctionDefiniton:FunctionDefinition_Custom)
      {
         mCustomFunctionDefinition = customFunctionDefiniton;
         
         var func_declaration:FunctionDeclaration = mCustomFunctionDefinition.GetFunctionDeclaration ();
         
         mInputVariableSpace = new VariableSpace (func_declaration.GetNumInputs ());
         mOutputVariableSpace = new VariableSpace (func_declaration.GetNumOutputs ());
         mLocalVariableSpace = new VariableSpace (func_declaration.GetNumLocalVariables ());
      }
      
      public function SetAsCurrent ():void
      {
         mInputVariableSpace.FillVariableReferenceList (mCustomFunctionDefinition.mInputVariableRefList);
         mOutputVariableSpace.FillVariableReferenceList (mCustomFunctionDefinition.mOutputVariableRefList);
         mLocalVariableSpace.FillVariableReferenceList (mCustomFunctionDefinition.mLocalVariableRefList);
      }
      
      //public function GetInputVariableAt (index:int):VariableInstance
      //{
      //   if (mInputVariableSpace == null)
      //      return null;
      //   
      //   return mInputVariableSpace.GetVariableAt (index);
      //}
      //
      //public function GetReturnVariableAt (index:int):VariableInstance
      //{
      //   if (mReturnVariableSpace == null)
      //      return null;
      //   
      //   return mReturnVariableSpace.GetVariableAt (index);
      //}
      
      public function GetLocalVariableAt (index:int):VariableInstance
      {
         if (mLocalVariableSpace == null)
            return null;
         
         return mLocalVariableSpace.GetVariableAt (index);
      }
   }
}