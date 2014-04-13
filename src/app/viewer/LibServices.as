
//   private function SubmitHighScore (value:Number):void
//   {
////trace ("SubmitHighScore> " + value);
//      if (mParamsFromContainer.ExternalSubmitKeyValue != null)
//      {
//         mParamsFromContainer.ExternalSubmitKeyValue ("HighScore", value);
//               // please see GamePackaer.OnlineAPI for detail.
//      }
//   }
   
   // the api name for designer should be changed to "SubmitKeyValueToHostWebsite"
   private function SubmitKeyValue (key:String, value:Number):void
   {
//trace ("SubmitKeyValue> " + key + " = " + value);
      if (mParamsFromContainer.ExternalSubmitKeyValue != null)
      {
         mParamsFromContainer.ExternalSubmitKeyValue (key, value);
               // please see GamePackager.OnlineAPI for detail.
      }
   }
   
//==================================================================
// debug info
//==================================================================
   
   //private var mIsMultiplePlayerInstanceInfoShown:Boolean = false;
   //
   //// callback for world
   //private function SetMultiplePlayerInstanceInfoShown (show:Boolean):void
   //{
   //   if (mIsMultiplePlayerInstanceInfoShown != show)
   //   {
   //      mIsMultiplePlayerInstanceInfoShown = show;
   //      
   //      UpdateMultiplePlayerInstanceInfoText ();
   //   }
   //}
   //
   //private function UpdateMultiplePlayerInstanceInfoText ():void
   //{
   //   if (mIsMultiplePlayerInstanceInfoShown)
   //   {
   //   }
   //}
   
//==================================================================
// 
//==================================================================

   private var mJoinInstanceFrequencyStat:FrequencyStat = new FrequencyStat (3, 60000); // most 3 times in one minute
   
   private var mClientMessagesFrequencyStat:FrequencyStat = new FrequencyStat (20, 60000); // most 20 times in one minute
   
   private function UpdateMultiplePlayer ():void
   {
      if (mMultiplePlayerInstanceInfo != null && mMultiplePlayerInstanceInfo.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing)
      {
         // ...
      }
      
      if (mCurrentJointInstanceRequestData != null)
      {
         if (mJoinInstanceFrequencyStat.Hit (getTimer ()))
         {
            mCurrentJointInstanceRequestData.position = 0;
            
            SendMultiplePlayerClientMessagesToSchedulerServer (mCurrentJointInstanceRequestData);
            
            mCurrentJointInstanceRequestData = null;
         }
         
         return;
      }
      
      if (GetNumCachedClientMessages () > 0)
      {
         if (mClientMessagesFrequencyStat.Hit (getTimer ()))
         {
            var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
            
            var dataToSend:ByteArray = new ByteArray ();
            dataToSend.writeBytes (cachedMessagesData, 0, cachedMessagesData.length);
            dataToSend.position = 0;
            SendMultiplePlayerClientMessagesToInstanceServer (dataToSend);
            
            ClearCachedClientMessages ();
         }
      }
   }
   
