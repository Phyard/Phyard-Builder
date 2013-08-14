package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassDeclaration;
   import common.trigger.ClassTypeDefine;
   
   public class ClassBase
   {
      public var mClassName:String;
      public var mDefaultInstanceName:String;
      
      private var mInitialInstacneValue:Object;
      private var mInstanceValueValidateFunc:Function;
      
      private var mSceneDataDependent:Boolean;
      
      public function ClassBase (typeName:String, defalutInstanceName:String, initialInitialValue:Object, validateValueFunc:Function)
      {
         mClassName = typeName;
         mDefaultInstanceName = defalutInstanceName;
         
         mInitialInstacneValue = initialInitialValue;
         mInstanceValueValidateFunc = validateValueFunc;
      }
      
      public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Unknown;
      }
      
      public function GetID ():int
      {
         return -1; // to override
      }
      
      public function IsSceneDataDependent ():Boolean
      {
         return mSceneDataDependent;
      }
      
      public function SetSceneDataDependent (dependent:Boolean):void
      {
         mSceneDataDependent = dependent;
      }
      
      public function GetName ():String
      {
         return mClassName;
      }
      
      public function SetName (name:String):void
      {
         mClassName = name;
      }
      
      public function GetDefaultInstanceName ():String
      {
         return mDefaultInstanceName;
      }
      
      //===========
      
      public function GetInitialInstacneValue ():Object
      {
         return mInitialInstacneValue;
      }
      
      public function ValidateValueObject (valueObject:Object, options:Object):Object
      {
         return mInstanceValueValidateFunc (valueObject, options);
      }
      
   }
}

