
package common {
   
   import flash.utils.ByteArray;
   
   import player.design.Global;
   import player.world.World;
   import player.entity.Entity;
   import player.trigger.IPropertyOwner;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition;
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.FunctionDefinition_Logic;
   import player.trigger.FunctionInstance;
   import player.trigger.CodeSnippet;
   import player.trigger.FunctionCalling;
   import player.trigger.FunctionCalling_Condition;
   import player.trigger.FunctionCalling_Dummy;
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Null;
   import player.trigger.ValueSource_Direct;
   import player.trigger.ValueSource_Variable;
   import player.trigger.ValueTarget;
   import player.trigger.ValueTarget_Null;
   import player.trigger.ValueTarget_Variable;
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
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionCallingDefine;
   import common.trigger.define.ValueSourceDefine;
   import common.trigger.define.ValueSourceDefine_Null;
   import common.trigger.define.ValueSourceDefine_Direct;
   import common.trigger.define.ValueSourceDefine_Variable;
   import common.trigger.define.ValueTargetDefine;
   import common.trigger.define.ValueTargetDefine_Null;
   import common.trigger.define.ValueTargetDefine_Variable;
   
   import common.trigger.parse.CodeSnippetParser;
   
   import common.trigger.parse.FunctionCallingBlockInfo;
   import common.trigger.parse.FunctionCallingBranchInfo;
   import common.trigger.parse.FunctionCallingLineInfo;
   
   import common.CoordinateSystem;
   
   public class TriggerFormatHelper2
   {
      
//==============================================================================================
// define -> definition (player)
//==============================================================================================
      
      public static function CreateCodeSnippet (parentFunctionInstance:FunctionInstance, playerWorld:World, codeSnippetDefine:CodeSnippetDefine):CodeSnippet
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
            callingInfo.mFunctionId = callingDefine.mFunctionId;
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
               callingInfo.mFunctionCallingForPlaying = FunctionCallingDefine2FunctionCalling (lineNumber, parentFunctionInstance, playerWorld, callingInfo.mFunctionCallingDefine);
               validCallingInfos [numValidCallings ++] = callingInfo;
               
               if (lastCallingInfo != null)
                  lastCallingInfo.mNextValidCallingLine = callingInfo;
               
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
            
            var nextCallingInfo:FunctionCallingLineInfo;
            var branchInfo:FunctionCallingBranchInfo;
            
            do
            {
               lastCallingInfo = callingInfo;
               callingInfo = lastCallingInfo.mNextValidCallingLine;
               
               switch (lastCallingInfo.mFunctionId)
               {
                  case CoreFunctionIds.ID_ReturnIfTrue:
                     calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                     
                     calling_condition.SetNextCallingForTrue (null);
                     calling_condition.SetNextCallingForFalse (callingInfo == null ? null : callingInfo.mFunctionCallingForPlaying);
                     break;
                  case CoreFunctionIds.ID_ReturnIfFalse:
                     calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                     
                     calling_condition.SetNextCallingForTrue (callingInfo == null ? null : callingInfo.mFunctionCallingForPlaying);
                     calling_condition.SetNextCallingForFalse (null);
                     break;
                  case CoreFunctionIds.ID_StartIf:
                     calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                     
                     if (lastCallingInfo.mOwnerBlock.mFirstBranch.mNumValidCallings > 1)
                     {
                        calling_condition.SetNextCallingForTrue (callingInfo == null ? null : callingInfo.mFunctionCallingForPlaying);
                     }
                     else
                     {
                        nextCallingInfo = lastCallingInfo.mOwnerBlock.mEndCallingLine; // end if
                        if (nextCallingInfo != null)
                           nextCallingInfo = nextCallingInfo.mNextValidCallingLine;
                        calling_condition.SetNextCallingForTrue (nextCallingInfo == null ? null : nextCallingInfo.mFunctionCallingForPlaying);
                     }
                     branchInfo = lastCallingInfo.mOwnerBlock.mFirstBranch; // if branch, should not be null
                     branchInfo = branchInfo.mNextBranch; // else branch
                     if (branchInfo == null)
                        nextCallingInfo = null;
                     else
                        nextCallingInfo = branchInfo.mFirstCallingLine.mNextValidCallingLine;
                     calling_condition.SetNextCallingForFalse (nextCallingInfo == null ? null : nextCallingInfo.mFunctionCallingForPlaying);
                     break;
                  case CoreFunctionIds.ID_StartWhile:
                     calling_condition = lastCallingInfo.mFunctionCallingForPlaying as FunctionCalling_Condition;
                     
                     calling_condition.SetNextCallingForTrue (callingInfo == null ? null : callingInfo.mFunctionCallingForPlaying);
                     nextCallingInfo = lastCallingInfo.mOwnerBlock.mEndCallingLine; // end while
                     if (nextCallingInfo != null)
                        nextCallingInfo = nextCallingInfo.mNextValidCallingLine;
                     calling_condition.SetNextCallingForFalse (nextCallingInfo == null ? null : nextCallingInfo.mFunctionCallingForPlaying);
                     break;
                  case CoreFunctionIds.ID_Else:
                     lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (callingInfo == null ? null : callingInfo.mFunctionCallingForPlaying);
                     break;
                  case CoreFunctionIds.ID_EndIf:
                     lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (callingInfo == null ? null : callingInfo.mFunctionCallingForPlaying);
                     break;
                  case CoreFunctionIds.ID_EndWhile:
                     lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (lastCallingInfo.mOwnerBlock.mStartCallingLine.mFunctionCallingForPlaying);
                     break;
                  case CoreFunctionIds.ID_Return:
                     lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (null);
                     break;
                  case CoreFunctionIds.ID_Break:
                     nextCallingInfo = lastCallingInfo.mOwnerBlockSupportBreak.mEndCallingLine;
                     if (nextCallingInfo != null)
                        nextCallingInfo = nextCallingInfo.mNextValidCallingLine;
                     lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (nextCallingInfo == null ? null : nextCallingInfo.mFunctionCallingForPlaying);
                     break;
                  default:
                  {
                     if (callingInfo != null && callingInfo.mFunctionId == CoreFunctionIds.ID_Else)
                     {
                        nextCallingInfo = lastCallingInfo.mOwnerBlock.mEndCallingLine; // end if
                        if (nextCallingInfo != null)
                           nextCallingInfo = nextCallingInfo.mNextValidCallingLine;
                        lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (nextCallingInfo == null ? null : nextCallingInfo.mFunctionCallingForPlaying);
                     }
                     else
                     {
                        lastCallingInfo.mFunctionCallingForPlaying.SetNextCalling (callingInfo == null ? null : callingInfo.mFunctionCallingForPlaying);
                     }
                     break;
                  }
               }
            }
            while (callingInfo != null);
         }
         
         var code_snippet:CodeSnippet = new CodeSnippet (calling_list_head);
         
         return code_snippet;
      }
      
      public static function FunctionCallingDefine2FunctionCalling (lineNumber:int, parentFunctionInstance:FunctionInstance, playerWorld:World, funcCallingDefine:FunctionCallingDefine):FunctionCalling
      {
         if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
         {
            var function_id:int = funcCallingDefine.mFunctionId;
            var core_func_definition:FunctionDefinition = TriggerEngine.GetCoreFunctionDefinition (function_id);
            var core_func_declaration:FunctionDeclaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (function_id);
            
            var value_source_list:ValueSource = null;
            var value_source:ValueSource;
            var i:int;
            for (i = funcCallingDefine.mNumInputs - 1; i >= 0; -- i)
            {
               value_source = ValueSourceDefine2InputValueSource (parentFunctionInstance, playerWorld, funcCallingDefine.mInputValueSourceDefines [i], core_func_declaration.GetInputParamValueType (i));
               value_source.mNextValueSourceInList = value_source_list;
               value_source_list = value_source;
            }
            
            var value_target_list:ValueTarget = null;
            var value_target:ValueTarget;
            for (i = funcCallingDefine.mNumOutputs - 1; i >= 0; -- i)
            {
               value_target = ValueTargetDefine2ReturnValueTarget (parentFunctionInstance, playerWorld, funcCallingDefine.mOutputValueTargetDefines [i], core_func_declaration.GetOutputParamValueType (i));
               value_target.mNextValueTargetInList = value_target_list;
               value_target_list = value_target;
            }
            
            var calling:FunctionCalling;
            switch (function_id)
            {
               case CoreFunctionIds.ID_ReturnIfTrue:
               case CoreFunctionIds.ID_ReturnIfFalse:
               case CoreFunctionIds.ID_StartIf:
               case CoreFunctionIds.ID_StartWhile:
                  calling = new FunctionCalling_Condition (lineNumber, core_func_definition, value_source_list, value_target_list);
                  break;
               case CoreFunctionIds.ID_EndIf:
               case CoreFunctionIds.ID_Else:
               case CoreFunctionIds.ID_EndWhile:
               case CoreFunctionIds.ID_Return:
               case CoreFunctionIds.ID_Break:
                  calling = new FunctionCalling_Dummy (lineNumber, core_func_definition, value_source_list, value_target_list);
                  break;
               default:
               {
                  calling = new FunctionCalling (lineNumber, core_func_definition, value_source_list, value_target_list);
                  break;
               }
            }
            
            return calling;
         }
         else
         {
            return null;
         }
      }
      
      public static function ValueSourceDefine2InputValueSource (parentFunctionInstance:FunctionInstance, playerWorld:World, valueSourceDefine:ValueSourceDefine, valueType:int):ValueSource
      {
         var value_source:ValueSource = null;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            //assert (valueType == direct_source_define.mValueType);
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as Boolean);
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as Number);
                  break;
               case ValueTypeDefine.ValueType_String:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as String);
                  break;
               case ValueTypeDefine.ValueType_Entity:
               {
                  var entityIndex:int = direct_source_define.mValueObject as int;
                  if (entityIndex < 0)
                  {
                     if (entityIndex == Define.EntityId_Ground)
                        value_source = new ValueSource_Direct (playerWorld);
                     else // if (entityIndex == Define.EntityId_None)
                        value_source = new ValueSource_Direct (null);
                  }
                  else
                  {
                     value_source = new ValueSource_Direct (playerWorld.GetEntityByCreationId (entityIndex));
                  }
                  
                  break;
               }
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_source = new ValueSource_Direct (playerWorld.GetCollisionCategoryById (direct_source_define.mValueObject as int));
                  break;
               default:
                  break;
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var value_space_type:int = variable_source_define.mSpaceType;
            var variable_index:int   = variable_source_define.mVariableIndex;
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = Global.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = parentFunctionInstance.GetInputVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Output:
                  variable_instance = parentFunctionInstance.GetReturnVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  break;
               default:
                  break;
            }
            
            if (variable_instance != null)
            {
               value_source = new ValueSource_Variable (variable_instance);
            }
         }
         
         if (value_source == null)
         {
            //value_source = new ValueSource_Null ();
            //trace ("Error: source is null");
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_source = new ValueSource_Direct (false);
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_source = new ValueSource_Direct (0);
                  break;
               case ValueTypeDefine.ValueType_String:
                  value_source = new ValueSource_Direct (null);
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  value_source = new ValueSource_Direct (null);
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_source = new ValueSource_Direct (Define.CollisionCategoryId_HiddenCategory);
                  break;
               default:
                  value_source = new ValueSource_Null ();
                  trace ("Error: source is null");
                  break;
            }
         }
         
         return value_source;
      }
      
      public static function ValueTargetDefine2ReturnValueTarget (parentFunctionInstance:FunctionInstance, playerWorld:World, valueTargetDefine:ValueTargetDefine, valueType:int):ValueTarget
      {
         var value_target:ValueTarget = null;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Null)
         {
            value_target = new ValueTarget_Null ();
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            var value_space_type:int = variable_target_define.mSpaceType;
            var variable_index:int   = variable_target_define.mVariableIndex;
            var variable_instance:VariableInstance = null;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = Global.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = parentFunctionInstance.GetInputVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Output:
                  variable_instance = parentFunctionInstance.GetReturnVariableAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  break;
               default:
                  break;
            }
            
            if (variable_instance != null)
            {
               value_target = new ValueTarget_Variable (variable_instance);
            }
         }
         
         if (value_target == null)
         {
            value_target = new ValueTarget_Null ();
            
            //trace ("Error: target is null");
         }
         
         return value_target;
      }
      
