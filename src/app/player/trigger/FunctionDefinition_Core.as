package player.trigger
{
   public class FunctionDefinition_Core extends FunctionDefinition
   {
      public var mCoreFunction:Function = null;
      
      public function FunctionDefinition_Core (inputValueSourceDefines:Array, numOutputs:int, callback:Function)
      {
         super (inputValueSourceDefines, numOutputs);
         
         mCoreFunction = callback;
      }
      
      override public function DoCall (inputValueSourceList:Parameter, returnValueTargetList:Parameter):void
      {
         mCoreFunction (inputValueSourceList, returnValueTargetList);
      }
   }
}