
package editor {
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Graphics;
   
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.ui.Mouse;
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   
   
   import com.tapirgames.display.FpsCounter;
   import com.tapirgames.util.TimeSpan;
   
   import com.tapirgames.util.Logger;
   
   import editor.mode.Mode;
   import editor.mode.ModeCreateRectangle;
   import editor.mode.ModeCreateCircle;
   
   import editor.mode.ModeCreateHinge;
   import editor.mode.ModeCreateRope;
   import editor.mode.ModeCreateSlider;
   
   import editor.mode.ModeRegionSelectEntities;
   import editor.mode.ModeMoveSelectedEntities;
   
   import editor.mode.ModeRotateSelectedEntities;
   import editor.mode.ModeScaleSelectedEntities;
   
   import editor.mode.ModeMoveSelectedVertexControllers;
   
   import editor.setting.EditorSetting;
   
   import editor.display.CursorCrossingLine;
   
   import editor.entity.Entity;
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   
   import editor.entity.EntityJointRope;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   
   import editor.entity.VertexController;
   
   import editor.world.World;
   
   public class WorldView extends UIComponent 
   {
      
      private var mWorld:World;
      
      public var mBackgroundSprite:Sprite;
      public var mContentContainer:Sprite;
      public var mForegroundSprite:Sprite;
      public var mCursorLayer:Sprite;
      
      
      public function WorldView ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         //
         mBackgroundSprite = new Sprite ();
         addChild (mBackgroundSprite);
         
         mContentContainer = new Sprite ();
         addChild (mContentContainer);
         
         mForegroundSprite = new Sprite ();
         addChild (mForegroundSprite);
         
         mCursorLayer = new Sprite ();
         addChild (mCursorLayer);
         
         //
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         mWorld = new World ();
         mContentContainer.addChild (mWorld);
      }
      
      
      
//============================================================================
//   stage event
//============================================================================
      
      private function OnAddedToStage (event:Event):void 
      {
         // ...
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         addEventListener (MouseEvent.CLICK, OnMouseClick);
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         //
         stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      }
      
      private function OnResize (event:Event):void 
      {
         if (mBackgroundSprite != null)
         {
            mBackgroundSprite.graphics.clear ();
            mBackgroundSprite.graphics.beginFill(0xDDDDA0);
            mBackgroundSprite.graphics.drawRect (0, 0, width, height);
            mBackgroundSprite.graphics.endFill ();
         }
      }

      
      private var mFpsCounter:FpsCounter;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function OnEnterFrame (event:Event):void 
      {
         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         mWorld.Update (mStepTimeSpan.GetLastSpan ());
         
         // !!! seems if (DEFINE_VAR) can't includes another if clause.
         if ( Boolean(Compile::Is_Debugging) )
         {
            if (mFpsCounter == null)
            {
               mFpsCounter = new FpsCounter ();
               addChild (mFpsCounter);
            }
            
            mFpsCounter.x = (width - mFpsCounter.width) / 2;
            mFpsCounter.y = height - mFpsCounter.height;
            mFpsCounter.Update (mStepTimeSpan.GetLastSpan ());
         }
      }
      
      
//==================================================================================
// editing level
//==================================================================================
      
      public static const EditingLevel_Body:int = 0;
      public static const EditingLevel_SubBody:int = 1;
      public static const EditingLevel_Shape:int = 2;
      
      private var mEditingLevel:int = EditingLevel_Body;
      
      public function SetEditingLevel (level:int):void
      {
         mEditingLevel = level;
      }
      
      public function GetEditingLevel ():int
      {
         return mEditingLevel;
      }
      
//==================================================================================
// body editing mode
//==================================================================================
      
      public static const BodyEditingMode_Move:int = 0;
      public static const BodyEditingMode_Rotate:int = 1;
      public static const BodyEditingMode_Scale:int = 2;
      
      private var mBodyEditingMode:int = BodyEditingMode_Move;
      
      public function SetBodyEditingMode (mode:int):void
      {
         mBodyEditingMode = mode;
      }
      
      public function GetBodyEditingMode ():int
      {
         return mBodyEditingMode;
      }
      
//==================================================================================
// mode
//==================================================================================
      
      // create mode
      private var mCurrentCreatMode:Mode = null;
      private var mLastSelectedCreateButton:Button = null;
      
      // edit mode
      private var mCurrentEditMode:Mode = null;
      
      private var mModeRegionSelectEntities:ModeRegionSelectEntities = null;
      private var mModeMoveSelectedEntities:ModeMoveSelectedEntities = null;
      private var mModeRotateSelectedEntities:ModeRotateSelectedEntities = null;
      private var mModeScaleSelectedEntities:ModeScaleSelectedEntities = null;
      
      // cursors
      private var mCursorCreating:CursorCrossingLine = new CursorCrossingLine ();
      
      
      
      public function SetCurrentCreateMode (mode:Mode):void
      {
         if (mCurrentCreatMode != null)
            mCurrentCreatMode.Destroy ();
         
         mCurrentCreatMode = mode;
         
         if (mCurrentCreatMode != null)
         {
            mIsCreating = true;
            mLastSelectedCreateButton.selected = true;
            
            //mCursorLayer.addChild (mCursorCreating);
            //mCursorCreating.visible = true;
            
            //Mouse.hide();
         }
         else
         {
            mIsCreating = false;
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            
            //if ( mCursorLayer.contains (mCursorCreating) )
            //   mCursorLayer.removeChild (mCursorCreating);
            
            //mCursorCreating.visible = false;
            
            //Mouse.show();
         }
         
         if (mCurrentCreatMode != null)
            mCurrentCreatMode.Initialize ();
      }
      
      public function SetCurrentEditMode (mode:Mode):void
      {
         if (mCurrentEditMode != null)
            mCurrentEditMode.Destroy ();
         
         mCurrentEditMode = mode;
         
         if (mCurrentEditMode != null)
            mCurrentEditMode.Initialize ();
      }
      
      private var mIsCreating:Boolean = true;
      private var mIsPlaying:Boolean = false;
      private var mIsPlayingPaused:Boolean = false;
      
      private function IsCreating ():Boolean
      {
         return ! mIsPlaying && mIsCreating;
      }
      
      private function IsEditing ():Boolean
      {
         return ! mIsPlaying && ! mIsCreating;
      }
      
      private function IsPlaying ():Boolean
      {
         return mIsPlaying;
      }
      
      public function IsPlayingPaused ():Boolean
      {
         return mIsPlaying && mIsPlayingPaused;
      }
      
      
//==================================================================================
// interfaces exposed to right panel
//==================================================================================
      
      
      public var mButtonCreateBoxMovable:Button;
      public var mButtonCreateBoxStatic:Button;
      public var mButtonCreateBoxBreakable:Button;
      
      public var mButtonCreateBallUninfected:Button;
      public var mButtonCreateBallDontInfect:Button;
      public var mButtonCreateBallInfected:Button;
      public var mButtonCreateBallMovable:Button;
      public var mButtonCreateBallStatic:Button;
      
      public var mButtonCreateJointHinge:Button;
      public var mButtonCreateJointSlider:Button;
      public var mButtonCreateJointRope:Button;
      
      public var mButtonCreateComponentT:Button;
      public var mButtonCreateComponentV:Button;
      public var mButtonCreateComponent7:Button;
      
      
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         SetCurrentCreateMode (null);
         mLastSelectedCreateButton = (event.target as Button);
         
         switch (event.target)
         {
            case mButtonCreateBoxMovable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreateBoxStatic:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorMovableObject, true ) );
               break;
            case mButtonCreateBoxBreakable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorMovableObject, true ) );
               break;
            case mButtonCreateBallUninfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorMovableObject, true ) );
               break;
            case mButtonCreateBallDontInfect:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorMovableObject, true ) );
               break;
            case mButtonCreateBallInfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorMovableObject, true ) );
               break;
            case mButtonCreateBallMovable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorMovableObject, true ) );
               break;
            case mButtonCreateBallStatic:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorMovableObject, true ) );
               break;
               
            case mButtonCreateComponentT:
               SetCurrentCreateMode (null);
               break;
               SetCurrentCreateMode (null);
            case mButtonCreateComponentV:
               break;
            case mButtonCreateComponent7:
               SetCurrentCreateMode (null);
               break;
               
            case mButtonCreateJointHinge:
               SetCurrentCreateMode ( new ModeCreateHinge (this) );
               break;
            case mButtonCreateJointSlider:
               SetCurrentCreateMode ( new ModeCreateSlider (this) );
               break;
            case mButtonCreateJointRope:
               SetCurrentCreateMode ( new ModeCreateRope (this) );
               break;
            
            
            
            default:
               SetCurrentCreateMode (null);
               break;
         }
         
      }
      
      
      public function OnPlayRunRestart ():void
      {
         mIsPlaying = true;
      }
      
      public function OnPlayPauseResume ():void
      {
         mIsPlayingPaused = ! mIsPlayingPaused;
      }
      
      public function OnPlayStop ():void
      {
         mIsPlaying = false;
      }
      
      