//======================================================
// client -> server 
//======================================================
   
   private static var mNextRequestID:int = 0;
   
   // start server
   private static const kStartServer:String = "http://mp.phyard.com/";
   
   // lobby server
   private var mMultiplePlayerSchedulerServerAddress:String = "http://mpsdl.phyard.com/bapi/"; // binary api calling entry
   
   private function SendMultiplePlayerClientMessagesToSchedulerServer (messagesData:ByteArray):void
   {
      if (mParamsFromEditor != null)
      {
         mParamsFromEditor.OnMultiplePlayerClientMessagesToSchedulerServer (messagesData, this);
      }
      else
      {
         // URLLoader
      }
   }
   
   //---------------
   
   private function SendMultiplePlayerClientMessagesToInstanceServer (messagesData:ByteArray):void
   {
      if (mParamsFromEditor != null)
      {
         mParamsFromEditor.OnMultiplePlayerClientMessagesToInstanceServer (messagesData, this);
      }
      else
      {
         if (mMultiplePlayerInstanceInfo.mServerSocket != null)
         {
            // mMultiplePlayerInstanceInfo.mServerSocket.writeBytes
         }
      }
   }
   
   private function DisonnectToInstanceServer ():void
   {
      if (mMultiplePlayerInstanceInfo.mIsServerConnected)
      {
         if (mMultiplePlayerInstanceInfo.mServerSocket != null && mMultiplePlayerInstanceInfo.mServerSocket.connected)
         {
            try
            {
               var theSocket:Socket = mMultiplePlayerInstanceInfo.mServerSocket;
               mMultiplePlayerInstanceInfo.mServerSocket = null;
               theSocket.close ();
            }
            catch (error:Error)
            {
            }
         }
         
         OnInstanceServerClosed (null);
      }
   }
   
   private function ConnectToInstanceServer ():void
   {
      DisonnectToInstanceServer ();
      
      if (IsInstanceServerInfoRetrieved ())
      {
         if (mParamsFromEditor != null)
         {
            mMultiplePlayerInstanceInfo.mIsServerConnected = true;
            
            OnInstanceServerConnected ();
         }
         else
         {  
            try
            {
               var theSocket:Socket = new Socket ();
               
               theSocket.addEventListener(Event.CLOSE, OnInstanceServerClosed);
               theSocket.addEventListener(Event.CONNECT, OnInstanceServerConnected);
               theSocket.addEventListener(IOErrorEvent.IO_ERROR, OnInstanceServerClosed);
               theSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnInstanceServerClosed);
               theSocket.addEventListener(ProgressEvent.SOCKET_DATA, OnInstanceServerSocketData);
               
               theSocket.connect (mMultiplePlayerInstanceInfo.mServerAddress, mMultiplePlayerInstanceInfo.mServerPort);
               
               mMultiplePlayerInstanceInfo.mServerSocket = theSocket;
            }
            catch (error:Error)
            {
               
            }
         }
      }
   }
   
   private function OnInstanceServerConnected (event:Event = null):void
   {
      if (event != null && event.target != mMultiplePlayerInstanceInfo.mServerSocket)
         return; // this may be previous discarded socket. 
      
      mClientMessagesFrequencyStat.Reset ();
      ClearCachedClientMessages ();
      
      WriteMessage_LoginInstanceServer ();
   }
   
   // event == null means close-manually
   private function OnInstanceServerClosed (event:Event = null):void
   {
      if (event != null && event.target != mMultiplePlayerInstanceInfo.mServerSocket)
         return; // this may be previous discarded socket. 
      
      // ...
      
      mMultiplePlayerInstanceInfo.mIsServerConnected = false;
      
      mMultiplePlayerInstanceInfo.mIsServerLoggedIn = false;
   }
   
   private function OnInstanceServerSocketData (event:ProgressEvent):void
   {
      if (event == null || event.target != mMultiplePlayerInstanceInfo.mServerSocket)
         return;
      
      // ...
      
      //var newMessagesData:ByteArray = new ByteArray ();
      
      //OnMultiplePlayerServerMessages (newMessagesData);
   }
   
