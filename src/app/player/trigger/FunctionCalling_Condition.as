package player.trigger
{
   import player.design.Global;
   
   import common.trigger.CoreFunctionIds;
   
   public class FunctionCalling_Condition extends FunctionCalling
   {
      public var mNextFunctionCalling_True:FunctionCalling = null;
      public var mNextFunctionCalling_False:FunctionCalling = null;
      
      // todo: unlike the super.mFunctionDefinition, this.mFunctionDefinition is used to evaluate the condition result.
      //       this.mFunctionDefinition is an inline function, which has no input parameters and has one output parameter
      
      public function FunctionCalling_Condition (lineNumber:int, functionDefinition:FunctionDefinition, valueSourceList:ValueSource, valueTargetList:ValueTarget)
      {
         super (lineNumber, functionDefinition, valueSourceList, valueTargetList);
      }
      
      public function SetNextCallingForTrue (nextCalling:FunctionCalling):void
      {
         mNextFunctionCalling_True = nextCalling;
      }
      
      public function GetNextCallingForFalse ():FunctionCalling
      {
         return mNextFunctionCalling_False;
      }
      
      public function GetNextCallingForTrue ():FunctionCalling
      {
         return mNextFunctionCalling_True;
      }
      
      public function SetNextCallingForFalse (nextCalling:FunctionCalling):void
      {
         mNextFunctionCalling_False = nextCalling;
      }
      
      override public function Call ():void
      {
         //if (mBooleanReturnValueTarget == null)
         //   return;
         //
         //mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
         //if (mBooleanReturnValueTarget.mBoolValue)
         
         if (mInputValueSourceList.EvalateValueObject () as Boolean)
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