package editor.entity.dialog {

   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.geom.Point;
   
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import mx.core.UIComponent;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   
   import viewer.Viewer;
   
   import player.world.World;
   
   import common.DataFormat3;
   
   import common.MultiplePlayerDefine;
   import common.Define;
   
   public class ScenePlayPanel extends UIComponent
   {
      private var mBackgroundLayer:Sprite = new Sprite ();
      
      public function ScenePlayPanel ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         addChild (mBackgroundLayer);
      }
      
//============================================================================
//   
//============================================================================
      
      private var mDialogCallbacks:Object = null; // must not be null
      
      public function SetDialogCallbacks (callbacks:Object):void
      {
         mDialogCallbacks = callbacks;
      }
      
      //private var mDesignViewer:Viewer = null;
      
      private var mViewerParamsFromEditor:Object = null;
      
      private var mRestoreValues:Object = null;
      
      public function SetWorldViewerParams (worldBinaryData:ByteArray, currentSceneId:int, maskFieldInPlaying:Boolean, surroudingBackgroundColor:uint, callbackStopPlaying:Function):void
      {
         /*
         mDesignViewer = new Viewer ({mParamsFromEditor: {
                                         mWorldDomain: ApplicationDomain.currentDomain,  
                                         mWorldBinaryData: worldBinaryData, 
                                         mCurrentSceneId: currentSceneId, 
                                         GetViewportSize: GetViewportSize, 
                                         mStartRightNow: true, 
                                         mMaskViewerField: maskFieldInPlaying, 
                                         mBackgroundColor: surroudingBackgroundColor, 
                                         OnExitLevel: callbackStopPlaying, 
                                         
                                         //>> websocket
                                         OnClientMessagesToMultiplePlayerSchedulerServer: OnClientMessagesToMultiplePlayerSchedulerServer,
                                         OnSendClientMessagesToMultiplePlayerInstanceServer : OnSendClientMessagesToMultiplePlayerInstanceServer
                                         //<<
                                      }
                             });
         
         addChild (mDesignViewer);
         
         mDesignViewer.OnContainerResized ();
         */
         
         if (mRestoreValues == null)
            mRestoreValues = new Object ();
         mRestoreValues.mRenderQuality = stage.quality;
         
         mViewerParamsFromEditor = {mParamsFromEditor: {
                                         mWorldDomain: ApplicationDomain.currentDomain,  
                                         mWorldBinaryData: worldBinaryData, 
                                         mCurrentSceneId: currentSceneId, 
                                         GetViewportSize: GetViewportSize, 
                                         mStartRightNow: true, 
                                         mMaskViewerField: maskFieldInPlaying, 
                                         mBackgroundColor: surroudingBackgroundColor, 
                                         OnExitLevel: callbackStopPlaying, 
                                         
                                         //>> websocket
                                         EmbedCallContainer: EmbedCallContainer
                                         //<<
                                       }
                                    };
         
         SetNumMultiplePlayers (1);
      }
      
      public function CloseAllViewers ():void
      {
         //if (mDesignViewer != null)
         //{
         //   mDesignViewer.Destroy ();
         //   removeChild (mDesignViewer);
         //   mDesignViewer = null;
         //}
         
         SetNumMultiplePlayers (0);
         
         mDialogCallbacks = null;
         
         mViewerParamsFromEditor = null;
         
         if (mRestoreValues != null)
         {
            stage.quality = mRestoreValues.mRenderQuality;
         }
      }
      
      public function OnSelectMultiplePlayerIndex (index:int):void
      {
         SetCurrentMultiplePlayerIndex (index);
      }
      
      private function GetViewportSize ():Point
      {
         return new Point (mContentMaskWidth, mContentMaskHeight);
      }
      
//========================================================================================
// !!! 
//========================================================================================
      
      import player.WorldPlugin;
      
      private function Dummy ():void
      {
         new WorldPlugin (); // to make mxmlc include WorldPlugin, so the all player.* package, ...
      }

//============================================================================
//   
//============================================================================
      
      private var mFirstTimeAddTiStage:Boolean = true;
      
      private function OnAddedToStage (event:Event):void 
      {
         UpdateBackgroundAndContentMaskSprites ();
         
         // ...
         if (mFirstTimeAddTiStage)
         {
            mFirstTimeAddTiStage = false;
            
            addEventListener (Event.ENTER_FRAME, OnEnterFrame);
            
            addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
            addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
            addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
            
            addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
         }
      }
      
      private function OnEnterFrame (event:Event):void 
      {
         // before v2.04
         //if (mDesignViewer != null)
         //   stage.focus = this;
         
         // since v2.04
         //if (mDesignViewer != null)
         // sicne v2.06
         if (GetCurrentViewer () != null)
         {
            var io:InteractiveObject = stage.focus; // may be an editable text field
            while (io != this && io != null)
            {
               io = io.parent;
            }
            if (io != this)
            {
               stage.focus = this;
            }
         }
         
         UpdateSimulatedServers ();
         
         UpdateInterface ();
      }
      
      private function OnResize (event:Event):void
      {
         UpdateBackgroundAndContentMaskSprites ();
      }
      
      private var mContentMaskSprite:Shape = null;
      private var mContentMaskWidth :Number = 0;
      private var mContentMaskHeight:Number = 0;
      
      protected function UpdateBackgroundAndContentMaskSprites ():void
      {
         if (parent.width != mContentMaskWidth || parent.height != mContentMaskHeight)
         {
            mContentMaskWidth  = parent.width;
            mContentMaskHeight = parent.height;
            
            if (mContentMaskSprite == null)
            {
               mContentMaskSprite = new Shape ();
               addChild (mContentMaskSprite);
               mask = mContentMaskSprite;
            }
            
            GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true, 0xFFFFFF);
            GraphicsUtil.ClearAndDrawRect (mContentMaskSprite, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true);
            
            //if (mDesignViewer != null)
            //{
            //   mDesignViewer.OnContainerResized ();
            //}
            
            var designViewer:Viewer = GetCurrentViewer ();
            if (designViewer != null)
            {
               designViewer.OnContainerResized ();
            }
         }
      }
      
      private static function TraceError (error:Error):void
      {
         if (Capabilities.isDebugger)
         {
            trace (error.getStackTrace ());
            throw error;
         }
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         OnMousePositionChanged ();
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         OnMousePositionChanged ();
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         OnMousePositionChanged ();
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         //switch (event.keyCode)
         //{
         //   case 70: // F
         //   case Keyboard.SPACE:
         //      if (event.ctrlKey || event.shiftKey)
         //         AdvanceOneFrame (); 
         //      
         //      break;
         //   default:
         //      break;
         //}
         
         //event.stopPropagation (); // will cause Keyboard events not triggered in playing
      }
      
