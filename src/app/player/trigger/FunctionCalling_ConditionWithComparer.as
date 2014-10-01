package player.trigger
{
   import common.trigger.CoreFunctionIds;
   
   public class FunctionCalling_ConditionWithComparer extends FunctionCalling_Condition
   {
      public function FunctionCalling_ConditionWithComparer (lineNumber:int, functionDefinition:FunctionDefinition, valueSourceList:Parameter, valueTargetList:Parameter)
      {
         super (lineNumber, functionDefinition, valueSourceList, valueTargetList);
      }
      
      override public function Call (callingContext:FunctionCallingContext):void
      {
         //if (mBooleanReturnValueTarget == null)
         //   return;
         //
         //mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
         //if (mBooleanReturnValueTarget.mBoolValue)
         
         // before v2.05
         //if ((mInputValueSourceList.EvaluateValueObject () as Boolean) == (mInputValueSourceList.mNextParameter.EvaluateValueObject () as Boolean))
         // since v2.05
         if (CoreClassesHub.CompareEquals (mInputValueSourceList.GetVariableInstance (), mInputValueSourceList.mNextParameter.GetVariableInstance ()))
         {
            mNextFunctionCalling = mNextFunctionCalling_True;
         }
         else
         {
            mNextFunctionCalling = mNextFunctionCalling_False;
         }
      }
   }
}