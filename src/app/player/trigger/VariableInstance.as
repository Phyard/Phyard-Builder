package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableInstance extends ClassInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance; // for efficiency
      
      private var mDeclaration:VariableDeclaration;
      //public var mClassInstance:ClassInstance; // use the extend implementation instead now.
            //mDeclaration == null means this VariableInstacne will rejest value assginings (in normal mode).
      
      public function VariableInstance ()
      {
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
      
   //=====================================
   // assign
   //=====================================
      
      // if assign one VariableInstacne to the other, check if the two shell class definitions are same, 
      // if true, assign directly without calling this function.
      public function Assign (classDefinition:ClassDefinition, valueObject:Object):void
      {
         if (mDeclaration == null)
            return;
         
         //if (mVariableDeclaration.m
         mRealClassDefinition = classDefinition;
         mValueObject = valueObject;
      }
      
   }
}