
package editor {
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.utils.ByteArray;
   
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
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   import mx.controls.Alert;
   import mx.events.CloseEvent;
   
   
   import com.tapirgames.display.FpsCounter;
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import com.tapirgames.util.MathUtil;
   
   import com.tapirgames.display.TextFieldEx;
   
   import com.tapirgames.util.Logger;
   
   import editor.mode.Mode;
   import editor.mode.ModeCreateRectangle;
   import editor.mode.ModeCreateCircle;
   
   import editor.mode.ModeCreateHinge;
   import editor.mode.ModeCreateDistance;
   import editor.mode.ModeCreateSlider;
   import editor.mode.ModeCreateSpring;
   
   import editor.mode.ModeCreateText;
   import editor.mode.ModeCreateGravityController;
   
   import editor.mode.ModeRegionSelectEntities;
   import editor.mode.ModeMoveSelectedEntities;
   
   import editor.mode.ModeRotateSelectedEntities;
   import editor.mode.ModeScaleSelectedEntities;
   
   import editor.mode.ModeMoveSelectedVertexControllers;
   
   import editor.setting.EditorSetting;
   import editor.runtime.Runtime;
   
   import editor.display.CursorCrossingLine;
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityShapeGravityController;
   
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   
   import editor.entity.SubEntityJointAnchor;
   import editor.entity.SubEntityHingeAnchor;
   import editor.entity.SubEntitySliderAnchor;
   import editor.entity.SubEntityDistanceAnchor;
   import editor.entity.SubEntitySpringAnchor;
   
   import editor.entity.VertexController;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.world.World;
   
   import player.world.World;
   import player.ui.PlayHelpDialog;
   import player.ui.PlayControlBar;
   
   import common.WorldDefine;
   import common.DataFormat;
   import common.DataFormat2;
   import common.Define;   
   import common.Config;
   import common.ValueAdjuster;
   
   import misc.Analytics;
   
   public class WorldView extends UIComponent 
   {
      public static const WorldWidth:int = Define.WorldWidth; 
      public static const WorldHeight:int = Define.WorldHeight;
      public static const WorldBorderThinknessLR:int = Define.WorldBorderThinknessLR;
      public static const WorldBorderThinknessTB:int = Define.WorldBorderThinknessTB;
      
      
      
      private var mEditorElementsContainer:Sprite;
      
         public var mBackgroundSprite:Sprite;
         public var mContentContainer:Sprite;
         public var mForegroundSprite:Sprite;
         public var mCursorLayer:Sprite;
         
         private var mSelectedEntitiesCenterSprite:Sprite;
         private var mStatusBarEntityInfoSprite:Sprite;
         
         private var mEditorWorld:editor.world.World;
         
      private var mPlayerElementsContainer:Sprite;
         
         private var mPlayerWorld:player.world.World = null;
         
         //private var mWorldPlayingSpeedX:int = 2;
         
      private var mUiContainer:Sprite;
         
         private var mPlayControlBar:PlayControlBar;
         private var mHelpDialog:Sprite;
         
      //
      
      private var mOuterWorldHexString:String;
      
      //
      public var mCollisionManagerView:CollisionManagerView = null;
      
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
         mEditorElementsContainer = new Sprite ();
         addChild (mEditorElementsContainer);
         
         //
         mBackgroundSprite = new Sprite ();
         mBackgroundSprite.graphics.clear ();
         
         mBackgroundSprite.graphics.beginFill(0xDDDDA0);
         mBackgroundSprite.graphics.drawRect (0, 0, WorldWidth, WorldHeight);
         mBackgroundSprite.graphics.endFill ();
         
         mBackgroundSprite.graphics.lineStyle (1, 0xA0A0A0);
         var gridSize:int = 50;
         for (var lineX:int = gridSize; lineX < WorldWidth; lineX += gridSize)
         {
            mBackgroundSprite.graphics.moveTo (lineX, 0);
            mBackgroundSprite.graphics.lineTo (lineX, WorldHeight);
         }
         for (var lineY:int = gridSize; lineY < WorldHeight; lineY += gridSize)
         {
            mBackgroundSprite.graphics.moveTo (0, lineY);
            mBackgroundSprite.graphics.lineTo (WorldWidth, lineY);
         }
         mBackgroundSprite.graphics.lineStyle ();
         
         mBackgroundSprite.graphics.beginFill(0x606060);
         mBackgroundSprite.graphics.drawRect (0, 0, WorldBorderThinknessLR, WorldHeight);
         mBackgroundSprite.graphics.drawRect (WorldWidth - WorldBorderThinknessLR, 0, WorldBorderThinknessLR, WorldHeight);
         mBackgroundSprite.graphics.endFill ();
         
         mBackgroundSprite.graphics.beginFill(0x606060);
         mBackgroundSprite.graphics.drawRect (0, 0, WorldWidth, WorldBorderThinknessTB);
         mBackgroundSprite.graphics.drawRect (0, WorldHeight - WorldBorderThinknessTB, WorldWidth, WorldBorderThinknessTB);
         mBackgroundSprite.graphics.endFill ();
         
         mEditorElementsContainer.addChild (mBackgroundSprite);
         
         //
         mContentContainer = new Sprite ();
         
         mEditorElementsContainer.addChild (mContentContainer);
         
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
         
         //
         mUiContainer = new Sprite ();
         addChild (mUiContainer);
         
            mPlayControlBar = new PlayControlBar (_OnRestartPlaying, _OnStartPlaying, _OnPausePlaying, _OnStopPlaying, _OnSetPlayingSpeed, _OnOpenPlayHelpDialog);
            mUiContainer.addChild (mPlayControlBar);
            mPlayControlBar.x = (Define.WorldWidth - mPlayControlBar.width) * 0.5;
            mPlayControlBar.y = 2;
            
            mHelpDialog = new PlayHelpDialog (_OnClosePlayHelpDialog);
            mUiContainer.addChild (mHelpDialog);
            mHelpDialog.visible = false;
         
         //
         
         SetEditorWorld (new editor.world.World ());
         
         //
         
         BuildContextMenu ();
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
      }
      
      private var mContentMaskSprite:Shape = null;
      
      private function OnResize (event:Event):void 
      {
         var parentWidth :Number = parent.width;
         var parentHeight:Number = parent.height;
         
         // mask
         {
            if (mContentMaskSprite == null)
               mContentMaskSprite = new Shape ();
            
            mContentMaskSprite.graphics.clear ();
            mContentMaskSprite.graphics.beginFill(0x0);
            mContentMaskSprite.graphics.drawRect (0, 0, parentWidth, parentHeight);
            mContentMaskSprite.graphics.endFill ();
            mContentContainer.addChild (mContentMaskSprite);
            
            mEditorWorld.mask = mContentMaskSprite;
         }
         
         if (parentWidth / WorldWidth < parentHeight / WorldHeight)
         {
            if (parentWidth < WorldWidth)
               mEditorWorld.scaleX = mEditorWorld.scaleY = parentWidth / WorldWidth;
            else
               mEditorWorld.scaleX = mEditorWorld.scaleY = 1;
         }
         else
         {
            if (parentHeight < WorldHeight)
               mEditorWorld.scaleX = mEditorWorld.scaleY = parentHeight / WorldHeight;
            else
               mEditorWorld.scaleX = mEditorWorld.scaleY = 1;
         }
         
         mEditorWorld..x = (parentWidth - WorldWidth * mEditorWorld.scaleX) * 0.5;
         mEditorWorld..y = (parentHeight - WorldHeight * mEditorWorld.scaleY) * 0.5;
         
         SynchrinizePlayerWorldWithEditorWorld ();
         
         mBackgroundSprite.x = mEditorWorld.x;
         mBackgroundSprite.y = mEditorWorld.y;
         mBackgroundSprite.scaleX = mEditorWorld.scaleX;
         mBackgroundSprite.scaleY = mEditorWorld.scaleY;
         
         mUiContainer.x = mEditorWorld.x;
         mUiContainer.y = mEditorWorld.y;
         mUiContainer.scaleX = mEditorWorld.scaleX;
         mUiContainer.scaleY = mEditorWorld.scaleY;
         
         UpdateEntityInfoOnStatusBar ();
      }
      
      private function SynchrinizePlayerWorldWithEditorWorld ():void
      {
         if (mPlayerWorld != null)
         {
            mPlayerWorld.x = mEditorWorld.x;
            mPlayerWorld.y = mEditorWorld.y;
            mPlayerWorld.scaleX = mEditorWorld.scaleX;
            mPlayerWorld.scaleY = mEditorWorld.scaleY;
         }
      }
      
      private var mFpsCounter:FpsCounter;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      public var mActive:Boolean = true;
      
      private function OnEnterFrame (event:Event):void 
      {
         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if ( ! Runtime.HasSettingDialogOpened () && mActive)
            stage.focus = stage;
         
         if ( IsPlaying () )
         {
            if (mPlayerWorld != null && ! IsPlayingPaused () && ! mHelpDialog.visible )
               mPlayerWorld.Update (mStepTimeSpan.GetLastSpan (), GetPlayingSpeedX ());
         }
         else
         {
            mEditorWorld.Update (mStepTimeSpan.GetLastSpan ());
         }
         
         // ...
         mAnalytics.TrackTime (Config.VirtualPageName_EditorTimePrefix);
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
// interfaces exposed to right panel
//==================================================================================
      
      
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
      
      public var mButtonCreateJointHinge:Button;
      public var mButtonCreateJointSlider:Button;
      public var mButtonCreateJointDistance:Button;
      public var mButtonCreateJointSpring:Button;
      
      public var mButtonCreateComponentT:Button;
      public var mButtonCreateComponentV:Button;
      public var mButtonCreateComponent7:Button;
      
      public var mButtonCreateText:Button;
      public var mButtonCreateCravityController:Button;
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         SetCurrentCreateMode (null);
         mLastSelectedCreateButton = (event.target as Button);
         
         switch (event.target)
         {
         // boxes
            
            case mButtonCreateBoxMovable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreateBoxStatic:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorStaticObject, true ) );
               break;
            case mButtonCreateBoxBreakable:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorBreakableObject, true ) );
               break;
            case mButtonCreateBoxInfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBoxUninfected:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBoxDontinfect:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBoxBomb:
               SetCurrentCreateMode ( new ModeCreateRectangle (this, EditorSetting.ColorBombObject, false, true, EditorSetting.MinBombSquareSideLength, EditorSetting.MaxBombSquareSideLength ) );
               break;
               
         // balls
            
            case mButtonCreateBallMovable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorMovableObject, false ) );
               break;
            case mButtonCreateBallStatic:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorStaticObject, true ) );
               break;
            case mButtonCreateBallBreakable:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorBreakableObject, false ) );
               break;
            case mButtonCreateBallInfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorInfectedObject, false ) );
               break;
            case mButtonCreateBallUninfected:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorUninfectedObject, false ) );
               break;
            case mButtonCreateBallDontInfect:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorDontInfectObject, false ) );
               break;
            case mButtonCreateBallBomb:
               SetCurrentCreateMode ( new ModeCreateCircle (this, EditorSetting.ColorBombObject, false, EditorSetting.MinCircleRadium, EditorSetting.MaxBombSquareSideLength * 0.5 ) );
               break;
               
         // ...
            
            case mButtonCreateComponentT:
               SetCurrentCreateMode (null);
               break;
               SetCurrentCreateMode (null);
            case mButtonCreateComponentV:
               break;
            case mButtonCreateComponent7:
               SetCurrentCreateMode (null);
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
      
      public var mButtonAuthorInfo:Button;
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
         
         mButtonCreateCravityController.enabled = mEditorWorld.GetGravityControyList ().length == 0;
         
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
               FlipSelectedEntities (false);
               break;
            case mButtonFlipV:
               FlipSelectedEntities (true);
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
               break
            case mButtonAuthorInfo:
               OpenWorldSettingDialog ();
               break
            case mButtonSaveWorld:
               OpenWorldSavingDialog ();
               break
            case mButtonLoadWorld:
               OpenWorldLoadingDialog ();
               break
            default:
               break;
         }
      }
      
      //private var mMenuItemAuthorInfo:ContextMenuItem;
      //private var mMenuItemSaveWorld:ContextMenuItem;
      //private var mMenuItemLoadWorld:ContextMenuItem;
      
      // ---
      private var mMenuItemAbout:ContextMenuItem;
      
      private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         
         // need flash 10
         //theContextMenu.clipboardMenu = true;
         //var clipboardItems:ContextMenuClipboardItems = theContextMenu.builtInItems;
         //clipboardItems.clear = true;
         //clipboardItems.cut = false;
         //clipboardItems.copy = true;
         //clipboardItems.paste = true;
         //clipboardItems.selectAll = false;
            
            
            /*
            mMenuItemAuthorInfo = new ContextMenuItem ("Author Setting ...", true);
            theContextMenu.customItems.push (mMenuItemAuthorInfo);
            mMenuItemAuthorInfo.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
            
            mMenuItemSaveWorld = new ContextMenuItem ("Save World ...");
            theContextMenu.customItems.push (mMenuItemSaveWorld);
            mMenuItemSaveWorld.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
            
            mMenuItemLoadWorld = new ContextMenuItem ("Load World ...");
            theContextMenu.customItems.push (mMenuItemLoadWorld);
            mMenuItemLoadWorld.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
            */
            
            mMenuItemAbout = new ContextMenuItem("About This Editor", false);
            theContextMenu.customItems.push (mMenuItemAbout);
            mMenuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         contextMenu = theContextMenu;
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            /*
            case mMenuItemAuthorInfo:
               OpenWorldSettingDialog ();
               break;
            case mMenuItemSaveWorld:
               break;
            case mMenuItemLoadWorld:
               break;
            */
            case mMenuItemAbout:
               OpenAboutLink ();
               break;
            default:
               break;
         }
      }
      
      private function SetEditorWorld (newEditorWorld:editor.world.World):void
      {
         if (mEditorWorld == null)
         {
            mEditorWorld = newEditorWorld;
            mContentContainer.addChild (mEditorWorld);
            
            return;
         }
         
         if (newEditorWorld == null)
            return;
         
         newEditorWorld.x = mEditorWorld.x;
         newEditorWorld.y = mEditorWorld.y;
         newEditorWorld.scaleX = mEditorWorld.scaleX;
         newEditorWorld.scaleY = mEditorWorld.scaleY;
         
         mContentContainer.removeChild (mEditorWorld);
         
         mEditorWorld = newEditorWorld;
         mContentContainer.addChild (mEditorWorld);
         
         if (mCollisionManagerView != null)
            mCollisionManagerView.SetCollisionManager (mEditorWorld.GetCollisionManager ());
         
         //
         
         mTheSelectedVertexController = null;
         mLastSelectedEntity = null;
         mLastSelectedEntities = null;
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      private function SetPlayerWorld (newPlayerWorld:player.world.World):void
      {
         if (mPlayerWorld == null)
         {
            mPlayerWorld = newPlayerWorld;
            mPlayerElementsContainer.addChild (mPlayerWorld);
         }
         else
         {
            mPlayerElementsContainer.removeChild (mPlayerWorld);
            
            if (newPlayerWorld == null)
               return;
               
            mPlayerWorld = newPlayerWorld;
         }
         
         SynchrinizePlayerWorldWithEditorWorld ();
         mPlayerWorld.Update (0, 1);
         mPlayerElementsContainer.addChild (mPlayerWorld);
      }
      
      private function DestroyPlayerWorld ():void
      {
         if ( mPlayerWorld != null && mPlayerElementsContainer.contains (mPlayerWorld) )
         {
            mPlayerWorld.Destroy ();
            mPlayerElementsContainer.removeChild (mPlayerWorld);
         }
         
         mPlayerWorld = null;
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
            // there are some pricision losses in WorldDefine2ByteArray + ByteArray2WorldDefine
            
            var wd1:WorldDefine = DataFormat.EditorWorld2WorldDefine ( mEditorWorld );
            var ba:ByteArray = DataFormat.WorldDefine2ByteArray ( wd1 );
            ba.position = 0;
            var wd2:WorldDefine = DataFormat2.ByteArray2WorldDefine ( ba );
            
            playerWorld = DataFormat2.WorldDefine2PlayerWorld (wd2);
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
         mWorldPlayingSpeedX = Math.floor (speed + speed + 0.5);
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

      
//============================================================================
//    
//============================================================================
      
      public var ShowShapeSettingDialog:Function = null;
      public var ShowShapeCircleSettingDialog:Function = null;
      public var ShowHingeSettingDialog:Function = null;
      public var ShowSliderSettingDialog:Function = null;
      public var ShowSpringSettingDialog:Function = null;
      public var ShowDistanceSettingDialog:Function = null;
      public var ShowShapeTextSettingDialog:Function = null;
      public var ShowShapeGravityControllerSettingDialog:Function = null;
      
      public var ShowWorldSettingDialog:Function = null;
      public var ShowWorldSavingDialog:Function = null;
      public var ShowWorldLoadingDialog:Function = null;
      
      public var ShowCollisionGroupManageDialog:Function = null;
      
      public var ShowPlayCodeLoadingDialog:Function = null;
      
      public function IsEntitySettingable (entity:Entity):Boolean
      {
         if (entity == null)
            return false;
         
         return entity is EntityShape || entity is SubEntityHingeAnchor || entity is SubEntitySliderAnchor
                || entity is SubEntitySpringAnchor // v1.01
                || entity is SubEntityDistanceAnchor // v1.02
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
         
         values.mIsVisible = entity.IsVisible ();
         
         if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            //>>from v1.02
            values.mDrawBorder = shape.IsDrawBorder ();
            values.mPosX = shape.GetPositionX ();
            values.mPosY = shape.GetPositionY ();
            values.mAngle = shape.GetRotation () * 180.0 / Math.PI;
            
            values.mCollisionCategoryListDataProvider =  CollisionCategoryList2SelectListDataProvider (mEditorWorld.GetCollisionCategoryList ());
            values.mCollisionCategoryListSelectedIndex = CollisionCategoryIndex2SelectListSelectedIndex (shape.GetCollisionCategoryIndex (), values.mCollisionCategoryListDataProvider);
            //<<
            
            if (shape.IsPhysicsEntity ())
            {
               //>>from v1.02
               values.mCollisionCategoryListDataProvider =  CollisionCategoryList2SelectListDataProvider (mEditorWorld.GetCollisionCategoryList ());
               values.mCollisionCategoryListSelectedIndex = CollisionCategoryIndex2SelectListSelectedIndex (shape.GetCollisionCategoryIndex (), values.mCollisionCategoryListDataProvider);
               //<<
               
               values.mIsStatic = shape.IsStatic ();
               values.mIsBullet = shape.mIsBullet;
               values.mDensity = shape.mDensity;
               values.mFriction = shape.mFriction;
               values.mRestitution = shape.mRestitution;
               
               values.mVisibleEditable = true; //shape.GetFilledColor () == Define.ColorStaticObject;
               values.mStaticEditable = true; //shape.GetFilledColor () == Define.ColorBreakableObject
                                           // || shape.GetFilledColor () == Define.ColorBombObject
                                     ;
               if (entity is EntityShapeCircle)
               {
                  //>> from v102
                  //values.mRadius = (entity as EntityShapeCircle).GetRadius();
                  values.mRadius = ValueAdjuster.AdjustCircleRadius ((entity as EntityShapeCircle).GetRadius(), Config.VersionNumber);
                  //<<
                  values.mAppearanceType = (entity as EntityShapeCircle).GetAppearanceType();
                  
                  ShowShapeCircleSettingDialog (values, SetShapePropertities);
               }
               else if (entity is EntityShapeRectangle)
               {
                  //>>from v1.02
                  values.mWidth  = 2.0 * (shape as EntityShapeRectangle).GetHalfWidth ();
                  values.mHeight = 2.0 * (shape as EntityShapeRectangle).GetHalfHeight ();
                  //<<
                  
                  ShowShapeSettingDialog (values, SetShapePropertities);
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
                  values.mIsInteractive = (shape as EntityShapeGravityController).IsInteractive ();
                  values.mInitialGravityAcceleration = (shape as EntityShapeGravityController).GetInitialGravityAcceleration ();
                  values.mInitialGravityAngle = (shape as EntityShapeGravityController).GetInitialGravityAngle ();
                  
                  ShowShapeGravityControllerSettingDialog (values, SetShapePropertities);
               }
            }
         }
         else if (entity is SubEntityHingeAnchor)
         {
            var hinge:EntityJointHinge = entity.GetMainEntity () as EntityJointHinge;
            
            values.mCollideConnected = hinge.mCollideConnected;
            values.mEnableLimit = hinge.IsLimitsEnabled ();
            values.mLowerAngle = hinge.GetLowerLimit ();
            values.mUpperAngle = hinge.GetUpperLimit ();
            values.mEnableMotor = hinge.mEnableMotor;
            values.mMotorSpeed = hinge.mMotorSpeed;
            values.mBackAndForth = hinge.mBackAndForth;
            
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
            
            values.mCollideConnected = slider.mCollideConnected;
            values.mEnableLimit = slider.IsLimitsEnabled ();
            values.mLowerTranslation = slider.GetLowerLimit ();
            values.mUpperTranslation = slider.GetUpperLimit ();
            values.mEnableMotor = slider.mEnableMotor;
            values.mMotorSpeed = slider.mMotorSpeed;
            values.mBackAndForth = slider.mBackAndForth;
            
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
      
      private function OpenWorldSettingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         var values:Object = new Object ();
         
         values.mAuthorName = mEditorWorld.GetAuthorName ();
         values.mAuthorHomepage = mEditorWorld.GetAuthorHomepage ();
         
         //>>from v1.02
         values.mShareSourceCode = mEditorWorld.IsShareSourceCode ();
         //<<
         
         ShowWorldSettingDialog (values, SetWorldProperties);
      }
      
      private function OpenWorldSavingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         var values:Object = new Object ();
         
         values.mXmlString = DataFormat2.WorldDefine2Xml (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
         values.mHexString = DataFormat.WorldDefine2HexString (DataFormat.EditorWorld2WorldDefine (mEditorWorld));
         
         ShowWorldSavingDialog (values);
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
      
      private var _EntityInfoTextOnStatusBar:TextFieldEx = null;
      public function UpdateEntityInfoOnStatusBar ():void
      {
         if (_EntityInfoTextOnStatusBar == null)
         {
            _EntityInfoTextOnStatusBar = TextFieldEx.CreateTextField ("", false, 0xFFFF00, 0x0);
            
            mForegroundSprite.addChild (_EntityInfoTextOnStatusBar);
         }
         
         _EntityInfoTextOnStatusBar.visible = false;
         
         // ...
         if (mLastSelectedEntity != null && ! mEditorWorld.IsEntitySelected (mLastSelectedEntity))
            mLastSelectedEntity = null;
         
         if (mLastSelectedEntity == null)
            return;
         
         _EntityInfoTextOnStatusBar.visible = true;
         
         var typeName:String = mLastSelectedEntity.GetTypeName ();
         var infoText:String = mLastSelectedEntity.GetInfoText ();
         
         _EntityInfoTextOnStatusBar.htmlText = "<font color='#FFFFFF'><b>" + mEditorWorld.getChildIndex (mLastSelectedEntity) + ": " + typeName + "</b>: " + infoText + "</font>";
         
         var infoWorldX:Number = WorldBorderThinknessLR;
         var infoWorldY:Number = WorldHeight - (WorldBorderThinknessTB + _EntityInfoTextOnStatusBar.height) * 0.5;
         
         var point:Point = LocalToLocal (mEditorWorld, mForegroundSprite, new Point (infoWorldX, infoWorldY));
         
         _EntityInfoTextOnStatusBar.x = point.x;
         _EntityInfoTextOnStatusBar.y = point.y;
         _EntityInfoTextOnStatusBar.scaleX = mEditorWorld.scaleX;
         _EntityInfoTextOnStatusBar.scaleY = mEditorWorld.scaleY;
            
      }
      
//=================================================================================
//   
//=================================================================================
      
      private function ShapeList2SelectListDataProvider (shapeList:Array):Array
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
      
      private function EntityIndex2SelectListSelectedIndex (entityIndex:int, dataProvider:Array):int
      {
         for (var i:int = 0; i < dataProvider.length; ++ i)
         {
            if (dataProvider[i].data == entityIndex)
               return i;
         }
         
         return EntityIndex2SelectListSelectedIndex (Define.EntityId_None, dataProvider);
      }
      
      private function CollisionCategoryList2SelectListDataProvider (ccList:Array):Array
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
      
      private function CollisionCategoryIndex2SelectListSelectedIndex (categoryIndex:int, dataProvider:Array):int
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
      
      public static function LocalToLocal (display1:DisplayObject, display2:DisplayObject, point:Point):Point
      {
         //return display2.globalToLocal ( display1.localToGlobal (point) );
         
         var matrix:Matrix = display2.transform.concatenatedMatrix.clone();
         matrix.invert();
         return matrix.transformPoint (display1.transform.concatenatedMatrix.transformPoint (point));
      }
      
      public function ViewToWorld (point:Point):Point
      {
         return LocalToLocal (this, mEditorWorld, point);
      }
      
      public function WorldToView (point:Point):Point
      {
         return LocalToLocal (mEditorWorld, this, point);
      }
      
      
//==================================================================================
// key modifiers
//==================================================================================
      
      public var mButtonKeyShift:Button;
      public var mButtonKeyCtrl:Button;
      public var mButtonKeyAlt:Button;
      
      private function IsEntityMovingLocked ():Boolean
      {
         return Keyboard.capsLock;
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      private var _mouseEventCtrlDown:Boolean = false;
      private var _mouseEventShiftDown:Boolean = false;
      private var _mouseEventAltDown:Boolean = false;
      
      private var _isZeroMove:Boolean = false;
      
      private function CheckModifierKeys (event:MouseEvent):void
      {
         _mouseEventCtrlDown   = event.ctrlKey || (mButtonKeyCtrl != null && mButtonKeyCtrl.selected);
         _mouseEventShiftDown = event.shiftKey || (mButtonKeyShift != null && mButtonKeyShift.selected);
         _mouseEventAltDown     = event.altKey || (mButtonKeyAlt != null && mButtonKeyAlt.selected);
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
         
         var worldPoint:Point = LocalToLocal (event.target as DisplayObject, mEditorWorld, new Point (event.localX, event.localY) );
         
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
            
            var vertexControllers:Array = mEditorWorld.GetVertexControllersAtPoint (worldPoint.x, worldPoint.y);
            
            if (vertexControllers.length > 0)
            {
               if (mTheSelectedVertexController != null)
                  mTheSelectedVertexController.NotifySelectedChanged (false);
               
               mTheSelectedVertexController = vertexControllers[0] as VertexController;
               mTheSelectedVertexController.NotifySelectedChanged (true);
               
               SetCurrentEditMode (new ModeMoveSelectedVertexControllers (this));
               
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               // special handler for rect, to avoid problems caused by position auto adjusting
               if ( mTheSelectedVertexController.GetOwnerEntity () is EntityShapeRectangle)
               {
                  var rect:EntityShapeRectangle = mTheSelectedVertexController.GetOwnerEntity () as EntityShapeRectangle;
                  
                  rect.NotifyBeginMovingVertexController (mTheSelectedVertexController);
               }
               
               return;
            }
            
         // entities
            
            var entityArray:Array = mEditorWorld.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
            var entity:Entity;
            
            // move selecteds, first time
            {
               if (mEditorWorld.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
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
               if (mEditorWorld.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
               {
                  SetCurrentEditMode (new ModeMoveSelectedEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                   
                  return;
               }
            }
            
            //if (mSingleHandMode == SingleHandMode_Scale)
            //   _mouseEventCtrlDown = false;
            
            if (_mouseEventCtrlDown)
               mLastSelectedEntities = mEditorWorld.GetSelectedEntities ();
            else
               mEditorWorld.ClearSelectedEntities ();
            
            // region select
            {
               //var entityArray:Array = mEditorWorld.GetEntitiyAtPoint (worldPoint.x, worldPoint.y, null);
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
         
         var point:Point = LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         
         if ( ! rect.containsPoint (point) )
         {
            // wired: sometimes, moust out event can't be captured, so create a fake mouse out event here
            OnMouseOut (event);
            return;
         }

         
         _isZeroMove = false;
         
         var viewPoint:Point = LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         
         if (mCursorCreating.visible)
         {
            mCursorCreating.x = viewPoint.x;
            mCursorCreating.y = viewPoint.y;
         }
         
         var worldPoint:Point = LocalToLocal (event.target as DisplayObject, mEditorWorld, new Point (event.localX, event.localY) );
         
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
         
         var worldPoint:Point = LocalToLocal (event.target as DisplayObject, mEditorWorld, new Point (event.localX, event.localY) );
         
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
               var entityArray:Array = mEditorWorld.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
               var entity:Entity;
               
               // point select, ctrl down
               if (entityArray.length > 0)
               {
                  entity = (entityArray[0] as Entity);
                  
                  if (_mouseEventCtrlDown)
                  {
                     ToggleEntitySelected (entity);
                  }
                  else 
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
         var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         
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
            case 68: // D
               DeleteSelectedEntities ();
               break;
            case Keyboard.INSERT:
            case 67: // C
               CloneSelectedEntities ();
               break;
            case Keyboard.PAGE_UP:
            case 88: // X
               FlipSelectedEntities (false);
               break;
            case Keyboard.PAGE_DOWN:
            case 89: // Y
               FlipSelectedEntities (true);
               break;
            case 71: // G
               GlueSelectedEntities ();
               break;
            case 66: // B
               BreakApartSelectedEntities ();
               break;
            case Keyboard.TAB:
               //if (IsPlaying () && mOuterWorldHexString != null)
               //{
               //   System.setClipboard ((DataFormat.WorldDefine2Xml(DataFormat2.HexString2WorldDefine (mOuterWorldHexString))).toXMLString ());
               //}
               break;
            case 76: // L
               OpenPlayCodeLoadingDialog ();
               break;
            case Keyboard.LEFT:
               MoveSelectedEntities (-1, 0, true, false);
               break;
            case Keyboard.RIGHT:
               MoveSelectedEntities (1, 0, true, false);
               break;
            case Keyboard.UP:
               MoveSelectedEntities (0, -1, true, false);
               break;
            case Keyboard.DOWN:
               MoveSelectedEntities (0, 1, true, false);
               break;
            case 187:// +
            case Keyboard.NUMPAD_ADD:
               AlignCenterSelectedEntities ();
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
            return gController;
         
         gController.SetPosition (centerX, centerY);
         gController.SetRadius (radius);
         
         gController.SetStatic (true);
         
         SetTheOnlySelectedEntity (gController);
         
         return gController;
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
         UpdateEntityInfoOnStatusBar ();
         
         if (mEditorWorld.GetSelectedEntities ().length != 1 || mEditorWorld.GetSelectedEntities () [0] != entity)
            mEditorWorld.SetSelectedEntity (entity);
         
         if (mEditorWorld.GetSelectedEntities ().length != 1)
            return;
         
         mLastSelectedEntity = entity;
         
         entity.SetVertexControllersVisible (true);
         UpdateEntityInfoOnStatusBar ();
         
         mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function ToggleEntitySelected (entity:Entity):void
      {
         mEditorWorld.ToggleEntitySelected (entity);
         
         if (mEditorWorld.IsEntitySelected (entity))
         {
            if (mLastSelectedEntity != null)
               mLastSelectedEntity.SetVertexControllersVisible (false);
            
            entity.SetVertexControllersVisible (true);
         }
         
         mLastSelectedEntity = entity;
         
         UpdateEntityInfoOnStatusBar ();
         
         // to make selecting part of a glued possible
         // mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         var entities:Array = mEditorWorld.GetEntitiesIntersectWithRegion (left, top, right, bottom);
         
         mEditorWorld.ClearSelectedEntities ();
         
         UpdateEntityInfoOnStatusBar ();
         
         if (_mouseEventCtrlDown)
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
         
         mEditorWorld.SelectGluedEntitiesOfSelectedEntities ();
         
         CalSelectedEntitiesCenterPoint ();
         
         var selecteds:Array = mEditorWorld.GetSelectedEntities ();
         if (selecteds.length == 1)
         {
            mLastSelectedEntity = selecteds [0];
            UpdateEntityInfoOnStatusBar ();
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
            
            //var point:Point = LocalToLocal (mEditorWorld, this, _SelectedEntitiesCenterPoint );
            var point:Point = LocalToLocal (mEditorWorld, mForegroundSprite, _SelectedEntitiesCenterPoint );
            mSelectedEntitiesCenterSprite.x = point.x;
            mSelectedEntitiesCenterSprite.y = point.y;
         }
         
         mSelectedEntitiesCenterSprite.visible = (count > 1);
         
         UpdateUiButtonsEnabledStatus ();
         
         UpdateEntityInfoOnStatusBar ();
      }
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean, byMouse:Boolean = true):void
      {
         if (byMouse && IsEntityMovingLocked ())
            return;
         
         mEditorWorld.MoveSelectedEntities (offsetX, offsetY, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function RotateSelectedEntities (dAngle:Number, updateSelectionProxy:Boolean):void
      {
         if (IsEntityMovingLocked ())
            return;
         
         mEditorWorld.RotateSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), dAngle, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function ScaleSelectedEntities (ratio:Number, updateSelectionProxy:Boolean):void
      {
         if (IsEntityMovingLocked ())
            return;
         
         mEditorWorld.ScaleSelectedEntities (GetSelectedEntitiesCenterX (), GetSelectedEntitiesCenterY (), ratio, updateSelectionProxy);
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function DeleteSelectedEntities ():void
      {
         mEditorWorld.DeleteSelectedEntities ();
         
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
         
         CalSelectedEntitiesCenterPoint ();
      }
      
      public function FlipSelectedEntities (vertically:Boolean):void
      {
         if (vertically)
            mEditorWorld.FlipSelectedEntitiesVertically (GetSelectedEntitiesCenterY ());
         else
            mEditorWorld.FlipSelectedEntitiesHorizontally (GetSelectedEntitiesCenterX ());
         
         //CalSelectedEntitiesCenterPoint ();
      }
      
      public function GlueSelectedEntities ():void
      {
         mEditorWorld.GlueSelectedEntities ();
      }
      
      public function BreakApartSelectedEntities ():void
      {
         mEditorWorld.BreakApartSelectedEntities ();
      }
      
      public function ClearAllEntities ():void
      {
         Alert.show("Do you want to clear all objects?", "Clear All", 3, this, OnCloseClearAllAlert, null, Alert.NO);
      }
      
      private function OnCloseClearAllAlert (event:CloseEvent):void 
      {
         if (event == null || event.detail==Alert.YES)
         {
            mEditorWorld.DestroyAllEntities ();
            
            mEditorWorld.SetShareSourceCode (false);
            
            CalSelectedEntitiesCenterPoint ();
            
            if (mCollisionManagerView != null)
            {
               mCollisionManagerView.UpdateFriendLinkLines ();
            }
         }
      }
      
      public function MoveSelectedEntitiesToTop ():void
      {
         mEditorWorld.MoveSelectedEntitiesToTop ();
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
         mEditorWorld.MoveSelectedEntitiesToBottom ();
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
            
            CalSelectedEntitiesCenterPoint ();
         }
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
         
         CalSelectedEntitiesCenterPoint ();
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
            
            //>> from v1.02
            shape.SetDrawBorder (params.mDrawBorder);
            params.mPosX = MathUtil.GetClipValue (params.mPosX, 0, WorldWidth);
            params.mPosY = MathUtil.GetClipValue (params.mPosY, 0, WorldHeight);
            shape.SetPosition (params.mPosX, params.mPosY);
            shape.SetRotation (params.mAngle * Math.PI / 180.0);
            //<<
            
            if (shape.IsPhysicsEntity ())
            {
               //>> from v1.02
               shape.SetCollisionCategoryIndex (params.mCollisionCategoryIndex);
               //<<
               
               shape.SetStatic (params.mIsStatic);
               shape.SetVisible (params.mIsVisible);
               shape.mIsBullet = params.mIsBullet;
               shape.mDensity = params.mDensity;
               shape.mFriction = params.mFriction;
               shape.mRestitution = params.mRestitution;
               
               if (shape is EntityShapeCircle)
               {
                  (shape as EntityShapeCircle).SetRadius (params.mRadius);
                  (shape as EntityShapeCircle).SetAppearanceType (params.mAppearanceType);
               }
               else if (shape is EntityShapeRectangle)
               {
                  //>> from v1.02
                  (shape as EntityShapeRectangle).SetHalfWidth (params.mWidth * 0.5);
                  (shape as EntityShapeRectangle).SetHalfHeight (params.mHeight * 0.5);
                  //<<
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
                  
                  (shape as EntityShapeGravityController).SetInteractive (params.mIsInteractive);
                  (shape as EntityShapeGravityController).SetInitialGravityAcceleration (params.mInitialGravityAcceleration);
                  (shape as EntityShapeGravityController).SetInitialGravityAngle (params.mInitialGravityAngle);
               }
            }
            
            shape.UpdateAppearance ();
            shape.UpdateSelectionProxy ();
            
            if (shape is EntityShapeRectangle)
               (shape as EntityShapeRectangle).UpdateVertexControllers (true);
         }
         
         UpdateEntityInfoOnStatusBar ();
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
            
            //>> from v1.02
            hinge.SetConnectedShape1Index (params.mConntectedShape1Index);
            hinge.SetConnectedShape2Index (params.mConntectedShape2Index);
            //<<
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
            
            //>> from v1.02
            slider.SetConnectedShape1Index (params.mConntectedShape1Index);
            slider.SetConnectedShape2Index (params.mConntectedShape2Index);
            //<<
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
         }
      }
      
      public function SetWorldProperties (params:Object):void
      {
         mEditorWorld.SetAuthorName (params.mAuthorName);
         mEditorWorld.SetAuthorHomepage (params.mAuthorHomepage);
         
         //>>from v1.02
         mEditorWorld.SetShareSourceCode (params.mShareSourceCode);
         //<<
      }
      
      public function LoadEditorWorldFromXmlString (params:Object):void
      {
         var xmlString:String = params.mXmlString;
         
         var xml:XML = new XML (xmlString);
         
         try
         {
            var newEditorWorld:editor.world.World = DataFormat.WorldDefine2EditorWorld (DataFormat.Xml2WorldDefine (xml));
         
            SetEditorWorld (newEditorWorld);
         }
         catch (error:Error)
         {
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
      
//============================================================================
//    
//============================================================================
      
      
      
   }
}