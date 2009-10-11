package player.trigger
{
   import common.trigger.ValueTypeDefine;
   
   public class CommandListDefinition
   {
      protected var mFirstFunctionCalling:FunctionCalling = null;
      
      public function CommandListDefinition (firstCalling:FunctionCalling)
      {
         mFirstFunctionCalling = firstCalling;
      }
      
      public function Excute ():void
      {
         trace ("CommandListDefinition.Excute");
         
         var calling:FunctionCalling = mFirstFunctionCalling;
         
         while (calling != null)
         {
            calling.Call ();
            calling = calling.mNextFunctionCalling;
         }
      }
   }
}