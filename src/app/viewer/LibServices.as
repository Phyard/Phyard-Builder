
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
         // update local predictions.
      }
      
      if (mCurrentJointInstanceRequestData != null && mIsGettingInstanceServerInfo == false)
      {  
         if (mJoinInstanceFrequencyStat.Hit (getTimer ()))
         {
            mCurrentJointInstanceRequestData.position = 0;
            
            SendMultiplePlayerClientMessagesToSchedulerServer (mCurrentJointInstanceRequestData);
            
            mCurrentJointInstanceRequestData = null;
         }
         
         return;
      }

      if (GetNumCachedClientMessages () > 0 && IsInstanceServerConnected ())
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
// client -> mp http server
//======================================================
   
   private static const kGetInstanceServerInfoURL:String = "http://www.phyard.com/api/instance/serverinfo";
   
   private static const kTestingWithLocalServers:Boolean = false; // for editor mode only
   private static const kGetInstanceServerInfoURL_LocalServer:String = "http://192.168.6.131:12345/api/instance/serverinfo";
   
   private var mIsGettingInstanceServerInfo:Boolean = false;
   
   private function SendMultiplePlayerClientMessagesToSchedulerServer (messagesData:ByteArray):void
   {
      if (mParamsFromEditor != null && kTestingWithLocalServers == false)
      {
         mParamsFromEditor.OnMultiplePlayerClientMessagesToSchedulerServer (messagesData, this);
      }
      else
      {
         DisonnectToInstanceServer ();
         
         var serverinfoGetURL:String = mParamsFromEditor != null ? kGetInstanceServerInfoURL_LocalServer : kGetInstanceServerInfoURL;
         
         var request:URLRequest = new URLRequest (serverinfoGetURL);
         request.method = URLRequestMethod.POST;
         request.data = messagesData;
         request.contentType = "binary/octet-stream";
         request.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));

         var loader:URLLoader = new URLLoader ();
         loader.dataFormat = URLLoaderDataFormat.BINARY;

         loader.addEventListener(Event.COMPLETE, OnGetInstanceServerInfoCompleted);
         //loader.addEventListener(ProgressEvent.PROGRESS, OnLoadingDataProgress);
         loader.addEventListener(IOErrorEvent.IO_ERROR, OnGetInstanceServerInfoError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnGetInstanceServerInfoError);

         loader.load (request);
         
         mIsGettingInstanceServerInfo = true;
      }
   }

   private function OnGetInstanceServerInfoCompleted (event:Event):void
   {
      var loader:URLLoader = URLLoader(event.target);

      var data:ByteArray = ByteArray (loader.data);
      
      OnMultiplePlayerServerMessages (data);
      
      mIsGettingInstanceServerInfo = false;
   }
   
   private function OnGetInstanceServerInfoError (event:Object):void
   {
      mIsGettingInstanceServerInfo = false;
   }
   
