
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
   import flash.system.ApplicationDomain;
   
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
   
   import editor.mode.ModePlaceCreateEntity;
   
   import editor.mode.ModeRegionSelectEntities;
   import editor.mode.ModeMoveSelectedEntities;
   
   import editor.mode.ModeRotateSelectedEntities;
   import editor.mode.ModeScaleSelectedEntities;
   
   import editor.mode.ModeMoveSelectedVertexControllers;
   
   import editor.mode.ModeMoveWorldScene;
   
   import editor.mode.ModeCreateEntityLink;
   
   
   import editor.runtime.Runtime;
   
   import editor.display.CursorCrossingLine;
   
   import editor.display.EditingEffect
   import editor.display.EffectCrossingAiming;
   import editor.display.EffectMessagePopup;
   
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
   import editor.entity.EntityUtilityPowerSource;
   
   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityInputEntityScriptFilter;
   import editor.trigger.entity.EntityInputEntityPairScriptFilter;
   import editor.trigger.entity.EntityInputEntityRegionSelector;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_TimerWithPrePostHandling;
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
   
   import viewer.Viewer;
   
   import common.WorldDefine;
   import common.DataFormat;
   import common.DataFormat2;
   import common.DataFormat3;
   import common.Define;
   import common.Config;
   import common.Version;
   import common.ValueAdjuster;
   
   import common.trigger.CoreEventIds;
   import common.KeyCodes;
   
   //import misc.Analytics;
   
   public class WorldView extends UIComponent 
   {
      public static const DefaultWorldWidth:int = Define.DefaultWorldWidth; 
      public static const DefaultWorldHeight:int = Define.DefaultWorldHeight;
      public static const WorldBorderThinknessLR:int = Define.WorldBorderThinknessLR;
      public static const WorldBorderThinknessTB:int = Define.WorldBorderThinknessTB;
      
      public static const BackgroundGridSize:int = 50;
      
      
      private var mEditiingViewContainer:Sprite;
      private var mPlayingViewContainer:Sprite;
      
         public var mViewBackgroundSprite:Sprite = null;
         
         private var mEditorElementsContainer:Sprite;
         
            public var mEditorBackgroundLayer:Sprite = null;
               public var mEntityLinksLayer:Sprite = null;
            public var mContentLayer:Sprite;
            public var mForegroundLayer:Sprite;
               public var mWorldDebugInfoLayer:Sprite;
               private var mEntityIdsLayer:Sprite;
               private var mSelectedEntitiesCenterSprite:Sprite;
            private var mEditingEffectLayer:Sprite;
            public var mCursorLayer:Sprite;
            
         private var mPlayerElementsContainer:Sprite;
         private var mFloatingMessageLayer:Sprite;
         
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
      
      private var mDesignPlayer:Viewer = null;
         
      // ...
      private var mAnalyticsDurations:Array = [0.5, 1, 2, 5, 10, 15, 20, 30];
      //private var mAnalytics:Analytics;
      
   //===========================================================================
      
      public function WorldView ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         //
         mEditiingViewContainer = new Sprite ();
         mPlayingViewContainer = new Sprite ();
         addChild (mEditiingViewContainer);
         addChild (mPlayingViewContainer);
         mPlayingViewContainer.visible = false;
         
         //
         mViewBackgroundSprite = new Sprite ();
         mEditiingViewContainer.addChild (mViewBackgroundSprite);
         
         //
         mEditorElementsContainer = new Sprite ();
         mEditiingViewContainer.addChild (mEditorElementsContainer);
         
         //
         mContentLayer = new Sprite ();
         mEditorElementsContainer.addChild (mContentLayer);
         
         mForegroundLayer = new Sprite ();
         mEditorElementsContainer.addChild (mForegroundLayer);
            
            mWorldDebugInfoLayer = new Sprite ();
            mForegroundLayer.addChild (mWorldDebugInfoLayer);
            
            mEntityIdsLayer = new Sprite ();
            mForegroundLayer.addChild (mEntityIdsLayer);
            
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
            mForegroundLayer.addChild (mSelectedEntitiesCenterSprite);
            
         mEditingEffectLayer = new Sprite ();
         mEditorElementsContainer.addChild (mEditingEffectLayer);
         
         mCursorLayer = new Sprite ();
         mEditorElementsContainer.addChild (mCursorLayer);
         
         //
         mFloatingMessageLayer = new Sprite ();
         mFloatingMessageLayer.visible = true;
         mEditiingViewContainer.addChild (mFloatingMessageLayer);
         
         //
         mPlayerElementsContainer = new Sprite ();
         mPlayingViewContainer.addChild (mPlayerElementsContainer);
         
         //
         
         mWorldHistoryManager = new WorldHistoryManager ();
         SetEditorWorld (new editor.world.World (), true);
         CreateUndoPoint ("Startup");
         
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
      
      private function RegisterNotifyFunctions ():void
      {
         InputEntitySelector.sNotifyEntityLinksModified = NotifyEntityLinksModified;
      }
      
//============================================================================
//   online save . load
//============================================================================
      
      private var mIsOnlineEditing:Boolean = false;
      
      public function IsOnlineEditing ():Boolean
      {
         return mIsOnlineEditing;
      }
      
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
         //mAnalytics = new Analytics (this, mAnalyticsDurations);
         //mAnalytics.TrackPageview (Config.VirtualPageName_EditorJustLoaded);
         
         //
         mIsOnlineEditing = OnlineLoad (true);
      }
      
      private var mContentMaskSprite:Shape = null;
      
      private function OnResize (event:Event):void 
      {
         mViewWidth  = parent.width;
         mViewHeight = parent.height;
         
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
            mContentLayer.addChild (mContentMaskSprite);
            
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
         try
         {
            var newScale:Number;
            
            
            if ( IsPlaying () )
            {
               // mDesignPlayer.Update
               // will call mDesignPlayer.EnterFrame ()
               
               //
               UpdateDesignPalyerPosition ();
               var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld () as player.world.World;
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
                     {
                        mEditorWorld.SetZoomScale (mEditorWorldZoomScale);
                        NotifyEntityLinksModified ();
                        NotifyEntityIdsModified ();
                     }
                     
                     if (NotifyEditingScaleChanged != null)
                        NotifyEditingScaleChanged ();
                     
                     UpdateBackgroundAndWorldPosition ();
                  }
                  else if (mEditorWorld.scaleX > mEditorWorldZoomScale)
                  {
                     if (mEditorWorldZoomScaleChangedSpeed > 0)
                        mEditorWorldZoomScaleChangedSpeed = - mEditorWorldZoomScaleChangedSpeed;
                     
                     newScale = mEditorWorld.scaleX + mEditorWorldZoomScaleChangedSpeed;
                     mEditorWorld.scaleY = mEditorWorld.scaleX = newScale;
                     
                     if (mEditorWorld.scaleX <= mEditorWorldZoomScale)
                     {
                        mEditorWorld.SetZoomScale (mEditorWorldZoomScale);
                        NotifyEntityLinksModified ();
                        NotifyEntityIdsModified ();
                     }
                     
                     if (NotifyEditingScaleChanged != null)
                        NotifyEditingScaleChanged ();
                     
                     UpdateBackgroundAndWorldPosition ();
                  }
               }
               
               mEditorWorld.Update (mStepTimeSpan.GetLastSpan ());
               
               RepaintEntityLinks ();
               RepaintEntityIds ();
               
               UpdateEffects ();
            }
         }
         catch (error:Error)
         {
            if (IsPlaying ())
               HandlePlayingError (error);
            else
               HandleEditingError (error);
         }
         
         // ...
         //mAnalytics.TrackTime (Config.VirtualPageName_EditorTimePrefix);
      }
      
      private function SynchronizePositionAndScaleWithEditorWorld (sprite:Sprite):void
      {
            sprite.scaleX = mEditorWorld.scaleX;
            sprite.scaleY = mEditorWorld.scaleY;
            sprite.x = mEditorWorld.x;
            sprite.y = mEditorWorld.y;
      }
      
