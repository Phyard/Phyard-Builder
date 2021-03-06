
package viewer {

   import flash.utils.ByteArray;
   import flash.utils.Dictionary;

   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;

   import flash.system.System;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.utils.getTimer;

   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   import flash.events.ContextMenuEvent;

   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLLoader;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.net.navigateToURL;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.system.LoaderContext;
   
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   
   import flash.net.Socket;
   
   import mx.utils.SHA256;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.FrequencyStat;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;
   
   import com.tapirgames.gesture.GestureAnalyzer;
   import com.tapirgames.gesture.GesturePoint;
   import com.tapirgames.gesture.GestureSegment;
   
   import com.tapirgames.resloader.ResourceLoader;

   import common.DataFormat3;
   import common.ViewerDefine;
   import common.MultiplePlayerDefine;
   import common.Version;

   public class Viewer extends Sprite
   {
      include "LibCapabilities.as";
      include "LibGesture.as";
      include "LibSound.as";
      include "LibGraphics.as";
      include "LibCookie.as";
      include "LibServices.as";
      
//======================================================================
//
//======================================================================

   // input params, one and only one is not null

      private var mParamsFromContainer:Object; // can't be null, equals any of the following ones
   
         //todo: remove the followng 3 ones (seems they are usefull now)
         private var mParamsFromUniViewer:Object = null;
         private var mParamsFromEditor:Object = null;
         private var mParamsFromGamePackage:Object = null;

//======================================================================
//
//======================================================================

      internal var mStartRightNow:Boolean = false;
      internal var mMaskViewerField:Boolean = true;

      private var mBuildContextMenu:Boolean = true;

      // one of the following 2 is null
      private var mDesignAuthorSlotRevision:Object = null; // mAuthor, mAuthorForURL, mSlotID, mRevision
      private var mWorldPlayCode:String = null;
      private var mWorldPlayCodeFormat:String = null;

      private var mWorldBinaryData:ByteArray = null;
      private var mWorldSourceCode:String = null;

      private var mPlayerWorld:Object = null;
         private var mShowPlayBar:Boolean;
         private var mUseOverlaySkin:Boolean;
         private var mPlayBarColor:uint;
         private var mShowSpeedAdjustor:Boolean;
         private var mShowScaleAdjustor:Boolean;
         private var mShowSoundAdjustor:Boolean;
         private var mShowHelpButton:Boolean;
         private var mShowSoundController:Boolean;
         private var mShowLevelFinishedDialog:Boolean;
         private var mAdaptiveViewportSize:Boolean;
         private var mPreferredViewportWidth:int;
         private var mPreferredViewportHeight:int;

      //private var mIsPlaying:Boolean = false;
      //private var mPlayingSpeedX:int = 2;

      private var mWindowPadding:Rectangle = new Rectangle (0, 0, 0, 0);
      private var mPlayerWorldLayerScale:Number = 1.0;
      
      private var mPlayerWorldZoomScale:Number = 1.0;
      private var mPlayerWorldZoomScaleChangedSpeed:Number = 0.0;

      private var mBackgroundLayer:Sprite = new Sprite ();
      private var mMiddleLayer:Sprite = new Sprite ();
         private var mContentLayer:Sprite = new Sprite ();
            private var mWorldLayer:Sprite = new Sprite ();
            //private var mViewportMaskShape:Sprite = new Sprite ();
            private var mViewportMaskRect:Rectangle = new Rectangle ();
         private var mSkinLayer:Sprite = new Sprite ();
      private var mForegroundLayer:Sprite = new Sprite ();
         private var mErrorMessageLayer:Sprite = new Sprite ();
         private var mGesturePaintLayer:Sprite = new Sprite ();
      private var mFadingLayer:Sprite = new Sprite ();

//======================================================================
//
//======================================================================

      public function Viewer (params:Object = null)
      {
         //trace ("Viewer params = " + params);

         if (params == null) // strange: flash auto instance this class when loading done. shit!
            return;

         addChild (mBackgroundLayer);
         addChild (mMiddleLayer);
            mMiddleLayer.addChild (mContentLayer)
               mContentLayer.addChild (mWorldLayer);
            mMiddleLayer.addChild (mSkinLayer);
         addChild (mForegroundLayer);
            mForegroundLayer.addChild (mErrorMessageLayer);
            mForegroundLayer.addChild (mGesturePaintLayer);
         addChild (mFadingLayer);
         
         mErrorMessageLayer.visible = false;
         mGesturePaintLayer.visible = false;
         mFadingLayer.visible = false;

         mParamsFromUniViewer = params.mParamsFromUniViewer;
         if (mParamsFromUniViewer != null)
            mParamsFromContainer = mParamsFromUniViewer;
         mParamsFromEditor = params.mParamsFromEditor;
         if (mParamsFromEditor != null)
            mParamsFromContainer = mParamsFromEditor;
         mParamsFromGamePackage = params.mParamsFromGamePackage;
         if (mParamsFromGamePackage != null)
            mParamsFromContainer = mParamsFromGamePackage;

         // ...
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
      }

      private function OnAddedToStage (e:Event):void
      {
         mDefaultRenderQuality = stage.quality;
         
         // ...
         
         CheckPlatformCapabilities ();
         
         if (mTouchEventClass != null)
         {
            // mMultitouchClass must not null
            mMultitouchClass.inputMode = "touchPoint"; // mMultitouchClass.TOUCH_POINT; // MultitouchInputMode.TOUCH_POINT
            
            addEventListener (/*TOUCH_BEGIN.TOUCH_BEGIN*/"touchBegin", OnTouchBegin, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            addEventListener (/*TOUCH_BEGIN.TOUCH_MOVE*/"touchMove", OnTouchMove, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            addEventListener (/*TOUCH_BEGIN.TOUCH_END*/"touchEnd", OnTouchEnd, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
         }
         else
         {
            addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            addEventListener (MouseEvent.MOUSE_UP, OnMouseUp, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            
            TryToRegisterToggleInfoShowingKey ();
         }
         
         // ...
         
         addEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
         addEventListener (Event.ENTER_FRAME, Update);
         
         //mGesturePaintLayer.mouseEnabled = false;
         mGesturePaintLayer.mouseChildren = false;
         mGesturePaintLayer.addEventListener (MouseEvent.CLICK, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.addEventListener (MouseEvent.MOUSE_DOWN, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.addEventListener (MouseEvent.MOUSE_MOVE, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.addEventListener (MouseEvent.MOUSE_UP, OnMouseEvent_GesturePaintLayer);
         
         stage.addEventListener (Event.ACTIVATE, OnActivated);
         stage.addEventListener (Event.DEACTIVATE, OnDeactivated);
         
         // ...

         ParseParams ();
         
         RepaintFullScreenLayersWithBackgroundColor ();
      }

      private function OnRemovedFromStage (e:Event):void
      {
         stage.quality = mDefaultRenderQuality;

         stage.removeEventListener (Event.ACTIVATE, OnActivated);
         stage.removeEventListener (Event.DEACTIVATE, OnDeactivated);
         
         mGesturePaintLayer.removeEventListener (MouseEvent.CLICK, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.removeEventListener (MouseEvent.MOUSE_UP, OnMouseEvent_GesturePaintLayer);
         
         removeEventListener (Event.ENTER_FRAME, Update);
         removeEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
         
         //removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); 
               // this one don't need to be removed. Otherwise, 
               // the game package optimization for 1-level will crash.
         
         if (mTouchEventClass != null)
         {
            removeEventListener (/*TOUCH_BEGIN.TOUCH_BEGIN*/"touchBegin", OnTouchBegin, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            removeEventListener (/*TOUCH_BEGIN.TOUCH_MOVE*/"touchMove", OnTouchMove, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ();
            removeEventListener (/*TOUCH_BEGIN.TOUCH_END*/"touchEnd", OnTouchEnd, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
         }
         else
         {
            removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ();
            removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp, true); // must useCapture, otherwise MouseMoveEvent.stageX/Y may be changed by MouseMoveEvent.target.transform ()
            
            TryToUnregisterToggleInfoShowingKey ();
         }
         
         // ...
         
         CloseAllSounds ();
               // up to here, for one-level game package, mWorldDesignProperties.OnViewerDestroyed is not called.
      }
      
      // from v2.02, called manually
      // the isTheLastViewer param is added since v2.06, for multiple players feature.
      public function Destroy (isTheLastViewer:Boolean):void
      {
         DisonnectToInstanceServer ();
         
         if (mWorldDesignProperties != null) // && mWorldDesignProperties.OnViewerDestroyed != null)
         {
            try
            {            
               mWorldDesignProperties.OnViewerDestroyed ({
                                                           mIsTheLastViewer: isTheLastViewer
                                                        });
            }
            catch (error:Error)
            {
               TraceError (error);
            }
         }
      }
      
      // for editor, multiple player
      
      private var mIsCurrentViewer:Boolean = true;
      
      public function SetAsCurrentViewer (cv:Boolean):void
      {
         mIsCurrentViewer = cv;
      }
      
      private function IsCurrentViewer ():Boolean
      {
         return mIsCurrentViewer;
      }
      
      private var mVisible:Boolean = true;
      
      public function SetVisible (v:Boolean):void
      {
         mVisible = v;
         
         this.visible = mVisible;
      }
      
      // for game packageer, "should update frame"
      
      private var mActive:Boolean = true;
      
      public function SetActive (active:Boolean):void
      {
         mActive = active;
         
         SetVisible (mActive);;
      }

//======================================================================
// stop simulation on mobile devices
//======================================================================
      
      private var mIsAppDeactivated:Boolean = false;
      
      public function OnActivated (event:Event):void
      {
         mIsAppDeactivated = false;
         
         //SetSoundVolume (mSoundVolume);
         UpdateSoundVolume ();
      }
      
      public function OnDeactivated (event:Event):void
      {
         mIsAppDeactivated = true;
         
         if (mStateId == StateId_Playing && mWorldDesignProperties != null && (mWorldDesignProperties.IsPauseOnFocusLost () as Boolean))
         {
            if (mSkin != null) mSkin.OnDeactivate ();
         }
      }

//======================================================================
// platform capabilities
//======================================================================

      private static var mIsTouchScreen:Boolean = false; // false for PC device
         //private static var mIsPhoneDevice:Boolean = false; // only valid when mIsMobileDevice is true
      
      private static var mGeolocationClass:Object = null;
      private static var mAccelerometerClass:Object = null;
         private static var mAccelerometerInstance:Object; //flash.sensors.Accelerometer;
      private static var mMultitouchClass:Object = null;
      private static var mTouchEventClass:Object = null;
      
      private static var mPlatformCapabilitiesChecked:Boolean = false;
      
      private static var mIsIOS:Boolean = false;
      private static var mIsIOS_7Plus:Boolean = false;
      private static var mIsIPad:Boolean = false;
      
      private static function CheckPlatformCapabilities ():void
      {
         if (mPlatformCapabilitiesChecked)
            return;
         
         mPlatformCapabilitiesChecked = true;
         
         try
         {
         
            var os:String = Capabilities.os;
            
            if (os != null)
            {
               os = os.toLowerCase ();
               mIsIOS = os.indexOf ("iphone") >= 0;
               mIsIPad = os.indexOf ("ipad") >= 0;
               
               var text:String = " os ";
               var index:int = os.indexOf (text)
               if (index >= 0)
               {
                  var index1:int = index + text.length;
                  if (index1 < os.length - 1)
                  {
                     var index2:int = os.indexOf (".", index1);
                     var osversion:Number = parseInt (os.substring (index1, index2));
                     if (! isNaN (osversion))
                     {
                        mIsIOS_7Plus = osversion >= 7;
                     }
                  }
               }
               
               // iPhone OS 8.1.3 iPad2,1
               // iPhone OS 8.1.3 iPhone5,2
            }
             
            //Capabilities.pixelAspectRatio;
            //Capabilities.language // en, zh-TW, zh-CN, ru, pt, fr, de, es, ar, ...
            //Capabilities.isDebugger
            //Capabilities.playerType // 
                // "StandAlone" for the stand-alone Flash Player
                // "External" for the external Flash Player or in test mode
                // "PlugIn" for the Flash Player browser plug-in
                // "ActiveX" for the Flash Player ActiveX control used by Microsoft Internet Explorer
            //Capabilities.version
                // WIN 9,0,0,0  // Flash Player 9 for Windows
                // MAC 7,0,25,0   // Flash Player 7 for Macintosh
                // UNIX 5,0,55,0  // Flash Player 5 for UNIX
            //Capabilities.serverString
            
            //var dpi:int = Capabilities.screenDPI;
            //var screenX:int = Capabilities.screenResolutionX;
            //var screenY:int = Capabilities.screenResolutionY;
            //var diagonal:Number = Math.sqrt((screenX*screenX)+(screenY*screenY))/dpi;
            //// if diagonal is higher than 6, we will assume it is a tablet or PC
            //mIsPhoneDevice = diagonal < 6;
            //
            //if (mIsPhoneDevice)
            //{
            //   mIsTouchScreen = true;
            //}
            //else
            //{
            //   var manufacturer:String = Capabilities.manufacturer;
            //   manufacturer = (manufacturer == null ? "" : manufacturer.toLowerCase ());
            //   var osname:String = Capabilities.os;
            //   osname = (osname == null ? "" : osname.toLowerCase ());
            //   if (manufacturer.indexOf ("android") >= 0 || osname.indexOf ("ios") >= 0 || manufacturer.indexOf ("phone") >= 0 || manufacturer.indexOf ("pad") >= 0) // phone may be iphone or "windows phone" or "lephone"
            //   {
            //      mIsTouchScreen = true;
            //   }
            //   if (! mIsMobileDevice)
            //   {
            //      if (osname.indexOf ("android") >= 0 || osname.indexOf ("ios") >= 0 || osname.indexOf ("phone") >= 0 || osname.indexOf ("pad") >= 0)
            //      {
            //         mIsTouchScreen = true;
            //      }
            //   }
            //}
         
            // 
         
            if (ApplicationDomain.currentDomain.hasDefinition ("flash.sensors.Geolocation"))
            {
               mGeolocationClass = ApplicationDomain.currentDomain.getDefinition ("flash.sensors.Geolocation") as Class;
               if (mGeolocationClass != null && (! mGeolocationClass.isSupported))
               {
                  mGeolocationClass = null;
               }
               
               if (mGeolocationClass != null)
               {
               }
            }
               
            //if ((! mIsMobileDevice) && mGeolocationClass != null)
            //{
            //   mIsMobileDevice = true;
            //}
            
            if (ApplicationDomain.currentDomain.hasDefinition ("flash.sensors.Accelerometer"))
            {
               mAccelerometerClass = ApplicationDomain.currentDomain.getDefinition ("flash.sensors.Accelerometer") as Class;
               if (mAccelerometerClass != null && (! mAccelerometerClass.isSupported))
               {
                  mAccelerometerClass = null;
               }
               
               if (mAccelerometerClass != null)
               {
                  mAccelerometerInstance = new mAccelerometerClass ();
                  mAccelerometerInstance.addEventListener("update", OnAccelerationUpdate); //AccelerometerEvent.UPDATE, onUpdate)
               } 
            }
               
            //if ((! mIsMobileDevice) && mAccelerometerClass != null)
            //{
            //   mIsMobileDevice = true;
            //}
            
            if (ApplicationDomain.currentDomain.hasDefinition ("flash.ui.Multitouch"))
            {
               mMultitouchClass = ApplicationDomain.currentDomain.getDefinition ("flash.ui.Multitouch") as Class;
               
               //if (mMultitouchClass.maxTouchPoints <= 0)
               //{
               //   mMultitouchClass = null;
               //}
               
               if (mMultitouchClass != null && (! mMultitouchClass.supportsTouchEvents))
               {
                  mMultitouchClass = null;
               }
            }
               
            mIsTouchScreen = mMultitouchClass != null;
            
            if (mIsTouchScreen && ApplicationDomain.currentDomain.hasDefinition ("flash.events.TouchEvent"))
            {
               mTouchEventClass = ApplicationDomain.currentDomain.getDefinition ("flash.events.TouchEvent") as Class;
            }
         }
         catch (error:Error)
         {
            TraceError (error);
         }
      }
      
      private static var mAccelerationX:Number = 0.0;
      private static var mAccelerationY:Number = 1.0;
      private static var mAccelerationZ:Number = 0.0;
      
      private static function IsAccelerometerSupported ():Boolean
      {
         return mAccelerometerClass != null;
      }
      
      private static function GetAcceleration (valuesToFill:Array = null):Array
      {
         if (valuesToFill == null)
            valuesToFill = new Array (3);
         
         valuesToFill [0] = mAccelerationX;
         valuesToFill [1] = mAccelerationY;
         valuesToFill [2] = mAccelerationZ;
         
         return valuesToFill;
      }
      
      private static function OnAccelerationUpdate (event:Object):void // AccelerometerEvent):void
      {
         //mAccelerationX = - event.accelerationX; // why? // bug
            // !!! revert some bad changes in revison 2b7b691dca3f454921e229eb20163850675adda1 - now ccats and functions are edit in dialogs
         
         mAccelerationX = event.accelerationX;
         mAccelerationY = event.accelerationY;
         mAccelerationZ = event.accelerationZ;
      }
      
      private static var _DebugString:String = "";
      private function GetDebugString ():String
      {
         //if (ApplicationDomain.currentDomain.hasDefinition ("flash.sensors.Accelerometer"))
         //{
         //   var accelerometerClass:Object = ApplicationDomain.currentDomain.getDefinition ("flash.sensors.Accelerometer") as Class;
         //   var info:String = "acc class: " + accelerometerClass;
         //   if (accelerometerClass != null)
         //   {
         //      info = info + "\nsupported: " + mAccelerometerClass.isSupported;
         //   }
         //   
         //   return info;
         //}
         //         
         //return "null";
         return _DebugString;
         //+ "\nmMiddleLayer"
         //+ "\nmMiddleLayer.y=" + mMiddleLayer.y
         //+ "\nmContentLayer.y=" + mContentLayer.y
         //+ "\nmWorldLayer.y=" + mWorldLayer.y
         //+ "\nmPlayerWorld.y=" + mPlayerWorld.y
         //+ "\nmViewportMaskRect=" + mViewportMaskRect
         //;
         
      }
      
      private function GetAppID ():String
      {
         if (ApplicationDomain.currentDomain.hasDefinition ("flash.desktop.NativeApplication"))
         {
            var NativeAppClass:Object = ApplicationDomain.currentDomain.getDefinition ("flash.desktop.NativeApplication") as Class;
            if (NativeAppClass != null)
            {
               return NativeAppClass.nativeApplication.applicationID;
            }
         }
         
         return "";
      }
      
      private function GetAppRootURL ():String
      {
         return mParamsFromContainer.mAppRootURL == undefined ? "" : mParamsFromContainer.mAppRootURL;
      }
      
      private function IsNativeApp ():Boolean
      {
         return mParamsFromContainer.mIsNativeApp != undefined && (mParamsFromContainer.mIsNativeApp as Boolean);
      }
      
      private function IsFullScreen ():Boolean
      {
         return mParamsFromContainer.mIsFullScreen != undefined && (mParamsFromContainer.mIsFullScreen as Boolean);
      }
      
      private static function GetScreenResolution ():Point
      {
         return new Point (Capabilities.screenResolutionX, Capabilities.screenResolutionY);
      }
      
      private static function GetScreenDPI ():Number
      {
         return Capabilities.screenDPI;
      }

//======================================================================
// gesture lib
//======================================================================

      // for game template
      public static function CreateGestureAnalyzer (minGestureSize:Number):GestureAnalyzer
      {
         return new GestureAnalyzer (Capabilities.screenDPI * minGestureSize, Capabilities.screenDPI * 0.02);
      }
      
      // for world
      private var mEnabledMouseGesture:Boolean = false;
      private var mDrawdMouseGesture:Boolean = false;
      private var mMinGestureSize:Number = 0.2;
      private var mGestureColor:uint = 0x00FF00;
      
      private function SetMouseGestureSupported (supported:Boolean, draw:Boolean,
                                                minGestureSize:Number = 0.2, // this parameter is added from v2.10
                                                gestureColor:uint = 0x00FF00 // this parameter is added from v2.10
                                                ):void
      {
         mEnabledMouseGesture = supported;
         mDrawdMouseGesture = supported && draw;
         mMinGestureSize = Math.max (0.1, minGestureSize);
         mGestureColor = gestureColor;
         
         mGesturePaintLayer.visible = mDrawdMouseGesture; // mEnabledMouseGesture && mDrawdMouseGesture;
         
         if (! mGesturePaintLayer.visible)
         {
            //mGestureAnalyzer = null;
            ClearGesturePaintLayer ();
         }
      }
      
      // ...
      
      //private var mGestureAnalyzer:GestureAnalyzer = null;
      
      private var mGestureInfoTable:Dictionary = null; //new Dictionary ();
      private var mGestureInfos:Array = null; //new Array (32);
      private var mNumGestureInfos:int = 0;
      
      private function CreateGestureInfo (touchId:int):Object
      {
         var gestureInfo:Object = {
                     mTouchID        : touchId,
                     mGestureAnalyzer: CreateGestureAnalyzer (mMinGestureSize),
                     mGestureSprite  : null,
                     mIsEnd          : false
                  };
         
         //if (mDrawdMouseGesture)
         //{
         //   mGesturePaintLayer.addChild (gestureInfo.mGestureSprite);
         //   mGesturePaintLayer.visible = true;
         //}
         
         if (mGesturePaintLayer.visible)
         {
            gestureInfo.mGestureSprite = new Sprite ();
            mGesturePaintLayer.addChild (gestureInfo.mGestureSprite);
         }
         
         mGestureInfos [mNumGestureInfos ++] = gestureInfo;
         
         mGestureInfoTable [touchId] = gestureInfo;
         
         return gestureInfo;
      }
      
      private function ClearGesturePaintLayer ():void
      {
         //mGesturePaintLayer.graphics.clear ();
         while (mGesturePaintLayer.numChildren > 0)
            mGesturePaintLayer.removeChildAt (0);
         
         //mGesturePaintLayer.alpha = 1.0;
         //mGesturePaintLayer.visible = false;
         
         if (mNumGestureInfos > 0 || mGestureInfoTable == null || mGestureInfos == null)
         {
            mGestureInfoTable = new Dictionary ();
            mGestureInfos = new Array (32);
            mNumGestureInfos = 0;
         }
      }
      
      private function UpdateGesturePaintLayer ():void
      {  
         //if (mGesturePaintLayer.visible && mGestureAnalyzer == null)
         //{
         //   mGesturePaintLayer.alpha -= 1.0 / stage.frameRate; // mWorldDesignProperties.GetPreferredFPS ()
         //   if (mGesturePaintLayer.alpha < 0)
         //   {
         //      ClearGesturePaintLayer ();
         //   }
         //}
         
         //if (mGesturePaintLayer.visible)
         //{
            var oldNumGestures:int = mNumGestureInfos;
            var deltaAlpha:Number = 1.0 / stage.frameRate;
            var i:int = 0;
            var gestureInfo:Object;
            var done:Boolean;
            while (i < mNumGestureInfos)
            {
               gestureInfo = mGestureInfos [i];
               done = gestureInfo.mGestureSprite == null;

               if ((! done) && gestureInfo.mIsEnd)
               {
                  gestureInfo.mGestureSprite.alpha -= deltaAlpha;
                  if (gestureInfo.mGestureSprite.alpha <= 0.0)
                  {
                     if (gestureInfo.mGestureSprite.parent != null)
                        gestureInfo.mGestureSprite.parent.removeChild (gestureInfo.mGestureSprite);
                     
                     done = true;
                  }
               }
               
               if (done)
               {
                  // put in OnGestureEnd now.
                  //if (mGestureInfoTable [gestureInfo.mTouchID] == gestureInfo) // should be always
                  //   delete mGestureInfoTable [gestureInfo.mTouchID];
                  
                  mGestureInfos [i] = mGestureInfos [-- mNumGestureInfos];
                  mGestureInfos [mNumGestureInfos] = null;
                  
                  continue;
               }
               
               ++ i;
            }
            
            if (oldNumGestures > 0 && mNumGestureInfos <= 0)
            {
               ClearGesturePaintLayer ();
            }
         //}
      }
      
      private function OnGestureBegin (touchId:int, eventStageX:Number, eventStageY:Number):void
      {
         if (mGestureInfoTable == null)
            return;
         
         //if (mEnabledMouseGesture)
         //{
         //   mGestureAnalyzer = CreateGestureAnalyzer ();
         //   ClearGesturePaintLayer ();
         //   mGesturePaintLayer.visible = mDrawdMouseGesture;
         //   
         //   RegisterGesturePoint (eventStageX, eventStageY);
         //}
         
         var gestureInfo:Object = mGestureInfoTable [touchId];
         
         if (gestureInfo == null && mEnabledMouseGesture)
         {
            gestureInfo = CreateGestureInfo (touchId);
            
            RegisterGesturePoint (gestureInfo, eventStageX, eventStageY);
         }
      }
      
      private function OnGesturePaint (touchId:int, eventStageX:Number, eventStageY:Number, buttomDown:Boolean):void
      {
         if (mGestureInfoTable == null)
            return;
         
         var gestureInfo:Object = mGestureInfoTable [touchId];
         
         if (gestureInfo != null)
         {
            if (mEnabledMouseGesture && buttomDown)
            {
               RegisterGesturePoint (gestureInfo, eventStageX, eventStageY);
            }
            else
            {
               //mGestureAnalyzer = null;
               //ClearGesturePaintLayer ();
               
               gestureInfo.mGestureAnalyzer = null;
            }
         }
      }
      
      private function OnGestureEnd (touchId:int, eventStageX:Number, eventStageY:Number):void
      {
         if (mGestureInfoTable == null)
            return;
         
         var gestureInfo:Object = mGestureInfoTable [touchId];
         
         if (gestureInfo != null)
         {
            gestureInfo.mIsEnd = true;
            if (mEnabledMouseGesture)
            {
               //RegisterGesturePoint (gestureInfo, eventStageX, eventStageY); // the release point oftern is bad point.
               
               gestureInfo.mGestureAnalyzer.Finish (getTimer ());
               var result:Object = gestureInfo.mGestureAnalyzer.Analyze ();
               
               if (mPlayerWorld != null && result.mGestureType != null)
                  mWorldDesignProperties.RegisterGestureEvent (result);
            }
            
            gestureInfo.mGestureAnalyzer = null;
            
            delete mGestureInfoTable [gestureInfo.mTouchID];
               // deleted from hashtable, but not from mGestureInfos array yet.
         }
         //else
         //{
         //   ClearGesturePaintLayer ();
         //}
         //
         //mGestureAnalyzer = null;
      }
      
      private function OnMouseDown (event:MouseEvent):void
      {
         OnGestureBegin (0, event.stageX, event.stageY);
      }
      
      private function OnMouseMove (event:MouseEvent):void
      {
         OnGesturePaint (0, event.stageX, event.stageY, event.buttonDown);
      }
      
      private function OnMouseUp (event:MouseEvent):void
      {
         OnGestureEnd (0, event.stageX, event.stageY);
      }
      
      private function OnTouchBegin (touchEvent:Object):void
      {
         OnGestureBegin (touchEvent.touchPointID, touchEvent.stageX, touchEvent.stageY);
      }
      
      private function OnTouchMove (touchEvent:Object):void
      {
         OnGesturePaint (touchEvent.touchPointID, touchEvent.stageX, touchEvent.stageY, true);
      }
      
      private function OnTouchEnd (touchEvent:Object):void
      {
         OnGestureEnd (touchEvent.touchPointID, touchEvent.stageX, touchEvent.stageY);
      }
      
      //private function RegisterGesturePoint (event:MouseEvent):void
      private function RegisterGesturePoint (gestureInfo:Object, eventStageX:Number, eventStgeY:Number):void
      {
         if (mStateId != StateId_Playing || mCurrentPlayingStatePhase != PlayingStatePhase_Stepping)
            return;
         
         if (gestureInfo == null || gestureInfo.mGestureAnalyzer == null)
            return;
         
         //var gesturePoint:GesturePoint = mGestureAnalyzer.RegisterPoint (event.stageX / stage.scaleX, event.stageY / stage.scaleY, getTimer ());
         // todo: bug? should be eventStageX * stage.scaleX, eventStgeY * stage.scaleY?
         var gesturePoint:GesturePoint = gestureInfo.mGestureAnalyzer.RegisterPoint (eventStageX / stage.scaleX, eventStgeY / stage.scaleY, getTimer ());
         if (gesturePoint != null && gestureInfo.mGestureSprite != null)
         {
            var point:Point = globalToLocal (new Point (gesturePoint.mX * stage.scaleX, gesturePoint.mY * stage.scaleY));
            if (gesturePoint.mPrevPoint == null)
            {
               gestureInfo.mGestureSprite.graphics.lineStyle ();
               gestureInfo.mGestureSprite.graphics.beginFill (mGestureColor);
               gestureInfo.mGestureSprite.graphics.drawCircle (point.x, point.y, 9);
               gestureInfo.mGestureSprite.graphics.endFill ();
            }
            else
            {
               gestureInfo.mGestureSprite.graphics.lineStyle(9, mGestureColor);
               gestureInfo.mGestureSprite.graphics.moveTo (point.x, point.y);

               point = globalToLocal (new Point (gesturePoint.mPrevPoint.mX * stage.scaleX, gesturePoint.mPrevPoint.mY * stage.scaleY));
               gestureInfo.mGestureSprite.graphics.lineTo (point.x, point.y);
            }
         }
      }

//======================================================================
// mouse event
//======================================================================

      // !!! this function is introduced from v2.00 to fix the missed event triggerings caused by gesture shape overlapping.
      // ref: http://stackoverflow.com/questions/4924558/listen-to-click-event-on-overlapped-sprites
      // todo: still not a good fix! See player.World.OnViewerEvent for more.
      
      // [update at v2.10]: now the fix is cancelled, for follwoing reasons:
      // 1. designers shoud be aware that when gesture shapes are painted, world events lossing is just normal.
      // 2. the fix is never implemented perfectly.
      // 3. with incroducing the multitouch events, keeping this fix will bring many complexisties:
      //    > a. world should maintain a hastable to record if a touch point is down on the world
      //    > b. when a tocuh point ends, viewer should notify world, eitehr the end point is in world or not.
      // 4. even if the fix is implemented well, for potiential skin overlapping world cases later.
      //    there is no a safe method to judge if the touch end point is in world or not.
      
      private function OnMouseEvent_GesturePaintLayer (event:MouseEvent):void
      {
         //if (mPlayerWorld != null)
         //{
         //   var clonedEvent:MouseEvent = event.clone () as MouseEvent;
         //   clonedEvent.delta = 0x7FFFFFFF; // indicate mPlayerWorld this event is sent from here
         //   mPlayerWorld.dispatchEvent(clonedEvent);
         //}
         
         if (mWorldPluginProperties == null || mWorldPluginProperties.mWorldVersion >= 0x0210)
            return;
         
         if (mWorldDesignProperties != null) // && mWorldDesignProperties.OnViewerEvent != null)
         {
            //var clonedEvent:MouseEvent = event.clone () as MouseEvent;
            //mWorldDesignProperties.OnViewerEvent (clonedEvent);
            
            // problem: event.stageX and event.stageY are both 0 and are not writable.
            // so pass the origial event instead.
            // only its stageX and stageY properites are used.
            
            var stagePoint:Point = new Point (event.stageX, event.stageY);
            var worldPoint:Point = mWorldLayer.globalToLocal (stagePoint);
            
            // this "if" may cause a little incompatibility
            if (worldPoint.x >= 0 && worldPoint.y >= 0 && worldPoint.x < mViewportMaskRect.width && worldPoint.y < mViewportMaskRect.height)
            {
               mWorldDesignProperties.OnViewerEvent (event);
            }
         }
      }

//======================================================================
//
//======================================================================

      private static const StateId_Unknown:int = -1;
      private static const StateId_Loading:int = 0;
      private static const StateId_Playing:int = 1;
      private static const StateId_Error:int = 2;

      private var mStateId:int = StateId_Unknown;

      public function Update (event:Event):void
      {
         if (mIsAppDeactivated && mIsTouchScreen)
            return; // avoid making the mobile device slow
         
         switch (mStateId)
         {
            case StateId_Loading:
               // Load progress on screen
               break;
            case StateId_Playing:
               UpdatePlaying ();
               break;
            case StateId_Error:
               ExitLevelIfBackKeyEverPressed ();
               // todo: "Copy Error Message" and "Report Error" in Context Menu
               break;
            //case StateId_Unknown:
            default:
               ExitLevelIfBackKeyEverPressed ();
               break;
         }
      }

      public function ChangeState (stateId:int):void
      {
         //trace ("change state: " + stateId + "\n" + new Error ().getStackTrace ());
         
         mStateId = stateId;
         
         //switch (mStateId)
         //{
         //   case StateId_Loading:
         //      break;
         //   case StateId_Playing:
         //      break;
         //   case StateId_Error:
         //      //SetErrorMessage ("Runtime error!");
         //      break;
         //   //case StateId_Unknown:
         //   default:
         //      break;
         //}
      }
      
//======================================================================
//
//======================================================================
      
      private function OnError (errorTitle:String, error:Error):void
      {
         if (error == null)
            SetErrorMessage ("Error: title=" + errorTitle);
         else
            SetErrorMessage ("Error: id=" + error.errorID + ", title=" + errorTitle 
                           + "\nerror message: " + error.message 
                           + "\n" + error.getStackTrace ()
                           );

         ChangeState (StateId_Error);
         
         TraceError (error);
     }
     
     private static function TraceError (error:Error):void
     {
         if (Capabilities.isDebugger)
         {
            trace (error.getStackTrace ());
            throw error;
         }
      }

      private var mErrorMessageText:TextFieldEx = null;
      
      private function SetErrorMessage (errorMessage:String):void
      {           
         this.visible = mVisible; // true; // since v2.06, multiple players feature is added.
         
         if (mParamsFromUniViewer != null && mParamsFromUniViewer.SetLoadingText != null)
         {
            mParamsFromUniViewer.SetLoadingText (null);
         }
         
         if (errorMessage == null)
         {
            mErrorMessageLayer.visible = false;
            return;
         }
         
         mErrorMessageLayer.visible = true;
         
         if (mErrorMessageText != null && mErrorMessageText.parent == mErrorMessageLayer)
            mErrorMessageLayer.removeChild (mErrorMessageText);
         
         mErrorMessageText = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText (errorMessage), true, 0xFFFFFF);
         mErrorMessageLayer.addChild (mErrorMessageText);
         
//mErrorMessageText.scaleX=mErrorMessageText.scaleY=0.5;

         CenterErrorMessageText ();
      }
//public static var debugInfo:String = "";
      
      private function CenterErrorMessageText ():void
      {
         if (mErrorMessageText != null)
         {
            var containerSize:Point = mParamsFromContainer.GetViewportSize ();
            
            mErrorMessageText.x = 0.5 * (containerSize.x - mErrorMessageText.width );
            mErrorMessageText.y = 0.5 * (containerSize.y - mErrorMessageText.height);
         }
      }

//======================================================================
// 
//======================================================================
      
      //private var mUniViewerUrl:String;
      //private var mFlashParams:Object;

      private var mWorldPluginUrl:String;
      private var mWorldPluginFileSize:int = 0;
      
      private var mLoadDataUrl:String;
      
      private var mParamsParsed:Boolean = false;
      
      public function ParseParams ():void
      {
         mParamsParsed = true;
         
         try
         {
            if (mParamsFromEditor != null || mParamsFromGamePackage != null)
            {
               mMaskViewerField = mParamsFromContainer.mMaskViewerField;

               mWorldBinaryData = mParamsFromContainer.mWorldBinaryData;
               mStartRightNow = mParamsFromContainer.mStartRightNow == undefined ? true : mParamsFromContainer.mStartRightNow;
               mWorldPluginDomain = mParamsFromContainer.mWorldDomain;
               
               ReloadPlayerWorld (mParamsFromEditor != null ? mParamsFromEditor.mCurrentSceneId : 0);
            }
            else if (mParamsFromUniViewer != null)
            {
               //mFlashParams = mParamsFromUniViewer.mFlashVars;

               //mUniViewerUrl = mParamsFromUniViewer.mUniViewerUrl;

               //var stream:ByteArray = mParamsFromUniViewer.mDesignInfoStream;
               //var designRevision:int = stream.readInt ();
               //var worldPluginUrl:String = stream.readUTF ();
               var designRevision:int = mParamsFromUniViewer.mDesignRevision;
               var worldPluginUrl:String = mParamsFromUniViewer.mWorldPluginFileName;
               mWorldPluginFileSize = mParamsFromUniViewer.mWorldPluginFileSize;
               var worldUUID:String = mParamsFromUniViewer.mWorldUUID;
               if (worldUUID != null && worldUUID.length == 0) worldUUID = null;
               
               var isUniPlayer:Boolean = mParamsFromUniViewer.mUniViewerUrl.indexOf ("/uniplayer.swf") >= 0;
               
               if (mParamsFromUniViewer.mFlashVars.author != null && mParamsFromUniViewer.mFlashVars.slot != null)
               {
                  var author:String = mParamsFromUniViewer.mFlashVars.author.replace (/\./g, " ").replace (/\-/g, " ");
                  mDesignAuthorSlotRevision = {
                              mIsUniPlayer : isUniPlayer,
                              mAuthor : author,
                              mAuthorForURL : author.replace (/\s+/g, "_"),
                              mSlotID : parseInt (mParamsFromUniViewer.mFlashVars.slot),
                              mRevision : designRevision,
                              mWorldUUID : worldUUID
                           };
               }
               
               if (worldPluginUrl.indexOf ("://") < 0)
               {
                  var index:int = mParamsFromUniViewer.mUniViewerUrl.indexOf ("/uniplayer.swf");
                  if (index < 0)
                     index = mParamsFromUniViewer.mUniViewerUrl.indexOf ("/swfs/univiewer");

                  if (index < 0)
                  {
                     throw new Error ("Invalid url: " + mParamsFromUniViewer.mUniViewerUrl);
                  }

                  worldPluginUrl = mParamsFromUniViewer.mUniViewerUrl.substring (0, index) + "/swfs/" + worldPluginUrl;
               }

               mWorldPluginUrl = worldPluginUrl;

               var loadDataUrl:String;
               if (isUniPlayer)  // for play, add the return published revison id
               {
                  loadDataUrl = mParamsFromUniViewer.mUniViewerUrl.replace (/\/uniplayer\.*swf/, "/api/design/loaddata");
                  if (loadDataUrl.indexOf ("revision=") < 0)
                     loadDataUrl = loadDataUrl + "&revision=" + designRevision;
                  if (worldUUID != null && worldUUID.length > 0)
                  {
                     if (loadDataUrl.indexOf ("key=") < 0)
                        loadDataUrl = loadDataUrl + "&key=" + worldUUID;
                  }
               }
               else // for view, the revision is already caontained in mUniViewerUrl
               {
                  loadDataUrl = mParamsFromUniViewer.mUniViewerUrl.replace (/\/swfs\/univiewer.*\.swf/, "/api/design/loaddata");
                  // assert (loadDataUrl.indexOf ("revision=") >= 0)
                  if (loadDataUrl.indexOf ("view") < 0)
                     loadDataUrl = loadDataUrl + "&view=1"; // indication for view
               }

               //var loadDataUrl:String;
               //if (mUniViewerUrl.indexOf ("/uniplayer.swf") >= 0)  // for play, add the return published revison id
               //{
               //   loadDataUrl = mUniViewerUrl.replace (/\/uniplayer\.*swf/, "/api/design/loaddata");
               //   loadDataUrl = loadDataUrl + "&revision=" + designRevision;
               //}
               //else // for view, the revision is already caontained in mUniViewerUrl
               //{
               //   loadDataUrl = mUniViewerUrl.replace (/\/swfs\/univiewer.*\.swf/, "/api/design/loaddata");
               //   loadDataUrl = loadDataUrl + "&view=1"; // indication for view
               //}

               mLoadDataUrl = loadDataUrl;

               mWorldPlayCode = mParamsFromUniViewer.mFlashVars.playcode;
               mWorldPlayCodeFormat = mParamsFromUniViewer.mFlashVars.compressformat;
               if (mWorldPlayCode != null && mWorldPlayCode.length == 0)
               {
                  mWorldPlayCode = null;
               }
               if (mWorldPlayCode != null && DataFormat3.CompressFormat_Base64 != mWorldPlayCodeFormat)
               {
                  var binaryData:ByteArray = DataFormat3.HexString2ByteArray (mWorldPlayCode);
                  binaryData.compress ();
                  mWorldPlayCode = DataFormat3.EncodeByteArray2String (binaryData);
                  if (mWorldPlayCode == null)
                     throw new Error ("Convert hex playcode into base64 format failed!");

                  mWorldPlayCodeFormat = DataFormat3.CompressFormat_Base64;
               }

               //
               
               ChangeState (StateId_Loading);
               
               if (mWorldPlayCode == null)
               {
                  StartOnlineLoadingData ();
               }
               else
               {
                  StartOnlineLoadingWorldPlugin ();
               }
            }
         }
         catch (error:Error)
         {
            OnError ("parsing error!", error);
         }
      }

//======================================================================
//
//======================================================================

      //public static const k_ReturnCode_UnknowError:int = 0;
      public static const k_ReturnCode_Successed:int = 1;

      private function StartOnlineLoadingData ():Boolean
      {
         try
         {
            if (mLoadDataUrl == null)
            {
               throw new Error ("mLoadDataUrl == null");
            }
      trace ("StartOnlineLoadingData: " + mLoadDataUrl);

            var request:URLRequest = new URLRequest (mLoadDataUrl);
            request.method = URLRequestMethod.GET;

            var loader:URLLoader = new URLLoader ();
            loader.dataFormat = URLLoaderDataFormat.BINARY;

            loader.addEventListener(Event.COMPLETE, OnOnlineLoadDataCompleted);
            loader.addEventListener(ProgressEvent.PROGRESS, OnLoadingDataProgress);

            loader.load (request);
         }
         catch (error:Error)
         {
            OnError ("start loading error!", error);
            
            return false;
         }

         return true;
      }

      private function OnLoadingDataProgress (event:ProgressEvent):void
      {
         var startPercent:Number = mParamsFromUniViewer.mLoadingProgress;
         var endPercent:Number = mParamsFromUniViewer.mLoadingProgress + 0.5 * (100.0 - mParamsFromUniViewer.mLoadingProgress);

         mParamsFromUniViewer.SetLoadingText ("Loading ... (" + int (startPercent + (endPercent - startPercent) * event.bytesLoaded / event.bytesTotal) + "%)");
//trace ("111 Loading ... (" + int (startPercent + (endPercent - startPercent) * event.bytesLoaded / event.bytesTotal) + "%)");
//trace ("  startPercent = " + startPercent + ", endPercent = " + endPercent + ", event.bytesLoaded = " + event.bytesLoaded + ", event.bytesTotal = " + event.bytesTotal);
      }

      private function OnOnlineLoadDataCompleted (event:Event):void
      {
         try
         {
            var loader:URLLoader = URLLoader(event.target);

            var data:ByteArray = ByteArray (loader.data);

            var returnCode:int = data.readByte ();

            if (returnCode != k_ReturnCode_Successed)
            {
               var message:String = data.readUTF ();
               throw new Error ("Load data error, mLoadDataUrl = " + mLoadDataUrl + ", returnCode = " + returnCode + ", message = " + message);
            }

            var designDataForPlaying:ByteArray = new ByteArray ();
            data.readBytes (designDataForPlaying);
            designDataForPlaying.uncompress ();

            mWorldBinaryData = designDataForPlaying;

            //
            if (! StartOnlineLoadingWorldPlugin ())
            {
               throw new Error ("Fail to start load world plugin");
            }
         }
         catch (error:Error)
         {
            OnError ("online loading word data error!", error);
         }
      }

      private function StartOnlineLoadingWorldPlugin ():Boolean
      {
         try
         {
            if (mWorldPluginUrl == null)
            {
               throw new Error ("mWorldPluginUrl == null");
            }
      trace ("StartOnlineLoadingWorldPlugin: " + mWorldPluginUrl);

            var request:URLRequest = new URLRequest (mWorldPluginUrl);
            request.method = URLRequestMethod.GET;

            var loader:Loader = new Loader ();

            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnOnlineLoadWorldPluginCompleted);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, OnLoadWorldPluginProgress);
            //loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnLoadingError);
            //loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);

            mWorldPluginDomain = new ApplicationDomain ();
            loader.load(request, new LoaderContext(false, mWorldPluginDomain));
         }
         catch (error:Error)
         {
            OnError ("onlone loading world plugin error!", error);
            
            return false;
         }

         return true;
      }

      private function OnOnlineLoadWorldPluginCompleted (event:Event):void
      {
         mParamsFromUniViewer.SetLoadingText (null);
         this.alpha = 1.0;
         
         ReloadPlayerWorld ();
      }

      private function OnLoadWorldPluginProgress (event:ProgressEvent):void
      {
         var startPercent:Number = mParamsFromUniViewer.mLoadingProgress + 0.5 * (100.0 - mParamsFromUniViewer.mLoadingProgress);
         var endPercent:Number = 100;

         mParamsFromUniViewer.SetLoadingText ("Loading ... (" + int (startPercent + (endPercent - startPercent) * event.bytesLoaded / mWorldPluginFileSize/*event.bytesTotal*/) + "%)");
//trace ("222 Loading ... (" + int (startPercent + (endPercent - startPercent) * event.bytesLoaded / event.bytesTotal) + "%)");
//trace ("  startPercent = " + startPercent + ", endPercent = " + endPercent + ", event.bytesLoaded = " + event.bytesLoaded + ", event.bytesTotal = " + event.bytesTotal);
      }

//======================================================================
// world plugin
//======================================================================

      private var mWorldPluginDomain:ApplicationDomain;
      private var mWorldPlugin:Object;

      private var mWorldPluginProperties:Object;

      private function RetrieveWorldPluginProperties ():void
      {
         if (mWorldPluginDomain.hasDefinition ("Main")) // for uniplayer and game package
         {
            mWorldPlugin = mWorldPluginDomain.getDefinition ("Main");
         }
         else // if (mWorldPluginDomain.hasDefinition ("player.WorldPlugin")) // for editor
         {
            mWorldPlugin = mWorldPluginDomain.getDefinition ("player.WorldPlugin");
         }

         mWorldPluginProperties = mWorldPlugin.Call ("GetStaticProperties");
      }

      private var mWorldDesignProperties:Object;

      private function RetrieveWorldDesignProperties ():void
      {
         mWorldDesignProperties = mWorldPlugin.Call ("GetWorldProperties", {mWorld: mPlayerWorld});

         if (mWorldDesignProperties.mIsPermitPublishing == undefined)             mWorldDesignProperties.mIsPermitPublishing = false;
         if (mWorldDesignProperties.mIsShareSourceCode == undefined)              mWorldDesignProperties.mIsShareSourceCode = false;
         if (mWorldDesignProperties.GetZoomScale == undefined)                    mWorldDesignProperties.GetZoomScale = DummyCallback_GetScale;
         if (mWorldDesignProperties.SetZoomScale == undefined)                    mWorldDesignProperties.SetZoomScale = DummyCallback;
         if (mWorldDesignProperties.GetViewportWidth == undefined)                mWorldDesignProperties.GetViewportWidth = DummyCallback_ViewSize;
         if (mWorldDesignProperties.GetViewportHeight == undefined)               mWorldDesignProperties.GetViewportHeight = DummyCallback_ViewSize;
         if (mWorldDesignProperties.GetViewerUiFlags == undefined)                mWorldDesignProperties.GetViewerUiFlags = DummyCallback_UiFlags;
         if (mWorldDesignProperties.GetPlayBarColor == undefined)                 mWorldDesignProperties.GetPlayBarColor = DummyCallback_PlayBarColor;
         if (mWorldDesignProperties.GetBackgroundColor == undefined)              mWorldDesignProperties.GetBackgroundColor = DummyGetBackgroundColor;
         if (mWorldDesignProperties.Initialize == undefined)                      mWorldDesignProperties.Initialize = DummyCallback;
         if (mWorldDesignProperties.SetSingleStepMode == undefined)               mWorldDesignProperties.SetSingleStepMode = DummyCallback;
         if (mWorldDesignProperties.SetPaused == undefined)                       mWorldDesignProperties.SetPaused = DummyCallback;
         if (mWorldDesignProperties.SetInteractiveEnabledWhenPaused == undefined) mWorldDesignProperties.SetInteractiveEnabledWhenPaused = DummyCallback;
         if (mWorldDesignProperties.SetCacheSystemEvent == undefined)             mWorldDesignProperties.SetCacheSystemEvent = DummyCallback;
         if (mWorldDesignProperties.GetBuildingStatus == undefined)               mWorldDesignProperties.GetBuildingStatus = DummyCallback_GetBuildingStatus;
         if (mWorldDesignProperties.SetRealViewportSize == undefined)             mWorldDesignProperties.SetRealViewportSize = DummyCallback;
         if (mWorldDesignProperties.mInitialSpeedX == undefined)                  mWorldDesignProperties.mInitialSpeedX = 2;
         if (mWorldDesignProperties.mInitialZoomScale == undefined)               mWorldDesignProperties.mInitialZoomScale = 1.0;
         if (mWorldDesignProperties.mHasSounds == undefined)                      mWorldDesignProperties.mHasSounds = false;
         if (mWorldDesignProperties.mInitialSoundEnabled == undefined)            mWorldDesignProperties.mInitialSoundEnabled = true;
         if (mWorldDesignProperties.SetSoundEnabled == undefined)                 mWorldDesignProperties.SetSoundEnabled = DummyCallback;
         if (mWorldDesignProperties.GetPreferredFPS == undefined)                 mWorldDesignProperties.GetPreferredFPS = DummyCallback_GetFps;
         if (mWorldDesignProperties.IsPauseOnFocusLost == undefined)              mWorldDesignProperties.IsPauseOnFocusLost = mWorldDesignProperties.GetPauseOnFocusLost; // for a typo bug
         if (mWorldDesignProperties.IsPauseOnFocusLost == undefined)              mWorldDesignProperties.IsPauseOnFocusLost = DummyCallback_ReturnFalse;
         if (mWorldDesignProperties.RegisterGestureEvent == undefined)            mWorldDesignProperties.RegisterGestureEvent = DummyCallback;
         if (mWorldDesignProperties.OnViewerEvent == undefined)                   mWorldDesignProperties.OnViewerEvent = DummyCallback;
         if (mWorldDesignProperties.OnViewerDestroyed == undefined)               mWorldDesignProperties.OnViewerDestroyed = DummyCallback;
         if (mWorldDesignProperties.OnSystemBackEvent == undefined)               mWorldDesignProperties.OnSystemBackEvent = DummyOnSystemBackEvent;      
         if (mWorldDesignProperties.HasRestartLevelRequest == undefined)          mWorldDesignProperties.HasRestartLevelRequest = DummyCallback_ReturnFalse;      
         if (mWorldDesignProperties.GetDelayToLoadSceneIndex == undefined)        mWorldDesignProperties.GetDelayToLoadSceneIndex = DummyGetSceneIndex;
         if (mWorldDesignProperties.GetSceneSwitchingStyle == undefined)          mWorldDesignProperties.GetSceneSwitchingStyle = DummyGetSceneSwitchingStyle;
         if (mWorldDesignProperties.GetWorldCrossStagesData == undefined)         mWorldDesignProperties.GetWorldCrossStagesData = DummyCallback_ReturnNull;
         if (mWorldDesignProperties.OnMultiplePlayerServerMessage == undefined)   mWorldDesignProperties.OnMultiplePlayerServerMessage = DummyCallback;
         if (mWorldDesignProperties.SupportMoreMouseEvents == undefined)          mWorldDesignProperties.SupportMoreMouseEvents = DummyCallback_ReturnFalse;
         //>> only for v2.08
         //if (mWorldDesignProperties.SetViewportStretchScale == undefined)         mWorldDesignProperties.SetViewportStretchScale = DummyCallback;
         //<<
         if (mWorldDesignProperties.SetViewportBoundsInDevicePixels == undefined) mWorldDesignProperties.SetViewportBoundsInDevicePixels = DummyCallback;

         // todo: remove the following "mPlayerWorld == null ?"s.
         mShowPlayBar = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_UseDefaultSkin) != 0);
         mUseOverlaySkin = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_UseOverlaySkin) != 0);
         mPlayBarColor = mPlayerWorld == null ? 0x606060 : mWorldDesignProperties.GetPlayBarColor ();
         mShowSpeedAdjustor = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_ShowSpeedAdjustor) != 0);
         mShowScaleAdjustor = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_ShowScaleAdjustor) != 0);
         mShowSoundController = (mWorldDesignProperties.mHasSounds) && 
                              (mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_ShowSoundController) != 0));
         mShowHelpButton = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_ShowHelpButton) != 0);
         mShowLevelFinishedDialog = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_UseCustomLevelFinishedDialog) == 0);
         mAdaptiveViewportSize = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_AdaptiveViewportSize) != 0);
         mPreferredViewportWidth = mPlayerWorld == null ? ViewerDefine.DefaultPlayerWidth : mWorldDesignProperties.GetViewportWidth ();
         mPreferredViewportHeight = mPlayerWorld == null ? ViewerDefine.DefaultPlayerHeight : mWorldDesignProperties.GetViewportHeight ();
      }

      private function DummyCallback (param1:Object = null, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null, param6:Object = null, param7:Object = null):void
      {
      }

      private function DummyCallback_ReturnNull ():Object
      {
         return null;
      }

      private function DummyCallback_ReturnFalse ():Boolean
      {
         return false;
      }

      private function DummyCallback_GetScale ():Number
      {
         return 1.0;
      }

      private function DummyCallback_GetFps ():Number
      {
         return 30;
      }

      private function DummyCallback_ViewSize ():int
      {
         return 600;
      }

      private function DummyCallback_PlayBarColor ():uint
      {
         return 0x606060;
      }

      private function DummyCallback_UiFlags ():int
      {
         if (mWorldPluginProperties.mWorldVersion >= 0x0159)
         {
            return ViewerDefine.PlayerUiFlag_UseDefaultSkin | ViewerDefine.PlayerUiFlag_ShowSoundController | ViewerDefine.PlayerUiFlag_UseOverlaySkin;
         }
         else if (mWorldPluginProperties.mWorldVersion >= 0x0104)
         {
            return ViewerDefine.PlayerUiFlag_UseDefaultSkin | ViewerDefine.PlayerUiFlag_ShowSpeedAdjustor | ViewerDefine.PlayerUiFlag_ShowScaleAdjustor | ViewerDefine.PlayerUiFlag_ShowHelpButton;
         }
         else
         {
            return ViewerDefine.PlayerUiFlag_UseDefaultSkin | ViewerDefine.PlayerUiFlag_ShowSpeedAdjustor | ViewerDefine.PlayerUiFlag_ShowHelpButton;
         }
      }
      
      // from v1.58
      // =0 - loading
      // >0 - succeeded
      // <0 - failed
      private function DummyCallback_GetBuildingStatus ():int
      {
         return 1;
      }
      
      // from v2.02
      private function DummyOnSystemBackEvent ():int
      {
         return 0;
      }
      
      // from v2.03
      private function DummyGetSceneIndex ():int
      {
         return -1;
      }
      
      // from v2.04
      private function DummyGetSceneSwitchingStyle ():int
      {
         return SceneSwitchingStyle_FadingIn; // before v2.04
      }
      
      private function DummyGetBackgroundColor ():uint
      {
         return mParamsFromContainer.mBackgroundColor;
      }

