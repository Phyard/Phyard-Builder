
   protected var mEventHandlers:Array = new Array (IdPool.NumEventTypes);

   public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
   {
      if (eventId < 0 || eventId >= IdPool.NumEventTypes || eventHandler == null)
         return;
      
      var new_element:ListElement_EventHandler = new ListElement_EventHandler (eventHandler);
      new_element.mNextListElement = mEventHandlers [eventId];
      
      mEventHandlers [eventId] = new_element;
   }

//==================================
// general event handler
//==================================

   public function HandleEventById (eventId:int, valueSourceList:ValueSource = null):void
   {
      var handler_element:ListElement_EventHandler = mEventHandlers [eventId];
      
      while (handler_element != null)
      {
         handler_element.mEventHandler.HandleEvent (valueSourceList);
         
         handler_element = handler_element.mNextListElement;
      }
   }

//==================================
// timer event handler
//==================================

   private var mHandlerToDelayRunListHead_WorldTimer:EntityEventHandler_Timer = null;
   private var mHandlerToDelayRunListHead_EntityTimer:EntityEventHandler_Timer = null;
   private var mHandlerToDelayRunListHead_EntityPairTimer:EntityEventHandler_Timer = null;

   public function DelayRunTimerHandler (timerHandler:EntityEventHandler_Timer):void
   {
      var eventId:int = timerHandler.GetEventId ();
      switch (eventId)
      {
         case CoreEventIds.ID_OnEntityTimer:
            timerHandler.mNextTimerHandlerToRun = mHandlerToDelayRunListHead_EntityTimer;
            mHandlerToDelayRunListHead_EntityTimer = timerHandler;
            break;
         case CoreEventIds.ID_OnEntityPairTimer:
            timerHandler.mNextTimerHandlerToRun = mHandlerToDelayRunListHead_EntityPairTimer;
            mHandlerToDelayRunListHead_EntityPairTimer = timerHandler;
            break;
         case CoreEventIds.ID_OnWorldTimer:
            timerHandler.mNextTimerHandlerToRun = mHandlerToDelayRunListHead_WorldTimer;
            mHandlerToDelayRunListHead_WorldTimer = timerHandler;
            break;
         default:
            break;
      }
   }
   
   public function HandleTimerEvents ():void
   {
      var timerHandler:EntityEventHandler_Timer;
      var next:EntityEventHandler_Timer;
      
      timerHandler = mHandlerToDelayRunListHead_EntityTimer;
      mHandlerToDelayRunListHead_EntityTimer = null;
      while (timerHandler != null)
      {
         next = timerHandler.mNextTimerHandlerToRun;;
         timerHandler.HandleEntityTimerEvent ();
         timerHandler.mNextTimerHandlerToRun = null;
         timerHandler.mIsAlreadyInDelayRunList = false;
         timerHandler = next;
      }
      
      timerHandler = mHandlerToDelayRunListHead_EntityPairTimer;
      mHandlerToDelayRunListHead_EntityPairTimer = null;
      while (timerHandler != null)
      {
         next = timerHandler.mNextTimerHandlerToRun;;
         timerHandler.HandleEntityPairTimerEvent ();
         timerHandler.mNextTimerHandlerToRun = null;
         timerHandler.mIsAlreadyInDelayRunList = false;
         timerHandler = next;
      }
      
      timerHandler = mHandlerToDelayRunListHead_WorldTimer;
      mHandlerToDelayRunListHead_WorldTimer = null;
      while (timerHandler != null)
      {
         next = timerHandler.mNextTimerHandlerToRun;;
         timerHandler.HandleWorldTimerEvent ();
         timerHandler.mNextTimerHandlerToRun = null;
         timerHandler.mIsAlreadyInDelayRunList = false;
         timerHandler = next;
      }
   }
