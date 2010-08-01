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
      
      public function Excute ():void
      {
         var calling:FunctionCalling = mFirstFunctionCalling;
         
      trace ("-----------");
         while (calling != null)
         {
            calling.Call ();
         trace (calling.GetLineNumber () + "> mNextFunctionCalling = " + calling.mNextFunctionCalling);
            calling = calling.mNextFunctionCalling;
         }
      }
      
   }
}