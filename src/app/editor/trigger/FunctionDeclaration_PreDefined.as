package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.CoreFunctionDeclarations;
   
   // todo: change name to FunctionDeclaration_EventHandler
   public class FunctionDeclaration_PreDefined extends FunctionDeclaration
   {
      public function FunctionDeclaration_PreDefined (id:int, name:String, description:String = null, 
                                                      poemCallingFormat:String = null, traditionalCallingFormat:String = null, 
                                                      paramDefines:Array = null, returnDefinitions:Array = null, 
                                                      showUpInApiMenu:Boolean = true)
      {
         //super (id, name, description, paramDefines, returnDefinitions, showUpInApiMenu);
         super (id, name, description, showUpInApiMenu);
         AddInputVariableFromDefinitions (paramDefines);
         AddOutputVariableFromDefinitions (returnDefinitions);
         
         ParseAllCallingTextSegments (poemCallingFormat, traditionalCallingFormat);
         
         var result:String = CheckConsistent (CoreFunctionDeclarations.GetCoreFunctionDeclaration (id));
         if (result != null)
            throw new Error ("function not consistent! id = " + id + ", name = " + name + ", result: " + result);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_PreDefined;
      }
      
   }
}