//======================================================
// instance 
//======================================================
   
   private var mMultiplePlayerInstanceInfo:Object =  
   {
            mServerSocket : null,  // step 1
            
            mServerAddress : null,
            mServerPort : 0,
            
            mIsServerConnected : false, // step 2
            
            mID : "", // instance id, null or blank means invalid
            mMyConnectionID : "", // pls keep it non-null
            
            mIsServerLoggedIn : false, // step 3
            
            mNumPlayedGames : 0,
            
            // ====================== followings may be used by World, pls keep the compatibility =========================//
            
            mCurrentPhase : MultiplePlayerDefine.InstancePhase_Inactive,

            mNumSeats : 0,
            mMySeatIndex : -1,
            mSeatsPlayerName : null,
            mSeatsLastActiveTime : null,
            mIsSeatsConnected : null,
            
            mChannelsInfo : null,
                     // mChannelMode
                     // mTurnTimeoutMilliseconds // milliseconds, no X8
                     // mIsSeatsEnabled []
                     // mIsSeatsEnabled_Predicted []
                     // mSeatsLastEnableTime []
   
            mPendingEncryptedMessages : null // new Dictionary ()
   };
   
   private function IsInstanceServerInfoRetrieved ():Boolean
   {
      return   mMultiplePlayerInstanceInfo.mServerAddress != null 
            && mMultiplePlayerInstanceInfo.mServerAddress.length > 0 
            && mMultiplePlayerInstanceInfo.mServerPort > 0;
   }
   
   private function IsInstanceServerConnected ():Boolean
   {
      return mMultiplePlayerInstanceInfo.mIsServerConnected;
   }
   
   private function IsInstanceServerLoggedIn ():Boolean
   {
      return IsInstanceServerConnected () && mMultiplePlayerInstanceInfo.mIsServerLoggedIn;
   }
   
   private function SetInstanceServerInfo (serverAddress:String, serverPort:int, instanceId:String, connectionId:String):void
   {
//trace ("SetInstanceServerInfo, serverAddress = " + serverAddress + ":" + serverPort + ", instance id = " + instanceId + ", connectionId = " + connectionId);

      mMultiplePlayerInstanceInfo.mServerAddress = serverAddress;
      mMultiplePlayerInstanceInfo.mServerPort = serverPort;
      
      mMultiplePlayerInstanceInfo.mID = instanceId;
      mMultiplePlayerInstanceInfo.mMyConnectionID = connectionId;
      
      mMultiplePlayerInstanceInfo.mCurrentPhase = MultiplePlayerDefine.InstancePhase_Inactive;
   }
   
   private function SetInstanceBasicInfo (id:String, numPlayedGames:int, numSeats:int, mySeatIndex:int):void
   {
      if (id != mMultiplePlayerInstanceInfo.mID)
         return;
      if (numSeats < MultiplePlayerDefine.MinNumberOfInstanceSeats || numSeats > MultiplePlayerDefine.MaxNumberOfInstanceSeats)
         return;
      if (mySeatIndex < 0 || mySeatIndex >= numSeats)
         return;
      
      mMultiplePlayerInstanceInfo.mIsServerLoggedIn = true;
      
      mMultiplePlayerInstanceInfo.mNumPlayedGames = numPlayedGames;
      mMultiplePlayerInstanceInfo.mNumSeats = numSeats;
      mMultiplePlayerInstanceInfo.mMySeatIndex = mySeatIndex;
      
      mMultiplePlayerInstanceInfo.mSeatsPlayerName = new Array (numSeats);
      mMultiplePlayerInstanceInfo.mSeatsLastActiveTime = new Array (numSeats);
      mMultiplePlayerInstanceInfo.mIsSeatsConnected = new Array (numSeats);
      
      mMultiplePlayerInstanceInfo.mCurrentPhase = MultiplePlayerDefine.InstancePhase_Pending;
      
      // ...
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mInfoType: "InstanceBasicInfo"});
   }
   
   private function SetInstanceCurrentPhase (phase:int):void
   {
      if (     mMultiplePlayerInstanceInfo.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing 
            && phase == MultiplePlayerDefine.InstancePhase_Playing)
      {
         mMultiplePlayerInstanceInfo.mChannelsInfo = new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels);
         
         mMultiplePlayerInstanceInfo.mPendingEncryptedMessages = new Dictionary ();
      }
      else if (mMultiplePlayerInstanceInfo.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing 
            && phase != MultiplePlayerDefine.InstancePhase_Playing)
      {
         mMultiplePlayerInstanceInfo.mChannelsInfo = null;
         
         mMultiplePlayerInstanceInfo.mPendingEncryptedMessages = null;
      }
      
      mMultiplePlayerInstanceInfo.mCurrentPhase = phase;
      
      // ...
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mInfoType: "InstancePhaseInfo"});
   }
   
   private function SetSeatBasicInfo (seatIndex:int, playerName:String):void
   {
      if (seatIndex < 0 || seatIndex >= mMultiplePlayerInstanceInfo.mNumSeats)
         return;
      if (mMultiplePlayerInstanceInfo.mSeatsPlayerName == null)
         return;
      
      if (playerName == null)
         playerName = "";
      
      mMultiplePlayerInstanceInfo.mSeatsPlayerName [seatIndex] = playerName;
      
      // ...
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mInfoType: "SeatBasicInfo"});
   }
   
   private function SetSeatDanymicInfo (seatIndex:int, lastActiveTime:int, isConnected:Boolean):void
   {
      if (seatIndex < 0 || seatIndex >= mMultiplePlayerInstanceInfo.mNumSeats)
         return;
      if (mMultiplePlayerInstanceInfo.mSeatsLastActiveTime == null)
         return;
      if (mMultiplePlayerInstanceInfo.mIsSeatsConnected == null)
         return;
      
      mMultiplePlayerInstanceInfo.mSeatsLastActiveTime [seatIndex] = lastActiveTime;
      mMultiplePlayerInstanceInfo.mIsSeatsConnected [seatIndex] = isConnected;
      
      // ...
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mInfoType: "SeatDanymicInfo"});
   }
   
   private function SetChannelConstInfo (channelIndex:int, mode:int, timeoutX8:int):void
   {
      if (mMultiplePlayerInstanceInfo.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing)
         return;
      if (mMultiplePlayerInstanceInfo.mChannelsInfo == null)
         return;
      if (channelIndex < 0 || channelIndex >= MultiplePlayerDefine.MaxNumberOfInstanceChannels)
         return;
      
      var channelInfo:Object = mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex];
      if (channelInfo == null)
      {
         channelInfo = {
            //mChannelMode : mode,
            //mTurnTimeoutMilliseconds : timeoutX8 * 125.0,
            mIsSeatsEnabled : new Array (mMultiplePlayerInstanceInfo.mNumSeats),
            mIsSeatsEnabled_Predicted : new Array (mMultiplePlayerInstanceInfo.mNumSeats),
            mSeatsLastEnableTime : new Array (mMultiplePlayerInstanceInfo.mNumSeats)
         };
         
         mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex] = channelInfo;
      }

      channelInfo.mChannelMode = mode;
      channelInfo.mTurnTimeoutMilliseconds = timeoutX8 * 125.0;
      
      // ...
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mInfoType: "ChannelConstInfo"});
   }
   
   // SetChannelConstInfo muse be called before this function.
   private function SetChannelDynamicInfo (channelIndex:int, seatIndex:int, enabledTime:int, isSeatEnabled:Boolean):void
   {
      if (mMultiplePlayerInstanceInfo.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing)
         return;
      if (seatIndex < 0 || seatIndex >= mMultiplePlayerInstanceInfo.mNumSeats)
         return;
      if (channelIndex < 0 || channelIndex >= MultiplePlayerDefine.MaxNumberOfInstanceChannels)
         return;
      if (mMultiplePlayerInstanceInfo.mChannelsInfo == null)
         return;
      
      var channelInfo:Object = mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex];
      if (channelInfo == null)
         return;
      
      if (seatIndex < 0 || seatIndex >= mMultiplePlayerInstanceInfo.mNumSeats)
         return;
      
      channelInfo.mIsSeatsEnabled [seatIndex] = isSeatEnabled;
      channelInfo.mIsSeatsEnabled_Predicted [seatIndex] = isSeatEnabled;
      channelInfo.mSeatsLastEnableTime [seatIndex] = enabledTime;
      
      // ...
      if (mWorldDesignProperties != null)
      {
         mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mInfoType: "ChannelDynamicInfo"});
      }
   }
   
   private function OnInstanceChannelMessage (channelIndex:int, senderSeatIndex:int, messageData:ByteArray):void
   {
      if (mWorldDesignProperties != null)
      {
         mWorldDesignProperties.OnMultiplePlayerEvent ("OnChannelSeatMessage", 
                                                       {
                                                          mChannelIndex : channelIndex,
                                                          mSeatIndex : senderSeatIndex,
                                                          mMessageData : messageData
                                                       });
      }
   }
   
   private function OnInstanceChannelMessageEncrpted (encryptionIndex:int, encryptedMessageData:ByteArray):void
   {
      if (mMultiplePlayerInstanceInfo.mPendingEncryptedMessages == null)
         return;
      
      if (encryptedMessageData == null)
         return;
      
      mMultiplePlayerInstanceInfo.mPendingEncryptedMessages [encryptionIndex] = encryptedMessageData;
   }
   
   private function OnInstanceChannelMessageEncrptionCiphers (channelIndex:int, seatIndex:int, messageEncryptionIndex:int, messageEncryptionMethod:int, cipherData:ByteArray):void
   {
      if (mMultiplePlayerInstanceInfo.mPendingEncryptedMessages == null)
         return;
      
      var messageData:ByteArray = mMultiplePlayerInstanceInfo.mPendingEncryptedMessages [messageEncryptionIndex];
      if (messageData == null)
         return;
      
      delete mMultiplePlayerInstanceInfo.mPendingEncryptedMessages [messageEncryptionIndex];
      
      var validData:Boolean = false;
      
      do
      {
         if (messageEncryptionMethod == MultiplePlayerDefine.MessageEncryptionMethod_SwapRollShift)
         {
            var seed:uint = uint (cipherData.readInt ());
            
            Decryption_SwapRollShift (messageData, seed);
            
            validData = true;
            
            break;
         }
         else if (messageEncryptionMethod == MultiplePlayerDefine.MessageEncryptionMethod_DoNothing)
         {  
            validData = true;
         }
      }
      while (false);
      
      if (validData)
      {
         OnInstanceChannelMessage (channelIndex, seatIndex, messageData);
      }
   }
   
