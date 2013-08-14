package editor.trigger {
   
   import common.trigger.ClassTypeDefine;
   
   public class VariableDefinition_Core extends VariableDefinition
   {
      public function VariableDefinition_Core (coreClass:ClassCore, name:String, description:String = null, options:Object = null)
      {
         //super (ClassTypeDefine.ClassType_Core, classId, name, description);
         super (coreClass, name, description, options);
      }
      
      public function GetCoreClass ():ClassCore
      {
         return mClass as ClassCore;
      }
   }
}

