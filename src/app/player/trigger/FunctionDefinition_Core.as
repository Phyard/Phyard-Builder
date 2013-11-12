package player.trigger
{
   public class FunctionDefinition_Core extends FunctionDefinition
   {
      public var mCoreFunction:Function = null;
      
      //public function FunctionDefinition_Core (inputValueSourceDefines:Array, ouputParamValueTypes:Array, callback:Function)
      public function FunctionDefinition_Core (inputVariableSpace:VariableSpace, outputVariableSpace:VariableSpace, callback:Function)
      {
         //super (inputValueSourceDefines, ouputParamValueTypes);
         super (inputVariableSpace, outputVariableSpace);
         
         mCoreFunction = callback;
      }
      
      override public function DoCall (inputValueSourceList:Parameter, returnValueTargetList:Parameter):void
      {
         mCoreFunction (inputValueSourceList, returnValueTargetList);
      }
   }
}