//======================================================
// 
//======================================================
   
   private static function Encryption_SwapRollShift (messageData:ByteArray, randomSeed:uint):void
   {
      // only swap the beginning bytes.
      
   }
   
   private static function Decryption_SwapRollShift (messageData:ByteArray, randomSeed:uint):void
   {
      // only swap the beginning bytes.
      
   }
   
//======================================================
// 
//======================================================
   
   private function WriteMultiplePlayerMessagesHeader (messagesData:ByteArray, numMessages:int):void
   {
      if (messagesData == null)
         return;
      
      messagesData.position = 0;

      messagesData.writeInt (messagesData.length); // the whole length 
      messagesData.writeShort (numMessages);
   }
   
   //---------
   
   private var mCachedClientMessagesData:ByteArray = null;
   private var mNumCachedClientMessages:int = 0;
   
   private function GetNumCachedClientMessages ():int
   {
      return mNumCachedClientMessages;
   }
   
   private function GetCachedClientMessagesData ():ByteArray
   {
      if (mCachedClientMessagesData == null)
      {
         mCachedClientMessagesData = new ByteArray ();
         ClearCachedClientMessages ();
      }
      
      return mCachedClientMessagesData;
   }
   
   private function ClearCachedClientMessages ():void
   {
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      mCachedClientMessagesData.length = 0;
      mNumCachedClientMessages = 0;
      
      WriteMultiplePlayerMessagesHeader (mCachedClientMessagesData, mNumCachedClientMessages);
   }
   
   private function UpdateCachedClientMessagesHeader ():void
   {
      ++ mNumCachedClientMessages;
      
      var posBackup:int = mCachedClientMessagesData.position;
      
      WriteMultiplePlayerMessagesHeader (mCachedClientMessagesData, mNumCachedClientMessages);
      
      mCachedClientMessagesData.position = posBackup;
   }
   
