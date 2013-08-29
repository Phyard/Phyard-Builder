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
      
      // real class must be shell class or sub class of shell class
      public var mRealClassDefinition:ClassDefinition = null; // CoreClasses.kVoidClassDefinition;
      public var mValueObject:Object = null; // undefined;
      
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
      
      public function SetShellClassDefinition (classDefinition:ClassDefinition):void
      {
         mShellClassDefinition = classDefinition == null ? CoreClasses.kVoidClassDefinition : classDefinition;
         if (mRealClassDefinition == null)
         {
            mRealClassDefinition = mShellClassDefinition; // may change later. Shell one never change.
         }
      }
      
      //public function SetClassType1 (type:int):void
      //{
      //   mClassType = type;
      //}
      
      //public function GetShellClassType ():int
      //{
      //   //return mClassType;
      //   return mShellClassDefinition.GetClassType ();
      //}
      
      //public function SetValueType1 (type:int):void
      //{
      //   mValueType = type;
      //}
      
      //public function GetShellValueType ():int
      //{
      //   //return mValueType;
      //   return mShellClassDefinition.GetID ();
      //}
      
      public function SetRealClassDefinition (classDefinition:ClassDefinition):void
      {
         mRealClassDefinition = classDefinition == null ? CoreClasses.kVoidClassDefinition : classDefinition;
      }
      
      public function GetRealClassType ():int
      {
         return mRealClassDefinition.GetClassType ();
      }
      
      public function GetRealValueType ():int
      {
         //return mValueType;
         return mRealClassDefinition.GetID ();
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
         forVI.SetRealClassDefinition (mRealClassDefinition);
         forVI.SetValueObject (mValueObject);
      }
      
   }
}