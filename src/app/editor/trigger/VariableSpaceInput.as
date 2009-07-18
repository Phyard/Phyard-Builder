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
      
   }
}

