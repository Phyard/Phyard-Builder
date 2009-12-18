package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionTypeDefine;
   import common.trigger.FunctionDeclaration;
   
   public class FunctionDeclaration_Core extends editor.trigger.FunctionDeclaration
   {
      protected var mFunctionDeclaration_Common :common.trigger.FunctionDeclaration;
      
      public function FunctionDeclaration_Core (id:int, name:String, inputDefinitions:Array = null, returnDefinitions:Array = null, description:String = null)
      {
         super (id, name, inputDefinitions, description, returnDefinitions);
         
         mFunctionDeclaration_Common = TriggerEngine.GetCoreFunctionDeclaration (id);
         
         if ( ! CheckConsistent (mFunctionDeclaration_Common) )
            throw new Error ("not consistent! id = " + id);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_Core;
      }
      
//=================================================================
//
//=================================================================
      
      override public function GetInputNumberTypeDetail (inputId:int):int
      {
         return mFunctionDeclaration_Common.GetInputNumberTypeDetail (inputId);
      }
      
      override public function GetInputNumberTypeUsage (inputId:int):int
      {
         return mFunctionDeclaration_Common.GetInputNumberTypeUsage (inputId);
      }
      
   }
}

