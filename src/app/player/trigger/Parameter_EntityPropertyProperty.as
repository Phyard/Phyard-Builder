package player.trigger
{
   import player.entity.Entity;
   
   public class Parameter_EntityPropertyProperty extends Parameter_EntityProperty
   {
      protected var mPropertyId:int;
      
      public function Parameter_EntityPropertyProperty (entityParameter:Parameter, spaceId:int, entityPropertyId:int, propertyPropertyId:int, next:Parameter = null)
      {
         super (entityParameter, spaceId, entityPropertyId, next);
         
         mPropertyId = propertyPropertyId;
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         var ownerVi:VariableInstance = super.GetVariableInstance ();
         //if (ownerVi == null) // must be not null now. It may be VariableInstance.kVoidVariableInstance.
         //   return null;
         
         var variableSpace:VariableSpace = ownerVi.GetValueObject () as VariableSpace;
         if (variableSpace == null)
            return VariableInstanceConstant.kVoidVariableInstance;
         
         return variableSpace.GetVariableByIndex (mPropertyId);
      }
   }
}