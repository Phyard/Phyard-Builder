package viewer {

   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.events.Event;
   import flash.events.MouseEvent;

   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;

   import common.Define;

   public class SkinSmallScreen extends Skin
   {

//======================================================================
//
//======================================================================
      
      private var mPlayBarLayer:Sprite = new Sprite ();
      private var mHelpDialogLayer:Sprite = new Sprite ();
      private var mLevelFinishedDialogLayer:Sprite = new Sprite ();
      
      public function SkinSmallScreen (params:Object)
      {
         super (params);
         
         addChild (mPlayBarLayer);
         addChild (mHelpDialogLayer);
         addChild (mLevelFinishedDialogLayer);
      }
      
      private function GetPlayBarWidth ():Number
      {
         return 3.0 * DefaultButtonBaseHalfSize;
      }
      
      private function GetSkinScale ():Number
      {
         return mViewerHeight / 320.0;
      }
      
      override public function GetPreferredViewerSize (viewportWidth:Number, viewportHeight:Number):Point
      {
         return new Point (viewportWidth, viewportHeight);
      }
      
      override public function GetContentRegion ():Rectangle
      {
         return new Rectangle (0, 0, mViewerWidth, mViewerHeight);
      }
      
      override public function Update (dt:Number):void
      {
         if (mLevelFinishedDialog != null)
         {
            if (mLevelFinishedDialog.visible)
            {
               if (mLevelFinishedDialog.alpha < 1.0) mLevelFinishedDialog.alpha += 0.02;
            }
            else
            {
               if (mLevelFinishedDialog.alpha > 0.0) mLevelFinishedDialog.alpha -= 0.02;
            }
         }
         
         var fadingSpeed:Number = 0.05;
         
         if (IsPlaying ())
         {
            mHubButtonContainer.visible = true;
            if (mHubButtonContainer.alpha < 0.5)
               mHubButtonContainer.alpha += fadingSpeed;
            if (mHubButtonContainer.alpha > 0.5)
               mHubButtonContainer.alpha = 0.5;
            
            if (mPlayBar.alpha > 0.0)
               mPlayBar.alpha -= fadingSpeed;
            if (mPlayBar.alpha <= 0.0)
            {
               mPlayBar.alpha = 0.0;
               mPlayBar.visible = false;
            }
         }
         else
         {
            mPlayBar.visible = true;
            if (mPlayBar.alpha < 1.0)
               mPlayBar.alpha += fadingSpeed;
            if (mPlayBar.alpha >= 1.0)
               mPlayBar.alpha = 1.0;
            
            if (mHubButtonContainer.alpha > 0.0)
               mHubButtonContainer.alpha -= fadingSpeed;
            if (mHubButtonContainer.alpha <= 0.0)
            {
               mHubButtonContainer.alpha = 0.0;
               mHubButtonContainer.visible = false;
            }
         }
      }
      
      override public function Rebuild (params:Object):void
      {
         RebuildPlayBar (params);
         //RebuildHelpDialog ();
         //RebuildLevelFinishedDialog ();
         CenterSpriteOnContentRegion (mLevelFinishedDialogLayer);
         CenterSpriteOnContentRegion (mHelpDialog);
      }

      override protected function OnStartedChanged ():void
      {
      }
      
      override protected function OnPlayingChanged ():void
      {
      }
      
      override protected function OnPlayingSpeedXChanged (oldSpeedX:int):void
      {
         var speedX:int = GetPlayingSpeedX ();
         
         if (mFasterButton != null)
         {
            mFasterButton.alpha = speedX >= 4 ? 0.5 : 1.0;
         }
         
         if (mSlowerButton != null)
         {
            mSlowerButton.alpha = speedX <= 1 ? 0.5 : 1.0;
         }
      }
      
      override protected function OnZoomScaleChanged (oldZoonScale:Number):void
      {
         var zoomScale:Number = GetZoomScale ();
         
         if (mScaleOutButton != null)
         {
            mScaleOutButton.alpha = zoomScale <= Define.MinWorldZoomScale ? 0.5 : 1.0;
         }
         
         if (mScaleInButton != null)
         {
            mScaleInButton.alpha = zoomScale >= Define.MaxWorldZoomScale ? 0.5 : 1.0;
         }
      }
      
      override protected function OnSoundEnabledChanged ():void
      {
         mSoundOnButton.visible = IsSoundEnabled ();
         mSoundOffButton.visible = ! mSoundOnButton.visible;
      }
      
      override protected function OnHelpDialogVisibleChanged ():void
      {
         if (mHelpDialog == null)
         {
            if (IsHelpDialogVisible ())
               CreateHelpDialog ();
         }
         else
         {
            mHelpDialog.visible = IsHelpDialogVisible ();
         }         
      }
      
      override protected function OnLevelFinishedDialogVisibleChanged ():void
      {
         if (mLevelFinishedDialog == null)
         {
            if (IsLevelFinishedDialogVisible ())
            {
               CreateLevelFinishedDialog ();
            }
         }
         
         if (mLevelFinishedDialog != null)
         {
            mLevelFinishedDialog.visible = IsLevelFinishedDialogVisible () && (! mHasLevelFinishedDialogEverOpened);
         
            if (IsLevelFinishedDialogVisible ())
            {
               mHasLevelFinishedDialogEverOpened = true;
            }
         }
      }
      
      
//======================================================================
//
//======================================================================

      private function OnClickRestart (data:Object = null):void
      {
         Restart ();
         
         SetPlaying (true);
      }

      private function OnClickStart (data:Object = null):void
      {
         SetPlaying (true);
      }

      private function OnClickPause (data:Object = null):void
      {
         SetPlaying (false);
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
      }
      
      private function OnClickSoundOff (data:Object):void
      {
         SetSoundEnabled (true);
      }

      private function OnClickHelp (data:Object):void
      {
         SetHelpDialogVisible (true);
         
         SetPlaying (true);
      }

      private function OnClickCloseHelpDialog ():void
      {
         SetHelpDialogVisible (false);
      }

      private function OnClickCloseLevelFinishedDialog ():void
      {
         SetLevelFinishedDialogVisible (false);
      }

//======================================================================
//
//======================================================================

      private static const NumButtonSpeed:int = 5;
      private static const ButtonMargin:int = 5;
      
      private var mPlayBar:Sprite  = null;
         private var mBarMask:Shape;
         private var mBarBackground:Sprite;
         private var mBasicButtonBar:Sprite;
            private var mStartButton:Sprite;
            private var mRestartButton:Sprite;
            private var mSoundOnButton:Sprite;
            private var mSoundOffButton:Sprite;
            private var mHelpButton:Sprite;
            private var mExitButton:Sprite;
      
      private var mHubButtonContainer:Sprite;
            private var mScaleOutButton:Sprite;
            private var mScaleInButton:Sprite;
            private var mFasterButton:Sprite;
            private var mSlowerButton:Sprite;
         
      private function RebuildPlayBar (params:Object):void
      {
         if (mPlayBar == null)
         {
            mHubButtonContainer = new Sprite ();
            mHubButtonContainer.alpha = 0.0;
            mHubButtonContainer.visible = false;
            mPlayBarLayer.addChild (mHubButtonContainer);
            
            var topMargin:Number = 10 * GetSkinScale ();
            
            // ...
            
            var mPauseButton:Sprite = CreateButton (0, mPauseButtonData);
            mPauseButton.scaleX = mPauseButton.scaleY = GetSkinScale ();
            mPauseButton.x = topMargin + 0.5 * mPauseButton.width;
            mPauseButton.y = topMargin + 0.5 * mPauseButton.height;
            mPauseButton.buttonMode = true;
            mPauseButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickPause);
            mHubButtonContainer.addChild (mPauseButton);
            
            // ...
            
            var buttonX:Number;
            var buttonY:Number;
            
            buttonX = mViewerWidth - topMargin;
            
            if (params.mShowScaleAdjustor)
            {
               mScaleOutButton = CreateButton (0, mScaleOutButtonData);
               mScaleOutButton.scaleX = mScaleOutButton.scaleY = GetSkinScale ();
               buttonX -= mScaleOutButton.width;
               mScaleOutButton.x = buttonX + 0.5 * mScaleOutButton.width;
               mScaleOutButton.y = topMargin  + 0.5 * mScaleOutButton.height;
               mScaleOutButton.buttonMode = true;
               mScaleOutButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickZoomOut);
               mHubButtonContainer.addChild (mScaleOutButton);
               
               buttonX -= ButtonMargin;
               
               mScaleInButton = CreateButton (0, mScaleInButtonData);
               mScaleInButton.scaleX = mScaleInButton.scaleY = GetSkinScale ();
               buttonX -= mScaleInButton.width;
               mScaleInButton.x = buttonX + 0.5 * mScaleInButton.width;
               mScaleInButton.y = topMargin  + 0.5 * mScaleInButton.height;
               mScaleInButton.buttonMode = true;
               mScaleInButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickZoomIn);
               mHubButtonContainer.addChild (mScaleInButton);
               
               buttonX -= ButtonMargin;
            }
            
            if (params.mShowSpeedAdjustor)
            {
               mFasterButton = CreateButton (0, mFasterButtonData);
               mFasterButton.scaleX = mFasterButton.scaleY = GetSkinScale ();
               buttonX -= mFasterButton.width;
               mFasterButton.x = buttonX + 0.5 * mFasterButton.width;
               mFasterButton.y = topMargin  + 0.5 * mFasterButton.height;
               mFasterButton.buttonMode = true;
               mFasterButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickFaster);
               mHubButtonContainer.addChild (mFasterButton);
               
               buttonX -= ButtonMargin;
               
               mSlowerButton = CreateButton (0, mSlowerButtonData);
               mSlowerButton.scaleX = mSlowerButton.scaleY = GetSkinScale ();
               buttonX -= mSlowerButton.width;
               mSlowerButton.x = buttonX + 0.5 * mSlowerButton.width;
               mSlowerButton.y = topMargin  + 0.5 * mSlowerButton.height;
               mSlowerButton.buttonMode = true;
               mSlowerButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickSlower);
               mHubButtonContainer.addChild (mSlowerButton);
               
               buttonX -= ButtonMargin;
            }
                  
            //=======================================
            
            mPlayBar = new Sprite ();
            mPlayBarLayer.addChild (mPlayBar);
            mPlayBar.alpha = 0.0;
            mPlayBar.visible = false;
            
            // ...
            
            mBasicButtonBar = new Sprite ();
            mPlayBar.addChild (mBasicButtonBar);
            
            buttonY = 0;
   
            // restart start/pause, stop
            
            mStartButton = CreateButton (0, mPlayButtonData);
            buttonY += mStartButton.height;
            mStartButton.y = buttonY;
            mStartButton.buttonMode = true;
            mStartButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickStart);
            mBasicButtonBar.addChild (mStartButton);
            
            buttonY += ButtonMargin;
            
            mRestartButton = CreateButton (0, mRestartButtonData);
            buttonY += mRestartButton.height;
            mRestartButton.y = buttonY;
            mRestartButton.buttonMode = true;
            mRestartButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickRestart);
            mBasicButtonBar.addChild (mRestartButton);
            
            buttonY += ButtonMargin;
            
            if (true || params.mShowSoundController)
            {
               mSoundOnButton = CreateButton (0, mSoundOnButtonData);
               buttonY += mSoundOnButton.height;
               mSoundOnButton.y = buttonY;
               mSoundOnButton.buttonMode = true;
               mSoundOnButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickSoundOn);
               mBasicButtonBar.addChild (mSoundOnButton);
               
               buttonY += ButtonMargin;
               
               mSoundOffButton = CreateButton (0, mSoundOffButtonData);
               mSoundOffButton.x = mSoundOnButton.x;
               mSoundOffButton.y = mSoundOnButton.y;
               mSoundOffButton.buttonMode = true;
               mSoundOffButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickSoundOff);
               mSoundOffButton.visible = false;
               mBasicButtonBar.addChild (mSoundOffButton);
            }
            
            if (params.mShowHelpButton)
            {
               mHelpButton = CreateButton (0, mHelpButtonData);
               buttonY += mHelpButton.height;
               mHelpButton.y = buttonY;
               mHelpButton.buttonMode = true;
               mHelpButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickHelp);
               mBasicButtonBar.addChild (mHelpButton);
               
               buttonY += ButtonMargin;
            }
            
            if (_OnExitLevel != null)
            {
               if (mHasMainMenu)
               {
                  mExitButton = CreateButton (0, mMenuButtonData);
               }
               else
               {
                  mExitButton = CreateButton (0, mExitAppButtonData);
               }
               
               buttonY += mExitButton.height;
               mExitButton.y = buttonY;
               mExitButton.buttonMode = true;
               mExitButton.addEventListener(MouseEvent.MOUSE_DOWN, _OnExitLevel);
               mBasicButtonBar.addChild (mExitButton);
               
               buttonY += ButtonMargin;
            }
         
            // ... 
         
            var bounds:Rectangle = mBasicButtonBar.getBounds (mBasicButtonBar);
            var topBottomMargin:Number = 0.5 * (GetPlayBarWidth () - bounds.width);
            mBasicButtonBar.x = topBottomMargin - bounds.x;
            mBasicButtonBar.y = topBottomMargin - bounds.y;
            
            // ...
            
            mBarBackground = new Sprite ();
            mPlayBar.addChildAt (mBarBackground, 0);
            //GraphicsUtil.DrawRect (mBarBackground, - DefaultButtonBaseHalfSize, 0, GetPlayBarWidth () + DefaultButtonBaseHalfSize, bounds.height + topBottomMargin + topBottomMargin, params.mPlayBarColor, -1, true, params.mPlayBarColor, false, true, DefaultButtonBaseHalfSize);
            GraphicsUtil.DrawRect (mBarBackground, 0, 0, GetPlayBarWidth () + DefaultButtonBaseHalfSize, bounds.height + topBottomMargin + topBottomMargin, params.mPlayBarColor, -1, true, params.mPlayBarColor, false, false);
            
            mBarMask = new Shape ();
            GraphicsUtil.DrawRect (mBarMask, 0, 0, GetPlayBarWidth (), bounds.height + topBottomMargin + topBottomMargin, 0x0, -1, true, 0x0, false);
            mPlayBar.addChild (mBarMask);
            mPlayBar.mask = mBarMask;
            mBarMask.visible = false;

            // ...
            
            var unscaldHeight:Number = mPlayBar.height;
            mPlayBar.scaleX = mPlayBar.scaleY = GetSkinScale ();
            if (mPlayBar.height > mViewerHeight)
               mPlayBar.scaleX = mPlayBar.scaleY =  mViewerHeight / unscaldHeight;
            mPlayBar.x = 0;
            mPlayBar.y = 0.5 * (mViewerHeight - mPlayBar.height);

            // ...
         
            //mPlayBar.rotation = -90;
            //mPlayBar.x = 0.5 * (mViewerWidth - mPlayBar.width);
            //mPlayBar.y = GetPlayBarWidth ();
         }

      }
      
