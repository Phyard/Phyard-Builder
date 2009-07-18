package editor.trigger {
   
   public class CommandDefine extends CommandDefine
   {
      public var mCallback:Function;
      
      public function CommandDefine (id:int, name:String, paramDefines:Array = null, callback:Function = null):void
      {
         super (id, name, paramDefines);
         
         mCallback = callback;
      }
   }
}

