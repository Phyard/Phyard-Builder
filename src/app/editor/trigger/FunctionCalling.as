package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class FunctionCalling
   {
      public var mFunctionDeclaration:FunctionDeclaration;
      public var mInputVariableValueSources:Array;
      
      public function FunctionCalling (functionDeclatation:FunctionDeclaration)
      {
         mFunctionDeclaration = functionDeclatation;
         
         var variable_def:VariableDefinition;
         var num_params:int = mFunctionDeclaration.GetNumParameters ();
         mInputVariableValueSources = new Array (num_params);
         for (var i:int = 0; i < num_params; ++ i)
         {
            variable_def = mFunctionDeclaration.GetParamDefinitionAt (i);
            mInputVariableValueSources [i] = variable_def.GetDefaultDirectValueSource ();
         }
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function SetParamValueSources (valueSources:Array):void
      {
         mInputVariableValueSources = valueSources;
      }
      
      public function GetParamValueSource (paramId:int):VariableValueSource
      {
         return mInputVariableValueSources [paramId];
      }
      
      public function SetParamValueSourceDirect (paramId:int, valueObject:Object):void
      {
         var value_source:VariableValueSource = mInputVariableValueSources [paramId];
         
         if (value_source.GetValueSourceType () != ValueSourceTypeDefine.ValueSource_Direct)
         {
            value_source = new VariableValueSourceDirect (valueObject);
            mInputVariableValueSources [paramId] = value_source;
         }
         else
         {
            (value_source as VariableValueSourceDirect).SetValueObject (valueObject);
         }
      }
      
      public function SetParamValueSourceVariable (paramId:int, variableInstance:VariableInstance):void
      {
         var value_source:VariableValueSource = mInputVariableValueSources [paramId];
         
         if (value_source.GetValueSourceType ()!= ValueSourceTypeDefine.ValueSource_Variable)
         {
            value_source = new VariableValueSourceVariable (variableInstance);
            mInputVariableValueSources [paramId] = value_source;
         }
         else
         {
            (value_source as VariableValueSourceVariable).SetVariableInstance (variableInstance);
         }
      }
      
      public function ValidateValueSources ():void
      {
         var value_source:VariableValueSource;
         for (var i:int = 0; i < mInputVariableValueSources.length; ++ i)
         {
            value_source = mInputVariableValueSources [i] as VariableValueSource;
            
            value_source.Validate ();
         }
      }
      
   }
}

