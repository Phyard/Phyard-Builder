package player.trigger
{
   import player.entity.Entity;
   
   public class Parameter_ObjectProperty extends Parameter_Variable
   {
      protected var mPropertyId:int;
      
      public function Parameter_ObjectProperty (ownerVi:VariableInstance, propertyId:int, next:Parameter = null)
      {
         super (ownerVi, next);
         
         mPropertyId = propertyId;
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         var variableSpace:VariableSpace = mVariableInstance.mValueObject as VariableSpace;
         if (variableSpace == null)
            return null;

         return variableSpace.GetVariableByIndex (mPropertyId);
      }
      
      // restore super.super
      override public function EvaluateValueObject ():Object
      {
         var vi:VariableInstance = GetVariableInstance ();

         return vi == null ? null : vi.GetValueObject ();
      }
      
      // restore super.super
      override public function AssignValueObject (valueObject:Object):void
      {
         var vi:VariableInstance = GetVariableInstance ();
         
         if (vi != null)
         {
            vi.SetValueObject (valueObject);
         }
      }
   }
}