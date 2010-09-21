package editor.trigger {
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.ValueAdjuster;
   import common.CoordinateSystem;
   
   public class FunctionCalling_Core extends FunctionCalling
   {
      public var mCoreFunctionDeclatation:FunctionDeclaration_Core;
      
      public function FunctionCalling_Core (triggerEngine:TriggerEngine, coreFunctionDeclatation:FunctionDeclaration_Core, createDefaultSourcesAndTargets:Boolean = true)
      {
         super (triggerEngine, coreFunctionDeclatation, createDefaultSourcesAndTargets);
         
         mCoreFunctionDeclatation = coreFunctionDeclatation;
      }
      
      override protected function CloneShell ():FunctionCalling
      {
         return new FunctionCalling_Core (mTriggerEngine, mCoreFunctionDeclatation, false);
      }
   }
}
