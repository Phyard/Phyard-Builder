package player.trigger
{
   import player.design.Global;
   
   import common.trigger.CoreFunctionIds;
   
   public class FunctionCalling_Condition extends FunctionCalling
   {
      public var mNextFunctionCalling_True:FunctionCalling = null;
      public var mNextFunctionCalling_False:FunctionCalling = null;
      
      //protected var mBooleanReturnValueTarget:ValueTarget_BooleanReturn = new ValueTarget_BooleanReturn ();
      
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