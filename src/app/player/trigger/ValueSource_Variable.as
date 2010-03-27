package player.trigger
{
   public class ValueSource_Variable extends ValueSource
   {
      protected var mVariableInstance:VariableInstance;
      
      public function ValueSource_Variable (vi:VariableInstance, next:ValueSource = null)
      {
         super (next);
         
         mVariableInstance = vi;
      }
      
      override public function EvalateValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
      
      // this function is for some special apis
      public function GetVariableInstance ():VariableInstance
      {
         return mVariableInstance;
      }
   }
}