package editor.trigger {
   
   import common.trigger.ClassTypeDefine;
   
   public class VariableDefinition_Core extends VariableDefinition
   {
      protected var mCoreClass:CoreClass;
      
      public function VariableDefinition_Core (coreClass:CoreClass, name:String, description:String = null, options:Object = null)
      {
         //super (ClassTypeDefine.ClassType_Core, classId, name, description, options);
         super (name, description);
         
         mCoreClass = coreClass;
         
         SetDefaultValue (mCoreClass.GetInitialInstacneValue ()); // may be changed by other classes.
      }

      override public function GetTypeType ():int
      {
         return ClassTypeDefine.ClassType_Core;
      }
      
      override public function GetValueType ():int
      {
         return mCoreClass.GetID ();
      }
      
   }
}

