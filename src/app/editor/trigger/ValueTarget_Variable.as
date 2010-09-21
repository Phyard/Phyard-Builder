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
      
      public function CloneTarget ():ValueTarget
      {
         return new ValueTarget_Variable (mVariableInstance);
      }
      
      public function CloneVariableTarget (triggerEngine:TriggerEngine, ownerFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueTarget
      {
         var variableDefinition:VariableDefinition;;
         
         switch (mVariableInstance.GetSpaceType ())
         {
            case ValueSpaceTypeDefine.ValueSpace_Input:
               variableDefinition = ownerFunctionDefinition.GetInputParamDefinitionAt (mVariableInstance.GetIndex ());
               
               if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               {
                  return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               }
               else
               {
                  return new ValueTarget_Variable (ownerFunctionDefinition.GetInputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               }
            case ValueSpaceTypeDefine.ValueSpace_Output:
               variableDefinition = ownerFunctionDefinition.GetOutputParamDefinitionAt (mVariableInstance.GetIndex ());
               
               if (variableDefinition == null || variableDefinition.GetValueType () != mVariableInstance.GetValueType ())
               {
                  return callingFunctionDeclaration.GetOutputParamDefinitionAt (paramIndex).GetDefaultNullValueTarget ();
               }
               else
               {
                  return new ValueTarget_Variable (ownerFunctionDefinition.GetOutputVariableSpace ().GetVariableInstanceAt (mVariableInstance.GetIndex ()));
               }
            default:
               return new ValueTarget_Variable (mVariableInstance);
         }
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

