package player.trigger.entity
{
   import flash.utils.Dictionary;
   
   import player.world.World;
   import player.entity.Entity;
   
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Direct;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.ValueDefine;
   
   import common.Define;
   
   public class EntityInputEntityAssigner extends EntityInputEntityLimiter
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
            if (mIsPairLimiter)
            {
               if (entityDefine.mPairingType != undefined)
                  mAssignerType = entityDefine.mPairingType;
               else
                  mAssignerType = Define.EntityPairAssignerType_OneToOne;
               
               if (entityDefine.mEntityCreationIds1 != undefined)
                  mEntitiesIndexes1 = entityDefine.mEntityCreationIds1;
               else
                  mEntitiesIndexes1 = new Array ();
               
               if (entityDefine.mEntityCreationIds2 != null)
                  mEntitiesIndexes2 = entityDefine.mEntityCreationIds2;
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
                  {
                     length = mEntitiesIndexes2.length;
                  }
                  
                  var id:int;
                  var id1:int;
                  var id2:int;
                  for (i = 0; i < length; ++ i)
                  {
                     id1 = mEntitiesIndexes1 [i];
                     id2 = mEntitiesIndexes2 [i];
                     id = ((id1 & 0xFFFF) << 16) | (id2 & 0xFFFF);
                     
                     mPairHashtable [id] = 1;
                     mPairHashtable_IgnorePairOrder [id] = 1;
                     
                     id = ((id2 & 0xFFFF) << 16) | (id1 & 0xFFFF);
                     
                     mPairHashtable_IgnorePairOrder [id] = 1;
                  }
               }
            }
            else // not mIsPairLimiter
            {
               if (entityDefine.mSelectorType != undefined)
                  mAssignerType = entityDefine.mSelectorType;
               else
                  mAssignerType = Define.EntitySelectorType_Many;
               
               if (entityDefine.mEntityCreationIds != undefined)
               {
                  mEntitiesIndexes1 = entityDefine.mEntityCreationIds;
                  
                  // to optimize: sort by creation id
               }
               else
               {
                  mEntitiesIndexes1 = new Array ();
               }
            }
            
            // get entities
            
            if (mEntitiesIndexes1 != null)
            {
               mInputEntityArray1 = new Array (mEntitiesIndexes1.length);
               for (i = 0; i < mEntitiesIndexes1.length; ++ i)
               {
                  mInputEntityArray1 [i] = mWorld.GetEntityByCreationId (mEntitiesIndexes1 [i]);
               }
            }
            
            if (mEntitiesIndexes2 != null)
            {
               mInputEntityArray2 = new Array (mEntitiesIndexes2.length);
               for (i = 0; i < mEntitiesIndexes2.length; ++ i)
               {
                  mInputEntityArray2 [i] = mWorld.GetEntityByCreationId (mEntitiesIndexes2 [i]);
               }
            }
         } // if (createStageId == 0)
      }
      
