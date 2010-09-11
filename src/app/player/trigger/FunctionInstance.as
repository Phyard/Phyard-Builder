package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   // instance of custom functions
   public class FunctionInstance
   {
      internal var mIsFree:Boolean = true;
      internal var mNextFreeFunctionInstance:FunctionInstance = null;
      
      //
      protected var mFunctionDefinition:FunctionDefinition;
      
      // to reduce the number of function callings, set the 3 variables public
      public var mInputVariableSpace:VariableSpace;
      public var mReturnVariableSpace:VariableSpace;
      public var mLocalVariableSpace:VariableSpace;
      
      public function FunctionInstance (functionDefiniton:FunctionDefinition)
      {
         mFunctionDefinition = functionDefiniton;
         
         // create variable spaces
         var func_declaration:FunctionDeclaration = functionDefiniton.GetFunctionDeclaration ();
         
         var num_inputs :int = func_declaration == null ? 0 : func_declaration.GetNumInputs ();
         mInputVariableSpace = new VariableSpace (num_inputs);
         
         var num_returns:int = func_declaration == null ? 0 : func_declaration.GetNumOutputs ();
         mReturnVariableSpace = new VariableSpace (num_returns);
         
         var num_locals:int = func_declaration == null ? 0 : func_declaration.GetNumLocalVariables ();
         mLocalVariableSpace = new VariableSpace (num_locals);
      }
      
      public function GetFunctionDefinition ():FunctionDefinition
      {
         return mFunctionDefinition;
      }
      
      public function GetInputVariableAt (index:int):VariableInstance
      {
         if (mInputVariableSpace == null)
            return null;
         
         return mInputVariableSpace.GetVariableAt (index);
      }
      
      public function GetReturnVariableAt (index:int):VariableInstance
      {
         if (mReturnVariableSpace == null)
            return null;
         
         return mReturnVariableSpace.GetVariableAt (index);
      }
      
      public function GetLocalVariableAt (index:int):VariableInstance
      {
         if (mLocalVariableSpace == null)
            return null;
         
         return mLocalVariableSpace.GetVariableAt (index);
      }
   }
}