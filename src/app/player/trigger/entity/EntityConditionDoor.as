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
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mIsAnd != undefined)
               SetAnd (entityDefine.mIsAnd);
            if (entityDefine.mIsNot != undefined)
               SetNot (entityDefine.mIsNot);
            
            if (entityDefine.mNumInputConditions != undefined)
            {
               var length:int = entityDefine.mNumInputConditions;
               
               var conditionEntityIndexes:Array = entityDefine.mInputConditionEntityCreationIds;
               var targetValues          :Array = entityDefine.mInputConditionTargetValues;
               
               if (conditionEntityIndexes != null && targetValues != null)
               {
                  var newOne:ConditionAndTargetValue;
                  
                  for (var i:int = length - 1; i >= 0; -- i)
                  {
                     // must be an entity palced in editor (before v2.02)
                     //newOne = new ConditionAndTargetValue (mWorld.GetEntityByCreateOrderId (int(conditionEntityIndexes [i]), false) as EntityCondition, int (targetValues [i]));
                     
                     // from v2.02, merging scene is added
                     var conditionEntityIndex:int = conditionEntityIndexes [i] as int;
                     newOne = new ConditionAndTargetValue (mWorld.GetEntityByCreateOrderId (conditionEntityIndex, true) as EntityCondition, targetValues [i] as int);
                                                                              // NOT only support entities placed in editor
                     
                     newOne.mNextConditionAndTargetValue = mInputConditionListHead;
                     mInputConditionListHead = newOne;
                  }
               }
            }
         }
      }
      
//=============================================================
//   
//=============================================================
      
      public function SetAnd (isAnd:Boolean):void
      {
         mIsAnd = isAnd;
      }
      
      public function SetNot (isNot:Boolean):void
      {
         mIsNot = isNot;
      }
      
//=============================================================
//   as condition
//=============================================================
      
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
                  
                  return;
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
                  
                  return;
               }
               
               conditionAndTargetValue = conditionAndTargetValue.mNextConditionAndTargetValue;
            }
            
            mEvaluatedValue = mIsNot ? ValueDefine.BoolValue_True : ValueDefine.BoolValue_False;
         }
      }
   }
}