//======================================================================
//
//======================================================================
      
      private var mFirstTimePlaying:Boolean = true;
      
      private var mLastPreferredFPS:Number = 30;
      
      private var mCurrentSceneID:int = 0;
      
      private var mWorldDefine:Object = null;

      private function ReloadPlayerWorld (sceneId:int = 0, forRestartLevel:Boolean = false, dontReloadGlobalAssets:Boolean = false):void
      {
      trace ("ReloadPlayerWorld");
         
         try
         {
            // reset gesture shapes
            SetMouseGestureSupported (false, false);
            
            StopAllInLevelSounds ();
            if (! dontReloadGlobalAssets)
            {
               StopCrossLevelsSound (null);
            }
         }
         catch (error:Error)
         {
            // do nothing
         }
         
         //var isFirstTime:Boolean = (mPlayerWorld == null);
         mFirstTimePlaying = (mPlayerWorld == null);

         try
         {
            mCurrentSceneID = sceneId;
               
            if (mFirstTimePlaying)
            {
               RetrieveWorldPluginProperties ();

               if (mWorldBinaryData == null && mWorldPlayCode != null)
               {
                  //mWorldBinaryData = (mWorldPluginProperties.WorldFormat_HexString2ByteArray as Function) (mWorldPlayCode); // before v1.55

                  //if (mParamsFromUniViewer != null && mFlashParams != null && DataFormat3.CompressFormat_Base64 == mWorldPlayCodeFormat)
                  // changed since v2.06: seems mFlashParams will never be null if mParamsFromUniViewer != null
                  if (mParamsFromUniViewer != null && DataFormat3.CompressFormat_Base64 == mWorldPlayCodeFormat)
                  {
                     mWorldBinaryData = DataFormat3.DecodeString2ByteArray (mWorldPlayCode); // from v1.55
                     mWorldBinaryData.uncompress ();
                  }
                  else
                  {
                     mWorldBinaryData = DataFormat3.HexString2ByteArray (mWorldPlayCode); // for playing in editor and to be compitiable with version before v1.55
                  }
               }
            }
            //else
            //{
            //   mWorldDesignProperties.Destroy ();
            //
            //   if (mWorldLayer.contains (mPlayerWorld as Sprite))
            //      mWorldLayer.removeChild (mPlayerWorld as Sprite);
            //
            //   mPlayerWorld = null;
            //}
            else
            {
               // delay to remove old data for scene switching
               mOldWorldDesignProperties = mWorldDesignProperties;
               mOldPlayerWorld = mPlayerWorld;
               
               if (mOldWorldDesignProperties != null) // should not be null
                  mOldWorldDesignProperties.Destroy (); // move from blow since v2.09.

               // .
               mWorldDesignProperties = null;
               mPlayerWorld = null;
            }

            var worldDefine:Object;
            if (mWorldDefine == null)
            {
               mWorldBinaryData.position = 0;
               worldDefine = (mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine as Function) (mWorldBinaryData);
               
               if (mWorldPluginProperties.mWorldVersion >= 0x0200)
               {
                  // !!! this optimazation is added from v2.01. v2.00 design is also played with v2.01 world plugin.
                  // for world plugins with version earlier than v2.00, this optimazation is not available
                  mWorldDefine = worldDefine;
               }
            }
            else
            {
               worldDefine = mWorldDefine;
            }
            
            if (worldDefine == null)
               throw new Error ("Fails to create worldDefine");

            if (worldDefine.hasOwnProperty ("mForRestartLevel"))
            {
               worldDefine.mForRestartLevel = forRestartLevel;
            }
            if (worldDefine.hasOwnProperty ("mCurrentSceneId"))
            {
               worldDefine.mCurrentSceneId = sceneId;
            }
            //if (worldDefine.hasOwnProperty ("mDontReloadGlobalAssets")) // useless for any versions now.
            //{
            //   worldDefine.mDontReloadGlobalAssets = dontReloadGlobalAssets;
            //}
            if (worldDefine.hasOwnProperty ("mWorldCrossStagesData"))
            {
               if ((forRestartLevel || dontReloadGlobalAssets) && mOldWorldDesignProperties != null)
               {
                  worldDefine.mWorldCrossStagesData = mOldWorldDesignProperties.GetWorldCrossStagesData ();
               }
               else
               {
                  worldDefine.mWorldCrossStagesData = null;
               }
            }
            if (worldDefine.hasOwnProperty ("mViewerParams"))
            {
               worldDefine.mViewerParams = {
                  //Viewer
                  OnLoadScene : OnLoadScene,
                  GetDebugString: GetDebugString,
                  SetMouseGestureSupported: SetMouseGestureSupported,
                  mLibCapabilities : {
                              IsAccelerometerSupported: IsAccelerometerSupported,
                              GetAcceleration         : GetAcceleration,
                              GetScreenResolution     : GetScreenResolution,
                              GetScreenDPI            : GetScreenDPI,
                              IsMultitouchSupported   : IsMultitouchSupported, // v2.10
                              "" : null
                  },
                  mLibSound : {
                              LoadSoundFromBytes  : LoadSoundFromBytes, 
                              PlaySound           : PlaySound,
                              StopAllInLevelSounds: StopAllInLevelSounds,
                              StopCrossLevelsSound: StopCrossLevelsSound,
                             
                              // SetSoundVolume and SoundEnabled are passed by UI_XXXXX
                              
                              "" : null
                  },
                  mLibGraphics : {
                              LoadImageFromBytes: LoadImageFromBytes,
                              SetRenderQuality  : SetRenderQuality,
                              "" : null
                  },
                  mLibApp : {
                              IsNativeApp: IsNativeApp,
                              OnExitApp : ExitLevel,
                              OpenURL : UrlUtil.PopupPage,
                              GetRealtimeFps : GetRealtimeFps,
                              IsCurrentViewer : IsCurrentViewer,     // since v2.08
                              GetAppWindowPadding : GetAppWindowPadding,  // since v2.09
                              SetAppWindowPadding : SetAppWindowPadding,  // since v2.09
                              GetAppRootURL : GetAppRootURL,  // since v2.09
                              GetAppID      : GetAppID,       // since v2.10
                              "" : null
                  },
                  mLibCookie : {
                              LoadCookie : LoadCookie,
                              WriteCookie: WriteCookie,
                              ClearCookie: ClearCookie,
                              "" : null
                  },
                  mLibService : {
                              // ...
                              SubmitKeyValue: SubmitKeyValue, // v2.00 ?
                              
                              // ...
                              
                              //SetMultiplePlayerInstanceInfoShown: SetMultiplePlayerInstanceInfoShown, // v2.06
                              
                              MultiplePlayer_CreateInstanceDefine: MultiplePlayer_CreateInstanceDefine, // v2.06
                              MultiplePlayer_CreateInstanceChannelDefine: MultiplePlayer_CreateInstanceChannelDefine, // v2.06
                              MultiplePlayer_ReplaceInstanceChannelDefine: MultiplePlayer_ReplaceInstanceChannelDefine, // v2.06
                              
                              MultiplePlayer_SendJoinRandomInstanceRequest: MultiplePlayer_SendJoinRandomInstanceRequest, // v2.06
                              MultiplePlayer_ExitInstance : MultiplePlayer_ExitCurrentInstance, // v2.06
                              
                              MultiplePlayer_SendChannelMessage: MultiplePlayer_SendChannelMessage, // v2.06
                              MultiplePlayer_SendSignalMessage : MultiplePlayer_SendSignalMessage, // v2.06
                              
                              MultiplePlayer_GetGameInstanceBasicInfo: MultiplePlayer_GetGameInstanceBasicInfo, // v2.06
                              MultiplePlayer_GetGameInstanceSeatInfo: MultiplePlayer_GetGameInstanceSeatInfo, // v2.06
                              MultiplePlayer_GetGameInstanceChannelSeatInfo: MultiplePlayer_GetGameInstanceChannelSeatInfo, // v2.06
                              
                              // ...
                              
                              GetAdvertisementProxy : GetAdvertisementProxy, // v2.08
                              
                              // ...
                              "" : null
                  },
                  
                  // ...
                  "" : null
               };
            }
            
            mPlayerWorld = (mWorldPluginProperties.WorldFormat_WorldDefine2PlayerWorld as Function) (worldDefine);

            if (mPlayerWorld == null)
               throw new Error ("Fails to create world");

            mPlayerWorld.visible = false;

            RetrieveWorldDesignProperties ();

            mWorldDesignProperties.SetCacheSystemEvent (mShowPlayBar);
            //mWorldDesignProperties.SetInteractiveEnabledWhenPaused ((! mShowPlayBar) ||  mParamsFromEditor != null); // before v2.10
            mWorldDesignProperties.SetInteractiveEnabledWhenPaused ((! mShowPlayBar)); 
                                 // since v2.10. In fact, this above two callings are useless since v2.10.
                                 // they are still called just to keep compatibility for old world plugins.

            mWorldLayer.addChild (mPlayerWorld as Sprite);

            if (mFirstTimePlaying)
            {
               BuildContextMenu ();
            }
            
            RebuildSkin ();

            mSkin.SetStarted (false);
            
            //mSkin.SetLevelFinishedDialogVisible (false);
            //mSkin.SetHelpDialogVisible (false);
            mSkin.CloseAllVisibleDialogs ();

            mSkin.SetSoundEnabled (IsSoundEnabled ()); // will call OnSoundControlChanged ()
            mSkin.SetPlayingSpeedX (mWorldDesignProperties.mInitialSpeedX);
            mSkin.SetZoomScale (mWorldDesignProperties.mInitialZoomScale, false);

            // from v1.5
            mWorldPlugin.Call ("SetUiParams", {
               mWorld : mPlayerWorld,
               
               //UI 
               OnClickRestart : mSkin.Restart,
               IsPlaying : mSkin.IsPlaying,
               SetPlaying : mSkin.SetPlaying,
               GetPlayingSpeedX : mSkin.GetPlayingSpeedX,
               SetPlayingSpeedX : mSkin.SetPlayingSpeedX,
               GetZoomScale : mSkin.GetZoomScale,
               SetZoomScale : mSkin.SetZoomScale,
               IsSoundEnabled : mSkin.IsSoundEnabled,
               SetSoundEnabled : mSkin.SetSoundEnabled,
               GetSoundVolume : GetSoundVolume,
               SetSoundVolume : SetSoundVolume
            });

            // ...
            mPlayerWorldZoomScale = mWorldDesignProperties.GetZoomScale ();
            mSkin.SetZoomScale (mPlayerWorldZoomScale);
            
            // set fps. Don't forget restore fps when exit playing.
            mLastPreferredFPS = mWorldDesignProperties.GetPreferredFPS ();
            stage.frameRate = mLastPreferredFPS;
            
            // avoid flashing
            RepaintFullScreenLayersWithBackgroundColor ();
            
            if (mOldPlayerWorld == null) // first loading
            {
               mSceneSwitchingStyle = SceneSwitchingStyle_FadingIn;
               mFadingLayer.visible = true;
            }
            else
            {
               mFadingLayer.visible = false;
            }
            
            // ...
            ChangeState (StateId_Playing);
            
            if (CheckBuildingStatus ())
            {
               mCurrentPlayingStatePhase = PlayingStatePhase_Building;
            }
         }
         catch (error:Error)
         {
            OnError ("building error!", error);
         }
      }
      
      private function InitPlayerWorld ():void
      {
      //trace ("InitPlayerWorld");
         try
         {  
            // ...
            
            stage.focus = stage; // avoid losing focus after restart.
            
            // ...
            
            var worldPluginProperties:Object = mWorldDesignProperties;

            mWorldDesignProperties.Initialize (); // may Load New Scene so that mWorldDesignProperties is changed.
            
            // current, call LoadScene API is forbidded in world.Initialize
            //if (worldPluginProperties != mWorldDesignProperties)
            //   return;
            
            // special handling, before v1.02 (not include v1.02), to make world center in viewer
            // (edit) ??? seems before v1.06 (including v1.06)
            // maybe it is better to put this in mWorldDesignProperties.Initialize ()
            //if (mWorldPluginProperties.mWorldVersion < 0x0102)
            
            if (mWorldPluginProperties.mWorldVersion <= 0x0106)
            {
               mWorldDesignProperties.Update (0, 1); 
               
               // not essential, for LoadScene API is added since v2.00
               
               // may Load New Scene so that mWorldDesignProperties is changed.
               //if (worldPluginProperties != mWorldDesignProperties)
               //   return;
            }
            
            // ...

            mSkin.SetPlaying (mStartRightNow);
            
            mStartRightNow = true; // for following restarts
            
            // ...
            
            if (mParamsFromUniViewer != null && mFirstTimePlaying)
            {
               mSkin.OnDeactivate ();
            }
            
            UpdateSoundVolume ();
         }
         catch (error:Error)
         {
            OnError ("initing error!", error);
         }         
      }

