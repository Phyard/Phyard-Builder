package player.ui {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   import com.tapirgames.display.ImageButton;
   
   import common.Define;
   
   public class PlayControlBar extends Sprite
   {
      
      
      [Embed(source="../../res/player/player-restart.png")]
      private static var IconRestart:Class;
      [Embed(source="../../res/player/player-restart-disabled.png")]
      private static var IconRestartDisabled:Class;
      [Embed(source="../../res/player/player-start.png")]
      private static var IconStart:Class;
      [Embed(source="../../res/player/player-pause.png")]
      private static var IconPause:Class;
      [Embed(source="../../res/player/player-stop.png")]
      private static var IconStop:Class;
      [Embed(source="../../res/player/player-stop-disabled.png")]
      private static var IconStopDisabled:Class;
      
      [Embed(source="../../res/player/player-help.png")]
      private static var IconHelp:Class;
      
      [Embed(source="../../res/player/player-speed.png")]
      private static var IconSpeed:Class;
      [Embed(source="../../res/player/player-speed-selected.png")]
      private static var IconSpeedSelected:Class;
      
      [Embed(source="../../res/player/player-mainmenu.png")]
      private static var IconMainMenu:Class;
      
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
      private var mBitmapDataStop:BitmapData = new IconStop ().bitmapData;
      private var mBitmapDataStopDisabled:BitmapData = new IconStopDisabled ().bitmapData;
      private var mBitmapDataHelp:BitmapData  = new IconHelp ().bitmapData;
      private var mBitmapDataSpeed:BitmapData  = new IconSpeed ().bitmapData;
      private var mBitmapDataSpeedSelected:BitmapData  = new IconSpeedSelected ().bitmapData;
      
      private var mBitmapDataMainMenu:BitmapData  = new IconMainMenu ().bitmapData;
      
      private var mBitmapDataZoomIn:BitmapData  = new IconZoomIn ().bitmapData;
      private var mBitmapDataZoomInDisabled:BitmapData  = new IconZoomInDisabled ().bitmapData;
      private var mBitmapDataZoomOut:BitmapData  = new IconZoomOut ().bitmapData;
      private var mBitmapDataZoomOutDisabled:BitmapData  = new IconZoomOutDisabled ().bitmapData;
      
//======================================================================
//
//======================================================================
      
      private var _OnRestart:Function;
      private var _OnStart:Function;
      private var _OnPause:Function;
      private var _OnStop:Function;
      private var _OnSpeed:Function;
      private var _OnHelp:Function;
      
      private var _OnMainMenu:Function = null;
      
      private var _OnZoom:Function;
      
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      
      private var mZoomScale:Number = 1.0;
      
      private var mButtonRestart:ImageButton;
      private var mButtonStartPause:ImageButton;
      private var mButtonStop:ImageButton;
      private var mButtonHelp:ImageButton;
      private var mButtonSpeeds:Array;
      
      private var mButtonMainMenu:ImageButton;
      
      private var mButtonZoomIn:ImageButton;
      private var mButtonZoomOut:ImageButton;
      
      private static const NumButtonSpeed:int = 5;
      private static const ButtonMargin:int = 8;
      
      public function PlayControlBar (onRestart:Function, onStart:Function, onPause:Function, onStop:Function, onSpeed:Function, onHelp:Function, onMainMenu:Function = null, onZoom:Function = null)
      {
         _OnRestart = onRestart;
         _OnStart = onStart;
         _OnPause = onPause;
         _OnStop = onStop;
         _OnSpeed = onSpeed;
         _OnHelp = onHelp;
         
         _OnMainMenu = onMainMenu;
         _OnZoom = onZoom;
         
         mIsPlaying = false;
         
         var bar:Sprite = new Sprite ();
         
         var i:int;
         var buttonX:Number = 0;
         
      // main menu
         
         if (_OnMainMenu != null)
         {
            mButtonMainMenu = new ImageButton (mBitmapDataMainMenu);
            mButtonMainMenu.SetClickEventHandler (_OnMainMenu);
            addChild (mButtonMainMenu);
         
            mButtonMainMenu.x = buttonX;
            buttonX += mButtonMainMenu.width;
            buttonX += ButtonMargin;
         }
         
      // restart start/pause, stop
         
         mButtonRestart = new ImageButton (mBitmapDataRetartDisabled);
         addChild (mButtonRestart);
         
         mButtonRestart.x = buttonX; 
         buttonX += mButtonRestart.width;
         
         mButtonStartPause = new ImageButton (mBitmapDataStart);
         mButtonStartPause.SetClickEventHandler (OnClickStart);
         addChild (mButtonStartPause);
         
         mButtonStartPause.x = buttonX; 
         buttonX += mButtonStartPause.width;
         
         if (onStop != null)
         {
            mButtonStop = new ImageButton (mBitmapDataStopDisabled);
            addChild (mButtonStop);
            
            mButtonStop.x = buttonX; 
            buttonX += mButtonStop.width;
         }
         
         buttonX += ButtonMargin;
         
      // speed
         
         mButtonSpeeds = new Array (5);
         
         for (i = 0; i < NumButtonSpeed; ++ i)
         {
            mButtonSpeeds [i] = new ImageButton (mBitmapDataSpeed, i);
            
            if (mButtonShown [i])
            {
               mButtonSpeeds [i].SetClickEventHandler (OnClickSpeed);
               
               addChild (mButtonSpeeds[i]);
               
               mButtonSpeeds[i].x = buttonX; 
               buttonX += mButtonSpeeds[i].width - 1;
            }
         }
         
         buttonX += ButtonMargin;
         
      // zoom
         
         mButtonZoomIn = new ImageButton (mBitmapDataZoomIn);
         mButtonZoomIn.SetClickEventHandler (OnClickZoomIn);
         addChild (mButtonZoomIn);
         
         mButtonZoomOut = new ImageButton (mBitmapDataZoomOut);
         mButtonZoomOut.SetClickEventHandler (OnClickZoomOut);
         addChild (mButtonZoomOut);
         
         mButtonZoomIn.x = buttonX;
         buttonX += mButtonZoomIn.width;
         mButtonZoomOut.x = buttonX;
         buttonX += mButtonZoomOut.width;
         buttonX += ButtonMargin;
         
      // help
         
         mButtonHelp = new ImageButton (mBitmapDataHelp);
         mButtonHelp.SetClickEventHandler (OnClickHelp);
         addChild (mButtonHelp);
         
         mButtonHelp.x = buttonX;
         buttonX += mButtonHelp.width;
         buttonX += ButtonMargin;
         
      // 
         
         OnClickSpeed (1); // speed X2
      }
      
      public function IsPlaying ():Boolean
      {
         return mIsPlaying;
      }
      
      public function SetPlaying (playing:Boolean):void
      {
         if (mIsPlaying != playing)
         {
            if (playing)
               OnClickStart ();
            else
               OnClickPause ();
         }
      }
      
      public function GetPlayingSpeedX ():int
      {
         return mPlayingSpeedX;
      }
      
      public function GetZoomScale ():Number
      {
         return mZoomScale;
      }
      
      public function SetZoomScale (zoomScale:Number):void
      {
         var oldScale:Number = mZoomScale;
         
         mZoomScale = zoomScale;
         
         if ( mZoomScale <= Define.MinWorldZoomScale)
         {
            mZoomScale = Define.MinWorldZoomScale;
            
            mButtonZoomOut.SetBitmapData (mBitmapDataZoomOutDisabled);
            mButtonZoomOut.SetClickEventHandler (null);
         }
         else if (oldScale <= Define.MinWorldZoomScale)
         {
            mButtonZoomOut.SetBitmapData (mBitmapDataZoomOut);
            mButtonZoomOut.SetClickEventHandler (OnClickZoomOut);
         }
         
         if ( mZoomScale >= Define.MaxWorldZoomScale)
         {
            mZoomScale = Define.MaxWorldZoomScale;
            
            mButtonZoomIn.SetBitmapData (mBitmapDataZoomInDisabled);
            mButtonZoomIn.SetClickEventHandler (null);
         }
         else if (oldScale >= Define.MaxWorldZoomScale)
         {
            mButtonZoomIn.SetBitmapData (mBitmapDataZoomIn);
            mButtonZoomIn.SetClickEventHandler (OnClickZoomIn);
         }
      }
      
      public function NotifyStepped ():void
      {
         mButtonRestart.SetBitmapData (mBitmapDataRetart);
         mButtonRestart.SetClickEventHandler (OnClickRestart);
      }
      
//======================================================================
//
//======================================================================
      
      public function OnClickStart (data:Object = null):void
      {
         mIsPlaying = true;
         
         mButtonRestart.SetBitmapData (mBitmapDataRetart);
         mButtonRestart.SetClickEventHandler (OnClickRestart);
         
         mButtonStartPause.SetBitmapData (mBitmapDataPause);
         mButtonStartPause.SetClickEventHandler (OnClickPause);
         
         if (mButtonStop != null)
         {
            mButtonStop.SetBitmapData (mBitmapDataStop);
            mButtonStop.SetClickEventHandler (OnClickStop);
         }
         
         if (_OnStart != null)
            _OnStart ();
      }
      
      private function OnClickRestart (data:Object = null):void
      {
         if (mIsPlaying)
         {
            //OnClickStart (null);
         }
         else
         {
            mButtonRestart.SetBitmapData (mBitmapDataRetartDisabled);
            mButtonRestart.SetClickEventHandler (null);
            OnClickPause (null);
         }
         
         if (_OnRestart != null)
            _OnRestart ();
      }
      
      public function OnClickPause (data:Object = null):void
      {
         mIsPlaying = false;
         
         mButtonStartPause.SetBitmapData (mBitmapDataStart);
         mButtonStartPause.SetClickEventHandler (OnClickStart);
         
         if (_OnPause != null)
            _OnPause ();
      }
      
      public function OnClickStop (data:Object = null):void
      {
         mIsPlaying = false;
         
         mButtonRestart.SetBitmapData (mBitmapDataRetartDisabled);
         mButtonRestart.SetClickEventHandler (null);
         
         if (mButtonStop != null)
         {
            mButtonStop.SetBitmapData (mBitmapDataStopDisabled);
            mButtonStop.SetClickEventHandler (null);
         }
         
         mButtonStartPause.SetBitmapData (mBitmapDataStart);
         mButtonStartPause.SetClickEventHandler (OnClickStart);
         
         if (_OnStop != null)
            _OnStop ();
      }
      
      private static const ButtonIndex2SpeedXTable:Array = [1, 2, 3, 4, 5];
      private static var mButtonShown:Array = [true, true, false, true, false];
      
      public function OnClickSpeed (data:Object):void
      {
         var index:int = int (data);
         if (index < 0) index = 0;
         if (index >= NumButtonSpeed) index = NumButtonSpeed - 1;
         
         SetPlayingSpeedX (ButtonIndex2SpeedXTable [index]);
      }
      
      public function SetPlayingSpeedX (speedX:int):void
      {
         if (speedX < 0)
            speedX = 0;
         
         mPlayingSpeedX = speedX;
         
         for (var i:int = 0; i < NumButtonSpeed; ++ i)
         {
            if (ButtonIndex2SpeedXTable [i] == speedX)
               mButtonSpeeds [i].SetBitmapData (mBitmapDataSpeedSelected);
            else
               mButtonSpeeds [i].SetBitmapData (mBitmapDataSpeed);
         }
         
         if (_OnSpeed != null)
            _OnSpeed ();
      }
      
      private function OnClickZoomIn (data:Object):void
      {
         SetZoomScale (mZoomScale * 2.0);
         
         if (_OnZoom != null)
            _OnZoom ();
      }
      
      private function OnClickZoomOut (data:Object):void
      {
         SetZoomScale (mZoomScale * 0.5);
         
         if (_OnZoom != null)
            _OnZoom ();
      }
      
      private function OnClickHelp (data:Object):void
      {
         if (_OnHelp != null)
            _OnHelp ();
      }
      
//======================================================================
//
//======================================================================
      
   }
}
