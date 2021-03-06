
package common {
   
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.system.Capabilities;
   
   import player.world.Global;
   import player.world.World;
   import player.entity.Entity;
   import player.world.CollisionCategory;
   
   import player.trigger.ClassDefinition;
   import player.trigger.CoreClassesHub;
      
   import player.trigger.FunctionDefinition;
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.FunctionDefinition_Custom;
   
   import player.trigger.TriggerEngine;
   import player.trigger.CodeSnippet;
   import player.trigger.FunctionCalling;
   import player.trigger.FunctionCalling_Condition;
   import player.trigger.FunctionCalling_ConditionWithComparer;
   import player.trigger.FunctionCalling_Dummy;
   import player.trigger.FunctionCalling_CommonAssign;
   import player.trigger.Parameter;
   import player.trigger.Parameter_DirectConstant;
   import player.trigger.Parameter_Variable;
   import player.trigger.Parameter_ObjectProperty;
   import player.trigger.Parameter_EntityProperty;
   import player.trigger.Parameter_EntityPropertyProperty;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   import player.trigger.VariableInstanceConstant;
   import player.trigger.VariableDeclaration;
   
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreFunctionIds;
   import common.trigger.FunctionCoreBasicDefine;
   import common.trigger.CoreFunctionDeclarations;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.CoreClassDeclarations;
   
   import common.trigger.define.FunctionDefine;
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionCallingDefine;
   import common.trigger.define.ValueSourceDefine;
   import common.trigger.define.ValueSourceDefine_Null;
   import common.trigger.define.ValueSourceDefine_Direct;
   import common.trigger.define.ValueSourceDefine_Variable;
   import common.trigger.define.ValueSourceDefine_ObjectProperty;
   import common.trigger.define.ValueSourceDefine_EntityProperty;
   import common.trigger.define.ValueTargetDefine;
   import common.trigger.define.ValueTargetDefine_Null;
   import common.trigger.define.ValueTargetDefine_Variable;
   import common.trigger.define.ValueTargetDefine_ObjectProperty;
   import common.trigger.define.ValueTargetDefine_EntityProperty;
   
   //import common.trigger.define.VariableSpaceDefine;
   import common.trigger.define.VariableDefine;
   
   import common.trigger.parse.CodeSnippetParser;
   
   import common.trigger.parse.FunctionCallingBlockInfo;
   import common.trigger.parse.FunctionCallingBranchInfo;
   import common.trigger.parse.FunctionCallingLineInfo;
   
   import common.CoordinateSystem;
   
   public class TriggerFormatHelper2
   {
      // playerWorld == null is for core APIs and later potiential custom global and library functions.
      // [this param is removed] toClearRefs is only meaningful when playerWorld == null.
      public static function BuildParamDefinesDefinesFormFunctionDeclaration (playerWorld:World, /*toClearRefs:Boolean,*/ variableSpace:VariableSpace, functionDeclaration:FunctionCoreBasicDefine, forInputParams:Boolean):VariableSpace
      {
         var variableInstance:VariableInstance;
         var i:int;
         var classId:int;
         var classDefinition:ClassDefinition;
         var varDeclaration:VariableDeclaration;
         
         var firstTime:Boolean = (variableSpace == null);
         
         if (forInputParams)
         {
            var numInputs:int = functionDeclaration.GetNumInputs ();
            if (firstTime)
               variableSpace = new VariableSpace (numInputs);
            
            for (i =  0; i < numInputs; ++ i)
            {
               variableInstance = variableSpace.GetVariableByIndex (i);
               
               classId = functionDeclaration.GetInputParamValueType (i);
               classDefinition = CoreClassesHub.GetCoreClassDefinition (classId);
               
               if (firstTime)
               {
                  ////variableInstance.SetIndex (i);
                  ////variableInstance.SetClassType (ClassTypeDefine.ClassType_Core);
                  ////variableInstance.SetValueType (functionDeclaration.GetInputParamValueType (i));
                  //variableInstance.SetShellClassDefinition (CoreClassesHub.GetCoreClassDefinition (classId));
                  
                  varDeclaration = new VariableDeclaration (classDefinition);
                  varDeclaration.SetIndex (i);
                  //varDeclaration.SetKey (variableDefine.mKey);
                  //varDeclaration.SetName (variableDefine.mName);

                  variableInstance.SetDeclaration (varDeclaration);                  
               }

               // real ClassDefinition may be changed if not first time. (or maybe not?)
               variableInstance.SetRealClassDefinition (classDefinition);
               
               //variableInstance.SetValueObject (functionDeclaration.GetInputParamDefaultValue (i));
               //if (toClearRefs) //playerWorld == null) // avoid memory consuming after testing in editor.
               //   variableInstance.SetValueObject (null);
               //else
               //{
                  variableInstance.SetValueObject (CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, ClassTypeDefine.ClassType_Core, classId, functionDeclaration.GetInputParamDefaultValue (i)));
               //}
            }
         }
         else
         {
            var numOutputs:int = functionDeclaration.GetNumOutputs ();
            if (firstTime)
               variableSpace = new VariableSpace (numOutputs);
            
            for (i =  0; i < numOutputs; ++ i)
            {
               variableInstance = variableSpace.GetVariableByIndex (i);
               
               classId = functionDeclaration.GetOutputParamValueType (i);
               classDefinition = CoreClassesHub.GetCoreClassDefinition (classId);
               
               if (firstTime)
               {
                  ////variableInstance.SetIndex (i);
                  ////variableInstance.SetClassType (ClassTypeDefine.ClassType_Core);
                  ////variableInstance.SetValueType (functionDeclaration.GetOutputParamValueType (i));
                  //variableInstance.SetShellClassDefinition (CoreClassesHub.GetCoreClassDefinition (classId));
                  
                  varDeclaration = new VariableDeclaration (classDefinition);
                  varDeclaration.SetIndex (i);
                  //varDeclaration.SetKey (variableDefine.mKey);
                  //varDeclaration.SetName (variableDefine.mName);

                  variableInstance.SetDeclaration (varDeclaration);                  
               }

               // real ClassDefinition may be changed if not first time. (or maybe not?)
               variableInstance.SetRealClassDefinition (classDefinition);
               
               //variableInstance.SetValueObject (functionDeclaration.GetOutputParamDefaultValue (i));
               //if (toClearRefs) //playerWorld == null) // avoid memory consuming after testing in editor.
               //   variableInstance.SetValueObject (null);
               //else
               //{
                  variableInstance.SetValueObject (CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, ClassTypeDefine.ClassType_Core, classId, functionDeclaration.GetOutputParamDefaultValue (i)));
               //}
            }
         }
         
         return variableSpace;
      }
      
      //public static function BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration:FunctionCoreBasicDefine, forInputParams:Boolean):Array
      //{
      //   var paramDefines:Array = null;
      //   
      //   var i:int;
      //   
      //   if (forInputParams)
      //   {
      //      var numInputs:int = functionDeclaration.GetNumInputs ();
      //      if (numInputs > 0)
      //      {
      //         paramDefines = new Array (numInputs);
      //         
      //         for (i =  0; i < numInputs; ++ i)
      //         {
      //            paramDefines [i] = new ValueSourceDefine_Direct (/*functionDeclaration.GetInputParamValueType (i), */functionDeclaration.GetInputParamDefaultValue (i));
      //         }
      //      }
      //   }
      //   else
      //   {
      //      var numOutputs:int = functionDeclaration.GetNumOutputs ();
      //      if (numOutputs > 0)
      //      {
      //         paramDefines = new Array (numOutputs);
      //         
      //         for (i =  0; i < numOutputs; ++ i)
      //         {
      //            paramDefines [i] = functionDeclaration.GetOutputParamValueType (i);
      //         }
      //      }
      //   }
      //   
      //   return paramDefines;
      //}
      
      //public static function BuildParamDefinesFormVariableDefines (inputVariableDefines:Array, forInputParams:Boolean):Array
      //{
      //   var paramDefines:Array = null;
      //   
      //   var i:int;
      //   var variableDefine:VariableDefine;
      //   var direct_source_define:ValueSourceDefine_Direct;
      //   
      //   if (forInputParams)
      //   {
      //      var numInputs:int = inputVariableDefines.length;
      //      if (numInputs > 0)
      //      {
      //         paramDefines = new Array (numInputs);
      //         
      //         for (i =  0; i < numInputs; ++ i)
      //         {
      //            variableDefine = inputVariableDefines [i] as VariableDefine;
      //            //direct_source_define = variableDefine.mDirectValueSourceDefine;
      //            //paramDefines [i] = new ValueSourceDefine_Direct (direct_source_define.mValueType, direct_source_define.mValueObject);
      //            paramDefines [i] = new ValueSourceDefine_Direct (/*variableDefine.mValueType, */variableDefine.mValueObject);
      //         }
      //      }
      //   }
      //   else
      //   {
      //      var numOutputs:int = inputVariableDefines.length;
      //      if (numOutputs > 0)
      //      {
      //         paramDefines = new Array (numOutputs);
      //         
      //         for (i =  0; i < numOutputs; ++ i)
      //         {
      //            variableDefine = inputVariableDefines [i] as VariableDefine;
      //            //direct_source_define = variableDefine.mDirectValueSourceDefine;
      //            //paramDefines [i] = direct_source_define.mValueType;
      //            paramDefines [i] = variableDefine.mValueType;
      //         }
      //      }
      //   }
      //   
      //   return paramDefines;
      //}
      
      // coreFunction == null means this is the first time to create the function.
      // otherwise, means to reset initial ClassInstance for all sources and target to avoid memory leak and logic errors.
      public static function CreateCoreFunctionDefinition (/*playerWorld:World*//*toClearRefs:Boolean,*/ coreFunction:FunctionDefinition_Core, functionDeclaration:FunctionCoreBasicDefine, callback:Function):FunctionDefinition_Core
      {
         if (coreFunction == null)
         {
            return new FunctionDefinition_Core (
                        BuildParamDefinesDefinesFormFunctionDeclaration (/*playerWorld*/null, /*toClearRefs,*/ null, functionDeclaration, true), 
                        BuildParamDefinesDefinesFormFunctionDeclaration (/*playerWorld*/null, /*toClearRefs,*/ null, functionDeclaration, false), 
                        callback);
         }
         else // to reset param values
         {
            BuildParamDefinesDefinesFormFunctionDeclaration (/*playerWorld*/null, /*toClearRefs,*/ coreFunction.GetInputVariableSpace (), functionDeclaration, true);
            BuildParamDefinesDefinesFormFunctionDeclaration (/*playerWorld*/null, /*toClearRefs,*/ coreFunction.GetOutputVariableSpace (), functionDeclaration, false);
            
            return coreFunction;
         }
      }
      
