package editor.trigger {
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   
   import editor.entity.Entity;
   import editor.entity.EntityCollisionCategory;
   
   public class ValueSource_Direct implements ValueSource
   {
      
   //========================================================================================================
   // 
   //========================================================================================================
      
      public var mValueObject:Object = null;
      
      public function ValueSource_Direct (valueObject:Object)
      {
         SetValueObject (valueObject);
      }
      
      // this is a shortcut to change the value object quickly without creating a new ValueSource_Direct
      public function SetValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Direct;
      }
      
      public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      public function CloneSource ():ValueSource
      {
         return new ValueSource_Direct (mValueObject);
      }
      
      public function ValidateSource ():void
      {
         if (mValueObject is Entity)
         {
            var entity:Entity = mValueObject as Entity;
            if (entity.GetEntityIndex () < 0)
               SetValueObject (null)
         }
         else if (mValueObject is EntityCollisionCategory)
         {
            
         }
      }
      
   }
}

