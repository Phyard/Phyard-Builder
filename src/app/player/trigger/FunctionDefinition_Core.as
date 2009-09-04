package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   import common.trigger.ValueTypeDefine;
   
   public class FunctionDefinition_Core extends FunctionDefinition
   {
      public var mCoreFunction:Function = null;
      
      protected var mFreeFunctionInstance:FunctionInstance = null;
      
      public function FunctionDefinition_Core (functionDecl:FunctionDeclaration, callback:Function)
      {
         super (functionDecl);
         
         mCoreFunction = callback;
      }
      
      override public function DoCall (inputValueSourceList:ValueSource, returnValueTargetList:ValueTarget):void
      {
         mCoreFunction (inputValueSourceList, returnValueTargetList);
      }
   }
}