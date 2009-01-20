
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
   
   import common.DataFormat2;
   import common.Define;
   import common.WorldDefine;;
   
   public dynamic class ColorInfectionPlayer extends Sprite 
   {
      
      
      [Embed(source="../res/player/player-restart.png")]
      private static var IconRestart:Class;
      [Embed(source="../res/player/player-restart-disabled.png")]
      private static var IconRestartDisabled:Class;
      [Embed(source="../res/player/player-start.png")]
      private static var IconStart:Class;
      [Embed(source="../res/player/player-pause.png")]
      private static var IconPause:Class;
      
      [Embed(source="../res/player/player-help.png")]
      private static var IconHelp:Class;
      
      [Embed(source="../res/player/player-speed.png")]
      private static var IconSpeed:Class;
      [Embed(source="../res/player/player-speed-selected.png")]
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
      
         private var mHelpDialog:Sprite;
         private var mFinishedDialog:Sprite;
      
      private var mWorldDataHexString:String = null;
      //private var mWorldDefine:WorldDefine = null;
      private var mPlayerWorld:World = null;
      
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      
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
      }
      
      private function OnEnterFrame (event:Event):void 
      {
         Update ();
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
            
            if (mWorldDataHexString != null)
            {
               CreateUI ();
               
               BuildContextMenu ();
               
               OnRestart (null);
            }
            
            //if (mWorldDefine == null)
            if (mWorldDataHexString == null || mPlayerWorld == null)
            {
               mTopBarLayer.visible = false;
               
               // ...
               
               var errorText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Fail to parse play code."));
               errorText.x = (Define.WorldWidth  - errorText.width ) * 0.5;
               errorText.y = (Define.WorldHeight - errorText.height) * 0.5;
               mWorldLayer.addChild (errorText);
               
               var linkText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("<font size='10' color='#0000ff'><u><a href='http://www.colorinfection.com' target='_blank'>ColorInfection.com</a></u></font>"));
               linkText.x = (Define.WorldWidth  - linkText.width ) * 0.5;
               linkText.y = Define.WorldHeight - linkText.height - 20;
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
            if (mPlayerWorld != null && mIsPlaying)
               mPlayerWorld.Update (mStepTimeSpan.GetLastSpan (), mPlayingSpeedX);
            
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
               initText.x = (Define.WorldWidth  - initText.width ) * 0.5;
               initText.y = (Define.WorldHeight - initText.height) * 0.5;
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
                     mWorldDataHexString = valueStr; 
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
         
         var copyPlayCodeItem:ContextMenuItem = new ContextMenuItem("Copy Play Code", false);
         theContextMenu.customItems.push (copyPlayCodeItem);
         copyPlayCodeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnCopyPlayCode);
         
         contextMenu = theContextMenu;
      }
      
      private function OnCopyPlayCode (event:ContextMenuEvent):void
      {
         if (mWorldDataHexString != null)
            System.setClipboard(mWorldDataHexString);
      }
      
      private function CreateBottomBar ():void
      {
         if (mWorldLayer != null)
         {
            var authorName:String = mPlayerWorld.GetAuthorName ();
            var anthorUrl:String = mPlayerWorld.GetAuthorHomepage ().toLowerCase();
            
            var infoText:String = "<font face='Verdana' size='10'> Designed by: ";
            
            if (authorName != null && authorName.length > 0)
            {
               authorName = TextUtil.TrimString (authorName);
               
               if (authorName.length > 50)
                  authorName = authorName.substr (0, 50);
               
               infoText = infoText + "<b><i>" + authorName + "</i></b>";
               
               if (anthorUrl != null)
               {
                  if (anthorUrl.indexOf ("http") != 0)
                     anthorUrl = null;
               }
               
               if (anthorUrl != null)
               {
                  anthorUrl = TextUtil.TrimString (anthorUrl);
                  
                  var maxUrlLength:int = 100 - authorName.length;
                  
                  var anthorUrlShort:String = anthorUrl;
                  
                  if (anthorUrl.length > maxUrlLength)
                  {
                     anthorUrlShort = anthorUrl.substr (0, maxUrlLength - 3) + "...";
                  }
                  else
                     anthorUrl = anthorUrl;
                  
                  
                  infoText = infoText + " (<u><font color='#0000ff'><a href='" + anthorUrl + "' target='_blank' >" + anthorUrlShort + "</a></font></u>)";
               }
               
               mBottomBarLayer.addChild ( TextFieldEx.CreateTextField (infoText, true, 0xDDDDDD));
            }
            
            mBottomBarLayer.x = (Define.WorldWidth - mBottomBarLayer.width) * 0.5;
            mBottomBarLayer.y = Define.WorldHeight - mBottomBarLayer.height - 2;
         }
      }
      
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
                  infoText = infoText + "<font face='Verdana' size='15'>This puzzle in created by <b><i>" + authorName + "</i></b></font>.";
               else
                  infoText = infoText + "<font face='Verdana' size='15'>This puzzle in created by <font color='#0000FF'><b><i><u><a href='" + anthorUrl + "' target='_blank' >" + authorName + "</a></u></i></b></font>.</font>";
            }
         }
         
         if (infoText.length > 0 )
            infoText = infoText + "<br>";
         infoText = infoText + "<br><font face='Verdana' size='15'>";
         infoText = infoText + "Want to <font color='#0000FF'><u><a href='" + Define.EditorUrl + "' target='_blank'>design your own puzzles</a></u></font>?";
         infoText = infoText + "</font>";
         
         mTextAuthorInfo = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, 0x0);
         
         mFinishedDialog = CreateDialog ([mTextFinished, 20, mTextAuthorInfo, 20, buttonContainer]);
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
      
      private var mTextTutorial:TextFieldEx;
      private var mButtonCloseHelpDialog:TextButton;
      
      private var mBox2dText:TextFieldEx;
      
      private function CreateHelpDialog ():void
      {
         var tutorialText:String = 
            "<font size='15' face='Verdana' color='#000000'>The goal of <b>Color Infection</b> puzzles is to infect all <font color='#FFFF00'><b>YELLOW</b></font> objects with "
                        + "the <font color='#804000'><b>BROWN</b></font> color by colliding them with <font color='#804000'><b>BROWN</b></font> objects "
                        + "but keep all <font color='#60FF60'><b>GREEN</b></font> objects uninfected."
                        + "<br /><br />To play, click a <font color='#FF00FF'><b>PINK</b></font> object to destroy it.</font>";
         
         mTextTutorial = TextFieldEx.CreateTextField (tutorialText, false, 0xFFFFFF, 0x0, true, Define.WorldWidth / 2);
         
         var box2dText:String =  "<font size='10' face='Verdana' color='#000000'>(This player is based on Box2d physics engine (AS3).)</font>";
         mBox2dText = TextFieldEx.CreateTextField (box2dText);
         
         mButtonCloseHelpDialog = new TextButton ("<font face='Verdana' size='16' color='#0000FF'>   Close   </font>", CloseHelpDialog);
         
         mHelpDialog = CreateDialog ([mTextTutorial, 20 ,mBox2dText, 20, mButtonCloseHelpDialog]);
         mHelpDialog.visible = false;
         
         mDialogLayer.addChild (mHelpDialog);
      }
      
      
      private function OpenHelpDialog ():void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = true;
         
         OnPause (null);
      }
      
      private function CloseHelpDialog ():void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = false;
      }
      
      private function CreateDialog (components:Array):Sprite
      {
         var dialog:Sprite = new Sprite ();
         
         var margin:int = 20;
         var dialogWidth:Number = 0;
         var dialogHeight:Number = margin;
         
         var sprite:DisplayObject;
         var i:int;
         
         for (i = 0; i < components.length; ++ i)
         {
            if (components [i] is DisplayObject)
            {
               sprite = components [i] as DisplayObject;
               
               sprite.y = dialogHeight;
               
               if (sprite.width > dialogWidth)
                  dialogWidth = sprite.width;
               dialogHeight += sprite.height;
               
               dialog.addChild (sprite);
            }
            else
            {
               dialogHeight += components [i];
            }
         }
         
         dialogHeight += margin;
         dialogWidth += margin + margin;
         
         var bg:Sprite = new Sprite ();
         GraphicsUtil.DrawRect (bg, 0, 0, dialogWidth, dialogHeight, 0x606060, 3, true, 0x8080D0);
         dialog.addChildAt (bg, 0);
         
         for (i = 0; i < components.length; ++ i)
         {
            if (components [i] is DisplayObject)
            {
               sprite = components [i] as DisplayObject;
               
               sprite.x = (dialogWidth - sprite.width) * 0.5;
            }
         }
         
         dialog.x = (Define.WorldWidth - dialog.width) * 0.5;
         dialog.y = (Define.WorldHeight - dialog.height) * 0.5;
         
         return dialog;
      }
      
      private var mButtonRestart:ImageButton;
      private var mButtonStartPause:ImageButton;
      private var mButtonHelp:ImageButton;
      private var mButtonSpeeds:Array;
      
      private static const NumButtonSpeed:int = 5;
      private static const ButtonMargin:int = 8;
      
      private function CreateUI ():void
      {
         var i:int;
         var buttonX:Number = 0;
         
         mButtonRestart = new ImageButton (null, mBitmapDataRetartDisabled);
         mTopBarLayer.addChild (mButtonRestart); 
         mButtonRestart.x = buttonX; 
         buttonX += mButtonRestart.width;
         
         mButtonStartPause = new ImageButton (OnStart, mBitmapDataStart);
         mTopBarLayer.addChild (mButtonStartPause); 
         mButtonStartPause.x = buttonX; 
         buttonX += mButtonStartPause.width - 1 + ButtonMargin;
         
         mButtonSpeeds = new Array (5);
         for (i = 0; i < NumButtonSpeed; ++ i)
         {
            mButtonSpeeds [i] = new ImageButton (OnSpeed, mBitmapDataSpeed, i);
            mTopBarLayer.addChild (mButtonSpeeds[i]); 
            mButtonSpeeds[i].x = buttonX; 
            buttonX += mButtonSpeeds[i].width - 1;
         }
         
         mButtonHelp = new ImageButton (OnHelp, mBitmapDataHelp);
         buttonX += ButtonMargin;
         mTopBarLayer.addChild (mButtonHelp); 
         mButtonHelp.x = buttonX;
         
         mTopBarLayer.x= (Define.WorldWidth - mTopBarLayer.width) * 0.5;
         mTopBarLayer.y = 2;
         
         OnSpeed (1);
      }
      
      private function OnRestart (data:Object = null):void
      {
         try
         {
            if (mPlayerWorld != null && mWorldLayer.contains (mPlayerWorld))
               mWorldLayer.removeChild (mPlayerWorld);
            
            mPlayerWorld = DataFormat2.WorldDefine2PlayerWorld (DataFormat2.HexString2WorldDefine (mWorldDataHexString));
            
            if (mPlayerWorld != null)
            {
               mPlayerWorld.Update (0, 1);
               
               mWorldLayer.addChild (mPlayerWorld);
               
               mEverFinished = false;
               
               if (mIsPlaying)
               {
                  mButtonRestart.SetBitmapData (mBitmapDataRetart);
                  mButtonRestart.SetClickEventHandler (OnRestart);
                  OnStart (null);
               }
               else
               {
                  mButtonRestart.SetBitmapData (mBitmapDataRetartDisabled);
                  mButtonRestart.SetClickEventHandler (null);
                  OnPause (null);
               }
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
         mButtonRestart.SetBitmapData (mBitmapDataRetart);
         mButtonRestart.SetClickEventHandler (OnRestart);
         
         mIsPlaying = true;
         
         mButtonStartPause.SetBitmapData (mBitmapDataPause);
         mButtonStartPause.SetClickEventHandler (OnPause);
         
         CloseFinishedDialog ();
         CloseHelpDialog ();
      }
      
      public function OnPause (data:Object = null):void
      {
         mIsPlaying = false;
         
         mButtonStartPause.SetBitmapData (mBitmapDataStart);
         mButtonStartPause.SetClickEventHandler (OnStart);
      }
      
      private static const ButtonIndex2SpeedXTable:Array = [1, 2, 3, 4, 5];
      
      private function OnSpeed (data:Object):void
      {
         var index:int = int (data);
         if (index < 0) index = 0;
         if (index >= NumButtonSpeed) index = NumButtonSpeed - 1;
         
         for (var i:int = 0; i < NumButtonSpeed; ++ i)
         {
            if (i == index)
               mButtonSpeeds [i].SetBitmapData ( mBitmapDataSpeedSelected );
            else
               mButtonSpeeds [i].SetBitmapData ( mBitmapDataSpeed );
         }
         
         mPlayingSpeedX = ButtonIndex2SpeedXTable [index];
      }
      
      private function OnHelp(data:Object):void
      {
         OpenHelpDialog ();
      }
      
   }
}
