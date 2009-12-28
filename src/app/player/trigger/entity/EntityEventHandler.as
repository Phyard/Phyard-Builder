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
      public var mNextEntityEventHandlerOfTheSameType:EntityEventHandler = null;
      
      public var mExternalCondition:ConditionAndTargetValue = null;
      public var mFirstEntityAssigner:ListElement_InputEntityAssigner = null;
      public var mEventHandlerDefinition:FunctionDefinition_Logic = null;
      
      public function EntityEventHandler (world:World)
      {
         super (world);
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
               mEventHandlerDefinition = new FunctionDefinition_Logic (CoreEventDeclarations.GetCoreEventHandlerDeclarationById (entityDefine.mEventId));
               
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
         }
         else if (createStageId == 1) // somthing to do after all EntityAssigners are created with stageId=0
         {
            // entity (pair) assigners
            if (entityDefine.mNumAssigners != undefined && entityDefine.mInputAssignerCreationIds != undefined)
            {
               var numAssigners:int = entityDefine.mNumAssigners;
               
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
      
      private function RegisterToEntityEventHandlerLists ():void
      {
         var eventId:int = mEventHandlerDefinition.GetFunctionDeclaration ().GetID ();
         
         mWorld.RegisterEventHandler (eventId, this);
         
         switch (eventId)
         {
            case CoreEventIds.ID_OnEntityInitialized:
            case CoreEventIds.ID_OnEntityUpdated:
            case CoreEventIds.ID_OnEntityDestroyed:
            case CoreEventIds.ID_OnJointReachLowerLimit:
            case CoreEventIds.ID_OnJointReachUpperLimit:
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
      
      public function HandleEvent (valueSourceList:ValueSource):void
      {
         if (mExternalCondition != null && mExternalCondition.mConditionEntity.GetEvaluatedValue () != mExternalCondition.mTargetValue)
            return;
         
         //mEventHandlerDefinition.DoCall (valueSourceList, null);
         mEventHandlerDefinition.ExcuteEventHandler (valueSourceList);
      }     
   }
}
