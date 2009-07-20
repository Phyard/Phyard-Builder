package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class FunctionCalling
   {
      public var mFunctionDeclaration:FunctionDeclaration;
      public var mInputValueSources:Array;
      
      public function FunctionCalling (functionDeclatation:FunctionDeclaration)
      {
         mFunctionDeclaration = functionDeclatation;
         
         var variable_def:VariableDefinition;
         var num_params:int = mFunctionDeclaration.GetNumParameters ();
         mInputValueSources = new Array (num_params);
         for (var i:int = 0; i < num_params; ++ i)
         {
            variable_def = mFunctionDeclaration.GetParamDefinitionAt (i);
            mInputValueSources [i] = variable_def.GetDefaultDirectValueSource ();
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
      
      public function GetNumParameters ():int
      {
         return mFunctionDeclaration.GetNumParameters ();
      }
      
      public function SetParamValueSources (valueSources:Array):void
      {
         mInputValueSources = valueSources;
      }
      
      public function GetParamValueSource (paramId:int):ValueSource
      {
         return mInputValueSources [paramId];
      }
      
      public function SetParamValueSourceDirect (paramId:int, valueObject:Object):void
      {
         var value_source:ValueSource = mInputValueSources [paramId];
         
         if (value_source.GetValueSourceType () != ValueSourceTypeDefine.ValueSource_Direct)
         {
            value_source = new ValueSourceDirect (valueObject);
            mInputValueSources [paramId] = value_source;
         }
         else
         {
            (value_source as ValueSourceDirect).SetValueObject (valueObject);
         }
      }
      
      public function SetParamValueSourceVariable (paramId:int, variableInstance:VariableInstance):void
      {
         var value_source:ValueSource = mInputValueSources [paramId];
         
         if (value_source.GetValueSourceType ()!= ValueSourceTypeDefine.ValueSource_Variable)
         {
            value_source = new ValueSourceVariable (variableInstance);
            mInputValueSources [paramId] = value_source;
         }
         else
         {
            (value_source as ValueSourceVariable).SetVariableInstance (variableInstance);
         }
      }
      
      public function ValidateValueSources ():void
      {
         var value_source:ValueSource;
         for (var i:int = 0; i < mInputValueSources.length; ++ i)
         {
            value_source = mInputValueSources [i] as ValueSource;
            
            value_source.Validate ();
         }
      }
      
   }
}

