package player.trigger
{
   public class FunctionCalling
   {
      public var mNextFunctionCalling:FunctionCalling = null;
      
      public var mIsConditionCalling:Boolean = true; // special for condition list definition, useless for command callings
      public var mTargetBoolValue:Boolean = false; // special for condition list definition, useless for command callings
      
   // .........
      
      protected var mFunctionDefinition:FunctionDefinition;
      protected var mInputValueSourceList:ValueSource;
      protected var mReturnValueTargetList:ValueTarget;
      
      public function FunctionCalling (functionDefinition:FunctionDefinition, valueSourceList:ValueSource, valueTargetList:ValueTarget)
      {
         mFunctionDefinition = functionDefinition;
         
         mInputValueSourceList = valueSourceList;
         mReturnValueTargetList = valueTargetList;
      }
      
      public function Call ():void
      {
         mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
      }
      
      // can optimize a bit
      //public function CallEventHandler ()
   }
}