//============================================================================
//   
//============================================================================
      
      public function UpdateInterface ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.UpdateInterface == null)
            return;
         
         var designViewer:Viewer = GetCurrentViewer ();
         
         if (/*mDesignViewer*/designViewer == null)
         {
            mDialogCallbacks.UpdateInterface (null);
            return;
         }
         
         var viewerStatusInfo:Object = new Object ();
         
         var playerWorld:World = /*mDesignViewer*/designViewer.GetPlayerWorld () as World;
         
         viewerStatusInfo.mSpeedX = /*mDesignViewer*/designViewer.GetPlayingSpeedX ();
         viewerStatusInfo.mIsPlaying = /*mDesignViewer*/designViewer.IsPlaying ();
         viewerStatusInfo.mCurrentSimulationStep = playerWorld == null ? 0 : playerWorld.GetSimulatedSteps ();
         viewerStatusInfo.mFPS = /*mDesignViewer*/designViewer.GetFPS ();
         viewerStatusInfo.mShowPlayBar = /*mDesignViewer*/designViewer.IsShowPlayBar ();
         
         mDialogCallbacks.UpdateInterface (viewerStatusInfo);
      }
      
      protected function OnMousePositionChanged ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.SetMousePosition == null)
            return;
         
         var designViewer:Viewer = GetCurrentViewer ();
         
         if (/*mDesignViewer*/designViewer == null)
         {
            mDialogCallbacks.SetMousePosition (null);
            return;
         }
         
         var playerWorld:World = /*mDesignViewer*/designViewer.GetPlayerWorld () as World;
         
         if (playerWorld == null)
         {
            mDialogCallbacks.SetMousePosition (null);
            return;
         }
         
         var mousePositionInfo:Object = new Object ();
         mousePositionInfo.mPixelX = playerWorld.mouseX;
         mousePositionInfo.mPixelY = playerWorld.mouseY;
         mousePositionInfo.mPhysicsX = playerWorld.GetCoordinateSystem ().D2P_PositionX (playerWorld.mouseX);
         mousePositionInfo.mPhysicsY = playerWorld.GetCoordinateSystem ().D2P_PositionY (playerWorld.mouseY);
         
         mDialogCallbacks.SetMousePosition (mousePositionInfo);
      }
      
      private var mMaskViewport:Boolean = false;
      
      public function IsMaskViewport ():Boolean
      {
         return mMaskViewport;
      }
      
      public function SetMaskViewport (mask:Boolean):void
      {
         mMaskViewport = mask;
         
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().SetMaskViewerField (mMaskViewport);
         }
      }
      
      public function SimulateSystemBack ():void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null && /*mDesignViewer*/GetCurrentViewer ().OnBackKeyDown != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().OnBackKeyDown ();
         }
      }
      
      public function Restart ():void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().PlayRestart ();
         }
      }
      
      public function ChangePlayingStatus (playing:Boolean):void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().ResumeOrPause (playing);
         }
      }
      
      public function ChangeSpeedX (deltaSpeedX:int):void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().ChangeSpeedX (deltaSpeedX);
         }
      }
      
      public function AdvanceOneFrame ():void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().UpdateSingleFrame ();
         }
      }
      
      public function ClearGameSaveData (soFilename:String):void
      {
         Viewer.ClearCookie (soFilename);
      }
      
