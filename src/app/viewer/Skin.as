package viewer {

   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import com.tapirgames.util.GraphicsUtil;

   import common.Define;

   public class Skin extends Sprite
   {
//======================================================================
//
//======================================================================

      public function Skin (params:Object)
      {
         _OnRestart = params.OnRestart;
         _OnStart = params.OnStart;
         _OnPause = params.OnPause;
         _OnSpeed = params.OnSpeed;
         _OnZoom = params.OnZoom;
         
         _OnMainMenu = params.OnMainMenu;
         _OnNextLevel = params.OnNextLevel;
      }
      
//======================================================================
// viewer interfaces for skin
//======================================================================
      
      // interfaces from viewer, None can be null
      protected var _OnRestart:Function;
      protected var _OnStart:Function;
      protected var _OnPause:Function;
      protected var _OnSpeed:Function;
      protected var _OnZoom:Function;
      
      // these can be null
      protected var _OnMainMenu:Function;
      protected var _OnNextLevel:Function;
      
//======================================================================
// skin interfaces for viewer
//======================================================================
      
      // ...
      protected var mViewerWidth :Number;
      protected var mViewerHeight:Number;

      // ...
      private var mIsStarted:Boolean = false;
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      private var mZoomScale:Number = 1.0;
      
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
      
      public function Rebuild (params:Object):void
      {
         // to override
      }

      final public function IsStarted ():Boolean
      {
         return mIsStarted;
      }
      
      final public function NotifyStarted ():void
      {
         if (mIsStarted)
            return;
         
         mIsStarted = true;
         
         OnStartedChanged ();
      }
      
      final public function Restart ():void
      {
         mHasLevelFinishedDialogEverOpened = false;
         
         mIsStarted = false;
         
         if (_OnRestart != null)
            _OnRestart ();
         
         OnStartedChanged ();
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
         
         if (_OnSpeed != null)
            _OnSpeed ();
         
         OnPlayingSpeedXChanged (oldSpeedX);
      }
      
      protected function OnPlayingSpeedXChanged (oldSpeedX:int):void
      {
         // to override
      }

      final public function GetZoomScale ():Number
      {
         return mZoomScale;
      }

      final public function SetZoomScale (zoomScale:Number, smoothly:Boolean = true):void
      {
         if ( zoomScale <= Define.MinWorldZoomScale)
         {
            zoomScale = Define.MinWorldZoomScale;
         }

         if ( zoomScale >= Define.MaxWorldZoomScale)
         {
            zoomScale = Define.MaxWorldZoomScale;
         }
         
         if (mZoomScale == zoomScale)
            return;
         
         var oldZoonScale:Number = mZoomScale;
         mZoomScale = zoomScale;

         if (_OnZoom != null)
            _OnZoom (smoothly);
         
         OnZoomScaleChanged (oldZoonScale);
      }
      
      protected function OnZoomScaleChanged (oldZoonScale:Number):void
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

//======================================================================
//
//======================================================================

      protected function CenterSpriteOnContentRegion (sprite:Sprite):void
      {
         var contentRegion:Rectangle = GetContentRegion ();
         
         sprite.x = contentRegion.x + 0.5 * (contentRegion.width  - sprite.width );
         sprite.y = contentRegion.y + 0.5 * (contentRegion.height - sprite.height);
      }
      
      public static function CreateDialog (components:Array, dialog:Sprite = null):Sprite
      {
         if (dialog == null)
            dialog = new Sprite ();
         
         var margin:int = 20;
         var dialogWidth:Number = 0;
         var dialogHeight:Number = margin;
         
         var sprite:DisplayObject;
         var i:int;
         
         for (i = 0; i < components.length; ++ i)
         {
            if (components [i] is DisplayObject)
            {
               sprite = components [i] as DisplayObject;
               
               sprite.y = dialogHeight;
               
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
         
         dialogHeight += margin;
         dialogWidth += margin + margin;
         
         var bg:Sprite = new Sprite ();
         GraphicsUtil.DrawRect (bg, 0, 0, dialogWidth, dialogHeight, 0x606060, 2, true, 0x8080D0);
         dialog.addChildAt (bg, 0);
         
         for (i = 0; i < components.length; ++ i)
         {
            if (components [i] is DisplayObject)
            {
               sprite = components [i] as DisplayObject;
               
               sprite.x = (dialogWidth - sprite.width) * 0.5;
            }
         }
         
         return dialog;
      }

   }
}
