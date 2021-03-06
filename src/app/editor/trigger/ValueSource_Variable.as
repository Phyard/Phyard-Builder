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
      
      private var mPropertyVariableInstance:VariableInstance = null;
            // null for general variables
            // non-null for object properties, in this case, mVariableInstance is the property owner
      
      public function ValueSource_Variable (variableInstacne:VariableInstance)
      {
         SetVariableInstance (variableInstacne);
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
         ValidateProeprty ();
         
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
      
      private function GetPropertyVariableInstanceAt (propertyIndex:int):VariableInstance
      {
         if (propertyIndex < 0)
            return null;
         
         var viDef:VariableDefinition_Custom = mVariableInstance.GetVariableDefinition () as VariableDefinition_Custom;
         if (viDef == null)
            return null;
         
         var customClass:ClassDefinition_Custom = viDef.GetCustomClass ();
         //assert customClass != null
         if (customClass.GetID () < 0)
            return null;
         
         var propertySpace:VariableSpaceClassInstance = customClass.GetPropertyDefinitionSpace ();
         //assert propertySpace != null
         
         var vi:VariableInstance = propertySpace.GetVariableInstanceAt (propertyIndex);
         if (vi.GetIndex () < 0)
            return null;
         
         return vi;
      }
      
      private function ValidateProeprty ():void
      {
         if (mPropertyVariableInstance != null)
         {
            mPropertyVariableInstance = GetPropertyVariableInstanceAt (mPropertyVariableInstance.GetIndex ());
            if (mPropertyVariableInstance == null)
            {
               mVariableInstance = mVariableInstance.GetVariableSpace ().GetNullVariableInstance ();
            }
         }
      }
      
      public function GetPropertyIndex ():int
      {
         ValidateProeprty ();
         
         return mPropertyVariableInstance == null ? -1: mPropertyVariableInstance.GetIndex ();
      }
      
      // call this function if really try to set a valid property.
      // To clear the property, call ClearProperty 
      public function SetPropertyIndex (proeprtyIndex:int):void
      {
         mPropertyVariableInstance = GetPropertyVariableInstanceAt (proeprtyIndex);
         if (mPropertyVariableInstance == null)
         {
            mVariableInstance = mVariableInstance.GetVariableSpace ().GetNullVariableInstance ();
         }
      }
      
      public function ClearProperty ():void
      {
         mPropertyVariableInstance = null;
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return GetPropertyIndex () >= 0 ? ValueSourceTypeDefine.ValueSource_ObjectProperty : ValueSourceTypeDefine.ValueSource_Variable;
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
         
         var clonedSource:ValueSource_Variable = new ValueSource_Variable (vi);
         
         if (mPropertyVariableInstance != null)
            clonedSource.SetPropertyIndex (mPropertyVariableInstance.GetIndex ());
         
         return clonedSource;
         
         //// assert vi.GetClassType () == Custom
         //if (vi.GetClassType () != ClassTypeDefine.ClassType_Custom)
         //   return defaultValueSource;
         //
         //var customClass:ClassDefinition_Custom = scene.GetCodeLibManager ().GetCustomClass (vi.GetValueType ());
         //if (customClass == null)
         //   return defaultValueSource;
         //
         //var propertySpace:VariableSpaceClassInstance = customClass.GetPropertyDefinitionSpace ();
         //
         //var propertyVariableInstance:VariableInstance;
         //if (mPropertyVariableInstance.GetIndex () < 0)
         //   propertyVariableInstance = propertySpace.GetNullVariableInstance ();
         //else
         //{
         //   propertyVariableInstance = propertySpace.GetVariableInstanceByTypeAndName (scene, mPropertyVariableInstance.GetClassType (), mPropertyVariableInstance.GetValueType (), mPropertyVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
         //   propertyVariableInstance.SetValueObject (mPropertyVariableInstance.GetValueObject ());
         //}
         //
         //return new ValueSource_Variable (vi, propertyVariableInstance);
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

