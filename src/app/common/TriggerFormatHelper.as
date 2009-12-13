
package common {
   
   import flash.utils.ByteArray;
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.EntityCollisionCategory;
   
   import editor.trigger.entity.ConditionAndTargetValue;
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.FunctionCalling;
   import editor.trigger.VariableDefinition;
   import editor.trigger.ValueSource;
   import editor.trigger.ValueSource_Null;
   import editor.trigger.ValueSource_Direct;
   import editor.trigger.ValueSource_Variable;
   import editor.trigger.ValueTarget;
   import editor.trigger.ValueTarget_Null;
   import editor.trigger.ValueTarget_Variable;
   import editor.trigger.VariableSpace;
   import editor.trigger.VariableInstance;
   
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
   //import common.trigger.define.ValueSourceDefine_Property_Global;
   //import common.trigger.define.ValueSourceDefine_Property_World;
   //import common.trigger.define.ValueSourceDefine_Property_Entity;
   //import common.trigger.define.ValueSourceDefine_Property_OwnerVariable;
   import common.trigger.define.ValueTargetDefine;
   import common.trigger.define.ValueTargetDefine_Null;
   import common.trigger.define.ValueTargetDefine_Variable;
   
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
            value_source_defines [i] = ValueSource2ValueSourceDefine (editorWorld, funcCalling.GetInputValueSource (i), func_declaration.GetInputValueType (i));
         
         var value_target_defines:Array = new Array (num_outputs);
         for (i = 0; i < num_outputs; ++ i)
            value_target_defines [i] = ValueTarget2ValueTargetDefine (editorWorld, funcCalling.GetReturnValueTarget (i), func_declaration.GetInputValueType (i));
         
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
            
            var valid:Boolean = true;
            var value_object:Object = null;
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_object = direct_source.GetValueObject () as Boolean;
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_object = direct_source.GetValueObject () as Number;
                  break;
               case ValueTypeDefine.ValueType_String:
                  value_object = direct_source.GetValueObject () as String;
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  value_object = editorWorld.GetEntityCreationId (direct_source.GetValueObject () as Entity);
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_object = editorWorld.GetCollisionCategoryIndex (direct_source.GetValueObject () as EntityCollisionCategory);
                  break;
               default:
                  valid = false;
                  break;
            }
            
            if (valid)
               value_source_define = new ValueSourceDefine_Direct (valueType, value_object);
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source:ValueSource_Variable = valueSource as ValueSource_Variable;
            
            value_source_define = new ValueSourceDefine_Variable (variable_source.GetVariableSpaceType (), variable_source.GetVariableIndex ());
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
         
         if (value_target_define == null)
         {
            value_target_define = new ValueTargetDefine_Null ();
         }
         
         return value_target_define;
      }
      
//==============================================================================================
// define -> definition (editor)
//==============================================================================================
      
      public static function LoadCodeSnippetFromCodeSnippetDefine (editorWorld:World, codeSnippet:CodeSnippet, codeSnippetDefine:CodeSnippetDefine):void
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
         var func_id:int = funcCallingDefine.mFunctionId;
         var func_type:int = funcCallingDefine.mFunctionType;
         var func_declaration:FunctionDeclaration = TriggerEngine.GetPlayerFunctionDeclarationById (func_id);
         
         var i:int;
         var num_inputs:int = funcCallingDefine.mNumInputs;
         var num_outputs:int = funcCallingDefine.mNumOutputs;
         var inputValueSourceDefines:Array = funcCallingDefine.mInputValueSourceDefines;
         var outputValueTargetDefines:Array = funcCallingDefine.mOutputValueTargetDefines;
         
         var value_sources:Array = new Array (funcCallingDefine.mNumInputs);
         for (i = 0; i < num_inputs; ++ i)
            value_sources [i] = ValueSourceDefine2ValueSource (editorWorld, inputValueSourceDefines [i], func_declaration.GetInputValueType (i), functionDefinition);
         
         var value_targets:Array = new Array (funcCallingDefine.mNumOutputs);
         for (i = 0; i < num_outputs; ++ i)
            value_targets [i] = ValueTargetDefine2ValueTarget (editorWorld, outputValueTargetDefines [i], func_declaration.GetOutputValueType (i), functionDefinition);
         
         var func_calling:FunctionCalling = new FunctionCalling (func_declaration);
         func_calling.SetInputValueSources (value_sources);
         func_calling.SetReturnValueTargets (value_targets);
         
         return func_calling;
      }
      
      public static function ValueSourceDefine2ValueSource (editorWorld:World, valueSourceDefine:ValueSourceDefine, valueType:int, functionDefinition:FunctionDefinition):ValueSource
      {
         var value_source:ValueSource = null;
         
         var source_type:int = valueSourceDefine.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source_define:ValueSourceDefine_Direct = valueSourceDefine as ValueSourceDefine_Direct;
            
            var valid:Boolean = true;
            var value_object:Object = null;
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_object = direct_source_define.mValueObject as Boolean;
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_object = direct_source_define.mValueObject as Number;
                  break;
               case ValueTypeDefine.ValueType_String:
                  // "as String in commented off, otherwise value_object will be always null, bug?!
                  // re: add back  "as String", in xml -> define: String (valueSourceElement.@direct_value)
                  value_object = direct_source_define.mValueObject as String
                  if (value_object == null)
                     value_object = "";
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  value_object = editorWorld.GetEntityByCreationId (direct_source_define.mValueObject as int);
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_object = editorWorld.GetCollisionCategoryByIndex (direct_source_define.mValueObject as int);
                  break;
               default:
                  valid = false;
                  break;
            }
            
            if (valid)
               value_source = new ValueSource_Direct (value_object);
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var variable_instance:VariableInstance = null;
            
            var variable_index:int = variable_source_define.mVariableIndex;
            
            switch (variable_source_define.mSpaceType)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = TriggerEngine.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableInstanceAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = functionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Return:
                  variable_instance = functionDefinition.GetReturnVariableSpace ().GetVariableInstanceAt (variable_index);
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
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  var variable_space:VariableSpace = TriggerEngine.GetRegisterVariableSpace (valueType);
                  if (variable_space != null)
                  {
                     variable_instance = variable_space.GetVariableInstanceAt (variable_index);
                  }
                  
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  variable_instance = functionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (variable_index);
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Return:
                  variable_instance = functionDefinition.GetReturnVariableSpace ().GetVariableInstanceAt (variable_index);
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
         }
         
         return value_target;
      }
      
