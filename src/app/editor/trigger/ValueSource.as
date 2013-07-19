package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.entity.Scene;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public interface ValueSource
   {
      function GetValueSourceType ():int;
      
      function GetValueObject ():Object;
      
      //todo: remove this functions. Use asset->define->new_asset instead (making use of uuid)
      function CloneSource (scene:Scene, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource;
      
      function ValidateSource ():void;
      
      function SourceToCodeString (vd:VariableDefinition):String;
   }
}

