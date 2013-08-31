package player.trigger
{
   import player.entity.Entity;
   
   public class Parameter_EntityProperty extends Parameter
   {
      protected var mEntityParameter:Parameter;
      protected var mSpacePackageId:int;
      protected var mEntityPropertyId:int;
      
      public function Parameter_EntityProperty (entityParameter:Parameter, spaceId:int, entityPropertyId:int, next:Parameter = null)
      {
         super (next);
         
         mEntityParameter = entityParameter;
         mSpacePackageId = spaceId;
         mEntityPropertyId = entityPropertyId;
      }
      
      override public function GetVariableInstance ():VariableInstance
      {
         var entity:Entity = mEntityParameter.EvaluateValueObject () as Entity;
         
         return entity == null ? /*undefined*/null : entity.GetCustomPropertyInstance (mSpacePackageId, mEntityPropertyId);
      }
   }
}