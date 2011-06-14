package player.trigger.entity
{
   import flash.utils.Dictionary;
   
   import player.world.World;
   import player.world.EntityList;
   
   import player.entity.Entity;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionDefine;
   import common.trigger.ValueDefine;
   
   import common.TriggerFormatHelper2;
   
   public class EntityInputEntityFilter extends EntitySelector
   {
      public var mFilterDefinition:FunctionDefinition_Custom;
      public var mName:String = null;
      
      public function EntityInputEntityFilter (world:World, isPairFilter:Boolean)
      {
         super (world, isPairFilter);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mFunctionDefine != undefined)
            {
               var codeSnippetDefine:CodeSnippetDefine = ((entityDefine.mFunctionDefine as FunctionDefine).mCodeSnippetDefine as CodeSnippetDefine).Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
               
               if (mIsPairSelector)
                  mFilterDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (entityDefine.mFunctionDefine, TriggerEngine.GetEntityPairFilterFunctionDeclaration ());
               else
                  mFilterDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (entityDefine.mFunctionDefine, TriggerEngine.GetEntityFilterFunctionDeclaration ());
               
               mFilterDefinition.SetCodeSnippetDefine (codeSnippetDefine);
            }
         }
      }
      
//=============================================================
//   evaluate
//=============================================================
      
      // todo, seems it is ok to use parameters like that in contact event handling.
      // currently, ApplyNewDirectParameter and ReleaseDirectParameter are some not very efficient.
      
      public function DoFilterEntity (entity:Entity):Boolean
      {
         var outputValueTarget:Parameter_Direct = TriggerEngine.ApplyNewDirectParameter (false, null);
         var inputValueSource:Parameter_Direct = TriggerEngine.ApplyNewDirectParameter (entity, null);
         
         // if (mFilterDefinition != null) // should not be null
         mFilterDefinition.DoCall (inputValueSource, outputValueTarget);
         
         TriggerEngine.ReleaseDirectParameter_Source (inputValueSource);
         return TriggerEngine.ReleaseDirectParameter_Target (outputValueTarget) as Boolean;
      }

      public function DoFilterEntityPair (entity1:Entity, entity2:Entity):Boolean
      {
         var outputValueTarget:Parameter_Direct = TriggerEngine.ApplyNewDirectParameter (false, null);
         var inputValueSource1:Parameter_Direct = TriggerEngine.ApplyNewDirectParameter (entity2, null);
         var inputValueSource0:Parameter_Direct = TriggerEngine.ApplyNewDirectParameter (entity1, inputValueSource1);
         
         // if (mFilterDefinition != null) // should not be null
         mFilterDefinition.DoCall (inputValueSource0, outputValueTarget);
         
         TriggerEngine.ReleaseDirectParameter_Source (inputValueSource0);
         TriggerEngine.ReleaseDirectParameter_Source (inputValueSource1);
         return TriggerEngine.ReleaseDirectParameter_Target (outputValueTarget) as Boolean;
      }

//==========================================================================================================
//   containing test
//==========================================================================================================
      
      //override public function ContainsEntity (entityIndex:int):Boolean
      //{
      //   if (mIsPairSelector)
      //      return false;
      //   
      //   return DoFilterEntity (mWorld.GetEntityByCreateOrderId (entityIndex, true));
      //}
      
      override public function ContainsEntityPair (entity1:Entity, entity2:Entity, ignorePairOrder:Boolean):int
      {
         if ( ! mIsPairSelector)
            return PairContainingResult_False;
            
         if (DoFilterEntityPair (entity1, entity2))
            return PairContainingResult_True;
         
         if (ignorePairOrder && DoFilterEntityPair (entity2, entity1))
            return PairContainingResult_TrueButNeedExchangePairOrder;
         
         return PairContainingResult_False;
      }
      
//==========================================================================================================
//   register handlers for entities, for entities placed in editor only
//==========================================================================================================

      // as input of an event handler
      override public function RegisterEventHandlerForEntitiesPlacedInEditor (eventId:int, eventHandler:EntityEventHandler):void
      {
         if (mIsPairSelector)
            return;
         
         _RegisterEventHandlerForEntitiesPlacedInEditor (DoFilterEntity, eventId, eventHandler);
      }
      
      // as input of an event handler
      override public function RegisterEventHandlerForRuntimeCreatedEntity (entity:Entity, eventId:int, eventHandler:EntityEventHandler):void
      {
         if (DoFilterEntity (entity))
         {
            entity.RegisterEventHandler (eventId, eventHandler);
         }
      }
      
//==========================================================================================================
//   as input of task entities
//==========================================================================================================

      // as input of a task entity
      override public function GetEntityListTaskStatus ():int
      {
         if (mIsPairSelector)
            return ValueDefine.TaskStatus_Unfinished;
      
         return AggregateEntityListTaskStatus (mWorld.GetEntityList (), DoFilterEntity);
      }
      
//==========================================================================================================
//   as input of timer event handlers
//==========================================================================================================
      
      override public function HandleTimerEventForEntities (timerEventHandler:EntityEventHandler_Timer, valueSourceList:Parameter):void
      {
         if (mIsPairSelector)
            return;
         
         HandleTimerEventForEntityList (mWorld.GetEntityList (), DoFilterEntity, timerEventHandler, valueSourceList);
      }
      
      override public function HandleTimerEventForEntityPairs (timerEventHandler:EntityEventHandler_Timer, valueSourceList:Parameter):void
      {
         if (! mIsPairSelector)
            return;
            
         // script filter is not support for entity-pair-timer event handlers now.
         // if later they are supported, it is best to add an option "enabled script selector for entity-pair-timer event handlers" 

         return; // currently, script filter doesn't support entity-pair-timer event handler.
      }
   }
}
