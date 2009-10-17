package player.trigger.entity
{
   import flash.utils.Dictionary;
   
   import player.world.World;
   import player.entity.Entity;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.ValueDefine;
   
   import common.Define;
   
   public class EntityInputEntityAssigner extends EntityLogic
   {
      protected var mIsPairAssigner:Boolean = false;
      
      protected var mAssignerType:int; // if isPair, pair type
      protected var mPairOrderImportant:Boolean = false; // only for mIsPairAssigner == true
      
      // the indexes are indexes in editor
      protected var mEntitiesIndexes1:Array = null;
      protected var mEntitiesIndexes2:Array = null;
      
      // for 1-1 optimizing
      protected var mPairHashtable:Dictionary = null;
      protected var mPairHashtable_IgnorePairOrder:Dictionary = null;
      
      // 
      public function EntityInputEntityAssigner (world:World, isPairAssigner:Boolean)
      {
         super (world);
         
         mIsPairAssigner = isPairAssigner;
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         if (mIsPairAssigner)
            mAssignerType = params.mPairingType;
         else
            mAssignerType = params.mSelectorType;
      }
      
      public function SetEntityIndexes (entityIndexes:Array):void
      {
         mEntitiesIndexes1 = entityIndexes;
         
         // to optimize: sort by entityIdInEditor
      }
      
      public function SetEntityPairIndexes (entityIndexes1:Array, entityIndexes2:Array):void
      {
         mEntitiesIndexes1 = entityIndexes1;
         mEntitiesIndexes2 = entityIndexes2;
         
         // to optimize: sort by entityIdInEditor
         
         // for 1-1
         if (mAssignerType == Define.EntityPairAssignerType_OneToOne && entityIndexes1 != null && entityIndexes2 != null)
         {
            mPairHashtable = new Dictionary ();
            mPairHashtable_IgnorePairOrder = new Dictionary ();
            
            var length:int = entityIndexes1.length;
            if (length > entityIndexes2.length)
            {
               length = entityIndexes2.length;
            }
            
            var id:int;
            var id1:int;
            var id2:int;
            for (var i:int = 0; i < length; ++ i)
            {
               id1 = entityIndexes1 [i];
               id2 = entityIndexes2 [i];
               id = ((id1 & 0xFFFF) << 16) | (id2 & 0xFFFF);
               
               mPairHashtable [id] = 1;
               mPairHashtable_IgnorePairOrder [id] = 1;
               
               id = ((id2 & 0xFFFF) << 16) | (id1 & 0xFFFF);
               
               mPairHashtable_IgnorePairOrder [id] = 1;
            }
         }
      }
      
      public function ContainsEntity (entityIndex:int):Boolean
      {
         if (mIsPairAssigner)
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
         if ( ! mIsPairAssigner)
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
      
      // as input of a task entity
      public function UpdateEntityTaskStatus ():int
      {
         return ValueDefine.TaskStatus_Undetermined;
      }
      
      // as input of an event handler
      public function RegisterEntityEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         if (mIsPairAssigner)
            return;
         
         var i:int;
         var count:int;
         switch (mAssignerType)
         {
            case Define.EntitySelectorType_Single:
            case Define.EntitySelectorType_Many:
               trace ("mEntitiesIndexes1 = " + mEntitiesIndexes1);
               if (mEntitiesIndexes1 != null)
               {
                  count = mEntitiesIndexes1.length;
                  
                  trace ("count = " + count);
                  
                  for (i = 0; i < count; ++ i)
                  {
                     mWorld.GetEntityByIndexInEditor (mEntitiesIndexes1 [i]).RegisterEventHandler (eventId, eventHandler);
                  }
               }
               break;
            case Define.EntitySelectorType_Any:
               count = mWorld.GetNumEntitiesInEditor ();
               for (i = 0; i < count; ++ i)
               {
                  mWorld.GetEntityByIndexInEditor (i).RegisterEventHandler (eventId, eventHandler);
               }
               break;
            default:
               break;
         }
      }
      
//==========================================================================================================
// 
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
   }
}