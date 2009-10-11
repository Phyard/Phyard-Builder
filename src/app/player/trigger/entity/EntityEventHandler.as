package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   import player.trigger.ValueSource;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.define.ConditionListDefine;
   import common.trigger.define.CommandListDefine;
   
   import common.trigger.CoreEventIds;
   
   public class EntityEventHandler extends EntityLogic
   {
      public var mNextEntityEventHandlerOfTheSameType:EntityEventHandler = null;
      
      public var mFirstEntityAssigner:ListElement_InputEntityAssigner = null;
      
      public var mExternalCondition:ConditionAndTargetValue = null;
      public var mExternalPostActionEntity:EntityAction = null;
      
      public var mEventHandlerDefinition:FunctionDefinition_Logic;
      
      public function EntityEventHandler (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         mEventHandlerDefinition = new FunctionDefinition_Logic (TriggerEngine.GetCoreEventHandlerDeclarationById (params.mEventId));
      }
      
      public function SetExternalCondition (conditionEntityIndex:int, targetValue:int):void
      {
         var conditionEntity:EntityCondition = mWorld.GetEntityByIndexInEditor (conditionEntityIndex) as EntityCondition;
         if (conditionEntity != null)
         {
            mExternalCondition =  new ConditionAndTargetValue (conditionEntity, targetValue);
         }
      }
      
      public function SetExternalPostActionEntity (actionEntityIndex:int):void
      {
         mExternalPostActionEntity = mWorld.GetEntityByIndexInEditor (actionEntityIndex) as EntityAction;
      }
      
      public function SetEntityAssigners (assignerEntityIndexes:Array):void
      {
         if (assignerEntityIndexes == null)
            return;
         
         var newElement:ListElement_InputEntityAssigner;
          
         for (var i:int = assignerEntityIndexes.length - 1; i >= 0; -- i)
         {
            newElement = new ListElement_InputEntityAssigner (mWorld.GetEntityByIndexInEditor (assignerEntityIndexes [i]) as EntityInputEntityAssigner);
            newElement.mNextListElement = mFirstEntityAssigner;
            mFirstEntityAssigner = newElement;
         }
      }
      
      public function SetInternalConditionListDefine (conditionListDefine:ConditionListDefine):void
      {
         if (mEventHandlerDefinition != null) // should not be null
            mEventHandlerDefinition.SetConditionListDefine (conditionListDefine);
      }
      
      public function SetInternalCommandListDefine (commandListDefine:CommandListDefine):void
      {
         if (mEventHandlerDefinition != null) // should not be null
            mEventHandlerDefinition.SetCommandListDefine (commandListDefine);
      }
      
      public function HandleEvent (valueSourceList:ValueSource):void
      {
         trace ("mExternalCondition = " + mExternalCondition);
         
         if (mExternalCondition != null && mExternalCondition.mConditionEntity.GetEvaluatedValue () != mExternalCondition.mTargetValue)
            return;
         
         mEventHandlerDefinition.DoCall (valueSourceList, null);
      }
      
//======================================================================================================
//
//======================================================================================================
      
      public function Register ():void
      {
         var eventId:int = mEventHandlerDefinition.GetFunctionDeclaration ().GetID ();
         
         mWorld.RegisterEventHandler (eventId, this);
         
         switch (eventId)
         {
            case CoreEventIds.ID_OnEntityInitialized:
            case CoreEventIds.ID_OnEntityUpdated:
            case CoreEventIds.ID_OnEntityDestroyed:
            case CoreEventIds.ID_OnJointBroken:
            case CoreEventIds.ID_OnJointReachLowerLimit:
            case CoreEventIds.ID_OnJointReachUpperLimit:
               var list_element:ListElement_InputEntityAssigner = mFirstEntityAssigner;
               while (list_element != null)
               {
                  list_element.mInputEntityAssigner.RegisterEntityEventHandler (eventId, this);
                  
                  list_element = list_element.mNextListElement;
               }
               break;
            default:
               break;
         }
      }
   }
}
