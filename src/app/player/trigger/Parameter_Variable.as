package player.trigger
{
   public class Parameter_Variable extends Parameter
   {
      internal var mVariableInstance:VariableInstance; // msut be not null.
      
      public function Parameter_Variable (vi:VariableInstance, next:Parameter = null)
      {
         super (next);
         
         mVariableInstance = vi;
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         return mVariableInstance;
      }
   }
}