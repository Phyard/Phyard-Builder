package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTarget_Self implements ValueTarget
   {
      private var mValueObject:Object;
      
      public function ValueTarget_Self (valueObject:Object)
      {
         mValueObject = valueObject;
      }
      
      public function ToCodeString ():String
      {
         return "this";
      }
      
//======================================================
// override
//======================================================
      
      public function GetValueTargetType ():int
      {
         return ValueTargetTypeDefine.ValueTarget_Self;
      }
      
      public function AssignValue (source:ValueSource):void
      {
         mValueObject = source.GetValueObject ();
      }
      
      public function CloneTarget ():ValueTarget
      {
         return new ValueTarget_Self (mValueObject);
      }
      
      public function ValidateTarget ():void
      {
      }
   }
}

