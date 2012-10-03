package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceWorld extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceWorld  (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_World;
      }
      
      override public function GetSpaceName ():String
      {
         return "World Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "World";
      }
      
      override public function GetCodeName ():String
      {
         return "world";
      }
      
   }
}

