package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   
   import editor.entity.Entity;
   
   public class ValueSourceDirect extends ValueSource
   {
      
   //========================================================================================================
   // 
   //========================================================================================================
      
      public var mValueObject:Object;
      
      public function ValueSourceDirect (valueObject:Object)
      {
         SetValueObject (valueObject);
      }
      
      public function SetValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
      
      override public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Direct;
      }
      
      override public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      override public function Clone ():ValueSource
      {
         return new ValueSourceDirect (mValueObject);
      }
      
      override public function Validate ():void
      {
         if (mValueObject is Entity)
         {
            var entity:Entity = mValueObject as Entity;
            if (entity.GetEntityIndex () < 0)
               SetValueObject (null)
         }
      }
      
   }
}

