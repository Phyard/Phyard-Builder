package editor.trigger {
   
   import common.Define;
   
   import common.trigger.ClassTypeDefine;
   
   public class ClassDefinition_Custom extends ClassDefinition
   {
      private var mPropertyDefinitionSpace:VariableSpaceClassInstance;
      
      private var mId:int = -1;
        
      public function ClassDefinition_Custom (typeName:String, validateValueFunc:Function)
      {
         super (typeName, typeName.toLowerCase (), null, validateValueFunc);
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
      
      public function GetPropertyDefinitionSpace ():VariableSpaceClassInstance
      {
         return mPropertyDefinitionSpace;
      }
      
      override public function SetName (name:String):void
      {
         super.SetName (name);
         
         mPropertyDefinitionSpace.SetSpaceName (GetName ());
      }
   }
}

