package viewer {

   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.TextField;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import flash.system.Capabilities;

   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;

   import common.Define;

   public class SkinDefault extends Skin
   {
      private static const PlayBarHeight:Number = 20.0;

//======================================================================
//
//======================================================================
      
      private var mHudLayer:Sprite = new Sprite ();
      private var mHelpDialogLayer:Sprite = new Sprite ();
      private var mLevelFinishedDialogLayer:Sprite = new Sprite ();
      private var mDeactivatedLayer:Sprite = new Sprite ();
      private var mInfosLayer:Sprite = new Sprite ();
      
      public function SkinDefault (params:Object)
      {
         super (params);
         
         addChild (mHelpDialogLayer);
         addChild (mLevelFinishedDialogLayer);
         addChild (mHudLayer);
         addChild (mDeactivatedLayer);
         addChild (mInfosLayer);
         mDeactivatedLayer.visible = false;
         mInfosLayer.visible = false;
         //mInfosLayer.alpha = 0.67;
      }

//======================================================================
//
//======================================================================
      
      override public function GetPreferredViewerSize (viewportWidth:Number, viewportHeight:Number):Point
      {
         if (mIsOverlay || (! IsShowPlayBar ()))
            return new Point (viewportWidth, viewportHeight);
         
         return new Point (viewportWidth, viewportHeight + PlayBarHeight);
      }
      
      override public function GetContentRegion ():Rectangle
      {
         if (mIsOverlay || (! IsShowPlayBar ()))
            return new Rectangle (0, 0, mViewerWidth, mViewerHeight);
         
         var top:Number = PlayBarHeight;
         return new Rectangle (0, top, mViewerWidth, mViewerHeight - top);
      }
      
      override public function Update (dt:Number):void
      {  
         mFpsTime += dt; 
         ++ mFpsSteps;
         
         if (mTotalSteps < 30)
         {
            ++ mTotalSteps;
            mFps = mFpsSteps / mFpsTime;
            
            if (mInfosLayer.visible)
            {
               UpdateInfosPanel ();
            }
         }
         else if (mFpsSteps >= 30)
         {
            mFps = mFpsSteps / mFpsTime;
            mFpsTime = 0.0;
            mFpsSteps = 0;
            
            if (mInfosLayer.visible)
            {
               UpdateInfosPanel ();
            }
         }
         
         if (mDeactivated)
         {
            UpdateDeactivatedLayer ();
            return;
         }
         
         var fadingSpeed:Number = dt;
         
         if (mLevelFinishedDialog != null)
         {
            if (IsLevelFinishedDialogVisible () && (! mHasLevelFinishedDialogEverOpened))
            {
               mLevelFinishedDialog.visible = true;
               
               if (mLevelFinishedDialog.alpha < 0.9)
                  mLevelFinishedDialog.alpha += fadingSpeed;
               if (mLevelFinishedDialog.alpha >= 0.9)
                  mLevelFinishedDialog.alpha = 0.9;
            }
            else
            {
               // //if (mLevelFinishedDialog.alpha > 0.0) 
               // //   mLevelFinishedDialog.alpha -= fadingSpeed;
               // //if (mLevelFinishedDialog.alpha <= 0.0)
               // //{
               //   mLevelFinishedDialog.alpha = 0.0;
               //   mLevelFinishedDialog.visible = false;
               // //}
            }
         }
         
         if (mHelpDialog != null)
         {
            if (IsHelpDialogVisible ())
            {
               mHelpDialog.visible = true;
               
               if (mHelpDialog.alpha < 1.0)
                  mHelpDialog.alpha += fadingSpeed;
               if (mHelpDialog.alpha >= 1.0)
                  mHelpDialog.alpha = 1.0;
            }
            else
            {
               // //if (mHelpDialog.alpha > 0.0)
               // //   mHelpDialog.alpha -= fadingSpeed;
               // //if (mHelpDialog.alpha <= 0.0)
               // //{
               //   mHelpDialog.alpha = 0.0;
               //   mHelpDialog.visible = false;
               // //}
            }
         }
         
         if (mIsOverlay)
         {
            var isPlaying:Boolean = IsPlaying () && (! AreSomeDialogsVisible ());
            
            if (isPlaying)
            {
               mHudLayerForPlay.visible = true;
               if (mHudLayerForPlay.alpha < 0.5)
                  mHudLayerForPlay.alpha += fadingSpeed;
               if (mHudLayerForPlay.alpha > 0.5)
                  mHudLayerForPlay.alpha = 0.5;
            }
            else
            {
               if (mHudLayerForPlay.alpha > 0.0)
                  mHudLayerForPlay.alpha -= fadingSpeed;
               if (mHudLayerForPlay.alpha <= 0.0)
               {
                  mHudLayerForPlay.alpha = 0.0;
                  mHudLayerForPlay.visible = false;
               }
            }
            
            var isPaused:Boolean = (! IsPlaying ()) && (! AreSomeDialogsVisible ());
            if (isPaused)
            {
               mHudLayerForPause.visible = true;
               if (mHudLayerForPause.alpha < 1.0)
                  mHudLayerForPause.alpha += fadingSpeed;
               if (mHudLayerForPause.alpha >= 1.0)
                  mHudLayerForPause.alpha = 1.0;
            }
            else
            {
               if (mHudLayerForPause.alpha > 0.0)
                  mHudLayerForPause.alpha -= fadingSpeed;
               if (mHudLayerForPause.alpha <= 0.0)
               {
                  mHudLayerForPause.alpha = 0.0;
                  mHudLayerForPause.visible = false;
               }
            }
         }
         else
         {
            // ...
         }
      }
      
      override public function Rebuild (params:Object):void
      {
         RebuildPlayBar (params);
         //RebuildHelpDialog ();
         //RebuildLevelFinishedDialog ();
         CenterSpriteOnContentRegion (mLevelFinishedDialogLayer);
         CenterSpriteOnContentRegion (mHelpDialog);
         
         mFps = (stage == null ? 30 : stage.frameRate);
      }

      override protected function OnStartedChanged ():void
      {
         if (! mIsOverlay)
         {
            mRestartButton.alpha = IsStarted () ? 1.0 : 0.5;
            mRestartButton.buttonMode = IsStarted ();
         }
      }
      
      override protected function OnPlayingChanged ():void
      {
         if (! mIsOverlay)
         {
            mStartButton.visible = ! IsPlaying ();
            mPauseButton.visible = IsPlaying ();
         }
      }
      
      override protected function OnPlayingSpeedXChanged ():void
      {
         var speedX:int = GetPlayingSpeedX ();
         
         if (mIsOverlay)
         {
            if (mFasterButton_Overlay != null)
            {
               mFasterButton_Overlay.alpha = speedX >= 4 ? 0.5 : 1.0;
               mFasterButton_Overlay.buttonMode = speedX < 4;
            }
            
            if (mSlowerButton_Overlay != null)
            {
               mSlowerButton_Overlay.alpha = speedX <= 1 ? 0.5 : 1.0;
               mSlowerButton_Overlay.buttonMode = speedX > 1;
            }
         }
         else
         {
            if (mFasterButton != null)
            {
               mFasterButton.alpha = speedX >= 4 ? 0.5 : 1.0;
               mFasterButton.buttonMode = speedX < 4;
            }
            
            if (mSlowerButton != null)
            {
               mSlowerButton.alpha = speedX <= 1 ? 0.5 : 1.0;
               mSlowerButton.buttonMode = speedX > 1;
            }
         }
      }
      
      override protected function OnZoomScaleChanged ():void
      {
         var zoomScale:Number = GetZoomScale ();
         
         if (mIsOverlay)
         {
            if (mScaleOutButton_Overlay != null)
            {
               mScaleOutButton_Overlay.alpha = zoomScale <= Define.MinWorldZoomScale ? 0.5 : 1.0;
               mScaleOutButton_Overlay.buttonMode = zoomScale > Define.MinWorldZoomScale;
            }
            
            if (mScaleInButton_Overlay != null)
            {
               mScaleInButton_Overlay.alpha = zoomScale >= Define.MaxWorldZoomScale ? 0.5 : 1.0;
               mScaleInButton_Overlay.buttonMode = zoomScale < Define.MaxWorldZoomScale;
            }
         }
         else
         {
            if (mScaleOutButton != null)
            {
               mScaleOutButton.alpha = zoomScale <= Define.MinWorldZoomScale ? 0.5 : 1.0;
               mScaleOutButton.buttonMode = zoomScale > Define.MinWorldZoomScale;
            }
            
            if (mScaleInButton != null)
            {
               mScaleInButton.alpha = zoomScale >= Define.MaxWorldZoomScale ? 0.5 : 1.0;
               mScaleInButton.buttonMode = zoomScale < Define.MaxWorldZoomScale;
            }
         }
      }
      
      override protected function OnSoundEnabledChanged ():void
      {
         if (mIsOverlay)
         {
            if (mSoundOnButton_Overlay != null)
               mSoundOnButton_Overlay.visible = IsSoundEnabled ();
            if (mSoundOffButton_Overlay != null)
               mSoundOffButton_Overlay.visible = ! IsSoundEnabled ();
         }
         else
         {
            if (mSoundOnButton != null)
               mSoundOnButton.visible = IsSoundEnabled ();
            if (mSoundOffButton != null)
               mSoundOffButton.visible = ! IsSoundEnabled ();
         }
      }
      
      override protected function OnHelpDialogVisibleChanged ():void
      {
         if (IsHelpDialogVisible ())
            OnClickCloseLevelFinishedDialog (null);
         
         if (mHelpDialog == null)
         {
            if (IsHelpDialogVisible ())
               CreateHelpDialog ();
         
            if (mHelpDialog != null)
            {
               mHelpDialog.alpha = 0.0;
            }
         }
         else if (! IsHelpDialogVisible ())
         {
            if (mHelpDialog != null)
            {
               mHelpDialog.visible = false;
               mHelpDialog.alpha = 0.0;
            }
         }
      }
      
      override protected function OnLevelFinishedDialogVisibleChanged ():void
      {
         if (mHasLevelFinishedDialogEverOpened && IsLevelFinishedDialogVisible ())
         {
            SetLevelFinishedDialogVisible (false);
            return;
         }
         
         if (mLevelFinishedDialog == null)
         {
            if (IsLevelFinishedDialogVisible ())
               CreateLevelFinishedDialog ();
            
            if (mLevelFinishedDialog != null)
            {
               mLevelFinishedDialog.alpha = 0.0;
            }
         }
         else if (! IsLevelFinishedDialogVisible ())
         {
            if (mLevelFinishedDialog != null)
            {
               mLevelFinishedDialog.visible = IsLevelFinishedDialogVisible () && (! mHasLevelFinishedDialogEverOpened);
               mLevelFinishedDialog.alpha = 0.0;
            }
         }
      }
      
      //private var mFirstTimeDeactived:Boolean = true;
      private var mDeactivated:Boolean = false;
      private var mIsPlayingBeforeDeactivated:Boolean;
      override public function OnDeactivate ():void
      {
         mDeactivated = true;
         mIsPlayingBeforeDeactivated = true; //mFirstTimeDeactived ? true : IsPlaying ();
         //mFirstTimeDeactived = false;
         SetPlaying (false);
      }
      
      override public function GetFPS ():Number
      {
         return mFps;
      }
      
//======================================================================
//
//======================================================================

      private function OnActivate (data:Object = null):void
      {
         mDeactivated = false;
         SetPlaying (mIsPlayingBeforeDeactivated);
         
         mDeactivatedLayer.visible = false;
      }

      private function OnClickRestartForPlay (data:Object = null):void
      {
         Restart ();
         
         SetPlaying (true);
      }

      private function OnClickRestartForPause (data:Object = null):void
      {
         Restart ();
         
         SetPlaying (true);
      }
      
      private function OnClickRestart (data:Object = null):void
      {
         Restart ();
      }

      private function OnClickStart (data:Object = null):void
      {
         SetPlaying (true);
      }

      private function OnClickPause (data:Object = null):void
      {
         SetPlaying (false);
         
         if (! IsPlaying ())
         {
            TryToToggleInfosPanelVisibility ();
         }
      }
      
      private function OnClickFaster (data:Object):void
      {
         var speedX:int = GetPlayingSpeedX ();
         speedX = speedX < 1 ? 1 : speedX * 2;
         if (speedX > 4)
            speedX = 4;
         SetPlayingSpeedX (speedX);
      }

      private function OnClickSlower (data:Object):void
      {
         var speedX:int = GetPlayingSpeedX ();
         speedX = speedX / 2;
         if (speedX < 1)
            speedX = 1;
         SetPlayingSpeedX (speedX);
      }
      
      private function OnClickZoomIn (data:Object):void
      {
         SetZoomScale (GetZoomScale () * 2.0);
      }

      private function OnClickZoomOut (data:Object):void
      {
         SetZoomScale (GetZoomScale () * 0.5);
      }
      
      private function OnClickSoundOn (data:Object):void
      {
         SetSoundEnabled (false);
         
         //SetPlaying (true);
      }
      
      private function OnClickSoundOff (data:Object):void
      {
         SetSoundEnabled (true);
         
         //SetPlaying (true);
      }

      private function OnClickHelp (data:Object):void
      {
         SetHelpDialogVisible (true);
         
         SetPlaying (true);
      }

      private function OnClickCloseHelpDialog (data:Object):void
      {
         SetHelpDialogVisible (false);
      }

      private function OnClickCloseLevelFinishedDialog (data:Object):void
      {
         if (mLevelFinishedDialog != null)
            mHasLevelFinishedDialogEverOpened = true;
         
         SetLevelFinishedDialogVisible (false);
      }
      
      override public function CloseAllVisibleDialogs ():void
      {
         if (IsHelpDialogVisible ())
            OnClickCloseHelpDialog (null);
         
         if (IsLevelFinishedDialogVisible ())
            OnClickCloseLevelFinishedDialog (null);
      }

//======================================================================
// 
//======================================================================
      
      private var mPauseTimes:Array = new Array (0, 0, 0, 0, 0);
      private var mPausedIndex:int = 0;
      
      private var mTotalSteps:int = 0;
      private var mFpsSteps:int = 0;
      private var mFpsTime:Number = 0.0; 
      private var mFps:Number = 0.0;
      
      private var mInfosPanel:Sprite = null;
      private var mFpsText:TextField;
      
      private function TryToToggleInfosPanelVisibility ():void
      {
         var currentTime:Number = new Date ().getTime ();
         mPauseTimes [mPausedIndex] = currentTime;
         mPausedIndex = (mPausedIndex + 1) % mPauseTimes.length;
         if (currentTime - mPauseTimes [mPausedIndex] > 5000)
            return;
         
         for (var i:int = 0; i < mPauseTimes.length; ++ i)
            mPauseTimes [i] = 0;
         
         if (mInfosLayer.visible)
         {
            mInfosLayer.visible = false;
         }
         else
         {
            mInfosLayer.visible = true;
            
            if (mInfosPanel == null)
            {
               mInfosPanel = new Sprite ();
               mInfosLayer.addChild (mInfosPanel);
               mInfosLayer.mouseEnabled = false;
               mInfosLayer.mouseChildren = false;
                              
               mFpsText = new TextField ();

               mInfosPanel.addChild (mFpsText);
               mFpsText.mouseEnabled = false;
               
               mFpsText.autoSize = "left";
               mFpsText.textColor = 0x0;
               mFpsText.background = false;
               mFpsText.border = true;
               mFpsText.borderColor = 0x0;
               mFpsText.wordWrap = false;
                  //mFpsText.width = mViewerWidth / 2;
               mFpsText.selectable = false;
            }
            
            UpdateInfosPanel ();
         }
      }
      
      private function UpdateInfosPanel ():void
      {
         if (mInfosLayer.visible)
         {
            if (mInfosPanel != null)
            {
               mFpsText.htmlText = "FPS: " + mFps.toPrecision (3);
               
               GraphicsUtil.Clear (mInfosPanel);
               
               var bounds:Rectangle = mInfosPanel.getBounds (mInfosPanel);
               mInfosPanel.x = 0.5 * (mViewerWidth - bounds.width) + bounds.x;
               mInfosPanel.y = mViewerHeight - bounds.height - 3 + bounds.y;
               
               GraphicsUtil.DrawRect (mInfosPanel, bounds.x, bounds.y, bounds.width, bounds.height, 0x0, 1, true, 0xFFFFFF);
            }
         }
      }
      
//======================================================================
// 
//======================================================================
      
      private var mLastDeactivatedLayerSize:int = 0;
      private var mActivateButton:Sprite = null;
      
      private function UpdateDeactivatedLayer ():void
      {
         if (mDeactivated)
         {
            if (! mDeactivatedLayer.visible)
            {
               mDeactivatedLayer.alpha = 0.0;
               mDeactivatedLayer.visible = true;
            }
            
            var targetAlpha:Number = 0.83;
            
            //if (mDeactivatedLayer.alpha > targetAlpha)
            //   mDeactivatedLayer.alpha = targetAlpha;
            //else if (mDeactivatedLayer.alpha < targetAlpha - 0.05)
            //   mDeactivatedLayer.alpha += 0.05;
            
            if (mDeactivatedLayer.alpha < targetAlpha - 0.05 || mDeactivatedLayer.alpha > targetAlpha + 0.05)
               mDeactivatedLayer.alpha = targetAlpha;
            
            if (mActivateButton == null)
            {
               mActivateButton = CreateButton (0, mPlayButtonData, SkinDefault.DefaultButtonIconFilledColor, true, mIsTouchScreen, OnActivate);
               if (mActivateButton.width < 0.33 * mViewerWidth && mActivateButton.height < 0.33 * mViewerHeight)
               {
                  mActivateButton.scaleX *= 2.0;
                  mActivateButton.scaleY *= 2.0;
               }
               
               mDeactivatedLayer.addChild (mActivateButton);
            }
            
            var rightSize:int = (mViewerWidth << 16) | mViewerHeight;
            if (mLastDeactivatedLayerSize != rightSize)
            {
               mLastDeactivatedLayerSize = rightSize;
               
               GraphicsUtil.ClearAndDrawRect (mDeactivatedLayer, 0, 0, mViewerWidth, mViewerHeight, 0xFFFFFF, -1, true, 0xFFFFFF);
               
               mActivateButton.x = 0.5 * mViewerWidth;
               mActivateButton.y = 0.5 * mViewerHeight;
            }
         }
         else if (mDeactivatedLayer.visible)
         {
            mDeactivatedLayer.visible = false;
         }
      }

//======================================================================
//
//======================================================================

      private static const NumButtonSpeed:int = 5;
      private static const ButtonMargin:int = 5;
      
      // for overlay UI
      
         private var mHudLayerForPause:Sprite  = null;
            private var mStartButton_Overlay:Sprite;
            private var mRestartButtonForPause_Overlay:Sprite;
            private var mSoundOnButton_Overlay:Sprite;
            private var mSoundOffButton_Overlay:Sprite;
            private var mHelpButton_Overlay:Sprite;
            private var mExitButton_Overlay:Sprite;
         
         private var mHudLayerForPlay:Sprite;
            private var mPauseButton_Overlay:Sprite;
            private var mRestartButtonForPlay_Overlay:Sprite;
            private var mScaleOutButton_Overlay:Sprite;
            private var mScaleInButton_Overlay:Sprite;
            private var mFasterButton_Overlay:Sprite;
            private var mSlowerButton_Overlay:Sprite;
      
      // for top bar UI
      
         private var mPlayBar:Sprite = null;
            private var mPlayBarButtonLayer:Sprite;
               private var mStartButton:Sprite;
               private var mPauseButton:Sprite;
               private var mRestartButton:Sprite;
               private var mScaleOutButton:Sprite;
               private var mScaleInButton:Sprite;
               private var mFasterButton:Sprite;
               private var mSlowerButton:Sprite;
               private var mSoundOnButton:Sprite;
               private var mSoundOffButton:Sprite;
               private var mHelpButton:Sprite;
               private var mExitButton:Sprite;
      
      private function RebuildPlayBar (params:Object):void
      {
         var buttonX:Number;
         var buttonY:Number;
         
         var gap:Number = GetButtonGap ();
         
         mHudLayer.visible = IsShowPlayBar ();
         while (mHudLayer.numChildren > 0)
            mHudLayer.removeChildAt (0);
   
         if (mIsOverlay)
         {
            var margin:Number = GetMarginForOverlayUI ();
   
            // ...
            
            //{
               // visible button in playing
                        
               mHudLayerForPlay = new Sprite ();
               mHudLayerForPlay.alpha = 0.0;
               mHudLayerForPlay.visible = false;
               mHudLayer.addChild (mHudLayerForPlay);
               
               //{
                  // ...
                  
                  buttonX = margin;
                  buttonY = margin;
                  
                  mPauseButton_Overlay = CreateButton (0, mPauseButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickPause);
                  mPauseButton_Overlay.x = buttonX + 0.5 * mPauseButton_Overlay.width;
                  mPauseButton_Overlay.y = buttonY + 0.5 * mPauseButton_Overlay.height;
                  mHudLayerForPlay.addChild (mPauseButton_Overlay);
                  
                  buttonX += (mPauseButton_Overlay.width + gap);
                  
                  //mRestartButtonForPlay_Overlay = CreateButton (0, mRestartButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickRestartForPlay);
                  //mRestartButtonForPlay_Overlay.x = buttonX + 0.5 * mRestartButtonForPlay_Overlay.width;
                  //mRestartButtonForPlay_Overlay.y = buttonY + 0.5 * mRestartButtonForPlay_Overlay.height;
                  //mHudLayerForPlay.addChild (mRestartButtonForPlay_Overlay);
                  //
                  //buttonX += (mRestartButtonForPlay_Overlay.width + gap);
               
                  // ...
                  
                  buttonX = mViewerWidth - margin;
                  buttonY = margin;
                  
                  if (params.mShowScaleAdjustor)
                  {
                     mScaleOutButton_Overlay = CreateButton (0, mScaleOutButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickZoomOut);
                     mScaleOutButton_Overlay.x = buttonX - 0.5 * mScaleOutButton_Overlay.width;
                     mScaleOutButton_Overlay.y = buttonY + 0.5 * mScaleOutButton_Overlay.height;
                     mHudLayerForPlay.addChild (mScaleOutButton_Overlay);
                     
                     buttonX -= (mScaleOutButton_Overlay.width + gap);
                     
                     mScaleInButton_Overlay = CreateButton (0, mScaleInButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickZoomIn);
                     mScaleInButton_Overlay.x = buttonX - 0.5 * mScaleInButton_Overlay.width;
                     mScaleInButton_Overlay.y = buttonY + 0.5 * mScaleInButton_Overlay.height;
                     mHudLayerForPlay.addChild (mScaleInButton_Overlay);
                     
                     buttonX -= (mScaleInButton_Overlay.width + gap);
                  }
                  
                  if (params.mShowSpeedAdjustor)
                  {
                     mFasterButton_Overlay = CreateButton (0, mFasterButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickFaster);
                     mFasterButton_Overlay.x = buttonX - 0.5 * mFasterButton_Overlay.width;
                     mFasterButton_Overlay.y = buttonY + 0.5 * mFasterButton_Overlay.height;
                     mHudLayerForPlay.addChild (mFasterButton_Overlay);
                     
                     buttonX -= (mFasterButton_Overlay.width + gap);
                     
                     mSlowerButton_Overlay = CreateButton (0, mSlowerButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickSlower);
                     mSlowerButton_Overlay.x = buttonX - 0.5 * mSlowerButton_Overlay.width;
                     mSlowerButton_Overlay.y = buttonY + 0.5 * mSlowerButton_Overlay.height;
                     mHudLayerForPlay.addChild (mSlowerButton_Overlay);
                     
                     buttonX -= (mSlowerButton_Overlay.width + gap);
                  }
               //}
               
               // visible buttons when paused
               
               mHudLayerForPause = new Sprite ();
               mHudLayer.addChild (mHudLayerForPause);
               mHudLayerForPause.alpha = 0.0;
               mHudLayerForPause.visible = false;
               
               //{
                  // ...
               
                  buttonX = margin;
                  buttonY = margin;
      
                  mStartButton_Overlay = CreateButton (0, mPlayButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickStart);
                  mStartButton_Overlay.x = buttonX + 0.5 * mStartButton_Overlay.width;
                  mStartButton_Overlay.y = buttonY + 0.5 * mStartButton_Overlay.height;
                  mHudLayerForPause.addChild (mStartButton_Overlay);
                  
                  buttonX += (mStartButton_Overlay.width + gap);
                  
                  mRestartButtonForPause_Overlay = CreateButton (0, mRestartButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickRestartForPause);
                  mRestartButtonForPause_Overlay.x = buttonX + 0.5 * mRestartButtonForPause_Overlay.width;
                  mRestartButtonForPause_Overlay.y = buttonY + 0.5 * mRestartButtonForPause_Overlay.height;
                  mHudLayerForPause.addChild (mRestartButtonForPause_Overlay);
                  
                  buttonX += (mRestartButtonForPause_Overlay.width + gap);
                  
                  // ...
                  
                  buttonX = mViewerWidth - margin;
                  buttonY = margin;
                  
                  if (params.mShowHelpButton)
                  {
                     mHelpButton_Overlay = CreateButton (0, mHelpButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickHelp);
                     mHelpButton_Overlay.x = buttonX - 0.5 * mHelpButton_Overlay.width;
                     mHelpButton_Overlay.y = buttonY + 0.5 * mHelpButton_Overlay.height;
                     mHudLayerForPause.addChild (mHelpButton_Overlay);
                     
                     buttonX -= (mHelpButton_Overlay.width + gap);
                  }
               
                  // ...
                  
                  if (_OnExitLevel == null)
                  {
                     if (params.mShowSoundController)
                     {
                        mSoundOnButton_Overlay = CreateButton (0, mSoundOnButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickSoundOn);
                        mSoundOnButton_Overlay.x = buttonX - 0.5 * mSoundOnButton_Overlay.width;
                        mSoundOnButton_Overlay.y = buttonY + 0.5 * mSoundOnButton_Overlay.height;
                        mHudLayerForPause.addChild (mSoundOnButton_Overlay);
                        
                        buttonX -= (mSoundOnButton_Overlay.width + gap);
                     }
                  }
                  else
                  {
                     buttonX = mViewerWidth - margin;
                     buttonY = mViewerHeight - margin;
                     
                     if (params.mShowSoundController)
                     {
                        mSoundOnButton_Overlay = CreateButton (0, mSoundOnButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickSoundOn);
                        mSoundOnButton_Overlay.x = buttonX - 0.5 * mSoundOnButton_Overlay.width;
                        mSoundOnButton_Overlay.y = buttonY - 0.5 * mSoundOnButton_Overlay.height;
                        mHudLayerForPause.addChild (mSoundOnButton_Overlay);
                        
                        buttonX -= (mSoundOnButton_Overlay.width + gap);
                     }
                     
                     // ...
                     
                     buttonX = margin;
                     buttonY = mViewerHeight - margin;
               
                     mExitButton_Overlay = CreateButton (0, mHasMainMenu ? mMenuButtonData : mBackButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnExitLevel);
                     mExitButton_Overlay.x = buttonX + 0.5 * mExitButton_Overlay.width;
                     mExitButton_Overlay.y = buttonY - 0.5 * mExitButton_Overlay.height;
                     mHudLayerForPause.addChild (mExitButton_Overlay);
                     
                     buttonX += (mExitButton_Overlay.width + gap);
                  }
                  
                  // ...
                  
                  if (params.mShowSoundController)
                  {
                     mSoundOffButton_Overlay = CreateButton (0, mSoundOffButtonData, SkinDefault.DefaultButtonIconFilledColor, mIsOverlay, mIsTouchScreen, OnClickSoundOff);
                     mSoundOffButton_Overlay.x = mSoundOnButton_Overlay.x;
                     mSoundOffButton_Overlay.y = mSoundOnButton_Overlay.y;
                     mSoundOffButton_Overlay.visible = false;
                     mHudLayerForPause.addChild (mSoundOffButton_Overlay);
                  }
               //}
            //}
         }
         else
         {
            mPlayBar = new Sprite ();
            GraphicsUtil.ClearAndDrawRect (mPlayBar, 0, 0, mViewerWidth, PlayBarHeight, 
                                                     params.mPlayBarColor, 1, true, params.mPlayBarColor);
            mHudLayer.addChild (mPlayBar);
            
            mPlayBarButtonLayer = new Sprite ();
            mPlayBar.addChild (mPlayBarButtonLayer);
            
            buttonX = 0;
            
            mRestartButton = CreateButton (1, mRestartButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickRestart);
            mRestartButton.x = buttonX ;
            mPlayBarButtonLayer.addChild (mRestartButton);
            
            buttonX += (mRestartButton.width + 1);
            
            mStartButton = CreateButton (1, mPlayButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickStart);
            mStartButton.x = buttonX;
            mPlayBarButtonLayer.addChild (mStartButton);
            
               mPauseButton = CreateButton (1, mPauseButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickPause);
               mPauseButton.x = buttonX;
               mPauseButton.visible = false;
               mPlayBarButtonLayer.addChild (mPauseButton);
            
            buttonX += (mStartButton.width + gap);
            
            if (params.mShowSpeedAdjustor)
            {  
               mSlowerButton = CreateButton (1, mSlowerButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickSlower);
               mSlowerButton.x = buttonX;
               mPlayBarButtonLayer.addChild (mSlowerButton);
               
               buttonX += (mSlowerButton.width + 1);
               
               mFasterButton = CreateButton (1, mFasterButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickFaster);
               mFasterButton.x = buttonX;
               mPlayBarButtonLayer.addChild (mFasterButton);
               
               buttonX += (mFasterButton.width + gap);
            }
            
            if (params.mShowScaleAdjustor)
            {  
               mScaleInButton = CreateButton (1, mScaleInButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickZoomIn);
               mScaleInButton.x = buttonX;
               mPlayBarButtonLayer.addChild (mScaleInButton);
               
               buttonX += (mScaleInButton.width + 1);
               
               mScaleOutButton = CreateButton (1, mScaleOutButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickZoomOut);
               mScaleOutButton.x = buttonX;
               mPlayBarButtonLayer.addChild (mScaleOutButton);
               
               buttonX += (mScaleOutButton.width + gap);
            }
            
            if (params.mShowSoundController)
            {
               mSoundOnButton = CreateButton (1, mSoundOnButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickSoundOn);
               mSoundOnButton.x = buttonX;
               mPlayBarButtonLayer.addChild (mSoundOnButton);
               
                  mSoundOffButton = CreateButton (1, mSoundOffButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickSoundOff);
                  mSoundOffButton.x = buttonX;
                  mSoundOffButton.visible = false;
                  mPlayBarButtonLayer.addChild (mSoundOffButton);
               
               buttonX += (mSoundOnButton.width + gap);
            }
            
            if (_OnExitLevel == null)
            {
               if (params.mShowHelpButton)
               {
                  mHelpButton = CreateButton (1, mHelpButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickHelp);
                  mHelpButton.x = buttonX;
                  mPlayBarButtonLayer.addChild (mHelpButton);
                  
                  buttonX += (mHelpButton.width + gap);
               }
            }
            else
            {
               if (params.mShowHelpButton)
               {
                  mHelpButton = CreateButton (1, mHelpButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnClickHelp);
                  mHelpButton.x = mViewerWidth - gap - 0.5 * mHelpButton.width;
                  mHelpButton.y = 0.5 * PlayBarHeight;
                  mPlayBar.addChild (mHelpButton);
               }
               
               mExitButton = CreateButton (1, mHasMainMenu ? mMenuButtonData : mBackButtonData, SkinDefault.DefaultButtonIconFilledColor, false, false, OnExitLevel);
               mExitButton.x = gap + 0.5 * mExitButton.width;
               mExitButton.y = 0.5 * PlayBarHeight;
               mPlayBar.addChild (mExitButton);
            }
            
            //
            var bounds:Rectangle = mPlayBarButtonLayer.getBounds (mPlayBarButtonLayer);
            mPlayBarButtonLayer.x = 0.5 * (mViewerWidth  - mPlayBarButtonLayer.scaleX * bounds.width ) - mPlayBarButtonLayer.scaleX * bounds.x;
            mPlayBarButtonLayer.y = 0.5 * (PlayBarHeight - mPlayBarButtonLayer.scaleY * bounds.height) - mPlayBarButtonLayer.scaleY * bounds.y;
         }
         
         UpdateDeactivatedLayer ();
         
         OnPlayingChanged ();
         OnPlayingSpeedXChanged ();
         OnZoomScaleChanged ();
         OnSoundEnabledChanged ();
      }
      
//======================================================================
//
//======================================================================

      private function GetPreferredDialogWidth ():Number
      {  
         var w:Number;
         
         if (mIsTouchScreen)
         {
            w = 4.0 * GetPreferredButtonSize (true, true) + 2.0 * GetButtonGap ();
            if (w > mViewerWidth * 0.75)
               w = mViewerWidth * 0.75;
         }
         else
         {
            w = mViewerWidth * 0.75;
            if (w > 350)
               w = 350;
         }
         
         return w;
      }
      
      private function GetMarginForOverlayUI ():Number
      {
         if (mIsTouchScreen)
         {
            var viewerSize:Number = mViewerWidth < mViewerHeight ? mViewerWidth : mViewerHeight;
            
            return 10.0 * viewerSize / 320.0;
         }
         else
            return 16.0;
      }
      
      private function GetButtonGap ():Number
      {
         if (mIsTouchScreen)
         {
            var viewerSize:Number = mViewerWidth < mViewerHeight ? mViewerWidth : mViewerHeight;
            
            return 4.0 * viewerSize / 320.0;
         }
         else
            return 6.0;
      }

//======================================================================
//
//======================================================================

      private var mLevelFinishedDialog:Sprite = null;
      
      private function OnClickNextLevel (data:Object):void
      {
         if (_OnNextLevel != null)
            _OnNextLevel ();
      }
      
      private function OnClickExitLevel (data:Object):void
      {
         if (_OnExitLevel != null)
            _OnExitLevel ();
      }

      private function CreateLevelFinishedDialog ():void
      {
         if (mLevelFinishedDialog != null && mLevelFinishedDialog.parent == mLevelFinishedDialogLayer)
            mLevelFinishedDialogLayer.removeChild (mLevelFinishedDialog);
         
         // ...
         
         var buttons:Array = new Array ();
         
         var margin:Number = GetMarginForOverlayUI ();
         var gap:Number = GetButtonGap ();
         
         var buttonX:Number = 0;
         
         if (_OnExitLevel != null && mHasMainMenu)
         {
            var exitButton:Sprite = CreateButton (0, mMenuButtonData, SkinDefault.DefaultButtonIconFilledColor, true, mIsTouchScreen, OnClickExitLevel);
            exitButton.x = buttonX + 0.5 * exitButton.width;
            buttons.push (exitButton);
            buttons.push (gap);
            
            buttonX += (exitButton.width + margin);
         }
         else
         {
            var replayButton:Sprite = CreateButton (0, mRestartButtonData, SkinDefault.DefaultButtonIconFilledColor, true, mIsTouchScreen, OnClickRestartForPlay);
            replayButton.x = buttonX + 0.5 * replayButton.width;
            buttons.push (replayButton);
            buttons.push (gap);
            
            buttonX += (replayButton.width + margin);
         }
         
         var closeButton:Sprite = CreateButton (0, mCloseButtonData, SkinDefault.DefaultButtonIconFilledColor, true, mIsTouchScreen, OnClickCloseLevelFinishedDialog);
         closeButton.x = buttonX + 0.5 * closeButton.width;
         buttons.push (closeButton);
         
         buttonX += (closeButton.width + margin);
         
         if (_OnNextLevel != null && mHasNextLevel)
         {
            var nextLevelButton:Sprite = CreateButton (0, mNextLevelButtonData, SkinDefault.DefaultButtonIconFilledColor, true, mIsTouchScreen, OnClickNextLevel);
            nextLevelButton.x = buttonX + 0.5 * nextLevelButton.width;
            buttons.push (gap);
            buttons.push (nextLevelButton);
            
            buttonX += (nextLevelButton.width + margin);
         }
         
         // ...
         
         var levelFinishedString:String = "<p align='center'><font size='30' face='Verdana' color='#000000'> <b>Cool! It is solved.</b></font></p>";
         var levelFinishedText:TextFieldEx = TextFieldEx.CreateTextField (levelFinishedString, false, 0xFFFFFF, 0x0, true, GetPreferredDialogWidth ());
         
         // ...
         
         var referLinkString:String = "<p align='center'><font face='Verdana' size='13'><font color='#0000FF'><u><a href='http://www.phyard.com/?from=complete_dialog' target='_blank'>Have interest making your own games?</a></u></font></font></p>";

         var referLinkTextField:TextFieldEx = TextFieldEx.CreateTextField (referLinkString, false, 0xFFFFFF, 0x0, true, GetPreferredDialogWidth ());

         // ...
         
         mLevelFinishedDialog = CreateDialog ([levelFinishedText, 20, referLinkTextField], buttons);
         mLevelFinishedDialogLayer.addChild (mLevelFinishedDialog);
         CenterSpriteOnContentRegion (mLevelFinishedDialogLayer);
         mLevelFinishedDialog.alpha = 0.01;
      }

//======================================================================
//
//======================================================================

      private var mHelpDialog:Sprite = null;

      private function CreateHelpDialog ():void
      {
         if (mHelpDialog != null && mHelpDialog.parent == mHelpDialogLayer)
            mHelpDialogLayer.removeChild (mHelpDialog);

         // ...
                  
         var tutorialText:String = 
            "<font size='15' face='Verdana' color='#000000'>The goal of <b>Color Infection</b> puzzles is to infect all <font color='#FFFF00'><b>YELLOW</b></font> objects with "
                        + "the <font color='#804000'><b>BROWN</b></font> color by colliding them with <font color='#804000'><b>BROWN</b></font> objects "
                        + "but keep all <font color='#60FF60'><b>GREEN</b></font> objects uninfected."
                        + "<br /><br />To play, click a <font color='#FF00FF'><b>PINK</b></font> object to destroy it or click a <font color='#000000'><b>BOMB</b></font> object to explode it."
                        + "</font>";
         
         var textTutorial:TextFieldEx = TextFieldEx.CreateTextField (tutorialText, false, 0xFFFFFF, 0x0, true, GetPreferredDialogWidth ());
         
         var mOkButton:Sprite = CreateButton (0, mOkButtonData, SkinDefault.DefaultButtonIconFilledColor, true, mIsTouchScreen, OnClickCloseHelpDialog);
         
         // ...
       
         mHelpDialog = CreateDialog ([textTutorial], [mOkButton]);
         mHelpDialogLayer.addChild (mHelpDialog);
         CenterSpriteOnContentRegion (mHelpDialog);
      }

//======================================================================
//
//======================================================================

      protected function CenterSpriteOnContentRegion (sprite:Sprite):void
      {
         if (sprite != null)
         {
            var contentRegion:Rectangle = GetContentRegion ();
            
            var spriteBounds:Rectangle = sprite.getBounds (sprite);
            
            sprite.x = contentRegion.x + 0.5 * (contentRegion.width  - spriteBounds.width  * sprite.scaleX) - spriteBounds.x * sprite.scaleX;
            sprite.y = contentRegion.y + 0.5 * (contentRegion.height - spriteBounds.height * sprite.scaleY) - spriteBounds.y * sprite.scaleY;
         }
      }
      
      //
      public static function CreateDialog (components:Array, buttons:Array):Sprite
      {
         var dialog:Sprite = new Sprite ();
         
         var sprite:DisplayObject;
         var bounds:Rectangle;
         var i:int;
         
         // ...
         
         var verticalMargin:int = 20;
         
         var dialogWidth:Number = 0;
         var dialogHeight:Number = verticalMargin;
         
         for (i = 0; i < components.length; ++ i)
         {
            if (components [i] is DisplayObject)
            {
               sprite = components [i] as DisplayObject;
               bounds = sprite.getBounds (sprite);
               
               sprite.y = dialogHeight - bounds.y * sprite.scaleY;
               
               if (sprite.width > dialogWidth)
                  dialogWidth = sprite.width;
               dialogHeight += sprite.height;
               
               dialog.addChild (sprite);
            }
            else
            {
               dialogHeight += components [i];
            }
         }
         
         dialogWidth += verticalMargin + verticalMargin;
         dialogHeight += verticalMargin;
         
         // ...
         
         var buttonPanel:Sprite = null;
         
         var maxButtonHeight:Number = 0;
         var buttonX:Number = 0;
         
         if (buttons != null)
         {
            buttonPanel = new Sprite ();
            
            for (i = 0; i < buttons.length; ++ i)
            {
               if (buttons [i] is DisplayObject)
               {
                  sprite = buttons [i] as DisplayObject;
                  bounds = sprite.getBounds (sprite);
                  
                  sprite.y = - 0.5 * sprite.height - bounds.y * sprite.scaleY;
                  sprite.x = buttonX;
                  buttonX += sprite.width;
                  
                  if (sprite.height > maxButtonHeight)
                     maxButtonHeight = sprite.height;
                  
                  buttonPanel.addChild (sprite);
               }
               else
               {
                  buttonX += buttons [i];
               }
            }
         }
         
         if (buttonPanel != null && buttonPanel.numChildren > 0)
         {
            dialog.addChild (buttonPanel);
            dialogHeight += 0.5 * buttonPanel.height;
            
            if (buttonPanel.numChildren > 1)
            {
               //var preferredWidth:Number = dialogWidth - maxButtonHeight - maxButtonHeight;
               var preferredWidth:Number = 0.75 * dialogWidth;
               var buttonsWidth:Number = buttonPanel.width - maxButtonHeight;
               if (buttonsWidth > 0 && preferredWidth > 0 && buttonsWidth < preferredWidth)
               {
                  var xPosScale:Number = preferredWidth / buttonsWidth;
                  for (i = 0; i < buttonPanel.numChildren; ++ i)
                  {
                     sprite = buttonPanel.getChildAt (i);
                     sprite.x *= xPosScale;
                  }
               }
            }
         }
         
         // ...
         
         var bg:Sprite = new Sprite ();
         GraphicsUtil.DrawRect (bg, 0, 0, dialogWidth, dialogHeight, 
                                0x606060, 5, true, 0xB0B0D0, //0x8080D0,
                                false, true, 16);
            // shape:Object, x:Number, y:Number, w:Number, h:Number, 
            // borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFFF, 
            // roundJoints:Boolean = false, roundCorners:Boolean = false, cornerRadius:Number = 1.0
         dialog.addChildAt (bg, 0);
         
         for (i = 0; i < components.length; ++ i)
         {
            if (components [i] is DisplayObject)
            {
               sprite = components [i] as DisplayObject;
               bounds = sprite.getBounds (sprite);
               
               sprite.x = (dialogWidth - sprite.width) * 0.5 - bounds.x * sprite.scaleX;
            }
         }
         
         // ...
         
         if (buttonPanel != null && buttonPanel.numChildren > 0)
         {
            bounds = buttonPanel.getBounds (buttonPanel);
            if (buttonPanel.numChildren == 1)
            {
               sprite = buttonPanel.getChildAt (0);
               //if (sprite.x < dialogWidth - sprite.width)
               //{
               //   sprite.x = dialogWidth - sprite.width;
               //}
               if (sprite.x < dialogWidth * 0.875)
                  sprite.x = dialogWidth * 0.875;
               
               buttonPanel.x = 0.0;
            }
            else
            {  
               buttonPanel.x = 0.5 * (dialogWidth - buttonPanel.width * buttonPanel.scaleX) - bounds.x * buttonPanel.scaleX;
            }
            
            buttonPanel.y = dialogHeight - 0.5 * buttonPanel.height * buttonPanel.scaleY - bounds.y * buttonPanel.scaleY;
         }
         
         // ...
         
         return dialog;
      }

//======================================================================
//
//======================================================================

      public static const mPlayButtonData:Array = [
         [3,
             8,  0.0,
            -5, -12, 
            -5,  12,
         ],
      ];
      
      public static const mPauseButtonData:Array = [
         [3,
           -11, -12, 
           -11,  12,
            -4,  12,
            -4, -12,
         ],
         [3,
             4, -12, 
             4,  12,
            11,  12,
            11, -12,
         ],
      ];
      
      protected static var mRestartButtonData:Array = [
         [3,
             -11, -12,
             -11,  12,
              -7,  12,
              -7, -12,
         ],
         [3,
             -4, 0.0, 
             10,  12,
             10, -12,
         ],
      ];
      
      protected static var mMenuButtonData:Array = [
         [3,
             -15, -12, 
             -15, -8,
             -11, -8,
             -11, -12,
         ],
         [3,
             -8, -12,
             -8, -8,
             15, -8,
             15, -12,
         ],
         [3,
             -15, -2, 
             -15,  2,
             -11,  2,
             -11, -2,
         ],
         [3,
             -8, -2,
             -8,  2,
             15,  2,
             15, -2,
         ],
         [3,
             -15,  8, 
             -15, 12,
             -11, 12,
             -11,  8,
         ],
         [3,
             -8,  8,
             -8, 12,
             15, 13,
             15,  8,
         ],
      ];
      
      public static const mSoundOnButtonData:Array = [
         [3,
             -15,   5,
              -9,   5,
              -3,  11,
              -1,  11,
              -1, -11,
              -3, -11,
              -9,  -5,
             -15,  -5, 
         ],
         [2 | (3 << 8),
              4, -9,
             13,  0, // control point
              4,  9,
         ],
         [2 | (3 << 8),
              9,  14,
             22,   0, // control point
              9, -14,
         ],
      ];
      
      public static const mSoundOffButtonData:Array = [
         [3,
             -15,   5,
              -9,   5,
              -3,  11,
              -1,  11,
              -1, -11,
              -3, -11,
              -9,  -5,
             -15,  -5, 
         ],
         [1 | (3 << 8),
              6, -4,
             14,  4,
         ],
         [1 | (3 << 8),
              6,  4, 
             14, -4,
         ],
      ];
      
      public static const mExitAppButtonData:Array = [
         [3,
              5, -5,
              1,  0,
              5,  5,
              5,  3,
             11,  3,
             11, -3,
              5, -3,
         ],
         [1 | (3 << 8),
               9,  -6, 
               9, -16,
             -10, -16,
             -10,  16,
               9,  16,
               9,   6,
         ],
      ];
      
      public static const mBackButtonData:Array = [
         [1 | (5 << 8),
              -11,  -5,
              -11,  11,
         ],
         [1 | (5 << 8),
                5, 11,
              -11, 11,
         ],
         [1 | (5 << 8),
               10, -10,
              -11, 11,
         ],
      ];
      
      public static const mNextLevelButtonData:Array = [
         [1 | (5 << 8),
                0, 10,
               14,  0,
         ],
         [1 | (5 << 8),
                0, -10,
               14,   0,
         ],
         [1 | (5 << 8),
              -14, 0,
               14, 0,
         ],
      ];
      
      public static const mHelpButtonData:Array = [
         [3,
              -6,  -4,
             -10,  -4,
             -10, -14,
              11, -14,
              11,   2,
               3,   2,
               3,   8,
              -2,   8,
              -2,  -2,
               7,  -2,
               7, -10,
              -6, -10,
         ],
         [3,
              -2, 11,
               3, 11,
               3, 16,
              -2, 16,
         ],
      ];
      
      public static const mSlowerButtonData:Array = [
         [3,
              -2,  -1,
               9, -12,
               9,  12,
              -2,   1,
              -2,  12,
             -14,   0,
              -2, -12,
         ],
      ];
      
      public static const mFasterButtonData:Array = [
         [3,
               2,  -1,
              -9, -12,
              -9,  12,
               2,   1,
               2,  12,
              14,   0,
               2, -12,
         ],
      ];
      
      //public static const mScaleInButtonData:Array = [
      //   [1 | (5 << 8),
      //        -7, 0,
      //         7, 0,
      //   ],
      //   [1 | (5 << 8),
      //         0, -7,
      //         0,  7,
      //   ],
      //   [0 | (5 << 8),
      //        0, 0, 13, 0, // x, y, radius, filled
      //   ],
      //];
      //
      //public static const mScaleOutButtonData:Array = [
      //   [1 | (5 << 8),
      //        -7, 0,
      //         7, 0,
      //   ],
      //   [0 | (5 << 8),
      //        0, 0, 13, 0, // x, y, radius, filled
      //   ],
      //];
      
      public static const mScaleInButtonData:Array = [
         [3,
              -12,  -2,
              -12,   2,
               -2,   2,
               -2,  12,
                2,  12,
                2,   2,
               12,   2,
               12,  -2,
                2,  -2,
                2, -12,
               -2, -12,
               -2,  -2,
         ],
      ];
      
      public static const mScaleOutButtonData:Array = [
         [3,
              -12, -2,
              -12,  2,
               12,  2,
               12, -2,
         ],
      ];
      
      public static const mOkButtonData:Array = [
         [3,
               -4,   5,
               -9,  -2,
              -16,   3, 
               -4,  14,
               16,  -6,
               10, -12,
         ],
      ];
      
      public static const mCloseButtonData:Array = [
         [3,
               6,   0,
              12,   6,
               6,  12,
               0,   6,
              -6,  12,
             -12,   6,
              -6,   0,
             -12,  -6,
              -6, -12,
               0,  -6,
               6, -12,
              12,  -6,
         ],
      ];
      
      public static const mLockButtonData:Array = [
         [1 | (3 << 8),
              -10,  -3, 
              -10, -10,
         ],
         [2 | (3 << 8),
              -10, -10,
                0, -22, // control point
               10, -10,
         ],
         [1 | (3 << 8),
               10,  -3, 
               10, -10,
         ],
         [3,
              -15,  -2,
               15,  -2,
               15,  16,
              -15,  16,
         ],
      ];
      
      public static const DefaultButtonBaseRadius:Number = 26.0;
      public static const DefaultButtonBaseHalfSize:Number = 20.0;
      public static const DefaultButtonBaseFilledColor:uint = 0x61a70e;
      public static const DefaultButtonBaseBorderThickness:Number = 5.0;
      public static const DefaultButtonBaseBorderColor:uint = 0x50e61d;
      public static const DefaultButtonIconFilledColor:uint = 0xff0000;
      
      private static function ShapeDataToPointArray (shapeData:Array):Array
      {
         var numPoints:int = shapeData.length / 2;
         var points:Array = new Array (numPoints);
         var index:int = 1;
         for (var i:int = 0; i < numPoints; ++ i)
         {
            points [i] = new Point (shapeData [index ++], shapeData [index ++]);
         }
         
         return points;
      }

      public static function CreateButton (baseShapeType:int, buttonData:Array, iconColor:uint, isOverlay:Boolean, isTocuhScreen:Boolean, onClickHandler:Function = null):Sprite
      {
         var baseShape:Shape = null;
         
         if (baseShapeType >= 0)
         {
            baseShape = new Shape ();
            if (baseShapeType == 0) // circle
            {
               GraphicsUtil.DrawCircle (baseShape, 0, 0, DefaultButtonBaseRadius, DefaultButtonBaseFilledColor, DefaultButtonBaseBorderThickness, true, DefaultButtonBaseBorderColor);
            }
            else // rectangle
            {
               //GraphicsUtil.DrawRect (baseShape, 
               //                     - DefaultButtonBaseHalfSize, - DefaultButtonBaseHalfSize, DefaultButtonBaseHalfSize + DefaultButtonBaseHalfSize, DefaultButtonBaseHalfSize + DefaultButtonBaseHalfSize, 
               //                     DefaultButtonBaseFilledColor, DefaultButtonBaseBorderThickness, true, DefaultButtonBaseBorderColor);
               GraphicsUtil.DrawRect (baseShape, 
                                    - DefaultButtonBaseHalfSize, - DefaultButtonBaseHalfSize, DefaultButtonBaseHalfSize + DefaultButtonBaseHalfSize, DefaultButtonBaseHalfSize + DefaultButtonBaseHalfSize, 
                                    DefaultButtonBaseFilledColor, -1, true, DefaultButtonBaseBorderColor);
            }
         }
         
         var iconShape:Shape = new Shape ();
         for (var i:int = 0; i < buttonData.length; ++ i)
         {
            var shapeData:Array = buttonData [i] as Array;
            
            var shapeTyle:int = (shapeData [0] >> 0) & 0xFF;
            var thickness:Number = (shapeData [0] >> 8) & 0xFF;
             
            switch (shapeTyle)
            {
               case 0: // circle
                  GraphicsUtil.DrawCircle (iconShape, shapeData [1], shapeData[2], shapeData[3], iconColor, thickness, shapeData[4] != 0, iconColor);
                  break;
               case 1: // polyline
                  GraphicsUtil.DrawPolyline (iconShape, ShapeDataToPointArray (shapeData), iconColor, thickness, true, false);
                  break;
               case 2: // curve
                  iconShape.graphics.lineStyle(thickness, iconColor);
                  iconShape.graphics.moveTo(shapeData [1], shapeData[2]);
                  iconShape.graphics.curveTo(shapeData[3], shapeData[4], shapeData[5], shapeData[6]);
                  break;
               case 3: // polygon
                  GraphicsUtil.DrawPolygon (iconShape, ShapeDataToPointArray (shapeData), 0x0, -1, true, iconColor);
                  break;
               default:
                  break;
            }
         }
         
         var button:Sprite = new Sprite;
         if (baseShape != null)
            button.addChild (baseShape);
         button.addChild (iconShape);
         
         // ...
         
         if (onClickHandler != null)
         {
            button.buttonMode = true;
            button.addEventListener (MouseEvent.MOUSE_DOWN, onClickHandler);
         }
         
         ScaleButton (button, isOverlay, isTocuhScreen);
         
         return button;
      }
      
      private static function ScaleButton (button:Sprite, isOverlay:Boolean, isTocuhScreen:Boolean):void
      {
         button.scaleX = button.scaleY = GetPreferredButtonSize (isOverlay, isTocuhScreen) / button.width;
      }
      
      private static function GetPreferredButtonSize (isOverlay:Boolean, isTocuhScreen:Boolean):Number
      {
         // should be xonsitent with Game.as
         
         if (isTocuhScreen)
            return Capabilities.screenDPI * 0.32; // 0.32 inches
         else if (isOverlay)
            return 32.0;
         else
            return 16.0;
      }
      
   }
}
