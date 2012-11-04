
package viewer {

   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;

   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Stage;
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
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;
   
   import com.tapirgames.gesture.GestureAnalyzer;
   import com.tapirgames.gesture.GesturePoint;
   import com.tapirgames.gesture.GestureSegment;
   
   import com.tapirgames.util.ResourceLoader;

   import common.DataFormat3;
   import common.Define;
   import common.Version;

   public class Viewer extends Sprite
   {
      include "LibCapabilities.as";
      include "LibGesture.as";
      include "LibSound.as";
      include "LibImage.as";
      include "LibCookie.as";
      include "LibServices.as";
      
//======================================================================
//
//======================================================================

   // input params, one and only one is not null

      private var mParamsFromContainer:Object; // can't be null, equals any of the following ones
   
         //todo: remove the followng 3 ones
         private var mParamsFromUniViewer:Object = null;
         private var mParamsFromEditor:Object = null;
         private var mParamsFromGamePackage:Object = null;

//======================================================================
//
//======================================================================

      internal var mStartRightNow:Boolean = false;
      internal var mMaskViewerField:Boolean = true;

      private var mBuildContextMenu:Boolean = true;

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

      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;

      private var mPlayerWorldZoomScale:Number = 1.0;
      private var mPlayerWorldZoomScaleChangedSpeed:Number = 0.0;

      private var mBackgroundLayer:Sprite = new Sprite ();
      private var mMiddleLayer:Sprite = new Sprite ();
         private var mContentLayer:Sprite = new Sprite ();
            private var mWorldLayer:Sprite = new Sprite ();
            private var mViewportMaskShape:Sprite = new Sprite ();
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
         trace ("Viewer params = " + params);

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
         CheckPlatformCapabilities ();

         ParseParams ();
         
         addEventListener (Event.ENTER_FRAME, Update);
         addEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         
         //mGesturePaintLayer.mouseEnabled = false;
         mGesturePaintLayer.mouseChildren = false;
         mGesturePaintLayer.addEventListener (MouseEvent.CLICK, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.addEventListener (MouseEvent.MOUSE_DOWN, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.addEventListener (MouseEvent.MOUSE_MOVE, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.addEventListener (MouseEvent.MOUSE_UP, OnMouseEvent_GesturePaintLayer);
         
         stage.addEventListener (Event.ACTIVATE, OnActivated);
         stage.addEventListener (Event.DEACTIVATE, OnDeactivated);
         
         var containerSize:Point = mParamsFromContainer.GetViewportSize ();
         RepaintFullScreenLayersWithBackgroundColor (containerSize.x, containerSize.y);
      }

      private function OnRemovedFromStage (e:Event):void
      {
         stage.removeEventListener (Event.ACTIVATE, OnActivated);
         stage.removeEventListener (Event.DEACTIVATE, OnDeactivated);
         
         mGesturePaintLayer.removeEventListener (MouseEvent.CLICK, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseEvent_GesturePaintLayer);
         mGesturePaintLayer.removeEventListener (MouseEvent.MOUSE_UP, OnMouseEvent_GesturePaintLayer);
         
         removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         removeEventListener (Event.ENTER_FRAME, Update);
         removeEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
         
         //removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); 
               // this one don't need to be removed. Otherwise, 
               // the game package optimization for 1-level will crash.
         
         // ...
         
         CloseAllSounds ();
               // up to here, for one-level game package, mWorldDesignProperties.OnViewerDestroyed is not called.
      }
      
      // from v2.02, called manually
      public function Destroy ():void
      {  
         if (mWorldDesignProperties != null && mWorldDesignProperties.OnViewerDestroyed != null)
         {
            mWorldDesignProperties.OnViewerDestroyed ();
         }
      }

//======================================================================
// stop simulation on mobile devices
//======================================================================
      
      private var mIsAppDeactivated:Boolean = false;
      
      public function OnActivated (event:Event):void
      {
         mIsAppDeactivated = false;
         
         SetSoundVolume (mSoundVolume);
      }
      
      public function OnDeactivated (event:Event):void
      {
         mIsAppDeactivated = true;
         
         if (mStateId == StateId_Playing && mWorldDesignProperties != null && (mWorldDesignProperties.mPauseOnFocusLost as Boolean))
         {
            if (mSkin != null) mSkin.OnDeactivate ();
         }
      }

//======================================================================
// platform capabilities
//======================================================================

      private static var mIsTouchScreen:Boolean = false; // false for PC device
         private static var mIsPhoneDevice:Boolean = false; // only valid when mIsMobileDevice is true
      
      private static var mGeolocationClass:Object = null;
      private static var mAccelerometerClass:Object = null;
         private static var mAccelerometer:Object; //flash.sensors.Accelerometer;
      private static var mMultitouchClass:Object = null;
      
      private static var mPlatformCapabilitiesChecked:Boolean = false;
      
      private static function CheckPlatformCapabilities ():void
      {
         if (mPlatformCapabilitiesChecked)
            return;
         
         mPlatformCapabilitiesChecked = true;
         
         try
         {
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
            
            var dpi:int = Capabilities.screenDPI;
            var screenX:int = Capabilities.screenResolutionX;
            var screenY:int = Capabilities.screenResolutionY;
            var diagonal:Number = Math.sqrt((screenX*screenX)+(screenY*screenY))/dpi;
            // if diagonal is higher than 6, we will assume it is a tablet or PC
            mIsPhoneDevice = diagonal < 6;

            if (mIsPhoneDevice)
            {
               mIsTouchScreen = true;
            }
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
               if (! mGeolocationClass.isSupported)
               {
                  mGeolocationClass = null;
               }
            }
               
            //if ((! mIsMobileDevice) && mGeolocationClass != null)
            //{
            //   mIsMobileDevice = true;
            //}
            
            if (ApplicationDomain.currentDomain.hasDefinition ("flash.sensors.Accelerometer"))
            {
               mAccelerometerClass = ApplicationDomain.currentDomain.getDefinition ("flash.sensors.Accelerometer") as Class;
               if (! mAccelerometerClass.isSupported)
               {
                  mAccelerometerClass = null;
               }
               else
               {
                  mAccelerometer = new mAccelerometerClass ();
                  mAccelerometer.addEventListener("update", OnAccelerationUpdate); //AccelerometerEvent.UPDATE, onUpdate)
               } 
            }
               
            //if ((! mIsMobileDevice) && mAccelerometerClass != null)
            //{
            //   mIsMobileDevice = true;
            //}
            
            if (ApplicationDomain.currentDomain.hasDefinition ("flash.ui.Multitouch"))
            {
               mMultitouchClass = ApplicationDomain.currentDomain.getDefinition ("flash.ui.Multitouch") as Class;
               if (mMultitouchClass.maxTouchPoints <= 0)
               {
                  mMultitouchClass = null;
               }
            }
               
            if (mMultitouchClass != null)
            {
               mIsTouchScreen = true;
            }
         }
         catch (error:Error)
         {
            TraceError (error);
         
            if (Capabilities.isDebugger)
            {
               throw error;
            }
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
      
      private static function GetDebugString ():String
      {
         if (ApplicationDomain.currentDomain.hasDefinition ("flash.sensors.Accelerometer"))
         {
            var accelerometerClass:Object = ApplicationDomain.currentDomain.getDefinition ("flash.sensors.Accelerometer") as Class;
            var info:String = "acc class: " + accelerometerClass;
            if (accelerometerClass != null)
            {
               info = info + "\nsupported: " + mAccelerometerClass.isSupported;
            }
            
            return info;
         }
                  
         return "null";
      }
      
      private function IsNativeApp ():Boolean
      {
         return mParamsFromContainer.mIsNativeApp != undefined && (mParamsFromContainer.mIsNativeApp as Boolean);
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
      public static function CreateGestureAnalyzer ():GestureAnalyzer
      {
         return new GestureAnalyzer (Capabilities.screenDPI * 0.2, Capabilities.screenDPI * 0.02);
      }
      
      // for world
      private var mEnabledMouseGesture:Boolean = false;
      private var mDrawdMouseGesture:Boolean = false;
      
      private function SetMouseGestureSupported (supported:Boolean, draw:Boolean):void
      {
         mEnabledMouseGesture = supported;
         mDrawdMouseGesture = draw;
         
         mGesturePaintLayer.visible = mEnabledMouseGesture && mDrawdMouseGesture;
         
         if (! mEnabledMouseGesture)
         {
            mGestureAnalyzer = null;
            ClearGesturePaintLayer ();
         }
      }
      
      // ...
      
      private var mGestureInBuilding:Boolean = false;
      
      private function ClearGesturePaintLayer ():void
      {
         mGesturePaintLayer.graphics.clear ();
         mGesturePaintLayer.alpha = 1.0;
         mGesturePaintLayer.visible = false;
      }
      
      private function UpdateGesturePaintLayer ():void
      {  
         if (mGesturePaintLayer.visible && mGestureAnalyzer == null)
         {
            mGesturePaintLayer.alpha -= 1.0 / stage.frameRate; // mWorldDesignProperties.mPreferredFPS
            if (mGesturePaintLayer.alpha < 0)
            {
               ClearGesturePaintLayer ();
            }
         }
      }
      
      private var mGestureAnalyzer:GestureAnalyzer = null;
      
      private function OnMouseDown (event:MouseEvent):void
      {
         if (mEnabledMouseGesture)
         {
            mGestureAnalyzer = CreateGestureAnalyzer ();
            ClearGesturePaintLayer ();
            mGesturePaintLayer.visible = mDrawdMouseGesture;
            
            RegisterGesturePoint (event);
         }
      }
      
      private function OnMouseMove (event:MouseEvent):void
      {
         if (mGestureAnalyzer != null)
         {
            if (mEnabledMouseGesture && event.buttonDown)
            {
               RegisterGesturePoint (event);
            }
            else
            {
               mGestureAnalyzer = null;
               ClearGesturePaintLayer ();
            }
         }
      }
      
      private function OnMouseUp (event:MouseEvent):void
      {
         if (mGestureAnalyzer != null)
         {
            if (mEnabledMouseGesture)
            {
               RegisterGesturePoint (event);

               var result:Object = mGestureAnalyzer.Analyze ();
               
               if (mPlayerWorld != null && result.mGestureType != null)
                  mWorldDesignProperties.RegisterGestureEvent (result);
            }
         }
         else
         {
            ClearGesturePaintLayer ();
         }
         
         mGestureAnalyzer = null;
      }
      
      private function RegisterGesturePoint (event:MouseEvent):void
      {
         if (mFadingStatus != 0)
            return;
         
         if (mGestureAnalyzer == null)
            return;
         
         var gesturePoint:GesturePoint = mGestureAnalyzer.RegisterPoint (event.stageX / stage.scaleX, event.stageY / stage.scaleY, getTimer ());
         if (gesturePoint != null)
         {
            var point:Point = globalToLocal (new Point (gesturePoint.mX * stage.scaleX, gesturePoint.mY * stage.scaleY));
            if (gesturePoint.mPrevPoint == null)
            {
               mGesturePaintLayer.graphics.lineStyle ();
               mGesturePaintLayer.graphics.beginFill (0x00FF00);
               mGesturePaintLayer.graphics.drawCircle (point.x, point.y, 9);
               mGesturePaintLayer.graphics.endFill ();
            }
            else
            {
               mGesturePaintLayer.graphics.lineStyle(9, 0x00FF00);
               mGesturePaintLayer.graphics.moveTo (point.x, point.y);

               point = globalToLocal (new Point (gesturePoint.mPrevPoint.mX * stage.scaleX, gesturePoint.mPrevPoint.mY * stage.scaleY));
               mGesturePaintLayer.graphics.lineTo (point.x, point.y);
            }
         }
      }

//======================================================================
// mouse event
//======================================================================

      // !!! this function is introduced from v2.00 to fix the missed event triggerings caused by gesture shape overlapping.
      // ref: http://stackoverflow.com/questions/4924558/listen-to-click-event-on-overlapped-sprites
      
      private function OnMouseEvent_GesturePaintLayer (event:MouseEvent):void
      {
         //if (mPlayerWorld != null)
         //{
         //   var clonedEvent:MouseEvent = event.clone () as MouseEvent;
         //   clonedEvent.delta = 0x7FFFFFFF; // indicate mPlayerWorld this event is sent from here
         //   mPlayerWorld.dispatchEvent(clonedEvent);
         //}
         
         if (mWorldDesignProperties != null && mWorldDesignProperties.OnViewerEvent != null)
         {
            var clonedEvent:MouseEvent = event.clone () as MouseEvent;
            mWorldDesignProperties.OnViewerEvent (clonedEvent);
         }
      }

//======================================================================
//
//======================================================================

      private static const StateId_Unknown:int = -1;
      private static const StateId_ParsingError:int = 0;
      private static const StateId_Loading:int = 1;
      private static const StateId_LoadingError:int = 2;
      private static const StateId_Building:int = 3;
      private static const StateId_BuildingError:int = 4;
      private static const StateId_Playing:int = 5;
      private static const StateId_PlayingError:int = 6;

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
            case StateId_LoadingError:
               ExitLevelIfBackKeyEverPressed ();
               // todo: "Copy Error Message" and "Report Error" in Context Menu
               break;
            case StateId_Building:
               // "Build ..." text on screen
               var buildStatus:int = mWorldDesignProperties.GetBuildingStatus (); 
               if (buildStatus > 0)
               {
                  InitPlayerWorld ();
                  
                  SetErrorMessage (null); // will call this.visible = true
                  
                  if (! ((mParamsFromEditor != null) || (mParamsFromUniViewer != null && mFirstTimePlaying)))
                     SetFadingStatus (-1);
                  
                  ChangeState (StateId_Playing);
               }
               else if (buildStatus < 0)
               {
                  ChangeState (StateId_BuildingError);
               }
               
               break;
            case StateId_BuildingError:
               ExitLevelIfBackKeyEverPressed ();
               // todo: "Copy Error Message" and "Report Error" in Context Menu
               break;
            case StateId_Playing:
               UpdateFrame (false);
               break;
            case StateId_PlayingError:
               ExitLevelIfBackKeyEverPressed ();
               // todo: "Copy Error Message" and "Report Error" in Context Menu
               break;
            case StateId_Unknown:
            default:
               ExitLevelIfBackKeyEverPressed ();
               break;
         }
      }

      public function ChangeState (stateId:int):void
      {
      //trace ("change state: " + stateId + "\n" + new Error ().getStackTrace ());
         mStateId = stateId;
         switch (mStateId)
         {
            case StateId_Loading:
               break;
            case StateId_LoadingError:
               SetErrorMessage ("Loading error!");
               break;
            case StateId_Building:
               if (mParamsFromUniViewer != null && mParamsFromUniViewer.SetLoadingText != null)
               {
                  mParamsFromUniViewer.SetLoadingText ("Building ...");
               }
               this.visible = false;
               break;
            case StateId_BuildingError:
               SetErrorMessage ("Building error!");
               break;
            case StateId_Playing:
               break;
            case StateId_PlayingError:
               SetErrorMessage ("Runtime error!");
               break;
            case StateId_Unknown:
            default:
               break;
         }
      }

      private static var mLastErrorInfo:String = null;
      
      public static function TraceError (error:Error):void
      {
         if (Capabilities.isDebugger)
            trace (error.getStackTrace ());
         
         mLastErrorInfo = "Error: id=" + error.errorID + ", msg=" + error.message + "\n" + error.getStackTrace ();
      }

//======================================================================
// 
//======================================================================

      private var mUniViewerUrl:String;
      private var mFlashParams:Object;

      private var mWorldPluginUrl:String;
      private var mLoadDataUrl:String;
      
      public function ParseParams ():void
      {
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
               mFlashParams = mParamsFromUniViewer.mFlashVars;

               mUniViewerUrl = mParamsFromUniViewer.mUniViewerUrl;

               var stream:ByteArray = mParamsFromUniViewer.mDesignInfoStream;
               var designRevision:int = stream.readInt ();
               var worldPluginUrl:String = stream.readUTF ();

               if (worldPluginUrl.indexOf ("://") < 0)
               {
                  var index:int = mUniViewerUrl.indexOf ("/uniplayer.swf");
                  if (index < 0)
                     index = mUniViewerUrl.indexOf ("/swfs/univiewer");

                  if (index < 0)
                  {
                     throw new Error ("Invalid url: " + mUniViewerUrl);
                  }

                  worldPluginUrl = mUniViewerUrl.substring (0, index) + "/swfs/" + worldPluginUrl;
               }

               mWorldPluginUrl = worldPluginUrl;

               var loadDataUrl:String;
               if (mUniViewerUrl.indexOf ("/uniplayer.swf") >= 0)  // for play, add the return published revison id
               {
                  loadDataUrl = mUniViewerUrl.replace (/\/uniplayer\.*swf/, "/api/design/loaddata");
                  loadDataUrl = loadDataUrl + "&revision=" + designRevision;
               }
               else // for view, the revision is already caontained in mUniViewerUrl
               {
                  loadDataUrl = mUniViewerUrl.replace (/\/swfs\/univiewer.*\.swf/, "/api/design/loaddata");
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

               mWorldPlayCode = mFlashParams.playcode;
               mWorldPlayCodeFormat = mFlashParams.compressformat;
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
               if (mWorldPlayCode == null)
               {
                  if (StartOnlineLoadingData ())
                  {
                     ChangeState (StateId_Loading);
                  }
                  else
                  {
                     ChangeState (StateId_LoadingError);
                  }
               }
               else
               {
                  if (StartOnlineLoadingWorldPlugin ())
                  {
                     ChangeState (StateId_Loading);
                  }
                  else
                  {
                     ChangeState (StateId_LoadingError);
                  }
               }
            }
         }
         catch (error:Error)
         {
            TraceError (error);
            
            ChangeState (StateId_ParsingError);

            if (Capabilities.isDebugger)
            {
               throw error;
            }
         }
      }

//======================================================================
//
//======================================================================

      public static const k_ReturnCode_UnknowError:int = 0;
      public static const k_ReturnCode_Successed:int = 1;
      public static const k_ReturnCode_NotLoggedIn:int = 2;
      public static const k_ReturnCode_SlotIdOutOfRange:int = 3;
      public static const k_ReturnCode_DesignNotCreatedYet:int = 4;
      public static const k_ReturnCode_DesignAlreadyRemoved:int = 5;
      public static const k_ReturnCode_DesignCannotBeCreated:int = 6;
      public static const k_ReturnCode_ProfileNameNotCreatedYet:int = 7;
      public static const k_ReturnCode_NoEnoughRightsToProcess:int = 8;

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
            TraceError (error);

            if (Capabilities.isDebugger)
               throw error;

            return false;
         }

         return true;
      }

      private function OnLoadingDataProgress (event:ProgressEvent):void
      {
         var startPercent:Number = mParamsFromUniViewer.mLoadingProgress;
         var endPercent:Number = mParamsFromUniViewer.mLoadingProgress + 0.5 * (100.0 - mParamsFromUniViewer.mLoadingProgress);

         mParamsFromUniViewer.SetLoadingText ("Loading ... (" + int (startPercent + (endPercent - startPercent) * event.bytesLoaded / event.bytesTotal) + "%)");
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
               throw new Error ("Load data error");
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
            TraceError (error);

            ChangeState (StateId_LoadingError);

            if (Capabilities.isDebugger)
            {
               throw error;
            }
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
            TraceError (error);

            if (flash.system.Capabilities.isDebugger)
               throw error;

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

         mParamsFromUniViewer.SetLoadingText ("Loading ... (" + int (startPercent + (endPercent - startPercent) * event.bytesLoaded / event.bytesTotal) + "%)");
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
         if (mWorldDesignProperties.SetRealViewportSize == undefined)             mWorldDesignProperties.SetRealViewportSize = DummyCallback;
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
         if (mWorldDesignProperties.mPreferredFPS == undefined)                   mWorldDesignProperties.mPreferredFPS = 30;
         if (mWorldDesignProperties.mPauseOnFocusLost == undefined)               mWorldDesignProperties.mPauseOnFocusLost = false;
         if (mWorldDesignProperties.RegisterGestureEvent == undefined)            mWorldDesignProperties.RegisterGestureEvent = DummyCallback;
         if (mWorldDesignProperties.OnViewerEvent == undefined)                   mWorldDesignProperties.OnViewerEvent = DummyCallback;
         if (mWorldDesignProperties.OnViewerDestroyed == undefined)               mWorldDesignProperties.OnViewerDestroyed = DummyCallback;
         if (mWorldDesignProperties.OnSystemBackEvent == undefined)               mWorldDesignProperties.OnSystemBackEvent = DummyOnSystemBackEvent;      
         if (mWorldDesignProperties.HasRestartLevelRequest == undefined)          mWorldDesignProperties.HasRestartLevelRequest = DummyCallback_ReturnFalse;      
         if (mWorldDesignProperties.GetDelayToLoadSceneIndex == undefined)        mWorldDesignProperties.GetDelayToLoadSceneIndex = DummyGetSceneIndex;      

         mShowPlayBar = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_UseDefaultSkin) != 0);
         mUseOverlaySkin = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_UseOverlaySkin) != 0);
         mPlayBarColor = mPlayerWorld == null ? 0x606060 : mWorldDesignProperties.GetPlayBarColor ();
         mShowSpeedAdjustor = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowSpeedAdjustor) != 0);
         mShowScaleAdjustor = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowScaleAdjustor) != 0);
         mShowSoundController = (mWorldDesignProperties.mHasSounds) && 
                              (mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowSoundController) != 0));
         mShowHelpButton = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowHelpButton) != 0);
         mShowLevelFinishedDialog = mPlayerWorld == null ? false : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_UseCustomLevelFinishedDialog) == 0);
         mAdaptiveViewportSize = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_AdaptiveViewportSize) != 0);
         mPreferredViewportWidth = mPlayerWorld == null ? Define.DefaultPlayerWidth : mWorldDesignProperties.GetViewportWidth ();
         mPreferredViewportHeight = mPlayerWorld == null ? Define.DefaultPlayerHeight : mWorldDesignProperties.GetViewportHeight ();
      }

      private function DummyCallback (param1:Object = null, param2:Object = null, param3:Object = null):void
      {
      }

      private function DummyCallback_ReturnFalse ():Boolean
      {
         return false;
      }

      private function DummyCallback_GetScale ():Number
      {
         return 1.0;
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
            return Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_ShowSoundController | Define.PlayerUiFlag_UseOverlaySkin;
         }
         else if (mWorldPluginProperties.mWorldVersion >= 0x0104)
         {
            return Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_ShowSpeedAdjustor | Define.PlayerUiFlag_ShowScaleAdjustor | Define.PlayerUiFlag_ShowHelpButton;
         }
         else
         {
            return Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_ShowSpeedAdjustor | Define.PlayerUiFlag_ShowHelpButton;
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
      
      private function DummyGetBackgroundColor ():uint
      {
         return mParamsFromContainer == null ? 0x000000 : mParamsFromContainer.mBackgroundColor;
      }

//======================================================================
//
//======================================================================
      
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

                  if (mParamsFromUniViewer != null && mFlashParams != null && DataFormat3.CompressFormat_Base64 == mWorldPlayCodeFormat)
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
            else
            {
               mWorldDesignProperties.Destroy ();

               if (mWorldLayer.contains (mPlayerWorld as Sprite))
                  mWorldLayer.removeChild (mPlayerWorld as Sprite);

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
            if (worldDefine.hasOwnProperty ("mDontReloadGlobalAssets"))
            {
               worldDefine.mDontReloadGlobalAssets = dontReloadGlobalAssets;
            }
            if (worldDefine.hasOwnProperty ("mViewerParams"))
            {
               worldDefine.mViewerParams = {
                  //Viewer
                  OnLoadScene : OnLoadScene,
                  mLibCapabilities : {
                              IsAccelerometerSupported: IsAccelerometerSupported,
                              GetAcceleration: GetAcceleration,
                              GetScreenResolution : GetScreenResolution,
                              GetScreenDPI : GetScreenDPI
                  },
                  GetDebugString: GetDebugString,
                  SetMouseGestureSupported: SetMouseGestureSupported,
                  mLibSound : {
                              LoadSoundFromBytes : LoadSoundFromBytes, 
                              PlaySound: PlaySound,
                              StopAllInLevelSounds: StopAllInLevelSounds,
                              StopCrossLevelsSound: StopCrossLevelsSound
                             
                              // SetSoundVolume and SoundEnabled are passed by UI_XXXXX
                  },
                  mLibImage : {
                              LoadImageFromBytes : LoadImageFromBytes
                  },
                  mLibApp : {
                              IsNativeApp: IsNativeApp,
                              OnExitApp : ExitLevel,
                              OpenURL : UrlUtil.PopupPage
                  },
                  mLibCookie : {
                              LoadCookie : LoadCookie,
                              WriteCookie : WriteCookie,
                              ClearCookie : ClearCookie
                  },
                  mServicesLib : {
                              SubmitHighScore: SubmitHighScore
                  }
               };
            }
            
            mPlayerWorld = (mWorldPluginProperties.WorldFormat_WorldDefine2PlayerWorld as Function) (worldDefine);

            if (mPlayerWorld == null)
               throw new Error ("Fails to create world");

            RetrieveWorldDesignProperties ();

            mWorldDesignProperties.SetCacheSystemEvent (mShowPlayBar);
            mWorldDesignProperties.SetInteractiveEnabledWhenPaused ((! mShowPlayBar) ||  mParamsFromEditor != null);

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
            stage.frameRate = mWorldDesignProperties.mPreferredFPS;
            
            ChangeState (StateId_Building);
         }
         catch (error:Error)
         {
            TraceError (error);

            ChangeState (StateId_LoadingError);

            if (Capabilities.isDebugger)
            {
               throw error;
            }
         }
      }

      private var mFirstTimePlaying:Boolean = true;
      
      private function InitPlayerWorld ():void
      {
      //trace ("InitPlayerWorld");
         try
         {
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
         }
         catch (error:Error)
         {
            TraceError (error);

            ChangeState (StateId_BuildingError);

            if (Capabilities.isDebugger)
            {
               throw error;
            }
         }
      }

