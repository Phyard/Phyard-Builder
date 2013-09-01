package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class ClassInstance
   {
      private var mRealClassDefinition:ClassDefinition = CoreClasses.kVoidClassDefinition; // must inited with this value, for kVoidVariableInstance.
      private var mValueObject:Object = null; // undefined;  // must inited with this value, for kVoidVariableInstance.
      
      public function ClassInstance ()
      {
      }
      
      public function GetRealClassDefinition ():ClassDefinition
      {
         return mRealClassDefinition;
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
      
      // this one may be overridden.
      public function SetValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
      
      // this one can't be overridden
      internal final function _SetValueObject (valueObject:Object):void
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