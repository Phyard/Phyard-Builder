
package editor {
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.events.EventPhase;
   
   import flash.utils.Dictionary;
   import flash.utils.ByteArray;
   
   import flash.display.LoaderInfo;
   
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Graphics;
   
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import flash.system.System;
   
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   //import flash.ui.MouseCursor;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.net.navigateToURL;
   
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.Alert;
   import mx.events.CloseEvent;
   //import mx.events.FlexEvent;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.FpsStat;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.MathUtil;
   import com.tapirgames.util.SystemUtil;
   
   import com.tapirgames.util.Logger;
   
   //import beziercurves.events.BezierEvent;
   //import beziercurves.BezierCurve;
   
   import editor.mode.Mode;
   import editor.mode.ModeCreateRectangle;
   import editor.mode.ModeCreateCircle;
   import editor.mode.ModeCreatePolygon;
   import editor.mode.ModeCreatePolyline;
   
   import editor.mode.ModeCreateJoint;
   
   import editor.mode.ModePlaceCreateEntitiy;
   
   import editor.mode.ModeRegionSelectEntities;
   import editor.mode.ModeMoveSelectedEntities;
   
   import editor.mode.ModeRotateSelectedEntities;
   import editor.mode.ModeScaleSelectedEntities;
   
   import editor.mode.ModeMoveSelectedVertexControllers;
   
   import editor.mode.ModeMoveWorldScene;
   
   import editor.mode.ModeCreateEntityLink;
   
   
   import editor.runtime.Runtime;
   
   import editor.display.CursorCrossingLine;
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapePolygon;
   import editor.entity.EntityShapePolyline;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityShapeTextButton;
   import editor.entity.EntityShapeGravityController;
   
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   import editor.entity.EntityJointWeld;
   import editor.entity.EntityJointDummy;
   
   import editor.entity.SubEntityJointAnchor;
   import editor.entity.SubEntityHingeAnchor;
   import editor.entity.SubEntitySliderAnchor;
   import editor.entity.SubEntityDistanceAnchor;
   import editor.entity.SubEntitySpringAnchor;
   import editor.entity.SubEntityWeldAnchor;
   import editor.entity.SubEntityDummyAnchor;
   
   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   
   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   import editor.trigger.entity.EntityAction;
   
   import editor.trigger.entity.InputEntitySelector;
   
   import editor.trigger.CodeSnippet;
   
   import editor.entity.VertexController;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.world.World;
   import editor.world.CollisionManager;
   import editor.undo.WorldHistoryManager;
   import editor.undo.WorldState;
   
   import editor.trigger.entity.Linkable;
   
   import editor.trigger.Filters;
   
   import player.world.World;
   //import player.ui.PlayHelpDialog;
   //import player.ui.PlayControlBar;
   import wrapper.ColorInfectionPlayer;
   
   import common.WorldDefine;
   import common.DataFormat;
   import common.DataFormat2;
   import common.Define;   
   import common.Config;
   import common.ValueAdjuster;
   
   import common.trigger.CoreEventIds;
   import common.KeyCodes;
   
   import misc.Analytics;
   
   public class WorldView extends UIComponent 
   {
      public static const DefaultWorldWidth:int = Define.DefaultWorldWidth; 
      public static const DefaultWorldHeight:int = Define.DefaultWorldHeight;
      public static const WorldBorderThinknessLR:int = Define.WorldBorderThinknessLR;
      public static const WorldBorderThinknessTB:int = Define.WorldBorderThinknessTB;
      
      public static const BackgroundGridSize:int = 50;
      
      public var mViewBackgroundSprite:Sprite = null;
      
      private var mEditorElementsContainer:Sprite;
      
         public var mEditorBackgroundSprite:Sprite = null;
            public var mEntityLinksSprite:Sprite = null;
         public var mContentContainer:Sprite;
         public var mWorldDebugInfoSprite:Sprite;
         public var mForegroundSprite:Sprite;
         public var mCursorLayer:Sprite;
         
         private var mSelectedEntitiesCenterSprite:Sprite;
         private var mStatusBarEntityInfoSprite:Sprite;
         
      private var mPlayerElementsContainer:Sprite;
      private var mTopLayerContainer:Sprite;
         
      //
      
      //
      //public var mCollisionManagerView:CollisionManagerView = null;
      
      //
      private var mEditorWorld:editor.world.World;
      
         private var mViewCenterWorldX:Number = DefaultWorldWidth * 0.5;
         private var mViewCenterWorldY:Number = DefaultWorldHeight * 0.5;
         private var mEditorWorldZoomScale:Number = 1.0;
         private var mEditorWorldZoomScaleChangedSpeed:Number = 0.0;
         
         private var mViewWidth:Number        = DefaultWorldWidth;
         private var mViewHeight:Number       = DefaultWorldHeight;
      
      private var mWorldHistoryManager:WorldHistoryManager;
      
      private var mDesignPlayer:ColorInfectionPlayer = null;
         
      // ...
      private var mAnalyticsDurations:Array = [0.5, 1, 2, 5, 10, 15, 20, 30];
      private var mAnalytics:Analytics;
      
      public function WorldView ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         //
         mViewBackgroundSprite = new Sprite ();
         addChild (mViewBackgroundSprite);
         
         //
         mEditorElementsContainer = new Sprite ();
         addChild (mEditorElementsContainer);
         
         //
         mContentContainer = new Sprite ();
         mEditorElementsContainer.addChild (mContentContainer);
         
         mWorldDebugInfoSprite = new Sprite ();
         mEditorElementsContainer.addChild (mWorldDebugInfoSprite);
         
         mForegroundSprite = new Sprite ();
         mEditorElementsContainer.addChild (mForegroundSprite);
         
            mSelectedEntitiesCenterSprite = new Sprite ();
            mSelectedEntitiesCenterSprite.alpha = 0.25;
            mSelectedEntitiesCenterSprite.visible = false;
            mSelectedEntitiesCenterSprite.graphics.beginFill(0x000000);
            mSelectedEntitiesCenterSprite.graphics.drawCircle (0, 0, 6);
            mSelectedEntitiesCenterSprite.graphics.endFill ();
            mSelectedEntitiesCenterSprite.graphics.beginFill(0x00FF00);
            mSelectedEntitiesCenterSprite.graphics.drawCircle (0, 0, 5);
            mSelectedEntitiesCenterSprite.graphics.endFill ();
            mSelectedEntitiesCenterSprite.graphics.beginFill(0x000000);
            mSelectedEntitiesCenterSprite.graphics.drawCircle (0, 0, 2);
            mSelectedEntitiesCenterSprite.graphics.endFill ();
            mForegroundSprite.addChild (mSelectedEntitiesCenterSprite);
            
            mStatusBarEntityInfoSprite = new Sprite ();
            mForegroundSprite.addChild (mStatusBarEntityInfoSprite);
            
         mCursorLayer = new Sprite ();
         mEditorElementsContainer.addChild (mCursorLayer);
         
         //
         mPlayerElementsContainer = new Sprite ();
         mPlayerElementsContainer.visible = false;
         addChild (mPlayerElementsContainer);
         
         mTopLayerContainer = new Sprite ();
         mTopLayerContainer.visible = true;
         addChild (mTopLayerContainer);
         
         //
         
         mWorldHistoryManager = new WorldHistoryManager ();
         SetEditorWorld (new editor.world.World (), true);
         CreateUndoPoint ();
         
         //
         UpdateChildComponents ();
         
         //
         BuildContextMenu ();
         
         //
         RegisterNotifyFunctions ();
      }
      
      public function GetEditorWorld ():editor.world.World
      {
         return mEditorWorld;
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
         addEventListener (MouseEvent.ROLL_OVER, OnMouseOut);
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         // ...
         stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
         
         // ...
         UpdateUiButtonsEnabledStatus ();
         
         //
         mAnalytics = new Analytics (this, mAnalyticsDurations);
         mAnalytics.TrackPageview (Config.VirtualPageName_EditorJustLoaded);
         
         //
         OnlineLoad (true);
      }
      
      private var mContentMaskSprite:Shape = null;
      
      private function OnResize (event:Event):void 
      {
         mViewWidth  = parent.width;
         mViewHeight = parent.height;
         
         trace ("mViewWidth = " + mViewWidth);
         trace ("mViewHeight = " + mViewHeight);
         
         mViewBackgroundSprite.graphics.clear ();
         mViewBackgroundSprite.graphics.beginFill(0xFFFFFF);
         mViewBackgroundSprite.graphics.drawRect (0, 0, mViewWidth, mViewHeight);
         mViewBackgroundSprite.graphics.endFill ();
         
         // mask
         {
            if (mContentMaskSprite == null)
               mContentMaskSprite = new Shape ();
            
            mContentMaskSprite.graphics.clear ();
            mContentMaskSprite.graphics.beginFill(0x0);
            mContentMaskSprite.graphics.drawRect (0, 0, mViewWidth, mViewHeight);
            mContentMaskSprite.graphics.endFill ();
            mContentContainer.addChild (mContentMaskSprite);
            
            this.mask = mContentMaskSprite;
         }
         
         //
         UpdateChildComponents ();
      }
      
      private var mFpsStat:FpsStat = new FpsStat ();
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function OnEnterFrame (event:Event):void 
      {
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         mFpsStat.Step (mStepTimeSpan.GetLastSpan ());
         
         //
         var newScale:Number;
         
         if ( IsPlaying () )
         {
            // mDesignPlayer.Update
            // will call mDesignPlayer.EnterFrame ()
            
            //
            UpdateDesignPalyerPosition ();
            var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld ();
            var playingSteps:int = playerWorld == null ? 0 : playerWorld.GetSimulatedSteps ();
            StatusBar_SetRunningSteps ("Step#" + playingSteps);
            StatusBar_SetRunningFPS ("FPS: " + mFpsStat.GetFps ().toFixed (2));
         }
         else
         {
            if (mEditorWorld.scaleX != mEditorWorldZoomScale)
            {
               if (mEditorWorld.scaleX < mEditorWorldZoomScale)
               {
                  if (mEditorWorldZoomScaleChangedSpeed < 0)
                     mEditorWorldZoomScaleChangedSpeed = - mEditorWorldZoomScaleChangedSpeed;
                  
                  newScale = mEditorWorld.scaleX + mEditorWorldZoomScaleChangedSpeed;
                  mEditorWorld.scaleY = mEditorWorld.scaleX = newScale;
                  
                  if (mEditorWorld.scaleX >= mEditorWorldZoomScale)
                     mEditorWorld.SetZoomScale (mEditorWorldZoomScale);
               }
               else
               {
                  if (mEditorWorldZoomScaleChangedSpeed > 0)
                     mEditorWorldZoomScaleChangedSpeed = - mEditorWorldZoomScaleChangedSpeed;
                  
                  newScale = mEditorWorld.scaleX + mEditorWorldZoomScaleChangedSpeed;
                  mEditorWorld.scaleY = mEditorWorld.scaleX = newScale;
                  
                  if (mEditorWorld.scaleX <= mEditorWorldZoomScale)
                     mEditorWorld.SetZoomScale (mEditorWorldZoomScale);
               }
               
               UpdateBackgroundAndWorldPosition ();
            }
            
            if (mEntityLinksSprite.scaleX != mEditorWorld.scaleX)
               mEntityLinksSprite.scaleX = mEditorWorld.scaleX;
            if (mEntityLinksSprite.scaleY != mEditorWorld.scaleY)
               mEntityLinksSprite.scaleY = mEditorWorld.scaleY;
            if (mEntityLinksSprite.x != mEditorWorld.x)
               mEntityLinksSprite.x = mEditorWorld.x;
            if (mEntityLinksSprite.y != mEditorWorld.y)
               mEntityLinksSprite.y = mEditorWorld.y;
            
            mEditorWorld.Update (mStepTimeSpan.GetLastSpan ());
         }
         
         // ...
         mAnalytics.TrackTime (Config.VirtualPageName_EditorTimePrefix);
      }
      
//==================================================================================
// painted interfaces
//==================================================================================
      
      public function UpdateChildComponents ():void
      {
         UpdateBackgroundAndWorldPosition ();
         //UpdateViewInterface ();
         UpdateSelectedEntityInfo ();
      }
      
      public function UpdateBackgroundAndWorldPosition ():void
      {
         if (mEditorBackgroundSprite == null)
         {
            mEditorBackgroundSprite = new Sprite ();
            mEditorElementsContainer.addChildAt (mEditorBackgroundSprite, 0);
            
            mEntityLinksSprite = new Sprite ();
            mEditorBackgroundSprite.addChild (mEntityLinksSprite);
         }
         
         var sceneLeft  :Number;
         var sceneTop   :Number;
         var sceneWidth :Number;
         var sceneHeight:Number;
         
         if (mEditorWorld.IsInfiniteSceneSize ())
         {
            sceneLeft   = - 0x7FFFFFFF;
            sceneTop    = - 0x7FFFFFFF;
            sceneWidth  = uint (0xFFFFFFFF);
            sceneHeight = uint (0xFFFFFFFF);
         }
         else
         {
            sceneLeft   = mEditorWorld.GetWorldLeft ();
            sceneTop    = mEditorWorld.GetWorldTop ();
            sceneWidth  = mEditorWorld.GetWorldWidth ();
            sceneHeight = mEditorWorld.GetWorldHeight ();
         }
         
         var bgColor    :uint = mEditorWorld.GetBackgroundColor ();
         var borderColor:uint = mEditorWorld.GetBorderColor ();
         var drawBorder:Boolean = mEditorWorld.IsBuildBorder ();
         
         if (mViewCenterWorldX < sceneLeft)
            mViewCenterWorldX = sceneLeft;
         if (mViewCenterWorldX > sceneLeft + sceneWidth)
            mViewCenterWorldX = sceneLeft + sceneWidth;
         if (mViewCenterWorldY < sceneTop)
            mViewCenterWorldY = sceneTop;
         if (mViewCenterWorldY > sceneTop + sceneHeight)
            mViewCenterWorldY = sceneTop + sceneHeight;
         
         mEditorWorld.SetCameraCenterX (mViewCenterWorldX);
         mEditorWorld.SetCameraCenterY (mViewCenterWorldY);
         
         //mEditorWorld.SetZoomScale (mEditorWorldZoomScale);
         
         var worldOriginViewX:Number = (0 - mViewCenterWorldX) * mEditorWorld.scaleX + mViewWidth  * 0.5;
         var worldOriginViewY:Number = (0 - mViewCenterWorldY) * mEditorWorld.scaleY + mViewHeight * 0.5;
         var worldViewLeft:Number   = (sceneLeft - mViewCenterWorldX) * mEditorWorld.scaleX + mViewWidth  * 0.5;
         var worldViewTop:Number    = (sceneTop  - mViewCenterWorldY) * mEditorWorld.scaleY + mViewHeight * 0.5;
         var worldViewRight:Number  = worldViewLeft + sceneWidth  * mEditorWorld.scaleX;
         var worldViewBottom:Number = worldViewTop  + sceneHeight * mEditorWorld.scaleY;
         var worldViewWidth:Number  = sceneWidth  * mEditorWorld.scaleX;
         var worldViewHeight:Number = sceneHeight * mEditorWorld.scaleY;
         
         mEditorWorld.x = Math.round (worldOriginViewX);
         mEditorWorld.y = Math.round (worldOriginViewY);
         
         //>>
         var adjustDx:Number = Math.round (worldOriginViewX) - worldOriginViewX;
         var adjustDy:Number = Math.round (worldOriginViewY) - worldOriginViewY;
         
         worldOriginViewX += adjustDx;
         worldOriginViewY += adjustDy;
         worldViewLeft += adjustDx;
         worldViewTop += adjustDy;
         worldViewRight += adjustDx;
         worldViewBottom += adjustDy;
         
         mEditorWorld.x += adjustDx;
         mEditorWorld.y += adjustDy;
         //<<
         
         //SynchrinizePlayerWorldWithEditorWorld ();
         UpdateSelectedEntitiesCenterSprite ();
         
         var bgLeft:Number   = worldViewLeft   < 0           ? 0           : worldViewLeft;
         var bgTop:Number    = worldViewTop    < 0           ? 0           : worldViewTop;
         var bgRight:Number  = worldViewRight  > mViewWidth  ? mViewWidth  : worldViewRight;
         var bgBottom:Number = worldViewBottom > mViewHeight ? mViewHeight : worldViewBottom;
         var bgWidth :Number = bgRight - bgLeft;
         var bgHeight:Number = bgBottom - bgTop;
         
         var gridWidth:Number  = BackgroundGridSize * mEditorWorld.scaleX;
         var gridHeight:Number = BackgroundGridSize * mEditorWorld.scaleY;
         
         var gridX:Number;
         if (bgLeft == worldViewLeft)
            gridX = bgLeft;
         else
            gridX = bgLeft + (gridWidth - (bgLeft - worldViewLeft) % gridWidth);
         var gridY:Number;
         if (bgTop == worldViewTop)
            gridY = bgTop;
         else
            gridY = bgTop  + (gridHeight - (bgTop  - worldViewTop) % gridHeight);
         
      // paint
         
         mEditorBackgroundSprite.graphics.clear ();
         
         mEditorBackgroundSprite.graphics.beginFill(bgColor);
         mEditorBackgroundSprite.graphics.drawRect (bgLeft, bgTop, bgWidth, bgHeight);
         mEditorBackgroundSprite.graphics.endFill ();
         
         mEditorBackgroundSprite.graphics.lineStyle (1, 0xA0A0A0);
         while (gridX <= bgRight)
         {
            mEditorBackgroundSprite.graphics.moveTo (gridX, bgTop);
            mEditorBackgroundSprite.graphics.lineTo (gridX, bgBottom);
            gridX += gridWidth;
         }
         
         while (gridY <= bgBottom)
         {
            mEditorBackgroundSprite.graphics.moveTo (bgLeft, gridY);
            mEditorBackgroundSprite.graphics.lineTo (bgRight, gridY);
            gridY += gridHeight;
         }
         mEditorBackgroundSprite.graphics.lineStyle ();
         
         if (drawBorder)
         {
            var borderThinknessL:Number = mEditorWorld.GetWorldBorderLeftThickness () * mEditorWorld.scaleX;
            var borderThinknessR:Number = mEditorWorld.GetWorldBorderRightThickness () * mEditorWorld.scaleX;
            var borderThinknessT:Number = mEditorWorld.GetWorldBorderTopThickness () * mEditorWorld.scaleY;
            var borderThinknessB:Number = mEditorWorld.GetWorldBorderBottomThickness () * mEditorWorld.scaleY;
            
            mEditorBackgroundSprite.graphics.beginFill(borderColor);
            mEditorBackgroundSprite.graphics.drawRect (worldViewLeft, worldViewTop, borderThinknessL, worldViewHeight);
            mEditorBackgroundSprite.graphics.drawRect (worldViewRight - borderThinknessR, worldViewTop, borderThinknessR, worldViewHeight);
            mEditorBackgroundSprite.graphics.endFill ();
            
            mEditorBackgroundSprite.graphics.beginFill(borderColor);
            mEditorBackgroundSprite.graphics.drawRect (worldViewLeft, worldViewTop, worldViewWidth, borderThinknessT);
            mEditorBackgroundSprite.graphics.drawRect (worldViewLeft, worldViewBottom - borderThinknessB, worldViewWidth, borderThinknessB);
            mEditorBackgroundSprite.graphics.endFill ();
         }
      }
      
      public function UpdateSelectedEntityInfo ():void
      {
         // ...
         if (mLastSelectedEntity != null && ! mEditorWorld.IsEntitySelected (mLastSelectedEntity))
            SetLastSelectedEntities (null);
         
         if (mLastSelectedEntity == null)
         {
            if (StatusBar_SetMainSelectedEntityInfo != null)
               StatusBar_SetMainSelectedEntityInfo (null);
            return;
         }
         
         var typeName:String = mLastSelectedEntity.GetMainEntity ().GetTypeName ();
         var infoText:String = mLastSelectedEntity.GetMainEntity ().GetInfoText ();
         
         StatusBar_SetMainSelectedEntityInfo ("<b>&lt;" + mEditorWorld.GetEntityCreationId (mLastSelectedEntity.GetMainEntity ()) + "&gt; " + typeName + "</b>: " + infoText);
      }
      
      private function UpdateMousePointInfo (stagePoint:Point):void
      {
         if (stagePoint == null)
         {
            StatusBar_SetMainDisplayPosition (null);
            StatusBar_SetMainPhysicsPosition (null);
            return;
         }
         
         var px:Number;
         var py:Number;
         var worldPoint:Point;
         
         if ( IsPlaying () )
         {
            if (mDesignPlayer != null)
            {
               var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld ();
               if (playerWorld != null)
               {
                  worldPoint = playerWorld.globalToLocal (new Point (stagePoint.x, stagePoint.y));
                  px = ValueAdjuster.Number2Precision (playerWorld.GetCoordinateSystem ().D2P_PositionX (worldPoint.x), 6);
                  py = ValueAdjuster.Number2Precision (playerWorld.GetCoordinateSystem ().D2P_PositionY (worldPoint.y), 6);
               }
            }
         }
         else
         {
            worldPoint = mEditorWorld.globalToLocal (new Point (Math.round(stagePoint.x), Math.round (stagePoint.y)));
            px = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_PositionX (worldPoint.x), 6);
            py = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_PositionY (worldPoint.y), 6);
         }
         
         StatusBar_SetMainDisplayPosition ("(" + worldPoint.x + "px, " + worldPoint.y + "px)");
         StatusBar_SetMainPhysicsPosition ("(" + px.toFixed (2) + "m,  " + py.toFixed (2) + "m)");
      }
      
      private function UpdateSelectedEntitiesCenterSprite ():void
      {
         //var point:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, this, _SelectedEntitiesCenterPoint );
         var point:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, mForegroundSprite, _SelectedEntitiesCenterPoint );
         mSelectedEntitiesCenterSprite.x = point.x;
         mSelectedEntitiesCenterSprite.y = point.y;
      }
      
      public function RepaintEntityLinks ():void
      {
         mEntityLinksSprite.graphics.clear ();
         
         if (mEditorWorld != null)
            mEditorWorld.DrawEntityLinkLines (mEntityLinksSprite);
      }
      
      public function RepaintWorldDebugInfo ():void
      {
         if (Compile::Is_Debugging)// && false)
         {
            mWorldDebugInfoSprite.x = mEditorWorld.x;
            mWorldDebugInfoSprite.y = mEditorWorld.y;
            mWorldDebugInfoSprite.scaleX = mEditorWorld.scaleX;
            mWorldDebugInfoSprite.scaleY = mEditorWorld.scaleY;
            
            while (mWorldDebugInfoSprite.numChildren > 0)
               mWorldDebugInfoSprite.removeChildAt (0);
            
            mEditorWorld.RepaintContactsInLastRegionSelecting (mWorldDebugInfoSprite);
         }
      }
      
