package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class ClassInstance
   {
      public static function CreateClassInstance (classDefinition:ClassDefinition, initValue:Object):ClassInstance
      {
         var ci:ClassInstance = new ClassInstance ();
         ci._mRealClassDefinition = classDefinition;
         ci._mValueObject = initValue;
         
         return ci;
      }
      
   //================================================
   
      // the 2 are set to public for better performance.
      // their values can only be changed in CommonAssgin API.
      // (mValueObject can also be changed in SetValueObject for old APIs)
      internal var _mRealClassDefinition:ClassDefinition = CoreClasses.kVoidClassDefinition; // must inited with this value, for kVoidVariableInstance.
      internal var _mValueObject:Object = null; // undefined;  // must inited with this value, for kVoidVariableInstance.
      
      public function ClassInstance ()
      {
      }
      
      public function GetRealClassDefinition ():ClassDefinition
      {
         return _mRealClassDefinition;
      }
      
      public function SetRealClassDefinition (classDefinition:ClassDefinition):void
      {
         _mRealClassDefinition = classDefinition == null ? CoreClasses.kVoidClassDefinition : classDefinition;
      }
      
      public function GetRealClassType ():int
      {
         return _mRealClassDefinition.GetClassType ();
      }
      
      public function GetRealValueType ():int
      {
         return _mRealClassDefinition.GetID ();
      }
      
      public function GetValueObject ():Object
      {
         return _mValueObject;
      }
      
      // this one may be overridden.
      public function SetValueObject (valueObject:Object):void
      {
         _mValueObject = valueObject;
      }
      
      // this one can't be overridden
      internal final function _SetValueObject (valueObject:Object):void
      {
         _mValueObject = valueObject;
      }
      
      public function CloneForClassInstance (forVI:ClassInstance):void
      {
         forVI._mRealClassDefinition = _mRealClassDefinition;
         forVI._mValueObject = _mValueObject;
      }
      
   }
}