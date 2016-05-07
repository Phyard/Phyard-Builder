package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceGlobal extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceGlobal (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Global;
      }
      
      override public function GetSpaceName ():String
      {
         return "Global Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Global";
      }
      
      override public function GetCodeName ():String
      {
         return "global";
      }
      
   }
}