//==================================================================================
// reponse to some world modififactions
//==================================================================================
      
      private function RegisterNotifyFunctions ():void
      {
         InputEntitySelector.sNotifyEntityLinksModified = NotifyEntityLinksModified;
      }
      
      private function NotifyEntityLinksModified ():void
      {
         RepaintEntityLinks ();
      }
      
//==================================================================================
// mode
//==================================================================================
      
      // create mode
      private var mCurrentCreatMode:Mode = null;
      private var mLastSelectedCreateButton:Button = null;
      
      // edit mode
      private var mCurrentEditMode:Mode = null;
      
      // cursors
      private var mCursorCreating:CursorCrossingLine = new CursorCrossingLine ();
      
      
      
      public function SetCurrentCreateMode (mode:Mode):void
      {
         if (mCurrentCreatMode != null)
            mCurrentCreatMode.Destroy ();
         //CancelCurrentCreatingMode ();
         
         if (Runtime.HasSettingDialogOpened ())
         {
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            return;
         }
         
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
         
         UpdateUiButtonsEnabledStatus ();
         
         if (mCurrentCreatMode != null)
            mCurrentCreatMode.Initialize ();
      }
      
      public function CancelCurrentCreatingMode ():void
      {
         if (mCurrentCreatMode != null)
         {
            mCurrentCreatMode.Reset ();
            SetCurrentCreateMode (null);
         }
         
         UpdateUiButtonsEnabledStatus ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function SetCurrentEditMode (mode:Mode):void
      {
         if (mCurrentEditMode != null)
            mCurrentEditMode.Destroy ();
         
         if (Runtime.HasSettingDialogOpened ())
         {
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            return;
         }
         
         mCurrentEditMode = mode;
         
         if (mCurrentEditMode != null)
            mCurrentEditMode.Initialize ();
      }
      
      private var mIsCreating:Boolean = false;
      
      private var mIsPlaying:Boolean = false;
      
      private function IsCreating ():Boolean
      {
         return ! mIsPlaying && mIsCreating;
      }
      
      private function IsEditing ():Boolean
      {
         return ! mIsPlaying && ! mIsCreating;
      }
      
      public function IsPlaying ():Boolean
      {
         return mIsPlaying;
      }
      
      public function IsPlayingPaused ():Boolean
      {
         return mIsPlaying && mDesignPlayer != null && (! mDesignPlayer.IsPlaying ());
      }
      
//==================================================================================
// outer components
//==================================================================================
      
      //public var mStatusMessageBar:Label;
      
      
      
      public var mButtonCreateBoxMovable:Button;
      public var mButtonCreateBoxStatic:Button;
      public var mButtonCreateBoxBreakable:Button;
      public var mButtonCreateBoxInfected:Button;
      public var mButtonCreateBoxUninfected:Button;
      public var mButtonCreateBoxDontinfect:Button;
      public var mButtonCreateBoxBomb:Button;
      
      public var mButtonCreateBallMovable:Button;
      public var mButtonCreateBallStatic:Button;
      public var mButtonCreateBallBreakable:Button;
      public var mButtonCreateBallInfected:Button;
      public var mButtonCreateBallUninfected:Button;
      public var mButtonCreateBallDontInfect:Button;
      public var mButtonCreateBallBomb:Button;
      
      public var mButtonCreatePolygonStatic:Button;
      public var mButtonCreatePolygonMovable:Button;
      public var mButtonCreatePolygonBreakable:Button;
      public var mButtonCreatePolygonInfected:Button;
      public var mButtonCreatePolygonUninfected:Button;
      public var mButtonCreatePolygonDontinfect:Button;
      
      public var mButtonCreatePolylineStatic:Button;
      public var mButtonCreatePolylineMovable:Button;
      public var mButtonCreatePolylineBreakable:Button;
      public var mButtonCreatePolylineInfected:Button;
      public var mButtonCreatePolylineUninfected:Button;
      public var mButtonCreatePolylineDontinfect:Button;
      
      public var mButtonCreateJointHinge:Button;
      public var mButtonCreateJointSlider:Button;
      public var mButtonCreateJointDistance:Button;
      public var mButtonCreateJointSpring:Button;
      public var mButtonCreateJointWeld:Button;
      public var mButtonCreateJointHingeSlider:Button;
      public var mButtonCreateJointDummy:Button;
      
      public var mButtonCreateText:Button;
      public var mButtonCreateGravityController:Button;
      public var mButtonCreateBox:Button;
      public var mButtonCreateBall:Button;
      public var mButtonCreatePolygon:Button;
      public var mButtonCreatePolyline:Button;
      public var mButtonCreateCamera:Button;
      public var mButtonCreateTextButton:Button;
      
      public var mButton_CreateCondition:Button;
      public var mButton_CreateConditionDoor:Button;
      public var mButton_CreateTask:Button;
      public var mButton_CreateEntityAssigner:Button;
      public var mButton_CreateEntityPairAssigner:Button;
      public var mButton_CreateAction:Button;
      public var mButton_CreateEventHandler0:Button;
      public var mButton_CreateEventHandler1:Button;
      public var mButton_CreateEventHandler2:Button;
      public var mButton_CreateEventHandler3:Button;
      public var mButton_CreateEventHandler4:Button;
      public var mButton_CreateEventHandler5:Button;
      public var mButton_CreateEventHandler6:Button;
      public var mButton_CreateEventHandler7:Button;
      public var mButton_CreateEventHandler8:Button;
      public var mButton_CreateEventHandler50:Button;
      public var mButton_CreateEventHandler51:Button;
      public var mButton_CreateEventHandler52:Button;
      public var mButton_CreateEventHandler53:Button;
      public var mButton_CreateEventHandler56:Button;
      public var mButton_CreateEventHandler57:Button;
      public var mButton_CreateEventHandler58:Button;
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         if (mCurrentCreatMode != null)
         {
            SetCurrentCreateMode (null);
            
            if (mLastSelectedCreateButton == event.target as Button)
            {
               mLastSelectedCreateButton.selected = false;
               mLastSelectedCreateButton = null;
               return;
            }
         }
         
         mLastSelectedCreateButton = (event.target as Button);
         
         switch (event.target)
         {
         // CI boxes
            
            case mButtonCreateBoxMovable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreateBoxStatic:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreateBoxBreakable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, true ) );
               break;
            case mButtonCreateBoxInfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBoxUninfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBoxDontinfect:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBoxBomb:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Bomb, Define.ColorBombObject, false, true, Define.MinBombSquareSideLength, Define.MaxBombSquareSideLength ) );
               break;
               
         // CI balls
            
            case mButtonCreateBallMovable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreateBallStatic:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreateBallBreakable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, false ) );
               break;
            case mButtonCreateBallInfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBallUninfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBallDontInfect:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBallBomb:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Bomb, Define.ColorBombObject, false, Define.MinCircleRadius, Define.MaxBombSquareSideLength * 0.5 ) );
               break;
               
         // CI polygons
            
            case mButtonCreatePolygonMovable:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolygonStatic:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreatePolygonBreakable:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, true ) );
               break;
            case mButtonCreatePolygonInfected:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, false ) );
               break;
            case mButtonCreatePolygonUninfected:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, false ) );
               break;
            case mButtonCreatePolygonDontinfect:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, false ) );
               break;
            
         // CI polylines
            
            case mButtonCreatePolylineMovable:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Movable, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolylineStatic:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Static, Define.ColorStaticObject, true ) );
               break
            case mButtonCreatePolylineBreakable:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Breakable, Define.ColorBreakableObject, true ) );
               break;
            case mButtonCreatePolylineInfected:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Infected, Define.ColorInfectedObject, true ) );
               break;
            case mButtonCreatePolylineUninfected:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Uninfected, Define.ColorUninfectedObject, true ) );
               break;
            case mButtonCreatePolylineDontinfect:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_DontInfect, Define.ColorDontInfectObject, true ) );
               break;
            
          // general box, ball, polygons, polyline
            
            case mButtonCreateBox:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Unknown, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreateBall:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Unknown, Define.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolygon:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Unknown, Define.ColorStaticObject, true ) );
               break;
            case mButtonCreatePolyline:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Unknown,Define.ColorStaticObject, true ) );
               break;
               
         // joints
            
            case mButtonCreateJointHinge:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateHinge) );
               break;
            case mButtonCreateJointSlider:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateSlider) );
               break;
            case mButtonCreateJointDistance:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateDistance) );
               break;
            case mButtonCreateJointSpring:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateSpring) );
               break;
            case mButtonCreateJointWeld:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateWeldJoint) );
               break;
            case mButtonCreateJointHingeSlider:
               break;
            case mButtonCreateJointDummy:
               SetCurrentCreateMode ( new ModeCreateJoint (this, CreateDummyJoint) );
               break;
            
         // others
            
            case mButtonCreateText:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateText));
               break;
            case mButtonCreateGravityController:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateGravityController));
               break;
            case mButtonCreateCamera:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityUtilityCamera));
               break;
            case mButtonCreateTextButton:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityTextButton));
               break;
            
          // logic
          
            case mButton_CreateCondition:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityCondition) );
               break;
            case mButton_CreateConditionDoor:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityConditionDoor) );
               break;
            case mButton_CreateTask:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityTask) );
               break;
            case mButton_CreateAction:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityAction) );
               break;
            case mButton_CreateEntityAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityInputEntityAssigner) );
               break;
            case mButton_CreateEntityPairAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityInputEntityPairAssigner) );
               break;
            case mButton_CreateEventHandler0:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldBeforeInitializing, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler1:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldAfterInitialized, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler2:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLWorldBeforeUpdating, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler3:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldAfterUpdated, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler4:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointReachLowerLimit, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler5:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointReachUpperLimit, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler6:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldTimer, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler7:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldKeyDown, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler8:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldMouseClick, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler50:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityInitialized, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler51:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityUpdated, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler52:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityDestroyed, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler53:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler56:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityPairTimer, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler57:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityTimer, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler58:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityMouseClick, mPotientialEventIds:null}) );
               break;
            
         // ...
            default:
               SetCurrentCreateMode (null);
               break;
         }
         
      }
      
      public var mButtonClone:Button;
      public var mButtonDelete:Button;
      public var mButtonFlipH:Button;
      public var mButtonFlipV:Button;
      public var mButtonGlue:Button;
      public var mButtonBreakApart:Button;
      public var mButtonSetting:Button;
      public var mButtonMoveToTop:Button;
      public var mButtonMoveToBottom:Button;
      public var mButtonUndo:Button;
      public var mButtonRedo:Button;
      public var mButtonMouseMoveScene:Button;
      public var mButtonMouseSelectGlued:Button;
      public var mButtonMouseSelectSingle:Button;
      public var mButtonMouseMove:Button;
      public var mButtonMouseRotate:Button;
      public var mButtonMouseScale:Button;
      
      public var mButton_Play:Button;
      public var mButton_Stop:Button;
      
      public var mButtonNewDesign:Button;
      public var mButtonSaveWorld:Button;
      public var mButtonLoadWorld:Button;
      
      public var mButtonHideShapes:Button;
      public var mButtonHideJoints:Button;
      public var mButtonHideTriggers:Button;
      
      private function UpdateUiButtonsEnabledStatus ():void
      {
      // edit
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         
         //mButtonSetting.enabled = selectedEntities.length == 1 && IsEntitySettingable (selectedEntities[0]);
         mButtonSetting.enabled = mLastSelectedEntity != null && IsEntitySettingable (mLastSelectedEntity);
         
         mButtonDelete.enabled = mButtonFlipH.enabled = mButtonFlipV.enabled = 
         mButtonMoveToTop.enabled = mButtonMoveToBottom.enabled = selectedEntities.length > 0;
         mButtonGlue.enabled = mButtonBreakApart.enabled = selectedEntities.length > 1;
         
         mButtonUndo.enabled = mWorldHistoryManager.GetPrevWorldState () != null;
         mButtonRedo.enabled = mWorldHistoryManager.GetNextWorldState () != null;
         
         if (selectedEntities.length == 0)
            mButtonClone.enabled = false;
         else
         {
            var clonedable:Boolean = false;
            
            for (var i:int = 0; i < selectedEntities.length; ++ i)
            {
               if ( (selectedEntities[i] as Entity).IsClonedable () )
               {
                  clonedable = true;
                  break;
               }
            }
            
            mButtonClone.enabled = clonedable;
         }
         
      // creat ...
         
         //mButtonCreateGravityController.enabled = mEditorWorld.GetNumEntities (Filters.IsGravityControllerEntity) == 0;
         //mButtonCreateCamera           .enabled = mEditorWorld.GetNumEntities (Filters.IsCameraEntity) == 0;
         
      // file ...
         
         mButtonNewDesign.enabled = true; //mEditorWorld.numChildren > 0;
         
      // context menu
         
         mMenuItemExportSelectedsToSystemMemory.enabled = selectedEntities.length > 0;
      }
      
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
            case mButtonNewDesign:
               ClearAllEntities ();
               break;
            case mButtonSaveWorld:
               OpenWorldSavingDialog ();
               break;
            case mButtonLoadWorld:
               OpenWorldLoadingDialog ();
               break;
            
            case mButtonClone:
               CloneSelectedEntities ();
               break;
            case mButtonDelete:
               DeleteSelectedEntities ();
               break;
            case mButtonFlipH:
               FlipSelectedEntitiesHorizontally ();
               break;
            case mButtonFlipV:
               FlipSelectedEntitiesVertically ();
               break;
            case mButtonGlue:
               GlueSelectedEntities ();
               break;
            case mButtonBreakApart:
               BreakApartSelectedEntities ();
               break;
            case mButtonSetting:
               OpenEntitySettingDialog ();
               break;
            case mButtonMoveToTop:
               MoveSelectedEntitiesToTop ();
               break;
            case mButtonMoveToBottom:
               MoveSelectedEntitiesToBottom ();
               break;
            case mButtonUndo:
               Undo ();
               break;
            case mButtonRedo:
               Redo ();
               break;
            case mButtonMouseMoveScene:
               SetMouseMode (MouseMode_MoveScene);
               break;
            case mButtonMouseSelectGlued:
               SetMouseMode (MouseMode_SelectGlued);
               break;
            case mButtonMouseSelectSingle:
               SetMouseMode (MouseMode_SelectSingle);
               break;
            case mButtonMouseMove:
               SetMouseEditModeEnabled (MouseEditMode_Move, mButtonMouseMove.selected);
               break;
            case mButtonMouseRotate:
               SetMouseEditModeEnabled (MouseEditMode_Rotate, mButtonMouseRotate.selected);
               break;
            case mButtonMouseScale:
               SetMouseEditModeEnabled (MouseEditMode_Scale, mButtonMouseScale.selected);
               break;
            
            case mButton_Play:
               Play_RunRestart ()
               break;
            case mButton_Stop:
               Play_Stop ();
               break;
            
            case mButtonHideShapes:
               mEditorWorld.SetShapesVisible (! mButtonHideShapes.selected);
               OnSelectedEntitiesChanged ();
               break;
            case mButtonHideJoints:
               mEditorWorld.SetJointsVisible (! mButtonHideJoints.selected);
               OnSelectedEntitiesChanged ();
               break;
            case mButtonHideTriggers:
               mEditorWorld.SetTriggerVisible (! mButtonHideTriggers.selected);
               OnSelectedEntitiesChanged ();
               break;
            
            default:
               break;
         }
      }
      
   // status bar
      
      public var StatusBar_SetMainSelectedEntityInfo:Function;
      public var StatusBar_SetMainDisplayPosition:Function;
      public var StatusBar_SetMainPhysicsPosition:Function;
      
      public var StatusBar_SetRunningSteps:Function;
      public var StatusBar_SetRunningFPS:Function;
      
   // context menu
      
      private var mMenuItemAbout:ContextMenuItem;
      
      private var mMenuItemExportSelectedsToSystemMemory:ContextMenuItem;
      private var mMenuItemImport:ContextMenuItem;
      private var mMenuItemQuickLoad:ContextMenuItem;
      
      private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
         
         // need flash 10
         //theContextMenu.clipboardMenu = true;
         //var clipboardItems:ContextMenuClipboardItems = theContextMenu.builtInItems;
         //clipboardItems.clear = true;
         //clipboardItems.cut = false;
         //clipboardItems.copy = true;
         //clipboardItems.paste = true;
         //clipboardItems.selectAll = false;
            
         
         mMenuItemExportSelectedsToSystemMemory = new ContextMenuItem ("Export Selected(s) to System Memory", true);
         theContextMenu.customItems.push (mMenuItemExportSelectedsToSystemMemory);
         mMenuItemExportSelectedsToSystemMemory.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         mMenuItemImport = new ContextMenuItem ("Import ...", false);
         theContextMenu.customItems.push (mMenuItemImport);
         mMenuItemImport.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         mMenuItemQuickLoad = new ContextMenuItem ("Load Quick Save Data ...", false);
         theContextMenu.customItems.push (mMenuItemQuickLoad);
         mMenuItemQuickLoad.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         var majorVersion:int = (Config.VersionNumber & 0xFF00) >> 8;
         var minorVersion:Number = (Config.VersionNumber & 0xFF) >> 0;
         
         mMenuItemAbout = new ContextMenuItem("About Color Infection Editor v" + majorVersion + "." + (minorVersion >= 10 ? "" : "0") + minorVersion, true);
         theContextMenu.customItems.push (mMenuItemAbout);
         mMenuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemExportSelectedsToSystemMemory:
               ExportSelectedsToSystemMemory ();
               break;
            case mMenuItemImport:
               OpenImportSourceCodeDialog ();
               break;
            case mMenuItemQuickLoad:
               QuickLoad ();
               break;
            case mMenuItemAbout:
               OpenAboutLink ();
               break;
            default:
               break;
         }
      }
      
      private function SetEditorWorld (newEditorWorld:editor.world.World, firstTime:Boolean = false):void
      {
         if (newEditorWorld == null || newEditorWorld == mEditorWorld)
            return;
         
         DestroyEditorWorld ();
         
         mEditorWorld = newEditorWorld;
         
         mContentContainer.addChild (mEditorWorld);
         
         if (Runtime.mCollisionCategoryView != null)
            Runtime.mCollisionCategoryView.SetCollisionManager (mEditorWorld.GetCollisionManager ());
         
         if (! firstTime)
         {
            //
            SetLastSelectedEntities (null);
            mLastSelectedEntities = null;
            
            CalSelectedEntitiesCenterPoint ();
            
            UpdateBackgroundAndWorldPosition ();
         }
      }
      
      private function DestroyEditorWorld ():void
      {
         if ( mEditorWorld != null)
         {
            mEditorWorld.Destroy ();
            
            if ( mContentContainer.contains (mEditorWorld) )
               mContentContainer.removeChild (mEditorWorld);
         }
         
         mEditorWorld = null;
      }
      
      public function ScaleEditorWorld (scaleIn:Boolean):Boolean
      {
         var reachLimit:Boolean = false;
         
         if (IsEditing ())
         {
            var newSscale:Number = mEditorWorldZoomScale * (scaleIn ? 2.0 : 0.5);
            if (int (newSscale * 16.0) <= 1)
            {
               newSscale = 1.0 / 16.0;
               reachLimit = true;
            }
            if (int (newSscale) >= 16)
            {
               newSscale = 16.0;
               reachLimit = true;
            }
            
            mEditorWorldZoomScale = newSscale;
            mEditorWorldZoomScaleChangedSpeed = (mEditorWorldZoomScale - mEditorWorld.scaleX) * 0.03;
            
            //UpdateBackgroundAndWorldPosition ();
         }
         
         return reachLimit;
      }
      
      private function SetDesignPlayer (newPlayer:ColorInfectionPlayer):void
      {
         DestroyDesignPlayer ();
         
         mDesignPlayer = newPlayer;
         
         if (mDesignPlayer == null)
            return;
         
         mPlayerElementsContainer.addChild (mDesignPlayer);
         
         UpdateDesignPalyerPosition ();
      }
      
      private function DestroyDesignPlayer():void
      {
         //SystemUtil.TraceMemory ("before DestroyPlayerWorld", true);
         
         if ( mDesignPlayer != null)
         {
            if ( mPlayerElementsContainer.contains (mDesignPlayer) )
               mPlayerElementsContainer.removeChild (mDesignPlayer);
         }
         
         mDesignPlayer = null;
         
         //SystemUtil.TraceMemory ("after DestroyPlayerWorld", true);
      }
      
      public function UpdateDesignPalyerPosition ():void
      {
         if (mDesignPlayer != null)
         {
            mDesignPlayer.x = Math.round ((mViewWidth - Define.DefaultPlayerWidth) / 2);
            mDesignPlayer.y = Math.round ((mViewHeight - Define.DefaultPlayerHeight - Define.PlayerPlayBarThickness) / 2);
         }
      }
      
