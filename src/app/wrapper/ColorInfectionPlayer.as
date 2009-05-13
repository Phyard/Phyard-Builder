
package wrapper {

   import flash.utils.ByteArray;
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.display.LoaderInfo;
   
   import flash.system.System;
   
   import flash.events.Event;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.net.navigateToURL;
   
   import com.tapirgames.display.FpsCounter;
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;
   
   import player.world.World;
   import player.ui.UiUtil;
   import player.ui.PlayHelpDialog;
   import player.ui.PlayControlBar;
   
   import common.DataFormat2;
   import common.Define;
   import common.WorldDefine;
   
   import common.Config;
   //import misc.Analytics;
   
   public dynamic class ColorInfectionPlayer extends Sprite 
   {
      
//======================================================================
//
//======================================================================
      
      private var mWorldPlayCode:String = null;
      private var mWorldDataForPlaying:ByteArray = null;
      private var mWorldSourceCode:String = null;
      
      private var mBuildContextMenu:Boolean = true;
      private var mMainMenuCallback:Function = null;
      
      private var mPlayerWorld:World = null;
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      
      private var mPlayerWorldZoomScale:Number = 1.0;
      private var mPlayerWorldZoomScaleChangedSpeed:Number = 0.0;
      
      private var mWorldLayer:Sprite = new Sprite ();
      private var mTopBarLayer:Sprite = new Sprite ();
      private var mBottomBarLayer:Sprite = new Sprite ();
      private var mErrorMessageLayer:Sprite = new Sprite ();
      private var mFinishedTextLayer:Sprite = new Sprite ();
      private var mDialogLayer:Sprite = new Sprite ();
      
      //
      //private var mAnalyticsDurations:Array = [0.20, 0.30, 1, 1.5, 2, 3, 5];
      //private var mAnalytics:Analytics;
      
//======================================================================
//
//======================================================================
      
      public function ColorInfectionPlayer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
         
         addChild (mWorldLayer);
         addChild (mTopBarLayer);
         addChild (mBottomBarLayer);
         addChild (mErrorMessageLayer);
         addChild (mFinishedTextLayer);
         addChild (mDialogLayer);
      }
      
      public function SetOptions (options:Object = null):void
      {
         if (options != null)
         {
            if (options.mWorldPlayCode != null)
            {
               mWorldPlayCode = options.mWorldPlayCode;
               mWorldDataForPlaying = DataFormat2.HexString2ByteArray (mWorldPlayCode);
            }
            if (options.mBuildContextMenu != null)
               mBuildContextMenu = options.mBuildContextMenu;
            if (options.mMainMenuCallback != null)
               mMainMenuCallback = options.mMainMenuCallback;
         }
      }
      
      private function OnAddedToStage (e:Event):void
      {
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         ChangeState (StateId_Load);
         
         //
         //mAnalytics = new Analytics (this, mAnalyticsDurations);
         //mAnalytics.TrackPageview (Config.VirtualPageName_PlayerJustLoaded);
      }
      
      private function OnEnterFrame (event:Event):void 
      {
         Update ();
         
         // ...
         //mAnalytics.TrackTime (Config.VirtualPageName_PlayerTimePrefix);
      }
      
      private function BuildContextMenu ():void
      {
         if (! mBuildContextMenu)
            return;
         
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         
         var addSeperaor:Boolean = false;
         if (Compile::Is_Debugging || mPlayerWorld != null && mPlayerWorld.IsShareSourceCode ())
         {
            //if (mWorldPlayCode != null)
            if (mWorldDataForPlaying != null)
            {
               //mWorldSourceCode = DataFormat2.WorldDefine2Xml (DataFormat2.HexString2WorldDefine (mWorldPlayCode));
               
               mWorldDataForPlaying.position = 0;
               mWorldSourceCode = DataFormat2.WorldDefine2Xml (DataFormat2.ByteArray2WorldDefine (mWorldDataForPlaying));
               
               if (mWorldSourceCode != null)
               {
                  var copySourceCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Source Code", false);
                  theContextMenu.customItems.push (copySourceCodeMenuItem);
                  copySourceCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopySourceCode);
                  
                  addSeperaor = true;
               }
            }
         }
         
         if (Compile::Is_Debugging || mPlayerWorld != null && mPlayerWorld.IsPermitPublishing ())
         {
            if (mWorldPlayCode != null)
            {
               var copyPlayCodeMenuItem:ContextMenuItem = new ContextMenuItem("Copy Play Code", false);
               theContextMenu.customItems.push (copyPlayCodeMenuItem);
               copyPlayCodeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyPlayCode);
               
               addSeperaor = true;
            }
         }
         
         var aboutItem:ContextMenuItem = new ContextMenuItem("About Color Infection Player", addSeperaor);
         theContextMenu.customItems.push (aboutItem);
         aboutItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnAbout);
         
         contextMenu = theContextMenu;
      }
      