//======================================================================
//
//======================================================================

      private var PlayingStatePhase_Building:int = 0;
      private var PlayingStatePhase_Switching:int = 1;
      private var PlayingStatePhase_Stepping:int = 2;
      
      private var mCurrentPlayingStatePhase:int;
     
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      public function UpdatePlaying ():void
      {
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if (mErrorMessageLayer.visible)
         {
            ExitLevelIfBackKeyEverPressed ();
            return;
         }
         
         if (mPlayerWorld == null)
         {
            ExitLevelIfBackKeyEverPressed ();
            return;
         }
         
         if (TryToSwitchScene ())
         {
            return;
         }
         
         // ...
         
         if (mCurrentPlayingStatePhase == PlayingStatePhase_Stepping)
         {
            UpdateFrame (false);
         }
         else if (mCurrentPlayingStatePhase == PlayingStatePhase_Switching)
         {
            UpdateSceneSwitching (false);
         }
         else if (mCurrentPlayingStatePhase == PlayingStatePhase_Building)
         {
            CheckBuildingStatus ();
         }
      }
      
      // return if still in building
      private function CheckBuildingStatus ():Boolean
      {
         var buildStatus:int = mWorldDesignProperties.GetBuildingStatus (); 
         if (buildStatus > 0)
         {
            InitPlayerWorld ();
            
            SetErrorMessage (null); // will call this.visible = true
            
            UpdateSceneSwitching (true);
         }
         else if (buildStatus < 0)
         {
            OnError ("error in building.", null);
         }
         else
         {
            return true;
         }
         
         return false;
      }
      
      // DON'T change these const values. They muse be same as the values in player.World.
      private static const SceneSwitchingStyle_None:int = 0;
      private static const SceneSwitchingStyle_FadingIn:int = 1;
      private static const SceneSwitchingStyle_FadingOut:int = 2;
      private static const SceneSwitchingStyle_FadingOutThenFadingIn:int = 3;
      private static const SceneSwitchingStyle_Blend:int = 4;
      
      private var mSceneSwitchingStyle:int = SceneSwitchingStyle_None;
      
      private var mOldWorldDesignProperties:Object = null;
      private var mOldPlayerWorld:Object = null;
      
      private function UpdateSceneSwitching (isInit:Boolean):void
      {
         var nextPlayingStatePhase:int = -1;
         var toDestroyOldWorld:Boolean = false;
         
         if (isInit)
            nextPlayingStatePhase = PlayingStatePhase_Switching;
         
         var fadingSpeed:Number = 2.0 * mStepTimeSpan.GetLastSpan ();
         if ((mParamsFromEditor != null || mParamsFromUniViewer != null) && mFirstTimePlaying)
            fadingSpeed *= 3.0;
         
         switch (mSceneSwitchingStyle)
         {
            case SceneSwitchingStyle_FadingOutThenFadingIn:
            case SceneSwitchingStyle_FadingOut:
               if (isInit)
               {
                  mFadingLayer.visible = true;
                  mFadingLayer.alpha = 0.0;
               }
               else
               {
                  mFadingLayer.alpha += fadingSpeed;
                  if (mFadingLayer.alpha >= 0.99)
                  {  
                     if (mSceneSwitchingStyle == SceneSwitchingStyle_FadingOutThenFadingIn)
                     {
                        mSceneSwitchingStyle = SceneSwitchingStyle_FadingIn;
                        UpdateSceneSwitching (true);
                     }
                     else // if (mSceneSwitchingStyle == SceneSwitchingStyle_FadingOut)
                     {
                        mFadingLayer.alpha = 1.0;
                        mFadingLayer.visible = false;
                        toDestroyOldWorld = true;
                        mPlayerWorld.visible = true;
                        
                        nextPlayingStatePhase = PlayingStatePhase_Stepping;
                     }
                  }
               }
               break;
            case SceneSwitchingStyle_FadingIn:
               if (isInit)
               {
                  toDestroyOldWorld = true;
                  mPlayerWorld.visible = true; 
                  mFadingLayer.visible = true;
                  mFadingLayer.alpha = 1.0;
               }
               else
               {
                  mFadingLayer.alpha -= fadingSpeed;
                  if (mFadingLayer.alpha <= 0.1)
                  {
                     mFadingLayer.alpha = 0.0;
                     mFadingLayer.visible = false;
                     nextPlayingStatePhase = PlayingStatePhase_Stepping;
                  }
               }
               break;
            case SceneSwitchingStyle_Blend:
               if (isInit)
               {
                  mPlayerWorld.visible = true;
                  mFadingLayer.visible = false;
                  mOldPlayerWorld.alpha = 1.0;
                  mPlayerWorld.alpha = 0.0;
               }
               else
               {
                  fadingSpeed *= 0.3;
                  
                  //mOldPlayerWorld.alpha -= fadingSpeed;
                  mPlayerWorld.alpha += fadingSpeed;
                  if (mPlayerWorld.alpha >= 0.95)
                  {
                     toDestroyOldWorld = true;
                     nextPlayingStatePhase = PlayingStatePhase_Stepping;
                  }
               }
               break;
            case SceneSwitchingStyle_None:
            default:
            {
               if (isInit)
                  nextPlayingStatePhase = PlayingStatePhase_Stepping;
               
               toDestroyOldWorld = true;
               mFadingLayer.visible = false;
               mPlayerWorld.visible = true;
               
               break;
            }
         }
         
         if (nextPlayingStatePhase >= 0)
            mCurrentPlayingStatePhase = nextPlayingStatePhase;

         if (toDestroyOldWorld)
         {
            if (mOldPlayerWorld != null)
            {
               if (mWorldLayer.contains (mOldPlayerWorld as Sprite))
                  mWorldLayer.removeChild (mOldPlayerWorld as Sprite);
               
               //mOldWorldDesignProperties.Destroy ();
                  // (moved above sine v2.09) 
                  // should call before creating the new one.
               
               mOldPlayerWorld = null;
               mOldWorldDesignProperties = null;
            }
         }
      }
      
      private function TryToSwitchScene ():Boolean
      {
         //>>>>>>>>>>>>>>>>>>>> moved from player.World.Update () from v2.03
         var delayToLoadSceneIndex:int = mWorldDesignProperties.GetDelayToLoadSceneIndex ();
         if (delayToLoadSceneIndex >= 0)
         {
            mSceneSwitchingStyle = mWorldDesignProperties.GetSceneSwitchingStyle ();
            OnLoadScene (delayToLoadSceneIndex);
            return true;
         }
         
         if (mWorldDesignProperties.HasRestartLevelRequest ())
         {
            //mSceneSwitchingStyle = SceneSwitchingStyle_FadingIn;
            mSceneSwitchingStyle = mWorldDesignProperties.GetSceneSwitchingStyle ();
            mSkin.Restart ();
            return true;
         }
         
         return false;
         //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      }

      public function UpdateFrame (singleStepMode:Boolean = false):void
      {
         if (! mActive)
            return;
         
         // ...
         
         UpdateGesturePaintLayer ();
         
         // ...
         
         UpdateMultiplePlayer ();

         // ...
         
         if (mLastPreferredFPS != mWorldDesignProperties.GetPreferredFPS ())
         {
            mLastPreferredFPS = mWorldDesignProperties.GetPreferredFPS ();
            stage.frameRate = mLastPreferredFPS;
         }
         
         // assert (mSkin != null);
         
         if (mBackKeyEverPressed)
         {
            if (mSkin.AreSomeDialogsVisible ())
            {
               mSkin.CloseAllVisibleDialogs ();
            }
            else if (mSkin.IsShowPlayBar ())
            {
               if (mSkin.IsPlaying ())
                  mSkin.SetPlaying (false);
               else
               {
                  ExitLevel ();
                  return;
               }
            }
            else
            {
               if (! mSkin.IsPlaying ())
                  mSkin.SetPlaying (true);
               
               if (mWorldDesignProperties.OnSystemBackEvent () == 0)
               {
                  ExitLevel ();
                  return;
               }
               //else
               //{
               //   // already custom handled
               //}
            }
            
            // ...
            
            mBackKeyEverPressed = false;
         }
                  
         // update scale
         
         if (mWorldDesignProperties.GetZoomScale () != mPlayerWorldZoomScale)
         {
            var newScale:Number;

            //trace ("mWorldDesignProperties.GetZoomScale () = " + mWorldDesignProperties.GetZoomScale ());
            //trace ("mPlayerWorldZoomScale = " + mPlayerWorldZoomScale);

            if (mWorldDesignProperties.GetZoomScale () < mPlayerWorldZoomScale)
            {
               if (mPlayerWorldZoomScaleChangedSpeed < 0)
                  mPlayerWorldZoomScaleChangedSpeed = - mPlayerWorldZoomScaleChangedSpeed;

               newScale = mWorldDesignProperties.GetZoomScale () + mPlayerWorldZoomScaleChangedSpeed;

               if (newScale >= mPlayerWorldZoomScale)
                  mWorldDesignProperties.SetZoomScale (mPlayerWorldZoomScale);
               else
                  mWorldDesignProperties.SetZoomScale (newScale);
            }
            else
            {
               if (mPlayerWorldZoomScaleChangedSpeed > 0)
                  mPlayerWorldZoomScaleChangedSpeed = - mPlayerWorldZoomScaleChangedSpeed;

               newScale = mWorldDesignProperties.GetZoomScale () + mPlayerWorldZoomScaleChangedSpeed;

               if (newScale <= mPlayerWorldZoomScale)
                  mWorldDesignProperties.SetZoomScale (mPlayerWorldZoomScale);
               else
                  mWorldDesignProperties.SetZoomScale (newScale);
            }
         }

         // ...

         var paused:Boolean = (! IsPlaying ()) || mSkin.IsHelpDialogVisible ();

         mWorldDesignProperties.SetPaused (paused);
         mWorldDesignProperties.SetSingleStepMode (singleStepMode);

         if ( (! mExternalPaused) && ((! paused) || singleStepMode) )
         {
            try
            {
               var worldPluginProperties:Object = mWorldDesignProperties;
               mWorldDesignProperties.Update (mStepTimeSpan.GetLastSpan (), GetPlayingSpeedX ()); // may Load New Scene so that mWorldDesignProperties is changed.
               if (worldPluginProperties != mWorldDesignProperties)
                  return;
            }
            catch (error:Error)
            {
               OnError ("playing error", error);

               // todo show dialog: "stop" or "continue";
               // write log of send message to server
               
               return;
            }

            mSkin.SetStarted (true);
         }

         var levelSucceeded:Boolean = mWorldDesignProperties.IsLevelSuccessed ();

         mSkin.SetLevelFinishedDialogVisible (mShowLevelFinishedDialog && levelSucceeded);
         
         mSkin.Update (mStepTimeSpan.GetLastSpan ());
         
         // for multiple-levels game package
         if (levelSucceeded && mParamsFromContainer.OnLevelFinished)
         {
            mParamsFromContainer.OnLevelFinished ();
         }
      }
      
//======================================================================
// on ios 7+, stataus bar overlay problem
//======================================================================

      private function GetExtraTopMargin ():Number
      {
         if (IsFullScreen ())
            return 0;
         
         if (! IsNativeApp ())
            return 0;
         
         // mobile app showing status bar
         
         if (mIsIOS && mIsIOS_7Plus)
         {
            var padding_top:int;
            
            var screenWidth:int = Math.min (Capabilities.screenResolutionX, Capabilities.screenResolutionY);
            
            if (screenWidth == 768) // iPad
            {
               padding_top = 20;
            }
            else if (screenWidth == 1536) // iPad large
            {
               padding_top = 40;
            }
            else if (screenWidth == 2048) // iPad pro
            {
               // not sure, just a guess
               padding_top = 60;
            }
            else if (screenWidth == 640) // iPhone 4, iPhone 4s, iPhone 5, iPhone 5c, iPhone 5s
            {
               padding_top = 40;
            }
            else if (screenWidth == 750) // iPhone 6, iPhone 6s
            {
               padding_top = 40;
            }
            else if (screenWidth == 1080 || screenWidth == 1242) // iPhone 6 plus, iPhone 6s plus
            {
               // not sure it is 1080 or 1242
               padding_top = 60;
            }
            else
            {
               padding_top = 60;
            }
            
            return padding_top;
         }
         
         return 0;
      }
      
//======================================================================
// skin and background
//======================================================================
      
      private var mSkin:Skin = null;

      private function RebuildSkin ():void
      {
         // remove old
         
         if (mSkin != null)
            mSkinLayer.removeChild (mSkin);
         
         // build new
         
         var useOverlaySkinForcely:Boolean = (mParamsFromContainer.skin != null && mParamsFromContainer.skin.toLowerCase () == "overlay");
         
         // fot testing
         //useOverlaySkin = true;
         //mIsTouchScreen = true;
         //   mIsPhoneDevice = true;

         var skinParams:Object = {
                  mIsOverlay: mUseOverlaySkin || useOverlaySkinForcely,
                  mIsTouchScreen: mIsTouchScreen,
                  //mIsPhoneDevice: mIsPhoneDevice,
                  
                  OnRestart: OnRestart,
                  OnStart: OnStart,
                  OnPause: OnPause,
                  OnSpeedChanged: OnSpeedChanged,
                  OnScaleChanged: OnScaleChanged,
                  OnSoundControlChanged: OnSoundControlChanged,
                  
                  mHasMainMenu: mParamsFromContainer.mHasMainMenu,
                  OnExitLevel: mParamsFromGamePackage == null ? null : mParamsFromContainer.OnExitLevel,
                  OnNextLevel: mParamsFromContainer.OnNextLevel,
                  mHasNextLevel: mParamsFromContainer.mHasNextLevel,
                  OnGoToPhyard: mParamsFromContainer.OnGoToPhyard
               };

         mSkin = new SkinDefault (skinParams);
         
         mSkin.SetShowPlayBar (mShowPlayBar);
         mSkinLayer.addChild (mSkin);
         
         // adjust positions of layers
         OnContainerResized ();
      }
      
      private function RepaintFullScreenLayersWithBackgroundColor ():void
      {
         var containerSize:Point = mParamsFromContainer.GetViewportSize ();
         var containerWidth :Number = containerSize.x;
         var containerHeight:Number = containerSize.y;
         
         var faddingColor:uint = mWorldDesignProperties == null ? mParamsFromContainer.mBackgroundColor : mWorldDesignProperties.GetBackgroundColor ();
         var bgColor:uint = (mParamsFromEditor == null ? faddingColor : mParamsFromEditor.mBackgroundColor);
         GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, containerWidth, containerHeight, 0x0, -1, true, bgColor);
         GraphicsUtil.ClearAndDrawRect (mFadingLayer    , 0, 0, containerWidth, containerHeight, 0x0, -1, true, faddingColor);
      }
      
      private function GetAppWindowPadding ():Rectangle
      {
         return mWindowPadding;
      }
      
      private function SetAppWindowPadding (left:Number, top:Number, right:Number, bottom:Number):void
      {
         mWindowPadding.left = Math.round (left);
         mWindowPadding.top = Math.round (top);
         mWindowPadding.right = Math.round (right);
         mWindowPadding.bottom = Math.round (bottom);
         
         ReLayout ();
      }
      
      public function OnContainerResized ():void
      {
         RepaintFullScreenLayersWithBackgroundColor ();
         
         ReLayout ();
      }
      
      private function ReLayout ():void
      {
         var containerSize:Point = mParamsFromContainer.GetViewportSize ();
         var containerWidth :Number = containerSize.x;
         var containerHeight:Number = containerSize.y;
         
         try
         {
            if (mSkin != null && mPlayerWorld != null && mWorldDesignProperties != null)
            {
               // position this
               
               var viewerWidth:Number;
               var viewerHeight:Number;
               
               if (mParamsFromEditor != null)
               {
                  // put at center in container
                  
                  var preferredViewerSize:Point = mSkin.GetPreferredViewerSize (mPreferredViewportWidth, mPreferredViewportHeight);
                  
                  viewerWidth  = preferredViewerSize.x;
                  viewerHeight = preferredViewerSize.y;
               
                  mMiddleLayer.x = Math.round ((containerWidth  - viewerWidth ) / 2);
                  mMiddleLayer.y = Math.round ((containerHeight - viewerHeight) / 2);
               }
               else //if (mParamsFromUniViewer != null || mParamsFromGamePackage != null)
               {
                  // fill all container space
                  
                  viewerWidth  = containerWidth;
                  viewerHeight = containerHeight;
                  
                  mMiddleLayer.x = mMiddleLayer.y = 0.0;
               }
               
               // rebuild skin
               
               //mSkin.SetViewerSize (viewerWidth, viewerHeight);
               //mSkin.SetPadding (mWindowPadding);
               var extra_top_margin:Number = GetExtraTopMargin (); // iOS7+ status bar will overlay app content area 
               mSkin.SetViewerSize (viewerWidth - mWindowPadding.left - mWindowPadding.right, viewerHeight - mWindowPadding.top - mWindowPadding.bottom - extra_top_margin);
               mSkin.x = mWindowPadding.left;
               mSkin.y = mWindowPadding.top + extra_top_margin;
               
               mSkin.Rebuild ({
                        mPlayBarColor : mPlayBarColor,
                        mShowSpeedAdjustor: mShowSpeedAdjustor,
                        mShowScaleAdjustor: mShowScaleAdjustor && (mParamsFromContainer.mHideScaleButtons == undefined || mParamsFromContainer.mHideScaleButtons == false),
                        mShowHelpButton: mShowHelpButton,
                        mShowSoundController: mShowSoundController
                        });
               
               // position content layer
               
               var contentRegion:Rectangle = mSkin.GetContentRegion ();
      
               //mContentLayer.x = contentRegion.x;
               //mContentLayer.y = contentRegion.y;
               mContentLayer.x = contentRegion.x + mWindowPadding.left;
               mContentLayer.y = contentRegion.y + mWindowPadding.top;
               
               // position world layer
                  
               var widthRatio :Number = contentRegion.width  / mPreferredViewportWidth;
               var heightRatio:Number = contentRegion.height / mPreferredViewportHeight;

               /*               
               GraphicsUtil.Clear (mContentLayer);
               
               if (widthRatio < heightRatio)
               {  
                  mWorldLayer.scaleX = mWorldLayer.scaleY = mPlayerWorldLayerScale = widthRatio;
                  mWorldLayer.x = 0.0;
                  mWorldLayer.y = mAdaptiveViewportSize ? 0.0 : 0.5 * Number (contentRegion.height - mPreferredViewportHeight * widthRatio);
               }
               else if (widthRatio > heightRatio)
               {
                  mWorldLayer.scaleX = mWorldLayer.scaleY = mPlayerWorldLayerScale = heightRatio;
                  mWorldLayer.x = mAdaptiveViewportSize ? 0.0 : 0.5 * Number (contentRegion.width - mPreferredViewportWidth * heightRatio);
                  mWorldLayer.y = 0.0;
               }
               else
               {
                  mWorldLayer.x = mWorldLayer.y = 0.0;
                  mWorldLayer.scaleX = mWorldLayer.scaleY = mPlayerWorldLayerScale = widthRatio;
               }
               */
               
               mPlayerWorldLayerScale = Math.min (widthRatio, heightRatio);
               mWorldLayer.scaleX = mWorldLayer.scaleY = mPlayerWorldLayerScale;
               
               //>> only for v2.08. removed at v2.09. v2.08 is not a main release.
               //mWorldDesignProperties.SetViewportStretchScale (mWorldLayer.scaleX, mWorldLayer.scaleY);
               //<<
               
               if (mAdaptiveViewportSize || widthRatio == heightRatio) // occupy whole content space
               {
                  mWorldLayer.x = 0.0;
                  mWorldLayer.y = 0.0;
                  
                  // mWorldLayer.scaleX == mWorldLayer.scaleY == mPlayerWorldLayerScale
                  
                  //mViewportMaskRect.width = contentRegion.width;
                  //mViewportMaskRect.height = contentRegion.height;
                  mViewportMaskRect.width = contentRegion.width / mWorldLayer.scaleX;
                  mViewportMaskRect.height = contentRegion.height / mWorldLayer.scaleY;
                  
                  mWorldDesignProperties.SetRealViewportSize (contentRegion.width / mWorldLayer.scaleX, contentRegion.height / mWorldLayer.scaleY);
               }
               else 
               {
                  mWorldDesignProperties.SetRealViewportSize (mPreferredViewportWidth, mPreferredViewportHeight);
                  
                  //mViewportMaskRect.width  = mWorldLayer.scaleX * mPreferredViewportWidth;
                  //mViewportMaskRect.height = mWorldLayer.scaleY * mPreferredViewportHeight;
                  mViewportMaskRect.width  = mPreferredViewportWidth;
                  mViewportMaskRect.height = mPreferredViewportHeight;
                  
                  if (widthRatio < heightRatio)
                  {
                     mWorldLayer.x = 0.0;
                     mWorldLayer.y = 0.5 * Number (contentRegion.height - mPreferredViewportHeight * widthRatio);
                  }
                  else // if (widthRatio > heightRatio)
                  {
                     mWorldLayer.x = 0.5 * Number (contentRegion.width - mPreferredViewportWidth * heightRatio);
                     mWorldLayer.y = 0.0;
                  }
               }
            
               //mViewportMaskRect.x = mWorldLayer.x;
               //mViewportMaskRect.y = mWorldLayer.y;
               mViewportMaskRect.x = 0;
               mViewportMaskRect.y = 0;
               
               //>> added in v2.09. Should be called after calling SetRealViewportSize.
               //mWorldDesignProperties.SetViewportBoundsInDevicePixels (mViewportMaskRect.x, mViewportMaskRect.y, mViewportMaskRect.width, mViewportMaskRect.height);
               // bug fixed in v2.10
               mWorldDesignProperties.SetViewportBoundsInDevicePixels (mWorldLayer.x, mWorldLayer.y, mViewportMaskRect.width * mWorldLayer.scaleX, mViewportMaskRect.height * mWorldLayer.scaleY);
               //<<
               
               // confirm mask
               
               SetMaskViewerField (mMaskViewerField);
               
               
               /*
               // position and rebuild viewport mask shape
               
               var halfContentSpaceWidth :Number = 0.5 * contentRegion.width;
               var halfContentSpaceHeight:Number = 0.5 * contentRegion.height;
               
               //mViewportMaskShape.x = halfContentSpaceWidth;
               //mViewportMaskShape.y = halfContentSpaceHeight;
               
               if (mAdaptiveViewportSize)
               {
                  // fill the full content space
                  
                  //mViewportMaskShape.scaleX = mViewportMaskShape.scaleY = 1.0;
                  //GraphicsUtil.ClearAndDrawRect (mViewportMaskShape, 
                  //                  -halfContentSpaceWidth, -halfContentSpaceHeight, contentRegion.width, contentRegion.height, 
                  //                  0x0, -1, true);
                  
                  mWorldDesignProperties.SetRealViewportSize (contentRegion.width / mWorldLayer.scaleX, contentRegion.height / mWorldLayer.scaleY);
               }
               else
               {
                  // overlap the preferred viewport size region
                  
                  //mViewportMaskShape.scaleX = mWorldLayer.scaleX;
                  //mViewportMaskShape.scaleY = mWorldLayer.scaleY;
                  //GraphicsUtil.ClearAndDrawRect (mViewportMaskShape, 
                  //                  - 0.5 * mPreferredViewportWidth, - 0.5 * mPreferredViewportHeight, mPreferredViewportWidth, mPreferredViewportHeight, 
                  //                  0x0, -1, true);
                  
                  mWorldDesignProperties.SetRealViewportSize (mPreferredViewportWidth, mPreferredViewportHeight);
               }
               */
            }
         }
         catch (error:Error)
         {
            OnError ("resizing error", error);
                        
            return;
         }
         
         if (mErrorMessageLayer.visible)
         {
            CenterErrorMessageText ();
         }
      }

      public function SetMaskViewerField (mask:Boolean):void
      {
         mMaskViewerField = mask;

         if (mMaskViewerField)
         {
            //if (! mContentLayer.contains (mViewportMaskShape))
            //   mContentLayer.addChild (mViewportMaskShape);
            //
            //mContentLayer.mask = mViewportMaskShape;
            
            //mContentLayer.scrollRect = mViewportMaskRect;
            mWorldLayer.scrollRect = mViewportMaskRect;
         }
         else
         {
            //if (mContentLayer.contains (mViewportMaskShape))
            //   mContentLayer.removeChild (mViewportMaskShape);
            //
            //mContentLayer.mask = null;
            
            //mContentLayer.scrollRect = null;
            mWorldLayer.scrollRect = null;
         }
      }