//==================================================================================
// painted interfaces
//==================================================================================
      
      public function GetViewWidth ():Number
      {
         return mViewWidth;
      }
      
      public function GetViewHeight ():Number
      {
         return mViewHeight;
      }
      
      public function UpdateChildComponents ():void
      {
         UpdateBackgroundAndWorldPosition ();
         //UpdateViewInterface ();
         UpdateSelectedEntityInfo ();
      }
      
      public function UpdateBackgroundAndWorldPosition ():void
      {
         if (mEditorBackgroundLayer == null)
         {
            mEditorBackgroundLayer = new Sprite ();
            mEditorElementsContainer.addChildAt (mEditorBackgroundLayer, 0);
            
            mEntityLinksLayer = new Sprite ();
            mEditorBackgroundLayer.addChild (mEntityLinksLayer);
         }
         
         var sceneLeft  :Number;
         var sceneTop   :Number;
         var sceneWidth :Number;
         var sceneHeight:Number;
         
         if (mEditorWorld.IsInfiniteSceneSize ())
         {
            sceneLeft   = -1000000000; // about halft of - 0x7FFFFFFF;
            sceneTop    = - 1000000000; // about half of - 0x7FFFFFFF;
            sceneWidth  = 2000000000; // about half of uint (0xFFFFFFFF);
            sceneHeight = 2000000000; // about half of uint (0xFFFFFFFF);
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
         
         mEditorBackgroundLayer.graphics.clear ();
         
         mEditorBackgroundLayer.graphics.beginFill(bgColor);
         mEditorBackgroundLayer.graphics.drawRect (bgLeft, bgTop, bgWidth, bgHeight);
         mEditorBackgroundLayer.graphics.endFill ();
         
         mEditorBackgroundLayer.graphics.lineStyle (1, 0xA0A0A0);
         while (gridX <= bgRight)
         {
            mEditorBackgroundLayer.graphics.moveTo (gridX, bgTop);
            mEditorBackgroundLayer.graphics.lineTo (gridX, bgBottom);
            gridX += gridWidth;
         }
         
         while (gridY <= bgBottom)
         {
            mEditorBackgroundLayer.graphics.moveTo (bgLeft, gridY);
            mEditorBackgroundLayer.graphics.lineTo (bgRight, gridY);
            gridY += gridHeight;
         }
         mEditorBackgroundLayer.graphics.lineStyle ();
         
         if (drawBorder)
         {
            var borderThinknessL:Number = mEditorWorld.GetWorldBorderLeftThickness () * mEditorWorld.scaleX;
            var borderThinknessR:Number = mEditorWorld.GetWorldBorderRightThickness () * mEditorWorld.scaleX;
            var borderThinknessT:Number = mEditorWorld.GetWorldBorderTopThickness () * mEditorWorld.scaleY;
            var borderThinknessB:Number = mEditorWorld.GetWorldBorderBottomThickness () * mEditorWorld.scaleY;
            
            mEditorBackgroundLayer.graphics.beginFill(borderColor);
            mEditorBackgroundLayer.graphics.drawRect (worldViewLeft, worldViewTop, borderThinknessL, worldViewHeight);
            mEditorBackgroundLayer.graphics.drawRect (worldViewRight - borderThinknessR, worldViewTop, borderThinknessR, worldViewHeight);
            mEditorBackgroundLayer.graphics.endFill ();
            
            mEditorBackgroundLayer.graphics.beginFill(borderColor);
            mEditorBackgroundLayer.graphics.drawRect (worldViewLeft, worldViewTop, worldViewWidth, borderThinknessT);
            mEditorBackgroundLayer.graphics.drawRect (worldViewLeft, worldViewBottom - borderThinknessB, worldViewWidth, borderThinknessB);
            mEditorBackgroundLayer.graphics.endFill ();
         }
      }
      
      public function UpdateSelectedEntityInfo ():void
      {
         // ...
         if (mLastSelectedEntity != null && ! mEditorWorld.IsEntitySelected (mLastSelectedEntity))
            SetLastSelectedEntities (null);
         
         if (mMainSelectedEntity == null)
         {
            if (StatusBar_SetMainSelectedEntityInfo != null)
               StatusBar_SetMainSelectedEntityInfo (null);
            return;
         }
         
         var mainEntity:Entity = mMainSelectedEntity.GetMainEntity ();
         var typeName:String = mMainSelectedEntity.GetTypeName ();
         var infoText:String = mMainSelectedEntity.GetInfoText ();
         
         if (infoText == null || infoText.length == 0)
            infoText = "</b>";
         else
            infoText = "</b>: " + infoText;
         
         if (mainEntity != mMainSelectedEntity)
         {
            infoText = " (of &lt;" + mEditorWorld.GetEntityCreationId (mainEntity) + "&gt; " + mainEntity.GetTypeName () + ")" + infoText;
         }
         infoText = "<b>&lt;" + mEditorWorld.GetEntityCreationId (mMainSelectedEntity) + "&gt; " + mMainSelectedEntity.GetTypeName () + infoText;
         
         StatusBar_SetMainSelectedEntityInfo (infoText);
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
               var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld () as player.world.World;
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
         var point:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, mForegroundLayer, _SelectedEntitiesCenterPoint );
         mSelectedEntitiesCenterSprite.x = point.x;
         mSelectedEntitiesCenterSprite.y = point.y;
      }
      
      private var mEntityLinksModified:Boolean = false;
      
      public function NotifyEntityLinksModified ():void
      {
         mEntityLinksModified = true;
      }
      
      private var mShowAllEntityLinks:Boolean = false;
      
      private function RepaintEntityLinks ():void
      {
         if (mEntityLinksModified)
         {
            mEntityLinksModified = false;
            mEntityLinksLayer.graphics.clear ();
            mEditorWorld.DrawEntityLinks (mEntityLinksLayer, mShowAllEntityLinks);
            
            UpdateSelectedEntityInfo ();
         }
         
         if (mEntityLinksLayer.scaleX != mEditorWorld.scaleX)
            mEntityLinksLayer.scaleX = mEditorWorld.scaleX;
         if (mEntityLinksLayer.scaleY != mEditorWorld.scaleY)
            mEntityLinksLayer.scaleY = mEditorWorld.scaleY;
         if ((int (20.0 * mEntityLinksLayer.x)) != (int (20.0 * mEditorWorld.x)))
            mEntityLinksLayer.x = mEditorWorld.x;
         if ((int (20.0 * mEntityLinksLayer.y)) != (int (20.0 * mEditorWorld.y)))
            mEntityLinksLayer.y = mEditorWorld.y;
      }
      
      private var mEntityIdsModified:Boolean = false;
      
      private function NotifyEntityIdsModified ():void
      {
         mEntityIdsModified = true;
      }
      
      private var mShowAllEntityIds:Boolean = false;
      
      private function RepaintEntityIds ():void
      {
         if (mEntityIdsModified)
         {
            mEntityIdsModified = false;
            
            mEntityIdsLayer.visible = mShowAllEntityIds;
            
            if (! mShowAllEntityIds)
               return;
            
            mEditorWorld.DrawEntityIds (mEntityIdsLayer);
         }
         
         if (mEntityIdsLayer.scaleX != mEditorWorld.scaleX)
            mEntityIdsLayer.scaleX = mEditorWorld.scaleX;
         if (mEntityIdsLayer.scaleY != mEditorWorld.scaleY)
            mEntityIdsLayer.scaleY = mEditorWorld.scaleY;
         if ((int (20.0 * mEntityIdsLayer.x)) != (int (20.0 * mEditorWorld.x)))
            mEntityIdsLayer.x = mEditorWorld.x;
         if ((int (20.0 * mEntityIdsLayer.y)) != (int (20.0 * mEditorWorld.y)))
            mEntityIdsLayer.y = mEditorWorld.y;
     }
      
      public function RepaintWorldDebugInfo ():void
      {
         if (Compile::Is_Debugging)// && false)
         {
            mWorldDebugInfoLayer.x = mEditorWorld.x;
            mWorldDebugInfoLayer.y = mEditorWorld.y;
            mWorldDebugInfoLayer.scaleX = mEditorWorld.scaleX;
            mWorldDebugInfoLayer.scaleY = mEditorWorld.scaleY;
            
            while (mWorldDebugInfoLayer.numChildren > 0)
               mWorldDebugInfoLayer.removeChildAt (0);
            
            mEditorWorld.RepaintContactsInLastRegionSelecting (mWorldDebugInfoLayer);
         }
      }
      
      public function UpdateEffects ():void
      {
         // reverse order for some effects will remove itself
         var effect:EditingEffect;
         var i:int;
         
         if (! IsPlaying ())
         {
            for (i = mEditingEffectLayer.numChildren - 1; i >= 0; -- i)
            {
               effect = mEditingEffectLayer.getChildAt (i) as EditingEffect
               if (effect != null)
               {
                  effect.Update ();
               }
            }
         }
         
         for (i = mFloatingMessageLayer.numChildren - 1; i >= 0; -- i)
         {
            effect = mFloatingMessageLayer.getChildAt (i) as EditingEffect
            if (effect != null)
            {
               effect.Update ();
            }
         }
         
         EffectMessagePopup.UpdateMessagesPosition (mFloatingMessageLayer);
      }
      
