package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceEntityProperties extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceEntityProperties (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_EntityProperties;
      }
      
      override public function GetSpaceName ():String
      {
         return "Entity Properties Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Property";
      }
      
      override public function GetCodeName ():String
      {
         return "property";
      }
      
   }
}
