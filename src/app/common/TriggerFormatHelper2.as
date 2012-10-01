
package common {
   
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   import player.design.Global;
   import player.world.World;
   import player.entity.Entity;
   import player.world.CollisionCategory;
   
   import player.trigger.FunctionDefinition;
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.FunctionDefinition_Custom;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition;
   import player.trigger.FunctionDefinition_Custom;
   import player.trigger.CodeSnippet;
   import player.trigger.FunctionCalling;
   import player.trigger.FunctionCalling_Condition;
   import player.trigger.FunctionCalling_ConditionWithComparer;
   import player.trigger.FunctionCalling_Dummy;
   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;
   import player.trigger.Parameter_Variable;
   import player.trigger.Parameter_VariableRef;
   import player.trigger.Parameter_Property;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.FunctionDeclaration;
   import common.trigger.CoreFunctionDeclarations;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.trigger.define.FunctionDefine;
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionCallingDefine;
   import common.trigger.define.ValueSourceDefine;
   import common.trigger.define.ValueSourceDefine_Null;
   import common.trigger.define.ValueSourceDefine_Direct;
   import common.trigger.define.ValueSourceDefine_Variable;
   import common.trigger.define.ValueSourceDefine_Property;
   import common.trigger.define.ValueTargetDefine;
   import common.trigger.define.ValueTargetDefine_Null;
   import common.trigger.define.ValueTargetDefine_Variable;
   import common.trigger.define.ValueTargetDefine_Property;
   
   //import common.trigger.define.VariableSpaceDefine;
   import common.trigger.define.VariableInstanceDefine;
   
   import common.trigger.parse.CodeSnippetParser;
   
   import common.trigger.parse.FunctionCallingBlockInfo;
   import common.trigger.parse.FunctionCallingBranchInfo;
   import common.trigger.parse.FunctionCallingLineInfo;
   
   import common.CoordinateSystem;
   
   public class TriggerFormatHelper2
   {
      
      public static function BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration:FunctionDeclaration, forInputParams:Boolean):Array
      {
         var paramDefines:Array = null;
         
         var i:int;
         
         if (forInputParams)
         {
            var numInputs:int = functionDeclaration.GetNumInputs ();
            if (numInputs > 0)
            {
               paramDefines = new Array (numInputs);
               
               for (i =  0; i < numInputs; ++ i)
               {
                  paramDefines [i] = new ValueSourceDefine_Direct (functionDeclaration.GetInputParamValueType (i), functionDeclaration.GetInputParamDefaultValue (i));
               }
            }
         }
         else
         {
            var numOutputs:int = functionDeclaration.GetNumOutputs ();
            if (numOutputs > 0)
            {
               paramDefines = new Array (numOutputs);
               
               for (i =  0; i < numOutputs; ++ i)
               {
                  paramDefines [i] = functionDeclaration.GetOutputParamValueType (i);
               }
            }
         }
         
         return paramDefines;
      }
      
      public static function BuildParamDefinesFormVariableDefines (inputVariableDefines:Array, forInputParams:Boolean):Array
      {
         var paramDefines:Array = null;
         
         var i:int;
         var variableInstanceDefine:VariableInstanceDefine;
         var direct_source_define:ValueSourceDefine_Direct;
         
         if (forInputParams)
         {
            var numInputs:int = inputVariableDefines.length;
            if (numInputs > 0)
            {
               paramDefines = new Array (numInputs);
               
               for (i =  0; i < numInputs; ++ i)
               {
                  variableInstanceDefine = inputVariableDefines [i] as VariableInstanceDefine;
                  direct_source_define = variableInstanceDefine.mDirectValueSourceDefine;
                  
                  paramDefines [i] = new ValueSourceDefine_Direct (direct_source_define.mValueType, direct_source_define.mValueObject);
               }
            }
         }
         else
         {
            var numOutputs:int = inputVariableDefines.length;
            if (numOutputs > 0)
            {
               paramDefines = new Array (numOutputs);
               
               for (i =  0; i < numOutputs; ++ i)
               {
                  variableInstanceDefine = inputVariableDefines [i] as VariableInstanceDefine;
                  direct_source_define = variableInstanceDefine.mDirectValueSourceDefine;
                  
                  paramDefines [i] = direct_source_define.mValueType;
               }
            }
         }
         
         return paramDefines;
      }
      
      public static function CreateCoreFunctionDefinition (functionDeclaration:FunctionDeclaration, callback:Function):FunctionDefinition_Core
      {
         return new FunctionDefinition_Core (BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration, true), BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration, false), callback);
      }
      
