package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassDeclaration;
   import common.trigger.ClassTypeDefine;
   
   public class ClassDefinition_Core extends ClassDefinition
   {
      private var mCoreClassDeclaration:ClassDeclaration;
      
      public function ClassDefinition_Core (coreDecl:ClassDeclaration, typeName:String, defalutInstanceName:String, initialInitialValue:Object, validateValueFunc:Function)
      {
         super (typeName, defalutInstanceName, initialInitialValue, validateValueFunc);
         
         mCoreClassDeclaration = coreDecl;
      }
      
      public function GetCoreClassDeclaration ():ClassDeclaration
      {
         return mCoreClassDeclaration;
      }
      
      override public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Core;
      }
      
      override public function GetID ():int
      {
         return mCoreClassDeclaration.GetID ();
      }
   }
}

