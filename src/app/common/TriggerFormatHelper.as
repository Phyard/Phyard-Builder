
package common {
   
   import flash.utils.ByteArray;
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.EntityCollisionCategory;
   
   import editor.trigger.entity.ConditionAndTargetValue;
   import editor.trigger.entity.EntityFunction;
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionDeclaration_Core;
   import editor.trigger.FunctionDeclaration_Custom;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.FunctionCalling;
   import editor.trigger.FunctionCalling_Core;
   import editor.trigger.FunctionCalling_Custom;
   import editor.trigger.VariableDefinition;
   import editor.trigger.ValueSource;
   import editor.trigger.ValueSource_Null;
   import editor.trigger.ValueSource_Direct;
   import editor.trigger.ValueSource_Variable;
   import editor.trigger.ValueSource_Property;
   import editor.trigger.ValueTarget;
   import editor.trigger.ValueTarget_Null;
   import editor.trigger.ValueTarget_Variable;
   import editor.trigger.ValueTarget_Property;
   import editor.trigger.VariableSpace;
   import editor.trigger.VariableInstance;
   import editor.trigger.VariableSpace;
   import editor.trigger.VariableDefinitionBoolean;
   import editor.trigger.VariableDefinitionNumber;
   import editor.trigger.VariableDefinitionString;
   import editor.trigger.VariableDefinitionEntity;
   import editor.trigger.VariableDefinitionCollisionCategory;
   
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
   
   import common.trigger.CoreFunctionIds;
   
   public class TriggerFormatHelper
   {
      
//==============================================================================================
// editor world -> define
//==============================================================================================
      
      public static function ConditionAndTargetValueArray2EntityDefineProperties (editorWorld:World, conditionAndTargetValueArray:Array, entityDefine:Object):void
      {
         if (conditionAndTargetValueArray == null)
         {
            entityDefine.mNumInputConditions = 0;
            entityDefine.mInputConditionEntityCreationIds = [];
            entityDefine.mInputConditionTargetValues = [];
         }
         else
         {
            var num:int = conditionAndTargetValueArray.length;
            
            var indexes:Array = new Array (num);
            var values:Array = new Array (num);
            var conditionAndValue:ConditionAndTargetValue;
            for (var i:int = 0; i < num; ++ i)
            {
               conditionAndValue = conditionAndTargetValueArray [i] as ConditionAndTargetValue;
               
               indexes [i] = editorWorld.GetEntityCreationId (conditionAndValue.mConditionEntity as Entity);
               values [i] = conditionAndValue.mTargetValue;
            }
            
            entityDefine.mNumInputConditions = num;
            entityDefine.mInputConditionEntityCreationIds = indexes;
            entityDefine.mInputConditionTargetValues = values;
         }
      }
      
      public static function Function2FunctionDefine (editorWorld:World, codeSnippet:CodeSnippet):FunctionDefine
      {
         var functionDefine:FunctionDefine = new FunctionDefine ();
         
         var functionDefinition:FunctionDefinition = codeSnippet.GetOwnerFunctionDefinition ();
         
         //>> from v`1.53
         if (functionDefinition.GetFunctionDeclaration () is FunctionDeclaration_Custom)
         {
            functionDefine.mInputVariableDefines = new Array ();
            VariableSpace2VariableDefines (editorWorld, functionDefinition.GetInputVariableSpace (), functionDefine.mInputVariableDefines, true);
            
            functionDefine.mOutputVariableDefines = new Array ();
            VariableSpace2VariableDefines (editorWorld, functionDefinition.GetOutputVariableSpace (), functionDefine.mOutputVariableDefines, false);
         }
         
         functionDefine.mLocalVariableDefines = new Array ();
         VariableSpace2VariableDefines (editorWorld, functionDefinition.GetLocalVariableSpace (), functionDefine.mLocalVariableDefines, false);
         //<<
         
         functionDefine.mCodeSnippetDefine = CodeSnippet2CodeSnippetDefine (editorWorld, codeSnippet);
         
         return functionDefine;
      }
      
      public static function CodeSnippet2CodeSnippetDefine (editorWorld:World, codeSnippet:CodeSnippet):CodeSnippetDefine
      {
         var num:int = codeSnippet.GetNumFunctionCallings ();
         var func_calling_defines:Array = new Array (num);
         
         for (var i:int = 0; i < num; ++ i)
            func_calling_defines [i] = FunctionCalling2FunctionCallingDefine (editorWorld, codeSnippet.GetFunctionCallingAt (i));
         
         var code_snippet_define:CodeSnippetDefine = new CodeSnippetDefine ();
         
         code_snippet_define.mName = codeSnippet.GetName ();
         code_snippet_define.mNumCallings = num;
         code_snippet_define.mFunctionCallingDefines = func_calling_defines;
         
         return code_snippet_define;
      }
      
      public static function FunctionCalling2FunctionCallingDefine (editorWorld:World, funcCalling:FunctionCalling):FunctionCallingDefine
      {
         var func_declaration:FunctionDeclaration = funcCalling.GetFunctionDeclaration ();
         var num_inputs:int = func_declaration.GetNumInputs ();
         var num_outputs:int = func_declaration.GetNumOutputs ();
         var i:int;
         
         var value_source_defines:Array = new Array (num_inputs);
         for (i = 0; i < num_inputs; ++ i)
            value_source_defines [i] = ValueSource2ValueSourceDefine (editorWorld, funcCalling.GetInputValueSource (i), func_declaration.GetInputParamValueType (i));
         
         var value_target_defines:Array = new Array (num_outputs);
         for (i = 0; i < num_outputs; ++ i)
            value_target_defines [i] = ValueTarget2ValueTargetDefine (editorWorld, funcCalling.GetOutputValueTarget (i), func_declaration.GetInputParamValueType (i));
         
         var func_calling_define:FunctionCallingDefine = new FunctionCallingDefine ();
         func_calling_define.mFunctionType = func_declaration.GetType ();
         func_calling_define.mFunctionId = func_declaration.GetID ();
         func_calling_define.mNumInputs = num_inputs;
         func_calling_define.mInputValueSourceDefines = value_source_defines;
         func_calling_define.mNumOutputs = num_outputs;
         func_calling_define.mOutputValueTargetDefines = value_target_defines;
         
         return func_calling_define;
      }
      
      public static function ValueSource2ValueSourceDefine (editorWorld:World, valueSource:ValueSource, valueType:int):ValueSourceDefine
      {
         var value_source_define:ValueSourceDefine = null;
         
         var source_type:int = valueSource.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source:ValueSource_Direct = valueSource as ValueSource_Direct;
            
            try
            {
               value_source_define = new ValueSourceDefine_Direct (valueType, ValidateDirectValueObject_Object2Define (editorWorld, valueType, direct_source.GetValueObject ()));
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source:ValueSource_Variable = valueSource as ValueSource_Variable;
            
            value_source_define = new ValueSourceDefine_Variable (variable_source.GetVariableSpaceType (), variable_source.GetVariableIndex ());
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Property)
         {
            var property_source:ValueSource_Property = valueSource as ValueSource_Property;
            
            
            value_source_define = new ValueSourceDefine_Property (ValueSource2ValueSourceDefine (editorWorld, property_source.GetEntityValueSource (), ValueTypeDefine.ValueType_Entity)
                                            , 0, property_source.GetPropertyVariableIndex ());
         }
         
         if (value_source_define == null)
         {
            value_source_define = new ValueSourceDefine_Null ();
            
            trace ("ValueSource2ValueSourceDefine: Error: value source is null");
         }
         
         return value_source_define;
      }
      
      public static function ValueTarget2ValueTargetDefine (editorWorld:World, valueTarget:ValueTarget, valueType:int):ValueTargetDefine
      {
         var value_target_define:ValueTargetDefine = null;
         
         var target_type:int = valueTarget.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variable_target:ValueTarget_Variable = valueTarget as ValueTarget_Variable;
            
            value_target_define = new ValueTargetDefine_Variable (variable_target.GetVariableSpaceType (), variable_target.GetVariableIndex ());
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Property)
         {
            var property_target:ValueTarget_Property = valueTarget as ValueTarget_Property;
            
            value_target_define = new ValueTargetDefine_Property (ValueSource2ValueSourceDefine (editorWorld, property_target.GetEntityValueSource (), ValueTypeDefine.ValueType_Entity)
                                            , 0, property_target.GetPropertyVariableIndex ());
         }
         
         if (value_target_define == null)
         {
            value_target_define = new ValueTargetDefine_Null ();
         }
         
         return value_target_define;
      }
      
      private static function ValidateDirectValueObject_Object2Define (editorWorld:World, valueType:int, valueObject:Object):Object
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
               var entity:Entity = valueObject as Entity;
               
               if (entity == null)
               {
                  if (valueObject is World)
                     return Define.EntityId_Ground;
                  else
                     return Define.EntityId_None;
               }
               else
               {
                  return editorWorld.GetEntityCreationId (entity);
               }
            }
            case ValueTypeDefine.ValueType_CollisionCategory:
               return editorWorld.GetCollisionManager ().GetCollisionCategoryIndex (valueObject as EntityCollisionCategory);
               break;
            default:
            {
               throw new Error ("! wrong value");
            }
         }
      }
      
      public static function VariableSpace2VariableDefines (editorWorld:World, variableSpace:VariableSpace, outputVariableDefines:Array, supportInitalValues:Boolean):void
      {
         var numVariables:int = variableSpace.GetNumVariableInstances ();
         
         //>> v1.52 only
         //var spaceDefine:VariableSpaceDefine = new VariableSpaceDefine ();
         //spaceDefine.mSpaceType = variableSpace.GetSpaceType ();
         //spaceDefine.mPackageId = 0;
         //spaceDefine.mParentPackageId = -1;
         //spaceDefine.mName = "";
         //spaceDefine.mVariableDefines = new Array (numVariables);
         //<<
         
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {
            var variableInstance:VariableInstance = variableSpace.GetVariableInstanceAt (variableId);
            
            var variableInstanceDefine:VariableInstanceDefine = new VariableInstanceDefine ();
            variableInstanceDefine.mName = variableInstance.GetName ();
            variableInstanceDefine.mDirectValueSourceDefine = new ValueSourceDefine_Direct (variableInstance.GetValueType (), ValidateDirectValueObject_Object2Define (editorWorld, variableInstance.GetValueType (), supportInitalValues ? variableInstance.GetValueObject () : ValueTypeDefine.GetDefaultDirectDefineValue (variableInstance.GetValueType ())));
            
            //spaceDefine.mVariableDefines [variableId] = variableInstanceDefine; // 1.52 only
            
            outputVariableDefines.push (variableInstanceDefine);
         }
         
         //return spaceDefine; // 1.52 only
      }
      
