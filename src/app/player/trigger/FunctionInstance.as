package player.trigger
{
   
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
      
      public function FunctionInstance (customFunctionDefiniton:FunctionDefinition_Custom, isPrimary:Boolean)
      {
         mCustomFunctionDefinition = customFunctionDefiniton;
         
         // before v2.05
         //mInputVariableSpace = new VariableSpace (mCustomFunctionDefinition.GetNumInputParameters ());
         //mOutputVariableSpace = new VariableSpace (mCustomFunctionDefinition.GetNumOutputParameters ());
         //mLocalVariableSpace = new VariableSpace (mCustomFunctionDefinition.GetNumLocalVariables ());
         
         //since v2.05
         if (isPrimary)
         {
            mInputVariableSpace = mCustomFunctionDefinition.GetInputVariableSpace ();
            mOutputVariableSpace = mCustomFunctionDefinition.GetOutputVariableSpace ();
            mLocalVariableSpace = mCustomFunctionDefinition.GetLocalVariableSpace ();
         }
         else
         {
            mInputVariableSpace = mCustomFunctionDefinition.GetInputVariableSpace ().CloneSpace ();
            mOutputVariableSpace = mCustomFunctionDefinition.GetOutputVariableSpace ().CloneSpace ();
            mLocalVariableSpace = mCustomFunctionDefinition.GetLocalVariableSpace ().CloneSpace ();
         }
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
      //   return mInputVariableSpace.GetVariableByIndex (index);
      //}
      //
      //public function GetReturnVariableAt (index:int):VariableInstance
      //{
      //   if (mReturnVariableSpace == null)
      //      return null;
      //   
      //   return mReturnVariableSpace.GetVariableByIndex (index);
      //}
      
      //public function GetLocalVariableAt (index:int):VariableInstance
      //{
      //   if (mLocalVariableSpace == null)
      //      return null;
      //   
      //   return mLocalVariableSpace.GetVariableByIndex (index);
      //}
   }
}