//==============================================================================================
// define -> definition (player)
//==============================================================================================
      
      // for functionDefine and functionDeclaration, at least one is not null
      public static function FunctionDefine2FunctionDefinition (functionDefine:FunctionDefine, functionDeclaration:FunctionDeclaration):FunctionDefinition_Custom
      {
         var numLocals:int = functionDefine.mLocalVariableDefines == null ? 0 : functionDefine.mLocalVariableDefines.length;
         var costomFunction:FunctionDefinition_Custom;
         if (functionDeclaration != null)
         {
            costomFunction = new FunctionDefinition_Custom (BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration, true), BuildParamDefinesDefinesFormFunctionDeclaration (functionDeclaration, false), numLocals);
         }
         else
         {
            costomFunction = new FunctionDefinition_Custom (BuildParamDefinesFormVariableDefines (functionDefine.mInputVariableDefines, true), BuildParamDefinesFormVariableDefines (functionDefine.mOutputVariableDefines, false), numLocals);
         }
         
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
            callingInfo.mFunctionCallingDefine = callingDefine;
         }
         
         // create valid callings
         
         var numValidCallings:int = CodeSnippetParser.ParseCodeSnippet (callingInfos);
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
            func_definition = Global.GetCustomFunctionDefinition (function_id + extraInfos.mBeginningCustomFunctionIndex);
         }
         else if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         // assert (func_definition != null)
         
         var real_num_input_params:int = func_definition.GetNumInputParameters ();
         var dafault_value_source_define:ValueSourceDefine_Direct;
         
         var real_num_output_params:int = func_definition.GetNumOutputParameters ();
         var dafault_value_target_define:ValueSourceDefine_Direct;
         
         var i:int;
         
         var value_source_list:Parameter = null;
         var value_source:Parameter;
         for (i = real_num_input_params - 1; i >= 0; -- i)
         {
            dafault_value_source_define = func_definition.GetDefaultInputValueSourceDefine (i);
            
            if (i >= funcCallingDefine.mNumInputs) // fill the missed parameters
               value_source = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, dafault_value_source_define, dafault_value_source_define.mValueType, dafault_value_source_define.mValueObject, extraInfos);
            else                                   // use the value set by designer
               value_source = ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, funcCallingDefine.mInputValueSourceDefines [i], dafault_value_source_define.mValueType, dafault_value_source_define.mValueObject, extraInfos);
               
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
               value_target = ValueTargetDefine2ReturnValueTarget (customFunctionDefinition, playerWorld, funcCallingDefine.mOutputValueTargetDefines [i], func_definition.GetOutputParamValueType (i), extraInfos);
            
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
      
      public static function ValueSourceDefine2InputValueSource (customFunctionDefinition:FunctionDefinition_Custom, playerWorld:World, valueSourceDefine:ValueSourceDefine, valueType:int, defaultDirectValue:Object, extraInfos:Object):Parameter
      {
         var value_source:Parameter = null;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            //assert (valueType == direct_source_define.mValueType);
            
            value_source = new Parameter_Direct (ValidateDirectValueObject_Define2Object (playerWorld, valueType, direct_source_define.mValueObject, extraInfos));
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var value_space_type:int = variable_source_define.mSpaceType;
            var variable_index:int   = variable_source_define.mVariableIndex;
            
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Session:
                  if (variable_index >= 0)
                     variable_index += extraInfos.mBeinningSessionVariableIndex;
                  variable_instance = (Global.GetSessionVariableSpace () as VariableSpace).GetVariableAt (variable_index);
                  if (variable_instance != null)
                     value_source = new Parameter_Variable (variable_instance);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  if (variable_index >= 0)
                     variable_index += extraInfos.mBeinningGlobalVariableIndex;
                  variable_instance = (Global.GetGlobalVariableSpace () as VariableSpace).GetVariableAt (variable_index);
                  if (variable_instance != null)
                     value_source = new Parameter_Variable (variable_instance);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Register:
                  var variable_space:VariableSpace = Global.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableAt (variable_index);
                     if (variable_instance != null)
                        value_source = new Parameter_Variable (variable_instance);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
               case ValueSpaceTypeDefine.ValueSpace_Output:
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  value_source = customFunctionDefinition.CreateVariableParameter (value_space_type, variable_index, false);
                  break;
               default:
                  break;
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Property)
         {
            var property_source_define:ValueSourceDefine_Property = valueSourceDefine as ValueSourceDefine_Property;
            
            // here, assume property_source_define.mSpacePackageId is always 0.
            var customPropertyId:int = property_source_define.mPropertyId as int;
            if (customPropertyId >= 0)
               customPropertyId += extraInfos.mBeinningCustomEntityVariableIndex;
            value_source = new Parameter_Property (ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, property_source_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, null, extraInfos)
                                                      , property_source_define.mSpacePackageId, customPropertyId);
         }
         
         if (value_source == null)
         {
            value_source = new Parameter_Direct (ValidateDirectValueObject_Define2Object (playerWorld, valueType, defaultDirectValue, extraInfos));
         }
         
         return value_source;
      }
      
      public static function ValueTargetDefine2ReturnValueTarget (customFunctionDefinition:FunctionDefinition_Custom, playerWorld:World, valueTargetDefine:ValueTargetDefine, valueType:int, extraInfos:Object):Parameter
      {
         var value_target:Parameter = null;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Null)
         {
            value_target = new Parameter ();
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            var value_space_type:int = variable_target_define.mSpaceType;
            var variable_index:int   = variable_target_define.mVariableIndex;
            
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Session:
                  if (variable_index >= 0)
                     variable_index += extraInfos.mBeinningSessionVariableIndex;
                  variable_instance = (Global.GetSessionVariableSpace () as VariableSpace).GetVariableAt (variable_index);
                  if (variable_instance != null)
                     value_target = new Parameter_Variable (variable_instance);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  if (variable_index >= 0)
                     variable_index += extraInfos.mBeinningGlobalVariableIndex;
                  variable_instance = (Global.GetGlobalVariableSpace () as VariableSpace).GetVariableAt (variable_index);
                  if (variable_instance != null)
                     value_target = new Parameter_Variable (variable_instance);
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Register:
                  var variable_space:VariableSpace = Global.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableAt (variable_index);
                     if (variable_instance != null)
                        value_target = new Parameter_Variable (variable_instance);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
               case ValueSpaceTypeDefine.ValueSpace_Output:
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  value_target = customFunctionDefinition.CreateVariableParameter (value_space_type, variable_index, true);
                  break;
               default:
                  break;
            }
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Property)
         {
            var property_target_define:ValueTargetDefine_Property = valueTargetDefine as ValueTargetDefine_Property;
            
            // here, assume property_source_define.mSpacePackageId is always 0.
            var customPropertyId:int = property_target_define.mPropertyId as int;
            if (customPropertyId >= 0)
               customPropertyId += extraInfos.mBeinningCustomEntityVariableIndex;
            value_target = new Parameter_Property (ValueSourceDefine2InputValueSource (customFunctionDefinition, playerWorld, property_target_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, null, extraInfos)
                                                      , property_target_define.mSpacePackageId, customPropertyId);
         }
         
         if (value_target == null)
         {
            value_target = new Parameter ();
            
            //trace ("Error: target is null");
         }
         
         return value_target;
      }
      
      private static function ValidateDirectValueObject_Define2Object (playerWorld:World, valueType:int, valueObject:Object, extraInfos:Object = null):Object
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return valueObject as Boolean;
            case ValueTypeDefine.ValueType_Number:
               return valueObject as Number;
            case ValueTypeDefine.ValueType_String:
               return valueObject as String;
            case ValueTypeDefine.ValueType_Entity:
            {
               var entityIndex:int = valueObject as int;
               if (entityIndex < 0)
               {
                  if (entityIndex == Define.EntityId_Ground)
                     return playerWorld;
                  else // if (entityIndex == Define.EntityId_None)
                     return null;
               }
               else
               {
                  if (extraInfos != null)
                     entityIndex = extraInfos.mEntityIdCorrectionTable [entityIndex];
                  //return playerWorld.GetEntityByCreateOrderId (entityIndex, false); // must be an entity placed in editor (before v2.02)
                  return playerWorld.GetEntityByCreateOrderId (entityIndex, true); // may be an entity runtime created (from v2.02, merging scene is added)
               }
            }
            case ValueTypeDefine.ValueType_CollisionCategory:
            {
               var ccatIndex:int = valueObject as int;
               if (ccatIndex >= 0 && extraInfos != null)
                  ccatIndex += extraInfos.mBeinningCCatIndex;
               return playerWorld.GetCollisionCategoryById (ccatIndex);
            }
            case ValueTypeDefine.ValueType_Module:
            {
               var moduleIndex:int = valueObject as int;
               //return Global.GetImageModuleByGlobalIndex (moduleIndex);
               return moduleIndex;
            }
            case ValueTypeDefine.ValueType_Sound:
            {
               var soundIndex:int = valueObject as int;
               //return Global.GetSoundByIndex (soundIndex);
               return soundIndex;
            }
            case ValueTypeDefine.ValueType_Scene:
            {
               var sceneIndex:int = valueObject as int;
               //return Global.GetSceneByIndex (sceneIndex);
               return sceneIndex;
            }
            case ValueTypeDefine.ValueType_Array:
               //if (valueObject == null)
               //{
                  return null;
               //}
               //else
               //{
               //   
               //}
            default:
            {
               return null;
            }
         }
      }
      
      //public static function VariableSpaceDefine2VariableSpace (playerWorld:World, variableSpaceDefine:VariableSpaceDefine):VariableSpace // v1.52 only
      // if variableSpace is not null, append new one into it and return it.
      public static function VariableDefines2VariableSpace (playerWorld:World, variableDefines:Array, variableSpace:VariableSpace):VariableSpace // supportInitalValues parameter:is not essential
      {
         //var numVariables:int = variableSpaceDefine.mVariableDefines.length; // v1.52 only
         var numNewVariables:int = variableDefines.length;
         var numOldVariables:int;
         if (variableSpace == null)
         {
            numOldVariables = 0;
            variableSpace = new VariableSpace (numNewVariables);
         }
         else
         {
            numOldVariables = variableSpace.GetNumVariables ();
            variableSpace.SetNumVariables (numOldVariables + numNewVariables);
         }
         
         for (var variableId:int = 0; variableId < numNewVariables; ++ variableId)
         {
            //var variableInstanceDefine:VariableInstanceDefine = variableSpaceDefine.mVariableDefines [variableId] as VariableInstanceDefine; // v1.52 only
            var variableInstanceDefine:VariableInstanceDefine = variableDefines [variableId] as VariableInstanceDefine;
            var direct_source_define:ValueSourceDefine_Direct = variableInstanceDefine.mDirectValueSourceDefine;
            
            var variableInstance:VariableInstance = variableSpace.GetVariableAt (variableId + numOldVariables);
            variableInstance.SetName (variableInstanceDefine.mName);
            variableInstance.SetValueObject (ValidateDirectValueObject_Define2Object (playerWorld, direct_source_define.mValueType, direct_source_define.mValueObject));
         }
         
         return variableSpace;
      }
      
      // this function is for validating entity and ccat session variables when restarting a level
      // if variableDefines is not null, the lenght of variableSpace will be adjusted to variableDefines.length
      public static function ValidateVariableSpaceInitialValues (playerWorld:World, variableSpace:VariableSpace, variableDefines:Array):void
      {
         if (variableDefines != null)
            variableSpace.SetNumVariables (variableDefines.length);
         
         // ...
         
         var convertedArrays:Dictionary = new Dictionary ();
         
         var numVariables:int = variableSpace.GetNumVariables ();
         
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {  
            var variableInstance:VariableInstance = variableSpace.GetVariableAt (variableId);
            
            variableInstance.SetValueObject (ValidateVariableValueObject (playerWorld, variableInstance.GetValueObject (), convertedArrays));
         }
      }
      
      private static function ValidateVariableValueObject (playerWorld:World, valueObject:Object, convertedArrays:Dictionary):Object
      {
         if (valueObject is Entity)
         {
            var entity:Entity = valueObject as Entity;
            if (entity != null)
            {
               return ValidateDirectValueObject_Define2Object (playerWorld, ValueTypeDefine.ValueType_Entity, entity.GetCreationId ());
            }
         }
         else if (valueObject is CollisionCategory)
         {
            var ccat:CollisionCategory = valueObject as CollisionCategory;
            if (ccat != null)
            {
               return ValidateDirectValueObject_Define2Object (playerWorld, ValueTypeDefine.ValueType_CollisionCategory, ccat.GetIndexInEditor ());
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
                  
                  anArray [i] =  ValidateVariableValueObject (playerWorld, element, convertedArrays);
               }
            }
            
            return anArray;
         }
         
         return valueObject;
      }
      