//============================================================================
// playing
//============================================================================
      
      public var OnPlayingStarted:Function;
      public var OnPlayingStopped:Function;
      
      private function GetWorldDefine ():WorldDefine
      {
         return DataFormat.EditorWorld2WorldDefine ( mEditorWorld );
      }
      
      private function GetWorldBinaryData ():ByteArray
      {
         var byteArray:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine ( mEditorWorld ));
         byteArray.position = 0;
         
         return byteArray;
      }
      
      public function Play_RunRestart (keepPauseStatus:Boolean = false):void
      {
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         DestroyDesignPlayer ();
         
         var useQuickMethod:Boolean;
         
         if (Compile::Is_Debugging)
         {
            useQuickMethod = true;
         }
         else
         {
            useQuickMethod = false;
         }
         
         if (useQuickMethod)
            SetDesignPlayer (new ColorInfectionPlayer (true, PlayingErrorHandler, GetWorldDefine, null));
         else
            SetDesignPlayer (new ColorInfectionPlayer (true, PlayingErrorHandler, null, GetWorldBinaryData));
         
         mIsPlaying = true;
         
         mPlayerElementsContainer.visible = true;
         mEditorElementsContainer.visible = false;
         
         if (OnPlayingStarted != null)
            OnPlayingStarted ();
         
         mAlreadySavedWhenPlayingError = false;
      }
      
      public function Play_Stop ():void
      {
         DestroyDesignPlayer ();
         
         mIsPlaying = false;
         
         mPlayerElementsContainer.visible = false;
         mEditorElementsContainer.visible = true;
         
         if (OnPlayingStopped != null)
            OnPlayingStopped ();
      }
      
      private function SetPlayingSpeed (speed:Number):void
      {
      }
      
      private function PlayingErrorHandler (error:Error):void
      {
         mDesignPlayer.SetExternalPaused (true);
         
         if (! mAlreadySavedWhenPlayingError)
         {
            QuickSave ("Auto Save when playing error.");
            mAlreadySavedWhenPlayingError = true;
         }
         
         Alert.show (error.message + "\n\nDo you stop the simulation?", "Playing Error! ", 
                     Alert.YES | Alert.NO, 
                     this, 
                     OnPlayingErrorAlertClickHandler
                     );
      }
      
      private var mAlreadySavedWhenPlayingError:Boolean = false;
      
      private function OnPlayingErrorAlertClickHandler (event:CloseEvent):void 
      {
          if (event.detail == Alert.YES)
          {
             Play_Stop ();
          }
          else if (event.detail == Alert.NO)
          {
             mDesignPlayer.SetExternalPaused (false);
          }
      }
      
