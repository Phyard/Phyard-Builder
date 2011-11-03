
package viewer {

   import flash.utils.ByteArray;

   import flash.geom.Point;
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

   import com.tapirgames.display.FpsCounter;
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;

   import viewer.ui.UiUtil;
   import viewer.ui.PlayHelpDialog;
   import viewer.ui.PlayControlBar;

   import common.DataFormat3;
   import common.Define;
   import common.Version;

   public class Viewer extends Sprite
   {
      [Embed(source="../../res/player/player-mainmenu.png")]
      private static var IconMainMenu:Class;
      [Embed(source="../../res/player/player-phyard.png")]
      private static var IconPhyard:Class;

      private var mBitmapDataMainMenu:BitmapData  = new IconMainMenu ().bitmapData;
      private var mBitmapDataPhyard:BitmapData  = new IconPhyard ().bitmapData;

//======================================================================
//
//======================================================================

   // input params, one and only one is not null

      private var mParamsFromContainer:Object; // can't be null, equals any of the following ones

         private var mParamsFromUniViewer:Object = null;

         private var mParamsFromEditor:Object = null;

         private var mParamsFromGamePackage:Object = null;

   // special interfaces for editor

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

      public function SetMaskViewerField (mask:Boolean):void
      {
         mMaskViewerField = mask;

         if (mMaskViewerField)
         {
            if (! contains (mMaskShape))
               addChild (mMaskShape);

            this.mask = mMaskShape;
         }
         else
         {
            if (contains (mMaskShape))
               removeChild (mMaskShape);

            this.mask = null;
         }
      }

//======================================================================
//
//======================================================================

      private var mStartRightNow:Boolean = false;
      private var mMaskViewerField:Boolean = true;

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
         private var mViewportWidth:int;
         private var mViewportHeight:int;
         private var mViewerWidth:Number;
         private var mViewerHeight:Number;

      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;

      private var mPlayerWorldZoomScale:Number = 1.0;
      private var mPlayerWorldZoomScaleChangedSpeed:Number = 0.0;

      private var mWorldLayer:Sprite = new Sprite ();
      private var mTopBarLayer:Sprite = new Sprite ();
      //private var mBottomBarLayer:Sprite = new Sprite ();
      //private var mBorderLineBarLayer:Sprite = new Sprite ();
      //private var mErrorMessageLayer:Sprite = new Sprite ();
      private var mFinishedTextLayer:Sprite = new Sprite ();
      private var mDialogLayer:Sprite = new Sprite ();

      private var mMaskShape:Sprite = new Sprite ();

//======================================================================
//
//======================================================================



      public function Viewer (params:Object = null)
      {
         trace ("Viewer params = " + params);

         if (params == null) // strange: flash auto instance this class when loading done. shit!
            return;

         addChild (mWorldLayer);
         //addChild (mBottomBarLayer);
         addChild (mTopBarLayer);
         //addChild (mErrorMessageLayer);
         //addChild (mBorderLineBarLayer);
         addChild (mFinishedTextLayer);
         addChild (mDialogLayer);

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
         //if (mParamsFromEditor == null || mParamsFromEditor.GetViewportSize == null)
         //{
         //   CheckStageSize (Number (App::Default_Width),  Number (App::Default_Height));
         //}

         addEventListener (Event.ENTER_FRAME, Update);
         addEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromFrame);

         ParseParams ();
      }

      private function OnRemovedFromFrame (e:Event):void
      {
         removeEventListener (Event.ENTER_FRAME, Update);
         removeEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromFrame);
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
               break;
            case StateId_Building:
               break;
            case StateId_BuildingError:
               break;
            case StateId_Playing:
               break;
            case StateId_PlayingError:
               break;
         }
      }

      public static function TraceError (error:Error):void
      {
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

            if (Compile::Is_Debugging)
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

            if (Compile::Is_Debugging)
               throw error;
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

            if (Compile::Is_Debugging)
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
         if (mWorldDesignProperties.GetViewerUiFlags == null)                mWorldDesignProperties.GetViewerUiFlags = DummyCallback_UiFlags;
         if (mWorldDesignProperties.GetPlayBarColor == null)                 mWorldDesignProperties.GetPlayBarColor = DummyCallback_PlayBarColor;
         if (mWorldDesignProperties.Initialize == null)                      mWorldDesignProperties.Initialize = DummyCallback;
         if (mWorldDesignProperties.SetSingleStepMode == null)               mWorldDesignProperties.SetSingleStepMode = DummyCallback;
         if (mWorldDesignProperties.SetPaused == null)                       mWorldDesignProperties.SetPaused = DummyCallback;
         if (mWorldDesignProperties.SetInteractiveEnabledWhenPaused == null) mWorldDesignProperties.SetInteractiveEnabledWhenPaused = DummyCallback;
         if (mWorldDesignProperties.SetCacheSystemEvent == null)             mWorldDesignProperties.SetCacheSystemEvent = DummyCallback;
         if (mWorldDesignProperties.GetBuildingStatus == null)               mWorldDesignProperties.GetBuildingStatus = DummyCallback_BuildingStatus;

         mPlayBarColor = mPlayerWorld == null ? 0x606060 : mWorldDesignProperties.GetPlayBarColor ();
         mShowPlayBar = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0);
         mShowSpeedAdjustor = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowSpeedAdjustor) != 0);
         mShowScaleAdjustor = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowScaleAdjustor) != 0);
         mShowHelpButton = mPlayerWorld == null ? true : ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowHelpButton) != 0);
         mViewportWidth = mPlayerWorld == null ? Define.DefaultPlayerWidth : mWorldDesignProperties.GetViewportWidth ();
         mViewportHeight = mPlayerWorld == null ? Define.DefaultPlayerHeight : mWorldDesignProperties.GetViewportHeight ();
         mViewerWidth = mViewportWidth;
         mViewerHeight = mShowPlayBar ? (Define.PlayerPlayBarThickness + mViewportHeight) : mViewportHeight;
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

         var isFirstTime:Boolean = (mPlayerWorld == null);

         try
         {
            if (isFirstTime)
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

            mEverFinished = false;

            if (isFirstTime)
            {
               CreateTopBar ();

               if ((mWorldDesignProperties.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0)
                  mWorldLayer.y = mTopBarLayer.y + mTopBarLayer.height;
               else
                  mWorldLayer.y = mTopBarLayer.y;

               CreateHelpDialog ();

               CreateFinishedDialog ();

               BuildContextMenu ();
            }

            CloseFinishedDialog ();
            CloseHelpDialog ();

            // from v1.5
            mWorldPlugin.Call ("SetUiParams", {
               mWorld : mPlayerWorld,
               OnClickRestart : mPlayControlBar.OnClickRestart,
               IsPlaying : mPlayControlBar.IsPlaying,
               SetPlaying : mPlayControlBar.SetPlaying,
               GetPlayingSpeedX : mPlayControlBar.GetPlayingSpeedX,
               SetPlayingSpeedX : mPlayControlBar.SetPlayingSpeedX,
               GetZoomScale : mPlayControlBar.GetZoomScale,
               SetZoomScale : mPlayControlBar.SetZoomScale
            });

            mWorldDesignProperties.Initialize ();

            // special handling, before v1.02 (not include v1.02), to make world center in viewer
            // (edit) ??? seems before v1.06 (including v1.06)
            // maybe it is better to put this in mWorldDesignProperties.Initialize ()
            //if (mWorldPluginProperties.mWorldVersion < 0x0102)
            if (mWorldPluginProperties.mWorldVersion <= 0x0106)
            {
               mWorldDesignProperties.Update (0, 1);
            }

            // ...
            mPlayerWorldZoomScale = mWorldDesignProperties.GetZoomScale ();
            mPlayControlBar.SetZoomScale (mPlayerWorldZoomScale);

            if (isFirstTime)
            {
               if (mStartRightNow) mPlayControlBar.OnClickStart ();
            }
            
            ChangeState (StateId_Building);
         }
         catch (error:Error)
         {
            TraceError (error);

            if (Compile::Is_Debugging)
               throw error;

            ChangeState (StateId_LoadingError);
         }
      }

