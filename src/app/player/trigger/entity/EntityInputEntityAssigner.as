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
   
   public class EntityInputEntityAssigner extends EntitySelector
   {
      protected var mAssignerType:int = Define.EntitySelectorType_Many; // if isPair, pair type, if not pair, selector type
      
      // the indexes are indexes in editor
      protected var mEntitiesIndexes1:Array = null;
      protected var mEntitiesIndexes2:Array = null;
      
      // sometimes, it is more convient to use entity referance directly
      protected var mInputEntityArray1:Array = null;
      protected var mInputEntityArray2:Array = null;
      
      // for 1-1 optimizing
      protected var mPairHashtable:Dictionary = null;
      protected var mPairHashtable_IgnorePairOrder:Dictionary = null;
      
      // 
      public function EntityInputEntityAssigner (world:World, isPairAssigner:Boolean)
      {
         super (world, isPairAssigner);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         var i:int;
         
         if (createStageId == 0)
         {
            if (mIsPairSelector)
            {
               if (entityDefine.mPairingType != undefined)
                  mAssignerType = entityDefine.mPairingType;
               else
                  mAssignerType = Define.EntityPairAssignerType_OneToOne;
               
               if (entityDefine.mEntityCreationIds1 != undefined)
                  mEntitiesIndexes1 = entityDefine.mEntityCreationIds1.concat ();
               else
                  mEntitiesIndexes1 = new Array ();
               
               if (entityDefine.mEntityCreationIds2 != null)
                  mEntitiesIndexes2 = entityDefine.mEntityCreationIds2.concat ();
               else
                  mEntitiesIndexes2 = new Array ();
               
               // to optimize: sort by creation id
               
               // special for 1-1
               if (mAssignerType == Define.EntityPairAssignerType_OneToOne && mEntitiesIndexes1 != null && mEntitiesIndexes2 != null)
               {
                  mPairHashtable = new Dictionary ();
                  mPairHashtable_IgnorePairOrder = new Dictionary ();
                  
                  var length:int = mEntitiesIndexes1.length;
                  if (length > mEntitiesIndexes2.length)
                     length = mEntitiesIndexes2.length; // some ones in array 2 will be ignored
                  
                  // create hash for fast judgement
                  
                  var id:int;
                  var id1:int;
                  var id2:int;
                  for (i = 0; i < length; ++ i)
                  {
                     id1 = mEntitiesIndexes1 [i];
                     id2 = mEntitiesIndexes2 [i];
                     
                     if (id1 >= 0 && id2 >= 0)
                     {
                        id = ((id1 & 0xFFFF) << 16) | (id2 & 0xFFFF);
                        
                        mPairHashtable [id] = 1;
                        mPairHashtable_IgnorePairOrder [id] = 1;
                        
                        if (id1 != id2)
                        {
                           id = ((id2 & 0xFFFF) << 16) | (id1 & 0xFFFF);
                           
                           mPairHashtable_IgnorePairOrder [id] = 1;
                        }
                     }
                  }
               }
            }
            else // not mIsPairSelector
            {
               if (entityDefine.mSelectorType != undefined)
                  mAssignerType = entityDefine.mSelectorType;
               else
                  mAssignerType = Define.EntitySelectorType_Many;
               
               if (entityDefine.mEntityCreationIds != undefined)
               {
                  mEntitiesIndexes1 = entityDefine.mEntityCreationIds.concat ();
                  
                  // to optimize: sort by creation id
               }
               else
               {
                  mEntitiesIndexes1 = new Array (); // avoid checkings of "mEntitiesIndexes1 == null"
               }
            }
            
            // get entities for optimizing 
            
            if (mEntitiesIndexes1 != null)
            {
               mInputEntityArray1 = new Array (mEntitiesIndexes1.length);
               for (i = 0; i < mEntitiesIndexes1.length; ++ i)
               {
                  mInputEntityArray1 [i] = mWorld.GetEntityByCreateOrderId (mEntitiesIndexes1 [i], false); // must be an entity placed in editor
               }
            }
            
            if (mEntitiesIndexes2 != null)
            {
               mInputEntityArray2 = new Array (mEntitiesIndexes2.length);
               for (i = 0; i < mEntitiesIndexes2.length; ++ i)
               {
                  mInputEntityArray2 [i] = mWorld.GetEntityByCreateOrderId (mEntitiesIndexes2 [i], false); // must be an entity placed in editor
               }
            }
         } // if (createStageId == 0)
      }
      
//==========================================================================================================
//   containing test
//==========================================================================================================
      
      //override public function ContainsEntity (entityIndex:int):Boolean
      //{
      //   if (mIsPairSelector)
      //      return false;
      //   
      //   switch (mAssignerType)
      //   {
      //      case Define.EntityAssignerType_Any:
      //         
      //         return true;
      //         
      //      case Define.EntityAssignerType_Single:
      //      case Define.EntityAssignerType_Many:
      //         
      //         if (mEntitiesIndexes1 == null)
      //            return false;
      //         
      //         return mEntitiesIndexes1.indexOf (entityIndex) >= 0; // need optimized
      //         
      //      default:
      //         return false;
      //   }
      //}
      
      override public function ContainsEntityPair (entity1:Entity, entity2:Entity, ignorePairOrder:Boolean):int
      {
         if ( ! mIsPairSelector)
            return PairContainingResult_False;
         
         var entityIndex1:int = entity1.GetCreationId ();
         var entityIndex2:int = entity2.GetCreationId ();

         switch (mAssignerType)
         {
            case Define.EntityPairAssignerType_OneToOne:
               
               // for it is hard in AS3 to create a hash key for creationIds larger than 0xFFFF.
               // so all entities should be entities placed in editor.
               
               // NOTES: here the hash id is composed with 2 cteation ids, instead of contact proxy ids.
               
               var numEntitiesInEditor:int = mWorld.GetNumEntitiesInEditor ();      
         
               if (entityIndex1 >= numEntitiesInEditor || entityIndex2 >= numEntitiesInEditor)
                  return PairContainingResult_False;
               
               // ...
               var id:int = ((entityIndex1 & 0xFFFF) << 16) | (entityIndex2 & 0xFFFF);
               
               if (mPairHashtable [id] != null)
                  return PairContainingResult_True;
               
               if (ignorePairOrder)
               {
                  id = ((entityIndex2 & 0xFFFF) << 16) | (entityIndex1 & 0xFFFF);
                  
                  return mPairHashtable_IgnorePairOrder [id] != null ? PairContainingResult_TrueButNeedExchangePairOrder : PairContainingResult_False;
               }
               
               return PairContainingResult_False;
               
            case Define.EntityPairAssignerType_ManyToMany:
               
               if (mEntitiesIndexes1 == null || mEntitiesIndexes2 == null)
                  return PairContainingResult_False;
               
               if (mEntitiesIndexes1.indexOf (entityIndex1) < 0)
               {
                  if (ignorePairOrder)
                  {
                     if (mEntitiesIndexes2.indexOf (entityIndex1) < 0)
                        return PairContainingResult_False;
                     
                     return mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? PairContainingResult_TrueButNeedExchangePairOrder : PairContainingResult_False;
                  }
                  else return PairContainingResult_False;
               }
               else
               {
                  if (mEntitiesIndexes2.indexOf (entityIndex2) >= 0)
                     return PairContainingResult_True;
                  
                  if (ignorePairOrder)
                  {
                     if (mEntitiesIndexes2.indexOf (entityIndex1) < 0)
                        return PairContainingResult_False;
                     
                     return mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? PairContainingResult_TrueButNeedExchangePairOrder : PairContainingResult_False;
                  }
                  else return PairContainingResult_False;
               }
               
            case Define.EntityPairAssignerType_BothInMany:
               
               if (mEntitiesIndexes1 == null)
                  return PairContainingResult_False;
               
               return mEntitiesIndexes1.indexOf (entityIndex1) >= 0 && mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? PairContainingResult_True : PairContainingResult_False;
               
            case Define.EntityPairAssignerType_EitherInMany:
               
               if (mEntitiesIndexes1 == null)
                  return PairContainingResult_False;
               
               return mEntitiesIndexes1.indexOf (entityIndex1) >= 0 || mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? PairContainingResult_True : PairContainingResult_False;
               
            case Define.EntityPairAssignerType_ManyToAny:
            
               if (mEntitiesIndexes1 == null)
                  return PairContainingResult_False;
            
               if (mEntitiesIndexes1.indexOf (entityIndex1) >= 0)
                  return PairContainingResult_True;
               
               if (ignorePairOrder)
                  return mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? PairContainingResult_TrueButNeedExchangePairOrder : PairContainingResult_False;
               else 
                  return PairContainingResult_False;
               
            case Define.EntityPairAssignerType_AnyToMany:
               
               if (mEntitiesIndexes2 == null)
                  return PairContainingResult_False;
               
               if (mEntitiesIndexes2.indexOf (entityIndex2) >= 0)
                  return PairContainingResult_True;
               
               if (ignorePairOrder)
                  return mEntitiesIndexes2.indexOf (entityIndex1) >= 0 ? PairContainingResult_TrueButNeedExchangePairOrder : PairContainingResult_False;
               else 
                  return PairContainingResult_False;
               
            case Define.EntityPairAssignerType_AnyToAny:
               
               return PairContainingResult_True;
               
            default:
               return PairContainingResult_False;
         }
      }
      
//==========================================================================================================
//   register handlers for entities
//==========================================================================================================
      
      // as input of an event handler
      override public function RegisterEventHandlerForEntitiesPlacedInEditor (eventId:int, eventHandler:EntityEventHandler):void
      {
         if (mIsPairSelector)
            return;
         
         if (mAssignerType == Define.EntitySelectorType_Any)
         {
            _RegisterEventHandlerForEntitiesPlacedInEditor (null, eventId, eventHandler);
         }
         else // if (mAssignerType == Define.EntitySelectorType_Single || mAssignerType == Define.EntitySelectorType_Many)
         {
            var count:int = mEntitiesIndexes1.length;
            
            for (var i:int = 0; i < count; ++ i)
            {
               // only support entities placed in editor now
               
               var entity:Entity = mWorld.GetEntityByCreateOrderId (mEntitiesIndexes1 [i], false);
               if (entity == null || entity.IsDestroyedAlready ())
                  continue;
               
               entity.RegisterEventHandler (eventId, eventHandler);
            }
         }
      }
      
      // as input of an event handler
      override public function RegisterEventHandlerForRuntimeCreatedEntity (entity:Entity, eventId:int, eventHandler:EntityEventHandler):void
      {
         if (mAssignerType == Define.EntitySelectorType_Any)
         {
            entity.RegisterEventHandler (eventId, eventHandler);
         }
      }
      
//==========================================================================================================
//   as input of task entities
//==========================================================================================================
      
      // as input of a task entity
      // Define.EntitySelectorType_Any: is not supported
      override public function GetEntityListTaskStatus ():int
      {
         if (mIsPairSelector)
            return ValueDefine.TaskStatus_Unfinished;
         
         if (mAssignerType == Define.EntitySelectorType_Any)
         {
            return AggregateEntityListTaskStatus (mWorld.GetEntityList (), null);
         }
         else // if (mAssignerType == Define.EntitySelectorType_Single || mAssignerType == Define.EntitySelectorType_Many)
         {
            var numUndertermineds:int = 0;
            
            var count:int = mInputEntityArray1.length;
            var entity:Entity;
            var i:int = 0;
            while (i < count)
            {
               entity = mInputEntityArray1 [i];
               if (entity == null) // || entity.IsDestroyedAlready ()) // bug: destroyed entities still contribute in the final task aggregating result. 
               {
                  // commented off for potential bugs
                  //mInputEntityArray1.splice (i, 1);
                  //-- count;
               }
               else
               {
                  ++ i;
                  
                  if (entity.IsTaskFailed ())
                     return ValueDefine.TaskStatus_Failed;
                  else if (entity.IsTaskUnfinished ())
                     ++ numUndertermineds;
               }
            }
            
            if (numUndertermineds > 0)
               return ValueDefine.TaskStatus_Unfinished;
            else
               return ValueDefine.TaskStatus_Successed;
         }
      }
      
//==========================================================================================================
//   as input of timer event handlers
//==========================================================================================================
      
      override public function HandleTimerEventForEntities (timerEventHandler:EntityEventHandler_Timer, valueSourceList:Parameter):void
      {
         if (mIsPairSelector)
            return;
         
         if (mAssignerType == Define.EntitySelectorType_Any)
         {
            HandleTimerEventForEntityList (mWorld.GetEntityList (), null, timerEventHandler, valueSourceList);
         }
         else // if (mAssignerType == Define.EntitySelectorType_Single || mAssignerType == Define.EntitySelectorType_Many)
         {
            var valueSourceEntity:Parameter_Direct = valueSourceList.mNextParameter as Parameter_Direct;
            
            var count:int = mInputEntityArray1.length;
            var entity:Entity;
            var i:int = 0;
            while (i < count)
            {
               entity = mInputEntityArray1 [i];
               if (entity == null || entity.IsDestroyedAlready ()) // bug ! 
               {
                  // commented off for potential bugs
                  //mInputEntityArray1.splice (i, 1);
                  //-- count;
               }
               else
               {
                  ++ i;
                  
                  valueSourceEntity.mValueObject = entity;
                  
                  timerEventHandler.HandleEvent (valueSourceList);
               }
            }
         }
      }
      
      override public function HandleTimerEventForEntityPairs (timerEventHandler:EntityEventHandler_Timer, valueSourceList:Parameter):void
      {
         if (! mIsPairSelector)
            return;
         
         var valueSourceEntity1:Parameter_Direct = valueSourceList.mNextParameter as Parameter_Direct;
         var valueSourceEntity2:Parameter_Direct = valueSourceEntity1.mNextParameter as Parameter_Direct;
         
         var entity1:Entity;
         var entity2:Entity;
         
         var num1:int;
         var num2:int;
         var i:int;
         var j:int;
         
         switch (mAssignerType)
         {
            case Define.EntityPairAssignerType_OneToOne:
               num1 = mInputEntityArray1.length;
               num2 = mInputEntityArray2.length;
               num1 = num1 < num2 ? num1 : num2;
               
               while (i < num1)
               {
                  entity1 = mInputEntityArray1 [i];
                  entity2 = mInputEntityArray2 [i];
                  
                  if (entity1 == null  || entity1.IsDestroyedAlready ()
                     || entity2 == null || entity2.IsDestroyedAlready ())
                  {
                     // commented off for potential bugs
                     //mInputEntityArray1.splice (i, 1);
                     //mInputEntityArray2.splice (i, 1);
                     //
                     //-- num1;
                  }
                  else
                  {
                     ++ i;
                     
                     valueSourceEntity1.mValueObject = entity1;
                     valueSourceEntity2.mValueObject = entity2;
                     
                     // it is possible entity1 == entity2, this is not prevented now
                     
                     timerEventHandler.HandleEvent (valueSourceList);
                  }
               }
               
               break;
            case Define.EntityPairAssignerType_ManyToMany:
               num1 = mInputEntityArray1.length;
               num2 = mInputEntityArray2.length;
               
               // commented off for potential bugs
               //j = 0;
               //while (j < num2)
               //{
               //   entity2 = mInputEntityArray2 [j];
               //   
               //   if (entity2 == null || entity2.IsDestroyedAlready ())
               //   {
               //      mInputEntityArray2.splice (j, 1);
               //      -- num2;
               //   }
               //   else
               //   {
               //      ++ j;
               //   }
               //}
               
               while (i < num1)
               {
                  entity1 = mInputEntityArray1 [i];
                  
                  if (entity1 == null || entity1.IsDestroyedAlready ())
                  {
                     // commented off for potential bugs
                     //mInputEntityArray1.splice (i, 1);
                     //-- num1;
                  }
                  else
                  {
                     ++ i;
                     
                     for (j = 0; j < num2; ++ j)
                     {
                        entity2 = mInputEntityArray2 [j];
                        
                        if (entity2 == null || entity2.IsDestroyedAlready ())
                        {
                           // do nothing
                        }
                        else
                        {
                           valueSourceEntity1.mValueObject = entity1;
                           valueSourceEntity2.mValueObject = entity2;
                           
                           // it is possible entity1 == entity2, this is not prevent now
                           
                           timerEventHandler.HandleEvent (valueSourceList);
                        }
                     }
                  }
               }
               
               break;
            case Define.EntityPairAssignerType_BothInMany:
               num1 = mInputEntityArray1.length;
               
               // commented off for potential bugs
               //i = 0;
               //while (i < num1)
               //{
               //   entity1 = mInputEntityArray1 [i];
               //   
               //   if (entity1 == null || entity1.IsDestroyedAlready ())
               //   {
               //      mInputEntityArray1.splice (i, 1);
               //      -- num1;
               //   }
               //   else
               //   {
               //      ++ i;
               //   }
               //}
               
               for (i = 0; i < num1; ++ i)
               {
                  entity1 = mInputEntityArray1 [i];
                  
                  if (entity1 == null || entity1.IsDestroyedAlready ())
                  {
                  }
                  else
                  {
                     //for (j = i; j < num1; ++ j)
                     for (j = i + 1; j < num1; ++ j) // from v1.56
                     {
                        entity2 = mInputEntityArray1 [j];
                        
                        if (entity2 == null || entity2.IsDestroyedAlready ())
                        {
                        }
                        else
                        {
                           valueSourceEntity1.mValueObject = entity1;
                           valueSourceEntity2.mValueObject = entity2;
                           
                           // it is possible entity1 == entity2, this is not prevented now
                           
                           timerEventHandler.HandleEvent (valueSourceList);
                        }
                     }
                  }
               }
               
               break;
            
            // the following types are not support for entity-pair-timer event handlers now.
            // if later they are supported, it is best to add an option "enabled any-type selector for entity-pair-timer event handlers" 
            
            case Define.EntityPairAssignerType_EitherInMany:
               
               break;
            case Define.EntityPairAssignerType_ManyToAny:
            case Define.EntityPairAssignerType_AnyToMany:
               
               // Note the order
               
               break;
            case Define.EntityPairAssignerType_AnyToAny:
               
               break;
            default:
               break;
         }
      }
   }
}