//==============================================================================================
// define -> byte array
//==============================================================================================
      
      public static function CodeSnippetDefine2ByteArray (codeSnippetDefine:CodeSnippetDefine):ByteArray
      {
         return null;
      }
      
      public static function FunctionCallingDefine2ByteArray (funcCallingDefine:FunctionCallingDefine):ByteArray
      {
         // param number will be packed for easey back-compiliabel later
         return null;
      }
      
      public static function ValueSourceDefine2ByteArray (valueSourceDefine:ValueSourceDefine):ByteArray
      {
         // ValueSourceDefine_Direct.mValueType will not packed
         return null;
      }
      
      public static function ValueTargetDefine2ByteArray (valueTargetDefine:ValueTargetDefine):ByteArray
      {
         // ValueSourceDefine_Direct.mValueType will not packed
         return null;
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
      
      public static function Xml2CodeSnippetDefine (codeSnippetElement:XMLList):CodeSnippetDefine
      {
         var func_calling_defines:Array = new Array ();
         
         var elementFunctionCalling:XML;
         for each (elementFunctionCalling in codeSnippetElement.FunctionCalling)
         {
            func_calling_defines.push (Xml2FunctionCallingDefine (elementFunctionCalling));
         }
         
         var code_snippet_define:CodeSnippetDefine = new CodeSnippetDefine ();
         
         code_snippet_define.mName = codeSnippetElement.@name;
         code_snippet_define.mNumCallings = func_calling_defines.length;
         code_snippet_define.mFunctionCallingDefines = func_calling_defines;
         
         return code_snippet_define;
      }
      
      public static function Xml2FunctionCallingDefine (funcCallingElement:XML):FunctionCallingDefine
      {
         var function_type:int = parseInt (funcCallingElement.@function_type);
         var function_id  :int = parseInt (funcCallingElement.@function_id);
 
         var func_declaration:FunctionDeclaration = TriggerEngine.GetPlayerFunctionDeclarationById (function_id);
         
         var i:int;
         var value_source_defines:Array = new Array ();
         var elementValueSource:XML;
         i = 0;
         for each (elementValueSource in funcCallingElement.InputValueSources.ValueSource)
         {
            value_source_defines.push (Xml2ValueSourceDefine (elementValueSource, func_declaration.GetInputValueType (i ++)));
         }
         
         var value_target_defines:Array = new Array ();
         var elementValueTarget:XML;
         i = 0;
         for each (elementValueTarget in funcCallingElement.OutputValueTargets.ValueTarget)
         {
            value_target_defines.push (Xml2ValueTargetDefine (elementValueTarget, func_declaration.GetOutputValueType (i ++)));
         }
         
         var func_calling_define:FunctionCallingDefine = new FunctionCallingDefine ();
         
         func_calling_define.mFunctionType = function_type;
         func_calling_define.mFunctionId = function_id;
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
            var valid:Boolean = true;;
            var value_object:Object = null;
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  value_object = parseInt (valueSourceElement.@direct_value) != 0;
                  break;
               case ValueTypeDefine.ValueType_Number:
                  value_object = parseFloat (valueSourceElement.@direct_value);
                  break;
               case ValueTypeDefine.ValueType_String:
                  value_object = String (valueSourceElement.@direct_value); // valueSourceElement.@direct_value is not a string, ??? 
                  if (value_object == null)
                     value_object = "";
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  value_object = parseInt (valueSourceElement.@direct_value);
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_object = parseInt (valueSourceElement.@direct_value);
                  break;
               default:
                  valid = false;
                  break;
            }
            
            if (valid)
               value_source_define = new ValueSourceDefine_Direct (valueType, value_object);
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            value_source_define = new ValueSourceDefine_Variable (parseInt (valueSourceElement.@variable_space), parseInt (valueSourceElement.@variable_index));
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
         
         if (value_target_define == null)
         {
            value_target_define = new ValueTargetDefine_Null ();
         }
         
         return value_target_define;
      }
      
//========================================================================================
// 
//========================================================================================
      
      public static function FunctionCallingDefines_PhysicsValues2DisplayValues (functionCallingDefines:Array):void
      {
         
      }
      
   }
}
