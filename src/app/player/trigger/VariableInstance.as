package player.trigger
{
   import common.trigger.ValueTypeDefine;
   
   public class VariableInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance; // for efficiency
      
      private var mKey:String;
      
      private var mValueType:int = ValueTypeDefine.ValueType_Void;
      
      public var mName:String = null; // for debug usage only
      
      public var mValueObject:Object = null;
      
      public function VariableInstance (value:Object = null)
      {
         mValueObject = value;
      }
      
      public function SetKey (key:String):void
      {
         mKey = key;
      }
      
      public function GetKey ():String
      {
         return mKey;
      }
      
      public function SetValueType (type:int):void
      {
         mValueType = type;
      }
      
      public function GetValueType ():int
      {
         return mValueType;
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