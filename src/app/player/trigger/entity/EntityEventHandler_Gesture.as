package player.trigger.entity
{
   import player.world.World;

   import player.entity.Entity;
   
   import player.trigger.TriggerEngine;
   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;
   
   import common.trigger.define.CodeSnippetDefine;
   
   import common.trigger.CoreEventIds;
   import common.trigger.CoreEventDeclarations;
   import common.GestureIDs;
   
   public class EntityEventHandler_Gesture extends EntityEventHandler
   {
      public function EntityEventHandler_Gesture (world:World)
      {
         super (world);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 2)
         {
            if (entityDefine.mGestureIDs != undefined)
            {
               mGestureIDs = GestureIDs.GetGestureIDsFromSelectedGestureIDs (entityDefine.mGestureIDs);
               //trace ("mGestureIDs = " + mGestureIDs);
               mWorld.RegisterGestureEventHandler (this, mGestureIDs);
            }
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mGestureIDs:Array = null;
      
//=============================================================
//   register to entity
//=============================================================
      
      override public function RegisterToEntityEventHandlerLists (runtimeCreatedEntity:Entity = null):void
      {
         // do nothing
      }      
   }
}
