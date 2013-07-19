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
      
      // this space is added from v2.03 and support UUID since born.
      override public function IsVariableKeySupported ():Boolean
      {
         return true;
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