//==============================================================================================
// byte array -> define
//==============================================================================================
      
      public static function LoadCodeSnippetDefineFromBinFile (binFile:ByteArray):CodeSnippetDefine
      {
         var codeSnippetDefine:CodeSnippetDefine = new CodeSnippetDefine ();
         
         codeSnippetDefine.mName = binFile.readUTF ();
         codeSnippetDefine.mNumCallings = binFile.readShort ();
         codeSnippetDefine.mFunctionCallingDefines = new Array (codeSnippetDefine.mNumCallings);
         for (var i:int = 0; i < codeSnippetDefine.mNumCallings; ++ i)
            codeSnippetDefine.mFunctionCallingDefines [i] = LoadFunctionCallingDefineFromBinFile (binFile);
         
         return codeSnippetDefine;
      }
      
      public static function  LoadFunctionCallingDefineFromBinFile (binFile:ByteArray):FunctionCallingDefine
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
         
         var func_declaration:FunctionDeclaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (func_id);
         
         for (i = 0; i < num_inputs; ++ i)
            inputValueSourceDefines [i] = LoadValueSourceDefineFromBinFile (binFile, func_declaration.GetInputParamValueType (i), func_declaration.GetInputNumberTypeDetail (i));
         
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
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  valueSourceDefine = new ValueSourceDefine_Direct (ValueTypeDefine.ValueType_Boolean, binFile.readByte () != 0);
                  break;
               case ValueTypeDefine.ValueType_Number:
                  switch (numberDetail)
                  {
                     case ValueTypeDefine.NumberTypeDetail_Single:
                        valueSourceDefine = new ValueSourceDefine_Direct (ValueTypeDefine.ValueType_Number, binFile.readFloat ());
                        break;
                     case ValueTypeDefine.NumberTypeDetail_Integer:
                        valueSourceDefine = new ValueSourceDefine_Direct (ValueTypeDefine.ValueType_Number, binFile.readInt ());
                        break;
                     case ValueTypeDefine.NumberTypeDetail_Double:
                     default:
                        valueSourceDefine = new ValueSourceDefine_Direct (ValueTypeDefine.ValueType_Number, binFile.readDouble ());
                        break;
                  }
                  
                  break;
               case ValueTypeDefine.ValueType_String:
                  valueSourceDefine = new ValueSourceDefine_Direct (ValueTypeDefine.ValueType_String, binFile.readUTF ());
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  valueSourceDefine = new ValueSourceDefine_Direct (ValueTypeDefine.ValueType_Entity, binFile.readInt ());
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  valueSourceDefine = new ValueSourceDefine_Direct (ValueTypeDefine.ValueType_CollisionCategory, binFile.readInt ());
                  break;
               default:
                  trace ("error");
                  break;
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            valueSourceDefine = new ValueSourceDefine_Variable (
                  binFile.readByte (),
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
         
         if (valueTargetDefine == null)
         {
            valueTargetDefine = new ValueTargetDefine_Null ();
         }
         
         return valueTargetDefine;
      }
      