//============================================================================
//   fake players
//============================================================================
      
      public static const MaxNumMultiplePlayers:int = 4;
      
      protected var mMultiplePlayerViewers:Array = new Array (MaxNumMultiplePlayers);
      protected var mNumMultiplePlayers:int = 0;
      protected var mCurrentMutiplePlayerIndex:int = -1;
      
      protected function SetNumMultiplePlayers (num:int):void
      {
         if (num < 0)
            num = 0;
         if (num > MaxNumMultiplePlayers)
            num = MaxNumMultiplePlayers;
            
         if (mCurrentMutiplePlayerIndex >= num)
            SetCurrentMultiplePlayerIndex (-1);
         
         var i:int;
         var designViewer:Viewer;
         
         if (mNumMultiplePlayers > num)
         {
            for (i = mNumMultiplePlayers - 1; i >= num; -- i)
            {
               designViewer = mMultiplePlayerViewers [i] as Viewer;
               designViewer.Destroy (i == 0);
               removeChild (designViewer);
            }
         }
         else if (mNumMultiplePlayers < num)
         {
            for (i = mNumMultiplePlayers; i < num; ++ i)
            {
               designViewer = new Viewer (mViewerParamsFromEditor);
               designViewer.SetActive (false);
               mMultiplePlayerViewers [i] = designViewer;
               addChild (designViewer);
            }
         }
         
         mNumMultiplePlayers = num;
            
         if (mCurrentMutiplePlayerIndex < 0 && num > 0)
            SetCurrentMultiplePlayerIndex (0);
         
         if (mDialogCallbacks != null && mDialogCallbacks.SetNumMultiplePlayers != null)
         {
            mDialogCallbacks.SetNumMultiplePlayers (mNumMultiplePlayers, mCurrentMutiplePlayerIndex);
         }
      }
      
      protected function SetCurrentMultiplePlayerIndex (index:int):void
      {
         if (index < 0 || index >= mNumMultiplePlayers)
            index = -1;
         
         if (mCurrentMutiplePlayerIndex != index)
         {
            var designViewer:Viewer;
            
            if (mCurrentMutiplePlayerIndex >= 0)
            {
               designViewer = mMultiplePlayerViewers [mCurrentMutiplePlayerIndex] as Viewer;
               designViewer.SetActive (false);
               //removeChild (designViewer);
            }
            
            mCurrentMutiplePlayerIndex = index;
            
            if (mCurrentMutiplePlayerIndex >= 0)
            {
               designViewer = mMultiplePlayerViewers [mCurrentMutiplePlayerIndex] as Viewer;
               designViewer.SetActive (true);
               //addChild (designViewer);
               designViewer.OnContainerResized ();
            }
         }
      }
      
      protected function GetCurrentViewer ():Viewer
      {
         return mMultiplePlayerViewers [mCurrentMutiplePlayerIndex] as Viewer;
      }
      
