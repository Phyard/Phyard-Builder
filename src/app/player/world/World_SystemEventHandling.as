
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

private var mCachedSystemEvents:Array = new Array ();

private function HandleCachedSystemEvent ():void
{
   var numEvents:int = mCachedSystemEvents.length;
   
   for (var i:int = 0; i < numEvents; ++ i)
   {
      var eventInfo:Array = mCachedSystemEvents [i];
      if (eventInfo [0] == CachedEventType_RemoveBombsAndRemovableShapes)
      {
         RemoveBombsAndRemovableShapes (eventInfo [1] as Array);
      }
      else
      {
         var handlerElement:ListElement_EventHandler = eventInfo [1] as ListElement_EventHandler;
         var valueSourceList:ValueSource = eventInfo [2] as ValueSource;
         
         IncStepStage ();
         while (handlerElement != null)
         {
            handlerElement.mEventHandler.HandleEvent (valueSourceList);
            
            handlerElement = handlerElement.mNextListElement;
         }
      }
   }
}

private function ClearCachedSystemEvent ():void
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

private var mCurrentMouseX:Number = 0;
private var mCurrentMouseY:Number = 0;
private var mIsMouseButtonDown:Boolean = false;

public function GetCurrentMouseX ():Number
{
   return mCurrentMouseX;
}

public function GetCurrentMouseY ():Number
{
   return mCurrentMouseY;
}

public function IsMouseButtonDown ():Boolean
{
   return mIsMouseButtonDown;
}

public function UpdateMousePositionAndHoldInfo (event:MouseEvent):void
{
   var point:Point = new Point (event.stageX, event.stageY);
   point = globalToLocal (point);
   point = mCoordinateSystem.DisplayPoint2PhysicsPosition (point.x, point.y);
   
   mCurrentMouseX = ValueAdjuster.Number2Precision (point.x, 12);
   mCurrentMouseY = ValueAdjuster.Number2Precision (point.y, 12);
   
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
   
   // ...
   stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
   stage.addEventListener (KeyboardEvent.KEY_UP, OnKeyUp);
   
   //
   addEventListener(Event.ACTIVATE, OnActivated);
   addEventListener(Event.DEACTIVATE, OnDeactivated);
   
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
   
   stage.removeEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
   stage.removeEventListener (KeyboardEvent.KEY_UP, OnKeyUp);
   
   //
   removeEventListener(Event.ACTIVATE, OnActivated);
   removeEventListener(Event.DEACTIVATE, OnDeactivated);
}

//=============================================================
//   mouse events
//   All moust events are not directly caused by the world sprite itself.
//   They are all caused by some descendants of the world sprite. 
//   So every mouse event will not be triggered twice.
//=============================================================

public function OnMouseClick (event:MouseEvent):void
{
   UpdateMousePositionAndHoldInfo (event);
   
   if (IsInteractiveEnabledNow ())
   {
      // ...
      RegisterMouseEvent (event, mEventHandlers [CoreEventIds.ID_OnWorldMouseClick]);
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
      RegisterMouseEvent (event, mEventHandlers [CoreEventIds.ID_OnWorldMouseDown]);
      
      // ...
      if (mEventHandlers [CoreEventIds.ID_OnPhysicsShapeMouseDown] != null)
      {
         var worldDisplayPoint:Point = globalToLocal (new Point (event.stageX, event.stageY));
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
}

public function OnMouseUp (event:MouseEvent):void
{
   // ...
   if (mCurrentMode != null)
      mCurrentMode.OnMouseUp (event.stageX, event.stageY);
   
   UpdateMousePositionAndHoldInfo (event);
   
   if (! IsKeyHold (KeyCodes.LeftMouseButton))
      return;
   
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
      RegisterMouseEvent (event, mEventHandlers [CoreEventIds.ID_OnWorldMouseUp]);
      
      // ...
      var worldDisplayPoint:Point = globalToLocal (new Point (event.stageX, event.stageY));
      var physicsPoint:Point = mCoordinateSystem.DisplayPoint2PhysicsPosition (worldDisplayPoint.x, worldDisplayPoint.y);
      var shapeArray:Array = mPhysicsEngine.GetShapesAtPoint (physicsPoint.x, physicsPoint.y);
      
      if (mEventHandlers [CoreEventIds.ID_OnPhysicsShapeMouseUp] != null)
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
      mCachedSystemEvents.push ([CachedEventType_RemoveBombsAndRemovableShapes, shapeArray]);
   }
   
   KeyReleased (KeyCodes.LeftMouseButton, 0);
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
      RegisterMouseEvent (event, mEventHandlers [CoreEventIds.ID_OnWorldMouseMove]);
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
}

public function RegisterMouseEvent (event:MouseEvent, handlerList:ListElement_EventHandler, shape:EntityShape = null):void
{
   if (handlerList == null)
      return;
   
   var valueSource7:ValueSource_Direct = new ValueSource_Direct (null); // is overlapped by some entities
   var valueSource6:ValueSource_Direct = new ValueSource_Direct (null, valueSource7); // alt down
   var valueSource5:ValueSource_Direct = new ValueSource_Direct (null, valueSource6); // shift down
   var valueSource4:ValueSource_Direct = new ValueSource_Direct (null, valueSource5); // ctrl down
   var valueSource3:ValueSource_Direct = new ValueSource_Direct (null, valueSource4); // button down
   var valueSource2:ValueSource_Direct = new ValueSource_Direct (null, valueSource3); // world physics y
   var valueSource1:ValueSource_Direct = new ValueSource_Direct (null, valueSource2); // world physics x
   
   valueSource1.mValueObject = mCurrentMouseX;
   valueSource2.mValueObject = mCurrentMouseY;
   valueSource3.mValueObject = event.buttonDown;
   valueSource4.mValueObject = event.ctrlKey;
   valueSource5.mValueObject = event.shiftKey;
   valueSource6.mValueObject = event.altKey;
   
   if (shape == null)
   {
      valueSource7.mValueObject = IsContentLayerContains (event.target as DisplayObject); // for world event only
      mCachedSystemEvents.push ([CachedEventType_General, handlerList, valueSource1]);
   }
   else
   {
      var valueSource0:ValueSource_Direct = new ValueSource_Direct (null, valueSource1); // entity
      valueSource0.mValueObject = shape;
      mCachedSystemEvents.push ([CachedEventType_General, handlerList, valueSource0]);
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
   
   var valueSource4:ValueSource_Direct = new ValueSource_Direct (null);
   var valueSource3:ValueSource_Direct = new ValueSource_Direct (null, valueSource4);
   var valueSource2:ValueSource_Direct = new ValueSource_Direct (null, valueSource3);
   var valueSource1:ValueSource_Direct = new ValueSource_Direct (null, valueSource2);
   var valueSource0:ValueSource_Direct = new ValueSource_Direct (null, valueSource1);
   
   valueSource0.mValueObject = exactKeyCode;
   valueSource1.mValueObject = event.charCode;
   valueSource2.mValueObject = event.ctrlKey;
   valueSource3.mValueObject = event.shiftKey;
   valueSource4.mValueObject = mKeyHoldInfo [exactKeyCode][KeyHoldInfo_Ticks];
   
   mCachedSystemEvents.push ([CachedEventType_General, handlerList, valueSource0]);
}

//=============================================================
//   focus events
//=============================================================

public function OnActivated (event:Event):void
{
   // to be exposed to users
}

public function OnDeactivated (event:Event):void
{
   // to be exposed to users
   
   // 
   ClearKeyHoldInfo (true);
   
   // todo: also a ClearMouseHoldInfo () ? This needs tracking the mouse position.
}

