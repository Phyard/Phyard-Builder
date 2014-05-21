package player.trigger
{
   import player.trigger.CoreFunctionDefinitions;
   
   import common.trigger.CoreFunctionIds;
   
   public class FunctionCalling_CommonAssign extends FunctionCalling
   {
      public function FunctionCalling_CommonAssign (lineNumber:int, functionDefinition:FunctionDefinition, valueSourceList:Parameter, valueTargetList:Parameter)
      {
         super (lineNumber, functionDefinition, valueSourceList, valueTargetList);
      }
      
      override public function Call (callingContext:FunctionCallingContext):void
      {
         CoreClasses.AssignValue (mInputValueSourceList.GetVariableInstance (), mReturnValueTargetList.GetVariableInstance ());
      }
   }
}