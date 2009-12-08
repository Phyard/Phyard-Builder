
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
   
   addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
   addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
   addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
   addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
   addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
   
   // ...
   //stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
   
   //
   MoveWorldScene_DisplayOffset (0, 0);
}

private function OnRemovedFromStage (event:Event):void 
{
   // must remove this listeners, to avoid memory leak
   
   removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
   removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
   
   removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
   removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
   removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
   removeEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
   removeEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
   
   //stage.removeEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
}

//=============================================================
//   
//=============================================================

public function OnMouseDown (event:MouseEvent):void
{
   //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
   //   return;
   
   SetCurrentMode (new ModeMoveWorldScene (this));
   
   if (mCurrentMode != null)
      mCurrentMode.OnMouseDown (event.stageX, event.stageY);
}

public function OnMouseMove (event:MouseEvent):void
{
   //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
   //   return;
   
   if (mCurrentMode != null)
      mCurrentMode.OnMouseMove (event.stageX, event.stageY, event.buttonDown);
}

public function OnMouseUp (event:MouseEvent):void
{
   //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
   //   return;
   
   if (mCurrentMode != null)
      mCurrentMode.OnMouseUp (event.stageX, event.stageY);
   
   RemoveBombsAndRemovableShapes (globalToLocal (new Point (event.stageX, event.stageY)));
}

public function OnMouseOut (event:MouseEvent):void
{
   //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
   //   return;
   
   var point:Point = new Point (event.stageX, event.stageY);
   var rect:Rectangle = new Rectangle (0, 0, stage.stageWidth, stage.stageHeight);
   
   //trace ("point = " + point);
   
   var isOut:Boolean = ! rect.containsPoint (point);
   
   if ( ! isOut )
      return;
   
   SetCurrentMode (null);
}

public function OnMouseWheel (event:MouseEvent):void
{
   if (event.eventPhase != EventPhase.BUBBLING_PHASE)
      return;
}

public function OnKeyDown (event:KeyboardEvent):void
{
}
