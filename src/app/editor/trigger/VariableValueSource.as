package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class VariableValueSource
   {
      public function GetSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Undetermined;
      }
      
      public function GetValueObject ():Object
      {
         return null;
      }
      
      public function GetValueSourceType ():int
      {
         return -1;
      }
      
      // to override
      public function Clone ():VariableValueSource
      {
         return null;
      }
      
      public function Validate ():void
      {
      }
   }
}

