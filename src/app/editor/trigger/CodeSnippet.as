package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class CodeSnippet
   {
      protected var mOwnerFunctionDefinition:FunctionDefinition = null;
      protected var mFunctionCallings:Array = new Array ();
      
      public function CodeSnippet (ownerFunctionDefinition:FunctionDefinition = null)
      {
         mOwnerFunctionDefinition = ownerFunctionDefinition;
      }
      
      public function GetOwnerFunctionDefinition ():FunctionDefinition
      {
         return mOwnerFunctionDefinition;
      }
      
      public function ClearFunctionCallings ():void
      {
         mFunctionCallings.splice (0, mFunctionCallings.length);
      }
      
      public function AssignFunctionCallings (funcCallings:Array):void
      {
         if (funcCallings == null)
            funcCallings = new Array ();
         
         mFunctionCallings = funcCallings;
      }
      
      public function AddFunctionCalling (funcCalling:FunctionCalling):void
      {
         mFunctionCallings.push (funcCalling);
      }
      
      public function GetNumFunctionCallings ():int
      {
         return mFunctionCallings.length;
      }
      
      public function GetFunctionCallingAt (index:int):FunctionCalling
      {
         if (index < 0 || index >= mFunctionCallings.length)
            return null;
         
         return mFunctionCallings [index];
      }
      
      public function ValidateValueSources ():void
      {
         var func_calling:FunctionCalling;
         for (var i:int = 0; i < mFunctionCallings.length; ++ i)
         {
            func_calling = mFunctionCallings [i] as FunctionCalling;
            if (func_calling != null)
               func_calling.ValidateValueSources ();
         }
      }
   }
}

