package player.trigger
{
   public class ValueSource_Null extends ValueSource
   {
      public function ValueSource_Null ()
      {
      }
      
      override public function EvalateValueObject ():Object
      {
         return null;
      }
   }
}