
package viewer {

   import flash.utils.ByteArray;

   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;

   import flash.system.System;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;

   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   import flash.events.ContextMenuEvent;

   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.net.navigateToURL;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.system.LoaderContext;
   
   import flash.system.Capabilities;

   import com.tapirgames.display.FpsCounter;
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;

   import common.DataFormat3;
   import common.Define;
   import common.Version;

   public class Viewer extends Sprite
   {

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
         private var mPlayBarColor:uint;
         private var mShowPlayBar:Boolean;
         private var mShowSpeedAdjustor:Boolean;
         private var mShowScaleAdjustor:Boolean;
         private var mShowHelpButton:Boolean;
         private var mShowSoundController:Boolean;
         private var mAdaptiveViewportSize:Boolean;
         private var mPreferredViewportWidth:int;
         private var mPreferredViewportHeight:int;

      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;

      private var mPlayerWorldZoomScale:Number = 1.0;
      private var mPlayerWorldZoomScaleChangedSpeed:Number = 0.0;

      private var mContentLayer:Sprite = new Sprite ();
         private var mWorldLayer:Sprite = new Sprite ();
         private var mViewportMaskShape:Sprite = new Sprite ();
      private var mSkinLayer:Sprite = new Sprite ();
      private var mErrorMessageLayer:Sprite = new Sprite ();

//======================================================================
//
//======================================================================

      public function Viewer (params:Object = null)
      {
         trace ("Viewer params = " + params);

         if (params == null) // strange: flash auto instance this class when loading done. shit!
            return;

         addChild (mContentLayer)
            mContentLayer.addChild (mWorldLayer);
         addChild (mSkinLayer);
         addChild (mErrorMessageLayer);
         mErrorMessageLayer.visible = false;

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
         
         addEventListener (Event.ENTER_FRAME, Update);
         addEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromFrame);
         
         stage.addEventListener (Event.ACTIVATE, OnActivated);
         stage.addEventListener (Event.DEACTIVATE, OnDeactivated);

         ParseParams ();
      }

      private function OnRemovedFromFrame (e:Event):void
      {
         stage.removeEventListener (Event.ACTIVATE, OnActivated);
         stage.removeEventListener (Event.DEACTIVATE, OnDeactivated);
         
         removeEventListener (Event.ENTER_FRAME, Update);
         removeEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromFrame);
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }

//======================================================================
// stop simulation on mobile devices
//======================================================================
      
      private var mIsAppDeactivated:Boolean = false;
      
      public function OnActivated (event:Event):void
      {
         mIsAppDeactivated = false;
      }
      
      public function OnDeactivated (event:Event):void
      {
         mIsAppDeactivated = true;
      }

