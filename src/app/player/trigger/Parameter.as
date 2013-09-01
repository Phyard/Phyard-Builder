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
         return VariableInstanceConstant.kVoidVariableInstance; 
                  // returning a non-null value will make program more efficient and tidy.
                  // for there is no needs to add many "if GetVariableInstance () != null"s.
                  //
                  // if a sub classes overrides this fucntion, it also can't be null value.
      }
      
      // as an input
      public function EvaluateValueObject ():Object
      {
         //var vi:VariableInstance = GetVariableInstance ();
         //
         //return vi == null ? null : vi.GetValueObject ();
         
         return GetVariableInstance ().GetValueObject ();
      }
      
      // as an output
      public function AssignValueObject (valueObject:Object):void
      {
         //var vi:VariableInstance = GetVariableInstance ();
         //
         //if (vi != null)
         //{
         //   vi.SetValueObject (valueObject);
         //}
         
         GetVariableInstance ().SetValueObject (valueObject);
      }
   }
}