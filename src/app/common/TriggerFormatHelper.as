
package common {
   
   import flash.utils.ByteArray;
   
   import editor.world.World;
   import editor.world.CoreClasses;
   import editor.entity.Scene;
   import editor.entity.Entity;
   //import editor.entity.EntityCollisionCategory;
   import editor.ccat.CollisionCategory;
   
   import editor.image.AssetImageModule;
   
   import editor.sound.AssetSound;
   
   import editor.trigger.entity.ConditionAndTargetValue;
   //import editor.trigger.entity.EntityFunction;
   import editor.codelib.AssetFunction;
   
   //import editor.trigger.TriggerEngine;
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
   import editor.trigger.ValueSource_EntityProperty;
   import editor.trigger.ValueTarget;
   import editor.trigger.ValueTarget_Null;
   import editor.trigger.ValueTarget_Variable;
   import editor.trigger.ValueTarget_EntityProperty;
   import editor.trigger.VariableSpace;
   import editor.trigger.VariableInstance;
   import editor.trigger.VariableSpace;
   import editor.trigger.VariableSpaceLocal;
   import editor.trigger.VariableDefinitionBoolean;
   import editor.trigger.VariableDefinitionNumber;
   import editor.trigger.VariableDefinitionString;
   import editor.trigger.VariableDefinitionScene;
   import editor.trigger.VariableDefinitionEntity;
   import editor.trigger.VariableDefinitionCollisionCategory;
   import editor.trigger.VariableDefinitionArray;
   import editor.trigger.VariableDefinitionModule;
   import editor.trigger.VariableDefinitionSound;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ClassTypeDefine;
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
   
   import common.trigger.CoreFunctionIds;
   
   public class TriggerFormatHelper
   {
      
//==============================================================================================
// editor world -> define
//==============================================================================================
      
      public static function ConditionAndTargetValueArray2EntityDefineProperties (scene:Scene, conditionAndTargetValueArray:Array, entityDefine:Object):void
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
               
               indexes [i] = scene.GetAssetCreationId (conditionAndValue.mConditionEntity as Entity);
               values [i] = conditionAndValue.mTargetValue;
            }
            
            entityDefine.mNumInputConditions = num;
            entityDefine.mInputConditionEntityCreationIds = indexes;
            entityDefine.mInputConditionTargetValues = values;
         }
      }
      
      public static function Function2FunctionDefine (scene:Scene, codeSnippet:CodeSnippet, createLocalVariableDefines:Boolean = true):FunctionDefine
      {
         var functionDefine:FunctionDefine = new FunctionDefine ();
         
         var functionDefinition:FunctionDefinition = codeSnippet.GetOwnerFunctionDefinition ();
         
         //>> from v`1.53
         if (functionDefinition.GetFunctionDeclaration () is FunctionDeclaration_Custom)
         {
            functionDefine.mInputVariableDefines = new Array ();
            VariableSpace2VariableDefines (scene, functionDefinition.GetInputVariableSpace (), functionDefine.mInputVariableDefines, true, false);
            
            functionDefine.mOutputVariableDefines = new Array ();
            VariableSpace2VariableDefines (scene, functionDefinition.GetOutputVariableSpace (), functionDefine.mOutputVariableDefines, false, false);
         }
         
         if (createLocalVariableDefines)
         {
            //>>from v1.56
            functionDefine.mLocalVariableDefines = new Array ();
            VariableSpace2VariableDefines (scene, functionDefinition.GetLocalVariableSpace (), functionDefine.mLocalVariableDefines, false, false);
            //<<
         }
         //<<
         
         functionDefine.mCodeSnippetDefine = CodeSnippet2CodeSnippetDefine (scene, codeSnippet);
         
         return functionDefine;
      }
      
      public static function CodeSnippet2CodeSnippetDefine (scene:Scene, codeSnippet:CodeSnippet):CodeSnippetDefine
      {
         var num:int = codeSnippet.GetNumFunctionCallings ();
         var func_calling_defines:Array = new Array (num);
         
         for (var i:int = 0; i < num; ++ i)
            func_calling_defines [i] = FunctionCalling2FunctionCallingDefine (scene, codeSnippet.GetFunctionCallingAt (i));
         
         var code_snippet_define:CodeSnippetDefine = new CodeSnippetDefine ();
         
         code_snippet_define.mName = codeSnippet.GetName ();
         code_snippet_define.mNumCallings = num;
         code_snippet_define.mFunctionCallingDefines = func_calling_defines;
         
         return code_snippet_define;
      }
      
      public static function FunctionCalling2FunctionCallingDefine (scene:Scene, funcCalling:FunctionCalling):FunctionCallingDefine
      {
         var func_declaration:FunctionDeclaration = funcCalling.GetFunctionDeclaration ();
         var num_inputs:int = func_declaration.GetNumInputs ();
         var num_outputs:int = func_declaration.GetNumOutputs ();
         var i:int;
         
         var value_source_defines:Array = new Array (num_inputs);
         for (i = 0; i < num_inputs; ++ i)
            value_source_defines [i] = ValueSource2ValueSourceDefine (scene, funcCalling.GetInputValueSource (i), func_declaration.GetInputParamClassType (i), func_declaration.GetInputParamValueType (i));
         
         var value_target_defines:Array = new Array (num_outputs);
         for (i = 0; i < num_outputs; ++ i)
            value_target_defines [i] = ValueTarget2ValueTargetDefine (scene, funcCalling.GetOutputValueTarget (i));//, func_declaration.GetInputParamValueType (i));
         
         var func_calling_define:FunctionCallingDefine = new FunctionCallingDefine ();
         func_calling_define.mFunctionType = func_declaration.GetType ();
         func_calling_define.mFunctionId = func_declaration.GetID ();
         func_calling_define.mNumInputs = num_inputs;
         func_calling_define.mInputValueSourceDefines = value_source_defines;
         func_calling_define.mNumOutputs = num_outputs;
         func_calling_define.mOutputValueTargetDefines = value_target_defines;
         
         return func_calling_define;
      }
      
      public static function ValueSource2ValueSourceDefine (scene:Scene, valueSource:ValueSource, classType:int, valueType:int):ValueSourceDefine
      {
         var value_source_define:ValueSourceDefine = null;
         
         var source_type:int = valueSource.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source:ValueSource_Direct = valueSource as ValueSource_Direct;
            
            try
            {
               value_source_define = new ValueSourceDefine_Direct (/*valueType, */CoreClasses.ValidateDirectValueObject_Object2Define (scene, classType, valueType, direct_source.GetValueObject ()));
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable || source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            var variable_source:ValueSource_Variable = valueSource as ValueSource_Variable;
            
            if (variable_source.GetPropertyIndex () < 0)
               value_source_define = new ValueSourceDefine_Variable (variable_source.GetVariableSpaceType (), variable_source.GetVariableIndex ());
            else
               value_source_define = new ValueSourceDefine_ObjectProperty (variable_source.GetVariableSpaceType (), variable_source.GetVariableIndex (), variable_source.GetPropertyIndex ());
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            var property_source:ValueSource_EntityProperty = valueSource as ValueSource_EntityProperty;
            
            // before v2.03
            //value_source_define = new ValueSourceDefine_EntityProperty (ValueSource2ValueSourceDefine (scene, property_source.GetEntityValueSource (), CoreClassIds.ValueType_Entity)
            //                                , 0, property_source.GetPropertyVariableIndex ());
            // from v2.03
            //value_source_define = new ValueSourceDefine_EntityProperty (ValueSource2ValueSourceDefine (scene, property_source.GetEntityValueSource (), ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity)
            //                                , property_source.GetPropertyVariableSpaceType (), property_source.GetPropertyVariableIndex ());
            // from v2.05
            value_source_define = new ValueSourceDefine_EntityProperty (ValueSource2ValueSourceDefine (scene, property_source.GetEntityValueSource (), ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity)
                                                                      , ValueSource2ValueSourceDefine (scene, property_source.GetPropertyValueSource (), classType, valueType) as ValueSourceDefine_Variable
                                                                     );
         }
         
         if (value_source_define == null)
         {
            value_source_define = new ValueSourceDefine_Null ();
            
            trace ("ValueSource2ValueSourceDefine: Error: value source is null");
         }
         
         return value_source_define;
      }
      
      public static function ValueTarget2ValueTargetDefine (scene:Scene, valueTarget:ValueTarget):ValueTargetDefine
      {
         var value_target_define:ValueTargetDefine = null;
         
         var target_type:int = valueTarget.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable || target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            var variable_target:ValueTarget_Variable = valueTarget as ValueTarget_Variable;
            
            if (variable_target.GetPropertyIndex () < 0)
               value_target_define = new ValueTargetDefine_Variable (variable_target.GetVariableSpaceType (), variable_target.GetVariableIndex ());
            else
               value_target_define = new ValueTargetDefine_ObjectProperty (variable_target.GetVariableSpaceType (), variable_target.GetVariableIndex (), variable_target.GetPropertyIndex ());
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            var property_target:ValueTarget_EntityProperty = valueTarget as ValueTarget_EntityProperty;
            
            // before v2.03
            //value_target_define = new ValueTargetDefine_EntityProperty (ValueSource2ValueSourceDefine (scene, property_target.GetEntityValueSource (), CoreClassIds.ValueType_Entity)
            //                                , 0, property_target.GetPropertyVariableIndex ());
            // from v2.03
            //value_target_define = new ValueTargetDefine_EntityProperty (ValueSource2ValueSourceDefine (scene, property_target.GetEntityValueSource (), ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity)
            //                                , property_target.GetPropertyVariableSpaceType (), property_target.GetPropertyVariableIndex ());
            // since v2.05
            value_target_define = new ValueTargetDefine_EntityProperty (ValueSource2ValueSourceDefine (scene, property_target.GetEntityValueSource (), ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity)
                                                                      , ValueTarget2ValueTargetDefine (scene, property_target.GetPropertyValueTarget ()) as ValueTargetDefine_Variable
                                                                    );
         }
         
         if (value_target_define == null)
         {
            value_target_define = new ValueTargetDefine_Null ();
         }
         
         return value_target_define;
      }
      
      public static function VariableSpace2VariableDefines (scene:Scene, variableSpace:VariableSpace, outputVariableDefines:Array, supportInitalValues:Boolean, variablesHaveKey:Boolean = false):void
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
         
         if (variablesHaveKey != variableSpace.IsVariableKeySupported ())
            throw new Error ();
         
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {
            var variableInstance:VariableInstance = variableSpace.GetVariableInstanceAt (variableId);
            
            var variableDefine:VariableDefine = new VariableDefine ();
            if (variablesHaveKey)
               variableDefine.mKey = variableInstance.GetKey ();
            variableDefine.mName = variableInstance.GetName ();
            //variableDefine.mDirectValueSourceDefine = new ValueSourceDefine_Direct (variableInstance.GetValueType (), CoreClasses.ValidateDirectValueObject_Object2Define (scene, variableInstance.GetValueType (), supportInitalValues ? variableInstance.GetValueObject () : CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (variableInstance.GetValueType ())));
            variableDefine.mClassType = variableInstance.GetClassType (); // since v2.05
            variableDefine.mValueType = variableInstance.GetValueType ();
            variableDefine.mValueObject = CoreClasses.ValidateDirectValueObject_Object2Define (scene, variableInstance.GetClassType (), variableInstance.GetValueType (), supportInitalValues ? variableInstance.GetValueObject () : CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (variableInstance.GetValueType ()));
            
            //spaceDefine.mVariableDefines [variableId] = variableDefine; // 1.52 only
            
            outputVariableDefines.push (variableDefine);
         }
         
         //return spaceDefine; // 1.52 only
      }
      
