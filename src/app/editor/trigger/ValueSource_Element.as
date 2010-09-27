package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Element implements ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mArrayValueSource:ValueSource; // can't be a ValueSource_Property
      private var mIndexValueSource:ValueSource_Variable;
      
      public function ValueSource_Element (arrayalueSource:ValueSource, indexValueSource:ValueSource)
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
      
      public function GetPropertyVariableIndex ():int
      {
         return mPropertyValueSource.GetVariableIndex ();
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Property;
      }
      
      public function GetValueObject ():Object
      {
         return mPropertyValueSource.GetValueObject ();
      }
      
      public function CloneSource ():ValueSource
      {
         // not a safe clone. Only used in FunctionCallingLineData
         return new ValueSource_Property (mEntityValueSource.CloneSource (), mPropertyValueSource.CloneSource () as ValueSource_Variable);
      }
      
      public function ClonePropertySource (triggerEngine:TriggerEngine, ownerFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource
      {
         var newEntityValueSource:ValueSource;
         var newPropertyValueSource:ValueSource_Variable;
         
         if (mEntityValueSource is ValueSource_Property)
         {
            throw new Error ("mEntityValueSource can't be a ValueSource_Property");
         }
         else if (mEntityValueSource is ValueSource_Variable)
         {
            newEntityValueSource = (mEntityValueSource as ValueSource_Variable).CloneVariableSource (triggerEngine, ownerFunctionDefinition, callingFunctionDeclaration, paramIndex);
         }
         else
         {
            newEntityValueSource = mEntityValueSource.CloneSource ();
         }
         
         // in fact, "newPropertyValueSource = mPropertyValueSource.CloneSource () as ValueSource_Variable;" is ok
         newPropertyValueSource = mPropertyValueSource.CloneVariableSource (triggerEngine, ownerFunctionDefinition, callingFunctionDeclaration, paramIndex) as ValueSource_Variable;
         
         return new ValueSource_Property (newEntityValueSource, newPropertyValueSource);
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
   }
}

