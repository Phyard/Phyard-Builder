
   private var mEnabledInteractiveWhenPaused:Boolean = false;
   
   public function SetInteractiveEnabledWhenPaused (enable:Boolean):void
   {
      mEnabledInteractiveWhenPaused = enable;
   }
   
   public function IsInteractiveEnabledNow ():Boolean
   {
      // not a good ideas:
      // assume: mouse down before fading, release mosue when fading, then make some confused.
      // it is best provide a function IsCameraFading () for user convienience.
      
      if (mIsPaused)
         return mEnabledInteractiveWhenPaused;
      else
         return true;
   }

//=============================================================
//   
//=============================================================

   private var mCurrentMode:Mode = null;
   
   public function SetCurrentMode (mode:Mode):void
   {
      if (mCurrentMode != null)
         mCurrentMode.Destroy ();
      
      mCurrentMode = mode;
      
      if (mCurrentMode != null)
         mCurrentMode.Initialize ();
   }

//=============================================================
//   
//=============================================================

   public static const CachedEventType_General:int = 0;
   public static const CachedEventType_RemoveBombsAndRemovableShapes:int = 1;
   
   private var mCacheSystemEvents:Boolean = true;
   
   public function SetCacheSystemEvent (cache:Boolean):void
   {
      mCacheSystemEvents = cache;
      
      if (! mCacheSystemEvents)
      {
         HandleAllCachedSystemEvents ();
         ClearAllCachedSystemEvents ();
      }
   }
   
   private var mCachedSystemEvents:Array = new Array ();
   
   private function RegisterCachedSystemEvent (eventInfo:Array):void
   {
      if (mCacheSystemEvents)
      {
         mCachedSystemEvents.push (eventInfo);
      }
      else
      {
         HandleCachedSystemEvent (eventInfo);
      }
   }
   
   private function HandleAllCachedSystemEvents ():void
   {
      var numEvents:int = mCachedSystemEvents.length;
      
      for (var i:int = 0; i < numEvents; ++ i)
      {
         HandleCachedSystemEvent (mCachedSystemEvents [i] as Array);
      }
   }
   
   private function HandleCachedSystemEvent (eventInfo:Array):void
   {
      if (eventInfo [0] == CachedEventType_RemoveBombsAndRemovableShapes)
      {
         RemoveBombsAndRemovableShapes (eventInfo [1] as Array);
      }
      else
      {
         var handlerElement:ListElement_EventHandler = eventInfo [1] as ListElement_EventHandler;
         var valueSourceList:Parameter = eventInfo [2] as Parameter;
         
         IncStepStage ();
         while (handlerElement != null)
         {
            handlerElement.mEventHandler.HandleEvent (valueSourceList);
            
            handlerElement = handlerElement.mNextListElement;
         }
      }
   }
   
   private function ClearAllCachedSystemEvents ():void
   {
      var numEvents:int = mCachedSystemEvents.length;
      
      if (numEvents > 0)
      {
         mCachedSystemEvents.splice (0, numEvents);
      }
   }

//=============================================================
//   
//=============================================================

   private var mCachedMousePoint:Point = null;
   private var mCurrentMouseX:Number = 0; // generally, use GetCurrentMouseX ()
   private var mCurrentMouseY:Number = 0; // generally, use GetCurrentMouseY ()
   private var mIsMouseButtonDown:Boolean = false;
   
   public function GetCurrentMouseX ():Number
   {
      UpdateMousePosition ();
      
      return mCurrentMouseX;
   }
   
   public function GetCurrentMouseY ():Number
   {
      UpdateMousePosition ();
      
      return mCurrentMouseY;
   }
   
   private function UpdateMousePosition ():void
   {
      var worldDisplayPoint:Point = ThisToContentLayer (new Point (mouseX, mouseY));
      
      if (mCachedMousePoint == null)
      {
         mCachedMousePoint = new Point ();
      }
      else if (mCachedMousePoint.x == worldDisplayPoint.x && mCachedMousePoint.y == worldDisplayPoint.y)
      {
         return;
      }
      
      mCachedMousePoint.x = worldDisplayPoint.x;
      mCachedMousePoint.y = worldDisplayPoint.y;
      
      var point:Point = mCoordinateSystem.DisplayPoint2PhysicsPosition (mCachedMousePoint.x, mCachedMousePoint.y);
      
      mCurrentMouseX = ValueAdjuster.Number2Precision (point.x, 12); // why do this?
      mCurrentMouseY = ValueAdjuster.Number2Precision (point.y, 12);
   }
   
   public function IsMouseButtonDown ():Boolean
   {
      return mIsMouseButtonDown;
   }
   
   public function UpdateMousePositionAndHoldInfo (event:MouseEvent):void
   {
      //var point:Point = new Point (event.stageX, event.stageY);
      //point = globalToLocal (point);
      //point = mCoordinateSystem.DisplayPoint2PhysicsPosition (point.x, point.y);
      //
      //mCurrentMouseX = ValueAdjuster.Number2Precision (point.x, 12);
      //mCurrentMouseY = ValueAdjuster.Number2Precision (point.y, 12);
      
      mIsMouseButtonDown = event.buttonDown;
   }



