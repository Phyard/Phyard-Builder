//==================================
// gesture event handler
//==================================
   
   protected var mGestureEventHandlerLists:Array = new Array (GestureIDs.kNumGestures);
   
   public function RegisterGestureEventHandler (gestureEventHandler:EntityEventHandler_Gesture, gestureIDs:Array):void
   {
      if (gestureEventHandler == null || gestureIDs == null || gestureIDs.length == 0)
         return;
      
      if (gestureEventHandler.GetEventId () == CoreEventIds.ID_OnMouseGesture)
      {
         for (var i:int = 0; i < gestureIDs.length; ++ i)
         {
            var gestureId:int = gestureIDs [i];
            if (gestureId < 0 || gestureId >= GestureIDs.kNumGestures)
               continue;
            
            var listHead:ListElement_EventHandler = mGestureEventHandlerLists [gestureId];
            
            var newHead:ListElement_EventHandler = new ListElement_EventHandler (gestureEventHandler);
            newHead.mNextListElement = listHead;
            mGestureEventHandlerLists [gestureId] = newHead;
         }
      }
   }

   // call back from viewer
   public function RegisterGestureEvent (gestureAnalyzeResult:Object):void
   {
      var exactGestureId:int = GestureIDs.GetGestureID (gestureAnalyzeResult.mGestureType, gestureAnalyzeResult.mGestureAngle);
      
      if (exactGestureId < 0 || exactGestureId >= GestureIDs.kNumGestures)
         return;
      
      // special for ctrl and shift
      
      var handlerList:ListElement_EventHandler = mGestureEventHandlerLists [exactGestureId];
      if (handlerList == null)
         return;
      
      var valueSource0:Parameter_Direct = new Parameter_Direct (null);
      
      valueSource0.mValueObject = exactGestureId;
      
      RegisterCachedSystemEvent ([CachedEventType_General, handlerList, valueSource0]);
   }
   
