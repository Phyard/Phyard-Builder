package player.trigger
{
   import common.trigger.ClassTypeDefine;

   public class ClassDefinition_Custom extends ClassDefinition
   {
      private var mId:int;
      public var mPropertyVariableSpaceTemplate:VariableSpace = null; // null for core class.
      
      public function ClassDefinition_Custom (customId:int)
      {
         mId = customId;
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
   }
}