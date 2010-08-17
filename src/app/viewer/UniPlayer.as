package viewer
{
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import flash.display.Sprite;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
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
       - action=[play | view]
       - app=ci
       - version=[0x0152 | ...]
       - author=
       - slot=
       - revision=
    
    2. Load Design Info (/design/loadinfo?action=XXX&author=xxx&slot=xx&revision=XX&list=XX&)
       
       Paramters:
       - {all FlashVars}
       - time= (·ÀÖ¹ä¯ÀÀÆ÷»º³å)
       - other user pc info for statistics
       
       Return Info:
       - real player swf file path
       - design published revision (if action is play)
       - design latest revision (if action is view)
    
    3. Load Real Player
    
    4. Load Design Data (/design/author/slot/revision/N/loadpc)
       
       (Before loading design data, check whether or not the data already exists in falsh cookie)
    
    5. Wait to play
       
    */
   
   public dynamic class Viewer extends Sprite
   {
      private static const VersionNumber:int = 0x0001;
   
   //================================================
   //   
   //================================================
      
      public function Viewer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage)
      }
      
      private function OnAddedToStage (e:Event):void 
      {
         addEventListener(Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         
         if (ParseFlashParams ())
         {
            LoadDesignInfo ();
         }
      }
      
      private function OnRemovedFromStage (e:Event):void 
      {
         removeEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
      }
      
      private function ErrorScreen (message:String):void
      {
         
      }
      
   //====================================================
   // parser flash vars
   //====================================================
      
      private var mUniplayerUrl:String;
      private var mWebSiteRootUrl:String;
      private var mPlayCode:String;
      
      private function ParseFlashParams ():Boolean
      {
         try 
         {
            var loadInfo:LoaderInfo = LoaderInfo(this.loaderInfo);
            
            if (loadInfo.loaderURL != null)
               throw new Error ("Must be a top swf");
            
            mUniplayerUrl = loaderInfo.url;
            
            if (mUniplayerUrl == null)
               throw new Error ("Url can't be null");
            
            mUniplayerUrl = mUniplayerUrl.toLowerCase ();
            
            var domainStart:int = mUniplayerUrl.indexOf("://");
            
            if (domainStart < 0)
               throw new Error ("Unknown url error");
            
            domainStart += 3;
            
            var domainEnd:int = mUniplayerUrl.indexOf("/", domainStart);
            if (domainEnd < 0)
               mWebSiteRootUrl = mUniplayerUrl + "/"
            else
               mWebSiteRootUrl = mUniplayerUrl.substring(0, domainEnd + 1);
            
            var flashVars:Object = loaderInfo.parameters;
            if (flashVars != null)
            {
               mPlayCode = flashVars.playcode;
            }
            
            return true;
         } 
         catch (error:Error) 
         {
            ErrorScreen (error.toString ());
         }
         
         return false;
      }
      
   //====================================================
   // load design info
   //====================================================
      
      public static const k_ReturnCode_Successed:int = 1;
      
      private function LoadDesignInfo ():void
      {
         var loadInfoUrl:String = mUniplayerUrl.replace (/\/uniplayer\//, "/loadinfo/") + "&amp;time=" + getTimer ();
         
         var request:URLRequest = new URLRequest (loadInfoUrl);
         request.method = URLRequestMethod.GET;
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener(Event.COMPLETE, OnLoadDesignInfoCompleted);
         loader.addEventListener(IOErrorEvent.IO_ERROR, OnLoadDesignInfoIoError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadDesignInfoSecurityError);
         
         loader.load ( request );
      }
      
      private function OnLoadDesignInfoCompleted (event:Event):void 
      {
         var loader:URLLoader = URLLoader(event.target);
         
         try
         {
            var data:ByteArray = ByteArray (loader.data);
            
            var returnCode:int = data.readByte ();
            
            if (returnCode != k_ReturnCode_Successed)
               throw new Error ("Load design info error: " + returnCode);
            
            var playerPath:String = data.readUTF ();
            if (playerPath.indexOf ("://") < 0)
               mRealPlayerPath = mWebSiteRootUrl + playerPath;
            else
               mRealPlayerPath = playerPath;
            
            LoadRealPlayer ();
         }
         catch (error:Error)
         {
            ErrorScreen (error.toString ());
         }
      }
      
      private function OnLoadDesignInfoIoError (event:IOErrorEvent):void 
      {
         ErrorScreen (event.text);
      }
      
       private function OnLoadDesignInfoSecurityError (event:SecurityErrorEvent):void
      {
         ErrorScreen (event.text);
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
         
         loader.load(request, loaderContext);
      }
      
      private function OnLoadPlayerComplete (event:Event):void
      {
         var paramsFromUniPlayer:Object = new Object ();
         paramsFromUniPlayer.loadWorldBinaryData;
         
         var PlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("wrapper.ColorInfectionPlayer") as Class;
         var player:Sprite = (new PlayerClass (false, null, paramsFromUniPlayer)) as Sprite;
         addChild (player);
      }
      
      private function OnLoadPlayerProgress (event:ProgressEvent):void
      {
         trace ("progress: " + (int (event.bytesLoaded * 100 / event.bytesTotal)) + "%");
      }
      
      private function OnLoadPlayerIoError (event:IOErrorEvent):void
      {
         ErrorScreen (event.text);
      }
      
      private function OnLoadPlayerSecurityError (event:SecurityErrorEvent):void
      {
         ErrorScreen (event.text);
      }
      
   //====================================================
   // load design data
   //====================================================
      
      private function LoadDesignData ():void
      {
         //
      }
      
   }
}
