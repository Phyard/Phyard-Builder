package editor.trigger {
   
   import editor.world.World;
   import editor.runtime.Runtime;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Property_World extends ValueSource_Property
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function ValueSource_Property_World (propertyId:int)
      {
         super (propertyId);
      }
      
      override public function GetPropertyOwnerType ():int
      {
         return ValueSourceTypeDefine.PropertyOwner_World;
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
         var world:World = Runtime.GetCurrentWorld ();
         
         if (world == null)
            return undefined;
         
         return world.GetPropertyValue (mPropertyId);
      }
      
      override public function CloneSource ():ValueSource
      {
         return new ValueSource_Property_World (mPropertyId);
      }
      
      override public function ValidateSource ():void
      {
         // ...
      }
   }
}