//==============================================================================================
// define -> definition (player)
//==============================================================================================
      
      // functionDefine must not be null, functionDeclaration may be null (custom function) or non-null (predefined function, which is not core).
      // customClassIdShiftOffset is used for custom functions.
      public static function FunctionDefine2FunctionDefinition (playerWorld:World, functionDefine:FunctionDefine, functionDeclaration:FunctionCoreBasicDefine, customClassIdShiftOffset:int = 0):FunctionDefinition_Custom
      {
         var inputVariableSpace:VariableSpace;
         var outputVariableSpace:VariableSpace;
         
         // before v2.05
         //var numLocals:int = functionDefine.mLocalVariableDefines == null ? 0 : functionDefine.mLocalVariableDefines.length;
         // sicne v2.05
         var localVariableSpace:VariableSpace = VariableDefines2VariableSpace (playerWorld, functionDefine.mLocalVariableDefines, null, customClassIdShiftOffset);
         
         if (functionDeclaration != null) // event handler / action / condition / ...
         {
            // maybe creating one Function for each event type is better. May be not.
            // Currently, still create one for each instance.
            
            //costomFunction = new FunctionDefinition_Custom (BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration, true), BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration, false), numLocals);
            inputVariableSpace = BuildParamDefinesDefinesFormFunctionDeclaration (playerWorld, /*false,*/ null, functionDeclaration, true);
            outputVariableSpace = BuildParamDefinesDefinesFormFunctionDeclaration (playerWorld, /*false,*/ null, functionDeclaration, false);
         }
         else
         {
            //costomFunction = new FunctionDefinition_Custom (BuildParamDefinesFormVariableDefines (functionDefine.mInputVariableDefines, true), BuildParamDefinesFormVariableDefines (functionDefine.mOutputVariableDefines, false), numLocals);
            inputVariableSpace = VariableDefines2VariableSpace (playerWorld, functionDefine.mInputVariableDefines, null, customClassIdShiftOffset);
            outputVariableSpace = VariableDefines2VariableSpace (playerWorld, functionDefine.mOutputVariableDefines, null, customClassIdShiftOffset);
         }
         
         var costomFunction:FunctionDefinition_Custom = new FunctionDefinition_Custom (inputVariableSpace, outputVariableSpace, localVariableSpace);
         
         return costomFunction;
      }
      
      public static function CreateCodeSnippet (customFunctionDefinition:FunctionDefinition_Custom, playerWorld:World, codeSnippetDefine:CodeSnippetDefine, extraInfos:Object):CodeSnippet
      {
         var lineNumber:int;
         var callingInfo:FunctionCallingLineInfo;
         var callingDefine:FunctionCallingDefine;
         
         // parse...
         
         var callingInfos:Array = new Array (codeSnippetDefine.mNumCallings);
         
         for (lineNumber = 0; lineNumber < codeSnippetDefine.mNumCallings; ++ lineNumber)
         {
            callingDefine = codeSnippetDefine.mFunctionCallingDefines [lineNumber] as FunctionCallingDefine;
            
            callingInfo = new FunctionCallingLineInfo ();
            callingInfos [lineNumber] = callingInfo;
            
            callingInfo.mLineNumber = lineNumber;
            if (callingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
            {
               callingInfo.mIsCoreDeclaration = true;
               callingInfo.mFunctionId = callingDefine.mFunctionId;
            }
            else
            {
               callingInfo.mIsCoreDeclaration = false;
               callingInfo.mFunctionId = callingDefine.mFunctionId + extraInfos.mBeginningCustomFunctionIndex;
            }
            
            if (playerWorld.GetVersion () >= 0x0209)
            {
               callingInfo.mCommentDepth = callingDefine.mCommentDepth;
            }
            
            callingInfo.mFunctionCallingDefine = callingDefine; // temp ref, for using below
         }
         
         // create valid callings
         
         var numValidCallings:int = CodeSnippetParser.ParseCodeSnippet (callingInfos, Capabilities.isDebugger);
         var validCallingInfos:Array = new Array (numValidCallings + 1);
         validCallingInfos [numValidCallings] = null;
         
         var lastCallingInfo:FunctionCallingLineInfo = null;
         numValidCallings = 0;
         for (lineNumber = 0; lineNumber < codeSnippetDefine.mNumCallings; ++ lineNumber)
         {
            callingInfo = callingInfos [lineNumber] as FunctionCallingLineInfo;
            
            if (callingInfo.mIsValid)
            {
               callingInfo.mFunctionCallingForPlaying = FunctionCallingDefine2FunctionCalling (lineNumber, customFunctionDefinition, playerWorld, callingInfo.mFunctionCallingDefine, extraInfos);
               callingInfo.mFunctionCallingDefine = null; // clear ref
               
               validCallingInfos [numValidCallings ++] = callingInfo;
               
               if (lastCallingInfo != null)
               {
                  lastCallingInfo.mNextValidCallingLine = callingInfo;
                  lastCallingInfo.mNextGoodCallingLine = callingInfo;
               }
               
               lastCallingInfo = callingInfo;
            }
         }
         
         // build calling list
         
         var calling_list_head:FunctionCalling = null;
         
         if (numValidCallings > 0)
         {
            callingInfo = validCallingInfos [0] as FunctionCallingLineInfo;
            calling_list_head = callingInfo.mFunctionCallingForPlaying;
            
            var calling_condition:FunctionCalling_Condition;
            
            var branchInfo:FunctionCallingBranchInfo;
            
            var nextCallingInfo:FunctionCallingLineInfo;
            var nextCallingInfoForTrue:FunctionCallingLineInfo;
            var nextCallingInfoForFalse:FunctionCallingLineInfo;
            
            do
            {
               lastCallingInfo = callingInfo;
               callingInfo = lastCallingInfo.mNextValidCallingLine;
               
               nextCallingInfo = null;
               nextCallingInfoForTrue = null;
               nextCallingInfoForFalse = null;
               
               calling_condition = null;
               
               if (lastCallingInfo.mIsCoreDeclaration)
               {
                  switch (lastCallingInfo.mFunctionId)
                  {
                     case CoreFunctionIds.ID_ReturnIfTrue:
                        calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                        
                        nextCallingInfoForTrue = null;
                        nextCallingInfoForFalse = callingInfo;
                        break;
                     case CoreFunctionIds.ID_ReturnIfFalse:
                        calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                        
                        nextCallingInfoForTrue = callingInfo;
                        nextCallingInfoForFalse = null;
                        break;
                     case CoreFunctionIds.ID_StartIf:
                        calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                        
                        if (lastCallingInfo.mOwnerBlock.mFirstBranch.mNumValidCallings > 1)
                        {
                           nextCallingInfoForTrue = callingInfo;
                        }
                        else
                        {
                           nextCallingInfoForTrue = lastCallingInfo.mOwnerBlock.mEndCallingLine; // end if
                           
                           if (nextCallingInfoForTrue != null)
                              nextCallingInfoForTrue = nextCallingInfoForTrue.mNextGoodCallingLine;
                        }
                        
                        branchInfo = lastCallingInfo.mOwnerBlock.mFirstBranch; // if branch, should not be null
                        branchInfo = branchInfo.mNextBranch; // else branch
                        if (branchInfo != null && branchInfo.mNumValidCallings > 1)
                        {
                           nextCallingInfoForFalse = branchInfo.mFirstCallingLine.mNextGoodCallingLine;
                        }
                        else
                        {
                           nextCallingInfoForFalse = lastCallingInfo.mOwnerBlock.mEndCallingLine; // end if
                           
                           if (nextCallingInfoForFalse != null)
                              nextCallingInfoForFalse = nextCallingInfoForFalse.mNextGoodCallingLine;
                        }
                        break;
                     case CoreFunctionIds.ID_StartWhile:
                        calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                        
                        nextCallingInfoForTrue = callingInfo;
                        
                        nextCallingInfoForFalse = lastCallingInfo.mOwnerBlock.mEndCallingLine; // end while
                        if (nextCallingInfoForFalse != null)
                           nextCallingInfoForFalse = nextCallingInfoForFalse.mNextGoodCallingLine;
                        break;
                     
                     //========================================================
                     
                     case CoreFunctionIds.ID_Else:
                        nextCallingInfo = callingInfo;
                        break;
                     case CoreFunctionIds.ID_EndIf:
                        nextCallingInfo = callingInfo;
                        break;
                     case CoreFunctionIds.ID_EndWhile:
                        nextCallingInfo = lastCallingInfo.mOwnerBlock.mStartCallingLine; // start while
                        break;
                     case CoreFunctionIds.ID_Return:
                        nextCallingInfo = null;
                        break;
                     case CoreFunctionIds.ID_Break:
                        nextCallingInfo = lastCallingInfo.mOwnerBlockSupportBreak.mEndCallingLine; // end while / end switch / end do while / end for / ...
                        if (nextCallingInfo != null)
                           nextCallingInfo = nextCallingInfo.mNextGoodCallingLine;
                        break;
                     case CoreFunctionIds.ID_Continue:
                        nextCallingInfo = lastCallingInfo.mOwnerBlockSupportContinue.mStartCallingLine; // end while / end switch / end do while / end for / ...
                        break;
                     default:
                     {
                        nextCallingInfo = callingInfo;
                        break;
                     }
                  }
               }
               else
               {
                  nextCallingInfo = callingInfo;
               }
               
               if (calling_condition != null)
               {
                  nextCallingInfoForTrue = GetNextGoodCalling (nextCallingInfoForTrue);
                  calling_condition.SetNextCallingForTrue (nextCallingInfoForTrue == null ? null : nextCallingInfoForTrue.mFunctionCallingForPlaying);
                  
                  nextCallingInfoForFalse = GetNextGoodCalling (nextCallingInfoForFalse);
                  calling_condition.SetNextCallingForFalse (nextCallingInfoForFalse == null ? null : nextCallingInfoForFalse.mFunctionCallingForPlaying);
         //trace ("> " + lastCallingInfo.mFunctionCallingForPlaying.GetLineNumber () + " -> " + (nextCallingInfoForTrue == null ? -1 : nextCallingInfoForTrue.mFunctionCallingForPlaying.GetLineNumber ()) + " : " +  (nextCallingInfoForFalse == null ? -1 : nextCallingInfoForFalse.mFunctionCallingForPlaying.GetLineNumber ()));
               }
               else
               {
                  nextCallingInfo = GetNextGoodCalling (nextCallingInfo);
                  lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (nextCallingInfo == null ? null : nextCallingInfo.mFunctionCallingForPlaying);
                  
         //trace ("> " + lastCallingInfo.mFunctionCallingForPlaying.GetLineNumber () + " -> " + (nextCallingInfo == null ? -1 : nextCallingInfo.mFunctionCallingForPlaying.GetLineNumber ()));
               }
            }
            while (callingInfo != null);
         }
         
         var code_snippet:CodeSnippet = new CodeSnippet (calling_list_head);
         
         return code_snippet;
      }
      
      // a good calling <=> not an "else" calling and not an "end if" calling
      private static function GetNextGoodCalling (inputCallingInfo:FunctionCallingLineInfo):FunctionCallingLineInfo
      {
         var goodCallingInfo:FunctionCallingLineInfo = inputCallingInfo;
         var nextCallingInfo:FunctionCallingLineInfo = inputCallingInfo;
         
         //while (nextCallingInfo != null && (nextCallingInfo.mFunctionId == CoreFunctionIds.ID_Else || nextCallingInfo.mFunctionId == CoreFunctionIds.ID_EndIf)) // a bad calling
         // above is a bug: if number of custom functions exceeds 32, the logic may be ill. 
         while (nextCallingInfo != null && nextCallingInfo.mIsCoreDeclaration && (nextCallingInfo.mFunctionId == CoreFunctionIds.ID_Else || nextCallingInfo.mFunctionId == CoreFunctionIds.ID_EndIf)) // a bad calling
         {
            goodCallingInfo = nextCallingInfo.mOwnerBlock.mEndCallingLine;  // "end if" of the bad calling block
            if (goodCallingInfo == nextCallingInfo)
            {
               nextCallingInfo = nextCallingInfo.mNextGoodCallingLine;
               goodCallingInfo = nextCallingInfo;
            }
            else
            {
               nextCallingInfo.mNextGoodCallingLine = goodCallingInfo;
               nextCallingInfo = goodCallingInfo;
            }
         }
         
         // optimize
         while (inputCallingInfo != goodCallingInfo)
         {
            nextCallingInfo = inputCallingInfo.mNextGoodCallingLine;
            inputCallingInfo.mNextGoodCallingLine = goodCallingInfo;
            inputCallingInfo = nextCallingInfo;
         }
         
         return goodCallingInfo;
      }
      
      public static function FunctionCallingDefine2FunctionCalling (lineNumber:int, customFunctionDefinition:FunctionDefinition_Custom, playerWorld:World, funcCallingDefine:FunctionCallingDefine, extraInfos:Object):FunctionCalling
      {
         var function_id:int = funcCallingDefine.mFunctionId;
         var func_definition:FunctionDefinition;
         
         if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
         {
            func_definition = TriggerEngine.GetCoreFunctionDefinition (function_id);
         }
         else if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Custom)
         {
            func_definition = /*Global*/playerWorld.GetCustomFunctionDefinition (function_id + extraInfos.mBeginningCustomFunctionIndex);
         }
         else if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         // assert (func_definition != null)

         var real_num_input_params:int = func_definition.GetNumInputParameters ();
         var dafault_value_source_define:ValueSourceDefine_Direct = new ValueSourceDefine_Direct (null);
         
         var real_num_output_params:int = func_definition.GetNumOutputParameters ();
         
         var vi:VariableInstance;
         var i:int;
         
         var value_source_list:Parameter = null;
         var value_source:Parameter;
         for (i = real_num_input_params - 1; i >= 0; -- i)
         {
            vi = func_definition.GetInputParameter (i);

            //dafault_value_source_define = func_definition.GetDefaultInputValueSourceDefine (i);
            dafault_value_source_define.mValueObject = vi.GetValueObject ();
            
            if (i >= funcCallingDefine.mNumInputs) // fill the missed parameters
            {
               //value_source = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, dafault_value_source_define, dafault_value_source_define.mValueType, dafault_value_source_define.mValueObject, extraInfos);
               value_source = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, dafault_value_source_define, vi.GetRealClassType (), vi.GetRealValueType (), vi.GetValueObject (), extraInfos);
            }
            else                                   // use the value set by designer
            {
               //value_source = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, funcCallingDefine.mInputValueSourceDefines [i], dafault_value_source_define.mValueType, dafault_value_source_define.mValueObject, extraInfos);
               value_source = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, funcCallingDefine.mInputValueSourceDefines [i], vi.GetRealClassType (), vi.GetRealValueType (), vi.GetValueObject (), extraInfos);
            }
               
            value_source.mNextParameter = value_source_list;
            value_source_list = value_source;
         }
         
         var value_target_list:Parameter = null;
         var value_target:Parameter;
         for (i = real_num_output_params - 1; i >= 0; -- i)
         {
            if (i >= funcCallingDefine.mNumOutputs) // fill the missed parameters
               value_target = new Parameter ();
            else
            {
               //value_target = ValueTargetDefine2ReturnValueTarget (customFunctionDefinition, playerWorld, funcCallingDefine.mOutputValueTargetDefines [i], func_definition.GetOutputParamValueType (i), extraInfos);
               vi = func_definition.GetOutputParameter (i);
               value_target = ValueTargetDefine2ReturnValueTarget (customFunctionDefinition, playerWorld, funcCallingDefine.mOutputValueTargetDefines [i], vi.GetRealClassType (), vi.GetRealValueType (), extraInfos);
            }
            
            value_target.mNextParameter = value_target_list;
            value_target_list = value_target;
         }
         
         var calling:FunctionCalling = null;
         
         if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
         {
            switch (function_id)
            {
               case CoreFunctionIds.ID_ReturnIfTrue:
               case CoreFunctionIds.ID_ReturnIfFalse:
                  calling = new FunctionCalling_Condition (lineNumber, func_definition, value_source_list, value_target_list);
                  break;
               case CoreFunctionIds.ID_StartIf:
               case CoreFunctionIds.ID_StartWhile:
                  calling = new FunctionCalling_ConditionWithComparer (lineNumber, func_definition, value_source_list, value_target_list);
                  break;
               case CoreFunctionIds.ID_EndIf:
               case CoreFunctionIds.ID_Else:
               case CoreFunctionIds.ID_EndWhile:
               case CoreFunctionIds.ID_Return:
               case CoreFunctionIds.ID_Break:
               case CoreFunctionIds.ID_Continue:
                  calling = new FunctionCalling_Dummy (lineNumber, func_definition, value_source_list, value_target_list);
                  break;
               case CoreFunctionIds.ID_CommonAssign: // since v2.05
                  calling = new FunctionCalling_CommonAssign (lineNumber, func_definition, value_source_list, value_target_list);
                  break;
               default:
               { 
                  break;
               }
            }
         }
         
         if (calling == null)
            calling = new FunctionCalling (lineNumber, func_definition, value_source_list, value_target_list);
         
         return calling;
      }
      
      public static function ValueSourceDefine2InputValueSource (customFunctionDefinition:FunctionDefinition_Custom, playerWorld:World, valueSourceDefine:ValueSourceDefine, classType:int, valueType:int, defaultDirectValue:Object, extraInfos:Object):Parameter
      {
         var value_source:Parameter = null;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            //assert (valueType == direct_source_define.mValueType);

            value_source = new Parameter_DirectConstant (
                                    Global.sTheGlobal.GetClassDefinition (playerWorld, classType, valueType),
                                    CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, classType, valueType, direct_source_define.mValueObject, extraInfos)
                                 ); 
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable || source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var value_space_type:int = variable_source_define.mSpaceType;
            var variable_index:int   = variable_source_define.mVariableIndex;
            
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_World:
                  // will not merge with new ones
                  variable_instance = (/*Global*/playerWorld.GetWorldVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GameSave:
                  // will not merge with new ones
                  variable_instance = (/*Global*/playerWorld.GetGameSaveVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Session:
                  if (variable_index >= 0)
                  {
                     //variable_index += extraInfos.mBeinningSessionVariableIndex;
                     variable_index = extraInfos.mSessionVariableIdMappingTable [variable_index];
                  }
                  variable_instance = (/*Global*/playerWorld.GetSessionVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  if (variable_index >= 0)
                     variable_index += extraInfos.mBeinningGlobalVariableIndex;
                  variable_instance = (/*Global*/playerWorld.GetGlobalVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
                  // will not merge with new ones
                  variable_instance = (/*Global*/playerWorld.GetCommonGlobalVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Register:
                  if (classType == ClassTypeDefine.ClassType_Core)
                  {
                     var variable_space:VariableSpace = /*Global*/playerWorld.GetRegisterVariableSpace (valueType);
                     if (variable_space != null)
                        variable_instance = variable_space.GetVariableByIndex (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
               case ValueSpaceTypeDefine.ValueSpace_Output:
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  if (source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
                     value_source = customFunctionDefinition.CreateVariableParameter (value_space_type, variable_index, true, (variable_source_define as ValueSourceDefine_ObjectProperty).mPropertyIndex);
                  else
                     value_source = customFunctionDefinition.CreateVariableParameter (value_space_type, variable_index, false, -1);
                  
                  // variable_instance == null
                  break;
               default:
                  break;
            }
            
            if (variable_instance != null && variable_instance != VariableInstanceConstant.kVoidVariableInstance)
            {
               if (source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
                  value_source = new Parameter_ObjectProperty (variable_instance, (variable_source_define as ValueSourceDefine_ObjectProperty).mPropertyIndex);
               else
                  value_source = new Parameter_Variable (variable_instance);
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            var property_source_define:ValueSourceDefine_EntityProperty = valueSourceDefine as ValueSourceDefine_EntityProperty;
            
            // property_source_define.mPropertyValueSourceDefine.mSpacePackageId == 0 means ValueSpace_EntityProperties
            var customPropertyId:int = property_source_define.mPropertyValueSourceDefine.mVariableIndex as int;
            
            if (customPropertyId >= 0)
            {
               if (property_source_define.mPropertyValueSourceDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
               {
                  // do nothing
               }
               else // if (property_source_define.mPropertyValueSourceDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_EntityProperties) or 0
               {
                  customPropertyId += extraInfos.mBeinningCustomEntityVariableIndex;
               }
            }
            
            var entitySource:Parameter = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, property_source_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, null, extraInfos);
            if (property_source_define.mPropertyValueSourceDefine.GetValueSourceType () == ValueSourceTypeDefine.ValueSource_ObjectProperty)
            {
               var propertyPropertyIndex:int = (property_source_define.mPropertyValueSourceDefine as ValueSourceDefine_ObjectProperty).mPropertyIndex;
               if (propertyPropertyIndex >= 0)
               {
                  value_source = new Parameter_EntityPropertyProperty (entitySource, property_source_define.mPropertyValueSourceDefine.mSpaceType, customPropertyId, propertyPropertyIndex);
               }
            }
            else
            {
               value_source = new Parameter_EntityProperty (entitySource, property_source_define.mPropertyValueSourceDefine.mSpaceType, customPropertyId);
            }
         }
         
         if (value_source == null)
         {
            // before v2.05, 2 <- null + null 
            //value_source = new Parameter_DirectConstant (
            //                     Global.GetClassDefinition (classType, valueType),
            //                     CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, classType, valueType, defaultDirectValue, extraInfos)
            //                  );
            
            // since v2.05, 0 <- null + null
            var theClass:ClassDefinition = Global.sTheGlobal.GetClassDefinition (playerWorld, classType, valueType);
            value_source = new Parameter_DirectConstant (
                                 theClass,
                                 theClass.mGetNullFunc () // this function must be not null
                              );
            
         }
         
         return value_source;
      }
      
      public static function ValueTargetDefine2ReturnValueTarget (customFunctionDefinition:FunctionDefinition_Custom, playerWorld:World, valueTargetDefine:ValueTargetDefine, classType:int, valueType:int, extraInfos:Object):Parameter
      {
         var value_target:Parameter = null;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Null)
         {
            value_target = new Parameter ();
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Variable || target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            var value_space_type:int = variable_target_define.mSpaceType;
            var variable_index:int   = variable_target_define.mVariableIndex;
            
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_World:
                  // will not merge with new ones
                  variable_instance = (/*Global*/playerWorld.GetWorldVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GameSave:
                  // will not merge with new ones
                  variable_instance = (/*Global*/playerWorld.GetGameSaveVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Session:
                  if (variable_index >= 0)
                  {
                     //variable_index += extraInfos.mBeinningSessionVariableIndex;
                     variable_index = extraInfos.mSessionVariableIdMappingTable [variable_index];
                  }
                  variable_instance = (/*Global*/playerWorld.GetSessionVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  if (variable_index >= 0)
                     variable_index += extraInfos.mBeinningGlobalVariableIndex;
                  variable_instance = (/*Global*/playerWorld.GetGlobalVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
                  variable_instance = (/*Global*/playerWorld.GetCommonGlobalVariableSpace () as VariableSpace).GetVariableByIndex (variable_index);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Register:
                  if (classType == ClassTypeDefine.ClassType_Core)
                  {
                     var variable_space:VariableSpace = /*Global*/playerWorld.GetRegisterVariableSpace (valueType);
                     if (variable_space != null)
                        variable_instance = variable_space.GetVariableByIndex (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
               case ValueSpaceTypeDefine.ValueSpace_Output:
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  if (target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
                     value_target = customFunctionDefinition.CreateVariableParameter (value_space_type, variable_index, true, (variable_target_define as ValueTargetDefine_ObjectProperty).mPropertyIndex);
                  else
                     value_target = customFunctionDefinition.CreateVariableParameter (value_space_type, variable_index, false, -1);
                  
                  // variable_instance == null
                  break;
               default:
                  break;
            }
            
            if (variable_instance != null && variable_instance != VariableInstanceConstant.kVoidVariableInstance)
            {
               if (target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
                  value_target = new Parameter_ObjectProperty (variable_instance, (variable_target_define as ValueTargetDefine_ObjectProperty).mPropertyIndex);
               else
                  value_target = new Parameter_Variable (variable_instance);
            }
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            var property_target_define:ValueTargetDefine_EntityProperty = valueTargetDefine as ValueTargetDefine_EntityProperty;
            
            // here, assume property_source_define.mSpacePackageId is always 0.
            //var customPropertyId:int = property_target_define.mPropertyId as int;
            var customPropertyId:int = property_target_define.mPropertyValueTargetDefine.mVariableIndex as int;
            
            if (customPropertyId >= 0)
            {
               if (property_target_define.mPropertyValueTargetDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
               {
                  // do nothing
               }
               else // if (property_target_define.mPropertyValueTargetDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_EntityProperties) or 0
               {
                  customPropertyId += extraInfos.mBeinningCustomEntityVariableIndex;
               }
            }
            
            var entitySource:Parameter = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, property_target_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, null, extraInfos);
            if (property_target_define.mPropertyValueTargetDefine.GetValueTargetType () == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
            {
               var propertyPropertyIndex:int = (property_target_define.mPropertyValueTargetDefine as ValueTargetDefine_ObjectProperty).mPropertyIndex;
               if (propertyPropertyIndex >= 0)
               {
                  value_target = new Parameter_EntityPropertyProperty (entitySource, property_target_define.mPropertyValueTargetDefine.mSpaceType, customPropertyId, propertyPropertyIndex);
               }
            }
            else
            {
               value_target = new Parameter_EntityProperty (entitySource, property_target_define.mPropertyValueTargetDefine.mSpaceType, customPropertyId);
            }
         }
         
         if (value_target == null)
         {
            value_target = new Parameter ();
            
            //trace ("Error: target is null");
         }
         
         return value_target;
      }
      
      // supportInitalValues:Boolean param is not essential, for default value object is already set in LoadFromBinFile
      
      //public static function VariableSpaceDefine2VariableSpace (playerWorld:World, variableSpaceDefine:VariableSpaceDefine):VariableSpace // v1.52 only
      // if variableSpace is not null, append new one into it and return it.
      // playerWorld and customClassIdShiftOffset is meaningless for world scope variable spaces.
      public static function VariableDefines2VariableSpace (playerWorld:World, variableDefines:Array, variableSpace:VariableSpace, customClassIdShiftOffset:int, supportKeymapping:Boolean = false, varialbeIdMappingTable:Array = null):VariableSpace // supportInitalValues parameter:is not essential
      {
         var useIdMappingTable:Boolean = false;
         
         //var numVariables:int = variableSpaceDefine.mVariableDefines.length; // v1.52 only
         var numNewVariables:int = variableDefines == null ? 0 : variableDefines.length;
         var numOldVariables:int;
         if (variableSpace == null)
         {
            numOldVariables = 0;
            variableSpace = new VariableSpace (numNewVariables);
         }
         else
         {
            numOldVariables = variableSpace.GetNumVariables ();
            
            if (varialbeIdMappingTable == null)
            {  
               variableSpace.SetNumVariables (numOldVariables + numNewVariables);
            }
            else
            {
               useIdMappingTable = true;
            }
         }
         
         var newVariableIndexInSpace:int = numOldVariables;
         for (var variableId:int = 0; variableId < numNewVariables; ++ variableId)
         {
            //var variableDefine:VariableDefine = variableSpaceDefine.mVariableDefines [variableId] as VariableDefine; // v1.52 only
            var variableDefine:VariableDefine = variableDefines [variableId] as VariableDefine;
            var variableInstance:VariableInstance;
            
            if (useIdMappingTable)
            {
               variableInstance = variableSpace.GetVariableByKey (variableDefine.mKey);

               if (variableInstance != VariableInstanceConstant.kVoidVariableInstance)
               {
                  varialbeIdMappingTable [variableId] = variableInstance.GetDeclaration ().GetIndex ();
                  continue;
               }
            }
            
            //var direct_source_define:ValueSourceDefine_Direct = variableDefine.mDirectValueSourceDefine;
            
            if (useIdMappingTable)
            {
               variableSpace.SetNumVariables (newVariableIndexInSpace + 1);
            }
            
            variableInstance = variableSpace.GetVariableByIndex (newVariableIndexInSpace);
                  // msut be not null (VariableInstanceConstant.kVoidVariableInstance)
            
            //variableInstance.SetValueType (direct_source_define.mValueType);
            var valueType:int = variableDefine.mValueType;
            if (variableDefine.mClassType == ClassTypeDefine.ClassType_Custom) // since v2.05
            {
               if (playerWorld == null)
                  throw new Error ("Should not be a custom class!");
               
               valueType += customClassIdShiftOffset;
            }
            var classDefinition:ClassDefinition = CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Class, {mClassType : variableDefine.mClassType, mValueType : valueType}) as ClassDefinition;
            //variableInstance.SetShellClassDefinition (classDefinition);
            
            var varDeclaration:VariableDeclaration = new VariableDeclaration (classDefinition);
            varDeclaration.SetIndex (newVariableIndexInSpace);
            varDeclaration.SetKey (variableDefine.mKey);
            varDeclaration.SetName (variableDefine.mName);

            variableInstance.SetDeclaration (varDeclaration);
            
            variableInstance.SetRealClassDefinition (classDefinition);
            //if (playerWorld != null)
            //{
               //variableInstance.SetValueObject (CoreClassesHub.ValidateDirectValueObject_Define2Object (playerWorld, direct_source_define.mValueType, direct_source_define.mValueObject));
               variableInstance.SetValueObject (CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, variableInstance.GetRealClassType (), variableInstance.GetRealValueType (), variableDefine.mValueObject));
            //}
            
            if (useIdMappingTable)
            {
               varialbeIdMappingTable [variableId] = variableInstance.GetDeclaration ().GetIndex ();
            }
            
            if (supportKeymapping)
            {
               variableSpace.RegisterKeyValue (variableDefine.mKey, variableInstance);
            }

            ++ newVariableIndexInSpace;
         }
         
         return variableSpace;
      }
      
      // this function is for validating entity and ccat session variables when restarting a level
      // if variableDefines is not null, the length of variableSpace will be adjusted to variableDefines.length
      public static function ValidateVariableSpaceInitialValues (playerWorld:World, variableSpace:VariableSpace, variableDefines:Array, trimSpace:Boolean, tryToReSceneDependentVariables:Boolean):void
      {
         if (variableDefines != null && trimSpace)
            variableSpace.SetNumVariables (variableDefines.length);
         
         // ...
         
         var convertedArrays:Dictionary = new Dictionary ();
         
         var numVariables:int = variableSpace.GetNumVariables ();
         
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {  
            var variableInstance:VariableInstance = variableSpace.GetVariableByIndex (variableId);
                  // must be not null (VariableInstanceConstant.kVoidVariableInstance)
            
            variableInstance.SetValueObject (ValidateVariableValueObject (playerWorld, variableInstance.GetValueObject (), convertedArrays, tryToReSceneDependentVariables));
         }
      }
      
      private static function ValidateVariableValueObject (playerWorld:World, valueObject:Object, convertedArrays:Dictionary, tryToReSceneDependentVariables:Boolean):Object
      {
         if (valueObject is Entity)
         {
            var entity:Entity = valueObject as Entity;
            if (entity != null)
            {
               if (tryToReSceneDependentVariables)
                  return CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, entity.GetCreationId ());
               else
                  return null;
            }
         }
         else if (valueObject is CollisionCategory)
         {
            var ccat:CollisionCategory = valueObject as CollisionCategory;
            if (ccat != null)
            {
               if (tryToReSceneDependentVariables)
                  return CoreClassesHub.ValidateInitialDirectValueObject_Define2Object (playerWorld, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_CollisionCategory, ccat.GetCategoryIndex ());
               else
                  return null;
            }
         }
         // sound
         // module
         else if (valueObject is Array)
         {
            var anArray:Array = valueObject as Array;
            
            if (convertedArrays [anArray] == null)
            {
               convertedArrays [anArray] = true;
               
               for (var i:int = 0; i < anArray.length; ++ i)
               {
                  var element:Object = anArray [i];
                  
                  anArray [i] =  ValidateVariableValueObject (playerWorld, element, convertedArrays, tryToReSceneDependentVariables);
               }
            }
            
            return anArray;
         }
         
         return valueObject;
      }
      
//==============================================================================================
// byte array -> define
//==============================================================================================
      
      //public static function LoadFunctionDefineFromBinFile (binFile:ByteArray, functionDefine:FunctionDefine, hasParams:Boolean, loadVariables:Boolean, customFunctionDefines:Array, loadLocalVariables:Boolean = true):FunctionDefine
      public static function LoadFunctionDefineFromBinFile (worldVersion:int, binFile:ByteArray, functionDefine:FunctionDefine, loadParams:Boolean, loadLocalVariables:Boolean, customFunctionDefines:Array, supportCustomClasses:Boolean, customClassDefines:Array):FunctionDefine
      {
         if (functionDefine == null)
            functionDefine = new FunctionDefine ();
         
         //if (loadVariables)
         //{
            if (loadParams)
            {
               LoadVariableDefinesFromBinFile (binFile, functionDefine.mInputVariableDefines, true, false, null, supportCustomClasses);
               
               LoadVariableDefinesFromBinFile (binFile, functionDefine.mOutputVariableDefines, false, false, null, supportCustomClasses);
            }
            
            if (loadLocalVariables)
            {
               LoadVariableDefinesFromBinFile (binFile, functionDefine.mLocalVariableDefines, false, false, null, supportCustomClasses);
            }
         //}
         
         if (customFunctionDefines != null)
         {
            functionDefine.mCodeSnippetDefine = LoadCodeSnippetDefineFromBinFile (worldVersion, binFile, customFunctionDefines);
         }
         
         return functionDefine;
      }
      
      public static function LoadCodeSnippetDefineFromBinFile (worldVersion:int, binFile:ByteArray, customFunctionDefines:Array):CodeSnippetDefine
      {
         var codeSnippetDefine:CodeSnippetDefine = new CodeSnippetDefine ();
         
         codeSnippetDefine.mName = binFile.readUTF ();
         codeSnippetDefine.mNumCallings = binFile.readShort ();
         codeSnippetDefine.mFunctionCallingDefines = new Array (codeSnippetDefine.mNumCallings);
         for (var i:int = 0; i < codeSnippetDefine.mNumCallings; ++ i)
            codeSnippetDefine.mFunctionCallingDefines [i] = LoadFunctionCallingDefineFromBinFile (worldVersion, binFile, customFunctionDefines);
         
         return codeSnippetDefine;
      }
      
      public static function LoadFunctionCallingDefineFromBinFile (worldVersion:int, binFile:ByteArray, customFunctionDefines:Array):FunctionCallingDefine
      {
         var funcCallingDefine:FunctionCallingDefine = new FunctionCallingDefine ();
         
         var func_type:int;
         var func_id:int;
         
         var i:int;
         var num_inputs:int;
         var num_outputs:int;
         var inputValueSourceDefines:Array;
         var outputValueTargetDefines:Array;
         var vd:VariableDefine;
         
         funcCallingDefine.mFunctionType = func_type = binFile.readByte ();
         funcCallingDefine.mFunctionId = func_id = binFile.readShort ();
         
         if (worldVersion >= 0x0209)
         {  
            funcCallingDefine.mCommentDepth = num_inputs = binFile.readByte () & 0xFF;
         }
         
         funcCallingDefine.mNumInputs = num_inputs = binFile.readByte ();
         funcCallingDefine.mNumOutputs = num_outputs = binFile.readByte ();
         
         funcCallingDefine.mInputValueSourceDefines = inputValueSourceDefines = new Array (num_inputs);
         funcCallingDefine.mOutputValueTargetDefines = outputValueTargetDefines = new Array (num_outputs);
         
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            var func_declaration:FunctionCoreBasicDefine = CoreFunctionDeclarations.GetCoreFunctionDeclaration (func_id);
            
            for (i = 0; i < num_inputs; ++ i)
               inputValueSourceDefines [i] = LoadValueSourceDefineFromBinFile (binFile, ClassTypeDefine.ClassType_Core, func_declaration.GetInputParamValueType (i), func_declaration.GetInputNumberTypeDetailBit (i));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledInputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for (i = 0; i < num_inputs; ++ i)
            {
               //inputValueSourceDefines [i] = LoadValueSourceDefineFromBinFile (binFile, (calledInputVariableDefines [i] as VariableDefine).mDirectValueSourceDefine.mValueType, CoreClassIds.NumberTypeDetailBit_Double);
               vd = calledInputVariableDefines [i] as VariableDefine;
               inputValueSourceDefines [i] = LoadValueSourceDefineFromBinFile (binFile, vd.mClassType, vd.mValueType, CoreClassIds.NumberTypeDetailBit_Double);
            }
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         for (i = 0; i < num_outputs; ++ i)
            outputValueTargetDefines [i] = LoadValueTargetDefineFromBinFile (binFile);
         
         return funcCallingDefine;
      }
      
      public static function LoadValueSourceDefineFromBinFile (binFile:ByteArray, classType:int, valueType:int, numberDetail:int, forPropertyOfEntity:Boolean = false):ValueSourceDefine
      {
         var valueSourceDefine:ValueSourceDefine = null;
         
         var source_type:int = binFile.readByte ();
         
         //>>from v2.05
         // ! important
         if (forPropertyOfEntity)
         {
            if (source_type == 0) // or source_type != ValueSourceTypeDefine.ValueSource_ObjectProperty, only 2 possibilities
               source_type = ValueSourceTypeDefine.ValueSource_Variable; // in history, source_type for PropertyOfEntity is alwasy 0. 
         }
         //<<

         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            valueSourceDefine = new ValueSourceDefine_Direct (/*valueType, */CoreClassesHub.LoadDirectValueObjectFromBinFile (binFile, classType, valueType, numberDetail));
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable || source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
            {
               valueSourceDefine = new ValueSourceDefine_Variable (
                     binFile.readByte (),
                     binFile.readShort ()
                  );
            }
            else
            {
               valueSourceDefine = new ValueSourceDefine_ObjectProperty (
                     binFile.readByte (),
                     binFile.readShort (),
                     binFile.readShort ()
                  );
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            //>> before v2.05
            //valueSourceDefine = new ValueSourceDefine_EntityProperty (
            //      LoadValueSourceDefineFromBinFile (binFile, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, CoreClassIds.NumberTypeDetailBit_Double),
            //      //binFile.readShort (), // before v2.03
            //      (binFile.readByte () & 0x00) | binFile.readByte (), // from v2.03
            //      binFile.readShort ()
            //   );
            //<<
            
            //sine v2.05
            valueSourceDefine = new ValueSourceDefine_EntityProperty (
                  LoadValueSourceDefineFromBinFile (binFile, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, CoreClassIds.NumberTypeDetailBit_Double),
                  LoadValueSourceDefineFromBinFile (binFile, classType, valueType, CoreClassIds.NumberTypeDetailBit_Double, true) as ValueSourceDefine_Variable
               );
            //<<
         }
         
         if (valueSourceDefine == null)
         {
            valueSourceDefine = new ValueSourceDefine_Null ();
         }
         
         return valueSourceDefine;
      }
      
      public static function LoadValueTargetDefineFromBinFile (binFile:ByteArray, forPropertyOfEntity:Boolean = false):ValueTargetDefine
      {
         var valueTargetDefine:ValueTargetDefine = null;
         
         var target_type:int = binFile.readByte ();
         
         //>>from v2.05
         // ! important
         if (forPropertyOfEntity)
         {
            if (target_type == 0) // or source_type != ValueTargetTypeDefine.ValueTarget_ObjectProperty, only 2 possibilities
               target_type = ValueTargetTypeDefine.ValueTarget_Variable; // in history, target_type for PropertyOfEntity is alwasy 0. 
         }
         //<<
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable || target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
            {
               valueTargetDefine = new ValueTargetDefine_Variable (
                     binFile.readByte (),
                     binFile.readShort ()
                  );
            }
            else
            {
               valueTargetDefine = new ValueTargetDefine_ObjectProperty (
                     binFile.readByte (),
                     binFile.readShort (),
                     binFile.readShort ()
                  );
            }
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            //>> before v2.05
            //valueTargetDefine = new ValueTargetDefine_EntityProperty (
            //      LoadValueSourceDefineFromBinFile (binFile, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, CoreClassIds.NumberTypeDetailBit_Double),
            //      //binFile.readShort (), // before v2.03
            //      (binFile.readByte () & 0x00) | binFile.readByte (), // from v2.03
            //      binFile.readShort ()
            //   );
            //<<
            
            //sine v2.05
            valueTargetDefine = new ValueTargetDefine_EntityProperty (
                  LoadValueSourceDefineFromBinFile (binFile, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, CoreClassIds.NumberTypeDetailBit_Double),
                  LoadValueTargetDefineFromBinFile (binFile, true) as ValueTargetDefine_Variable
               );
            //<<
         }
         
         if (valueTargetDefine == null)
         {
            valueTargetDefine = new ValueTargetDefine_Null ();
         }
         
         return valueTargetDefine;
      }
      
      //public static function LoadVariableSpaceDefineFromBinFile (binFile:ByteArray):VariableSpaceDefine // v1.52 only
      public static function LoadVariableDefinesFromBinFile (binFile:ByteArray, variableDefines:Array, supportInitalValues:Boolean, variablesHaveKey:Boolean, keyPostfix:String, supportCustomClasses:Boolean):void
      {
         //>> only v1.52
         //var variableSpaceDefine:VariableSpaceDefine = new VariableSpaceDefine ();
         //
         //variableSpaceDefine.mName = binFile.readUTF ();
         //variableSpaceDefine.mParentPackageId = binFile.readShort ();
         //<<
         
         var numVariables:int = binFile.readShort ();
         //variableSpaceDefine.mVariableDefines = new Array (numVariables); // v1.52 only
         var classType:int;
         var valueType:int;
         
         for (var i:int = 0; i < numVariables; ++ i)
         {
            var variableDefine:VariableDefine = new VariableDefine ();
            
            if (variablesHaveKey)
            {
               variableDefine.mKey = binFile.readUTF ();
            }
            else if (keyPostfix != null)
            {
               variableDefine.mKey = i + keyPostfix; // for session variables in runtime playing
            }
            variableDefine.mName = binFile.readUTF ();
            if (supportCustomClasses)
               classType = binFile.readByte ();
            else
               classType = ClassTypeDefine.ClassType_Core;
            
            valueType = binFile.readShort ();
            //variableDefine.mDirectValueSourceDefine = new ValueSourceDefine_Direct (
            //                                                valueType,
            //                                                supportInitalValues ? CoreClassesHub.LoadDirectValueObjectFromBinFile (binFile, valueType, CoreClassIds.NumberTypeDetailBit_Double) : CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (valueType)
            //                                                );
            variableDefine.mClassType = classType;
            variableDefine.mValueType = valueType;
            variableDefine.mValueObject = supportInitalValues ? CoreClassesHub.LoadDirectValueObjectFromBinFile (binFile, classType, valueType, CoreClassIds.NumberTypeDetailBit_Double) : CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (valueType);
            
            //variableSpaceDefine.mVariableDefines [i] = variableDefine; // v1.52 only
            variableDefines.push (variableDefine);
         }
         
         //return variableSpaceDefine; // v1.52 only
      }
      
//==============================================================================================
// define -> xml
//==============================================================================================
      
      //public static function FunctionDefine2Xml (functionDefine:FunctionDefine, functionElement:XML, hasParams:Boolean, convertVariables:Boolean, customFunctionDefines:Array, convertLocalVariables:Boolean = true, codeSnippetElement:XML = null):void
      public static function FunctionDefine2Xml (worldVersion:int, functionDefine:FunctionDefine, functionElement:XML, convertParams:Boolean, convertLocalVariables:Boolean, customFunctionDefines:Array, codeSnippetElement:XML, supportCustomClasses:Boolean, customClassDefines:Array):void
      {
         //if (convertVariables)
         //{
            if (convertParams)
            {
               functionElement.InputParameters = <InputParameters/>;
               VariablesDefine2Xml (functionDefine.mInputVariableDefines, functionElement.InputParameters [0], true, false, supportCustomClasses);
               
               functionElement.OutputParameters = <OutputParameters/>;
               VariablesDefine2Xml (functionDefine.mOutputVariableDefines, functionElement.OutputParameters [0], false, false, supportCustomClasses);
            }
            
            if (convertLocalVariables)
            {
               functionElement.LocalVariables = <LocalVariables/>;
               VariablesDefine2Xml (functionDefine.mLocalVariableDefines, functionElement.LocalVariables [0], false, false, supportCustomClasses);
            }
         //}
         
         if (customFunctionDefines != null)
         {
            functionElement.appendChild (CodeSnippetDefine2Xml (worldVersion, codeSnippetElement, functionDefine.mCodeSnippetDefine, customFunctionDefines));
         }
      }
      
      public static function CodeSnippetDefine2Xml (worldVersion:int, elementCodeSnippet:XML, codeSnippetDefine:CodeSnippetDefine, customFunctionDefines:Array):XML
      {
         if (elementCodeSnippet == null)
         {
            elementCodeSnippet = <CodeSnippet />;
         }
         
         elementCodeSnippet.@name = codeSnippetDefine.mName;
         
         var num:int = codeSnippetDefine.mNumCallings;
         var functionCallings:Array = codeSnippetDefine.mFunctionCallingDefines;
         for (var i:int = 0; i < num; ++ i)
         {
            elementCodeSnippet.appendChild (FunctionCallingDefine2Xml (worldVersion, functionCallings[i], customFunctionDefines));
         }
         
         //trace ("elementCodeSnippet = " + elementCodeSnippet.toXMLString ());
         
         return elementCodeSnippet;
      }
      
      public static function FunctionCallingDefine2Xml (worldVersion:int, funcCallingDefine:FunctionCallingDefine, customFunctionDefines:Array):XML
      {
         var func_type:int = funcCallingDefine.mFunctionType;
         var func_id:int = funcCallingDefine.mFunctionId;
         var func_declaration:FunctionCoreBasicDefine = CoreFunctionDeclarations.GetCoreFunctionDeclaration (func_id)
         
         var elementFunctionCalling:XML = <FunctionCalling />;
         
         elementFunctionCalling.@function_type = funcCallingDefine.mFunctionType;
         elementFunctionCalling.@function_id = funcCallingDefine.mFunctionId;
         
         if (worldVersion >= 0x0209)
         {
            elementFunctionCalling.@comment_depth = funcCallingDefine.mCommentDepth;
         }
         
         var i:int;
         var vd:VariableDefine;
         var num_inputs:int = funcCallingDefine.mNumInputs;
         var inputValueSourceDefines:Array = funcCallingDefine.mInputValueSourceDefines;
         
         elementFunctionCalling.InputValueSources = <InputValueSources />;
         
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            for (i = 0; i < num_inputs; ++ i)
               elementFunctionCalling.InputValueSources.appendChild (ValueSourceDefine2Xml (inputValueSourceDefines [i], ClassTypeDefine.ClassType_Core, func_declaration.GetInputParamValueType (i)));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledInputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for (i = 0; i < num_inputs; ++ i)
            {
               //elementFunctionCalling.InputValueSources.appendChild (ValueSourceDefine2Xml (inputValueSourceDefines [i], (calledInputVariableDefines [i] as VariableDefine).mDirectValueSourceDefine.mValueType));
               vd = calledInputVariableDefines [i] as VariableDefine;
               elementFunctionCalling.InputValueSources.appendChild (ValueSourceDefine2Xml (inputValueSourceDefines [i], vd.mClassType, vd.mValueType));
            }
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         var num_outputs:int = funcCallingDefine.mNumOutputs;
         var outputValueTargetDefines:Array = funcCallingDefine.mOutputValueTargetDefines;
         elementFunctionCalling.OutputValueTargets = <OutputValueTargets />
         
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            for (i = 0; i < num_outputs; ++ i)
               elementFunctionCalling.OutputValueTargets.appendChild (ValueTargetDefine2Xml (outputValueTargetDefines [i]));//, func_declaration.GetOutputParamValueType (i)));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledOutputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mOutputVariableDefines;
            
            for (i = 0; i < num_outputs; ++ i)
            {
               //elementFunctionCalling.OutputValueTargets.appendChild (ValueTargetDefine2Xml (outputValueTargetDefines [i], (calledOutputVariableDefines [i] as VariableDefine).mDirectValueSourceDefine.mValueType));
               elementFunctionCalling.OutputValueTargets.appendChild (ValueTargetDefine2Xml (outputValueTargetDefines [i]));//, (calledOutputVariableDefines [i] as VariableDefine).mValueType));
            }
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         return elementFunctionCalling;
      }
      
      public static function ValueSourceDefine2Xml (valueSourceDefine:ValueSourceDefine, classType:int, valueType:int, isForProperyOwner:Boolean = false, forPropertyOfEntity:Boolean = false):XML
      {
         var elementValueSource:XML;
         
         if (forPropertyOfEntity)
            elementValueSource = <PropertyVariableValueSource />;
         else if (isForProperyOwner)
            elementValueSource = <PropertyOwnerValueSource />;
         else
            elementValueSource = <ValueSource />;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         elementValueSource.@type = source_type;
         
         //>> sine v2.05
         // no needs
         //if (forPropertyOfEntity)
         //{
         //   //if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         //   source_type = ValueSourceTypeDefine.ValueSource_ObjectProperty; // the only possibility
         //}
         //<<
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            try
            {
               var directValue:Object = CoreClassesHub.ValidateDirectValueObject_Define2Xml (classType, valueType, direct_source_define.mValueObject);
               if (directValue != null)// now, for Array and custom classes.
               {
                  elementValueSource.@direct_value = directValue;
               }
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable || source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            elementValueSource.@variable_space = variable_source_define.mSpaceType;
            elementValueSource.@variable_index = variable_source_define.mVariableIndex;
            
            if (source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
            {
               elementValueSource.@object_property_index = (variable_source_define as ValueSourceDefine_ObjectProperty).mPropertyIndex;
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            var property_source_define:ValueSourceDefine_EntityProperty = valueSourceDefine as ValueSourceDefine_EntityProperty;
            
            elementValueSource.appendChild (ValueSourceDefine2Xml (property_source_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, true, false));

            // for compability, non-object-property source still uses the old style
            if (property_source_define.mPropertyValueSourceDefine.GetValueSourceType () == ValueSourceTypeDefine.ValueSource_Variable)
            {
               //>>before v2.05
               //elementValueSource.@property_package_id = property_source_define.mSpacePackageId;
               //elementValueSource.@property_id = property_source_define.mPropertyId;
               elementValueSource.@property_package_id = property_source_define.mPropertyValueSourceDefine.mSpaceType;
               elementValueSource.@property_id = property_source_define.mPropertyValueSourceDefine.mVariableIndex;
               //<<
            }
            else // ValueSourceTypeDefine.ValueSource_ObjectProperty, new style for object property since c2.05
            {
               //from v2.05
               elementValueSource.appendChild (ValueSourceDefine2Xml (property_source_define.mPropertyValueSourceDefine, classType, valueType, false, true));
               //<<
            }
         }
         
         return elementValueSource;
      }
      
      public static function ValueTargetDefine2Xml (valueTargetDefine:ValueTargetDefine, forPropertyOfEntity:Boolean = false):XML
      {
         var elementValueTarget:XML;
         
         if (forPropertyOfEntity)
            elementValueTarget = <PropertyVariableValueTarget />;
         else
            elementValueTarget = <ValueTarget />;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         //>> sine v2.05
         // no needs
         //if (forPropertyOfEntity)
         //{
         //   //if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         //   target_type = ValueTargetTypeDefine.ValueTarget_ObjectProperty; // the only possibility
         //}
         //<<
         
         elementValueTarget.@type = target_type;
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable || target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            elementValueTarget.@variable_space = variable_target_define.mSpaceType;
            elementValueTarget.@variable_index = variable_target_define.mVariableIndex;
            
            if (target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
            {
               elementValueTarget.@object_property_index = (variable_target_define as ValueTargetDefine_ObjectProperty).mPropertyIndex;
            }
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            var property_target_define:ValueTargetDefine_EntityProperty = valueTargetDefine as ValueTargetDefine_EntityProperty;
            
            elementValueTarget.appendChild (ValueSourceDefine2Xml (property_target_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, true, false));
            

            // for compability, non-object-property source still uses the old style
            if (property_target_define.mPropertyValueTargetDefine.GetValueTargetType () == ValueTargetTypeDefine.ValueTarget_Variable)
            {
               //>>before v2.05
               //elementValueTarget.@property_package_id = property_target_define.mSpacePackageId;
               //elementValueTarget.@property_id = property_target_define.mPropertyId;
               elementValueTarget.@property_package_id = property_target_define.mPropertyValueTargetDefine.mSpaceType;
               elementValueTarget.@property_id = property_target_define.mPropertyValueTargetDefine.mVariableIndex;
               //<<
            }
            else // ValueTargetTypeDefine.ValueTarget_ObjectProperty, new style for object property since c2.05
            {
               //from v2.05
               elementValueTarget.appendChild (ValueTargetDefine2Xml (property_target_define.mPropertyValueTargetDefine, true));
               //<<
            }
         }
         
         return elementValueTarget;
      }
      
      //public static function VariableSpaceDefine2Xml (variableSpaceDefine:VariableSpaceDefine):XML // v1.52 only
      public static function VariablesDefine2Xml (variableDefines:Array, elementVariablePackage:XML, supportInitalValues:Boolean, variablesHaveKey:Boolean, supportCustomClasses:Boolean):void
      {
         //>> v1.52 only
         //var elementVariablePackage:XML = <VariablePackage />;
         //
         //elementVariablePackage.@name = variableSpaceDefine.mName;
         //elementVariablePackage.@package_id = variableSpaceDefine.mPackageId;
         //elementVariablePackage.@parent_package_id = variableSpaceDefine.mParentPackageId;
         //<<
         
         var variableDefine:VariableDefine;
         var element:Object;;
         
         //var numVariables:int = variableSpaceDefine.mVariableDefines.length; // v1.52 only
         var numVariables:int = variableDefines.length;
         for (var variableIndex:int = 0; variableIndex < numVariables; ++ variableIndex)
         {
            //variableDefine = variableSpaceDefine.mVariableDefines [variableIndex] as VariableDefine; // v1.52 only
            variableDefine = variableDefines [variableIndex] as VariableDefine;
            
            element = <Variable />;
            if (variablesHaveKey)
               element.@key = variableDefine.mKey;
            element.@name = variableDefine.mName;
            //element.@value_type = variableDefine.mDirectValueSourceDefine.mValueType;
            if (supportCustomClasses)
               element.@class_type = variableDefine.mClassType;
            element.@value_type = variableDefine.mValueType;
            
            if (supportInitalValues)
            {
               //var directValue:Object = CoreClassesHub.ValidateDirectValueObject_Define2Xml (variableDefine.mDirectValueSourceDefine.mValueType, variableDefine.mDirectValueSourceDefine.mValueObject);
               var directValue:Object = CoreClassesHub.ValidateDirectValueObject_Define2Xml (variableDefine.mClassType, variableDefine.mValueType, variableDefine.mValueObject);
               if (directValue != null)
               {
                  element.@initial_value = directValue;
               }
            }
            
            elementVariablePackage.appendChild (element);
         }
         
         //return elementVariablePackage; // v1.52 only
      }
      
//========================================================================================
// 
//========================================================================================
      
      // float -> 6 precisions, double -> 12 precisions
      public static function AdjustNumberPrecisionsInFunctionDefine (functionDefine:FunctionDefine):void
      {
         AdjustNumberPrecisionsInVariableDefines (functionDefine.mInputVariableDefines);
         // output and local variables have no default values now.
         
         AdjustNumberPrecisionsInCodeSnippetDefine (functionDefine.mCodeSnippetDefine);
      }
      
      public static function AdjustNumberPrecisionsInCodeSnippetDefine (codeSnippetDefine:CodeSnippetDefine):void
      {
         var funcCallingDefine:FunctionCallingDefine;
         var i:int;
         var numCallings:int = codeSnippetDefine.mNumCallings;
         for (i = 0; i < numCallings; ++ i)
         {
            funcCallingDefine = codeSnippetDefine.mFunctionCallingDefines [i];
            
            if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
            {
               var functionId:int = funcCallingDefine.mFunctionId;
               var funcDclaration:FunctionCoreBasicDefine = CoreFunctionDeclarations.GetCoreFunctionDeclaration (functionId);
               
               var sourceDefine:ValueSourceDefine;
               var direcSourceDefine:ValueSourceDefine_Direct;
               var sourceValueType:int;
               var valueType:int;
               var directNumber:Number;
               var numberDetail:int;
               var numInputs:int = funcCallingDefine.mNumInputs;
               var j:int;
               for (j = 0; j < numInputs; ++ j)
               {
                  sourceDefine = funcCallingDefine.mInputValueSourceDefines [j];
                  sourceValueType = sourceDefine.GetValueSourceType ();
                  valueType = funcDclaration.GetInputParamValueType (j);
                  
                  if (sourceValueType == ValueSourceTypeDefine.ValueSource_Direct)
                  {
                     direcSourceDefine = sourceDefine as ValueSourceDefine_Direct;
                     
                     if (valueType == CoreClassIds.ValueType_Number)
                     {
                        directNumber = Number (direcSourceDefine.mValueObject);
                        numberDetail = funcDclaration.GetInputNumberTypeDetailBit (j);
                        
                        switch (numberDetail)
                        {
                           case CoreClassIds.NumberTypeDetailBit_Single:
                              directNumber = ValueAdjuster.Number2Precision (directNumber, 6);
                              break;
                           case CoreClassIds.NumberTypeDetailBit_Integer:
                              directNumber = Math.round (directNumber);
                              break;
                           case CoreClassIds.NumberTypeDetailBit_Double:
                           default:
                              directNumber = ValueAdjuster.Number2Precision (directNumber, 12);
                              break;
                        }
                        
                        direcSourceDefine.mValueObject = directNumber;
                     }
                  }
               }
            }
            else
            {
            }
         }
      }
      
      //public static function AdjustNumberPrecisionsInVariableSpaceDefine (variableSpaceDefine:VariableSpaceDefine):void // v1.52 only
      public static function AdjustNumberPrecisionsInVariableDefines (variableDefines:Array):void
      {
         //var numVariables:int = variableSpaceDefine.mVariableDefines.length; // v1.52 only
         var numVariables:int = variableDefines.length;
         
         var directNumber:Number;
         for (var i:int = 0; i < numVariables; ++ i)
         {
            //var variableDefine:VariableDefine = variableSpaceDefine.mVariableDefines [i] as VariableDefine; // v1.52 only
            var variableDefine:VariableDefine = variableDefines [i] as VariableDefine;
            
            //if (variableDefine.mDirectValueSourceDefine.mValueType == CoreClassIds.ValueType_Number)
            //{
            //   directNumber = Number (variableDefine.mDirectValueSourceDefine.mValueObject);
            //   variableDefine.mDirectValueSourceDefine.mValueObject = ValueAdjuster.Number2Precision (directNumber, 12);
            //}
            if (variableDefine.mValueType == CoreClassIds.ValueType_Number)
            {
               directNumber = Number (variableDefine.mValueObject);
               variableDefine.mValueObject = ValueAdjuster.Number2Precision (directNumber, 12);
            }
         }
      }
      
      // it is possible some new parameters are appended in a newer version for some functions
      public static function FillMissedFieldsInFunctionDefine (functionDefine:FunctionDefine):void
      {
      }
   }
}
