package player.trigger
{
   import common.trigger.ClassTypeDefine;

   public class ClassDefinition_Custom extends ClassDefinition
   {
      private var mId:int;
      public var mPropertyVariableSpaceTemplate:VariableSpace; // should not be null
      
      public function ClassDefinition_Custom (customId:int)
      {
         mId = customId;
      }
      
      override public function CreateDefaultInitialValue ():Object
      {
         return mPropertyVariableSpaceTemplate.CloneSpace ();
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
      
      override public function IsCustomClass ():Boolean
      {
         return true;
      }
   }
}