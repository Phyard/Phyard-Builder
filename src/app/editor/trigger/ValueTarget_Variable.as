package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueTarget_Variable implements ValueTarget
   {
      private var mVariableInstance:VariableInstance;
      
      public function ValueTarget_Variable (vi:VariableInstance)
      {
         SetVariableInstance (vi);
      }
      
      public function TargetToCodeString (vd:VariableDefinition):String
      {
         return mVariableInstance.TargetToCodeString (vd);
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
      
      public function GetVariableIndex ():int
      {
         return mVariableInstance.GetIndex ();
      }
      
//======================================================
// override
//======================================================
      
      public function GetValueTargetType ():int
      {
         return ValueTargetTypeDefine.ValueTarget_Variable;
      }
      
      public function AssignValue (source:ValueSource):void
      {
         mVariableInstance.SetValueObject (source.GetValueObject ());
      }
      
      //public function CloneTarget ():ValueTarget
      //{
      //   return new ValueTarget_Variable (mVariableInstance);
      //}
      
      public function CloneTarget (triggerEngine:TriggerEngine, targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueTarget
      {
         //var variableDefinition:VariableDefinition;
         var variableInstance:VariableInstance;
         
         switch (mVariableInstance.GetSpaceType ())
         {
            case ValueSpaceTypeDefine.ValueSpace_Input:
            {
               //variableDefinition = targetFunctionDefinition.GetInputParamDefinitionAt (mVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               //else
               //   return new ValueTarget_Variable (targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               
               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), targetFunctionDefinition.IsPure ());
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ());
               }
               
               return new ValueTarget_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Output:
            {
               //variableDefinition = targetFunctionDefinition.GetOutputParamDefinitionAt (mVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               //else
               //   return new ValueTarget_Variable (targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               
               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), targetFunctionDefinition.IsPure ());
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ());
               }
               
               return new ValueTarget_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Local:
            {
               //variableDefinition = targetFunctionDefinition.GetLocalVariableDefinitionAt (mVariableInstance.GetIndex ());
               //
               //if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               //   return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               //else
               //   return new ValueTarget_Variable (targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               
               if (mVariableInstance.GetIndex () < 0)
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetNullVariableInstance ();
               else
               {
                  variableInstance = targetFunctionDefinition.GetLocalVariableSpace ().GetVariableInstanceByTypeAndName (mVariableInstance.GetValueType (), mVariableInstance.GetName (), true); // targetFunctionDefinition.IsPure ());
                  variableInstance.SetValueObject (mVariableInstance.GetValueObject ());
               }
               
               return new ValueTarget_Variable (variableInstance);
            }
            case ValueSpaceTypeDefine.ValueSpace_Entity:
               // assert (targetFunctionDefinition.IsPure () == false);
               // no problems to use the default handling.
            default:
            {
               if (targetFunctionDefinition.IsPure ())
                  return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               else
                  return new ValueTarget_Variable (mVariableInstance);
            }
         }
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

