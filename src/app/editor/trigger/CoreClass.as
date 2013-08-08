package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassDeclaration;
   
   public class CoreClass
   {
      private var mCoreClassDeclaration:ClassDeclaration;
      public var mClassName:String;
      public var mDefaultInstanceName:String;
      public var mInitialInstacneValue:Object;
      public var mInstanceValueValidateFunc:Function;
      
      private var mSceneDataDependent:Boolean;
      
      public function CoreClass (coreDecl:ClassDeclaration, typeName:String, defalutInstanceName:String, initialInitialValue:Object, validateValueFunc:Function)
      {
         mCoreClassDeclaration = coreDecl;
         mClassName = typeName;
         mDefaultInstanceName = defalutInstanceName;
         mInitialInstacneValue = initialInitialValue;
         mInstanceValueValidateFunc = validateValueFunc;
      }
      
      public function GetCoreClassDeclaration ():ClassDeclaration
      {
         return mCoreClassDeclaration;
      }
      
      public function IsSceneDataDependent ():Boolean
      {
         return mSceneDataDependent;
      }
      
      public function SetSceneDataDependent (dependent:Boolean):void
      {
         mSceneDataDependent = dependent;
      }
      
      public function GetID ():int
      {
         return mCoreClassDeclaration.GetID ();
      }
      
      public function GetName ():String
      {
         return mClassName;
      }
      
      public function GetDefaultInstanceName ():String
      {
         return mDefaultInstanceName;
      }
      
      public function GetInitialInstacneValue ():Object
      {
         return mInitialInstacneValue;
      }
   }
}

