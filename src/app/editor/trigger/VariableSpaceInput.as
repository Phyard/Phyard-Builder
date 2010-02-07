package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceInput extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceInput ()
      {
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Input;
      }
      
      override public function GetSpaceName ():String
      {
         return "Input Variable Space";
      }
      
      override public function GetShortName ():String
      {
         return "Input";
      }
      
      override public function GetCodeName ():String
      {
         return "in";
      }
      
   }
}

