package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassDeclaration;
   import common.trigger.ClassTypeDefine;
   
   public class ClassBase
   {
      public var mClassName:String;
      public var mDefaultInstanceName:String;
      
      private var mSceneDataDependent:Boolean;
      
      public function ClassBase (typeName:String, defalutInstanceName:String)
      {
         mClassName = typeName;
         mDefaultInstanceName = defalutInstanceName;
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
         return true; // to override
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
   }
}

