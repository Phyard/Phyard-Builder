package player.trigger
{
   import player.design.Global;
   
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.FunctionDeclaration;
   import common.trigger.define.CodeSnippetDefine;
   import common.TriggerFormatHelper2;
   
   public class FunctionDefinition_Custom extends FunctionDefinition
   {
      protected var mPrimaryFunctionInstance:FunctionInstance;
      protected var mCurrentFunctionInstance:FunctionInstance = null;
      protected var mCodeSnippet:CodeSnippet;
      
      protected var mDesignDependent:Boolean = true;
      
      internal var mNumLocalVariables:int;
      
      internal var mInputVariableReferences:Array;
      internal var mOutputVariableReferences:Array;
      internal var mLocalVariableReferences:Array;
      
      internal var mInputVariableRefList:VariableReference;
      internal var mOutputVariableRefList:VariableReference;
      internal var mLocalVariableRefList:VariableReference;
      
      public function FunctionDefinition_Custom (inputValueSourceDefines:Array, ouputParamValueTypes:Array, numLocalVariables:int)
      {
         super (inputValueSourceDefines, ouputParamValueTypes);
         
         mNumLocalVariables = numLocalVariables;
         
         mInputVariableReferences = VariableReference.CreateVariableReferenceArray (mNumInputParams);
         mOutputVariableReferences = VariableReference.CreateVariableReferenceArray (mNumOutputParams);
         mLocalVariableReferences = VariableReference.CreateVariableReferenceArray (mNumLocalVariables);
         
         mInputVariableRefList = mNumInputParams > 0 ? mInputVariableReferences [0] : null;
         mOutputVariableRefList = mNumOutputParams > 0 ? mOutputVariableReferences [0] : null;
         mLocalVariableRefList = mNumLocalVariables > 0 ? mLocalVariableReferences [0] : null;
         
         mPrimaryFunctionInstance = new FunctionInstance (this);
      }
      
      public function SetDesignDependent (designDependent:Boolean):void
      {
         mDesignDependent = designDependent;
      }
      
      public function IsDesignDependent ():Boolean
      {
         return mDesignDependent;
      }
      
      public function GetNumLocalVariables ():int
      {
         return mNumLocalVariables;
      }
      
      //>>these are only for EntityEventHandler_Timer with pre and post handling
      public function GetLocalVariableReferences ():Array
      {
         return mLocalVariableReferences;
      }
      
      public function SetLocalVariableReferences (refs:Array):void
      {
         mLocalVariableReferences = refs;
         mLocalVariableRefList = mNumLocalVariables > 0 ? mLocalVariableReferences [0] : null;
      }
      //<<
      
      public function SetCodeSnippetDefine (codeSnippetDefine:CodeSnippetDefine, extraInfos:Object):void
      {
         mCodeSnippet = TriggerFormatHelper2.CreateCodeSnippet (this, Global.GetCurrentWorld (), codeSnippetDefine, extraInfos);
         mPrimaryFunctionInstance.SetAsCurrent ();
      }
      
      public function CreateVariableParameter (variableSpaceType:int, variableIndex:int, isOutput:Boolean, nextParameter:Parameter = null):Parameter
      {
         var variableReferenceArray:Array;
         
         if (variableSpaceType == ValueSpaceTypeDefine.ValueSpace_Input)
         {
            variableReferenceArray = mInputVariableReferences;
         }
         else if (variableSpaceType == ValueSpaceTypeDefine.ValueSpace_Output)
         {
            variableReferenceArray = mOutputVariableReferences;
         }
         else if (variableSpaceType == ValueSpaceTypeDefine.ValueSpace_Local)
         {
            variableReferenceArray = mLocalVariableReferences;
         }
         else
         {
            throw new Error ("unknown var space");
         }
         
         if (variableIndex < 0 || variableIndex >= variableReferenceArray.length)
         {
            //throw new Error ("index out of range");
            
            return null; // will be converted to a default direct parameter.
         }
         
         //if (variableSpaceType == ValueSpaceTypeDefine.ValueSpace_Local && mFunctionDeclaration.IsStaticLocalVariable (variableIndex))
         //{
         //   return new Parameter_Variable (mPrimaryFunctionInstance.GetLocalVariableAt (variableIndex), nextParameter);
         //}
         
         return new Parameter_VariableRef (variableReferenceArray [variableIndex], nextParameter);
      }
      
      // general calling
      override public function DoCall (inputParamList:Parameter, outputParamList:Parameter):void
      {
         // 1. push 
         
         if (mCurrentFunctionInstance == null) // first dream space
         {
            mCurrentFunctionInstance = mPrimaryFunctionInstance;
            
            mCurrentFunctionInstance.mInputVariableSpace.GetValuesFromParameters (inputParamList);
            mCodeSnippet.Excute ();
            mCurrentFunctionInstance.mOutputVariableSpace.SetValuesToParameters (outputParamList);
            
            mCurrentFunctionInstance = null;
         }
         else
         {
            if (mCurrentFunctionInstance.mNextFunctionInstance == null)
            {
               var next:FunctionInstance = new FunctionInstance (this);
               mCurrentFunctionInstance.mNextFunctionInstance = next;
               next.mPrevFunctionInstance = mCurrentFunctionInstance;
            }
            
            mCurrentFunctionInstance = mCurrentFunctionInstance.mNextFunctionInstance;
            mCurrentFunctionInstance.mInputVariableSpace.GetValuesFromParameters (inputParamList);
            mCurrentFunctionInstance.SetAsCurrent ();
            
            mCodeSnippet.Excute ();
            
            mCurrentFunctionInstance = mCurrentFunctionInstance.mPrevFunctionInstance;
            mCurrentFunctionInstance.SetAsCurrent ();
            mCurrentFunctionInstance.mNextFunctionInstance.mOutputVariableSpace.SetValuesToParameters (outputParamList);
         }
      }
      
      // special for event handlers, a little faster than DoCall. Maybe it is not worthy to create this function.
      // NOTICE: DON'T call this function in iteration functions
      // as event handler, no returns
      public function ExcuteEventHandler (inputParamList:Parameter):void
      {
         mPrimaryFunctionInstance.mInputVariableSpace.GetValuesFromParameters (inputParamList);
         
         mCodeSnippet.Excute ();
         
         // no returns
         //mPrimaryFunctionInstance.mOutputVariableSpace.SetValuesToParameters (outputParamList);
      }
      
      // EvaluateCondition and ExcuteAction are disabled now for it is wrong to call them in CallScript API, which may can these functions in iteration functions
      // 
      //// as condition component, no inputs
      //public function EvaluateCondition (outputParamList:Parameter):void
      //{
      //   // no inputs
      //   //mPrimaryFunctionInstance.mInputVariableSpace.GetValuesFromParameters (inputParamList);
      //   
      //   mCodeSnippet.Excute ();
      //   
      //   mPrimaryFunctionInstance.mOutputVariableSpace.SetValuesToParameters (outputParamList);
      //}
      //
      //// as action, no inputs, returns
      //public function ExcuteAction ():void
      //{
      //   //mPrimaryFunctionInstance.mInputVariableSpace.GetValuesFromParameters (inputParamList);
      //   
      //   mCodeSnippet.Excute ();
      //   
      //   // no returns
      //   //mPrimaryFunctionInstance.mOutputVariableSpace.SetValuesToParameters (outputParamList);
      //}
   }
}