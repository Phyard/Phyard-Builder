package player.trigger.entity
{
   import flash.utils.Dictionary;
   
   import player.world.World;
   import player.world.EntityList;
   
   import player.entity.Entity;
   
   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;
   
   import player.trigger.data.ListElement_EntitySelector;
   
   import common.trigger.ValueDefine;
   
   import common.Define;
   
   public class EntitySelector extends EntityLogic
   {
      protected var mIsPairLimiter:Boolean;
      
      // 
      public function EntitySelector (world:World, isPairLimiter:Boolean)
      {
         super (world);
         
         mIsPairLimiter = isPairLimiter;
      }
      
//========================================
// to override
//========================================
      
      //public function ContainsEntity (entityIndex:int):Boolean
      //{
      //   return false; // to override
      //}
      
      public static const PairContainingResult_False:int = 0;
      public static const PairContainingResult_True:int = 1;
      public static const PairContainingResult_TrueButNeedExchangePairOrder:int = 2;
      
      public function ContainsEntityPair (entity1:Entity, entity2:Entity, ignorePairOrder:Boolean):int
      {
         return PairContainingResult_False; // to override
      }
      
      public function HandleTimerEventForEntities (timerEventHandler:EntityEventHandler_Timer, valueSourceList:Parameter):void
      {
         // to override
      }
      
      public function HandleTimerEventForEntityPairs (timerEventHandler:EntityEventHandler_Timer, valueSourceList:Parameter):void
      {
         // to override
      }
      
      public function GetEntityListTaskStatus ():int
      {
         return ValueDefine.TaskStatus_Unfinished; // to override
      }
      
      // for entities placed in editor only. Called in world.Init
      public function RegisterEventHandlerForEntities (eventId:int, eventHandler:EntityEventHandler):void
      {
         // to override
      }
      
//==========================================================================================================
//   static
//==========================================================================================================

      // this one is not static in fact.
      public function RegisterEventHandlerForEntitiesPlacedInEditor (filterFunc:Function, eventId:int, eventHandler:EntityEventHandler):void
      {
         var count:int = mWorld.GetNumEntitiesInEditor ();
         for (var entityIndex:int = 0; entityIndex < count; ++ entityIndex)
         {
            var entity:Entity = mWorld.GetEntityByCreateOrderId (entityIndex, false);
            if (entity == null || entity.IsDestroyedAlready ())
               continue;
            
            if (filterFunc == null || filterFunc (entity))
            {
               entity.RegisterEventHandler (eventId, eventHandler);
            }
         }
      }
      
      public static function AggregateEntityListTaskStatus (entityList:EntityList, filterFunc:Function):int
      {
         var numUndertermineds:int = 0;
         
         var entity:Entity = entityList.GetHead ();
         if (entity != null)
         {
            var tail:Entity = entityList.GetTail ();
            
            while (true)
            {
               if ((! entity.IsDestroyedAlready ()) && (filterFunc == null || filterFunc (entity)))
               {
                  if (entity.IsTaskFailed ())
                     return ValueDefine.TaskStatus_Failed;
                  else if (entity.IsTaskUnfinished ())
                     ++ numUndertermineds;
               }
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         if (numUndertermineds > 0)
            return ValueDefine.TaskStatus_Unfinished;
         else
            return ValueDefine.TaskStatus_Successed;
      }
      
      public static function HandleTimerEventForEntityList (entityList:EntityList, filterFunc:Function, timerEventHandler:EntityEventHandler_Timer, valueSourceList:Parameter):void
      {
         var valueSourceEntity:Parameter_Direct = valueSourceList.mNextParameter as Parameter_Direct;
         
         var entity:Entity = entityList.GetHead ();
         if (entity != null)
         {
            var tail:Entity = entityList.GetTail ();
            
            while (true)
            {
               if ((! entity.IsDestroyedAlready ()) && (filterFunc == null || filterFunc (entity)))
               {
                  valueSourceEntity.mValueObject = entity;
               
                  timerEventHandler.HandleEvent (valueSourceList);
               }
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
      }
      
      /*
      public static function GetContainingEntityPairResult (selectorListHead:ListElement_EntitySelector, entity1:Entity, entity2:Entity, ignorePairOrder:Boolean = true):int
      {
         var list_element:ListElement_EntitySelector = selectorListHead;
         var result:int;
         
         while (list_element != null)
         {
            result = list_element.mEntitySelector.ContainsEntityPair (entity1, entity2, ignorePairOrder);
            
            if (result != PairContainingResult_False)
               return result;
            
            list_element = list_element.mNextListElement;
         }
         
         return PairContainingResult_False;
      }
      
      public static function GetContainingEntityResult (selectorListHead:ListElement_EntitySelector, entityId:int):int
      {
         return PairContainingResult_False;
      }
      */
   }
}
