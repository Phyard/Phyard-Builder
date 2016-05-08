package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.entity.Scene;
   
   import common.trigger.ValueTargetTypeDefine;
   
   public interface ValueTarget
   {
      function GetValueTargetType ():int;
      
      //function AssignValue (source:ValueSource):void;
      
      function CloneTarget (scene:Scene, /*triggerEngine:TriggerEngine, */ownerFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueTarget;
      
      function ValidateTarget ():void;
      
      function TargetToCodeString (vd:VariableDefinition):String;
   }
}

