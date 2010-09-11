package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   public class FunctionDefinition
   {
      protected var mFunctionDeclaration:FunctionDeclaration = null;
      
      public function FunctionDefinition (functionDecl:FunctionDeclaration)
      {
         mFunctionDeclaration = functionDecl;
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration
      {
         return mFunctionDeclaration;
      }
      
      public function DoCall (inputValueSources:ValueSource, returnValueTarget:ValueTarget):void
      {
         throw new Error ("to override");
      }
   }
}