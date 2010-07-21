
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
      public var mLineNumber:int;
      public var mIndentLevel:int = 0;
      
      public var mFunctionId:int;
      public var mFuncDeclaration:FunctionDeclaration;
      
      public var mHtmlText:String;
      
      public var mInitialValueSources:Array;
      public var mCurrentValueSources:Array;
      public var mInitialValueTargets:Array;
      public var mCurrentValueTargets:Array;
      
      public var mIsValid:Boolean;
      
      //public var mIsBlockStart:Boolean;
      //public var mIsBlockEnd:Boolean;
      //public var mIsBlockBranch:Boolean;
      
      public var mCallingBlock:FunctionCallingBlockData;
      
      public function SetFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         mFuncDeclaration = funcDeclaration;
         mFunctionId = funcDeclaration.GetID ();
         
         //mIsBlockStart  = CoreFunctionIds.IsBlockStartCalling  (mFunctionId);
         //mIsBlockEnd    = CoreFunctionIds.IsBlockEndCalling    (mFunctionId);
         //mIsBlockBranch = CoreFunctionIds.IsBlockBranchCalling (mFunctionId);
      }
      
      public function UpdateCodeLineText ():void
      {
         mHtmlText = mFuncDeclaration.CreateFormattedCallingText (mCurrentValueSources, mCurrentValueTargets);
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
         
         mHtmlText = funcDeclaration.GetName ();
         mInitialValueSources = initialValueSources;
         mCurrentValueSources = currentValueSources;
         mInitialValueTargets = initialReturnTargets;
         mCurrentValueTargets = currentReturnTargets;
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
         UpdateCodeLineText ();
      }
      
      public var mValueSourceParentControls:Array;
      public var mValueSourceControls:Array;
      public var mValueTargetParentControls:Array;
      public var mValueTargetControls:Array;
   }
}
