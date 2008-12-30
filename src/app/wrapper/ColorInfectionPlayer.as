
package wrapper {

   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.display.LoaderInfo;
   
   import flash.events.Event;
   
   import com.tapirgames.display.FpsCounter;
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   
   import player.world.World;
   
   import common.DataFormat2;
   import common.Define;
   import common.WorldDefine;;
   
   public dynamic class ColorInfectionPlayer extends Sprite 
   {
      
      private var mWorldLayer:Sprite = new Sprite ();
      private var mUiLayer:Sprite = new Sprite ();
      private var mFinishedTextLayer:Sprite = new Sprite ();
      private var mDialogLayer:Sprite = new Sprite ();
      
         private var mHelpDialog:Sprite;
         private var mFinishedDialog:Sprite;
      
      private var mWorldDefine:WorldDefine = null;
      private var mPlayerWorld:World = null;
      
      private var mIsPlaying:Boolean = false;
      private var mPlayingSpeedX:int = 2;
      
      public function ColorInfectionPlayer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
         
         addChild (mWorldLayer);
         addChild (mUiLayer);
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
      
      public function Update ():void
      {
      // ...
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
      // ...
         if (mStateId == StateId_Load)
         {
            ParseParams ();
            
            while (mWorldLayer.numChildren > 0)
               mWorldLayer.removeChildAt (0);
            
            if (mWorldDefine == null)
            {
               var errorText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Fail to parse play code."));
               errorText.x = (Define.WorldWidth  - errorText.width ) * 0.5;
               errorText.y = (Define.WorldHeight - errorText.height) * 0.5;
               mWorldLayer.addChild (errorText);
               
               var linkText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("<font size='8' color='#0000ff'><u><a href='http://www.colorinfection.com'>ColorInfection.com</a></u></font>"));
               linkText.x = (Define.WorldWidth  - linkText.width ) * 0.5;
               linkText.y = Define.WorldHeight - linkText.height;
               mWorldLayer.addChild (linkText);
               ChangeState (StateId_None);
               return;
            }
            
            
            CreateUI ();
            
            OnRestart ();
            
            CreateHelpDialog ();
            OpenHelpDialog ();
            
            CreateFinishedDialog ();
            
            
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
      
      private function ParseParams ():void
      {
         try 
         {
            var loadInfo:LoaderInfo = LoaderInfo(root.loaderInfo);
            
            var flashVars:Object = loaderInfo.parameters;
            
            if (flashVars != null)
            {
               var keyStr:String;
               var valueStr:String;
               for (keyStr in flashVars) 
               {
                  valueStr = String(flashVars[keyStr]);
                  
                  trace (keyStr + "=" + valueStr);
                  
                  if (keyStr == "playcode")
                  {
                     mWorldDefine = DataFormat2.HexString2WorldDefine (valueStr);
                  }
               }
            }
         } 
         catch (error:Error) 
         {
             trace ("flash vars error." + error);
         }
      }
      
      
      private var mTextFinished:TextFieldEx;
      private var mTextAuthorInfo:TextFieldEx;
      private var mButtonReplay:TextButton;
      
      private function CreateFinishedDialog ():void
      {
         var finishedText:String = "<font size='30' face='Verdana' color='#000000'> <b>Cool! It is solved.</b></font>";
         mTextFinished = TextFieldEx.CreateTextField (finishedText, false, 0xFFFFFF, 0x0, false);
         
         mButtonReplay = new TextButton ("<font size='30' face='Verdana' color='#0000FF'>   Replay   </font>", OnRestart);
         
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
                  infoText = infoText + "<font face='Verdana' size='15'>This puzzle in created by <b><i>" + authorName + "</i></b></font>";
               else
                  infoText = infoText + "<font face='Verdana' size='15'>This puzzle in created by <font color='#0000FF'><b><i><u><a href='" + anthorUrl + "' target='_blank' >" + authorName + "</a></u></i></b></font>.</font>";
            }
         }
            
         infoText = infoText + "<font face='Verdana' size='15'> Want to <font color='#0000FF'><u><a href='http://www.colorinfection.com' target='_blank'>design your own puzzles</a></u></font>?</font>";
         
         mTextAuthorInfo = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, 0x0, true);
         
         mFinishedDialog = CreateDialog ([mTextFinished, 20, mTextAuthorInfo, 20, mButtonReplay]);
         mFinishedDialog.visible = false;
         mFinishedDialog.alpha = 0.9;
         
         mFinishedTextLayer.addChild (mFinishedDialog);
      }
      
      private function OpenFinishedDialog ():void
      {
         if (mFinishedDialog != null)
         {
            mFinishedDialog.visible = true;
            
            mFinishedDialog.alpha += 0.025;
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
      
      private function CreateHelpDialog ():void
      {
         var tutorialText:String = 
            "<font size='15' face='Verdana' color='#000000'>The goal of <b>Color Infection</b> puzzles is to infect all <font color='#FFFF00'><b>YELLOW</b></font> objects with "
                        + "the <font color='#804000'><b>BROWN</b></font> color by colliding them with <font color='#804000'><b>BROWN</b></font> objects "
                        + "but keep all <font color='#60FF60'><b>GREEN</b></font> objects uninfected."
                        + "<br /><br />To play, click a <font color='#FF00FF'><b>PINK</b></font> object to destroy it.</font>";
         
         mTextTutorial = TextFieldEx.CreateTextField (tutorialText, false, 0xFFFFFF, 0x0, true, Define.WorldWidth / 2);
         
         mButtonCloseHelpDialog = new TextButton ("<font face='Verdana' size='16' color='#0000FF'>   Close   </font>", CloseHelpDialog);
         
         mHelpDialog = CreateDialog ([mTextTutorial, 20, mButtonCloseHelpDialog]);
         mHelpDialog.visible = false;
         
         mDialogLayer.addChild (mHelpDialog);
      }
      
      
      private function OpenHelpDialog ():void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = true;
         
         mIsPlaying = false;
      }
      
      private function CloseHelpDialog ():void
      {
         if (mHelpDialog != null)
            mHelpDialog.visible = false;
         
         mIsPlaying = true;
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
      
      private var mButtonRestart:TextButton;
      private var mButtonSlow:TextButton;
      private var mButtonNormal:TextButton;
      private var mButtonSpeedy:TextButton;
      private var mButtonHelp:TextButton;
      
      private function CreateUI ():void
      {
         mButtonRestart = new TextButton ("<font face='Verdana' size='10' color='#0000FF'>Restart</font>", OnRestart);
         mButtonSlow = new TextButton ("<font face='Verdana' size='10' color='#0000FF'>Slow</font>", OnSlow);
         mButtonNormal = new TextButton ("<font face='Verdana' size='10' color='#0000FF'>Normal</font>", OnNormal);
         mButtonSpeedy = new TextButton ("<font face='Verdana' size='10' color='#0000FF'>Speedy</font>", OnSpeedy);
         mButtonHelp = new TextButton ("<font face='Verdana' size='10' color='#0000FF'>Help (?)</font>", OnHelp);
         
         mUiLayer.addChild (mButtonRestart);
         mUiLayer.addChild (mButtonSlow); mButtonSlow.x = mButtonRestart.x + mButtonRestart.width + 2;
         mUiLayer.addChild (mButtonNormal); mButtonNormal.x = mButtonSlow.x + mButtonSlow.width;
         mUiLayer.addChild (mButtonSpeedy); mButtonSpeedy.x = mButtonNormal.x + mButtonNormal.width;
         mUiLayer.addChild (mButtonHelp); mButtonHelp.x = mButtonSpeedy.x + mButtonSpeedy.width + 2;
         
         var dialogWidth:Number = mUiLayer.width;
         var bg:Sprite = new Sprite ();
         var radius:int = 5;
         bg.graphics.beginFill(Define.ColorStaticObject);
         bg.graphics.lineStyle(1, Define.ColorStaticObject);
         bg.graphics.drawRoundRect(- radius, 0, mUiLayer.width + radius + radius,  mUiLayer.height + radius, radius, radius);
         bg.graphics.endFill();
         mUiLayer.addChildAt (bg, 0);
         
         mUiLayer.x= (Define.WorldWidth - dialogWidth) * 0.5;
         mUiLayer.y = 2;
         
         OnNormal ();
      }
      
      private function OnRestart ():void
      {
         if (mPlayerWorld != null && mWorldLayer.contains (mPlayerWorld))
            mWorldLayer.removeChild (mPlayerWorld);
         
         mPlayerWorld = DataFormat2.WorldDefine2PlayerWorld (mWorldDefine);
         
         if (mPlayerWorld != null)
         {
            mPlayerWorld.Update (0, 1);
            mIsPlaying = true;
            
            mWorldLayer.addChild (mPlayerWorld);
         }
         
         CloseFinishedDialog ();
         CloseHelpDialog ();
      }
      
      private function OnNormal ():void
      {
         mPlayingSpeedX = 2;
         
         mButtonNormal.SetSelected (true);
         mButtonSlow.SetSelected (false);
         mButtonSpeedy.SetSelected (false);
      }
      
      private function OnSpeedy ():void
      {
         mPlayingSpeedX = 6;
         
         mButtonNormal.SetSelected (false);
         mButtonSlow.SetSelected (false);
         mButtonSpeedy.SetSelected (true);
      }
      
      private function OnSlow ():void
      {
         mPlayingSpeedX = 1;
         
         mButtonNormal.SetSelected (false);
         mButtonSlow.SetSelected (true);
         mButtonSpeedy.SetSelected (false);
      }
      
      private function OnHelp():void
      {
         OpenHelpDialog ();
      }
      
   }
}
