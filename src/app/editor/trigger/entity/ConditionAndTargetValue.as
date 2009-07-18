
package editor.trigger.entity {
   
   public class ConditionAndTargetValue
   {
      public var mConditionEntity:EntityCondition;
      public var mTargetValue:int;
      
      public function ConditionAndTargetValue (conditionEntity:EntityCondition, targetValue:int)
      {
         mConditionEntity = conditionEntity;
         mTargetValue = targetValue;
      }
   }
}
