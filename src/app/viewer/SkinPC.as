package viewer {

   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;

   import com.tapirgames.display.ImageButton;
   import com.tapirgames.util.GraphicsUtil;

   import common.Define;

   public class SkinPC extends Skin
   {
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

//======================================================================
//
//======================================================================
      
      public function SkinPC (params:Object)
      {
         super (params);
      }
      
      override public function GetPreferredViewerSize (viewportWidth:Number, viewportHeight:Number):Point
      {
         return new Point (viewportWidth, viewportHeight + Define.DefaultPlayerSkinPlayBarHeight);
      }
      
      override public function GetContentRegion ():Rectangle
      {
         var top:Number = Define.DefaultPlayerSkinPlayBarHeight;
         
         return new Rectangle (0, top, mViewerWidth, mViewerHeight - top);
      }
      
      private var mPlayBar:Sprite  = null;
      
      private var mButtonRestart:ImageButton;
      private var mButtonStartPause:ImageButton;
      private var mButtonHelp:ImageButton;
      private var mButtonSpeeds:Array;

      private var mButtonZoomIn:ImageButton;
      private var mButtonZoomOut:ImageButton;

      private static const NumButtonSpeed:int = 5;
      private static const ButtonMargin:int = 8;
      
      override public function Rebuild (params:Object):void
      {
         GraphicsUtil.ClearAndDrawRect (this, 
                              0, 0, mViewerWidth - 1, Define.DefaultPlayerSkinPlayBarHeight, 
                              params.mPlayBarColor, 1, true, params.mPlayBarColor);
         
         // ...
         
         if (mPlayBar == null)
         {
            mPlayBar = new Sprite ();
            
            var i:int;
            var buttonX:Number = 0;
   
            // restart start/pause, stop
   
            mButtonRestart = new ImageButton (mBitmapDataRetartDisabled);
            mPlayBar.addChild (mButtonRestart);
   
            mButtonRestart.x = buttonX;
            buttonX += mButtonRestart.width;
   
            mButtonStartPause = new ImageButton (mBitmapDataStart);
            mButtonStartPause.SetClickEventHandler (OnClickStart);
            mPlayBar.addChild (mButtonStartPause);
   
            mButtonStartPause.x = buttonX;
            buttonX += mButtonStartPause.width;
   
            buttonX += ButtonMargin;
   
            // speed
   
            mButtonSpeeds = new Array (5);
   
            for (i = 0; i < NumButtonSpeed; ++ i)
            {
               mButtonSpeeds [i] = new ImageButton (mBitmapDataSpeed, i);
   
               if (mButtonShown [i] && params.mShowSpeedAdjustor)
               {
                  mButtonSpeeds [i].SetClickEventHandler (OnClickSpeed);
   
                  mPlayBar.addChild (mButtonSpeeds[i]);
   
                  mButtonSpeeds[i].x = buttonX;
                  buttonX += mButtonSpeeds[i].width - 1;
               }
            }
   
            buttonX += ButtonMargin;
   
            // zoom
   
            mButtonZoomIn = new ImageButton (mBitmapDataZoomIn);
            mButtonZoomOut = new ImageButton (mBitmapDataZoomOut);
   
            if (params.mShowScaleAdjustor)
            {
               mButtonZoomIn.SetClickEventHandler (OnClickZoomIn);
               mPlayBar.addChild (mButtonZoomIn);
   
               mButtonZoomOut.SetClickEventHandler (OnClickZoomOut);
               mPlayBar.addChild (mButtonZoomOut);
   
               mButtonZoomIn.x = buttonX;
               buttonX += mButtonZoomIn.width;
               mButtonZoomOut.x = buttonX;
               buttonX += mButtonZoomOut.width;
               buttonX += ButtonMargin;
            }
   
            // help
   
            mButtonHelp = new ImageButton (mBitmapDataHelp);
   
            if (params.mShowHelpButton)
            {
               mButtonHelp.SetClickEventHandler (OnClickHelp);
               mPlayBar.addChild (mButtonHelp);
   
               mButtonHelp.x = buttonX;
               buttonX += mButtonHelp.width;
               buttonX += ButtonMargin;
            }
   
            //
            addChild (mPlayBar);
            
            //
            OnClickSpeed (1); // speed X2
         }
         
         mPlayBar.x = 0.5 * (mViewerWidth - mPlayBar.width);
         mPlayBar.y = 0.5 * (Define.DefaultPlayerSkinPlayBarHeight - mPlayBar.height);
      }

      override protected function OnStartedChanged ():void
      {
         if (IsStarted ())
         {
            mButtonRestart.SetBitmapData (mBitmapDataRetart);
            mButtonRestart.SetClickEventHandler (OnClickRestart);
         }
         else
         {
            mButtonRestart.SetBitmapData (mBitmapDataRetartDisabled);
            mButtonRestart.SetClickEventHandler (null);
         }
      }
      
      override protected function OnPlayingChanged ():void
      {
         if (IsPlaying ())
         {
            mButtonStartPause.SetBitmapData (mBitmapDataPause);
            mButtonStartPause.SetClickEventHandler (OnClickPause);
         }
         else
         {
            mButtonStartPause.SetBitmapData (mBitmapDataStart);
            mButtonStartPause.SetClickEventHandler (OnClickStart);
         }
      }
      
      override protected function OnPlayingSpeedXChanged (oldSpeedX:int):void
      {
         var speedX:int = GetPlayingSpeedX ();
         
         for (var i:int = 0; i < NumButtonSpeed; ++ i)
         {
            if (ButtonIndex2SpeedXTable [i] == speedX)
               mButtonSpeeds [i].SetBitmapData (mBitmapDataSpeedSelected);
            else
               mButtonSpeeds [i].SetBitmapData (mBitmapDataSpeed);
         }
      }
      
      override protected function OnZoomScaleChanged (oldZoonScale:Number):void
      {
         var zoomScale:Number = GetZoomScale ();
         
         if (zoomScale <= Define.MinWorldZoomScale)
         {
            mButtonZoomOut.SetBitmapData (mBitmapDataZoomOutDisabled);
            mButtonZoomOut.SetClickEventHandler (null);
         }
         else if (oldZoonScale <= Define.MinWorldZoomScale)
         {
            mButtonZoomOut.SetBitmapData (mBitmapDataZoomOut);
            mButtonZoomOut.SetClickEventHandler (OnClickZoomOut);
         }

         if (zoomScale >= Define.MaxWorldZoomScale)
         {
            mButtonZoomIn.SetBitmapData (mBitmapDataZoomInDisabled);
            mButtonZoomIn.SetClickEventHandler (null);
         }
         else if (oldZoonScale >= Define.MaxWorldZoomScale)
         {
            mButtonZoomIn.SetBitmapData (mBitmapDataZoomIn);
            mButtonZoomIn.SetClickEventHandler (OnClickZoomIn);
         }
      }

//======================================================================
//
//======================================================================

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
         ShowHelpDialog ();
      }

   }
}
