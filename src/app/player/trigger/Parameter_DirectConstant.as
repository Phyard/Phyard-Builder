package player.trigger
{
   public class Parameter_DirectConstant extends Parameter_Variable
   {
      //public var mValueObject:Object;
      
      // for optimizing, TriggerEngine will cache many Parameter_Direct instances. 
      // Notice: when a Parameter_Direct is recycled, mValueObjec must be reset to null
      
      // above comments is for old implementation.
            
      public function Parameter_DirectConstant (classDefinition:ClassDefinition, valueObject:Object, next:Parameter = null)
      {
         ////super (valueObject, next);
         //super (new VariableInstanceConstant (new VariableDeclaration (CoreClassesHub.kObjectClassDefinition)), next);
         ////mVariableInstance.SetDeclaration (new VariableDeclaration (CoreClassesHub.kObjectClassDefinition));
         //mVariableInstance.SetRealClassDefinition (classDefinition);
         //
         //mValueObject = valueObject;
         
         super (new VariableInstanceConstant (new VariableDeclaration (CoreClassesHub.kObjectClassDefinition), classDefinition, valueObject), next);
      }
      
      //>>>>>>> this function is important for calling in constructor. !!!
      public function get mValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
      
      public function set mValueObject (valueObject:Object):void
      {
         mVariableInstance._SetValueObject (valueObject);
      }
      //<<<<<<<
   }
}