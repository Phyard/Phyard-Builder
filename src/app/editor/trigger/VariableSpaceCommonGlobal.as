package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceCommonGlobal extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceCommonGlobal (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_CommonGlobal;
      }
      
      override public function GetSpaceName ():String
      {
         return "Common Global Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Common Global";
      }
      
      override public function GetCodeName ():String
      {
         return "common global";
      }
      
   }
}

