package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class ClassInstance
   {
      public var mRealClassDefinition:ClassDefinition = null; // CoreClasses.kVoidClassDefinition;
      public var mValueObject:Object = null; // undefined;
      
      public function ClassInstance (value:Object = null)
      {
         mValueObject = value;
      }
      
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
         return mRealClassDefinition.GetID ();
      }
      
      public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      public function SetValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
      
      public function CloneForClassInstance (forVI:ClassInstance):void
      {
         forVI.SetRealClassDefinition (mRealClassDefinition);
         forVI.SetValueObject (mValueObject);
      }
      
   }
}