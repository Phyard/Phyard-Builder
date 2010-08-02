package player.trigger
{
   import player.entity.Entity;
   
   public class ValueSource_Property extends ValueSource
   {
      protected var mEntityValueSource:ValueSource;
      protected var mSpacePackageId:int;
      protected var mPropertyId:int;
      
      public function ValueSource_Property (entityValueSource:ValueSource, spaceId:int, propertyId:int, next:ValueSource = null)
      {
         super (next);
         
         mEntityValueSource = entityValueSource;
         mSpacePackageId = spaceId;
         mPropertyId = propertyId;
      }
      
      override public function EvalateValueObject ():Object
      {
         var entity:Entity = mEntityValueSource.EvalateValueObject () as Entity;
         
         return entity == null ? null : entity.GetCustomProperty (mSpacePackageId, mPropertyId);
      }
   }
}