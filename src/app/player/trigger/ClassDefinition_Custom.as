package player.trigger
{
   import common.trigger.ClassTypeDefine;

   public class ClassDefinition_Custom extends ClassDefinition
   {
      private var mId:int;
      private var mName:String;
      public var mPropertyVariableSpaceTemplate:VariableSpace; // should not be null
      
      public function ClassDefinition_Custom (customId:int, name:String)
      {
         mId = customId;
         mName = name;
         
         mToNumberFunc = CoreClassesHub.Object2Number;
         mToBooleanFunc = CoreClassesHub.Object2Boolean;
         mToStringFunc = CoreClassesHub.Object2String;
         mIsNullFunc = CoreClassesHub.IsNullObjectValue;
         mGetNullFunc = CoreClassesHub.GetNullObjectValue;
         
         mValueConvertOrder = ClassDefinition.ValueConvertOrder_Others;
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
      
      override public function GetName ():String
      {
         return mName;
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