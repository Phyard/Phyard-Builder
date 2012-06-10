package player.trigger
{
   // also used as Parameter_Null
   
   public class Parameter
   {
      public var mNextParameter:Parameter; // next parameter in input/output parameter list
      
      public function Parameter (next:Parameter = null)
      {
         mNextParameter = next;
      }
      
      // as an input
      public function EvaluateValueObject ():Object
      {
         return undefined; // to override
      }
      
      // as an output
      public function AssignValueObject (valueObject:Object):void
      {
         // to override
      }
   }
}