//============================================================================
//    
//============================================================================
      
      public var ShowShapeRectangleSettingDialog:Function = null;
      public var ShowShapeCircleSettingDialog:Function = null;
      public var ShowShapePolygonSettingDialog:Function = null;
      public var ShowShapePolylineSettingDialog:Function = null;
      
      public var ShowHingeSettingDialog:Function = null;
      public var ShowSliderSettingDialog:Function = null;
      public var ShowSpringSettingDialog:Function = null;
      public var ShowDistanceSettingDialog:Function = null;
      public var ShowWeldSettingDialog:Function = null;
      public var ShowDummySettingDialog:Function = null;
      
      public var ShowShapeTextSettingDialog:Function = null;
      public var ShowShapeTextButtonSettingDialog:Function = null;
      public var ShowShapeGravityControllerSettingDialog:Function = null;
      public var ShowCameraSettingDialog:Function = null;
      
      public var ShowWorldSettingDialog:Function = null;
      public var ShowWorldSavingDialog:Function = null;
      public var ShowWorldLoadingDialog:Function = null;
      public var ShowWorldQuickLoadingDialog:Function = null;
      public var ShowImportSourceCodeDialog:Function = null;
      
      public var ShowCollisionGroupManageDialog:Function = null;
      
      public var ShowPlayCodeLoadingDialog:Function = null;
      
      public var ShowEditorCustomCommandSettingDialog:Function = null;
      
      public var ShowConditionDoorSettingDialog:Function = null;
      public var ShowTaskSettingDialog:Function = null;
      public var ShowConditionSettingDialog:Function = null;
      public var ShowEventHandlerSettingDialog:Function = null;
      public var ShowTimerEventHandlerSettingDialog:Function = null;
      public var ShowKeyboardEventHandlerSettingDialog:Function = null;
      public var ShowMouseEventHandlerSettingDialog:Function = null;
      public var ShowContactEventHandlerSettingDialog:Function = null;
      public var ShowActionSettingDialog:Function = null;
      public var ShowEntityAssignerSettingDialog:Function = null;
      public var ShowEntityPairAssignerSettingDialog:Function = null;
      
      public function IsEntitySettingable (entity:Entity):Boolean
      {
         if (entity == null)
            return false;
         
         //return entity is EntityShape || entity is SubEntityHingeAnchor || entity is SubEntitySliderAnchor
         //       || entity is SubEntitySpringAnchor // v1.01
         //       || entity is SubEntityDistanceAnchor // v1.02
         //       || entity is EntityBasicCondition // v1.07
         //       || entity is EntityEventHandler // v1.07
         //       ;
         
         return true; // v1.08
      }
      
      public function OpenEntitySettingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         //var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         //if (selectedEntities == null || selectedEntities.length != 1)
         //   return;
         if (mLastSelectedEntity == null)
            return;
         
         //var entity:Entity = selectedEntities [0] as Entity;
         var entity:Entity = mLastSelectedEntity;
         
         var values:Object = new Object ();
         
         values.mPosX = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_PositionX (entity.GetPositionX ()), 12);
         values.mPosY = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_PositionY (entity.GetPositionY ()), 12);
         values.mAngle = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_RotationRadians (entity.GetRotation ()) * Define.kRadians2Degrees, 6);
         
         values.mIsVisible = entity.IsVisible ();
         values.mAlpha = entity.GetAlpha ();
         values.mIsEnabled = entity.IsEnabled ();
         
         if (entity is EntityLogic)
         {
            if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               
               values.mCodeSnippetName = event_handler.GetCodeSnippetName ();
               values.mEventId = event_handler.GetEventId ();
               values.mCodeSnippet  = event_handler.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  values.mRunningInterval = timer_event_handler.GetRunningInterval ();
                  values.mOnlyRunOnce = timer_event_handler.IsOnlyRunOnce ();
                  
                  ShowTimerEventHandlerSettingDialog (values, SetEntityProperties);
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  values.mKeyCodes = keyboard_event_handler.GetKeyCodes ();
                  
                  ShowKeyboardEventHandlerSettingDialog (values, SetEntityProperties);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  ShowMouseEventHandlerSettingDialog (values, SetEntityProperties);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  ShowContactEventHandlerSettingDialog (values, SetEntityProperties);
               }
               else
               {
                  ShowEventHandlerSettingDialog (values, SetEntityProperties);
               }
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               
               values.mCodeSnippetName = condition.GetCodeSnippetName ();
               values.mCodeSnippet  = condition.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               ShowConditionSettingDialog (values, SetEntityProperties);
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               
               values.mCodeSnippetName = action.GetCodeSnippetName ();
               values.mCodeSnippet  = action.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               ShowActionSettingDialog (values, SetEntityProperties);
            }
            else if (entity is EntityConditionDoor)
            {
               ShowConditionDoorSettingDialog (values, SetEntityProperties);
            }
            else if (entity is EntityTask)
            {
               ShowTaskSettingDialog (values, SetEntityProperties);
            }
            else if (entity is EntityInputEntityAssigner)
            {
               ShowEntityAssignerSettingDialog (values, SetEntityProperties);
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
               ShowEntityPairAssignerSettingDialog (values, SetEntityProperties);
            }
         }
         else if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            values.mDrawBorder = shape.IsDrawBorder ();
            values.mDrawBackground = shape.IsDrawBackground ();
            values.mBorderColor = shape.GetBorderColor ();
            values.mBorderThickness = shape.GetBorderThickness ();
            values.mBackgroundColor = shape.GetFilledColor ();
            values.mTransparency = shape.GetTransparency ();
            values.mBorderTransparency = shape.GetBorderTransparency ();
            
            values.mAiType = shape.GetAiType ();
            
            if (shape.IsBasicShapeEntity ())
            {
               values.mCollisionCategoryIndex = shape.GetCollisionCategoryIndex ();
               values.mCollisionCategoryListDataProvider =  mEditorWorld.GetCollisionCategoryListDataProvider ();
               values.mCollisionCategoryListSelectedIndex = editor.world.World.CollisionCategoryIndex2SelectListSelectedIndex (shape.GetCollisionCategoryIndex (), values.mCollisionCategoryListDataProvider);
               
               values.mIsPhysicsEnabled = shape.IsPhysicsEnabled ();
               values.mIsSensor = shape.mIsSensor;
               values.mIsStatic = shape.IsStatic ();
               values.mIsBullet = shape.mIsBullet;
               values.mIsHollow = shape.IsHollow ();
               values.mBuildBorder = shape.IsBuildBorder ();
               values.mDensity = ValueAdjuster.Number2Precision (shape.mDensity, 6);
               values.mFriction = ValueAdjuster.Number2Precision (shape.mFriction, 6);
               values.mRestitution = ValueAdjuster.Number2Precision (shape.mRestitution, 6);
               
               values.mLinearVelocityMagnitude = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (shape.GetLinearVelocityMagnitude ()), 6);
               values.mLinearVelocityAngle = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees (shape.GetLinearVelocityAngle ()), 6);
               values.mAngularVelocity = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_AngularVelocity (shape.GetAngularVelocity ()), 6);
               values.mLinearDamping = ValueAdjuster.Number2Precision (shape.GetLinearDamping (), 6);
               values.mAngularDamping = ValueAdjuster.Number2Precision (shape.GetAngularDamping (), 6);
               values.mAllowSleeping = shape.IsAllowSleeping ();
               values.mFixRotation = shape.IsFixRotation ();
               
               //values.mVisibleEditable = true; //shape.GetFilledColor () == Define.ColorStaticObject;
               //values.mStaticEditable = true; //shape.GetFilledColor () == Define.ColorBreakableObject
                                           // || shape.GetFilledColor () == Define.ColorBombObject
                                     ;
               if (entity is EntityShapeCircle)
               {
                  //values.mRadius = (entity as EntityShapeCircle).GetRadius();
                  values.mRadius = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Length ((entity as EntityShapeCircle).GetRadius()), 6);
                  
                  values.mAppearanceType = (entity as EntityShapeCircle).GetAppearanceType();
                  values.mAppearanceTypeListSelectedIndex = (entity as EntityShapeCircle).GetAppearanceType();
                  
                  ShowShapeCircleSettingDialog (values, SetEntityProperties);
               }
               else if (entity is EntityShapeRectangle)
               {
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mEditorWorld.GetCoordinateSystem ().D2P_Length ((shape as EntityShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mEditorWorld.GetCoordinateSystem ().D2P_Length ((shape as EntityShapeRectangle).GetHalfHeight ()), 6);
                  values.mIsRoundCorners = (shape as EntityShapeRectangle).IsRoundCorners ();
                  
                  ShowShapeRectangleSettingDialog (values, SetEntityProperties);
               }
               else if (entity is EntityShapePolygon)
               {
                  ShowShapePolygonSettingDialog (values, SetEntityProperties);
               }
               else if (entity is EntityShapePolyline)
               {
                  values.mCurveThickness = (shape as EntityShapePolyline).GetCurveThickness ();
                  values.mIsRoundEnds = (shape as EntityShapePolyline).IsRoundEnds ();
                  
                  ShowShapePolylineSettingDialog (values, SetEntityProperties);
               }
            }
            else // no physics entity
            {
               if (entity is EntityShapeText)
               {
                  values.mText = (shape as EntityShapeText).GetText ();
                  
                  values.mTextColor = (shape as EntityShapeText).GetTextColor ();
                  values.mFontSize = (shape as EntityShapeText).GetFontSize ();
                  values.mIsBold = (shape as EntityShapeText).IsBold ();
                  values.mIsItalic = (shape as EntityShapeText).IsItalic ();
                  
                  values.mIsUnderlined = (shape as EntityShapeText).IsUnderlined ();
                  values.mTextAlign = (shape as EntityShapeText).GetTextAlign ();
                  
                  values.mWordWrap = (shape as EntityShapeText).IsWordWrap ();
                  values.mAdaptiveBackgroundSize = (shape as EntityShapeText).IsAdaptiveBackgroundSize ();
                  
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mEditorWorld.GetCoordinateSystem ().D2P_Length ((shape as EntityShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mEditorWorld.GetCoordinateSystem ().D2P_Length ((shape as EntityShapeRectangle).GetHalfHeight ()), 6);
                  
                  if (entity is EntityShapeTextButton)
                  {
                     values.mUsingHandCursor = (shape as EntityShapeTextButton).UsingHandCursor ();
                     
                     var moveOverShape:EntityShape = (shape as EntityShapeTextButton).GetMouseOverShape ();
                     values.mMouseOverValues = new Object ();
                     values.mMouseOverValues.mDrawBorder = moveOverShape.IsDrawBorder ();
                     values.mMouseOverValues.mDrawBackground = moveOverShape.IsDrawBackground ();
                     values.mMouseOverValues.mBorderColor = moveOverShape.GetBorderColor ();
                     values.mMouseOverValues.mBorderThickness = moveOverShape.GetBorderThickness ();
                     values.mMouseOverValues.mBackgroundColor = moveOverShape.GetFilledColor ();
                     values.mMouseOverValues.mTransparency = moveOverShape.GetTransparency ();
                     values.mMouseOverValues.mBorderTransparency = moveOverShape.GetBorderTransparency ();
                     
                     ShowShapeTextButtonSettingDialog (values, SetEntityProperties);
                  }
                  else
                  {
                     ShowShapeTextSettingDialog (values, SetEntityProperties);
                  }
               }
               else if (entity is EntityShapeGravityController)
               {
                  values.mRadius = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Length ((entity as EntityShapeCircle).GetRadius()), 6);
                  
                  // removed from v1.05
                  /////values.mIsInteractive = (shape as EntityShapeGravityController).IsInteractive ();
                  values.mInteractiveZones = (shape as EntityShapeGravityController).GetInteractiveZones ();
                  
                  values.mInteractiveConditions = (shape as EntityShapeGravityController).mInteractiveConditions;
                  
                  values.mMaximalGravityAcceleration = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((shape as EntityShapeGravityController).GetMaximalGravityAcceleration ()), 6);
                  
                  values.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((shape as EntityShapeGravityController).GetInitialGravityAcceleration ()), 6);
                  values.mInitialGravityAngle = ValueAdjuster.Number2Precision ( mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees ((shape as EntityShapeGravityController).GetInitialGravityAngle ()), 6);
                  
                  ShowShapeGravityControllerSettingDialog (values, SetEntityProperties);
               }
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            var jointAnchor:SubEntityJointAnchor = entity as SubEntityJointAnchor;
            var joint:EntityJoint = entity.GetMainEntity () as EntityJoint;
            
            var jointValues:Object = new Object ();
            values.mJointValues = jointValues;
            
            jointValues.mCollideConnected = joint.mCollideConnected;
            
            jointValues.mPosX = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_PositionX (joint.GetPositionX ()), 12);
            jointValues.mPosY = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_PositionY (joint.GetPositionY ()), 12);
            jointValues.mAngle = ValueAdjuster.Number2Precision (joint.GetRotation () * Define.kRadians2Degrees, 6);
            
            jointValues.mIsVisible = joint.IsVisible ();
            jointValues.mAlpha = joint.GetAlpha ();
            jointValues.mIsEnabled = joint.IsEnabled ();
            
            //>>from v1.02
            jointValues.mShapeListDataProvider = mEditorWorld.GetEntitySelectListDataProviderByFilter (Filters.IsPhysicsShapeEntity, true, "[Auto Select]");
            jointValues.mShapeList1SelectedIndex = editor.world.World.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape1Index (), jointValues.mShapeListDataProvider);
            jointValues.mShapeList2SelectedIndex = editor.world.World.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape2Index (), jointValues.mShapeListDataProvider);
            jointValues.mAnchorIndex = jointAnchor.GetAnchorIndex (); // hinge will modify it below
            //<<
            
            //from v1.08
            jointValues.mIsBreakable = joint.IsBreakable ();
            //<<
            
            if (entity is SubEntityHingeAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var hinge:EntityJointHinge = joint as EntityJointHinge;
               var lowerAngle:Number = mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetLowerLimit ());
               var upperAngle:Number = mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetUpperLimit ());
               if (lowerAngle > upperAngle)
               {
                  var tempAngle:Number = lowerAngle;
                  lowerAngle = upperAngle;
                  upperAngle = tempAngle;
               }
               
               jointValues.mEnableLimit = hinge.IsLimitsEnabled ();
               jointValues.mLowerAngle = ValueAdjuster.Number2Precision (lowerAngle, 6);
               jointValues.mUpperAngle = ValueAdjuster.Number2Precision (upperAngle, 6);
               jointValues.mEnableMotor = hinge.mEnableMotor;
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees (hinge.mMotorSpeed), 6);
               jointValues.mBackAndForth = hinge.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorTorque = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Torque (hinge.GetMaxMotorTorque ()), 6);
               //<<
               
               ShowHingeSettingDialog (values, SetEntityProperties);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = joint as EntityJointSlider;
               
               jointValues.mEnableLimit = slider.IsLimitsEnabled ();
               jointValues.mLowerTranslation = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Length (slider.GetLowerLimit ()), 6);
               jointValues.mUpperTranslation = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Length (slider.GetUpperLimit ()), 6);
               jointValues.mEnableMotor = slider.mEnableMotor;
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (slider.mMotorSpeed), 6);
               jointValues.mBackAndForth = slider.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorForce = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_ForceMagnitude (slider.GetMaxMotorForce ()), 6);
               //<<
               
               ShowSliderSettingDialog (values, SetEntityProperties);
            }
            else if (entity is SubEntitySpringAnchor)
            {
               var spring:EntityJointSpring = joint as EntityJointSpring;
               
               jointValues.mStaticLengthRatio = ValueAdjuster.Number2Precision (spring.GetStaticLengthRatio (), 6);
               jointValues.mSpringType = spring.GetSpringType ();
               jointValues.mDampingRatio = ValueAdjuster.Number2Precision (spring.mDampingRatio, 6);
               
               //from v1.08
               jointValues.mFrequencyDeterminedManner = spring.GetFrequencyDeterminedManner ();
               jointValues.mFrequency = ValueAdjuster.Number2Precision (spring.GetFrequency (), 6);
               jointValues.mSpringConstant = ValueAdjuster.Number2Precision (spring.GetSpringConstant () * mEditorWorld.GetCoordinateSystem ().D2P_Length (1.0) / mEditorWorld.GetCoordinateSystem ().D2P_ForceMagnitude (1.0), 6);
               jointValues.mBreakExtendedLength = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Length (spring.GetBreakExtendedLength ()), 6);
               //<<
               
               ShowSpringSettingDialog (values, SetEntityProperties);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               jointValues.mBreakDeltaLength = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Length (distance.GetBreakDeltaLength ()), 6);
               //<<
               
               ShowDistanceSettingDialog (values, SetEntityProperties);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               var weld:EntityJointWeld = joint as EntityJointWeld;
               
               ShowWeldSettingDialog (values, SetEntityProperties);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               ShowDummySettingDialog (values, SetEntityProperties);
            }
         }
         else if (entity is EntityUtility)
         {
            var utility:EntityUtility = entity as EntityUtility;
            
            if (entity is EntityUtilityCamera)
            {
               var camera:EntityUtilityCamera = utility as EntityUtilityCamera;
               
               //from v1.08
               values.mFollowedTarget = camera.GetFollowedTarget ();
               values.mFollowingStyle = camera.GetFollowingStyle ();
               //<<
               
               ShowCameraSettingDialog (values, SetEntityProperties);
            }
         }
      }
      
      
      
      //private function OpenWorldSettingDialog ():void
      //{
      //   if (! IsEditing ())
      //      return;
      //   
      //   if (Runtime.HasSettingDialogOpened ())
      //      return;
      //   
      //   var values:Object = new Object ();
      //   
      //   values.mAuthorName = mEditorWorld.GetAuthorName ();
      //   values.mAuthorHomepage = mEditorWorld.GetAuthorHomepage ();
      //   
      //   //>>from v1.02
      //   values.mShareSourceCode = mEditorWorld.IsShareSourceCode ();
      //   //<<
      //   
      //   ShowWorldSettingDialog (values, SetWorldProperties);
      //}
      
      private function OpenWorldSavingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         try
         {
            var values:Object = new Object ();
            
            values.mXmlString = DataFormat2.WorldDefine2Xml (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
            values.mHexString = DataFormat.WorldDefine2HexString (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
            
            ShowWorldSavingDialog (values);
         }
         catch (error:Error)
         {
            Alert.show("Sorry, saving error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
      private function OpenWorldLoadingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         ShowWorldLoadingDialog (LoadEditorWorldFromXmlString);
      }
      
      private function OpenCollisionGroupManageDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         ShowCollisionGroupManageDialog (null);
      }
      
      private function OpenAboutLink ():void
      {
         UrlUtil.PopupPage (Define.AboutUrl);
      }
      
      //private function OpenPlayCodeLoadingDialog ():void
      //{
      //   if (! IsPlaying ())
      //      return;
      //   
      //   if (Runtime.HasSettingDialogOpened ())
      //      return;
      //   
      //   ShowPlayCodeLoadingDialog (LoadPlayerWorldFromHexString);
      //}
      
      private function  OpenImportSourceCodeDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         ShowImportSourceCodeDialog (ImportFromXmlString);
      }
      
//==================================================================================
// trigger setting
//==================================================================================
      
      //public var mStatusMessageBar:Label;
      
      public var mCustomTriggerButtons:Array;
      
      public function SetCustomTriggerButtons (buttons:Array):void
      {
         mCustomTriggerButtons = buttons;
         
         var button:Button;
         for (var i:int = 0; i < mCustomTriggerButtons.length; ++ i)
         {
            button = mCustomTriggerButtons [i] as Button;
            button.maxWidth = button.width;
            button.percentWidth = NaN;
            
            button.label = "" + ( (i + 1) % 10);
            button.width = button.maxWidth;
            
            button.addEventListener (MouseEvent.CLICK, OnCustomTriggerButtonClick);
         }
      }
      
      private function GetCustomTriggerIdByEventTarget (object:Object):int
      {
         if (mCustomTriggerButtons == null)
            return -1;
         
         return mCustomTriggerButtons.indexOf (object);
      }
      
      private function OnCustomTriggerButtonClick (event:Event):void
      {
         var index:int = GetCustomTriggerIdByEventTarget (event.target);
         if (index < 0)
            return;
         
         Alert.show("Alert", "Button #" + index + " is clicked.");
         
         if (mLastSelectedEntity != null)
         {
            var func:Function = (mLastSelectedEntity as EntityShape).SetDensity;
            
            func.apply (mLastSelectedEntity, [5.0]);
         }
      }
      
      public function OnClickEditorCustomCommand (event:ContextMenuEvent):void
      {
         var index:int = GetCustomTriggerIdByEventTarget (event.contextMenuOwner);
         if (index < 0)
            return;
         
         ShowEditorCustomCommandSettingDialog (null);
      }
      
//=================================================================================
//   coordinates
//=================================================================================
      
      // use the one in DisplayObjectUtil instead
      
      //public static function LocalToLocal (display1:DisplayObject, display2:DisplayObject, point:Point):Point
      //{
      //   //return display2.globalToLocal ( display1.localToGlobal (point) );
      //   
      //   var matrix:Matrix = display2.transform.concatenatedMatrix.clone();
      //   matrix.invert();
      //   return matrix.transformPoint (display1.transform.concatenatedMatrix.transformPoint (point));
      //}
      
      public function ViewToWorld (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (this, mEditorWorld, point);
      }
      
      public function WorldToView (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (mEditorWorld, this, point);
      }
      
      
//==================================================================================
// key modifiers and mouse modes
//==================================================================================
      
      private var _mouseEventCtrlDown:Boolean = false;
      private var _mouseEventShiftDown:Boolean = false;
      private var _mouseEventAltDown:Boolean = false;
      
      private var _isZeroMove:Boolean = false;
      
      private function CheckModifierKeys (event:MouseEvent):void
      {
         _mouseEventCtrlDown   = event.ctrlKey;
         _mouseEventShiftDown = event.shiftKey;
         _mouseEventAltDown     = event.altKey;
      }
      
      public static const MouseMode_SelectGlued:int = 0;
      public static const MouseMode_SelectSingle:int = 1;
      public static const MouseMode_MoveScene:int = 2;
      
      public var mCurrentMouseMode:int = MouseMode_SelectGlued;
      
      public static const MouseEditMode_None:int = -1;
      public static const MouseEditMode_Move:int = 0;
      public static const MouseEditMode_Rotate:int = 1;
      public static const MouseEditMode_Scale:int = 2;
      
      public var mCurrentMouseEditMode:int = MouseEditMode_Move;
      public var mLastMouseEditMode:int = MouseEditMode_Move;
      
      public function SetMouseMode (mode:int):void
      {
         mCurrentMouseMode = mode;
         
         mButtonMouseSelectGlued.selected = false;
         mButtonMouseSelectSingle.selected = false;
         mButtonMouseMoveScene.selected = false;
         
         if (mCurrentMouseMode == MouseMode_SelectGlued)
             mButtonMouseSelectGlued.selected = true;
         else if (mCurrentMouseMode == MouseMode_SelectSingle)
            mButtonMouseSelectSingle.selected = true;
         else if (mCurrentMouseMode == MouseMode_MoveScene)
            mButtonMouseMoveScene.selected = true;
         
         //Mouse.cursor = mCurrentMouseMode == MouseMode_MoveScene ? MouseCursor.HAND : MouseCursor.ARROW;
      }
      
      private function ToggleMouseMode ():void
      {
         if (mCurrentMouseMode == MouseMode_SelectGlued)
             SetMouseMode (MouseMode_SelectSingle);
         else if (mCurrentMouseMode == MouseMode_SelectSingle)
             SetMouseMode (MouseMode_MoveScene);
         else if (mCurrentMouseMode == MouseMode_MoveScene)
             SetMouseMode (MouseMode_SelectGlued);
      }
      
      public function SetMouseEditModeEnabled (mode:int, modeEnabled:Boolean = false):void
      {
         if (modeEnabled)
            mCurrentMouseEditMode = mode;
         else
            mCurrentMouseEditMode = MouseEditMode_None;
         
         if (modeEnabled)
            mLastMouseEditMode = mCurrentMouseEditMode;
         
         mButtonMouseMove.selected = false;
         mButtonMouseRotate.selected = false;
         mButtonMouseScale.selected = false;
         
         if (modeEnabled)
         {
            if (mCurrentMouseEditMode == MouseEditMode_Move)
            {
               mButtonMouseMove.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_Rotate)
            {
               mButtonMouseRotate.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_Scale)
            {
               mButtonMouseScale.selected = true;
            }
         }
      }
      
      private function ToggleMouseEditLocked ():void
      {
         if (mCurrentMouseEditMode != MouseEditMode_None)
            SetMouseEditModeEnabled (MouseEditMode_None, false);
         else if (mLastMouseEditMode != MouseEditMode_None)
            SetMouseEditModeEnabled (mLastMouseEditMode, true);
      }
      
      private function IsEntityMouseMoveEnabled ():Boolean
      {
         return mCurrentMouseMode != MouseMode_MoveScene && mCurrentMouseEditMode == MouseEditMode_Move;
      }
      
      private function IsEntityMouseRotateEnabled ():Boolean
      {
         if (_mouseEventShiftDown && ! IsEntityMouseEditLocked ())
            return true;
         
         return mCurrentMouseMode != MouseMode_MoveScene && mCurrentMouseEditMode == MouseEditMode_Rotate;
      }
      
      private function IsEntityMouseScaleEnabled ():Boolean
      {
         if (_mouseEventCtrlDown && ! IsEntityMouseEditLocked ())
            return true;
         
         return mCurrentMouseMode != MouseMode_MoveScene && mCurrentMouseEditMode == MouseEditMode_Scale;
      }
      
      private function IsEntityMouseEditLocked ():Boolean
      {
         return mCurrentMouseMode == MouseMode_MoveScene || mCurrentMouseEditMode == MouseEditMode_None;
      }
      
      private function StartMouseEditMode ():void
      {
         if (_mouseEventShiftDown && _mouseEventCtrlDown)
         {
         }
         else if (IsEntityMouseRotateEnabled ())
         {
            SetCurrentEditMode (new ModeRotateSelectedEntities (this));
         }
         else if (IsEntityMouseScaleEnabled ())
         {
            SetCurrentEditMode (new ModeScaleSelectedEntities (this));
         }
         else if (IsEntityMouseMoveEnabled ())
         {
            SetCurrentEditMode (new ModeMoveSelectedEntities (this));
         }
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
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
         
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mEditorWorld, new Point (event.localX, event.localY) );
         var worldPoint:Point = mEditorWorld.globalToLocal (new Point (Math.round(event.stageX), Math.round (event.stageY)));
         
         if (IsCreating ())
         {
            if (mCurrentCreatMode != null)
            {
               mCurrentCreatMode.OnMouseDown (worldPoint.x, worldPoint.y);
            }
         }
         
         if (IsEditing ())
         {
            var entityArray:Array = mEditorWorld.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
            
         // move scene
            
            if (mCurrentMouseMode == MouseMode_MoveScene || (_mouseEventShiftDown && entityArray.length == 0))
            {
               SetCurrentEditMode (new ModeMoveWorldScene (this));
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               _isZeroMove = false; // to prevent somecallings in OnMouseUp ()
               
               return;
            }
            
         // vertex controllers
            var vertexControllers:Array = mEditorWorld.GetVertexControllersAtPoint (worldPoint.x, worldPoint.y);
            
            if (vertexControllers.length > 0)
            {
               mEditorWorld.SetSelectedVertexController (vertexControllers[0]);
               SetCurrentEditMode (new ModeMoveSelectedVertexControllers (this, vertexControllers[0]));
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               return;
            }
            
            mEditorWorld.SetSelectedVertexController (null);
            
         // create / break logic link
            
            var linkable:Linkable = mEditorWorld.GetFirstLinkablesAtPoint (worldPoint.x, worldPoint.y);
            if (linkable != null && linkable.CanStartCreatingLink (worldPoint.x, worldPoint.y))
            {
               SetCurrentEditMode (new ModeCreateEntityLink (this, linkable));
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               return;
            }
            
         // entities
            
            var entity:Entity;
            
            // move selecteds, first time
            {
               if (mEditorWorld.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
               {
                  StartMouseEditMode ();
                   
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
               
               if ( (! _mouseEventCtrlDown) && (mCurrentMouseMode == MouseMode_SelectGlued) )
               {
                  SetTheOnlySelectedEntity (entity);
                  
                  _isZeroMove = false;
               }
            }
            
            // move selecteds, 2nd time
            {
               if (mEditorWorld.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
               {
                  StartMouseEditMode ();
                   
                  if (mCurrentEditMode != null)
                     mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                  
                  return;
               }
            }
            
            if (_mouseEventCtrlDown || mCurrentMouseMode == MouseMode_SelectSingle)
               mLastSelectedEntities = mEditorWorld.GetSelectedEntities ();
            else
               mEditorWorld.ClearSelectedEntities ();
            
            // region select
            {
               //var entityArray:Array = mEditorWorld.GetEntitiyAtPoint (worldPoint.x, worldPoint.y, null);
               if (entityArray.length == 0)
               {
                  //_isZeroMove = false;
                  
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
         
         UpdateMousePointInfo (new Point (event.stageX, event.stageY));
         
         var viewPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         
         var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         
         if ( ! rect.containsPoint (viewPoint) )
         {
            // wired: sometimes, moust out event can't be captured, so create a fake mouse out event here. (but, still not always work)
            OnMouseOut (event);
            return;
         }
         
         _isZeroMove = false;
         
         if (mCursorCreating.visible)
         {
            mCursorCreating.x = viewPoint.x;
            mCursorCreating.y = viewPoint.y;
         }
         
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mEditorWorld, new Point (event.localX, event.localY) );
         var worldPoint:Point = mEditorWorld.globalToLocal (new Point (Math.round(event.stageX), Math.round (event.stageY)));
         
         if (IsCreating ())
         {
            if (mCurrentCreatMode != null)
            {
               mCurrentCreatMode.OnMouseMove (worldPoint.x, worldPoint.y);
            }
         }
         
         
         if (IsEditing ())
         {
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
         
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mEditorWorld, new Point (event.localX, event.localY) );
         var worldPoint:Point = mEditorWorld.globalToLocal (new Point (Math.round(event.stageX), Math.round (event.stageY)));
         
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
            if ( _isZeroMove && ! (mCurrentEditMode is ModeRegionSelectEntities) )
            {
               var vertexControllerArray:Array = mEditorWorld.GetSelectedVertexControllers ();
               if (vertexControllerArray.length > 0 && vertexControllerArray [0].ContainsPoint (worldPoint.x, worldPoint.y))
               {
               }
               else
               {
                  var entityArray:Array = mEditorWorld.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
                  var entity:Entity;
                  
                  // point select, ctrl down
                  if (entityArray.length > 0)
                  {
                     entity = (entityArray[0] as Entity);
                     
                     if ( _mouseEventCtrlDown || mCurrentMouseMode == MouseMode_SelectSingle )
                     {
                        ToggleEntitySelected (entity);
                     }
                     else 
                     {
                        SetTheOnlySelectedEntity (entity);
                     }
                     
                     _isZeroMove = false; // weird? just to avoid the following calling
                  }
               }
            }
            
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.OnMouseUp (worldPoint.x, worldPoint.y);
            }
            
            if ( _isZeroMove && (! _mouseEventCtrlDown) && mCurrentMouseMode == MouseMode_SelectSingle )
            {
               mEditorWorld.ClearSelectedEntities ();
            }
         }
      }
      
      public function OnMouseOut (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         UpdateMousePointInfo (null);
         
         CheckModifierKeys (event);
         
         //var point:Point = DisplayObjectUtil.LocalToLocal ( (event.target as DisplayObject).parent, this, new Point (event.localX, event.localY) );
         var point:Point = globalToLocal ( new Point (event.stageX, event.stageY) );
         
         if ( new Rectangle (1, 1, width - 1, height - 1).containsPoint (point) )
            return;
         
         if (IsCreating ())
         {
            if (mCurrentCreatMode != null)
            {
               CancelCurrentCreatingMode ();
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
         if (! Runtime.IsActiveView (this))
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         //trace ("event.keyCode = " + event.keyCode + ", event.charCode = " + event.charCode);
         
         if (IsPlaying ()) // playing
         {
            switch (event.keyCode)
            {
               case Keyboard.SPACE:
                  mDesignPlayer.Step (true);
                  break;
               default:
                  break;
            }
         }
         else if (IsCreating ())
         {
            switch (event.keyCode)
            {
               case Keyboard.ESCAPE:
                  if (mCurrentCreatMode != null)
                  {
                     CancelCurrentCreatingMode ();
                  }
                  break;
               default:
                  break;
            }
         }
         else if (IsEditing ())
         {
            switch (event.keyCode)
            {
               case Keyboard.ESCAPE:
                  //if (mCurrentCreatMode != null)
                  //{
                  //   CancelCurrentEditingMode ();
                  //}
                  //else
                  {
                     mEditorWorld.ClearSelectedEntities ();
                     OnSelectedEntitiesChanged ();
                  }
                  break;
               case Keyboard.SPACE:
                  OpenEntitySettingDialog ();
                  break;
               case Keyboard.DELETE:
                  if (event.ctrlKey)
                     DeleteSelectedVertexController ();
                  else
                     DeleteSelectedEntities ();
                  break;
               case Keyboard.INSERT:
                  if (event.ctrlKey)
                     InsertVertexController ();
                  else
                     CloneSelectedEntities ();
                  break;
               case 68: // D
                  DeleteSelectedEntities ();
                  break;
               case 67: // C
                  CloneSelectedEntities ();
                  break;
               case Keyboard.PAGE_UP:
               case 88: // X
                  FlipSelectedEntitiesHorizontally ();
                  break;
               case Keyboard.PAGE_DOWN:
               case 89: // Y
                  FlipSelectedEntitiesVertically ();
                  break;
               case 85: // U
                  Undo ();
                  break;
               case 82: // R
                  Redo ();
                  break;
               case 83: // S
                  if (event.ctrlKey)
                     QuickSave ();
                  break;
               case 71: // G
                  GlueSelectedEntities ();
                  break;
               case 66: // B
                  BreakApartSelectedEntities ();
                  break;
               //case 76: // L // cancelled
               //   OpenPlayCodeLoadingDialog ();
               //   break;
               case 192: // ~
                  ToggleMouseEditLocked ();
                  break;
               case Keyboard.TAB:
                  ToggleMouseMode ();
                  break;
               case Keyboard.LEFT:
                  if (event.shiftKey)
                     RotateSelectedEntities (- 0.5 * Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (-1, 0, true, false);
                  break;
               case Keyboard.RIGHT:
                  if (event.shiftKey)
                     RotateSelectedEntities (0.5 * Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (1, 0, true, false);
                  break;
               case Keyboard.UP:
                  if (event.shiftKey)
                     RotateSelectedEntities (- 5 * Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (0, -1, true, false);
                  break;
               case Keyboard.DOWN:
                  if (event.shiftKey)
                     RotateSelectedEntities (5* Define.kDegrees2Radians, true, false);
                  else
                     MoveSelectedEntities (0, 1, true, false);
                  break;
               case 187:// +
               case Keyboard.NUMPAD_ADD:
                  AlignCenterSelectedEntities ();
                  break;
               case 189:// -
               case Keyboard.NUMPAD_SUBTRACT:
                  RoundPositionForSelectedEntities ();
                  break;
               default:
                  break;
            }
         }
      }
      
      
//============================================================================
//    
//============================================================================
      
      public function DestroyEntity (entity:Entity):void
      {
         mEditorWorld.DestroyEntity (entity);
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function SetShapeInitialProperties (shape:EntityShape):void
      {
         //shape.SetPhysicsEnabled (Runtime.mShape_EnablePhysics);
         //shape.SetStatic (Runtime.mShape_IsStatic);
         //shape.SetAsSensor (Runtime.mShape_IsSensor);
         //shape.SetDrawBackground (Runtime.mShape_DrawBackground);
         //shape.SetFilledColor (Runtime.mShape_BackgroundColor);
         //shape.SetDrawBorder (Runtime.mShape_DrawBorder);
         //shape.SetBorderColor (Runtime.mShape_BorderColor);
      }
      
      public function CreateCircle (centerX:Number, centerY:Number, radius:Number, filledColor:uint, isStatic:Boolean):EntityShapeCircle
      {
         var centerPoint:Point = new Point (centerX, centerY);
         var edgePoint  :Point = new Point (centerX + radius, centerY);
         
         radius = Point.distance (centerPoint, edgePoint);
         
         var circle:EntityShapeCircle = mEditorWorld.CreateEntityShapeCircle ();
         if (circle == null)
            return null;
         
         circle.SetPosition (centerX, centerY);
         circle.SetRadius (radius);
         
         circle.SetFilledColor (filledColor);
         circle.SetStatic (isStatic);
         circle.SetDrawBorder (filledColor != Define.ColorStaticObject);
         circle.SetBuildBorder (circle.IsDrawBorder ());
         
         SetTheOnlySelectedEntity (circle);
         
         SetShapeInitialProperties (circle);
         
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
         
         var rect:EntityShapeRectangle = mEditorWorld.CreateEntityShapeRectangle ();
         if (rect == null)
            return null;
         
         rect.SetPosition (centerX, centerY);
         rect.SetHalfWidth  (halfWidth);
         rect.SetHalfHeight (halfHeight);
         
         rect.SetFilledColor (filledColor);
         rect.SetStatic (isStatic);
         rect.SetDrawBorder (filledColor != Define.ColorStaticObject);
         rect.SetBuildBorder (rect.IsDrawBorder ());
         
         SetTheOnlySelectedEntity (rect);
         
         SetShapeInitialProperties (rect);
         
         return rect;
      }
      
      public function CreatePolygon (filledColor:uint, isStatic:Boolean):EntityShapePolygon
      {
         var polygon:EntityShapePolygon = mEditorWorld.CreateEntityShapePolygon ();
         if (polygon == null)
            return null;
         
         polygon.SetFilledColor (filledColor);
         polygon.SetStatic (isStatic);
         polygon.SetDrawBorder (filledColor != Define.ColorStaticObject);
         polygon.SetBuildBorder (polygon.IsDrawBorder ());
         
         SetTheOnlySelectedEntity (polygon);
         
         SetShapeInitialProperties (polygon);
         
         return polygon;
      }
      
      public function CreatePolyline (filledColor:uint, isStatic:Boolean):EntityShapePolyline
      {
         var polyline:EntityShapePolyline = mEditorWorld.CreateEntityShapePolyline ();
         if (polyline == null)
            return null;
         
         polyline.SetFilledColor (filledColor);
         polyline.SetStatic (isStatic);
         polyline.SetDrawBorder (filledColor != Define.ColorStaticObject);
         polyline.SetBuildBorder (polyline.IsDrawBorder ());
         
         SetTheOnlySelectedEntity (polyline);
         
         SetShapeInitialProperties (polyline);
         
         return polyline;
      }
      
      public function CreateHinge ():EntityJointHinge
      {
         var hinge:EntityJointHinge = mEditorWorld.CreateEntityJointHinge ();
         if (hinge == null)
            return null;
            
         SetTheOnlySelectedEntity (hinge.GetAnchor ());
         
         return hinge;
      }
      
      public function CreateDistance ():EntityJointDistance
      {
         var distaneJoint:EntityJointDistance = mEditorWorld.CreateEntityJointDistance ();
         if (distaneJoint == null)
            return null;
         
         SetTheOnlySelectedEntity (distaneJoint.GetAnchor2 ());
         
         return distaneJoint;
      }
      
      public function CreateSlider ():EntityJointSlider
      {
         var slider:EntityJointSlider = mEditorWorld.CreateEntityJointSlider ();
         if (slider == null)
            return null;
         
         SetTheOnlySelectedEntity (slider.GetAnchor2 ());
         
         return slider;
      }
      
      public function CreateSpring ():EntityJointSpring
      {
         var spring:EntityJointSpring = mEditorWorld.CreateEntityJointSpring ();
         if (spring == null)
            return null;
         
         SetTheOnlySelectedEntity (spring.GetAnchor2 ());
         
         return spring;
      }
      
      public function CreateWeldJoint ():EntityJointWeld
      {
         var weld:EntityJointWeld = mEditorWorld.CreateEntityJointWeld ();
         if (weld == null)
            return null;
         
         SetTheOnlySelectedEntity (weld.GetAnchor ());
         
         return weld;
      }
      
      public function CreateDummyJoint ():EntityJointDummy
      {
         var dummy:EntityJointDummy = mEditorWorld.CreateEntityJointDummy ();
         if (dummy == null)
            return null;
         
         SetTheOnlySelectedEntity (dummy.GetAnchor2 ());
         
         return dummy;
      }
      
      public function CreateText (options:Object = null):EntityShapeText
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var shapeText:EntityShapeText = mEditorWorld.CreateEntityShapeText ();
            if (shapeText == null)
               return null;
            
            var halfWidth :Number = 50;
            var halfHeight:Number = 25;
            
            shapeText.SetHalfWidth  (halfWidth);
            shapeText.SetHalfHeight (halfHeight);
            
            shapeText.SetFilledColor (Define.ColorTextBackground);
            shapeText.SetStatic (true);
            
            SetTheOnlySelectedEntity (shapeText);
            
            SetShapeInitialProperties (shapeText);
            
            return shapeText;
         }
      }
      
      public function CreateEntityTextButton (options:Object = null):EntityShapeTextButton
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var button:EntityShapeTextButton = mEditorWorld.CreateEntityShapeTextButton ();
            if (button == null)
               return null;
            
            button.SetStatic (true);
            
            SetTheOnlySelectedEntity (button);
            
            SetShapeInitialProperties (button);
            
            return button;
         }
      }
      
      public function CreateGravityController (options:Object = null):EntityShapeGravityController
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var gController:EntityShapeGravityController = mEditorWorld.CreateEntityShapeGravityController ();
            if (gController == null)
               return null;
            
            var radius:Number = 50;
            
            gController.SetRadius (radius);
            
            gController.SetStatic (true);
            
            SetTheOnlySelectedEntity (gController);
            
            return gController;
         }
      }
      
      public function CreateEntityUtilityCamera (options:Object = null):EntityUtilityCamera
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var camera:EntityUtilityCamera = mEditorWorld.CreateEntityUtilityCamera ();
            if (camera == null)
               return null;
            
            SetTheOnlySelectedEntity (camera);
            
            return camera;
         }
      }
      
      public function CreateEntityCondition (options:Object = null):EntityBasicCondition
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var condition:EntityBasicCondition = mEditorWorld.CreateEntityCondition ();
            if (condition == null)
               return null;
            
            SetTheOnlySelectedEntity (condition);
            
            return condition;
         }
      }
      
      public function CreateEntityConditionDoor (options:Object = null):EntityConditionDoor
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var condition_door:EntityConditionDoor = mEditorWorld.CreateEntityConditionDoor ();
            if (condition_door == null)
               return null;
            
            SetTheOnlySelectedEntity (condition_door);
            
            return condition_door;
         }
      }
      
      public function CreateEntityTask (options:Object = null):EntityTask
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var task:EntityTask = mEditorWorld.CreateEntityTask ();
            if (task == null)
               return null;
            
            SetTheOnlySelectedEntity (task);
            
            return task;
         }
      }
      
      public function CreateEntityInputEntityAssigner (options:Object = null):EntityInputEntityAssigner
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityAssigner).SetInternalComponentsVisible (true);
            return null;
         }
         else
         {
            var entity_assigner:EntityInputEntityAssigner = mEditorWorld.CreateEntityInputEntityAssigner ();
            if (entity_assigner == null)
               return null;
            
            SetTheOnlySelectedEntity (entity_assigner);
            
            return entity_assigner;
         }
      }
      
      public function CreateEntityInputEntityPairAssigner (options:Object = null):EntityInputEntityPairAssigner
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityPairAssigner).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_pair_assigner:EntityInputEntityPairAssigner = mEditorWorld.CreateEntityInputEntityPairAssigner ();
         if (entity_pair_assigner == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_pair_assigner);
         
         return entity_pair_assigner;
      }
      
      public function CreateEntityEventHandler (options:Object = null):EntityEventHandler
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var handler:EntityEventHandler
            
            switch (options.mDefaultEventId)
            {
               case CoreEventIds.ID_OnWorldTimer:
               case CoreEventIds.ID_OnEntityTimer:
               case CoreEventIds.ID_OnEntityPairTimer:
                  handler = mEditorWorld.CreateEntityEventHandler_Timer (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnPhysicsShapeMouseDown:
               case CoreEventIds.ID_OnPhysicsShapeMouseUp:
               case CoreEventIds.ID_OnEntityMouseClick:
               case CoreEventIds.ID_OnEntityMouseDown:
               case CoreEventIds.ID_OnEntityMouseUp:
               case CoreEventIds.ID_OnEntityMouseMove:
               case CoreEventIds.ID_OnEntityMouseEnter:
               case CoreEventIds.ID_OnEntityMouseOut:
               case CoreEventIds.ID_OnWorldMouseClick:
               case CoreEventIds.ID_OnWorldMouseDown:
               case CoreEventIds.ID_OnWorldMouseUp:
               case CoreEventIds.ID_OnWorldMouseMove:
                  handler = mEditorWorld.CreateEntityEventHandler_Mouse (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnWorldKeyDown:
               case CoreEventIds.ID_OnWorldKeyUp:
               case CoreEventIds.ID_OnWorldKeyHold:
                  handler = mEditorWorld.CreateEntityEventHandler_Keyboard (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting:
               case CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting:
               case CoreEventIds.ID_OnTwoPhysicsShapesEndContacting:
                  handler = mEditorWorld.CreateEntityEventHandler_Contact (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               default:
                  handler = mEditorWorld.CreateEntityEventHandler (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
            }
            
            if (handler == null)
               return null;
            
            SetTheOnlySelectedEntity (handler);
            
            return handler;
         }
      }
      
      public function CreateEntityAction (options:Object = null):EntityAction
      {
         if (options != null && options.stage ==ModePlaceCreateEntitiy. StageFinished)
         {
            return null;
         }
         else
         {
            var action:EntityAction = mEditorWorld.CreateEntityAction ();
            if (action == null)
               return null;
            
            SetTheOnlySelectedEntity (action);
            
            return action;
         }
      }
      
//============================================================================
//    
//============================================================================
      
      private var mLastSelectedEntity:Entity = null;
      private var mLastSelectedEntities:Array = null;
      
      private var _SelectedEntitiesCenterPoint:Point = new Point ();
      
      public function SetLastSelectedEntities (entity:Entity):void
      {
         mLastSelectedEntity = entity;
         
         if (mLastSelectedEntity != null)
            entity.SetInternalComponentsVisible (true);
         
         UpdateUiButtonsEnabledStatus ();
         UpdateSelectedEntityInfo ();
      }
      
      public function SetTheOnlySelectedEntity (entity:Entity):void
      {
         if (entity == null)
            return;
         
         mEditorWorld.ClearSelectedEntities ();
         UpdateSelectedEntityInfo ();
         
         if (mEditorWorld.GetSelectedEntities ().length != 1 || mEditorWorld.GetSelectedEntities () [0] != entity)
            mEditorWorld.SetSelectedEntity (entity);
         
         if (mEditorWorld.GetSelectedEntities ().length != 1)
            return;
         
         SetLastSelectedEntities (entity);
         
         if (mCurrentMouseMode == MouseMode_SelectGlued)
            mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function ToggleEntitySelected (entity:Entity):void
      {
         mEditorWorld.ToggleEntitySelected (entity);
         
         if (mEditorWorld.IsEntitySelected (entity))
         {
            if (mLastSelectedEntity != null)
               mLastSelectedEntity.SetInternalComponentsVisible (false);
            
            entity.SetInternalComponentsVisible (true);
         }
         
         SetLastSelectedEntities (entity);
         
         // to make selecting part of a glued possible
         // mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         var entities:Array = mEditorWorld.GetEntitiesIntersectWithRegion (left, top, right, bottom);
         
         mEditorWorld.ClearSelectedEntities ();
         
         if (_mouseEventCtrlDown || mCurrentMouseMode == MouseMode_SelectSingle)
         {
            if (mLastSelectedEntities != null)
               mEditorWorld.SelectEntities (mLastSelectedEntities);
            
            //mEditorWorld.SelectEntities (entities);
            for (var i:int = 0; i < entities.length; ++ i)
            {
               mEditorWorld.ToggleEntitySelected (entities [i]);
            }
         }
         else
            mEditorWorld.SelectEntities (entities);
         
         if (mCurrentMouseMode == MouseMode_SelectGlued)
            mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         OnSelectedEntitiesChanged ();
      }
      
      public function OnSelectedEntitiesChanged ():void
      {
         CalSelectedEntitiesCenterPoint ();
         
         var selecteds:Array = mEditorWorld.GetSelectedEntities ();
         if (selecteds.length > 0)
         {
            SetLastSelectedEntities (selecteds [0]);
         }
         else
         {
            SetLastSelectedEntities (null);
         }
      }
      
      public function GetSelectedEntitiesCenterX ():Number
      {
         return _SelectedEntitiesCenterPoint.x;
      }
      
      public function GetSelectedEntitiesCenterY ():Number
      {
         return _SelectedEntitiesCenterPoint.y;
      }
      
      public function CalSelectedEntitiesCenterPoint ():void
      {
         var centerX:Number = 0;
         var centerY:Number = 0;
         
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         var count:uint = 0;
         
         for (var i:uint = 0; i < selectedEntities.length; ++ i)
         {
            var entity:Entity = selectedEntities[i] as Entity;
            
            if (entity != null)
            {
               centerX += entity.GetPositionX ();
               centerY += entity.GetPositionY ();
               ++ count;
            }
         }
         
         if (count > 0)
         {
            centerX /= count;
            centerY /= count;
            
            _SelectedEntitiesCenterPoint.x = centerX;
            _SelectedEntitiesCenterPoint.y = centerY;
            
            UpdateSelectedEntitiesCenterSprite ();
         }
         
         var showCenter:Boolean = count > 1;
         
         if (count ==1)
         {
            entity = selectedEntities [0];
            if (entity is EntityShapePolygon)
               showCenter = true;
            else
               showCenter = false;
         }
         
         mSelectedEntitiesCenterSprite.visible = showCenter;
         
         UpdateUiButtonsEnabledStatus ();
         
         UpdateSelectedEntityInfo ();
         
         RepaintEntityLinks ();
      }
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseMoveEnabled () )
            return;
         
         mEditorWorld.MoveSelectedEntities (offsetX, offsetY, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
         
      }
      
      public function RotateSelectedEntities (dAngle:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseRotateEnabled () )
            return;
         
         mEditorWorld.RotateSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), dAngle, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function ScaleSelectedEntities (ratio:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseScaleEnabled () )
            return;
         
         mEditorWorld.ScaleSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), ratio, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function DeleteSelectedEntities ():void
      {
         mEditorWorld.DeleteSelectedEntities ();
         
         CreateUndoPoint ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function CloneSelectedEntities ():void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         
         var clonedable:Boolean = false;
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            if ( (selectedEntities[i] as Entity).IsClonedable () )
            {
               clonedable = true;
               break;
            }
         }
         if (! clonedable)
            return;
         
         mEditorWorld.CloneSelectedEntities (Define.BodyCloneOffsetX, Define.BodyCloneOffsetY);
         
         selectedEntities = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities.length == 1)
         {
            SetLastSelectedEntities (selectedEntities [0]);
         }
         
         CreateUndoPoint ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function FlipSelectedEntitiesHorizontally ():void
      {
         mEditorWorld.FlipSelectedEntitiesHorizontally (GetSelectedEntitiesCenterX ());
         
         CreateUndoPoint ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function FlipSelectedEntitiesVertically ():void
      {
         mEditorWorld.FlipSelectedEntitiesVertically (GetSelectedEntitiesCenterY ());
         
         CreateUndoPoint ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function GlueSelectedEntities ():void
      {
         mEditorWorld.GlueSelectedEntities ();
      }
      
      public function BreakApartSelectedEntities ():void
      {
         mEditorWorld.BreakApartSelectedEntities ();
      }
      
      public function ClearAllEntities (showAlert:Boolean = true, resetScene:Boolean = false):void
      {
         if (showAlert)
            Alert.show("Do you want to clear all objects?", "Clear All", 3, this, resetScene ? OnCloseClearAllAndResetSceneAlert : OnCloseClearAllAlert, null, Alert.NO);
         else
         {
            if (resetScene)
            {
               SetEditorWorld (new editor.world.World ());
               mViewCenterWorldX = DefaultWorldWidth * 0.5;
               mViewCenterWorldY = DefaultWorldHeight * 0.5;
               mEditorWorldZoomScale = 1.0;
               
               UpdateChildComponents ();
            }
            else
            {
               mEditorWorld.DestroyAllEntities ();
            }
            
            CreateUndoPoint ();
            
            CalSelectedEntitiesCenterPoint ();
            
            Runtime.mCollisionCategoryView.UpdateFriendLinkLines ();
         }
      }
      
      private function OnCloseClearAllAlert (event:CloseEvent):void 
      {
         if (event == null || event.detail==Alert.YES)
         {
            ClearAllEntities (false, false);
         }
      }
      
      private function OnCloseClearAllAndResetSceneAlert (event:CloseEvent):void 
      {
         if (event == null || event.detail==Alert.YES)
         {
            ClearAllEntities (false, true);
         }
      }
      
      public function MoveSelectedEntitiesToTop ():void
      {
         mEditorWorld.MoveSelectedEntitiesToTop ();
         
         CreateUndoPoint ();
         
         UpdateSelectedEntityInfo ();
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
         mEditorWorld.MoveSelectedEntitiesToBottom ();
         
         CreateUndoPoint ();
         
         UpdateSelectedEntityInfo ();
      }
      
      public function AlignCenterSelectedEntities ():void
      {
         // try to find the largest circle and set its position as target position, 
         // if no circle found, set the first joint anchor as target position,
         // 
         
         var entities:Array = mEditorWorld.GetSelectedEntities ();
         var entity:Entity;
         var i:int;
         var centerX:Number;
         var centerY:Number;
         var maxArea:Number = 0;
         var area:Number;
         var numShapes:int = 0;
         var circleRadius:Number;
         var numAnchors:int = 0;
         for (i = 0; i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            if (entity is EntityShapeCircle)
            {
               ++ numShapes;
               circleRadius = (entity as EntityShapeCircle).GetRadius ();
               area = Math.PI * circleRadius * circleRadius;
               if ( area > maxArea )
               {
                  maxArea = area;
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
            }
            else if (entity is EntityShapeRectangle)
            {
               ++ numShapes;
               area = 4 * (entity as EntityShapeRectangle).GetHalfWidth () * (entity as EntityShapeRectangle).GetHalfHeight ();
               if ( area > maxArea )
               {
                  maxArea = area;
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
            }
            else if (entity is SubEntityJointAnchor)
            {
               if (numShapes == 0 && numAnchors == 0)
               {
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
               
               ++ numAnchors;
            }
         }
         
         if (numShapes + numAnchors > 1)
         {
            for (i = 0; i < entities.length; ++ i)
            {
               entity = entities [i] as Entity;
               if (entity is EntityShapeCircle || entity is EntityShapeRectangle || entity is SubEntityJointAnchor)
                  entity.Move (centerX - entity.GetPositionX (), centerY - entity.GetPositionY (), true);
            }
            
            CreateUndoPoint ();
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function RoundPositionForSelectedEntities ():void
      {
         var entities:Array = mEditorWorld.GetSelectedEntities ();
         var entity:Entity;
         var i:int;
         var posX:Number;
         var posY:Number;
         for (i = 0; i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            posX = Math.round (entity.GetPositionX ());
            posY = Math.round (entity.GetPositionY ());
            entity.SetPosition (posX, posY);
         }
         
         if (entities.length > 0)
            CalSelectedEntitiesCenterPoint ();
      }
      
//============================================================================
//    vertex controllers
//============================================================================
      
      public function MoveSelectedVertexControllers (offsetX:Number, offsetY:Number):void
      {
         if (mEditorWorld.GetSelectedVertexControllers ().length > 0)
         {
            mEditorWorld.MoveSelectedVertexControllers (offsetX, offsetY);
         }
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function DeleteSelectedVertexController ():void
      {
         if (mEditorWorld.GetSelectedVertexControllers ().length > 0)
         {
            mEditorWorld.DeleteSelectedVertexControllers ();
            
            CreateUndoPoint ();
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function InsertVertexController ():void
      {
         if (mEditorWorld.GetSelectedVertexControllers ().length > 0)
         {
            mEditorWorld.InsertVertexControllerBeforeSelectedVertexControllers ();
            
            CreateUndoPoint ();
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
//=================================================================================
//   set properties
//=================================================================================
      
      public function SetEntityProperties (params:Object):void
      {
         //var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         //if (selectedEntities == null || selectedEntities.length != 1)
         //   return;
         if (mLastSelectedEntity == null)
            return;
         
         //var entity:Entity = selectedEntities [0] as Entity;
         var entity:Entity = mLastSelectedEntity;
         
         var newPosX:Number = mEditorWorld.GetCoordinateSystem ().P2D_PositionX (params.mPosX);
         var newPosY:Number = mEditorWorld.GetCoordinateSystem ().P2D_PositionY (params.mPosY);
         if (! mEditorWorld.IsInfiniteSceneSize ())
         {
            newPosX = MathUtil.GetClipValue (newPosX, mEditorWorld.GetWorldLeft (), mEditorWorld.GetWorldRight ());
            newPosY = MathUtil.GetClipValue (newPosY, mEditorWorld.GetWorldTop (), mEditorWorld.GetWorldBottom ());
         }
         
         entity.SetPosition (newPosX, newPosY);
         entity.SetRotation (mEditorWorld.GetCoordinateSystem ().P2D_RotationRadians (params.mAngle * Define.kDegrees2Radians));
         entity.SetVisible (params.mIsVisible);
         entity.SetAlpha (params.mAlpha);
         entity.SetEnabled (params.mIsEnabled);
         
         if (entity is EntityLogic)
         {
            var code_snippet:CodeSnippet;
            
            if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               
               code_snippet = event_handler.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  timer_event_handler.SetRunningInterval (params.mRunningInterval);
                  timer_event_handler.SetOnlyRunOnce (params.mOnlyRunOnce);
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  keyboard_event_handler.ChangeKeyboardEventId (params.mEventId);
                  keyboard_event_handler.SetKeyCodes (params.mKeyCodes);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  var mouse_event_handler:EntityEventHandler_Mouse = entity as EntityEventHandler_Mouse;
                  
                  mouse_event_handler.ChangeMouseEventId (params.mEventId);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  var contact_event_handler:EntityEventHandler_Contact = entity as EntityEventHandler_Contact;
                  
                  contact_event_handler.ChangeContactEventId (params.mEventId);
               }
               
               event_handler.UpdateAppearance ();
               event_handler.UpdateSelectionProxy ();
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               
               condition.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = condition.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
               
               condition.UpdateAppearance ();
               condition.UpdateSelectionProxy ();
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               
               action.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = action.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
               
               action.UpdateAppearance ();
               action.UpdateSelectionProxy ();
            }
            else if (entity is EntityConditionDoor)
            {
            }
            else if (entity is EntityTask)
            {
            }
            else if (entity is EntityInputEntityAssigner)
            {
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
            }
         }
         else if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            shape.SetDrawBorder (params.mDrawBorder);
            shape.SetTransparency (params.mTransparency);
            shape.SetDrawBorder (params.mDrawBorder);
            shape.SetBorderColor (params.mBorderColor);
            shape.SetBorderThickness (params.mBorderThickness);
            shape.SetDrawBackground (params.mDrawBackground);
            shape.SetFilledColor (params.mBackgroundColor);
            shape.SetBorderTransparency (params.mBorderTransparency);
            
            if (shape.IsBasicShapeEntity ())
            {
               shape.SetAiType (params.mAiType);
               shape.SetCollisionCategoryIndex (params.mCollisionCategoryIndex);
               
               shape.SetPhysicsEnabled (params.mIsPhysicsEnabled);
               shape.SetAsSensor (params.mIsSensor);
               shape.SetStatic (params.mIsStatic);
               shape.SetAsBullet (params.mIsBullet);
               shape.SetDensity (params.mDensity);
               shape.SetFriction (params.mFriction);
               shape.SetRestitution (params.mRestitution);
               shape.SetHollow (params.mIsHollow);
               shape.SetBuildBorder (params.mBuildBorder);
               
               if (params.mLinearVelocityMagnitude < 0)
               {
                  params.mLinearVelocityMagnitude = -params.mLinearVelocityMagnitude;
                  params.mLinearVelocityAngle = 360.0 - params.mLinearVelocityAngle;
               }
               shape.SetLinearVelocityMagnitude (mEditorWorld.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mLinearVelocityMagnitude));
               shape.SetLinearVelocityAngle (mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (params.mLinearVelocityAngle));
               shape.SetAngularVelocity (mEditorWorld.GetCoordinateSystem ().P2D_AngularVelocity (params.mAngularVelocity));
               shape.SetLinearDamping (params. mLinearDamping);
               shape.SetAngularDamping (params.mAngularDamping);
               shape.SetAllowSleeping (params.mAllowSleeping);
               shape.SetFixRotation (params.mFixRotation);
               
               if (entity is EntityShapeCircle)
               {
                  (shape as EntityShapeCircle).SetRadius (mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mRadius));
                  (shape as EntityShapeCircle).SetAppearanceType (params.mAppearanceType);
               }
               else if (entity is EntityShapeRectangle)
               {
                  (shape as EntityShapeRectangle).SetHalfWidth (0.5 * mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mWidth));
                  (shape as EntityShapeRectangle).SetHalfHeight (0.5 * mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mHeight));
                  (shape as EntityShapeRectangle).SetRoundCorners (params.mIsRoundCorners);
               }
               else if (entity is EntityShapePolygon)
               {
               }
               else if (entity is EntityShapePolyline)
               {
                  (shape as EntityShapePolyline).SetCurveThickness (params.mCurveThickness);
                  (shape as EntityShapePolyline).SetRoundEnds (params.mIsRoundEnds);
               }
            }
            else // no physics entity
            {
               if (entity is EntityShapeText)
               {
                  (shape as EntityShapeRectangle).SetHalfWidth (0.5 * mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mWidth));
                  (shape as EntityShapeRectangle).SetHalfHeight (0.5 * mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mHeight));
                  
                  (shape as EntityShapeText).SetWordWrap (params.mWordWrap);
                  (shape as EntityShapeText).SetAdaptiveBackgroundSize (params.mAdaptiveBackgroundSize);
                  
                  (shape as EntityShapeText).SetUnderlined (params.mIsUnderlined);
                  (shape as EntityShapeText).SetTextAlign (params.mTextAlign);
                  
                  (shape as EntityShapeText).SetText (params.mText);
                  (shape as EntityShapeText).SetTextColor (params.mTextColor);
                  (shape as EntityShapeText).SetFontSize (params.mFontSize);
                  (shape as EntityShapeText).SetBold (params.mIsBold);
                  (shape as EntityShapeText).SetItalic (params.mIsItalic);
                  
                  if (entity is EntityShapeTextButton)
                  {
                     (shape as EntityShapeTextButton).SetUsingHandCursor (params.mUsingHandCursor);
                     
                     var moveOverShape:EntityShape = (shape as EntityShapeTextButton).GetMouseOverShape ();
                     moveOverShape.SetDrawBorder (params.mMouseOverValues.mDrawBorder);
                     moveOverShape.SetTransparency (params.mMouseOverValues.mTransparency);
                     moveOverShape.SetDrawBorder (params.mMouseOverValues.mDrawBorder);
                     moveOverShape.SetBorderColor (params.mMouseOverValues.mBorderColor);
                     moveOverShape.SetBorderThickness (params.mMouseOverValues.mBorderThickness);
                     moveOverShape.SetDrawBackground (params.mMouseOverValues.mDrawBackground);
                     moveOverShape.SetFilledColor (params.mMouseOverValues.mBackgroundColor);
                     moveOverShape.SetBorderTransparency (params.mMouseOverValues.mBorderTransparency);
                   }
                  else
                  {
                  }
               }
               else if (entity is EntityShapeGravityController)
               {
                  (shape as EntityShapeCircle).SetRadius (mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mRadius));
                  
                  //(shape as EntityShapeGravityController).SetInteractive (params.mIsInteractive);
                  (shape as EntityShapeGravityController).SetInteractiveZones (params.mInteractiveZones);
                  
                  (shape as EntityShapeGravityController).mInteractiveConditions = params.mInteractiveConditions;
                  
                  if (params.mInitialGravityAcceleration < 0)
                  {
                     params.mInitialGravityAcceleration = -params.mInitialGravityAcceleration;
                     params.mInitialGravityAngle = 360.0 - params.mInitialGravityAngle;
                  }
                  
                  (shape as EntityShapeGravityController).SetMaximalGravityAcceleration (mEditorWorld.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mMaximalGravityAcceleration));
                  (shape as EntityShapeGravityController).SetInitialGravityAcceleration (mEditorWorld.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mInitialGravityAcceleration));
                  (shape as EntityShapeGravityController).SetInitialGravityAngle (mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (params.mInitialGravityAngle));
               }
            }
            
            shape.UpdateAppearance ();
            shape.UpdateSelectionProxy ();
            
            if (shape is EntityShapeRectangle)
            {
               (shape as EntityShapeRectangle).UpdateVertexControllers (true);
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            var jointAnchor:SubEntityJointAnchor = entity as SubEntityJointAnchor;
            var joint:EntityJoint = jointAnchor.GetMainEntity () as EntityJoint;
            
            var jointParams:Object = params.mJointValues;
            
            joint.mCollideConnected = jointParams.mCollideConnected;
            
            newPosX = mEditorWorld.GetCoordinateSystem ().P2D_PositionX (jointParams.mPosX);
            newPosY = mEditorWorld.GetCoordinateSystem ().P2D_PositionY (jointParams.mPosY);
            if (! mEditorWorld.IsInfiniteSceneSize ())
            {
               newPosX = MathUtil.GetClipValue (newPosX, mEditorWorld.GetWorldLeft (), mEditorWorld.GetWorldRight ());
               newPosY = MathUtil.GetClipValue (newPosY, mEditorWorld.GetWorldTop (), mEditorWorld.GetWorldBottom ());
            }
            joint.SetPosition (newPosX, newPosY);
            joint.SetRotation (mEditorWorld.GetCoordinateSystem ().P2D_RotationRadians (jointParams.mAngle * Define.kDegrees2Radians));
            joint.SetVisible (jointParams.mIsVisible);
            joint.SetAlpha (jointParams.mAlpha);
            joint.SetEnabled (jointParams.mIsEnabled);
            
            //>> from v1.02
            joint.SetConnectedShape1Index (jointParams.mConntectedShape1Index);
            joint.SetConnectedShape2Index (jointParams.mConntectedShape2Index);
            //<<
            
            //from v1.08
            joint.SetBreakable (jointParams.mIsBreakable);
            //<<
            
            if (entity is SubEntityHingeAnchor)
            {
               var hinge:EntityJointHinge = joint as EntityJointHinge;
               
               hinge.SetLimitsEnabled (jointParams.mEnableLimit);
               hinge.SetLimits (mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mLowerAngle), mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mUpperAngle));
               hinge.mEnableMotor = jointParams.mEnableMotor;
               hinge.mMotorSpeed = mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mMotorSpeed);
               hinge.mBackAndForth = jointParams.mBackAndForth;
               
               //>>from v1.04
               hinge.SetMaxMotorTorque (mEditorWorld.GetCoordinateSystem ().P2D_Torque (jointParams.mMaxMotorTorque));
               //<<
               
               // 
               hinge.GetAnchor ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = joint as EntityJointSlider;
               
               slider.SetLimitsEnabled (jointParams.mEnableLimit);
               slider.SetLimits (mEditorWorld.GetCoordinateSystem ().P2D_Length (jointParams.mLowerTranslation), mEditorWorld.GetCoordinateSystem ().P2D_Length (jointParams.mUpperTranslation));
               slider.mEnableMotor = jointParams.mEnableMotor;
               slider.mMotorSpeed = mEditorWorld.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (jointParams.mMotorSpeed);
               slider.mBackAndForth = jointParams.mBackAndForth;
               
               //>>from v1.04
               slider.SetMaxMotorForce (mEditorWorld.GetCoordinateSystem ().P2D_ForceMagnitude (jointParams.mMaxMotorForce));
               //<<
               
               // 
               slider.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               slider.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntitySpringAnchor)
            {
               var spring:EntityJointSpring = joint as EntityJointSpring;
               
               spring.SetStaticLengthRatio (jointParams.mStaticLengthRatio);
               spring.SetSpringType (jointParams.mSpringType);
               spring.mDampingRatio = jointParams.mDampingRatio;
               
               //from v1.08
               spring.SetFrequencyDeterminedManner (jointParams.mFrequencyDeterminedManner);
               spring.SetFrequency (jointParams.mFrequency);
               spring.SetSpringConstant (jointParams.mSpringConstant * mEditorWorld.GetCoordinateSystem ().P2D_Length (1.0) / mEditorWorld.GetCoordinateSystem ().P2D_ForceMagnitude (1.0));
               spring.SetBreakExtendedLength (mEditorWorld.GetCoordinateSystem ().P2D_Length (jointParams.mBreakExtendedLength));
               //<<
               
               // 
               spring.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               spring.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               distance.SetBreakDeltaLength (mEditorWorld.GetCoordinateSystem ().P2D_Length (jointParams.mBreakDeltaLength));
               //<<
               
               // 
               distance.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               distance.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               var weld:EntityJointWeld = joint as EntityJointWeld;
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
            }
            
            jointAnchor.GetMainEntity ().UpdateAppearance ();
            jointAnchor.UpdateSelectionProxy ();
         }
         else if (entity is EntityUtility)
         {
            var utility:EntityUtility = entity as EntityUtility;
            
            if (entity is EntityUtilityCamera)
            {
               var camera:EntityUtilityCamera = utility as EntityUtilityCamera;
               
               //from v1.08
               camera.SetFollowedTarget (params.mFollowedTarget);
               camera.SetFollowingStyle (params.mFollowingStyle);
               //<<
            }
         }
         
         CreateUndoPoint ();
      }
      
