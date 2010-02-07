package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTarget_Property implements ValueTarget
   {
      // to do
      
      public function ValueTarget_Property ()
      {
      }
      
      public function ToCodeString ():String
      {
         return "property (not supproted now)";
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
      }
      
      public function CloneTarget ():ValueTarget
      {
         return new ValueTarget_Property ();
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