//============================================================================
//   simulated servers
//============================================================================
      
      private var mCurrentInstance:Object = null;
      
      private var mHeadCachedMessagesInfo:Object = null;
      
      private var mMessagesSendingTimer:int = 0;
      
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function UpdateSimulatedServers ():void
      {
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if (mHeadCachedMessages != null)
         {
            ++ mMessagesSendingTimer;
            if (mMessagesSendingTimer >= 16)
            {
               mMessagesSendingTimer = 0;
               
               SendMultiplePlayerServerMessages (mHeadCachedMessages.mMessagesData, mHeadCachedMessages.mTargetViewers);
               
               mHeadCachedMessages = mHeadCachedMessages.mNextCachedMessagesInfo;
            }
         }
         
         if (mCurrentInstance != null)
         {
            UpdateInstance (mStepTimeSpan.GetLastSpan ());
         }
      }
      
      // 
      private function SendMultiplePlayerServerMessages (messagesData:ByteArray, designViewers:Array):void
      {
         for each (var designerViewer:Viewer in designViewers)
         {
            if (designViewer != null)
            {
               designViewer.OnMultiplePlayerServerMessages (messagesData);
            }
         }
      }
      
      //
      private function CreateNewCachedMessagesInfo (messagesData:ByteArray, targetViewers:Array):void
      {
         messagesData.position = 0;
         mHeadCachedMessagesInfo = {mMessagesData: messagesData, mTargetViewers: targetViewers, mNextCachedMessagesInfo: mHeadCachedMessagesInfo};
      }
      
