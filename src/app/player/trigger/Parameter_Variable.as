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
      
      override public function GetVariableInstance ():VariableInstance
      {
         return mVariableInstance;
      }
      
      // a little faster than super
      override public function EvaluateValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
      
      // a little faster than super
      override public function AssignValueObject (valueObject:Object):void
      {
         mVariableInstance.SetValueObject (valueObject);
      }
   }
}