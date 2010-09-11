package player.trigger
{
   import common.trigger.FunctionDeclaration;
   
   // instance of custom functions
   public class ClassInstance
   {
      public var mNextFreeClassInstance:ClassInstance = null;
      
      //
      protected var mClassDefinition:ClassDefinition;
      
      // to reduce the number of function callings, set the variable public
      public var mMemberVariableSpace:VariableSpace;
      
      public function ClassInstance (classDefinition:ClassDefinition)
      {
         mClassDefinition = classDefinition;
      }
   }
}