package unieditor
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
   
   public dynamic class UniEditor extends Sprite
   {
      private static const VersionNumber:int = 1;
      
      private static const StartLoadingPercent:int = 5;
      private static const StartLoadingBuilderPercent:int = 5;
      private static const EndLoadingBuilderPercent = 86;
      
   //================================================
   //   
   //================================================
      
      public function UniViewer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage)
      }
      
      private var mUniEditorUrl:String;
      private function OnAddedToStage (e:Event):void 
      {
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
         
         var index2:int = mUniEditorUrl.indexOf ("builder=");
         if (index2 < 0)
         {
            SetInfoText ("Unknown editor file");
            return;
         }
         
         var index3:int = mUniEditorUrl.indexOf ("&", index2 + 1);
         if (index3 < 0)
            index3 = mUniEditorUrl.length;
            
         realEditorSwfUrl = mUniEditorUrl.substring (0, index) + "/swfs/" +  mUniEditorUrl.substring (index2, index3) + ".swf";
            
         var request:URLRequest = new URLRequest (realEditorSwfUrl);
         request.method = URLRequestMethod.GET;
         
         var loader:Loader = new Loader ();
            
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadBuilderSwfComplete);
         loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, OnLoadBuilderSwfProgress);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnLoadingError);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnLoadingError);
         
         mLoadingStage = " real editor ";
         loader.load(request, new LoaderContext(false, ApplicationDomain.currentDomain));
         
         //
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
      }
      
      private function OnLoadBuilderSwfComplete (event:Event):void 
      {
         //SetInfoText (null);
         
         var MainClass:Object = ApplicationDomain.currentDomain.getDefinition("Main") as Class;
         if (MainClass == null)
         {
            SetInfoText ("Loading error! No main entry");
            return;
         }
         
         var paramsFromUniViewer:Object = new Object ();
         
         paramsFromUniEditor.mUniEditorUrl = mUniEditorUrl;
         paramsFromUniEditor.mFlashVars = LoaderInfo(this.loaderInfo).parameters;
         paramsFromUniEditor.mLoadingProgress = EndLoadingBuilderPercent;
         paramsFromUniEditor.SetLoadingText = SetInfoText;
         
         var viewer:Sprite = (MainClass.Call as Function) ("NewBuilder", {mParamsFromUniEditor: paramsFromUniEditor}) as Sprite;
         viewer.alpha = 0.0;
         addChild (viewer);
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
            mInfoTextField.x = 0.5 * (App::Default_Width - mInfoTextField.width);
            mInfoTextField.y = 0.5 * (App::Default_Height - mInfoTextField.height);
         }
      }
   }
}
