package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.ClassDeclaration;
   
   public class ClassDefinition_Core extends ClassDefinition
   {
      protected var mClassDeclaration:ClassDeclaration;
      
      protected var mDefaultInitialValue:Object;
      
      public function ClassDefinition_Core (classDeclaration:ClassDeclaration)
      {
         mClassDeclaration = classDeclaration;
      }
      
      override public function GetDefaultInitialValue ():Object
      {
         return mDefaultInitialValue;
      }
      
      public function SetDefaultInitialValue (value:Object):void
      {
         mDefaultInitialValue = value;
      }
      
      override public function GetID ():int
      {
         return mClassDeclaration.GetID ();
      }
      
      override public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Core;
      }
      
      //override public function IsCustomClass ():Boolean
      //{
      //   return false;
      //}
   }
}