//==========================================================================================================
//   containing test
//==========================================================================================================
      
      public function ContainsEntity (entityIndex:int):Boolean
      {
         if (mIsPairLimiter)
            return false;
         
         switch (mAssignerType)
         {
            case Define.EntityAssignerType_Any:
               
               return true;
               
            case Define.EntityAssignerType_Single:
            case Define.EntityAssignerType_Many:
               
               if (mEntitiesIndexes1 == null)
                  return false;
               
               return mEntitiesIndexes1.indexOf (entityIndex) >= 0; // need optimized
               
            default:
               return false;
         }
      }
      
      public function ContainsEntityPair (entityIndex1:int, entityIndex2:int, ignorePairOrder:Boolean):int
      {
         if ( ! mIsPairLimiter)
            return ContainingResult_False;
         
         var p1:int;
         var p2:int;
         
         switch (mAssignerType)
         {
            case Define.EntityPairAssignerType_OneToOne:
               
               var id:int = ((entityIndex1 & 0xFFFF) << 16) | (entityIndex2 & 0xFFFF);
               
               if (mPairHashtable [id] != null)
                  return ContainingResult_True;
               
               if (ignorePairOrder)
               {
                  id = ((entityIndex2 & 0xFFFF) << 16) | (entityIndex1 & 0xFFFF);
                  
                  return mPairHashtable_IgnorePairOrder [id] != null ? ContainingResult_TrueButNeedExchangePairOrder : ContainingResult_False;
               }
               
               return ContainingResult_False;
               
            case Define.EntityPairAssignerType_ManyToMany:
               
               if (mEntitiesIndexes1 == null || mEntitiesIndexes2 == null)
                  return ContainingResult_False;
               
               if (mEntitiesIndexes1.indexOf (entityIndex1) < 0)
               {
                  if (ignorePairOrder)
                  {
                     if (mEntitiesIndexes2.indexOf (entityIndex1) < 0)
                        return ContainingResult_False;
                     
                     return mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? ContainingResult_TrueButNeedExchangePairOrder : ContainingResult_False;
                  }
                  else return ContainingResult_False;
               }
               else
               {
                  if (mEntitiesIndexes2.indexOf (entityIndex2) >= 0)
                     return ContainingResult_True;
                  
                  if (ignorePairOrder)
                  {
                     if (mEntitiesIndexes2.indexOf (entityIndex1) < 0)
                        return ContainingResult_False;
                     
                     return mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? ContainingResult_TrueButNeedExchangePairOrder : ContainingResult_False;
                  }
                  else return ContainingResult_False;
               }
               
            case Define.EntityPairAssignerType_ManyToAny:
               
               if (mEntitiesIndexes1 == null)
                  return ContainingResult_False;
               
               if (mEntitiesIndexes1.indexOf (entityIndex1) >= 0)
                  return ContainingResult_True;
               
               if (ignorePairOrder)
                  return mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? ContainingResult_TrueButNeedExchangePairOrder : ContainingResult_False;
               else 
                  return ContainingResult_False;
               
            case Define.EntityPairAssignerType_AnyToMany:
               
               if (mEntitiesIndexes2 == null)
                  return ContainingResult_False;
               
               if (mEntitiesIndexes2.indexOf (entityIndex2) >= 0)
                  return ContainingResult_True;
               
               if (ignorePairOrder)
                  return mEntitiesIndexes2.indexOf (entityIndex1) >= 0 ? ContainingResult_TrueButNeedExchangePairOrder : ContainingResult_False;
               else 
                  return ContainingResult_False;
               
            case Define.EntityPairAssignerType_AnyToAny:
               
               return ContainingResult_True;
               
            case Define.EntityPairAssignerType_EitherInMany:
               
               if (mEntitiesIndexes1 == null)
                  return ContainingResult_False;
               
               return mEntitiesIndexes1.indexOf (entityIndex1) >= 0 || mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? ContainingResult_True : ContainingResult_False;
               
            case Define.EntityPairAssignerType_BothInMany:
               
               if (mEntitiesIndexes1 == null)
                  return ContainingResult_False;
               
               return mEntitiesIndexes1.indexOf (entityIndex1) >= 0 && mEntitiesIndexes1.indexOf (entityIndex2) >= 0 ? ContainingResult_True : ContainingResult_False;
               
            default:
               return ContainingResult_False;
         }
      }
      
//==========================================================================================================
//   as input of eneral entity event handlers
//==========================================================================================================
      
      // as input of an event handler
      public function RegisterEventHandlerForEntities (eventId:int, eventHandler:EntityEventHandler):void
      {
         if (mIsPairLimiter)
            return;
         
         var i:int;
         var count:int;
         switch (mAssignerType)
         {
            case Define.EntitySelectorType_Single:
            case Define.EntitySelectorType_Many:
               if (mEntitiesIndexes1 != null)
               {
                  count = mEntitiesIndexes1.length;
                  
                  for (i = 0; i < count; ++ i)
                  {
                     mWorld.GetEntityByCreationId (mEntitiesIndexes1 [i]).RegisterEventHandler (eventId, eventHandler);
                  }
               }
               break;
            case Define.EntitySelectorType_Any:
               count = mWorld.GetNumEntitiesInEditor ();
               for (i = 0; i < count; ++ i)
               {
                  mWorld.GetEntityByCreationId (i).RegisterEventHandler (eventId, eventHandler);
               }
               break;
            default:
               break;
         }
      }
      
//==========================================================================================================
//   as input of contact event handlers
//==========================================================================================================
      
      public static const ContainingResult_False:int = 0;
      public static const ContainingResult_True:int = 1;
      public static const ContainingResult_TrueButNeedExchangePairOrder:int = 2;
      
      public static function GetContainingEntityPairResult (assignerListHead:ListElement_InputEntityAssigner, entityId1:int, entityId2:int, ignorePairOrder:Boolean = true):int
      {
         var list_element:ListElement_InputEntityAssigner = assignerListHead;
         var result:int;
         
         while (list_element != null)
         {
            result = list_element.mInputEntityAssigner.ContainsEntityPair (entityId1, entityId2, ignorePairOrder);
            
            if (result != ContainingResult_False)
               return result;
            
            list_element = list_element.mNextListElement;
         }
         
         return ContainingResult_False;
      }
      
      public static function GetContainingEntityResult (assignerListHead:ListElement_InputEntityAssigner, entityId:int):int
      {
         return ContainingResult_False;
      }
      
