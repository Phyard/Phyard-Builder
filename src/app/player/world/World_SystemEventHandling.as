
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

private function OnAddedToStage (event:Event):void 
{
   addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
   
   addEventListener (MouseEvent.CLICK, OnMouseClick);
   addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
   addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
   addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
   //addEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
   //addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
   //addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
   //addEventListener (MouseEvent.ROLL_OVER, OnRollOver);
   //addEventListener (MouseEvent.ROLL_OUT, OnRollOut);
   
   // ...
   stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
   stage.addEventListener (KeyboardEvent.KEY_UP, OnKeyUp);
   
   //
   addEventListener(Event.ACTIVATE, OnActivated);
   addEventListener(Event.DEACTIVATE, OnDeactivated);
   
   //
   MoveWorldScene_DisplayOffset (0, 0);
}

private function OnRemovedFromStage (event:Event):void 
{
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
//=============================================================

public function OnMouseClick (event:MouseEvent):void
{
   MouseEvent2ValueSourceList (event);
   HandleEventById (CoreEventIds.ID_OnWorldMouseClick, mWorldMouseEventHandlerValueSourceList);
}

public function OnMouseDown (event:MouseEvent):void
{
   MouseEvent2ValueSourceList (event);
   HandleEventById (CoreEventIds.ID_OnWorldMouseDown, mWorldMouseEventHandlerValueSourceList);
   
   // ...
   SetCurrentMode (new ModeMoveWorldScene (this));
   
   if (mCurrentMode != null)
      mCurrentMode.OnMouseDown (event.stageX, event.stageY);
}

public function OnMouseUp (event:MouseEvent):void
{
   MouseEvent2ValueSourceList (event);
   HandleEventById (CoreEventIds.ID_OnWorldMouseUp, mWorldMouseEventHandlerValueSourceList);
   
   // ...
   if (mCurrentMode != null)
      mCurrentMode.OnMouseUp (event.stageX, event.stageY);
   
   RemoveBombsAndRemovableShapes (globalToLocal (new Point (event.stageX, event.stageY)));
}

public function OnMouseMove (event:MouseEvent):void
{
   MouseEvent2ValueSourceList (event);
   HandleEventById (CoreEventIds.ID_OnWorldMouseMove, mWorldMouseEventHandlerValueSourceList);
   
   // ...
   if (mCurrentMode != null)
      mCurrentMode.OnMouseMove (event.stageX, event.stageY, event.buttonDown);
}

private var mMouseEventHandlerValueSource7:ValueSource_Direct = new ValueSource_Direct (null); // is overlapped by some entities
private var mMouseEventHandlerValueSource6:ValueSource_Direct = new ValueSource_Direct (null, mMouseEventHandlerValueSource7); // alt down
private var mMouseEventHandlerValueSource5:ValueSource_Direct = new ValueSource_Direct (null, mMouseEventHandlerValueSource6); // shift down
private var mMouseEventHandlerValueSource4:ValueSource_Direct = new ValueSource_Direct (null, mMouseEventHandlerValueSource5); // ctrl down
private var mMouseEventHandlerValueSource3:ValueSource_Direct = new ValueSource_Direct (null, mMouseEventHandlerValueSource4); // button down
private var mMouseEventHandlerValueSource2:ValueSource_Direct = new ValueSource_Direct (null, mMouseEventHandlerValueSource3); // world physics y
private var mMouseEventHandlerValueSource1:ValueSource_Direct = new ValueSource_Direct (null, mMouseEventHandlerValueSource2); // world physics x
private var mMouseEventHandlerValueSource0:ValueSource_Direct = new ValueSource_Direct (null, mMouseEventHandlerValueSource1); // entity
private var mEntityMouseEventHandlerValueSourceList:ValueSource_Direct = mMouseEventHandlerValueSource0;
private var mWorldMouseEventHandlerValueSourceList:ValueSource_Direct = mMouseEventHandlerValueSource1;

public function MouseEvent2ValueSourceList (event:MouseEvent):ValueSource_Direct
{
   var point:Point = new Point (event.stageX, event.stageY);
   point = globalToLocal (point);
   point = mCoordinateSystem.DisplayPoint2PhysicsPosition (point.x, point.y);
   
   mMouseEventHandlerValueSource1.mValueObject = point.x;
   mMouseEventHandlerValueSource2.mValueObject = point.y;
   mMouseEventHandlerValueSource3.mValueObject = event.buttonDown;
   mMouseEventHandlerValueSource4.mValueObject = event.ctrlKey;
   mMouseEventHandlerValueSource5.mValueObject = event.shiftKey;
   mMouseEventHandlerValueSource6.mValueObject = event.altKey;
   mMouseEventHandlerValueSource7.mValueObject = (event.target is DisplayObject) ? (! IsBackgroundLayerContains (event.target as DisplayObject)) : false; // for world event only
   
   return mEntityMouseEventHandlerValueSourceList; // for entities
}

//=============================================================
//   keyboard events
//=============================================================

public function OnKeyDown (event:KeyboardEvent):void
{
   // event handling can't be run simutaniously with PhysicsEngine.Step ().
   // in flash, this is not a problem. Be careful when porting to other platforms.
   
   if (IsKeyHold (event.keyCode))
      return;
   
   KeyPressed (event.keyCode, event.charCode);
   HandleKeyEventByKeyCode (event, true);
   
   //trace ("Pressed: " + String.fromCharCode (event.charCode));
}

public function OnKeyUp (event:KeyboardEvent):void
{
   // event handling can't be run simutaniously with PhysicsEngine.Step ().
   // in flash, this is not a problem. Be careful when porting to other platforms.
   
   if (! IsKeyHold (event.keyCode))
      return;
   
   HandleKeyEventByKeyCode (event, false);
   KeyReleased (event.keyCode);
   
   //trace ("Released: " + String.fromCharCode (event.charCode));
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
}

