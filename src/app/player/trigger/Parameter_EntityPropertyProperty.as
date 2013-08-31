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
         if (ownerVi == null)
            return null;
         
         var variableSpace:VariableSpace = ownerVi.mValueObject as VariableSpace;
         if (variableSpace == null)
            return null;
         
         return variableSpace.GetVariableByIndex (mPropertyId);
      }
   }
}