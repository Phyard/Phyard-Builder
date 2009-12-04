package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class FunctionCalling
   {
      public var mFunctionDeclaration:FunctionDeclaration;
      public var mInputValueSources:Array;
      public var mReturnValueTargets:Array;
      
      public function FunctionCalling (functionDeclatation:FunctionDeclaration)
      {
         mFunctionDeclaration = functionDeclatation;
         
         var variable_def:VariableDefinition;
         var i:int;
         
         var num_inputs:int = mFunctionDeclaration.GetNumInputs ();
         mInputValueSources = new Array (num_inputs);
         
         for (i = 0; i < num_inputs; ++ i)
         {
            variable_def = mFunctionDeclaration.GetParamDefinitionAt (i);
            mInputValueSources [i] = variable_def.GetDefaultValueSource ();
         }
         
         var num_returns:int = mFunctionDeclaration.GetNumOutputs ();
         mReturnValueTargets = new Array (num_returns);
         
         for (i = 0; i < num_returns; ++ i)
         {
            variable_def = mFunctionDeclaration.GetReturnDefinitionAt (i);
            mReturnValueTargets [i] = variable_def.GetDefaultValueTarget ();
         }
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function GetFunctionDeclarationId ():int
      {
         return mFunctionDeclaration.GetID ();
      }
      
      public function GetNumInputs ():int
      {
         return mFunctionDeclaration.GetNumInputs ();
      }
      
      public function SetInputValueSources (valueSources:Array):void
      {
         mInputValueSources = valueSources; // best to clone
      }
      
      public function GetInputValueSource (inputId:int):ValueSource
      {
         return mInputValueSources [inputId];
      }
      
      public function GetNumOutputs ():int
      {
         return mFunctionDeclaration.GetNumOutputs ();
      }
      
      public function SetReturnValueTargets (valueTargets:Array):void
      {
         mReturnValueTargets = valueTargets; // best to clone
      }
      
      public function GetReturnValueTarget (returnId:int):ValueTarget
      {
         return mReturnValueTargets [returnId];
      }
      
      public function SetParamValueSourceDirect (inputId:int, valueObject:Object):void
      {
         var value_source:ValueSource = mInputValueSources [inputId];
         
         if (value_source.GetValueSourceType () != ValueSourceTypeDefine.ValueSource_Direct)
         {
            value_source = new ValueSource_Direct (valueObject);
            mInputValueSources [inputId] = value_source;
         }
         else
         {
            (value_source as ValueSource_Direct).SetValueObject (valueObject);
         }
      }
      
      public function SetParamValueSourceVariable (inputId:int, variableInstance:VariableInstance):void
      {
         var value_source:ValueSource = mInputValueSources [inputId];
         
         if (value_source.GetValueSourceType ()!= ValueSourceTypeDefine.ValueSource_Variable)
         {
            value_source = new ValueSource_Variable (variableInstance);
            mInputValueSources [inputId] = value_source;
         }
         else
         {
            (value_source as ValueSource_Variable).SetVariableInstance (variableInstance);
         }
      }
      
      public function ValidateValueSources ():void
      {
         var value_source:ValueSource;
         for (var i:int = 0; i < mInputValueSources.length; ++ i)
         {
            value_source = mInputValueSources [i] as ValueSource;
            
            value_source.ValidateSource ();
         }
      }
      
   }
}

