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
         if (mVariableInstance == null)
            return ValueSpaceTypeDefine.ValueSpace_Global;
         
         return mVariableInstance.GetSpaceType ();
      }
      
      public function GetVariableIndex ():int
      {
         if (mVariableInstance == null)
            return -1;
         
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
         if (mVariableInstance != null)
            mVariableInstance.AssignValue (source);
      }
      
      public function CloneTarget ():ValueTarget
      {
         return new ValueTarget_Variable (mVariableInstance);
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

