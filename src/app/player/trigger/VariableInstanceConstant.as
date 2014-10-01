package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableInstanceConstant extends VariableInstance
   {
      // void target or null source.
      public static const kVoidVariableInstance:VariableInstanceConstant = new VariableInstanceConstant (new VariableDeclaration (), CoreClassesHub.kVoidClassDefinition, CoreClassesHub.kVoidClassDefinition.CreateDefaultInitialValue ());
            // mxmlc is weak: if this variable is put in super class VariableInstance, then compiling error.
      
   //=====================================
   
      public function VariableInstanceConstant (variableDeclaration:VariableDeclaration, classDefinition:ClassDefinition, valueObject:Object)
      {
         SetDeclaration (variableDeclaration);
         _mRealClassDefinition = classDefinition;
         _mValueObject = valueObject; // don's use SetValueObject, which is overridden and do nothing.
      }
      
      // this class is to make common assignment more faster and safer.

      override public function Assign (classDefinition:ClassDefinition, valueObject:Object):void
      {
         // need this override for common assign
      }
      
      override public function SetValueObject (valueObject:Object):void
      {
         // need this override for old APIs
      }
      
   }
}