//=================================================================================
//   mouse and key events
//=================================================================================
      
      public function LocalToLocal (display1:DisplayObject, display2:DisplayObject, point:Point):Point
      {
         return display2.globalToLocal ( display1.localToGlobal (point) );
      }
      
      public function ViewToWorld (point:Point):Point
      {
         return LocalToLocal (this, mWorld, point);
      }
      
      
      private var _mouseEventCtrlDown:Boolean = false;
      private var _mouseEventShiftDown:Boolean = false;
      private var _mouseEventAltDown:Boolean = false;
      
      private var _isZeroMove:Boolean = false;
      
      private function CheckModifierKeys (event:MouseEvent):void
      {
         _mouseEventCtrlDown = event.ctrlKey;
         _mouseEventShiftDown = event.shiftKey;
         _mouseEventAltDown = event.altKey
      }
      
      public function OnMouseClick (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         CheckModifierKeys (event);
         
         if (IsEditing ())
         {
         }
      }
      
      public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         CheckModifierKeys (event);
         _isZeroMove = true;
         
         var worldPoint:Point = LocalToLocal (event.target as DisplayObject, mWorld, new Point (event.localX, event.localY) );
         
         if (IsCreating ())
         {
            if (mCurrentCreatMode != null)
            {
               mCurrentCreatMode.OnMouseDown (worldPoint.x, worldPoint.y);
            }
         }
         
         if (IsEditing ())
         {
         // vertex controllers
            
            var vertexControllers:Array = mWorld.GetVertexControllersAtPoint (worldPoint.x, worldPoint.y);
            
            if (vertexControllers.length > 0)
            {
               if (mTheSelectedVertexController != null)
                  mTheSelectedVertexController.NotifySelectedChanged (false);
               
               mTheSelectedVertexController = vertexControllers[0] as VertexController;
               mTheSelectedVertexController.NotifySelectedChanged (true);
               
               SetCurrentEditMode (new ModeMoveSelectedVertexControllers (this));
               
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               return;
            }
            
         // entities
         
            var entityArray:Array = mWorld.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
            var entity:Entity;
            
            // move selecteds, first time
            {
               if (mWorld.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
               {
                  if (_mouseEventShiftDown && _mouseEventCtrlDown)
                  {
                  }
                  else if (_mouseEventShiftDown)
                  {
                     SetCurrentEditMode (new ModeRotateSelectedEntities (this));
                  }
                  else if (_mouseEventCtrlDown)
                  {
                     SetCurrentEditMode (new ModeScaleSelectedEntities (this));
                  }
                  else
                  {
                     SetCurrentEditMode (new ModeMoveSelectedEntities (this));
                   }
                   
                   if (mCurrentEditMode != null)
                     mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                   
                   return;
               }
            }
            
            // point select, ctrl not down.
            // for the situation: press on an unselected entity and move it
            if (entityArray.length > 0)
            {
               entity = (entityArray[0] as Entity);
               
               if (! _mouseEventCtrlDown)
               {
                  SetTheOnlySelectedEntity (entity);
                  
                  _isZeroMove = false;
               }
            }
            
            // move selecteds, 2nd time
            {
               if (mWorld.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
               {
                  SetCurrentEditMode (new ModeMoveSelectedEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                   
                  return;
               }
            }
            
            if (_mouseEventCtrlDown)
               mLastSelectedEntities = mWorld.GetSelectedEntities ();
            else
               mWorld.ClearSelectedEntities ();
            
            // region select
            {
               //var entityArray:Array = mWorld.GetEntitiyAtPoint (worldPoint.x, worldPoint.y, null);
               if (entityArray.length == 0)
               {
                  _isZeroMove = false;
                  
                  SetCurrentEditMode (new ModeRegionSelectEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               }
            }
         }
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         _isZeroMove = false;
         
         var viewPoint:Point = LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         
         if (mCursorCreating.visible)
         {
            mCursorCreating.x = viewPoint.x;
            mCursorCreating.y = viewPoint.y;
         }
         
         var worldPoint:Point = LocalToLocal (event.target as DisplayObject, mWorld, new Point (event.localX, event.localY) );
         
         if (IsCreating ())
         {
            if (mCurrentCreatMode != null)
            {
               mCurrentCreatMode.OnMouseMove (worldPoint.x, worldPoint.y);
            }
         }
         
         
         if (IsEditing ())
         {
         trace ("mCurrentEditMode = " + mCurrentEditMode);;
         
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.OnMouseMove (worldPoint.x, worldPoint.y);
            }
         }
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         
         var worldPoint:Point = LocalToLocal (event.target as DisplayObject, mWorld, new Point (event.localX, event.localY) );
         
         if (IsCreating ())
         {
            if (mCurrentCreatMode != null)
            {
               mCurrentCreatMode.OnMouseUp (worldPoint.x, worldPoint.y);
               
               return;
            }
         }
         
         
         if (IsEditing ())
         {
            if (_isZeroMove)
            {
               var entityArray:Array = mWorld.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
               var entity:Entity;
               
               // point select, ctrl down
               if (entityArray.length > 0)
               {
                  entity = (entityArray[0] as Entity);
                  
                  if (_mouseEventCtrlDown)
                  {
                     mWorld.ToggleEntitySelected (entity);
                  }
                  
                  if (! _mouseEventCtrlDown)
                  {
                     SetTheOnlySelectedEntity (entity);
                  }
                }
             }
            
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.OnMouseUp (worldPoint.x, worldPoint.y);
            }
         }
      }
      
      public function OnMouseOut (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         CheckModifierKeys (event);
         
         var point:Point = LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         var rect:Rectangle = getBounds (this);
         var isOut:Boolean = ! rect.containsPoint (point);
         
         if ( ! isOut )
            return;
         
         if (IsCreating ())
         {
            if (mCurrentCreatMode != null)
            {
               mCurrentCreatMode.Reset ();
            }
         }
         
         
         if (IsEditing ())
         {
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.Reset ();
            }
         }
      }
      
      public function OnMouseWheel (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         CheckModifierKeys (event);
         
         if (IsEditing ())
         {
         }
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         switch (event.keyCode)
         {
            case Keyboard.SPACE:
               break;
            case Keyboard.DELETE:
            case Keyboard.LEFT:
            case 68: // D
               DeleteSelectedEntities ();
               break;
            case Keyboard.INSERT:
            case Keyboard.RIGHT:
            case 65: // A
               CloneSelectedEntities ();
               break;
            case Keyboard.UP:
               break;
            case Keyboard.DOWN:
               break;
            case Keyboard.TAB:
               break;
            case Keyboard.ESCAPE:
               break;
            default:
               break;
         }
      }
      
      