//==============================================================================================
// define -> definition (editor)
//==============================================================================================
      
      public static function FunctionDefine2FunctionDefinition (editorWorld:World, functionDefine:FunctionDefine, codeSnippet:CodeSnippet, functionDefinition:FunctionDefinition, createVariables:Boolean = true, createCodeSnippet:Boolean = true):void
      {
         if (createVariables)
         {
            //>> from v`1.53
            if (functionDefinition.GetFunctionDeclaration () is FunctionDeclaration_Custom)
            {
               VariableDefines2VariableSpace (editorWorld, functionDefine.mInputVariableDefines, functionDefinition.GetInputVariableSpace (), true);
               
               VariableDefines2VariableSpace (editorWorld, functionDefine.mOutputVariableDefines, functionDefinition.GetOutputVariableSpace (), false);
            }
            
            VariableDefines2VariableSpace (editorWorld, functionDefine.mLocalVariableDefines, functionDefinition.GetLocalVariableSpace (), false);
            //<<
         }
         
         if (createCodeSnippet)
         {
            LoadCodeSnippetFromCodeSnippetDefine (editorWorld, functionDefine.mCodeSnippetDefine, codeSnippet);
         }
      }
      
      public static function LoadCodeSnippetFromCodeSnippetDefine (editorWorld:World, codeSnippetDefine:CodeSnippetDefine, codeSnippet:CodeSnippet):void
      {
         var function_definition:FunctionDefinition = codeSnippet.GetOwnerFunctionDefinition ();
         
         var func_calling_defines:Array = codeSnippetDefine.mFunctionCallingDefines;
         var num:int = codeSnippetDefine.mNumCallings;
         var func_callings:Array = new Array (num);
         for (var i:int = 0; i < num; ++ i)
            func_callings [i] = FunctionCallingDefine2FunctionCalling (editorWorld,func_calling_defines [i], function_definition);
         
         codeSnippet.SetName (codeSnippetDefine.mName);
         codeSnippet.AssignFunctionCallings (func_callings);
      }
      
      public static function FunctionCallingDefine2FunctionCalling (editorWorld:World, funcCallingDefine:FunctionCallingDefine, functionDefinition:FunctionDefinition):FunctionCalling
      {
         var func_type:int = funcCallingDefine.mFunctionType;
         var func_id:int = funcCallingDefine.mFunctionId;
         
         var func_calling:FunctionCalling = null;
         
         var func_declaration:FunctionDeclaration;
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            func_declaration = TriggerEngine.GetPlayerCoreFunctionDeclarationById (func_id);
            
            if (func_declaration != null)
            {
               func_calling = new FunctionCalling_Core (editorWorld.GetTriggerEngine (), func_declaration as FunctionDeclaration_Core, false)
            }
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var entityFunction:EntityFunction = editorWorld.GetFunctionManager ().GetFunctionByIndex (func_id) as EntityFunction;
            
            if (entityFunction != null)
            {
               func_declaration = entityFunction.GetFunctionDeclaration ();
               
               func_calling = new FunctionCalling_Custom (editorWorld.GetTriggerEngine (), func_declaration as FunctionDeclaration_Custom, false);
            }
         }
         else if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         var value_sources:Array;
         var value_targets:Array;
         
         if (func_calling == null)
         {
            func_calling = new FunctionCalling_Core (editorWorld.GetTriggerEngine (), TriggerEngine.GetPlayerCoreFunctionDeclarationById (CoreFunctionIds.ID_Blank), false)
            
            value_sources = new Array ();
            value_targets = new Array ();
         }
         else
         {
            var real_num_inputs:int = func_declaration.GetNumInputs ()
            var real_num_outputs:int = func_declaration.GetNumOutputs ()
            
            var inputValueSourceDefines:Array = funcCallingDefine.mInputValueSourceDefines;
            var outputValueTargetDefines:Array = funcCallingDefine.mOutputValueTargetDefines;
            
            var i:int;
            
            value_sources = new Array (funcCallingDefine.mNumInputs);
            for (i = 0; i < real_num_inputs; ++ i)
            {
               if (i >= funcCallingDefine.mNumInputs)
                  value_sources [i] = func_declaration.GetInputParamDefinitionAt (i).GetDefaultValueSource (editorWorld.GetTriggerEngine ());
               else
                  value_sources [i] = ValueSourceDefine2ValueSource (editorWorld, inputValueSourceDefines [i], func_declaration.GetInputParamValueType (i), functionDefinition);
            }
            
            value_targets = new Array (funcCallingDefine.mNumOutputs);
            for (i = 0; i < real_num_outputs; ++ i)
            {
               if (i >= funcCallingDefine.mNumOutputs)
                  value_targets [i] = func_declaration.GetOutputParamDefinitionAt (i).GetDefaultValueTarget ();
               else
                  value_targets [i] = ValueTargetDefine2ValueTarget (editorWorld, outputValueTargetDefines [i], func_declaration.GetOutputParamValueType (i), functionDefinition);
            }
         }
         
         func_calling.AssignInputValueSources (value_sources);
         func_calling.AssignOutputValueTargets (value_targets);
         
         return func_calling;
      }
      
      public static function ValueSourceDefine2ValueSource (editorWorld:World, valueSourceDefine:ValueSourceDefine, valueType:int, functionDefinition:FunctionDefinition):ValueSource
      {
         var value_source:ValueSource = null;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            try
            {
               value_source = new ValueSource_Direct (ValidateDirectValueObject_Define2Object (editorWorld, valueType, direct_source_define.mValueObject));
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var variable_instance:VariableInstance = null;
            
            var variable_index:int = variable_source_define.mVariableIndex;
            
            switch (variable_source_define.mSpaceType)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  variable_instance = editorWorld.GetTriggerEngine ().GetGlobalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = editorWorld.GetTriggerEngine ().GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableInstanceAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = functionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Output:
                  variable_instance = functionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  variable_instance = functionDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               default:
                  break;
            }
            
            
            if (variable_instance != null)
            {
               value_source = new ValueSource_Variable (variable_instance);
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Property)
         {
            var property_source_define:ValueSourceDefine_Property = valueSourceDefine as ValueSourceDefine_Property;
            
            value_source = new ValueSource_Property (ValueSourceDefine2ValueSource (editorWorld, property_source_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, functionDefinition)
                                                   , new ValueSource_Variable (editorWorld.GetTriggerEngine ().GetEntityVariableSpace ().GetVariableInstanceAt (property_source_define.mPropertyId)));
         }
         
         if (value_source == null)
         {
            value_source = new ValueSource_Null ();
            
            trace ("ValueSourceDefine2ValueSource: Error: value source is null");
         }
         
         return value_source;
      }
      
      public static function ValueTargetDefine2ValueTarget (editorWorld:World, valueTargetDefine:ValueTargetDefine, valueType:int, functionDefinition:FunctionDefinition):ValueTarget
      {
         var value_target:ValueTarget = null;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            var variable_instance:VariableInstance = null;
            
            var variable_index:int = variable_target_define.mVariableIndex;
            
            switch (variable_target_define.mSpaceType)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  variable_instance = editorWorld.GetTriggerEngine ().GetGlobalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = editorWorld.GetTriggerEngine ().GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableInstanceAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = functionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Output:
                  variable_instance = functionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  variable_instance = functionDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               default:
                  break;
            }
            
            if (variable_instance != null)
            {
               value_target = new ValueTarget_Variable (variable_instance);
            }
         }
         else  if (target_type == ValueTargetTypeDefine.ValueTarget_Property)
         {
            var property_target_define:ValueTargetDefine_Property = valueTargetDefine as ValueTargetDefine_Property;
            
            value_target = new ValueTarget_Property (ValueSourceDefine2ValueSource (editorWorld, property_target_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, functionDefinition)
                                                   , new ValueTarget_Variable (editorWorld.GetTriggerEngine ().GetEntityVariableSpace ().GetVariableInstanceAt (property_target_define.mPropertyId)));
         }
         
         if (value_target == null)
         {
            value_target = new ValueTarget_Null ();
         }
         
         return value_target;
      }
      
      private static function ValidateDirectValueObject_Define2Object (editorWorld:World, valueType:int, valueobject:Object):Object
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return Boolean (valueobject);
            case ValueTypeDefine.ValueType_Number:
               return Number (valueobject);
            case ValueTypeDefine.ValueType_String:
               // "as String in commented off, otherwise value_object will be always null, bug?!
               // re: add back  "as String", in xml -> define: String (valueSourceElement.@direct_value)
               var text:String = valueobject as String
               if (text == null)
                  text = "";
               return text;
            case ValueTypeDefine.ValueType_Entity:
            {
               var entityIndex:int = valueobject as int;
               if (entityIndex < 0)
               {
                  if (entityIndex == Define.EntityId_Ground)
                  {
                     return editorWorld;
                  }
                  else if (entityIndex == Define.EntityId_None)
                  {
                     return null;
                  }
               }
               else
               {
                  return editorWorld.GetEntityByCreationId (entityIndex);
               }
            }
            case ValueTypeDefine.ValueType_CollisionCategory:
               return editorWorld.GetCollisionManager ().GetCollisionCategoryByIndex (valueobject as int);
            default:
            {
               throw new Error ("!wrong balue");
            }
         }
      }
      
      //public static function VariableSpaceDefine2VariableSpace (editorWorld:World, spaceDefine:VariableSpaceDefine, variableSpace:VariableSpace):void // v1.52 only
      public static function VariableDefines2VariableSpace (editorWorld:World, variableDefines:Array, variableSpace:VariableSpace, supportInitalValues:Boolean):void
      {
         //>> v1.52 only
         //var numVariables:int = spaceDefine.mVariableDefines.length;
         //
         //spaceDefine.mPackageId = 0;
         //spaceDefine.mSpaceType = variableSpace.GetSpaceType ();
         //spaceDefine.mParentPackageId = -1;
         //<<
         
         var numVariables:int = variableDefines.length;
         
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {
            //var variableInstanceDefine:VariableInstanceDefine = spaceDefine.mVariableDefines [variableId] as VariableInstanceDefine; // v1.52 only
            var variableInstanceDefine:VariableInstanceDefine = variableDefines [variableId] as VariableInstanceDefine;
            var directValueSourceDefine:ValueSourceDefine_Direct = variableInstanceDefine.mDirectValueSourceDefine;
            
            var variableDefinition:VariableDefinition = null;
            var valueObject:Object = supportInitalValues ? ValidateDirectValueObject_Define2Object (editorWorld, directValueSourceDefine.mValueType, directValueSourceDefine.mValueObject) : null;
            
            switch (directValueSourceDefine.mValueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  variableDefinition = new VariableDefinitionBoolean (variableInstanceDefine.mName);
                  break;
               case ValueTypeDefine.ValueType_Number:
                  variableDefinition = new VariableDefinitionNumber (variableInstanceDefine.mName);
                  break;
               case ValueTypeDefine.ValueType_String:
                  variableDefinition = new VariableDefinitionString (variableInstanceDefine.mName);
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  variableDefinition = new VariableDefinitionEntity (variableInstanceDefine.mName);
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  variableDefinition = new VariableDefinitionCollisionCategory (variableInstanceDefine.mName);
                  break;
               default:
               {
                  trace ("error!");
                  variableDefinition = new VariableDefinitionNumber ("!error");
               }
            }
            
            if (variableDefinition != null)
            {
               var vi:VariableInstance = variableSpace.CreateVariableInstanceFromDefinition (variableDefinition);
               vi.SetValueObject (valueObject);
            }
         }
      }
      
