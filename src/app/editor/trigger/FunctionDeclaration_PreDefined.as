package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.CoreEventDeclarations;
   
   // todo: change name to FunctionDeclaration_PreDefined
   public class FunctionDeclaration_PreDefined extends FunctionDeclaration
   {
      
      public function FunctionDeclaration_PreDefined (id:int, name:String, description:String = null, 
                                                      poemCallingFormat:String = null, traditionalCallingFormat:String = null, 
                                                      paramDefines:Array = null, 
                                                      showUpInApiMenu:Boolean = true)
      {
         super (id, name, description, poemCallingFormat, traditionalCallingFormat, paramDefines, null, showUpInApiMenu);
         
         if ( ! CheckConsistent (CoreEventDeclarations.GetCoreEventHandlerDeclarationById (id) ) )
            throw new Error ("not consistent! event id = " + id);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_EventHandler;
      }
      
   }
}

