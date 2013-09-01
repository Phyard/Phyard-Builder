package player.trigger
{
   public class Parameter_Variable extends Parameter
   {
      internal var mVariableInstance:VariableInstance; // msut be not null.
      
      public function Parameter_Variable (vi:VariableInstance, next:Parameter = null)
      {
         super (next);
         
         mVariableInstance = vi;
         
if (mVariableInstance == null)
throw new Error ("111");
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         return mVariableInstance;
      }
   }
}