//======================================================
// write client messages
//======================================================
   
   private function WriteMessage_CreateInstance (buffer:ByteArray, instanceDefineData:ByteArray, password:String):void
   {     
      WriteMultiplePlayerMessagesHeader (buffer, 0);
      
      buffer.writeShort (MultiplePlayerDefine.ClientMessageType_CreateInstance);
      buffer.writeShort (MultiplePlayerDefine.ClientMessageDataFormatVersion);
      buffer.writeInt (instanceDefineData.length);
      buffer.writeBytes (instanceDefineData);
      buffer.writeUTF (mMultiplePlayerInstanceInfo.mMyConnectionID);
      buffer.writeUTF (password);
      
      WriteMultiplePlayerMessagesHeader (buffer, 1);
   }
   
   private function WriteMessage_JoinRandomInstance (buffer:ByteArray, instanceDefineData:ByteArray):void
   {     
      WriteMultiplePlayerMessagesHeader (buffer, 0);
      
      buffer.writeShort (MultiplePlayerDefine.ClientMessageType_JoinRandomInstance);
      buffer.writeShort (MultiplePlayerDefine.ClientMessageDataFormatVersion);
      buffer.writeInt (instanceDefineData.length);
      buffer.writeBytes (instanceDefineData);
      buffer.writeUTF (mMultiplePlayerInstanceInfo.mMyConnectionID);
      
      WriteMultiplePlayerMessagesHeader (buffer, 1);
   }
   
   //------------
   
   private function WriteMessage_Ping ():void
   {
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_Ping);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   private function WriteMessage_Pong ():void
   {
      // ...

      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();

      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_Pong);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   private function WriteMessage_LoginInstanceServer ():void
   {
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_LoginInstanceServer);
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageDataFormatVersion);
      cachedMessagesData.writeUTF (mMultiplePlayerInstanceInfo.mID);
      cachedMessagesData.writeUTF (mMultiplePlayerInstanceInfo.mMyConnectionID);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   private function WriteMessage_ExitCurrentInstance ():void
   {
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_ExitCurrentInstance);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   private function WriteMessage_ChannelMessage (channelIndex:int, messageData:ByteArray, needHolding:Boolean):void
   {
      var encryptionMethod:int = -1;
      
      if (needHolding && messageData != null && messageData.length > MultiplePlayerDefine.MaxMessageDataLengthToHoldReally)
      {
         // too long for server to hold, so we encrypt the data here, the server just holds the encryption ciphers.
         
         encryptionMethod = MultiplePlayerDefine.MessageEncryptionMethod_SwapRollShift;
      }
      
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      if (encryptionMethod >= 0)
      {
         cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_ChannelMessageWithEncrption);
         
         // .
         
         var cipherData:ByteArray = new ByteArray ();
         if (encryptionMethod == MultiplePlayerDefine.MessageEncryptionMethod_SwapRollShift)
         {
            var seed:uint = uint (Math.floor (Math.random () * (2.0 + 0x7FFFFFFF + 0x7FFFFFFF)));
            
            // ...
            
            cipherData.writeInt (int (seed));
            
            // ...
            
            Encryption_SwapRollShift (messageData, seed);
         }
         
         // .
         
         cachedMessagesData.writeByte (encryptionMethod);
         cachedMessagesData.writeByte (cipherData.length);
         cachedMessagesData.writeBytes (cipherData, 0, cipherData.length);
      }
      else
      {
         cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_ChannelMessage);
      }
      
      // ...
      
      cachedMessagesData.writeByte (channelIndex);
      
      // ...
      
      if (messageData == null) // pass
         cachedMessagesData.writeInt (-1);
      else
      {
         cachedMessagesData.writeInt (messageData.length & 0x7FFFFFFF);
         cachedMessagesData.writeBytes (messageData, 0, messageData.length);
      }
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   private function WriteMessage_Signal_RestartInstance ():void
   {
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_Signal_RestartInstance);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
//======================================================
// callbacks for world (be careful of compatibility problems)
//======================================================
   
   protected function MultiplePlayer_GetGameInstanceBasicInfo ():Object
   {
      return {
         mIsLoggedIn       : IsInstanceServerLoggedIn (),
         mIsInPlayingPhase : mMultiplePlayerInstanceInfo.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing,
         mNumSeats         : mMultiplePlayerInstanceInfo.mNumSeats, 
         mMySeatIndex      : mMultiplePlayerInstanceInfo.mMySeatIndex
      };
   }
   
   protected function MultiplePlayer_GetGameInstanceSeatInfo (seatIndex:int):Object
   {
      var badIndex:Boolean = seatIndex < 0 || seatIndex >= mMultiplePlayerInstanceInfo.mNumSeats;
      
      return {
         mPlayerName     : (badIndex || mMultiplePlayerInstanceInfo.mSeatsPlayerName == null) ? null : mMultiplePlayerInstanceInfo.mSeatsPlayerName [seatIndex],
         mLastActiveTime : (badIndex || mMultiplePlayerInstanceInfo.mSeatsLastActiveTime == null) ? 0 : mMultiplePlayerInstanceInfo.mSeatsLastActiveTime [seatIndex],
         mIsLoggedIn     : (badIndex || mMultiplePlayerInstanceInfo.mIsSeatsConnected == null) ? false : mMultiplePlayerInstanceInfo.mIsSeatsConnected [seatIndex]
      };
   }
   
   protected function MultiplePlayer_GetGameInstanceChannelSeatInfo (channelIndex:int, seatIndex:int):Object
   {
      var channelInfo:Object = null;
      
      if (  seatIndex >= 0 && seatIndex < mMultiplePlayerInstanceInfo.mNumSeats
         && channelIndex < 0 && channelIndex < MultiplePlayerDefine.MaxNumberOfInstanceChannels
         && mMultiplePlayerInstanceInfo.mChannelsInfo != null)
      {
         channelInfo = mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex];
      }
      
      return {
         mIsEnabled      : channelInfo == null || channelInfo.mIsSeatsEnabled_Predicted == null ? false : channelInfo.mIsSeatsEnabled_Predicted [seatIndex],
         mLastEnableTime : channelInfo == null || channelInfo.mSeatsLastEnableTime      == null ? 0     : channelInfo.mSeatsLastEnableTime      [seatIndex]
      }
   }
   
   // inputs
   //    mGameID
   //    mNumberOfSeats
   // outputs
   //    mInstanceDefine
   //       mGameID
   //       mNumberOfSeats
   //       mChannelDefines
   protected function MultiplePlayer_CreateInstanceDefine (params:Object):Object
   {
      var instanceDefine:Object = new Object ();
      
      // id
      instanceDefine.mGameID = params.mGameID;
      if (instanceDefine.mGameID.length > 60)
         instanceDefine.mGameID = instanceDefine.mGameID.substring (0, 60);
      
      // number of seats
      instanceDefine.mNumberOfSeats = params.mNumberOfSeats;
      
      // default channel
      instanceDefine.mChannelDefines = new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels);
      
      MultiplePlayer_ReplaceInstanceChannelDefine ({mInstanceDefine: instanceDefine, 
                                                    mChannelIndex: 0, 
                                                    mChannelDefine: MultiplePlayer_CreateInstanceChannelDefine ({
                                                       mChannelMode: MultiplePlayerDefine.InstanceChannelMode_Free,
                                                       mTurnTimeoutSeconds: MultiplePlayerDefine.MaxTurnTimeoutInPractice
                                                    }).mChannelDefine
                                                  })
      
      // ...
      return {mInstanceDefine: instanceDefine};
   }
   
   // inputs
   //    mChannelMode
   //    mTurnTimeoutSeconds
   // outputs
   //    mChannelDefine
   //       mChannelMode
   //       mTurnTimeoutSecondsX8
   protected function MultiplePlayer_CreateInstanceChannelDefine (params:Object):Object
   {
      var channelDefine:Object = new Object ();
      
      channelDefine.mChannelMode = params.mChannelMode;
      channelDefine.mTurnTimeoutSecondsX8 = int (params.mTurnTimeoutSeconds * 8);
      
      return {mChannelDefine: channelDefine};
   }
   
   // inputs
   //    mInstanceDefine
   //    mChannelIndex
   //    mChannelDefine
   // outputs
   //    mResult
   protected function MultiplePlayer_ReplaceInstanceChannelDefine (params:Object):Object
   {
      var succeeded:Boolean = false;
      
      do
      {
         var instacneDefine:Object = params.mInstanceDefine;
         if (instacneDefine == null)
            break;
         if (instacneDefine.mChannelDefines == null)
            break;
         if (params.mChannelIndex < 0 && params.mChannelIndex >= MultiplePlayerDefine.MaxNumberOfInstanceChannels)
            break;
         
         instacneDefine.mChannelDefines [params.mChannelIndex] = params.mChannelDefine;
         
         succeeded = true;
      }
      while (false);
      
      return {mResult: succeeded};
   }

   //========================
   
   private var mCurrentJointInstanceRequestData:ByteArray = null;
   
   // inputs
   //    mInstanceDefine
   //    mPassword
   protected function MultiplePlayer_JoinNewInstance (params:Object):Object
   {
      var cached:Boolean = false;
      
      do
      {
         var instanceDefine:Object = params.mInstanceDefine;
         if (instanceDefine == null)
            break;
         
         //
         
         var instanceDefineData:ByteArray = MultiplePlayerInstanceDefine2ByteArray (instanceDefine);
         
         // ...
         
         var messageData:ByteArray = new ByteArray ();
         
         WriteMessage_CreateInstance (messageData, instanceDefineData, params.mPassword);
         
         mCurrentJointInstanceRequestData = messageData;
         
         // ...
         
         cached = true;
      }
      while (false);
      
      return {mResult: cached};
   }
   
   // inputs
   //    mInstanceDefine
   protected function MultiplePlayer_JoinRandomInstance (params:Object):Object
   {
      var cached:Boolean = false;
      
      do
      {
         var instanceDefine:Object = params.mInstanceDefine;
         if (instanceDefine == null)
            break;
         
         var instanceDefineData:ByteArray = MultiplePlayerInstanceDefine2ByteArray (instanceDefine);
         
         // ...
         
         var messageData:ByteArray = new ByteArray ();
         
         WriteMessage_JoinRandomInstance (messageData, instanceDefineData);
         
         mCurrentJointInstanceRequestData = messageData;
         
         // ...
         
         cached = true;
      }
      while (false);
      
      return {mResult: cached};
   }
   
   //protected function MultiplePlayer_JoinSpecifiedInstance (params:Object):Object
   //{
   //}
   
   //=================
   
   protected function MultiplePlayer_SendChannelMessage (params:Object):Object
   {
      var channelIndex:int = params.mChannelIndex;
      var messageData:ByteArray = params.mMessageData;
      
      var result:Boolean = false;
      do
      {
         if (! IsInstanceServerLoggedIn ())
            break;
         if (mMultiplePlayerInstanceInfo.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing)
            break;
         if (mMultiplePlayerInstanceInfo.mMySeatIndex < 0)
            break;
         if (channelIndex < 0 || channelIndex >= MultiplePlayerDefine.MaxNumberOfInstanceChannels)
            break;
         if (mMultiplePlayerInstanceInfo.mChannelsInfo == null)
            break;
         
         var channelInfo:Object = mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex];
         if (channelInfo == null)
            break;
            
         WriteMessage_ChannelMessage (channelIndex, messageData, channelInfo.mChannelMode == MultiplePlayerDefine.InstanceChannelMode_WeGo);
         
         result = true;
      }
      while (false);
      
      return {mResult: result};
   }
   
   //=================
   
   protected function MultiplePlayer_SendSignalMessage (params:Object):Object
   {
      var result:Boolean = false;
      
      do
      {
         if (! IsInstanceServerLoggedIn ())
            break;
         
         var signalType:String = params.mSignalType; // be careful of compatibility problem.
         var signalInfo:Object = params.mSignalInfo;
         
         switch (signalType)
         {
            case "RestartInstance":
            {
               if (mMultiplePlayerInstanceInfo.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing)
               {  
                  WriteMessage_Signal_RestartInstance ();
               }
               
               break;
            }  
            default:
            {
               break;
            }
         }
      }
      while (false);
      
      return {mResult: result};
   }
   