//======================================================================
//
//======================================================================

      private var mLevelFinishedDialog:Sprite = null;

      private function CreateLevelFinishedDialog ():void
      {
         if (mLevelFinishedDialog != null && mLevelFinishedDialog.parent == mLevelFinishedDialogLayer)
            mLevelFinishedDialogLayer.removeChild (mLevelFinishedDialog);
         
         // ...
         
         var buttonContainer:Sprite = new Sprite ();
         var buttonMargin:Number = 50.0;
         
         //{
            var buttonX:Number = 0;
            if (_OnNextLevel != null && _OnNextLevel ())
            {
               var buttonNextLevel:TextButton = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Next</font>", _OnNextLevel);
               buttonContainer.addChild (buttonNextLevel);
               buttonNextLevel.x = buttonX;
               buttonX += buttonNextLevel.width + buttonMargin;
            }
            
            var buttonReplay:TextButton = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Replay</font>", _OnRestart);
            buttonContainer.addChild (buttonReplay);
            buttonReplay.x = buttonX;
            buttonX += buttonReplay.width + buttonMargin;
            
            var buttonCloseFinishDialog:TextButton = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Close</font>", OnClickCloseLevelFinishedDialog);
            buttonContainer.addChild (buttonCloseFinishDialog);
            buttonCloseFinishDialog.x = buttonX;
            buttonX += buttonCloseFinishDialog.width + buttonMargin;
            
            if (_OnExitLevel != null)
            {
               var buttonMainMenu:TextButton = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Menu</font>", _OnExitLevel);
               buttonContainer.addChild (buttonMainMenu);
               buttonMainMenu.x = buttonX;
               buttonX += buttonMainMenu.width + buttonMargin;
            }
         //}
         
         // ...
         
         var levelFinishedString:String = "<font size='30' face='Verdana' color='#000000'> <b>Cool! It is solved.</b></font>";
         var levelFinishedText:TextFieldEx = TextFieldEx.CreateTextField (levelFinishedString, false, 0xFFFFFF, 0x0, false);
         
         // ...
         
         var referLinkString:String = "<font face='Verdana' size='15'>Want to <font color='#0000FF'><u><a href='http://www.phyard.com' target='_blank'>design your own games</a></u></font>?</font>";

         var referLinkTextField:TextFieldEx = TextFieldEx.CreateTextField (referLinkString, false, 0xFFFFFF, 0x0);

         // ...
         
         mLevelFinishedDialog = Skin.CreateDialog ([levelFinishedText, 20, referLinkTextField, 20, buttonContainer]);
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
            mLevelFinishedDialogLayer.removeChild (mHelpDialog);

         // ...
                  
         var tutorialText:String = 
            "<font size='15' face='Verdana' color='#000000'>The goal of <b>Color Infection</b> puzzles is to infect all <font color='#FFFF00'><b>YELLOW</b></font> objects with "
                        + "the <font color='#804000'><b>BROWN</b></font> color by colliding them with <font color='#804000'><b>BROWN</b></font> objects "
                        + "but keep all <font color='#60FF60'><b>GREEN</b></font> objects uninfected."
                        + "<br /><br />To play, <br/>"
                        + "- click a <font color='#FF00FF'><b>PINK</b></font> object to destroy it,<br/>"
                        + "- click a <font color='#000000'><b>BOMB</b></font> object to explode it."
                        + "</font>";
         
         var textTutorial:TextFieldEx = TextFieldEx.CreateTextField (tutorialText, false, 0xFFFFFF, 0x0, true, Define.DefaultWorldWidth / 2);
         
         var box2dTextStr:String =  "<font size='10' face='Verdana' color='#000000'>(This player is based on fbox2d, an actionscript<br/>"
                                                                                + "port of the famous box2d c++ physics engine.)</font>";
         var box2dText:TextFieldEx = TextFieldEx.CreateTextField (box2dTextStr);
         
         var buttonCloseHelpDialog:TextButton = new TextButton ("<font face='Verdana' size='16' color='#0000FF'>   Close   </font>", OnClickCloseHelpDialog);
         
         // ...
         
         mHelpDialog = Skin.CreateDialog ([textTutorial, 20 , box2dText, 20, buttonCloseHelpDialog]);
         mHelpDialogLayer.addChild (mHelpDialog);
         CenterSpriteOnContentRegion (mHelpDialog);
      }
   }
}