//==============================================================================================
// define -> byte array
//==============================================================================================
      
      public static function WriteFunctionDefineIntoBinFile (binFile:ByteArray, functionDefine:FunctionDefine, hasParams:Boolean, writeVariables:Boolean, customFunctionDefines:Array):void
      {
         if (writeVariables)
         {
            if (hasParams)
            {
               WriteVariableDefinesIntoBinFile (binFile, functionDefine.mInputVariableDefines, true);
               
               WriteVariableDefinesIntoBinFile (binFile, functionDefine.mOutputVariableDefines, false);
            }
            
            WriteVariableDefinesIntoBinFile (binFile, functionDefine.mLocalVariableDefines, false);
         }
         
         if (customFunctionDefines != null)
         {
            WriteCodeSnippetDefineIntoBinFile (binFile, functionDefine.mCodeSnippetDefine, customFunctionDefines);
         }
      }
      
      public static function WriteCodeSnippetDefineIntoBinFile (binFile:ByteArray, codeSnippetDefine:CodeSnippetDefine, customFunctionDefines:Array):void
      {
         binFile.writeUTF (codeSnippetDefine.mName);
         binFile.writeShort (codeSnippetDefine.mNumCallings);
         for (var i:int = 0; i < codeSnippetDefine.mNumCallings; ++ i)
            WriteFunctionCallingDefineIntoBinFile (binFile, codeSnippetDefine.mFunctionCallingDefines [i], customFunctionDefines);
      }
      
      public static function WriteFunctionCallingDefineIntoBinFile (binFile:ByteArray, funcCallingDefine:FunctionCallingDefine, customFunctionDefines:Array):void
      {
         // param number will be packed for easey back-compiliabel later
         
         var func_type:int = funcCallingDefine.mFunctionType;
         var func_id:int = funcCallingDefine.mFunctionId;
         
         var i:int;
         var num_inputs:int = funcCallingDefine.mNumInputs;
         var num_outputs:int = funcCallingDefine.mNumOutputs;
         var inputValueSourceDefines:Array = funcCallingDefine.mInputValueSourceDefines;
         var outputValueTargetDefines:Array = funcCallingDefine.mOutputValueTargetDefines;
         
         binFile.writeByte (func_type);
         binFile.writeShort (func_id);
         
         binFile.writeByte (num_inputs);
         binFile.writeByte (num_outputs);
         
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            var func_declaration:FunctionDeclaration = TriggerEngine.GetPlayerCoreFunctionDeclarationById (func_id);
            
            for (i = 0; i < num_inputs; ++ i)
               WriteValueSourceDefinIntoBinFile (binFile, inputValueSourceDefines [i], func_declaration.GetInputParamValueType (i), func_declaration.GetInputNumberTypeDetail (i));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var variableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for (i = 0; i < num_inputs; ++ i)
               WriteValueSourceDefinIntoBinFile (binFile, inputValueSourceDefines [i], (variableDefines [i] as VariableInstanceDefine).mDirectValueSourceDefine.mValueType, ValueTypeDefine.NumberTypeDetail_Double);
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         for (i = 0; i < num_outputs; ++ i)
            WriteValueTargetDefinIntoBinFile (binFile, outputValueTargetDefines [i]);
      }
      
      public static function WriteValueSourceDefinIntoBinFile (binFile:ByteArray, valueSourceDefine:ValueSourceDefine, valueType:int, numberDetail:int):void
      {
         // ValueSourceDefine_Direct.mValueType will not packed
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         binFile.writeByte (source_type);
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            var value_object:Object = direct_source_define.mValueObject;
            
            WriteDirectValueObjectIntoBinFile (binFile, valueType, numberDetail, direct_source_define.mValueObject);
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            binFile.writeByte (variable_source_define.mSpaceType);
            binFile.writeShort (variable_source_define.mVariableIndex);
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Property)
         {
            var property_source_define:ValueSourceDefine_Property = valueSourceDefine as ValueSourceDefine_Property;
            
            WriteValueSourceDefinIntoBinFile (binFile, property_source_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, ValueTypeDefine.NumberTypeDetail_Double); // ValueTypeDefine.NumberTypeDetail_Double is useless
            binFile.writeShort (property_source_define.mSpacePackageId);
            binFile.writeShort (property_source_define.mPropertyId);
         }
      }
      
      public static function WriteValueTargetDefinIntoBinFile (binFile:ByteArray, valueTargetDefine:ValueTargetDefine):void
      {
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         binFile.writeByte (target_type);
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            binFile.writeByte (variable_target_define.mSpaceType);
            binFile.writeShort (variable_target_define.mVariableIndex);
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Property)
         {
            var property_target_define:ValueTargetDefine_Property = valueTargetDefine as ValueTargetDefine_Property;
            
            WriteValueSourceDefinIntoBinFile (binFile, property_target_define.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, ValueTypeDefine.NumberTypeDetail_Double); // ValueTypeDefine.NumberTypeDetail_Double is useless
            binFile.writeShort (property_target_define.mSpacePackageId);
            binFile.writeShort (property_target_define.mPropertyId);
         }
      }
      
      private static function WriteDirectValueObjectIntoBinFile (binFile:ByteArray, valueType:int,  numberDetail:int, valueObject:Object):void
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               binFile.writeByte ((valueObject as Boolean) ? 1 : 0);
               break;
            case ValueTypeDefine.ValueType_Number:
               switch (numberDetail)
               {
                  case ValueTypeDefine.NumberTypeDetail_Single:
                     binFile.writeFloat (valueObject as Number);
                     break;
                  case ValueTypeDefine.NumberTypeDetail_Integer:
                     binFile.writeInt (valueObject as Number);
                     break;
                  case ValueTypeDefine.NumberTypeDetail_Double:
                  default:
                     binFile.writeDouble (valueObject as Number);
                     break;
               }
               
               break;
            case ValueTypeDefine.ValueType_String:
               binFile.writeUTF (valueObject == null ? "" : valueObject as String);
               break;
            case ValueTypeDefine.ValueType_Entity:
               binFile.writeInt (valueObject as int);
               break;
            case ValueTypeDefine.ValueType_CollisionCategory:
               binFile.writeInt (valueObject as int);
               break;
            default:
            {
               throw new Error ("! bad value");
            }
         }
      }
      
      //public static function WriteVariableSpaceDefineIntoBinFile (binFile:ByteArray, variableSpaceDefine:VariableSpaceDefine):void // v1.52 only
      public static function WriteVariableDefinesIntoBinFile (binFile:ByteArray, variableDefines:Array, supportInitalValues:Boolean):void
      {
         //>> v1.52 only
         //binFile.writeUTF (variableSpaceDefine.mName);
         //binFile.writeShort (variableSpaceDefine.mParentPackageId);
         //<<
         
         //var numVariables:int = variableSpaceDefine.mVariableDefines.length; // v1.52 only
         var numVariables:int = variableDefines.length;
         binFile.writeShort (numVariables);
         
         for (var i:int = 0; i < numVariables; ++ i)
         {
            //var viDefine:VariableInstanceDefine = variableSpaceDefine.mVariableDefines [i]; // v1.52 only
            var viDefine:VariableInstanceDefine = variableDefines [i];
            
            binFile.writeUTF (viDefine.mName);
            binFile.writeShort (viDefine.mDirectValueSourceDefine.mValueType);
            
            if (supportInitalValues)
            {
               WriteDirectValueObjectIntoBinFile (binFile, viDefine.mDirectValueSourceDefine.mValueType, ValueTypeDefine.NumberTypeDetail_Double, viDefine.mDirectValueSourceDefine.mValueObject);
            }
         }
      }
      
