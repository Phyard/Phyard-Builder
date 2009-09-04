package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTarget_Null implements ValueTarget
   {
      public function GetValueTargetType ():int
      {
         return ValueTargetTypeDefine.ValueTarget_Null;
      }
      
      public function AssignValue (source:ValueSource):void
      {
      }
      
      public function CloneTarget ():ValueTarget
      {
         return new ValueTarget_Null ();
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