//==============================================================================================
// byte array -> define
//==============================================================================================
      
      public static function LoadFunctionDefineFromBinFile (binFile:ByteArray, functionDefine:FunctionDefine, hasParams:Boolean, loadVariables:Boolean, customFunctionDefines:Array, loadLocalVariables:Boolean = true):FunctionDefine
      {
         if (functionDefine == null)
            functionDefine = new FunctionDefine ();
         
         if (loadVariables)
         {
            if (hasParams)
            {
               LoadVariableDefinesFromBinFile (binFile, functionDefine.mInputVariableDefines, true);
               
               LoadVariableDefinesFromBinFile (binFile, functionDefine.mOutputVariableDefines, false);
            }
            
            if (loadLocalVariables)
            {
               LoadVariableDefinesFromBinFile (binFile, functionDefine.mLocalVariableDefines, false);
            }
         }
         
         if (customFunctionDefines != null)
         {
            functionDefine.mCodeSnippetDefine = LoadCodeSnippetDefineFromBinFile (binFile, customFunctionDefines);
         }
         
         return functionDefine;
      }
      
      public static function LoadCodeSnippetDefineFromBinFile (binFile:ByteArray, customFunctionDefines:Array):CodeSnippetDefine
      {
         var codeSnippetDefine:CodeSnippetDefine = new CodeSnippetDefine ();
         
         codeSnippetDefine.mName = binFile.readUTF ();
         codeSnippetDefine.mNumCallings = binFile.readShort ();
         codeSnippetDefine.mFunctionCallingDefines = new Array (codeSnippetDefine.mNumCallings);
         for (var i:int = 0; i < codeSnippetDefine.mNumCallings; ++ i)
            codeSnippetDefine.mFunctionCallingDefines [i] = LoadFunctionCallingDefineFromBinFile (binFile, customFunctionDefines);
         
         return codeSnippetDefine;
      }
      
      public static function  LoadFunctionCallingDefineFromBinFile (binFile:ByteArray, customFunctionDefines:Array):FunctionCallingDefine
      {
         var funcCallingDefine:FunctionCallingDefine = new FunctionCallingDefine ();
         
         var func_type:int;
         var func_id:int;
         
         var i:int;
         var num_inputs:int;
         var num_outputs:int;
         var inputValueSourceDefines:Array;
         var outputValueTargetDefines:Array;
         
         funcCallingDefine.mFunctionType = func_type = binFile.readByte ();
         funcCallingDefine.mFunctionId = func_id = binFile.readShort ();
         
         funcCallingDefine.mNumInputs = num_inputs = binFile.readByte ();
         funcCallingDefine.mNumOutputs = num_outputs = binFile.readByte ();
         
         funcCallingDefine.mInputValueSourceDefines = inputValueSourceDefines = new Array (num_inputs);
         funcCallingDefine.mOutputValueTargetDefines = outputValueTargetDefines = new Array (num_outputs);
         
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            var func_declaration:FunctionDeclaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (func_id);
            
            for (i = 0; i < num_inputs; ++ i)
               inputValueSourceDefines [i] = LoadValueSourceDefineFromBinFile (binFile, func_declaration.GetInputParamValueType (i), func_declaration.GetInputNumberTypeDetail (i));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledInputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for (i = 0; i < num_inputs; ++ i)
               inputValueSourceDefines [i] = LoadValueSourceDefineFromBinFile (binFile, (calledInputVariableDefines [i] as VariableInstanceDefine).mDirectValueSourceDefine.mValueType, ValueTypeDefine.NumberTypeDetail_Double);
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         for (i = 0; i < num_outputs; ++ i)
            outputValueTargetDefines [i] = LoadValueTargetDefineFromBinFile (binFile);
         
         return funcCallingDefine;
      }
      
      public static function  LoadValueSourceDefineFromBinFile (binFile:ByteArray, valueType:int, numberDetail:int):ValueSourceDefine
      {
         var valueSourceDefine:ValueSourceDefine = null;
         
         var source_type:int = binFile.readByte ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            valueSourceDefine = new ValueSourceDefine_Direct (valueType, LoadDirectValueObjectFromBinFile (binFile, valueType, numberDetail));
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            valueSourceDefine = new ValueSourceDefine_Variable (
                  binFile.readByte (),
                  binFile.readShort ()
               );
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Property)
         {
            valueSourceDefine = new ValueSourceDefine_Property (
                  LoadValueSourceDefineFromBinFile (binFile, ValueTypeDefine.ValueType_Entity, ValueTypeDefine.NumberTypeDetail_Double),
                  binFile.readShort (),
                  binFile.readShort ()
               );
         }
         
         if (valueSourceDefine == null)
         {
            valueSourceDefine = new ValueSourceDefine_Null ();
         }
         
         return valueSourceDefine;
      }
      
      public static function  LoadValueTargetDefineFromBinFile (binFile:ByteArray):ValueTargetDefine
      {
         var valueTargetDefine:ValueTargetDefine = null;
         
         var target_type:int = binFile.readByte ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            valueTargetDefine = new ValueTargetDefine_Variable (
                  binFile.readByte (),
                  binFile.readShort ()
               );
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Property)
         {
            valueTargetDefine = new ValueTargetDefine_Property (
                  LoadValueSourceDefineFromBinFile (binFile, ValueTypeDefine.ValueType_Entity, ValueTypeDefine.NumberTypeDetail_Double),
                  binFile.readShort (),
                  binFile.readShort ()
               );
         }
         
         if (valueTargetDefine == null)
         {
            valueTargetDefine = new ValueTargetDefine_Null ();
         }
         
         return valueTargetDefine;
      }
      
      private static function LoadDirectValueObjectFromBinFile (binFile:ByteArray, valueType:int, numberDetail:int):Object
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return binFile.readByte () != 0;
            case ValueTypeDefine.ValueType_Number:
               switch (numberDetail)
               {
                  case ValueTypeDefine.NumberTypeDetail_Single:
                     return binFile.readFloat ();
                  case ValueTypeDefine.NumberTypeDetail_Integer:
                     return binFile.readInt ();
                  case ValueTypeDefine.NumberTypeDetail_Double:
                  default:
                     return binFile.readDouble ();
               }
            case ValueTypeDefine.ValueType_String:
               return binFile.readUTF ();
            case ValueTypeDefine.ValueType_Entity:
               return binFile.readInt ();
            case ValueTypeDefine.ValueType_CollisionCategory:
               return binFile.readInt (); // in fact, short is ok
            case ValueTypeDefine.ValueType_Module:
               return binFile.readInt (); // in fact, short is ok
            case ValueTypeDefine.ValueType_Sound:
               return binFile.readInt (); // in fact, short is ok
            case ValueTypeDefine.ValueType_Scene:
               return binFile.readInt (); // in fact, short is ok
            case ValueTypeDefine.ValueType_Array:
               var nullArray:Boolean = binFile.readByte () == 0;
               //if (nullArray == null) 
               //{
                  return null;
               //}
               //else
               //{
               //   var values:Array = valueObject as Array;
               //   if (values.length > 1024)
               //      throw new Error ("array i too length: " + values.length);
               //   
               //   binFile.writeShort (values.length);
               //}
               
               break;
            default:
            {
               throw new Error ("! bad value");
            }
         }
      }
      
      //public static function  LoadVariableSpaceDefineFromBinFile (binFile:ByteArray):VariableSpaceDefine // v1.52 only
      public static function  LoadVariableDefinesFromBinFile (binFile:ByteArray, variableDefines:Array, supportInitalValues:Boolean):void
      {
         //>> only v1.52
         //var variableSpaceDefine:VariableSpaceDefine = new VariableSpaceDefine ();
         //
         //variableSpaceDefine.mName = binFile.readUTF ();
         //variableSpaceDefine.mParentPackageId = binFile.readShort ();
         //<<
         
         var numVariables:int = binFile.readShort ();
         //variableSpaceDefine.mVariableDefines = new Array (numVariables); // v1.52 only
         var valueType:int;
         
         for (var i:int = 0; i < numVariables; ++ i)
         {
            var viDefine:VariableInstanceDefine = new VariableInstanceDefine ();
            
            viDefine.mName = binFile.readUTF ();
            valueType = binFile.readShort ();
            viDefine.mDirectValueSourceDefine = new ValueSourceDefine_Direct (
                                                            valueType,
                                                            supportInitalValues ? LoadDirectValueObjectFromBinFile (binFile, valueType, ValueTypeDefine.NumberTypeDetail_Double) : ValueTypeDefine.GetDefaultDirectDefineValue (valueType)
                                                            );
            
            //variableSpaceDefine.mVariableDefines [i] = viDefine; // v1.52 only
            variableDefines.push (viDefine);
         }
         
         //return variableSpaceDefine; // v1.52 only
      }
      
