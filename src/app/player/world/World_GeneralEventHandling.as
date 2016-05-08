
   protected var mAllEventHandlers:ListElement_EventHandler = null;
   protected var mEventHandlersByTypes:Array = new Array (IdPool.NumEventTypes);

   public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
   {
      if (eventId < 0 || eventId >= IdPool.NumEventTypes || eventHandler == null)
         return;

      // ...

      var new_element:ListElement_EventHandler = new ListElement_EventHandler (eventHandler);
      new_element.mNextListElement = mAllEventHandlers;

      mAllEventHandlers = new_element;

      // ...

      var new_element_by_type:ListElement_EventHandler = new ListElement_EventHandler (eventHandler);
      new_element_by_type.mNextListElement = mEventHandlersByTypes [eventId];

      mEventHandlersByTypes [eventId] = new_element_by_type;
   }

   public function GetEventHandlerList ():ListElement_EventHandler
   {
      return mAllEventHandlers;
   }

   // "entity == null" means for all entities placed in editor
   // "entity != null" is mainly used for runtime-created entities
   public function RegisterEventHandlersForEntity (forOnEntityCreatedEventHandlers:Boolean, entity:Entity = null):void
   {
      var list_element_eventHandler:ListElement_EventHandler;
      var eventHandler:EntityEventHandler;

      if (forOnEntityCreatedEventHandlers)
      {
         list_element_eventHandler = mEventHandlersByTypes [CoreEventIds.ID_OnEntityCreated];

         while (list_element_eventHandler != null)
         {
            eventHandler = list_element_eventHandler.mEventHandler;

            eventHandler.RegisterToEntityEventHandlerLists (entity);

            list_element_eventHandler = list_element_eventHandler.mNextListElement;
         }
      }
      else
      {
         list_element_eventHandler = mAllEventHandlers;

         while (list_element_eventHandler != null)
         {
            eventHandler = list_element_eventHandler.mEventHandler;

            if (eventHandler.GetEventId () != CoreEventIds.ID_OnEntityCreated)
            {
               eventHandler.RegisterToEntityEventHandlerLists (entity);
            }

            list_element_eventHandler = list_element_eventHandler.mNextListElement;
         }
      }
   }

   // used for runtime-created entities
   public function RegisterEventHandlersForRuntimeCreatedEntities (forOnEntityCreatedEventHandlers:Boolean, entities:Array):void
   {
      if (entities == null)
         return;

      for each (var entity:Entity in entities)
      {
         RegisterEventHandlersForEntity (forOnEntityCreatedEventHandlers, entity);
      }
   }

//==================================
// general event handler
//==================================

   public function HandleEventById (eventId:int, valueSourceList:Parameter = null):void
   {
      var handler_element:ListElement_EventHandler = mEventHandlersByTypes [eventId];

      IncStepStage ();
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
      IncStepStage ();
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
      IncStepStage ();
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
      IncStepStage ();
      while (timerHandler != null)
      {
         next = timerHandler.mNextTimerHandlerToRun;;
         timerHandler.HandleWorldTimerEvent ();
         timerHandler.mNextTimerHandlerToRun = null;
         timerHandler.mIsAlreadyInDelayRunList = false;
         timerHandler = next;
      }
   }
