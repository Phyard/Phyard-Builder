package player.trigger
{
   import common.trigger.FunctionDeclaration;
   import common.CoordinateSystem;
   
   public class FunctionCalling_Dummy extends FunctionCalling
   {
      public function FunctionCalling_Dummy (lineNumber:int, functionDefinition:FunctionDefinition, valueSourceList:Parameter, valueTargetList:Parameter)
      {
         super (lineNumber, functionDefinition, valueSourceList, valueTargetList);
      }
      
      override public function Call ():void
      {
         // do nothing
      }
   }
}