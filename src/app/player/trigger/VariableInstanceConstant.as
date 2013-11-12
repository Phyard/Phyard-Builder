package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableInstanceConstant extends VariableInstance
   {
      // void target or null source.
      public static const kVoidVariableInstance:VariableInstanceConstant = new VariableInstanceConstant (new VariableDeclaration ());
            // mxmlc is weak: if this variable is put in super class VariableInstance, then compiling error.
      
   //=====================================
   
      public function VariableInstanceConstant (variableDeclaration:VariableDeclaration)
      {
         SetDeclaration (variableDeclaration);
      }
      
      // this class is to make common assignment more faster and safer.

      override public function Assign (classDefinition:ClassDefinition, valueObject:Object):void
      {
      }
      
      override public function SetValueObject (valueObject:Object):void
      {
      }
      
   }
}