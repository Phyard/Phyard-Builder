package player.trigger
{
   // this class instance used as null Parameter.
   
   public class Parameter
   {
      public var mNextParameter:Parameter; // next parameter in input/output parameter list
      
      public function Parameter (next:Parameter = null)
      {
         mNextParameter = next;
      }
      
      public function GetVariableInstance ():VariableInstance
      {
         return null;
      }
      
      // as an input
      public function EvaluateValueObject ():Object
      {
         var vi:VariableInstance = GetVariableInstance ();

         return vi == null ? null : vi.GetValueObject ();
      }
      
      // as an output
      public function AssignValueObject (valueObject:Object):void
      {
         var vi:VariableInstance = GetVariableInstance ();
         
         if (vi != null)
         {
            vi.SetValueObject (valueObject);
         }
      }
   }
}