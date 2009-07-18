package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class VariableValueSourceVariable extends VariableValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstance:VariableInstance;
      
      public function VariableValueSourceVariable (variableInstacne:VariableInstance = null)
      {
         SetVariableInstance (variableInstacne);
      }
      
      public function SetVariableInstance (variableInstacne:VariableInstance):void
      {
         mVariableInstance = variableInstacne;
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
      
      override public function Clone ():VariableValueSource
      {
         return new VariableValueSourceVariable (mVariableInstance);
      }
      
      override public function Validate ():void
      {
         // ...
      }
   }
}