//======================================================================
//
//======================================================================

      private var mFpsCounter:FpsCounter;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();

      public function Step (singleStepMode:Boolean = false):void
      {
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

         var paused:Boolean = (! IsPlaying ()) || mHelpDialog.visible;

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

               //if (mParamsFromEditor != null)
               //{
               //   throw error; // let editor to handle it
               //}
               //else
               {
                  // todo show dialog: "stop" or "continue";
                  // write log of send message to server

                  ChangeState (StateId_PlayingError);
               }

               if (Compile::Is_Debugging)
               {
                  throw error;
               }
            }

            if (mPlayControlBar != null)
            {
               mPlayControlBar.NotifyStepped ();
            }
         }

         if (mWorldDesignProperties.IsLevelSuccessed ())
         {
            OpenFinishedDialog ();
         }
         else
         {
            CloseFinishedDialog ();
         }
      }

//======================================================================
//
//======================================================================

      /*
      private function ClearInfoMessage ():void
      {
         while (mErrorMessageLayer.numChildren > 0)
            mErrorMessageLayer.removeChildAt (0);
         GraphicsUtil.Clear (mErrorMessageLayer);
      }

      private function BuildInfoMessage (message:String, linkUrl:String = null):void
      {
         ClearInfoMessage ();

         var w:int;
         var h:int;
         if (mParamsFromEditor == null || mParamsFromEditor.GetViewportSize == null)
         {
            w = App::Default_Width;
            h = App::Default_Height;
         }
         else
         {
            var size:Point = mParamsFromEditor.GetViewportSize ();
            w = size.x;
            h = size.y;
         }

         var errorText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText (message));
         errorText.x = (w  - errorText.width ) * 0.5;
         errorText.y = (h - errorText.height) * 0.5;
         mErrorMessageLayer.addChild (errorText);

         if (linkUrl != null)
         {
            var linkText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("<font size='10' color='#0000ff'><u><a href='" + linkUrl + "' target='_blank'>ColorInfection.com</a></u></font>"));
            linkText.x = (w  - linkText.width ) * 0.5;
            linkText.y = h - linkText.height - 20;
            mErrorMessageLayer.addChild (linkText);
         }
      }
      */

