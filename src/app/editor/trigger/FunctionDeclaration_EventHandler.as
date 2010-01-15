package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.CoreEventDeclarations;
   
   // todo: change name to FunctionDeclaration_EventHandler
   public class FunctionDeclaration_EventHandler extends FunctionDeclaration
   {
      
      public function FunctionDeclaration_EventHandler (id:int, name:String, paramDefines:Array = null, description:String = null):void
      {
         super (id, name, paramDefines, description);
         
         if ( ! CheckConsistent (CoreEventDeclarations.GetCoreEventHandlerDeclarationById (id) ) )
            throw new Error ("not consistent! event id = " + id);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_EventHandler;
      }
      
   }
}

