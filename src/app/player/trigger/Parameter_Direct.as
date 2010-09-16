package player.trigger
{
   public class Parameter_Direct extends Parameter
   {
      public var mValueObject:Object;
      
      public function Parameter_Direct (valueObject:Object, next:Parameter = null)
      {
         super (next);
         
         mValueObject = valueObject;
      }
      
      override public function EvaluateValueObject ():Object
      {
         return mValueObject;
      }
      
      // used internally
      override public function AssignValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
   }
}