//==============================================================================================
// define -> xml
//==============================================================================================
      
      public static function CodeSnippetDefine2Xml (codeSnippetDefine:CodeSnippetDefine):XML
      {
         var elementCodeSnippet:XML = <CodeSnippet />;
         
         elementCodeSnippet.@name = codeSnippetDefine.mName;
         
         var num:int = codeSnippetDefine.mNumCallings;
         var functionCallings:Array = codeSnippetDefine.mFunctionCallingDefines;
         for (var i:int = 0; i < num; ++ i)
         {
            elementCodeSnippet.appendChild (FunctionCallingDefine2Xml (functionCallings[i]));
         }
         
         return elementCodeSnippet;
      }
      
      public static function FunctionCallingDefine2Xml (funcCallingDefine:FunctionCallingDefine):XML
      {
         var func_declaration:FunctionDeclaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (funcCallingDefine.mFunctionId);
         
         var elementFunctionCalling:XML = <FunctionCalling />;
         
         elementFunctionCalling.@function_type = funcCallingDefine.mFunctionType;
         elementFunctionCalling.@function_id = funcCallingDefine.mFunctionId;
         
         var i:int;
         
         var num_inputs:int = funcCallingDefine.mNumInputs;
         var inputValueSourceDefines:Array = funcCallingDefine.mInputValueSourceDefines;
         elementFunctionCalling.InputValueSources = <InputValueSources />;
         for (i = 0; i < num_inputs; ++ i)
            elementFunctionCalling.InputValueSources.appendChild (ValueSourceDefine2Xml (inputValueSourceDefines [i], func_declaration.GetInputParamValueType (i)));
         
         var num_outputs:int = funcCallingDefine.mNumOutputs;
         var outputValueTargetDefines:Array = funcCallingDefine.mOutputValueTargetDefines;
         elementFunctionCalling.OutputValueTargets = <OutputValueTargets />
         for (i = 0; i < num_outputs; ++ i)
            elementFunctionCalling.OutputValueTargets.appendChild (ValueTargetefine2Xml (outputValueTargetDefines [i], func_declaration.GetOutputParamValueType (i)));
         
         return elementFunctionCalling;
      }
      
      public static function ValueSourceDefine2Xml (valueSourceDefine:ValueSourceDefine, valueType:int):XML
      {
         var elementValueSource:XML = <ValueSource />;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         elementValueSource.@type = source_type;
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            var valid:Boolean = true;
            var value_object:Object = null;
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_object = (direct_source_define.mValueObject as Boolean) ? 1 : 0;
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_object = direct_source_define.mValueObject as Number;
                  break;
               case ValueTypeDefine.ValueType_String:
                  value_object = direct_source_define.mValueObject as String;
                  if (value_object == null)
                     value_object = "";
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  value_object = direct_source_define.mValueObject as int;
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_object = direct_source_define.mValueObject as int;
                  break;
               default:
                  valid = false;
                  break;
            }
            
            if (valid)
            {
               elementValueSource.@direct_value = value_object;
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            elementValueSource.@variable_space = variable_source_define.mSpaceType;
            elementValueSource.@variable_index = variable_source_define.mVariableIndex;
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
         
         return elementValueTarget;
      }
      
//========================================================================================
// 
//========================================================================================
      
      // float -> 6 precisions, double -> 12 precisions
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
      
      // it is possible some new parameters are appended in a newer version for some functions
      public static function FillMissedFieldsInWorldDefine (codeSnippetDefine:CodeSnippetDefine):void
      {
         
      }
   }
}
