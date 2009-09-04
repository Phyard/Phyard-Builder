package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public interface ValueSource
   {
      function GetValueSourceType ():int;
      
      function GetValueObject ():Object;
      
      // to override
      function CloneSource ():ValueSource;
      
      function ValidateSource ():void;
      
      /*
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Null;
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
      */
   }
}

