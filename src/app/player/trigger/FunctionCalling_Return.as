package player.trigger
{
   import player.global.Global;
   
   import common.trigger.CoreFunctionIds;
   
   public class FunctionCalling_Return extends FunctionCalling
   {
      protected var mBooleanReturnValueTarget:ValueTarget_BooleanReturn = null;
      public var mNextFunctionCalling_Original:FunctionCalling = null;
      
      public function FunctionCalling_Return (functionDefinition:FunctionDefinition, valueSourceList:ValueSource, valueTargetList:ValueTarget, coreApiId:int)
      {
         super (functionDefinition, valueSourceList, valueTargetList);
         
         switch (coreApiId)
         {
            case CoreFunctionIds.ID_ReturnIfTrue:
            case CoreFunctionIds.ID_ReturnIfFalse:
               mBooleanReturnValueTarget = new ValueTarget_BooleanReturn ();
               mReturnValueTargetList = mBooleanReturnValueTarget;
               break;
            case CoreFunctionIds.ID_Return:
            defalut:
               mBooleanReturnValueTarget = null;
               mNextFunctionCalling = null;
               break;
         }
      }
      
      override public function SetNextCalling (nextCalling:FunctionCalling):void
      {
         mNextFunctionCalling_Original = nextCalling;
         
         if (mBooleanReturnValueTarget == null)
         {
            mNextFunctionCalling = null;
         }
      }
      
      override public function Call ():void
      {
         if (mBooleanReturnValueTarget == null)
            return;
         
         mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
         
         if (mBooleanReturnValueTarget.mBoolValue)
         {
            mNextFunctionCalling = null;
         }
         else
         {
            mNextFunctionCalling = mNextFunctionCalling_Original;
         }
      }
   }
}