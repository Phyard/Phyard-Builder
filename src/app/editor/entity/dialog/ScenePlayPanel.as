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
   import common.UUID;
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
                                         
                                         //...
                                         OnMultiplePlayerClientMessagesToSchedulerServer : OnMultiplePlayerClientMessagesToSchedulerServer,
                                         OnMultiplePlayerClientMessagesToInstanceServer  : OnMultiplePlayerClientMessagesToInstanceServer
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
         
         DestroySimulatedServers ();
         
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
      
      //private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function UpdateSimulatedServers ():void
      {
         //mStepTimeSpan.End ();
         //mStepTimeSpan.Start ();
         
         if (mCurrentInstance != null)
         {
            UpdateInstance (); //mStepTimeSpan.GetLastSpan ());
         }
      }
      
      private function DestroySimulatedServers ():void
      {         
         CloseInstance ();
         
         SetNumMultiplePlayers (0);
      }
      
//============================================================================
//   
//============================================================================
      
      private var mPosOfNumBytesInHeader:int = -1;
      private var mPosOfNumMessagesInHeader:int = -1;
      private var mNumBytesInHeader:int = 0;
      
      private function WriteMultiplePlayerMessagesHeader (serverMessagesData:ByteArray, numMessages:int):void
      {
         if (serverMessagesData == null)
            return;
         
         serverMessagesData.position = 0;
         
         // serverMessagesData.writeShort (MultiplePlayerDefine.ServerMessageDataFormatVersion);
            // server messages don't have a format.
            // server may return different message types on different client message data formats
         
         mPosOfNumBytesInHeader = serverMessagesData.position;
         
         serverMessagesData.writeInt (serverMessagesData.length); // the whole length 
         
         mPosOfNumMessagesInHeader = serverMessagesData.position;
         
         serverMessagesData.writeShort (numMessages);
         
         mNumBytesInHeader = serverMessagesData.position;
      }
      
      private function GetInstanceSeatClientStream (seatIndex:int):ByteArray
      {
         var messagesData:ByteArray = mCurrentInstance.mSeatsMessagesDataToSend [seatIndex];
         
         if (messagesData == null)
         {
            messagesData = new ByteArray ();
            mCurrentInstance.mSeatsMessagesDataToSend [seatIndex] = messagesData;
         }
         
         if (messagesData.length == 0)
         {
            WriteMultiplePlayerMessagesHeader (messagesData, 0);
         }
         
         return messagesData;
      }
      
      private function ClearInstanceSeatClientStream (seatIndex:int):void
      {
         var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
         if (messagesData.length != mNumBytesInHeader)
         {
            messagesData.length = 0;
         }
      }
      
      private function UpdateInstanceSeatClientStreamHeader (seatIndex:int):void
      {
         var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
         
         var backupPos:int = messagesData.length;
         
         // 
         
         messagesData.position = mPosOfNumBytesInHeader;
         var numBytes:int = messagesData.readInt ();
         
         if (numBytes != messagesData.length)
         {
            messagesData.position = mPosOfNumMessagesInHeader;
            var numMessages:int = messagesData.readShort () + 1;
            
            messagesData.position = 0;
            WriteMultiplePlayerMessagesHeader (messagesData, numMessages);
         }
         
         // 
         
         messagesData.position = backupPos;
      }
      
      private function FlushInstanceSeatClientStream (seatIndex:int):void
      {
         var designViewer:Viewer = mCurrentInstance.mSeatsViewer [seatIndex];
         
         if (designViewer != null)
         {
            var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
            
            var dataToSend:ByteArray = new ByteArray ();
            dataToSend.writeBytes (messagesData, 0, messagesData.length);
            dataToSend.position = 0;
            designViewer.OnMultiplePlayerServerMessages (dataToSend);
         }
         
         ClearInstanceSeatClientStream (seatIndex);
      }
      