//======================================================================
//
//======================================================================

      private var mFinishedDialog:Sprite;

      private var mTextFinished:TextFieldEx;
      private var mTextAuthorInfo:TextFieldEx;
      private var mButtonMainMenu:TextButton;
      private var mButtonNextLevel:TextButton;
      private var mButtonReplay:TextButton;
      private var mButtonCloseFinishDialog:TextButton;

      private var mEverFinished:Boolean = false;

      private function CreateFinishedDialog ():void
      {
         var finishedText:String = "<font size='30' face='Verdana' color='#000000'> <b>Cool! It is solved.</b></font>";
         mTextFinished = TextFieldEx.CreateTextField (finishedText, false, 0xFFFFFF, 0x0, false);

         mButtonMainMenu = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Menu</font>", OnMainMenu);
         mButtonNextLevel = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Next</font>", OnNextLevel);
         mButtonReplay = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Replay</font>", OnRestart);
         mButtonCloseFinishDialog = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>Close</font>", CloseFinishedDialog);
         var buttonContainer:Sprite = new Sprite ();
         var buttonX:Number = 0;
         if (mParamsFromContainer.HasNextLevel != null && mParamsFromContainer.HasNextLevel ())
         {
            buttonContainer.addChild (mButtonNextLevel);
            mButtonNextLevel.x = buttonX;
            buttonX += mButtonNextLevel.width + 50;
         }
         else if (mParamsFromContainer.OnMainMenu != null)
         {
            buttonContainer.addChild (mButtonMainMenu);
            mButtonMainMenu.x = buttonX;
            buttonX += mButtonMainMenu.width + 50;
         }
         buttonContainer.addChild (mButtonReplay);
         mButtonReplay.x = buttonX;
         buttonX += mButtonReplay.width + 50;
         buttonContainer.addChild (mButtonCloseFinishDialog);
         mButtonCloseFinishDialog.x = buttonX;

         var infoText:String = "";

         if (mWorldLayer != null)
         {
            var authorName:String = mWorldDesignProperties.mAuthorName;
            var anthorUrl:String = mWorldDesignProperties.mAuthorHomepage.toLowerCase();

            if (anthorUrl.indexOf ("http") != 0)
               anthorUrl = null;

            if (authorName != null && authorName.length > 0)
            {
               authorName = authorName.substr (0, 32);

               var authorInfoText:String;

               if (anthorUrl == null)
                  infoText = infoText + "<font face='Verdana' size='15'>This puzzle is created by <b><i>" + authorName + "</i></b></font>.";
               else
                  infoText = infoText + "<font face='Verdana' size='15'>This puzzle is created by <font color='#0000FF'><b><i><u><a href='" + anthorUrl + "' target='_blank' >" + authorName + "</a></u></i></b></font>.</font>";
            }
         }

         if (infoText.length > 0 )
            infoText = infoText + "<br>";
         infoText = infoText + "<br><font face='Verdana' size='15'>";
         infoText = infoText + "Want to <font color='#0000FF'><u><a href='http://www.phyard.com' target='_blank'>design your own puzzles</a></u></font>?";
         infoText = infoText + "</font>";

         mTextAuthorInfo = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, 0x0);

         mFinishedDialog = UiUtil.CreateDialog ([mTextFinished, 20, mTextAuthorInfo, 20, buttonContainer]);
         CenterSpriteOnWorld (mFinishedDialog);
         mFinishedDialog.visible = false;
         mFinishedDialog.alpha = 0.9;

         //
         mFinishedTextLayer.addChild (mFinishedDialog);
      }

      private function OpenFinishedDialog ():void
      {
         if (mFinishedDialog == null)
            return;

         if (mFinishedDialog != null && ! mEverFinished)
         {
            mEverFinished = true;

            mFinishedDialog.visible = true;

            if (mParamsFromContainer.OnLevelFinished != null)
               mParamsFromContainer.OnLevelFinished ();
         }

         if (mFinishedDialog.visible)
         {
            mFinishedDialog.alpha += 0.025;
            if (mFinishedDialog.alpha > 0.9)
               mFinishedDialog.alpha = 0.9;
         }
      }

      private function CloseFinishedDialog ():void
      {
         if (mFinishedDialog != null)
         {
            mFinishedDialog.alpha = 0.00;
            mFinishedDialog.visible = false;
         }
      }

      private var mHelpDialog:Sprite;

      private function CreateHelpDialog ():void
      {
         mHelpDialog = new PlayHelpDialog (CloseHelpDialog);
         CenterSpriteOnWorld (mHelpDialog);

         mHelpDialog.visible = false;

         mDialogLayer.addChild (mHelpDialog);
      }

      private function OpenHelpDialog ():void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = true;

         //OnPause (null);
      }

      private function CloseHelpDialog ():void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = false;
      }

      private var mPlayControlBar:PlayControlBar = null;
      private var mImageButtonMainMenu:ImageButton = null;
      private var mImageButtonPhyard:ImageButton = null;

      private function CreateTopBar ():void
      {
         OnContainerResized ();

         // play bar

         GraphicsUtil.ClearAndDrawRect (mTopBarLayer, 0, 0, mViewportWidth, Define.PlayerPlayBarThickness, mPlayBarColor, 1, true, mPlayBarColor);

         mPlayControlBar = new PlayControlBar ({
                              OnRestart: OnRestart,
                              OnStart: OnStart,
                              OnPause: OnPause,
                              OnSpeed: OnSpeed, mShowSpeedAdjustor: mShowSpeedAdjustor,
                              OnZoom: OnZoom, mShowScaleAdjustor: mShowScaleAdjustor && (mParamsFromContainer.mHideScaleButtons == undefined || mParamsFromContainer.mHideScaleButtons == false),
                              OnHelp: OnHelp, mShowHelpButton: mShowHelpButton,
                              OnMainMenu: null
                           });
         mTopBarLayer.addChild (mPlayControlBar);
         mPlayControlBar.x = 0.5 * (mTopBarLayer.width - mPlayControlBar.width);
         mPlayControlBar.y = 2;

         //GraphicsUtil.ClearAndDrawRect (mBorderLineBarLayer, 0, 0, mViewerWidth - 1, mViewerHeight - 1, 0x606060);

         mTopBarLayer.visible = mShowPlayBar;
         mTopBarLayer.x = 0;
         mTopBarLayer.y = 0;

         // main menu
         if (mParamsFromContainer.OnMainMenu != null)
         {
            mImageButtonMainMenu = new ImageButton (mBitmapDataMainMenu);
            mImageButtonMainMenu.SetClickEventHandler (OnMainMenu);
            mTopBarLayer.addChild (mImageButtonMainMenu);
            mImageButtonMainMenu.x = 2;
            mImageButtonMainMenu.y = 2;
         }

         // phyard link
         if (mParamsFromContainer.OnGoToPhyard != null)
         {
            mImageButtonPhyard = new ImageButton (mBitmapDataPhyard);
            mImageButtonPhyard.SetClickEventHandler (OnGotoPhyard);
            mTopBarLayer.addChild (mImageButtonPhyard);
            mImageButtonPhyard.x = mViewportWidth - mImageButtonPhyard.width - 2;
            mImageButtonPhyard.y = 2;
         }

         // mask
         GraphicsUtil.ClearAndDrawRect (mMaskShape, 0, 0, mViewerWidth, mViewerHeight, 0x0, -1, true);
         if (mMaskViewerField)
         {
            addChild (mMaskShape);
            this.mask = mMaskViewerField ? mMaskShape : null;
         }
      }

      public function OnContainerResized ():void
      {
         //if (mParamsFromEditor == null || mParamsFromEditor.GetViewportSize == null)
         if (mParamsFromUniViewer != null || mParamsFromGamePackage != null)
         {
            var containerSize:Point = mParamsFromContainer.GetViewportSize ();
            var containerWidth :Number = containerSize.x;
            var containerHeight:Number = containerSize.y;
            var widthRatio :Number = containerWidth  / mViewerWidth ;
            var heightRatio:Number = containerHeight / mViewerHeight;

            if (widthRatio < heightRatio)
            {
               this.scaleX = this.scaleY = widthRatio;
               this.x = 0;
               this.y = 0.5 * Number (containerHeight - mViewerHeight * widthRatio);
            }
            else if (widthRatio > heightRatio)
            {
               this.scaleX = this.scaleY = heightRatio;
               this.x = 0.5 * Number (containerWidth - mViewerWidth * heightRatio);
               this.y = 0;
            }
            else
            {
               this.scaleX = this.scaleY = widthRatio;
               this.x = 0;
               this.y = 0;
            }
         }
      }

      private function CenterSpriteOnWorld (sprite:Sprite):void
      {
         sprite.x = mWorldLayer.x + 0.5 * (mWorldDesignProperties.GetViewportWidth () - sprite.width);
         sprite.y = mWorldLayer.y + 0.5 * (mWorldDesignProperties.GetViewportHeight () - sprite.height);
      }

