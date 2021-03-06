package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassDeclaration;
   import common.trigger.ClassTypeDefine;
   
   public class ClassDefinition
   {
      public var mDefaultInstanceName:String;
      
      private var mInitialInstacneValue:Object;
      private var mInstanceValueValidateFunc:Function;
      
      private var mSceneDataDependent:Boolean;
      private var mGameSavable:Boolean;
      
      public function ClassDefinition (defalutInstanceName:String, initialInitialValue:Object, validateValueFunc:Function)
      {
         SetDefaultInstanceName (defalutInstanceName);
         
         mInitialInstacneValue = initialInitialValue;
         mInstanceValueValidateFunc = validateValueFunc;
         
         SetSceneDataDependent (false);
         SetGameSavable (false);
      }
      
      public function toString ():String
      {
         return (GetClassType () == ClassTypeDefine.ClassType_Custom ? "Custom : " : "Core : ")
                 +
                GetName ();
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
      
      public function SetSceneDataDependent (dependent:Boolean):ClassDefinition
      {
         mSceneDataDependent = dependent;
         
         return this;
      }
      
      public function IsGameSavable ():Boolean
      {
         return mGameSavable;
      }
      
      public function SetGameSavable (savable:Boolean):ClassDefinition
      {
         mGameSavable = savable;
         
         return this;
      }
      
      public function GetName ():String
      {
         return null; // to overide
      }
      
      public function GetDefaultInstanceName ():String
      {
         return mDefaultInstanceName;
      }
      
      public function SetDefaultInstanceName (defalutInstanceName:String):void
      {
         mDefaultInstanceName = defalutInstanceName;
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

