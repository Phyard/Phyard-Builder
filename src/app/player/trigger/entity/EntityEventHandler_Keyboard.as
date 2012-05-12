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
   import common.KeyCodes;
   
   public class EntityEventHandler_Keyboard extends EntityEventHandler
   {
      public function EntityEventHandler_Keyboard (world:World)
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
            if (entityDefine.mKeyCodes != undefined)
            {
               mKeyCodes = KeyCodes.GetKeyCodesFromSelectedKeyCodes (entityDefine.mKeyCodes);
               //trace ("mKeyCodes = " + mKeyCodes);
               mWorld.RegisterKeyboardEventHandler (this, mKeyCodes);
            }
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mKeyCodes:Array = null;
      
//=============================================================
//   register to entity
//=============================================================
      
      override public function RegisterToEntityEventHandlerLists (runtimeCreatedEntity:Entity = null):void
      {
         // do nothing
      }
      
//=============================================================
//   handle
//=============================================================
      
      // for judging if this handler is excuted already in current step.
      private var mLastHandlingStep:int = -1;
      
      override public function HandleEvent (valueSourceList:Parameter):Boolean
      {
         if (mEventId == CoreEventIds.ID_OnWorldKeyHold)
         {
            var worldSimulateSteps:int = mWorld.GetSimulatedSteps ();
            if (mLastHandlingStep >= worldSimulateSteps)
               return false;
            
            mLastHandlingStep = worldSimulateSteps;
         }
         else if (mKeyCodes != null)
         {
            var i:int;
            var num:int = mKeyCodes.length;
            var keyCode:int;
            
            var eventKeyCode:int = int ((valueSourceList as Parameter_Direct).mValueObject);
            for (i = 0; i < num; ++ i)
            {
               keyCode = mKeyCodes [i];
               if (mWorld.IsKeyHold (keyCode) && keyCode != eventKeyCode)
                  return false;
            }
         }
         
         return super.HandleEvent (valueSourceList);
      }      
   }
}
