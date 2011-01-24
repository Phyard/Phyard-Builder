package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.CodeSnippet;
   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.define.CodeSnippetDefine;
   
   import common.trigger.CoreEventIds;
   import common.trigger.CoreEventDeclarations;
   
   public class EntityEventHandler_Timer extends EntityEventHandler
   {
      public function EntityEventHandler_Timer (world:World)
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
            if (entityDefine.mRunningInterval != undefined)
               SetRunningInterval (entityDefine.mRunningInterval as Number);
            
            if (entityDefine.mOnlyRunOnce != undefined)
               SetOnlyRunOnce (entityDefine.mOnlyRunOnce as Boolean);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mRunningInterval:Number = 1.0; // steps or seconds
      protected var mRunningInterval_Int:int = 1; // steps or seconds
      protected var mOnlyRunOnce:Boolean = true;
      
      public function SetRunningInterval (interval:Number):void
      {
         mRunningInterval = interval;
         mRunningInterval_Int = Math.round (mRunningInterval);
         if (mRunningInterval_Int < 1)
            mRunningInterval_Int = 1;
      }
      
      public function GetRunningInterval ():Number
      {
         return mRunningInterval;
      }
      
      public function SetOnlyRunOnce (once:Boolean):void
      {
         mOnlyRunOnce = once;
      }
      
      public function IsOnlyRunOnce ():Boolean
      {
         return mOnlyRunOnce;
      }
      
//=============================================================
//   register to entity
//=============================================================
      
      override protected function RegisterToEntityEventHandlerLists ():void
      {
         // do nothing
      }
      
//=============================================================
//   to-run list
//   all timer event handlers will be run after all entities are updated
//=============================================================
      
      public var mNextTimerHandlerToRun:EntityEventHandler_Timer = null;
      public var mIsAlreadyInDelayRunList:Boolean = false;
      
      protected function DelayRun ():void
      {
         if (mIsAlreadyInDelayRunList)
            return;
         
         mWorld.DelayRunTimerHandler (this);
      }
      
//=============================================================
//   update
//=============================================================
      
      protected var mCurrentTimerStep:int = 0;
      protected var mRunningTimes:int = 0;
      protected var mPaused:Boolean = false; // ??? why use this variable?
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mPaused)
            return;
         
         ++ mCurrentTimerStep;
         if (mCurrentTimerStep >= mRunningInterval_Int)
         {
            mCurrentTimerStep = 0;
            
            DelayRun ();
         }
      }
      
      public function Reset ():void
      {
         mCurrentTimerStep = 0;
      }
      
      public function SetPaused (paused:Boolean):void
      {
         mPaused = paused;
      }
      
//=============================================================
//   handle
//   all timer event handler will be run once mostly at each step
//=============================================================
      
      // for judging if this handler is excuted already in current step.
      private var mLastHandlingStep:int = -1;
      
      protected function WillNotRun ():Boolean
      {
         if (mIsEnabled == false)
            return true; // avoid to run
         
         if (mOnlyRunOnce && mRunningTimes > 0)
            return true;
         
         var worldSimulateSteps:int = mWorld.GetSimulatedSteps ();
         if (mLastHandlingStep >= worldSimulateSteps)
            return true;
         
         mLastHandlingStep = worldSimulateSteps;
         
         ++ mRunningTimes;
         
         return false;
      }
      
      private var mTimerEventHandlerValueSource2:Parameter_Direct = new Parameter_Direct (null);
      private var mTimerEventHandlerValueSource1:Parameter_Direct = new Parameter_Direct (null, mTimerEventHandlerValueSource2);
      private var mTimerEventHandlerValueSource0:Parameter_Direct = new Parameter_Direct (null, mTimerEventHandlerValueSource1);
      private var mTimerEventHandlerValueSourceList:Parameter = mTimerEventHandlerValueSource0;
      
      public function HandleWorldTimerEvent ():void
      {
         if (WillNotRun ())
            return;
         
         mTimerEventHandlerValueSource0.mValueObject = mRunningTimes;
         
      //if (mCreationId == 120) CodeSnippet.mEnableTrace = true;
         
         HandleEvent (mTimerEventHandlerValueSourceList);
         
      //if (mCreationId == 120) CodeSnippet.mEnableTrace = false;
      }      
      public function HandleEntityTimerEvent ():void
      {
         if (WillNotRun ())
            return;
         
         mTimerEventHandlerValueSource0.mValueObject = mRunningTimes;
         
         var list_element:ListElement_InputEntityAssigner = mFirstEntityAssigner;
         while (list_element != null)
         {
            list_element.mInputEntityAssigner.HandleTimerEventForEntities (this, mTimerEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }      
      public function HandleEntityPairTimerEvent ():void
      {
         if (WillNotRun ())
            return;
         
         mTimerEventHandlerValueSource0.mValueObject = mRunningTimes;
         
         var list_element:ListElement_InputEntityAssigner = mFirstEntityAssigner;
         while (list_element != null)
         {
            list_element.mInputEntityAssigner.HandleTimerEventForEntityPairs (this, mTimerEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }      
   }
}