//==============================================================================================
// define -> definition (editor)
//==============================================================================================
      
      public static function FunctionDefine2FunctionDefinition (scene:Scene, functionDefine:FunctionDefine, codeSnippet:CodeSnippet, functionDefinition:FunctionDefinition, createVariables:Boolean, classRefIndex_CorrectionTable:Array, createCodeSnippet:Boolean = true, localVariableSpace:VariableSpaceLocal = null):void
      {
         if (createVariables)
         {
            //>> from v`1.53
            if (functionDefinition.GetFunctionDeclaration () is FunctionDeclaration_Custom)
            {
               VariableDefines2VariableSpace (scene, functionDefine.mInputVariableDefines, classRefIndex_CorrectionTable, functionDefinition.GetInputVariableSpace (), true, false);
               
               VariableDefines2VariableSpace (scene, functionDefine.mOutputVariableDefines, classRefIndex_CorrectionTable, functionDefinition.GetOutputVariableSpace (), false, false);
            }
            
            if (localVariableSpace == null)
            {
               VariableDefines2VariableSpace (scene, functionDefine.mLocalVariableDefines, classRefIndex_CorrectionTable, functionDefinition.GetLocalVariableSpace (), false, false);
            }
            //>> from v1.56
            else
            {
               functionDefinition.SetLocalVariableSpace (localVariableSpace);
            }
           //<<
         }
         
         if (createCodeSnippet)
         {
            LoadCodeSnippetFromCodeSnippetDefine (scene, functionDefine.mCodeSnippetDefine, codeSnippet);
         }
      }
      
      public static function LoadCodeSnippetFromCodeSnippetDefine (scene:Scene, codeSnippetDefine:CodeSnippetDefine, codeSnippet:CodeSnippet):void
      {
         var function_definition:FunctionDefinition = codeSnippet.GetOwnerFunctionDefinition ();
         
         var func_calling_defines:Array = codeSnippetDefine.mFunctionCallingDefines;
         var num:int = codeSnippetDefine.mNumCallings;
         var func_callings:Array = new Array (num);
         for (var i:int = 0; i < num; ++ i)
            func_callings [i] = FunctionCallingDefine2FunctionCalling (scene,func_calling_defines [i], function_definition);
         
         codeSnippet.SetName (codeSnippetDefine.mName);
         codeSnippet.AssignFunctionCallings (func_callings);
      }
      
      public static function FunctionCallingDefine2FunctionCalling (scene:Scene, funcCallingDefine:FunctionCallingDefine, functionDefinition:FunctionDefinition):FunctionCalling
      {
         var func_type:int = funcCallingDefine.mFunctionType;
         var func_id:int = funcCallingDefine.mFunctionId;
         
         var func_calling:FunctionCalling = null;
         
         var func_declaration:FunctionDeclaration;
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            func_declaration = World.GetPlayerCoreFunctionDeclarationById (func_id);
            
            if (func_declaration != null)
            {
               func_calling = new FunctionCalling_Core (/*editorWorld.GetTriggerEngine (), */func_declaration as FunctionDeclaration_Core, false)
            }
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var functionAsset:AssetFunction = scene.GetCodeLibManager ().GetFunctionByIndex (func_id) as AssetFunction;
            
            if (functionAsset != null)
            {
               func_declaration = functionAsset.GetFunctionDeclaration ();
               
               func_calling = new FunctionCalling_Custom (/*editorWorld.GetTriggerEngine (), */func_declaration as FunctionDeclaration_Custom, false);
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
            func_calling = new FunctionCalling_Core (/*editorWorld.GetTriggerEngine (), */World.GetPlayerCoreFunctionDeclarationById (CoreFunctionIds.ID_Blank), false)
            
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
                  value_sources [i] = func_declaration.GetInputParamDefinitionAt (i).GetDefaultValueSource (/*editorWorld.GetTriggerEngine ()*/);
               else
                  value_sources [i] = ValueSourceDefine2ValueSource (scene, inputValueSourceDefines [i], func_declaration.GetInputParamClassType (i), func_declaration.GetInputParamValueType (i), functionDefinition);
            }
            
            value_targets = new Array (funcCallingDefine.mNumOutputs);
            for (i = 0; i < real_num_outputs; ++ i)
            {
               if (i >= funcCallingDefine.mNumOutputs)
                  value_targets [i] = func_declaration.GetOutputParamDefinitionAt (i).GetDefaultValueTarget ();
               else
                  value_targets [i] = ValueTargetDefine2ValueTarget (scene, outputValueTargetDefines [i], func_declaration.GetInputParamClassType (i), func_declaration.GetOutputParamValueType (i), functionDefinition);
            }
         }
         
         func_calling.AssignInputValueSources (value_sources);
         func_calling.AssignOutputValueTargets (value_targets);
         
         return func_calling;
      }
      
      public static function ValueSourceDefine2ValueSource (scene:Scene, valueSourceDefine:ValueSourceDefine, classType:int, valueType:int, functionDefinition:FunctionDefinition, forPropertyOfEntity:Boolean = false):ValueSource
      {
         var value_source:ValueSource = null;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            try
            {
               value_source = new ValueSource_Direct (CoreClasses.ValidateDirectValueObject_Define2Object (scene, classType, valueType, direct_source_define.mValueObject));
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable || source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var variable_instance:VariableInstance = null;
            
            var variable_index:int = variable_source_define.mVariableIndex;
            
            var variable_space_type:int = variable_source_define.mSpaceType;
            
            if (forPropertyOfEntity)
            {
               // ! important. In history, the value may be 0 for ValueSpaceTypeDefine.ValueSpace_EntityProperties
               if (variable_space_type != ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
                  variable_space_type = ValueSpaceTypeDefine.ValueSpace_EntityProperties;
            }
            
            switch (variable_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_World:
                  variable_instance = scene.GetWorld ().GetWorldVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GameSave:
                  variable_instance = scene.GetWorld ().GetGameSaveVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Session:
                  variable_instance = scene.GetCodeLibManager ().GetSessionVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
                  variable_instance = scene.GetWorld ().GetCommonSceneGlobalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  variable_instance = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Register:
                  if (classType == ClassTypeDefine.ClassType_Core)
                  {
                     var variable_space:VariableSpace = scene.GetWorld ().GetRegisterVariableSpace (valueType);
                     if (variable_space != null)
                     {
                        variable_instance = variable_space.GetVariableInstanceAt (variable_index);
                     }
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
               //>>> from v2.05
               case ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties:
                  variable_instance = scene.GetWorld ().GetCommonCustomEntityVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_EntityProperties:
                  variable_instance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               //<<<
               default:
                  break;
            }
            
            if (variable_instance != null)
            {
               value_source = new ValueSource_Variable (variable_instance);
               if (source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
               {
                  (value_source as ValueSource_Variable).SetPropertyIndex ((variable_source_define as ValueSourceDefine_ObjectProperty).mPropertyIndex);
               }
            }
            else if (forPropertyOfEntity)
            {
               // make sure it is not null Variable source for property of entity
               variable_instance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetNullVariableInstance ();
               value_source = new ValueSource_Variable (variable_instance);
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            var property_source_define:ValueSourceDefine_EntityProperty = valueSourceDefine as ValueSourceDefine_EntityProperty;
            
            //switch (property_source_define.mSpacePackageId)
            //{
            //   case ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties:
            //      value_source = new ValueSource_EntityProperty (ValueSourceDefine2ValueSource (scene, property_source_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, functionDefinition)
            //                                       , new ValueSource_Variable (scene.GetWorld ().GetCommonCustomEntityVariableSpace ().GetVariableInstanceAt (property_source_define.mPropertyId)));
            //      break;
            //   case ValueSpaceTypeDefine.ValueSpace_EntityProperties:
            //   case 0: // for compability, old versions use this value for ValueSpaceTypeDefine.ValueSpace_EntityProperties
            //   default:
            //      value_source = new ValueSource_EntityProperty (ValueSourceDefine2ValueSource (scene, property_source_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, functionDefinition)
            //                                       , new ValueSource_Variable (scene.GetCodeLibManager ().GetEntityVariableSpace ().GetVariableInstanceAt (property_source_define.mPropertyId)));
            //      break;
            //}
            
            value_source = new ValueSource_EntityProperty (ValueSourceDefine2ValueSource (scene, property_source_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, functionDefinition)
                                                         , ValueSourceDefine2ValueSource (scene, property_source_define.mPropertyValueSourceDefine, classType, valueType, null, true) as ValueSource_Variable
                                                      );
         }
         
         if (value_source == null)
         {
            value_source = new ValueSource_Null ();
            
            trace ("ValueSourceDefine2ValueSource: Error: value source is null");
         }
         
         return value_source;
      }
      
      public static function ValueTargetDefine2ValueTarget (scene:Scene, valueTargetDefine:ValueTargetDefine, classType:int, valueType:int, functionDefinition:FunctionDefinition, forPropertyOfEntity:Boolean = false):ValueTarget
      {
         var value_target:ValueTarget = null;
         
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable || target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            var variable_instance:VariableInstance = null;
            
            var variable_index:int = variable_target_define.mVariableIndex;
            
            var variable_space_type:int = variable_target_define.mSpaceType;
            
            if (forPropertyOfEntity)
            {
               // ! important. In history, the value may be 0 for ValueSpaceTypeDefine.ValueSpace_EntityProperties
               if (variable_space_type != ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
                  variable_space_type = ValueSpaceTypeDefine.ValueSpace_EntityProperties;
            }
            
            switch (variable_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_World:
                  variable_instance = scene.GetWorld ().GetWorldVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GameSave:
                  variable_instance = scene.GetWorld ().GetGameSaveVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Session:
                  variable_instance = scene.GetCodeLibManager ().GetSessionVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
                  variable_instance = scene.GetWorld ().GetCommonSceneGlobalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  variable_instance = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Register:
                  if (classType == ClassTypeDefine.ClassType_Core)
                  {
                     var variable_space:VariableSpace = scene.GetWorld ().GetRegisterVariableSpace (valueType);
                     if (variable_space != null)
                     {
                        variable_instance = variable_space.GetVariableInstanceAt (variable_index);
                     }
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
               //>>> from v2.05
               case ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties:
                  variable_instance = scene.GetWorld ().GetCommonCustomEntityVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_EntityProperties:
                  variable_instance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               //<<<
               default:
                  break;
            }
            
            if (variable_instance != null)
            {
               value_target = new ValueTarget_Variable (variable_instance);
               if (target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
               {
                  (value_target as ValueTarget_Variable).SetPropertyIndex ((variable_target_define as ValueTargetDefine_ObjectProperty).mPropertyIndex);
               }
            }
            else if (forPropertyOfEntity)
            {
               // make sure it is not null Variable source for property of entity
               variable_instance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetNullVariableInstance ();
               value_target = new ValueTarget_Variable (variable_instance);
            }
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            var property_target_define:ValueTargetDefine_EntityProperty = valueTargetDefine as ValueTargetDefine_EntityProperty;
            
            //switch (property_target_define.mSpacePackageId)
            //{
            //   case ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties:
            //      value_target = new ValueTarget_EntityProperty (ValueSourceDefine2ValueSource (scene, property_target_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, functionDefinition)
            //                                       , new ValueTarget_Variable (scene.GetWorld ().GetCommonCustomEntityVariableSpace ().GetVariableInstanceAt (property_target_define.mPropertyId)));
            //      break;
            //   case ValueSpaceTypeDefine.ValueSpace_EntityProperties:
            //   case 0: // for compability
            //   default:
            //      value_target = new ValueTarget_EntityProperty (ValueSourceDefine2ValueSource (scene, property_target_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, functionDefinition)
            //                                       , new ValueTarget_Variable (scene.GetCodeLibManager ().GetEntityVariableSpace ().GetVariableInstanceAt (property_target_define.mPropertyId)));
            //      break;
            //}

            value_target = new ValueTarget_EntityProperty (ValueSourceDefine2ValueSource (scene, property_target_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, functionDefinition)
                                                         , ValueTargetDefine2ValueTarget (scene, property_target_define.mPropertyValueTargetDefine, classType, valueType, null, true) as ValueTarget_Variable
                                                       );
         }
         
         if (value_target == null)
         {
            value_target = new ValueTarget_Null ();
         }
         
         return value_target;
      }
      
      //public static function VariableSpaceDefine2VariableSpace (scene:Scene, spaceDefine:VariableSpaceDefine, variableSpace:VariableSpace):void // v1.52 only
      // since v1.53, return a variableIndex_CorrectionTable
      public static function VariableDefines2VariableSpace (scene:Scene, variableDefines:Array, classRefIndex_CorrectionTable:Array, variableSpace:VariableSpace, supportInitalValues:Boolean, avoidNameConflicting:Boolean, variablesHaveKey:Boolean = false, overrideValueOnExisting:Boolean = true):Array
      {
         //>> v1.52 only
         //var numVariables:int = spaceDefine.mVariableDefines.length;
         //
         //spaceDefine.mPackageId = 0;
         //spaceDefine.mSpaceType = variableSpace.GetSpaceType ();
         //spaceDefine.mParentPackageId = -1;
         //<<
         
         if (variablesHaveKey != variableSpace.IsVariableKeySupported ())
            throw new Error ();
         
         var numVariables:int = variableDefines.length;
         
         var variableIndex_CorrectionTable:Array = new Array (numVariables);
         
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {
            //var variableDefine:VariableDefine = spaceDefine.mVariableDefines [variableId] as VariableDefine; // v1.52 only
            var variableDefine:VariableDefine = variableDefines [variableId] as VariableDefine;

            var vi:VariableInstance = VariableDefine2VariableInstance (scene, variableDefine, classRefIndex_CorrectionTable, variableSpace, supportInitalValues, avoidNameConflicting, variablesHaveKey, overrideValueOnExisting);
            
            variableIndex_CorrectionTable [variableId] = (vi == null ? - 1 : vi.GetIndex ());
         }
         
         return variableIndex_CorrectionTable;
      }
      
      public static function VariableDefine2VariableInstance (scene:Scene, variableDefine:VariableDefine, classRefIndex_CorrectionTable:Array, variableSpace:VariableSpace, supportInitalValue:Boolean, avoidNameConflicting:Boolean, variablesHaveKey:Boolean = false, overrideValueOnExisting:Boolean = true):VariableInstance
      {
         //var directValueSourceDefine:ValueSourceDefine_Direct = variableDefine.mDirectValueSourceDefine;
         
         var valueObject:Object = supportInitalValue ? CoreClasses.ValidateDirectValueObject_Define2Object (scene, variableDefine.mClassType, variableDefine.mValueType, variableDefine.mValueObject) : null;
         
         var variableDefinition:VariableDefinition;
         if (variableDefine.mClassType == ClassTypeDefine.ClassType_Custom)
         {
            var realClassId:int = classRefIndex_CorrectionTable == null ? variableDefine.mValueType : classRefIndex_CorrectionTable [variableDefine.mValueType];
            variableDefinition = scene.GetCodeLibManager ().CreateCustomVariableDefinition (realClassId, variableDefine.mName);
         }
         else
         {
            variableDefinition = VariableDefinition.CreateCoreVariableDefinition (variableDefine.mValueType, variableDefine.mName);
         }
         
         if (variableDefinition != null)
         {
            var oldNum:int = variableSpace.GetNumVariableInstances ();
            var vi:VariableInstance = variableSpace.CreateVariableInstanceFromDefinition (variablesHaveKey ? variableDefine.mKey : null, variableDefinition, avoidNameConflicting);

            if (oldNum != variableSpace.GetNumVariableInstances () || overrideValueOnExisting)
            {
               vi.SetValueObject (valueObject);
            }
             
            return vi;
         }
         
         return null;
      }
      
      // for ConvertRegisterVariablesToGlobalVariables
      
      public static function RegisterVariable2GlobalVariable (scene:Scene, registerVariableInstance:VariableInstance):VariableInstance
      {
         // assert (registerVariableInstance != null);
         // assert (registerVariableInstance.GetSpaceType () == ValueSpaceTypeDefine.ValueSpace_Register);
         
         if (registerVariableInstance.GetIndex () < 0)
            return scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetNullVariableInstance ();
         
         if (registerVariableInstance.mCorrespondingGlobalVariable != null && registerVariableInstance.mCorrespondingGlobalVariable.GetIndex () < 0)
            registerVariableInstance.mCorrespondingGlobalVariable = null;
         
         if (registerVariableInstance.mCorrespondingGlobalVariable == null)
         {
            var variableDefine:VariableDefine = new VariableDefine ();
            variableDefine.mName = "Old " + registerVariableInstance.GetCodeStringAsRegisterVariable ();
            //variableDefine.mDirectValueSourceDefine = new ValueSourceDefine_Direct (
            //                           registerVariableInstance.GetValueType (), 
            //                           CoreClasses.ValidateDirectValueObject_Object2Define (
            //                                 scene, registerVariableInstance.GetValueType (), 
            //                                 CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (registerVariableInstance.GetValueType ())
            //                           )
            //                        );
            variableDefine.mValueType = registerVariableInstance.GetValueType ();
            variableDefine.mValueObject = CoreClasses.ValidateDirectValueObject_Object2Define (
                                             scene,
                                             ClassTypeDefine.ClassType_Core, // only core part of core types have register space.
                                             registerVariableInstance.GetValueType (), 
                                             CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (registerVariableInstance.GetValueType ())
                                          );
            
            var newGlobalVariableInstance:VariableInstance = VariableDefine2VariableInstance (
                                                                     scene, variableDefine, null,
                                                                     scene.GetCodeLibManager ().GetGlobalVariableSpace (), true, false);
            if (newGlobalVariableInstance == null)
               registerVariableInstance.mCorrespondingGlobalVariable = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetNullVariableInstance ();
            else
            {
               registerVariableInstance.mCorrespondingGlobalVariable = newGlobalVariableInstance;
            }
         }
         
         return registerVariableInstance.mCorrespondingGlobalVariable;
      }
             
//==============================================================================================
// define -> byte array
//==============================================================================================
      
      //public static function WriteFunctionDefineIntoBinFile (binFile:ByteArray, functionDefine:FunctionDefine, writeParams:Boolean, writeVariables:Boolean, customFunctionDefines:Array, writeLocalVariables:Boolean = true):void
      public static function WriteFunctionDefineIntoBinFile (binFile:ByteArray, functionDefine:FunctionDefine, writeParams:Boolean, writeLocalVariables:Boolean, customFunctionDefines:Array, supportCustomClasses:Boolean, customClassDefines:Array):void
      {
         //if (writeVariables)
         //{
            if (writeParams)
            {
               WriteVariableDefinesIntoBinFile (binFile, functionDefine.mInputVariableDefines, true, false, supportCustomClasses);
               
               WriteVariableDefinesIntoBinFile (binFile, functionDefine.mOutputVariableDefines, false, false, supportCustomClasses);
            }
            
            if (writeLocalVariables)
            {
               WriteVariableDefinesIntoBinFile (binFile, functionDefine.mLocalVariableDefines, false, false, supportCustomClasses);
            }
         //}
         
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
         var vd:VariableDefine;
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
            var func_declaration:FunctionDeclaration = World.GetPlayerCoreFunctionDeclarationById (func_id);
            
            for (i = 0; i < num_inputs; ++ i)
               WriteValueSourceDefinIntoBinFile (binFile, inputValueSourceDefines [i], ClassTypeDefine.ClassType_Core, func_declaration.GetInputParamValueType (i), func_declaration.GetInputNumberTypeDetail (i));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var variableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for (i = 0; i < num_inputs; ++ i)
            {
               //WriteValueSourceDefinIntoBinFile (binFile, inputValueSourceDefines [i], (variableDefines [i] as VariableDefine).mDirectValueSourceDefine.mValueType, CoreClassIds.NumberTypeDetail_Double);
               vd = variableDefines [i] as VariableDefine;
               WriteValueSourceDefinIntoBinFile (binFile, inputValueSourceDefines [i], vd.mClassType, vd.mValueType, CoreClassIds.NumberTypeDetail_Double);
            }
         }
         else // if (func_type == FunctionTypeDefine.FunctionType_PreDefined)
         {
            // impossible
         }
         
         for (i = 0; i < num_outputs; ++ i)
            WriteValueTargetDefinIntoBinFile (binFile, outputValueTargetDefines [i]);
      }
      
      public static function WriteValueSourceDefinIntoBinFile (binFile:ByteArray, valueSourceDefine:ValueSourceDefine, classType:int, valueType:int, numberDetail:int, forPropertyOfEntity:Boolean = false):void
      {
         // ValueSourceDefine_Direct.mValueType will not packed
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         //>>from v2.05
         // no needs
         //if (forPropertyOfEntity)
         //{
         //   if (source_type == 0) // or source_type != ValueSourceTypeDefine.ValueSource_ObjectProperty, only 2 possibilities
         //      source_type = ValueSourceTypeDefine.ValueSource_Variable; // in history, source_type forPropertyOfEntity is alwasy 0. 
         //}
         //<<
         
         binFile.writeByte (source_type);
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            var value_object:Object = direct_source_define.mValueObject;
            
            CoreClasses.WriteDirectValueObjectIntoBinFile (binFile, classType, valueType, numberDetail, direct_source_define.mValueObject);
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable || source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            binFile.writeByte (variable_source_define.mSpaceType);
            binFile.writeShort (variable_source_define.mVariableIndex);
            //>> from v2.05
            if (source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
            {
               binFile.writeShort ((valueSourceDefine as ValueSourceDefine_ObjectProperty).mPropertyIndex);
            }
            //<<
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            var property_source_define:ValueSourceDefine_EntityProperty = valueSourceDefine as ValueSourceDefine_EntityProperty;
            
            WriteValueSourceDefinIntoBinFile (binFile, property_source_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, CoreClassIds.NumberTypeDetail_Double); // CoreClassIds.NumberTypeDetail_Double is useless
            
            //>> before v2.05
            ////binFile.writeShort (property_source_define.mSpacePackageId); // before v2.03
            ////>> from v2.03
            //binFile.writeByte (0);
            //binFile.writeByte (property_source_define.mSpacePackageId);
            ////<<
            //binFile.writeShort (property_source_define.mPropertyId);
            //<<
            
            //>>since v2.05
            WriteValueSourceDefinIntoBinFile (binFile, property_source_define.mPropertyValueSourceDefine, classType, valueType, CoreClassIds.NumberTypeDetail_Double, true); // CoreClassIds.NumberTypeDetail_Double is useless
            //<<
         }
      }
      
      public static function WriteValueTargetDefinIntoBinFile (binFile:ByteArray, valueTargetDefine:ValueTargetDefine, forPropertyOfEntity:Boolean = false):void
      {
         var target_type:int = valueTargetDefine.GetValueTargetType ();
         
         //>>from v2.05
         // no needs
         //if (forPropertyOfEntity)
         //{
         //   if (target_type == 0) // or target_type != ValueTargetTypeDefine.ValueTarget_ObjectProperty, only 2 possibilities
         //      target_type = ValueTargetTypeDefine.ValueTarget_Variable; // in history, target_type forPropertyOfEntity is alwasy 0. 
         //}
         //<<
         
         binFile.writeByte (target_type);
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable || target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            var variable_target_define:ValueTargetDefine_Variable = valueTargetDefine as ValueTargetDefine_Variable;
            
            binFile.writeByte (variable_target_define.mSpaceType);
            binFile.writeShort (variable_target_define.mVariableIndex);
            //>> from v2.05
            if (target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
            {
               binFile.writeShort ((valueTargetDefine as ValueTargetDefine_ObjectProperty).mPropertyIndex);
            }
            //<<
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            var property_target_define:ValueTargetDefine_EntityProperty = valueTargetDefine as ValueTargetDefine_EntityProperty;
            
            WriteValueSourceDefinIntoBinFile (binFile, property_target_define.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, CoreClassIds.NumberTypeDetail_Double); // CoreClassIds.NumberTypeDetail_Double is useless
            
            ////binFile.writeShort (property_target_define.mSpacePackageId); // before v2.03
            ////>> from v2.03
            //binFile.writeByte (0);
            //binFile.writeByte (property_target_define.mSpacePackageId);
            ////<<
            //binFile.writeShort (property_target_define.mPropertyId);
            
            WriteValueTargetDefinIntoBinFile (binFile, property_target_define.mPropertyValueTargetDefine, true);
         }
      }
      
      //public static function WriteVariableSpaceDefineIntoBinFile (binFile:ByteArray, variableSpaceDefine:VariableSpaceDefine):void // v1.52 only
      public static function WriteVariableDefinesIntoBinFile (binFile:ByteArray, variableDefines:Array, supportInitalValues:Boolean, variablesHaveKey:Boolean, supportCustomClasses:Boolean):void
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
            //var variableDefine:VariableDefine = variableSpaceDefine.mVariableDefines [i]; // v1.52 only
            var variableDefine:VariableDefine = variableDefines [i];
            
            if (variablesHaveKey)
               binFile.writeUTF (variableDefine.mKey == null ? "" : variableDefine.mKey);
            binFile.writeUTF (variableDefine.mName);
            //binFile.writeShort (variableDefine.mDirectValueSourceDefine.mValueType);
            if (supportCustomClasses)
               binFile.writeByte (variableDefine.mClassType);
            binFile.writeShort (variableDefine.mValueType);
            
            if (supportInitalValues)
            {
               //CoreClasses.WriteDirectValueObjectIntoBinFile (binFile, variableDefine.mDirectValueSourceDefine.mValueType, CoreClassIds.NumberTypeDetail_Double, variableDefine.mDirectValueSourceDefine.mValueObject);
               CoreClasses.WriteDirectValueObjectIntoBinFile (binFile, variableDefine.mClassType, variableDefine.mValueType, CoreClassIds.NumberTypeDetail_Double, variableDefine.mValueObject);
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
      
      //public static function Xml2FunctionDefine (functionElement:XML, functionDefine:FunctionDefine, parseParams:Boolean, convertVariables:Boolean, customFunctionDefines:Array, convertLocalVariables:Boolean = true, codeSnippetElement:XML = null):void
      public static function Xml2FunctionDefine (functionElement:XML, functionDefine:FunctionDefine, convertParams:Boolean, convertLocalVariables:Boolean, customFunctionDefines:Array, codeSnippetElement:XML, supportCustomClasses:Boolean, customClassDefines:Array):void
      {
         //if (convertVariables)
         //{
            if (convertParams)
            {
               VariablesXml2Define (functionElement.InputParameters [0], functionDefine.mInputVariableDefines, true, false, supportCustomClasses);
               
               VariablesXml2Define (functionElement.OutputParameters [0], functionDefine.mOutputVariableDefines, false, false, supportCustomClasses);
            }
            
            if (convertLocalVariables)
            {
               VariablesXml2Define (functionElement.LocalVariables [0], functionDefine.mLocalVariableDefines, false, false, supportCustomClasses);
            }
         //}
         
         if (customFunctionDefines != null)
         {
            functionDefine.mCodeSnippetDefine = Xml2CodeSnippetDefine (codeSnippetElement == null ? functionElement.CodeSnippet [0] : codeSnippetElement, customFunctionDefines);
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
         
         var func_declaration:FunctionDeclaration = World.GetPlayerCoreFunctionDeclarationById (func_id);
         
         var i:int;
         var value_source_defines:Array = new Array ();
         var vd:VariableDefine;
         var elementValueSource:XML;
         i = 0;
         if (func_type == FunctionTypeDefine.FunctionType_Core)
         {
            for each (elementValueSource in funcCallingElement.InputValueSources.ValueSource)
               value_source_defines.push (Xml2ValueSourceDefine (elementValueSource, ClassTypeDefine.ClassType_Core, func_declaration.GetInputParamValueType (i ++)));
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledInputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mInputVariableDefines;
            
            for each (elementValueSource in funcCallingElement.InputValueSources.ValueSource)
            {
               //value_source_defines.push (Xml2ValueSourceDefine (elementValueSource, (calledInputVariableDefines [i ++] as VariableDefine).mDirectValueSourceDefine.mValueType));
               vd = calledInputVariableDefines [i ++] as VariableDefine;
               value_source_defines.push (Xml2ValueSourceDefine (elementValueSource, vd.mClassType, vd.mValueType));
            }
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
            {
               value_target_defines.push (Xml2ValueTargetDefine (elementValueTarget));//, func_declaration.GetOutputParamValueType (i)));
               ++ i;
            }
         }
         else if (func_type == FunctionTypeDefine.FunctionType_Custom)
         {
            var calledOutputVariableDefines:Array = (customFunctionDefines [func_id] as FunctionDefine).mOutputVariableDefines;
            
            for each (elementValueTarget in funcCallingElement.OutputValueTargets.ValueTarget)
            {
               //value_target_defines.push (Xml2ValueTargetDefine (elementValueTarget, (calledOutputVariableDefines [i ++] as VariableDefine).mDirectValueSourceDefine.mValueType));
               value_target_defines.push (Xml2ValueTargetDefine (elementValueTarget));//, (calledOutputVariableDefines [i] as VariableDefine).mValueType));
               ++ i;
            }
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
      
      public static function Xml2ValueSourceDefine (valueSourceElement:XML, classType:int, valueType:int, forPropertyOfEntity:Boolean = false):ValueSourceDefine
      {
         var value_source_define:ValueSourceDefine = null;
         
         var source_type:int = parseInt (valueSourceElement.@type);
         
         //>>from v2.05
         // no needs
         //if (forPropertyOfEntity)
         //{
         //   //if (source_type == 0)
         //   source_type = ValueSourceTypeDefine.ValueSource_ObjectProperty; // the only possible
         //}
         //<<
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            try
            {
               value_source_define = new ValueSourceDefine_Direct (/*valueType, */CoreClasses.ValidateDirectValueObject_Xml2Define (classType, valueType, valueSourceElement.@direct_value));
            }
            catch (err:Error)
            {
               trace (err.getStackTrace ());
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable || source_type == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
               value_source_define = new ValueSourceDefine_Variable (parseInt (valueSourceElement.@variable_space), parseInt (valueSourceElement.@variable_index));
            else
               value_source_define = new ValueSourceDefine_ObjectProperty (parseInt (valueSourceElement.@variable_space), parseInt (valueSourceElement.@variable_index), parseInt (valueSourceElement.@object_property_index));
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            //>> before v2.05
            //value_source_define = new ValueSourceDefine_EntityProperty (Xml2ValueSourceDefine (valueSourceElement.PropertyOwnerValueSource[0], ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity)
            //                                                      , parseInt (valueSourceElement.@property_package_id), parseInt (valueSourceElement.@property_id));
            //<<
            
            var propertyVariableValueSource:ValueSourceDefine_Variable;
            
            // for compability, non-object-property source still uses the old style
            if (valueSourceElement.PropertyVariableValueSource == null || valueSourceElement.PropertyVariableValueSource.length () == 0)
            {
               //>> before v2.05
               propertyVariableValueSource = new ValueSourceDefine_Variable (parseInt (valueSourceElement.@property_package_id), parseInt (valueSourceElement.@property_id));
               //<<
            }
            else // new style for object property since c2.05
            {
               propertyVariableValueSource = Xml2ValueSourceDefine (valueSourceElement.PropertyVariableValueSource [0], classType, valueType, true) as ValueSourceDefine_Variable;
            }
            
            value_source_define = new ValueSourceDefine_EntityProperty (Xml2ValueSourceDefine (valueSourceElement.PropertyOwnerValueSource[0], ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity)
                                                                      , propertyVariableValueSource
                                                                   );
         }
         
         if (value_source_define == null)
         {
            value_source_define = new ValueSourceDefine_Null ();
            
            trace ("Xml2ValueSourceDefine: Error: value source is null");
         }
         
         return value_source_define;
      }
      
      public static function Xml2ValueTargetDefine (valueTargetElement:XML, forPropertyOfEntity:Boolean = false):ValueTargetDefine
      {
         var value_target_define:ValueTargetDefine = null;
         
         var target_type:int = parseInt (valueTargetElement.@type);
         
         //>>from v2.05
         // no needs
         //if (forPropertyOfEntity)
         //{
         //   //if (target_type == 0)
         //   target_type = ValueTargetTypeDefine.ValueTarget_ObjectProperty; // the only possible
         //}
         //<<
         
         if (target_type == ValueTargetTypeDefine.ValueTarget_Variable || target_type == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            if (target_type == ValueTargetTypeDefine.ValueTarget_Variable)
               value_target_define = new ValueTargetDefine_Variable (parseInt (valueTargetElement.@variable_space), parseInt (valueTargetElement.@variable_index));
            else
               value_target_define = new ValueTargetDefine_ObjectProperty (parseInt (valueTargetElement.@variable_space), parseInt (valueTargetElement.@variable_index), parseInt (valueTargetElement.@object_property_index));
         }
         else if (target_type == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            //value_target_define = new ValueTargetDefine_EntityProperty (Xml2ValueSourceDefine (valueTargetElement.PropertyOwnerValueSource[0],
            //                                                          ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity),
            //                                                      parseInt (valueTargetElement.@property_package_id), parseInt (valueTargetElement.@property_id));

            var propertyVariableValueTarget:ValueTargetDefine_Variable;
            
            // for compability, non-object-property source still uses the old style
            if (valueTargetElement.PropertyVariableValueTarget == null || valueTargetElement.PropertyVariableValueTarget.length () == 0)
            {
               //>> before v2.05
               propertyVariableValueTarget = new ValueTargetDefine_Variable (parseInt (valueTargetElement.@property_package_id), parseInt (valueTargetElement.@property_id));
               //<<
            }
            else // new style for object property since c2.05
            {
               propertyVariableValueTarget = Xml2ValueTargetDefine (valueTargetElement.PropertyVariableValueTarget [0], true) as ValueTargetDefine_Variable;
            }

            value_target_define = new ValueTargetDefine_EntityProperty (Xml2ValueSourceDefine (valueTargetElement.PropertyOwnerValueSource[0], ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity)
                                                                      , propertyVariableValueTarget
                                                                    );
         }
         
         if (value_target_define == null)
         {
            value_target_define = new ValueTargetDefine_Null ();
         }
         
         return value_target_define;
      }
      
      //public static function VariableSpaceXml2Define (elementVariablePackage:XML):VariableSpaceDefine // v1.52 only
      public static function VariablesXml2Define (elementVariablePackage:XML, outputVariableDefines:Array, supportInitalValues:Boolean, variablesHaveKey:Boolean, supportCustomClasses:Boolean):void
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
            var variableDefine:VariableDefine = new VariableDefine ();
            
            var classType:int = supportCustomClasses ? parseInt (element.@class_type) : ClassTypeDefine.ClassType_Core;
            var valueType:int = parseInt (element.@value_type);
            
            if (variablesHaveKey)
               variableDefine.mKey = element.@key;
            variableDefine.mName = element.@name;
            //variableDefine.mDirectValueSourceDefine = new ValueSourceDefine_Direct (valueType, supportInitalValues ? CoreClasses.ValidateDirectValueObject_Xml2Define (valueType, element.@initial_value) : CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (valueType));
            variableDefine.mClassType = classType;
            variableDefine.mValueType = valueType;
            variableDefine.mValueObject = supportInitalValues ? CoreClasses.ValidateDirectValueObject_Xml2Define (classType, valueType, element.@initial_value) : CoreClassDeclarations.GetCoreClassDefaultDirectDefineValue (valueType);

            //variableSpaceDefine.mVariableDefines.push (variableDefine); v1.52 only
            outputVariableDefines.push (variableDefine);
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
      
      public static function ShiftReferenceIndexesInCodeSnippetDefine (scene:Scene, codeSnippetDefine:CodeSnippetDefine, isCustomCodeSnippet:Boolean, correctionTables:Object):void // entityIdShiftedValue:int, ccatRefIndex_CorrectionTable:Array, worldVariableShiftIndex:int, saveDataVariableShiftIndex:int, globalVariableShiftIndex:int, commonGlobalVariableShiftIndex:int, entityVariableShiftIndex:int, commonEntityVariableShiftIndex:int, functionRefIndex_CorrectionTable:Array, sessionVariableShiftIndex:int, imageModuleRefIndex_CorrectionTable:Array, soundRefIndex_CorrectionTable:Array, sceneRefIndex_CorrectionTable:Array):void
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
               funcDclaration = World.GetPlayerCoreFunctionDeclarationById (functionId);
            }
            else // if (func_type == FunctionTypeDefine.FunctionType_Custom)
            {
               //functionId += beginningCustomFunctionIndex;
               functionId = correctionTables.mFunctionRefIndex_CorrectionTable [functionId];
               funcCallingDefine.mFunctionId = functionId;
               funcDclaration = scene.GetCodeLibManager ().GetFunctionByIndex (functionId).GetFunctionDeclaration ();
            }
            
            //>>>>>, commented off from v2.03. Why do this, for pure functions?
            //if (isCustomCodeSnippet)
            //{
            //}
            //else // only apply for main scene code snippets
            //<<<<<
            {
               //if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
               //{
                  var numInputs:int = funcCallingDefine.mNumInputs;
                  for (j = 0; j < numInputs; ++ j)
                  {
                     ShiftReferenceIndexesInValueSourceDefine (funcCallingDefine.mInputValueSourceDefines [j] as ValueSourceDefine, funcDclaration.GetInputParamClassType (j), funcDclaration.GetInputParamValueType (j), correctionTables); // entityIdShiftedValue, ccatRefIndex_CorrectionTable, worldVariableShiftIndex, saveDataVariableShiftIndex, globalVariableShiftIndex, commonGlobalVariableShiftIndex, entityVariableShiftIndex, commonEntityVariableShiftIndex, sessionVariableShiftIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  }
                  
                  var numOutputs:int = funcCallingDefine.mNumOutputs;
                  for (j = 0; j < numOutputs; ++ j)
                  {
                     ShiftReferenceIndexesInValueTargetDefine (funcCallingDefine.mOutputValueTargetDefines [j] as ValueTargetDefine, funcDclaration.GetOutputParamClassType (j), funcDclaration.GetOutputParamValueType (j), correctionTables); // entityIdShiftedValue, ccatRefIndex_CorrectionTable, worldVariableShiftIndex, saveDataVariableShiftIndex, globalVariableShiftIndex, commonGlobalVariableShiftIndex, entityVariableShiftIndex, commonEntityVariableShiftIndex, sessionVariableShiftIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  }
               //}
               //else
               //{
               //}
            }
         }
      }
      
      public static function ShiftReferenceIndexesInValueSourceDefine (sourceDefine:ValueSourceDefine, classType:int, valueType:int, correctionTables:Object):void // entityIdShiftedValue:int, ccatRefIndex_CorrectionTable:Array, worldVariableShiftIndex:int, saveDataVariableShiftIndex:int, globalVariableShiftIndex:int, commonGlobalVariableShiftIndex:int, entityVariableShiftIndex:int, commonEntityVariableShiftIndex:int, sessionVariableShiftIndex:int, imageModuleRefIndex_CorrectionTable:Array, soundRefIndex_CorrectionTable:Array, sceneRefIndex_CorrectionTable:Array):void
      {
         var valueSourceType:int = sourceDefine.GetValueSourceType ();
         
         if (valueSourceType == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var directSourceDefine:ValueSourceDefine_Direct = sourceDefine as ValueSourceDefine_Direct;
            
            if (classType == ClassTypeDefine.ClassType_Core)
            {
               if (valueType == CoreClassIds.ValueType_Entity)
               {
                  var entityIndex:int = int (directSourceDefine.mValueObject);
                  
                  if (entityIndex >= 0 && entityIndex < correctionTables.mEntityIndex_CorrectionTable.length)
                     directSourceDefine.mValueObject = correctionTables.mEntityIndex_CorrectionTable [entityIndex]; // + entityIdShiftedValue;
                  else
                     directSourceDefine.mValueObject = Define.EntityId_None;
               }
               else if (valueType == CoreClassIds.ValueType_CollisionCategory)
               {
                  var ccatIndex:int = int (directSourceDefine.mValueObject);
                  
                  if (ccatIndex >= 0 && ccatIndex < correctionTables.mCcatRefIndex_CorrectionTable)
                     directSourceDefine.mValueObject = correctionTables.mCcatRefIndex_CorrectionTable [ccatIndex];
                  else
                     ccatIndex = Define.CCatId_Hidden;
               }
               else if (valueType == CoreClassIds.ValueType_Module)
               {
                  var moduleIndex:int = int (directSourceDefine.mValueObject);
                  
                  if (ccatIndex >= 0 && ccatIndex < correctionTables.mImageModuleRefIndex_CorrectionTable.length)
                     directSourceDefine.mValueObject = correctionTables.mImageModuleRefIndex_CorrectionTable [moduleIndex];
                  else
                     directSourceDefine.mValueObject = -1;
               }
               else if (valueType == CoreClassIds.ValueType_Sound)
               {
                  var soundIndex:int = int (directSourceDefine.mValueObject);
                  
                  if (soundIndex >= 0 && soundIndex < correctionTables.mSoundRefIndex_CorrectionTable.length)
                     directSourceDefine.mValueObject = correctionTables.mSoundRefIndex_CorrectionTable [soundIndex];
                  else
                     directSourceDefine.mValueObject = -1;
               }
               else if (valueType == CoreClassIds.ValueType_Scene)
               {
                  var sceneIndex:int = int (directSourceDefine.mValueObject);
                  
                  if (sceneIndex >= 0 && sceneIndex < correctionTables.mSceneRefIndex_CorrectionTable.length)
                     directSourceDefine.mValueObject = correctionTables.mSceneRefIndex_CorrectionTable [sceneIndex];
                  else
                     directSourceDefine.mValueObject = -1;
               }
            }
         }
         else if (valueSourceType == ValueSourceTypeDefine.ValueSource_Variable || valueSourceType == ValueSourceTypeDefine.ValueSource_ObjectProperty)
         {
            var variableSourceDefine:ValueSourceDefine_Variable = sourceDefine as ValueSourceDefine_Variable;
            
            var variableIndex:int = variableSourceDefine.mVariableIndex;
            if (variableIndex >= 0)
            {
               switch (variableSourceDefine.mSpaceType)
               {
                  case ValueSpaceTypeDefine.ValueSpace_World:
                     variableSourceDefine.mVariableIndex = correctionTables.mWorldVariableIndex_CorrectionTable [variableIndex]; // + worldVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_GameSave:
                     variableSourceDefine.mVariableIndex = correctionTables.mGameSaveVariableIndex_CorrectionTable [variableIndex]; // + saveDataVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Session:
                     variableSourceDefine.mVariableIndex = correctionTables.mSessionVariableIndex_CorrectionTable [variableIndex]; // + sessionVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Global:
                     variableSourceDefine.mVariableIndex = correctionTables.mGlobalVariableIndex_CorrectionTable [variableIndex]; // + globalVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
                     variableSourceDefine.mVariableIndex = correctionTables.mCommonGlobalVariableIndex_CorrectionTable [variableIndex]; // + commonGlobalVariableShiftIndex;
                     break;
               }
            }
         }
         else if (valueSourceType == ValueSourceTypeDefine.ValueSource_EntityProperty)
         {
            var propertySourceDefine:ValueSourceDefine_EntityProperty = sourceDefine as ValueSourceDefine_EntityProperty;
            
            var propertyId:int = propertySourceDefine.mPropertyValueSourceDefine.mVariableIndex;
            if (propertyId >= 0)
            {
               if (propertySourceDefine.mPropertyValueSourceDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
               {
                  propertySourceDefine.mPropertyValueSourceDefine.mVariableIndex = correctionTables.mCommonEntityVariableIndex_CorrectionTable [propertyId]; // + commonEntityVariableShiftIndex;
               }
               else // if (propertySourceDefine.mPropertyValueSourceDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_EntityProperties) or 0
               {
                  propertySourceDefine.mPropertyValueSourceDefine.mVariableIndex = correctionTables.mEntityVariableIndex_CorrectionTable [propertyId]; // + entityVariableShiftIndex;
               }
            }
            
            ShiftReferenceIndexesInValueSourceDefine (propertySourceDefine.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, correctionTables); // entityIdShiftedValue, ccatRefIndex_CorrectionTable, worldVariableShiftIndex, saveDataVariableShiftIndex, globalVariableShiftIndex, commonGlobalVariableShiftIndex, entityVariableShiftIndex, commonEntityVariableShiftIndex, sessionVariableShiftIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
         }
      }
      
      public static function ShiftReferenceIndexesInValueTargetDefine (targetDefine:ValueTargetDefine, classType:int, valueType:int, correctionTables:Object):void // entityIdShiftedValue:int, ccatRefIndex_CorrectionTable:Array, worldVariableShiftIndex:int, saveDataVariableShiftIndex:int, globalVariableShiftIndex:int, commonGlobalVariableShiftIndex:int, entityVariableShiftIndex:int, commonEntityVariableShiftIndex:int, sessionVariableShiftIndex:int, imageModuleRefIndex_CorrectionTable:Array, soundRefIndex_CorrectionTable:Array, sceneRefIndex_CorrectionTable:Array):void
      {
         var valueTargetType:int = targetDefine.GetValueTargetType ();
         
         if (valueTargetType == ValueTargetTypeDefine.ValueTarget_Variable || valueTargetType == ValueTargetTypeDefine.ValueTarget_ObjectProperty)
         {
            var variableTargetDefine:ValueTargetDefine_Variable = targetDefine as ValueTargetDefine_Variable;
            
            var variableIndex:int = variableTargetDefine.mVariableIndex;
            if (variableIndex >= 0)
            {
               switch (variableTargetDefine.mSpaceType)
               {
                  case ValueSpaceTypeDefine.ValueSpace_World:
                     variableTargetDefine.mVariableIndex = correctionTables.mWorldVariableIndex_CorrectionTable [variableIndex]; // + worldVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_GameSave:
                     variableTargetDefine.mVariableIndex = correctionTables.mGameSaveVariableIndex_CorrectionTable [variableIndex]; // + saveDataVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Session:
                     variableTargetDefine.mVariableIndex = correctionTables.mSessionVariableIndex_CorrectionTable [variableIndex]; // + sessionVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_Global:
                     variableTargetDefine.mVariableIndex = correctionTables.mGlobalVariableIndex_CorrectionTable [variableIndex]; // + globalVariableShiftIndex;
                     break;
                  case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
                     variableTargetDefine.mVariableIndex = correctionTables.mCommonGlobalVariableIndex_CorrectionTable [variableIndex]; // + commonGlobalVariableShiftIndex;
                     break;
               }
            }
         }
         else if (valueTargetType == ValueTargetTypeDefine.ValueTarget_EntityProperty)
         {
            var propertyTargetDefine:ValueTargetDefine_EntityProperty = targetDefine as ValueTargetDefine_EntityProperty;
            
            var propertyId:int = propertyTargetDefine.mPropertyValueTargetDefine.mVariableIndex;
            if (propertyId >= 0)
            {
               if (propertyTargetDefine.mPropertyValueTargetDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
               {
                  propertyTargetDefine.mPropertyValueTargetDefine.mVariableIndex = correctionTables.mCommonEntityVariableIndex_CorrectionTable [propertyId]; // + commonEntityVariableShiftIndex;
               }
               else // if (propertyTargetDefine.mPropertyValueTargetDefine.mSpaceType == ValueSpaceTypeDefine.ValueSpace_EntityProperties) or 0
               {
                  propertyTargetDefine.mPropertyValueTargetDefine.mVariableIndex = correctionTables.mEntityVariableIndex_CorrectionTable [propertyId]; // + entityVariableShiftIndex;
               }
            }
            
            ShiftReferenceIndexesInValueSourceDefine (propertyTargetDefine.mEntityValueSourceDefine, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Entity, correctionTables); // entityIdShiftedValue, ccatRefIndex_CorrectionTable, worldVariableShiftIndex, saveDataVariableShiftIndex, globalVariableShiftIndex, commonGlobalVariableShiftIndex, entityVariableShiftIndex, commonEntityVariableShiftIndex, sessionVariableShiftIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
         }
      }
   }
}
