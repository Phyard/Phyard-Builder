
package wrapper {

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
      
      
      [Embed(source="../../res/player/player-restart.png")]
      private static var IconRestart:Class;
      [Embed(source="../../res/player/player-restart-disabled.png")]
      private static var IconRestartDisabled:Class;
      [Embed(source="../../res/player/player-start.png")]
      private static var IconStart:Class;
      [Embed(source="../../res/player/player-pause.png")]
      private static var IconPause:Class;
      
      [Embed(source="../../res/player/player-help.png")]
      private static var IconHelp:Class;
      
      [Embed(source="../../res/player/player-speed.png")]
      private static var IconSpeed:Class;
      [Embed(source="../../res/player/player-speed-selected.png")]
      private static var IconSpeedSelected:Class;
      
      private var mBitmapDataRetart:BitmapData = new IconRestart ().bitmapData;
      private var mBitmapDataRetartDisabled:BitmapData = new IconRestartDisabled ().bitmapData;
      private var mBitmapDataStart:BitmapData = new IconStart ().bitmapData;
      private var mBitmapDataPause:BitmapData = new IconPause ().bitmapData;
      private var mBitmapDataHelp:BitmapData  = new IconHelp ().bitmapData;
      private var mBitmapDataSpeed:BitmapData  = new IconSpeed ().bitmapData;
      private var mBitmapDataSpeedSelected:BitmapData  = new IconSpeedSelected ().bitmapData;
      
//======================================================================
//
//======================================================================
      
      private var mWorldLayer:Sprite = new Sprite ();
      private var mTopBarLayer:Sprite = new Sprite ();
      private var mBottomBarLayer:Sprite = new Sprite ();
      private var mFinishedTextLayer:Sprite = new Sprite ();
      private var mDialogLayer:Sprite = new Sprite ();
      
      private var mWorldPlayCode:String = null;
      //private var mWorldDefine:WorldDefine = null;
      private var mPlayerWorld:World = null;
      private var mWorldSourceCode:String = null;
      
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      
      //
      //private var mAnalyticsDurations:Array = [0.20, 0.30, 1, 1.5, 2, 3, 5];
      //private var mAnalytics:Analytics;
      
      public function ColorInfectionPlayer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
         
         addChild (mWorldLayer);
         addChild (mTopBarLayer);
         addChild (mBottomBarLayer);
         addChild (mFinishedTextLayer);
         addChild (mDialogLayer);
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
      
      
      private static const StateId_None:int = -1;
      private static const StateId_Load:int = 0;
      private static const StateId_Play:int = 1;
      
      private var mStateId:int = StateId_None;
      
      private var mFpsCounter:FpsCounter;
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      
      private var _temp:int = 0;
      
      public function Update ():void
      {
      // ...
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
      // ...
         if (mStateId == StateId_None)
         {
         }
         else if (mStateId == StateId_Load)
         {
            //trace ("root.parent");
            //   ParseParams (LoaderInfo(root.parent.loaderInfo));
            //trace ("stage");
            //   ParseParams (LoaderInfo(stage.loaderInfo));
            //trace ("stage.root");
            //   ParseParams (LoaderInfo(stage.root.loaderInfo));
            //trace ("root");
               ParseParams (LoaderInfo(root.loaderInfo));
            
            while (mWorldLayer.numChildren > 0)
               mWorldLayer.removeChildAt (0);
            
            if (mWorldPlayCode != null)
            {
               CreateUI ();
               
               OnRestart (null);
               
               BuildContextMenu ();
            }
            
            //if (mWorldDefine == null)
            if (mWorldPlayCode == null || mPlayerWorld == null)
            {
               mTopBarLayer.visible = false;
               
               // ...
               
               var errorText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Fail to parse play code."));
               errorText.x = (Define.DefaultWorldWidth  - errorText.width ) * 0.5;
               errorText.y = (Define.DefaultWorldHeight - errorText.height) * 0.5;
               mWorldLayer.addChild (errorText);
               
               var linkText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("<font size='10' color='#0000ff'><u><a href='http://www.colorinfection.com' target='_blank'>ColorInfection.com</a></u></font>"));
               linkText.x = (Define.DefaultWorldWidth  - linkText.width ) * 0.5;
               linkText.y = Define.DefaultWorldHeight - linkText.height - 20;
               mWorldLayer.addChild (linkText);
               ChangeState (StateId_None);
               return;
            }
            
            
            OnPause (null);
            
            CreateHelpDialog ();
            //OpenHelpDialog ();
            
            CreateFinishedDialog ();
            
            CreateBottomBar ();
            
            ChangeState (StateId_Play);
         }
         else if (mStateId == StateId_Play)
         {
            if ( mPlayerWorld != null && IsPlaying () && mHelpDialog.visible == false )
               mPlayerWorld.Update (mStepTimeSpan.GetLastSpan (), GetPlayingSpeedX ());
            
            if ( mPlayerWorld.IsPuzzleSolved () )
               OpenFinishedDialog ();
            else
               CloseFinishedDialog ();
         }
      }
      
      public function ChangeState (newStateId:int):void
      {
         switch (newStateId)
         {
            case StateId_Load:
               var initText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Initializing ..."));
               initText.x = (Define.DefaultWorldWidth  - initText.width ) * 0.5;
               initText.y = (Define.DefaultWorldHeight - initText.height) * 0.5;
               mWorldLayer.addChild (initText);
               break;
            case StateId_Play:
               
               
               
               break;
            default:
               break;
         }
         
         mStateId = newStateId;
      }
      
      private function ParseParams (loadInfo:LoaderInfo):void
      {
         try 
         {
            var flashVars:Object = loaderInfo.parameters;
            
            if (flashVars != null)
            {
               var keyStr:String;
               var valueStr:String;
               for (keyStr in flashVars) 
               {
                  valueStr = String(flashVars[keyStr]);
                  
                  //trace (keyStr + "=" + valueStr);
                  
                  if (keyStr == "playcode")
                  {
                     mWorldPlayCode = valueStr; 
                     //mWorldDefine = DataFormat2.HexString2WorldDefine (valueStr);
                  }
               }
            }
         } 
         catch (error:Error) 
         {
             trace ("flash vars error." + error);
         }
      }
      
      private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         
         var addSeperaor:Boolean = false;
         if (Compile::Is_Debugging || mWorldPlayCode != null && mPlayerWorld != null && mPlayerWorld.IsShareSourceCode ())
         {
            mWorldSourceCode = DataFormat2.WorldDefine2Xml (DataFormat2.HexString2WorldDefine (mWorldPlayCode));
            
            if (mWorldSourceCode != null)
            {
               var copySourceCodeItem:ContextMenuItem = new ContextMenuItem("Copy Source Code", false);
               theContextMenu.customItems.push (copySourceCodeItem);
               copySourceCodeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopySourceCode);
               
               addSeperaor = true;
            }
         }
         
         if (Compile::Is_Debugging || mWorldPlayCode != null &&  mPlayerWorld != null && mPlayerWorld.IsPermitPublishing ())
         {
            var copyPlayCodeItem:ContextMenuItem = new ContextMenuItem("Copy Play Code", false);
            theContextMenu.customItems.push (copyPlayCodeItem);
            copyPlayCodeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyPlayCode);
            
            addSeperaor = true;
         }
         
         var aboutItem:ContextMenuItem = new ContextMenuItem("About Color Infection Player", addSeperaor);
         theContextMenu.customItems.push (aboutItem);
         aboutItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnAbout);
         
         contextMenu = theContextMenu;
      }
      
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
      
      private function CreateBottomBar ():void
      {
         mBottomBarLayer.x = Define.DefaultWorldWidth * 0.5;
         mBottomBarLayer.y = Define.DefaultWorldHeight - Define.WorldBorderThinknessTB;
         
         mBottomBarLayer.graphics.clear ();
         mBottomBarLayer.graphics.beginFill(0x606060);
         mBottomBarLayer.graphics.drawRect ( - Define.DefaultWorldWidth * 0.5, 0, Define.DefaultWorldWidth, Define.WorldBorderThinknessTB);
         mBottomBarLayer.graphics.endFill ();
         
         if (mWorldLayer != null)
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
         
         mFinishedTextLayer.addChild (mFinishedDialog);
      }
      
      private function OpenFinishedDialog ():void
      {
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
         
         mPlayControlBar = new PlayControlBar (OnRestart, OnStart, OnPause, null, OnSpeed, OnHelp);
         mTopBarLayer.addChild (mPlayControlBar); 
         mPlayControlBar.x = - mPlayControlBar.width * 0.5;
         mPlayControlBar.y = 2;
      }
      
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
         try
         {
            if (mPlayerWorld != null && mWorldLayer.contains (mPlayerWorld))
               mWorldLayer.removeChild (mPlayerWorld);
            
            mPlayerWorld = DataFormat2.WorldDefine2PlayerWorld (DataFormat2.HexString2WorldDefine (mWorldPlayCode));
            
            if (mPlayerWorld != null)
            {
               mPlayerWorld.Update (0, 1);
               
               mWorldLayer.addChild (mPlayerWorld);
               
               mEverFinished = false;
            }
         }
         catch (error:Error)
         {
            mPlayerWorld = null;
         }
         
         CloseFinishedDialog ();
         CloseHelpDialog ();
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
      
      private function OnHelp(data:Object = null):void
      {
         OpenHelpDialog ();
      }
      
   }
}
