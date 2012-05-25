package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class ValueSource_Null implements ValueSource
   {
      public function ValueSource_Null ()
      {
         
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
      {
         return "null";
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Null;
      }
      
      public function GetValueObject ():Object
      {
         return null;
      }
      
      // to override
      public function CloneSource (/*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource
      {
         return new ValueSource_Null ();
      }
      
      public function ValidateSource ():void
      {
      }
   }
}