//============================================================================
//   
//============================================================================
      
      private var mCurrentInstance:Object = null;
      
      private function UpdateInstance ():void //dt:Number):void
      {
         if (mCurrentInstance.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Pending)
         {
            TryToTransitPhaseFromPendingToPlaying (true);
               // for this calling is called elsewhere, this calling will never be called.
               // if later the "call all write message calling" policy is sticked,
               // the time consumed per single thread loop step should be added to all sort of timeouts.
               // and the time consumed per single thread loop step should be as smaller as possible.
         }
         
         // ...
         
         if (mCurrentInstance.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing)
         {
            var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
            
            var nowTimer:int = getTimer ();
            for (var i:int = 0; i < numEnabledChannels; ++ i)
            {
               var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
               var channel:Object = mCurrentInstance.mChannels [channelIndex];
               var channemTurnTimeout:int = channel.mTurnTimeoutMilliseconds;
               
               if (channemTurnTimeout > 0)
               {
                  var numSeats:int = mCurrentInstance.mNumSeats;
                  
                  for (var iSeat:int = 0; iSeat < numSeats; ++ iSeat)
                  {
                     if (channel.mIsSeatsEnabled [iSeat] == true)
                     {
                        if ( (nowTimer - channel.mSeatsLastEnabledTime [iSeat]) > channemTurnTimeout)
                        {
                           // pass
                           OnChannelMessage (mCurrentInstance.mSeatsViewer [iSeat], 
                                             channelIndex, 
                                             null
                                             );
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function CloseInstance ():void
      {
         if (mCurrentInstance != null)
         {
            mCurrentInstance.mCurrentPhase = MultiplePlayerDefine.InstancePhase_Inactive;
            
            // ...
            
            var numSeats:int = mCurrentInstance.mNumSeats;
            for (var seatIndex:int = 0; seatIndex < numSeats; ++ seatIndex)
            {
               var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
               
               WriteMessage_InstanceCurrentPhase (messagesData);
               
               UpdateInstanceSeatClientStreamHeader (seatIndex);
                
               FlushInstanceSeatClientStream (seatIndex);
            }
            
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
         
         // ...
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         
         for (var seatIndex:int = 0; seatIndex < numSeats; ++ seatIndex)
         {
            mCurrentInstance.mSeatsMessagesDataToSend [seatIndex] = null;
            
            if (breakConnections)
            {
               BreakSeatConnection (seatIndex);
            }
         }
         
         // ...
         
         ResetInstanceChannels ()
      }
      
      private function BreakSeatConnection (seatIndex:int):void
      {
         mCurrentInstance.mSeatsPlayerConnectionID [seatIndex] = null;
         mCurrentInstance.mSeatsPlayerName [seatIndex] = null;
         mCurrentInstance.mSeatsLastActiveTime [seatIndex] = 0;
         mCurrentInstance.mSeatsLastPongTime [seatIndex] = 0;
         mCurrentInstance.mSeatsLastPingTime [seatIndex] = 0;
         mCurrentInstance.mSeatsViewer [seatIndex] = null;
      }
      
      private function ResetInstanceChannels ():void
      {
         var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
         var timer:int = getTimer ();
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
            var channel:Object = mCurrentInstance.mChannels [channelIndex];
            
            var seatDefaultEnabled:Boolean = channel.mChannelMode != MultiplePlayerDefine.InstanceChannelMode_Chess;
            
            for (var seatIndex:int = 0; seatIndex < numSeats; ++ seatIndex)
            {
               channel.mIsSeatsEnabled [seatIndex] = seatDefaultEnabled;
               channel.mSeatsLastEnabledTime [seatIndex] = timer;
               channel.mSeatsMessage [seatIndex] = null;
            }
            
            if (channel.mChannelMode == MultiplePlayerDefine.InstanceChannelMode_Chess)
            {
               channel.mIsSeatsEnabled [Math.floor (Math.random () * numSeats)] = true;
            }
         }
      }
      
      private function CreateInstance (instanceDefine:Object, password:String):void
      {
         if (mCurrentInstance != null)
         {
            CloseInstance ();
         }
         
         // ...
         
         var numSeats:int = instanceDefine.mNumSeats;
         var enabledChannelIndexes:Array = instanceDefine.mEnabledChannelIndexes;
         
         mCurrentInstance = {
            mID : UUID.BuildRandomKey (), // "123-abc_ABC", // a Base64 string represents an int8 value.

            mInstanceDefineData : instanceDefine.mInstanceDefineData, 
            mGameID : instanceDefine.mGameID,
            mPassword : password,
            
            // ...
            
            mNumPlayedGames : 0, // restart instance will increase it. Most client messages must send it back to server.
                                 // if the value sent back is not same as this one, server will ignore client message.
            
            // ...
                        
            mCurrentPhase : MultiplePlayerDefine.InstancePhase_Pending,
            
            // ...
            
            mNumSeats : instanceDefine.mNumSeats,

            mSeatsPlayerConnectionID : new Array (numSeats), // string
            mSeatsClientDataFormatVersion : new Array (numSeats), // uint8
            mSeatsPlayerName : new Array (numSeats),  // string
            mSeatsLastActiveTime : new Array (numSeats), // int, last mouse/keyboard input time
            mSeatsLastPongTime : new Array (numSeats), // int, last client message time
            mSeatsLastPingTime : new Array (numSeats), // int, last ping (by server) time
            mSeatsViewer : new Array (numSeats), // viewer
            
            mSeatsMessagesDataToSend : new Array (numSeats), // ByteArray
            
            // ...
            
            mEnabledChannelIndexes : enabledChannelIndexes,
            mChannels : new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels), // Channel Object
                              // mChannelMode
                              // mTurnTimeoutMilliseconds // milliseconds, not X8
                              // mIsSeatsEnabled [] boolean
                              // mSeatsLastEnableTime [] int
                              // mSeatsMessage [] string
            
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
                  channel.mTurnTimeoutMilliseconds = channelDefine.mTurnTimeoutSecondsX8 * 125.0;
         
                  channel.mIsSeatsEnabled = new Array (numSeats);
                  channel.mSeatsLastEnabledTime = new Array (numSeats);
                  channel.mSeatsMessage = new Array (numSeats); // only useful for some modes
                  
                  continue;
               }
            }
            
            enabledChannelIndexes.splice (i, 1);
            -- i;
         }
         
         ResetInstance (true);
         
         // ...
         
         SetNumMultiplePlayers (numSeats);
      }
      
      // designViewer is used to determine seat index.
      // This method of determining index may be not good.
      private function JoinInstance (instance:Object, password:String, playerConnectionId:String, designViewer:Viewer):void
      {
         if (mCurrentInstance == null)
            return;
         
         var viewerIndex:int = mMultiplePlayerViewers.indexOf (designViewer);
         if (viewerIndex < 0)
            return;
         
trace ("888 playerConnectionId = " + playerConnectionId);

         if (playerConnectionId == null || playerConnectionId.length == 0)
            playerConnectionId = UUID.BuildRandomKey ();
         
         var seatIndex:int = mCurrentInstance.mSeatsPlayerConnectionID.indexOf (playerConnectionId);

trace ("888 seatIndex = " + seatIndex + ", viewerIndex = " + viewerIndex);

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
            mCurrentInstance.mSeatsLastActiveTime [seatIndex] = 0;
            mCurrentInstance.mSeatsLastPongTime [seatIndex] = 0;
            mCurrentInstance.mSeatsLastPingTime [seatIndex] = 0;
            //mCurrentInstance.mSeatsViewer [seatIndex] = null; // will be confirmed in OnPlayerLoginInstanceServer.
            mCurrentInstance.mSeatsViewer [seatIndex] = designViewer; // but to avoid null pointer in FlushInstanceSeatClientStream, we still ...
         }
         
         // ...
         
         var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
         
         WriteMessage_InstanceServerInfo (messagesData, playerConnectionId);
         
         UpdateInstanceSeatClientStreamHeader (seatIndex);
         
         // ...
         
         FlushInstanceSeatClientStream (seatIndex);
      }
         
      private function TryToTransitPhaseFromPendingToPlaying (writePhaseMessageIfTransitted:Boolean):void
      {
         if (mCurrentInstance.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Pending)
            return;
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         
         var nowTimer:int = getTimer ();
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {
            var connectionId:String = mCurrentInstance.mSeatsPlayerConnectionID [seatIndex];
            if (connectionId == null || connectionId.length == 0)
               return;
            
            if (nowTimer - mCurrentInstance.mSeatsLastPongTime [seatIndex] > 15000)
            {
               //if (nowTimer - mCurrentInstance.mSeatsLastPingTime [seatIndex] > 6000)
               //{
               //   // break connect
               //   return;
               //}
               
               // ...
               
               var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
               
               WriteMessage_Ping (messagesData);
               
               UpdateInstanceSeatClientStreamHeader (seatIndex);
               
               // ...
               
               FlushInstanceSeatClientStream (seatIndex);
               
               return;
            }
         }
         
         // ...
         
         StartPlayingInstance (writePhaseMessageIfTransitted);
      }
      
      private function StartPlayingInstance (writePhaseMessageIfTransitted:Boolean):void
      {
         mCurrentInstance.mCurrentPhase = MultiplePlayerDefine.InstancePhase_Playing;
         
         // ...
         
         ResetInstanceChannels ();
         
         // ...
         
         if (writePhaseMessageIfTransitted)
         {
            var numSeats:int = mCurrentInstance.mNumSeats;
            var seatIndex:int;
            
            for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
            {
               var connectionId:String = mCurrentInstance.mSeatsPlayerConnectionID [seatIndex];
               if (connectionId == null || connectionId.length == 0)
                  return;
               
               var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
               
               WriteMessage_InstanceCurrentPhase (messagesData);
               
               UpdateInstanceSeatClientStreamHeader (seatIndex);
               
               // ...
               
               FlushInstanceSeatClientStream (seatIndex);
            }
         }
      }
      
//============================================================================
//   
//============================================================================
      
      private function WriteMessage_InstanceServerInfo (dataBuffer:ByteArray, playerConnectionId:String):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceServerInfo);
         dataBuffer.writeUTF ("127.0.0.1"); // host
         dataBuffer.writeShort (5678); // port
         dataBuffer.writeUTF (mCurrentInstance.mID);
         dataBuffer.writeUTF (playerConnectionId);
      }
      
      private function WriteMessage_Ping (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_Ping);
      }
      
      private function WriteMessage_Pong (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_Pong);
      }
      
      private function WriteMessage_InstanceBasicInfo (dataBuffer:ByteArray, receiverSeatIndex:int):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceBasicInfo);
         dataBuffer.writeUTF (mCurrentInstance.mID);
         dataBuffer.writeInt (mCurrentInstance.mNumPlayedGames);
         dataBuffer.writeByte (mCurrentInstance.mNumSeats);
         dataBuffer.writeByte (receiverSeatIndex);
      }
      
      private function WriteMessage_InstanceCurrentPhase (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceCurrentPhase);
         
         dataBuffer.writeByte (mCurrentInstance.mCurrentPhase);
      }
      
      private function WriteMessage_SeatBasicInfo (dataBuffer:ByteArray, seatIndex:int):void
      {
         var playerName:String = mCurrentInstance.mSeatsPlayerName [seatIndex];
         if (playerName == null)
            playerName = "";
            
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_SeatBasicInfo);
         dataBuffer.writeByte (seatIndex);
         dataBuffer.writeUTF (playerName);
      }
      
      private function WriteMessage_SeatDynamicInfo (dataBuffer:ByteArray, seatIndex:int):void
      {
         var lastActiveTime:int = 0x7FFFFFFF & mCurrentInstance.mSeatsLastActiveTime [seatIndex];
         var isConnected:Boolean = mCurrentInstance.mSeatsViewer [seatIndex] != null;
         if (isConnected)
            lastActiveTime |= 0x80000000;
         
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_SeatDynamicInfo);
         dataBuffer.writeByte (seatIndex);
         dataBuffer.writeShort (lastActiveTime);
      }
      
      private function WriteMessage_AllChannelsConstInfo (dataBuffer:ByteArray):void
      {
         var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
         
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_AllChannelsConstInfo);
         dataBuffer.writeByte (numEnabledChannels);
         
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
            var channel:Object = mCurrentInstance.mChannels [channelIndex];
            var mode:int = channel.mChannelMode;
            var timeoutX8:int = channel.mTurnTimeoutMilliseconds * 0.008;
            
            dataBuffer.writeByte (channelIndex);
            dataBuffer.writeByte (mode);
            dataBuffer.writeInt (timeoutX8);
         }
      }
      
      private function WriteMessage_ChannelDynamicInfo (dataBuffer:ByteArray, channelIndex:int, seatIndex:int):void
      {
         var channel:Object = mCurrentInstance.mChannels [channelIndex];
         
         var enabledTime:int = 0x7FFFFFFF & (int (Math.round (channel.mSeatsLastEnableTime [seatIndex] * 8 / 1000)));
         if (channel.mIsSeatsEnabled [seatIndex])
            enabledTime |= 0x80000000;
       
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_ChannelSeatInfo);
         dataBuffer.writeByte (channelIndex);
         dataBuffer.writeInt (enabledTime);
      }
      
      private function WriteMessage_ChannelMessage (dataBuffer:ByteArray, channelIndex:int, senderSeatIndex:int, messageData:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_ChannelMessage);
         
         dataBuffer.writeByte (channelIndex);
         dataBuffer.writeByte (senderSeatIndex);
         if (messageData == null) // pass
            dataBuffer.writeInt (-1);
         else
         {
            dataBuffer.writeInt (messageData.length & 0x7FFFFFFF);
            dataBuffer.writeBytes (messageData);
         }
      }
      
