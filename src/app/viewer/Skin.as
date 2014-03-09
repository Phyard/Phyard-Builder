package viewer {

   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import com.tapirgames.util.GraphicsUtil;

   import common.ViewerDefine;

   public class Skin extends Sprite
   {
//======================================================================
//
//======================================================================

      public function Skin (params:Object)
      {
         mIsOverlay = params.mIsOverlay;
         mIsTouchScreen = params.mIsTouchScreen;
         mIsPhoneDevice = params.mIsPhoneDevice;
         if (mIsPhoneDevice)
            mIsTouchScreen = true; // forcely
         if (mIsTouchScreen)
            mIsOverlay = true; // forcely
         
         _OnRestart = params.OnRestart;
         _OnStart = params.OnStart;
         _OnPause = params.OnPause;
         _OnSpeedChanged = params.OnSpeedChanged;
         _OnScaleChanged = params.OnScaleChanged;
         _OnSoundControlChanged = params.OnSoundControlChanged;
         
         mHasMainMenu = params.mHasMainMenu;
         _OnExitLevel = params.OnExitLevel;
         mHasNextLevel = params.mHasNextLevel;
         _OnNextLevel = params.OnNextLevel;
         _OnGoToPhyard = params.OnGoToPhyard;
      }
      
//======================================================================
// viewer interfaces for skin
//======================================================================
      // ...
      protected var mIsOverlay:Boolean;
      protected var mIsTouchScreen:Boolean;
      protected var mIsPhoneDevice:Boolean;
      
      // interfaces from viewer, None can be null
      protected var _OnRestart:Function;
      protected var _OnStart:Function;
      protected var _OnPause:Function;
      protected var _OnSpeedChanged:Function;
      protected var _OnScaleChanged:Function;
      protected var _OnSoundControlChanged:Function;
      
      // these can be null
      protected var mHasMainMenu:Boolean;
      protected var _OnExitLevel:Function;
      protected var mHasNextLevel:Boolean;
      protected var _OnNextLevel:Function;
      protected var _OnGoToPhyard:Function;
      
      protected function OnExitLevel (dummyParam:Object = null):void
      {
         if (_OnExitLevel != null)
            _OnExitLevel ();
      }
      
      protected function OnGoToPhyard (dummyParam:Object = null):void
      {
         if (_OnGoToPhyard != null)
            _OnGoToPhyard ();
      }
      
//======================================================================
// skin interfaces for viewer
//======================================================================
      
      // ...
      protected var mViewerWidth :Number;
      protected var mViewerHeight:Number;
      
      //
      protected var mShowPlayBar:Boolean = true;

      // ...
      private var mIsStarted:Boolean = false;
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      private var mZoomScale:Number = 1.0;
      private var mIsSoundEnabled:Boolean = true;
      
      // ...
      private var mIsHelpDialogVisible:Boolean = false;
      private var mIsLevelFinishedDialogVisible:Boolean = false;
      protected var mHasLevelFinishedDialogEverOpened:Boolean = false;

      final public function SetViewerSize (viewerWidth:Number, viewerHeight:Number):void
      {
         mViewerWidth  = viewerWidth;
         mViewerHeight = viewerHeight;
      }
      
      // should call after SetViewerSize
      public function GetContentRegion ():Rectangle
      {
         return new Rectangle (0, 0, mViewerWidth, mViewerHeight); // to override
      }
      
      public function GetPreferredViewerSize (viewportWidth:Number, viewportHeight:Number):Point
      {
         return new Point (viewportWidth, viewportHeight); // to override
      }
      
      public function Update (dt:Number):void
      {
         // to override
      }
      
      // should call this function 
      final public function SetShowPlayBar (showPlayBar:Boolean):void
      {
         mShowPlayBar = showPlayBar;
      }
      
      final public function IsShowPlayBar ():Boolean
      {
         return mShowPlayBar;
      }
      
      public function Rebuild (params:Object):void
      {
         // to override
      }
      
      final public function IsStarted ():Boolean
      {
         return mIsStarted;
      }
      
      final public function SetStarted (started:Boolean):void
      {
         if (! mIsStarted)
         {
            mHasLevelFinishedDialogEverOpened = false;
         }
         
         if (mIsStarted == started)
            return;
         
         mIsStarted = started;
         
         OnStartedChanged ();
      }
      
      final public function Restart ():void
      {
         //mIsStarted = false;
         
         if (_OnRestart != null)
            _OnRestart ();
         
         //OnStartedChanged ();
      }
      
      protected function OnStartedChanged ():void
      {
         // to override
      }

      final public function IsPlaying ():Boolean
      {
         return mIsPlaying;
      }

      final public function SetPlaying (playing:Boolean):void
      {
         if (mIsPlaying == playing)
            return;
         
         mIsPlaying = playing;
         
         if (mIsPlaying)
         {
            if (_OnStart != null)
               _OnStart ();
         }
         else
         {
            if (_OnPause != null)
               _OnPause ();
         }
         
         OnPlayingChanged ();
      }
      
      protected function OnPlayingChanged ():void
      {
         // to override
      }

      final public function GetPlayingSpeedX ():int
      {
         return mPlayingSpeedX;
      }

      final public function SetPlayingSpeedX (speedX:int):void
      {
         if (speedX < 0)
            speedX = 0;

         if (mPlayingSpeedX == speedX)
            return;
         
         var oldSpeedX:int = mPlayingSpeedX;
         mPlayingSpeedX = speedX;
         
         if (_OnSpeedChanged != null)
            _OnSpeedChanged ();
         
         OnPlayingSpeedXChanged ();
      }
      
      protected function OnPlayingSpeedXChanged ():void
      {
         // to override
      }

      final public function GetZoomScale ():Number
      {
         return mZoomScale;
      }

      final public function SetZoomScale (zoomScale:Number, smoothly:Boolean = true):void
      {
         if ( zoomScale <= ViewerDefine.MinWorldZoomScale)
         {
            zoomScale = ViewerDefine.MinWorldZoomScale;
         }

         if ( zoomScale >= ViewerDefine.MaxWorldZoomScale)
         {
            zoomScale = ViewerDefine.MaxWorldZoomScale;
         }
         
         if (mZoomScale == zoomScale)
            return;
         
         var oldZoonScale:Number = mZoomScale;
         mZoomScale = zoomScale;

         if (_OnScaleChanged != null)
            _OnScaleChanged (smoothly);
         
         OnZoomScaleChanged ();
      }
      
      protected function OnZoomScaleChanged ():void
      {
         // to override
      }
      
      final public function IsSoundEnabled ():Boolean
      {
         return mIsSoundEnabled;
      }
      
      final public function SetSoundEnabled (soundOn:Boolean):void
      {
         if (mIsSoundEnabled == soundOn)
            return;
         
         mIsSoundEnabled = soundOn;
         
         if (_OnSoundControlChanged != null)
            _OnSoundControlChanged ();
         
         OnSoundEnabledChanged ();
      }
      
      protected function OnSoundEnabledChanged ():void
      {
         // to override
      }

      final public function IsHelpDialogVisible ():Boolean
      {
         return mIsHelpDialogVisible;
      }

      final public function SetHelpDialogVisible (show:Boolean):void
      {
         if (mIsHelpDialogVisible == show)
            return;
         
         mIsHelpDialogVisible = show;
         
         OnHelpDialogVisibleChanged ();
      }
      
      protected function OnHelpDialogVisibleChanged ():void
      {
         // to override
      }

      final public function IsLevelFinishedDialogVisible ():Boolean
      {
         return mIsLevelFinishedDialogVisible;
      }

      final public function SetLevelFinishedDialogVisible (show:Boolean):void
      {
         if (mIsLevelFinishedDialogVisible == show)
            return;
         
         mIsLevelFinishedDialogVisible = show;
         
         OnLevelFinishedDialogVisibleChanged ();
      }
      
      protected function OnLevelFinishedDialogVisibleChanged ():void
      {
         // to override
      }
      
      public function OnDeactivate ():void
      {
         // to override
      }
      
      public function GetFPS ():Number
      {
         return 0; //to overrride
      }

//======================================================================
// for Viewer
//======================================================================
      
      public function AreSomeDialogsVisible ():Boolean
      {
         return IsHelpDialogVisible () || IsLevelFinishedDialogVisible ();
      }
      
      public function CloseAllVisibleDialogs ():void
      {
         SetHelpDialogVisible (false);
         SetLevelFinishedDialogVisible (false);
      }
   }
}
