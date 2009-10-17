package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionTypeDefine;
   
   public class FunctionDeclaration_Core extends FunctionDeclaration
   {
      public function FunctionDeclaration_Core (id:int, name:String, inputDefinitions:Array = null, returnDefinitions:Array = null, description:String = null)
      {
         super (id, name, inputDefinitions, description, returnDefinitions);
         
         if ( ! CheckConsistent (TriggerEngine.GetCoreFunctionDeclaration (id) ) )
            throw new Error ("not consistent! id = " + id);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_Core;
      }
   }
}

