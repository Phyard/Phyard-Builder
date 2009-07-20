package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class ValueSource
   {
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Undetermined;
      }
      
      public function GetValueObject ():Object
      {
         return null;
      }
      
      // to override
      public function Clone ():ValueSource
      {
         return null;
      }
      
      public function Validate ():void
      {
      }
   }
}

