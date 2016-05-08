
package player.trigger.entity {
   
   public class ConditionAndTargetValue
   {
      public var mConditionEntity:EntityCondition;
      public var mTargetValue:int;
      
      public var mNextConditionAndTargetValue:ConditionAndTargetValue = null;
      
      public function ConditionAndTargetValue (conditionEntity:EntityCondition, targetValue:int)
      {
         mConditionEntity = conditionEntity;
         mTargetValue = targetValue;
      }
      
      public function IsSatisfied ():Boolean
      {
         return mConditionEntity.GetEvaluatedValue () == mTargetValue;
      }
   }
}
