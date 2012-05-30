package editor.trigger {

   import flash.utils.Dictionary;
   import editor.entity.Scene;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.ValueAdjuster;
   import common.CoordinateSystem;
   
   import common.TriggerFormatHelper;
   
   public class FunctionCalling
   {
      //public var mTriggerEngine:TriggerEngine;
      
      public var mFunctionDeclaration:FunctionDeclaration;
      
      public var mInputValueSources:Array;
      public var mOutputValueTargets:Array;
      
      protected var mCommentedOff:Boolean = false;
      
      public function FunctionCalling (/*triggerEngine:TriggerEngine, */functionDeclatation:FunctionDeclaration, createDefaultSourcesAndTargets:Boolean = true)
      {
         //mTriggerEngine = triggerEngine;
         
         mFunctionDeclaration = functionDeclatation;
         
         var variable_def:VariableDefinition;
         var i:int;
         
         var num_inputs:int = mFunctionDeclaration.GetNumInputs ();
         mInputValueSources = new Array (num_inputs);
         
         var num_returns:int = mFunctionDeclaration.GetNumOutputs ();
         mOutputValueTargets = new Array (num_returns);
         
         if (createDefaultSourcesAndTargets)
         {
            for (i = 0; i < num_inputs; ++ i)
            {
               variable_def = mFunctionDeclaration.GetInputParamDefinitionAt (i);
               mInputValueSources [i] = variable_def.GetDefaultValueSource (/*mTriggerEngine*/);
            }
            
            for (i = 0; i < num_returns; ++ i)
            {
               variable_def = mFunctionDeclaration.GetOutputParamDefinitionAt (i);
               mOutputValueTargets [i] = variable_def.GetDefaultValueTarget ();
            }
         }
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function GetFunctionType ():int
      {
         return mFunctionDeclaration.GetType ();
      }
      
      public function GetFunctionId ():int
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
         mOutputValueTargets = valueTargets; // best to clone
         
         mSourcesOrTargetsChanged = true;
      }
      
      public function GetOutputValueTarget (returnId:int):ValueTarget
      {
         return mOutputValueTargets [returnId];
      }
      
      public function ValidateValueSourcesAndTargets ():void
      {
         var i:int;
         
         var value_source:ValueSource;
         for (i = 0; i < mInputValueSources.length; ++ i)
         {
            value_source = mInputValueSources [i] as ValueSource;
            
            value_source.ValidateSource ();
         }
         
         var value_target:ValueTarget;
         for (i = 0; i < mOutputValueTargets.length; ++ i)
         {
            value_target = mOutputValueTargets [i] as ValueTarget;
            
            value_target.ValidateTarget ();
         }
      }
      
      // return true if can't be validated
      public function Validate ():Boolean
      {
         return false; // to override
      }
      
      public function IsCommentedOff ():Boolean
      {
         return mCommentedOff;
      }
      
      public function SetCommentedOff (commentedOff:Boolean):void
      {
         mCommentedOff = commentedOff;
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
            
            mCacheCodeString = mFunctionDeclaration.CreateFormattedCallingText (mInputValueSources, mOutputValueTargets);
         }
         
         return mCacheCodeString;
      }
      
//====================================================================
// 
//====================================================================
      
      protected function CloneShell ():FunctionCalling
      {
         return null; // to override
      }
      
      public function Clone (targetFunctionDefinition:FunctionDefinition):FunctionCalling
      {
         var calling:FunctionCalling = new FunctionCalling (/*mTriggerEngine, */mFunctionDeclaration, false);
         
         var i:int;
         var vi:VariableInstance;
         
         var numInputs:int = mInputValueSources.length;
         var sourcesArray:Array = new Array (numInputs);
         var source:ValueSource;
         
         for (i = 0; i < numInputs; ++ i)
         {
            source = mInputValueSources [i] as ValueSource;
            
            sourcesArray [i] = source.CloneSource (/*mTriggerEngine, */targetFunctionDefinition, mFunctionDeclaration, i);
         }
         
         calling.AssignInputValueSources (sourcesArray);
         
         var numOutputs:int = mOutputValueTargets.length;
         var targetsArray:Array = new Array (numOutputs);
         var target:ValueTarget;
         
         for (i = 0; i < numOutputs; ++ i)
         {
            target = mOutputValueTargets [i] as ValueTarget;
            
            targetsArray [i] = target.CloneTarget (/*mTriggerEngine, */targetFunctionDefinition, mFunctionDeclaration, i);
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
      
//====================================================================
//
//====================================================================
      
      public function ConvertRegisterVariablesToGlobalVariables (scene:Scene):void
      {
         var i:int;
         var entityValueSource:ValueSource;
         
         var numInputs:int = mInputValueSources.length;
         for (i = 0; i < numInputs; ++ i)
         {
            var source:ValueSource = mInputValueSources [i] as ValueSource;
            
            if (source is ValueSource_Variable)
            {
               ConvertRegisterVariablesForValueSource (scene, source as ValueSource_Variable);
            }
            else if (source is ValueSource_Property)
            {
               entityValueSource = (source as ValueSource_Property).GetEntityValueSource ();
               if (entityValueSource is ValueSource_Variable)
               {
                  ConvertRegisterVariablesForValueSource (scene, entityValueSource as ValueSource_Variable);
               }
               
               var propertyValueSource:ValueSource = (source as ValueSource_Property).GetPropertyValueSource ();
               if (propertyValueSource is ValueSource_Variable)
               {
                  ConvertRegisterVariablesForValueSource (scene, propertyValueSource as ValueSource_Variable);
               }
            }
         }
         
         var numOutputs:int = mOutputValueTargets.length;
         for (i = 0; i < numOutputs; ++ i)
         {
            var target:ValueTarget = mOutputValueTargets [i] as ValueTarget;
            
            if (target is ValueTarget_Variable)
            {
               ConvertRegisterVariablesForValueTarget (scene, target as ValueTarget_Variable);
            }
            else if (target is ValueTarget_Property)
            {
               entityValueSource = (target as ValueTarget_Property).GetEntityValueSource ();
               if (entityValueSource is ValueSource_Variable)
               {
                  ConvertRegisterVariablesForValueSource (scene, entityValueSource as ValueSource_Variable);
               }
               
               var propertyValueTarget:ValueTarget = (target as ValueTarget_Property).GetPropertyValueTarget ();
               if (propertyValueTarget is ValueTarget_Variable)
               {
                  ConvertRegisterVariablesForValueTarget (scene, propertyValueTarget as ValueTarget_Variable);
               }
            }
         }
      }
      
      private function ConvertRegisterVariablesForValueSource (scene:Scene, variableValueSource:ValueSource_Variable):void
      {
         if (variableValueSource == null)
            return;
         
         var vi:VariableInstance = variableValueSource.GetVariableInstance ();
         if (vi == null)
            return;
         
         if (vi.GetSpaceType () != ValueSpaceTypeDefine.ValueSpace_GlobalRegister)
            return;
         
         variableValueSource.SetVariableInstance (TriggerFormatHelper.RegisterVariable2GlobalVariable (scene, vi));
      }
      
      private function ConvertRegisterVariablesForValueTarget (scene:Scene, variableValueTarget:ValueTarget_Variable):void
      {
         if (variableValueTarget == null)
            return;
         
         var vi:VariableInstance = variableValueTarget.GetVariableInstance ();
         if (vi == null)
            return;
         
         if (vi.GetSpaceType () != ValueSpaceTypeDefine.ValueSpace_GlobalRegister)
            return;
         
         variableValueTarget.SetVariableInstance (TriggerFormatHelper.RegisterVariable2GlobalVariable (scene, vi));
      }
   }
}