//============================================================================
//    
//============================================================================
      
      public function DestroyEntity (entity:Entity):void
      {
         mWorld.DestroyEntity (entity);
      }
      
      public function CreateCircle (centerX:Number, centerY:Number, radius:Number, filledColor:uint, isStatic:Boolean):EntityShapeCircle
      {
         var centerPoint:Point = new Point (centerX, centerY);
         var edgePoint  :Point = new Point (centerX + radius, centerY);
         
         radius = Point.distance (centerPoint, edgePoint);
         
         
         var circle:EntityShapeCircle = mWorld.CreateEntityShapeCircle ();
         
         circle.SetPosition (centerX, centerY);
         circle.SetRadius (radius);
         
         circle.SetFilledColor (filledColor);
         circle.SetStatic (isStatic);
         
         return circle;
      }
      
      public function CreateRectangle (left:Number, top:Number, right:Number, bottom:Number, filledColor:uint, isStatic:Boolean):EntityShapeRectangle
      {
         var startPoint:Point = new Point (left, top);
         var endPoint  :Point = new Point (right,bottom);
         
         var centerX:Number = (startPoint.x + endPoint.x) * 0.5;
         var centerY:Number = (startPoint.y + endPoint.y) * 0.5;
         
         var halfWidth :Number = (startPoint.x - endPoint.x) * 0.5; if (halfWidth  < 0) halfWidth  = - halfWidth;
         var halfHeight:Number = (startPoint.y - endPoint.y) * 0.5; if (halfHeight < 0) halfHeight = - halfHeight;
         
         var rect:EntityShapeRectangle = mWorld.CreateEntityShapeRectangle ();
         
         rect.SetPosition (centerX, centerY);
         rect.SetHalfWidth  (halfWidth);
         rect.SetHalfHeight (halfHeight);
         
         rect.SetFilledColor (filledColor);
         rect.SetStatic (isStatic);
         
         return rect;
      }
      
      public function CreateHinge (posX:Number, posY:Number):EntityJointHinge
      {
         var hinge:EntityJointHinge = mWorld.CreateEntityJointHinge ();
         hinge.GetAnchor ().SetPosition (posX, posY);
         
         return hinge;
      }
      
      public function CreateRope (posX1:Number, posY1:Number, posX2:Number, posY2:Number):EntityJointRope
      {
         var rope:EntityJointRope = mWorld.CreateEntityJointRope ();
         rope.GetAnchor1 ().SetPosition (posX1, posY1);
         rope.GetAnchor2 ().SetPosition (posX2, posY2);
         
         return rope;
      }
      
      public function CreateSlider (posX1:Number, posY1:Number, posX2:Number, posY2:Number):EntityJointSlider
      {
         var slider:EntityJointSlider = mWorld.CreateEntityJointSlider ();
         slider.GetAnchor1 ().SetPosition (posX1, posY1);
         slider.GetAnchor2 ().SetPosition (posX2, posY2);
         
         return slider;
      }
      