//==============================================================================================
// xml -> define
//==============================================================================================
      
      public static function CondtionListXml2EntityDefineProperties (conditionListElement:XMLList, entityDefine:Object):void
      {
         var numConditions:int = 0;
         var indexes:Array = new Array ();
         var values:Array = new Array ();
         
         var elementCondition:XML;
         for each (elementCondition in conditionListElement.Condition)
         {
            ++ numConditions;
            indexes.push (parseInt (elementCondition.@entity_index));
            values.push (parseInt (elementCondition.@target_value));
         }
         
         entityDefine.mNumInputConditions = numConditions;
         entityDefine.mInputConditionEntityCreationIds = indexes;
         entityDefine.mInputConditionTargetValues = values;
      }
      
      public static function Xml2FunctionDefine (functionElement:XML, functionDefine:FunctionDefine, parseParams:Boolean, convertVariables:Boolean, customFunctionDefines:Array):void
      {
         if (convertVariables)
         {
            if (parseParams)
            {
               VariablesXml2Define (functionElement.InputParameters [0], functionDefine.mInputVariableDefines, true);
               
               VariablesXml2Define (functionElement.OutputParameters [0], functionDefine.mOutputVariableDefines, false);
            }
            
            VariablesXml2Define (functionElement.LocalVariables [0], functionDefine.mLocalVariableDefines, false);
         }
         
         if (customFunctionDefines != null)
         {
            functionDefine.mCodeSnippetDefine = Xml2CodeSnippetDefine (functionElement.CodeSnippet [0], customFunctionDefines);
         }
      }
      
      public static function Xml2CodeSnippetDefine (codeSnippetElement:XML, customFunctionDefines:Array):CodeSnippetDefine
      {
         var func_calling_defines:Array = new Array ();
         
         var elementFunctionCalling:XML;
         for each (elementFunctionCalling in codeSnippetElement.FunctionCalling)
         {
            func_calling_defines.push (Xml2FunctionCallingDefine (elementFunctionCalling, customFunctionDefines));
         }
         
         var code_snippet_define:CodeSnippetDefine = new CodeSnippetDefine ();
         
         code_snippet_define.mName = codeSnippetElement.@name;
         code_snippet_define.mNumCallings = func_calling_defines.length;
         code_snippet_define.mFunctionCallingDefines = func_calling_defines;
         
         return code_snippet_define;
      }
      
      public static function Xml2FunctionCallingDefine (funcCallingElement:XML, customFunctionDefines:Array):FunctionCallingDefine
      {
         var func_type:int = parseInt (funcCallingElement.@function_type);
         var func_id  :int = parseInt (funcCallingElement.@function_id);
         
         var func_declaration:FunctionDeclaration = TriggerEngine.GetPlayerCoreFunctionDeclarationById (func_id);
         
         var i:int;
         var value_source_defines:Array = new Array ();
         var elementValueSource:XML;
         i = 0;
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            for each (elementValueSource in funcCallingElement.InputValueSources.ValueSource)
               value_source_defines.push (Xml2ValueSourceDefine (elementValueSource, func_declaration.GetInputParamValueType (i ++)));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledInputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for each (elementValueSource in funcCallingElement.InputValueSources.ValueSource)
               value_source_defines.push (Xml2ValueSourceDefine (elementValueSource, (calledInputVariableDefines [i ++] as VariableInstanceDefine).mDirectValueSourceDefine.mValueType));
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         var value_target_defines:Array = new Array ();
         var elementValueTarget:XML;
         i = 0;
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            for each (elementValueTarget in funcCallingElement.OutputValueTargets.ValueTarget)
               value_target_defines.push (Xml2ValueTargetDefine (elementValueTarget, func_declaration.GetOutputParamValueType (i ++)));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledOutputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mOutputVariableDefines;
            
            for each (elementValueTarget in funcCallingElement.OutputValueTargets.ValueTarget)
               value_target_defines.push (Xml2ValueTargetDefine (elementValueTarget, (calledOutputVariableDefines [i ++] as VariableInstanceDefine).mDirectValueSourceDefine.mValueType));
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         var func_calling_define:FunctionCallingDefine = new FunctionCallingDefine ();
         
         func_calling_define.mFunctionType = func_type;
         func_calling_define.mFunctionId = func_id;
         func_calling_define.mNumInputs = value_source_defines.length;
         func_calling_define.mInputValueSourceDefines = value_source_defines;
         func_calling_define.mNumOutputs = value_target_defines.length;
         func_calling_define.mOutputValueTargetDefines = value_target_defines;
         
         return func_calling_define;
      }
      
      public static function Xml2ValueSourceDefine (valueSourceElement:XML, valueType:int):ValueSourceDefine
      {
         var value_source_define:ValueSourceDefine = null;
         
         var source_type:int = parseInt (valueSourceElement.@type);
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            try
            {
               value_source_define = new ValueSourceDefine_Direct (valueType, ValidateDirectValueObject_Xml2Define (valueType, valueSourceElement.@direct_value));
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            value_source_define = new ValueSourceDefine_Variable (parseInt (valueSourceElement.@variable_space), parseInt (valueSourceElement.@variable_index));
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Property)
         {
            value_source_define = new ValueSourceDefine_Property (Xml2ValueSourceDefine (valueSourceElement.PropertyOwnerValueSource[0], ValueTypeDefine.ValueType_Entity)
                                                                  , parseInt (valueSourceElement.@property_package_id), parseInt (valueSourceElement.@property_id));
         }
         
         if (value_source_define == null)
         {
            value_source_define = new ValueSourceDefine_Null ();
            
            trace ("Xml2ValueSourceDefine: Error: value source is null");
         }
         
         return value_source_define;
      }
      
      public static function Xml2ValueTargetDefine (valueTargetElement:XML, valueType:int):ValueTargetDefine
      {
         var value_target_define:ValueTargetDefine = null;
         
         var target_type:int = parseInt (valueTargetElement.@type);
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            value_target_define = new ValueTargetDefine_Variable (parseInt (valueTargetElement.@variable_space), parseInt (valueTargetElement.@variable_index));
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_Property)
         {
            value_target_define = new ValueTargetDefine_Property (Xml2ValueSourceDefine (valueTargetElement.PropertyOwnerValueSource[0], ValueTypeDefine.ValueType_Entity)
                                                                  , parseInt (valueTargetElement.@property_package_id), parseInt (valueTargetElement.@property_id));
         }
         
         if (value_target_define == null)
         {
            value_target_define = new ValueTargetDefine_Null ();
         }
         
         return value_target_define;
      }
      
      private static function ValidateDirectValueObject_Xml2Define (valueType:int, direct_value:String):Object
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return parseInt (String (direct_value)) != 0;
            case ValueTypeDefine.ValueType_Number:
               return parseFloat (String (direct_value));
            case ValueTypeDefine.ValueType_String:
               var text:String = String (direct_value); // valueSourceElement.@direct_value is not a string, ??? 
               if (text == null)
                  text = "";
               return text;
            case ValueTypeDefine.ValueType_Entity:
               return parseInt (String (direct_value));
            case ValueTypeDefine.ValueType_CollisionCategory:
               return parseInt (String (direct_value));
            default:
            {
               throw new Error ("! wrong value");
            }
         }
      }
      
      //public static function VariableSpaceXml2Define (elementVariablePackage:XML):VariableSpaceDefine // v1.52 only
      public static function VariablesXml2Define (elementVariablePackage:XML, outputVariableDefines:Array, supportInitalValues:Boolean):void
      {
         //>> v1.52 only
         //var variableSpaceDefine:VariableSpaceDefine = new VariableSpaceDefine ();
         //
         //variableSpaceDefine.mName = elementVariablePackage.@name;
         //variableSpaceDefine.mPackageId = parseInt (elementVariablePackage.@package_id);
         //variableSpaceDefine.mParentPackageId = parseInt (elementVariablePackage.@parent_package_id);
         //variableSpaceDefine.mVariableDefines = new Array ();
         
         
         for each (var element:XML in elementVariablePackage.Variable)
         {
            var viDefine:VariableInstanceDefine = new VariableInstanceDefine ();
            
            var valueType:int = parseInt (element.@value_type);
            
            viDefine.mName = element.@name;
            viDefine.mDirectValueSourceDefine = new ValueSourceDefine_Direct (valueType, supportInitalValues ? ValidateDirectValueObject_Xml2Define (valueType, element.@initial_value) : ValueTypeDefine.GetDefaultDirectDefineValue (valueType));
            
            //variableSpaceDefine.mVariableDefines.push (viDefine); v1.52 only
            outputVariableDefines.push (viDefine);
         }
         
         //return variableSpaceDefine; // v1.52 only
     }
      
