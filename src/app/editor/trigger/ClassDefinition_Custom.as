package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassTypeDefine;
   
   public class ClassDefinition_Custom extends ClassDefinition
   {
      private var mPropertyDefinitionSpace:VariableSpaceClassInstance;
      
      private var mId:int = -1;
      
      private var mName:String;
        
      public function ClassDefinition_Custom (typeName:String, validateValueFunc:Function)
      {
         super (typeName.toLowerCase (), null, validateValueFunc);
         mName = typeName;
         SetSceneDataDependent (true);
         
         mPropertyDefinitionSpace = new VariableSpaceClassInstance (GetName ());
      }
      
      override public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Custom;
      }
      
      override public function GetID ():int
      {
         return mId;
      }
      
      public function SetID (id:int):void
      {
         mId = id;
      }
      
      override public function GetName ():String
      {
         return mName;
      }
      
      public function SetName (name:String):void
      {
         mName = name;
         
         mPropertyDefinitionSpace.SetSpaceName (GetName ());
      }
      
      public function GetPropertyDefinitionSpace ():VariableSpaceClassInstance
      {
         return mPropertyDefinitionSpace;
      }
   }
}

