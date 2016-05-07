package player.trigger
{
   import common.CoordinateSystem;
   
   public class CodeSnippet
   {
      protected var mFirstFunctionCalling:FunctionCalling = null;
      
      public function CodeSnippet (firstCalling:FunctionCalling)
      {
         mFirstFunctionCalling = firstCalling;
      }
      
   //public static var mEnableTrace:Boolean = true;
      
      public function Excute (callingContext:FunctionCallingContext):void
      {
         var calling:FunctionCalling = mFirstFunctionCalling;
         
   //if (mEnableTrace) trace ("-----------");
         while (calling != null)
         {
            calling.Call (callingContext);
   //if (mEnableTrace) trace (calling.GetLineNumber () + "> mNextFunctionCalling = " + calling.mNextFunctionCalling);
            calling = calling.mNextFunctionCalling;
         }
   //if (mEnableTrace)  trace ("#############" + new Error ().getStackTrace ());
      }
      
      public function Clone ():CodeSnippet
      {
         return null;
      }
      
      public function SetParentFunctionInstance (parentFunctionInstance:FunctionInstance):void
      {
         // replace current input/output/local/memeber variable sources
      }
   }
}