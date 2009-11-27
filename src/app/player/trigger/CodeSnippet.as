package player.trigger
{
   import common.trigger.ValueTypeDefine;
   
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
         
         while (calling != null)
         {
         trace ("calling = " + calling);
            calling.Call ();
            calling = calling.mNextFunctionCalling;
         }
      }
   }
}