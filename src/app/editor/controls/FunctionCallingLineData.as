
package editor.controls {
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.VariableDefinition;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionCalling;
   import editor.trigger.ValueSource;
   import editor.trigger.ValueTarget;
   
   import editor.runtime.Runtime;
   
   import common.trigger.CoreFunctionIds;
   
   public class FunctionCallingLineData
   {
      private var _mIndentLevel:int = 0;
      
      public var mOwnerBlock:FunctionCallingBlockData;
      public var mOwnerBranch:FunctionCallingBranchData; // may be null
      
      private var _mIsValid:Boolean = true;
      
      private var _mLineNumber:int;
      
      public function set mIsValid (valid:Boolean):void
      {
         if (_mIsValid != valid)
         {
            mHtmlText = null;
            _mIsValid = valid;
         }
      }
      
      public function get mIsValid ():Boolean
      {
         return _mIsValid;
      }
      
      public function set mLineNumber (lineNumber:int):void
      {
         _mLineNumber = lineNumber;
      }
      
      public function get mLineNumber ():int
      {
         return _mLineNumber;
      }
      
      public function set mIndentLevel (indentLevel:int):void
      {
         _mIndentLevel = indentLevel;
      }
      
      public function get mIndentLevel ():int
      {
         return _mIndentLevel;
      }
      
      // ...
      
      public var mHtmlText:String = null;
      
      public function UpdateCodeLineText ():void
      {
         if (mHtmlText != null)
            return;
         
         mHtmlText = mFuncDeclaration.CreateFormattedCallingText (mCurrentValueSources, mCurrentValueTargets);
         
         if (! mIsValid)
         {
            mHtmlText = "<font color='#A0A0A0'>" + mHtmlText + "</font>"
         }
      }
      
      // ...
      
      public var mFunctionId:int;
      public var mFuncDeclaration:FunctionDeclaration;
      
      public var mInitialValueSources:Array;
      public var mCurrentValueSources:Array;
      public var mInitialValueTargets:Array;
      public var mCurrentValueTargets:Array;
      
      public function SetFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         mFuncDeclaration = funcDeclaration;
         mFunctionId = funcDeclaration.GetID ();
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
         mHtmlText = funcDeclaration.GetName ();
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
         mHtmlText = null;
         UpdateCodeLineText ();
      }
      
      public var mValueSourceParentControls:Array;
      public var mValueSourceControls:Array;
      public var mValueTargetParentControls:Array;
      public var mValueTargetControls:Array;
   }
}
