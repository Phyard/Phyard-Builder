package player.trigger.entity
{
   import player.world.World;
   
   import common.trigger.ValueDefine;
   
   public class EntityConditionDoor extends EntityCondition
   {
      protected var mInputConditionListHead:ConditionAndTargetValue = null;
      
      protected var mIsAnd:Boolean = true;
      protected var mIsNot:Boolean = false;
      
      public function EntityConditionDoor (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
      }
      
      public function SetInputConditions (conditionEntityIndexes:Array, targetValues:Array):void
      {
         if (conditionEntityIndexes == null || targetValues == null)
            return;
         
         if (targetValues.length < conditionEntityIndexes.length)
            return;
         
         var newOne:ConditionAndTargetValue;
         
         for (var i:int = conditionEntityIndexes.length - 1; i >= 0; -- i)
         {
            newOne = new ConditionAndTargetValue (mWorld.GetEntityByIndexInEditor (conditionEntityIndexes [i]) as EntityCondition, targetValues [i]);
            
            newOne.mNextConditionAndTargetValue = mInputConditionListHead;
            mInputConditionListHead = newOne;
         }
      }
      
      public function SetAnd (isAnd:Boolean):void
      {
         mIsAnd = isAnd;
      }
      
      public function SetNot (isNot:Boolean):void
      {
         mIsNot = isNot;
      }
      
      public function UnshiftInputConditions (conditionEntity:EntityCondition, targetValue:int):void
      {
         var newOne:ConditionAndTargetValue = new ConditionAndTargetValue (conditionEntity, targetValue);
         
         newOne.mNextConditionAndTargetValue = mInputConditionListHead;
         mInputConditionListHead = newOne;
      }
      
      override public function Evaluate ():void
      {
         var conditionAndTargetValue:ConditionAndTargetValue = mInputConditionListHead;
         
         if (mIsAnd)
         {
            while (conditionAndTargetValue != null)
            {
               if (! conditionAndTargetValue.IsSatisfied ())
               {
                  mEvaluatedValue = mIsNot ? ValueDefine.BoolValue_True : ValueDefine.BoolValue_False;
                  
                  break;
               }
                  
               conditionAndTargetValue = conditionAndTargetValue.mNextConditionAndTargetValue;
            }
            
            mEvaluatedValue = mIsNot ? ValueDefine.BoolValue_False : ValueDefine.BoolValue_True;
         }
         else
         {
            while (conditionAndTargetValue != null)
            {
               if (conditionAndTargetValue.IsSatisfied ())
               {
                  mEvaluatedValue = mIsNot ? ValueDefine.BoolValue_False : ValueDefine.BoolValue_True;
                  
                  break;
               }
               
               conditionAndTargetValue = conditionAndTargetValue.mNextConditionAndTargetValue;
            }
            
            mEvaluatedValue = mIsNot ? ValueDefine.BoolValue_True : ValueDefine.BoolValue_False;
         }
      }
   }
}