//======================================================================
//
//======================================================================

      private function OnTryToCopySourceCode (event:MouseEvent):void
      {
         if (event.ctrlKey && event.shiftKey)
         {
            OnCopySourceCode ();
         }
      }
      
      private var mIsToggleInfoShowingKeyREgisted:Boolean = false;
       
      private function TryToRegisterToggleInfoShowingKey ():Boolean
      {
         if (mWorldDesignProperties != null && mWorldDesignProperties.SupportMoreMouseEvents () as Boolean)
         {
            if (! mIsToggleInfoShowingKeyREgisted)
            {
               addEventListener (/*MouseEvent.RIGHT_CLICK*/"rightClick", OnTryToCopySourceCode);
               mIsToggleInfoShowingKeyREgisted = true;
            }
            
            return true;
         }
         
         return false;
      }
      
      private function TryToUnregisterToggleInfoShowingKey ():void
      {
         if (mIsToggleInfoShowingKeyREgisted)
         {
            removeEventListener (/*MouseEvent.RIGHT_CLICK*/"rightClick", OnTryToCopySourceCode);
            mIsToggleInfoShowingKeyREgisted = false;
         }
      }

      private function BuildContextMenu ():void
      {
         if (TryToRegisterToggleInfoShowingKey ())
            return;
         
         if (! mBuildContextMenu)
            return;

         var theContextMenu:ContextMenu = new ContextMenu ();
         if (theContextMenu == null) // may be still not one some devices
            return;
         
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         
         if (theContextMenu.customItems == null) // possible null in air app
            return;

         var restartCodeMenuItem:ContextMenuItem = new ContextMenuItem("Restart Game", false);
         theContextMenu.customItems.push (restartCodeMenuItem);
         restartCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnRestartGame);

         var addSeperaorBeforeVersion:Boolean = true;
         var addSeperaorForSelf:Boolean = true;
         if (Capabilities.isDebugger || mPlayerWorld != null && mWorldDesignProperties.mIsShareSourceCode)
         {
            if (mWorldBinaryData != null && mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine != null && mWorldPluginProperties.WorldFormat_WorldDefine2Xml != null)
            {
               // the convertion is very time consuming, so put int in OnCopySourceCode to decrease the game init time
               ////mWorldSourceCode = DataFormat2.WorldDefine2Xml (DataFormat2.HexString2WorldDefine (mWorldPlayCode));
               //
               //mWorldBinaryData.position = 0;
               //mWorldSourceCode = (mWorldPluginProperties.WorldFormat_WorldDefine2Xml as Function) ((mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine as Function) (mWorldBinaryData));

               //if (mWorldSourceCode != null)
               //{
                  var copySourceCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Source Code", addSeperaorForSelf);
                  theContextMenu.customItems.push (copySourceCodeMenuItem);
                  copySourceCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopySourceCode);

                  addSeperaorBeforeVersion = true;
                  addSeperaorForSelf = false;
               //}
            }
         }

         if (mParamsFromUniViewer != null && mPlayerWorld != null && mParamsFromUniViewer.mUniViewerUrl != null && mParamsFromUniViewer.mUniViewerUrl.indexOf ("uniplayer.swf?") >= 0)
         {
            if (mWorldDesignProperties.mIsPermitPublishing)
            {
               var copyEmbedCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy HTML Embed Code", addSeperaorForSelf);
               theContextMenu.customItems.push (copyEmbedCodeMenuItem);
               copyEmbedCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyEmbedCode);
               
               addSeperaorForSelf = false;
            }

            // now this is disabled, for
            // for playcode, it can be copied from editor.
            // for phyard designs, it is {@ phyard_url @}
            //var copyForumEmbedCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Phyard Forum Embed Code", addSeperaorForSelf);
            //theContextMenu.customItems.push (copyForumEmbedCodeMenuItem);
            //copyForumEmbedCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyForumEmbedCode);

            addSeperaorBeforeVersion = true;
            addSeperaorForSelf = false;
         }

         var aboutItem:ContextMenuItem = new ContextMenuItem("About Phyard Viewer", addSeperaorBeforeVersion); // v" + DataFormat3.GetVersionString (Version.VersionNumber), addSeperaorBeforeVersion);
         theContextMenu.customItems.push (aboutItem);
         aboutItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnAbout);

         if (mPlayerWorld != null)
         {
            var designVersionItem:ContextMenuItem = new ContextMenuItem("Design File Format Version: v" + DataFormat3.GetVersionString (mPlayerWorld.GetVersion ()), false);
            // v1.00 has no GetVersion () in player.World (fixed)
            //var designVersionItem:ContextMenuItem = new ContextMenuItem("Design File Format Version: v" + DataFormat3.GetVersionString (mWorldPluginProperties.mWorldVersion), false);
            designVersionItem.enabled = false;
            theContextMenu.customItems.push (designVersionItem);
         }

         if (mWorldPluginProperties != null)
         {
            var worldPlayerVersionItem:ContextMenuItem = new ContextMenuItem("World Player Version: v" + DataFormat3.GetVersionString (mWorldPluginProperties.mWorldVersion), false);
            worldPlayerVersionItem.enabled = false;
            theContextMenu.customItems.push (worldPlayerVersionItem);
         }

         contextMenu = theContextMenu;
      }

      private function OnCopySourceCode (event:ContextMenuEvent = null):void
      {
         try
         {
            if (mWorldDesignProperties != null && mWorldDesignProperties.mIsShareSourceCode)
            {
               // the convertion is very time consuming, so put int here to decrease the game init time
               //mWorldSourceCode = DataFormat2.WorldDefine2Xml (DataFormat2.HexString2WorldDefine (mWorldPlayCode));
               
               System.setClipboard ("Wait a moment to produce the source code ...");
               
               if (mWorldSourceCode == null)
               {
                  mWorldBinaryData.position = 0;
                  mWorldSourceCode = (mWorldPluginProperties.WorldFormat_WorldDefine2Xml as Function) ((mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine as Function) (mWorldBinaryData));
               }

               System.setClipboard (mWorldSourceCode);
            }
            else
            {
               System.setClipboard ("Not available");
            }
         }
         catch (error:Error)
         {
            trace (error.getStackTrace ());
            System.setClipboard ("error!");
         }
      }

      private function OnCopyEmbedCode (event:ContextMenuEvent):void
      {
         if (mParamsFromUniViewer != null && mPlayerWorld != null && mParamsFromUniViewer.mUniViewerUrl != null && mParamsFromUniViewer.mUniViewerUrl.indexOf ("uniplayer.swf?") >= 0)
         {
            var width:int = mWorldDesignProperties.GetViewportWidth ();
            var height:int = mWorldDesignProperties.GetViewportHeight ();
            //if ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_ShowPlayBar) != 0)
            if ((mWorldDesignProperties.GetViewerUiFlags () & (ViewerDefine.PlayerUiFlag_UseDefaultSkin | ViewerDefine.PlayerUiFlag_UseOverlaySkin)) == ViewerDefine.PlayerUiFlag_UseDefaultSkin)
               height += ViewerDefine.DefaultPlayerSkinPlayBarHeight;

            var index:int = mParamsFromUniViewer.mUniViewerUrl.indexOf ("uniplayer.swf?");
            var uniplayerUrl:String = "http://www.phyard.com/" + mParamsFromUniViewer.mUniViewerUrl.substr (index);

            // before v1.55. depreciated now.
            //var embedCode:String =
            //   "<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"" + width + "\" height=\"" + height + "\">"
            //     + (mWorldPlayCode == null ? "\n" : "\n  <param name=\"FlashVars\" value=\"playcode=" + mWorldPlayCode + "\"></param>\n") +
            //   "  <param name=\"movie\" value=\"" + uniplayerUrl + "\"></param>"
            //     + "\n" +
            //   "  <param name=\"quality\" value=\"high\"></param>"
            //     + "\n" +
            //   "  <embed src=\"" + uniplayerUrl + "\" width=\"" + width + "\" height=\"" + height + "\""
            //     + (mWorldPlayCode == null ? "\n" : "\n    FlashVars=\"playcode=" + mWorldPlayCode + "\"\n") +
            //   "    quality=\"high\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\">"
            //     + "\n" +
            //   "  </embed>"
            //     + "\n" +
            //   "</object>"
            //   ;

            // from v1.55

            var embedCode:String;
            
            //{
               embedCode =
               //"<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"" + width + "\" height=\"" + height + "\">"
               //  + (mWorldPlayCode == null ? "\n" : "\n  <param name=\"FlashVars\" value=\"playcode=" + mWorldPlayCode + "\"></param>\n") +
               //"  <param name=\"movie\" value=\"" + uniplayerUrl + "\"></param>"
               //  + "\n" +
               //"  <param name=\"quality\" value=\"high\"></param>"
               //  + "\n" +
               "<embed src=\"" + uniplayerUrl + "\" width=\"" + width + "\" height=\"" + height + "\""
                 + (mWorldPlayCode == null ? "\n" : "\n    FlashVars=\"" + (mWorldPlayCodeFormat == null ? "playcode=" : "compressformat=" + mWorldPlayCodeFormat + "&playcode=") + mWorldPlayCode + "\"\n") +
               "    quality=\"high\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\">"
                 + "\n" +
               "</embed>"
               //  + "\n" +
               //"</object>"
               ;
            //}

            try
            {
               System.setClipboard(embedCode);
            }
            catch (error:Error)
            {
               trace (error.getStackTrace ());
            }
         }
      }

      private function OnCopyForumEmbedCode (event:ContextMenuEvent):void
      {
         if (mParamsFromUniViewer != null && mPlayerWorld != null && mParamsFromUniViewer.mUniViewerUrl != null && mParamsFromUniViewer.mUniViewerUrl.indexOf ("uniplayer.swf?") >= 0)
         {
            // before v1.55. depreciated now.
            //if (mWorldPlayCode != null)
            //{
            //   System.setClipboard(mWorldPlayCode);
            //}
            //else
            //{
            //   var width:int = mWorldDesignProperties.GetViewportWidth ();
            //   var height:int = mWorldDesignProperties.GetViewportHeight ();
            //   //if ((mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_ShowPlayBar) != 0)
            //   if ((mWorldDesignProperties.GetViewerUiFlags () & (ViewerDefine.PlayerUiFlag_UseDefaultSkin | ViewerDefine.PlayerUiFlag_UseOverlaySkin)) == ViewerDefine.PlayerUiFlag_UseDefaultSkin)
            //      height += 20;
            //
            //   var substr:String = "uniplayer.swf?";
            //
            //   var index:int = mParamsFromUniViewer.mUniViewerUrl.indexOf (substr);
            //   if (index < 0)
            //   {
            //       System.setClipboard("");
            //      return;
            //   }
            //
            //   //var embedCode:String = "[phyard=" + mParamsFromUniViewer.mUniViewerUrl.substring (index + substr.length) + "&width=" + width + "&height=" + height + "][/phyard]";
            //
            //   System.setClipboard (embedCode);
            //}

            // from v1.55

            var forumEmbedCode:String = null;

            //var url:String = mParamsFromUniViewer.mUniViewerUrl;
            //
            //const AuthorEquals:String = "author=";
            //var index1:int = url.indexOf (AuthorEquals);
            //var index2:int;
            //if (index1 >= 0)
            //{
            //   index1 += AuthorEquals.length;
            //   index2 = url.indexOf ("&", index1);
            //   if (index2 < 0) index2 = url.length;
            //   var author:String = url.substring (index1, index2);
            //
            //   const SlotEquals:String = "slot=";
            //   index1 = url.indexOf (SlotEquals);
            //   if (index1 >= 0)
            //   {
            //      index1 += SlotEquals.length;
            //      index2 = url.indexOf ("&", index1);
            //      if (index2 < 0) index2 = url.length;
            //      var slotId:String = url.substring (index1, index2);
            //
            //      forumEmbedCode = "{@http://www.phyard.com/design/" + author + "/" + slotId + "@}";
            //   }
            //}
            if (mDesignAuthorSlotRevision != null)
            {
               forumEmbedCode = "{@http://www.phyard.com/design/" + mDesignAuthorSlotRevision.mAuthorForURL + "/" + mDesignAuthorSlotRevision.mSlotID + "@}";
            }
            else if (mWorldBinaryData != null)
            {
               var playcodeBase64:String = (DataFormat3.CompressFormat_Base64 == mWorldPlayCodeFormat ? mWorldPlayCode : DataFormat3.EncodeByteArray2String (mWorldBinaryData));

               if (playcodeBase64 != null)
               {
                  var fileVersionHexString:String = DataFormat3.GetVersionHexString (mPlayerWorld.GetVersion ());
                  // v1.00 has no GetVersion () in player.World (fixed now)
                  //var fileVersionHexString:String = DataFormat3.GetVersionHexString (mWorldPluginProperties.mWorldVersion);

                  //var showPlayBar:Boolean = (mWorldDesignProperties.GetViewerUiFlags () & ViewerDefine.PlayerUiFlag_ShowPlayBar) != 0;
                  var showPlayBar:Boolean = (mWorldDesignProperties.GetViewerUiFlags () & (ViewerDefine.PlayerUiFlag_UseDefaultSkin | ViewerDefine.PlayerUiFlag_UseOverlaySkin)) == ViewerDefine.PlayerUiFlag_UseDefaultSkin;
                  var viewportWidth:int = mWorldDesignProperties.GetViewportWidth ();
                  var viewportHeight:int = mWorldDesignProperties.GetViewportHeight ();

                  forumEmbedCode = DataFormat3.CreateForumEmbedCode (fileVersionHexString, viewportWidth, viewportHeight, showPlayBar, playcodeBase64);
               }
            }

            if (forumEmbedCode != null)
            {
               try
               {
                  System.setClipboard (forumEmbedCode);
               }
               catch (error:Error)
               {
                  trace (error.getStackTrace ());
               }
            }
         }
      }

      private function OnAbout (event:ContextMenuEvent):void
      {
         UrlUtil.PopupPage (ViewerDefine.AboutUrl);
      }
      
