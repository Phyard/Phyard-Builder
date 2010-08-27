package univiewer
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.display.Sprite;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   public dynamic class UniViewer extends Sprite
   {
      private static const VersionNumber:int = 0x0001;
      
      private static const TotalStartLoadingPercent:int = 3;
      private static const TotalInfoLoadingPercent:int = 10;
      private static const TotalViewerLoadingPercent:int = 36;
      private static const TotalWorldLoadingPercent:int = 76;
      private static const TotalDataLoadingPercent:int = 100;
      
      public static const k_ReturnCode_Successed:int = 1;
      
   //================================================
   //   
   //================================================
      
      public function UniViewer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage)
      }
      
      private var mUniViewerUrl:String;
      private function OnAddedToStage (e:Event):void 
      {
         // init
         
         mUniViewerUrl =  LoaderInfo(this.loaderInfo).url;
         
         // ...
         
         mStartLoadingProgress = TotalStartLoadingPercent;
         mEndLoadingProgress = TotalInfoLoadingPercent;
         UpdateLoadingProgress (0, 0);
         
         // load design info
         
         var infoUrl:String;
         if (mUniViewerUrl.indexOf ("/uniplayer.swf") >= 0) // for play. avoid using browser cache
         {
            var date:Date = new Date ();
            infoUrl = mUniViewerUrl.replace (/\/uniplayer\.swf/, "/i/design/loadinfo") + "&vn=" + VersionNumber;
            infoUrl = infoUrl + "&time=" + date.getFullYear () + "-" + date.getMonth () + "-" + date.getDate () + "-" + date.getHours () + "-" + date.getMinutes () + "-" + date.getSeconds ();
         }
         else // for view, the brower cache will be used if availabe
         {
            infoUrl = mUniViewerUrl.replace (/\/swfs\/univiewer.*\.swf/, "/i/design/loadinfo") + "&vn=" + VersionNumber;
         }
         
         CreateNewLoading (infoUrl, "Loading design info", null, OnLoadInfoComplete, UpdateLoadingProgress, UpdateInfoText);
      }
      
      private var mRealRevision:int;
      private var mViewerSwfUrl:String;
      private var mWorldSwfUrl:String
      private function OnLoadInfoComplete (loader:URLLoader):void 
      {
         mStartLoadingProgress = TotalInfoLoadingPercent;
         mEndLoadingProgress = TotalViewerLoadingPercent;
         UpdateLoadingProgress (0, 0);
         
         try
         {
            var loader:URLLoader = URLLoader(loader);
            var stream:ByteArray = ByteArray (loader.data);
            
            var returnCode:int = stream.readByte ();
            
            if (returnCode != k_ReturnCode_Successed)
               throw new Error ("code = " + returnCode);
            
            // design revision
            mRealRevision = stream.readInt ();
            
            // world.swf url and viewer swf url
            var worldSwfUrl:String = stream.readUTF ();
            var viewerSwfUrl:String = stream.readUTF ();
            if (worldSwfUrl.indexOf ("://") >= 0)
            {
               mWorldSwfUrl = worldSwfUrl;
               mViewerSwfUrl = viewerSwfUrl;
            }
            else 
            {
               var index:int = mUniViewerUrl.indexOf ("/uniplayer.swf");
               if (index < 0)
                  index = mUniViewerUrl.indexOf ("/swfs/univiewer.swf");
               
               if (index < 0)
                  throw new Error ("index < 0");
               
               mWorldSwfUrl = mUniViewerUrl.substring (0, index) + "/swfs/" + worldSwfUrl;
               mViewerSwfUrl = mUniViewerUrl.substring (0, index) + "/swfs/" + viewerSwfUrl;
            }
            
            CreateNewLoading (mViewerSwfUrl, "Loading viewer", "viewer", OnLoadViewerSwfComplete, UpdateLoadingProgress, UpdateInfoText);
         }
         catch (error:Error)
         {
            UpdateInfoText ("Loading info error:" + error.message);
         }
      }
      
      private function OnLoadViewerSwfComplete (loaderInfo:LoaderInfo):void 
      {
         mStartLoadingProgress = TotalViewerLoadingPercent;
         mEndLoadingProgress = TotalWorldLoadingPercent;
         UpdateLoadingProgress (0, 0);
         
         CreateNewLoading (mWorldSwfUrl, "Loading world", "world", OnLoadWorldSwfComplete, UpdateLoadingProgress, UpdateInfoText);
      }
      
      private function OnLoadWorldSwfComplete (loaderInfo:LoaderInfo):void 
      {
         mStartLoadingProgress = TotalWorldLoadingPercent;
         mEndLoadingProgress = TotalDataLoadingPercent;
         UpdateLoadingProgress (0, 0);
         
         try
         {
            if (mUniViewerUrl.indexOf ("format=") < 0)
            {
               var dataUrl:String;
               if (mUniViewerUrl.indexOf ("/uniplayer.swf") >= 0)  // for play, add the return published revison id
               {
                  dataUrl = mUniViewerUrl.replace (/\/uniplayer\.swf/, "/i/design/loaddata");
                  dataUrl = dataUrl + "&revision=" + mRealRevision;
               }
               else // for view, the revision should be already caontained in mUniViewerUrl
               {
                  dataUrl = mUniViewerUrl.replace (/\/swfs\/univiewer.*\.swf/, "/i/design/loaddata");
                  dataUrl = dataUrl + "&view=1"; // indication for view
               }
               
               CreateNewLoading (dataUrl, "Loading design data", null, OnLoadDataComplete, UpdateLoadingProgress, UpdateInfoText);
            }
            else
            {
               OnLoadDataComplete (null);
            }
         }
         catch (error:Error)
         {
            UpdateInfoText ("Loading error:" + error.message);
         }
      }
      
      private function OnLoadDataComplete (loader:URLLoader):void 
      {
         mStartLoadingProgress = TotalDataLoadingPercent;
         mEndLoadingProgress = TotalDataLoadingPercent;
         UpdateLoadingProgress (0, 0);
         
         try
         {
            UpdateInfoText (null);
            
            var designBinaryData:ByteArray = null;
            if (loader != null)
            {
               var loader:URLLoader = URLLoader(loader);
               var data:ByteArray = ByteArray (loader.data);
               
               var returnCode:int = data.readByte ();
               
               if (returnCode != k_ReturnCode_Successed)
                  throw new Error ("code = " + returnCode)
               
               var designDataForPlaying:ByteArray = new ByteArray ();
               data.readBytes (designDataForPlaying);
               designDataForPlaying.uncompress ();
               
               designBinaryData = designDataForPlaying;
            }
            
            // all loadings are done
            
            var ViewerClass:Class = mApplicationDomains ["viewer"].getDefinition("viewer.Viewer") as Class;
            if (ViewerClass == null)
            {
               throw new Error ("viewer class not found");
            }
            var WorldDomain:ApplicationDomain = mApplicationDomains ["world"] as ApplicationDomain;
            if (WorldDomain == null)
            {
               throw new Error ("world domain not found");
            }
            
            var paramsFromUniPlayer:Object = new Object ();
            
            paramsFromUniPlayer.CreateNewLoadingFunction = CreateNewLoading;
            paramsFromUniPlayer.mUniViewerUrl = mUniViewerUrl;
            paramsFromUniPlayer.mWorldDomain = WorldDomain;
            paramsFromUniPlayer.mDesignBinaryData = designBinaryData;
            paramsFromUniPlayer.mWorldPlayCode = LoaderInfo(this.loaderInfo).parameters.playcode;
            paramsFromUniPlayer.mFlashVars = LoaderInfo(this.loaderInfo).parameters;
            
            var viewer:Sprite = (new ViewerClass ({mParamsFromUniViewer: paramsFromUniPlayer})) as Sprite;
            addChild (viewer);
         }
         catch (error:Error)
         {
         throw error;
            UpdateInfoText ("Loading error: " + error.message);
         }
      }
      
   //================================================
   //   
   //================================================
      
      private var mLoadingThreadInfos:Dictionary = new Dictionary ();
      private var mApplicationDomains:Dictionary = new Dictionary ();
      
      // only support GET method
      private function CreateNewLoading (url:String, loadingName:String, appDomainName:String, onCompete:Function, onProgress:Function = null, onError:Function = null, reservedParams:Object = null):void
      {
         var message:String;
         
         try
         {
            var request:URLRequest = new URLRequest (url);
            request.method = URLRequestMethod.GET;
            
            var loader:Object;
            var listenersOwner:Object;
            
            if (appDomainName == null)
            {
               loader = new URLLoader ();
               loader.dataFormat = URLLoaderDataFormat.BINARY;
               
               listenersOwner = loader;
            }
            else
            {
               loader = new Loader ();
               
               listenersOwner = loader.contentLoaderInfo;
               
               var appDomain:ApplicationDomain = mApplicationDomains [appDomainName];
               if (appDomain == null)
               {
                  appDomain = new ApplicationDomain ();
                  mApplicationDomains [appDomainName] = appDomain;
               }
               
               var loaderContext:LoaderContext = new LoaderContext(false, appDomain);
            }
            
            listenersOwner.addEventListener(Event.COMPLETE, OnLoadingComplete);
            listenersOwner.addEventListener(ProgressEvent.PROGRESS, OnLoadingProgress);
            listenersOwner.addEventListener(IOErrorEvent.IO_ERROR, OnLoadingError);
            listenersOwner.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
            
            message = "Start loading (" + loadingName + ", " + url + ") ...";
            trace (message);
            
            if (loader is URLLoader)
               loader.load(request);
            else
               loader.load(request, loaderContext);
         }
         catch (error:Error)
         {
            message = "Create loading thread error (" + loadingName + ", " + url + ") :" + error.message;
            trace (message);
            if (onError != null) onError (message);
            
            return;
         }
         
         mLoadingThreadInfos [listenersOwner] = {mUrl: url, mLoadingName: loadingName, OnCompete: onCompete, OnProgress: onProgress, OnError: onError};
      }
      
      private function OnLoadingComplete (event:Event):void
      {
      trace ("+++++++++++++++++++++++");
         var listenerOwner:Object = event.currentTarget;
         var threadInfo:Object = mLoadingThreadInfos [listenerOwner];
         if (threadInfo == null)
            return;
         
         delete mLoadingThreadInfos [listenerOwner];
         
         var message:String = "Loading compete (" + threadInfo.mLoadingName + ", " + threadInfo.mUrl + ").";
         trace (message);
         
         if (threadInfo.OnCompete == null)
            return;
         
         threadInfo.OnCompete (listenerOwner);
      }
      
      private function OnLoadingProgress (event:ProgressEvent):void
      {
         var listenerOwner:Object = event.currentTarget;
         var threadInfo:Object = mLoadingThreadInfos [listenerOwner];
         if (threadInfo == null)
            return;
         
         //var message:String = "Loading progress (" + threadInfo.mLoadingName + ", " + threadInfo.mUrl + "): " + event.bytesTotal + "/" + event.bytesTotal;
         //trace (message);
         
         if (threadInfo.OnProgress == null)
            return;
         
         threadInfo.OnProgress (event.bytesTotal, event.bytesLoaded);
      }
      
      private function OnLoadingError (event:Object):void
      {
         var listenerOwner:Object = event.currentTarget;
         var threadInfo:Object = mLoadingThreadInfos [listenerOwner];
         if (threadInfo == null)
            return;
         
         delete mLoadingThreadInfos [listenerOwner];
         
         var message:String = "Loading error (" + threadInfo.mLoadingName + ", " + threadInfo.mUrl + "): " + event.text;
         trace (message);
         
         if (threadInfo.OnError == null)
            return;
         
         threadInfo.OnError ("Loading error: " + event.text);
      }
      
   //================================================
   //   
   //================================================
      
      private var loadingText:TextField = null;
      private function UpdateInfoText (infoText:String):void
      {
         if (loadingText == null)
         {
            loadingText = new TextField ();
            loadingText.textColor = 0x0;
            loadingText.background = false;
            loadingText.border = false;
            loadingText.wordWrap = false;
            loadingText.selectable = false;
            loadingText.autoSize = TextFieldAutoSize.LEFT;
            
            addChild (loadingText);
         }
         
         if (infoText == null)
         {
            loadingText.visible = false;
            loadingText.htmlText = "";
         }
         else
         {
            loadingText.visible = true;
            loadingText.x = 0.5 * (App::Default_Width - loadingText.width);
            loadingText.y = 0.5 * (App::Default_Height - loadingText.height);
            
            trace ("loadingText.x = " + loadingText.x + ", loadingText.y = " + loadingText.y + ", infoText = " + infoText);
         }
      }
      
      private var mStartLoadingProgress:int;
      private var mEndLoadingProgress:int;
      private function UpdateLoadingProgress (bytesTotal:int, bytesLoaded:int):void
      {
         UpdateInfoText ("Loading ... (" + (mStartLoadingProgress + (bytesTotal == 0 ? 0 : ((mEndLoadingProgress - mStartLoadingProgress) * bytesLoaded / bytesTotal))) + "%)");
      }
   }
}
