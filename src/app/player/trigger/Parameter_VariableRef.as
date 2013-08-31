package player.trigger
{
   public class Parameter_VariableRef extends Parameter
   {
      internal var mVariableReference:VariableReference;
      
      public function Parameter_VariableRef (varRef:VariableReference, next:Parameter = null)
      {
         super (next);
         
         mVariableReference = varRef;
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         return mVariableReference.mVariableInstance;
      }
      
      // a little faster than super
      override public function EvaluateValueObject ():Object
      {
         return mVariableReference.mVariableInstance.GetValueObject ();
      }
      
      // a little faster than super
      override public function AssignValueObject (valueObject:Object):void
      {
         mVariableReference.mVariableInstance.SetValueObject (valueObject);
      }
   }
}