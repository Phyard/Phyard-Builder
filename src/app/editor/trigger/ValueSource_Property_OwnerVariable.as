package editor.trigger {
   
   import editor.entity.Entity;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   public class ValueSource_Property_OwnerVariable extends ValueSource_Property
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstance:VariableInstance;
      
      public function ValueSource_Property_OwnerVariable (propertyId:int, variableInstance:VariableInstance)
      {
         super (propertyId);
         
         mVariableInstance = variableInstance;
      }
      
      public function GetEntityVariableSpaceType ():int
      {
         if (mVariableInstance == null)
            return ValueSpaceTypeDefine.ValueSpace_Global;
         
         return mVariableInstance.GetSpaceType ();
      }
      
      public function GetEntityVariableIndex ():int
      {
         if (mVariableInstance == null)
            return -1;
         
         return mVariableInstance.GetIndex ();
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
         if (mVariableInstance == null)
            return undefined;
            
         var entity:Entity = mVariableInstance.GetValueObject () as Entity;
         
         if (entity == null)
            return undefined;
         
         return entity.GetPropertyValue (mPropertyId);
      }
      
      override public function CloneSource ():ValueSource
      {
         return new ValueSource_Property_OwnerVariable (mPropertyId, mVariableInstance);
      }
      
      override public function ValidateSource ():void
      {
         // ...
      }
   }
}

