package viewer {

   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   
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
         _OnSpeedChanged = params.OnSpeedChanged;
         _OnScaleChanged = params.OnScaleChanged;
         _OnSoundControlChanged = params.OnSoundControlChanged;
         
         mHasMainMenu = params.mHasMainMenu;
         _OnExitLevel = params.OnExitLevel;
         _OnNextLevel = params.OnNextLevel;
         _OnGoToPhyard = params.OnGoToPhyard;
      }
      
//======================================================================
// viewer interfaces for skin
//======================================================================
      
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
      protected var _OnNextLevel:Function;
      protected var _OnGoToPhyard:Function;
      
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
         
         if (_OnSpeedChanged != null)
            _OnSpeedChanged ();
         
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

         if (_OnScaleChanged != null)
            _OnScaleChanged (smoothly);
         
         OnZoomScaleChanged (oldZoonScale);
      }
      
      protected function OnZoomScaleChanged (oldZoonScale:Number):void
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

//======================================================================
//
//======================================================================

      protected function CenterSpriteOnContentRegion (sprite:Sprite):void
      {
         if (sprite != null)
         {
            var contentRegion:Rectangle = GetContentRegion ();
            
            sprite.x = contentRegion.x + 0.5 * (contentRegion.width  - sprite.width );
            sprite.y = contentRegion.y + 0.5 * (contentRegion.height - sprite.height);
         }
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

//======================================================================
//
//======================================================================

      protected static var mPlayButtonData:Array = [
         [3,
             8,  0.0,
            -5, -12, 
            -5,  12,
         ],
      ];
      
      protected static var mPauseButtonData:Array = [
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
             -10, -12,
             -10,  12,
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
      
      protected static var mSoundOnButtonData:Array = [
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
      
      protected static var mSoundOffButtonData:Array = [
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
      
      protected static var mExitAppButtonData:Array = [
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
      
      protected static var mExitLevelButtonData:Array = [
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
      
      protected static var mNextLevelButtonData:Array = [
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
      
      protected static var mHelpButtonData:Array = [
         [3,
              -6,  -6,
             -10,  -6,
             -10, -17,
              11, -17,
              11,   2,
               2,   2,
               2,  11,
              -2,  11,
              -2,  -2,
               7,  -2,
               7, -13,
              -6, -13,
         ],
         [3,
              -2, 15,
               2, 15,
               2, 19,
              -2, 19,
         ],
      ];
      
      protected static var mSlowerButtonData:Array = [
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
      
      protected static var mFasterButtonData:Array = [
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
      
      //protected static var mScaleInButtonData:Array = [
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
      //protected static var mScaleOutButtonData:Array = [
      //   [1 | (5 << 8),
      //        -7, 0,
      //         7, 0,
      //   ],
      //   [0 | (5 << 8),
      //        0, 0, 13, 0, // x, y, radius, filled
      //   ],
      //];
      
      protected static var mScaleInButtonData:Array = [
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
      
      protected static var mScaleOutButtonData:Array = [
         [3,
              -12, -2,
              -12,  2,
               12,  2,
               12, -2,
         ],
      ];
      
      protected static const DefaultButtonBaseHalfSize:Number = 26.0;
      protected static const DefaultButtonBaseFilledColor:uint = 0x61a70e;
      protected static const DefaultButtonBaseBorderThickness:Number = 5.0;
      protected static const DefaultButtonBaseBorderColor:uint = 0x50e61d;
      protected static const DefaultButtonIconFilledColor:uint = 0xff0000;
      
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

      protected static function CreateButton (baseShapeType:int, buttonData:Array):Sprite
      {
         var baseShape:Shape = new Shape ();
         if (baseShapeType == 0) // circle
         {
            GraphicsUtil.DrawCircle (baseShape, 0, 0, DefaultButtonBaseHalfSize, DefaultButtonBaseFilledColor, DefaultButtonBaseBorderThickness, true, DefaultButtonBaseBorderColor);
         }
         else // rectangle
         {
            GraphicsUtil.DrawRect (baseShape, 
                                 - DefaultButtonBaseHalfSize, - DefaultButtonBaseHalfSize, DefaultButtonBaseHalfSize + DefaultButtonBaseHalfSize, DefaultButtonBaseHalfSize + DefaultButtonBaseHalfSize, 
                                 DefaultButtonBaseFilledColor, DefaultButtonBaseBorderThickness, true, DefaultButtonBaseBorderColor);
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
                  GraphicsUtil.DrawCircle (iconShape, shapeData [1], shapeData[2], shapeData[3], DefaultButtonIconFilledColor, thickness, shapeData[4] != 0, DefaultButtonIconFilledColor);
                  break;
               case 1: // polyline
                  GraphicsUtil.DrawPolyline (iconShape, ShapeDataToPointArray (shapeData), DefaultButtonIconFilledColor, thickness, true, false);
                  break;
               case 2: // curve
                  iconShape.graphics.lineStyle(thickness, DefaultButtonIconFilledColor);
                  iconShape.graphics.moveTo(shapeData [1], shapeData[2]);
                  iconShape.graphics.curveTo(shapeData[3], shapeData[4], shapeData[5], shapeData[6]);
                  break;
               case 3: // polygon
                  GraphicsUtil.DrawPolygon (iconShape, ShapeDataToPointArray (shapeData), 0x0, -1, true, DefaultButtonIconFilledColor);
                  break;
               default:
                  break;
            }
         }
         
         var button:Sprite = new Sprite;
         button.addChild (baseShape);
         button.addChild (iconShape);
         
         return button;
      }

   }
}
