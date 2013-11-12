package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   import common.ValueAdjuster;
   import common.CoordinateSystem;
   
   import editor.EditorContext;
   
   public class FunctionCalling_Custom extends FunctionCalling
   {
      public var mInputVariableDefinitions:Array;
      public var mOutputVariableDefinitions:Array;
      
      public var mCustomfunctionDeclatation:FunctionDeclaration_Custom;
      
      public function FunctionCalling_Custom (/*triggerEngine:TriggerEngine, */customfunctionDeclatation:FunctionDeclaration_Custom, createDefaultSourcesAndTargets:Boolean = true)
      {
         super (/*triggerEngine, */customfunctionDeclatation, createDefaultSourcesAndTargets);
         
         mCustomfunctionDeclatation = customfunctionDeclatation;
         
         // ...
         
         mLastModifiedTimesOfFunctionDeclaration = mCustomfunctionDeclatation.GetNumModifiedTimes ();
         
         var numInputs:int = mCustomfunctionDeclatation.GetNumInputs ();
         var numOutputs:int = mCustomfunctionDeclatation.GetNumOutputs ();
         
         mInputVariableDefinitions = new Array (numInputs);
         mOutputVariableDefinitions = new Array (numOutputs);
         
         var i:int;
         
         for (i = 0; i < numInputs; ++ i)
         {
            mInputVariableDefinitions [i] = mCustomfunctionDeclatation.GetInputParamDefinitionAt (i);
         }
         
         for (i = 0; i < numOutputs; ++ i)
         {
            mOutputVariableDefinitions [i] = mCustomfunctionDeclatation.GetOutputParamDefinitionAt (i);
         }
      }
      
      override protected function CloneShell ():FunctionCalling
      {
         return new FunctionCalling_Custom (/*mTriggerEngine, */mCustomfunctionDeclatation, false);
      }
      
      private var mLastModifiedTimesOfFunctionDeclaration:int;
      
      // return true if can't be validated
      override public function Validate ():Boolean
      {
         if (mCustomfunctionDeclatation.IsRemoved ())
         {
            return true;
         }
         
         if (mLastModifiedTimesOfFunctionDeclaration < mCustomfunctionDeclatation.GetNumModifiedTimes ())
         {
            mLastModifiedTimesOfFunctionDeclaration = mCustomfunctionDeclatation.GetNumModifiedTimes ();
            
            var numInputs:int = mCustomfunctionDeclatation.GetNumInputs ();
            var numOutputs:int = mCustomfunctionDeclatation.GetNumOutputs ();
            
            var newInputValueSources:Array = new Array (numInputs);
            var newOutputValueSources:Array = new Array (numOutputs);
            
            var newInputVariableDefinitions:Array = new Array (numInputs);
            var newOutputVariableDefinitions:Array = new Array (numOutputs);
            
            var i:int;
            var index:int;
            var variableDefinition:VariableDefinition;
            
            for (i = 0; i < numInputs; ++ i)
            {
               variableDefinition = mCustomfunctionDeclatation.GetInputParamDefinitionAt (i);
               
               index = mInputVariableDefinitions.indexOf (variableDefinition);
               if (index >= 0)
                  newInputValueSources [i] = mInputValueSources [index];
               else
                  newInputValueSources [i] = variableDefinition.GetDefaultValueSource (/*EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ()*/);
               
               newInputVariableDefinitions [i] = variableDefinition;
            }
            
            for (i = 0; i < numOutputs; ++ i)
            {
               variableDefinition = mCustomfunctionDeclatation.GetOutputParamDefinitionAt (i);
               
               index = mOutputVariableDefinitions.indexOf (variableDefinition);
               if (index >= 0)
                  newOutputValueSources [i] = mOutputValueTargets [index];
               else
                  newOutputValueSources [i] = variableDefinition.GetDefaultValueTarget ();
               
               newOutputVariableDefinitions [i] = variableDefinition;
            }
            
            mInputValueSources = newInputValueSources;
            mOutputValueTargets = newOutputValueSources;
            
            mInputVariableDefinitions = newInputVariableDefinitions;
            mOutputVariableDefinitions = newOutputVariableDefinitions;
         }
         
         return false;
      }
      
   }
}
