
package common {
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.trigger.entity.ConditionAndTargetValue;
   
   import editor.trigger.ConditionListDefinition;
   import editor.trigger.CommandListDefinition;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionCalling;
   import editor.trigger.VariableDefinition;
   import editor.trigger.ValueSource;
   import editor.trigger.ValueSourceDirect;
   import editor.trigger.ValueSourceVariable;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.trigger.define.ConditionListDefine;
   import common.trigger.define.CommandListDefine;
   import common.trigger.define.FunctionCallingDefine;
   import common.trigger.define.ValueSourceDefine;
   import common.trigger.define.ValueSourceDirectDefine_Boolean;
   import common.trigger.define.ValueSourceDirectDefine_CollisionCategory;
   import common.trigger.define.ValueSourceDirectDefine_Entity;
   import common.trigger.define.ValueSourceDirectDefine_Number;
   import common.trigger.define.ValueSourceDirectDefine_String;
   import common.trigger.define.ValueSourceVariableDefine;
   
   public class TriggerFormatHelper
   {
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
         var num:int = conditionListDefinition.GetNumConditions ();;
         var func_calling_defines:Array = new Array (num);
         var condition_inverteds:Array = new Array (num);
         
         for (var i:int = 0; i < num; ++ i)
         {
            func_calling_defines [i] = FunctionCalling2FunctionCallingDefine (editorWorld, conditionListDefinition.GetConditionAt (i));
            condition_inverteds [i] = conditionListDefinition.IsConditionInverted (i);
         }
         
         var condition_list_define:ConditionListDefine = new ConditionListDefine ();
         
         condition_list_define.mNumConditions = num;
         condition_list_define.mFunctionCallingDefines = func_calling_defines;
         condition_list_define.mConditionInverteds = condition_inverteds;
         
         condition_list_define.mIsAnd = conditionListDefinition.IsAnd ();
         condition_list_define.mIsNot = conditionListDefinition.IsNot ();
         
         return condition_list_define;
      }
      
      public static function CommandListDefinition2Define (editorWorld:World, commandListDefinition:CommandListDefinition):CommandListDefine
      {
         var num:int = commandListDefinition.GetNumCommnads ();;
         var func_calling_defines:Array = new Array (num);
         
         for (var i:int = 0; i < num; ++ i)
            func_calling_defines [i] = FunctionCalling2FunctionCallingDefine (editorWorld, commandListDefinition.GetCommandAt (i));
         
         var command_list_define:CommandListDefine = new CommandListDefine ();
         
         command_list_define.mNumCommands = num;
         command_list_define.mFunctionCallingDefines = func_calling_defines;
         
         return command_list_define;
      }
      
      public static function FunctionCalling2FunctionCallingDefine (editorWorld:World, funcCalling:FunctionCalling):FunctionCallingDefine
      {
         var func_declaration:FunctionDeclaration = funcCalling.GetFunctionDeclaration ();
         var num_params:int = func_declaration.GetNumParameters ();
         
         var value_source_defines:Array = new Array (num_params);
         for (var j:int = 0; j < num_params; ++ j)
            value_source_defines [j] = ValueSource2ValueSourceDefine (editorWorld, funcCalling.GetParamValueSource (j), func_declaration.GetParamDefinitionAt (j).GetValueType ());
         
         var func_calling_define:FunctionCallingDefine = new FunctionCallingDefine ();
         func_calling_define.mFunctionDeclarationId = func_declaration.GetID ();
         func_calling_define.mParamValueSourceDefines = value_source_defines;
         
         return func_calling_define;
      }
      
      public static function ValueSource2ValueSourceDefine (editorWorld:World, valueSource:ValueSource, valueType:int):ValueSourceDefine
      {
         var value_source_define:ValueSourceDefine = null;
         
         var value_source_type:int = valueSource.GetValueSourceType ();
         
         if (value_source_type == ValueSourceTypeDefine.ValueSource_Direct)
         {
            var direct_source:ValueSourceDirect = valueSource as ValueSourceDirect;
            
            switch (valueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
               {
                  value_source_define = new ValueSourceDirectDefine_Boolean ();
                  
                  (value_source_define as ValueSourceDirectDefine_Boolean).mBoolValue = direct_source.GetValueObject () as Boolean;
                  
                  break;
               }
               case ValueTypeDefine.ValueType_Number:
               {
                  value_source_define = new ValueSourceDirectDefine_Number ();
                  
                  (value_source_define as ValueSourceDirectDefine_Number).mNumberValue = direct_source.GetValueObject () as Number;
                  
                  break;
               }
               case ValueTypeDefine.ValueType_String:
               {
                  value_source_define = new ValueSourceDirectDefine_String ();
                  
                  (value_source_define as ValueSourceDirectDefine_String).mStringValue = direct_source.GetValueObject () as String;
                  
                  break;
               }
               case ValueTypeDefine.ValueType_Entity:
               {
                  value_source_define = new ValueSourceDirectDefine_Entity ();
                  
                  (value_source_define as ValueSourceDirectDefine_Entity).mEntityIndex = editorWorld.GetEntityIndex (direct_source.GetValueObject () as Entity);
                  
                  break;
               }
               case ValueTypeDefine.ValueType_CollisionCategory:
               {
                  value_source_define = new ValueSourceDirectDefine_CollisionCategory ();
                  
                  (value_source_define as ValueSourceDirectDefine_CollisionCategory).mCollisionCategoryId = direct_source.GetValueObject () as int;
                  
                  break;
               }
               default:
                  break;
            }
         }
         else if (value_source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source:ValueSourceVariable = valueSource as ValueSourceVariable;
            
            value_source_define = new ValueSourceVariableDefine ();
            
            (value_source_define as ValueSourceVariableDefine).mValueSpaceType = variable_source.GetVariableSpaceType ();
            (value_source_define as ValueSourceVariableDefine).mVariableIndex =  variable_source.GetVariableIndex ();
         }
         
         if (value_source_define != null)
            value_source_define.mValueSourceType = value_source_type;
         else
            trace ("err, vst=" + value_source_type);
         
         return value_source_define;
      }
      
   }
}
