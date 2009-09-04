package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Property implements ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mPropertyId:int;
      
      public function ValueSource_Property (propetyId:int)
      {
         mPropertyId = propetyId;
      }
      
      public function GetPropertyOwnerType ():int
      {
         return ValueSourceTypeDefine.PropertyOwner_Void;
      }
      
      public function GetPropertyId ():int
      {
         return mPropertyId;
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Property;
      }
      
      public function GetValueObject ():Object
      {
         return null;
      }
      
      public function CloneSource ():ValueSource
      {
         return null;
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
   }
}

