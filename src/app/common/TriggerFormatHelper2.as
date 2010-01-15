
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
   import player.trigger.FunctionCalling_Return;
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
   
   import common.CoordinateSystem;
   
   public class TriggerFormatHelper2
   {
      
//==============================================================================================
// define -> definition (player)
//==============================================================================================
      
      public static function CreateCodeSnippet (parentFunctionInstance:FunctionInstance, playerWorld:World, codeSnippetDefine:CodeSnippetDefine):CodeSnippet
      {
         var calling_list_head:FunctionCalling = null;
         var calling:FunctionCalling = null;
         
         for (var i:int = codeSnippetDefine.mNumCallings - 1; i >= 0; -- i)
         {
            calling = FunctionCallingDefine2FunctionCalling (parentFunctionInstance, playerWorld, codeSnippetDefine.mFunctionCallingDefines [i]);
            
            calling.SetNextCalling (calling_list_head);
            calling_list_head = calling;
         }
         
         var code_snippet:CodeSnippet = new CodeSnippet (calling_list_head);
         
         return code_snippet;
      }
      
      public static function FunctionCallingDefine2FunctionCalling (parentFunctionInstance:FunctionInstance, playerWorld:World, funcCallingDefine:FunctionCallingDefine):FunctionCalling
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
            if (CoreFunctionIds.IsReturnCalling (function_id))
            {
               calling = new FunctionCalling_Return (core_func_definition, value_source_list, value_target_list, function_id);
            }
            else
            {
               calling = new FunctionCalling (core_func_definition, value_source_list, value_target_list);
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
                  value_source = new ValueSource_Direct (playerWorld.GetEntityByCreationId (direct_source_define.mValueObject as int));
                  break;
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
      
      public static function ByteArray2CodeSnippetDefine (byteArray:ByteArray):CodeSnippetDefine
      {
         return null;
      }
      
      public static function ByteArray2FunctionCallingDefine (byteArray:ByteArray):FunctionCallingDefine
      {
         //GetInputNumberTypeDetail
         return null;
      }
      
      public static function ByteArray2ValueSourceDefine (byteArray:ByteArray):ValueSourceDefine
      {
         //case ValueTypeDefine.ValueType_Number:
         //{
         //   number_value = ;
         //   switch ()
         //   {
         //      case ValueTypeDefine.NumberTypeDetail_Integer:
         //         writeInt ( int(number_value & 0xFFFFFFFF) );
         //   }
         //}
         
         return null;
      }
      
      public static function ByteArray2ValueTargetDefine (byteArray:ByteArray):ValueTargetDefine
      {
         //case ValueTypeDefine.ValueType_Number:
         //{
         //   number_value = ;
         //   switch ()
         //   {
         //      case ValueTypeDefine.NumberTypeDetail_Integer:
         //         writeInt ( int(number_value & 0xFFFFFFFF) );
         //   }
         //}
         
         return null;
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
               var directNumber:Number;
               var numberDetail:int;
               var numInputs:int = funcCallingDefine.mNumInputs;
               var j:int;
               for (j = 0; j < numInputs; ++ j)
               {
                  sourceDefine = funcCallingDefine.mInputValueSourceDefines [j];
                  sourceValueType = sourceDefine.GetValueSourceType ();
                  
                  if (sourceValueType == ValueTypeDefine.ValueType_Number && sourceDefine is ValueSourceDefine_Direct)
                  {
                     direcSourceDefine = sourceDefine as ValueSourceDefine_Direct;
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