//======================================================================
//
//======================================================================
      
      private var mFadingStatus:int = 0;
      
      private function SetFadingStatus (status:int):void
      {
         if (mFadingStatus != status)
         {
            mFadingStatus = status;
            
            mFadingLayer.visible = mFadingStatus != 0;
            if (mFadingLayer.visible)
            {
               mFadingLayer.alpha = mFadingStatus > 0 ? 0.0 : 1.0;
            }
         }
      } 
      
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();

      public function UpdateFrame (singleStepMode:Boolean = false):void
      {
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
         
         //>>>>>>>>>>>>>>>>>>>> moved from player.World.Update () from v2.03
         if (mWorldDesignProperties.HasRestartLevelRequest ())
         {
            mSkin.Restart ();
            return;
         }
         
         var delayToLoadSceneIndex:int = mWorldDesignProperties.GetDelayToLoadSceneIndex ();
         if (delayToLoadSceneIndex >= 0)
         {
            OnLoadScene (delayToLoadSceneIndex);
            return;
         }
         //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
         
         if (mFadingStatus != 0)
         {
            if (mFadingStatus > 0)
            {
               mFadingLayer.alpha += 0.02;
               if (mFadingLayer.alpha >= 1.0)
                  SetFadingStatus (0);
            }
            else
            {
               if (mFadingLayer.alpha > 0.97)
                  mFadingLayer.alpha -= 0.005;
               else if (mFadingLayer.alpha > 0.88)
                  mFadingLayer.alpha -= 0.01;
               else if (mFadingLayer.alpha > 0.60)
                  mFadingLayer.alpha -= 0.02;
               else if (mFadingLayer.alpha > 0.10)
                  mFadingLayer.alpha -= 0.05;
               else
                  SetFadingStatus (0);
            }
            
            return;
         }
         
         UpdateGesturePaintLayer ();

         // ...
         
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

         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();

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
               TraceError (error);

               // todo show dialog: "stop" or "continue";
               // write log of send message to server

               ChangeState (StateId_PlayingError);

               if (Capabilities.isDebugger)
               {
                  throw error;
               }
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
                  mIsPhoneDevice: mIsPhoneDevice,
                  
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

         // mask
         SetMaskViewerField (mMaskViewerField);
         
         // adjust positions of layers
         OnContainerResized ();
      }
      
      public function OnContainerResized ():void
      {
         var containerSize:Point = mParamsFromContainer.GetViewportSize ();
         var containerWidth :Number = containerSize.x;
         var containerHeight:Number = containerSize.y;
         
         RepaintFullScreenLayersWithBackgroundColor (containerWidth, containerHeight);
         
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
               
               mSkin.SetViewerSize (viewerWidth, viewerHeight);
               
               mSkin.Rebuild ({
                        mPlayBarColor : mPlayBarColor,
                        mShowSpeedAdjustor: mShowSpeedAdjustor,
                        mShowScaleAdjustor: mShowScaleAdjustor && (mParamsFromContainer.mHideScaleButtons == undefined || mParamsFromContainer.mHideScaleButtons == false),
                        mShowHelpButton: mShowHelpButton,
                        mShowSoundController: mShowSoundController
                        });
               
               // position content layer
               
               var contentRegion:Rectangle = mSkin.GetContentRegion ();
      
               mContentLayer.x = contentRegion.x;
               mContentLayer.y = contentRegion.y;
               
               // position world layer
                  
               var widthRatio :Number = contentRegion.width  / mPreferredViewportWidth ;
               var heightRatio:Number = contentRegion.height / mPreferredViewportHeight;
               
               GraphicsUtil.Clear (mContentLayer);
               
               if (widthRatio < heightRatio)
               {
                  mWorldLayer.scaleX = mWorldLayer.scaleY = widthRatio;
                  mWorldLayer.x = 0.0;
                  mWorldLayer.y = mAdaptiveViewportSize ? 0.0 : 0.5 * Number (contentRegion.height - mPreferredViewportHeight * widthRatio);
               }
               else if (widthRatio > heightRatio)
               {
                  mWorldLayer.scaleX = mWorldLayer.scaleY = heightRatio;
                  mWorldLayer.x = mAdaptiveViewportSize ? 0.0 : 0.5 * Number (contentRegion.width - mPreferredViewportWidth * heightRatio);
                  mWorldLayer.y = 0.0;
               }
               else
               {
                  mWorldLayer.x = mWorldLayer.y = 0.0;
                  mWorldLayer.scaleX = mWorldLayer.scaleY = widthRatio;
               }
               
               // position and rebuild viewport mask shape
               
               var halfContnetSpaceWidth:Number  = 0.5 * contentRegion.width;
               var halfContentSpaceHeight:Number = 0.5 * contentRegion.height;
               
               mViewportMaskShape.x = halfContnetSpaceWidth;
               mViewportMaskShape.y = halfContentSpaceHeight;
               
               if (mAdaptiveViewportSize)
               {
                  // fill the full content space
                  
                  mViewportMaskShape.scaleX = mViewportMaskShape.scaleY = 1.0;
                  GraphicsUtil.ClearAndDrawRect (mViewportMaskShape, 
                                    -halfContnetSpaceWidth, -halfContentSpaceHeight, contentRegion.width, contentRegion.height, 
                                    0x0, -1, true);
                  
                  mWorldDesignProperties.SetRealViewportSize (contentRegion.width / mWorldLayer.scaleX, contentRegion.height / mWorldLayer.scaleY);
               }
               else
               {
                  // overlap the preferred viewport size region
                  
                  mViewportMaskShape.scaleX = mWorldLayer.scaleX;
                  mViewportMaskShape.scaleY = mWorldLayer.scaleY;
                  GraphicsUtil.ClearAndDrawRect (mViewportMaskShape, 
                                    - 0.5 * mPreferredViewportWidth, - 0.5 * mPreferredViewportHeight, mPreferredViewportWidth, mPreferredViewportHeight, 
                                    0x0, -1, true);
                  
                  mWorldDesignProperties.SetRealViewportSize (mPreferredViewportWidth, mPreferredViewportHeight);
               }
            }
         }
         catch (error:Error)
         {
            TraceError (error);
            
            ChangeState (StateId_PlayingError);

            if (Capabilities.isDebugger)
            {
               throw error;
            }
            
            return;
         }
         
         if (mErrorMessageLayer.visible)
         {
            CenterErrorMessageText ();
         }
      }
      
      private function RepaintFullScreenLayersWithBackgroundColor (newWidth:Number, newHeight:Number):void
      {
         GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, newWidth, newHeight, 0x0, -1, true, mWorldDesignProperties.GetBackgroundColor ());//mParamsFromContainer.mBackgroundColor);
         GraphicsUtil.ClearAndDrawRect (mFadingLayer    , 0, 0, newWidth, newHeight, 0x0, -1, true, mWorldDesignProperties.GetBackgroundColor ());//mParamsFromContainer.mBackgroundColor);
      }

