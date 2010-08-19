package uniplayer
{
   import flash.utils.ByteArray;
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
   
   /**
    1. Load viewer.swf (force loading, to get the page referer url)
       
       FlashVars:
       - app=ci
       - format=[0x0152 | ...]
       - author=
       - slot=
    
    2. Load Design Info (/design/loadinfo?action=XXX&author=xxx&slot=xx&revision=XX&list=XX&)
       
       Paramters:
       - {all FlashVars}
       - vn=VersionNumber
       - timer= (·ÀÖ¹ä¯ÀÀÆ÷»º³å)
       - other user pc info for statistics
       
       Return Info:
       - published revision id
       - real player swf file path
    
    3. Load Real Player
    
    4. Load Design Data (/design/author/slot/revision/N/loadpc)
       
       (Before loading design data, check whether or not the data already exists in falsh cookie)
    
    5. Wait to play
       
    */
   
   public dynamic class UniPlayer extends Sprite
   {
      private static const VersionNumber:int = 0x0001;
   
   //================================================
   //   
   //================================================
      
      public function UniPlayer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage)
      }
      
      private function OnAddedToStage (e:Event):void 
      {
         addEventListener(Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         
         if (ParseFlashParams ())
         {
            Loading (5);
            LoadDesignInfo ();
         }
      }
      
      private function OnRemovedFromStage (e:Event):void 
      {
         removeEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
      }
      
      private var loadingText:TextField = null;
      private function UpdateInfoText (infoText:String):void
      {
         if (loadingText == null)
         {
            loadingText = CreateText ();
            addChild (loadingText);
         }
         
         loadingText.htmlText = infoText;
         loadingText.x = 0.5 * (App::Default_Width - loadingText.width);
         loadingText.y = 0.5 * (App::Default_Height - loadingText.height);
      }
      
      private function Loading (percent:int):void
      {
         UpdateInfoText ("Loading ... (" + percent + "%)");
      }
      
      private function ErrorLoading (message:String):void
      {
         trace ("--- Error: " + message);
         trace (new Error ().getStackTrace ());
         
         UpdateInfoText ("Error loading");
      }
      
      private function CreateText ():TextField
      {
         var textField:TextField = new TextField ();
         textField.textColor = 0x0;
         textField.background = false;
         textField.border = false;
         textField.wordWrap = false;
         textField.selectable = false;
         textField.autoSize = TextFieldAutoSize.LEFT;
         
         return textField;
      }
      
   //====================================================
   // parser flash vars
   //====================================================
      
      private var mUniplayerUrl:String;
      
      private function ParseFlashParams ():Boolean
      {
         try 
         {
            var loadInfo:LoaderInfo = LoaderInfo(this.loaderInfo);
            
            mUniplayerUrl = loaderInfo.url;
            
            var flashVars:Object = loaderInfo.parameters;
            if (flashVars != null)
            {
               mPlayCode = flashVars.playcode;
            }
            
            return true;
         } 
         catch (error:Error) 
         {
            ErrorLoading (error.message);
         }
         
         return false;
      }
      
   //====================================================
   // load design info
   //====================================================
      
      public static const k_ReturnCode_Successed:int = 1;
      
      private function LoadDesignInfo ():void
      {
         var date:Date = new Date ();
         var loadInfoUrl:String = mUniplayerUrl.replace (/\/uniplayer.swf/, "/i/design/loadinfo") + "&vn=" + VersionNumber + "&time=" 
                                                         + date.getFullYear () + "-" + date.getMonth () + "-" + date.getDate () + "-"
                                                         + date.getHours () + "-" + date.getMinutes () + "-" + date.getSeconds ();
         
         var request:URLRequest = new URLRequest (loadInfoUrl);
         request.method = URLRequestMethod.GET;
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener(Event.COMPLETE, OnLoadDesignInfoCompleted);
         loader.addEventListener(IOErrorEvent.IO_ERROR, OnLoadDesignInfoIoError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadDesignInfoSecurityError);
         
      trace ("1> start loading design info ... " + loadInfoUrl);
         loader.load ( request );
      }
      
      private function OnLoadDesignInfoCompleted (event:Event):void 
      {
         Loading (10);
         
         var loader:URLLoader = URLLoader(event.target);
         
         try
         {
            var stream:ByteArray = ByteArray (loader.data);
            
            var returnCode:int = stream.readByte ();
            
            if (returnCode != k_ReturnCode_Successed)
               throw new Error ("Load design info error: " + returnCode);
            
            mRealRevision = stream.readInt ();
            
            var playerFilename:String = stream.readUTF ();
            if (playerFilename.indexOf ("://") >= 0)
               mRealPlayerPath = playerFilename;
            else
            {
               var index:int = mUniplayerUrl.indexOf ("/uniplayer.swf");
               mRealPlayerPath = mUniplayerUrl.substring (0, index) + "/swfs/" + playerFilename;
            }
            
      trace ("   loading design info done");
            if (mUniplayerUrl.indexOf ("format=") < 0)
            {
               LoadDesignData ();
            }
            else
               LoadRealPlayer ();
         }
         catch (error:Error)
         {
            ErrorLoading (error.message);
         }
      }
      
      private function OnLoadDesignInfoIoError (event:IOErrorEvent):void 
      {
         ErrorLoading (event.text);
      }
      
       private function OnLoadDesignInfoSecurityError (event:SecurityErrorEvent):void
      {
         ErrorLoading (event.text);
      }
      
   //====================================================
   // load design data
   //====================================================
      
      private var mPlayCode:String = null;
      
      private var mRealRevision:int;
      
      private var mBinaryData:ByteArray = null;
      
      private function LoadDesignData ():void
      {
         var loadDataUrl:String = mUniplayerUrl.replace (/\/uniplayer.swf/, "/i/design/loaddata") + "&revision=" + mRealRevision;
         
         var request:URLRequest = new URLRequest (loadDataUrl);
         request.method = URLRequestMethod.GET;
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener(Event.COMPLETE, OnLoadDesignDataCompleted);
         loader.addEventListener(ProgressEvent.PROGRESS, OnLoadDesignDataProgress);
         loader.addEventListener(IOErrorEvent.IO_ERROR, OnLoadDesignDataIoError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadDesignDataSecurityError);
         
      trace ("2> start loading data ... " + loadDataUrl);
         loader.load ( request );
      }
      
      private function OnLoadDesignDataCompleted(event:Event):void 
      {
         var loader:URLLoader = URLLoader(event.target);
         
         try
         {
            var data:ByteArray = ByteArray (loader.data);
            
            var returnCode:int = data.readByte ();
            
            if (returnCode != k_ReturnCode_Successed)
               throw new Error ("Load design data error: " + returnCode)
            
            var designDataForPlaying:ByteArray = new ByteArray ();
            data.readBytes (designDataForPlaying);
            designDataForPlaying.uncompress ();
            
            mBinaryData = designDataForPlaying;
            
      trace ("   loading design data done");
            LoadRealPlayer ();
         }
         catch (error:Error)
         {
            ErrorLoading (error.message);
         }
      }
      
      private function OnLoadDesignDataProgress (event:ProgressEvent):void
      {
         Loading (int(10 + 20.0 * event.bytesLoaded / event.bytesTotal));
         //trace ("----- progress: " + (int (event.bytesLoaded * 100 / event.bytesTotal)) + "%");
      }
      
      private function OnLoadDesignDataIoError (event:IOErrorEvent):void 
      {
         ErrorLoading (event.text);
      }
      
       private function OnLoadDesignDataSecurityError (event:SecurityErrorEvent):void
      {
         ErrorLoading (event.text);
      }
      
   //====================================================
   // load player
   //====================================================
      
      private var mRealPlayerPath:String;
      
      private function LoadRealPlayer ():void
      {
         var loader:Loader = new Loader();
         var request:URLRequest = new URLRequest(mRealPlayerPath);
         
         var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadPlayerComplete);
         loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, OnLoadPlayerProgress);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnLoadPlayerIoError);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadPlayerSecurityError);
         
      trace ("3> start loading player ... " + mRealPlayerPath);
         loader.load(request, loaderContext);
      }
      
      private function OnLoadPlayerComplete (event:Event):void
      {
         try
         {
            var paramsFromUniPlayer:Object = new Object ();
            paramsFromUniPlayer.mWorldBinaryData = mBinaryData;
            paramsFromUniPlayer.mWorldPlayCode = mPlayCode;
            paramsFromUniPlayer.mUniplayerUrl = mUniplayerUrl;
            
         trace ("   loading design player done.");
            var PlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("wrapper.ColorInfectionPlayer") as Class;
            if (PlayerClass == null)
            {
               throw new Error ("No class def");
            }
            
            var player:Sprite = (new PlayerClass (false, null, paramsFromUniPlayer)) as Sprite;
            addChild (player);
         }
         catch (error:Error)
         {
            ErrorLoading (error.message);
         }
      }
      
      private function OnLoadPlayerProgress (event:ProgressEvent):void
      {
         Loading (int(30 + 70.0 * event.bytesLoaded / event.bytesTotal));
         //trace ("----- progress: " + (int (event.bytesLoaded * 100 / event.bytesTotal)) + "%");
      }
      
      private function OnLoadPlayerIoError (event:IOErrorEvent):void
      {
         ErrorLoading (event.text);
      }
      
      private function OnLoadPlayerSecurityError (event:SecurityErrorEvent):void
      {
         ErrorLoading (event.text);
      }
      
   }
}
