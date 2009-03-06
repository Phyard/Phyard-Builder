package wrapper {
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.display.LoaderInfo;
   import flash.display.Loader;
   import flash.utils.ByteArray;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   
   import packager.display.MainMenuLevelItem;
   
   public class ColorInfectionPackager extends Sprite
   {
      //[Embed(source="player_secure.swf")]
      //[Bindable]
      //public var CIPlayer:Class;
      
      [Embed(source="data.bin", mimeType="application/octet-stream")]
      private var DataBinFile:Class;
      
      //private var mLevelPlayer:Sprite = null;
      private var mLevelPlayer:ColorInfectionPlayer = null;
      
      private var mGameTitle:String = "Color Infection";
      private var mLevelsData:Array = null;
      
      private var mCurrentLevelId:int = 0;
      
      private var mBackgrounpLayer:Sprite = new Sprite ();
      private var mContentLayer:Sprite = new Sprite ();
      
      public function ColorInfectionPackager ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
         
         addChild (mBackgrounpLayer);
         addChild (mContentLayer);
      }
      
      private function OnAddedToStage (e:Event):void 
      {
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         ChangeState (StateId_InitData);
         
         GraphicsUtil.ClearAndDrawRect (mBackgrounpLayer, 0, 0, App::Default_Width, App::Default_Height, 0x0, 0, true, 0x0);
         GraphicsUtil.DrawLine (mBackgrounpLayer, 0, 0, 100, 100);
      }
      
      private function OnEnterFrame (event:Event):void 
      {
         Update ();
      }
      
//======================================================================
//
//======================================================================
      
      private static var _stateId:int = -1;
      private static const StateId_None:int = _stateId ++;
      private static const StateId_InitData:int = _stateId ++;
      private static const StateId_InitDataError:int = _stateId ++;
      private static const StateId_Startup:int = _stateId ++;
      private static const StateId_MainMenuIn:int = _stateId ++;
      private static const StateId_MainMenu:int = _stateId ++;
      private static const StateId_MainMenuOut:int = _stateId ++;
      private static const StateId_LevelIn:int = _stateId ++;
      private static const StateId_Level:int = _stateId ++;
      private static const StateId_LevelOut:int = _stateId ++;
      
      private var mStateId:int = StateId_None;
      
      public function Update ():void
      {
         switch (mStateId)
         {
            case StateId_InitData:
            {
               if (InitializeLevelsData ())
                  ChangeState (StateId_Startup);
               else
                  ChangeState (StateId_InitDataError);
               
               break;
            }
            case StateId_MainMenu:
            {
               break;
            }
            case StateId_Level:
            {
               UpdateLevel ();
               
               break;
            }
            default:
               break;
         }
      }
      
      public function ChangeState (newStateId:int):void
      {
         while (mContentLayer.numChildren > 0)
            mContentLayer.removeChildAt (0);
         
         switch (newStateId)
         {
            case StateId_InitDataError:
               CreateInitDataErrorScreen ();
               
               break;
            case StateId_Startup:
               CreateStartupScreen ();
               
               break;
            case StateId_MainMenu:
               CreateMainMenu ();
               
               break;
            case StateId_Level:
               CreateLevel ();
               
               break;
            default:
               break;
         }
         
         mStateId = newStateId;
      }
      
//======================================================================
//
//======================================================================
      
      private function InitializeLevelsData ():Boolean
      {
         var dataFile:ByteArray = new DataBinFile ();
         
         mGameTitle = dataFile.readUTF ();
         
         var numLevels:int = dataFile.readInt ();
         
         var levelDataOffsets:Array = new Array (numLevels);
         var levelDataLengths:Array = new Array (numLevels);
         
         mLevelsData = new Array (numLevels);
         
         var levelId:int;
         for (levelId = 0; levelId < numLevels; ++ levelId)
         {
            levelDataOffsets [levelId] = dataFile.readInt ();
            levelDataLengths [levelId] = dataFile.readInt () - levelDataOffsets [levelId];
         }
         
         for (levelId = 0; levelId < numLevels; ++ levelId)
         {
            var levelPlayCode:ByteArray = new ByteArray ();
            dataFile.position = levelDataOffsets [levelId];
            dataFile.readBytes (levelPlayCode, 0, levelDataLengths [levelId]);
            
            var levelData:Object = new Object ();
            levelData.mPlayCode = levelPlayCode;
            levelData.mIsFinished = false;
            levelData.mIsLocked = false;
            mLevelsData [levelId] = levelData;
         }
         
         return true;
      }
      
      private function CreateInitDataErrorScreen ():void
      {
         var errorText:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText ("Failed to initialize.", 16, "#FFFF00"));
         errorText.x = (App::Default_Width  - errorText.width ) * 0.5;
         errorText.y = (App::Default_Height - errorText.height) * 0.5;
         mContentLayer.addChild (errorText);
      }
      
      private function CreateStartupScreen ():void
      {
         var buttonText:String = TextUtil.CreateHtmlText ("Play");
         
         var playButton:TextButton = new TextButton (buttonText, OnClickPlayButton, 0xCCFFCC, 0xCCCCFF);
         
         playButton.x = (App::Default_Width - playButton.width) / 2;
         playButton.y = (App::Default_Height - playButton.height) / 2;
         mContentLayer.addChild (playButton);
      }
      
      private function OnClickPlayButton ():void
      {
         ChangeState (StateId_MainMenu);
      }
      
      private function CreateMainMenu ():void
      {
         var titleText:String = "<font size='30' face='Verdana' color='#8080FF'> <b>" + mGameTitle + "</b></font>";
         var titleTextField:TextFieldEx = TextFieldEx.CreateTextField (titleText, false, 0x0, 0x8080FF, false);
         
         titleTextField.x = ( App::Default_Width - titleTextField.width ) / 2;
         titleTextField.y = 20;
         mContentLayer.addChild(titleTextField);
         
         var linePosY1:int = titleTextField.y + titleTextField.height + 20;
         DrawSeperatorLine (linePosY1);
         
         if (mLevelsData != null)
         {
            var levelsCount:int = mLevelsData.length;
            
            var maxCols:uint = 10;
            
            var cols:uint = levelsCount > maxCols ? maxCols : levelsCount;
            var rows:uint = (levelsCount + maxCols - 1) / maxCols;
            
            var blockWidth:uint = 30;
            var blockHeight:uint = 30;
            
            var blockGapX:uint = 6;
            var blockGapY:uint = 6;
            
            var startX:int = ( App::Default_Width - (cols * blockWidth + (cols - 1) * blockGapX) ) / 2;
            var startY:int = linePosY1 + 20;
            
            var row:uint = 0;
            var col:uint = 0;
            var bx:int = startX;
            var by:int = startY
            
            for (var levelID:uint = 0; levelID < levelsCount; ++ levelID)
            {
               var levelData:Object = mLevelsData [levelID];
               
               var menuItem:MainMenuLevelItem = new MainMenuLevelItem (levelID + 1, levelData.mIsFinished, levelData.mIsLocked, blockWidth, blockHeight);
               if ( ! levelData.mIsLocked )
                  menuItem.addEventListener( MouseEvent.CLICK, OnClickLevelMenuItem);
               
               menuItem.x = bx;
               menuItem.y = by;
               
               mContentLayer.addChild(menuItem);
               
               ++ col;
               bx += blockWidth + blockGapX;
               
               if (col >= maxCols)
               {
                  col = 0;
                  bx = startX;
                  
                  ++ row;
                  by += blockHeight + blockGapY;
               }
            }
            
            if (col != 0)
            {
               by += blockHeight + 20;
            }
            else
            {
               by += -6 + 20;
            }
         }
         
         var linePosY2:int = by;
         DrawSeperatorLine (linePosY2);
            
         var moreButton:TextButton = new TextButton ("<font size='12' face='Verdana' color='#0000FF'>Want to Design Your Own Levels?</font>", OnClickDesignLevels, 0xCCFFCC, 0xCCCCFF);
         moreButton.x = ( App::Default_Width - moreButton.width ) / 2;
         moreButton.y = linePosY2 + 20;
         mContentLayer.addChild(moreButton);
         
         var linePosY3:int = moreButton.y + moreButton.height + 20;
         DrawSeperatorLine (linePosY3);
         
      }
      
      private function OnClickLevelMenuItem (event:MouseEvent):void
      {
         mCurrentLevelId = (event.target as MainMenuLevelItem).GetLevelIndex () - 1;
         ChangeState (StateId_Level);
      }
      
      private function OnClickDesignLevels ():void
      {
         UrlUtil.PopupPage ("http://colorinfection.appspot.com/htmls/editor_page1.html");
      }
      
      private function CreateLevel ():void
      {
         var errorText:String = null;
         
         if (mLevelsData == null)
            errorText = "Failed to initialize.";
         else if (mCurrentLevelId < 0 || mCurrentLevelId >= mLevelsData.length)
            errorText = "Level ID is out of range.";
         else if (mLevelsData [mCurrentLevelId] == null)
            errorText = "No data for level #" + mCurrentLevelId + ".";
         else
         {
            var options:Object = new Object ();
            options.mWorldPlayCode = mLevelsData [mCurrentLevelId].mPlayCode;
            options.mBuildContextMenu = false;
            options.mMainMenuCallback = OnBackToMainMenuFromLevel;
            
            //mLevelPlayer = new CIPlayer () as Sprite;
            //(mLevelPlayer as Object).SetOptions (options);
            
            mLevelPlayer = new ColorInfectionPlayer ();
            mLevelPlayer.SetOptions (options);
            
            mContentLayer.addChild (mLevelPlayer);
         }
         
         if (errorText != null)
         {
            var errorTextField:TextFieldEx = TextFieldEx.CreateTextField (TextUtil.CreateHtmlText (errorText, 16, "#FFFF00"));
            errorTextField.x = (App::Default_Width  - errorTextField.width ) * 0.5;
            errorTextField.y = (App::Default_Height - errorTextField.height) * 0.5;
            mContentLayer.addChild (errorTextField);
            
            var backText:String = TextUtil.CreateHtmlText ("Back to Main Menu");
            var backButton:TextButton = new TextButton (backText, OnBackToMainMenuFromLevel);
            backButton.x = (App::Default_Width - backButton.width) * 0.5;
            backButton.y = (App::Default_Height - backButton.height) * 0.5 + App::Default_Height * 0.25;
            mContentLayer.addChild (backButton);
         }
      }
      
      private function OnBackToMainMenuFromLevel (data:Object = null):void
      {
         ChangeState (StateId_MainMenu);
      }
      
      private function UpdateLevel ():void
      {
      }
      
//======================================================================
//
//======================================================================
      
      private function DrawSeperatorLine (posY:int):void
      {
         var margin:int = 50;
         GraphicsUtil.DrawLine (mContentLayer, margin, posY, App::Default_Width - margin, posY, 0x0000FF, 1);
      }
      
      
      
   }
}