//======================================================
// 
//======================================================
   
   // before calling this function, make sure instanceDefine is validated.
   private function MultiplePlayerInstanceDefine2ByteArray (instanceDefine:Object):ByteArray
   {
      var enabledChannelIndexes:Array = new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels);
      var numEnabledChannles:int = 0;
      
      var channelIndex:int;
      var channelDefine:Object;
      for (channelIndex = 0; channelIndex < MultiplePlayerDefine.MaxNumberOfInstanceChannels; ++ channelIndex)
      {
         channelDefine = instanceDefine.mChannelDefines [channelIndex];
         if (channelDefine != null)
         {
            enabledChannelIndexes [numEnabledChannles ++] = channelIndex;
         }
      }
      
      // ...
      
      var instanceDefineData:ByteArray = new ByteArray ();
      
      instanceDefineData.writeUTF (instanceDefine.mGameID);
      instanceDefineData.writeByte (instanceDefine.mNumberOfSeats);
      
      instanceDefineData.writeByte (numEnabledChannles);
      for (var i:int = 0; i < numEnabledChannles; ++ i)
      {
         channelIndex = enabledChannelIndexes [i];
         channelDefine = instanceDefine.mChannelDefines [channelIndex];
         
         instanceDefineData.writeByte (channelIndex);
         instanceDefineData.writeByte (channelDefine.mChannelMode);
         instanceDefineData.writeInt (channelDefine.mTurnTimeoutSecondsX8);
      }
      
      // ...
      
      instanceDefineData.position = 0;
      return instanceDefineData;
   }
   