//======================================================================
// platform capabilities
//======================================================================

      private var mIsMobileDevice:Boolean = false; // false for PC device
         private var mIsPhoneDevice:Boolean = false; // only valid when mIsMobileDevice is true
      
      private var mGeolocationClass:Object = null;
      private var mAccelerometerClass:Object = null;
      private var mMultitouchClass:Object = null;

      private function CheckPlatformCapabilities ():void
      {
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
            // if diagonal is higher than 6, we will assume it is a tablet
            mIsPhoneDevice = diagonal < 6;

            if (mIsPhoneDevice)
            {
               mIsMobileDevice = true;
            }
            else
            {
               var manufacturer:String = Capabilities.manufacturer;
               manufacturer = (manufacturer == null ? "" : manufacturer.toLowerCase ());
               var osname:String = Capabilities.os;
               osname = (osname == null ? "" : osname.toLowerCase ());
               if (manufacturer.indexOf ("android") >= 0 || osname.indexOf ("ios") >= 0 || manufacturer.indexOf ("phone") >= 0 || manufacturer.indexOf ("pad") >= 0) // phone may be iphone or "windows phone" or "lephone"
               {
                  mIsMobileDevice = true;
               }
               if (! mIsMobileDevice)
               {
                  if (osname.indexOf ("android") >= 0 || osname.indexOf ("ios") >= 0 || osname.indexOf ("phone") >= 0 || osname.indexOf ("pad") >= 0)
                  {
                     mIsMobileDevice = true;
                  }
               }
            }
         
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
               
            if ((! mIsMobileDevice) && mMultitouchClass != null)
            {
               mIsMobileDevice = true;
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
         if (mIsAppDeactivated && mIsMobileDevice)
            return; // avoid making the mobile device slow
         
         switch (mStateId)
         {
            case StateId_Loading:
               // Load progress on screen
               break;
            case StateId_LoadingError:
               // "Copy Error Message" and "Report Error" in Context Menu
               break;
            case StateId_Building:
               // "Build ..." text on screen

               var buildStatus:int = mWorldDesignProperties.GetBuildingStatus (); 
               if (buildStatus > 0)
               {
                  SetErrorMessage (null);
                  
                  InitPlayerWorld ();
                  
                  ChangeState (StateId_Playing);
               }
               else if (buildStatus < 0)
               {
                  ChangeState (StateId_BuildingError);
               }
               
               break;
            case StateId_BuildingError:
               // "Copy Error Message" and "Report Error" in Context Menu
               break;
            case StateId_Playing:
               Step (false);
               break;
            case StateId_PlayingError:
               // "Copy Error Message" and "Report Error" in Context Menu
               break;
            case StateId_Unknown:
            default:
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

      public static function TraceError (error:Error):void
      {
         //if (Capabilities.isDebugger)
            trace (error.getStackTrace ());
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

               ReloadPlayerWorld ();
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
         if (mWorldPluginDomain.hasDefinition ("Main")) // for uniplayer and gamepackage
         {
            mWorldPlugin = mWorldPluginDomain.getDefinition ("Main");
         }
         else // if (mWorldPluginDomain.hasDefinition ("plugin.WorldPlugin")) // for editor
         {
            mWorldPlugin = mWorldPluginDomain.getDefinition ("plugin.WorldPlugin");
         }

         mWorldPluginProperties = mWorldPlugin.Call ("GetStaticProperties");
      }

      private var mWorldDesignProperties:Object;

      private function RetrieveWorldDesignProperties ():void
      {
         mWorldDesignProperties = mWorldPlugin.Call ("GetWorldProperties", {mWorld: mPlayerWorld});

         if (mWorldDesignProperties.mIsPermitPublishing == undefined)        mWorldDesignProperties.mIsPermitPublishing = false;
         if (mWorldDesignProperties.mIsShareSourceCode == undefined)         mWorldDesignProperties.mIsShareSourceCode = false;
         if (mWorldDesignProperties.GetZoomScale == null)                    mWorldDesignProperties.GetZoomScale = DummyCallback_GetScale;
         if (mWorldDesignProperties.SetZoomScale == null)                    mWorldDesignProperties.SetZoomScale = DummyCallback;
         if (mWorldDesignProperties.GetViewportWidth == null)                mWorldDesignProperties.GetViewportWidth = DummyCallback_ViewSize;
         if (mWorldDesignProperties.GetViewportHeight == null)               mWorldDesignProperties.GetViewportHeight = DummyCallback_ViewSize;
         if (mWorldDesignProperties.SetRealViewportSize == null)             mWorldDesignProperties.SetRealViewportSize = DummyCallback;
         if (mWorldDesignProperties.GetViewerUiFlags == null)                mWorldDesignProperties.GetViewerUiFlags = DummyCallback_UiFlags;
         if (mWorldDesignProperties.GetPlayBarColor == null)                 mWorldDesignProperties.GetPlayBarColor = DummyCallback_PlayBarColor;
         if (mWorldDesignProperties.Initialize == null)                      mWorldDesignProperties.Initialize = DummyCallback;
         if (mWorldDesignProperties.SetSingleStepMode == null)               mWorldDesignProperties.SetSingleStepMode = DummyCallback;
         if (mWorldDesignProperties.SetPaused == null)                       mWorldDesignProperties.SetPaused = DummyCallback;
         if (mWorldDesignProperties.SetInteractiveEnabledWhenPaused == null) mWorldDesignProperties.SetInteractiveEnabledWhenPaused = DummyCallback;
         if (mWorldDesignProperties.SetCacheSystemEvent == null)             mWorldDesignProperties.SetCacheSystemEvent = DummyCallback;
         if (mWorldDesignProperties.GetBuildingStatus == null)               mWorldDesignProperties.GetBuildingStatus = DummyCallback_BuildingStatus;
         if (mWorldDesignProperties.SetRealViewportSize == null)             mWorldDesignProperties.SetRealViewportSize = DummyCallback;
         if (mWorldDesignProperties.mHasSounds == undefined)                 mWorldDesignProperties.mHasSounds = false;
         if (mWorldDesignProperties.mInitialSoundEnabled == undefined)       mWorldDesignProperties.mInitialSoundEnabled = true;
         if (mWorldDesignProperties.mInitialSpeedX == undefined)             mWorldDesignProperties.mInitialSpeedX = 2;
         if (mWorldDesignProperties.mInitialZoomScale == undefined)          mWorldDesignProperties.mInitialZoomScale = 1.0;

         mPlayBarColor = mPlayerWorld == null ? 0x606060 : mWorldDesignProperties.GetPlayBarColor ();
         mShowPlayBar = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0);
         mShowSpeedAdjustor = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowSpeedAdjustor) != 0);
         mShowScaleAdjustor = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowScaleAdjustor) != 0);
         mShowSoundController = mWorldDesignProperties.mHasSounds;
         mShowHelpButton = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowHelpButton) != 0);
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
         if (mWorldPluginProperties.mWorldVersion >= 0x0104)
         {
            return Define.PlayerUiFlag_ShowPlayBar | Define.PlayerUiFlag_ShowSpeedAdjustor | Define.PlayerUiFlag_ShowScaleAdjustor | Define.PlayerUiFlag_ShowHelpButton;
         }
         else
         {
            return Define.PlayerUiFlag_ShowPlayBar | Define.PlayerUiFlag_ShowSpeedAdjustor | Define.PlayerUiFlag_ShowHelpButton;
         }
      }
      
      // from v1.58
      // =0 - loading
      // >0 - succeeded
      // <0 - failed
      private function DummyCallback_BuildingStatus ():int
      {
         return 1;
      }

