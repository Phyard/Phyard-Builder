package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceEntity extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceEntity (triggerEngine:TriggerEngine)
      {
         super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Entity;
      }
      
      override public function GetSpaceName ():String
      {
         return "Entity Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Entity Property";
      }
      
      override public function GetCodeName ():String
      {
         return "entity";
      }
      
   }
}
