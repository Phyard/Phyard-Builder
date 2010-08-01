package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueTarget_Property implements ValueTarget
   {
      private var mEntityValueSource:ValueSource;
      private var mPropertyValueTarget:ValueTarget_Variable;
      
      public function ValueTarget_Property  (entityValueSource:ValueSource, propertyValueTarget:ValueTarget_Variable)
      {
         SetEntityValueSource (entityValueSource);
         SetPropertyValueTarget(propertyValueTarget);
      }
      
      public function TargetToCodeString (vd:VariableDefinition):String
      {
         return mEntityValueSource.SourceToCodeString (null) + mPropertyValueTarget.TargetToCodeString (vd);
      }
      
      public function SetEntityValueSource (entityValueSource:ValueSource):void
      {
         mEntityValueSource = entityValueSource;
      }
      
      public function GetEntityValueSource ():ValueSource
      {
         return mEntityValueSource;
      }
      
      public function GetPropertyValueTarget ():ValueTarget_Variable
      {
         return mPropertyValueTarget;
      }
      
      public function SetPropertyValueTarget (propertyValueTarget:ValueTarget_Variable):void
      {
         mPropertyValueTarget = propertyValueTarget;
      }
      
      public function GetPropertyVariableIndex ():int
      {
         return mPropertyValueTarget.GetVariableIndex ();
      }
      
//======================================================
// override
//======================================================
      
      public function GetValueTargetType ():int
      {
         return ValueTargetTypeDefine.ValueTarget_Property;
      }
      
      public function AssignValue (source:ValueSource):void
      {
         mPropertyValueTarget.AssignValue (source);
      }
      
      public function CloneTarget ():ValueTarget
      {
         return new ValueTarget_Property (mEntityValueSource.CloneSource (), mPropertyValueTarget.CloneTarget () as ValueTarget_Variable);
      }
      
      public function ClonePropertyTarget (triggerEngine:TriggerEngine, ownerFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueTarget
      {
         var newEntityValueSource:ValueSource;
         var newPropertyValueTarget:ValueTarget_Variable;
         
         if (mEntityValueSource is ValueSource_Property)
         {
            throw new Error ("mEntityValueSource can't be a ValueSource_Property");
         }
         else if (mEntityValueSource is ValueSource_Variable)
         {
            newEntityValueSource = (mEntityValueSource as ValueSource_Variable).CloneVariableSource (triggerEngine, ownerFunctionDefinition, callingFunctionDeclaration, paramIndex);
         }
         else
         {
            newEntityValueSource = mEntityValueSource.CloneSource ();
         }
         
         // in fact, "newPropertyValueSource = mPropertyValueSource.CloneSource () as ValueSource_Variable;" is ok
         newPropertyValueTarget = mPropertyValueTarget.CloneVariableTarget (triggerEngine, ownerFunctionDefinition, callingFunctionDeclaration, paramIndex) as ValueTarget_Variable;
         
         return new ValueTarget_Property (newEntityValueSource, newPropertyValueTarget);
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

