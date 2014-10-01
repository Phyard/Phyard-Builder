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
      
      //public static const kClassInstanceVoid:ClassInstance = CreateClassInstance (CoreClassesHub.kVoidClassDefinition, CoreClassesHub.kVoidClassDefinition.CreateDefaultInitialValue ());
      
   //================================================
   
      // the 2 are set to public for better performance.
      // their values can only be changed in CommonAssgin API.
      // (mValueObject can also be changed in SetValueObject for old APIs)
      internal var _mRealClassDefinition:ClassDefinition = CoreClassesHub.kVoidClassDefinition; // must inited with this value, for kVoidVariableInstance.
      internal var _mValueObject:Object = null; // undefined;  // must inited with this value, for kVoidVariableInstance.
      
      public function ClassInstance ()
      {
      }
      
      public function GetRealClassDefinition ():ClassDefinition
      {
         return _mRealClassDefinition;
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
      
      // this one can't be overridden
      public final function _SetValueObject (valueObject:Object):void
      {
         _mValueObject = valueObject;
      }
      
      public function toString ():String
      {
         //return "{class: " + _mRealClassDefinition.GetName () + ", value: " + _mValueObject + "}";
         
         // above one may enter dead loop.
         
         return "{class: " + _mRealClassDefinition.GetName () + ", value: " +_mRealClassDefinition.ToString ( _mValueObject) + "}";
      }
      
      // NOTE: ClassInstance should be viewed as constant/immutable values.
      // If this rule is broken, following APIs need modified:
      // - CreateArray
      // - InsertArrayElements (SpliceArrayElements)
      // - SubArray
      // - ConcatArrays
      // - ...
      public function CloneClassInstance ():ClassInstance
      {
         //if (_mRealClassDefinition == CoreClassesHub.kVoidClassDefinition)
         //   return null;
            
         //var newCI:ClassInstance = new ClassInstance ();
         ////CloneForClassInstance (newCI);
         //newCI._mRealClassDefinition = _mRealClassDefinition;
         //newCI._mValueObject = _mValueObject;
         //return newCI;
         
         return CreateClassInstance (_mRealClassDefinition, _mValueObject);
      }
      
      //public function CloneForClassInstance (forVI:ClassInstance):void
      //{
      //   forVI._mRealClassDefinition = _mRealClassDefinition;
      //   forVI._mValueObject = _mValueObject;
      //}
      
   }
}