package editor.trigger {
   
   public class FunctionDefinition
   {
      public var mFunctionDeclaration:FunctionDeclaration;
      
      public var mInputVariableSpace:VariableSpaceInput;
      
      public function FunctionDefinition (functionDeclatation:FunctionDeclaration = null)
      {
         mFunctionDeclaration = functionDeclatation;
         
         mInputVariableSpace = new VariableSpaceInput ();
         
         if (mFunctionDeclaration != null)
         {
            var num_params:int = mFunctionDeclaration.GetNumParameters ();
            for (var i:int = 0; i < num_params; ++ i)
               mInputVariableSpace.CreateVariableInstance (mFunctionDeclaration.GetParamDefinitionAt (i));
         }
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function GetFunctionDeclarationId ():int
      {
         if(mFunctionDeclaration == null)
            return -1;
         
         return mFunctionDeclaration.GetID ();
      }
      
      public function GetInputVariableSpace ():VariableSpaceInput
      {
         return mInputVariableSpace;
      }
      
      public function GetName ():String
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetName ();
      }
      
      public function GetDescription ():String
      {
         if (mFunctionDeclaration == null)
            return null;
         
         return mFunctionDeclaration.GetDescription ();
      }
      
      public function ValidateValueSources ():void
      {
      }
   }
}

