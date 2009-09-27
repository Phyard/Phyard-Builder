package player.trigger.entity
{
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
      
      public function SetEntityIndexes1 (entityIndexes:Array):void
      {
         mEntitiesIndexes1 = entityIndexes;
         
         // sort by entityIdInEditor
      }
      
      public function SetEntityIndexes2 (entityIndexes:Array):void
      {
         mEntitiesIndexes2 = entityIndexes;
         
         // sort by entityIdInEditor
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
      trace ("mIsPairAssigner = " + mIsPairAssigner + ", mAssignerType = " + mAssignerType);
      
         if ( ! mIsPairAssigner)
            return ContainingResult_False;
         
         var p1:int;
         var p2:int;
         
         switch (mAssignerType)
         {
            case Define.EntityPairAssignerType_OneToOne:
               
               if (mEntitiesIndexes1 == null || mEntitiesIndexes2 == null)
                  return ContainingResult_False;
               
               p1 = mEntitiesIndexes1.indexOf (entityIndex1);
               if (p1 < 0)
               {
                  if (ignorePairOrder)
                  {
                     p1 = mEntitiesIndexes2.indexOf (entityIndex1);
                     
                     if (p1 < 0)
                        return ContainingResult_False;
                     
                     return p1 == mEntitiesIndexes1.indexOf (entityIndex2) ? ContainingResult_TrueButNeedExchangePairOrder : ContainingResult_False;
                  }
                  else return ContainingResult_False;
               }
               else
               {
                  if (p1 == mEntitiesIndexes2.indexOf (entityIndex2))
                     return ContainingResult_True;
                  
                  if (ignorePairOrder)
                  {
                     p1 = mEntitiesIndexes2.indexOf (entityIndex1);
                     
                     if (p1 < 0)
                        return ContainingResult_False;
                     
                     return p1 == mEntitiesIndexes1.indexOf (entityIndex2) ? ContainingResult_TrueButNeedExchangePairOrder : ContainingResult_False;
                  }
                  else return ContainingResult_False;
               }
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
      
      public function UpdateEntityTaskStatus ():int
      {
         return ValueDefine.TaskStatus_Undetermined;
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