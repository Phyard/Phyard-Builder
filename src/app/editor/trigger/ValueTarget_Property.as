package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueTarget_Property implements ValueTarget
   {
      private var mEntityValueSource:ValueSource;
      private var mPropertyValueTarget:ValueTarget_Variable;
      
      public function ValueTarget_Property  (entityValueSource:ValueSource, propertyValueTarget:ValueTarget_Variable)
      {
         SetEntityValueSource (entityValueSource);
         SetPropertyValueTarget(propertyValueTarget);
      }
      
      public function TargetToCodeString (vd:VariableDefinition):String
      {
         return mEntityValueSource.SourceToCodeString (null) + mPropertyValueTarget.TargetToCodeString (vd);
      }
      
      public function SetEntityValueSource (entityValueSource:ValueSource):void
      {
         mEntityValueSource = entityValueSource;
      }
      
      public function GetEntityValueSource ():ValueSource
      {
         return mEntityValueSource;
      }
      
      public function GetPropertyValueTarget ():ValueTarget_Variable
      {
         return mPropertyValueTarget;
      }
      
      public function SetPropertyValueTarget (propertyValueTarget:ValueTarget_Variable):void
      {
         mPropertyValueTarget = propertyValueTarget;
      }
      
      public function GetPropertyVariableIndex ():int
      {
         return mPropertyValueTarget.GetVariableIndex ();
      }
      
//======================================================
// override
//======================================================
      
      public function GetValueTargetType ():int
      {
         return ValueTargetTypeDefine.ValueTarget_Property;
      }
      
      public function AssignValue (source:ValueSource):void
      {
         mPropertyValueTarget.AssignValue (source);
      }
      
      //public function CloneTarget ():ValueTarget
      //{
      //   return new ValueTarget_Property (mEntityValueSource.CloneSource (), mPropertyValueTarget.CloneTarget () as ValueTarget_Variable);
      //}
      
      public function CloneTarget (/*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueTarget
      {
         if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
         {
            return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueTarget ();
         }
         else
         {
            var newEntityValueSource:ValueSource;
            var newPropertyValueTarget:ValueTarget_Variable;
            
            newEntityValueSource = mEntityValueSource.CloneSource (/*triggerEngine, */targetFunctionDefinition, callingFunctionDeclaration, paramIndex);
            
            newPropertyValueTarget = mPropertyValueTarget.CloneTarget (/*triggerEngine, */targetFunctionDefinition, callingFunctionDeclaration, paramIndex) as ValueTarget_Variable;
            
            return new ValueTarget_Property (newEntityValueSource, newPropertyValueTarget);
         }
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