//======================================================
// server -> client. Will call world callbacks (be careful of compatibility problems)
//======================================================
   
   //...
   
   public function OnMultiplePlayerServerMessages (messagesData:ByteArray):void
   {
      if (mWorldDesignProperties != null)
      {
         try
         {
            var dataLength:int = messagesData.readInt ();
            //if (dataLength > )
            //   ...
            
            var numMessages:int = messagesData.readShort ();
            //if (numMessages > )
            //   ...
            
//trace (">>>>> get server messages, dataLength = " + dataLength + ", numMessages = " + numMessages);
            for (var msgIndex:int = 0; msgIndex < numMessages; ++ msgIndex)
            {
//trace (">>>> msgIndex = " + msgIndex + ", messagesData.position = " + messagesData.position + " / " + messagesData.length);

               var serverMessageType:int = messagesData.readShort ();
            
//trace (">> serverMessageType = " + serverMessageType);   
               switch (serverMessageType)
               {
               // ...
               
                  case MultiplePlayerDefine.ServerMessageType_InstanceServerInfo:
                  {
                     SetInstanceServerInfo (messagesData.readUTF (), // server address
                                            messagesData.readShort () & 0xFFFF, // server port
                                            messagesData.readUTF (), // instance id
                                            messagesData.readUTF () // my connection id
                                            );
                     
                     ConnectToInstanceServer ();
                     
                     break;
                  }
                  
               // ...
                  
                  case MultiplePlayerDefine.ServerMessageType_Ping:
                  {
                     WriteMessage_Pong ();
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_Pong:
                  {
                     // ...
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_InstanceBasicInfo:
                  {
                     var id:String = messagesData.readUTF ();
                     var numPlayedGames:int = messagesData.readInt ();
                     var numSeats:int = messagesData.readByte ();
                     var mySeatIndex:int = messagesData.readByte ();
                     
                     SetInstanceBasicInfo (id, numPlayedGames, numSeats, mySeatIndex);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_InstanceCurrentPhase:
                  {
                     var newCurrentPhase:int = messagesData.readByte ();
                     
                     SetInstanceCurrentPhase (newCurrentPhase);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_SeatBasicInfo:
                  {
                     var basicInfoSeatIndex:int = messagesData.readByte ();
                     var basicInfoPlayerName:String = messagesData.readUTF ();
                     
                     SetSeatBasicInfo (basicInfoSeatIndex, basicInfoPlayerName);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_SeatDynamicInfo:
                  {
                     var dynamicInfoSeatIndex:int = messagesData.readByte ();
                     var dynamicInfoLastActiveTime:int = messagesData.readInt ();
                     var dynamicInfoIsConnected:Boolean = (dynamicInfoLastActiveTime & 0x80000000) == 0;
                     dynamicInfoLastActiveTime &= 0x7FFFFFFF;
                     
                     SetSeatDanymicInfo (dynamicInfoSeatIndex, dynamicInfoLastActiveTime, dynamicInfoIsConnected);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_AllChannelsConstInfo:
                  {
                     var numEnabledChannels:int = messagesData.readByte ();
                     
                     for (var i:int = 0; i < numEnabledChannels; ++ i)
                     {
                        var constInfoChannelIndex:int = messagesData.readByte ();
                        var constInfoMode:int = messagesData.readByte ();
                        var constInfoTimeoutX8:int = messagesData.readInt ();
                        
                        SetChannelConstInfo (constInfoChannelIndex, constInfoMode, constInfoTimeoutX8);
                     }
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_ChannelSeatInfo:
                  {
                     var seatInfoChannelIndex:int = messagesData.readByte ();
                     var seatInfoSeatIndex:int = messagesData.readByte ();
                     var seatInfoEnabledTime:int = messagesData.readInt ();
                     var seatInfoIsSeatEnabled:Boolean = (seatInfoEnabledTime & 0x80000000) != 0;
                     seatInfoEnabledTime &= 0x7FFFFFFF;
                     
                     SetChannelDynamicInfo (seatInfoChannelIndex, seatInfoSeatIndex, seatInfoEnabledTime, seatInfoIsSeatEnabled);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_ChannelMessage:
                  {
                     var mesageChannelIndex:int = messagesData.readByte ();
                     var messageSeatIndex:int = messagesData.readByte ();
                     var channelMessageDataLength:int = messagesData.readInt ();
                     var channelMessageData:ByteArray = null;

                     if (channelMessageDataLength >= 0)
                     {
                        channelMessageDataLength &= 0x7FFFFFFF;
                        channelMessageData = new ByteArray ();

                        if (channelMessageDataLength > 0)
                        {
                           messagesData.readBytes (channelMessageData, 0, channelMessageDataLength);
                        }
                     }
                     
                     OnInstanceChannelMessage (mesageChannelIndex, messageSeatIndex, channelMessageData);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_ChannelMessageEncrpted:
                  {
                     var encryptionIndex:int = messagesData.readInt () & 0x7FFFFFFF;
                     
                     var encryptedMessageDataLength:int = messagesData.readInt ();
                     
                     var encryptedMessageData:ByteArray = null;
                     
                     if (encryptedMessageDataLength >= 0)
                     {
                        encryptedMessageDataLength &= 0x7FFFFFFF;
                        encryptedMessageData = new ByteArray ();

                        if (encryptedMessageDataLength > 0)
                        {
                           messagesData.readBytes (encryptedMessageData, 0, encryptedMessageDataLength);
                        }
                     }
                     
                     OnInstanceChannelMessageEncrpted (encryptionIndex, encryptedMessageData);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_ChannelMessageEncrptionCiphers:
                  {  
                     var cipherMesageChannelIndex:int = messagesData.readByte ();
                     var cipherMessageSeatIndex:int = messagesData.readByte ();
                     
                     var messageEncryptionIndex:int = messagesData.readInt ();
                     
                     var messageEncryptionMethod:int = messageEncryptionIndex & 0xFF;
                     messageEncryptionIndex = (messageEncryptionIndex >> 8) & 0xFFFFFF;
                     
                     var ciphereDataLength:int = messagesData.readByte () & 0xFF;
                     var cipherData:ByteArray = new ByteArray ();

                     if (ciphereDataLength > 0)
                     {
                        messagesData.readBytes (cipherData, 0, ciphereDataLength);
                     }
                     
                     OnInstanceChannelMessageEncrptionCiphers (cipherMesageChannelIndex, cipherMessageSeatIndex, messageEncryptionIndex, messageEncryptionMethod, cipherData);
                     
                     break;
                  }
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
            
         //UpdateMultiplePlayerInstanceInfoText ();
      }
   }
   