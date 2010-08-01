package player.trigger
{
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionDeclaration;
   import common.CoordinateSystem;
   
   public class FunctionCalling
   {
      internal var mNextFunctionCalling:FunctionCalling = null;
      
   // .........
      
      protected var mLineNumberInEditor:int;
      
      protected var mFunctionDefinition:FunctionDefinition;
      protected var mInputValueSourceList:ValueSource;
      protected var mReturnValueTargetList:ValueTarget;
      
      public function FunctionCalling (lineNumber:int, functionDefinition:FunctionDefinition, valueSourceList:ValueSource, valueTargetList:ValueTarget)
      {
         mLineNumberInEditor = lineNumber;
         mFunctionDefinition = functionDefinition;
         
         mInputValueSourceList = valueSourceList;
         mReturnValueTargetList = valueTargetList;
      }
      
      public function GetLineNumber ():int
      {
         return mLineNumberInEditor;
      }
      
      public function SetNextCalling (nextCalling:FunctionCalling):void
      {
         mNextFunctionCalling = nextCalling;
      }
      
      // todo: best to return next calling
      public function Call ():void
      {
         //trace ("FunctionCalling.Call");
         
         mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
      }
      
      // can optimize a bit
      //public function CallEventHandler ()
      
   }
}