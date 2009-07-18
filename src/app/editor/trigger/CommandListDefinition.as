package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class CommandListDefinition extends FunctionDefinition
   {
      protected var mFunctionCallings:Array = new Array ();
      
      public function CommandListDefinition (functionDeclatation:FunctionDeclaration = null)
      {
         super (functionDeclatation);
      }
      
      public function ClearCommands ():void
      {
         mFunctionCallings.splice (0, mFunctionCallings.length);
      }
      
      public function SetCommands (funcCallings:Array):void
      {
         mFunctionCallings = funcCallings;
      }
      
      public function AddCommand (funcCalling:FunctionCalling):void
      {
         mFunctionCallings.push (funcCalling);
      }
      
      public function GetNumCommnads ():int
      {
         return mFunctionCallings.length;
      }
      
      public function GetCommandAt (index:int):FunctionCalling
      {
         if (index < 0 || index >= mFunctionCallings.length)
            return null;
         
         return mFunctionCallings [index];
      }
      
      override public function ValidateValueSources ():void
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

