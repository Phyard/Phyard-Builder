package player.trigger
{
   import common.trigger.ClassTypeDefine;

   public class ClassDefinition_Custom extends ClassDefinition
   {
      protected var mId:int;
      protected var mPropertyVariableSpaceTemplate:VariableSpace = null; // null for core class.
      
      public function ClassDefinition_Custom (id:int)
      {
         mId = id;
      }
      
      public function SetPropertyVariableSpaceTemplate (propertyVariableSpaceTemplate:VariableSpace):void
      {
         mPropertyVariableSpaceTemplate = propertyVariableSpaceTemplate;
      }
      
      override public function GetID ():int
      {
         return mId;
      }
      
      override public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Custom;
      }
      
      override public function CreateInstance ():ClassInstance
      {
         return new ClassInstance (this, mPropertyVariableSpaceTemplate.CloneSpace ());
      }
   }
}