//==========================================================================================================
//   as input of task entities
//==========================================================================================================
      
      // as input of a task entity
      public function GetEntityListTaskStatus ():int
      {
         if (mEntityList == null)
            return ValueDefine.TaskStatus_Unfinished;
         
         var numUndertermineds:int = 0;
         
         var num:int = mInputEntityArray1.length;
         var entity:Entity;
         var i:int = 0;
         while (i < num)
         {
            entity = mInputEntityArray1 [i];
            if (entity == null)
            {
               mInputEntityArray1.splice (i, 1);
               -- num;
            }
            else if (entity.IsDestroyedAlready ())
            {
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
      
//==========================================================================================================
//   as input of timer event handlers
//==========================================================================================================
      
      public function HandleTimerEventForEntities (timerEventHandler:EntityEventHandler_Timer, valueSourceList:ValueSource):void
      {
         if (mIsPairLimiter)
            return;
         
         var valueSourceEntity:ValueSource_Direct = valueSourceList.mNextValueSourceInList as ValueSource_Direct;
         
         var num:int = mInputEntityArray1.length;
         var entity:Entity;
         var i:int = 0;
         while (i < num)
         {
            entity = mInputEntityArray1 [i];
            if (entity == null) // || entity.IsDestroyedAlready ())
            {
               mInputEntityArray1.splice (i, 1);
               -- num;
            }
            else
            {
               ++ i;
               
               valueSourceEntity.mValueObject = entity;
               
               timerEventHandler.HandleEvent (valueSourceList);
            }
         }
      }
      
      public function HandleTimerEventForEntityPairs (timerEventHandler:EntityEventHandler_Timer, valueSourceList:ValueSource):void
      {
         if (! mIsPairLimiter)
            return;
         
         var valueSourceEntity1:ValueSource_Direct = valueSourceList.mNextValueSourceInList as ValueSource_Direct;
         var valueSourceEntity2:ValueSource_Direct = valueSourceEntity1.mNextValueSourceInList as ValueSource_Direct;
         
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
                  
                  if (entity1 == null // || entity1.IsDestroyedAlready ()
                     || entity2 == null) // || entity2.IsDestroyedAlready ())
                  {
                     mInputEntityArray1.splice (i, 1);
                     mInputEntityArray2.splice (i, 1);
                     
                     -- num1;
                  }
                  else
                  {
                     ++ i;
                     
                     valueSourceEntity1.mValueObject = entity1;
                     valueSourceEntity2.mValueObject = entity2;
                     
                     timerEventHandler.HandleEvent (valueSourceList);
                  }
               }
               
               break;
            case Define.EntityPairAssignerType_ManyToMany:
               num1 = mInputEntityArray1.length;
               num2 = mInputEntityArray2.length;
               
               j = 0;
               while (j < num2)
               {
                  entity2 = mInputEntityArray2 [j];
                  
                  if (entity2 == null) // || entity2.IsDestroyedAlready ())
                  {
                     mInputEntityArray2.splice (j, 1);
                     -- num2;
                  }
                  else
                  {
                     ++ j;
                  }
               }
               
               while (i < num1)
               {
                  entity1 = mInputEntityArray1 [i];
                  
                  if (entity1 == null) // || entity1.IsDestroyedAlready ())
                  {
                     mInputEntityArray1.splice (i, 1);
                     -- num1;
                  }
                  else
                  {
                     ++ i;
                     
                     for (j = 0; j < num2; ++ j)
                     {
                        entity2 = mInputEntityArray2 [j];
                        
                        valueSourceEntity1.mValueObject = entity1;
                        valueSourceEntity2.mValueObject = entity2;
                        
                        timerEventHandler.HandleEvent (valueSourceList);
                     }
                  }
               }
               
               break;
            case Define.EntityPairAssignerType_BothInMany:
               num1 = mInputEntityArray1.length;
               
               i = 0;
               while (i < num1)
               {
                  entity1 = mInputEntityArray1 [i];
                  
                  if (entity1 == null) // || entity1.IsDestroyedAlready ())
                  {
                     mInputEntityArray1.splice (i, 1);
                     -- num1;
                  }
                  else
                  {
                     ++ i;
                  }
               }
               
               for (i = 0; i < num1; ++ i)
               {
                  entity1 = mInputEntityArray1 [i];
                  
                  for (j = i; j < num1; ++ j)
                  {
                     entity2 = mInputEntityArray1 [j];
                     
                     valueSourceEntity1.mValueObject = entity1;
                     valueSourceEntity2.mValueObject = entity2;
                     
                     timerEventHandler.HandleEvent (valueSourceList);
                  }
               }
               
               break;
            default:
               break;
         }
      }
   }
}
