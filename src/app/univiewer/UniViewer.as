package univiewer
{
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import flash.display.Sprite;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.system.ApplicationDomain;
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
      private static const VersionNumber:int = 2;
      //private static const VersionNumber:int = 3;
      
      private static const StartLoadingPercent:int = 5;
      private static const StartLoadingViewerPercent:int = 5;
      private static const EndLoadingViewerPercent:int = 18;
      
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
         //
         SetInfoText ("Loading ... (" + StartLoadingPercent + "%)");
         
         // init
         
         mUniViewerUrl =  LoaderInfo(this.loaderInfo).url;
         
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
         
         //var infoUrl:String;
         //if (mUniViewerUrl.indexOf ("/uniplayer.swf") >= 0) // for play. avoid using browser cache
         //{
         //   var date:Date = new Date ();
         //   infoUrl = mUniViewerUrl.replace (/\/uniplayer\.swf/, "/api/design/loadinfo") + "&vn=" + VersionNumber;
         //   infoUrl = infoUrl + "&time=" + date.getFullYear () + "-" + date.getMonth () + "-" + date.getDate () + "-" + date.getHours () + "-" + date.getMinutes () + "-" + date.getSeconds ();
         //}
         //else // for view, the brower cache will be used if availabe
         //{
         //   infoUrl = mUniViewerUrl.replace (/\/swfs\/univiewer.*\.swf/, "/api/design/loadinfo") + "&vn=" + VersionNumber;
         //}
         
         var request:URLRequest = new URLRequest (infoUrl);
         request.method = URLRequestMethod.GET;
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener(Event.COMPLETE, OnLoadInfoComplete);
         loader.addEventListener(IOErrorEvent.IO_ERROR, OnLoadingError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
         
         mLoadingStage = " info ";
         loader.load(request);
      }
      
      private var mDesignInfoStream:ByteArray;
      private function OnLoadInfoComplete (event:Event):void 
      {
         SetInfoText ("Loading ... (" + StartLoadingViewerPercent + "%)");
         
         var stream:ByteArray = ByteArray ((event.target as URLLoader).data);
         
         var returnCode:int = stream.readByte ();
         
         if (returnCode != k_ReturnCode_Successed)
         {
            SetInfoText ("Loading error! code = " + returnCode);
            return;
         }
         
         mDesignInfoStream = stream;
         
         // world.swf url and viewer swf url
         var viewerSwfUrl:String = stream.readUTF ();
         if (viewerSwfUrl.indexOf ("://") < 0)
         {
            var index:int = mUniViewerUrl.indexOf ("/uniplayer.swf");
            if (index < 0)
               index = mUniViewerUrl.indexOf ("/swfs/univiewer");
            
            if (index < 0)
            {
               SetInfoText ("Invalid url: " + mUniViewerUrl);
               return;
            }
            
            viewerSwfUrl = mUniViewerUrl.substring (0, index) + "/swfs/" + viewerSwfUrl;
         }
            
         var request:URLRequest = new URLRequest (viewerSwfUrl);
         request.method = URLRequestMethod.GET;
         
         var loader:Loader = new Loader ();
            
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadViewerSwfComplete);
         loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, OnLoadViewerSwfProgress);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnLoadingError);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
         
         mLoadingStage = " viewer ";
         loader.load(request, new LoaderContext(false, ApplicationDomain.currentDomain));
      }
      
      private function OnLoadViewerSwfComplete (event:Event):void 
      {
         //SetInfoText (null);
         
         var MainClass:Object = ApplicationDomain.currentDomain.getDefinition("Main") as Class;
         if (MainClass == null)
         {
            SetInfoText ("Loading error! No main entry");
            return;
         }
         
         var paramsFromUniViewer:Object = new Object ();
         
         paramsFromUniViewer.mUniViewerUrl = mUniViewerUrl;
         paramsFromUniViewer.mDesignInfoStream = mDesignInfoStream;
         paramsFromUniViewer.mFlashVars = LoaderInfo(this.loaderInfo).parameters;
         paramsFromUniViewer.mLoadingProgress = EndLoadingViewerPercent;
         paramsFromUniViewer.SetLoadingText = SetInfoText;
         
         var viewer:Sprite = (MainClass.Call as Function) ("NewViewer", {mParamsFromUniViewer: paramsFromUniViewer}) as Sprite;
         viewer.alpha = 0.0;
         addChild (viewer);
      }
      
      private function OnLoadViewerSwfProgress (event:ProgressEvent):void
      {
         SetInfoText ("Loading ... (" + int (StartLoadingViewerPercent + (EndLoadingViewerPercent - StartLoadingViewerPercent) * event.bytesLoaded / event.bytesTotal) + "%)");
      }
      
      private var mLoadingStage:String = " ";
      private function OnLoadingError (event:Object):void
      {
         SetInfoText ("Loading" + mLoadingStage + "error!");
      }
      
      private var mInfoTextField:TextField = null;
      private function SetInfoText (infoText:String):void
      {
      //trace ("infoText = " + infoText);
         if (mInfoTextField == null)
         {
            mInfoTextField = new TextField ();
            mInfoTextField.textColor = 0x0;
            mInfoTextField.background = false;
            mInfoTextField.border = false;
            mInfoTextField.wordWrap = false;
            mInfoTextField.selectable = false;
            mInfoTextField.autoSize = TextFieldAutoSize.LEFT;
            
            addChild (mInfoTextField);
         }
         
         if (infoText == null)
         {
            mInfoTextField.visible = false;
            mInfoTextField.htmlText = "";
         }
         else
         {
            mInfoTextField.visible = true;
            mInfoTextField.htmlText = infoText;
            mInfoTextField.x = 0.5 * (App::Default_Width - mInfoTextField.width);
            mInfoTextField.y = 0.5 * (App::Default_Height - mInfoTextField.height);
         }
      }
   }
}
