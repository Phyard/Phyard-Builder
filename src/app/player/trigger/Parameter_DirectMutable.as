package player.trigger
{
   // since v2.05, use this new implementation.
   // So that every Parameter.GetVariableInstane () will non-null VariableInstance.
   // This will bring conviences for common value assignments, which is introduced at v2.05.
   
   public class Parameter_DirectMutable extends Parameter_Variable // Parameter_DirectConstant
   {
      public static function CreateCoreClassDirectMutable (coreClassId:int, initValue:Object, next:Parameter = null):Parameter_DirectMutable
      {
         var classDef:ClassDefinition = CoreClasses.GetCoreClassDefinition (coreClassId);
         return new Parameter_DirectMutable (new VariableDeclaration (classDef), classDef, initValue, next);
      }
      
   //====================================
   
      public function Parameter_DirectMutable (variableDeclaration:VariableDeclaration, classDefinition:ClassDefinition, valueObject:Object, next:Parameter = null)
      {
         //super (valueObject, next);
         super (new VariableInstance (), next)
         mVariableInstance.SetDeclaration (variableDeclaration);
         mVariableInstance.SetRealClassDefinition (classDefinition);
         
         //AssignValueObject (valueObject); // bug
         mValueObject = valueObject;
      }
      
      //>>>>>>> this function is important for calling in constructor. !!!
      public function get mValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
      
      public function set mValueObject (valueObject:Object):void
      {
         mVariableInstance.SetValueObject (valueObject);
      }
      //<<<<<<<
   }
}