//==================================================================================
// mode
//==================================================================================
      
      // create mode
      private var mCurrentCreateMode:Mode = null;
      private var mLastSelectedCreateButton:Button = null;
      
      // edit mode
      private var mCurrentEditMode:Mode = null;
      
      // cursors
      private var mCursorCreating:CursorCrossingLine = new CursorCrossingLine ();
      
      
      
      public function SetCurrentCreateMode (mode:Mode):void
      {
         if (mCurrentCreateMode != null)
         {
            mCurrentCreateMode.Destroy ();
            mCurrentCreateMode = null;
         }
         
         if (Runtime.HasSettingDialogOpened ())
         {
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            return;
         }
         
         mCurrentCreateMode = mode;
         
         if (mCurrentCreateMode != null)
         {
            mIsCreating = true;
            mLastSelectedCreateButton.selected = true;
         }
         else
         {
            mIsCreating = false;
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
         }
         
         UpdateUiButtonsEnabledStatus ();
         
         if (mCurrentCreateMode != null)
            mCurrentCreateMode.Initialize ();
      }
      
      public function CancelCurrentCreatingMode ():void
      {
         if (mCurrentCreateMode != null)
         {
            SetCurrentCreateMode (null);
         }
      }
      
      public function SetCurrentEditMode (mode:Mode):void
      {
         if (mCurrentEditMode != null)
         {
            mCurrentEditMode.Destroy ();
            mCurrentEditMode = null;
         }
         
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
      
      public function CancelCurrentEditingMode ():void
      {
         if (mCurrentEditMode != null)
         {
            SetCurrentEditMode (null);
         }
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
      
      public var mButtonCreateBox:Button;
      public var mButtonCreateBall:Button;
      public var mButtonCreatePolygon:Button;
      public var mButtonCreatePolyline:Button;
      public var mButtonCreateTextButton:Button;
      public var mButtonCreateText:Button;
      public var mButtonCreateGravityController:Button;
      public var mButtonCreateCamera:Button;
      
      public var mButtonCreateLinearForce:Button;
      public var mButtonCreateAngularForce:Button;
      public var mButtonCreateLinearImpulse:Button;
      public var mButtonCreateAngularImpulse:Button;
      //public var mButtonCreateAngularAcceleration:Button;
      //public var mButtonCreateAngularVelocity:Button;
      //public var mButtonCreateLinearAcceleration:Button;
      //public var mButtonCreateLinearVelocity:Button;
      
      public var mButtonCreateCondition:Button;
      public var mButtonCreateConditionDoor:Button;
      public var mButtonCreateTask:Button;
      public var mButtonCreateEntityAssigner:Button;
      public var mButtonCreateEntityPairAssigner:Button;
      //public var mButtonCreateEntityRegionSelector:Button;
      public var mButtonCreateEntityFilter:Button;
      public var mButtonCreateEntityPairFilter:Button;
      public var mButtonCreateAction:Button;
      public var mButtonCreateEventHandler0:Button;
      public var mButtonCreateEventHandler1:Button;
      public var mButtonCreateEventHandler2:Button;
      public var mButtonCreateEventHandler3:Button;
      public var mButtonCreateEventHandler4:Button;
      public var mButtonCreateEventHandler5:Button;
      public var mButtonCreateEventHandler6:Button;
      public var mButtonCreateEventHandler7:Button;
      public var mButtonCreateEventHandler8:Button;
      public var mButtonCreateEventHandler50:Button;
      public var mButtonCreateEventHandler51:Button;
      public var mButtonCreateEventHandler52:Button;
      public var mButtonCreateEventHandler53:Button;
      public var mButtonCreateEventHandler56:Button;
      public var mButtonCreateEventHandler57:Button;
      public var mButtonCreateEventHandler58:Button;
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         if (mCurrentCreateMode != null)
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
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateText));
               break;
            case mButtonCreateTextButton:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityTextButton));
               break;
            case mButtonCreateGravityController:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateGravityController));
               break;
            case mButtonCreateCamera:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityCamera));
               break;
            
            case mButtonCreateLinearForce:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_Force}));
               break;
            case mButtonCreateAngularForce:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_Torque}));
               break;
            case mButtonCreateLinearImpulse:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_LinearImpusle}));
               break;
            case mButtonCreateAngularImpulse:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_AngularImpulse}));
               break;
            //case mButtonCreateAngularAcceleration:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_AngularAcceleration}));
            //   break;
            //case mButtonCreateAngularVelocity:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_AngularVelocity}));
            //   break;
            //case mButtonCreateLinearAcceleration:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_LinearAcceleration}));
            //   break;
            //case mButtonCreateLinearVelocity:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityUtilityPowerSource, {mPowerSourceType: Define.PowerSource_LinearVelocity}));
            //   break;
            
          // logic
          
            case mButtonCreateCondition:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityCondition) );
               break;
            case mButtonCreateConditionDoor:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityConditionDoor) );
               break;
            case mButtonCreateTask:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityTask) );
               break;
            case mButtonCreateAction:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityAction) );
               break;
            case mButtonCreateEntityAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityAssigner) );
               break;
            case mButtonCreateEntityPairAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityPairAssigner) );
               break;
            //case mButtonCreateEntityRegionSelector:
            //   SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityRegionSelector) );
            //   break;
            case mButtonCreateEntityFilter:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityFilter) );
               break;
            case mButtonCreateEntityPairFilter:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityInputEntityPairFilter) );
               break;
               
            case mButtonCreateEventHandler0:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldBeforeInitializing, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler1:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldAfterInitialized, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler2:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLWorldBeforeUpdating, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler3:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldAfterUpdated, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler4:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointReachLowerLimit, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler5:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointReachUpperLimit, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler6:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldTimer, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler7:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldKeyDown, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler8:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnWorldMouseClick, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler50:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityInitialized, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler51:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityUpdated, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler52:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityDestroyed, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler53:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler56:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityPairTimer, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler57:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityTimer, mPotientialEventIds:null}) );
               break;
            case mButtonCreateEventHandler58:
               SetCurrentCreateMode (new ModePlaceCreateEntity (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityMouseClick, mPotientialEventIds:null}) );
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
      public var mButtonMouseCookieMode:Button;
      public var mButtonMouseMoveScene:Button;
      public var mButtonMouseMove:Button;
      public var mButtonMouseRotate:Button;
      public var mButtonMouseScale:Button;
      
      public var mButton_Play:Button;
      public var mButton_Stop:Button;
      
      public var mButtonNewDesign:Button;
      //public var mButtonSaveWorld:Button;
      //public var mButtonLoadWorld:Button;
      
      public var mButtonShowEntityIds:Button;
      public var mButtonShowLinks:Button;
      
      public var mButtonHideInvisibleEntities:Button;
      public var mButtonHideShapesAndJoints:Button;
      public var mButtonHideTriggers:Button;
      
      public var SetBatchSettingMenuItemsEnabled:Function;
      
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
         
         //mMenuItemExportSelectedsToSystemMemory.enabled = selectedEntities.length > 0;
         
      // context menu of entity setting button
         
         var numEntities:int = 0;
         var numShapes:int = 0;
         var numJoints:int = 0;
         
         var entity:Entity;
         for (var j:int = 0; j < selectedEntities.length; ++ j)
         {
            entity = selectedEntities [j];
            if (entity != null)
            {
               ++ numEntities;
               
               if (entity is EntityShape)
                  ++ numShapes;
               else if (entity is SubEntityJointAnchor)
                  ++ numJoints;
            }
         }
         
         
         SetBatchSettingMenuItemsEnabled (
                              numEntities > 0,
                              
                              numShapes > 0,
                              numShapes > 0,
                              numShapes > 0,
                              numShapes > 0,
                              
                              numJoints > 0
                              );
      }
      
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
            //case mButtonNewDesign:
            //   ClearAllEntities ();
            //   break;
            //case mButtonSaveWorld:
            //   OpenWorldSavingDialog ();
            //   break;
            //case mButtonLoadWorld:
            //   OpenWorldLoadingDialog ();
            //   break;
            
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
               SetMouseEditModeEnabled (MouseEditMode_MoveWorld, mButtonMouseMoveScene.selected);
               break;
            case mButtonMouseMove:
               SetMouseEditModeEnabled (MouseEditMode_MoveSelecteds, mButtonMouseMove.selected);
               break;
            case mButtonMouseRotate:
               SetMouseEditModeEnabled (MouseEditMode_RotateSelecteds, mButtonMouseRotate.selected);
               break;
            case mButtonMouseScale:
               SetMouseEditModeEnabled (MouseEditMode_ScaleSelecteds, mButtonMouseScale.selected);
               break;
            case mButtonMouseCookieMode:
               SetCookieModeEnabled (mButtonMouseCookieMode.selected);
               break;
            
            case mButton_Play:
               Play_RunRestart ()
               break;
            case mButton_Stop:
               Play_Stop ();
               break;
            
            case mButtonShowEntityIds:
               mShowAllEntityIds = mButtonShowEntityIds.selected;
               NotifyEntityIdsModified ();
               break;
            case mButtonShowLinks:
               mShowAllEntityLinks = mButtonShowLinks.selected;
               NotifyEntityLinksModified ();
               break;
            
            case mButtonHideInvisibleEntities:
               mEditorWorld.SetInvisiblesVisible (! mButtonHideInvisibleEntities.selected);
               OnSelectedEntitiesChanged ();
               break;
            case mButtonHideShapesAndJoints:
               mEditorWorld.SetShapesVisible (! mButtonHideShapesAndJoints.selected);
               mEditorWorld.SetJointsVisible (! mButtonHideShapesAndJoints.selected);
               OnSelectedEntitiesChanged ();
               break;
            case mButtonHideTriggers:
               mEditorWorld.SetTriggersVisible (! mButtonHideTriggers.selected);
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
      
      //private var mMenuItemExportSelectedsToSystemMemory:ContextMenuItem;
      //private var mMenuItemImport:ContextMenuItem;
      //private var mMenuItemQuickLoad:ContextMenuItem;
      
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
            
         
         //mMenuItemExportSelectedsToSystemMemory = new ContextMenuItem ("Export Selected(s) to System Memory", true);
         //theContextMenu.customItems.push (mMenuItemExportSelectedsToSystemMemory);
         //mMenuItemExportSelectedsToSystemMemory.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         //mMenuItemImport = new ContextMenuItem ("Import ...", false);
         //theContextMenu.customItems.push (mMenuItemImport);
         //mMenuItemImport.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         //mMenuItemQuickLoad = new ContextMenuItem ("Load Quick Save Data ...", false);
         //theContextMenu.customItems.push (mMenuItemQuickLoad);
         //mMenuItemQuickLoad.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         mMenuItemAbout = new ContextMenuItem("About Phyard Builder v" + DataFormat3.GetVersionString (Version.VersionNumber)); //, true);
         theContextMenu.customItems.push (mMenuItemAbout);
         mMenuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            //case mMenuItemExportSelectedsToSystemMemory:
            //   ExportSelectedsToSystemMemory ();
            //   break;
            //case mMenuItemImport:
            //   OpenImportSourceCodeDialog ();
            //   break;
            //case mMenuItemQuickLoad:
            //   QuickLoad ();
            //   break;
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
         
         NotifyEntityLinksModified ();
         
         DestroyEditorWorld ();
         ClearAccumulatedModificationsByArrowKeys ();
         
         mEditorWorld = newEditorWorld;
         mEditorWorld.GetCollisionManager ().SetChanged (false);
         if (mEditorWorld.GetFunctionManager ().IsChanged ())
         {
            mEditorWorld.GetFunctionManager ().UpdateFunctionMenu ();
            mEditorWorld.GetFunctionManager ().SetChanged (false)
            mEditorWorld.GetFunctionManager ().SetDelayUpdateFunctionMenu (false)
         }
         
         mEditorWorld.scaleX = mEditorWorld.scaleY = mEditorWorldZoomScale = mEditorWorld.GetZoomScale ();
         
         if (NotifyEditingScaleChanged != null)
            NotifyEditingScaleChanged ();
         
         mContentLayer.addChild (mEditorWorld);
         
         if (Runtime.mCollisionCategoryView != null)
            Runtime.mCollisionCategoryView.SetCollisionManager (mEditorWorld.GetCollisionManager ());
         
         if (Runtime.mFunctionEditingView != null)
            Runtime.mFunctionEditingView.SetFunctionManager (mEditorWorld.GetFunctionManager ());
         
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
            
            if ( mContentLayer.contains (mEditorWorld) )
               mContentLayer.removeChild (mEditorWorld);
         }
         
         mEditorWorld = null;
      }
      
      public function ScaleEditorWorld (scaleIn:Boolean):Boolean
      {
         var reachLimit:Boolean = false;
         
         if (IsEditing ())
         {
            var newSscale:Number = mEditorWorldZoomScale * (scaleIn ? 2.0 : 0.5);
            if (int (newSscale * 32.0) <= 1)
            {
               newSscale = 1.0 / 32.0;
               reachLimit = true;
            }
            if (int (newSscale) >= 32)
            {
               newSscale = 32.0;
               reachLimit = true;
            }
            
            mEditorWorldZoomScale = newSscale;
            mEditorWorldZoomScaleChangedSpeed = (mEditorWorldZoomScale - mEditorWorld.scaleX) * 0.03;
            
            //UpdateBackgroundAndWorldPosition ();
            
            if (NotifyEditingScaleChanged != null)
               NotifyEditingScaleChanged ();
         }
         
         return reachLimit;
      }
      
      public var NotifyEditingScaleChanged:Function = null;
      
      public function GetEditorWorldZoomScale ():Number
      {
         //return mEditorWorld.GetZoomScale ();
         return mEditorWorld.scaleX;
      }
      
      private function SetDesignPlayer (newPlayer:Viewer):void
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
            var playerSize:Point = GetViewportSize ();
            
            mDesignPlayer.x = Math.round ((mViewWidth - playerSize.x) / 2);
            mDesignPlayer.y = Math.round ((mViewHeight - playerSize.y) / 2);
         }
      }
      
      private function HandleEditingError (error:Error):void 
      {
      }
      
//============================================================================
// playing
//============================================================================
      
      public var OnPlayingStarted:Function;
      public var OnPlayingStopped:Function;
      
      //private function GetWorldDefine ():WorldDefine
      //{
      //   return DataFormat.EditorWorld2WorldDefine ( mEditorWorld );
      //}
      
      private function GetWorldBinaryData ():ByteArray
      {
         var byteArray:ByteArray = DataFormat.WorldDefine2ByteArray (DataFormat.EditorWorld2WorldDefine ( mEditorWorld ));
         byteArray.position = 0;
         
         return byteArray;
      }
      
      private function GetViewportSize ():Point
      {
         var viewerUiFlags:int = mEditorWorld.GetViewerUiFlags ();
         var viewportWidth:int = mEditorWorld.GetViewportWidth ();
         var viewportHeight:int = mEditorWorld.GetViewportHeight ();
         
         if ((viewerUiFlags & Define.PlayerUiFlag_ShowPlayBar) != 0)
         {
            return new Point (viewportWidth, viewportHeight + Define.PlayerPlayBarThickness);
         }
         else
         {
            return new Point (viewportWidth, viewportHeight);
         }
      }
      
      public function Play_RunRestart (keepPauseStatus:Boolean = false):void
      {
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         Runtime.SetHasInputFocused (false);
         stage.focus = this;
         
         DestroyDesignPlayer ();
         
         //var useQuickMethod:Boolean;
         //
         //if (Compile::Is_Debugging)
         //{
         //   useQuickMethod = true;
         //}
         //else
         //{
         //   useQuickMethod = false;
         //}
         //
         //if (useQuickMethod)
         //{
         //   SetDesignPlayer (new Viewer ({mParamsFromEditor: {GetWorldDefine:GetWorldDefine, GetWorldBinaryData:null, GetViewportSize:GetViewportSize, mStartRightNow: true, mMaskViewerField: mMaskViewerField}}));
         //}
         //else
         //{
         //   SetDesignPlayer (new Viewer ({mParamsFromEditor: {GetWorldDefine:null, GetWorldBinaryData:GetWorldBinaryData, GetViewportSize:GetViewportSize, mStartRightNow: true, mMaskViewerField: mMaskViewerField}}));
         //}
         
         SetDesignPlayer (new Viewer ({mParamsFromEditor: {mWorldDomain: ApplicationDomain.currentDomain, mWorldBinaryData: GetWorldBinaryData (), GetViewportSize:GetViewportSize, mStartRightNow: true, mMaskViewerField: mMaskViewerField}}));
         
         mIsPlaying = true;
         
         mEditiingViewContainer.visible = false;
         mPlayingViewContainer.visible = true;
         
         if (OnPlayingStarted != null)
            OnPlayingStarted ();
         
         mAlreadySavedWhenPlayingError = false;
      }
      
      public function Play_Stop ():void
      {
         mAlreadySavedWhenPlayingError = false;
         
         DestroyDesignPlayer ();
         
         mIsPlaying = false;
         
         mEditiingViewContainer.visible = true;
         mPlayingViewContainer.visible = false;
         
         if (OnPlayingStopped != null)
            OnPlayingStopped ();
      }
      
      private function SetPlayingSpeed (speed:Number):void
      {
      }
      
      private function HandlePlayingError (error:Error):void
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
      
      public function PlayRestart ():void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayRestart ();
         }
      }
      
      public function PlayRun ():void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayRun ();
         }
      }
      
      public function PlayPause ():void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayPause ();
         }
      }
      
      public function PlayOneStep ():void
      {
         if (IsPlaying ())
         {
            mDesignPlayer.UpdateSingleStep ();
         }
      }
      
      public function PlayFaster (delta:uint):Boolean
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlayFaster (delta);
         }
         
         return true;
      }
      
      public function PlaySlower (delta:uint):Boolean
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.PlaySlower (delta);
         }
         
          return true;
      }
      
      public function GetPlayingSpeedX ():int
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.GetPlayingSpeedX ();
         }
         
         return 0;
      }
      
      public function GetPlayingSimulatedSteps ():int
      {
         if (IsPlaying ())
         {
            var playerWorld:player.world.World = mDesignPlayer.GetPlayerWorld () as player.world.World;
            return playerWorld == null ? 0 : playerWorld.GetSimulatedSteps ();
         }
         
         return 0;
      }
      
      public function SetOnSpeedChangedFunction (onSpeed:Function):void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.SetOnSpeedChangedFunction (onSpeed);
         }
      }
      
      public function SetOnPlayStatusChangedFunction (onPlayStatusChanged:Function):void
      {
         if (IsPlaying ())
         {
            return mDesignPlayer.SetOnPlayStatusChangedFunction (onPlayStatusChanged);
         }
      }
      
      private static var mMaskViewerField:Boolean = false;
      
      public function IsMaskViewerField ():Boolean
      {
         return mMaskViewerField;
      }
      
      public function SetMaskViewerField (mask:Boolean):void
      {
         mMaskViewerField = mask;
         
         if (IsPlaying ())
         {
            mDesignPlayer.SetMaskViewerField (mMaskViewerField);
         }
      }
      
