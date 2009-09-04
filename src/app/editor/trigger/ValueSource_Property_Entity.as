package editor.trigger {
   
   import editor.entity.Entity;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Property_Entity extends ValueSource_Property
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mEntity:Entity;
      
      public function ValueSource_Property_Entity (propertyId:int, entity:Entity)
      {
         super (propertyId);
         
         mEntity = entity;
      }
      
      public function GetEntityObject ():Entity
      {
         return mEntity;
      }
      
      override public function GetPropertyOwnerType ():int
      {
         return ValueSourceTypeDefine.PropertyOwner_Entity;
      }
      
//=============================================================
// override
//=============================================================
      
      override public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Property;
      }
      
      override public function GetValueObject ():Object
      {
         if (mEntity == null)
            return undefined;
         
         return mEntity.GetPropertyValue (mPropertyId);
      }
      
      override public function CloneSource ():ValueSource
      {
         return new ValueSource_Property_Entity (mPropertyId, mEntity);
      }
      
      override public function ValidateSource ():void
      {
         // ...
      }
   }
}

