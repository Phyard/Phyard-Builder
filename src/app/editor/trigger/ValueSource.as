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
      
      function ToCodeString ():String;
   }
}