//======================================================================
//
//======================================================================

      /*
      private function CheckStageSize (contentWidth:Number, contentHeight:Number):void
      {
         // In fact, I still don't know why this code works.
         // Weird flash!

         var defaultRatio:Number;
         var stageRatio:Number;
         var marginTop:Number; // default unit
         var marginLeft:Number; // default unit
         var scaleStageToDefault:Number;

         defaultRatio = Number (App::Default_Height) / Number (App::Default_Width);
         stageRatio = stage.stageHeight / stage.stageWidth;
         if (defaultRatio < stageRatio)
         {
            marginLeft = 0;
            marginTop = 0.5 * (Number (App::Default_Width) * stageRatio - Number (App::Default_Height));
            scaleStageToDefault = Number (App::Default_Width) / stage.stageWidth;
         }
         else
         {
            marginLeft = 0.5 * (Number (App::Default_Height) / stageRatio - Number (App::Default_Width));
            marginTop = 0;
            scaleStageToDefault = Number (App::Default_Height) / stage.stageHeight;
         }

         var ratio:Number = contentHeight / contentWidth;
         var availableWidth:Number; // stage unit
         var availableHeight:Number; // stage unit
         var scale:Number;
         var topY:Number; // stage unit
         var leftX:Number; // stage unit
         if (Math.abs (ratio - stageRatio) < 1e-12)
         {
            availableWidth = stage.stageWidth;
            availableHeight = stage.stageHeight;
            scale = contentWidth >= contentHeight ? availableWidth / contentWidth : availableHeight / contentHeight;
            leftX = 0;
            topY = 0;
         }
         else if (ratio < stageRatio)
         {
            availableWidth = stage.stageWidth;
            availableHeight = availableWidth * ratio;
            scale = availableWidth / contentWidth;
            leftX = 0;
            topY = 0.5 * (stage.stageHeight - availableHeight);
         }
         else
         {
            availableHeight = stage.stageHeight;
            availableWidth = availableHeight / ratio;
            scale = availableHeight / contentHeight;
            leftX = 0.5 * (stage.stageWidth - availableWidth);
            topY = 0;
         }
         leftX *= scaleStageToDefault;
         topY *= scaleStageToDefault;
         scale *= scaleStageToDefault;

         this.scaleX = this.scaleY = scale;
         this.x =  leftX - marginLeft;
         this.y = topY - marginTop;
      }
      */

      /*
      private function CheckStageSize (viewerWidth:Number, viewerHeight:Number):void
      {
         var containerSize:Point = mParamsFromContainer.GetViewportSize ();
         var containerWidth :Number = containerSize.x;
         var containerHeight:Number = containerSize.y;
         var widthRatio :Number = containerWidth  / viewerWidth ;
         var heightRatio:Number = containerHeight / viewerHeight;

         if (widthRatio < heightRatio)
         {
            this.scaleX = this.scaleY = widthRatio;
            this.x = 0;
            this.y = 0.5 * Number (containerHeight - viewerHeight * widthRatio);
         }
         else if (widthRatio > heightRatio)
         {
            this.scaleX = this.scaleY = heightRatio;
            this.x = 0.5 * Number (containerWidth - viewerWidth * heightRatio);
            this.y = 0;
         }
         else
         {
            this.scaleX = this.scaleY = widthRatio;
            this.x = 0;
            this.y = 0;
         }
      }
      */

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

         var addSeperaor:Boolean = false;
         if (Compile::Is_Debugging || mPlayerWorld != null && mWorldDesignProperties.mIsShareSourceCode)
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
               height += 20;

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