//=================================================================================
//   world settings
//=================================================================================
      
      public function GetCurrentWorldDesignInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mShareSoureCode = mEditorWorld.IsShareSourceCode ();
         info.mAuthorName = mEditorWorld.GetAuthorName ();
         info.mAuthorHomepage = mEditorWorld.GetAuthorHomepage ();
         
         return info;
      }
      
      public function SetCurrentWorldDesignInfo (info:Object):void
      {
         mEditorWorld.SetShareSourceCode (info.mShareSoureCode);
         mEditorWorld.SetAuthorName (info.mAuthorName);
         mEditorWorld.SetAuthorHomepage (info.mAuthorHomepage);
         
         CreateUndoPoint ();
      }
      
      public function GetCurrentWorldCoordinateSystemInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mIsRightHand = mEditorWorld.GetCoordinateSystem ().IsRightHand ();
         info.mScale = mEditorWorld.GetCoordinateSystem ().GetScale ();
         info.mOriginX = mEditorWorld.GetCoordinateSystem ().GetOriginX ();
         info.mOroginY = mEditorWorld.GetCoordinateSystem ().GetOriginY ();
         
         return info;
      }
      
      public function SetCurrentWorldCoordinateSystemInfo (info:Object):void
      {
         mEditorWorld.RebuildCoordinateSystem (
                  info.mOriginX,
                  info.mOroginY,
                  info.mScale,
                  info.mIsRightHand
               );
         
         UpdateSelectedEntityInfo ();
         
         CreateUndoPoint ();
      }
      
      public function GetCurrentWorldLevelRulesInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mIsCiRulesEnabled = mEditorWorld.IsCiRulesEnabled ();
         
         return info;
      }
      
      public function SetCurrentWorldLevelRulesInfo (info:Object):void
      {
         mEditorWorld.SetCiRulesEnabled (info.mIsCiRulesEnabled);
         
         CreateUndoPoint ();
      }
      
      public function GetCurrentWorldGravityInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mDefaultGravityAccelerationMagnitude = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (mEditorWorld.GetDefaultGravityAccelerationMagnitude ()), 6);
         info.mDefaultGravityAccelerationAngle = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees (mEditorWorld.GetDefaultGravityAccelerationAngle ()), 6);
         
         return info;
      }
      
      public function SetCurrentWorldGravityInfo (info:Object):void
      {
         mEditorWorld.SetDefaultGravityAccelerationMagnitude (mEditorWorld.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (info.mDefaultGravityAccelerationMagnitude));
         mEditorWorld.SetDefaultGravityAccelerationAngle (mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (info.mDefaultGravityAccelerationAngle));
         
         CreateUndoPoint ();
      }
      
      public function GetCurrentWorldAppearanceInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mIsInfiniteSceneSize = mEditorWorld.IsInfiniteSceneSize ();
         info.mWorldLeft = mEditorWorld.GetWorldLeft ();
         info.mWorldTop = mEditorWorld.GetWorldTop ();
         info.mWorldWidth = mEditorWorld.GetWorldWidth ();
         info.mWorldHeight = mEditorWorld.GetWorldHeight ();
         
         info.mBackgroundColor = mEditorWorld.GetBackgroundColor ();
         info.mBorderColor = mEditorWorld.GetBorderColor ();
         info.mIsBuildBorder = mEditorWorld.IsBuildBorder ();
         info.mIsBorderAtTopLayer = mEditorWorld.IsBorderAtTopLayer ();
         info.mWorldBorderLeftThickness = mEditorWorld.GetWorldBorderLeftThickness ();
         info.mWorldBorderTopThickness = mEditorWorld.GetWorldBorderTopThickness ();
         info.mWorldBorderRightThickness  = mEditorWorld.GetWorldBorderRightThickness ();
         info.mWorldBorderBottomThickness = mEditorWorld.GetWorldBorderBottomThickness ();
         
         
         return info;
      }
      
      public function SetCurrentWorldAppearanceInfo (info:Object):void
      {
         mEditorWorld.SetInfiniteSceneSize (info.mIsInfiniteSceneSize);
         mEditorWorld.SetWorldLeft (info.mWorldLeft);
         mEditorWorld.SetWorldTop (info.mWorldTop);
         mEditorWorld.SetWorldWidth (info.mWorldWidth);
         mEditorWorld.SetWorldHeight (info.mWorldHeight);
         
         mEditorWorld.SetBackgroundColor (info.mBackgroundColor);
         mEditorWorld.SetBorderColor (info.mBorderColor);
         mEditorWorld.SetBuildBorder (info.mIsBuildBorder);
         mEditorWorld.SetBorderAtTopLayer (info.mIsBorderAtTopLayer);
         mEditorWorld.SetWorldBorderLeftThickness (info.mWorldBorderLeftThickness);
         mEditorWorld.SetWorldBorderTopThickness (info.mWorldBorderTopThickness);
         mEditorWorld.SetWorldBorderRightThickness (info.mWorldBorderRightThickness);
         mEditorWorld.SetWorldBorderBottomThickness (info.mWorldBorderBottomThickness);
         
         UpdateChildComponents ();
         
         CreateUndoPoint ();
      }
      
