package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTargetTypeDefine;
   
   public interface ValueTarget
   {
      function GetValueTargetType ():int;
      
      function AssignValue (source:ValueSource):void;
      
      function CloneTarget ():ValueTarget;
      
      function ValidateTarget ():void;
      
      function TargetToCodeString ():String;
   }
}

