package player.trigger
{
   import common.trigger.ValueTypeDefine;
   import common.CoordinateSystem;
   
   public class CodeSnippet
   {
      protected var mFirstFunctionCalling:FunctionCalling = null;
      
      public function CodeSnippet (firstCalling:FunctionCalling)
      {
         mFirstFunctionCalling = firstCalling;
      }
      
   //public static var mEnableTrace:Boolean = false;
      
      public function Excute ():void
      {
         var calling:FunctionCalling = mFirstFunctionCalling;
         
   //if (mEnableTrace) trace ("-----------");
         while (calling != null)
         {
            calling.Call ();
   //if (mEnableTrace) trace (calling.GetLineNumber () + "> mNextFunctionCalling = " + calling.mNextFunctionCalling);
            calling = calling.mNextFunctionCalling;
         }
   //if (mEnableTrace)  trace ("#############" + new Error ().getStackTrace ());
      }
      
   }
}