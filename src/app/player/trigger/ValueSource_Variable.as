package player.trigger
{
   public class ValueSource_Variable extends ValueSource
   {
      protected var mVariableInstance:VariableInstance;
      
      public function ValueSource_Variable (vi:VariableInstance)
      {
         mVariableInstance = vi;
      }
      
      override public function EvalateValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
   }
}