//============================================================================
//    
//============================================================================
      
      
      private var mLastSelectedEntity:Entity = null;
      private var mLastSelectedEntities:Array = null;
      
      public function SetTheOnlySelectedEntity (entity:Entity):void
      {
         if (mWorld.GetSelectedEntities ().length != 1 || mWorld.GetSelectedEntities () [0] != entity)
            mWorld.SetSelectedEntity (entity);
         
         if (entity != null)
            mLastSelectedEntity = entity;
         
         entity.SetVertexControllersVisible (true);
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         var entities:Array = mWorld.GetEntitiesIntersectWithRegion (left, top, right, bottom);
         
         mWorld.ClearSelectedEntities ();
         
         if (_mouseEventCtrlDown)
         {
            if (mLastSelectedEntities != null)
               mWorld.SelectEntities (mLastSelectedEntities);
            
            mWorld.SelectEntities (entities);
         }
         else
            mWorld.SelectEntities (entities);
      }
      
      private var _SelectedEntitiesCenterPoint:Point = new Point ();
      
      public function GetSelectedEntitiesCenterPoint ():Point
      {
         var centerX:Number = 0;
         var centerY:Number = 0;
         
         var selectedEntities:Array = mWorld.GetSelectedEntities ();
         var count:uint = 0;
         
         for (var i:uint = 0; i < selectedEntities.length; ++ i)
         {
            var entity:Entity = selectedEntities[i] as Entity;
            
            if (entity != null)
            {
               centerX += entity.x;
               centerY += entity.y;
               ++ count;
            }
         }
         
         if (count > 0)
         {
            centerX /= count;
            centerY /= count;
         }
         
         _SelectedEntitiesCenterPoint.x = centerX;
         _SelectedEntitiesCenterPoint.y = centerY;
         
         return _SelectedEntitiesCenterPoint;
      }
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number):void
      {
         mWorld.MoveSelectedEntities (offsetX, offsetY);
      }
      
      public function RotateSelectedEntities (dAngle:Number):void
      {
         mWorld.RotateSelectedEntities (_SelectedEntitiesCenterPoint.x, _SelectedEntitiesCenterPoint.y, dAngle);
      }
      
      public function ScaleSelectedEntities (ratio:Number):void
      {
         mWorld.ScaleSelectedEntities (_SelectedEntitiesCenterPoint.x, _SelectedEntitiesCenterPoint.y, ratio);
      }
      
      public function DeleteSelectedEntities ():void
      {
      
      }
      
      public function CloneSelectedEntities ():void
      {
      
      }
      
//============================================================================
//    vertex controllers
//============================================================================
      
      private var mTheSelectedVertexController:VertexController = null;
      
      public function MoveSelectedVertexControllers (offsetX:Number, offsetY:Number):void
      {
         if (mTheSelectedVertexController != null)
         {
            mTheSelectedVertexController.Move (offsetX, offsetY);
         }
      }
      
//============================================================================
//    
//============================================================================
      
      
      
      
   }
}