package player.trigger
{
   import common.trigger.ClassTypeDefine;
   
   public class ClassDefinition
   {
      public function GetID ():int
      {
         return 0; // to override
      }
      
      public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Unknown;
      }
      
      public function CreateInstance ():ClassInstance
      {
         return null;
      }
   }
}