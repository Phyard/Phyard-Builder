package player.trigger
{
   public class Parameter_VariableRef extends Parameter
   {
      internal var mVariableReference:VariableReference; // it and it.mVariableInstacne must be not null.
      
      public function Parameter_VariableRef (varRef:VariableReference, next:Parameter = null)
      {
         super (next);
         
         mVariableReference = varRef;
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         return mVariableReference.mVariableInstance;
      }
   }
}