//============================================================================
//   
//============================================================================
      
      private var mPosOfNumMessagesInHeader:int = -1;
      
      private function WriteMultiplePlayerMessagesHeader (serverMessagesData:ByteArray, numMessages:int):void
      {
         if ((serverMessagesData == null)
            return;
         
         serverMessagesData.position = 0;
         
         serverMessagesData.writeShort (MultiplePlayerDefine.MessageDataFormatVersion);
         serverMessagesData.writeInt (messagesData.length); // the whole length 
         
         mPosOfNumMessagesInHeader = serverMessagesData.position;
         serverMessagesData.writeShort (numMessages);
      }
      
      private function UpdateSeatMessagesHeader (iSeat:int):void
      {
         if (mCurrentInstance != null)
         {
            var messagesData:ByteArray = mCurrentInstance.mSeatsMessagesDataToSend [iSeat];
            
            if (messagesData == null)
            {
               messagesData = new ByteArray ();
               mCurrentInstance.mSeatsMessagesDataToSend [iSeat] = messagesData;
            }
            
            if (messagesData.length == 0)
               WriteMultiplePlayerMessagesHeader (messagesData, 0);
            else
            {
               var backupPos:int = messagesData.length;
               
               messagesData.position = mPosOfNumMessagesInHeader;
               var numMessages:int = messagesData.readShort () + 1;
               
               messagesData.position = 0;
               WriteMultiplePlayerMessagesHeader (messagesData, numMessages);
               
               messagesData.position = backupPos;
            }
         }
      }
      
//============================================================================
//   
//============================================================================
      
      private function UpdateInstance (dt:Number):void
      {  
         var numSeats:int = mCurrentInstance.mNumSeats;
         var iSeat:int;
         
         for (iSeat = 0; iSeat < numSeats; ++ iSeat)
         {
            mCurrentInstance.mSeatsIdleTime [iSeat] += dt;
         }
         
         // ...
         
         var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
         
         var timer:int = getTimer ();
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
            var channel:Object = mCurrentInstance.mChannels [channelIndex];
            var channemTurnTimeout:int = channel.mTurnTimeoutSecondsX8 * 1000 / 8;
            
            for (iSeat = 0; iSeat < numSeats; ++ iSeat)
            {
               if (channel.mIsSeatsEnabled [iSeat] == true)
               {
                  if ( (timer - channel.mSeatsLastEnableTime [iSeat]) > channemTurnTimeout)
                  {
                     // pass
                  }
               }
            }
         }
      }
      
      private function CloseInstance ():void
      {
         if (mCurrentInstance != null)
         {
            mCurrentInstance.mCurrentPhase = MultiplePlayerDefine.InstancePhase_Closed;
            
            // ...
            
            var messagesData:ByteArray = new ByteArray ();
            
            WriteMultiplePlayerMessagesHeader (messagesData, 0);
            
            messagesData.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceClosed);
            messagesData.writeUTF (mCurrentInstance.mID);
            
            WriteMultiplePlayerMessagesHeader (messagesData, 1);
            
            // ...
            
            SendMultiplePlayerServerMessages (messagesData, GetInstanceViewers ());
            
            // ...
            
            ResetInstance (true);
         }
         
         mCurrentInstance = null;
      }
      
      private function ResetInstance (breakConnections:Boolean):void
      {
         if (mCurrentInstance == null)
            return;
         
         mCurrentInstance.mCurrentPhase = MultiplePlayerDefine.InstancePhase_Pending;
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {
            mCurrentInstance.mSeatsMessagesDataToSend [seatIndex] = null;
            
            if (breakConnections)
            {
               mCurrentInstance.mSeatsPlayerConnectionID [seatIndex] = null;
               mCurrentInstance.mSeatsPlayerName [seatIndex] = null;
               mCurrentInstance.mSeatsIdleTime [seatIndex] = 0;
               mCurrentInstance.mSeatsViewer [seatIndex] = null;
            }
         }
         
         var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
         var timer:int = getTimer ();
         
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
            var channel:Object = mCurrentInstance.mChannels [channelIndex];
            
            var seatDefaultEnabled:Boolean = channel.mChannelMode != MultiplePlayerDefine.InstaneChannelMode_Chess;
            
            for (var  = 0; seatIndex < numSeats; ++ seatIndex)
            {
               channel.mIsSeatsEnabled [seatIndex] = seatDefaultEnabled;
               channel.mSeatsLastEnableTime [seatIndex] = timer;
               channel.mSeatsMessage [seatIndex] = null;
            }
            
            if (channel.mChannelMode == MultiplePlayerDefine.InstaneChannelMode_Chess)
            {
               channel.mIsSeatsEnabled [Math.floor (Math.random () * numSeats)] = true;
            }
         }
      }
      
      private function CreateInstance (instanceDefine:Object, password:String):void
      {
         if (mCurrentInstance != null)
         {
            CloseInstance (mCurrentInstance);
         }
         
         // ...
         
         var numSeats:int = instanceDefine.mNumSeats;
         var enabledChannelIndexes:Array = instanceDefine.mEnabledChannelIndexes;
         
         mCurrentInstance = {
            mID : UUID.BuildRandomKey (), // "123-abc_ABC", // a Base64 string represents an int8 value.
            mInstanceDefineData : instanceDefine.mInstanceDefineData, 
            mGameID : instanceDefine.mGameID,
            mPassword : password,
            mNumSeats : instanceDefine.mNumSeats,
            
            mSessionID : UUID.BuildRandomKey (), // each new game will get a new session id, to avoid accepting old useless data.
            mCurrentPhase : MultiplePlayerDefine.InstancePhase_Pending,
            
            // ...
            
            mSeatsPlayerConnectionID : new Array (numSeats), // string
            mSeatsPlayerName : new Array (numSeats),  // string
            mSeatsIdleTime : new Array (numSeats), // int
            mSeatsViewer : new Array (numSeats), // viewer
            
            mSeatsMessagesDataToSend : new Array (numSeats); // ByteArray
            
            // ...
            
            mEnabledChannelIndexes : enabledChannelIndexes,
            mChannels : new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels), // Channel Object
                              // mChannelMode
                              // mTurnTimeoutSecondsX8
                              // mIsSeatsEnabled []
                              // mSeatsLastEnableTime []
                              // mSeatsMessage []
            
            // voting and signal will be merged into channel
            //mVotings : new Array (MultiplePlayerDefine.MaxNumberOfInstanceVotings),
            //mSignals : new Array (MultiplePlayerDefine.MaxNumberOfInstanceSignals),
            "" : null
         };
         
         // ...
         
         var numEnabledChannels:int = instanceDefine.mEnabledChannelIndexes.length;
         
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = enabledChannelIndexes [i];
            if (channelIndex >= 0 && channelIndex < MultiplePlayerDefine.MaxNumberOfInstanceChannels)
            {
               var channelDefine:Object = instanceDefine.mEnabledChannelDefines [i];
               if (channelDefine != null)
               {
                  var channel:Object = new Object ();
                  mCurrentInstance.mChannels [channelIndex] = channel;
                  
                  channel.mChannelMode = channelDefine.mChannelMode;
                  channel.mTurnTimeoutSecondsX8 = channelDefine.mTurnTimeoutSecondsX8;
         
                  channel.mIsSeatsEnabled = new Array (numSeats);
                  channel.mSeatsLastEnableTime = new Array (numSeats);
                  channel.mSeatsMessage = new Array (numSeats); // only useful for some modes
                  
                  continue;
               }
            }
            
            enabledChannelIndexes.splice (i, 1);
            -- i;
         }
         
         ResetInstance (true);
      }
      
      private function GetInstanceViewers ():Array
      {
         var numSeats:int = mCurrentInstance.mNumSeats;
         var iSeat:int;
         
         var viewers:Array = new Array (numSeats);
         
         for (iSeat = 0; iSeat < numSeats; ++ iSeat)
         {
            var aViewer:Viewer = mCurrentInstance.mSeatsViewer [iSeat] as Viewer;
            
            viewers [iSeat] = aViewer;
         }
         
         return viewers;
      }
      
      private function JoinInstance (instance:Object, password:String, playerConnectionId:String, designViewer:Viewer):void
      {
         if (mCurrentInstance == null)
            return;
         
         var viewerIndex:int = mMultiplePlayerViewers.indexOf (designViewer);
         if (viewerIndex < 0)
            return;
         
         if (playerConnectionId == null || playerConnectionId.length == 0)
            playerConnectionId = UUID.BuildRandomKey ();
         
         var seatIndex:int = mCurrentInstance.mSeatsPlayerConnectionID.indexOf (playerConnectionId);
         if (seatIndex != viewerIndex)
         {
            if (seatIndex >= 0)
            {
               mCurrentInstance.mSeatsPlayerConnectionID [seatIndex] = null;
               mCurrentInstance.mSeatsPlayerName [seatIndex] = null;
            }
            
            seatIndex = viewerIndex;
            
            mCurrentInstance.mSeatsPlayerConnectionID [seatIndex] = playerConnectionId;
            mCurrentInstance.mSeatsPlayerName [seatIndex] = "Player " + viewerIndex;
            mCurrentInstance.mSeatsIdleTime [seatIndex] = 0;
            mCurrentInstance.mSeatsViewer [seatIndex] = null; // will be confirmed in OnRegisterPlayer.
         }
         
         // ...
         
         var messagesData:ByteArray = new ByteArray ();
         WriteMultiplePlayerMessagesHeader (messagesData, 0);
         
         messagesData.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceServerInfo);
         messagesData.writeUTF ("127.0.0.1"); // host
         messagesData.writeShort (5678); // port
         messagesData.writeUTF (mCurrentInstance.mID);
         messagesData.writeUTF (playerConnectionId);
         
         WriteMultiplePlayerMessagesHeader (messagesData, 1);
         
         CreateNewCachedMessagesInfo (messagesData, [designViewer]);
      }
      
      private function OnCreateNewInstance (instanceDefine:Object, password:String, playerConnectionId:String, designViewer:Viewer):void
      {
         if (mCurrentInstance != null)
         {
            CloseInstance (mCurrentInstance);
         }
         
         CreateInstance (instanceDefine, password);
         
         JoinInstance (mCurrentInstance, password, playerConnectionId, designViewer);
      }
      
      private function OnJoinRandomInstance (instanceDefine:Object, playerConnectionId:String, designViewer:Viewer):void
      {
         if (mCurrentInstance != null && CompareByteArrays (mCurrentInstance.mInstanceDefineData, instanceDefine.mInstanceDefineData) == false)
         {
            CloseInstance (mCurrentInstance);
         }
         
         if (mCurrentInstance == null)
         {
            CreateInstance (instanceDefine, "");
         }
         
         JoinInstance (mCurrentInstance, "", playerConnectionId, designViewer);
      }
      
