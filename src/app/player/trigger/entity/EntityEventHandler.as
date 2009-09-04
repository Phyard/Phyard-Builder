package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.define.ConditionListDefine;
   import common.trigger.define.CommandListDefine;
   
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
         mExternalCondition =  new ConditionAndTargetValue (mWorld.GetEntityByIndexInEditor (conditionEntityIndex) as EntityCondition, targetValue);
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
      
      // IsExternalConditionSatisfied () {if (mEnabled) ...}
   }
}