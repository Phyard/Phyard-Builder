package player.trigger
{
   public class VariableInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance;
      
      public var mValueObject:Object = null;
      
      public function VariableInstance (value:Object = null)
      {
         mValueObject = value;
      }
      
      // ti is possible to remvoe the set/get function when optimizing
      
      public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      public function SetValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
      
   }
}