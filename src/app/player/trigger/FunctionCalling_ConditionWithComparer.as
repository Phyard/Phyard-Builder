package player.trigger
{
   import player.design.Global;
   
   import common.trigger.CoreFunctionIds;
   
   public class FunctionCalling_ConditionWithComparer extends FunctionCalling_Condition
   {
      public function FunctionCalling_ConditionWithComparer (lineNumber:int, functionDefinition:FunctionDefinition, valueSourceList:Parameter, valueTargetList:Parameter)
      {
         super (lineNumber, functionDefinition, valueSourceList, valueTargetList);
      }
      
      override public function Call ():void
      {
         //if (mBooleanReturnValueTarget == null)
         //   return;
         //
         //mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
         //if (mBooleanReturnValueTarget.mBoolValue)
         
         if ((mInputValueSourceList.EvaluateValueObject () as Boolean) == (mInputValueSourceList.mNextParameter.EvaluateValueObject () as Boolean))
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