//======================================================================
//
//======================================================================

      // restart current scene/level
      //private function OnRestartGame (data:Object = null):void
      //{
      //   mCurrentSceneID = 0;
      //   
      //   if (mSkin != null)
      //      mSkin.Restart ();
      //   else
      //      OnRestart ();
      //}
      
      // also used for context menu
      public function OnRestartGame (data:Object = null):void
      {
         mSceneSwitchingStyle = SceneSwitchingStyle_None;
         
         OnLoadScene (0);
      }

      private function OnLoadScene (sceneId:int):void
      {
         ReloadPlayerWorld (sceneId, false, true);

         if (_onPlayStatusChanged != null)
            _onPlayStatusChanged ();
      }

      // restart current scene/level
      private function OnRestart (data:Object = null):void
      {
         mSceneSwitchingStyle = SceneSwitchingStyle_None;
         
         ReloadPlayerWorld (mCurrentSceneID, true, true);

         if (_onPlayStatusChanged != null)
            _onPlayStatusChanged ();
      }

      public function OnStart (data:Object = null):void
      {
         if (_onPlayStatusChanged != null)
            _onPlayStatusChanged ();
      }

      public function OnPause (data:Object = null):void
      {
         if (_onPlayStatusChanged != null)
            _onPlayStatusChanged ();
         
         // since v2.10, if skin UI is disabled, deactivate desgin on paused.
         if (! mShowPlayBar)
         {
            if (mSkin != null) mSkin.OnDeactivate ();
         }
      }

      public function IsPlaying ():Boolean
      {
         if(mSkin == null)
            return false;

         return mSkin.IsPlaying ();
      }

      public function GetPlayingSpeedX ():int
      {
         if (mSkin == null)
            return 2;

         return mSkin.GetPlayingSpeedX ();
      }
      
      public function GetRealtimeFps ():Number
      {
         if (mSkin == null)
            return 0;

         return mSkin.GetFPS ();
      }
      
      public function IsShowPlayBar ():Boolean
      {
         if (mSkin == null)
            return false;

         return mSkin.IsShowPlayBar ();
      }

      private function OnSpeedChanged (data:Object = null):void
      {
         if (_OnSpeedChanged != null)
            _OnSpeedChanged ();
      }

      private function OnScaleChanged (data:Object = null):void
      {
         if (mSkin == null)
            return;

         mPlayerWorldZoomScale = mSkin.GetZoomScale ();

         if (mPlayerWorld == null)
            return;

         if ((data is Boolean) && (! (data as Boolean))) // not smoothly
         {
            mWorldDesignProperties.SetZoomScale (mPlayerWorldZoomScale);

            return;
         }

         mPlayerWorldZoomScaleChangedSpeed = ( mPlayerWorldZoomScale - mWorldDesignProperties.GetZoomScale () ) * 0.03;
      }

   //======================================================================

      private function OnSoundControlChanged (data:Object = null):void
      {
         if (mSkin == null)
            return;

         SetSoundEnabled (mSkin.IsSoundEnabled ());
         //SetSoundVolume (mSkin.GetSoundVolume ()); // to add
         
         // from v2.02, sound status info is stored in Viewer instead of world plugin
         //mWorldDesignProperties.SetSoundEnabled (mSkin.IsSoundEnabled ());
      }

