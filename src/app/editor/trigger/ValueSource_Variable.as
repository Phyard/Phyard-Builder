package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.entity.Scene;
   
   import common.trigger.ClassTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Variable implements ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstance:VariableInstance; // should not be null
      
      private var mPropertyVariableInstance:VariableInstance;
            // null for general variables
            // non-null for object properties, in this case, mVariableInstance is the property owner
      
      public function ValueSource_Variable (variableInstacne:VariableInstance, propertyVariableInstance:VariableInstance = null)
      {
         SetVariableInstance (variableInstacne);
         
         SetPropertyVariableInstance (propertyVariableInstance);
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
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
      
      public function SetVariableInstance (variableInstacne:VariableInstance):void
      {
         mVariableInstance = variableInstacne;
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
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return mPropertyVariableInstance != null ? ValueSourceTypeDefine.ValueSource_ObjectProperty : ValueSourceTypeDefine.ValueSource_Variable;
      }
      
      public function GetValueObject ():Object
      {
         return mVariableInstance.GetValueObject ();
      }
      
      //public function CloneSource ():ValueSource
      //{
      //   // not a safe clone. Only used in FunctionCallingLineData
      //   return new ValueSource_Variable (mVariableInstance);
      //}
      
      public function CloneSource (scene:Scene, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource
      {
         var defaultValueSource:ValueSource = callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);

         var vi:VariableInstance = GetVariableInstanceFrom (mVariableInstance, scene, targetFunctionDefinition, callingFunctionDeclaration, paramIndex);
         if (vi == null)
            return defaultValueSource;
         
         if (mPropertyVariableInstance == null)
            return new ValueSource_Variable (vi);

         // assert vi.GetClassType () == Custom
         if (vi.GetClassType () != ClassTypeDefine.ClassType_Custom)
            return defaultValueSource;

         var customClass:ClassCustom = scene.GetCodeLibManager ().GetCustomClass (vi.GetValueType ());
         if (customClass == null)
            return defaultValueSource;
         
         var propertySpace:VariableSpaceClassInstance = customClass.GetPropertyDefinitionSpace ();
         
         var propertyVariableInstance:VariableInstance;
         if (mPropertyVariableInstance.GetIndex () < 0)
            propertyVariableInstance = propertySpace.GetNullVariableInstance ();
         else
         {
            propertyVariableInstance = propertySpace.GetVariableInstanceByTypeAndName (scene, mPropertyVariableInstance.GetClassType (), mPropertyVariableInstance.GetValueType (), mPropertyVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
            propertyVariableInstance.SetValueObject (mPropertyVariableInstance.GetValueObject ());
         }
         
         return new ValueSource_Variable (vi, propertyVariableInstance);
      }
      
      private static function GetVariableInstanceFrom (fromVariableInstance:VariableInstance, scene:Scene, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):VariableInstance
      {
         //var variableDefinition:VariableDefinition;
         var variableInstance:VariableInstance;
         
         var spaceType:int = fromVariableInstance.GetSpaceType ();
         switch (spaceType)
         {
            case ValueSpaceTypeDefine.ValueSpace_Input:
               //variableDefinition = targetFunctionDefinition.GetInputParamDefinitionAt (fromVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != fromVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               //else
               //   return new ValueSource_Variable (targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (fromVariableInstance.GetIndex ()));
               
               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ());
               }
               
               break;
            case ValueSpaceTypeDefine.ValueSpace_Output:
               //variableDefinition = targetFunctionDefinition.GetOutputParamDefinitionAt (fromVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != fromVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               //else
               //   return new ValueSource_Variable (targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (fromVariableInstance.GetIndex ()));
               
               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ());
               }
               
               break;
            case ValueSpaceTypeDefine.ValueSpace_Local:
               //variableDefinition = targetFunctionDefinition.GetLocalVariableDefinitionAt (fromVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != fromVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               //else
               //   return new ValueSource_Variable (targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (fromVariableInstance.GetIndex ()));
               
               if (fromVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceByTypeAndName (scene, fromVariableInstance.GetClassType (), fromVariableInstance.GetValueType (), fromVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (fromVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               break;
            case ValueSpaceTypeDefine.ValueSpace_Session:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
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
            case ValueSpaceTypeDefine.ValueSpace_Global:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
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
            case ValueSpaceTypeDefine.ValueSpace_EntityProperties:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
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
            case ValueSpaceTypeDefine.ValueSpace_Register:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
                  return null;
               }

               variableInstance = scene.GetWorld ().GetRegisterVariableSpace (fromVariableInstance.GetValueType ()).GetVariableInstanceAt (fromVariableInstance.GetIndex ());
               
               break;
            case ValueSpaceTypeDefine.ValueSpace_CommonGlobal:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
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
            case ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
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
            case ValueSpaceTypeDefine.ValueSpace_World:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
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
            case ValueSpaceTypeDefine.ValueSpace_GameSave:
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
               {
                  //return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
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
            default: // never run here
            {
               variableInstance = null;
               
               break;
            }
         }
         
         return variableInstance;
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
      
   }
}

