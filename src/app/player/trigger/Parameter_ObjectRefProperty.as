package player.trigger
{   
   public class Parameter_ObjectRefProperty extends Parameter_VariableRef
   {
      protected var mPropertyId:int;
      
      public function Parameter_ObjectRefProperty (ownerViRef:VariableReference, propertyId:int, next:Parameter = null)
      {
         super (ownerViRef, next);
         
         mPropertyId = propertyId;
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         var variableSpace:VariableSpace = mVariableReference.mVariableInstance.GetValueObject () as VariableSpace;
         if (variableSpace == null)
            return VariableInstanceConstant.kVoidVariableInstance;
         
         return variableSpace.GetVariableByIndex (mPropertyId);
      }
   }
}