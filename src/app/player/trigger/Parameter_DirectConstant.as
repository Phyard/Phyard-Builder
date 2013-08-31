package player.trigger
{
   public class Parameter_DirectConstant extends Parameter_DirectMutable // Parameter
   {
      //public var mValueObject:Object;
      
      // for optimizing, TriggerEngine will cache many Parameter_Direct instances. 
      // Notice: when a Parameter_Direct is recycled, mValueObjec must be reset to null
      
      public function Parameter_DirectConstant (classDefinition:ClassDefinition, valueObject:Object, next:Parameter = null)
      {
         //super (next);
         super (null, classDefinition, valueObject, next);
               // mVariableInstacne.mDeclaration == null means mVariableInstacne will rejest value assginings in CommonAssign API.
      }
      
      override public function AssignValueObject (valueObject:Object):void
      {
         // do nothing
      }
   }
}