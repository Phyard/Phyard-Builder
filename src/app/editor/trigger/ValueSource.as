package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public interface ValueSource
   {
      function GetValueSourceType ():int;
      
      function GetValueObject ():Object;
      
      // to override
      function CloneSource (triggerEngine:TriggerEngine, targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource;
      
      function ValidateSource ():void;
      
      function SourceToCodeString (vd:VariableDefinition):String;
   }
}

