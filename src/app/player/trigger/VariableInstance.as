package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableInstance extends ClassInstance
   {
      public var mNextVariableInstanceInSpace:VariableInstance; // for efficiency
      
      public var _mDeclaration:VariableDeclaration;
            // _mDeclaration.mClassDefinition == VoidClassDefinition means 
            // this VariableInstacne will reject value assginings (in normal mode).
            //
            // this value is never null.
            // when clone a variable instance, this value is passed to the cloned one directly.
      
      //public var mClassInstance:ClassInstance; 
            // use the extend implementation instead now.
            // sadly, but this is realy a bad change.
            //
            // TODO: change back to mClassInstance instead of extending.
            // 

      public function VariableInstance ()
      {
      }
      
      public function GetDeclaration ():VariableDeclaration
      {
         return _mDeclaration;
      }
      
      public function SetDeclaration (declaration:VariableDeclaration):void
      {
         _mDeclaration = declaration;
      }
      
      public function CloneForVariableInstance (forVI:VariableInstance):void
      {
         CloneForClassInstance (forVI);
         
         forVI.SetDeclaration (_mDeclaration);
      }
      
   //=====================================
   // assign
   //=====================================
      
      // if assign one VariableInstacne to the other, check if the two shell class definitions are same, 
      // if true, assign directly without calling this function.
      public function Assign (classDefinition:ClassDefinition, valueObject:Object):void
      {
         _mRealClassDefinition = classDefinition;
         _mValueObject = valueObject;
      }
      
   }
}