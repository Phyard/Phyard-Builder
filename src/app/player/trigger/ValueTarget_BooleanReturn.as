package player.trigger
{
   public class ValueTarget_BooleanReturn extends ValueTarget
   {
      public var mBoolValue:Boolean = false;
      
      public function ValueTarget_BooleanReturn ()
      {
      }
      
      override public function AssignValueObject (valueObject:Object):void
      {
         mBoolValue = Boolean (valueObject);
      }
   }
}