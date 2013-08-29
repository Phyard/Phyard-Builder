package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableInstance extends ClassInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance; // for efficiency
      
      private var mDeclaration:VariableDeclaration;
      //public var mClassInstance:ClassInstance; // use the extend implementation instead.
      
      public function VariableInstance (value:Object = null)
      {
         super (value);
      }
      
      public function GetDeclaration ():VariableDeclaration
      {
         return mDeclaration;
      }
      
      public function SetDeclaration (declaration:VariableDeclaration):void
      {
         mDeclaration = declaration;
      }
      
      public function CloneForVariableInstance (forVI:VariableInstance):void
      {
         CloneForClassInstance (forVI);
         
         forVI.SetDeclaration (mDeclaration);
      }
      
   }
}