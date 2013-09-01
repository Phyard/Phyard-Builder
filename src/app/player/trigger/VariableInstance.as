package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableInstance extends ClassInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance; // for efficiency
      
      private var mDeclaration:VariableDeclaration;
            // mDeclaration.mClassDefinition == VoidClassDefinition means 
            // this VariableInstacne will reject value assginings (in normal mode).
            //
            // this value is never null.
            // when clone a variable instance, this value is passed to the cloned one directly.
      
      //public var mClassInstance:ClassInstance; 
            // use the extend implementation instead now.

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
         
         //
         SetRealClassDefinition (classDefinition);
         SetValueObject (valueObject);
      }
      
   }
}