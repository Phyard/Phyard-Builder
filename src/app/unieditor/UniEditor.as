package unieditor
{
   import flash.display.StageScaleMode;
   import flash.display.StageAlign;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
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
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   
   public dynamic class UniEditor extends Sprite
   {
      private static const VersionNumber:int = 1;
      
      private static const StartLoadingPercent:int = 5;
      private static const StartLoadingBuilderPercent:int = 5;
      private static const EndLoadingBuilderPercent:int = 100;
      
   //================================================
   //   
   //================================================
      
      public function UniEditor ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage)
      }
      
      private var mUniEditorUrl:String;
      private function OnAddedToStage (e:Event):void
      {
         //stage.scaleMode = StageScaleMode.SHOW_ALL;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         
         //
         SetInfoText ("Loading ... (" + StartLoadingPercent + "%)");
         
         // init
         
         mUniEditorUrl =  LoaderInfo(this.loaderInfo).url;
         
         // real editor
         
         var index:int = mUniEditorUrl.indexOf ("/unieditor.swf");
            
         if (index < 0)
         {
            SetInfoText ("Invalid url: " + mUniEditorUrl);
            return;
         }
         
         var builderFileKey:String = "builder=";
         var index2:int = mUniEditorUrl.indexOf (builderFileKey);
         if (index2 < 0)
         {
            SetInfoText ("Unknown editor file");
            return;
         }
         index2 += builderFileKey.length;
         if (index2 >= mUniEditorUrl.length)
         {
            SetInfoText ("Unknown editor file");
            return;
         }
         
         var index3:int = mUniEditorUrl.indexOf ("&", index2);
         if (index3 < 0)
            index3 = mUniEditorUrl.length;
         
         var realEditorSwfUrl:String = mUniEditorUrl.substring (index2, index3);
         
         if (realEditorSwfUrl.indexOf ("://") < 0)
         {
            realEditorSwfUrl = mUniEditorUrl.substring (0, index) + "/swfs/" + realEditorSwfUrl;
         }
         
trace ("realEditorSwfUrl = " + realEditorSwfUrl);
          
         var request:URLRequest = new URLRequest (realEditorSwfUrl);
         request.method = URLRequestMethod.GET;
         
         mRealEditorFileLoader = new Loader ();
            
         mRealEditorFileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadBuilderSwfComplete);
         mRealEditorFileLoader.contentLoaderInfo.addEventListener(Event.INIT, OnLoadBuilderSwfInited);
         mRealEditorFileLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, OnLoadBuilderSwfProgress);
         mRealEditorFileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnLoadingError);
         mRealEditorFileLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
         
         mLoadingStage = " real editor ";
         mRealEditorFileLoader.load(request, new LoaderContext(false, ApplicationDomain.currentDomain));
         
         //
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
      }
      
      private var mRealEditorFileLoader:Loader = null;
      
      private function OnLoadBuilderSwfComplete (event:Event):void 
      {
         SetInfoText ("Initializing ...");
         
         addChild (mRealEditorFileLoader);
      }
      
      private function OnLoadBuilderSwfInited(event:Event):void 
      {
         SetInfoText (null);
      }
      
      private function OnLoadBuilderSwfProgress (event:ProgressEvent):void
      {
         SetInfoText ("Loading ... (" + int (StartLoadingBuilderPercent + (EndLoadingBuilderPercent - StartLoadingBuilderPercent) * event.bytesLoaded / event.bytesTotal) + "%)");
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
            //mInfoTextField.x = 0.5 * (App::Default_Width - mInfoTextField.width);
            //mInfoTextField.y = 0.5 * (App::Default_Height - mInfoTextField.height);
            mInfoTextField.x = 0.5 * (stage.stageWidth - mInfoTextField.width);
            mInfoTextField.y = 0.5 * (stage.stageHeight - mInfoTextField.height);
         }
      }
   }
}
