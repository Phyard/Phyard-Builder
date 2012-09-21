package player.trigger.entity
{
   import player.world.World;

   import player.entity.Entity;

   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   import player.trigger.Parameter;

   import player.trigger.data.ListElement_EntitySelector;

   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionDefine;

   import common.trigger.CoreEventIds;
   import common.trigger.CoreEventDeclarations;

   import common.TriggerFormatHelper2;

   public class EntityEventHandler extends EntityLogic
   {
      //public var mNextEntityEventHandlerOfTheSameType:EntityEventHandler = null;

      public var mExternalCondition:ConditionAndTargetValue = null;

      public var mFirstEntitySelector:ListElement_EntitySelector = null;

      protected var mEventId:int = CoreEventIds.ID_Invalid;
      public var mEventHandlerDefinition:FunctionDefinition_Custom = null;

      public var mExternalAction:EntityAction = null;

      public function EntityEventHandler (world:World)
      {
         super (world);
      }

      public function GetEventId ():int
      {
         return mEventId;
      }

      override protected function CanBeDisabled ():Boolean
      {
         return true;
      }

//=============================================================
//   create
//=============================================================

      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);

         if (createStageId == 0)
         {
            if (entityDefine.mEventId != undefined)
            {
               mEventId = int (entityDefine.mEventId);
            }

            if (entityDefine.mFunctionDefine != undefined)
            {
               // ! clone is important
               var codeSnippetDefine:CodeSnippetDefine = ((entityDefine.mFunctionDefine as FunctionDefine).mCodeSnippetDefine as CodeSnippetDefine).Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());

               mEventHandlerDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (entityDefine.mFunctionDefine, CoreEventDeclarations.GetCoreEventHandlerDeclarationById (mEventId));
               mEventHandlerDefinition.SetCodeSnippetDefine (codeSnippetDefine, extraInfos);
            }

            // external condition
            if (entityDefine.mInputConditionEntityCreationId != undefined && entityDefine.mInputConditionTargetValue != undefined)
            {
               // must be an entity placed in editor
               //var conditionEntity:EntityCondition = mWorld.GetEntityByCreateOrderId (entityDefine.mInputConditionEntityCreationId, false) as EntityCondition;
               
               // from v2.02, merging scene is added
               var conditionEntityId:int = entityDefine.mInputConditionEntityCreationId as int;
               if (conditionEntityId >= 0)
                  conditionEntityId = extraInfos.mEntityIdCorrectionTable [conditionEntityId];
               var conditionEntity:EntityCondition = mWorld.GetEntityByCreateOrderId (conditionEntityId, true) as EntityCondition;
                                                               // may be runtime created entities
               
               if (conditionEntity != null)
               {
                  mExternalCondition =  new ConditionAndTargetValue (conditionEntity, entityDefine.mInputConditionTargetValue);
               }
            }

            if (entityDefine.mExternalActionEntityCreationId != undefined)
            {
               // must be an entity placed in editor
               //mExternalAction = mWorld.GetEntityByCreateOrderId (entityDefine.mExternalActionEntityCreationId, false) as EntityAction;
               
               // from v2.02, merging scene is added
               var actionEntityId:int = entityDefine.mExternalActionEntityCreationId as int;
               if (actionEntityId >= 0)
                  actionEntityId = extraInfos.mEntityIdCorrectionTable [actionEntityId];
               mExternalAction = mWorld.GetEntityByCreateOrderId (actionEntityId, true) as EntityAction;
                                                               // may be runtime created entities
            }
         }
         else if (createStageId == 1) // somthing to do after all EntitySelectors are created with stageId=0
         {
            // entity (pair) assigners
            if (entityDefine.mInputAssignerCreationIds != undefined)
            {
               var assignerEntityIndexes:Array = entityDefine.mInputAssignerCreationIds; //.concat ();
               var newElement:ListElement_EntitySelector;

               for (var i:int = assignerEntityIndexes.length - 1; i >= 0; -- i)
               {
                  // must be an entity placed in editor
                  //newElement = new ListElement_EntitySelector (mWorld.GetEntityByCreateOrderId (int(assignerEntityIndexes [i]), false) as EntitySelector);
                  
                  var assignerEntityIndex:int = assignerEntityIndexes [i] as int;
                  if (assignerEntityIndex >= 0)
                     assignerEntityIndex = extraInfos.mEntityIdCorrectionTable [assignerEntityIndex];
                  newElement = new ListElement_EntitySelector (mWorld.GetEntityByCreateOrderId (assignerEntityIndex, true) as EntitySelector);
                                                               // may be runtime created entities
                  newElement.mNextListElement = mFirstEntitySelector;
                  mFirstEntitySelector = newElement;
               }
            }

            mWorld.RegisterEventHandler (mEventId, this);

            // register self
            //RegisterToEntityEventHandlerLists (); // now moved into DetaFormat2.WorldDefine2PlayerWorld ()
         }
      }

