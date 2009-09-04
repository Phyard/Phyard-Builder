package player.trigger
{
   public class ValueTarget_Variable extends ValueTarget
   {
      protected var mVariableInstance:VariableInstance;
      
      public function ValueTarget_Variable (vi:VariableInstance)
      {
         mVariableInstance = vi;
      }
      
      override public function AssignValueObject (valueObject:Object):void
      {
         mVariableInstance.SetValueObject (valueObject);
      }
   }
}