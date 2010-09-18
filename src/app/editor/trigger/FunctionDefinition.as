package editor.trigger {
   
   import flash.utils.ByteArray;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionTypeDefine;
   
   public class FunctionDefinition
   {
      public var mTriggerEngine:TriggerEngine;
      
      public var mFunctionDeclaration:FunctionDeclaration;
      
      public var mInputVariableSpace:VariableSpaceInput;
      
      public var mOutputVariableSpace:VariableSpaceOutput;
      
      public var mLocalVariableSpace:VariableSpaceLocal;
      
      public function FunctionDefinition (triggerEngine:TriggerEngine, functionDeclatation:FunctionDeclaration = null)
      {
         mTriggerEngine = triggerEngine;
         
         mFunctionDeclaration = functionDeclatation;
         
         mInputVariableSpace = new VariableSpaceInput (mTriggerEngine);
         
         if (mFunctionDeclaration != null)
         {
            var num_inputs:int = mFunctionDeclaration.GetNumInputs ();
            for (var i:int = 0; i < num_inputs; ++ i)
               mInputVariableSpace.CreateVariableInstanceFromDefinition (mFunctionDeclaration.GetInputParamDefinitionAt (i));
         }
         
         mOutputVariableSpace = new VariableSpaceOutput (mTriggerEngine);
         
         if (mFunctionDeclaration != null)
         {
            var num_returns:int = mFunctionDeclaration.GetNumOutputs ();
            for (var j:int = 0; j < num_returns; ++ j)
               mOutputVariableSpace.CreateVariableInstanceFromDefinition (mFunctionDeclaration.GetOutputParamDefinitionAt (j));
         }
         
         mLocalVariableSpace = new VariableSpaceLocal (mTriggerEngine);
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function GetFunctionDeclarationId ():int
      {
         if(mFunctionDeclaration == null)
            return -1;
         
         return mFunctionDeclaration.GetID ();
      }
      
      public function GetInputVariableSpace ():VariableSpaceInput
      {
         return mInputVariableSpace;
      }
      
      public function GetOutputVariableSpace ():VariableSpaceOutput
      {
         return mOutputVariableSpace;
      }
      
      public function GetLocalVariableSpace ():VariableSpaceLocal
      {
         return mLocalVariableSpace;
      }
      
      public function ValidateValueSources ():void
      {
      }
      
//==============================================================================
// some shortcuts of declaration properties
//==============================================================================
      
      public function GetDeclarationID ():int
      {
         if (mFunctionDeclaration == null)
            return -1;
         
         return mFunctionDeclaration.GetID ();
      }
      
      public function GetFunctionType ():int 
      {
         if (mFunctionDeclaration == null)
            return FunctionTypeDefine.FunctionType_Unknown;
         
         return mFunctionDeclaration.GetType ();
      }
      
      public function GetName ():String
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetName ();
      }
      
      public function GetDescription ():String
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetDescription ();
      }
      
      public function GetNumInputs ():int
      {
         if (mFunctionDeclaration == null)
            return 0;
         
         return mFunctionDeclaration.GetNumInputs ();
      }
      
      public function GetInputParamDefinitionAt (inputId:int):VariableDefinition
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetInputParamDefinitionAt (inputId);
      }
      
      public function GetInputParamValueType (inputId:int):int
      {
         if (mFunctionDeclaration == null)
            return ValueTypeDefine.ValueType_Void;;
         
         return mFunctionDeclaration.GetInputParamValueType (inputId);
      }
      
      public function GetNumOutputs ():int
      {
         if (mFunctionDeclaration == null)
            return 0;
         
         return mFunctionDeclaration.GetNumOutputs ();
      }
      
      public function GetOutputParamDefinitionAt (outputId:int):VariableDefinition
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetOutputParamDefinitionAt (outputId);
      }
      
      public function GetOutputParamValueType (outputId:int):int
      {
         if (mFunctionDeclaration == null)
            return ValueTypeDefine.ValueType_Void;;
         
         return mFunctionDeclaration.GetOutputParamValueType (outputId);
      }
      
      public function HasInputsWithValueTypeOf (valueType:int):Boolean
      {
         if (mFunctionDeclaration == null)
            return false;
         
         return mFunctionDeclaration.HasInputsWithValueTypeOf (valueType);
      }
      
      public function HasInputsSatisfy (variableDefinition:VariableDefinition):Boolean
      {
         if (mFunctionDeclaration == null)
            return false;
         
         return mFunctionDeclaration.HasInputsSatisfy (variableDefinition);
      }
      
      public function HasOutputsSatisfiedBy (variableDefinition:VariableDefinition):Boolean
      {
         if (mFunctionDeclaration == null)
            return false;
         
         return mFunctionDeclaration.HasOutputsSatisfiedBy (variableDefinition);
      }
   }
}

