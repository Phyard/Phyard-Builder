
package editor.trigger.entity {
   
   public class ConditionAndTargetValue
   {
      public var mConditionEntity:ICondition;
      public var mTargetValue:int;
      
      public function ConditionAndTargetValue (conditionEntity:ICondition, targetValue:int)
      {
         mConditionEntity = conditionEntity;
         mTargetValue = targetValue;
      }
   }
}