//===========================================================================
// interfaces for game template
//===========================================================================
      
      
      private var mBackKeyEverPressed:Boolean = false;
      
      public function OnBackKeyDown ():void
      {
         mBackKeyEverPressed = true;
      }
      
      private function ExitLevel ():void
      {
         if (mParamsFromContainer.OnExitLevel != null)
         {
            mParamsFromContainer.OnExitLevel ();
         }
      }
      
      private function ExitLevelIfBackKeyEverPressed ():void
      {
         if (mBackKeyEverPressed)
         {
            mBackKeyEverPressed = false;

            ExitLevel ();
         }
      }
         
      //{
         /* mWorldDesignProperties.HasSystemBackEventHandlers mWorldDesignProperties.OnSystemBackEvent
         if (skin != null)
         {
            if (skin is visible)
            {
               if (is playing)
                  pause;
               else if (mParamsFromContainer.OnExitLevel != null)
                  ...
            }
            else if (world.OnExternalEscapeDown ())
            {
               // do nothing
            }
            else if (mParamsFromContainer.OnExitLevel != null)
            {
               ...
            }
         }
         
         return ! mErrorMessageLayer.visible;
         */
         /////////////////////
         
         /*
         if (mSkin != null)
         {
            if (mSkin.AreSomeDialogsVisible ())
               mSkin.CloseAllVisibleDialogs ();
            else if (mSkin.IsPlaying ())
            {
               if (mSkin.IsShowPlayBar ())
               {
                  mSkin.SetPlaying (false);
                  // disable sounds
               }
               else
               {
                  // check if the level has implemented an OnBackKeyPressed event handler, 
                  // if not, mParamsFromContainer.OnExitLevel (),
                  // else, trigger mWorld.OnKeyPressed (BackKey)
               }
            }
            else if (mParamsFromContainer.OnExitLevel != null)
            {
               mParamsFromContainer.OnExitLevel ();
               // close sounds
            }
            else
            {
               return false;
            }
            
            return true;
         }
         
         return ! mErrorMessageLayer.visible;
         */
      //}
      
      //
      
      public static function IsMultitouchSupported ():Boolean
      {
         // todo: some devices may enable/disable multi-touch at runtime.
         
         return IsTouchScreen ();
      }

      public static function IsTouchScreen ():Boolean
      {
         CheckPlatformCapabilities ();
         
         return mIsTouchScreen;
      }
      
      // create buttons

      public static function CreatePlayButton (onClickHandler:Function):Sprite
      {
         return SkinDefault.CreateButton (0, SkinDefault.mPlayButtonData, SkinDefault.DefaultButtonIconFilledColor, true, IsTouchScreen (), onClickHandler);
      }

      public static function CreateExitAppButton (onClickHandler:Function):Sprite
      {
         return SkinDefault.CreateButton (0, SkinDefault.mExitAppButtonData, SkinDefault.DefaultButtonIconFilledColor, true, IsTouchScreen (), onClickHandler);
      }
      
      public static function CreateBackButton (onClickHandler:Function):Sprite
      {
         return SkinDefault.CreateButton (0, SkinDefault.mBackButtonData, SkinDefault.DefaultButtonIconFilledColor, true, IsTouchScreen (), onClickHandler);
      }
      
      public static function CreateSoundOnButton (onClickHandler:Function):Sprite
      {
         return SkinDefault.CreateButton (0, SkinDefault.mSoundOnButtonData, SkinDefault.DefaultButtonIconFilledColor, true, IsTouchScreen (), onClickHandler);
      }
      
      public static function CreateSoundOffButton (onClickHandler:Function):Sprite
      {
         return SkinDefault.CreateButton (0, SkinDefault.mSoundOffButtonData, SkinDefault.DefaultButtonIconFilledColor, true, IsTouchScreen (), onClickHandler);
      }
      
      public static function CreateLockIcon (iconColor:uint):DisplayObject
      {
         return SkinDefault.CreateButton (-1, SkinDefault.mLockButtonData, iconColor, true, IsTouchScreen (), null);
      }
      