//============================================================================
//   
//============================================================================
      
      private function OnChannelMessage (designViewer:Viewer, messageDefine:Object):void
      {
         if (mCurrentInstance == null)
            return;
         
         if (mCurrentInstance.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing)
            return;
         
         var seatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (seatIndex < 0)
            return;
         
         var channel:Object = mCurrentInstance.mChannels [messageDefine.mChannelIndex];
         if (channel == null)
            return;
         
         if (! channel.mIsSeatsEnabled [seatIndex])
            return;
         
         var iSeat:int;
         
         switch (channel.mChannelMode)
         {
            case MultiplePlayerDefine.InstaneChannelMode_Free:
            case MultiplePlayerDefine.InstaneChannelMode_Chess:
               for (iSeat = 0; iSeat < mCurrentInstance.mNumSeats; ++ iSeat)
               {
                  
               }
               
               break;
            case MultiplePlayerDefine.InstaneChannelMode_WeGO:
               var wegoMessages:Array = channel.mSeatsMessage;
               if (wegoMessages != null && wegoMessages [seatIndex] == null)
               {
                  channel.mIsSeatsEnabled [seatIndex] = false;
                  
                  wegoMessages [seatIndex] = messageDefine.mMessageData;
                  
                  for (iSeat = 0; iSeat < mCurrentInstance.mNumSeats; ++ iSeat)
                  {
                     
                  }
               }
               
               break;
            default:
               return;
         }
      }
      
      private function SendInstaneInfo (seatIndex:int):void
      {
         if (mCurrentInstance == null)
            return;
         
         if (seatIndex < 0 || seatIndex >= mCurrentInstance.mNumSeats)
            return;
         
         var designerViewer:Viewer = mCurrentInstance.mSeatsViewer [seatIndex];
         if (designerViewer == null)
            return;
         
         // ...
         
         var messagesData:ByteArray = new ByteArray ();
         WriteMultiplePlayerMessagesHeader (messagesData, 0);
         
         messagesData.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceInfo);
         
         messagesData.writeUTF (mCurrentInstance.mID);
         
         messagesData.writeUTF (mCurrentInstance.mSessionID);
         messagesData.writeByte (mCurrentInstance.mCurrentPhase);
                  
         var numSeats:int = mCurrentInstance.mNumSeats;
         
         messagesData.writeByte (mCurrentInstance.mNumSeats);
         messagesData.writeByte (seatIndex); // my seat index
         
         var seatIndex:int;
         
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {
            messagesData.writeUTF (mCurrentInstance.mSeatsPlayerName [seatIndex]);
            messagesData.writeInt (mCurrentInstance.mSeatsIdleTime [seatIndex]);
         }
         
         messagesData.writeByte (mCurrentInstance.mEnabledChannelIndexes.length);
         
         for (var i:int = 0; i < mCurrentInstance.mEnabledChannelIndexes.length; ++ i)
         {
            var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
            var channel:Object = mCurrentInstance.mChannels [channelIndex];
            
            messagesData.writeByte (channelIndex);
            
            for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
            {
               messagesData.writeByte (channel.mIsSeatsEnabled [seatIndex] ? 1 : 0);
            }
         }
         
         WriteMultiplePlayerMessagesHeader (messagesData, 1);
         
         // ...
         
         var designViewer:Viewer = mCurrentInstance.mSeatsViewer [seatIndex] as Viewer;
         CreateNewCachedMessagesInfo (messagesData, [designViewer]);
      }
      
      public function OnRegisterPlayer (designViewer:Viewer, instanceID:String, playerConnectionId:String):void
      {
         if (mCurrentInstance == null)
            return;
         
         if (playerConnectionId == null || playerConnectionId.length == 0)
            return;
         
         var seatIndex:int = mCurrentInstance.mSeatsPlayerConnectionID.indexOf (playerConnectionId);
         if (seatIndex < 0)
            return;
         
         mCurrentInstance.mSeatsViewer [seatIndex] = designViewer;
         
         SendInstaneInfo (seatIndex);
      }
      
