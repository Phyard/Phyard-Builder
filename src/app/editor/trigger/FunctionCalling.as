package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.ValueAdjuster;
   import common.CoordinateSystem;
   
   public class FunctionCalling
   {
      public var mFunctionDeclaration:FunctionDeclaration;
      public var mInputValueSources:Array;
      public var mReturnValueTargets:Array;
      
      public function FunctionCalling (functionDeclatation:FunctionDeclaration, createDefaultSourcesAndTargets:Boolean = true)
      {
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
               mInputValueSources [i] = variable_def.GetDefaultValueSource ();
            }
            
            for (i = 0; i < num_returns; ++ i)
            {
               variable_def = mFunctionDeclaration.GetOuputParamDefinitionAt (i);
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
      
      public static function CreateCodeString (functionDeclaration:FunctionDeclaration, valueSources:Array, valueTargets:Array):String
      {
         var i:int;
         var vi:VariableInstance;
         
         var numInputs:int = (valueSources == null ? 0 : valueSources.length);
         var source:ValueSource;
         
         var sourcesString:String = " (";
         if (numInputs > 0)
         {
            source = valueSources [0] as ValueSource;
            sourcesString = sourcesString + source.ToCodeString ();
         }
         for (i = 1; i < numInputs; ++ i)
         {
            source = valueSources [i] as ValueSource;
            sourcesString = sourcesString + ", " + source.ToCodeString ();
         }
         sourcesString = sourcesString + ")";
         
         var numOutputs:int = (valueTargets == null ? 0 : valueTargets.length);
         var target:ValueTarget;
         
         if (numOutputs == 0)
            return functionDeclaration.GetCodeName () + sourcesString;
         
         target = valueTargets [0] as ValueTarget;
         var targetString:String = target.ToCodeString ();
         
         if (numOutputs == 1)
         {
            targetString = targetString + " = ";
         }
         else
         {
            targetString = "{" + targetString;
            
            for (i = 1; i < numOutputs; ++ i)
            {
               target = valueTargets [i] as ValueTarget;
               targetString = targetString + ", " + target.ToCodeString ();
            }
            targetString = targetString + "} = ";
         }
         
         return targetString + functionDeclaration.GetCodeName () + sourcesString;
      }
      
      private var mSourcesOrTargetsChanged:Boolean = true;
      private var mCacheCodeString:String = null;
      public function ToCodeString ():String
      {
         if (mSourcesOrTargetsChanged)
         {
            mSourcesOrTargetsChanged = false;
            
            mCacheCodeString = CreateCodeString (mFunctionDeclaration, mInputValueSources, mReturnValueTargets);
         }
         
         return mCacheCodeString;
      }
      
//====================================================================
// 
//====================================================================
      
      public function Clone (ownerFunctionDefinition:FunctionDefinition):FunctionCalling
      {
         var calling:FunctionCalling = new FunctionCalling (mFunctionDeclaration, false);
         
         var i:int;
         var vi:VariableInstance;
         
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
               switch (vi.GetSpaceType ())
               {
                  case ValueSpaceTypeDefine.ValueSpace_Input:
                     vi = ownerFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Output:
                     vi = ownerFunctionDefinition.GetReturnVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     break;
                  default:
                     break;
               }
               
               sourcesArray [i] = new ValueSource_Variable (vi);
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
               switch (vi.GetSpaceType ())
               {
                  case ValueSpaceTypeDefine.ValueSpace_Input:
                     vi = ownerFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Output:
                     vi = ownerFunctionDefinition.GetReturnVariableSpace ().GetVariableInstanceAt (vi.GetIndex ());
                     break;
                  default:
                     break;
               }
               
               targetsArray [i] = new ValueTarget_Variable (vi);
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
