package player.trigger
{
   public class ValueSource_Null extends ValueSource
   {
      public function ValueSource_Null (next:ValueSource = null)
      {
         super (next);
      }
      
      override public function EvalateValueObject ():Object
      {
         return null;
      }
   }
}