//============================================================================
//   
//============================================================================
      
      public function OnMultiplePlayerClientMessagesToSchedulerServer (messagesData:ByteArray, designViewer:Viewer):void
      {
         OnClientMessages (messagesData, designViewer);
      }
      
      public function OnMultiplePlayerClientMessagesToInstanceServer (messagesData:ByteArray, designViewer:Viewer):void
      {
         OnClientMessages (messagesData, designViewer);
      }
      
      // don't change this name, 
      private function OnClientMessages (messagesData:ByteArray, designViewer:Viewer):void
      {
         try
         {
            var clientDataFormatVersion:int = messagesData.readShort ();

            var dataLength:int = messagesData.readInt ();
            //if (dataLength > )
            //   ...
            
            var numMessages:int = messagesData.readShort ();
            //if (numMessages > )
            //   ...
            
            var msgIndex:int;
            var messages:Array = new Array (numMessages); // ByteArrays
            for (msgIndex = 0; msgIndex < numMessages; ++ msgIndex)
            {
               var clientMessageType:int = messagesData.readShort ();
               
               switch (clientMessageType)
               {
               // ...
               
                  //case MultiplePlayerDefine.ClientMessageType_CreateInstance:
                  //   OnCreateNewInstance (designViewer, 
                  //                        ReadInstanceDefine (messagesData, clientDataFormatVersion), 
                  //                        messagesData.readUTF (), // password
                  //                        messagesData.readUTF ()  // connection id
                  //                        );
                  //   break;
                  case MultiplePlayerDefine.ClientMessageType_JoinRandomInstance:
                     OnJoinRandomInstance (designViewer, 
                                           ReadInstanceDefine (messagesData, clientDataFormatVersion), 
                                           messagesData.readUTF () // connection id
                                           );
                     break;
               
               // ...
               
                  case MultiplePlayerDefine.ClientMessageType_Register:
                     OnRegisterPlayer (designViewer, 
                                       messagesData.readUTF (), // instance id
                                       messagesData.readUTF ()  // connection id
                                       );
                     break;
                  case MultiplePlayerDefine.ClientMessageType_ChannelMessage:
                     OnChannelMessage (designViewer, 
                                       ReadChannelMessage (messagesData)
                                       );
                     break;
                  default:
                  {
                     break;
                  }
               }
            }
         }
         catch (error:Error)
         {
            TraceError (error);
         }
      }
      
