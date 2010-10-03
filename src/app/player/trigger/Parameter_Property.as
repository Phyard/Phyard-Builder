package player.trigger
{
   import player.entity.Entity;
   
   public class Parameter_Property extends Parameter
   {
      protected var mEntityParameter:Parameter;
      protected var mSpacePackageId:int;
      protected var mPropertyId:int;
      
      public function Parameter_Property (entityParameter:Parameter, spaceId:int, propertyId:int, next:Parameter = null)
      {
         super (next);
         
         mEntityParameter = entityParameter;
         mSpacePackageId = spaceId;
         mPropertyId = propertyId;
      }
      
      override public function EvaluateValueObject ():Object
      {
         var entity:Entity = mEntityParameter.EvaluateValueObject () as Entity;
         
         return entity == null ? undefined : entity.GetCustomProperty (mSpacePackageId, mPropertyId);
      }
      
      override public function AssignValueObject (valueObject:Object):void
      {
         var entity:Entity = mEntityParameter.EvaluateValueObject () as Entity;
         
         if (entity != null)
         {
            entity.SetCustomProperty (mSpacePackageId, mPropertyId, valueObject);
         }
      }
   }
}