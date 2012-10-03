package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceGameSave extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceGameSave  (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_GameSave;
      }
      
      override public function GetSpaceName ():String
      {
         return "Game Save Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Game Save";
      }
      
      override public function GetCodeName ():String
      {
         return "game_save";
      }
      
   }
}