//======================================================================
//
//======================================================================
      
      private static const StateId_None:int = -1;
      private static const StateId_Load:int = 0;
      private static const StateId_LoadFailed:int = 1;
      private static const StateId_Play:int = 2;
      private static const StateId_OnlineLoad:int = 3;
      
      private var mStateId:int = StateId_None;
      
      private var mFpsCounter:FpsCounter;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      public function Update ():void
      {
      // ...
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
      // ...
         
         switch (mStateId)
         {
            case StateId_None:
               break;
            case StateId_Load:
            {
               var params:Object = GetFlashParams ();
               
               if (params.mWorldPlayCode != null)
               {
                  mWorldPlayCode = params.mWorldPlayCode;
                  mWorldDataForPlaying = DataFormat2.HexString2ByteArray (mWorldPlayCode);
                  
                  RebuildPlayerWorld ();
                  
                  if (mPlayerWorld == null)
                  {
                     ChangeState (StateId_LoadFailed);
                  }
                  else
                  {
                     ChangeState (StateId_Play);
                  }
               }
               else
               {
                  TryToStartOnlineLoading (params)
               }
               
               break;
            }
            case StateId_OnlineLoad:
               break;
            case StateId_LoadFailed:
               break;
            case StateId_Play:
            {
               if (mPlayerWorld != null && mPlayerWorld.GetZoomScale () != mPlayerWorldZoomScale)
               {
                  var newScale:Number;
                  
                  if (mPlayerWorld.GetZoomScale () < mPlayerWorldZoomScale)
                  {
                     if (mPlayerWorldZoomScaleChangedSpeed < 0)
                        mPlayerWorldZoomScaleChangedSpeed = - mPlayerWorldZoomScaleChangedSpeed;
                     
                     newScale = mPlayerWorld.scaleX + mPlayerWorldZoomScaleChangedSpeed;
                     
                     if (newScale >= mPlayerWorldZoomScale)
                        mPlayerWorld.SetZoomScale (mPlayerWorldZoomScale);
                     else
                        mPlayerWorld.SetZoomScale (newScale);
                  }
                  else
                  {
                     if (mPlayerWorldZoomScaleChangedSpeed > 0)
                        mPlayerWorldZoomScaleChangedSpeed = - mPlayerWorldZoomScaleChangedSpeed;
                     
                     newScale = mPlayerWorld.scaleX + mPlayerWorldZoomScaleChangedSpeed;
                     
                     if (newScale <= mPlayerWorldZoomScale)
                        mPlayerWorld.SetZoomScale (mPlayerWorldZoomScale);
                     else
                        mPlayerWorld.SetZoomScale (newScale);
                  }
               }
               
               if ( mPlayerWorld != null && IsPlaying () && mHelpDialog.visible == false )
               {
                  mPlayerWorld.Update (mStepTimeSpan.GetLastSpan (), GetPlayingSpeedX ());
               }
               
               if ( mPlayerWorld.IsPuzzleSolved () )
                  OpenFinishedDialog ();
               else
                  CloseFinishedDialog ();
               break;
            }
            default:
               break;
         }
      }
      
      public function ChangeState (newStateId:int):void
      {
         switch (newStateId)
         {
            case StateId_Load:
               while (mErrorMessageLayer.numChildren > 0)
                  mErrorMessageLayer.removeChildAt (0);
               
               var initText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Initializing ..."));
               initText.x = (Define.DefaultWorldWidth  - initText.width ) * 0.5;
               initText.y = (Define.DefaultWorldHeight - initText.height) * 0.5;
               mErrorMessageLayer.addChild (initText);
               
               break;
            case StateId_OnlineLoad:
               while (mErrorMessageLayer.numChildren > 0)
                  mErrorMessageLayer.removeChildAt (0);
               
               var loadingText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Loading ..."));
               loadingText.x = (Define.DefaultWorldWidth  - loadingText.width ) * 0.5;
               loadingText.y = (Define.DefaultWorldHeight - loadingText.height) * 0.5;
               mErrorMessageLayer.addChild (loadingText);
               
               break;
            case StateId_LoadFailed:
               while (mErrorMessageLayer.numChildren > 0)
                  mErrorMessageLayer.removeChildAt (0);
               
               var errorText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Fail to parse play code."));
               errorText.x = (Define.DefaultWorldWidth  - errorText.width ) * 0.5;
               errorText.y = (Define.DefaultWorldHeight - errorText.height) * 0.5;
               mErrorMessageLayer.addChild (errorText);
               
               var linkText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("<font size='10' color='#0000ff'><u><a href='http://forum.colorinfection.com' target='_blank'>ColorInfection.com</a></u></font>"));
               linkText.x = (Define.DefaultWorldWidth  - linkText.width ) * 0.5;
               linkText.y = Define.DefaultWorldHeight - linkText.height - 20;
               mErrorMessageLayer.addChild (linkText);
               
               break;
            case StateId_Play:
               while (mErrorMessageLayer.numChildren > 0)
                  mErrorMessageLayer.removeChildAt (0);
               
               BuildContextMenu ();
               
               CreateUI ();
               
               OnPause (null);
               
               CreateHelpDialog ();
               //OpenHelpDialog ();
               
               CreateFinishedDialog ();
               
               CreateBottomBar ();
               
               break;
            default:
               break;
         }
         
         mStateId = newStateId;
      }
      
