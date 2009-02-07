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
      
      private var mBitmapDataRetart:BitmapData = new IconRestart ().bitmapData;
      private var mBitmapDataRetartDisabled:BitmapData = new IconRestartDisabled ().bitmapData;
      private var mBitmapDataStart:BitmapData = new IconStart ().bitmapData;
      private var mBitmapDataPause:BitmapData = new IconPause ().bitmapData;
      private var mBitmapDataStop:BitmapData = new IconStop ().bitmapData;
      private var mBitmapDataStopDisabled:BitmapData = new IconStopDisabled ().bitmapData;
      private var mBitmapDataHelp:BitmapData  = new IconHelp ().bitmapData;
      private var mBitmapDataSpeed:BitmapData  = new IconSpeed ().bitmapData;
      private var mBitmapDataSpeedSelected:BitmapData  = new IconSpeedSelected ().bitmapData;
      
      
//======================================================================
//
//======================================================================
      
      private var _OnRestart:Function;
      private var _OnStart:Function;
      private var _OnPause:Function;
      private var _OnStop:Function;
      private var _OnSpeed:Function;
      private var _OnHelp:Function;
      
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      
      private var mButtonRestart:ImageButton;
      private var mButtonStartPause:ImageButton;
      private var mButtonStop:ImageButton;
      private var mButtonHelp:ImageButton;
      private var mButtonSpeeds:Array;
      
      private static const NumButtonSpeed:int = 5;
      private static const ButtonMargin:int = 8;
      
      public function PlayControlBar (onRestart:Function, onStart:Function, onPause:Function, onStop:Function, onSpeed:Function, onHelp:Function)
      {
         _OnRestart = onRestart;
         _OnStart = onStart;
         _OnPause = onPause;
         _OnStop = onStop;
         _OnSpeed = onSpeed;
         _OnHelp = onHelp;
         
         mIsPlaying = false;
         
         var bar:Sprite = new Sprite ();
         
         var i:int;
         var buttonX:Number = 0;
         
         mButtonRestart = new ImageButton (null, mBitmapDataRetartDisabled);
         addChild (mButtonRestart);
         
         mButtonRestart.x = buttonX; 
         buttonX += mButtonRestart.width;
         
         mButtonStartPause = new ImageButton (OnClickStart, mBitmapDataStart);
         addChild (mButtonStartPause);
         
         mButtonStartPause.x = buttonX; 
         buttonX += mButtonStartPause.width;
         
         if (onStop != null)
         {
            mButtonStop = new ImageButton (null, mBitmapDataStopDisabled);
            addChild (mButtonStop);
            
            mButtonStop.x = buttonX; 
            buttonX += mButtonStop.width;
         }
         
         buttonX += ButtonMargin - 1;
         
         mButtonSpeeds = new Array (5);
         for (i = 0; i < NumButtonSpeed; ++ i)
         {
            mButtonSpeeds [i] = new ImageButton (OnClickSpeed, mBitmapDataSpeed, i);
            addChild (mButtonSpeeds[i]);
            
            mButtonSpeeds[i].x = buttonX; 
            buttonX += mButtonSpeeds[i].width - 1;
         }
         
         mButtonHelp = new ImageButton (OnClickHelp, mBitmapDataHelp);
         addChild (mButtonHelp);
         
         buttonX += ButtonMargin;
         mButtonHelp.x = buttonX;
         
         OnClickSpeed (1);
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
      
      private function OnClickSpeed (data:Object):void
      {
         var index:int = int (data);
         if (index < 0) index = 0;
         if (index >= NumButtonSpeed) index = NumButtonSpeed - 1;
         
         for (var i:int = 0; i < NumButtonSpeed; ++ i)
         {
            if (i == index)
               mButtonSpeeds [i].SetBitmapData ( mBitmapDataSpeedSelected );
            else
               mButtonSpeeds [i].SetBitmapData ( mBitmapDataSpeed );
         }
         
         mPlayingSpeedX = ButtonIndex2SpeedXTable [index];
         
         if (_OnSpeed != null)
            _OnSpeed ();
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