//======================================================================
//
//======================================================================

      public function IsPlaying ():Boolean
      {
         if(mPlayControlBar == null)
            return false;

         return mPlayControlBar.IsPlaying ();
      }

      public function GetPlayingSpeedX ():int
      {
         if(mPlayControlBar == null)
            return 2;

         return mPlayControlBar.GetPlayingSpeedX ();
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

      private function OnSpeed (data:Object = null):void
      {
         if (_OnSpeed != null)
            _OnSpeed ();
      }

      private function OnZoom (data:Object = null):void
      {
         if (mPlayControlBar == null)
            return;

         mPlayerWorldZoomScale = mPlayControlBar.GetZoomScale ();

         if (mPlayerWorld == null)
            return;

         if ((data is Boolean) && (! (data as Boolean)))
         {
            mWorldDesignProperties.SetZoomScale (mPlayerWorldZoomScale);

            return;
         }

         mPlayerWorldZoomScaleChangedSpeed = ( mPlayerWorldZoomScale - mWorldDesignProperties.GetZoomScale () ) * 0.03;
      }

      private function OnHelp (data:Object = null):void
      {
         OpenHelpDialog ();
      }

      private function OnMainMenu (data:Object = null):void
      {
         if (mParamsFromContainer.OnMainMenu != null)
            mParamsFromContainer.OnMainMenu (data);
      }
      
      private function OnNextLevel (data:Object = null):void
      {
         if (mParamsFromContainer.OnNextLevel != null)
            mParamsFromContainer.OnNextLevel (data);
      }

      private function OnGotoPhyard (data:Object = null):void
      {
         if (mParamsFromContainer.OnGoToPhyard != null)
            mParamsFromContainer.OnGoToPhyard (data);
      }

   //=========================
   // interfaces for editing
   //=========================

      public function PlayRestart ():void
      {
         if (mPlayControlBar != null)
            mPlayControlBar.OnClickRestart ();
      }

      public function PlayRun ():void
      {
         if (mPlayControlBar != null)
            mPlayControlBar.OnClickStart ();
      }

      public function PlayPause ():void
      {
         if (mPlayControlBar != null)
            mPlayControlBar.OnClickPause ();
      }

      public function PlayFaster (delta:uint):Boolean
      {
         if (mPlayControlBar == null)
            return true;

         mPlayControlBar.SetPlayingSpeedX (GetPlayingSpeedX () + delta);

         return true;
      }

      public function PlaySlower (delta:uint):Boolean
      {
         if (mPlayControlBar == null)
            return true;

         mPlayControlBar.SetPlayingSpeedX (GetPlayingSpeedX () - delta);

          return GetPlayingSpeedX () > 0;
      }

      private var _OnSpeed:Function = null;
      public function SetOnSpeedChangedFunction (onSpeed:Function):void
      {
         _OnSpeed = onSpeed;
      }

      private var _onPlayStatusChanged:Function = null;
      public function SetOnPlayStatusChangedFunction (onPlayStatusChanged:Function):void
      {
         _onPlayStatusChanged = onPlayStatusChanged;
      }

   }
}
