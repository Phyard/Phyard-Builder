package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Property_Global extends ValueSource_Property
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public function ValueSource_Property_Global (propertyId:int)
      {
         super (propertyId);
      }
      
      override public function GetPropertyOwnerType ():int
      {
         return ValueSourceTypeDefine.PropertyOwner_Global;
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
         return null; // todo
      }
      
      override public function CloneSource ():ValueSource
      {
         return new ValueSource_Property_Global (mPropertyId);
      }
      
      override public function ValidateSource ():void
      {
         // ...
      }
   }
}

