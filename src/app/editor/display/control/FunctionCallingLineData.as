
package editor.display.control {
   
   //import editor.trigger.TriggerEngine;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.VariableDefinition;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionDeclaration_Core;
   import editor.trigger.FunctionDeclaration_Custom;
   import editor.trigger.FunctionCalling;
   import editor.trigger.ValueSource;
   import editor.trigger.ValueTarget;
   
   import editor.entity.Scene;
   
   import editor.EditorContext;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.parse.FunctionCallingLineInfo;
   
   public class FunctionCallingLineData
   {
      public static const kPattern1:RegExp = /&/g;
      public static const kReplace1:String = "&amp;";
      public static const kPattern2:RegExp = /</g;
      public static const kReplace2:String = "&lt;";
   
   //=================
   
      public var mInfo:FunctionCallingLineInfo = new FunctionCallingLineInfo ();
      
      public function UpdateCodeLineText ():Boolean
      {
         if (mInfo.mHtmlText == null)
         {
            mInfo.mHtmlText = mFuncDeclaration.CreateFormattedCallingText (mCurrentValueSources, mCurrentValueTargets);
            
            //mInfo.mHtmlText = mInfo.mHtmlText.replace (kPattern1, kReplace1);
            //mInfo.mHtmlText = mInfo.mHtmlText.replace (kPattern2, kReplace2);
            
            mInfo.mIndentChanged = false;
            
            return true;
         }
         else if (mInfo.mIndentChanged)
         {
            mInfo.mIndentChanged = false;
            
            return true;
         }
         else
         {
            return false;
         }
      }
      
      public function get mIsValid ():Boolean
      {
         return mInfo.mIsValid;
      }
      
      public function get mLineNumber ():int
      {
         return mInfo.mLineNumber;
      }
      
      public function get mFunctionId ():int
      {
         return mInfo.mFunctionId;
      }
      
      public function get mHtmlText ():String
      {
         return mInfo.mHtmlText;
      }
      
      public function get mIndentLevel ():int
      {
         return mInfo.mIndentLevel;
      }
      
      public function get mCommentDepth ():int
      {
         return mInfo.mCommentDepth;
      }
      
      public function ChangeCommentDepth (deltaDepth:int):void
      {
         var newDepth:int = mInfo.mCommentDepth + deltaDepth;
         
         if (newDepth < 0)
            mInfo.mCommentDepth = 0;
         else if (newDepth > 255)
            mInfo.mCommentDepth = 255;
         else
            mInfo.mCommentDepth = newDepth;
      }
      
      // ...
      
      public var mFuncDeclaration:FunctionDeclaration;
      
      public var mInitialValueSources:Array;
      public var mInitialValueTargets:Array;
      
      public var mCurrentValueSources:Array;
      public var mCurrentValueTargets:Array;
      
      public var mInputVariableDefinitions:Array;
      public var mOutputVariableDefinitions:Array;
      
      public function SetFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         mFuncDeclaration = funcDeclaration;
         mInfo.mFunctionId = funcDeclaration.GetID ();
         mInfo.mIsCoreDeclaration = mFuncDeclaration is FunctionDeclaration_Core;
         
         if (mFuncDeclaration is FunctionDeclaration_Custom)
         {
            var numInputs:int = mFuncDeclaration.GetNumInputs ();
            var numOutputs:int = mFuncDeclaration.GetNumOutputs ();
            
            mInputVariableDefinitions = new Array (numInputs);
            mOutputVariableDefinitions = new Array (numOutputs);
            
            var i:int;
            
            for (i = 0; i < numInputs; ++ i)
            {
               mInputVariableDefinitions [i] = mFuncDeclaration.GetInputParamDefinitionAt (i);
            }
            
            for (i = 0; i < numOutputs; ++ i)
            {
               mOutputVariableDefinitions [i] = mFuncDeclaration.GetOutputParamDefinitionAt (i);
            }
         }
      }
      
      public function BuildFromFunctionDeclaration (scene:Scene, funcDeclaration:FunctionDeclaration, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition):void
      {
         SetFunctionDeclaration (funcDeclaration);
         
         var initialValueSources:Array = new Array ();
         var currentValueSources:Array = new Array ();
         var initialReturnTargets:Array = new Array ();
         var currentReturnTargets:Array = new Array ();
         
         var variableDefinition:VariableDefinition;
         
         var j:int;
         var valueSource:ValueSource;
         var valueTarget:ValueTarget;
         
         for (j = 0; j < funcDeclaration.GetNumInputs (); ++ j)
         {
            variableDefinition = funcDeclaration.GetInputParamDefinitionAt (j);
            valueSource = variableDefinition.GetDefaultValueSource (/*EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ()*/);
            initialValueSources.push (valueSource.CloneSource (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
            currentValueSources.push (valueSource.CloneSource (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
         }
         
         for (j = 0; j < funcDeclaration.GetNumOutputs (); ++ j)
         {
            variableDefinition = funcDeclaration.GetOutputParamDefinitionAt (j);
            valueTarget = variableDefinition.GetDefaultValueTarget ();
            initialReturnTargets.push (valueTarget.CloneTarget (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
            currentReturnTargets.push (valueTarget.CloneTarget (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
         }
         
         mInitialValueSources = initialValueSources;
         mCurrentValueSources = currentValueSources;
         mInitialValueTargets = initialReturnTargets;
         mCurrentValueTargets = currentReturnTargets;
         mInfo.mHtmlText = funcDeclaration.GetName ();
      }
      
      public function BuildFromFunctionCalling (scene:Scene, funcCalling:FunctionCalling, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition):void
      {
         var funcDeclaration:FunctionDeclaration = funcCalling.GetFunctionDeclaration ();
         SetFunctionDeclaration (funcDeclaration);
         mInfo.mCommentDepth = funcCalling.GetCommentDepth ();
         
         var initialValueSources:Array = new Array ();
         var currentValueSources:Array = new Array ();
         var initialReturnTargets:Array = new Array ();
         var currentReturnTargets:Array = new Array ();
         
         var j:int;
         var valueSource:ValueSource;
         var valueTarget:ValueTarget
         
         for (j = 0; j < funcDeclaration.GetNumInputs (); ++ j)
         {
            valueSource = funcCalling.GetInputValueSource (j);
            
            initialValueSources.push (valueSource.CloneSource (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
            currentValueSources.push (valueSource.CloneSource (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
         }
         
         for (j = 0; j < funcDeclaration.GetNumOutputs (); ++ j)
         {
            valueTarget = funcCalling.GetOutputValueTarget (j);
            
            initialReturnTargets.push (valueTarget.CloneTarget (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
            currentReturnTargets.push (valueTarget.CloneTarget (scene, /*triggerEngine, */targetFunctionDefinition, funcDeclaration, j));
         }
         
         mInitialValueSources = initialValueSources;
         mCurrentValueSources = currentValueSources;
         mInitialValueTargets = initialReturnTargets;
         mCurrentValueTargets = currentReturnTargets;
         
         //UpdateCodeLineText ();
      }
      
      public function NotifyParametersModified ():void
      {
         mInfo.mHtmlText = null;
         UpdateCodeLineText ();
      }
      
      public function Validate (functionDeclaration:FunctionDeclaration):void
      {
         if (functionDeclaration != mFuncDeclaration)
            return;
         
      // ...
         
         if (mFuncDeclaration is FunctionDeclaration_Custom)
         {
            var customfunctionDeclatation:FunctionDeclaration_Custom = mFuncDeclaration as FunctionDeclaration_Custom;
            
            var numInputs:int = customfunctionDeclatation.GetNumInputs ();
            var numOutputs:int = customfunctionDeclatation.GetNumOutputs ();
            
            var newInitialInputValueSources:Array = new Array (numInputs);
            var newInitialOutputValueTargets:Array = new Array (numOutputs);
            
            var newCurrentInputValueSources:Array = new Array (numInputs);
            var newCurrentOutputValueTargets:Array = new Array (numOutputs);
            
            var newInputVariableDefinitions:Array = new Array (numInputs);
            var newOutputVariableDefinitions:Array = new Array (numOutputs);
            
            var i:int;
            var index:int;
            var variableDefinition:VariableDefinition;
            
            for (i = 0; i < numInputs; ++ i)
            {
               variableDefinition = customfunctionDeclatation.GetInputParamDefinitionAt (i);
               
               index = mInputVariableDefinitions.indexOf (variableDefinition);
               if (index >= 0)
               {
                  newInitialInputValueSources [i] = mInitialValueSources [index];
                  newCurrentInputValueSources [i] = mCurrentValueSources [index];
               }
               else
               {
                  newInitialInputValueSources [i] = variableDefinition.GetDefaultValueSource (/*EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ()*/);
                  newCurrentInputValueSources [i] = variableDefinition.GetDefaultValueSource (/*EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ()*/);
               }
               
               newInputVariableDefinitions [i] = variableDefinition;
            }
            
            for (i = 0; i < numOutputs; ++ i)
            {
               variableDefinition = customfunctionDeclatation.GetOutputParamDefinitionAt (i);
               
               index = mOutputVariableDefinitions.indexOf (variableDefinition);
               if (index >= 0)
               {
                  newInitialOutputValueTargets [i] = mInitialValueTargets [index];
                  newCurrentOutputValueTargets [i] = mCurrentValueTargets [index];
               }
               else
               {
                  newInitialOutputValueTargets [i] = variableDefinition.GetDefaultValueTarget ();
                  newCurrentOutputValueTargets [i] = variableDefinition.GetDefaultValueTarget ();
               }
               
               newOutputVariableDefinitions [i] = variableDefinition;
            }
            
            mInitialValueSources = newInitialInputValueSources;
            mInitialValueTargets = newInitialOutputValueTargets;
            
            mCurrentValueSources = newCurrentInputValueSources;
            mCurrentValueTargets = newCurrentOutputValueTargets;
            
            mInputVariableDefinitions = newInputVariableDefinitions;
            mOutputVariableDefinitions = newOutputVariableDefinitions;
         }
         
      // ...
         
         mInfo.mHtmlText = null;
         UpdateCodeLineText ();
      }
      
      public var mValueSourceParentControls:Array;
      public var mValueSourceControls:Array;
      public var mValueTargetParentControls:Array;
      public var mValueTargetControls:Array;
   }
}