//=============================================================
//   
//=============================================================

   private function OnAddedToStage (event:Event):void 
   {
      addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
      
      addEventListener (MouseEvent.CLICK, OnMouseClick);
      addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
      addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
      addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
      //addEventListener (MouseEvent.MOUSE_OVER, OnOtherMouseEvents);
      //addEventListener (MouseEvent.MOUSE_OUT, OnOtherMouseEvents);
      //addEventListener (MouseEvent.ROLL_OVER, OnOtherMouseEvents);
      //addEventListener (MouseEvent.ROLL_OUT, OnOtherMouseEvents);
      //addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
      
      // !!! don't forget to register corresponding event on Viewer.mGesgureSprite
      
      // ...
      stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      stage.addEventListener (KeyboardEvent.KEY_UP, OnKeyUp);
      
      //
      stage.addEventListener (Event.ACTIVATE, OnActivated);
      stage.addEventListener (Event.DEACTIVATE, OnDeactivated);
      
      //
      MoveWorldScene_DisplayOffset (0, 0);
      
      // commented off for exceptions on some latin system
      //IME.enabled = false; // seems no effects
   }
   
   private function OnRemovedFromStage (event:Event):void 
   {
      // 
      //IME.enabled = true;
      
      // must remove this listeners, to avoid memory leak
      
      removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
      
      removeEventListener (MouseEvent.CLICK, OnMouseClick);
      removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
      removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
      removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
      //removeEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
      //removeEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
      //removeEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
      //removeEventListener (MouseEvent.ROLL_OVER, OnRollOver);
      //removeEventListener (MouseEvent.ROLL_OUT, OnRollOut);
      
      // !!! don't forget to unregister corresponding event on Viewer.mGesgureSprite
      
      stage.removeEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      stage.removeEventListener (KeyboardEvent.KEY_UP, OnKeyUp);
      
      //
      stage.removeEventListener (Event.ACTIVATE, OnActivated);
      stage.removeEventListener (Event.DEACTIVATE, OnDeactivated);
   }