//===========================================================================
// interfaces for editing
//===========================================================================

      public function PlayRestart ():void
      {
         if (mSkin != null)
            mSkin.Restart ();
      }
      
      public function ResumeOrPause (playing:Boolean):void
      {
         if (mSkin != null)
            mSkin.SetPlaying (playing);
      }
      
      public function ChangeSpeedX (deltaSpeedX:int):void
      {
         if (mSkin != null)
            mSkin.SetPlayingSpeedX (GetPlayingSpeedX () + deltaSpeedX);
      }

      public function UpdateSingleFrame ():void
      {
         UpdateFrame (true);
      }
      
      public function GetFPS ():Number
      {
         if (mSkin != null)
            return mSkin.GetFPS ();
         
         return 0;
      }

      public function GetPlayerWorld ():Object
      {
         return mPlayerWorld;
      }
      
      private var mExternalPaused:Boolean = false;
      public function SetExternalPaused (paused:Boolean):void
      {
         mExternalPaused = paused;
      }
      
      // maybe useless now
      
      private var _OnSpeedChanged:Function = null;
      public function SetOnSpeedChangedFunction (onSpeed:Function):void
      {
         _OnSpeedChanged = onSpeed;
      }
      
      private var _onPlayStatusChanged:Function = null;
      public function SetOnPlayStatusChangedFunction (onPlayStatusChanged:Function):void
      {
         _onPlayStatusChanged = onPlayStatusChanged;
      }
      
//===========================================================================
// general "embed <-> containers"
//===========================================================================
      
      // don't change the api name. 
      //public function ContainerCallEmbed (funcName:String, params:Object):Object
      //{
      //   if (funcName == "OnMultiplePlayerServerMessages")
      //   {
      //      OnMultiplePlayerServerMessages (params);
      //   }
      //   else if (funcName == "OnSetConnectionID")
      //   {
      //      OnSetConnectionID (params);
      //   }
      //   
      //   return null;
      //}
      
      // for websocket, etc.
      //public function EmbedCallContainer (funcName:String, params:Object):Object
      //{
      //   if (mParamsFromContainer.EmbedCallContainer != null)
      //   {
      //      return mParamsFromContainer.EmbedCallContainer (funcName, params);
      //   }
      //   
      //   return null;
      //}

   }
}
