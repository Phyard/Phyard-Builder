package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpaceClassInstance extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================

      private var mName:String = "Custom Type"; // to rreplace
        
      public function VariableSpaceClassInstance (/*triggerEngine:TriggerEngine, */ name:String)
      {
         //super(triggerEngine);
         
         SetSpaceName (name);
      }
      
      public function SetSpaceName (name:String):void
      {
         mName = name;
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_CustomType;
      }
      
      override public function GetSpaceName ():String
      {
         return mName;
      }
      
      override public function GetShortName ():String
      {
         return mName;
      }
      
      override public function GetCodeName ():String
      {
         return mName;
      }
      
   }
}

