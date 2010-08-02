package player.trigger
{
   import player.entity.Entity;
   
   public class ValueTarget_Property extends ValueTarget
   {
      protected var mEntityValueSource:ValueSource;
      protected var mSpacePackageId:int;
      protected var mPropertyId:int;
      
      public function ValueTarget_Property (entityValueSource:ValueSource, spaceId:int, propertyId:int)
      {
         mEntityValueSource = entityValueSource;
         mSpacePackageId = spaceId;
         mPropertyId = propertyId;
      }
      
      override public function AssignValueObject (valueObject:Object):void
      {
         var entity:Entity = mEntityValueSource.EvalateValueObject () as Entity;
         
         if (entity != null)
         {
            entity.SetCustomProperty (mSpacePackageId, mPropertyId, valueObject);
         }
      }
   }
}