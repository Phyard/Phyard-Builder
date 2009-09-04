
package common {
   
   import flash.utils.ByteArray;
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.EntityCollisionCategory;
   
   import editor.trigger.entity.ConditionAndTargetValue;
   
   import editor.trigger.ConditionListDefinition;
   import editor.trigger.CommandListDefinition;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionCalling;
   import editor.trigger.VariableDefinition;
   import editor.trigger.ValueSource;
   import editor.trigger.ValueSource_Null;
   import editor.trigger.ValueSource_Direct;
   import editor.trigger.ValueSource_Variable;
   //import editor.trigger.ValueSource_Property;
   //import editor.trigger.ValueSource_Property_Global;
   //import editor.trigger.ValueSource_Property_World;
   //import editor.trigger.ValueSource_Property_Entity;
   //import editor.trigger.ValueSource_Property_OwnerVariable;
   import editor.trigger.ValueTarget;
   import editor.trigger.ValueTarget_Null;
   import editor.trigger.ValueTarget_Variable;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.trigger.define.ConditionListDefine;
   import common.trigger.define.CommandListDefine;
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
            entityDefine.mInputConditionEntityIndexes = null;
            entityDefine.mInputConditionTargetValues = null;
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
               
               indexes [i] = editorWorld.GetEntityIndex (conditionAndValue.mConditionEntity);
               values [i] = conditionAndValue.mTargetValue;
            }
            
            entityDefine.mNumInputConditions = num;
            entityDefine.mInputConditionEntityIndexes = indexes;
            entityDefine.mInputConditionTargetValues = values;
         }
      }
      
      public static function ConditionListDefinition2Define (editorWorld:World, conditionListDefinition:ConditionListDefinition):ConditionListDefine
      {
         var num:int = conditionListDefinition.GetNumFunctionCallings ();;
         var func_calling_defines:Array = new Array (num);
         var is_conditions:Array = new Array (num);
         var result_inverteds:Array = new Array (num);
         
         for (var i:int = 0; i < num; ++ i)
         {
            func_calling_defines [i] = FunctionCalling2FunctionCallingDefine (editorWorld, conditionListDefinition.GetFunctionCallingAt (i));
            is_conditions [i] = conditionListDefinition.IsConditionCalling (i);
            result_inverteds [i] = conditionListDefinition.IsConditionResultInverted (i);
         }
         
         var condition_list_define:ConditionListDefine = new ConditionListDefine ();
         
         condition_list_define.mNumConditions = num;
         condition_list_define.mFunctionCallingDefines = func_calling_defines;
         condition_list_define.mIsConditionCallings = is_conditions;
         condition_list_define.mConditionResultInverted = result_inverteds;
         
         condition_list_define.mIsAnd = conditionListDefinition.IsAnd ();
         condition_list_define.mIsNot = conditionListDefinition.IsNot ();
         
         return condition_list_define;
      }
      
      public static function CommandListDefinition2Define (editorWorld:World, commandListDefinition:CommandListDefinition):CommandListDefine
      {
         var num:int = commandListDefinition.GetNumFunctionCallings ();;
         var func_calling_defines:Array = new Array (num);
         
         for (var i:int = 0; i < num; ++ i)
            func_calling_defines [i] = FunctionCalling2FunctionCallingDefine (editorWorld, commandListDefinition.GetFunctionCallingAt (i));
         
         var command_list_define:CommandListDefine = new CommandListDefine ();
         
         command_list_define.mNumCommands = num;
         command_list_define.mFunctionCallingDefines = func_calling_defines;
         
         return command_list_define;
      }
      
      public static function FunctionCalling2FunctionCallingDefine (editorWorld:World, funcCalling:FunctionCalling):FunctionCallingDefine
      {
         var func_declaration:FunctionDeclaration = funcCalling.GetFunctionDeclaration ();
         var num_inputs:int = func_declaration.GetNumInputs ();
         var num_returns:int = func_declaration.GetNumReturns ();
         var j:int;
         
         var value_source_defines:Array = new Array (num_inputs);
         for (j = 0; j < num_inputs; ++ j)
            value_source_defines [j] = ValueSource2ValueSourceDefine (editorWorld, funcCalling.GetInputValueSource (j), func_declaration.GetInputValueType (j));
         
         var value_target_defines:Array = new Array (num_returns);
         for (j = 0; j < num_returns; ++ j)
            value_target_defines [j] = ValueTarget2ValueTargetDefine (editorWorld, funcCalling.GetReturnValueTarget (j));
         
         var func_calling_define:FunctionCallingDefine = new FunctionCallingDefine ();
         func_calling_define.mFunctionType = func_declaration.GetType ();
         func_calling_define.mFunctionId = func_declaration.GetID ();
         func_calling_define.mNumInputs = num_inputs;
         func_calling_define.mInputValueSourceDefines = value_source_defines;
         func_calling_define.mNumReturns = num_returns;
         func_calling_define.mReturnValueTargetDefines = value_target_defines;
         
         return func_calling_define;
      }
      
      public static function ValueSource2ValueSourceDefine (editorWorld:World, valueSource:ValueSource, valueType:int):ValueSourceDefine
      {
         var value_source_define:ValueSourceDefine = null;
         
         var source_type:int = valueSource.GetValueSourceType ();
         
         if (source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source:ValueSource_Direct = valueSource as ValueSource_Direct;
            
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
                  value_object = editorWorld.GetEntityIndex (direct_source.GetValueObject () as Entity);
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_object = editorWorld.GetCollisionCategoryIndex (direct_source.GetValueObject () as EntityCollisionCategory);
                  break;
               default:
                  break;
            }
            
            if (value_object != null)
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
            
            trace ("Error: value source is null");
         }
         
         return value_source_define;
      }
      
      public static function ValueTarget2ValueTargetDefine (editorWorld:World, valueTarget:ValueTarget):ValueTargetDefine
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
      
      public static function ConditionListDefine2Definition (conditionListDefine:ConditionListDefine):ConditionListDefinition
      {
         return null;
      }
      
      public static function CommandListDefine2Definition (commandListDefine:CommandListDefine):CommandListDefinition
      {
         return null;
      }
      
      public static function FunctionCallingDefine2FunctionCalling (funcCallingDefine:FunctionCallingDefine):FunctionCalling
      {
         return null;
      }
      
      public static function ValueSourceDefine2ValueSource (valueSourceDefine:ValueSourceDefine):ValueSource
      {
         return null;
      }
      
//==============================================================================================
// define -> byte array
//==============================================================================================
      
      public static function ConditionListDefine2ByteArray (conditionListDefine:ConditionListDefine):ByteArray
      {
         return null;
      }
      
      public static function CommandListDefine2ByteArray (commandListDefine:CommandListDefine):ByteArray
      {
         return null;
      }
      
      public static function FunctionCallingDefine2ByteArray (funcCallingDefine:FunctionCallingDefine):ByteArray
      {
         return null;
      }
      
      public static function ValueSourceDefine2ByteArray (valueSourceDefine:ValueSourceDefine):ByteArray
      {
         return null;
      }
      
//==============================================================================================
// xml -> define
//==============================================================================================
      
      public static function ConditionListElement2Xml (conditionListElement:XML):ConditionListDefine
      {
         return null;
      }
      
      public static function CommandListElement2Xml (commandListElement:XML):CommandListDefine
      {
         return null;
      }
      
      public static function FunctionCallingElement2Xml (funcCallingElement:XML):FunctionCallingDefine
      {
         return null;
      }
      
      public static function ValueSourceElement2Xml (valueSourceElement:XML):ValueSourceDefine
      {
         return null;
      }
      
   }
}
