package player.trigger
{
   public class FunctionCalling
   {
      public var mNextFunctionCalling:FunctionCalling = null;
      
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
         //trace ("FunctionCalling.Call");
         
         mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
      }
      
      // can optimize a bit
      //public function CallEventHandler ()
   }
}