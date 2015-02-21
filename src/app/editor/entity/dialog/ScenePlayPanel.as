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
   import flash.geom.Rectangle;
   
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   
   import mx.utils.SHA256;
   
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
         mRestoreValues.mSoundVolume = SoundMixer.soundTransform.volume;
         
         mViewerParamsFromEditor = {mParamsFromEditor: {
                                         mWorldDomain: ApplicationDomain.currentDomain,  
                                         mWorldBinaryData: worldBinaryData, 
                                         mCurrentSceneId: currentSceneId, 
                                         GetViewportSize: GetViewportSize, 
                                         mStartRightNow: true, 
                                         mMaskViewerField: maskFieldInPlaying, 
                                         mBackgroundColor: surroudingBackgroundColor, 
                                         OnExitLevel: callbackStopPlaying,
                                         
                                         //mFlashVars
                                         mAppRootURL: "memory:///app.phd",
                                         
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
            SoundMixer.soundTransform = new SoundTransform (mRestoreValues.mSoundVolume);
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
      
      //private var mContentMaskSprite:Shape = null;
      private var mMaskRect:Rectangle = null;
      private var mContentMaskWidth :Number = 0;
      private var mContentMaskHeight:Number = 0;
      
      protected function UpdateBackgroundAndContentMaskSprites ():void
      {
         if (parent.width != mContentMaskWidth || parent.height != mContentMaskHeight)
         {
            mContentMaskWidth  = parent.width;
            mContentMaskHeight = parent.height;
            
            //if (mContentMaskSprite == null)
            //{
            //   mContentMaskSprite = new Shape ();
            //   addChild (mContentMaskSprite);
            //   this.mask = mContentMaskSprite;
            //}
            if (mMaskRect == null)
            {
               mMaskRect = new Rectangle ();
            }
            
            GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true, 0xFFFFFF);
            //GraphicsUtil.ClearAndDrawRect (mContentMaskSprite, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true);
            mMaskRect.x = mMaskRect.y = 0;
            mMaskRect.width = mContentMaskWidth;
            mMaskRect.height = mContentMaskHeight;
            this.scrollRect = mMaskRect; // must call this to update
            
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
      
      private static function TraceError (error:Error, dontThrowIt:Boolean = false):void
      {
         if (Capabilities.isDebugger)
         {
            trace (error.getStackTrace ());
            
            if (dontThrowIt)
               return;
            
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
               designViewer.SetVisible (false);
               designViewer.SetAsCurrentViewer (false);
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
               designViewer.SetVisible (false);
               designViewer.SetAsCurrentViewer (false);
               //removeChild (designViewer);
            }
            
            mCurrentMutiplePlayerIndex = index;
            
            if (mCurrentMutiplePlayerIndex >= 0)
            {
               designViewer = mMultiplePlayerViewers [mCurrentMutiplePlayerIndex] as Viewer;
               designViewer.SetVisible (true);
               designViewer.SetAsCurrentViewer (true);
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
      
      //private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function UpdateSimulatedServers ():void
      {
         //mStepTimeSpan.End ();
         //mStepTimeSpan.Start ();
         
         if (mCurrentInstance != null)
            UpdateInstance (); //mStepTimeSpan.GetLastSpan ());
      }
      
      private function DestroySimulatedServers ():void
      {
         mCurrentInstance = null;
         
         SetNumMultiplePlayers (0);
      }
      
//============================================================================
//   
//============================================================================
      
      private function UpdateInstance ():void //dt:Number):void
      {
         // assert (mCurrentInstance != null);
         
         if (mCurrentInstance.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Inactive)
            return;
         
         if (mCurrentInstance.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Waiting)
         {
            TryToTransitPhaseFromPendingToPlaying ();
            return;
         }
         
         // ...
         
         if (mCurrentInstance.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing)
         {
            var nowTimer:int = getTimer ();

            var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
            
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
                     if (channel.mIsSeatsEnabled [iSeat] == true) // && mCurrentInstance.mSeatsViewer [iSeat] != null)
                     {
                        if ( (nowTimer - channel.mSeatsLastEnabledTime [iSeat]) > channemTurnTimeout)
                        {
                           // pass
                           OnChannelMessage (iSeat, // mCurrentInstance.mSeatsViewer [iSeat],
                                             mCurrentInstance.mNumPlayedGames,
                                             channelIndex,
                                             channel.mVerifyNumber & 0xFFFF,
                                             null, // message
                                             -1, // encryption method 
                                             null // cipher
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
            ChangeInstancePhase (MultiplePlayerDefine.InstancePhase_Inactive, true, true);
            
            mCurrentInstance = null;
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
            
            mPlayersStatus : MultiplePlayerDefine.PlayerStatus_Queuing, // just a hint for what status most players stay in now. 
            
            // ...
            
            mInstanceDefineData : instanceDefine.mInstanceDefineData,
            mInstanceDefineDigest : instanceDefine.mInstanceDefineDigest,

            mPassword : password,
            
            // ...
            
            mID : UUID.BuildUUID (), // 16 bytes uuid
            
            // ...
                        
            mNumPlayedGames : 0, // restart instance will increase it. Most client messages must send it back to server.
                                 // if the value sent back is not same as this one, server will ignore client message.
            
            // ...
                        
            mCurrentPhase : MultiplePlayerDefine.InstancePhase_Inactive,
            mCurrentPhaseStartTime : getTimer (),
            
            // ...
            
            mNumSeats : numSeats,
            
            //mViewerIndex2SeatIndex : new Array (numSeats), // int
                  // now, viewer index == seat index
            
            mSeatsMessagesDataToSend : new Array (numSeats), // ByteArray

            mSeatsClientDataFormatVersion : new Array (numSeats), // uint8
            mSeatsPlayerConnectionID : new Array (numSeats), // string
            mSeatsPlayerName : new Array (numSeats),  // string
            mSeatsLastActiveTime : new Array (numSeats), // int, last mouse/keyboard input time
            mSeatsLastPongTime : new Array (numSeats), // int, last client message time
            mSeatsLastPingTime : new Array (numSeats), // int, last ping (by server) time
            mSeatsViewer : new Array (numSeats), // viewer
            
            // ...
            
            mSeatsSignal_ChangePhase_TargetPhase : new Array (numSeats),
            mSeatsSignal_ChangePhase_ArrivalTime : new Array (numSeats),
            
            // ...
            
            mNextMessageEncryptionIndex : 0, 
            
            mEnabledChannelIndexes : enabledChannelIndexes,
            mChannels : new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels), // Channel Object
                              // mChannelMode
                              // mTurnTimeoutMilliseconds // milliseconds, not X8
                              // mVerifyNumber // short
                              // mIsSeatsEnabled [] boolean
                              // mSeatsLastEnabledTime [] int
                              // mSeatsMessage [] string
                              // mIsSeatsMessageInHolding [] boolean
                              // mSeatsMessageEncryptionIndex [] int
                              // mSeatsMessageEncryptionMethod [] int
            
            // ...
            
            "" : null
         };
         
         // ...
         
         for (var seatIndex:int = 0; seatIndex < numSeats; ++ seatIndex)
         {
            ResetInstanceSeat (seatIndex);
            
            mCurrentInstance.mSeatsSignal_ChangePhase_TargetPhase [seatIndex] = -1;
            mCurrentInstance.mSeatsSignal_ChangePhase_ArrivalTime [seatIndex] = 0;
         }
         
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
                  channel.mIsSeatsMessageInHolding = new Array (numSeats); // only useful for some modes
                  channel.mSeatsMessageEncryptionIndex = new Array (numSeats); // only useful for some modes
                  channel.mSeatsMessageEncryptionMethod = new Array (numSeats); // only useful for some modes
                  
                  continue;
               }
            }
            
            enabledChannelIndexes.splice (i, 1); // remove the bad index
            -- i;
         }
         
         ResetInstanceChannels (true);
         
         // notify UI to change
         
         SetNumMultiplePlayers (numSeats);
      }
      
      private function ResetInstanceSeat (seatIndex:int):void
      {
         mCurrentInstance.mSeatsViewer [seatIndex] = null;
         
         mCurrentInstance.mSeatsPlayerConnectionID [seatIndex] = null;
         mCurrentInstance.mSeatsPlayerName [seatIndex] = null;
         mCurrentInstance.mSeatsLastActiveTime [seatIndex] = 0;
         mCurrentInstance.mSeatsLastPongTime [seatIndex] = 0;
         mCurrentInstance.mSeatsLastPingTime [seatIndex] = 0;
         
         mCurrentInstance.mSeatsMessagesDataToSend [seatIndex] = null;
      }
      
      private function ResetInstanceChannels (disablePlayingChannelsForcely:Boolean):void
      {
         if (mCurrentInstance == null)
            return;
         
         var nowTimer:int = getTimer ();
         
         // ...
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         
         // ...
         
         mCurrentInstance.mNextMessageEncryptionIndex = 0;
         
         // ...
          
         var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
         
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
            var channel:Object = mCurrentInstance.mChannels [channelIndex];
                  
            if (channel.mChannelMode == MultiplePlayerDefine.InstanceChannelMode_Free)
            {
               channel.mVerifyNumber = int ((nowTimer >> 10) & 0xFFFF); // about 60000 seconds per loop
            }
            else
            {
               channel.mVerifyNumber = 0;
            }
            
            var seatDefaultEnabled:Boolean = disablePlayingChannelsForcely ? false : channel.mChannelMode != MultiplePlayerDefine.InstanceChannelMode_Chess;
            
            for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
            {
               channel.mIsSeatsEnabled [seatIndex] = seatDefaultEnabled;
               channel.mSeatsLastEnabledTime [seatIndex] = nowTimer;
               channel.mSeatsMessage [seatIndex] = null;
               channel.mIsSeatsMessageInHolding [seatIndex] = false;
               channel.mSeatsMessageEncryptionIndex [seatIndex] = -1;
               channel.mSeatsMessageEncryptionMethod [seatIndex] = -1;
            }
            
            if (! disablePlayingChannelsForcely)
            {
               if (channel.mChannelMode == MultiplePlayerDefine.InstanceChannelMode_Chess)
               {
                  channel.mIsSeatsEnabled [Math.floor (Math.random () * numSeats)] = true;
               }
            }
         }
      }
      
      private function GetNextMessageEncryptionIndex ():int
      {
         var index:int = mCurrentInstance.mNextMessageEncryptionIndex ++ ;
         
         mCurrentInstance.mNextMessageEncryptionIndex &= 0x00FFFFFF; // one byte reserved for encryption method, see WriteMessage_ChannelMessageEncryptionCiphers.
         
         return index;
      }
      
      private function GetSeatIndexByPlayerConnectionID (playerConnectionId:ByteArray):int
      {
         if (playerConnectionId != null && mCurrentInstance != null && mCurrentInstance.mSeatsPlayerConnectionID != null)
         {
            for (var i:int = 0; i < mCurrentInstance.mNumSeats; ++ i)
            {
               if (DataFormat3.CompareTwoByteArrays (mCurrentInstance.mSeatsPlayerConnectionID [i], playerConnectionId))
                  return i;
            }
         }
         
         return -1;
      }
      
      // designViewer is used to determine seat index.
      // This method of determining index may be not good.
      private function HandleJoinInstanceRequest (instanceDefine:Object, password:String, designViewer:Viewer):void
      {
         if (instanceDefine == null || mCurrentInstance == null)
            return;
         
         if (mCurrentInstance.mPlayersStatus != MultiplePlayerDefine.PlayerStatus_Queuing)
            return;
         
         if (DataFormat3.CompareTwoByteArrays (mCurrentInstance.mInstanceDefineDigest, instanceDefine.mInstanceDefineDigest) == false)
            return;
         
         var viewerIndex:int = mMultiplePlayerViewers.indexOf (designViewer);
         if (viewerIndex < 0)
            return;
         
         var playerConnectionId:ByteArray = null; // is a parameter before.
         //if (playerConnectionId == null || playerConnectionId.length == 0)
            playerConnectionId = UUID.BuildUUID ();
         
         //var seatIndex:int = mCurrentInstance.mSeatsPlayerConnectionID.indexOf (playerConnectionId);
         var seatIndex:int = GetSeatIndexByPlayerConnectionID (playerConnectionId);
            // should be -1 now

         if (seatIndex != viewerIndex)
         {
            if (seatIndex >= 0) // impossible
            {
               ResetInstanceSeat (seatIndex);
            }
             
            seatIndex = viewerIndex;
            
            mCurrentInstance.mSeatsPlayerConnectionID [seatIndex] = playerConnectionId;
            mCurrentInstance.mSeatsPlayerName [seatIndex] = "Player " + viewerIndex;
            
            mCurrentInstance.mSeatsLastActiveTime [seatIndex] = getTimer ();
            mCurrentInstance.mSeatsLastPongTime [seatIndex] = 0;
            mCurrentInstance.mSeatsLastPingTime [seatIndex] = 0;
            
            mCurrentInstance.mSeatsViewer [seatIndex] = null; // will be confirmed in OnPlayerLoginInstanceServer.
         }
         
         // ...
         
         var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
         
         WriteMessage_InstanceServerInfo (messagesData, mCurrentInstance.mInstanceDefineDigest, playerConnectionId);
         
         // ...
         
         FlushInstanceSeatClientStream (seatIndex, designViewer);
      }
      
      private function TryToTransitPhaseFromPendingToPlaying ():Boolean
      {
         if (mCurrentInstance.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Waiting)
            return false;
         
         var nowTimer:int = getTimer ();
         
         if (nowTimer - mCurrentInstance.mCurrentPhaseStartTime < 3000) // minimum waiting duration
            return false;
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         
         var numAbsences:int = 0;
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {
            //var connectionId:String = mCurrentInstance.mSeatsPlayerConnectionID [seatIndex];
            //if (connectionId == null || connectionId.length == 0)
            if (mCurrentInstance.mSeatsViewer [seatIndex] == null)
            {
               ++ numAbsences;
               continue;
            }
            
            if (nowTimer - mCurrentInstance.mSeatsLastPongTime [seatIndex] > 8000)
            {
               ++ numAbsences;
               
               if (nowTimer - mCurrentInstance.mSeatsLastPingTime [seatIndex] > 8000)
               {
                  if (mCurrentInstance.mSeatsLastPingTime [seatIndex] > mCurrentInstance.mSeatsLastPongTime [seatIndex])
                  {
                     // break connect
                  }
                  else
                  {
                     mCurrentInstance.mSeatsLastPingTime [seatIndex] = nowTimer;
                     
                     var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
                     
                     WriteMessage_Ping (messagesData);
                     
                     // ...
                     
                     FlushInstanceSeatClientStream (seatIndex);
                  }
               }
            }
         }
         
         if (numAbsences > 0)
            return false;
         
         // ...
         
         ChangeInstancePhase (MultiplePlayerDefine.InstancePhase_Playing, true, true);
         
         return true;
      }
      
      // when players join at the same time, set broadcaseNewPlayerSeatInfo == false
      // when players join one by one,       set broadcaseNewPlayerSeatInfo == true
      private function NotifyNewPlayerJoinedInstance (newPlayerSeatIndex:int, flushMessages:Boolean):void
      {
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         var messagesData:ByteArray;
         
         // ...
         
         messagesData = GetInstanceSeatClientStream (newPlayerSeatIndex);
         
         // ...
         
         WriteMessage_PlayerStatus (messagesData, MultiplePlayerDefine.PlayerStatus_Joined);
         
         // ...
         
         WriteMessage_InstanceConstInfo (messagesData);
         
         // ...
         
         WriteMessage_MySeatIndex (messagesData, newPlayerSeatIndex);
         
         // ...
         
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {           
            // ...
            
            WriteMessage_SeatBasicInfo (messagesData, seatIndex);
            
            // ...
            
            WriteMessage_SeatDynamicInfo (messagesData, seatIndex);
         }
         
         // ...
         
         WriteMessage_InstanceCurrentPhase (messagesData);
         
         // ...
         
         WriteMessage_AllChannelsConstInfo (messagesData);
         
         // ...
         
         WriteMessage_InstancePlayingInfo (messagesData); // maybe not essential to send this now.
         
         // ...
         
         WriteNonConstChannelsInfoIntoSeatStream (messagesData);
         
         // ...
         
         if (flushMessages)
         {
            FlushInstanceSeatClientStream (newPlayerSeatIndex);
         }
      }
      
      private function NotifySeatInfoChanged (theSeatIndexOfInfoChanged:int, basicInfoChanged:Boolean, dynamicInfoChanged:Boolean, flushMessages:Boolean):void
      {
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         var messagesData:ByteArray;
         
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {
            if (seatIndex == theSeatIndexOfInfoChanged)
               continue;
            
            messagesData = GetInstanceSeatClientStream (seatIndex);
            
            // ...
            
            if (basicInfoChanged)
            {
               WriteMessage_SeatBasicInfo (messagesData, theSeatIndexOfInfoChanged);
            }
            
            // ...
            
            if (dynamicInfoChanged)
            {
               WriteMessage_SeatDynamicInfo (messagesData, theSeatIndexOfInfoChanged);
            }
            
            //...
            
            if (flushMessages)
            {
               FlushInstanceSeatClientStream (seatIndex);
            }
         }
      }
      
      // this fucntion will not flush messages
      private function WriteNonConstChannelsInfoIntoSeatStream (messagesData:ByteArray):void
      {
         var numSeats:int = mCurrentInstance.mNumSeats;
         
         var numEnabledChannels:int = mCurrentInstance.mEnabledChannelIndexes.length;
         
         for (var i:int = 0; i < numEnabledChannels; ++ i)
         {
            var channelIndex:int = mCurrentInstance.mEnabledChannelIndexes [i];
            
            // ...
            
            WriteMessage_ChannelDynamicInfo (messagesData, channelIndex);
            
            // ...
            
            for (var iSeat:int = 0; iSeat < numSeats; ++ iSeat)
            {
               WriteMessage_ChannelSeatInfo (messagesData, channelIndex, iSeat);
            }
         }
      }
      
      // somtimes, don't need to write messages
      private function ChangeInstancePhase (newPhase:int, shouldWriteMessages:Boolean, flushMessages:Boolean):void
      {
         var oldPhase:int = mCurrentInstance.mCurrentPhase;
         if (oldPhase == newPhase)
            return;
         
         mCurrentInstance.mCurrentPhase = newPhase;
         mCurrentInstance.mCurrentPhaseStartTime = getTimer ();
         
         // ...
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         var messagesData:ByteArray;
            
         // ...
         
         if (shouldWriteMessages)
         {
            for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
            {
               if (mCurrentInstance.mSeatsViewer [seatIndex] == null)
                  continue;
               
               messagesData = GetInstanceSeatClientStream (seatIndex);
               
               // ...
               
               WriteMessage_InstanceCurrentPhase (messagesData);
            }
         }
            
         // ...

         if (newPhase == MultiplePlayerDefine.InstancePhase_Inactive) // close instance
         {
            mCurrentInstance.mPlayersStatus = MultiplePlayerDefine.PlayerStatus_Wandering;
            
            // ...
            
            if (shouldWriteMessages)
            {
               for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
               {
                  if (mCurrentInstance.mSeatsViewer [seatIndex] == null)
                     continue;
                  
                  messagesData = GetInstanceSeatClientStream (seatIndex);
                  
                  // ...
                  
                  WriteMessage_PlayerStatus (messagesData, MultiplePlayerDefine.PlayerStatus_Wandering);
                  
                  // ...
                  
                  if (flushMessages)
                  {
                     FlushInstanceSeatClientStream (seatIndex);
                  }
               }
            }
            
            return;
         }
         
         // ...
         
         var needWriteChannelsInfo:Boolean = false;
         
         if (oldPhase == MultiplePlayerDefine.InstancePhase_Playing)
         {
            ResetInstanceChannels (true);
            needWriteChannelsInfo = true;
         }
         
         if (newPhase == MultiplePlayerDefine.InstancePhase_Playing)
         {
            ResetInstanceChannels (false);
            needWriteChannelsInfo = true;
            
            ++ mCurrentInstance.mNumPlayedGames;
            mCurrentInstance.mNumPlayedGames &= 0x7FFFFFFF;
         }
         else if (oldPhase == MultiplePlayerDefine.InstancePhase_Inactive)
         {
            ResetInstanceChannels (true);
            needWriteChannelsInfo = true;
         }
         
         // ...
         
         if (shouldWriteMessages)
         {
            for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
            {
               if (mCurrentInstance.mSeatsViewer [seatIndex] == null)
                  continue;
               
               messagesData = GetInstanceSeatClientStream (seatIndex);
               
               // ...
               
               if (newPhase == MultiplePlayerDefine.InstancePhase_Playing)
               {
                  WriteMessage_InstancePlayingInfo (messagesData);
               }
               
               // ...
               
               if (needWriteChannelsInfo)
               {
                  WriteNonConstChannelsInfoIntoSeatStream (messagesData);
               }
               
               // ...
               
               if (flushMessages)
               {
                  FlushInstanceSeatClientStream (seatIndex);
               }
            }
         }
      }
      
//============================================================================
//   
//============================================================================
      
      private var mPosOfNumBytesInHeader:int = 0; // will be updated correctly.
      private var mPosOfNumMessagesInHeader:int = 0; // will be updated correctly.
      private var mNumBytesInHeader:int = 0;
      
      private function WriteMultiplePlayerMessagesHeader (serverMessagesData:ByteArray, numMessages:int):void
      {
         if (serverMessagesData == null)
            return;
         
         var currentDataLength:int = serverMessagesData.length;
         
         serverMessagesData.position = 0;
         
         serverMessagesData.writeUTFBytes (MultiplePlayerDefine.ServerMessageHeadString);
         
         // serverMessagesData.writeShort (MultiplePlayerDefine.ServerMessageDataFormatVersion);
            // server messages don't have a format.
            // server may return different message types on different client message data formats
         
         mPosOfNumBytesInHeader = serverMessagesData.position;
         
         serverMessagesData.writeInt (currentDataLength); // the whole length
         
         mPosOfNumMessagesInHeader = serverMessagesData.position;
         
         serverMessagesData.writeShort (numMessages); // some messages need to be handled together.
         
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
      
      private function UpdateInstanceClientStreamHeader (messagesData:ByteArray):void
      {
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
      
      // for scheduler server, designViewer != null
      // for instance server, designViewer == null
      private function FlushInstanceSeatClientStream (seatIndex:int, designViewer:Viewer = null):void
      {
         if (designViewer == null)
            designViewer = mCurrentInstance.mSeatsViewer [seatIndex];
         
         if (designViewer != null)
         {
            var messagesData:ByteArray = GetInstanceSeatClientStream (seatIndex);
            
            if (messagesData.length > mNumBytesInHeader)
            {
               var dataToSend:ByteArray = new ByteArray ();
               dataToSend.writeBytes (messagesData, 0, messagesData.length);
               dataToSend.position = 0;
               designViewer.OnMultiplePlayerServerMessages (dataToSend);
            }
         }
         
         ClearInstanceSeatClientStream (seatIndex);
      }
      
//============================================================================
//   
//============================================================================
      
      //private function WriteMessage_InstanceServerInfo (dataBuffer:ByteArray, instanceDefineDigest:String, playerConnectionId:String):void
      private function WriteMessage_InstanceServerInfo (dataBuffer:ByteArray, instanceDefineDigest:ByteArray, playerConnectionId:ByteArray):void
      {
         var ip:String = "127.0.0.1";
         
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceServerInfo);
         dataBuffer.writeByte (ip.length);
         dataBuffer.writeUTFBytes (ip); // host
         dataBuffer.writeShort (5678); // port
         dataBuffer.writeBytes (instanceDefineDigest, 0, MultiplePlayerDefine.Length_InstanceDefineHashKey); // dataBuffer.writeUTF (instanceDefineDigest);
         dataBuffer.writeBytes (playerConnectionId, 0, MultiplePlayerDefine.Length_PlayerConnID); // dataBuffer.writeUTF (playerConnectionId);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
//===============================================
      
      private function WriteMessage_Ping (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_Ping);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_Pong (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_Pong);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_QueuingInfo (dataBuffer:ByteArray, queueLength:int, myOrder:int):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_QueuingInfo);
         dataBuffer.writeShort (queueLength);
         dataBuffer.writeShort (myOrder);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_InstanceConstInfo (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceConstInfo);
         dataBuffer.writeBytes (mCurrentInstance.mID, 0, MultiplePlayerDefine.Length_InstanceID); // dataBuffer.writeUTF (mCurrentInstance.mID);
         dataBuffer.writeByte (mCurrentInstance.mNumSeats);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      //private function WriteMessage_LoggedOff (dataBuffer:ByteArray):void
      //{
      //   dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_LoggedOff);
      //   
      //   UpdateInstanceClientStreamHeader (dataBuffer);
      //}
      
      private function WriteMessage_MySeatIndex (dataBuffer:ByteArray, receiverSeatIndex:int):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_MySeatIndex);
         dataBuffer.writeByte (receiverSeatIndex);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_InstancePlayingInfo (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_InstancePlayingInfo);
         dataBuffer.writeInt (mCurrentInstance.mNumPlayedGames);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_InstanceCurrentPhase (dataBuffer:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_InstanceCurrentPhase);
         dataBuffer.writeByte (mCurrentInstance.mCurrentPhase);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_SeatBasicInfo (dataBuffer:ByteArray, seatIndex:int):void
      {
         var playerName:String = mCurrentInstance.mSeatsPlayerName [seatIndex];
         if (playerName == null)
            playerName = "";
            
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_SeatBasicInfo);
         dataBuffer.writeByte (seatIndex);
         dataBuffer.writeByte (playerName.length);
         if (playerName.length > 0)
            dataBuffer.writeUTFBytes (playerName);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_SeatDynamicInfo (dataBuffer:ByteArray, seatIndex:int):void
      {
         var lastActiveTime:int = 0x7FFFFFFF & mCurrentInstance.mSeatsLastActiveTime [seatIndex];
         var isJoiined:Boolean = mCurrentInstance.mSeatsViewer [seatIndex] != null;
         if (isJoiined)
            lastActiveTime |= 0x80000000;
         
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_SeatDynamicInfo);
         dataBuffer.writeByte (seatIndex);
         dataBuffer.writeInt (lastActiveTime);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
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
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_ChannelDynamicInfo (dataBuffer:ByteArray, channelIndex:int):void
      {
         var channel:Object = mCurrentInstance.mChannels [channelIndex];
         
         var verifyNumber:int = channel.mVerifyNumber;
         
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_ChannelDynamicInfo);
         dataBuffer.writeByte (channelIndex);
         dataBuffer.writeShort (verifyNumber);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_ChannelSeatInfo (dataBuffer:ByteArray, channelIndex:int, seatIndex:int):void
      {
         var channel:Object = mCurrentInstance.mChannels [channelIndex];
         
         var enabledTime:int = 0x7FFFFFFF & (int (Math.round (channel.mSeatsLastEnabledTime [seatIndex] * 8 / 1000)));
         if (channel.mIsSeatsEnabled [seatIndex])
            enabledTime |= 0x80000000;
         
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_ChannelSeatInfo);
         dataBuffer.writeByte (channelIndex);
         dataBuffer.writeByte (seatIndex);
         dataBuffer.writeInt (enabledTime);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
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
            var dataLength:int = messageData.length & 0x7FFFFFFF;
            
            dataBuffer.writeInt (dataLength);
            dataBuffer.writeBytes (messageData, 0, dataLength);
         }
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_ChannelMessageEncrypted (dataBuffer:ByteArray, encryptionIndex:int, encryptedMessageData:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_ChannelMessageEncrpted);
         
         dataBuffer.writeInt (encryptionIndex);
         
         if (encryptedMessageData == null)
            dataBuffer.writeInt (-1);
         else
         {
            var dataLength:int = encryptedMessageData.length & 0x7FFFFFFF;
            
            dataBuffer.writeInt (dataLength);
            dataBuffer.writeBytes (encryptedMessageData, 0, dataLength);
         }
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_ChannelMessageEncryptionCiphers (dataBuffer:ByteArray, channelIndex:int, senderSeatIndex:int, encryptionIndex:int, encryptionMethod:int, encryptionCipherData:ByteArray):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_ChannelMessageEncrptionCiphers);

         dataBuffer.writeByte (channelIndex);
         dataBuffer.writeByte (senderSeatIndex);
         
         dataBuffer.writeInt ((encryptionIndex << 8) | (encryptionMethod & 0xFF));
         
         if (encryptionCipherData == null) // can't be null
            dataBuffer.writeByte (0);
         else
         {
            var cipherDataLength:int = encryptionCipherData.length & 0xFF; // max 255
            
            dataBuffer.writeByte (cipherDataLength);
            dataBuffer.writeBytes (encryptionCipherData, 0, cipherDataLength);
         }
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
      private function WriteMessage_PlayerStatus (dataBuffer:ByteArray, playerStatus:int):void
      {
         dataBuffer.writeShort (MultiplePlayerDefine.ServerMessageType_PlayerStatus);
         
         dataBuffer.writeByte (playerStatus);
         
         UpdateInstanceClientStreamHeader (dataBuffer);
      }
      
//============================================================================
//   
//============================================================================
      
      //private function OnCreateNewInstanceRequest (instanceDefine:Object, password:String, designViewer:Viewer):void
      //{
      //   if (instanceDefine.mInstanceDefineData == null)
      //      return;
      //   
      //   if (mCurrentInstance != null)
      //   {
      //      CloseInstance ();
      //   }
      //   
      //   CreateInstance (instanceDefine, password);
      //   
      //   HandleJoinInstanceRequest (mCurrentInstance, password, designViewer);
      //}
      
      private function OnJoinRandomInstanceRequest (instanceDefine:Object, designViewer:Viewer):void
      {
         if (instanceDefine == null)
            return;
         
         // the simulated server only allow most one instance runs now.
         
         var toCreateNewInstance:Boolean = mCurrentInstance == null
                        || mCurrentInstance.mPlayersStatus != MultiplePlayerDefine.PlayerStatus_Queuing
                        || mCurrentInstance.mInstanceDefineData.length != instanceDefine.mInstanceDefineData.length
                        || DataFormat3.CompareTwoByteArrays (mCurrentInstance.mInstanceDefineDigest, instanceDefine.mInstanceDefineDigest) == false
                     ;
         
         if (toCreateNewInstance)
         {
            CreateInstance (instanceDefine, ""); // which will close current instance
         }
         
         HandleJoinInstanceRequest (instanceDefine, "", designViewer);
      }
      
//============================================================================
      
      private function OnPlayerLoginInstanceServer (designViewer:Viewer, playerConnectionId:ByteArray, clientDataFormatVersion:int):void
      {
         if (mCurrentInstance == null)
            return;
         
         if (playerConnectionId == null || playerConnectionId.length != MultiplePlayerDefine.Length_PlayerConnID)
            return;
         
         //var newPlayerSeatIndex:int = mCurrentInstance.mSeatsPlayerConnectionID.indexOf (playerConnectionId);
         var newPlayerSeatIndex:int = GetSeatIndexByPlayerConnectionID (playerConnectionId);
         if (newPlayerSeatIndex < 0)
            return;
         
         // ...
         
         if (mCurrentInstance.mSeatsViewer [newPlayerSeatIndex] != null) // already logged in
            return;
         
         var nowTimer:int = getTimer ();
         
         mCurrentInstance.mSeatsViewer [newPlayerSeatIndex] = designViewer;
         
         mCurrentInstance.mSeatsClientDataFormatVersion [newPlayerSeatIndex] = clientDataFormatVersion;
         //mCurrentInstance.mSeatsLastActiveTime [newPlayerSeatIndex] = nowTimer;
         //mCurrentInstance.mSeatsLastPingTime [newPlayerSeatIndex] = nowTimer;
         mCurrentInstance.mSeatsLastPongTime [newPlayerSeatIndex] = nowTimer;
      }
      
      private function OnJoinRandomInstance (designViewer:Viewer, instanceDefineDigest:ByteArray):void
      {
         //if (mCurrentInstance == null || instanceDefineDigest != mCurrentInstance.mInstanceDefineDigest)
         if (mCurrentInstance == null || DataFormat3.CompareTwoByteArrays (instanceDefineDigest, mCurrentInstance.mInstanceDefineDigest) == false)
            return;
            
         // ... 
         
         var newPlayerSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (newPlayerSeatIndex < 0)
            return;
         
         mCurrentInstance.mSeatsLastPongTime [newPlayerSeatIndex] = getTimer ();
         
         // ...
         
         if (mCurrentInstance.mPlayersStatus != MultiplePlayerDefine.PlayerStatus_Queuing
           || mCurrentInstance.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Inactive)
         {
            return; // impossible
         }
         
         // ...
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         
         var messagesData:ByteArray;
         
         // ...
         
         var numPlayersInQueue:int = 0;
         var newPlayerOrder:int = 0;
         var newPlayerJoinedTime:int = mCurrentInstance.mSeatsLastActiveTime [newPlayerSeatIndex];
         
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {
            if (mCurrentInstance.mSeatsViewer [seatIndex] != null)
            {
               ++ numPlayersInQueue;
               if (mCurrentInstance.mSeatsLastActiveTime [seatIndex] < newPlayerJoinedTime)
                  ++ newPlayerOrder;
            }
         }
         
         if (numPlayersInQueue < numSeats) // 
         {
            messagesData = GetInstanceSeatClientStream (newPlayerSeatIndex);
            
            // ...
            
            WriteMessage_PlayerStatus (messagesData, MultiplePlayerDefine.PlayerStatus_Queuing);
            
            // ...
            
            WriteMessage_QueuingInfo (messagesData, numPlayersInQueue, newPlayerOrder);
            
            // ...
            
            FlushInstanceSeatClientStream (newPlayerSeatIndex);
         }
         else // start playing
         {
            // delay todo: random swap and disorder player indexes. 
            
            // ...
            
            ChangeInstancePhase (MultiplePlayerDefine.InstancePhase_Playing, false, false);
            
            // ...
            
            for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
            {
               NotifyNewPlayerJoinedInstance (seatIndex, true);
            }
         }
      }
      
      //private function OnPlayerLeaveCurrentInstance (designViewer:Viewer):void
      //{
      //   if (mCurrentInstance == null)
      //      return;
      //   
      //   var senderSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
      //   if (senderSeatIndex < 0)
      //      return;
      //   
      //   // ...
      //   
      //   var messagesData:ByteArray = GetInstanceSeatClientStream (senderSeatIndex);
      //   
      //   WriteMessage_LoggedOff (messagesData);
      //   
      //   // ...
      //   
      //   ResetInstanceSeat (senderSeatIndex);
      //   
      //   // ...
      //   
      //   var numSeats:int = mCurrentInstance.mNumSeats;
      //   var seatIndex:int;
      //   
      //   for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
      //   {
      //      if (seatIndex == senderSeatIndex)
      //         continue;
      //      
      //      messagesData = GetInstanceSeatClientStream (seatIndex);
      //      
      //      // ...
      //      
      //      WriteMessage_SeatBasicInfo (messagesData, senderSeatIndex)
      //      
      //      // ...
      //      
      //      WriteMessage_SeatDynamicInfo (messagesData, senderSeatIndex);
      //   }
      //   
      //   // ...
      //   
      //   // write player status
      //   
      //   // ...
      //   
      //   for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
      //   {
      //      FlushInstanceSeatClientStream (seatIndex);
      //   }
      //}
      
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
         
         // ...
         
         FlushInstanceSeatClientStream (senderSeatIndex);
      }
      
      private function OnPong (designViewer:Viewer):void
      {
         if (mCurrentInstance == null)
            return;
         
         var senderSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (senderSeatIndex < 0)
            return;
         
         mCurrentInstance.mSeatsLastPongTime [senderSeatIndex] = getTimer ();
      }

      // messageEncryptionMethod and messageCipherData are only valid for messages needing to hold.
      //private function OnChannelMessage (designViewer:Viewer, numPlayedGames:int, channelIndex:int, verifyNumber:int, theMessageData:ByteArray, messageEncryptionMethod:int, messageCipherData:ByteArray):void
      private function OnChannelMessage (senderSeatIndex:int, numPlayedGames:int, channelIndex:int, verifyNumber:int, theMessageData:ByteArray, messageEncryptionMethod:int, messageCipherData:ByteArray):void
      {
         if (mCurrentInstance == null)
            return;
         
         mCurrentInstance.mSeatsLastPongTime [senderSeatIndex] = getTimer ();
         
         if (mCurrentInstance.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing)
            return;
         
         if (mCurrentInstance.mNumPlayedGames != numPlayedGames)
            return;
         
         //var senderSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (senderSeatIndex < 0)
            return;
         
         var channel:Object = mCurrentInstance.mChannels [channelIndex];
         if (channel == null)
            return;
         
         if (! channel.mIsSeatsEnabled [senderSeatIndex])
            return;
         
         if ((channel.mVerifyNumber & 0xFFFF) != verifyNumber)
            return;
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         var messagesData:ByteArray;
         
         var nowTimer:int = getTimer ();
         
         switch (channel.mChannelMode)
         {
            case MultiplePlayerDefine.InstanceChannelMode_Chess:
            
               channel.mIsSeatsEnabled [senderSeatIndex] = false;
               var nextEnabledSeatIndex:int = senderSeatIndex >= numSeats - 1 ? 0 : senderSeatIndex + 1;
               channel.mIsSeatsEnabled [nextEnabledSeatIndex] = true;
               channel.mSeatsLastEnabledTime [nextEnabledSeatIndex] = nowTimer;
               ++ channel.mVerifyNumber; // turn ++
               
               for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
               {
                  messagesData = GetInstanceSeatClientStream (seatIndex);
                  
                  // ...
                  
                  WriteMessage_ChannelSeatInfo (messagesData, channelIndex, senderSeatIndex);
                  
                  // ...
                  
                  WriteMessage_ChannelSeatInfo (messagesData, channelIndex, nextEnabledSeatIndex);
            
                  // ...
                  
                  WriteMessage_ChannelDynamicInfo (messagesData, channelIndex);
               }
               
               // not break here
            case MultiplePlayerDefine.InstanceChannelMode_Free:
               
               if (messageEncryptionMethod >= 0)
                  return;
               
               for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
               {
                  messagesData = GetInstanceSeatClientStream (seatIndex);
                  
                  WriteMessage_ChannelMessage (messagesData, channelIndex, senderSeatIndex, theMessageData);
                  
                  // 
                  FlushInstanceSeatClientStream (seatIndex);
               }
               
               break;
            
            case MultiplePlayerDefine.InstanceChannelMode_WeGo:
            {
               var wegoMessages:Array = channel.mSeatsMessage;
               var wegoMessageEncryptionIndexes:Array = channel.mSeatsMessageEncryptionIndex;
               var wegoMessagesEncryptionMethod:Array = channel.mSeatsMessageEncryptionMethod;
               
               //if (wegoMessages != null && wegoMessages [senderSeatIndex] == null) // bug: may be a pass already in holding
               if (channel.mIsSeatsMessageInHolding != null && channel.mIsSeatsMessageInHolding [senderSeatIndex] == false)
               {
                  channel.mIsSeatsEnabled [senderSeatIndex] = false;
                  channel.mIsSeatsMessageInHolding [senderSeatIndex] = true;
                  
                  if (messageEncryptionMethod >= 0)
                  {
                     wegoMessages [senderSeatIndex] = messageCipherData;
                     wegoMessageEncryptionIndexes [senderSeatIndex] = GetNextMessageEncryptionIndex ();
                     wegoMessagesEncryptionMethod [senderSeatIndex] = messageEncryptionMethod;
                     
                  }
                  else
                  {
                     wegoMessages [senderSeatIndex] = theMessageData;
                  }
                  
                  var allHaveSent:Boolean = true;
                  for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                  {
                     //if (wegoMessages [seatIndex] == null) // bug! may be "pass" null data
                     if (! channel.mIsSeatsMessageInHolding [seatIndex])
                     {
                        allHaveSent = false;
                        break;
                     }
                  }
                  
                  // ...
                  
                  var iSeat:int;
                  
                  if (allHaveSent)
                  {
                     ++ channel.mVerifyNumber; // round ++
                     
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        channel.mIsSeatsEnabled [seatIndex] = true;
                        channel.mSeatsLastEnabledTime [seatIndex] = nowTimer;
                     }
                     
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        messagesData = GetInstanceSeatClientStream (seatIndex);
                  
                        // ...
                        
                        WriteMessage_ChannelDynamicInfo (messagesData, channelIndex);
                        
                        // ...
                        
                        for (iSeat = 0; iSeat < numSeats; ++ iSeat)
                        {
                           WriteMessage_ChannelSeatInfo (messagesData, channelIndex, iSeat);
                        }
                     }
                  }
                  else
                  {
                  
                  // ...

                     //for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     //{
                     //   messagesData = GetInstanceSeatClientStream (seatIndex);
                     //   
                     //   WriteMessage_ChannelSeatInfo (messagesData, channelIndex, senderSeatIndex);
                     //}
                     
                     // above is some info leaking.
                     
                     messagesData = GetInstanceSeatClientStream (senderSeatIndex);
                     
                     WriteMessage_ChannelSeatInfo (messagesData, channelIndex, senderSeatIndex);
                  }
                  
                  // ...
                  
                  if (messageEncryptionMethod >= 0)
                  {
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        messagesData = GetInstanceSeatClientStream (seatIndex);
                        
                        WriteMessage_ChannelMessageEncrypted (messagesData, wegoMessageEncryptionIndexes [senderSeatIndex], theMessageData);
                     }
                  }
                  
                  // ...
                  
                  if (allHaveSent)
                  {
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        messagesData = GetInstanceSeatClientStream (seatIndex);
                        
                        // ...
                        
                        for (iSeat = 0; iSeat < numSeats; ++ iSeat)
                        {
                           if (wegoMessageEncryptionIndexes [iSeat] >= 0)
                              WriteMessage_ChannelMessageEncryptionCiphers (messagesData, channelIndex, iSeat, wegoMessageEncryptionIndexes [iSeat], wegoMessagesEncryptionMethod [iSeat], wegoMessages [iSeat]);
                           else
                              WriteMessage_ChannelMessage (messagesData, channelIndex, iSeat, wegoMessages [iSeat]);
                        }
                     }
                     
                     //
                     
                     for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
                     {
                        channel.mIsSeatsMessageInHolding [seatIndex] = false;
                        wegoMessages [seatIndex] = null;
                        wegoMessageEncryptionIndexes [seatIndex] = -1;
                        wegoMessagesEncryptionMethod [seatIndex] = -1;
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
      
      private function OnSignal_ChangeInstancePhase (designViewer:Viewer, newPhase:int):void
      {
         if (mCurrentInstance == null)
            return;
         
         if (newPhase == mCurrentInstance.mCurrentPhase || (! MultiplePlayerDefine.IsValidInstancePhase (newPhase)))
            return;
         
         var senderSeatIndex:int = mCurrentInstance.mSeatsViewer.indexOf (designViewer);
         if (senderSeatIndex < 0)
            return;
         
         // ...
         
         var nowTimer:int = getTimer ();
         
         mCurrentInstance.mSeatsLastPongTime [senderSeatIndex] = nowTimer;
         
         // ... 
         
         if (mCurrentInstance.mSeatsSignal_ChangePhase_TargetPhase == null || mCurrentInstance.mSeatsSignal_ChangePhase_ArrivalTime == null)
            return;
         
         mCurrentInstance.mSeatsSignal_ChangePhase_TargetPhase [senderSeatIndex] = newPhase;
         mCurrentInstance.mSeatsSignal_ChangePhase_ArrivalTime [senderSeatIndex] = nowTimer;
         
         // ...
         
         var shouldChange:Boolean = true;
         
         var numSeats:int = mCurrentInstance.mNumSeats;
         var seatIndex:int;
         for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
         {
            if (mCurrentInstance.mSeatsViewer [seatIndex] == null)
               continue;
            
            if ( mCurrentInstance.mSeatsSignal_ChangePhase_ArrivalTime [seatIndex] == 0 
               || mCurrentInstance.mSeatsSignal_ChangePhase_TargetPhase [seatIndex] != newPhase)
            {
               shouldChange = false;
               break;
            }
         }
         
         if (shouldChange)
         {
            for (seatIndex = 0; seatIndex < numSeats; ++ seatIndex)
            {
               mCurrentInstance.mSeatsSignal_ChangePhase_TargetPhase [seatIndex] = MultiplePlayerDefine.InstancePhase_Invalid;
               mCurrentInstance.mSeatsSignal_ChangePhase_ArrivalTime [seatIndex] = 0;
            }
            
            ChangeInstancePhase (newPhase, true, true);
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
         if (mCurrentInstance == null)
            return;
         
         OnClientMessages (messagesData, designViewer);
      }
      
      // don't change this name, 
      private function OnClientMessages (messagesData:ByteArray, designViewer:Viewer):void
      {         
         try
         {
            var method:String = messagesData.readUTFBytes (MultiplePlayerDefine.ClientMessageHeadString.length);
            //if (method !== MultiplePlayerDefine.ClientMessageHeadString)
            //   ...
            
            var dataLength:int = messagesData.readInt ();
            //if (dataLength > )
            //   ...
//trace (">>>, dataLength = " + dataLength + ", messagesData.length = " + messagesData.length);
            
            var numMessages:int = messagesData.readShort ();
            //if (numMessages > )
            //   ...
//trace (">>>, numMessages = " + numMessages);
            
            for (var msgIndex:int = 0; msgIndex < numMessages; ++ msgIndex)
            {
               var clientMessageType:int = messagesData.readShort () & 0xFFFF;
               
               var instanceDefineDigest:ByteArray; //String;
               var connectionId:ByteArray; //String;
               var clientDataFormatVersion:int;
               
               var messageEncryptionMethod:int = -1;
               var messageCipherData:ByteArray = null;
               var messageCipherDataLength:int = 0;
               
//trace (">>> clientMessageType = 0x" + clientMessageType.toString (16));
               switch (clientMessageType)
               {
               // ...
               
                  //case MultiplePlayerDefine.ClientMessageType_CreateInstanceRequest:
                  //
                  //   clientDataFormatVersion = messagesData.readShort () & 0xFFFF;
                  //
                  //   OnCreateNewInstanceRequest (designViewer, 
                  //                        ReadInstanceDefine (messagesData, clientDataFormatVersion), 
                  //                        messagesData.readUTF (), // password, to use ReadUnsignedByte + readUTFBytes
                  //                        );
                  //   break;
                  case MultiplePlayerDefine.ClientMessageType_JoinRandomInstanceRequest:
                     
                     clientDataFormatVersion = messagesData.readShort () & 0xFFFF;
                     OnJoinRandomInstanceRequest (ReadInstanceDefine (messagesData, clientDataFormatVersion), 
                                           designViewer
                                           );
                     
                     break;
               
               // above is for scheduler server
               //------------------------------
               // following for instance server
               
               // ...
               
                  case MultiplePlayerDefine.ClientMessageType_LoginInstanceServer:
                     
                     clientDataFormatVersion = messagesData.readUnsignedShort ();
                     connectionId = DataFormat3.ByteArrayReadBytes (messagesData, MultiplePlayerDefine.Length_PlayerConnID); //messagesData.readUTF ();
                     
                     OnPlayerLoginInstanceServer (designViewer,
                                                  connectionId,
                                                  clientDataFormatVersion
                                                 );
                     
                     break;
               
               // for all following cases, 
               //   clientDataFormatVersion = mCurrentInstance.mSeatsClientDataFormatVersion [playerSeatIndex]
               //   playerConnectionId = mCurrentInstance.mSeatsPlayerConnectionID [playerSeatIndex]
                     
                  //case MultiplePlayerDefine.ClientMessageType_LeaveCurrentInstance:
                  //   
                  //   OnPlayerLeaveCurrentInstance (designViewer);
                  //   
                  //   break;
                  
                  case MultiplePlayerDefine.ClientMessageType_JoinRandomInstance:
                     
                     instanceDefineDigest = DataFormat3.ByteArrayReadBytes (messagesData, MultiplePlayerDefine.Length_InstanceDefineHashKey); // messagesData.readUTF ();
                     
                     OnJoinRandomInstance (designViewer,
                                           instanceDefineDigest
                                          );
                     
                     break;
               
                  case MultiplePlayerDefine.ClientMessageType_Ping:
                  
                     OnPing (designViewer);
               
                     break;
                     
                  case MultiplePlayerDefine.ClientMessageType_Pong:
                  
                     OnPong (designViewer);
               
                     break;
               
                  case MultiplePlayerDefine.ClientMessageType_ChannelMessageWithEncrption:
                     
                     messageEncryptionMethod = messagesData.readUnsignedByte ();
                     messageCipherDataLength = messagesData.readUnsignedByte ();
                     if (messageCipherDataLength > MultiplePlayerDefine.MaxMessageDataLengthToHoldReally)
                        throw new Error ();
                     messageCipherData = new ByteArray ();
                     messagesData.readBytes (messageCipherData, 0, messageCipherDataLength);
                     
                     // no break here
                     
                  case MultiplePlayerDefine.ClientMessageType_ChannelMessage:
                     
                     var numPlayedGames:int = messagesData.readInt ();
                     
                     var messageChannelIndex:int = messagesData.readUnsignedByte ();
                     var messageChannelVerifyNumber:int = messagesData.readUnsignedShort ();
                     var messageChannelMessageLength:int = messagesData.readInt ();
                     var messageChannelMessageData:ByteArray = null;
                     
                     if (messageChannelMessageLength >= 0)
                     {
                        messageChannelMessageLength &= 0x7FFFFFFF;
                        messageChannelMessageData = new ByteArray ();
                        if (messageChannelMessageLength > 0)
                        {
                           messagesData.readBytes (messageChannelMessageData, 0, messageChannelMessageLength);
                        }
                     }
                     
                     if (messageEncryptionMethod < 0 && messageChannelMessageLength > MultiplePlayerDefine.MaxMessageDataLengthToHoldReally)
                     {
                        messageEncryptionMethod = MultiplePlayerDefine.MessageEncryptionMethod_DoNothing;
                        messageCipherData = new ByteArray ();
                     }
                     
                     //OnChannelMessage (designViewer, numPlayedGames, messageChannelIndex, messageChannelVerifyNumber, messageChannelMessageData, messageEncryptionMethod, messageCipherData);
                     OnChannelMessage (mCurrentInstance.mSeatsViewer.indexOf (designViewer), numPlayedGames, messageChannelIndex, messageChannelVerifyNumber, messageChannelMessageData, messageEncryptionMethod, messageCipherData);
                     
                     break;
                     
                  case MultiplePlayerDefine.ClientMessageType_Signal_ChangeInstancePhase:
                     
                     var newPhase:int = messagesData.readByte ();
                     
                     OnSignal_ChangeInstancePhase (designViewer, newPhase);
                     
                     break;
                     
                  default:
                  {
                     trace ("unknown client message type: 0x" + clientMessageType.toString (16));
                     if (Capabilities.isDebugger)            
                        throw new Error ();;
                     
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
         
         var numSeats:int = instanceDefineData.readByte ();
         
         var gameIdLen:int = instanceDefineData.readUnsignedByte ();
         var gameID:String = instanceDefineData.readUTFBytes (gameIdLen);
         
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
            channelDefine.mTurnTimeoutSecondsX8 &= 0x7FFFFFFF;
            if (channelDefine.mTurnTimeoutSecondsX8 > MultiplePlayerDefine.MaxTurnTimeoutX8InPractice)
               channelDefine.mTurnTimeoutSecondsX8 = MultiplePlayerDefine.MaxTurnTimeoutX8InPractice;
         }
         
         // ...
         
         return {
            mInstanceDefineData : instanceDefineData, 
            mInstanceDefineDigest : SHA256.computeDigest (instanceDefineData),
            
            mGameID : gameID,
            mNumSeats : numSeats,
            mEnabledChannelIndexes : enabledChannelIndexes,
            mEnabledChannelDefines : enabledChannelDefines 
         };
      }
      
   }
}
