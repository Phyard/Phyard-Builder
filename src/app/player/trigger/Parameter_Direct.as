package player.trigger
{
   public class Parameter_Direct extends Parameter
   {
      public var mValueObject:Object;
      
      // for optimizing, TriggerEngine will cache many Parameter_Direct instances. 
      // Notice: when a Parameter_Direct is recycled, mValueObjec must be reset to null
      
      public function Parameter_Direct (valueObject:Object, next:Parameter = null)
      {
         super (next);
         
         mValueObject = valueObject;
      }
      
      override public function EvaluateValueObject ():Object
      {
         return mValueObject;
      }
      
      override public function AssignValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
            // generally, assign a value object for a Parameter_Direct is useless.
            // Here no preventing a Parameter_Direct from being assigned a new value is for internal usages, for example:
            // - use as output parameter for BasicCondition and EntityFilter, etc.
      }
   }
}