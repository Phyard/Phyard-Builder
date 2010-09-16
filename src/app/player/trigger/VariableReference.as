package player.trigger
{
   public class VariableReference
   {
      public static function CreateVariableReferenceArray (count:int):Array
      {
         var refs:Array = new Array (count);
         
         var next:VariableReference = null;
         while (-- count >= 0)
         {
            next = new VariableReference (null, next);
            refs [count] = next;
         }
         
         return refs;
      }
      
   //================================
      
      internal var mNextVariableReference:VariableReference = null;
      
      internal var mVariableInstance:VariableInstance;
      
      public function VariableReference (vi:VariableInstance = null, next:VariableReference = null)
      {
         mVariableInstance = vi;
         mNextVariableReference = next;
      }
   }
}