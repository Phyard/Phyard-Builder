package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   
   import editor.entity.Entity;
   
   public class VariableValueSourceDirect extends VariableValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public var mValueObject:Object;
      
      public function VariableValueSourceDirect (valueObject:Object)
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
      
      override public function Clone ():VariableValueSource
      {
         return new VariableValueSourceDirect (mValueObject);
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

