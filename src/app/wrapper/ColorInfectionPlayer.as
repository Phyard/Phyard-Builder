
package wrapper {

   import flash.utils.ByteArray;
   
   import flash.geom.Point;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.display.LoaderInfo;
   import flash.display.StageScaleMode;
   
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
   import player.design.Global;
   
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
      
      private var mParamsFromEditor:Object = null;
         private var GetWorldDefine:Function = null;
         private var GetWorldBinaryData:Function = null;
         private var GetViewportSize:Function = null;
      
      private var mStartRightNow:Boolean = false;
      
      private var mExternalPaused:Boolean = false;
      public function SetExternalPaused (paused:Boolean):void
      {
         mExternalPaused = paused;
      }
      
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
      //private var mBottomBarLayer:Sprite = new Sprite ();
      private var mBorderLineBarLayer:Sprite = new Sprite ();
      private var mErrorMessageLayer:Sprite = new Sprite ();
      private var mFinishedTextLayer:Sprite = new Sprite ();
      private var mDialogLayer:Sprite = new Sprite ();
      
      //
      //private var mAnalyticsDurations:Array = [0.20, 0.30, 1, 1.5, 2, 3, 5];
      //private var mAnalytics:Analytics;
      
//======================================================================
//
//======================================================================
      
      public function ColorInfectionPlayer (start:Boolean = false, paramsFromEditor:Object = null)
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
         
         addChild (mWorldLayer);
         //addChild (mBottomBarLayer);
         addChild (mTopBarLayer);
         addChild (mErrorMessageLayer);
         addChild (mBorderLineBarLayer);
         addChild (mFinishedTextLayer);
         addChild (mDialogLayer);
         
         mStartRightNow = start;
         
         mParamsFromEditor = paramsFromEditor
         if (paramsFromEditor != null)
         {
            GetWorldDefine = paramsFromEditor.getWorldDefine;
            GetWorldBinaryData = paramsFromEditor.getWorldBinaryData;
            GetViewportSize = paramsFromEditor.getViewportSize;
         }
      }
      
      public function GetPlayerWorld ():World
      {
         return mPlayerWorld;
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
         if (GetViewportSize == null)
         {
            CheckStageSize (Number (App::Default_Width),  Number (App::Default_Height));
         }
         
         addEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromFrame);
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         if (mParamsFromEditor != null) //(GetWorldDefine != null || GetWorldBinaryData != null )
            ChangeState (StateId_BuildWorld);
         else
            ChangeState (StateId_Load);
         
         //
         //mAnalytics = new Analytics (this, mAnalyticsDurations);
         //mAnalytics.TrackPageview (Config.VirtualPageName_PlayerJustLoaded);
      }
      
      private function OnRemovedFromFrame (e:Event):void
      {
         removeEventListener (Event.ENTER_FRAME, OnEnterFrame);
         removeEventListener (Event.REMOVED_FROM_STAGE, OnRemovedFromFrame);
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
         
         //
         //var copyCifEmbedItem:ContextMenuItem = new ContextMenuItem("Copy Embed Link For C.I. Forum", false);
         //theContextMenu.customItems.push (copyCifEmbedItem);
         //copyCifEmbedItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyEmbedLink);
         //addSeperaor = true;
         //
         
         var majorVersion:int = (Config.VersionNumber & 0xFF00) >> 8;
         var minorVersion:Number = (Config.VersionNumber & 0xFF) >> 0;
         var aboutItem:ContextMenuItem = new ContextMenuItem("About Phyard Viewer v" + majorVersion.toString (16) + (minorVersion < 16 ? ".0" : ".") + minorVersion.toString (16), addSeperaor);
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
      private static const StateId_BuildWorld:int = 2;
      private static const StateId_Play:int = 3;
      private static const StateId_OnlineLoad:int = 4;
      private static const StateId_RunningError:int = 5;
      
      private var mStateId:int = StateId_None;
      
      private var mFpsCounter:FpsCounter;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      public function Update ():void
      {
      // ...
         
         switch (mStateId)
         {
            case StateId_None:
               break;
            case StateId_Load:
            {
               ParseFlashParams ();
               
               if (mFlashParams.mWorldPlayCode != null)
               {
                  mWorldPlayCode = mFlashParams.mWorldPlayCode;
                  mWorldDataForPlaying = DataFormat2.HexString2ByteArray (mWorldPlayCode);
                  
                  ChangeState (StateId_BuildWorld)
               }
               else
               {
                  TryToStartOnlineLoading ()
               }
               
               break;
            }
            case StateId_OnlineLoad:
               break;
            case StateId_LoadFailed:
               break;
            case StateId_BuildWorld:
               RebuildPlayerWorld ();
               
               if (mPlayerWorld == null)
               {
                  ChangeState (StateId_LoadFailed);
               }
               else
               {
                  ChangeState (StateId_Play);
               }
               
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
               
               Step (false);
               
               if ( mPlayerWorld.IsLevelSuccessed () )
                  OpenFinishedDialog ();
               else
                  CloseFinishedDialog ();
               break;
            }
            case StateId_RunningError:
               break;
            default:
               break;
         }
      }
      
      public function Step (singleStepMode:Boolean = false):void
      {
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if (mPlayerWorld != null)
         {
            var paused:Boolean = (! IsPlaying ()) || mHelpDialog.visible;
            
            mPlayerWorld.SetPaused (paused);
            
            if ( (! mExternalPaused) && ((! paused) || singleStepMode) )
            {
               try
               {
                  mPlayerWorld.Update (mStepTimeSpan.GetLastSpan (), GetPlayingSpeedX (), singleStepMode);
               }
               catch (error:Error)
               {
                  //if (mParamsFromEditor != null) //(GetWorldBinaryData != null || GetWorldDefine != null)
                  //{
                  //   throw error; // let editor to handle it
                  //}
                  //else
                  {
                     // todo show dialog: "stop" or "continue";
                     // write log of send message to server
                     
                     ChangeState (StateId_RunningError);
                  }
                  
                  if (Compile::Is_Debugging)
                  {
                     throw error;
                  }
               }
               
               if (mPlayControlBar != null)
                  mPlayControlBar.NotifyStepped ();
            }
         }
      }
      
      public function ChangeState (newStateId:int):void
      {
         switch (newStateId)
         {
            case StateId_Load:
               BuildErrorMessage ("Initializing ...");
               break;
            case StateId_OnlineLoad:
               BuildErrorMessage ("Loading ...");
               break;
            case StateId_LoadFailed:
               BuildErrorMessage ("Fail to parse play code.", "http://www.phyard.com");
               break;
            case StateId_BuildWorld:
               BuildErrorMessage ("Building ...");
               break;
            case StateId_Play:
               BuildContextMenu ();
               
               CreateTopBar ();
               if (mStartRightNow)
                  mPlayControlBar.OnClickStart ();
               
               OnPause (null);
               
               CreateHelpDialog ();
               //OpenHelpDialog ();
               
               CreateFinishedDialog ();
               
               //CreateBottomBar ();
               
               break;
            case StateId_RunningError:
               //if (mPlayControlBar != null)
               //{
               //   mPlayControlBar.OnClickPause ();
               //   mPlayControlBar.OnClickRestart ();
               //}
               
               BuildErrorMessage ("Runtime error!");
               
               break;
            default:
               break;
         }
         
         mStateId = newStateId;
      }
      
      private function ClearErrorMessage ():void
      {
         while (mErrorMessageLayer.numChildren > 0)
            mErrorMessageLayer.removeChildAt (0);
         GraphicsUtil.Clear (mErrorMessageLayer);
      }
      
      private function BuildErrorMessage (message:String, linkUrl:String = null):void
      {
         ClearErrorMessage ();
         
         var w:int;
         var h:int;
         if (GetViewportSize == null)
         {
            w = App::Default_Width;
            h = App::Default_Height;
         }
         else
         {
            var size:Point = GetViewportSize ();
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
      
      private function CheckStageSize (contentWidth:Number, contentHeight:Number):void
      {
         // in fact, I still don't know why this code work.
         // weird flash.
         
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

      private var mFlashParams:Object;

      public function ParseFlashParams ():void
      {
         mFlashParams = new Object ();
         
         try 
         {
            var loadInfo:LoaderInfo = LoaderInfo(root.loaderInfo);
            
            mFlashParams.mRootUrl = UrlUtil.GetRootUrl (loaderInfo.url);
            
            var flashVars:Object = loaderInfo.parameters;
            if (flashVars != null)
            {
               if (flashVars.playcode != null)
                  mFlashParams.mWorldPlayCode = flashVars.playcode;
               if (flashVars.action != null)
                  mFlashParams.mAction = flashVars.action;
               if (flashVars.author != null)
                  mFlashParams.mAuthorName = flashVars.author;
               if (flashVars.slot != null)
                  mFlashParams.mSlotID = flashVars.slot;
               if (flashVars.revision != null)
                  mFlashParams.mRevisionID = flashVars.revision;
            }
         } 
         catch (error:Error) 
         {
             trace ("Parse flash vars error." + error);
         }
      }
      
      private function OnCopyEmbedLink (event:ContextMenuEvent):void
      {
         mFlashParams
      }
      
      private var mPhyardDesignEmbedCode:String = "";
      
      private function TryToStartOnlineLoading ():void
      {
         if (mFlashParams == null || mFlashParams.mRootUrl == null || mFlashParams.mAction == null || mFlashParams.mAuthorName == null || mFlashParams.mSlotID == null)
         {
            ChangeState (StateId_LoadFailed);
            return;
         }
         
         ChangeState (StateId_OnlineLoad);
         
         var designLoadUrl:String;
         
         if (mFlashParams.mAction == "play")
            designLoadUrl = mFlashParams.mRootUrl + "design/" + mFlashParams.mAuthorName + "/" + mFlashParams.mSlotID + "/loadpc";
         else // "view"
         {
            if (mFlashParams.mRevisionID == null)
               mFlashParams.mRevisionID = "latest";
            
            designLoadUrl = mFlashParams.mRootUrl + "design/" + mFlashParams.mAuthorName + "/" + mFlashParams.mSlotID + "/revision/" + mFlashParams.mRevisionID + "/loadvc";
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
               
               ChangeState (StateId_BuildWorld);
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
         ClearErrorMessage ();
         
         if (mPlayerWorld != null)
         {
            mPlayerWorld.Destroy ();
            
            if (mWorldLayer.contains (mPlayerWorld))
               mWorldLayer.removeChild (mPlayerWorld);
         }
         
         mPlayerWorld = null;
         
         try
         {
            var worldDefine:WorldDefine = null;
            
            if (GetWorldBinaryData != null)
            {
               worldDefine = DataFormat2.ByteArray2WorldDefine (GetWorldBinaryData ())
            }
            else if (GetWorldDefine != null)
            {
               worldDefine = GetWorldDefine ();
            }
            else if (mWorldDataForPlaying != null)
            {
               mWorldDataForPlaying.position = 0;
               worldDefine = DataFormat2.ByteArray2WorldDefine (mWorldDataForPlaying)
            }
            
            mPlayerWorld = DataFormat2.WorldDefine2PlayerWorld (worldDefine);
         }
         catch (error:Error)
         {
            trace ("create world error." + error);
            
            if (Compile::Is_Debugging)
               throw error;
         }
         
         if (mPlayerWorld != null)
         {
            var hidePlayBar:Boolean = (mPlayerWorld.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) == 0;
            
            mPlayerWorld.SetCacheSystemEvent (! hidePlayBar);
            mPlayerWorld.SetInteractiveEnabledWhenPaused (hidePlayBar ||  mParamsFromEditor != null); //GetWorldBinaryData != null || GetWorldDefine != null);
            
            mWorldLayer.addChild (mPlayerWorld);
            
            mEverFinished = false;
         }
         
         CloseFinishedDialog ();
         CloseHelpDialog ();
      }
      
//======================================================================
//
//======================================================================
      
      /*
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
      */
      
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
         CenterSprite (mFinishedDialog);
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
         CenterSprite (mHelpDialog);
         
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
      
      private function CreateTopBar ():void
      {
         var playBarColor:uint = mPlayerWorld == null ? 0x606060 : mPlayerWorld.GetPlayBarColor ();
         var showPlayBar:Boolean = mPlayerWorld == null ? true : ((mPlayerWorld.GetViewerUiFlags () & Define.PlayerUiFlag_ShowPlayBar) != 0);
         var showSpeedAdjustor:Boolean = mPlayerWorld == null ? true : ((mPlayerWorld.GetViewerUiFlags () & Define.PlayerUiFlag_ShowSpeedAdjustor) != 0);
         var showScaleAdjustor:Boolean = mPlayerWorld == null ? true : ((mPlayerWorld.GetViewerUiFlags () & Define.PlayerUiFlag_ShowScaleAdjustor) != 0);
         var showHelpButton:Boolean = mPlayerWorld == null ? true : ((mPlayerWorld.GetViewerUiFlags () & Define.PlayerUiFlag_ShowHelpButton) != 0);
         var viewportWidth:int = mPlayerWorld == null ? Define.DefaultPlayerWidth : mPlayerWorld.GetViewportWidth ();
         var viewportHeight:int = mPlayerWorld == null ? Define.DefaultPlayerHeight : mPlayerWorld.GetViewportHeight ();
         var viewerWidth:Number = viewportWidth;
         var viewerHeight:Number = showPlayBar ? (Define.PlayerPlayBarThickness + viewportHeight) : viewportHeight;
         
         if (GetViewportSize == null)
         {
            CheckStageSize (viewerWidth, viewerHeight);
         }
         
         GraphicsUtil.ClearAndDrawRect (mTopBarLayer, 0, 0, viewportWidth - 1, Define.PlayerPlayBarThickness, playBarColor, 1, true, playBarColor);
         
         mPlayControlBar = new PlayControlBar (OnRestart, OnStart, OnPause, null, showSpeedAdjustor ? OnSpeed : null, showHelpButton ? OnHelp : null, mMainMenuCallback, showScaleAdjustor ? OnZoom : null);
         mTopBarLayer.addChild (mPlayControlBar);
         mPlayControlBar.x = 0.5 * (mTopBarLayer.width - mPlayControlBar.width);
         mPlayControlBar.y = 2;
         
         //GraphicsUtil.ClearAndDrawRect (mBorderLineBarLayer, 0, 0, viewerWidth - 1, viewerHeight - 1, 0x606060);
         
         mTopBarLayer.visible = showPlayBar;
         mTopBarLayer.x = 0;
         mTopBarLayer.y = 0;
         
         mWorldLayer.x = 0;
         mWorldLayer.y = mTopBarLayer.y + (showPlayBar ? mTopBarLayer.height : 0);
         
         //
         Global.RestartPlay = mPlayControlBar.OnClickRestart;
         Global.IsPlaying = mPlayControlBar.IsPlaying;
         Global.SetPlaying = mPlayControlBar.SetPlaying;
         Global.GetSpeedX = mPlayControlBar.GetPlayingSpeedX;
         Global.SetSpeedX = mPlayControlBar.SetPlayingSpeedX;
         Global.GetScale = mPlayControlBar.GetZoomScale;
         Global.SetScale = mPlayControlBar.SetZoomScale;
         
         //
         mPlayerWorld.Initialize ();
      }
      
      private function CenterSprite (sprite:Sprite):void
      {
         var viewportWidth:int = mPlayerWorld == null ? Define.DefaultPlayerWidth : mPlayerWorld.GetViewportWidth ();
         var viewportHeight:int = mPlayerWorld == null ? Define.DefaultPlayerHeight : mPlayerWorld.GetViewportHeight ();
         
         sprite.x = mWorldLayer.x + 0.5 * (viewportWidth - sprite.width);
         sprite.y = mWorldLayer.y + 0.5 * (viewportHeight - sprite.height);
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
         
         mPlayerWorldZoomScaleChangedSpeed = ( mPlayerWorldZoomScale - mPlayerWorld.GetZoomScale () ) * 0.03;
      }
      
      private function OnHelp(data:Object = null):void
      {
         OpenHelpDialog ();
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
      
   }
}