//======================================================================
//
//======================================================================
      
      private var mErrorMessageText:TextFieldEx = null;
      
      private function SetErrorMessage (errorMessage:String):void
      {           
         this.visible = true;
         
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
         
         mErrorMessageText = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText (errorMessage) + "<br>" + mLastErrorInfo, true, 0xFFFFFF);
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

      private function BuildContextMenu ():void
      {
         if (! mBuildContextMenu)
            return;

         var theContextMenu:ContextMenu = new ContextMenu ();
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
               //mWorldSourceCode = DataFormat2.WorldDefine2Xml (DataFormat2.HexString2WorldDefine (mWorldPlayCode));

               mWorldBinaryData.position = 0;
               mWorldSourceCode = (mWorldPluginProperties.WorldFormat_WorldDefine2Xml as Function) ((mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine as Function) (mWorldBinaryData));

               if (mWorldSourceCode != null)
               {
                  var copySourceCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Source Code", addSeperaorForSelf);
                  theContextMenu.customItems.push (copySourceCodeMenuItem);
                  copySourceCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopySourceCode);

                  addSeperaorBeforeVersion = true;
                  addSeperaorForSelf = false;
               }
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

            var copyForumEmbedCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Phyard Forum Embed Code", addSeperaorForSelf);
            theContextMenu.customItems.push (copyForumEmbedCodeMenuItem);
            copyForumEmbedCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyForumEmbedCode);

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

      private function OnCopySourceCode (event:ContextMenuEvent):void
      {
         if (mWorldSourceCode != null)
         {
            System.setClipboard(mWorldSourceCode);
         }
      }

      private function OnCopyEmbedCode (event:ContextMenuEvent):void
      {
         if (mParamsFromUniViewer != null && mPlayerWorld != null && mParamsFromUniViewer.mUniViewerUrl != null && mParamsFromUniViewer.mUniViewerUrl.indexOf ("uniplayer.swf?") >= 0)
         {
            var width:int = mWorldDesignProperties.GetViewportWidth ();
            var height:int = mWorldDesignProperties.GetViewportHeight ();
            //if ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0)
            if ((mWorldDesignProperties.GetViewerUiFlags () & (Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_UseOverlaySkin)) == Define.PlayerUiFlag_UseDefaultSkin)
               height += Define.DefaultPlayerSkinPlayBarHeight;

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

            var embedCode:String =
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

            System.setClipboard(embedCode);
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
            //   //if ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0)
            //   if ((mWorldDesignProperties.GetViewerUiFlags () & (Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_UseOverlaySkin)) == Define.PlayerUiFlag_UseDefaultSkin)
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

            var url:String = mParamsFromUniViewer.mUniViewerUrl;

            const AuthorEquals:String = "author=";
            var index1:int = url.indexOf (AuthorEquals);
            var index2:int;
            if (index1 >= 0)
            {
               index1 += AuthorEquals.length;
               index2 = url.indexOf ("&", index1);
               if (index2 < 0) index2 = url.length;
               var author:String = url.substring (index1, index2);

               const SlotEquals:String = "slot=";
               index1 = url.indexOf (SlotEquals);
               if (index1 >= 0)
               {
                  index1 += SlotEquals.length;
                  index2 = url.indexOf ("&", index1);
                  if (index2 < 0) index2 = url.length;
                  var slotId:String = url.substring (index1, index2);

                  forumEmbedCode = "{@http://www.phyard.com/design/" + author + "/" + slotId + "@}";
               }
            }
            else if (mWorldBinaryData != null)
            {
               var playcodeBase64:String = (DataFormat3.CompressFormat_Base64 == mWorldPlayCodeFormat ? mWorldPlayCode : DataFormat3.EncodeByteArray2String (mWorldBinaryData));

               if (playcodeBase64 != null)
               {
                  var fileVersionHexString:String = DataFormat3.GetVersionHexString (mPlayerWorld.GetVersion ());
                  // v1.00 has no GetVersion () in player.World (fixed now)
                  //var fileVersionHexString:String = DataFormat3.GetVersionHexString (mWorldPluginProperties.mWorldVersion);

                  //var showPlayBar:Boolean = (mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0;
                  var showPlayBar:Boolean = (mWorldDesignProperties.GetViewerUiFlags () & (Define.PlayerUiFlag_UseDefaultSkin | Define.PlayerUiFlag_UseOverlaySkin)) == Define.PlayerUiFlag_UseDefaultSkin;
                  var viewportWidth:int = mWorldDesignProperties.GetViewportWidth ();
                  var viewportHeight:int = mWorldDesignProperties.GetViewportHeight ();

                  forumEmbedCode = DataFormat3.CreateForumEmbedCode (fileVersionHexString, viewportWidth, viewportHeight, showPlayBar, playcodeBase64);
               }
            }

            if (forumEmbedCode != null)
            {
               System.setClipboard (forumEmbedCode);
            }
         }
      }

      private function OnAbout (event:ContextMenuEvent):void
      {
         UrlUtil.PopupPage (Define.AboutUrl);
      }

//======================================================================
//
//======================================================================

      public function SetMaskViewerField (mask:Boolean):void
      {
         mMaskViewerField = mask;

         if (mMaskViewerField)
         {
            if (! mContentLayer.contains (mViewportMaskShape))
               mContentLayer.addChild (mViewportMaskShape);

            mContentLayer.mask = mViewportMaskShape;
         }
         else
         {
            if (mContentLayer.contains (mViewportMaskShape))
               mContentLayer.removeChild (mViewportMaskShape);

            mContentLayer.mask = null;
         }
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

   }
}