//======================================================
// client -> mp socket server
//======================================================
   
   private function SendMultiplePlayerClientMessagesToInstanceServer (messagesData:ByteArray):void
   {
      if (mParamsFromEditor != null && kTestingWithLocalServers == false)
      {
         mParamsFromEditor.OnMultiplePlayerClientMessagesToInstanceServer (messagesData, this);
      }
      else if (IsInstanceServerConnected ())
      {
         //if (mMultiplePlayerInstanceInfo.mServerSocket != null)
         //{
            try
            {
               mMultiplePlayerInstanceInfo.mServerSocket.writeBytes (messagesData);
               mMultiplePlayerInstanceInfo.mServerSocket.flush ();
            }
            catch (error:Error)
            {
               // DisonnectToInstanceServer ();
            }
         //}
      }
   }
   
   //----------------------------------
   
   private function DisonnectToInstanceServer ():void
   {
      if (IsInstanceServerConnected ())
      {
         try
         {
            mMultiplePlayerInstanceInfo.mServerSocket.close ();
         }
         catch (error:Error)
         {
         }
         
         SetInstanceServerConnectionStatus (false);
      }
   }
   
   private function ConnectToInstanceServer ():void
   {
      DisonnectToInstanceServer ();
      
      if (IsInstanceServerInfoRetrieved ())
      {
         if (mParamsFromEditor != null)
         {
            OnInstanceServerConnected ();
         }
         else
         {  
            try
            {
               var theSocket:Socket = new Socket ();
               
               theSocket.addEventListener(Event.CLOSE, OnInstanceServerClosed);
               theSocket.addEventListener(Event.CONNECT, OnInstanceServerConnected);
               theSocket.addEventListener(IOErrorEvent.IO_ERROR, OnInstanceServerError);
               theSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnInstanceServerError);
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
      if (event != null && event.target != mMultiplePlayerInstanceInfo.mServerSocket) // here is &&
         return; // this may be previous discarded socket. 
      
      SetInstanceServerConnectionStatus (true);
      
      mClientMessagesFrequencyStat.Reset ();
      ClearCachedClientMessages ();
      
      WriteMessage_LoginInstanceServer ();
   }
   
   // event == null means close-manually
   private function OnInstanceServerClosed (event:Event = null):void
   {
      if (event == null || event.target != mMultiplePlayerInstanceInfo.mServerSocket) // here is ||
         return;
      
      // ...
      
      mMultiplePlayerInstanceInfo.mServerSocket = null;

      SetInstanceServerConnectionStatus (false);
   }
   
   private function OnInstanceServerError (event:Event):void
   {
      if (event == null || event.target != mMultiplePlayerInstanceInfo.mServerSocket) // here is ||
         return; 
      
      DisonnectToInstanceServer ();
   }
   
   private function OnInstanceServerSocketData (event:ProgressEvent):void
   {
      if (event == null || event.target != mMultiplePlayerInstanceInfo.mServerSocket) // here is ||
         return;
      
      // ...
      
      while (IsInstanceServerConnected () && mMultiplePlayerInstanceInfo.mCachedServerMessages != null)
      {
         if (mMultiplePlayerInstanceInfo.mCachedServerMessages.length == 0)
         { 
            if (mMultiplePlayerInstanceInfo.mServerSocket.bytesAvailable >= MultiplePlayerDefine.ServerMessageHeadString.length + 4)
            {
               mMultiplePlayerInstanceInfo.mServerSocket.readBytes (mMultiplePlayerInstanceInfo.mCachedServerMessages,
                                                                    0,
                                                                    MultiplePlayerDefine.ServerMessageHeadString.length + 4
                                                                    );
               
               continue;
            }
            
            break;
         }
         else
         {     
            mMultiplePlayerInstanceInfo.mCachedServerMessage.position = 0;
            if (MultiplePlayerDefine.ServerMessageHeadString != mMultiplePlayerInstanceInfo.mCachedServerMessage.readUTFBytes (MultiplePlayerDefine.ServerMessageHeadString.length))
            {
               // bad message
               break;
            }
         
            //mMultiplePlayerInstanceInfo.mCachedServerMessage.position = MultiplePlayerDefine.ServerMessageHeadString.length;
            var messagesLength:int = mMultiplePlayerInstanceInfo.mCachedServerMessage.readInt ();
            var numPendingBytes:int = messagesLength - mMultiplePlayerInstanceInfo.mCachedServerMessages.length;
            if (numPendingBytes <= 0)
            {
               // error
               break;
            }
            
            var numBytesToRead:int = Math.min (numPendingBytes, mMultiplePlayerInstanceInfo.mServerSocket.bytesAvailable);
            mMultiplePlayerInstanceInfo.mServerSocket.readBytes (mMultiplePlayerInstanceInfo.mCachedServerMessages,
                                                                 mMultiplePlayerInstanceInfo.mCachedServerMessages.length,
                                                                 numBytesToRead
                                                                 );
            
            if (numPendingBytes == numBytesToRead)
            {
               mMultiplePlayerInstanceInfo.mCachedServerMessage.position = 0;
               OnMultiplePlayerServerMessages (mMultiplePlayerInstanceInfo.mCachedServerMessages);
               mMultiplePlayerInstanceInfo.mCachedServerMessages.length = 0;
            }
            
            if (mMultiplePlayerInstanceInfo.mServerSocket.bytesAvailable <= 0)
            {
               break;
            }
         }
      }
   }
   
//======================================================
// instance 
//======================================================
   
   private var mMultiplePlayerInstanceInfo:Object =  
   {
            //mSchedulerServerSocket : null.
            //mSchedulerServerAddress : null,
            //mSchedulerServerPort : 0,
            //mSchedulerServerConnected : false,
            
            mServerSocket : null,  // step 1
            mServerAddress : null,
            mServerPort : 0,
            mIsServerConnected : false, // step 2
            
            mID : "", // instance id, null or blank means invalid
            
            mInstanceDefineDigest : "", // must be a length-64 hex number string
            mMyConnectionID : "", // pls keep it non-null
            
            mCachedServerMessages : null,
            
            mIsServerLoggedIn : false, // step 3
            
            mNumPlayedGames : 0,
            
            // ====================== followings may be used by World, pls keep the compatibility =========================//
            
            mCurrentPhase : MultiplePlayerDefine.InstancePhase_Inactive,

            mNumSeats : 0,
            mMySeatIndex : -1,
            mSeatsPlayerName : null, // [mNumSeats]
            mSeatsLastActiveTime : null, // [mNumSeats]
            mIsSeatsConnected : null, // [mNumSeats]
            
            mChannelsInfo : null,
                     // mChannelMode
                     // mTurnTimeoutMilliseconds // milliseconds, no X8
                     // mVerifyNumber // short
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
      return   mMultiplePlayerInstanceInfo.mIsServerConnected;
            // for editor mode, socket is null
            //&& mMultiplePlayerInstanceInfo.mServerSocket != null
            //&& mMultiplePlayerInstanceInfo.mServerSocket.connected;
   }
   
   private function IsInstanceServerLoggedIn ():Boolean
   {
      return IsInstanceServerConnected () && mMultiplePlayerInstanceInfo.mIsServerLoggedIn;
   }
   
   private function SetInstanceServerConnectionStatus (connected:Boolean):void
   {
      if (mMultiplePlayerInstanceInfo.mIsServerConnected != connected)
      {
         var connBroken:Boolean = mMultiplePlayerInstanceInfo.mIsServerConnected;
         
         mMultiplePlayerInstanceInfo.mIsServerConnected = connected;
         
         if (connBroken)
         {
            mMultiplePlayerInstanceInfo.mIsServerLoggedIn = false;
            
            mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "LoggedOut"});
         }
         else
         {
            mMultiplePlayerInstanceInfo.mCachedServerMessages = new ByteArray ();
            
            //mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "Connected"});
         }
      }
   }
   
   private function SetInstanceServerInfo (serverAddress:String, serverPort:int, instanceDefineDigest:String, connectionId:String):void
   {
//trace ("SetInstanceServerInfo, serverAddress = " + serverAddress + ":" + serverPort + ", instance id = " + instanceId + ", connectionId = " + connectionId);

      mMultiplePlayerInstanceInfo.mServerAddress = serverAddress;
      mMultiplePlayerInstanceInfo.mServerPort = serverPort;
      
      mMultiplePlayerInstanceInfo.mInstanceDefineDigest = instanceDefineDigest;
      mMultiplePlayerInstanceInfo.mMyConnectionID = connectionId;
      
      mMultiplePlayerInstanceInfo.mCurrentPhase = MultiplePlayerDefine.InstancePhase_Inactive;
   }
   
   // const info is only sent when player logs in.
   private function SetInstanceConstInfo (id:String, numSeats:int):void
   {
      if (! mMultiplePlayerInstanceInfo.mIsServerConnected) // possible
         return;
      if (numSeats < MultiplePlayerDefine.MinNumberOfInstanceSeats || numSeats > MultiplePlayerDefine.MaxNumberOfInstanceSeats)
         return;
      
      mMultiplePlayerInstanceInfo.mIsServerLoggedIn = true;
      
      mMultiplePlayerInstanceInfo.mID = id;
      mMultiplePlayerInstanceInfo.mNumSeats = numSeats;
      
      mMultiplePlayerInstanceInfo.mSeatsPlayerName = new Array (numSeats);
      mMultiplePlayerInstanceInfo.mSeatsLastActiveTime = new Array (numSeats);
      mMultiplePlayerInstanceInfo.mIsSeatsConnected = new Array (numSeats);
      
      // ...
      
      mMultiplePlayerInstanceInfo.mChannelsInfo = new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels);
      
      // ...
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "LoggedIn"});
   }
   
   private function SetInstancePlayInfo (numPlayedGames:int, mySeatIndex:int):void
   {
      if (mySeatIndex < 0 || mySeatIndex >= mMultiplePlayerInstanceInfo.mNumSeats)
         return;
      
      mMultiplePlayerInstanceInfo.mNumPlayedGames = numPlayedGames;
      mMultiplePlayerInstanceInfo.mMySeatIndex = mySeatIndex;
      
      // ...
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "InstanceReset"});
   }
   
   private function SetInstanceCurrentPhase (newPhase:int):void
   {
      var phaseChanged:Boolean = (mMultiplePlayerInstanceInfo.mCurrentPhase != newPhase);
      
      if (phaseChanged)
      {
         if (newPhase == MultiplePlayerDefine.InstancePhase_Playing)
         {
            mMultiplePlayerInstanceInfo.mPendingEncryptedMessages = new Dictionary ();
         }
         else if (mMultiplePlayerInstanceInfo.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing)
         {
            mMultiplePlayerInstanceInfo.mPendingEncryptedMessages = null;
         }
         
         mMultiplePlayerInstanceInfo.mCurrentPhase = newPhase;
         
         // ...
         mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "PhaseChanged"});
      }
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
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "SeatBasicInfoChanged"});
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
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "SeatDanymicInfoChanged"});
   }
   
   private function SetChannelConstInfo (channelIndex:int, mode:int, timeoutX8:int):void
   {
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
            mVerifyNumber : 0,
            mIsSeatsEnabled : new Array (mMultiplePlayerInstanceInfo.mNumSeats),
            mIsSeatsEnabled_Predicted : new Array (mMultiplePlayerInstanceInfo.mNumSeats),
            mSeatsLastEnableTime : new Array (mMultiplePlayerInstanceInfo.mNumSeats)
         };
         
         mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex] = channelInfo;
      }

      channelInfo.mChannelMode = mode;
      channelInfo.mTurnTimeoutMilliseconds = timeoutX8 * 125.0;
      
      // ...
      //mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "ChannelConstInfo"}); // along with "LoggedIn"
   }
   
   // SetChannelConstInfo muse be called before this function.
   private function SetChannelDynamicInfo (channelIndex:int, verifyNumber:int):void
   {
      if (channelIndex < 0 || channelIndex >= MultiplePlayerDefine.MaxNumberOfInstanceChannels)
         return;
      if (mMultiplePlayerInstanceInfo.mChannelsInfo == null)
         return;
      
      var channelInfo:Object = mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex];
      if (channelInfo == null)
         return;
      
      channelInfo.mVerifyNumber = verifyNumber;
      
      // ...
      //mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "ChannelDynamicInfoChanged"}); // not visible to designers
   }
   
   // SetChannelConstInfo muse be called before this function.
   private function SetChannelSeatInfo (channelIndex:int, seatIndex:int, enabledTime:int, isSeatEnabled:Boolean):void
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
      mWorldDesignProperties.OnMultiplePlayerEvent ("OnGameInstanceInfoChanged", {mReason: "ChannelSeatInfoChanged"});
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
   
   private var mPosOfNumMessagesInHeader:int = 0; // will be updated correctly.
   
   private function WriteMultiplePlayerMessagesHeader (messagesData:ByteArray, numMessages:int):void
   {
      if (messagesData == null)
         return;
      
      var currentDataLength:int = messagesData.length;
      
      messagesData.position = 0;
      
      messagesData.writeUTFBytes (MultiplePlayerDefine.ClientMessageHeadString);
      
      messagesData.writeInt (currentDataLength); // the whole length
      
      mPosOfNumMessagesInHeader = messagesData.position;
      
      messagesData.writeShort (numMessages); // some messages need to be handled together.
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
   
   //private function WriteMessage_CreateInstance (buffer:ByteArray, instanceDefineData:ByteArray, password:String):void
   //{     
   //   WriteMultiplePlayerMessagesHeader (buffer, 0);
   //   
   //   buffer.writeShort (MultiplePlayerDefine.ClientMessageType_CreateInstance);
   //   buffer.writeShort (MultiplePlayerDefine.ClientMessageDataFormatVersion);
   //   buffer.writeInt (instanceDefineData.length);
   //   buffer.writeBytes (instanceDefineData);
   //   buffer.writeUTF (password);
   //   buffer.writeUTF (mMultiplePlayerInstanceInfo.mMyConnectionID);
   //   
   //   WriteMultiplePlayerMessagesHeader (buffer, 1);
   //}
   
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
      if (! IsInstanceServerLoggedIn ())
         return;
      
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_Ping);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   private function WriteMessage_Pong ():void
   {
      if (! IsInstanceServerLoggedIn ())
         return;
      
      // ...

      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();

      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_Pong);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   private function WriteMessage_LoginInstanceServer ():void
   {
      if (! IsInstanceServerConnected ()) // here is connected or loggedin
         return;
      
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_LoginInstanceServer);
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageDataFormatVersion);
      cachedMessagesData.writeUTF (mMultiplePlayerInstanceInfo.mInstanceDefineDigest);
      cachedMessagesData.writeUTF (mMultiplePlayerInstanceInfo.mMyConnectionID);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
   //private function WriteMessage_ExitCurrentInstance ():void
   //{
   //   if (! IsInstanceServerLoggedIn ()) // here need "logged in" to send message, but the player may be not logged in yet. So it is hard to break connection gracefully.
   //      return;
   //   
   //   // ...
   //   
   //   var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
   //   
   //   cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_ExitCurrentInstance);
   //   
   //   // ...
   //   
   //   UpdateCachedClientMessagesHeader ();
   //}
   
   private function WriteMessage_ChannelMessage (channelIndex:int, channelVerifyNumber:int, messageData:ByteArray, needHolding:Boolean):void
   {
      if (! IsInstanceServerLoggedIn ())
         return;
      
      // ...
      
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
      
      cachedMessagesData.writeShort (channelVerifyNumber);
      
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
      if (! IsInstanceServerLoggedIn ())
         return;
      
      // ...
      
      var cachedMessagesData:ByteArray = GetCachedClientMessagesData ();
      
      cachedMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_Signal_RestartInstance);
      
      cachedMessagesData.writeInt (mMultiplePlayerInstanceInfo.mNumPlayedGames);
      
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
         mIsInPlayingPhase : IsInstanceServerLoggedIn () && (mMultiplePlayerInstanceInfo.mCurrentPhase == MultiplePlayerDefine.InstancePhase_Playing),
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
         && channelIndex >= 0 && channelIndex < MultiplePlayerDefine.MaxNumberOfInstanceChannels
         && mMultiplePlayerInstanceInfo.mChannelsInfo != null)
      {
         channelInfo = mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex];
      }
      
      return {
         mIsEnabled      : (channelInfo == null || channelInfo.mIsSeatsEnabled_Predicted == null) ? false : channelInfo.mIsSeatsEnabled_Predicted [seatIndex],
         mLastEnableTime : (channelInfo == null || channelInfo.mSeatsLastEnableTime      == null) ? 0     : channelInfo.mSeatsLastEnableTime      [seatIndex]
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
   //protected function MultiplePlayer_JoinNewInstance (params:Object):Object
   //{
   //   var cached:Boolean = false;
   //   
   //   do
   //   {
   //      var instanceDefine:Object = params.mInstanceDefine;
   //      if (instanceDefine == null)
   //         break;
   //      
   //      //
   //      
   //      var instanceDefineData:ByteArray = MultiplePlayerInstanceDefine2ByteArray (instanceDefine);
   //      
   //      // ...
   //      
   //      var messageData:ByteArray = new ByteArray ();
   //      
   //      WriteMessage_CreateInstance (messageData, instanceDefineData, params.mPassword);
   //      
   //      mCurrentJointInstanceRequestData = messageData;
   //      
   //      // ...
   //      
   //      cached = true;
   //   }
   //   while (false);
   //   
   //   return {mResult: cached};
   //}
   
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
   
   protected function MultiplePlayer_ExitCurrentInstance (params:Object):Object
   {
      if (IsInstanceServerConnected ())
      {
         //if (IsInstanceServerLoggedIn ())
         //{
         //   WriteMessage_ExitCurrentInstance (); // server will break the connection gracefully.
         //}
         //else
         //{
            DisonnectToInstanceServer ();
         //}
         
         return {mResult: true};
      }
      
      return {mResult: false};
   }
   
   //=================
   
   protected function MultiplePlayer_SendChannelMessage (params:Object):Object
   {
      var channelIndex:int = params.mChannelIndex;
      var messageData:ByteArray = params.mMessageData;
      
      var result:Boolean = false;
      do
      {
trace (">>>>>>>>>>>>> aaa");
         if (! IsInstanceServerLoggedIn ())
            break;
trace ("bbb");
         if (mMultiplePlayerInstanceInfo.mCurrentPhase != MultiplePlayerDefine.InstancePhase_Playing)
            break;
trace ("ccc");
         if (mMultiplePlayerInstanceInfo.mMySeatIndex < 0)
            break;
trace ("ddd");
         if (channelIndex < 0 || channelIndex >= MultiplePlayerDefine.MaxNumberOfInstanceChannels)
            break;
trace ("eee");
         if (mMultiplePlayerInstanceInfo.mChannelsInfo == null)
            break;
         
trace ("fff");
         var channelInfo:Object = mMultiplePlayerInstanceInfo.mChannelsInfo [channelIndex];
         if (channelInfo == null)
            break;
         
trace ("ggg channelInfo.mIsSeatsEnabled = " + channelInfo.mIsSeatsEnabled);
         if (channelInfo.mIsSeatsEnabled == null || channelInfo.mIsSeatsEnabled [mMultiplePlayerInstanceInfo.mMySeatIndex] == false)
            break;
         
         //if (channelInfo.mIsSeatsEnabled_Predicted == null || channelInfo.mIsSeatsEnabled_Predicted [mMultiplePlayerInstanceInfo.mMySeatIndex] == false)
         //  break;
         
trace ("hhh");
         WriteMessage_ChannelMessage (channelIndex, channelInfo.mVerifyNumber, messageData, channelInfo.mChannelMode == MultiplePlayerDefine.InstanceChannelMode_WeGo);
         
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
            var method:String = messagesData.readUTFBytes (MultiplePlayerDefine.ServerMessageHeadString.length);
            //if (method !== MultiplePlayerDefine.ServerMessageHeadString)
            //   ...
            
            var dataLength:int = messagesData.readInt ();
            //if (dataLength > )
            //   ...
            
            var numMessages:int = messagesData.readShort ();
            //if (numMessages > )
            //   ...
            
trace (">>>>> get server messages, dataLength = " + dataLength + ", numMessages = " + numMessages);
            for (var msgIndex:int = 0; msgIndex < numMessages; ++ msgIndex)
            {
trace (">>>> msgIndex = " + msgIndex + ", messagesData.position = " + messagesData.position + " / " + messagesData.length);

               var serverMessageType:int = messagesData.readShort ();
            
trace (">> serverMessageType = 0x" + serverMessageType.toString (16));
               switch (serverMessageType)
               {
               // ...
               
                  case MultiplePlayerDefine.ServerMessageType_InstanceServerInfo:
                  {
                     SetInstanceServerInfo (messagesData.readUTF (), // server address
                                            messagesData.readShort () & 0xFFFF, // server port
                                            messagesData.readUTF (), // instance define digest
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
                  case MultiplePlayerDefine.ServerMessageType_InstanceConstInfo:
                  {
                     var instanceId:String = messagesData.readUTF ();
                     var numSeats:int = messagesData.readByte ();
                     
                     SetInstanceConstInfo (instanceId, numSeats);
                     
                     break;
                  }
                  //case MultiplePlayerDefine.ServerMessageType_LoggedOff:
                  //{
                  //   DisonnectToInstanceServer ();
                  //   
                  //   break;
                  //}
                  case MultiplePlayerDefine.ServerMessageType_InstancePlayInfo:
                  {
                     var numPlayedGames:int = messagesData.readInt ();
                     var mySeatIndex:int = messagesData.readByte ();
                     
                     SetInstancePlayInfo (numPlayedGames, mySeatIndex);
                     
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
                  case MultiplePlayerDefine.ServerMessageType_ChannelDynamicInfo:
                  {
                     var dynamicInfoChannelIndex:int = messagesData.readByte ();
                     var dynamicInfoChannelVerifyNumber:int = messagesData.readShort ();
                     
                     SetChannelDynamicInfo (dynamicInfoChannelIndex, dynamicInfoChannelVerifyNumber);
                     
                     break;
                  }
                  case MultiplePlayerDefine.ServerMessageType_ChannelSeatInfo:
                  {
                     var seatInfoChannelIndex:int = messagesData.readByte ();
                     var seatInfoSeatIndex:int = messagesData.readByte ();
                     var seatInfoEnabledTime:int = messagesData.readInt ();
                     var seatInfoIsSeatEnabled:Boolean = (seatInfoEnabledTime & 0x80000000) != 0;
                     seatInfoEnabledTime &= 0x7FFFFFFF;
                     
                     SetChannelSeatInfo (seatInfoChannelIndex, seatInfoSeatIndex, seatInfoEnabledTime, seatInfoIsSeatEnabled);
                     
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
                     trace ("unknown server message type: 0x" + serverMessageType.toString (16));
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
            
            DisonnectToInstanceServer ();
         }
            
         //UpdateMultiplePlayerInstanceInfoText ();
      }
   }
   