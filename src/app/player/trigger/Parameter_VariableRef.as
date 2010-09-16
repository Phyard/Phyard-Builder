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
      
      // as an input
      override public function EvaluateValueObject ():Object
      {
         return mVariableReference.mVariableInstance.GetValueObject ();
      }
      
      // as an output
      override public function AssignValueObject (valueObject:Object):void
      {
         mVariableReference.mVariableInstance.SetValueObject (valueObject);
      }
   }
}