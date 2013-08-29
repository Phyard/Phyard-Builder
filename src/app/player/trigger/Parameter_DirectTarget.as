package player.trigger
{
   public class Parameter_DirectTarget extends Parameter_DirectSource
   {  
      public function Parameter_DirectTarget (valueObject:Object, next:Parameter = null)
      {
         super (valueObject, next);
      }
      
      // - use for output parameter for BasicCondition and EntityFilter, etc.
      override public function AssignValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
   }
}