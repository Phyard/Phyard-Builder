
package editor {
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
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
   
   import flash.ui.Mouse;
   import flash.system.System;
   
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
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.Alert;
   import mx.events.CloseEvent;
   //import mx.events.FlexEvent;
   
   import com.tapirgames.display.FpsCounter;
   import com.tapirgames.display.TextFieldEx;
   
   import com.tapirgames.util.TimeSpan;
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
   
   import editor.mode.ModeCreateHinge;
   import editor.mode.ModeCreateDistance;
   import editor.mode.ModeCreateSlider;
   import editor.mode.ModeCreateSpring;
   
   import editor.mode.ModeCreateText;
   import editor.mode.ModeCreateGravityController;
   
   import editor.mode.ModePlaceCreateEntitiy;
   
   import editor.mode.ModeRegionSelectEntities;
   import editor.mode.ModeMoveSelectedEntities;
   
   import editor.mode.ModeRotateSelectedEntities;
   import editor.mode.ModeScaleSelectedEntities;
   
   import editor.mode.ModeMoveSelectedVertexControllers;
   
   import editor.mode.ModeMoveWorldScene;
   
   import editor.mode.ModeCreateEntityLink;
   
   import editor.setting.EditorSetting;
   import editor.runtime.Runtime;
   
   import editor.display.CursorCrossingLine;
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapePolygon;
   import editor.entity.EntityShapePolyline;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityShapeGravityController;
   import editor.entity.EntityUtilityCamera;
   
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   
   import editor.entity.SubEntityJointAnchor;
   import editor.entity.SubEntityHingeAnchor;
   import editor.entity.SubEntitySliderAnchor;
   import editor.entity.SubEntityDistanceAnchor;
   import editor.entity.SubEntitySpringAnchor;
   
   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityAction;
   import editor.trigger.entity.EntityEventHandler;
   //import editor.trigger.entity.EntityTrigger;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   
   import editor.entity.VertexController;
   
   import editor.trigger.entity.InputEntitySelector;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.trigger.CommandListDefinition;
   import editor.trigger.ConditionListDefinition;
   
   import editor.world.World;
   import editor.world.CollisionManager;
   import editor.undo.WorldHistoryManager;
   import editor.undo.WorldState;
   
   import editor.trigger.entity.Linkable;
   
   import player.world.World;
   import player.ui.PlayHelpDialog;
   import player.ui.PlayControlBar;
   
   import common.WorldDefine;
   import common.DataFormat;
   import common.DataFormat2;
   import common.Define;   
   import common.Config;
   import common.ValueAdjuster;
   
   import common.trigger.CoreEventIds;
   
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
         
      private var mUiContainer:Sprite;
         
         private var mUiTopBar:Shape = null;
         private var mUiBottomBar:Shape = null;
         private var mPlayControlBar:PlayControlBar = null;
         private var mHelpDialog:Sprite = null;
         private var mSelectedEntityInfoText:TextFieldEx = null;
         
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
      
      private var mPlayerWorld:player.world.World = null;
         
         private var mPlayerWorldZoomScale:Number = 1.0;
         private var mPlayerWorldZoomScaleChangedSpeed:Number = 0.0;
      
      //private var mWorldPlayingSpeedX:int = 2;
      
      private var mOuterWorldHexString:String;
      
      //
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
      
      private var mFpsCounter:FpsCounter = null;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      public var mActive:Boolean = true;
      
      private function OnEnterFrame (event:Event):void 
      {
         //
         if (mFpsCounter == null)
         {
            mFpsCounter = new FpsCounter ();
            mFpsCounter.x = 20;
            mFpsCounter.y = 30;
            mTopLayerContainer.addChild (mFpsCounter);
         }
         
         mFpsCounter.Update (mStepTimeSpan.GetLastSpan ());
         
         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if ( ! Runtime.HasSettingDialogOpened () && mActive)
            stage.focus = stage;
         
         var newScale:Number;
         
         if ( IsPlaying () )
         {
            if (mPlayerWorld != null)
            {
               if (mPlayerWorld.GetZoomScale () != mPlayerWorldZoomScale)
               {
                  if (mPlayerWorld.GetZoomScale () < mPlayerWorldZoomScale)
                  {
                     if (mPlayerWorldZoomScaleChangedSpeed < 0)
                        mPlayerWorldZoomScaleChangedSpeed = - mPlayerWorldZoomScaleChangedSpeed;
                     
                     newScale = mPlayerWorld.scaleX + mPlayerWorldZoomScaleChangedSpeed;
                     
                     if (newScale >= mPlayerWorldZoomScale)
                        mPlayerWorld.SetZoomScale (mPlayerWorldZoomScale);
                     else
                        mPlayerWorld.SetZoomScale (newScale);
                  }
                  else
                  {
                     if (mPlayerWorldZoomScaleChangedSpeed > 0)
                        mPlayerWorldZoomScaleChangedSpeed = - mPlayerWorldZoomScaleChangedSpeed;
                     
                     newScale = mPlayerWorld.scaleX + mPlayerWorldZoomScaleChangedSpeed;
                     
                     if (newScale <= mPlayerWorldZoomScale)
                        mPlayerWorld.SetZoomScale (mPlayerWorldZoomScale);
                     else
                        mPlayerWorld.SetZoomScale (newScale);
                  }
               }
               
               if ( ! IsPlayingPaused () && ! mHelpDialog.visible )
                  mPlayerWorld.Update (mStepTimeSpan.GetLastSpan (), GetPlayingSpeedX ());
            }
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
         UpdateViewInterface ();
         UpdateSelectedEntityInfo ();
         
         if (mPlayerWorld != null)
         {
            mPlayerWorld.SetCameraWidth (mViewWidth);
            mPlayerWorld.SetCameraHeight (mViewHeight);
         }
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
         
         var sceneLeft  :int = mEditorWorld.GetWorldLeft ();
         var sceneTop   :int = mEditorWorld.GetWorldTop ();
         var sceneWidth :int = mEditorWorld.GetWorldWidth ();
         var sceneHeight:int = mEditorWorld.GetWorldHeight ();
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
         
         mEditorWorld.x = worldOriginViewX;
         mEditorWorld.y = worldOriginViewY;
         
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
            var borderThinknessLR:Number = WorldBorderThinknessLR * mEditorWorld.scaleX;
            var borderThinknessTB:Number = WorldBorderThinknessTB * mEditorWorld.scaleY;
            
            mEditorBackgroundSprite.graphics.beginFill(borderColor);
            mEditorBackgroundSprite.graphics.drawRect (worldViewLeft, worldViewTop, borderThinknessLR, worldViewHeight);
            mEditorBackgroundSprite.graphics.drawRect (worldViewRight - borderThinknessLR, worldViewTop, borderThinknessLR, worldViewHeight);
            mEditorBackgroundSprite.graphics.endFill ();
            
            mEditorBackgroundSprite.graphics.beginFill(borderColor);
            mEditorBackgroundSprite.graphics.drawRect (worldViewLeft, worldViewTop, worldViewWidth, borderThinknessTB);
            mEditorBackgroundSprite.graphics.drawRect (worldViewLeft, worldViewBottom - borderThinknessTB, worldViewWidth, borderThinknessTB);
            mEditorBackgroundSprite.graphics.endFill ();
         }
      }
      
      public function UpdateViewInterface ():void
      {
         if (mUiContainer == null)
         {
            mUiContainer = new Sprite ();
            addChild (mUiContainer);
            
            mUiTopBar = new Shape ();
            mUiContainer.addChild (mUiTopBar);
            
            mUiBottomBar = new Shape ();
            mUiContainer.addChild (mUiBottomBar);
            
            mPlayControlBar = new PlayControlBar (_OnRestartPlaying, _OnStartPlaying, _OnPausePlaying, _OnStopPlaying, _OnSetPlayingSpeed, _OnOpenPlayHelpDialog, null, _OnZoomWorld);
            mUiContainer.addChild (mPlayControlBar);
            
            mHelpDialog = new PlayHelpDialog (_OnClosePlayHelpDialog);
            mUiContainer.addChild (mHelpDialog);
            mHelpDialog.visible = false;
         }
         
         mUiTopBar.graphics.clear ();
         mUiTopBar.graphics.beginFill(0x606060);
         mUiTopBar.graphics.drawRect (0, 0, mViewWidth, WorldBorderThinknessTB);
         mUiTopBar.graphics.endFill ();
         
         mUiBottomBar.graphics.clear ();
         mUiBottomBar.graphics.beginFill(0x606060);
         mUiBottomBar.graphics.drawRect (0, mViewHeight - WorldBorderThinknessTB, mViewWidth, WorldBorderThinknessTB);
         mUiBottomBar.graphics.endFill ();
         
         mPlayControlBar.x = (mViewWidth - mPlayControlBar.width) * 0.5;
         mPlayControlBar.y = 2;
      }
      
      public function UpdateSelectedEntityInfo ():void
      {
         if (mSelectedEntityInfoText == null)
         {
            mSelectedEntityInfoText = TextFieldEx.CreateTextField ("", false, 0xFFFF00, 0x0);
            
            addChild (mSelectedEntityInfoText);
         }
         
         mSelectedEntityInfoText.visible = false;
         
         // ...
         if (mLastSelectedEntity != null && ! mEditorWorld.IsEntitySelected (mLastSelectedEntity))
            mLastSelectedEntity = null;
         
         if (mLastSelectedEntity == null)
            return;
         
         mSelectedEntityInfoText.visible = true;
         
         var typeName:String = mLastSelectedEntity.GetTypeName ();
         var infoText:String = mLastSelectedEntity.GetInfoText ();
         
         mSelectedEntityInfoText.htmlText = "<font color='#FFFFFF'><b>" + mEditorWorld.getChildIndex (mLastSelectedEntity) + ": " + typeName + "</b>: " + infoText + "</font>";
         
         mSelectedEntityInfoText.x = WorldBorderThinknessLR;
         mSelectedEntityInfoText.y = mViewHeight - (WorldBorderThinknessTB + mSelectedEntityInfoText.height) * 0.5;
         
         /*
         mSelectedEntityInfoText.visible = false;
         mStatusMessageBar.text = "[" + mEditorWorld.getChildIndex (mLastSelectedEntity) + "] " + mLastSelectedEntity.GetTypeName () + ": " + mLastSelectedEntity.GetInfoText () ;
         */
      }
      
      private function UpdateSelectedEntitiesCenterSprite ():void
      {
         //var point:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, this, _SelectedEntitiesCenterPoint );
         var point:Point = DisplayObjectUtil.LocalToLocal (mEditorWorld, mForegroundSprite, _SelectedEntitiesCenterPoint );
         mSelectedEntitiesCenterSprite.x = point.x;
         mSelectedEntitiesCenterSprite.y = point.y;
      }
      
      private function SynchrinizePlayerWorldWithEditorWorld ():void
      {
         if (mPlayerWorld != null)
         {
            mPlayerWorld.x = mEditorWorld.x;
            mPlayerWorld.y = mEditorWorld.y;
            
            mPlayerWorldZoomScale = mEditorWorldZoomScale;
            mPlayerWorld.SetZoomScale (mPlayerWorldZoomScale);
            mPlayerWorld.MoveWorldScene (0, 0);
         }
         
         if (mHelpDialog != null)
         {
            mHelpDialog.x = (mViewWidth - mHelpDialog.width) * 0.5;
            mHelpDialog.y = (mViewHeight - mHelpDialog.height) * 0.5;
         }
      }
      
      public function RepaintEntityLinks ():void
      {
         mEntityLinksSprite.graphics.clear ();
         
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
      //private var mIsPlayingPaused:Boolean = false;
      
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
         //return mIsPlaying && mIsPlayingPaused;
         return mIsPlaying && ! mPlayControlBar.IsPlaying ();
      }
      
      public function GetPlayingSpeedX ():int
      {
         return mPlayControlBar.GetPlayingSpeedX ();
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
      
      public var mButtonCreateText:Button;
      public var mButtonCreateCravityController:Button;
      public var mButtonCreateBox:Button;
      public var mButtonCreateBall:Button;
      public var mButtonCreatePolygon:Button;
      public var mButtonCreatePolyline:Button;
      public var mButtonCreateCamera:Button;
      //public var mButtonCreateField:Button;
      
      public var mButton_CreateCondition:Button;
      public var mButton_CreateConditionDoor:Button;
      public var mButton_CreateTask:Button;
      public var mButton_CreateEntityAssigner:Button;
      public var mButton_CreateEntityPairAssigner:Button;
      public var mButton_CreateAction:Button;
      //public var mButton_CreateTrigger:Button;
      public var mButton_CreateEventHandler0:Button;
      public var mButton_CreateEventHandler1:Button;
      public var mButton_CreateEventHandler2:Button;
      public var mButton_CreateEventHandler3:Button;
      public var mButton_CreateEventHandler4:Button;
      public var mButton_CreateEventHandler5:Button;
      public var mButton_CreateEventHandler6:Button;
      public var mButton_CreateEventHandler7:Button;
      public var mButton_CreateEventHandler8:Button;
      //public var mButton_CreateEventHandler9:Button;
      public var mButton_CreateEventHandler10:Button;
      public var mButton_CreateEventHandler11:Button;
      public var mButton_CreateEventHandler12:Button;
      public var mButton_CreateEventHandler13:Button;
      public var mButton_CreateEventHandler14:Button;
      public var mButton_CreateEventHandler15:Button;
      public var mButton_CreateEventHandler16:Button;
      public var mButton_CreateEventHandler17:Button;
      //public var mButton_CreateEventHandler18:Button;
      //public var mButton_CreateEventHandler19:Button;
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         SetCurrentCreateMode (null);
         mLastSelectedCreateButton = (event.target as Button);
         
         switch (event.target)
         {
         // CI boxes
            
            case mButtonCreateBoxMovable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Movable, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreateBoxStatic:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Static, EditorSetting.ColorStaticObject, true ) );
               break;
            case mButtonCreateBoxBreakable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Breakable, EditorSetting.ColorBreakableObject, true ) );
               break;
            case mButtonCreateBoxInfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Infected, EditorSetting.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBoxUninfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Uninfected, EditorSetting.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBoxDontinfect:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_DontInfect, EditorSetting.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBoxBomb:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Bomb, EditorSetting.ColorBombObject, false, true, EditorSetting.MinBombSquareSideLength, EditorSetting.MaxBombSquareSideLength ) );
               break;
               
         // CI balls
            
            case mButtonCreateBallMovable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Movable, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreateBallStatic:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Static, EditorSetting.ColorStaticObject, true ) );
               break;
            case mButtonCreateBallBreakable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Breakable, EditorSetting.ColorBreakableObject, false ) );
               break;
            case mButtonCreateBallInfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Infected, EditorSetting.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBallUninfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Uninfected, EditorSetting.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBallDontInfect:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_DontInfect, EditorSetting.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBallBomb:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Bomb, EditorSetting.ColorBombObject, false, EditorSetting.MinCircleRadium, EditorSetting.MaxBombSquareSideLength * 0.5 ) );
               break;
               
         // CI polygons
            
            case mButtonCreatePolygonMovable:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Movable, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolygonStatic:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Static, EditorSetting.ColorStaticObject, true ) );
               break;
            case mButtonCreatePolygonBreakable:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Breakable, EditorSetting.ColorBreakableObject, true ) );
               break;
            case mButtonCreatePolygonInfected:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Infected, EditorSetting.ColorInfectedObject, false ) );
               break;
            case mButtonCreatePolygonUninfected:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Uninfected, EditorSetting.ColorUninfectedObject, false ) );
               break;
            case mButtonCreatePolygonDontinfect:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_DontInfect, EditorSetting.ColorDontInfectObject, false ) );
               break;
            
         // CI polylines
            
            case mButtonCreatePolylineMovable:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Movable, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolylineStatic:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Static, EditorSetting.ColorStaticObject, true ) );
               break
            case mButtonCreatePolylineBreakable:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Breakable, EditorSetting.ColorBreakableObject, true ) );
               break;
            case mButtonCreatePolylineInfected:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Infected, EditorSetting.ColorInfectedObject, true ) );
               break;
            case mButtonCreatePolylineUninfected:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Uninfected, EditorSetting.ColorUninfectedObject, true ) );
               break;
            case mButtonCreatePolylineDontinfect:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_DontInfect, EditorSetting.ColorDontInfectObject, true ) );
               break;
            
          // general box, ball, polygons, polyline
            
            case mButtonCreateBox:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, Define.ShapeAiType_Unknown, EditorSetting.ColorStaticObject, true ) );
               break;
            case mButtonCreateBall:
               SetCurrentCreateMode ( new ModeCreateCircle (this, Define.ShapeAiType_Unknown, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreatePolygon:
               SetCurrentCreateMode ( new ModeCreatePolygon (this, Define.ShapeAiType_Unknown, 0xFFFFFF, true ) );
               break;
            case mButtonCreatePolyline:
               SetCurrentCreateMode ( new ModeCreatePolyline (this, Define.ShapeAiType_Unknown, EditorSetting.ColorStaticObject, true ) );
               break;
               
         // joints
            
            case mButtonCreateJointHinge:
               SetCurrentCreateMode ( new ModeCreateHinge (this) );
               break;
            case mButtonCreateJointSlider:
               SetCurrentCreateMode ( new ModeCreateSlider (this) );
               break;
            case mButtonCreateJointDistance:
               SetCurrentCreateMode ( new ModeCreateDistance (this) );
               break;
            case mButtonCreateJointSpring:
               SetCurrentCreateMode ( new ModeCreateSpring (this) );
               break;
            
         // others
            
            case mButtonCreateText:
               SetCurrentCreateMode ( new ModeCreateText (this) );
               break;
            
            case mButtonCreateCravityController:
               SetCurrentCreateMode ( new ModeCreateGravityController (this) );
               break;
            
            case mButtonCreateCamera:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityUtilityCamera) );
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
            case mButton_CreateEntityAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityInputEntityAssigner) );
               break;
            case mButton_CreateEntityPairAssigner:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityInputEntityPairAssigner) );
               break;
            case mButton_CreateAction:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityAction) );
               break;
            //case mButton_CreateTrigger:
            //   SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityTrigger) );
            //   break;
            case mButton_CreateEventHandler0:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLevelBeginInitialize, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler1:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLevelEndInitialize, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler2:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLevelBeginUpdate, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler3:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLevelEndUpdate, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler4:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLevelFinished, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler5:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnLevelFailed, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler6:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityInitialized, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler7:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityUpdated, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler8:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnEntityDestroyed, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler10:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnSensorContainsPhysicsShape, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler11:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler12:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler13:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnTwoPhysicsShapesEndContacting, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler14:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnTimer, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler15:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointBroken, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler16:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointReachLowerLimit, mPotientialEventIds:null}) );
               break;
            case mButton_CreateEventHandler17:
               SetCurrentCreateMode (new ModePlaceCreateEntitiy (this, CreateEntityEventHandler, {mDefaultEventId:CoreEventIds.ID_OnJointReachUpperLimit, mPotientialEventIds:null}) );
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
      public var mButtonNewDesign:Button;
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
      
      //public var mButtonAuthorInfo:Button;
      public var mButtonSaveWorld:Button;
      public var mButtonLoadWorld:Button;
      
      
      
      private function UpdateUiButtonsEnabledStatus ():void
      {
      // edit
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         
         mButtonSetting.enabled = selectedEntities.length == 1 && IsEntitySettingable (selectedEntities[0]);
         
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
         
         mButtonCreateCravityController.enabled = mEditorWorld.GetGravityControllerList ().length == 0;
         mButtonCreateCamera.enabled = mEditorWorld.GetCameraList ().length == 0;
         
      // file ...
         
         mButtonNewDesign.enabled = true; //mEditorWorld.numChildren > 0;
      }
      
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
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
            case mButtonNewDesign:
               ClearAllEntities ();
               break
            case mButtonSetting:
               OpenEntitySettingDialog ();
               break;
            case mButtonMoveToTop:
               MoveSelectedEntitiesToTop ();
               break;
            case mButtonMoveToBottom:
               MoveSelectedEntitiesToBottom ();
               break;
            //case mButtonAuthorInfo:
            //   OpenWorldSettingDialog ();
            //   break;
            case mButtonSaveWorld:
               OpenWorldSavingDialog ();
               break;
            case mButtonLoadWorld:
               OpenWorldLoadingDialog ();
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
            default:
               break;
         }
      }
      
      private var mMenuItemAbout:ContextMenuItem;
      private var mMenuItemExportSelectedsToSystemMemory:ContextMenuItem;
      private var mMenuItemImport:ContextMenuItem;
      
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
         
         mMenuItemAbout = new ContextMenuItem("About This Editor", true);
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
         if (Runtime.mSynchronizeWorldSettingPanelWithWorld != null)
            Runtime.mSynchronizeWorldSettingPanelWithWorld (mEditorWorld);
         
         if (! firstTime)
         {
            //
            mLastSelectedEntity = null;
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
      
      private function SetPlayerWorld (newPlayerWorld:player.world.World):void
      {
         DestroyPlayerWorld ();
         
         mPlayerWorld = newPlayerWorld;
         
         if (mPlayerWorld == null)
            return;
         
         mPlayerElementsContainer.addChild (mPlayerWorld);
         
         mPlayerWorld.SetCameraWidth (mViewWidth);
         mPlayerWorld.SetCameraHeight (mViewHeight);
         
         SynchrinizePlayerWorldWithEditorWorld ();
         mPlayerWorld.Update (0, 1);
      }
      
      private function DestroyPlayerWorld ():void
      {
         SystemUtil.TraceMemory ("before DestroyPlayerWorld", true);
         
         if ( mPlayerWorld != null)
         {
            mPlayerWorld.Destroy ();
            
            if ( mPlayerElementsContainer.contains (mPlayerWorld) )
               mPlayerElementsContainer.removeChild (mPlayerWorld);
         }
         
         mPlayerWorld = null;
         
         SystemUtil.TraceMemory ("after DestroyPlayerWorld", true);
      }
      
      public function OnPlayRunRestart (keepPauseStatus:Boolean = false):void
      {
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         DestroyPlayerWorld ();
         
         var playerWorld:player.world.World = null;
         
         if (mOuterWorldHexString != null)
         {
            try 
            {
               playerWorld = DataFormat2.WorldDefine2PlayerWorld (DataFormat2.HexString2WorldDefine (mOuterWorldHexString));
            }
            catch (err:Error)
            {
               mOuterWorldHexString = null;
               playerWorld = null;
            }
         }
         
         if (playerWorld == null)
         {
            if (Runtime.mSynchronizeWorldWithWorldSettingPanel != null)
               Runtime.mSynchronizeWorldWithWorldSettingPanel (mEditorWorld);
            
            var wd1:WorldDefine = DataFormat.EditorWorld2WorldDefine ( mEditorWorld );
            //{
            //   var ba:ByteArray = DataFormat.WorldDefine2ByteArray ( wd1 );
            //   ba.position = 0;
            //   var wd2:WorldDefine = DataFormat2.ByteArray2WorldDefine ( ba );
            //   
            //   playerWorld = DataFormat2.WorldDefine2PlayerWorld (wd2);
            //}
            //{
               playerWorld = DataFormat2.WorldDefine2PlayerWorld (wd1);
            //}
         }
         
         SetPlayerWorld (playerWorld);
         
         mIsPlaying = true;
         //if ( ! keepPauseStatus )
         //   mIsPlayingPaused = false;
         
         mPlayerElementsContainer.visible = true;
         mEditorElementsContainer.visible = false;
         
         if (OnStartPlaying != null)
            OnStartPlaying ();
      }
      
      public function OnPlayPauseResume ():void
      {
         //mIsPlayingPaused = ! mIsPlayingPaused;
      }
      
      public function OnPlayStop ():void
      {
         mOuterWorldHexString = null;
         
         mPlayControlBar.SetZoomScale (mEditorWorldZoomScale);
         
         DestroyPlayerWorld ();
         
         mIsPlaying = false;
         
         mPlayerElementsContainer.visible = false;
         mEditorElementsContainer.visible = true;
         
         if (OnStopPlaying != null)
            OnStopPlaying ();
      }
      
      public function SetPlayingSpeed (speed:Number):void
      {
         /*
         mWorldPlayingSpeedX = Math.round (speed + speed);
         if (mWorldPlayingSpeedX < 0)
            mWorldPlayingSpeedX = 0;
         if (mWorldPlayingSpeedX > 10)
            mWorldPlayingSpeedX = 10;
         */
      }
      
//============================================================================
// callbacks for main.mxml
//============================================================================
      
      public var OnStartPlaying:Function;
      public var OnStopPlaying:Function;
      
//============================================================================
// play control var callbacks
//============================================================================
      
      private function _OnRestartPlaying (data:Object = null):void
      {
         OnPlayRunRestart ();
         //CloseHelpDialog ();
      }
      
      public function _OnStartPlaying (data:Object = null):void
      {
         if (! IsPlaying ())
            OnPlayRunRestart ();
      }
      
      public function _OnPausePlaying (data:Object = null):void
      {
      }
      
      public function _OnStopPlaying (data:Object = null):void
      {
         OnPlayStop ();
      }
      
      private function _OnSetPlayingSpeed (data:Object = null):void
      {
      }
      
      private function _OnOpenPlayHelpDialog(data:Object = null):void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = true;
         
         //OnPause (null);
      }
      
      private function _OnClosePlayHelpDialog ():void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = false;
      }
      
      private function _OnZoomWorld (data:Object = null):void
      {
         if (IsPlaying ())
         {
            if (mPlayerWorld != null)
            {
               mPlayerWorldZoomScale = mPlayControlBar.GetZoomScale ();
               mPlayerWorldZoomScaleChangedSpeed = (mPlayerWorldZoomScale - mPlayerWorld.scaleX) * 0.03;
            }
            
            //UpdateBackgroundAndWorldPosition ();
         }
         else
         {
            mEditorWorldZoomScale = mPlayControlBar.GetZoomScale ();
            mEditorWorldZoomScaleChangedSpeed = (mEditorWorldZoomScale - mEditorWorld.scaleX) * 0.03;
            
            //UpdateBackgroundAndWorldPosition ();
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
      public var ShowShapeTextSettingDialog:Function = null;
      public var ShowShapeGravityControllerSettingDialog:Function = null;
      
      public var ShowWorldSettingDialog:Function = null;
      public var ShowWorldSavingDialog:Function = null;
      public var ShowWorldLoadingDialog:Function = null;
      public var ShowImportSourceCodeDialog:Function = null;
      
      public var ShowCollisionGroupManageDialog:Function = null;
      
      public var ShowPlayCodeLoadingDialog:Function = null;
      
      public var ShowEditorCustomCommandSettingDialog:Function = null;
      
      public var ShowActionSettingDialog:Function = null;
      public var ShowEventHandlerSettingDialog:Function = null;
      public var ShowConditionSettingDialog:Function = null;
      public var ShowTriggerSettingDialog:Function = null;
      
      public function IsEntitySettingable (entity:Entity):Boolean
      {
         if (entity == null)
            return false;
         
         return entity is EntityShape || entity is SubEntityHingeAnchor || entity is SubEntitySliderAnchor
                || entity is SubEntitySpringAnchor // v1.01
                || entity is SubEntityDistanceAnchor // v1.02
                || entity is EntityAction // v1.07
                || entity is EntityEventHandler // v1.07
                //|| entity is EntityTrigger // v1.07
                || entity is EntityBasicCondition // v1.07
                ;
      }
      
      public function OpenEntitySettingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         var values:Object = new Object ();
         
         values.mPosX = entity.GetPositionX ();
         values.mPosY = entity.GetPositionY ();
         values.mAngle = entity.GetRotation () * 180.0 / Math.PI;
         
         values.mIsVisible = entity.IsVisible ();
         
         if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            values.mDrawBorder = shape.IsDrawBorder ();
            values.mDrawBackground = shape.IsDrawBackground ();
            values.mBorderColor = shape.GetBorderColor ();
            values.mBorderThickness = shape.GetBorderThickness ();
            values.mBackgroundColor =shape.GetFilledColor ();
            values.mTransparency = shape.GetTransparency ();
            values.mBorderTransparency = shape.GetBorderTransparency ();
            
            //values.mIsField = shape.IsField ();
            
            if (shape.IsBasicShapeEntity ())
            {
               values.mCollisionCategoryIndex = shape.GetCollisionCategoryIndex ();
               values.mCollisionCategoryListDataProvider =  CollisionCategoryList2SelectListDataProvider (mEditorWorld.GetCollisionCategoryList ());
               values.mCollisionCategoryListSelectedIndex = CollisionCategoryIndex2SelectListSelectedIndex (shape.GetCollisionCategoryIndex (), values.mCollisionCategoryListDataProvider);
               
               values.mAiType = shape.GetAiType ();
               
               values.mIsPhysicsEnabled = shape.IsPhysicsEnabled ();
               values.mIsSensor = shape.mIsSensor;
               values.mIsStatic = shape.IsStatic ();
               values.mIsBullet = shape.mIsBullet;
               values.mDensity = shape.mDensity;
               values.mFriction = shape.mFriction;
               values.mRestitution = shape.mRestitution;
               values.mIsHollow = shape.IsHollow ();
               
               //values.mVisibleEditable = true; //shape.GetFilledColor () == Define.ColorStaticObject;
               //values.mStaticEditable = true; //shape.GetFilledColor () == Define.ColorBreakableObject
                                           // || shape.GetFilledColor () == Define.ColorBombObject
                                     ;
               if (entity is EntityShapeCircle)
               {
                  //values.mRadius = (entity as EntityShapeCircle).GetRadius();
                  values.mRadius = ValueAdjuster.AdjustCircleRadius ((entity as EntityShapeCircle).GetRadius(), Config.VersionNumber);
                  
                  values.mAppearanceType = (entity as EntityShapeCircle).GetAppearanceType();
                  values.mAppearanceTypeListSelectedIndex = (entity as EntityShapeCircle).GetAppearanceType();
                  
                  ShowShapeCircleSettingDialog (values, SetShapePropertities);
               }
               else if (entity is EntityShapeRectangle)
               {
                  values.mWidth  = 2.0 * (shape as EntityShapeRectangle).GetHalfWidth ();
                  values.mHeight = 2.0 * (shape as EntityShapeRectangle).GetHalfHeight ();
                  
                  ShowShapeRectangleSettingDialog (values, SetShapePropertities);
               }
               else if (entity is EntityShapePolygon)
               {
                  ShowShapePolygonSettingDialog (values, SetShapePropertities);
               }
               else if (entity is EntityShapePolyline)
               {
                  values.mCurveThickness = (shape as EntityShapePolyline).GetCurveThickness ();
                  
                  ShowShapePolylineSettingDialog (values, SetShapePropertities);
               }
            }
            else // no physics entity
            {
               if (entity is EntityShapeText)
               {
                  values.mDrawBagkground = shape.IsDrawBackground ();
                  values.mText = (shape as EntityShapeText).GetText ();
                  values.mAutofitWidth = (shape as EntityShapeText).IsAutofitWidth ();
                  
                  ShowShapeTextSettingDialog (values, SetShapePropertities);
               }
               else if (entity is EntityShapeGravityController)
               {
                  values.mRadius = ValueAdjuster.AdjustCircleRadius ((entity as EntityShapeCircle).GetRadius(), Config.VersionNumber);
                  
                  // removed from v1.05
                  /////values.mIsInteractive = (shape as EntityShapeGravityController).IsInteractive ();
                  values.mInteractiveZones = (shape as EntityShapeGravityController).GetInteractiveZones ();
                  
                  values.mInteractiveConditions = (shape as EntityShapeGravityController).mInteractiveConditions;
                  
                  values.mInitialGravityAcceleration = (shape as EntityShapeGravityController).GetInitialGravityAcceleration ();
                  values.mInitialGravityAngle = (shape as EntityShapeGravityController).GetInitialGravityAngle ();
                  
                  ShowShapeGravityControllerSettingDialog (values, SetShapePropertities);
               }
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            if (entity is SubEntityHingeAnchor)
            {
               var hinge:EntityJointHinge = entity.GetMainEntity () as EntityJointHinge;
               
               values.mIsVisible = hinge.IsVisible ();
               
               values.mCollideConnected = hinge.mCollideConnected;
               values.mEnableLimit = hinge.IsLimitsEnabled ();
               values.mLowerAngle = hinge.GetLowerLimit ();
               values.mUpperAngle = hinge.GetUpperLimit ();
               values.mEnableMotor = hinge.mEnableMotor;
               values.mMotorSpeed = hinge.mMotorSpeed;
               values.mBackAndForth = hinge.mBackAndForth;
               
               //>>from v1.04
               values.mMaxMotorTorque = hinge.mMaxMotorTorque;
               //<<
               
               //>>from v1.02
               values.mShapeListDataProvider = ShapeList2SelectListDataProvider (mEditorWorld.GetPhysicsShapeList ());
               values.mShapeList1SelectedIndex = EntityIndex2SelectListSelectedIndex (hinge.GetConnectedShape1Index (), values.mShapeListDataProvider);
               values.mShapeList2SelectedIndex = EntityIndex2SelectListSelectedIndex (hinge.GetConnectedShape2Index (), values.mShapeListDataProvider);
               //<<
               
               ShowHingeSettingDialog (values, SetHingePropertities);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = entity.GetMainEntity () as EntityJointSlider;
               
               values.mIsVisible = slider.IsVisible ();
               
               values.mCollideConnected = slider.mCollideConnected;
               values.mEnableLimit = slider.IsLimitsEnabled ();
               values.mLowerTranslation = slider.GetLowerLimit ();
               values.mUpperTranslation = slider.GetUpperLimit ();
               values.mEnableMotor = slider.mEnableMotor;
               values.mMotorSpeed = slider.mMotorSpeed;
               values.mBackAndForth = slider.mBackAndForth;
               
               //>>from v1.04
               values.mMaxMotorForce = slider.mMaxMotorForce;
               //<<
               
               //>>from v1.02
               values.mShapeListDataProvider = ShapeList2SelectListDataProvider (mEditorWorld.GetPhysicsShapeList ());
               values.mShapeList1SelectedIndex = EntityIndex2SelectListSelectedIndex (slider.GetConnectedShape1Index (), values.mShapeListDataProvider);
               values.mShapeList2SelectedIndex = EntityIndex2SelectListSelectedIndex (slider.GetConnectedShape2Index (), values.mShapeListDataProvider);
               values.mAnchorIndex = (entity as SubEntitySliderAnchor).GetAnchorIndex ();
               //<<
               
               ShowSliderSettingDialog (values, SetSliderPropertities);
            }
            else if (entity is SubEntitySpringAnchor)
            {
               var spring:EntityJointSpring = entity.GetMainEntity () as EntityJointSpring;
               
               values.mIsVisible = spring.IsVisible ();
               
               values.mCollideConnected = spring.mCollideConnected;
               values.mStaticLengthRatio = spring.GetStaticLengthRatio ();
               //values.mFrequencyHz = spring.GetFrequencyHz ();
               values.mSpringType = spring.GetSpringType ();
               values.mDampingRatio = spring.mDampingRatio;
               
               //>>from v1.02
               values.mShapeListDataProvider = ShapeList2SelectListDataProvider (mEditorWorld.GetPhysicsShapeList ());
               values.mShapeList1SelectedIndex = EntityIndex2SelectListSelectedIndex (spring.GetConnectedShape1Index (), values.mShapeListDataProvider);
               values.mShapeList2SelectedIndex = EntityIndex2SelectListSelectedIndex (spring.GetConnectedShape2Index (), values.mShapeListDataProvider);
               values.mAnchorIndex = (entity as SubEntitySpringAnchor).GetAnchorIndex ();
               //<<
               
               ShowSpringSettingDialog (values, SetSpringPropertities);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = entity.GetMainEntity () as EntityJointDistance;
               
               values.mIsVisible = distance.IsVisible ();
               
               values.mCollideConnected = distance.mCollideConnected;
               
               //>>from v1.02
               values.mShapeListDataProvider = ShapeList2SelectListDataProvider (mEditorWorld.GetPhysicsShapeList ());
               values.mShapeList1SelectedIndex = EntityIndex2SelectListSelectedIndex (distance.GetConnectedShape1Index (), values.mShapeListDataProvider);
               values.mShapeList2SelectedIndex = EntityIndex2SelectListSelectedIndex (distance.GetConnectedShape2Index (), values.mShapeListDataProvider);
               values.mAnchorIndex = (entity as SubEntityDistanceAnchor).GetAnchorIndex ();
               //<<
               
               ShowDistanceSettingDialog (values, SetDistancePropertities);
            }
         }
         else if (entity is EntityLogic)
         {
            if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               
               values.mName = condition.GetName ();
               values.mConditionListDefinition  = condition.GetConditionListDefinition ();
               
               ShowConditionSettingDialog (values, SetConditionProperties);
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               
               values.mName = action.GetName ();
               values.mCommandListDefinition = action.GetCommandListDefinition ();
               
               ShowActionSettingDialog (values, SetActionProperties);
            }
            else if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               
               values.mName = event_handler.GetName ();
               values.mEventId = event_handler.GetEventId ();
               values.mConditionListDefinition  = event_handler.GetConditionListDefinition ();
               values.mCommandListDefinition  = event_handler.GetCommandListDefinition ();
               
               ShowEventHandlerSettingDialog (values, SetEventHandlerProperties);
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
            if (Runtime.mSynchronizeWorldWithWorldSettingPanel != null)
               Runtime.mSynchronizeWorldWithWorldSettingPanel (mEditorWorld);
            
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
      
      private function OpenPlayCodeLoadingDialog ():void
      {
         if (! IsPlaying ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         ShowPlayCodeLoadingDialog (LoadPlayerWorldFromHexString);
      }
      
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
//   
//=================================================================================
      
      public static function ShapeList2SelectListDataProvider (shapeList:Array):Array
      {
         var provider:Array = new Array ();
         
         provider.push({label:Define.EntityId_Ground + ":{Ground}", data:Define.EntityId_Ground});
         provider.push({label:Define.EntityId_None + ":[Auto Dectect]", data:Define.EntityId_None});
         
         var shape:EntityShape;
         var shapeType:String;
         var entityIndex:int;
         for (var i:int = 0; i < shapeList.length; ++ i)
         {
            shape = shapeList[i].mShape as EntityShape;
            shapeType = shape.GetTypeName ();
            entityIndex = shapeList[i].mEntityIndex;
            provider.push({label: entityIndex + ": " + shapeType, data:entityIndex});
         }
         
         return provider;
      }
      
      public static function EntityIndex2SelectListSelectedIndex (entityIndex:int, dataProvider:Array):int
      {
         for (var i:int = 0; i < dataProvider.length; ++ i)
         {
            if (dataProvider[i].data == entityIndex)
               return i;
         }
         
         return EntityIndex2SelectListSelectedIndex (Define.EntityId_None, dataProvider);
      }
      
      public static function CollisionCategoryList2SelectListDataProvider (ccList:Array):Array
      {
         var provider:Array = new Array ();
         
         provider.push ({label:"{Hidden Category}", data:Define.CollisionCategoryId_HiddenCategory});
         
         var category:EntityCollisionCategory;
         
         for (var i:int = 0; i < ccList.length; ++ i)
         {
            category = ccList [i].mCategory as EntityCollisionCategory;
            
            provider.push ({label:category.GetCategoryName (), data:ccList [i].mCategoryIndex});
         }
         
         return provider;
      }
      
      public static function CollisionCategoryIndex2SelectListSelectedIndex (categoryIndex:int, dataProvider:Array):int
      {
         for (var i:int = 0; i < dataProvider.length; ++ i)
         {
            if (dataProvider[i].data == categoryIndex)
               return i;
         }
         
         return CollisionCategoryIndex2SelectListSelectedIndex (Define.CollisionCategoryId_HiddenCategory, dataProvider);
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
         
         var point:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         
         if ( ! rect.containsPoint (point) )
         {
            // wired: sometimes, moust out event can't be captured, so create a fake mouse out event here
            OnMouseOut (event);
            return;
         }

         
         _isZeroMove = false;
         
         var viewPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         
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
         
         CheckModifierKeys (event);
         
         //var point:Point = DisplayObjectUtil.LocalToLocal ( (event.target as DisplayObject).parent, this, new Point (event.localX, event.localY) );
         var point:Point = globalToLocal ( new Point (event.stageX, event.stageY) );
         //var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         var rect:Rectangle = new Rectangle (0, 0, width, height);
         
         var isOut:Boolean = ! rect.containsPoint (point);
         
         if ( ! isOut )
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
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         // temp code
         if (event.keyCode == Keyboard.ESCAPE)
         {
            if (Runtime.mCollisionCategoryView != null)
               Runtime.mCollisionCategoryView.CancelCurrentCreatingMode ();
         }
         
         if (! mActive) // in other tab panels
            return;
         
         //trace ("event.keyCode = " + event.keyCode);
         
         switch (event.keyCode)
         {
            case Keyboard.ESCAPE:
               CancelCurrentCreatingMode ();
               break;
            case Keyboard.SPACE:
               OpenEntitySettingDialog ();
               break;
            //case 49: // 1
            //case Keyboard.NUMPAD_1:
            //   OpenCollisionGroupManageDialog ();
            //   break;
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
            case 71: // G
               GlueSelectedEntities ();
               break;
            case 66: // B
               BreakApartSelectedEntities ();
               break;
            case 76: // L
               OpenPlayCodeLoadingDialog ();
               break;
            case 192: // ~
               ToggleMouseEditLocked ();
               break;
            case Keyboard.TAB:
               ToggleMouseMode ();
               break;
            case Keyboard.LEFT:
               if (event.shiftKey)
                  RotateSelectedEntities (- 0.5 * Math.PI / 180.0, true, false);
               else
                  MoveSelectedEntities (-1, 0, true, false);
               break;
            case Keyboard.RIGHT:
               if (event.shiftKey)
                  RotateSelectedEntities (0.5 * Math.PI / 180.0, true, false);
               else
                  MoveSelectedEntities (1, 0, true, false);
               break;
            case Keyboard.UP:
               if (event.shiftKey)
                  RotateSelectedEntities (- 5 * Math.PI / 180.0, true, false);
               else
                  MoveSelectedEntities (0, -1, true, false);
               break;
            case Keyboard.DOWN:
               if (event.shiftKey)
                  RotateSelectedEntities (5* Math.PI / 180.0, true, false);
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
      
      
//============================================================================
//    
//============================================================================
      
      public function DestroyEntity (entity:Entity):void
      {
         mEditorWorld.DestroyEntity (entity);
         
         CalSelectedEntitiesCenterPoint ();
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
         
         SetTheOnlySelectedEntity (circle);
         
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
         
         SetTheOnlySelectedEntity (rect);
         
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
         
         SetTheOnlySelectedEntity (polygon);
         
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
         
         SetTheOnlySelectedEntity (polyline);
         
         return polyline;
      }
      
      public function CreateHinge (posX:Number, posY:Number):EntityJointHinge
      {
         var hinge:EntityJointHinge = mEditorWorld.CreateEntityJointHinge ();
         if (hinge == null)
            return null;
            
         hinge.GetAnchor ().SetPosition (posX, posY);
         
         SetTheOnlySelectedEntity (hinge.GetAnchor ());
         
         return hinge;
      }
      
      public function CreateDistance (posX1:Number, posY1:Number, posX2:Number, posY2:Number):EntityJointDistance
      {
         var distaneJoint:EntityJointDistance = mEditorWorld.CreateEntityJointDistance ();
         if (distaneJoint == null)
            return null;
         
         distaneJoint.GetAnchor1 ().SetPosition (posX1, posY1);
         distaneJoint.GetAnchor2 ().SetPosition (posX2, posY2);
         
         SetTheOnlySelectedEntity (distaneJoint.GetAnchor2 ());
         
         return distaneJoint;
      }
      
      public function CreateSlider (posX1:Number, posY1:Number, posX2:Number, posY2:Number):EntityJointSlider
      {
         var slider:EntityJointSlider = mEditorWorld.CreateEntityJointSlider ();
         if (slider == null)
            return null;
         
         slider.GetAnchor1 ().SetPosition (posX1, posY1);
         slider.GetAnchor2 ().SetPosition (posX2, posY2);
         
         SetTheOnlySelectedEntity (slider.GetAnchor2 ());
         
         return slider;
      }
      
      public function CreateSpring (posX1:Number, posY1:Number, posX2:Number, posY2:Number):EntityJointSpring
      {
         var spring:EntityJointSpring = mEditorWorld.CreateEntityJointSpring ();
         if (spring == null)
            return null;
         
         spring.GetAnchor1 ().SetPosition (posX1, posY1);
         spring.GetAnchor2 ().SetPosition (posX2, posY2);
         
         SetTheOnlySelectedEntity (spring.GetAnchor2 ());
         
         return spring;
      }
      
      public function CreateText (left:Number, top:Number, right:Number, bottom:Number):EntityShapeText
      {
         var startPoint:Point = new Point (left, top);
         var endPoint  :Point = new Point (right,bottom);
         
         var centerX:Number = (startPoint.x + endPoint.x) * 0.5;
         var centerY:Number = (startPoint.y + endPoint.y) * 0.5;
         
         var halfWidth :Number = (startPoint.x - endPoint.x) * 0.5; if (halfWidth  < 0) halfWidth  = - halfWidth;
         var halfHeight:Number = (startPoint.y - endPoint.y) * 0.5; if (halfHeight < 0) halfHeight = - halfHeight;
         
         var shapeText:EntityShapeText = mEditorWorld.CreateEntityShapeText ();
         if (shapeText == null)
            return null;
         
         shapeText.SetPosition (centerX, centerY);
         shapeText.SetHalfWidth  (halfWidth);
         shapeText.SetHalfHeight (halfHeight);
         
         shapeText.SetFilledColor (Define.ColorTextBackground);
         shapeText.SetStatic (true);
         
         SetTheOnlySelectedEntity (shapeText);
         
         return shapeText;
      }
      
      public function CreateGravityController (centerX:Number, centerY:Number, radius:Number):EntityShapeGravityController
      {
         var centerPoint:Point = new Point (centerX, centerY);
         var edgePoint  :Point = new Point (centerX + radius, centerY);
         
         radius = Point.distance (centerPoint, edgePoint);
         
         var gController:EntityShapeGravityController = mEditorWorld.CreateEntityShapeGravityController ();
         if (gController == null)
            return null;
         
         gController.SetPosition (centerX, centerY);
         gController.SetRadius (radius);
         
         gController.SetStatic (true);
         
         SetTheOnlySelectedEntity (gController);
         
         return gController;
      }
      
      public function CreateEntityUtilityCamera (options:Object = null):EntityUtilityCamera
      {
         var camera:EntityUtilityCamera = mEditorWorld.CreateEntityUtilityCamera ();
         if (camera == null)
            return null;
         
         SetTheOnlySelectedEntity (camera);
         
         return camera;
      }
      
      public function CreateEntityAction (options:Object = null):EntityAction
      {
         var action:EntityAction = mEditorWorld.CreateEntityAction ();
         if (action == null)
            return null;
         
         SetTheOnlySelectedEntity (action);
         
         return action;
      }
      
      public function CreateEntityEventHandler (options:Object = null):EntityEventHandler
      {
         var handler:EntityEventHandler = mEditorWorld.CreateEntityEventHandler (int(options.mDefaultEventId), options.mPotientialEventIds);
         if (handler == null)
            return null;
         
         SetTheOnlySelectedEntity (handler);
         
         return handler;
      }
      
      //public function CreateEntityTrigger (options:Object = null):EntityTrigger
      //{
      //   var trigger:EntityTrigger = mEditorWorld.CreateEntityTrigger ();
      //   if (trigger == null)
      //      return null;
      //   
      //   SetTheOnlySelectedEntity (trigger);
      //   
      //   return trigger;
      //}
      
      public function CreateEntityCondition (options:Object = null):EntityBasicCondition
      {
         var condition:EntityBasicCondition = mEditorWorld.CreateEntityCondition ();
         if (condition == null)
            return null;
         
         SetTheOnlySelectedEntity (condition);
         
         return condition;
      }
      
      
      public function CreateEntityConditionDoor (options:Object = null):EntityConditionDoor
      {
         var condition_door:EntityConditionDoor = mEditorWorld.CreateEntityConditionDoor ();
         if (condition_door == null)
            return null;
         
         SetTheOnlySelectedEntity (condition_door);
         
         return condition_door;
      }
      
      public function CreateEntityTask (options:Object = null):EntityTask
      {
         var task:EntityTask = mEditorWorld.CreateEntityTask ();
         if (task == null)
            return null;
         
         SetTheOnlySelectedEntity (task);
         
         return task;
      }
      
      public function CreateEntityInputEntityAssigner (options:Object = null):EntityInputEntityAssigner
      {
         var entity_assigner:EntityInputEntityAssigner = mEditorWorld.CreateEntityInputEntityAssigner ();
         if (entity_assigner == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_assigner);
         
         return entity_assigner;
      }
      
      public function CreateEntityInputEntityPairAssigner (options:Object = null):EntityInputEntityPairAssigner
      {
         var entity_pair_assigner:EntityInputEntityPairAssigner = mEditorWorld.CreateEntityInputEntityPairAssigner ();
         if (entity_pair_assigner == null)
            return null;
         
         SetTheOnlySelectedEntity (entity_pair_assigner);
         
         return entity_pair_assigner;
      }
      
      
      
//============================================================================
//    
//============================================================================
      
      private var mLastSelectedEntity:Entity = null;
      private var mLastSelectedEntities:Array = null;
      
      private var _SelectedEntitiesCenterPoint:Point = new Point ();
      
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
         
         mLastSelectedEntity = entity;
         
         entity.SetInternalComponentsVisible (true);
         UpdateSelectedEntityInfo ();
         
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
         
         mLastSelectedEntity = entity;
         
         UpdateSelectedEntityInfo ();
         
         // to make selecting part of a glued possible
         // mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         var entities:Array = mEditorWorld.GetEntitiesIntersectWithRegion (left, top, right, bottom);
         
         mEditorWorld.ClearSelectedEntities ();
         
         UpdateSelectedEntityInfo ();
         
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
         
         CalSelectedEntitiesCenterPoint ();
         
         var selecteds:Array = mEditorWorld.GetSelectedEntities ();
         if (selecteds.length == 1)
         {
            mLastSelectedEntity = selecteds [0];
            UpdateSelectedEntityInfo ();
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
         
         mEditorWorld.CloneSelectedEntities (EditorSetting.BodyCloneOffsetX, EditorSetting.BodyCloneOffsetY);
         
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
      
      public function ClearAllEntities (showAlert:Boolean = true):void
      {
         if (showAlert)
            Alert.show("Do you want to clear all objects?", "Clear All", 3, this, OnCloseClearAllAlert, null, Alert.NO);
         else
         {
            mEditorWorld.DestroyAllEntities ();
            
            CreateUndoPoint ();
            
            CalSelectedEntitiesCenterPoint ();
            
            if (Runtime.mCollisionCategoryView != null)
               Runtime.mCollisionCategoryView.UpdateFriendLinkLines ();
            if (Runtime.mSynchronizeWorldSettingPanelWithWorld != null)
               Runtime.mSynchronizeWorldSettingPanelWithWorld (mEditorWorld);
         }
      }
      
      private function OnCloseClearAllAlert (event:CloseEvent):void 
      {
         if (event == null || event.detail==Alert.YES)
         {
            ClearAllEntities (false);
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
      
      public function SetShapePropertities (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
         // entity
            
            shape.SetDrawBorder (params.mDrawBorder);
            params.mPosX = MathUtil.GetClipValue (params.mPosX, mEditorWorld.GetWorldLeft (), mEditorWorld.GetWorldRight ());
            params.mPosY = MathUtil.GetClipValue (params.mPosY, mEditorWorld.GetWorldTop (), mEditorWorld.GetWorldBottom ());
            shape.SetPosition (params.mPosX, params.mPosY);
            shape.SetRotation (params.mAngle * Math.PI / 180.0);
            
            shape.SetVisible (params.mIsVisible);
            
         // shape
            
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
               
               if (shape is EntityShapeCircle)
               {
                  (shape as EntityShapeCircle).SetRadius (params.mRadius);
                  (shape as EntityShapeCircle).SetAppearanceType (params.mAppearanceType);
               }
               else if (shape is EntityShapeRectangle)
               {
                  (shape as EntityShapeRectangle).SetHalfWidth (params.mWidth * 0.5);
                  (shape as EntityShapeRectangle).SetHalfHeight (params.mHeight * 0.5);
               }
               else if (shape is EntityShapePolygon)
               {
               }
               else if (shape is EntityShapePolyline)
               {
                  (shape as EntityShapePolyline).SetCurveThickness (params.mCurveThickness);
               }
            }
            else // not physics entity
            {
               if (shape is EntityShapeText)
               {
                  shape.SetDrawBackground (params.mDrawBackground);
                  (shape as EntityShapeText).SetText (params.mText);
                  (shape as EntityShapeText).SetAutofitWidth (params.mAutofitWidth);
               }
               else if (shape is EntityShapeGravityController)
               {
                  (shape as EntityShapeCircle).SetRadius (params.mRadius);
                  
                  //(shape as EntityShapeGravityController).SetInteractive (params.mIsInteractive);
                  (shape as EntityShapeGravityController).SetInteractiveZones (params.mInteractiveZones);
                  
                  (shape as EntityShapeGravityController).mInteractiveConditions = params.mInteractiveConditions;
                  
                  (shape as EntityShapeGravityController).SetInitialGravityAcceleration (params.mInitialGravityAcceleration);
                  (shape as EntityShapeGravityController).SetInitialGravityAngle (params.mInitialGravityAngle);
               }
            }
            
            shape.UpdateAppearance ();
            shape.UpdateSelectionProxy ();
            
            if (shape is EntityShapeRectangle)
               (shape as EntityShapeRectangle).UpdateVertexControllers (true);
            
            CreateUndoPoint ();
         }
         
         UpdateSelectedEntityInfo ();
      }
      
      public function SetHingePropertities (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is SubEntityHingeAnchor)
         {
            var hinge:EntityJointHinge = entity.GetMainEntity () as EntityJointHinge;
            
            hinge.SetVisible (params.mIsVisible);
            hinge.mCollideConnected = params.mCollideConnected;
            hinge.SetLimitsEnabled (params.mEnableLimit);
            hinge.SetLimits (params.mLowerAngle, params.mUpperAngle);
            hinge.mEnableMotor = params.mEnableMotor;
            hinge.mMotorSpeed = params.mMotorSpeed;
            hinge.mBackAndForth = params.mBackAndForth;
            
            //>>from v1.04
            hinge.mMaxMotorTorque = params.mMaxMotorTorque;
            //<<
            
            //>> from v1.02
            hinge.SetConnectedShape1Index (params.mConntectedShape1Index);
            hinge.SetConnectedShape2Index (params.mConntectedShape2Index);
            //<<
            
            CreateUndoPoint ();
         }
      }
      
      public function SetSliderPropertities (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is SubEntitySliderAnchor)
         {
            var slider:EntityJointSlider = entity.GetMainEntity () as EntityJointSlider;
            
            slider.SetVisible (params.mIsVisible);
            slider.mCollideConnected = params.mCollideConnected;
            slider.SetLimitsEnabled (params.mEnableLimit);
            slider.SetLimits (params.mLowerTranslation, params.mUpperTranslation);
            slider.mEnableMotor = params.mEnableMotor;
            slider.mMotorSpeed = params.mMotorSpeed;
            slider.mBackAndForth = params.mBackAndForth;
            
            //>>from v1.04
            slider.mMaxMotorForce = params.mMaxMotorForce;
            //<<
            
            //>> from v1.02
            slider.SetConnectedShape1Index (params.mConntectedShape1Index);
            slider.SetConnectedShape2Index (params.mConntectedShape2Index);
            //<<
            
            CreateUndoPoint ();
         }
      }
      
      public function SetSpringPropertities (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is SubEntitySpringAnchor)
         {
            var spring:EntityJointSpring = entity.GetMainEntity () as EntityJointSpring;
            
            spring.SetVisible (params.mIsVisible);
            spring.mCollideConnected = params.mCollideConnected;
            spring.SetStaticLengthRatio (params.mStaticLengthRatio);
            //spring.SetFrequencyHz (params.mFrequencyHz);
            spring.SetSpringType (params.mSpringType);
            spring.mDampingRatio = params.mDampingRatio;
            
            //>> from v1.02
            spring.SetConnectedShape1Index (params.mConntectedShape1Index);
            spring.SetConnectedShape2Index (params.mConntectedShape2Index);
            //<<
            
            CreateUndoPoint ();
         }
      }
      
      public function SetDistancePropertities (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is SubEntityDistanceAnchor)
         {
            var distance:EntityJointDistance = entity.GetMainEntity () as EntityJointDistance;
            
            distance.SetVisible (params.mIsVisible);
            distance.mCollideConnected = params.mCollideConnected;
            
            //>> from v1.02
            distance.SetConnectedShape1Index (params.mConntectedShape1Index);
            distance.SetConnectedShape2Index (params.mConntectedShape2Index);
            //<<
            
            CreateUndoPoint ();
         }
      }
      
      public function SetConditionProperties (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is EntityBasicCondition)
         {
            var condition:EntityBasicCondition = entity as EntityBasicCondition;
            condition.SetName (params.mName);
            
            var conditionlist_def:ConditionListDefinition = condition.GetConditionListDefinition ();
            
            conditionlist_def.AssignFunctionCallings (params.mReturnFunctionCallings_ConditionList);
            
            conditionlist_def.AssignFunctionCallingProperties (params.mReturnIsConditionCallings, params.mReturnConditionResultInverteds);
            conditionlist_def.SetAsAnd (params.mIsAnd);
            conditionlist_def.SetAsNot (params.mIsNot);
            
            condition.UpdateAppearance ();
            condition.UpdateSelectionProxy ();
         }
      }
      
      public function SetActionProperties (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is EntityAction)
         {
            var action:EntityAction = entity as EntityAction;
            action.SetName (params.mName);
            
            var cmdlist_def:CommandListDefinition = action.GetCommandListDefinition ();
            cmdlist_def.AssignFunctionCallings (params.mReturnFunctionCallings_CommandList);
            
            action.UpdateAppearance ();
            action.UpdateSelectionProxy ();
         }
      }
      
      public function SetEventHandlerProperties (params:Object):void
      {
         var selectedEntities:Array = mEditorWorld.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is EntityEventHandler)
         {
            var event_handler:EntityEventHandler = entity as EntityEventHandler;
            
            var conditionlist_def:ConditionListDefinition = event_handler.GetConditionListDefinition ()
            conditionlist_def.AssignFunctionCallings (params.mReturnFunctionCallings_ConditionList);
            conditionlist_def.AssignFunctionCallingProperties (params.mReturnIsConditionCallings, params.mReturnConditionResultInverteds);
            conditionlist_def.SetAsAnd (params.mIsAnd);
            conditionlist_def.SetAsNot (params.mIsNot);
            
            var cmdlist_def:CommandListDefinition = event_handler.GetCommandListDefinition ();
            cmdlist_def.AssignFunctionCallings (params.mReturnFunctionCallings_CommandList);
            
            //event_handler.UpdateAppearance ();
            //event_handler.UpdateSelectionProxy ();
         }
      }
      
      //public function SetTriggerProperties (params:Object):void
      //{
      //}
      
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
      
      public function LoadPlayerWorldFromHexString (params:Object):void
      {
         var hexString:String = params.mHexString;
         
         mOuterWorldHexString = hexString;
         
         try
         {
            OnPlayRunRestart (true);
         }
         catch (error:Error)
         {
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
            
            var i:int;
            var index:int;
            var entity:Entity;
            for (i = 0; i < selectedEntities.length; ++ i)
            {
               //trace ("selectedEntities[i] = " + selectedEntities[i]);
               //trace ("selectedEntities[i].parent = " + selectedEntities[i].parent);
               
               index = mEditorWorld.getChildIndex (selectedEntities[i]);
               entity = newWorld.getChildAt (index) as Entity;
               entity = entity.GetMainEntity ();
               newWorld.SelectEntity (entity);
               newWorld.SelectEntities (entity.GetSubEntities ());
            }
            
            i = 0;
            while (i < newWorld.numChildren)
            {
               entity = newWorld.getChildAt (i) as Entity;
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
            
            for (i = 0; i < newWorld.numChildren; ++ i)
            {
               entity = newWorld.getChildAt (i) as Entity;
               if (entity is EntityShape)
               {
                  ccId = (entity as EntityShape).GetCollisionCategoryIndex ();
                  if (ccId >= 0)
                     cm.SelectEntity (cm.GetCollisionCategoryByIndex (ccId));
               }
            }
            
            i = 0;
            while (i < cm.numChildren)
            {
               entity = cm.getChildAt (i) as Entity;
               if ( entity.IsSelected () ) // generally should use world.IsEntitySelected instead, this one is fast but only for internal uses
               {
                  ++ i;
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
            var oldEntitiesCount:int = mEditorWorld.numChildren;
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
            
            for (i = oldEntitiesCount; i < mEditorWorld.numChildren; ++ i)
            {
               entities = (mEditorWorld.getChildAt (i) as Entity).GetSubEntities ();
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
         
         object.mSelectedEntityIds = new Array (entityArray.length);
         object.mMainSelectedEntityId = -1;
         object.mSelectedVertexControllerId = -1;
         object.mViewCenterWorldX = mViewCenterWorldX;
         object.mViewCenterWorldY = mViewCenterWorldY;
         object.mEditorWorldZoomScale = mEditorWorldZoomScale;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            var entity:Entity = entityArray [i] as Entity;
            object.mSelectedEntityIds [i] = mEditorWorld.getChildIndex (entity);
            if (entity.AreInternalComponentsVisible ())
            {
               object.mMainSelectedEntityId = object.mSelectedEntityIds [i];
               
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
         
         mLastSelectedEntity = null;
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
         
         var numEntities:int = mEditorWorld.numChildren;
         var entityId:int;
         var entity:Entity;
         
         for (var i:int = 0; i < object.mSelectedEntityIds.length; ++ i)
         {
            entityId = object.mSelectedEntityIds [i];
            if (entityId >= 0 && entityId < numEntities)
            {
               entity = mEditorWorld.getChildAt (entityId) as Entity;
               mEditorWorld.SelectEntity (entity);
               
               if (entityId == object.mMainSelectedEntityId)
               {
                  entity.SetInternalComponentsVisible (true);
                  mLastSelectedEntity = entity;
                  
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
         try 
         {
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
         } 
         catch (error:Error) 
         {
             Logger.Trace ("Parse flash vars error." + error);
         }
         
         return null;
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