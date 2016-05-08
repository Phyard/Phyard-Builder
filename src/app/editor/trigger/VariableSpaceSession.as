package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceSession extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceSession  (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Session;
      }
      
      override public function GetSpaceName ():String
      {
         return "Session Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Session";
      }
      
      override public function GetCodeName ():String
      {
         return "session";
      }
      
   }
}

