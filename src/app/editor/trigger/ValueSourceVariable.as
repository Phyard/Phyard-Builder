package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class ValueSourceVariable extends ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstance:VariableInstance;
      
      public function ValueSourceVariable (variableInstacne:VariableInstance = null)
      {
         SetVariableInstance (variableInstacne);
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
      
      override public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Variable;
      }
      
      override public function GetValueObject ():Object
      {
         if (mVariableInstance == null)
            return undefined;
         
         return mVariableInstance.GetValueObject ();
      }
      
      override public function Clone ():ValueSource
      {
         return new ValueSourceVariable (mVariableInstance);
      }
      
      override public function Validate ():void
      {
         // ...
      }
   }
}

