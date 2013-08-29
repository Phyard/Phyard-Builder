package player.trigger
{
   public class Parameter_DirectSource extends Parameter
   {
      public var mValueObject:Object;
      
      // for optimizing, TriggerEngine will cache many Parameter_Direct instances. 
      // Notice: when a Parameter_Direct is recycled, mValueObjec must be reset to null
      
      public function Parameter_DirectSource (valueObject:Object, next:Parameter = null)
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
      }
   }
}