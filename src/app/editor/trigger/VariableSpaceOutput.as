package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceOutput extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceOutput (/*triggerEngine:TriggerEngine*/)
      {
         //super(triggerEngine);
      }
      
      override public function SupportEditingInitialValues ():Boolean
      {
         return false;
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Output;
      }
      
      override public function GetSpaceName ():String
      {
         return "Return Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Output";
      }
      
      override public function GetCodeName ():String
      {
         return "out";
      }
      
   }
}
