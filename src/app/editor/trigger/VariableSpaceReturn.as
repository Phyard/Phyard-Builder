package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceReturn extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableSpaceReturn ()
      {
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Output;
      }
      
      override public function GetSpaceName ():String
      {
         return "Return Variable Space";
      }
      
      override public function GetSpaceShortName ():String
      {
         return "Return";
      }
      
   }
}