//============================================================================
//   
//============================================================================
      
      private function OnCreateNewInstance (instanceDefine:Object, password:String, playerConnectionId:String, designViewer:Viewer):void
      {
         if (instanceDefine.mInstanceDefineData == null)
            return;
         
         if (mCurrentInstance != null)
         {
            CloseInstance ();
         }
         
         CreateInstance (instanceDefine, password);
         
         JoinInstance (mCurrentInstance, password, playerConnectionId, designViewer);
      }
      
      private function OnJoinRandomInstance (instanceDefine:Object, playerConnectionId:String, designViewer:Viewer):void
      {
trace ("666");

         if (instanceDefine.mInstanceDefineData == null)
            return;
         
trace ("777");

         var sameDefine:Boolean = false;
         
         if (mCurrentInstance != null)
         {
            sameDefine = instanceDefine.mInstanceDefineData.length == mCurrentInstance.mInstanceDefineData.length;
            
            if (sameDefine)
            {
               for (var i:int = 0; i < instanceDefine.mInstanceDefineData.length; ++ i)
               {
                  if (instanceDefine.mInstanceDefineData [i] != mCurrentInstance.mInstanceDefineData [i])
                  {
                     sameDefine = false;
                     break;
                  }
               }
            }
         }
         
trace ("888 sameDefine = " + sameDefine);
         
         if (mCurrentInstance != null && sameDefine == false)
         {
trace ("888 aaa");
            CloseInstance ();
         }
         
         if (mCurrentInstance == null)
         {
trace ("888 bbb");
            CreateInstance (instanceDefine, "");
         }
         
         JoinInstance (mCurrentInstance, "", playerConnectionId, designViewer);
      }
      
      private function OnPlayerLoginInstanceServer (designViewer:Viewer, instanceID:String, playerConnectionId:String, clientDataFormatVersion:int):void
      {
trace ("999 aaa instanceID = " + instanceID + ", mCurrentInstance.mID = " + (mCurrentInstance == null ? null : mCurrentInstance.mID));
         if (mCurrentInstance == null || instanceID != mCurrentInstance.mID)
            return;
         
trace ("999 bbb");
         if (playerConnectionId == null || playerConnectionId.length == 0)
            return;
         
trace ("999 ccc");
         var newPlayerSeatIndex:int = mCurrentInstance.mSeatsPlayerConnectionID.indexOf (playerConnectionId);
         if (newPlayerSeatIndex < 0)
            return;
         
         // ...
         
trace ("999 ddd");
         if (mCurrentInstance.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Pending)
         {
trace ("999 eee");
            if (mCurrentInstance.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing)
            {
               // maybe disconnected and re-connect.
               // Temp not supported now.
               // 
               // To support: need get game same info from other players then send to this player.
            }
            
            return;
         }
         
         // ...
         
         mCurrentInstance.mSeatsClientDataFormatVersion [newPlayerSeatIndex] = clientDataFormatVersion;
         mCurrentInstance.mSeatsLastPongTime [newPlayerSeatIndex] = getTimer ();
         mCurrentInstance.mSeatsViewer [newPlayerSeatIndex] = designViewer;
         
         // ...
         
         // send seats info to all
         //
         // if instance.mLastStatus == pending && instance.mStatus == playing
         //     send status change message to all
         //     send instance channels info to all
         // end if
         
         var messagesData:ByteArray;
         
         // ...
         
         messagesData = GetInstanceSeatClientStream (newPlayerSeatIndex);
         
         // basic info
         WriteMessage_InstanceBasicInfo (messagesData, newPlayerSeatIndex);
         
         UpdateInstanceSeatClientStreamHeader (newPlayerSeatIndex);
         
         // ...
         
trace ("999 fff, mCurrentInstance.mCurrentPhase = " + mCurrentInstance.mCurrentPhase);
         
         TryToTransitPhaseFromPendingToPlaying (false);
         
trace ("999 newPlayerSeatIndex = " + newPlayerSeatIndex + ", mCurrentInstance.mCurrentPhase = " + mCurrentInstance.mCurrentPhase);
         
         // ...
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         for (var seatIndex:int = 0; seatIndex < numSeats; ++ seatIndex)
         {
            messagesData = GetInstanceSeatClientStream (seatIndex);
            
            // ...
            
            WriteMessage_InstanceCurrentPhase (messagesData);
            
            UpdateInstanceSeatClientStreamHeader (seatIndex);
            
            // ...
            
            var iSeat:int;
            
            for (iSeat = 0; iSeat < numSeats; ++ iSeat)
            {
               WriteMessage_SeatBasicInfo (messagesData, iSeat)
               
               UpdateInstanceSeatClientStreamHeader (seatIndex);
            }
            
            for (iSeat = 0; iSeat < numSeats; ++ iSeat)
            {
               WriteMessage_SeatDynamicInfo (messagesData, iSeat)
               
               UpdateInstanceSeatClientStreamHeader (seatIndex);
            }
            
            // ...
             
            FlushInstanceSeatClientStream (seatIndex);
         }
      }
      
      private function OnPing (designViewer:Viewer):void
      {
         if (mCurrentInstance == null)
            return;
         
         var senderSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (senderSeatIndex < 0)
            return;
         
         mCurrentInstance.mSeatsLastPongTime [senderSeatIndex] = getTimer (); // yes, it is LastPongTime!
         
         // ...
         
         var messagesData:ByteArray = GetInstanceSeatClientStream (senderSeatIndex);
         
         WriteMessage_Pong (messagesData);
         
         UpdateInstanceSeatClientStreamHeader (senderSeatIndex);
         
         // ...
         
         FlushInstanceSeatClientStream (senderSeatIndex);
         
         // ...
         
         TryToTransitPhaseFromPendingToPlaying (true);
      }
      
      private function OnPong (designViewer:Viewer):void
      {
         if (mCurrentInstance == null)
            return;
         
         var senderSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (senderSeatIndex < 0)
            return;
         
         mCurrentInstance.mSeatsLastPongTime [senderSeatIndex] = getTimer ();
         
         // ...
         
         TryToTransitPhaseFromPendingToPlaying (true);
      }

      private function OnChannelMessage (designViewer:Viewer, channelIndex:int, theMessageData:ByteArray):void
      {
         if (mCurrentInstance == null)
            return;
         
         if (mCurrentInstance.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing)
            return;
         
         var senderSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (senderSeatIndex < 0)
            return;
         
         var channel:Object = mCurrentInstance.mChannels [channelIndex];
         if (channel == null)
            return;
         
         mCurrentInstance.mSeatsLastPongTime [senderSeatIndex] = getTimer ();
         
         if (! channel.mIsSeatsEnabled [senderSeatIndex])
            return;
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         var messagesData:ByteArray;
         
         var newTimer:int = getTimer ();
         
         switch (channel.mChannelMode)
         {
            case MultiplePlayerDefine.InstanceChannelMode_Chess:
            
               channel.mIsSeatsEnabled [senderSeatIndex] = false;
               var nextEnabledSeatIndex:int = senderSeatIndex >= numSeats - 1 ? 0 : senderSeatIndex + 1;
               channel.mIsSeatsEnabled [nextEnabledSeatIndex] = true;
               channel.mSeatsLastEnabledTime [nextEnabledSeatIndex] = newTimer;
               
               for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
               {
                  messagesData = GetInstanceSeatClientStream (seatIndex);
                  
                  WriteMessage_ChannelDynamicInfo (messagesData, channelIndex, senderSeatIndex);
                  
                  UpdateInstanceSeatClientStreamHeader (seatIndex);
                  
                  WriteMessage_ChannelDynamicInfo (messagesData, channelIndex, nextEnabledSeatIndex);
                  
                  UpdateInstanceSeatClientStreamHeader (seatIndex);
               }
               
               // not break here
            case MultiplePlayerDefine.InstanceChannelMode_Free:
            
               for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
               {
                  messagesData = GetInstanceSeatClientStream (seatIndex);
                  
                  WriteMessage_ChannelMessage (messagesData, channelIndex, senderSeatIndex, theMessageData);
                  
                  UpdateInstanceSeatClientStreamHeader (seatIndex);
                  
                  // 
                  FlushInstanceSeatClientStream (seatIndex);
               }
               
               break;
            
            case MultiplePlayerDefine.InstanceChannelMode_WeGo:
            {
               var wegoMessages:Array = channel.mSeatsMessage;
               if (wegoMessages != null && wegoMessages [senderSeatIndex] == null)
               {
                  channel.mIsSeatsEnabled [senderSeatIndex] = false;
                  
                  wegoMessages [senderSeatIndex] = theMessageData;
                  
                  var allHaveSent:Boolean = true;
                  for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                  {
                     if (wegoMessages [seatIndex] == null)
                     {
                        allHaveSent = false;
                        break;
                     }
                  }
                  
                  // ...
                  
                  var iSeat:int;
                  
                  if (allHaveSent)
                  { 
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        channel.mIsSeatsEnabled [seatIndex] = true;
                        channel.mSeatsLastEnabledTime [seatIndex] = newTimer;
                     }
                     
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        messagesData = GetInstanceSeatClientStream (seatIndex);
                        
                        for (iSeat = 0; iSeat < numSeats; ++ iSeat)
                        {
                           WriteMessage_ChannelDynamicInfo (messagesData, channelIndex, iSeat);
                           
                           UpdateInstanceSeatClientStreamHeader (seatIndex);
                        }
                     }
                  }
                  else
                  {
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        messagesData = GetInstanceSeatClientStream (seatIndex);
                        
                        WriteMessage_ChannelDynamicInfo (messagesData, channelIndex, senderSeatIndex);
                        
                        UpdateInstanceSeatClientStreamHeader (seatIndex);
                     }
                  }
                  
                  // ...
                  
                  if (allHaveSent)
                  {
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        messagesData = GetInstanceSeatClientStream (seatIndex);
                        
                        for (iSeat = 0; iSeat < numSeats; ++ iSeat)
                        {
                           WriteMessage_ChannelMessage (messagesData, channelIndex, iSeat, wegoMessages [iSeat]);
                           
                           UpdateInstanceSeatClientStreamHeader (seatIndex);
                        }
                     }
                     
                     //
                     
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        wegoMessages [seatIndex] = null;
                     }
                  }
               }
               
               // ...
               
               for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
               {
                  FlushInstanceSeatClientStream (seatIndex);
               }
               
               break;
            }
            default:
            {
               return;
            }
         }
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
trace ("333");
         try
         {
            var dataLength:int = messagesData.readInt ();
            //if (dataLength > )
            //   ...
trace ("333, dataLength = " + dataLength);
            
            var numMessages:int = messagesData.readShort ();
            //if (numMessages > )
            //   ...
trace ("333, numMessages = " + numMessages);
            
            var msgIndex:int;
            var messages:Array = new Array (numMessages); // ByteArrays
            for (msgIndex = 0; msgIndex < numMessages; ++ msgIndex)
            {
               var clientMessageType:int = messagesData.readShort ();
               
               var instanceId:String;
               var connectionId:String;
               var clientDataFormatVersion:int;
               
trace ("444 clientMessageType = " + clientMessageType);
               switch (clientMessageType)
               {
               // ...
               
                  //case MultiplePlayerDefine.ClientMessageType_CreateInstance:
                  //
                  //   clientDataFormatVersion = messagesData.readShort () & 0xFFFF;
                  //
                  //   OnCreateNewInstance (designViewer, 
                  //                        ReadInstanceDefine (messagesData, clientDataFormatVersion), 
                  //                        messagesData.readUTF (), // password
                  //                        messagesData.readUTF ()  // connection id
                  //                        );
                  //   break;
                  case MultiplePlayerDefine.ClientMessageType_JoinRandomInstance:
                     
                     clientDataFormatVersion = messagesData.readShort () & 0xFFFF;
                     
                     OnJoinRandomInstance (ReadInstanceDefine (messagesData, clientDataFormatVersion), 
                                           messagesData.readUTF (), // connection id
                                           designViewer
                                           );
                     
                     break;
               
               // ...
               
                  case MultiplePlayerDefine.ClientMessageType_LoginInstanceServer:
                     
                     clientDataFormatVersion = messagesData.readShort () & 0xFFFF;
                     instanceId = messagesData.readUTF ();
                     connectionId = messagesData.readUTF ();
                     
                     OnPlayerLoginInstanceServer (designViewer, 
                                                  instanceId,
                                                  connectionId,
                                                  clientDataFormatVersion
                                                 );
                     
                     break;
               
               // for all following cases, 
               //   clientDataFormatVersion = mCurrentInstance.mSeatsClientDataFormatVersion [playerSeatIndex]
               //   playerConnectionId = mCurrentInstance.mSeatsPlayerConnectionID [playerSeatIndex]
               
                  case MultiplePlayerDefine.ClientMessageType_Ping:
                  
                     OnPing (designViewer);
               
                     break;
                     
                  case MultiplePlayerDefine.ClientMessageType_Pong:
                  
                     OnPong (designViewer);
               
                     break;
                     
                  case MultiplePlayerDefine.ClientMessageType_ExitCurrentInstance:
                     
                     break;
               
                  case MultiplePlayerDefine.ClientMessageType_ChannelMessage:
                     
                     var channelIndex:int = messagesData.readByte ();
                     var channelMessageLength:int = messagesData.readInt ();
                     var channelMessageData:ByteArray = null;
                     if (channelMessageLength != -1)
                     {
                        channelMessageLength &= 0x7FFFFFFF;
                        channelMessageData = new ByteArray ();
                        messagesData.readBytes (channelMessageData, 0, channelMessageLength);
                     }
                     
                     OnChannelMessage (designViewer, channelIndex, channelMessageData);
                     
                     break;
                     
                  case MultiplePlayerDefine.ClientMessageType_SignalRestartInstance:
                     
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
         
         var instanceDefineData:ByteArray = new ByteArray ();
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
      
   }
}