//========================================================================================
// 
//========================================================================================
      
      // float -> 6 precisions, double -> 12 precisions
      public static function AdjustNumberPrecisionsInCodeSnippet (codeSnippet:CodeSnippet):void
      {
         codeSnippet.AdjustNumberPrecisions ();
      }
      
      public static function ShiftReferenceIndexesInCodeSnippetDefine (editorWorld:World, codeSnippetDefine:CodeSnippetDefine, isCustomCodeSnippet:Boolean, entityIdShiftedValue:int, ccatIdShiftedValue:int, globalVariableShiftIndex:int, entityVariableShiftIndex:int, beginningCustomFunctionIndex:int):void
      {
         var funcCallingDefine:FunctionCallingDefine;
         var i:int;
         var j:int;
         
         var numCallings:int = codeSnippetDefine.mNumCallings;
         for (i = 0; i < numCallings; ++ i)
         {
            funcCallingDefine = codeSnippetDefine.mFunctionCallingDefines [i];
            
            var func_type:int = funcCallingDefine.mFunctionType;
            var functionId:int = funcCallingDefine.mFunctionId;
            
            var funcDclaration:FunctionDeclaration;
            if (func_type == FunctionTypeDefine.FunctionType_Core)
            {
               funcDclaration = TriggerEngine.GetPlayerCoreFunctionDeclarationById (functionId);
            }
            else // if (func_type == FunctionTypeDefine.FunctionType_Custom)
            {
               functionId += beginningCustomFunctionIndex;
               funcCallingDefine.mFunctionId = functionId;
               funcDclaration = editorWorld.GetFunctionManager ().GetFunctionByIndex (functionId).GetFunctionDeclaration ();
            }
            
            if (isCustomCodeSnippet)
            {
            }
            else // only apply for main scene code snippets
            {
               //if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
               //{
                  var numInputs:int = funcCallingDefine.mNumInputs;
                  for (j = 0; j < numInputs; ++ j)
                  {
                     ShiftReferenceIndexesInValueSourceDefine (funcCallingDefine.mInputValueSourceDefines [j] as ValueSourceDefine, funcDclaration.GetInputParamValueType (j), entityIdShiftedValue, ccatIdShiftedValue, globalVariableShiftIndex, entityVariableShiftIndex);
                  }
                  
                  var numOutputs:int = funcCallingDefine.mNumOutputs;
                  for (j = 0; j < numOutputs; ++ j)
                  {
                     ShiftReferenceIndexesInValueTargetDefine (funcCallingDefine.mOutputValueTargetDefines [j] as ValueTargetDefine, funcDclaration.GetOutputParamValueType (j), entityIdShiftedValue, ccatIdShiftedValue, globalVariableShiftIndex, entityVariableShiftIndex);
                  }
               //}
               //else
               //{
               //}
            }
         }
      }
      
      public static function ShiftReferenceIndexesInValueSourceDefine (sourceDefine:ValueSourceDefine, valueType:int, entityIdShiftedValue:int, ccatIdShiftedValue:int, globalVariableShiftIndex:int, entityVariableShiftIndex:int):void
      {
         var valueSourceType:int = sourceDefine.GetValueSourceType ();
         
         if (valueSourceType == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var directSourceDefine:ValueSourceDefine_Direct = sourceDefine as ValueSourceDefine_Direct;
            
            if (valueType == ValueTypeDefine.ValueType_Entity)
            {
               var entityIndex:int = int (directSourceDefine.mValueObject);
               
               if (entityIndex >= 0)
                  directSourceDefine.mValueObject = entityIndex + entityIdShiftedValue;
            }
            else if (valueType == ValueTypeDefine.ValueType_CollisionCategory)
            {
               var ccatIndex:int = int (directSourceDefine.mValueObject);
               
               if (ccatIndex >= 0)
                  directSourceDefine.mValueObject = ccatIndex + ccatIdShiftedValue;
            }
         }
         else if (valueSourceType == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variableSourceDefine:ValueSourceDefine_Variable = sourceDefine as ValueSourceDefine_Variable;
            
            if (variableSourceDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_Global)
            {
               var variableIndex:int = variableSourceDefine.mVariableIndex;
               
               if (variableIndex >= 0)
                  variableSourceDefine.mVariableIndex = variableIndex + globalVariableShiftIndex;
            }
         }
         else if (valueSourceType == ValueSourceTypeDefine.ValueSource_Property)
         {
            var propertySourceDefine:ValueSourceDefine_Property = sourceDefine as ValueSourceDefine_Property;
            
            var propertyId:int = propertySourceDefine.mPropertyId;
            if (propertyId >= 0)
               propertySourceDefine.mPropertyId = propertyId + entityVariableShiftIndex;
            
            ShiftReferenceIndexesInValueSourceDefine (propertySourceDefine.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, entityIdShiftedValue, ccatIdShiftedValue, globalVariableShiftIndex, entityVariableShiftIndex);
         }
      }
      
      public static function ShiftReferenceIndexesInValueTargetDefine (targetDefine:ValueTargetDefine, valueType:int, entityIdShiftedValue:int, ccatIdShiftedValue:int, globalVariableShiftIndex:int, entityVariableShiftIndex:int):void
      {
         var valueTargetType:int = targetDefine.GetValueTargetType ();
         
         if (valueTargetType == ValueTargetTypeDefine.ValueTarget_Variable)
         {
            var variableTargetDefine:ValueTargetDefine_Variable = targetDefine as ValueTargetDefine_Variable;
            
            if (variableTargetDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_Global)
            {
               var variableIndex:int = variableTargetDefine.mVariableIndex;
               
               if (variableIndex >= 0)
                  variableTargetDefine.mVariableIndex = variableIndex + globalVariableShiftIndex;
            }
         }
         else if (valueTargetType == ValueTargetTypeDefine.ValueTarget_Property)
         {
            var propertyTargetDefine:ValueTargetDefine_Property = targetDefine as ValueTargetDefine_Property;
            
            var propertyId:int = propertyTargetDefine.mPropertyId;
            if (propertyId >= 0)
               propertyTargetDefine.mPropertyId = propertyId + entityVariableShiftIndex;
            
            ShiftReferenceIndexesInValueSourceDefine (propertyTargetDefine.mEntityValueSourceDefine, ValueTypeDefine.ValueType_Entity, entityIdShiftedValue, ccatIdShiftedValue, globalVariableShiftIndex, entityVariableShiftIndex);
         }
      }
   }
}
