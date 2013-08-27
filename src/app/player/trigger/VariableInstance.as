package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance; // for efficiency
      
      private var mKey:String;
      private var mIndex:int;
      
      public var mName:String = null; // for debug usage only
      
      //private var mClassType:int = ClassTypeDefine.ClassType_Unknown;  // since v2.05
      //private var mValueType:int = CoreClassIds.ValueType_Void;
      private var mShellClassDefinition:ClassDefinition = CoreClasses.kVoidClassDefinition;
      
      private var mValueClassDefinition:ClassDefinition = CoreClasses.kVoidClassDefinition;
      public var mValueObject:Object = undefined;
      
      public function VariableInstance (value:Object = null)
      {
         mValueObject = value;
      }
      
      public function SetIndex (index:int):void
      {
         mIndex = index;
      }
      
      public function GetIndex ():int
      {
         return mIndex;
      }
      
      public function SetKey (key:String):void
      {
         mKey = key;
      }
      
      public function GetKey ():String
      {
         return mKey;
      }
      
      //public function SetClassType1 (type:int):void
      //{
      //   mClassType = type;
      //}
      
      public function GetClassType ():int
      {
         //return mClassType;
         return mShellClassDefinition.GetClassType ();
      }
      
      //public function SetValueType1 (type:int):void
      //{
      //   mValueType = type;
      //}
      
      public function GetValueType ():int
      {
         //return mValueType;
         return mShellClassDefinition.GetID ();
      }
      
      public function SetShellClassDefinition (classDefinition:ClassDefinition):void
      {
         mShellClassDefinition = classDefinition == null ? CoreClasses.kVoidClassDefinition : classDefinition;
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
      
      public function CloneFor (forVI:VariableInstance):void
      {
         forVI.SetKey (mKey);
         forVI.SetName (mName);
         //forVI.SetClassType1 (mClassType);
         //forVI.SetValueType1 (mValueType);
         forVI.SetShellClassDefinition (mShellClassDefinition);
         forVI.SetValueObject (mValueObject);
      }
      
   }
}