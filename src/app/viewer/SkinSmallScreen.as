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
      [Embed(source="../../res/player/button_base.png")]
      private static var IconButtonBase:Class;
      
      [Embed(source="../../res/player/player-restart.png")]
      private static var IconRestart:Class;
      [Embed(source="../../res/player/player-restart-disabled.png")]
      private static var IconRestartDisabled:Class;
      [Embed(source="../../res/player/player-start.png")]
      private static var IconStart:Class;
      [Embed(source="../../res/player/player-pause.png")]
      private static var IconPause:Class;

      [Embed(source="../../res/player/player-help.png")]
      private static var IconHelp:Class;

      [Embed(source="../../res/player/player-speed.png")]
      private static var IconSpeed:Class;
      [Embed(source="../../res/player/player-speed-selected.png")]
      private static var IconSpeedSelected:Class;

      [Embed(source="../../res/player/player-zoom-in.png")]
      private static var IconZoomIn:Class;
      [Embed(source="../../res/player/player-zoom-in-disabled.png")]
      private static var IconZoomInDisabled:Class;
      [Embed(source="../../res/player/player-zoom-out.png")]
      private static var IconZoomOut:Class;
      [Embed(source="../../res/player/player-zoom-out-disabled.png")]
      private static var IconZoomOutDisabled:Class;

      private var mBitmapDataRetart:BitmapData = new IconRestart ().bitmapData;
      private var mBitmapDataRetartDisabled:BitmapData = new IconRestartDisabled ().bitmapData;
      private var mBitmapDataStart:BitmapData = new IconStart ().bitmapData;
      private var mBitmapDataPause:BitmapData = new IconPause ().bitmapData;
      private var mBitmapDataHelp:BitmapData  = new IconHelp ().bitmapData;
      private var mBitmapDataSpeed:BitmapData  = new IconSpeed ().bitmapData;
      private var mBitmapDataSpeedSelected:BitmapData  = new IconSpeedSelected ().bitmapData;

      private var mBitmapDataZoomIn:BitmapData  = new IconZoomIn ().bitmapData;
      private var mBitmapDataZoomInDisabled:BitmapData  = new IconZoomInDisabled ().bitmapData;
      private var mBitmapDataZoomOut:BitmapData  = new IconZoomOut ().bitmapData;
      private var mBitmapDataZoomOutDisabled:BitmapData  = new IconZoomOutDisabled ().bitmapData;
      
      // ...
      
      [Embed(source="../../res/player/player-mainmenu.png")]
      private static var IconMainMenu:Class;
      [Embed(source="../../res/player/player-phyard.png")]
      private static var IconPhyard:Class;

      private var mBitmapDataMainMenu:BitmapData  = new IconMainMenu ().bitmapData;
      private var mBitmapDataPhyard:BitmapData  = new IconPhyard ().bitmapData;

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
         
         if (IsPlaying ())
         {
            mHubButtonContainer.visible = true;
            if (mHubButtonContainer.alpha < 0.5)
               mHubButtonContainer.alpha += 0.02;
            if (mHubButtonContainer.alpha > 0.5)
               mHubButtonContainer.alpha = 0.5;
            
            if (mPlayBar.alpha > 0.0)
               mPlayBar.alpha -= 0.02;
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
               mPlayBar.alpha += 0.02;
            if (mPlayBar.alpha >= 1.0)
               mPlayBar.alpha = 1.0;
            
            if (mHubButtonContainer.alpha > 0.0)
               mHubButtonContainer.alpha -= 0.02;
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
      }
      
      override protected function OnZoomScaleChanged (oldZoonScale:Number):void
      {

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

      private static const ButtonIndex2SpeedXTable:Array = [1, 2, 3, 4, 5];
      private static var mButtonShown:Array = [true, true, false, true, false];

      private function OnClickSpeed (data:Object):void
      {
         var index:int = int (data);
         if (index < 0) index = 0;
         if (index >= NumButtonSpeed) index = NumButtonSpeed - 1;

         SetPlayingSpeedX (ButtonIndex2SpeedXTable [index]);
      }

      private function OnClickZoomIn (data:Object):void
      {
         SetZoomScale (GetZoomScale () * 2.0);
      }

      private function OnClickZoomOut (data:Object):void
      {
         SetZoomScale (GetZoomScale () * 0.5);
      }

      private function OnClickHelp (data:Object):void
      {
         SetHelpDialogVisible (true);
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
            private var mButtonRestart:ImageButton;
            private var mButtonStartPause:ImageButton;
            private var mButtonHelp:ImageButton;
            private var mButtonMainMenu:ImageButton;
            //private var mButtonGoToPhyard:ImageButton;
      
      private var mHubButtonContainer:Sprite;
         private var mButtonSpeeds:Array;
         private var mButtonZoomIn:ImageButton;
         private var mButtonZoomOut:ImageButton;
         
      private function RebuildPlayBar (params:Object):void
      {
         if (mPlayBar == null)
         {
            mHubButtonContainer = new Sprite ();
            mHubButtonContainer.alpha = 0.0;
            mHubButtonContainer.visible = false;
            mPlayBarLayer.addChild (mHubButtonContainer);
            
            // ...
            
            var mPauseButton:Sprite = CreateButton (0, mPauseButtonData);
            mPauseButton.scaleX = mPauseButton.scaleY = GetSkinScale ();
            mPauseButton.x = 10 + 0.5 * mPauseButton.width;
            mPauseButton.y = 10 + 0.5 * mPauseButton.height;
            mPauseButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickPause);
            mHubButtonContainer.addChild (mPauseButton);
         }            
                  
         if (mPlayBar == null)
         {
            // ...
            mPlayBar = new Sprite ();
            mPlayBarLayer.addChild (mPlayBar);
            mPlayBar.alpha = 0.0;
            mPlayBar.visible = false;
            
            // ...
            
            mBasicButtonBar = new Sprite ();
            mPlayBar.addChild (mBasicButtonBar);
            
            var buttonY:Number = 0;
   
            // restart start/pause, stop
            
            var mStartButton:Sprite = CreateButton (0, mPlayButtonData);
            buttonY += mStartButton.height;
            mStartButton.y = buttonY;
            mStartButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickStart);
            mBasicButtonBar.addChild (mStartButton);
            
            buttonY += ButtonMargin;
            
            var mRestartButton:Sprite = CreateButton (0, mRestartButtonData);
            buttonY += mRestartButton.height;
            mRestartButton.y = buttonY;
            mRestartButton.addEventListener(MouseEvent.MOUSE_DOWN, OnClickRestart);
            mBasicButtonBar.addChild (mRestartButton);
            
            buttonY += ButtonMargin;
            
            var mSoundButton:Sprite = CreateButton (0, mSoundOffButtonData);
            buttonY += mSoundButton.height;
            mSoundButton.y = buttonY;
            mBasicButtonBar.addChild (mSoundButton);
            
            buttonY += ButtonMargin;
            
            var mMenuButton:Sprite = CreateButton (0, mMenuButtonData);
            buttonY += mMenuButton.height;
            mMenuButton.y = buttonY;
            mBasicButtonBar.addChild (mMenuButton);
            
            buttonY += ButtonMargin;
            
            var mHelpButton:Sprite = CreateButton (0, mMenuButtonData);
            buttonY += mHelpButton.height;
            mHelpButton.y = buttonY;
            mBasicButtonBar.addChild (mHelpButton);
            
            buttonY += ButtonMargin;
         }
         
         // ... 
         
         var bounds:Rectangle = mBasicButtonBar.getBounds (mBasicButtonBar);
         var margin:Number = 0.5 * (GetPlayBarWidth () - bounds.width);
         mBasicButtonBar.x = margin - bounds.x;
         mBasicButtonBar.y = margin - bounds.y;
         
         // ...
         
         mBarBackground = new Sprite ();
         mPlayBar.addChildAt (mBarBackground, 0);
         GraphicsUtil.DrawRect (mBarBackground, - DefaultButtonBaseHalfSize, 0, GetPlayBarWidth () + DefaultButtonBaseHalfSize, bounds.height + margin + margin, params.mPlayBarColor, -1, true, params.mPlayBarColor, false, true, DefaultButtonBaseHalfSize);
         
         mBarMask = new Shape ();
         GraphicsUtil.DrawRect (mBarMask, 0, 0, GetPlayBarWidth (), bounds.height + margin + margin, 0x0, -1, true, 0x0, false);
         mPlayBar.addChild (mBarMask);
         mPlayBar.mask = mBarMask;
         mBarMask.visible = false;
         
         // ...
         
         mPlayBar.scaleX = mPlayBar.scaleY = GetSkinScale ();
         mPlayBar.x = 0;
         mPlayBar.y = 0.5 * (mViewerHeight - mPlayBar.height);

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
            
            if (_OnMainMenu != null)
            {
               var buttonMainMenu:TextButton = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Menu</font>", _OnMainMenu);
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
