
package common {
   
   import flash.utils.ByteArray;
   
   import player.global.Global;
   import player.world.World;
   import player.entity.Entity;
   import player.trigger.IPropertyOwner;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition;
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.FunctionDefinition_Logic;
   import player.trigger.FunctionInstance;
   import player.trigger.CommandListDefinition;
   import player.trigger.ConditionListDefinition;
   import player.trigger.FunctionCalling;
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Null;
   import player.trigger.ValueSource_Direct;
   import player.trigger.ValueSource_Variable;
   import player.trigger.ValueTarget;
   import player.trigger.ValueTarget_Null;
   import player.trigger.ValueTarget_Variable;
   
   import common.trigger.FunctionDeclaration;
   
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
   
   public class TriggerFormatHelper2
   {
      
//==============================================================================================
// define -> definition (player)
//==============================================================================================
      
      public static function ConditionListDefine2Definition (parentFunctionInstance:FunctionInstance, playerWorld:World, conditionListDefine:ConditionListDefine):ConditionListDefinition
      {
         var calling_list_head:FunctionCalling = null;
         var calling:FunctionCalling = null;
         
         for (var i:int = conditionListDefine.mNumConditions - 1; i >= 0; -- i)
         {
            calling = FunctionCallingDefine2FunctionCalling (parentFunctionInstance, playerWorld, conditionListDefine.mFunctionCallingDefines [i]);
            calling.mIsConditionCalling = conditionListDefine.mIsConditionCallings [i];
            calling.mTargetBoolValue = ! conditionListDefine.mConditionResultInverted [i];
            
            calling.mNextFunctionCalling = calling_list_head;
            calling_list_head = calling;
         }
         
         var condition_list:ConditionListDefinition = new ConditionListDefinition (calling_list_head, conditionListDefine.mIsAnd, conditionListDefine.mIsNot);
         
         return condition_list;
      }
      
      public static function CommandListDefine2Definition (parentFunctionInstance:FunctionInstance, playerWorld:World, commandListDefine:CommandListDefine):CommandListDefinition
      {
         var calling_list_head:FunctionCalling = null;
         var calling:FunctionCalling = null;
         
         for (var i:int = commandListDefine.mNumCommands - 1; i >= 0; -- i)
         {
            calling = FunctionCallingDefine2FunctionCalling (parentFunctionInstance, playerWorld, commandListDefine.mFunctionCallingDefines [i]);
            
            calling.mNextFunctionCalling = calling_list_head;
            calling_list_head = calling;
         }
         
         var common_list:CommandListDefinition = new CommandListDefinition (calling_list_head);
         
         return common_list;
      }
      
      public static function FunctionCallingDefine2FunctionCalling (parentFunctionInstance:FunctionInstance, playerWorld:World, funcCallingDefine:FunctionCallingDefine):FunctionCalling
      {
         if (funcCallingDefine.mFunctionType == FunctionTypeDefine.FunctionType_Core)
         {
            var core_func_definition:FunctionDefinition_Core = TriggerEngine.GetCoreFunctionDefinition (funcCallingDefine.mFunctionId);
            var core_func_declaration:FunctionDeclaration = core_func_definition.GetFunctionDeclaration ();
            
            var value_source_list:ValueSource = null;
            var value_source:ValueSource;
            var i:int;
            for (i = funcCallingDefine.mNumInputs - 1; i >= 0; -- i)
            {
               value_source = ValueSourceDefine2InputValueSource (parentFunctionInstance, playerWorld, funcCallingDefine.mInputValueSourceDefines [i], core_func_declaration.GetInputValueType (i));
               value_source.mNextValueSourceInList = value_source_list;
               value_source_list = value_source;
            }
            
            var value_target_list:ValueTarget = null;
            var value_target:ValueTarget;
            for (i = funcCallingDefine.mNumReturns - 1; i >= 0; -- i)
            {
               value_target = ValueTargetDefine2ReturnValueTarget (parentFunctionInstance, playerWorld, funcCallingDefine.mReturnValueTargetDefines [i], core_func_declaration.GetReturnValueType (i));
               value_target.mNextValueTargetInList = value_target_list;
               value_target_list = value_target;
            }
            
            var calling:FunctionCalling = new FunctionCalling (core_func_definition, value_source_list, value_target_list);
            
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
            
            var value_type:int  = direct_source_define.mValueType;
            
            switch (value_type)
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
                  value_source = new ValueSource_Direct (playerWorld.GetEntityByIndexInEditor (direct_source_define.mValueObject as int));
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  value_source = new ValueSource_Direct (direct_source_define.mValueObject as int);
                  break;
               default:
                  break;
            }
         }
         else if (source_type == ValueSourceTypeDefine.ValueSource_Variable)
         {
            var variable_source_define:ValueSourceDefine_Variable = valueSourceDefine as ValueSourceDefine_Variable;
            
            var value_space_type:int     = variable_source_define.mSpaceType;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  value_source = new ValueSource_Variable (Global.GetRegisterVariableSpace (valueType).GetVariableAt (variable_source_define.mVariableIndex));
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  value_source = new ValueSource_Variable (parentFunctionInstance.GetInputVariableAt (variable_source_define.mVariableIndex));
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Return:
                  value_source = new ValueSource_Variable (parentFunctionInstance.GetReturnVariableAt (variable_source_define.mVariableIndex));
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  break;
               default:
                  break;
            }
         }
         
         if (value_source == null)
         {
            value_source = new ValueSource_Null ();
            
            trace ("Error: source is null");
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
            
            var value_space_type:int     = variable_target_define.mSpaceType;
            
            switch (value_space_type)
            {
               case ValueSpaceTypeDefine.ValueSpace_Global:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
                  value_target = new ValueTarget_Variable (Global.GetRegisterVariableSpace (valueType).GetVariableAt (variable_target_define.mVariableIndex));
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Input:
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Return:
                  value_target = new ValueTarget_Variable (parentFunctionInstance.GetReturnVariableAt (variable_target_define.mVariableIndex));
                  break;
               case ValueSpaceTypeDefine.ValueSpace_Local:
                  break;
               default:
                  break;
            }
         }
         
         if (value_target == null)
         {
            value_target = new ValueTarget_Null ();
            
            trace ("Error: target is null");
         }
         
         return value_target;
      }
      
//==============================================================================================
// byte array -> define
//==============================================================================================
      
      public static function ByteArray2ConditionListDefine (byteArray:ByteArray):ConditionListDefine
      {
         return null;
      }
      
      public static function ByteArray2CommandListDefine (byteArray:ByteArray):CommandListDefine
      {
         return null;
      }
      
      public static function ByteArray2FunctionCallingDefine (byteArray:ByteArray):FunctionCallingDefine
      {
         return null;
      }
      
      public static function ByteArray2ValueSourceDefine (byteArray:ByteArray):ValueSourceDefine
      {
         return null;
      }
      
//==============================================================================================
// define -> xml
//==============================================================================================
      
      public static function ConditionListDefine2Xml (conditionListDefine:ConditionListDefine):XML
      {
         return null;
      }
      
      public static function CommandListDefine2Xml (commandListDefine:CommandListDefine):XML
      {
         return null;
      }
      
      public static function FunctionCallingDefine2Xml (funcCallingDefine:FunctionCallingDefine):XML
      {
         return null;
      }
      
      public static function ValueSourceDefine2Xml (valueSourceDefine:ValueSourceDefine):XML
      {
         return null;
      }
      
   }
}