//============================================================================
//   
//============================================================================
      
      private function ReadInstanceDefine (messageInfoData:ByteArray, clientDataFormatVersion:int):Object
      {
         var numBytes:int = messageInfoData.readInt ();
         //if (numBytes > ...)
         //   ...
         
         var instanceDefineData:ByteArray = new ByteArray (numBytes);
         messageInfoData.readBytes (instanceDefineData, 0, numBytes);
         
         instanceDefineData.position = 0;
         
         // ...
         
         var gameID:String = instanceDefineData.readUTF ();
         
         var numSeats:int = instanceDefineData.readByte ();
         
         var numEnabledChannels:int = instanceDefineData.readByte ();
         var enabledChannelIndexes:Array = new Array (numEnabledChannels);
         
         var enabledChannelDefines:Array = new Array (numSeats);
         
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = instanceDefineData.readByte ();
            
            enabledChannelIndexes [i] = channelIndex;
            
            var channelDefine:Object = new Object ();
            enabledChannelDefines [channelIndex] = channelDefine;
            
            channelDefine.mChannelMode = instanceDefineData.readByte ();
            channelDefine.mTurnTimeoutSecondsX8 = instanceDefineData.readInt ();
         }
         
         // ...
         
         return {
            mInstanceDefineData : instanceDefineData, 
            mGameID : gameID,
            mNumSeats : numSeats,
            mEnabledChannelDefines : enabledChannelDefines, 
            mEnabledChannelIndexes : enabledChannelIndexes
         };
      }
      
      private function ReadChannelMessage (messageInfoData:ByteArray, instanceID:String, clientDataFormatVersion:int):Object
      {
         var channelIndex:int = messageInfoData.readByte ();
         
         var messageLength:int = messageInfoData.readInt ();
         
         var messageData:ByteArray = new ByteArray (messageLength);
         messageInfoData.readBytes (messageData, 0, messageLength);
         
         return {
            mChannelIndex : channelIndex, 
            mMessageData : messageData
         };
      }
      
   }
}
