package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   import player.trigger.ValueSource;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.define.CodeSnippetDefine;
   
   import common.trigger.CoreEventIds;
   import common.trigger.CoreEventDeclarations;
   
   public class EntityEventHandler extends EntityLogic
   {
      //public var mNextEntityEventHandlerOfTheSameType:EntityEventHandler = null;
      
      public var mExternalCondition:ConditionAndTargetValue = null;
      
      public var mFirstEntityAssigner:ListElement_InputEntityAssigner = null;
      
      protected var mEventId:int = CoreEventIds.ID_Invalid;
      public var mEventHandlerDefinition:FunctionDefinition_Logic = null;
      
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
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mEventId != undefined)
            {
               mEventId = int (entityDefine.mEventId);
               mEventHandlerDefinition = new FunctionDefinition_Logic (CoreEventDeclarations.GetCoreEventHandlerDeclarationById (mEventId));
               
               // code snippets
               if (entityDefine.mCodeSnippetDefine != undefined)
               {
                  var codeSnippetDefine:CodeSnippetDefine = entityDefine.mCodeSnippetDefine.Clone ();
                  codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
                  mEventHandlerDefinition.SetCodeSnippetDefine (codeSnippetDefine);
               }
            }
            
            // external condition
            if (entityDefine.mInputConditionEntityCreationId != undefined && entityDefine.mInputConditionTargetValue != undefined)
            {
               var conditionEntity:EntityCondition = mWorld.GetEntityByCreationId (entityDefine.mInputConditionEntityCreationId) as EntityCondition;
               if (conditionEntity != null)
               {
                  mExternalCondition =  new ConditionAndTargetValue (conditionEntity, entityDefine.mInputConditionTargetValue);
               }
            }
            
            if (entityDefine.mExternalActionEntityCreationId != undefined)
            {
               mExternalAction = mWorld.GetEntityByCreationId (entityDefine.mExternalActionEntityCreationId) as EntityAction;
            }
         }
         else if (createStageId == 1) // somthing to do after all EntityAssigners are created with stageId=0
         {
            // entity (pair) assigners
            if (entityDefine.mInputAssignerCreationIds != undefined)
            {
               var assignerEntityIndexes:Array = entityDefine.mInputAssignerCreationIds;
               var newElement:ListElement_InputEntityAssigner;
                
               for (var i:int = assignerEntityIndexes.length - 1; i >= 0; -- i)
               {
                  newElement = new ListElement_InputEntityAssigner (mWorld.GetEntityByCreationId (int(assignerEntityIndexes [i])) as EntityInputEntityAssigner);
                  newElement.mNextListElement = mFirstEntityAssigner;
                  mFirstEntityAssigner = newElement;
               }
            }
            
            // register self
            RegisterToEntityEventHandlerLists ();
         }
      }
      
//=============================================================
//   register to entity
//=============================================================
      
      protected function RegisterToEntityEventHandlerLists ():void
      {
         var eventId:int = mEventHandlerDefinition.GetFunctionDeclaration ().GetID ();
         
         mWorld.RegisterEventHandler (eventId, this);
         
         switch (eventId)
         {
            // ai flow
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
               var list_element:ListElement_InputEntityAssigner = mFirstEntityAssigner;
               while (list_element != null)
               {
                  list_element.mInputEntityAssigner.RegisterEventHandlerForEntities (eventId, this);
                  
                  list_element = list_element.mNextListElement;
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
      
      public function HandleEvent (valueSourceList:ValueSource):void
      {
         if (mIsEnabled == false || mExternalCondition != null && mExternalCondition.mConditionEntity.GetEvaluatedValue () != mExternalCondition.mTargetValue)
            return;
         
         //mEventHandlerDefinition.DoCall (valueSourceList, null);
         mEventHandlerDefinition.ExcuteEventHandler (valueSourceList);
         
         if (mExternalAction != null)
            mExternalAction.Perform ();
      }     
   }
}
