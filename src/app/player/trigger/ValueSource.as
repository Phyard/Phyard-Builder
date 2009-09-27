package player.trigger
{
   public class ValueSource
   {
      public var mNextValueSourceInList:ValueSource; // next value source in input lsit
      
      // direct value sources don't need evaluated, cam make use of this to optimie a litte (!!! in some specail cases, the effect is negative)
      // mNextNeedEvaluatedValueSource 
      
      public function ValueSource (next:ValueSource = null)
      {
         mNextValueSourceInList = next;
      }
      
      public function EvalateValueObject ():Object
      {
         return null;
      }
   }
}