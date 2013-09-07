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
         var variableSpace:VariableSpace = mVariableInstance.GetValueObject () as VariableSpace;
         if (variableSpace == null)
            return VariableInstanceConstant.kVoidVariableInstance;

         return variableSpace.GetVariableByIndex (mPropertyId);
      }
   }
}