//============================================================================
//    
//============================================================================
      
      public function OnFinishedCCatEditing ():void
      {
         if (mEditorWorld.GetCollisionManager ().IsChanged ())
         {
            mEditorWorld.GetCollisionManager ().SetChanged (false);
            CreateUndoPoint ("Modify collision categories");
         }
         
         Runtime.SetHasInputFocused (false);
         stage.focus = this;
      }
      
      public function OnFinishedFunctionEditing ():void
      {
         if (mEditorWorld.GetFunctionManager ().IsChanged ())
         {
            mEditorWorld.GetFunctionManager ().SetChanged (false);
            CreateUndoPoint ("Modify functions");
         }
         
         Runtime.SetHasInputFocused (false);
         stage.focus = this;
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
      public var ShowPowerSourceSettingDialog:Function = null;
      
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
      public var ShowTimerEventHandlerWithPreAndPostHandlingSettingDialog:Function = null;
      public var ShowKeyboardEventHandlerSettingDialog:Function = null;
      public var ShowMouseEventHandlerSettingDialog:Function = null;
      public var ShowContactEventHandlerSettingDialog:Function = null;
      public var ShowActionSettingDialog:Function = null;
      public var ShowEntityAssignerSettingDialog:Function = null;
      public var ShowEntityPairAssignerSettingDialog:Function = null;
      public var ShowEntityPairFilterSettingDialog:Function = null;
      public var ShowEntityFilterSettingDialog:Function = null;
      
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
         if (mMainSelectedEntity == null)
            return;
         
         //var entity:Entity = selectedEntities [0] as Entity;
         var entity:Entity = mMainSelectedEntity;
         
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
               event_handler.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = event_handler.GetCodeSnippetName ();
               values.mEventId = event_handler.GetEventId ();
               values.mCodeSnippet  = event_handler.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  values.mRunningInterval = timer_event_handler.GetRunningInterval ();
                  values.mOnlyRunOnce = timer_event_handler.IsOnlyRunOnce ();
                  
                  if (entity is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timer_event_handler_withPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
                     
                     values.mPreCodeSnippet  = timer_event_handler_withPrePostHandling.GetPreCodeSnippet  ().Clone (null);
                     values.mPostCodeSnippet = timer_event_handler_withPrePostHandling.GetPostCodeSnippet ().Clone (null);
                     ShowTimerEventHandlerWithPreAndPostHandlingSettingDialog (values, ConfirmSettingEntityProperties);
                  }
                  else
                  {
                     ShowTimerEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
                  }
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  values.mKeyCodes = keyboard_event_handler.GetKeyCodes ();
                  
                  ShowKeyboardEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  ShowMouseEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  ShowContactEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else
               {
                  ShowEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               condition.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = condition.GetCodeSnippetName ();
               values.mCodeSnippet  = condition.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               ShowConditionSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               action.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = action.GetCodeSnippetName ();
               values.mCodeSnippet  = action.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               ShowActionSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityScriptFilter)
            {
               var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
               
               values.mCodeSnippetName = entityFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = entityFilter.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               ShowEntityFilterSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityPairScriptFilter)
            {
               var pairFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
               
               values.mCodeSnippetName = pairFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = pairFilter.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEditorWorld.GetCoordinateSystem ());
               
               ShowEntityPairFilterSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityConditionDoor)
            {
               ShowConditionDoorSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityTask)
            {
               ShowTaskSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityAssigner)
            {
               ShowEntityAssignerSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
               ShowEntityPairAssignerSettingDialog (values, ConfirmSettingEntityProperties);
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
                  
                  ShowShapeCircleSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityShapeRectangle)
               {
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mEditorWorld.GetCoordinateSystem ().D2P_Length ((shape as EntityShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mEditorWorld.GetCoordinateSystem ().D2P_Length ((shape as EntityShapeRectangle).GetHalfHeight ()), 6);
                  values.mIsRoundCorners = (shape as EntityShapeRectangle).IsRoundCorners ();
                  
                  ShowShapeRectangleSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityShapePolygon)
               {
                  ShowShapePolygonSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityShapePolyline)
               {
                  values.mCurveThickness = (shape as EntityShapePolyline).GetCurveThickness ();
                  values.mIsRoundEnds = (shape as EntityShapePolyline).IsRoundEnds ();
                  
                  ShowShapePolylineSettingDialog (values, ConfirmSettingEntityProperties);
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
                     
                     ShowShapeTextButtonSettingDialog (values, ConfirmSettingEntityProperties);
                  }
                  else
                  {
                     ShowShapeTextSettingDialog (values, ConfirmSettingEntityProperties);
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
                  values.mInitialGravityAngle = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees ((shape as EntityShapeGravityController).GetInitialGravityAngle ()), 6);
                  
                  ShowShapeGravityControllerSettingDialog (values, ConfirmSettingEntityProperties);
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
               
               ShowHingeSettingDialog (values, ConfirmSettingEntityProperties);
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
               
               ShowSliderSettingDialog (values, ConfirmSettingEntityProperties);
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
               
               ShowSpringSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               jointValues.mBreakDeltaLength = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_Length (distance.GetBreakDeltaLength ()), 6);
               //<<
               
               ShowDistanceSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var weld:EntityJointWeld = joint as EntityJointWeld;
               
               ShowWeldSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               ShowDummySettingDialog (values, ConfirmSettingEntityProperties);
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
               
               ShowCameraSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityUtilityPowerSource)
            {
               var powerSource:EntityUtilityPowerSource = entity as EntityUtilityPowerSource;
               
               values.mEventId = powerSource.GetKeyboardEventId ();
               values.mKeyCodes = powerSource.GetKeyCodes ();
               values.mPowerSourceType = powerSource.GetPowerSourceType ();
               values.mPowerMagnitude = powerSource.GetPowerMagnitude ();
               
               switch (powerSource.GetPowerSourceType ())
               {
                  case Define.PowerSource_Torque:
                     values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_Torque (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Torque";
                     break;
                  case Define.PowerSource_LinearImpusle:
                     values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_ImpulseMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Linear Impulse";
                     break;
                  case Define.PowerSource_AngularImpulse:
                     values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_AngularImpulse (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Impulse";
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_AngularAcceleration (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Acceleration";
                     break;
                  case Define.PowerSource_AngularVelocity:
                     values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_AngularVelocity (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Velocity";
                     break;
                  //case Define.PowerSource_LinearAcceleration:
                  //   values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Acceleration";
                  //   break;
                  //case Define.PowerSource_LinearVelocity:
                  //   values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Velocity";
                  //   break;
                  case Define.PowerSource_Force:
                  default:
                     values.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().D2P_ForceMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Force";
                     break;
               }
               values.mPowerMagnitude = ValueAdjuster.Number2Precision (values.mPowerMagnitude, 6);
               
               ShowPowerSourceSettingDialog (values, ConfirmSettingEntityProperties);
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
      
      public function OpenWorldSavingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         try
         {
            // ...
            var width:int = mEditorWorld.GetViewportWidth ();
            var height:int = mEditorWorld.GetViewportHeight ();
            var showPlayBar:Boolean = (mEditorWorld.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0;
            var heightWithPlayBar:int = (showPlayBar ? height + Define.PlayerPlayBarThickness : height);
            
            var fileFormatVersionString:String = DataFormat3.GetVersionHexString (Version.VersionNumber);
            
            var values:Object = new Object ();
            
            //========== source code ========== 
         
            values.mXmlString = DataFormat2.WorldDefine2Xml (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
            
            //=========== play code ========== 
         
            // before v1.55, depreciated now
            //var playcode:String = DataFormat.WorldDefine2HexString (DataFormat.EditorWorld2WorldDefine (mEditorWorld)); 
            //values.mHexString = playcode;
            
            // new one, from v1.55
            var playcodeBase64:String = DataFormat.WorldDefine2PlayCode_Base64 (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
            
            values.mHexString = DataFormat3.CreateForumEmbedCode (fileFormatVersionString, width, height, showPlayBar, playcodeBase64);
            
            //======== html embed code ======== 
         
            // before v1.55, depreciated now
            //values.mEmbedCode = "<embed src=\"http://www.phyard.com/uniplayer.swf?app=ci&format=0x" + fileFormatVersionString
            //                  + "\"\n width=\"" + width + "\" height=\"" + heightWithPlayBar + "\"\n"
            //                  + "  FlashVars=\"playcode=" + playcode
            //                  + "\"\n quality=\"high\" allowScriptAccess=\"sameDomain\"\n type=\"application/x-shockwave-flash\"\n pluginspage=\"http://www.macromedia.com/go/getflashplayer\">\n</embed>"
            //                  ;
            
            // new one: add compressformat in FlashVars; change app=ci to app=coin and change format to fileversion in url.
            values.mEmbedCode = "<embed src=\"http://www.phyard.com/uniplayer.swf?app=coin&fileversion=0x" + fileFormatVersionString
                              + "\"\n width=\"" + width + "\" height=\"" + heightWithPlayBar + "\"\n"
                              + "  FlashVars=\"compressformat=" + DataFormat3.CompressFormat_Base64 + "&playcode=" + playcodeBase64
                              + "\"\n quality=\"high\" allowScriptAccess=\"sameDomain\"\n type=\"application/x-shockwave-flash\"\n pluginspage=\"http://www.macromedia.com/go/getflashplayer\">\n</embed>"
                              ;
            
            ShowWorldSavingDialog (values);
         }
         catch (error:Error)
         {
            Alert.show("Sorry, saving error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
      public function OpenWorldLoadingDialog ():void
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
      
      public static function OpenAboutLink ():void
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
      
      public function  OpenImportSourceCodeDialog (importFunctionsOnly:Boolean):void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         if (importFunctionsOnly)
            ShowImportSourceCodeDialog (ImportFunctionsFromXmlString);
         else
            ShowImportSourceCodeDialog (ImportAllFromXmlString);
      }
      
//==================================================================================
// editing trigger setting
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
            //var func:Function = (mLastSelectedEntity as EntityShape).SetDensity;
            //
            //func.apply (mLastSelectedEntity, [5.0]);
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
      
      public static const MouseEditMode_None:int = -1;
      public static const MouseEditMode_MoveWorld:int = 0;
      public static const MouseEditMode_MoveSelecteds:int = 1;
      public static const MouseEditMode_RotateSelecteds:int = 2;
      public static const MouseEditMode_ScaleSelecteds:int = 3;
      
      public var mCurrentMouseEditMode:int = MouseEditMode_MoveSelecteds;
      public var mLastMouseEditMode:int = MouseEditMode_MoveSelecteds;
      
      private var mCookieModeEnabled:Boolean = false;
      
      public function SetCookieModeEnabled (enabled:Boolean):void
      {
         mCookieModeEnabled = enabled;
      }
      
      public function SetMouseEditModeEnabled (mode:int, modeEnabled:Boolean = false):void
      {
         if (modeEnabled)
            mCurrentMouseEditMode = mode;
         else
            mCurrentMouseEditMode = MouseEditMode_None;
         
         if (modeEnabled)
            mLastMouseEditMode = mCurrentMouseEditMode;
         
         mButtonMouseMoveScene.selected = false;
         mButtonMouseMove.selected = false;
         mButtonMouseRotate.selected = false;
         mButtonMouseScale.selected = false;
         
         if (modeEnabled)
         {
            if (mCurrentMouseEditMode == MouseEditMode_MoveWorld)
            {
               mButtonMouseMoveScene.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_MoveSelecteds)
            {
               mButtonMouseMove.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_RotateSelecteds)
            {
               mButtonMouseRotate.selected = true;
            }
            else if (mCurrentMouseEditMode == MouseEditMode_ScaleSelecteds)
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
         return mCurrentMouseEditMode != MouseEditMode_MoveWorld && mCurrentMouseEditMode == MouseEditMode_MoveSelecteds;
      }
      
      private function IsEntityMouseRotateEnabled ():Boolean
      {
         if (_mouseEventShiftDown && ! IsEntityMouseEditLocked ())
            return true;
         
         return mCurrentMouseEditMode != MouseEditMode_MoveWorld && mCurrentMouseEditMode == MouseEditMode_RotateSelecteds;
      }
      
      private function IsEntityMouseScaleEnabled ():Boolean
      {
         if (_mouseEventCtrlDown && ! IsEntityMouseEditLocked ())
            return true;
         
         return mCurrentMouseEditMode != MouseEditMode_MoveWorld && mCurrentMouseEditMode == MouseEditMode_ScaleSelecteds;
      }
      
      private function IsEntityMouseEditLocked ():Boolean
      {
         return mCurrentMouseEditMode == MouseEditMode_MoveWorld || mCurrentMouseEditMode == MouseEditMode_None;
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
         
         Runtime.SetHasInputFocused (false);
         stage.focus = this;
         
         CheckModifierKeys (event);
         _isZeroMove = true;
         
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mEditorWorld, new Point (event.localX, event.localY) );
         var worldPoint:Point = mEditorWorld.globalToLocal (new Point (Math.round(event.stageX), Math.round (event.stageY)));
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseDown (worldPoint.x, worldPoint.y);
            }
         }
         
         if (IsEditing ())
         {
            var entityArray:Array = mEditorWorld.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
            
         // move scene
            
            if (mCurrentMouseEditMode == MouseEditMode_MoveWorld || (_mouseEventShiftDown && entityArray.length == 0))
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
               
               if ( (! _mouseEventCtrlDown) && ((! mCookieModeEnabled)) )
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
            
            if (_mouseEventCtrlDown || mCookieModeEnabled)
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
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseMove (worldPoint.x, worldPoint.y);
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
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseUp (worldPoint.x, worldPoint.y);
               
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
                     
                     if ( _mouseEventCtrlDown || mCookieModeEnabled )
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
            
            if (_isZeroMove && (! _mouseEventCtrlDown) && mCookieModeEnabled)
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
            if (mCurrentCreateMode != null)
            {
               CancelCurrentCreatingMode ();
               UpdateUiButtonsEnabledStatus ();
               CalSelectedEntitiesCenterPoint ();
            }
         }
         
         
         if (IsEditing ())
         {
            if (mCurrentEditMode != null)
            {
               CancelCurrentEditingMode ();
               UpdateUiButtonsEnabledStatus ();
               CalSelectedEntitiesCenterPoint ();
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
         
         if (Runtime.HasInputFocused ())
            return;
         
         //trace ("event.keyCode = " + event.keyCode + ", event.charCode = " + event.charCode);
         
         if (IsPlaying ()) // playing
         {
            switch (event.keyCode)
            {
               case Keyboard.SPACE:
                  //mDesignPlayer.UpdateSingleStep (); // cancelled from v1.55
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
                  if (mCurrentCreateMode != null)
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
                  //if (mCurrentCreateMode != null)
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
               //case 71: // G // cancelled
               //   GlueSelectedEntities ();
               //   break;
               //case 66: // B // cancelled
               //   BreakApartSelectedEntities ();
               //   break;
               //case 76: // L // cancelled
               //   OpenPlayCodeLoadingDialog ();
               //   break;
               case 192: // ~
                  ToggleMouseEditLocked ();
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
         polygon.SetBorderThickness (0);
         
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
      
      public function CreateEntityUtilityPowerSource (options:Object = null):EntityUtilityPowerSource
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var power_source:EntityUtilityPowerSource = mEditorWorld.CreateEntityUtilityPowerSource ();
            if (power_source == null)
               return null;
            
            power_source.SetPowerSourceType (options.mPowerSourceType);
            
            SetTheOnlySelectedEntity (power_source);
            
            return power_source;
         }
      }
      
      public function CreateEntityCondition (options:Object = null):EntityBasicCondition
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
      
      public function CreateEntityInputEntityRegionSelector (options:Object = null):EntityInputEntityRegionSelector
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityRegionSelector).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_region_selector:EntityInputEntityRegionSelector = mEditorWorld.CreateEntityInputEntityRegionSelector ();
         if (entity_region_selector == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_region_selector);
         
         return entity_region_selector;
      }
      
      public function CreateEntityInputEntityFilter (options:Object = null):EntityInputEntityScriptFilter
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityScriptFilter).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_filter:EntityInputEntityScriptFilter = mEditorWorld.CreateEntityInputEntityScriptFilter ();
         if (entity_filter == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_filter);
         
         return entity_filter;
      }
      
      public function CreateEntityInputEntityPairFilter (options:Object = null):EntityInputEntityPairScriptFilter
      {
         if (options != null && options.stage == ModePlaceCreateEntity. StageFinished)
         {
            // show the entity selector
            (options.entity as EntityInputEntityPairScriptFilter).SetInternalComponentsVisible (true);
            return null;
         }
         
         var entity_pair_filter:EntityInputEntityPairScriptFilter = mEditorWorld.CreateEntityInputEntityPairScriptFilter ();
         if (entity_pair_filter == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_pair_filter);
         
         return entity_pair_filter;
      }
      
      public function CreateEntityEventHandler (options:Object = null):EntityEventHandler
      {
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
         {
            return null;
         }
         else
         {
            var handler:EntityEventHandler
            
            switch (options.mDefaultEventId)
            {
               case CoreEventIds.ID_OnWorldTimer:
                  handler = mEditorWorld.CreateEntityEventHandler_Timer (int(options.mDefaultEventId), options.mPotientialEventIds);
                  break;
               case CoreEventIds.ID_OnEntityTimer:
               case CoreEventIds.ID_OnEntityPairTimer:
                  handler = mEditorWorld.CreateEntityEventHandler_TimerWithPrePostHandling (int(options.mDefaultEventId), options.mPotientialEventIds);
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
         if (options != null && options.stage ==ModePlaceCreateEntity. StageFinished)
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
      
      private var mMainSelectedEntity:Entity = null;
      
      private var mLastSelectedEntity:Entity = null;
      private var mLastSelectedEntities:Array = null;
      
      private var _SelectedEntitiesCenterPoint:Point = new Point ();
      
      public function SetLastSelectedEntities (entity:Entity):void
      {
         mLastSelectedEntity = entity;
         
         
         if (mLastSelectedEntity != null && mEditorWorld != null && mEditorWorld.IsEntitySelected (mLastSelectedEntity))
         {
            mLastSelectedEntity.SetInternalComponentsVisible (true);
            
            mMainSelectedEntity = mLastSelectedEntity;
         }
         else
         {
            mMainSelectedEntity = mEditorWorld == null ? null : mEditorWorld.GetMainSelectedEntity ();
         }
         
         UpdateUiButtonsEnabledStatus ();
         UpdateSelectedEntityInfo ();
         
         NotifyEntityLinksModified ();
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
         
         if ((! mCookieModeEnabled))
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
         else
         {
            entity.SetInternalComponentsVisible (false);
         }
         
         SetLastSelectedEntities (entity);
         
         // to make selecting part of a glued possible
         // mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         SelectedEntities (mEditorWorld.GetEntitiesIntersectWithRegion (left, top, right, bottom), true, ! mCookieModeEnabled);
      }
      
      public function SelectedEntities (entities:Array, clearOlds:Boolean, selectBorthers:Boolean):void
      {
         if (clearOlds)
         {
            mEditorWorld.ClearSelectedEntities ();
         }
         
         if (_mouseEventCtrlDown || mCookieModeEnabled)
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
         
         if (selectBorthers)
         {
            mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         }
         
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
         
         if (count == 1)
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
         
         NotifyEntityLinksModified ();
         
         NotifyEntityIdsModified ();
      }
      
      protected var mAccumulatedCausedByArrowKeys_MovementX:Number = 0;
      protected var mAccumulatedCausedByArrowKeys_MovementY:Number = 0;
      protected function TryCreateUndoPointCausedByArrowKeys_Movement ():void
      {
         if (mAccumulatedCausedByArrowKeys_MovementX != 0 || mAccumulatedCausedByArrowKeys_MovementY != 0)
         {
            mAccumulatedCausedByArrowKeys_MovementX = 0;
            mAccumulatedCausedByArrowKeys_MovementY = 0;
            CreateUndoPoint ("Move entities by arrow keys", null, null, false);
         }
      }
      
      protected var mAccumulatedCausedByArrowKeys_Rotation:Number = 0;
      protected function TryCreateUndoPointCausedByArrowKeys_Rotation ():void
      {
         if (mAccumulatedCausedByArrowKeys_Rotation != 0)
         {
            mAccumulatedCausedByArrowKeys_Rotation = 0;
            CreateUndoPoint ("Rotate entities by arrow keys", null, null, false);
         }
      }
      
      protected function ClearAccumulatedModificationsByArrowKeys ():void
      {
         mAccumulatedCausedByArrowKeys_MovementX = 0;
         mAccumulatedCausedByArrowKeys_MovementY = 0;
         mAccumulatedCausedByArrowKeys_Rotation = 0;
      }
      
      // at any time, most one delayed undo point exists.
      protected function TryCreateDelayedUndoPoint ():void
      {
         TryCreateUndoPointCausedByArrowKeys_Movement ();
         TryCreateUndoPointCausedByArrowKeys_Rotation ();
      }
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseMoveEnabled () )
            return;
         
         mEditorWorld.MoveSelectedEntities (offsetX, offsetY, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
         
         TryCreateUndoPointCausedByArrowKeys_Rotation (); // right! rotate
         if (! byMouse)
         {
            mAccumulatedCausedByArrowKeys_MovementX += offsetX;
            mAccumulatedCausedByArrowKeys_MovementY += offsetY;
         }
      }
      
      public function RotateSelectedEntities (dAngle:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseRotateEnabled () )
            return;
         
         mEditorWorld.RotateSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), dAngle, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
         
         TryCreateUndoPointCausedByArrowKeys_Movement (); // right! move
         if (! byMouse)
         {
            mAccumulatedCausedByArrowKeys_Rotation += dAngle;
         }
      }
      
      public function ScaleSelectedEntities (ratio:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && ! IsEntityMouseScaleEnabled () )
            return;
         
         mEditorWorld.ScaleSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), ratio, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
         
         if ((! byMouse) && (ratio != 1.0))
         {
            CreateUndoPoint ("Scale entities");
         }
      }
      
      public function DeleteSelectedEntities ():void
      {
         if (mEditorWorld.DeleteSelectedEntities ())
         {
            CreateUndoPoint ("Delete");
            
            CalSelectedEntitiesCenterPoint ();
         }
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
         
         CreateUndoPoint ("Clone");
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function FlipSelectedEntitiesHorizontally ():void
      {
         mEditorWorld.FlipSelectedEntitiesHorizontally (GetSelectedEntitiesCenterX ());
         
         CreateUndoPoint ("Horizontal flip");
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function FlipSelectedEntitiesVertically ():void
      {
         mEditorWorld.FlipSelectedEntitiesVertically (GetSelectedEntitiesCenterY ());
         
         CreateUndoPoint ("Vertical flip");
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function GlueSelectedEntities ():void
      {
         mEditorWorld.GlueSelectedEntities ();
         
         CreateUndoPoint ("Make brothers");
      }
      
      public function BreakApartSelectedEntities ():void
      {
         mEditorWorld.BreakApartSelectedEntities ();
         
         CreateUndoPoint ("Break brothers");
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
               
               mShowAllEntityLinks = false;
               mShowAllEntityIds = false;
               
               UpdateChildComponents ();
               
               if (NotifyEditingScaleChanged != null)
                  NotifyEditingScaleChanged ();
            }
            else
            {
               mEditorWorld.DestroyAllEntities ();
            }
            
            CreateUndoPoint ("Clear world");
            
            CalSelectedEntitiesCenterPoint ();
            
            Runtime.mCollisionCategoryView.UpdateFriendLinkLines ();
            Runtime.mFunctionEditingView.UpdateEntityLinkLines ();
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
         
         CreateUndoPoint ("Move entities to the most top layer");
         
         UpdateSelectedEntityInfo ();
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
         mEditorWorld.MoveSelectedEntitiesToBottom ();
         
         CreateUndoPoint ("Move entities to the most bottom layer");
         
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
            
            CreateUndoPoint ("Coincide entity centers");
            
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
            
            CreateUndoPoint ("Delete a vertex");
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function InsertVertexController ():void
      {
         if (mEditorWorld.GetSelectedVertexControllers ().length > 0)
         {
            mEditorWorld.InsertVertexControllerBeforeSelectedVertexControllers ();
            
            CreateUndoPoint ("Insert a vertex");
            
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
//=================================================================================
//   set properties
//=================================================================================
      
      private var mLastGlobalVariableSpaceModifiedTimes:int = 0;
      private var mLastEntityVariableSpaceModifiedTimes:int = 0;
      
      public function StartSettingEntityProperties ():void
      {
         mLastGlobalVariableSpaceModifiedTimes = mEditorWorld.GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes ();
         mLastEntityVariableSpaceModifiedTimes = mEditorWorld.GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes ();
      }
      
      public function CancelSettingEntityProperties ():void
      {
         var globalVariableSpaceModified:Boolean = mEditorWorld.GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes () > mLastGlobalVariableSpaceModifiedTimes;
         var entityVariableSpaceModified:Boolean = mEditorWorld.GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes () > mLastEntityVariableSpaceModifiedTimes;
         
         if (globalVariableSpaceModified && entityVariableSpaceModified)
         {
            CreateUndoPoint ("Global variables and custom entity proeprties are changed", null, null);
         }
         else if (globalVariableSpaceModified)
         {
            CreateUndoPoint ("Global variables are changed", null, null);
         }
         else if (entityVariableSpaceModified)
         {
            CreateUndoPoint ("Custom entity proeprties are changed", null, null);
         }
      }
      
      public function ConfirmSettingEntityProperties (params:Object):void
      {
         //var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         //if (selectedEntities == null || selectedEntities.length != 1)
         //   return;
         if (mMainSelectedEntity == null)
            return;
         
         //var entity:Entity = selectedEntities [0] as Entity;
         var entity:Entity = mMainSelectedEntity;
         
         var newPosX:Number = mEditorWorld.GetCoordinateSystem ().P2D_PositionX (params.mPosX);
         var newPosY:Number = mEditorWorld.GetCoordinateSystem ().P2D_PositionY (params.mPosY);
         if (! mEditorWorld.IsInfiniteSceneSize ())
         {
            //todo: seems this is not essential
            newPosX = MathUtil.GetClipValue (newPosX, mEditorWorld.GetWorldLeft () - Define.WorldFieldMargin, mEditorWorld.GetWorldRight () + Define.WorldFieldMargin);
            newPosY = MathUtil.GetClipValue (newPosY, mEditorWorld.GetWorldTop () - Define.WorldFieldMargin, mEditorWorld.GetWorldBottom () + Define.WorldFieldMargin);
         }
         
         entity.SetPosition (newPosX, newPosY);
         entity.SetRotation (mEditorWorld.GetCoordinateSystem ().P2D_RotationRadians (params.mAngle * Define.kDegrees2Radians));
         entity.SetVisible (params.mIsVisible);
         entity.SetAlpha (params.mAlpha);
         entity.SetEnabled (params.mIsEnabled);
         
         if (entity is EntityLogic)
         {
            var logic:EntityLogic = entity as EntityLogic;
            
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
                  
                  if (entity is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timer_event_handler_withPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
                     
                     var pre_code_snippet:CodeSnippet = timer_event_handler_withPrePostHandling.GetPreCodeSnippet ();
                     pre_code_snippet.AssignFunctionCallings (params.mReturnPreFunctionCallings);
                     pre_code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
                     
                     var post_code_snippet:CodeSnippet = timer_event_handler_withPrePostHandling.GetPostCodeSnippet ();
                     post_code_snippet.AssignFunctionCallings (params.mReturnPostFunctionCallings);
                     post_code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
                  }
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
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               
               condition.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = condition.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               
               action.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = action.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
            }
            else if (entity is EntityInputEntityScriptFilter)
            {
               var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
               
               entityFilter.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = entityFilter.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
            }
            else if (entity is EntityInputEntityPairScriptFilter)
            {
               var pairFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
               
               pairFilter.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = pairFilter.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mEditorWorld.GetCoordinateSystem ());
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
            
            logic.UpdateAppearance ();
            logic.UpdateSelectionProxy ();
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
               shape.SetHollow (params.mIsHollow);
               shape.SetBuildBorder (params.mBuildBorder);
               shape.SetDensity (params.mDensity);
               shape.SetFriction (params.mFriction);
               shape.SetRestitution (params.mRestitution);
               
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
                  
                  (shape as EntityShapeText).SetWordWrap (params.mWordWrap);
                  (shape as EntityShapeText).SetAdaptiveBackgroundSize (params.mAdaptiveBackgroundSize);
                  
                  (shape as EntityShapeText).SetUnderlined (params.mIsUnderlined);
                  (shape as EntityShapeText).SetTextAlign (params.mTextAlign);
                  
                  (shape as EntityShapeText).SetText (params.mText);
                  (shape as EntityShapeText).SetTextColor (params.mTextColor);
                  (shape as EntityShapeText).SetFontSize (params.mFontSize);
                  (shape as EntityShapeText).SetBold (params.mIsBold);
                  (shape as EntityShapeText).SetItalic (params.mIsItalic);
                  
                  (shape as EntityShapeRectangle).SetHalfWidth (0.5 * mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mWidth));
                  (shape as EntityShapeRectangle).SetHalfHeight (0.5 * mEditorWorld.GetCoordinateSystem ().P2D_Length (params.mHeight));
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
               
               // 
               weld.GetAnchor ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               // 
               dummy.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               dummy.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
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
            else if (entity is EntityUtilityPowerSource)
            {
               var powerSource:EntityUtilityPowerSource = entity as EntityUtilityPowerSource;
               
               powerSource.SetKeyboardEventId (params.mEventId);
               powerSource.SetKeyCodes (params.mKeyCodes);
               
               switch (powerSource.GetPowerSourceType ())
               {
                  case Define.PowerSource_Torque:
                     params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_Torque (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_LinearImpusle:
                     params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_ImpulseMagnitude (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularImpulse:
                     params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_AngularImpulse (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_AngularAcceleration (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularVelocity:
                     params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_AngularVelocity (params.mPowerMagnitude);
                     break;
                  //case Define.PowerSource_LinearAcceleration:
                  //   params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mPowerMagnitude);
                  //   break;
                  //case Define.PowerSource_LinearVelocity:
                  //   params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mPowerMagnitude);
                  //   break;
                  case Define.PowerSource_Force:
                  default:
                     params.mPowerMagnitude = mEditorWorld.GetCoordinateSystem ().P2D_ForceMagnitude (params.mPowerMagnitude);
                     break;
               }
               powerSource.SetPowerMagnitude (params.mPowerMagnitude);
            }
            
            utility.UpdateAppearance ();
            utility.UpdateSelectionProxy ();
         }
         
         if (entity != null)
         {
            CreateUndoPoint ("The properties of entity [" + entity.GetTypeName ().toLowerCase () + "] are changed", null, entity);
            
            UpdateSelectedEntityInfo ();
            CalSelectedEntitiesCenterPoint ();
         }
      }
      
      public function OnBatchModifyEntityCommonProperties (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         var entity:Entity;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            entity = selectedEntities [i];
            
            if (entity != null)
            {
               if (params.mToModifyAngle)
                  entity.SetRotation (mEditorWorld.GetCoordinateSystem ().P2D_RotationRadians (params.mAngle * Define.kDegrees2Radians));
               if (params.mToModifyAlpha)
                  entity.SetAlpha (params.mAlpha);
               if (params.mToModifyVisible)
                  entity.SetVisible (params.mIsVisible);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify common proeprties for " + selectedEntities.length + " entities", null, null);
      }
      
      public function OnBatchModifyShapePhysicsFlags (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         var shape:EntityShape;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            shape = selectedEntities [i] as EntityShape;
            
            if (shape != null)
            {
               if (params.mToModifyEnablePhysics)
                  shape.SetPhysicsEnabled (params.mIsPhysicsEnabled);
               if (params.mToModifyStatic)
                  shape.SetStatic (params.mIsStatic);
               if (params.mToModifyBullet)
                  shape.SetAsBullet (params.mIsBullet);
               if (params.mToModifySensor)
                  shape.SetAsSensor (params.mIsSensor);
               if (params.mToModifyHollow)
                  shape.SetHollow (params.mIsHollow);
               if (params.mToModifyBuildBorder)
                  shape.SetBuildBorder (params.mBuildBorder);
               if (params.mToModifAllowSleeping)
                  shape.SetAllowSleeping (params.mAllowSleeping);
               if (params.mToModifyFixRotation)
                  shape.SetFixRotation (params.mFixRotation);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify physics proeprties for " + selectedEntities.length + " shapes", null, null);
      }
      
      public function OnBatchModifyShapePhysicsCollisionCategory (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         var shape:EntityShape;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            shape = selectedEntities [i] as EntityShape;
            
            if (shape != null)
            {
               shape.SetCollisionCategoryIndex (params.mCollisionCategoryIndex);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify collision category for " + selectedEntities.length + " shapes", null, null);
      }
      
      public function OnBatchModifyShapePhysicsVelocity (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         var shape:EntityShape;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            shape = selectedEntities [i] as EntityShape;
            
            if (shape != null)
            {
               if (params.mToModifyLinearVelocityMagnitude)
                  shape.SetLinearVelocityMagnitude (mEditorWorld.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mLinearVelocityMagnitude));
               if (params.mToModifyLinearVelocityAngle)
                  shape.SetLinearVelocityAngle (mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (params.mLinearVelocityAngle));
               if (params.mToModifyAngularVelocity)
                  shape.SetAngularVelocity (mEditorWorld.GetCoordinateSystem ().P2D_AngularVelocity (params.mAngularVelocity));
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify physics velocities for " + selectedEntities.length + " shapes", null, null);
      }
      
      public function OnBatchModifyShapePhysicsFixture (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         var shape:EntityShape;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            shape = selectedEntities [i] as EntityShape;
            
            if (shape != null)
            {
               if (params.mToModifyDensity)
                  shape.SetDensity (params.mDensity);
               if (params.mToModifyFriction)
                  shape.SetFriction (params.mFriction);
               if (params.mToModifyRestitution)
                  shape.SetRestitution (params.mRestitution);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify physics material proeprties for " + selectedEntities.length + " shapes", null, null);
      }
      
      public function OnBatchModifyJointCollideConnectedsProperty (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         var joint:EntityJoint;
         var anchor:SubEntityJointAnchor;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            anchor = selectedEntities [i] as SubEntityJointAnchor;
            
            if (anchor != null)
            {
               joint = anchor.GetMainEntity () as EntityJoint;
               
               if (joint != null)
               {
                  joint.mCollideConnected = params.mCollideConnected;
               }
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify collid-connected proeprty for " + selectedEntities.length + " joints", null, null);
      }
      
//=================================================================================
//   world settings
//=================================================================================
      
      public function GetCurrentWorldDesignInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mShareSoureCode = mEditorWorld.IsShareSourceCode ();
         info.mPermitPublishing = mEditorWorld.IsPermitPublishing ();
         info.mAuthorName = mEditorWorld.GetAuthorName ();
         info.mAuthorHomepage = mEditorWorld.GetAuthorHomepage ();
         
         return info;
      }
      
      public function SetCurrentWorldDesignInfo (info:Object):void
      {
         mEditorWorld.SetShareSourceCode (info.mShareSoureCode);
         mEditorWorld.SetPermitPublishing (info.mPermitPublishing);
         mEditorWorld.SetAuthorName (info.mAuthorName);
         mEditorWorld.SetAuthorHomepage (info.mAuthorHomepage);
         
         CreateUndoPoint ("Author info is modified");
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
         
         CreateUndoPoint ("Coordinate system is modified");
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
         
         CreateUndoPoint ("World rules are changed");
      }
      
      public function GetCurrentWorldPhysicsyInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mDefaultGravityAccelerationMagnitude = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (mEditorWorld.GetDefaultGravityAccelerationMagnitude ()), 6);
         info.mDefaultGravityAccelerationAngle = ValueAdjuster.Number2Precision (mEditorWorld.GetCoordinateSystem ().D2P_RotationDegrees (mEditorWorld.GetDefaultGravityAccelerationAngle ()), 6);
         info.mAutoSleepingEnabled = mEditorWorld.IsAutoSleepingEnabled ();
         
         return info;
      }
      
      public function SetCurrentWorldPhysicsInfo (info:Object):void
      {
         mEditorWorld.SetDefaultGravityAccelerationMagnitude (mEditorWorld.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (info.mDefaultGravityAccelerationMagnitude));
         mEditorWorld.SetDefaultGravityAccelerationAngle (mEditorWorld.GetCoordinateSystem ().P2D_RotationDegrees (info.mDefaultGravityAccelerationAngle));
         mEditorWorld.SetAutoSleepingEnabled (info.mAutoSleepingEnabled);
         
         CreateUndoPoint ("Default gravity is changed");
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
         
         info.mViewportWidth = mEditorWorld.GetViewportWidth ();
         info.mViewportHeight = mEditorWorld.GetViewportHeight ();
         
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
         
         CreateUndoPoint ("World appearance is changed");
      }
      
      public function GetViewportInfo ():Object
      {
         var info:Object = new Object ();
         
         info.mViewerUiFlags = mEditorWorld.GetViewerUiFlags ();
         info.mPlayBarColor = mEditorWorld.GetPlayBarColor ();
         
         info.mViewportWidth = mEditorWorld.GetViewportWidth ();
         info.mViewportHeight = mEditorWorld.GetViewportHeight ();
         
         info.mCameraRotatingEnabled = mEditorWorld.IsCameraRotatingEnabled ();
         
         return info;
      }
      
      public function SetViewportInfo (info:Object):void
      {
         mEditorWorld.SetViewerUiFlags (info.mViewerUiFlags);
         mEditorWorld.SetPlayBarColor (info.mPlayBarColor);
         
         mEditorWorld.SetViewportWidth (info.mViewportWidth);
         mEditorWorld.SetViewportHeight (info.mViewportHeight);
         
         mEditorWorld.SetCameraRotatingEnabled (info.mCameraRotatingEnabled);
         
         mEditorWorld.ValidateViewportSize ();
         
         CreateUndoPoint ("World appearance is changed");
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
      
      public function GoToEntity (entityIds:Array):void
      {
         var first:Boolean = true;
         
         for each (var entityId:int in entityIds)
         {
            if (entityId < 0 || entityId >= mEditorWorld.GetNumEntities ())
               continue;
            
            var entity:Entity = mEditorWorld.GetEntityByCreationId (entityId);
            
            var posX:Number = entity.GetPositionX ();
            var posY:Number = entity.GetPositionY ();
            
            var viewPoint:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, this, new Point (posX, posY) );
            if (viewPoint.x >= 0 && viewPoint.x < mViewWidth)
               posX = mViewCenterWorldX;
            if (viewPoint.y>= 0 && viewPoint.y < mViewHeight)
               posY = mViewCenterWorldY;
            
            var dx:Number = mViewCenterWorldX - posX;
            var dy:Number = mViewCenterWorldY - posY;
            
            if (first)
            {
               first = false;
               
               if (dx != 0 || dy != 0)
               {
                  MoveWorldScene (dx, dy);
               }
            }
            
            // aiming effect
            mEditingEffectLayer.addChild (new EffectCrossingAiming (entity));
         }
      }
      
      public function SelectEntityByIds (entityIds:Array, clearOldSelecteds:Boolean = true, selectBoothers:Boolean = false):void
      {
         var entites:Array = new Array ();
         
         for each (var entityId:int in entityIds)
         {
            if (entityId < 0 || entityId >= mEditorWorld.GetNumEntities ())
               continue;
            
            var entity:Entity = mEditorWorld.GetEntityByCreationId (entityId);
            
            var posX:Number = entity.GetPositionX ();
            var posY:Number = entity.GetPositionY ();
            
            var viewPoint:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, this, new Point (posX, posY) );
            if (viewPoint.x >= 0 && viewPoint.x < mViewWidth)
               posX = mViewCenterWorldX;
            if (viewPoint.y>= 0 && viewPoint.y < mViewHeight)
               posY = mViewCenterWorldY;
            
            var dx:Number = mViewCenterWorldX - posX;
            var dy:Number = mViewCenterWorldY - posY;
            
            // aiming effect
            mEditingEffectLayer.addChild (new EffectCrossingAiming (entity));
            
            //
            if (entity is EntityJoint)
            {
               var subEntities:Array = (entity as EntityJoint).GetSubEntities ();
               for each (var subEntity:Entity in subEntities)
               {
                  entites.push (subEntity);
               }
            }
            else
            {
               entites.push (entity);
            }
         }
         
         SelectedEntities (entites, clearOldSelecteds, selectBoothers);
      }
      
//=================================================================================
//   offline load (xml)
//=================================================================================
      
      public function LoadEditorWorldFromXmlString (params:Object):void
      {
         var newWorld:editor.world.World = null;
         
         DestroyEditorWorld ();
         
         try
         {
            var codeString:String = params.mXmlString;
            
            var newWorldDefine:WorldDefine = null;
            
            if (codeString != null)
            {
               const Text_PlayCode:String = "playcode";
               if (codeString.length > Text_PlayCode.length && codeString.substring (0, Text_PlayCode.length) == Text_PlayCode)
               {
                  var Text_OldCodeStarting:String = "434F494E";
                  var offset:int = codeString.indexOf (Text_OldCodeStarting, Text_PlayCode.length);
                  if (offset > 0) // old playcode
                  {
                     newWorldDefine = DataFormat2.HexString2WorldDefine (codeString.substring (offset));
                  }
                  else // new base64 playcode
                  {
                     offset = Text_PlayCode.length;
                     var Text_CompressFormat:String = "compressformat=base64";
                     offset = codeString.indexOf (Text_CompressFormat, offset);
                     if (offset > 0)
                     {
                        offset += Text_CompressFormat.length;
                        var Text_PlayCode2:String = "playcode=";
                        offset = codeString.indexOf (Text_PlayCode2, offset);
                        if (offset > 0)
                        {
                           offset += Text_PlayCode2.length;
                           var offset2:int = codeString.indexOf ("@}", offset);
                           if (offset2 > 0)
                           {
                              newWorldDefine = DataFormat2.PlayCode2WorldDefine_Base64 (codeString.substring (offset, offset2));
                           }
                        }
                     }
                  }
               }
               else
               {
                  var xml:XML = new XML (codeString);
                  
                  newWorldDefine = DataFormat.Xml2WorldDefine (xml);
               }
            }
            
            if (newWorldDefine == null)
               throw new Error ("newWorldDefine == null !!!");
            
            newWorld = DataFormat.WorldDefine2EditorWorld (newWorldDefine);
            
            SetEditorWorld (newWorld);
            
            //mWorldHistoryManager.ClearHistories ();
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Offline loading succeeded", EffectMessagePopup.kBgColor_OK));
            
            CreateUndoPoint ("Offline loading");
         }
         catch (error:Error)
         {
            if (Compile::Is_Debugging)
               throw error;
            
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
            
            //SetEditorWorld (new editor.world.World ());
            
            //Alert.show("Sorry, loading error!", "Error");
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Offline loading failed", EffectMessagePopup.kBgColor_Error));
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
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Export succeeded", EffectMessagePopup.kBgColor_OK));
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, export  error!", "Error");
            
            if (Compile::Is_Debugging)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Export failed", EffectMessagePopup.kBgColor_Error));
         }
         //finally // comment off for bug of secureSWF 
         {
            if (newWorld != null)
               newWorld.Destroy ();
         }
      }
      
      public function ImportFunctionsFromXmlString (params:Object):void
      {
         ImportFromXmlString (params, false, true);
      }
      
      public function ImportAllFromXmlString (params:Object):void
      {
         ImportFromXmlString (params, true, true);
      }
      
      public function ImportFromXmlString (params:Object, importEntities:Boolean, importFunctions:Boolean):void
      {
         var xmlString:String = params.mXmlString;
         
         var xml:XML = new XML (xmlString);
         
         try
         {
            var oldEntitiesCount:int = mEditorWorld.GetNumEntities ();
            var oldCategoriesCount:int = mEditorWorld.GetCollisionManager ().GetNumCollisionCategories ();
            
            var worldDefine:WorldDefine = DataFormat.Xml2WorldDefine (xml);
            
            if (oldEntitiesCount + worldDefine.mEntityDefines.length > Define.MaxEntitiesCount)
               return;
            
            if (oldCategoriesCount + worldDefine.mCollisionCategoryDefines.length > Define.MaxCCatsCount)
               return;
            
            DataFormat.WorldDefine2EditorWorld (worldDefine, true, mEditorWorld);
            
            if (mEditorWorld.GetFunctionManager ().IsChanged ())
            {
               mEditorWorld.GetFunctionManager ().UpdateFunctionMenu ();
               mEditorWorld.GetFunctionManager ().SetChanged (false)
            }
            
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
            
            UpdateUiButtonsEnabledStatus ();
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Import succeeded", EffectMessagePopup.kBgColor_OK));
            
            CreateUndoPoint ("Import");
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, import error!", "Error");
            
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Import failed", EffectMessagePopup.kBgColor_Error));
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
//============================================================================
// undo / redo 
//============================================================================
      
      public function CreateUndoPoint (description:String, editActions:Array = null, targetEntity:Entity = null, tryCreateDelayedUndoPoints:Boolean = true):void
      {
         if (mEditorWorld == null)
            return;
         
         if (tryCreateDelayedUndoPoints)
         {
            TryCreateDelayedUndoPoint ();
         }
         
         var worldState:WorldState = new WorldState (description, editActions);
         
         var object:Object = new Object ();
         worldState.mUserData = object;
         
         object.mWorldDefine = DataFormat.EditorWorld2WorldDefine (mEditorWorld);
         
         var entityArray:Array = mEditorWorld.GetSelectedEntities ();
         
         object.mSelectedEntityCreationIds = new Array (entityArray.length);
         object.mMainSelectedEntityId = -1;
         object.mSelectedVertexControllerId = -1;
         object.mViewCenterWorldX = mViewCenterWorldX;
         object.mViewCenterWorldY = mViewCenterWorldY;
         //object.mEditorWorldZoomScale = mEditorWorldZoomScale;
         
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
         
         var msgX:Number;
         var msgY:Number;
         
         if (targetEntity == null)
         {
            msgX =  mViewWidth * 0.5;
            msgY = mViewHeight * 0.5;
         }
         else
         {
            var viewPoint:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, mFloatingMessageLayer, new Point (targetEntity.GetLinkPointX (), targetEntity.GetLinkPointY ()));
            
            msgX = viewPoint.x;
            msgY = viewPoint.y;
         }
         
         mFloatingMessageLayer.addChild (new EffectMessagePopup ("Undo point created (" + description + ")", EffectMessagePopup.kBgColor_General));
      }
      
      private function RestoreWorld (worldState:WorldState):void
      {
         if (worldState == null)
         {
            OnCloseClearAllAndResetSceneAlert (null);
            return;
         }
         
         SetLastSelectedEntities (null);
         mLastSelectedEntities = null;
         
         var object:Object = worldState.mUserData;
         
         var currentWorld:Number = mEditorWorldZoomScale;
         
         var newEditorWorld:editor.world.World = DataFormat.WorldDefine2EditorWorld (object.mWorldDefine, false);
         SetEditorWorld (newEditorWorld);
         
         mViewCenterWorldX = object.mViewCenterWorldX;
         mViewCenterWorldY = object.mViewCenterWorldY;
         
         //mEditorWorldZoomScale = object.mEditorWorldZoomScale;
         mEditorWorldZoomScale = currentWorld;
         mEditorWorld.SetZoomScale (mEditorWorldZoomScale);
         
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
                  //entity.SetInternalComponentsVisible (true);
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
         
         TryCreateDelayedUndoPoint ();
         
         var worldState:WorldState = mWorldHistoryManager.UndoHistory ();
         
         if (worldState == null)
         {
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("No undo points available", EffectMessagePopup.kBgColor_General));
            return;
         }
         
         RestoreWorld (worldState);
         
         worldState = worldState.GetNextWorldState ();
         if (worldState != null) // should not
         {
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Undo (" + worldState.GetDescription () + ")", EffectMessagePopup.kBgColor_OK));
         }
      }
      
      public function Redo ():void
      {
         if (mEditorWorld == null)
            return;
         
         var worldState:WorldState = mWorldHistoryManager.RedoHistory ();
         
         if (worldState == null)
         {
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("No redo points available", EffectMessagePopup.kBgColor_General));
            return;
         }
         
         RestoreWorld (worldState);
         
         mFloatingMessageLayer.addChild (new EffectMessagePopup ("Redo (" + worldState.GetDescription () + ")", EffectMessagePopup.kBgColor_OK));
      }
      
      public var mUndoButtonContextMenu:ContextMenu = new ContextMenu ();
      public var mRedoButtonContextMenu:ContextMenu = new ContextMenu ();
      
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
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick save", EffectMessagePopup.kBgColor_OK));
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, quick saving error! " + error, "Error");
            
            if (Compile::Is_Debugging)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick save failed", EffectMessagePopup.kBgColor_Error));
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
            
            //mWorldHistoryManager.ClearHistories ();
            
            SetEditorWorld (newEditorWorld);
            
            CreateUndoPoint ("Quick save data is loaed");
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick load succeeded", EffectMessagePopup.kBgColor_OK));
         }
         catch (error:Error)
         {
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());

            if (Compile::Is_Debugging)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Quick load failed", EffectMessagePopup.kBgColor_Error));
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
         //designDataRevisionComment.writeMultiByte (revisionComment, "utf-8"); // has bug on linux
         designDataRevisionComment.writeUTFBytes (revisionComment);
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
         
         designDataAll.writeInt (Version.VersionNumber);
         
         //>> from v1.07 (in fact, the code added in v0110 r003)
         var shareSourceCode:Boolean = mEditorWorld.IsShareSourceCode ();
         designDataAll.writeShort (mEditorWorld.GetViewportWidth ()); // view width
         designDataAll.writeShort (mEditorWorld.GetViewportHeight ()); // view height
         designDataAll.writeByte  ((mEditorWorld.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0 ? 1 : 0); // show play bar?
         designDataAll.writeByte  (shareSourceCode ? 1 : 0); // share source code?
         //<<
         
         designDataAll.writeByte (isImportant ? 1 : 0);
         
         designDataAll.writeInt (designDataRevisionComment.length);
         designDataAll.writeInt (designDataForEditing.length);
         designDataAll.writeInt (shareSourceCode ? 0 : designDataForPlaying.length);
         
         designDataAll.writeBytes (designDataRevisionComment);
         designDataAll.writeBytes (designDataForEditing);
         if (! shareSourceCode)
         {
            designDataAll.writeBytes (designDataForPlaying);
         }
         
//infoString =  designDataForEditing[0] + ", " + designDataForEditing[1] + ", " + designDataForEditing[2]
//      + ", ..., " + designDataForEditing [designDataForEditing.length - 3]
//           + ", " + designDataForEditing [designDataForEditing.length - 2]
//           + ", " + designDataForEditing [designDataForEditing.length - 1];
//      + "  |||  " + designDataForPlaying[0] + ", " + designDataForPlaying[1] + ", " + designDataForPlaying[2]
//      + ", ..., " + designDataForPlaying [designDataForPlaying.length - 3]
//           + ", " + designDataForPlaying [designDataForPlaying.length - 2]
//           + ", " + designDataForPlaying [designDataForPlaying.length - 1];
         
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
      
// to debug a bug. seems there is a bug in ByteArray.compress () on linux
//private var infoString:String = "";
      
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
            {
               mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online save succeeded", EffectMessagePopup.kBgColor_OK));
            }
            else
            {
               //Alert.show("Some errors in saving! returnCode = " + returnCode + ", returnMessage = " + returnMessage, "Error");
               var errorMessage:String = "Online save failed,  returnCode = " + returnCode + ",  returnMessage = " + returnMessage;
               mFloatingMessageLayer.addChild (new EffectMessagePopup (errorMessage, EffectMessagePopup.kBgColor_Error));
            }
         }
         catch (error:Error)
         {
            //Alert.show("Sorry, online saving error! " + loader.data + " " + error, "Error");
            
            RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
            
            if (Compile::Is_Debugging)
               throw error;
            
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online save error", EffectMessagePopup.kBgColor_Error));
         }
      }
      
      // return: online or not
      public function OnlineLoad (isFirstTime:Boolean = false):Boolean
      {
         var params:Object = GetFlashParams ();
         
         //trace ("params.mRootUrl = " + params.mRootUrl)
         //trace ("params.mSlotID = " + params.mSlotID)
         
         if (params.mRootUrl == null || params.mAction == null || params.mAuthorName == null || params.mSlotID == null || params.mRevisionID == null)
            return false;
         
         if (isFirstTime && params.mAction == "create")
            return true;
         
         var designLoadUrl:String = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/revision/" + params.mRevisionID + "/loadsc";
         var request:URLRequest = new URLRequest (designLoadUrl);
         request.method = URLRequestMethod.GET;
         
         //trace ("designLoadUrl = " + designLoadUrl);
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener(Event.COMPLETE, OnOnlineLoadCompleted);
         
         loader.load ( request );
         
         return true;
      }
      
      private function OnOnlineLoadCompleted(event:Event):void 
      {
         var loader:URLLoader = URLLoader(event.target);
         
         var returnCode:int = k_ReturnCode_UnknowError;
         
         var data:ByteArray = ByteArray (loader.data);
         
         returnCode = data.readByte ();
         
         if (returnCode != k_ReturnCode_Successed)
         {
            //Alert.show("Some errors in loading! returnCode = " + returnCode, "Error");
            mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online load error,  returnCode = " + returnCode, EffectMessagePopup.kBgColor_Error));
         }
         else
         {
            DestroyEditorWorld ();
            
            try
            {
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
               
               //mWorldHistoryManager.ClearHistories ();
               
               SetEditorWorld (newEditorWorld);
               
               CreateUndoPoint ("Online data is loaded");
               
               //Alert.show("Loading Succeeded!", "Succeeded");
               mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online load succeeded", EffectMessagePopup.kBgColor_OK));
            }
            catch (error:Error)
            {
               RestoreWorld (mWorldHistoryManager.GetCurrentWorldState ());
               
               if (Compile::Is_Debugging)
                  throw error;
               
               //Alert.show("Sorry, online loading error!", "Error");
               
               mFloatingMessageLayer.addChild (new EffectMessagePopup ("Online load error", EffectMessagePopup.kBgColor_Error));
            }
         }
      }
      
      
      
   }
}
