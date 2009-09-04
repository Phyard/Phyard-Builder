package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.Define;
   
   public class CommandListWithNameDefinition extends CommandListDefinition
   {
      protected var mName:String;
      
      public function CommandListWithNameDefinition (name:String, ownerFunctionDefinition:FunctionDefinition = null)
      {
         super (ownerFunctionDefinition);
         
         SetName (name);
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

