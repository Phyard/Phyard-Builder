package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassDeclaration;
   import common.trigger.ClassTypeDefine;
   
   public class ClassCore extends ClassBase
   {
      private var mCoreClassDeclaration:ClassDeclaration;
      public var mInitialInstacneValue:Object;
      public var mInstanceValueValidateFunc:Function;
      
      private var mSceneDataDependent:Boolean;
      
      public function ClassCore (coreDecl:ClassDeclaration, typeName:String, defalutInstanceName:String, initialInitialValue:Object, validateValueFunc:Function)
      {
         super (typeName, defalutInstanceName);
         
         mCoreClassDeclaration = coreDecl;
         mInitialInstacneValue = initialInitialValue;
         mInstanceValueValidateFunc = validateValueFunc;
      }
      
      override public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Core;
      }
      
      override public function GetID ():int
      {
         return mCoreClassDeclaration.GetID ();
      }
      
      override public function IsSceneDataDependent ():Boolean
      {
         return mSceneDataDependent;
      }
      
      public function SetSceneDataDependent (dependent:Boolean):void
      {
         mSceneDataDependent = dependent;
      }
      
      public function GetCoreClassDeclaration ():ClassDeclaration
      {
         return mCoreClassDeclaration;
      }
      
      public function GetInitialInstacneValue ():Object
      {
         return mInitialInstacneValue;
      }
   }
}

