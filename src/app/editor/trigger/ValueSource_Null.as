package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class ValueSource_Null implements ValueSource
   {
      public function ValueSource_Null ()
      {
         
      }
      
      public function ToCodeString ():String
      {
         return "null";
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Null;
      }
      
      public function GetValueObject ():Object
      {
         return null;
      }
      
      // to override
      public function CloneSource ():ValueSource
      {
         return new ValueSource_Null ();
      }
      
      public function ValidateSource ():void
      {
      }
   }
}

