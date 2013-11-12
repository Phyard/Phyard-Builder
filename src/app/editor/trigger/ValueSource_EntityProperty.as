package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.entity.Scene;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_EntityProperty implements ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mEntityValueSource:ValueSource; // can't be a ValueSource_Property
      private var mPropertyValueSource:ValueSource_Variable;
      
      public function ValueSource_EntityProperty (entityValueSource:ValueSource, propertyValueSource:ValueSource_Variable)
      {
         SetEntityValueSource (entityValueSource);
         SetPropertyValueSource(propertyValueSource);
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
      {
         return mEntityValueSource.SourceToCodeString (null) + mPropertyValueSource.SourceToCodeString (vd);
      }
      
      public function SetEntityValueSource (entityValueSource:ValueSource):void
      {
         mEntityValueSource = entityValueSource;
      }
      
      public function GetEntityValueSource ():ValueSource
      {
         return mEntityValueSource;
      }
      
      public function GetPropertyValueSource ():ValueSource_Variable
      {
         return mPropertyValueSource;
      }
      
      public function SetPropertyValueSource (propertyValueSource:ValueSource_Variable):void
      {
         mPropertyValueSource = propertyValueSource;
      }
      
      public function GetPropertyVariableSpaceType ():int
      {
         return mPropertyValueSource.GetVariableSpaceType ();
      }
      
      public function GetPropertyVariableIndex ():int
      {
         return mPropertyValueSource.GetVariableIndex ();
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_EntityProperty;
      }
      
      public function GetValueObject ():Object
      {
         return mPropertyValueSource.GetValueObject ();
      }
      
      //public function CloneSource ():ValueSource
      //{
      //   // not a safe clone. Only used in FunctionCallingLineData
      //   return new ValueSource_Property (mEntityValueSource.CloneSource (), mPropertyValueSource.CloneSource () as ValueSource_Variable);
      //}
      
      public function CloneSource (scene:Scene, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource
      {
         if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
         {
            // why this? forget.
            return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
         }
         else
         {
            var newEntityValueSource:ValueSource;
            var newPropertyValueSource:ValueSource_Variable;
            
            newEntityValueSource = mEntityValueSource.CloneSource (scene, /*triggerEngine, */targetFunctionDefinition, callingFunctionDeclaration, paramIndex);
            
            newPropertyValueSource = mPropertyValueSource.CloneSource (scene, /*triggerEngine, */targetFunctionDefinition, callingFunctionDeclaration, paramIndex) as ValueSource_Variable;
            
            return new ValueSource_EntityProperty (newEntityValueSource, newPropertyValueSource);
         }
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
   }
}

