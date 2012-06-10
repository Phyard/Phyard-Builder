package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.entity.Scene;
   
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTarget_Null implements ValueTarget
   {
      public function GetValueTargetType ():int
      {
         return ValueTargetTypeDefine.ValueTarget_Null;
      }
      
      public function TargetToCodeString (vd:VariableDefinition):String
      {
         return "void";
      }
      
      //public function AssignValue (source:ValueSource):void
      //{
      //}
      
      public function CloneTarget (scene:Scene, /*triggerEngine:TriggerEngine, */ownerFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueTarget
      {
         return new ValueTarget_Null ();
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

