package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceCommonEntityProperties extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceCommonEntityProperties (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties;
      }
      
      override public function GetSpaceName ():String
      {
         return "Common Entity Properties Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Common Property";
      }
      
      override public function GetCodeName ():String
      {
         return "common property";
      }
      
   }
}
