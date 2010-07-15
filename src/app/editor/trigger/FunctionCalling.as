package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.ValueAdjuster;
   import common.CoordinateSystem;
   
   public class FunctionCalling
   {
      public var mTriggerEngine:TriggerEngine;
      
      public var mFunctionDeclaration:FunctionDeclaration;
      
      public var mInputValueSources:Array;
      public var mReturnValueTargets:Array;
      
      public function FunctionCalling (triggerEngine:TriggerEngine, functionDeclatation:FunctionDeclaration, createDefaultSourcesAndTargets:Boolean = true)
      {
         mTriggerEngine = triggerEngine;
         
         mFunctionDeclaration = functionDeclatation;
         
         var variable_def:VariableDefinition;
         var i:int;
         
         var num_inputs:int = mFunctionDeclaration.GetNumInputs ();
         mInputValueSources = new Array (num_inputs);
         
         var num_returns:int = mFunctionDeclaration.GetNumOutputs ();
         mReturnValueTargets = new Array (num_returns);
         
         if (createDefaultSourcesAndTargets)
         {
            for (i = 0; i < num_inputs; ++ i)
            {
               variable_def = mFunctionDeclaration.GetInputParamDefinitionAt (i);
               mInputValueSources [i] = variable_def.GetDefaultValueSource (mTriggerEngine);
            }
            
            for (i = 0; i < num_returns; ++ i)
            {
               variable_def = mFunctionDeclaration.GetOutputParamDefinitionAt (i);
               mReturnValueTargets [i] = variable_def.GetDefaultValueTarget ();
            }
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
      
      public function AssignInputValueSources (valueSources:Array):void
      {
         mInputValueSources = valueSources; // best to clone
         
         mSourcesOrTargetsChanged = true;
      }
      
      public function GetInputValueSource (inputId:int):ValueSource
      {
         return mInputValueSources [inputId];
      }
      
      public function GetNumOutputs ():int
      {
         return mFunctionDeclaration.GetNumOutputs ();
      }
      
      public function AssignOutputValueTargets (valueTargets:Array):void
      {
         mReturnValueTargets = valueTargets; // best to clone
         
         mSourcesOrTargetsChanged = true;
      }
      
      public function GetReturnValueTarget (returnId:int):ValueTarget
      {
         return mReturnValueTargets [returnId];
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
      
//====================================================================
// 
//====================================================================
      
      private var mSourcesOrTargetsChanged:Boolean = true;
      private var mCacheCodeString:String = null;
      public function ToCodeString ():String
      {
         if (mSourcesOrTargetsChanged)
         {
            mSourcesOrTargetsChanged = false;
            
            mCacheCodeString = mFunctionDeclaration.CreateFormattedCallingText (mInputValueSources, mReturnValueTargets);
         }
         
         return mCacheCodeString;
      }
      
//====================================================================
// 
//====================================================================
      
      public function Clone (ownerFunctionDefinition:FunctionDefinition):FunctionCalling
      {
         var calling:FunctionCalling = new FunctionCalling (mTriggerEngine, mFunctionDeclaration, false);
         
         var i:int;
         var vi:VariableInstance;
         
         var variableDefinition:VariableDefinition;
         var done:Boolean;
         
         var numInputs:int = mInputValueSources.length;
         var sourcesArray:Array = new Array (numInputs);
         var source:ValueSource;
         
         for (i = 0; i < numInputs; ++ i)
         {
            source = mInputValueSources [i] as ValueSource;
            
            if (source is ValueSource_Direct)
            {
               sourcesArray [i] = new ValueSource_Direct ((source as ValueSource_Direct).GetValueObject ());
            }
            else if (source is ValueSource_Variable)
            {
               vi = (source as ValueSource_Variable).GetVariableInstance ();
               
               done = false;
               
               switch (vi.GetSpaceType ())
               {
                  case ValueSpaceTypeDefine.ValueSpace_Input:
                     variableDefinition = ownerFunctionDefinition.GetInputParamDefinitionAt (vi.GetIndex ());
                     
                     if (variableDefinition == null || variableDefinition.GetValueType () != vi.GetValueType ())
                     {
                        done = true;
                        sourcesArray [i] = mFunctionDeclaration.GetInputParamDefinitionAt (i).GetDefaultValueSource (mTriggerEngine);
                     }
                     else
                     {
                        vi = ownerFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     }
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Output:
                     variableDefinition = ownerFunctionDefinition.GetOutputParamDefinitionAt (vi.GetIndex ());
                     
                     if (variableDefinition == null || variableDefinition.GetValueType () != vi.GetValueType ())
                     {
                        done = true;
                        sourcesArray [i] = mFunctionDeclaration.GetOutputParamDefinitionAt (i).GetDefaultNullValueTarget ();
                     }
                     else
                     {
                        vi = ownerFunctionDefinition.GetReturnVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     }
                     break;
                  default:
                     break;
               }
               
               if (! done)
               {
                  sourcesArray [i] = new ValueSource_Variable (vi);
               }
            }
            else
            {
               sourcesArray [i] = new ValueSource_Null ();
            }
         }
         calling.AssignInputValueSources (sourcesArray);
         
         var numOutputs:int = mReturnValueTargets.length;
         var targetsArray:Array = new Array (numOutputs);
         var target:ValueTarget;
         for (i = 0; i < numOutputs; ++ i)
         {
            target = mReturnValueTargets [i] as ValueTarget;
            
            if (target is ValueTarget_Variable)
            {
               vi = (target as ValueTarget_Variable).GetVariableInstance ();
               
               done = false;
               
               switch (vi.GetSpaceType ())
               {
                  case ValueSpaceTypeDefine.ValueSpace_Input:
                     variableDefinition = ownerFunctionDefinition.GetInputParamDefinitionAt (vi.GetIndex ());
                     
                     if (variableDefinition == null || variableDefinition.GetValueType () != vi.GetValueType ())
                     {
                        done = true;
                        targetsArray [i] = mFunctionDeclaration.GetInputParamDefinitionAt (i).GetDefaultValueSource (mTriggerEngine);
                     }
                     else
                     {
                        vi = ownerFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     }
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Output:
                     variableDefinition = ownerFunctionDefinition.GetOutputParamDefinitionAt (vi.GetIndex ());
                     
                     if (variableDefinition == null || variableDefinition.GetValueType () != vi.GetValueType ())
                     {
                        done = true;
                        targetsArray [i] = mFunctionDeclaration.GetOutputParamDefinitionAt (i).GetDefaultNullValueTarget ();
                     }
                     else
                     {
                        vi = ownerFunctionDefinition.GetReturnVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     }
                     break;
                  default:
                     break;
               }
               
               if (! done)
               {
                  targetsArray [i] = new ValueTarget_Variable (vi);
               }
            }
            else
            {
               targetsArray [i] = new ValueTarget_Null ();
            }
         }
         calling.AssignOutputValueTargets (targetsArray);
         
         return calling;
      }
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var numInputs:int = mInputValueSources.length;
         var source:ValueSource;
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberUsage:int;
         for (i = 0; i < numInputs; ++ i)
         {
            valueType = mFunctionDeclaration.GetInputParamValueType (i);
            source = mInputValueSources [i] as ValueSource;
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.GetValueObject ());
               numberUsage = mFunctionDeclaration.GetInputNumberTypeUsage (i);
               
               directSource.SetValueObject (coordinateSystem.D2P (directValue, numberUsage));
            }
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var numInputs:int = mInputValueSources.length;
         var source:ValueSource;
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberUsage:int;
         for (i = 0; i < numInputs; ++ i)
         {
            valueType = mFunctionDeclaration.GetInputParamValueType (i);
            source = mInputValueSources [i] as ValueSource;
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.GetValueObject ());
               numberUsage = mFunctionDeclaration.GetInputNumberTypeUsage (i);
               
               directSource.SetValueObject (coordinateSystem.P2D (directValue, numberUsage));
            }
         }
      }
      
      public function AdjustNumberPrecisions ():void
      {
         var i:int;
         var numInputs:int = mInputValueSources.length;
         var source:ValueSource;
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberDetail:int;
         for (i = 0; i < numInputs; ++ i)
         {
            source = mInputValueSources [i] as ValueSource;
            valueType = mFunctionDeclaration.GetInputParamValueType (i);
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.GetValueObject ());
               numberDetail = mFunctionDeclaration.GetInputNumberTypeDetail (i);
               
               switch (numberDetail)
               {
                  case ValueTypeDefine.NumberTypeDetail_Single:
                     directValue = ValueAdjuster.Number2Precision (directValue, 6);
                     break;
                  case ValueTypeDefine.NumberTypeDetail_Integer:
                     directValue = Math.round (directValue);
                     break;
                  case ValueTypeDefine.NumberTypeDetail_Double:
                  default:
                     directValue = ValueAdjuster.Number2Precision (directValue, 12);
                     break;
               }
               
               directSource.SetValueObject (directValue);
            }
         }
      }
   }
}