//=============================================================
//   register to entity
//=============================================================

      // if runtimeCreatedEntity == null, then register this handler for all entities placed in editor
      public function RegisterToEntityEventHandlerLists (runtimeCreatedEntity:Entity = null):void
      {
         //var eventId:int = mEventHandlerDefinition.GetFunctionDeclaration ().GetID ();

         switch (mEventId)
         {
            // ai flow
            case CoreEventIds.ID_OnEntityCreated:
            case CoreEventIds.ID_OnEntityInitialized:
            case CoreEventIds.ID_OnEntityUpdated:
            case CoreEventIds.ID_OnEntityDestroyed:
            // joint
            case CoreEventIds.ID_OnJointReachLowerLimit:
            case CoreEventIds.ID_OnJointReachUpperLimit:
            // shape
            case CoreEventIds.ID_OnPhysicsShapeMouseDown:
            case CoreEventIds.ID_OnPhysicsShapeMouseUp:
            case CoreEventIds.ID_OnEntityMouseClick:
            case CoreEventIds.ID_OnEntityMouseDown:
            case CoreEventIds.ID_OnEntityMouseUp:
            case CoreEventIds.ID_OnEntityMouseMove:
            case CoreEventIds.ID_OnEntityMouseEnter:
            case CoreEventIds.ID_OnEntityMouseOut:
               var list_element:ListElement_EntitySelector = mFirstEntitySelector;
               if (runtimeCreatedEntity != null)
               {
                  while (list_element != null)
                  {
                     list_element.mEntitySelector.RegisterEventHandlerForRuntimeCreatedEntity (runtimeCreatedEntity, mEventId, this);

                     list_element = list_element.mNextListElement;
                  }
               }
               else
               {
                  while (list_element != null)
                  {
                     list_element.mEntitySelector.RegisterEventHandlerForEntitiesPlacedInEditor (mEventId, this);

                     list_element = list_element.mNextListElement;
                  }
               }
               break;
            default:
               break;
         }
      }

//======================================================================================================
//
//======================================================================================================

      override protected function DestroyInternal ():void
      {
         SetEnabled (false);
      }

//======================================================================================================
//
//======================================================================================================

      protected var mEnabledChangedStep:int = 0;
      protected var mEnabledChangedStepStage:int = 0;
         // these variables are to make sure a disabled (before starting pf running all timer event handlers) event handler will not run (before ending of running all timer event handlers)
         // maybe the current implementation is not a good one.Maybe delay enabling will be used later.
         // to make it symmatrical (maybe shouldn't), an enbled (before starting pf running all timer event handlers) event handler should be always run (before ending of running all timer event handlers)
         // maybe dalay enabling is also not good enugh. It seems now mPaused is removed, which makes the case simpler: the ones in dlay-run list will always run, otherwuse, will not run.
         // [edit]: delay run is stil needed, to give user a consitent value returned by IsEnabled
         // above rules should not only apply on timer event handlers, but also for all event handlers

      override public function SetEnabled (enabled:Boolean):void
      {
         if (mIsEnabled != enabled)
         {
            mEnabledChangedStep      = mWorld.GetSimulatedSteps ();
            mEnabledChangedStepStage = mWorld.GetStepStage ();

            super.SetEnabled (enabled);
         }
      }

      // the return value is only useful for some event handlers
      public function HandleEvent (valueSourceList:Parameter):Boolean
      {
         if (mIsEnabled == false || mExternalCondition != null && mExternalCondition.mConditionEntity.GetEvaluatedValue () != mExternalCondition.mTargetValue)
            return false;

         // only excute event handler when the event handler is enabled before the event happens.
         if (mEnabledChangedStep < mWorld.GetSimulatedSteps () || mEnabledChangedStepStage < mWorld.GetStepStage ())
         {
            //mEventHandlerDefinition.DoCall (valueSourceList, null);
            mEventHandlerDefinition.ExcuteEventHandler (valueSourceList);

            if (mExternalAction != null)
            {
               mExternalAction.Perform ();
            }

            return true;
         }

         return false;
      }
   }
}
