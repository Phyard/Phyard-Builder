package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.entity.Scene;
   
   import common.trigger.ClassTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueTarget_Variable implements ValueTarget
   {
      private var mVariableInstance:VariableInstance;
      
      private var mPropertyVariableInstance:VariableInstance;
            // null for general variables
            // non-null for object properties, in this case, mVariableInstance is the property owner
      
      public function ValueTarget_Variable (vi:VariableInstance, propertyVariableInstance:VariableInstance = null)
      {
         SetVariableInstance (vi);
         
         SetPropertyVariableInstance (propertyVariableInstance);
      }
      
      public function TargetToCodeString (vd:VariableDefinition):String
      {
         var codeStr:String = mVariableInstance.SourceToCodeString (vd);
         if (mPropertyVariableInstance != null)
         {
            codeStr = codeStr + mPropertyVariableInstance.SourceToCodeString (null);
         }
         
         return codeStr;
      }
      
      public function GetVariableIndex ():int
      {
         return mVariableInstance.GetIndex ();
      }
      
      public function GetVariableInstance ():VariableInstance
      {
         return mVariableInstance;
      }
      
      public function SetVariableInstance (vi:VariableInstance):void
      {
         mVariableInstance = vi;
      }
      
      public function GetVariableSpaceType ():int
      {
         return mVariableInstance.GetSpaceType ();
      }
      
      //---------- 
      
      public function GetPropertyIndex ():int
      {
         return mPropertyVariableInstance == null ? -1: mPropertyVariableInstance.GetIndex ();
      }
      
      public function GetPropertyVariableInstance ():VariableInstance
      {
         return mPropertyVariableInstance;
      }
      
      public function SetPropertyVariableInstance (ownerVariableInstance:VariableInstance):void
      {
         mPropertyVariableInstance = ownerVariableInstance;
      }
      
//======================================================
// override
//======================================================
      
      public function GetValueTargetType ():int
      {
         return mPropertyVariableInstance != null ? ValueTargetTypeDefine.ValueTarget_ObjectProperty : ValueTargetTypeDefine.ValueTarget_Variable;
      }
      
      //public function AssignValue (source:ValueSource):void
      //{
      //   mVariableInstance.SetValueObject (source.GetValueObject ());
      //}
      
      //public function CloneTarget ():ValueTarget
      //{
      //   return new ValueTarget_Variable (mVariableInstance);
      //}
      
      public function CloneTarget (scene:Scene, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueTarget
      {
         var defaultValueTarget:ValueTarget = callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueTarget(/*triggerEngine*/);

         var vi:VariableInstance = GetVariableInstanceFrom (mVariableInstance, scene, targetFunctionDefinition, callingFunctionDeclaration, paramIndex);
         if (vi == null)
            return defaultValueTarget;
         
         if (mPropertyVariableInstance == null)
            return new ValueTarget_Variable (vi);

         // assert vi.GetClassType () == Custom
         if (vi.GetClassType () != ClassTypeDefine.ClassType_Custom)
            return defaultValueTarget;

         var customClass:ClassCustom = scene.GetCodeLibManager ().GetCustomClass (vi.GetValueType ());
         if (customClass == null)
            return defaultValueTarget;
         
         var propertySpace:VariableSpaceClassInstance = customClass.GetPropertyDefinitionSpace ();
         
         var propertyVariableInstance:VariableInstance;
         if (mPropertyVariableInstance.GetIndex () < 0)
            propertyVariableInstance = propertySpace.GetNullVariableInstance ();
         else
         {
            propertyVariableInstance = propertySpace.GetVariableInstanceByTypeAndName (scene, mPropertyVariableInstance.GetClassType (), mPropertyVariableInstance.GetValueType (), mPropertyVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
            propertyVariableInstance.SetValueObject (mPropertyVariableInstance.GetValueObject ());
         }
         
         return new ValueTarget_Variable (vi, propertyVariableInstance);
      }
      
      private static function GetVariableInstanceFrom (fromVariableInstance:VariableInstance, scene:Scene, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):VariableInstance
      {
         //var variableDefinition:VariableDefinition;
         var variableInstance:VariableInstance;
         
         switch (fromVariableInstance.GetSpaceType ())
         {
            case ValueSpaceTypeDefine.ValueSpace_Input:
            {
               //variableDefinition = targetFunctionDefinition.GetInputParamDefinitionAt (fromVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != fromVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               //else
               //   return new ValueTarget_Variable (targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (fromVariableInstance.GetIndex ()));
               
               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ());
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_Output:
            {
               //variableDefinition = targetFunctionDefinition.GetOutputParamDefinitionAt (fromVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != fromVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               //else
               //   return new ValueTarget_Variable (targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (fromVariableInstance.GetIndex ()));
               
               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ());
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_Local:
            {
               //variableDefinition = targetFunctionDefinition.GetLocalVariableDefinitionAt (fromVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != fromVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               //else
               //   return new ValueTarget_Variable (targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (fromVariableInstance.GetIndex ()));
               
               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ());
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_Session:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetCodeLibManager ().GetSessionVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetCodeLibManager ().GetSessionVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_Global:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_EntityProperties:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_Register:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               variableInstance = scene.GetWorld ().GetRegisterVariableSpace (fromVariableInstance.GetValueType ()).GetVariableInstanceAt (fromVariableInstance.GetIndex ());
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetWorld ().GetCommonSceneGlobalVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetWorld ().GetCommonSceneGlobalVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetWorld ().GetCommonCustomEntityVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetWorld ().GetCommonCustomEntityVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_World:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetWorld ().GetWorldVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetWorld ().GetWorldVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            }
            case ValueSpaceTypeDefine.ValueSpace_GameSave:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
                  return null;
               }

               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetWorld ().GetGameSaveVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetWorld ().GetGameSaveVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            }
            default: // never run here
            {
               //return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               variableInstance = null;
               
               break;
            }
         }
         
         return variableInstance;
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