//======================================================================
//
//======================================================================
      
      private function OnCopySourceCode (event:ContextMenuEvent):void
      {
         if (mWorldSourceCode != null)
            System.setClipboard(mWorldSourceCode);
      }
      
      private function OnCopyPlayCode (event:ContextMenuEvent):void
      {
         if (mWorldPlayCode != null)
            System.setClipboard(mWorldPlayCode);
      }
      
      private function OnAbout (event:ContextMenuEvent):void
      {
         UrlUtil.PopupPage (Define.AboutUrl);
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

      public function GetFlashParams ():Object
      {
         try 
         {
            var loadInfo:LoaderInfo = LoaderInfo(root.loaderInfo);
             
            var params:Object = new Object ();
            
            params.mRootUrl = UrlUtil.GetRootUrl (loaderInfo.url);
            
            var flashVars:Object = loaderInfo.parameters;
            if (flashVars != null)
            {
               if (flashVars.playcode != null)
                  params.mWorldPlayCode = flashVars.playcode;
               if (flashVars.action != null)
                  params.mAction = flashVars.action;
               if (flashVars.author != null)
                  params.mAuthorName = flashVars.author;
               if (flashVars.slot != null)
                  params.mSlotID = flashVars.slot;
               if (flashVars.revision != null)
                  params.mRevisionID = flashVars.revision;
            }
            
            return params;
         } 
         catch (error:Error) 
         {
             trace ("Parse flash vars error." + error);
         }
         
         return null;
      }
      
      private function TryToStartOnlineLoading (params:Object):void
      {
         if (params == null || params.mRootUrl == null || params.mAction == null || params.mAuthorName == null || params.mSlotID == null)
         {
            ChangeState (StateId_LoadFailed);
            return;
         }
         
         ChangeState (StateId_OnlineLoad);
         
         var designLoadUrl:String;
         
         if (params.mAction == "play")
            designLoadUrl = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/loadpc";
         else // "view"
         {
            if (params.mRevisionID == null)
               params.mRevisionID = "lastest";
            
            designLoadUrl = params.mRootUrl + "design/" + params.mAuthorName + "/" + params.mSlotID + "/revision/" + params.mRevisionID + "/loadvc";
         }
         
         var request:URLRequest = new URLRequest (designLoadUrl);
         request.method = URLRequestMethod.GET;
         
         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         
         loader.addEventListener(Event.COMPLETE, OnOnlineLoadCompleted);
         
         loader.load ( request );
      }
      
      private function OnOnlineLoadCompleted(event:Event):void 
      {
         var loader:URLLoader = URLLoader(event.target);
         
         try
         {
            var data:ByteArray = ByteArray (loader.data);
            
            var returnCode:int = data.readByte ();
            
            if (returnCode == k_ReturnCode_Successed)
            {
               var designDataForPlaying:ByteArray = new ByteArray ();
               data.readBytes (designDataForPlaying);
               designDataForPlaying.uncompress ();
               
               mWorldDataForPlaying = designDataForPlaying;
               
               //
               {
                  RebuildPlayerWorld ();
                  
                  if (mPlayerWorld == null)
                  {
                     ChangeState (StateId_LoadFailed);
                  }
                  else
                  {
                     ChangeState (StateId_Play);
                  }
               }
            }
            else
            {
               ChangeState (StateId_LoadFailed);
            }
         }
         catch (error:Error)
         {
            ChangeState (StateId_LoadFailed);
            
            if (Compile::Is_Debugging)
               throw error;
         }
      }
      
      private function RebuildPlayerWorld ():void
      {
         if (mPlayerWorld != null)
         {
            mPlayerWorld.Destroy ();
            
            if (mWorldLayer.contains (mPlayerWorld))
               mWorldLayer.removeChild (mPlayerWorld);
         }
         
         mPlayerWorld = null;
         
         if (mWorldDataForPlaying == null)
            trace ("mWorldDataForPlaying == null !");
         else
         {
            try
            {
               mWorldDataForPlaying.position = 0;
               mPlayerWorld = DataFormat2.WorldDefine2PlayerWorld (DataFormat2.ByteArray2WorldDefine (mWorldDataForPlaying));
            }
            catch (error:Error)
            {
               trace ("create world error." + error);
               
               if (Compile::Is_Debugging)
                  throw error;
            }
         }
         
         if (mPlayerWorld != null)
         {
            mPlayerWorld.Update (0, 1);
            
            mWorldLayer.addChild (mPlayerWorld);
            
            mEverFinished = false;
         }
         
         CloseFinishedDialog ();
         CloseHelpDialog ();
      }
      
//======================================================================
//
//======================================================================
      
      private function CreateBottomBar ():void
      {
         mBottomBarLayer.x = Define.DefaultWorldWidth * 0.5;
         mBottomBarLayer.y = Define.DefaultWorldHeight - Define.WorldBorderThinknessTB;
         
         mBottomBarLayer.graphics.clear ();
         mBottomBarLayer.graphics.beginFill(0x606060);
         mBottomBarLayer.graphics.drawRect ( - Define.DefaultWorldWidth * 0.5, 0, Define.DefaultWorldWidth, Define.WorldBorderThinknessTB);
         mBottomBarLayer.graphics.endFill ();
         
         while (mBottomBarLayer.numChildren > 0)
            mBottomBarLayer.removeChildAt (0);
         
         if (mPlayerWorld != null)
         {
            var authorName:String = mPlayerWorld.GetAuthorName ();
            var anthorUrl:String = mPlayerWorld.GetAuthorHomepage ().toLowerCase();
            
            var infoText:String = "<font face='Verdana' size='10'> Designed by: ";
            
            if (authorName != null && authorName.length > 0)
            {
               authorName = TextUtil.TrimString (authorName);
               
               if (authorName.length > 30)
                  authorName = authorName.substr (0, 30);
               
               infoText = infoText + "<b><i>" + authorName + "</i></b>";
               
               if (anthorUrl != null)
               {
                  if (anthorUrl.indexOf ("http") != 0)
                     anthorUrl = null;
               }
               
               if (anthorUrl != null)
               {
                  anthorUrl = TextUtil.TrimString (anthorUrl);
                  
                  var maxUrlLength:int = 60 - authorName.length;
                  
                  var anthorUrlShort:String = anthorUrl;
                  
                  if (anthorUrl.length > maxUrlLength)
                  {
                     anthorUrlShort = anthorUrl.substr (0, maxUrlLength - 3) + "...";
                  }
                  else
                     anthorUrl = anthorUrl;
                  
                  
                  infoText = infoText + " (<u><font color='#0000ff'><a href='" + anthorUrl + "' target='_blank' >" + anthorUrlShort + "</a></font></u>)";
               }
               
               var textField:TextFieldEx = TextFieldEx.CreateTextField (infoText, true, 0xDDDDDD);
               mBottomBarLayer.addChild (textField);
               
               textField.x = - textField.width * 0.5;
               textField.y = 2;
            }
         }
      }
      
      private var mFinishedDialog:Sprite;
      
      private var mTextFinished:TextFieldEx;
      private var mTextAuthorInfo:TextFieldEx;
      private var mButtonReplay:TextButton;
      private var mButtonCloseFinishDialog:TextButton;
      
      private var mEverFinished:Boolean = false;
      
      private function CreateFinishedDialog ():void
      {
         var finishedText:String = "<font size='30' face='Verdana' color='#000000'> <b>Cool! It is solved.</b></font>";
         mTextFinished = TextFieldEx.CreateTextField (finishedText, false, 0xFFFFFF, 0x0, false);
         
         mButtonReplay = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>   Replay   </font>", OnRestart);
         mButtonCloseFinishDialog = new TextButton ("<font size='16' face='Verdana' color='#0000FF'>   Close   </font>", CloseFinishedDialog);
         var buttonContainer:Sprite = new Sprite ();
         buttonContainer.addChild (mButtonReplay);
         buttonContainer.addChild (mButtonCloseFinishDialog);
         mButtonCloseFinishDialog.x = mButtonReplay.x + mButtonReplay.width + 50;
         
         var infoText:String = "";
         
         if (mWorldLayer != null)
         {
            var authorName:String = mPlayerWorld.GetAuthorName ();
            var anthorUrl:String = mPlayerWorld.GetAuthorHomepage ().toLowerCase();
            
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
         infoText = infoText + "Want to <font color='#0000FF'><u><a href='" + Define.EditorUrl + "' target='_blank'>design your own puzzles</a></u></font>?";
         infoText = infoText + "</font>";
         
         mTextAuthorInfo = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, 0x0);
         
         mFinishedDialog = UiUtil.CreateDialog ([mTextFinished, 20, mTextAuthorInfo, 20, buttonContainer]);
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
      
      private function CreateUI ():void
      {
         mTopBarLayer.x= Define.DefaultWorldWidth * 0.5;
         
         mTopBarLayer.graphics.clear ();
         mTopBarLayer.graphics.beginFill(0x606060);
         mTopBarLayer.graphics.drawRect ( - Define.DefaultWorldWidth * 0.5, 0, Define.DefaultWorldWidth, Define.WorldBorderThinknessTB);
         mTopBarLayer.graphics.endFill ();
         
         mPlayControlBar = new PlayControlBar (OnRestart, OnStart, OnPause, null, OnSpeed, OnHelp, mMainMenuCallback, OnZoom);
         mTopBarLayer.addChild (mPlayControlBar); 
         mPlayControlBar.x = - mPlayControlBar.width * 0.5;
         mPlayControlBar.y = 2;
      }
      
//======================================================================
//
//======================================================================
      
      private function IsPlaying ():Boolean
      {
         if(mPlayControlBar == null)
            return false;
         
         return mPlayControlBar.IsPlaying ();
      }
      
      private function GetPlayingSpeedX ():int
      {
         if(mPlayControlBar == null)
            return 2;
         
         return mPlayControlBar.GetPlayingSpeedX ();
      }
      
      private function OnRestart (data:Object = null):void
      {
         RebuildPlayerWorld ();
         
         mPlayerWorldZoomScale = mPlayerWorld.GetZoomScale ();
         if (mPlayControlBar != null)
            mPlayControlBar.SetZoomScale (mPlayerWorldZoomScale);
      }
      
      public function OnStart (data:Object = null):void
      {
      }
      
      public function OnPause (data:Object = null):void
      {
      }
      
      private function OnSpeed (data:Object = null):void
      {
      }
      
      private function OnZoom (data:Object = null):void
      {
         if (mPlayControlBar == null)
            return;
         
         mPlayerWorldZoomScale = mPlayControlBar.GetZoomScale ();
         
         if (mPlayerWorld == null)
            return;
         
         mPlayerWorldZoomScaleChangedSpeed = ( mPlayerWorldZoomScale - mPlayerWorld.GetZoomScale () ) * 0.03;
      }
      
      private function OnHelp(data:Object = null):void
      {
         OpenHelpDialog ();
      }
      
   }
}
