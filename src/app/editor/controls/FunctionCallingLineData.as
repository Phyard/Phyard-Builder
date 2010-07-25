
package editor.controls {
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.VariableDefinition;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionCalling;
   import editor.trigger.ValueSource;
   import editor.trigger.ValueTarget;
   
   import editor.runtime.Runtime;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.parse.FunctionCallingLineInfo;
   
   public class FunctionCallingLineData
   {
      public var mInfo:FunctionCallingLineInfo = new FunctionCallingLineInfo ();
      
      public function UpdateCodeLineText ():Boolean
      {
         if (mInfo.mHtmlText == null)
         {
            mInfo.mHtmlText = mFuncDeclaration.CreateFormattedCallingText (mCurrentValueSources, mCurrentValueTargets);
            
            if (! mInfo.mIsValid)
            {
               mInfo.mHtmlText = "<font color='#A0A0A0'>" + mHtmlText + "</font>"
            }
            
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
      
      // ...
      
      public var mFuncDeclaration:FunctionDeclaration;
      
      public var mInitialValueSources:Array;
      public var mCurrentValueSources:Array;
      public var mInitialValueTargets:Array;
      public var mCurrentValueTargets:Array;
      
      public function SetFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         mFuncDeclaration = funcDeclaration;
         mInfo.mFunctionId = funcDeclaration.GetID ();
      }
      
      public function BuildFromFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
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
            valueSource = variableDefinition.GetDefaultValueSource (Runtime.GetCurrentWorld ().GetTriggerEngine ());
            initialValueSources.push (valueSource.CloneSource ());
            currentValueSources.push (valueSource.CloneSource ());
         }
         
         for (j = 0; j < funcDeclaration.GetNumOutputs (); ++ j)
         {
            variableDefinition = funcDeclaration.GetOutputParamDefinitionAt (j);
            valueTarget = variableDefinition.GetDefaultValueTarget ();
            initialReturnTargets.push (valueTarget.CloneTarget ());
            currentReturnTargets.push (valueTarget.CloneTarget ());
         }
         
         mInitialValueSources = initialValueSources;
         mCurrentValueSources = currentValueSources;
         mInitialValueTargets = initialReturnTargets;
         mCurrentValueTargets = currentReturnTargets;
         mInfo.mHtmlText = funcDeclaration.GetName ();
      }
      
      public function BuildFromFunctionCalling (funcCalling:FunctionCalling):void
      {
         var funcDeclaration:FunctionDeclaration = funcCalling.GetFunctionDeclaration ();
         SetFunctionDeclaration (funcDeclaration);
         
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
            
            initialValueSources.push (valueSource.CloneSource ());
            currentValueSources.push (valueSource.CloneSource ());
         }
         
         for (j = 0; j < funcDeclaration.GetNumOutputs (); ++ j)
         {
            valueTarget = funcCalling.GetReturnValueTarget (j);
            
            initialReturnTargets.push (valueTarget.CloneTarget ());
            currentReturnTargets.push (valueTarget.CloneTarget ());
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
      
      public var mValueSourceParentControls:Array;
      public var mValueSourceControls:Array;
      public var mValueTargetParentControls:Array;
      public var mValueTargetControls:Array;
   }
}
