package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.data.ListElement_EntitySelector;
   
   import common.trigger.ValueDefine;
   
   public class EntityTask extends EntityCondition
   {
      protected var mFirstEntitySelector:ListElement_EntitySelector = null;
      
      public function EntityTask (world:World)
      {
         super (world);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mInputAssignerCreationIds != undefined)
            {
               var assignerEntityIndexes:Array = entityDefine.mInputAssignerCreationIds;
               if (assignerEntityIndexes != null)
               {
                  var newElement:ListElement_EntitySelector;
                   
                  for (var i:int = assignerEntityIndexes.length - 1; i >= 0; -- i)
                  {
                     // only support entities placed in editor
                     //newElement = new ListElement_EntitySelector (mWorld.GetEntityByCreateOrderId (int(assignerEntityIndexes [i]), false) as EntitySelector);
                     
                     // from v2.02, merging scene is added
                     var assignerEntityId:int = assignerEntityIndexes [i] as int;
                     if (assignerEntityId >= 0)
                        assignerEntityId = extraInfos.mEntityIdCorrectionTable [assignerEntityId];
                     newElement = new ListElement_EntitySelector (mWorld.GetEntityByCreateOrderId (assignerEntityId, true) as EntitySelector);
                                                                              // NOT only support entities placed in editor
                     
                     newElement.mNextListElement = mFirstEntitySelector;
                     mFirstEntitySelector = newElement;
                  }
               }
            }
         }
      }
         
//=============================================================
//   as condition
//=============================================================
      
      override public function Evaluate ():void
      {
         var num_undetermineds:int = 0;
         
         var element:ListElement_EntitySelector = mFirstEntitySelector;
         var status:int;
         
         while (element != null)
         {
            status = element.mEntitySelector.GetEntityListTaskStatus ();
            if (status == ValueDefine.TaskStatus_Unfinished)
               ++ num_undetermineds;
            else if (status == ValueDefine.TaskStatus_Failed)
            {
               mEvaluatedValue = ValueDefine.TaskStatus_Failed;
               return;
            }
            
            element = element.mNextListElement;
         }
         
         if (num_undetermineds > 0)
            mEvaluatedValue = ValueDefine.TaskStatus_Unfinished;
         else
            mEvaluatedValue = ValueDefine.TaskStatus_Successed;
      }
   }
}
