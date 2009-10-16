package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.Define;
   
   public class CommandListDefinition extends CodeSnippet
   {
      protected var mName:String = "";
      
      public function CommandListDefinition (ownerFunctionDefinition:FunctionDefinition = null)
      {
         super (ownerFunctionDefinition);
      }
      
      public function SetName (newName:String):void
      {
         if (newName == null)
            newName = "";
         
         if (newName.length > Define.MaxLogicComponentNameLength)
            newName = newName.substr (0, Define.MaxLogicComponentNameLength);
         
         mName = newName;
      }
      
      public function GetName ():String
      {
         return mName;
      }
   }
}

