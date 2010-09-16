package player.trigger
{
   public class Parameter_Variable extends Parameter
   {
      internal var mVariableInstance:VariableInstance;
      
      public function Parameter_Variable (vi:VariableInstance, next:Parameter = null)
      {
         super (next);
         
         mVariableInstance = vi;
      }
      
      public function GetVariableInstance ():VariableInstance
      {
         return mVariableInstance;
      }
      
      // as an input
      override public function EvaluateValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
      
      // as an output
      override public function AssignValueObject (valueObject:Object):void
      {
         mVariableInstance.SetValueObject (valueObject);
      }
   }
}