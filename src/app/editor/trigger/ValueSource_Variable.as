package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSource_Variable implements ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstance:VariableInstance;
      
      public function ValueSource_Variable (variableInstacne:VariableInstance = null)
      {
         SetVariableInstance (variableInstacne);
      }
      
      public function ToCodeString ():String
      {
         return mVariableInstance == null ? "null" : mVariableInstance.ToCodeString_ForSource ();
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
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Variable;
      }
      
      public function GetValueObject ():Object
      {
         if (mVariableInstance == null)
            return undefined;
         
         return mVariableInstance.GetValueObject ();
      }
      
      public function CloneSource ():ValueSource
      {
         return new ValueSource_Variable (mVariableInstance);
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
   }
}

