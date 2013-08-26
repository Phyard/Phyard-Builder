package player.trigger
{
   public class ClassInstance
   {
      internal var mClassDefinition:ClassDefinition;
      
      public var mValueObject:Object;
      
      public function ClassInstance (classDefinition:ClassDefinition, valueObject:Object)
      {
         mClassDefinition = classDefinition;
         
         mValueObject = valueObject;
      }
   }
}