//=================================================================================
//   IO
//=================================================================================
      
      public function LoadEditorWorldFromXmlString (params:Object):void
      {
         var newWorld:editor.world.World = null;
         
         DestroyEditorWorld ();
         
         try
         {
            var xmlString:String = params.mXmlString;
            
            var xml:XML = new XML (xmlString);
            
            var newWorldDefine:WorldDefine = DataFormat.Xml2WorldDefine (xml);
            if (newWorldDefine == null)
               throw new Error ("newWorldDefine == null !!!");
            
            newWorld = DataFormat.WorldDefine2EditorWorld (newWorldDefine);
            
            SetEditorWorld (newWorld);
            
            mWorldHistoryManager.ClearHistories ();
            CreateUndoPoint ();
         }
         catch (error:Error)
         {
            SetEditorWorld (new editor.world.World ());
            
            Alert.show("Sorry, loading error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
      public function ExportSelectedsToSystemMemory ():void
      {
         var newWorld:editor.world.World = null;
         
         try
         {
            var worldDefine:WorldDefine = DataFormat.EditorWorld2WorldDefine (mEditorWorld);
            newWorld = DataFormat.WorldDefine2EditorWorld (worldDefine);
            
            var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
            
            if (selectedEntities.length == 0)
               return;
            
            var numEntities:int = selectedEntities.length;
            var i:int;
            var index:int;
            var entity:Entity;
            for (i = 0; i < numEntities; ++ i)
            {
               //trace ("selectedEntities[i] = " + selectedEntities[i]);
               //trace ("selectedEntities[i].parent = " + selectedEntities[i].parent);
               
               index = mEditorWorld.GetEntityCreationId (selectedEntities[i]);
               entity = newWorld.GetEntityByCreationId (index);
               
               entity = entity.GetMainEntity ();
               newWorld.SelectEntity (entity);
               newWorld.SelectEntities (entity.GetSubEntities ());
            }
            
            i = 0;
            //numEntities = newWorld.GetNumEntities (); // this is bug
            while (i < newWorld.GetNumEntities ()) // numEntities)
            {
               entity = newWorld.GetEntityByCreationId (i);
               if ( entity.IsSelected () ) // generally should use world.IsEntitySelected instead, this one is fast but only for internal uses
               {
                  ++ i;
               }
               else
               {
                  newWorld.DestroyEntity (entity);
               }
            }
            
            var cm:CollisionManager = newWorld.GetCollisionManager ();
            var ccId:int;
            numEntities = newWorld.GetNumEntities ();
            
            for (i = 0; i < numEntities; ++ i)
            {
               entity = newWorld.GetEntityByCreationId (i);
               if (entity is EntityShape)
               {
                  ccId = (entity as EntityShape).GetCollisionCategoryIndex ();
                  if (ccId >= 0)
                     cm.SelectEntity (cm.GetCollisionCategoryByIndex (ccId));
               }
            }
            
            ccId = 0;
            //var numCats:int = cm.GetNumCollisionCategories ();// this is bug
            while (ccId < cm.GetNumCollisionCategories ()) //numCats)
            {
               entity = cm.GetCollisionCategoryByIndex (ccId);
               if ( entity.IsSelected () ) // generally should use world.IsEntitySelected instead, this one is fast but only for internal uses
               {
                  ++ ccId;
               }
               else
               {
                  cm.DestroyEntity (entity);
               }
            }
            
            System.setClipboard(DataFormat2.WorldDefine2Xml (DataFormat.EditorWorld2WorldDefine (newWorld)));
            
         }
         catch (error:Error)
         {
            Alert.show("Sorry, export  error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
         //finally // comment off for bug of secureSWF 
         {
            if (newWorld != null)
               newWorld.Destroy ();
         }
      }
      
      public function ImportFromXmlString (params:Object):void
      {
         var xmlString:String = params.mXmlString;
         
         var xml:XML = new XML (xmlString);
         
         try
         {
            var oldEntitiesCount:int = mEditorWorld.GetNumEntities ();
            var oldCategoriesCount:int = mEditorWorld.GetNumCollisionCategories ();
            
            var worldDefine:WorldDefine = DataFormat.Xml2WorldDefine (xml);
            
            if (oldEntitiesCount + worldDefine.mEntityDefines.length > Define.MaxEntitiesCount)
               return;
            
            if (oldCategoriesCount + worldDefine.mCollisionCategoryDefines.length > Define.MaxCollisionCategoriesCount)
               return;
            
            DataFormat.WorldDefine2EditorWorld (worldDefine, true, mEditorWorld);
            
            if (oldEntitiesCount == mEditorWorld.numChildren)
               return;
            
            mEditorWorld.ClearSelectedEntities ();
            
            var i:int;
            var j:int;
            var entity:Entity;
            var entities:Array;
            var centerX:Number = 0;
            var centerY:Number = 0;
            var numSelecteds:int = 0;
            
            var newEntitiesCount:int = mEditorWorld.GetNumEntities ();
            
            for (i = oldEntitiesCount; i < newEntitiesCount; ++ i)
            {
               entities = (mEditorWorld.GetEntityByCreationId (i) as Entity).GetSubEntities ();
               mEditorWorld.SelectEntities (entities);
               
               for (j = 0; j < entities.length; ++ j)
               {
                  entity = entities [j] as Entity;
                  centerX += entity.GetPositionX ();
                  centerY += entity.GetPositionY ();
                  ++ numSelecteds;
               }
            }
            
            if (numSelecteds > 0)
            {
               centerX /= numSelecteds;
               centerY /= numSelecteds;
               
               MoveSelectedEntities (mViewCenterWorldX - centerX, mViewCenterWorldY - centerY, true, false);
            }
            
            CreateUndoPoint ();
         }
         catch (error:Error)
         {
            Alert.show("Sorry, import error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
//=================================================================================
//   move scene
//=================================================================================
      
      public function MoveWorldScene (dx:Number, dy:Number):void
      {
         var sceneLeft  :int = mEditorWorld.GetWorldLeft ();
         var sceneTop   :int = mEditorWorld.GetWorldTop ();
         var sceneRight :int = sceneLeft + mEditorWorld.GetWorldWidth ();
         var sceneBottom:int = sceneTop  + mEditorWorld.GetWorldHeight ();
         
         mViewCenterWorldX -= dx;
         mViewCenterWorldY -= dy;
         
         UpdateBackgroundAndWorldPosition ();
      }
      
//============================================================================
// undo / redo 
//============================================================================
      
      public function CreateUndoPoint (editActions:Array = null):void
      {
         if (mEditorWorld == null)
            return;
         
         var worldState:WorldState = new WorldState (editActions);
         
         var object:Object = new Object ();
         worldState.mUserData = object;
         
         object.mWorldDefine = DataFormat.EditorWorld2WorldDefine (mEditorWorld);
         
         var entityArray:Array = mEditorWorld.GetSelectedEntities ();
         
         object.mSelectedEntityCreationIds = new Array (entityArray.length);
         object.mMainSelectedEntityId = -1;
         object.mSelectedVertexControllerId = -1;
         object.mViewCenterWorldX = mViewCenterWorldX;
         object.mViewCenterWorldY = mViewCenterWorldY;
         object.mEditorWorldZoomScale = mEditorWorldZoomScale;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            var entity:Entity = entityArray [i] as Entity;
            object.mSelectedEntityCreationIds [i] = mEditorWorld.GetEntityCreationId (entity);
            if (entity.AreInternalComponentsVisible ())
            {
               object.mMainSelectedEntityId = object.mSelectedEntityCreationIds [i];
               
               var vertexControllerArray:Array = mEditorWorld.GetSelectedVertexControllers ();
               if (vertexControllerArray.length > 0)
                  object.mSelectedVertexControllerId = entity.GetVertexControllerIndex (vertexControllerArray [0]);
            }
         }
         
         mWorldHistoryManager.AddHistory (worldState);
      }
      
      private function RestoreWorld (worldState:WorldState):void
      {
         if (worldState == null)
            return;
         
         SetLastSelectedEntities (null);
         mLastSelectedEntities = null;
         
         var object:Object = worldState.mUserData;
          
         //var cm:CollisionManager = mEditorWorld.GetCollisionManager ();
         mEditorWorld.DestroyAllEntities ();
         DataFormat.WorldDefine2EditorWorld (object.mWorldDefine, false, mEditorWorld);
         //mEditorWorld.SetCollisionManager (cm);
         
         mViewCenterWorldX = object.mViewCenterWorldX;
         mViewCenterWorldY = object.mViewCenterWorldY;
         
         mEditorWorldZoomScale = object.mEditorWorldZoomScale;
         mEditorWorld.SetZoomScale (mEditorWorldZoomScale);
         
         SetEditorWorld (mEditorWorld);
         
         var numEntities:int = mEditorWorld.GetNumEntities ();
         var entityId:int;
         var entity:Entity;
         
         for (var i:int = 0; i < object.mSelectedEntityCreationIds.length; ++ i)
         {
            entityId = object.mSelectedEntityCreationIds [i];
            if (entityId >= 0 && entityId < numEntities)
            {
               entity = mEditorWorld.GetEntityByCreationId (entityId);
               mEditorWorld.SelectEntity (entity);
               
               if (entityId == object.mMainSelectedEntityId)
               {
                  entity.SetInternalComponentsVisible (true);
                  SetLastSelectedEntities (entity);
                  
                  if (object.mSelectedVertexControllerId >= 0)
                  {
                     var vertexController:VertexController = entity.GetVertexControllerByIndex (object.mSelectedVertexControllerId);
                     if (vertexController != null)
                        mEditorWorld.SetSelectedVertexController (vertexController);
                  }
               }
            }
         }
         
         UpdateChildComponents ();
      }
      
      public function Undo ():void
      {
         if (mEditorWorld == null)
            return;
         
         var worldState:WorldState = mWorldHistoryManager.UndoHistory ();
         
         RestoreWorld (worldState);
      }
      
      public function Redo ():void
      {
         if (mEditorWorld == null)
            return;
         
         var worldState:WorldState = mWorldHistoryManager.RedoHistory ();
         
         RestoreWorld (worldState);
      }
      
//============================================================================
// quick save and load 
//============================================================================
      
      public static const kQuickSaveFileName:String = "cieditor-quicksave";
      public static const kAutoSaveName:String = "quick save";
      public static const kMaxQickSaveFileSize:uint = 1000000; // 1M bytes
      
      public function QuickSave (saveName:String = null):void
      {
         var so:SharedObject;
         try
         {
            so = SharedObject.getLocal(kQuickSaveFileName);
            
            var designDataForEditing:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
            designDataForEditing.compress ();
            designDataForEditing.position = 0;
            
            if (saveName == null)
               saveName = kAutoSaveName;
            
            var timeText:String = new Date ().toLocaleString ();
            
            var theSave:Object = {mName: saveName, mTime: timeText, mData: designDataForEditing};
            
            if (so.data.mQuickSaves == null)
               so.data.mQuickSaves = [theSave];
            else
               so.data.mQuickSaves.unshift (theSave);
            
            while (so.size > kMaxQickSaveFileSize && so.data.mQuickSaves.length > 1)
            {
               so.data.mQuickSaves.pop ();
            }
            
            var flushStatus:String = so.flush ();
            if (flushStatus != null) 
            {
                //switch (flushStatus) {
                //    case SharedObjectFlushStatus.PENDING:
                //        output.appendText("Requesting permission to save object...\n");
                //        mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                //        break;
                //    case SharedObjectFlushStatus.FLUSHED:
                //        output.appendText("Value flushed to disk.\n");
                //        break;
                //}
            }
         }
         catch (error:Error)
         {
            Alert.show("Sorry, quick saving error! " + error, "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
      public function QuickLoad ():void
      {
         var values:Object = new Object ();
         
         try
         {
            var so:SharedObject = SharedObject.getLocal(kQuickSaveFileName);
            
            values.mQuickSaves = so.data.mQuickSaves;
         }
         catch (error:Error)
         {
            values.mQuickSaves = null;
         }
         
         if (values.mQuickSaves == null)
         {
            values.mQuickSaves = new Array ();
         }
         
         ShowWorldQuickLoadingDialog (values, OnLoadQuickSaveData);
      }
      
      public function OnLoadQuickSaveData (params:Object):void
      {
         if (params.mLoadQuickSaveId == undefined || params.mLoadQuickSaveId < 0 || params.mLoadQuickSaveId >= params.mQuickSaves.length)
            return;
         
         try
         {
            var quickSave:Object = params.mQuickSaves [params.mLoadQuickSaveId];
            var designDataForEditing:ByteArray = new ByteArray ();
            quickSave.mData.readBytes (designDataForEditing, 0, quickSave.mData.length);
            
            designDataForEditing.position = 0;
            designDataForEditing.uncompress ();
            
            var newEditorWorld:editor.world.World = DataFormat.WorldDefine2EditorWorld (DataFormat2.ByteArray2WorldDefine (designDataForEditing));
            
            mWorldHistoryManager.ClearHistories ();
            
            SetEditorWorld (newEditorWorld);
            
            CreateUndoPoint ();
            
            Alert.show("Loading Scuessed!", "Scuessed");
         }
         catch (error:Error)
         {
            Alert.show("Sorry, quick loading error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
//============================================================================
// online save / open 
//============================================================================
      
      public static const k_ReturnCode_UnknowError:int = 0;
      public static const k_ReturnCode_Successed:int = 1;
      public static const k_ReturnCode_NotLoggedIn:int = 2;
      public static const k_ReturnCode_SlotIdOutOfRange:int = 3;
      public static const k_ReturnCode_DesignNotCreatedYet:int = 4;
      public static const k_ReturnCode_DesignAlreadyRemoved:int = 5;
      public static const k_ReturnCode_DesignCannotBeCreated:int = 6;
      public static const k_ReturnCode_ProfileNameNotCreatedYet:int = 7;
      public static const k_ReturnCode_NoEnoughRightsToProcess:int = 8;

      public function GetFlashParams ():Object
      {
         //try 
         //{
            var loadInfo:LoaderInfo = LoaderInfo(stage.root.loaderInfo);
            
            var params:Object = new Object ();
            
            params.mRootUrl = UrlUtil.GetRootUrl (loaderInfo.url);
            
            var flashVars:Object = loaderInfo.parameters;
            if (flashVars != null)
            {
               if (flashVars.action != null)
                  params.mAction = flashVars.action;
               if (flashVars.author != null)
                  params.mAuthorName = flashVars.author;
               if (flashVars.slot != null)
                  params.mSlotID = flashVars.slot;
               if (flashVars.revision != null)
                  params.mRevisionID = flashVars.revision;
            }
            
            return params;
         //} 
         //catch (error:Error) 
         //{
         //    Logger.Trace ("Parse flash vars error." + error);
         //}
         //
         //return null;
      }
      
      public function OnlineSave (options:Object = null):void
      {
         //
         var isImportant:Boolean = false;
         var revisionComment:String = "";
         if (options != null)
         {
            isImportant = options.mIsImportant;
            revisionComment = options.mRevisionComment.substr (0, 100);
         }
         var designDataRevisionComment:ByteArray = new ByteArray ();
         designDataRevisionComment.writeMultiByte (revisionComment, "utf-8");
         designDataRevisionComment.position = 0;
         
         //
         var params:Object = GetFlashParams ();
         
         //trace ("params.mRootUrl = " + params.mRootUrl)
         //trace ("params.mSlotID = " + params.mSlotID)
         
         if (params.mRootUrl == null || params.mAuthorName == null || params.mSlotID == null)
            return;
         
         var designDataForEditing:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
         designDataForEditing.compress ();
         designDataForEditing.position = 0;
         
         var designDataForPlaying:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
         designDataForPlaying.compress ();
         designDataForPlaying.position = 0;
         
         var designDataAll:ByteArray = new ByteArray ();
         
         designDataAll.writeInt (Config.VersionNumber);
         
         designDataAll.writeByte (isImportant ? 1 : 0);
         
         designDataAll.writeInt (designDataRevisionComment.length);
         designDataAll.writeInt (designDataForEditing.length);
         designDataAll.writeInt (designDataForPlaying.length);
         
         designDataAll.writeBytes (designDataRevisionComment);
         designDataAll.writeBytes (designDataForEditing);
         designDataAll.writeBytes (designDataForPlaying);
         
         //trace ("designDataForEditing.length = " + designDataForEditing.length)
         //trace ("designDataForPlaying.length = " + designDataForPlaying.length)
         
         var designSaveUrl:String = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/save";
         var request:URLRequest = new URLRequest (designSaveUrl);
         request.contentType = "application/octet-stream";
         request.method = URLRequestMethod.POST;
         request.data = designDataAll;
         
         //trace ("designSaveUrl = " + designSaveUrl)
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
            
            //loader.addEventListener (Event.OPEN, openHandler);
            //loader.addEventListener (ProgressEvent.PROGRESS, progressHandler);
            //loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            //loader.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            //loader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
         
         loader.addEventListener(Event.COMPLETE, OnOnlineSaveCompleted);
         
         loader.load ( request );
         //navigateToURL ( request )
      }
      
      private function OnOnlineSaveCompleted(event:Event):void 
      {
         var loader:URLLoader = URLLoader(event.target);
         
         try
         {
            var data:ByteArray = ByteArray (loader.data);
            
            var returnCode:int = data.readByte ();
            var returnMessage:String = null;
            if (data.length > data.position)
            {
               var length:int = data.readInt ();
               returnMessage = data.readUTFBytes (length);
            }
            
            if (returnCode == k_ReturnCode_Successed)
               Alert.show("Saving Scuessed!", "Scuessed");
            else
               Alert.show("Some errors in saving! returnCode = " + returnCode + ", returnMessage = " + returnMessage, "Error");
         }
         catch (error:Error)
         {
            Alert.show("Sorry, online saving error! " + loader.data + " " + error, "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
      public function OnlineLoad (isFirstTime:Boolean = false):void
      {
         var params:Object = GetFlashParams ();
         
         //trace ("params.mRootUrl = " + params.mRootUrl)
         //trace ("params.mSlotID = " + params.mSlotID)
         
         if (params.mRootUrl == null || params.mAction == null || params.mAuthorName == null || params.mSlotID == null || params.mRevisionID == null)
            return;
         
         if (isFirstTime && params.mAction == "create")
            return;
         
         var designLoadUrl:String = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/revision/" + params.mRevisionID + "/loadsc";
         var request:URLRequest = new URLRequest (designLoadUrl);
         request.method = URLRequestMethod.GET;
         
         //trace ("designLoadUrl = " + designLoadUrl);
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener(Event.COMPLETE, OnOnlineLoadCompleted);
         
         loader.load ( request );
      }
      
      private function OnOnlineLoadCompleted(event:Event):void 
      {
         var loader:URLLoader = URLLoader(event.target);
         
         var returnCode:int = k_ReturnCode_UnknowError;
         
         try
         {
            var data:ByteArray = ByteArray (loader.data);
            
            returnCode = data.readByte ();
            
            if (returnCode == k_ReturnCode_Successed)
            {
               DestroyEditorWorld ();
               
               var designDataForEditing:ByteArray = new ByteArray ();
               
               var newEditorWorld:editor.world.World;
               
               if (data.length > data.position)
               {
                  data.readBytes (designDataForEditing);
                  designDataForEditing.uncompress ();
                  
                  newEditorWorld = DataFormat.WorldDefine2EditorWorld (DataFormat2.ByteArray2WorldDefine (designDataForEditing));
               }
               else
               {
                  newEditorWorld = new editor.world.World ();
               }
               
               mWorldHistoryManager.ClearHistories ();
               
               SetEditorWorld (newEditorWorld);
               
               CreateUndoPoint ();
               
               Alert.show("Loading Scuessed!", "Scuessed");
            }
            else
               Alert.show("Some errors in loading! returnCode = " + returnCode, "Error");
         }
         catch (error:Error)
         {
            if (returnCode == k_ReturnCode_Successed)
               SetEditorWorld (new editor.world.World ());
            
            Alert.show("Sorry, online loading error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
   }
}