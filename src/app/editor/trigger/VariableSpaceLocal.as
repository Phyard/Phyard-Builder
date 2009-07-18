package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceLocal extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceLocal ()
      {
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Local;
      }
      
   }
}

