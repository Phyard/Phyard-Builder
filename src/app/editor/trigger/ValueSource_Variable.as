package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.entity.Scene;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Variable implements ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstance:VariableInstance; // should not be null
      
      public function ValueSource_Variable (variableInstacne:VariableInstance)
      {
         SetVariableInstance (variableInstacne);
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
      {
         return mVariableInstance.SourceToCodeString (vd);
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
      
      public function GetVariableIndex ():int
      {
         return mVariableInstance.GetIndex ();
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Variable;
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
         //var variableDefinition:VariableDefinition;
         var variableInstance:VariableInstance;
         
         var spaceType:int = mVariableInstance.GetSpaceType ();
         switch (spaceType)
         {
            case ValueSpaceTypeDefine.ValueSpace_Input:
            {
               //variableDefinition = targetFunctionDefinition.GetInputParamDefinitionAt (mVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               //else
               //   return new ValueSource_Variable (targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               
               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ());
               }
               
               return new ValueSource_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Output:
            {
               //variableDefinition = targetFunctionDefinition.GetOutputParamDefinitionAt (mVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               //else
               //   return new ValueSource_Variable (targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               
               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), targetFunctionDefinition.IsCustom ());
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ());
               }
               
               return new ValueSource_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Local:
            {
               //variableDefinition = targetFunctionDefinition.GetLocalVariableDefinitionAt (mVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (triggerEngine);
               //else
               //   return new ValueSource_Variable (targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               
               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               return new ValueSource_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Session:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);

               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetCodeLibManager ().GetSessionVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetCodeLibManager ().GetSessionVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               return new ValueSource_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Global:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);

               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               return new ValueSource_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Entity:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);

               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), true);
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ()); // ? meaningful?
               }
               
               return new ValueSource_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_GlobalRegister:
            {
               if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
                  return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);

               variableInstance = scene.GetWorld ().GetRegisterVariableSpace (mVariableInstance.GetValueType ()).GetVariableInstanceAt (mVariableInstance.GetIndex ());
               
               return new ValueSource_Variable (variableInstance);
            }
            default: // never run here
            {
               return callingFunctionDeclaration.GetInputParamDefinitionAt (paramIndex).GetDefaultValueSource (/*triggerEngine*/);
            }
         }
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
   }
}