//======================================================================
//
//======================================================================

      private function ReloadPlayerWorld (restartLevel:Boolean = false):void
      {
      //trace ("ReloadPlayerWorld");

         //var isFirstTime:Boolean = (mPlayerWorld == null);
         mFirstTimePlaying = (mPlayerWorld == null);

         try
         {
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

            mWorldBinaryData.position = 0;
            var worldDefine:Object = (mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine as Function) (mWorldBinaryData);
            if (worldDefine != null && worldDefine.hasOwnProperty ("mForRestartLevel"))
            {
               worldDefine.mForRestartLevel = restartLevel;
            }
            mPlayerWorld = (mWorldPluginProperties.WorldFormat_WorldDefine2PlayerWorld as Function) (worldDefine);

            if (mPlayerWorld == null)
               throw new Error ("Fails to create world");

            RetrieveWorldDesignProperties ();

            var hidePlayBar:Boolean = (mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) == 0;

            mWorldDesignProperties.SetCacheSystemEvent (! hidePlayBar);
            mWorldDesignProperties.SetInteractiveEnabledWhenPaused (hidePlayBar ||  mParamsFromEditor != null);

            mWorldLayer.addChild (mPlayerWorld as Sprite);

            if (mFirstTimePlaying)
            {
               BuildSkin ();

               BuildContextMenu ();
            }
            
            mSkin.SetSoundEnabled (mWorldDesignProperties.mInitialSoundEnabled);
            mSkin.SetPlayingSpeedX (mWorldDesignProperties.mInitialSpeedX);
            mSkin.SetZoomScale (mWorldDesignProperties.mInitialZoomScale, false);

            mSkin.SetLevelFinishedDialogVisible (false);
            mSkin.SetHelpDialogVisible (false);

            // from v1.5
            mWorldPlugin.Call ("SetUiParams", {
               mWorld : mPlayerWorld,
               OnClickRestart : mSkin.Restart,
               IsPlaying : mSkin.IsPlaying,
               SetPlaying : mSkin.SetPlaying,
               GetPlayingSpeedX : mSkin.GetPlayingSpeedX,
               SetPlayingSpeedX : mSkin.SetPlayingSpeedX,
               GetZoomScale : mSkin.GetZoomScale,
               SetZoomScale : mSkin.SetZoomScale,
               IsSoundEnabled : mSkin.IsSoundEnabled,
               SetSoundEnabled : mSkin.SetSoundEnabled
            });

            // ...
            mPlayerWorldZoomScale = mWorldDesignProperties.GetZoomScale ();
            mSkin.SetZoomScale (mPlayerWorldZoomScale);
            
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
            mWorldDesignProperties.Initialize ();

            // special handling, before v1.02 (not include v1.02), to make world center in viewer
            // (edit) ??? seems before v1.06 (including v1.06)
            // maybe it is better to put this in mWorldDesignProperties.Initialize ()
            //if (mWorldPluginProperties.mWorldVersion < 0x0102)
            if (mWorldPluginProperties.mWorldVersion <= 0x0106)
            {
               mWorldDesignProperties.Update (0, 1);
            }

            if (mFirstTimePlaying)
            {
               if (mStartRightNow) mSkin.SetPlaying (true);
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

      private var mFpsCounter:FpsCounter;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();

      public function Step (singleStepMode:Boolean = false):void
      {
         if (mErrorMessageLayer.visible)
            return;
         
         if (mPlayerWorld == null)
            return;

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
               mWorldDesignProperties.Update (mStepTimeSpan.GetLastSpan (), GetPlayingSpeedX ());
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

            mSkin.NotifyStarted ();
         }

         mSkin.SetLevelFinishedDialogVisible (mWorldDesignProperties.IsLevelSuccessed ());
         mSkin.Update (mStepTimeSpan.GetLastSpan ());
      }

//======================================================================
//
//======================================================================

      private var mSkin:Skin = null;

      private function BuildSkin ():void
      {
         // play bar

         var skinParams:Object = {
                  OnRestart: OnRestart,
                  OnStart: OnStart,
                  OnPause: OnPause,
                  OnSpeedChanged: OnSpeedChanged,
                  OnScaleChanged: OnScaleChanged,
                  OnSoundControlChanged: OnSoundControlChanged,
                  
                  mHasMainMenu: mParamsFromContainer.mHasMainMenu,
                  OnExitLevel: mParamsFromContainer.OnExitLevel,
                  OnNextLevel: mParamsFromContainer.OnNextLevel,
                  OnGoToPhyard: mParamsFromContainer.OnGoToPhyard
               };

         // for testing phones
         //mIsPhoneDevice = true;
         
         if (mIsPhoneDevice)
         {
            mSkin = new SkinSmallScreen (skinParams); // mobile phone
         }
         else
         {
            // fot testing tablets
            //mIsMobileDevice = true;
            
            skinParams.mIsMobileDevice = mIsMobileDevice;
            
            mSkin = new SkinLargeScreen (skinParams); // PC or tablet
         }
         
         mSkin.SetShowPlayBar ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0);
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
               
                  this.x = Math.round ((containerWidth  - viewerWidth ) / 2);
                  this.y = Math.round ((containerHeight - viewerHeight) / 2);
               }
               else //if (mParamsFromUniViewer != null || mParamsFromGamePackage != null)
               {
                  // fill all container space
                  
                  viewerWidth  = containerWidth;
                  viewerHeight = containerHeight;
                  
                  this.x = this.y = 0.0;
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
         
         mErrorMessageText = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText (errorMessage), true, 0xFFFFFF);
         mErrorMessageLayer.addChild (mErrorMessageText);
         
         CenterErrorMessageText ();
      }
      
      private function CenterErrorMessageText ():void
      {
         if (mErrorMessageText != null)
         {
            mErrorMessageLayer.x = - this.x;
            mErrorMessageLayer.y = - this.y;
            
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

         var addSeperaor:Boolean = false;
         if (Capabilities.isDebugger || mPlayerWorld != null && mWorldDesignProperties.mIsShareSourceCode)
         {
            if (mWorldBinaryData != null && mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine != null && mWorldPluginProperties.WorldFormat_WorldDefine2Xml != null)
            {
               //mWorldSourceCode = DataFormat2.WorldDefine2Xml (DataFormat2.HexString2WorldDefine (mWorldPlayCode));

               mWorldBinaryData.position = 0;
               mWorldSourceCode = (mWorldPluginProperties.WorldFormat_WorldDefine2Xml as Function) ((mWorldPluginProperties.WorldFormat_ByteArray2WorldDefine as Function) (mWorldBinaryData));

               if (mWorldSourceCode != null)
               {
                  var copySourceCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Source Code", false);
                  theContextMenu.customItems.push (copySourceCodeMenuItem);
                  copySourceCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopySourceCode);

                  addSeperaor = true;
               }
            }
         }

         if (mParamsFromUniViewer != null && mPlayerWorld != null && mParamsFromUniViewer.mUniViewerUrl != null && mParamsFromUniViewer.mUniViewerUrl.indexOf ("uniplayer.swf?") >= 0)
         {
            if (mWorldDesignProperties.mIsPermitPublishing)
            {
               var copyEmbedCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy HTML Embed Code", false);
               theContextMenu.customItems.push (copyEmbedCodeMenuItem);
               copyEmbedCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyEmbedCode);
            }

            var copyForumEmbedCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Phyard Forum Embed Code", false);
            theContextMenu.customItems.push (copyForumEmbedCodeMenuItem);
            copyForumEmbedCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyForumEmbedCode);

            addSeperaor = true;
         }

         var aboutItem:ContextMenuItem = new ContextMenuItem("About Phyard Viewer", addSeperaor); // v" + DataFormat3.GetVersionString (Version.VersionNumber), addSeperaor);
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
            if ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0)
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
            //   if ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0)
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

                  var showPlayBar:Boolean = (mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0;
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

//===========================================================================
// interfaces for game template
//===========================================================================

      public function OnBackKeyDown ():Boolean
      {
         if (mSkin != null)
         {
            if (mSkin.IsPlaying ())
               mSkin.SetPlaying (false);
            else if (mParamsFromContainer.OnExitLevel != null)
               mParamsFromContainer.OnExitLevel ();
            else
               return false;
            
            return true;
         }
         
         return false;
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

      private function OnRestart (data:Object = null):void
      {
         ReloadPlayerWorld (true);

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

      private function OnSoundControlChanged (data:Object = null):void
      {
         if (mSkin == null)
            return;

         mWorldDesignProperties.SetSoundEnabled (mSkin.IsSoundEnabled ());
      }

//===========================================================================
// interfaces for editing
//===========================================================================

      public function PlayRestart ():void
      {
         if (mSkin != null)
            mSkin.Restart ();
      }

      public function PlayRun ():void
      {
         if (mSkin != null)
            mSkin.SetPlaying (true);
      }

      public function PlayPause ():void
      {
         if (mSkin != null)
            mSkin.SetPlaying (false);
      }

      public function PlayFaster (delta:uint):Boolean
      {
         if (mSkin == null)
            return true;

         mSkin.SetPlayingSpeedX (GetPlayingSpeedX () + delta);

         return true;
      }

      public function PlaySlower (delta:uint):Boolean
      {
         if (mSkin == null)
            return true;

         mSkin.SetPlayingSpeedX (GetPlayingSpeedX () - delta);

          return GetPlayingSpeedX () > 0;
      }

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
      
      private var mExternalPaused:Boolean = false;
      public function SetExternalPaused (paused:Boolean):void
      {
         mExternalPaused = paused;
      }

      public function GetPlayerWorld ():Object
      {
         return mPlayerWorld;
      }

      public function UpdateSingleStep ():void
      {
         Step (true);
      }

   }
}