//=============================================================
//   mouse events
//   All moust events are not directly caused by the world sprite itself.
//   They are all caused by some descendants of the world sprite. 
//   So every mouse event will not be triggered twice.
//=============================================================

   public function OnViewerEvent (event:Event):void
   {
      if (event is MouseEvent)
      {
         var mouseEvent:MouseEvent = event as MouseEvent;
         
         switch (mouseEvent.type)
         {
            case MouseEvent.CLICK:
               OnMouseClick (mouseEvent);
               break;
            case MouseEvent.MOUSE_DOWN:
               OnMouseDown (mouseEvent);
               break;
            case MouseEvent.MOUSE_MOVE:
               OnMouseMove (mouseEvent);
               break;
            case MouseEvent.MOUSE_UP:
               OnMouseUp (mouseEvent);
               break;
         }
      }
   }
   
   public function OnMouseClick (event:MouseEvent):void
   {
      UpdateMousePositionAndHoldInfo (event);
      
      if (IsInteractiveEnabledNow ())
      {
         // ...
         RegisterMouseEvent (event, mEventHandlersByTypes [CoreEventIds.ID_OnWorldMouseClick]);
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   private var _KeyboardDownEvent:KeyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
   private var _KeyboardUpEvent:KeyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_UP);
   
   public function OnMouseDown (event:MouseEvent):void
   {
      // sometime, user release mouse out of world, ...
      if (IsKeyHold (KeyCodes.LeftMouseButton))
      {
         OnMouseUp (event);
      }
      
      // ...
      SetCurrentMode (new ModeMoveWorldScene (this));
      
      if (mCurrentMode != null)
         mCurrentMode.OnMouseDown (event.stageX, event.stageY);
      
      UpdateMousePositionAndHoldInfo (event);
      
      KeyPressed (KeyCodes.LeftMouseButton, 0);
      
      if (IsInteractiveEnabledNow ())
      {
         // as a key
         _KeyboardDownEvent.keyCode = KeyCodes.LeftMouseButton;
         _KeyboardDownEvent.charCode = 0;
         _KeyboardDownEvent.ctrlKey = event.ctrlKey;
         _KeyboardDownEvent.shiftKey = event.shiftKey;
         _KeyboardDownEvent.altKey = event.altKey;
         //HandleKeyEventByKeyCode (_KeyboardDownEvent, true);
         RegisterKeyboardEvent (KeyCodes.LeftMouseButton, _KeyboardDownEvent, mKeyDownEventHandlerLists);
         
         // ...
         RegisterMouseEvent (event, mEventHandlersByTypes [CoreEventIds.ID_OnWorldMouseDown]);
         
         // ...
         if (mEventHandlersByTypes [CoreEventIds.ID_OnPhysicsShapeMouseDown] != null)
         {
            //var worldDisplayPoint:Point = globalToLocal (new Point (event.stageX, event.stageY));
            var worldDisplayPoint:Point = StageToContentLayer (new Point (event.stageX, event.stageY));
            var physicsPoint:Point = mCoordinateSystem.DisplayPoint2PhysicsPosition (worldDisplayPoint.x, worldDisplayPoint.y);
            var shapeArray:Array = mPhysicsEngine.GetShapesAtPoint (physicsPoint.x, physicsPoint.y);
            
            var shape:EntityShape;
            var num:int = shapeArray.length;
            for (var i:int = 0; i < num; ++ i)
            {
               shape = shapeArray [i] as EntityShape;
               
               shape.OnPhysicsShapeMouseDown (event);
            }
         }
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   public function OnMouseUp (event:MouseEvent):void
   {
      // ...
      if (mCurrentMode != null)
         mCurrentMode.OnMouseUp (event.stageX, event.stageY);
      
      UpdateMousePositionAndHoldInfo (event);
      
      if (IsKeyHold (KeyCodes.LeftMouseButton))
      {
         // moved to bottom
         //KeyReleased (KeyCodes.LeftMouseButton);
         
         if (IsInteractiveEnabledNow ())
         {
            // as a key
            _KeyboardUpEvent.keyCode = KeyCodes.LeftMouseButton;
            _KeyboardUpEvent.charCode = 0;
            _KeyboardUpEvent.ctrlKey = event.ctrlKey;
            _KeyboardUpEvent.shiftKey = event.shiftKey;
            _KeyboardUpEvent.altKey = event.altKey;
            //HandleKeyEventByKeyCode (_KeyboardUpEvent, false);
            RegisterKeyboardEvent (KeyCodes.LeftMouseButton, _KeyboardUpEvent, mKeyUpEventHandlerLists);
            
            // ...
            RegisterMouseEvent (event, mEventHandlersByTypes [CoreEventIds.ID_OnWorldMouseUp]);
            
            // ...
            //var worldDisplayPoint:Point = globalToLocal (new Point (event.stageX, event.stageY));
            var worldDisplayPoint:Point = StageToContentLayer (new Point (event.stageX, event.stageY));
            var physicsPoint:Point = mCoordinateSystem.DisplayPoint2PhysicsPosition (worldDisplayPoint.x, worldDisplayPoint.y);
            var shapeArray:Array = mPhysicsEngine.GetShapesAtPoint (physicsPoint.x, physicsPoint.y);
            
            if (mEventHandlersByTypes [CoreEventIds.ID_OnPhysicsShapeMouseUp] != null)
            {
               var shape:EntityShape;
               var num:int = shapeArray.length;
               for (var i:int = 0; i < num; ++ i)
               {
                  shape = shapeArray [i] as EntityShape;
                  
                  shape.OnPhysicsShapeMousUp (event);
               }
            }
            
            //RemoveBombsAndRemovableShapes (shapeArray);
            RegisterCachedSystemEvent ([CachedEventType_RemoveBombsAndRemovableShapes, shapeArray]);
         }
         
         KeyReleased (KeyCodes.LeftMouseButton, 0);
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   public function OnMouseMove (event:MouseEvent):void
   {
      // ...
      if (mCurrentMode != null)
         mCurrentMode.OnMouseMove (event.stageX, event.stageY, event.buttonDown);
      
      UpdateMousePositionAndHoldInfo (event);
      
      if (IsInteractiveEnabledNow ())
      {
         //
         RegisterMouseEvent (event, mEventHandlersByTypes [CoreEventIds.ID_OnWorldMouseMove]);
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   public function OnOtherMouseEvents (event:MouseEvent):void
   {
      // ...
      if (mCurrentMode != null)
         mCurrentMode.OnMouseMove (event.stageX, event.stageY, event.buttonDown);
      
      UpdateMousePositionAndHoldInfo (event);
      
      if (IsInteractiveEnabledNow ())
      {
      }
      
      if (event.delta == 0x7FFFFFFF) // this event is sent from viewer
      {
         event.stopPropagation ();
      }
   }
   
   public function RegisterMouseEvent (event:MouseEvent, handlerList:ListElement_EventHandler, shape:EntityShape = null):void
   {
      if (handlerList == null)
         return;
      
      var valueSource7:Parameter_Direct = new Parameter_Direct (null); // is overlapped by some entities
      var valueSource6:Parameter_Direct = new Parameter_Direct (null, valueSource7); // alt down
      var valueSource5:Parameter_Direct = new Parameter_Direct (null, valueSource6); // shift down
      var valueSource4:Parameter_Direct = new Parameter_Direct (null, valueSource5); // ctrl down
      var valueSource3:Parameter_Direct = new Parameter_Direct (null, valueSource4); // button down
      var valueSource2:Parameter_Direct = new Parameter_Direct (null, valueSource3); // world physics y
      var valueSource1:Parameter_Direct = new Parameter_Direct (null, valueSource2); // world physics x
      
      valueSource1.mValueObject = GetCurrentMouseX ();
      valueSource2.mValueObject = GetCurrentMouseY ();
      valueSource3.mValueObject = event.buttonDown;
      valueSource4.mValueObject = event.ctrlKey;
      valueSource5.mValueObject = event.shiftKey;
      valueSource6.mValueObject = event.altKey;
      
      if (shape == null)
      {
         valueSource7.mValueObject = IsContentLayerContains (event.target as DisplayObject); // for world event only
         RegisterCachedSystemEvent ([CachedEventType_General, handlerList, valueSource1]);
      }
      else
      {
         var valueSource0:Parameter_Direct = new Parameter_Direct (null, valueSource1); // entity
         valueSource0.mValueObject = shape;
         RegisterCachedSystemEvent ([CachedEventType_General, handlerList, valueSource0]);
      }
   }

//=============================================================
//   keyboard events
//=============================================================

   public function OnKeyDown (event:KeyboardEvent):void
   {
      // event handling can't be run simutaniously with PhysicsEngine.Step ().
      // in flash, this is not a problem. Be careful when porting to other platforms.
      
      var exactKeyCode:int = GetExactKeyCode (event);
      
      if (IsKeyHold (exactKeyCode))
         return;
      
      if (IsInteractiveEnabledNow ())
      {
         KeyPressed (exactKeyCode, event.charCode);
         RegisterKeyboardEvent (exactKeyCode, event, mKeyDownEventHandlerLists);
         //HandleKeyEventByKeyCode (event, true);
      }
      
      //trace ("Pressed: " + String.fromCharCode (event.charCode));
   }
   
   public function OnKeyUp (event:KeyboardEvent):void
   {
      // event handling can't be run simutaniously with PhysicsEngine.Step ().
      // in flash, this is not a problem. Be careful when porting to other platforms.
      
      var exactKeyCode:int = GetExactKeyCode (event);
      
      if (! IsKeyHold (exactKeyCode))
         return;
      
      // commented off, because it seems not a good idea to ...
      // if (IsInteractiveEnabledNow ())
      {
         //HandleKeyEventByKeyCode (event, false);
         RegisterKeyboardEvent (exactKeyCode, event, mKeyUpEventHandlerLists);
         KeyReleased (exactKeyCode, event.charCode);
      }
      
      //trace ("Released: " + String.fromCharCode (event.charCode));
   }
   
   private function GetExactKeyCode (event:KeyboardEvent):int
   {
      // seems flash has bug in distinguishing the left and right ctrl
      
      //if (event.keyCode == Keyboard.CONTROL)
      //{
      //   if (event.keyLocation == KeyLocation.RIGHT)
      //   {
      //      return KeyCodes.ControlRight;
      //   }
      //   else
      //   {
      //      return KeyCodes.ControlLeft;
      //   }
      //}
      //if (event.keyCode == Keyboard.SHIFT)
      //{
      //   if (event.keyLocation == KeyLocation.RIGHT)
      //   {
      //      return KeyCodes.ShiftRight;
      //   }
      //   else
      //   {
      //      return KeyCodes.ShiftLeft;
      //   }
      //}
      
      return event.keyCode;
   }
   
   public function RegisterKeyboardEvent (exactKeyCode:int, event:KeyboardEvent, handleListArray:Array):void
   {
      if (exactKeyCode < 0 || exactKeyCode >= KeyCodes.kNumKeys)
         return;
      
      // special for ctrl and shift
      
      var handlerList:ListElement_EventHandler = handleListArray [exactKeyCode];
      if (handlerList == null)
         return;
      
      var valueSource4:Parameter_Direct = new Parameter_Direct (null);
      var valueSource3:Parameter_Direct = new Parameter_Direct (null, valueSource4);
      var valueSource2:Parameter_Direct = new Parameter_Direct (null, valueSource3);
      var valueSource1:Parameter_Direct = new Parameter_Direct (null, valueSource2);
      var valueSource0:Parameter_Direct = new Parameter_Direct (null, valueSource1);
      
      valueSource0.mValueObject = exactKeyCode;
      valueSource1.mValueObject = event.charCode;
      valueSource2.mValueObject = event.ctrlKey;
      valueSource3.mValueObject = event.shiftKey;
      valueSource4.mValueObject = mKeyHoldInfo [exactKeyCode][KeyHoldInfo_Ticks];
      
      RegisterCachedSystemEvent ([CachedEventType_General, handlerList, valueSource0]);
   }

//=============================================================
//   focus events
//=============================================================
   
   public function OnActivated (event:Event):void
   {
      HandleEventById (CoreEventIds.ID_OnGameActivated, null)
   }
   
   public function OnDeactivated (event:Event):void
   {
      // 
      ClearKeyHoldInfo (true);
      
      // todo: also a ClearMouseHoldInfo () ? This needs tracking the mouse position.
      
      // ...
      HandleEventById (CoreEventIds.ID_OnGameDeactivated, null)
   }
   
//=============================================================
//   system back
//=============================================================
   
   //public function HasSystemBackEventHandlers ():Boolean
   //{
   //   var handler_element:ListElement_EventHandler = mEventHandlersByTypes [CoreEventIds.ID_OnSystemBack];
   //   
   //   while (handler_element != null)
   //   {
   //      if (handler_element.mEventHandler.IsEnabled ())
   //         return true;
   //      
   //      handler_element = handler_element.mNextListElement;
   //   }
   //   
   //   return false;
   //}
   
   // return 1 for handled by world self.
   // return 0 to let Viewer handle the event.
   public function OnSystemBackEvent ():int
   {
      var handled:Boolean = false;
      
      var valueTarget:Parameter_Direct = new Parameter_Direct (null);
      
      var handler_element:ListElement_EventHandler = mEventHandlersByTypes [CoreEventIds.ID_OnSystemBack];
      
      while (handler_element != null)
      {
         valueTarget.mValueObject = false;
         handler_element.mEventHandler.HandleEvent (null, valueTarget);
         
         handled = handled || Boolean (valueTarget.EvaluateValueObject ());
   
         handler_element = handler_element.mNextListElement;
      }
      
      return handled ? 1 : 0;
   }

