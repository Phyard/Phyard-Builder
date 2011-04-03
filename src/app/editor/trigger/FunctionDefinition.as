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
      
      public var mPure:Boolean = false;
      
      public function FunctionDefinition (triggerEngine:TriggerEngine, functionDeclatation:FunctionDeclaration, isPure:Boolean = false, toDiscardedDefinition:FunctionDefinition = null)
      {
         mTriggerEngine = triggerEngine;
         
         mFunctionDeclaration = functionDeclatation;
         
         mPure = isPure;
         
         if (toDiscardedDefinition == null)
         {
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
         else
         {
            // the toDiscardedDefinition must have the same proto type as the new FunctionDefinition.
            
            mInputVariableSpace = toDiscardedDefinition.GetInputVariableSpace ();
            mOutputVariableSpace = toDiscardedDefinition.GetOutputVariableSpace ();
            mLocalVariableSpace = toDiscardedDefinition.GetLocalVariableSpace ();
         }
      }
      
      public function IsPure ():Boolean
      {
         return mPure;
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
      
      public function ValidateValueSourcesAndTargets ():void
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
      
      public function HasOutputsSatisfiedBy (variableDefinition:VariableDefinition):Boolean
      {
         if (mFunctionDeclaration == null)
            return false;
         
         return mFunctionDeclaration.HasOutputsSatisfiedBy (variableDefinition);
      }
      
      public function GetNumLocalVariables ():int
      {
         if (mLocalVariableSpace == null)
            return 0;
         
         return mLocalVariableSpace.GetNumVariableInstances ();
      }
      
      public function GetLocalVariableDefinitionAt (localId:int):VariableDefinition
      {
         if (mLocalVariableSpace == null)
            return null;
         
         var vi:VariableInstance = mLocalVariableSpace.GetVariableInstanceAt (localId);
         
         return vi.IsNull () ? null : vi.GetVariableDefinition ();
      }
      
      public function GetLocalVariableValueType (localId:int):int
      {
         if (mLocalVariableSpace == null)
            return ValueTypeDefine.ValueType_Void;
         
         var vi:VariableInstance = mLocalVariableSpace.GetVariableInstanceAt (localId);
         
         return vi.GetValueType ();
      }
      
      public function HasLocalVariablesSatisfiedBy (variableDefinition:VariableDefinition):Boolean
      {
         if (mLocalVariableSpace == null)
            return false;
         
         return mLocalVariableSpace.HasVariablesSatisfiedBy (variableDefinition);
      }
      
//==============================================================================
// it best to merge difinition with declaration (cancelled, not a good idea)
//==============================================================================
      
      public function HasSameDeclarationWith (functionDefinition:FunctionDefinition):Boolean
      {
         return mFunctionDeclaration == functionDefinition.GetFunctionDeclaration ();
         
         // todo: it is possible return true if mFunctionDeclaration != functionDefinition.GetFunctionDeclaration ()
      }
      
      public function SybchronizeDeclarationWithDefinition ():void
      {
         var functionDecl:FunctionDeclaration_Custom = mFunctionDeclaration as FunctionDeclaration_Custom;
         if (functionDecl == null)
            return;
         
         var i:int;
         
         var inputDefinitions:Array = new Array ();
         
         var num_inputs:int = mInputVariableSpace.GetNumVariableInstances ();
         for (i = 0; i < num_inputs; ++ i)
         {
            inputDefinitions.push (mInputVariableSpace.GetVariableInstanceAt (i).GetVariableDefinition ());
         }
         
         var outputDefinitions:Array = new Array ();
         
         var num_outputs:int = mOutputVariableSpace.GetNumVariableInstances ();
         for (i = 0; i < num_outputs; ++ i)
         {
            outputDefinitions.push (mOutputVariableSpace.GetVariableInstanceAt (i).GetVariableDefinition ());
         }
         
         functionDecl.SetInputParamDefinitions (inputDefinitions);
         functionDecl.SetOutputParamDefinitions (outputDefinitions);
         
         functionDecl.IncreaseModifiedTimes ();
         
         functionDecl.ParseAllCallingTextSegments ();
      }
      
//==============================================================================
// clone
//==============================================================================
      
      public function Clone ():FunctionDefinition
      {
         SybchronizeDeclarationWithDefinition ();
         
         var newFuncDefinition:FunctionDefinition;
         
         if ((mFunctionDeclaration is FunctionDeclaration_Custom))
         {
            newFuncDefinition = new FunctionDefinition (mTriggerEngine, (mFunctionDeclaration as FunctionDeclaration_Custom).Clone (), mPure);
            
            newFuncDefinition.SybchronizeDeclarationWithDefinition ();
         }
         else
         {
            newFuncDefinition = new FunctionDefinition (mTriggerEngine, mFunctionDeclaration, mPure);
         }
         
         var num_locals:int = mLocalVariableSpace.GetNumVariableInstances ();
         var vi:VariableInstance;
         var newVi:VariableInstance;
         for (var j:int = 0; j < num_locals; ++ j)
         {
            vi = mLocalVariableSpace.GetVariableInstanceAt (j);
            
            newFuncDefinition.GetLocalVariableSpace ().CreateVariableInstanceFromDefinition (vi.GetVariableDefinition ().Clone ());
            newVi = newFuncDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (j);
            newVi.SetValueObject (vi.GetValueObject ());
         }
         
         return newFuncDefinition;
      }
   }
}

