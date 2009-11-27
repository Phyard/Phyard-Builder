
protected var mEventHandlers:Array = new Array (CoreEventIds.NumEventTypes);

public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
{
   if (eventId < 0 || eventId >= CoreEventIds.NumEventTypes || eventHandler == null)
      return;
   
   eventHandler.mNextEntityEventHandlerOfTheSameType = mEventHandlers [eventId];
   mEventHandlers [eventId] = eventHandler;
}

public function HandleEvent (eventId:int, valueSourceList:ValueSource = null):void
{
   var event_handler:EntityEventHandler = mEventHandlers [eventId];
   
   while (event_handler != null)
   {
      event_handler.HandleEvent (valueSourceList);
      
      event_handler = event_handler.mNextEntityEventHandlerOfTheSameType;
   }
}