//==============================================================================================
// define -> xml
//==============================================================================================
      
      public static function FunctionDefine2Xml (functionDefine:FunctionDefine, functionElement:XML, hasParams:Boolean, convertVariables:Boolean, customFunctionDefines:Array, convertLocalVariables:Boolean = true, codeSnippetElement:XML = null):void
      {
         if (convertVariables)
         {
            if (hasParams)
            {
               functionElement.InputParameters = <InputParameters/>;
               VariablesDefine2Xml (functionDefine.mInputVariableDefines, functionElement.InputParameters [0], true);
               
               functionElement.OutputParameters = <OutputParameters/>;
               VariablesDefine2Xml (functionDefine.mOutputVariableDefines, functionElement.OutputParameters [0], false);
            }
            
            if (convertLocalVariables)
            {
               functionElement.LocalVariables = <LocalVariables/>;
               VariablesDefine2Xml (functionDefine.mLocalVariableDefines, functionElement.LocalVariables [0], false);
            }
         }
         
         if (customFunctionDefines != null)
         {
            functionElement.appendChild (CodeSnippetDefine2Xml (codeSnippetElement, functionDefine.mCodeSnippetDefine, customFunctionDefines));
         }
      }
      
      public static function CodeSnippetDefine2Xml (elementCodeSnippet:XML, codeSnippetDefine:CodeSnippetDefine, customFunctionDefines:Array):XML
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
            elementCodeSnippet.appendChild (FunctionCallingDefine2Xml (functionCallings[i], customFunctionDefines));
         }
         
         //trace ("elementCodeSnippet = " + elementCodeSnippet.toXMLString ());
         
         return elementCodeSnippet;
      }
      
      public static function FunctionCallingDefine2Xml (funcCallingDefine:FunctionCallingDefine, customFunctionDefines:Array):XML
      {
         var func_type:int = funcCallingDefine.mFunctionType;
         var func_id:int = funcCallingDefine.mFunctionId;
         var func_declaration:FunctionDeclaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (func_id)
         
         var elementFunctionCalling:XML = <FunctionCalling />;
         
         elementFunctionCalling.@function_type = funcCallingDefine.mFunctionType;
         elementFunctionCalling.@function_id = funcCallingDefine.mFunctionId;
         
         var i:int;
         
         var num_inputs:int = funcCallingDefine.mNumInputs;
         var inputValueSourceDefines:Array = funcCallingDefine.mInputValueSourceDefines;
         elementFunctionCalling.InputValueSources = <InputValueSources />;
         
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            for (i = 0; i < num_inputs; ++ i)
               elementFunctionCalling.InputValueSources.appendChild (ValueSourceDefine2Xml (inputValueSourceDefines [i], func_declaration.GetInputParamValueType (i)));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledInputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for (i = 0; i < num_inputs; ++ i)
               elementFunctionCalling.InputValueSources.appendChild (ValueSourceDefine2Xml (inputValueSourceDefines [i], (calledInputVariableDefines [i] as VariableInstanceDefine).mDirectValueSourceDefine.mValueType));
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
               elementFunctionCalling.OutputValueTargets.appendChild (ValueTargetefine2Xml (outputValueTargetDefines [i], func_declaration.GetOutputParamValueType (i)));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledOutputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mOutputVariableDefines;
            
            for (i = 0; i < num_outputs; ++ i)
               elementFunctionCalling.OutputValueTargets.appendChild (ValueTargetefine2Xml (outputValueTargetDefines [i], (calledOutputVariableDefines [i] as VariableInstanceDefine).mDirectValueSourceDefine.mValueType));
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         return elementFunctionCalling;
      }
      
      public static function ValueSourceDefine2Xml (valueSourceDefine:ValueSourceDefine, valueType:int, isForProperyOwner:Boolean = false):XML
      {
         var elementValueSource:XML;
         
         if (isForProperyOwner)
            elementValueSource = <PropertyOwnerValueSource />;
         else
            elementValueSource = <ValueSource />;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         elementValueSource.@type = source_type;
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            try
            {
               var directValue:Object = ValidateDirectValueObject_Define2Xml (valueType, direct_source_define.mValueObject);
               if (directValue != null)
               {
                  elementValueSource.@direct_value = directValue;
               }
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            elementValueSource.@variable_space = variable_source_define.mSpaceType;
            elementValueSource.@variable_index = variable_source_define.mVariableIndex;
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Property)
         {
            var property_source_define:ValueSourceDefine_Property = valueSourceDefine as ValueSourceDefine_Property;
            
            elementValueSource.@property_package_id = property_source_define.mSpacePackageId;
            elementValueSource.@property_id = property_source_define.mPropertyId;
            
            elementValueSource.appendChild (ValueSourceDefine2Xml (property_source_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, true));
         }
         
         return elementValueSource;
      }
      
      public static function ValueTargetefine2Xml (valueTargetDefine:ValueTargetDefine, valueType:int):XML
      {
         var elementValueTarget:XML = <ValueTarget />;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         elementValueTarget.@type = target_type;
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            elementValueTarget.@variable_space = variable_target_define.mSpaceType;
            elementValueTarget.@variable_index = variable_target_define.mVariableIndex;
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Property)
         {
            var property_target_define:ValueTargetDefine_Property = valueTargetDefine as ValueTargetDefine_Property;
            
            elementValueTarget.@property_package_id = property_target_define.mSpacePackageId;
            elementValueTarget.@property_id = property_target_define.mPropertyId;
            
            elementValueTarget.appendChild (ValueSourceDefine2Xml (property_target_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, true));
         }
         
         return elementValueTarget;
      }
      
      private static function ValidateDirectValueObject_Define2Xml (valueType:int, valueObject:Object):Object
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return (valueObject as Boolean) ? 1 : 0;
            case ValueTypeDefine.ValueType_Number:
               return valueObject as Number;
            case ValueTypeDefine.ValueType_String:
               var text:String = valueObject as String;
               if (text == null)
                  text = "";
               return text;
            case ValueTypeDefine.ValueType_Entity:
               return valueObject as int;
            case ValueTypeDefine.ValueType_CollisionCategory:
               return valueObject as int;
            case ValueTypeDefine.ValueType_Module:
               return valueObject as int;
            case ValueTypeDefine.ValueType_Sound:
               return valueObject as int;
            case ValueTypeDefine.ValueType_Scene:
               return valueObject as int;
            case ValueTypeDefine.ValueType_Array:
               //if (valueObject == null) 
               //{
                  return null;
               //}
               //else 
               //{
               //   
               //}
            default:
            {
               throw new Error ("! wrong value");
            }
         }
      }
      
      //public static function VariableSpaceDefine2Xml (variableSpaceDefine:VariableSpaceDefine):XML // v1.52 only
      public static function VariablesDefine2Xml (variableDefines:Array, elementVariablePackage:XML, supportInitalValues:Boolean):void
      {
         //>> v1.52 only
         //var elementVariablePackage:XML = <VariablePackage />;
         //
         //elementVariablePackage.@name = variableSpaceDefine.mName;
         //elementVariablePackage.@package_id = variableSpaceDefine.mPackageId;
         //elementVariablePackage.@parent_package_id = variableSpaceDefine.mParentPackageId;
         //<<
         
         var viDefine:VariableInstanceDefine;
         var element:Object;;
         
         //var numVariables:int = variableSpaceDefine.mVariableDefines.length; // v1.52 only
         var numVariables:int = variableDefines.length;
         for (var variableIndex:int = 0; variableIndex < numVariables; ++ variableIndex)
         {
            //viDefine = variableSpaceDefine.mVariableDefines [variableIndex] as VariableInstanceDefine; // v1.52 only
            viDefine = variableDefines [variableIndex] as VariableInstanceDefine;
            
            element = <Variable />;
            element.@name = viDefine.mName;
            element.@value_type = viDefine.mDirectValueSourceDefine.mValueType;
            
            if (supportInitalValues)
            {
               var directValue:Object = ValidateDirectValueObject_Define2Xml (viDefine.mDirectValueSourceDefine.mValueType, viDefine.mDirectValueSourceDefine.mValueObject);
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
               var funcDclaration:FunctionDeclaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (functionId);
               
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
                     
                     if (valueType == ValueTypeDefine.ValueType_Number)
                     {
                        directNumber = Number (direcSourceDefine.mValueObject);
                        numberDetail = funcDclaration.GetInputNumberTypeDetail (j);
                        
                        switch (numberDetail)
                        {
                           case ValueTypeDefine.NumberTypeDetail_Single:
                              directNumber = ValueAdjuster.Number2Precision (directNumber, 6);
                              break;
                           case ValueTypeDefine.NumberTypeDetail_Integer:
                              directNumber = Math.round (directNumber);
                              break;
                           case ValueTypeDefine.NumberTypeDetail_Double:
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
            //var viDefine:VariableInstanceDefine = variableSpaceDefine.mVariableDefines [i] as VariableInstanceDefine; // v1.52 only
            var viDefine:VariableInstanceDefine = variableDefines [i] as VariableInstanceDefine;
            
            if (viDefine.mDirectValueSourceDefine.mValueType == ValueTypeDefine.ValueType_Number)
            {
               directNumber = Number (viDefine.mDirectValueSourceDefine.mValueObject);
               viDefine.mDirectValueSourceDefine.mValueObject = ValueAdjuster.Number2Precision (directNumber, 12);
            }
         }
      }
      
      // it is possible some new parameters are appended in a newer version for some functions
      public static function FillMissedFieldsInFunctionDefine (functionDefine:FunctionDefine):void
      {
      }
   }
}
