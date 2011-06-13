package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;   
   import player.trigger.CodeSnippet;
   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;
   
   import player.trigger.data.ListElement_EntitySelector;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionDefine;
      
   import common.trigger.CoreEventIds;
   import common.trigger.CoreEventDeclarations;

   import common.TriggerFormatHelper2;
   
   public class EntityEventHandler_Timer extends EntityEventHandler
   {
      public var mPreEventHandlerDefinition:FunctionDefinition_Custom = null;
      public var mPostEventHandlerDefinition:FunctionDefinition_Custom = null;
      
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
            
            // fron v1.56
            if (mEventId == CoreEventIds.ID_OnEntityTimer || mEventId == CoreEventIds.ID_OnEntityPairTimer)
            {
               if (entityDefine.mPreFunctionDefine != undefined)
               {
                  var preCodeSnippetDefine:CodeSnippetDefine = ((entityDefine.mPreFunctionDefine as FunctionDefine).mCodeSnippetDefine as CodeSnippetDefine).Clone ();
                  preCodeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
   
                  mPreEventHandlerDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (entityDefine.mPreFunctionDefine, CoreEventDeclarations.GetCoreEventHandlerDeclarationById (CoreEventIds.ID_OnWorldPreTimer));
                  mPreEventHandlerDefinition.SetLocalVariableReferences (mEventHandlerDefinition.GetLocalVariableReferences ());
                  mPreEventHandlerDefinition.SetCodeSnippetDefine (preCodeSnippetDefine);
               }
               
               if (entityDefine.mPostFunctionDefine != undefined)
               {
                  var postCodeSnippetDefine:CodeSnippetDefine = ((entityDefine.mPostFunctionDefine as FunctionDefine).mCodeSnippetDefine as CodeSnippetDefine).Clone ();
                  postCodeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
   
                  mPostEventHandlerDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (entityDefine.mPostFunctionDefine, CoreEventDeclarations.GetCoreEventHandlerDeclarationById (CoreEventIds.ID_OnWorldPostTimer));
                  mPostEventHandlerDefinition.SetLocalVariableReferences (mEventHandlerDefinition.GetLocalVariableReferences ());
                  mPostEventHandlerDefinition.SetCodeSnippetDefine (postCodeSnippetDefine);
               }
            }
            //<<
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
      
      protected var mPaused:Boolean = false; 
            // ??? why use this variable?
            // the API SetTimerPaused () is depreciated from v1.54
            // [edit]: the "pause" is add back.
            //        A timer "Not Paused" but "Disabled" will still update ticker, but will not run the script.
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mPaused)
            return;
         // !!! here, some wavering back and forth in developing v1.54 (see above)
         // from v1.54, pasued == (! enabled)
         //if (mIsEnabled == false)
         //   return;
         
         //trace ("mCurrentTimerStep = " + mCurrentTimerStep);
         
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
      
      public function IsPaused ():Boolean
      {
         return mPaused;
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
         
         HandleEvent (mTimerEventHandlerValueSourceList);
      }      
      public function HandleEntityTimerEvent ():void
      {
         if (WillNotRun ())
            return;
         
         mTimerEventHandlerValueSource0.mValueObject = mRunningTimes;
         
         // when running code here, mIsEnabled must be true
         
         // pre handling
         if (mPreEventHandlerDefinition != null) // should not be null
         {
            mPreEventHandlerDefinition.ExcuteEventHandler (mTimerEventHandlerValueSourceList);
         }
         
         // handling
         var list_element:ListElement_EntitySelector = mFirstEntitySelector;
         while (list_element != null)
         {
            list_element.mEntitySelector.HandleTimerEventForEntities (this, mTimerEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
         
         // when running code here, mIsEnabled may be false, but the post handling will be always called
         
         // post handling (if pre handlign is called , the post must be also be called)
         if (mPostEventHandlerDefinition != null) // should not be null
         {
            mPostEventHandlerDefinition.ExcuteEventHandler (mTimerEventHandlerValueSourceList);
         } 
      }      
      public function HandleEntityPairTimerEvent ():void
      {
         if (WillNotRun ())
            return;
         
         mTimerEventHandlerValueSource0.mValueObject = mRunningTimes;
         
         // when running code here, mIsEnabled must be true
         
         // pre handling
         if (mPreEventHandlerDefinition != null) // should not be null
         {
            mPreEventHandlerDefinition.ExcuteEventHandler (mTimerEventHandlerValueSourceList);
         }
         
         // handling
         var list_element:ListElement_EntitySelector = mFirstEntitySelector;
         while (list_element != null)
         {
            list_element.mEntitySelector.HandleTimerEventForEntityPairs (this, mTimerEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
         
         // when running code here, mIsEnabled may be false, but the post handling will be always called
         
         // post handling (if pre handlign is called , the post must be also be called)
         if (mPostEventHandlerDefinition != null) // should not be null
         {
            mPostEventHandlerDefinition.ExcuteEventHandler (mTimerEventHandlerValueSourceList);
         } 
      }   }
}
