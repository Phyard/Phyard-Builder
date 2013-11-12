package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.CoreEventDeclarations;
   
   // todo: change name to FunctionDeclaration_EventHandler
   public class FunctionDeclaration_EventHandler extends FunctionDeclaration
   {
      
      public function FunctionDeclaration_EventHandler (id:int, name:String, description:String = null, 
                                                      poemCallingFormat:String = null, traditionalCallingFormat:String = null, 
                                                      paramDefines:Array = null, returnDefinitions:Array = null,
                                                      showUpInApiMenu:Boolean = true)
      {
         //super (id, name, description, paramDefines, returnDefinitions, showUpInApiMenu);
         super (id, name, description, showUpInApiMenu);
         AddInputVariableFromDefinitions (paramDefines);
         AddOutputVariableFromDefinitions (returnDefinitions);
         
         ParseAllCallingTextSegments (poemCallingFormat, traditionalCallingFormat);
         
         var result:String = CheckConsistent (CoreEventDeclarations.GetCoreEventHandlerDeclarationById (id))
         if (result != null)
            throw new Error ("event handler not consistent! event id = " + id + ", name = " + name + ", reason: " + result);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_PreDefined;
      }
      
   }
}

