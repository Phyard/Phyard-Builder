package player.trigger
{
   public class VariableInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance;
      
      public var mName:String = null; // for debug usage only
      public var mValueObject:Object = null;
      
      public function VariableInstance (value:Object = null)
      {
         mValueObject = value;
      }
      
      public function SetName (name:String):void
      {
         mName = name;
      }
      
      // it is possible to remvoe the set/get function when optimizing
      
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