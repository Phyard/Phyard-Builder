package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   // instance of custom functions
   public class FunctionInstance
   {
      public var mNextFreeFunctionInstance:FunctionInstance = null;
      
      //
      protected var mFunctionDefinition:FunctionDefinition;
      
      // to reduce the number of function callings, set the 2 variables public
      public var mInputVariableSpace:VariableSpace;
      public var mReturnVariableSpace:VariableSpace;
      
      protected var mLocalVariableSpace:VariableSpace;
      
      public function FunctionInstance (functionDefiniton:FunctionDefinition, localVariableDefines:Array = null)
      {
         mFunctionDefinition = functionDefiniton;
         
         // create variable spaces
         var func_declaration:FunctionDeclaration = functionDefiniton.GetFunctionDeclaration ();
         
         var num_inputs :int = func_declaration == null ? 0 : func_declaration.GetNumInputs ();
         mInputVariableSpace = new VariableSpace (num_inputs);
         
         var num_returns:int = func_declaration == null ? 0 : func_declaration.GetNumReturns ();
         mReturnVariableSpace = new VariableSpace (num_returns);
         
         var num_locals:int = localVariableDefines == null ? 0 : localVariableDefines.length;
         if (num_locals > 0)
         {
            mLocalVariableSpace = new VariableSpace (localVariableDefines.length);
            
            // create local varible instances
         }
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