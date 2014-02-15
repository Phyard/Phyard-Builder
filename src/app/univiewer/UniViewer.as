package univiewer
{
   import flash.display.StageScaleMode;
   import flash.display.StageAlign;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import flash.display.Sprite;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.geom.Point;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   import flash.external.ExternalInterface;

   public dynamic class UniViewer extends Sprite
   {
      private static const VersionNumber:int = 2;

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
         
         //Security.allowDomain("*");
      }

      private var mUniViewerUrl:String;
      private function OnAddedToStage (e:Event):void
      {
         //stage.scaleMode = StageScaleMode.SHOW_ALL;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.addEventListener(Event.RESIZE, OnResize);

         //
         SetInfoText ("Loading ... (" + StartLoadingPercent + "%)");
         
         //>> websockets
         if (ExternalInterface.available)
         {
             try
             {
                ExternalInterface.addCallback("call", ContainerCallEmbed);
             }
             catch (error:Error)
             {
             }
         }
         //<<

         // init

         mUniViewerUrl =  LoaderInfo(this.loaderInfo).url;

         const ViewerFileEquals:String = "ViewerFile=";
         const RevisionIdEquals:String = "RevisionId=";
         const WorldFileEquals:String = "WorldFile=";
         var index1:int = mUniViewerUrl.indexOf (ViewerFileEquals);
         var index2:int = mUniViewerUrl.indexOf (RevisionIdEquals);
         var index3:int = mUniViewerUrl.indexOf (WorldFileEquals);
         if (index1 >= 0 && index2 >= 0 && index3 >= 0)
         {
            var indexEnd:int;

            index1 += ViewerFileEquals.length;
            indexEnd = mUniViewerUrl.indexOf ("&", index1);
            if (indexEnd < 0) indexEnd = mUniViewerUrl.length;
            var viewerFile:String = mUniViewerUrl.substring (index1, indexEnd);

            index2 += RevisionIdEquals.length;
            indexEnd = mUniViewerUrl.indexOf ("&", index2);
            if (indexEnd < 0) indexEnd = mUniViewerUrl.length;
            var revisionId:String = mUniViewerUrl.substring (index2, indexEnd);

            index3 += WorldFileEquals.length;
            indexEnd = mUniViewerUrl.indexOf ("&", index3);
            if (indexEnd < 0) indexEnd = mUniViewerUrl.length;
            var worldFile:String = mUniViewerUrl.substring (index3, indexEnd);

            var stream:ByteArray = new ByteArray ();
            stream.writeUTF (viewerFile);
            stream.writeInt (parseInt (revisionId));
            stream.writeUTF (worldFile);
            stream.position = 0;
            SetDesignInfoStream (stream);
         }
         else
         {
            // load design info

            var infoUrl:String;
            if (mUniViewerUrl.indexOf ("/uniplayer.swf") >= 0) // for play. avoid using browser cache
            {
               var date:Date = new Date ();
               infoUrl = mUniViewerUrl.replace (/\/uniplayer\.swf/, "/api/design/loadinfo") + "&vn=" + VersionNumber;
               infoUrl = infoUrl + "&time=" + date.getFullYear () + "-" + date.getMonth () + "-" + date.getDate () + "-" + date.getHours () + "-" + date.getMinutes () + "-" + date.getSeconds ();
            }
            else // for view, the brower cache will be used if availabe
            {
               infoUrl = mUniViewerUrl.replace (/\/swfs\/univiewer.*\.swf/, "/api/design/loadinfo") + "&vn=" + VersionNumber;
            }

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

         //
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
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

         SetDesignInfoStream (stream);
      }

      private function SetDesignInfoStream (stream:ByteArray):void
      {
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

         loader.contentLoaderInfo.addEventListener (Event.COMPLETE, OnLoadViewerSwfComplete);
         loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, OnLoadViewerSwfProgress);
         loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, OnLoadingError);
         loader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);

         mLoadingStage = " viewer ";
         loader.load (request, new LoaderContext(false, ApplicationDomain.currentDomain));
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
         paramsFromUniViewer.GetViewportSize = GetViewportSize;
         paramsFromUniViewer.mBackgroundColor = 0xDDDDA0;
         
         //>> websockets
         paramsFromUniViewer.EmbedCallContainer = EmbedCallContainer;
         //<<

         var viewer:Sprite = (MainClass.Call as Function) ("NewViewer", {mParamsFromUniViewer: paramsFromUniViewer}) as Sprite;
         viewer.alpha = 0.0;
         addChild (viewer);

         mViewer = viewer;
      }

      private var mViewer:Object = null;

      private function GetViewportSize ():Point
      {
         //return new Point (App::Default_Width, App::Default_Height);
         return new Point (stage.stageWidth, stage.stageHeight);
      }

      private function OnResize (event:Event):void
      {
         if (mViewer != null && mViewer.hasOwnProperty ("OnContainerResized"))
         {
            mViewer.OnContainerResized ();
         }
         
         UpdateInfoTextPosition ();
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
            
            UpdateInfoTextPosition ();
         }
      }
      
      private function UpdateInfoTextPosition ():void
      {
         if (mInfoTextField != null)
         {
            //mInfoTextField.x = 0.5 * (App::Default_Width - mInfoTextField.width);
            //mInfoTextField.y = 0.5 * (App::Default_Height - mInfoTextField.height);
            mInfoTextField.x = 0.5 * (stage.stageWidth - mInfoTextField.width);
            mInfoTextField.y = 0.5 * (stage.stageHeight - mInfoTextField.height);
         }
      }
      
   // for multiple players
      
      // don't change this name, 
      public function ContainerCallEmbed (funcName:String, params:Object):void
      {
         if (mViewer != null)
         {
            mViewer.ContainerCallEmbed (funcName, params);
         }
      }
      
      // don't change this name, 
      public function EmbedCallContainer (funcName:String, params:Object):void
      {
         if (ExternalInterface.available)
         {
             try
             {
                ExternalInterface.call(funcName, params);
             }
             catch (error:Error)
             {
             }
         }
      }
   }
}
