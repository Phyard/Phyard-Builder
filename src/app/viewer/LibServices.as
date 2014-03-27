
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
   //      if (mWorldDesignProperties != null)
   //      { 
   //         //var mpInstance:Object = mWorldDesignProperties.GetCurrentMultiplePlayerInstance ();
   //      }
   //   }
   //}
   
//==================================================================
// 
//==================================================================

   private function UpdateMultiplePlayer ():void
   {
      if (mCurrentJointInstanceRequestData != null)
      {
         if (mJoinInstanceFrequencyStat.Hit (getTimer ())
         {
            SendMultiplePlayerClientMessagesToSchedulerServer (mCurrentJointInstanceRequestData);
            
            mCurrentJointInstanceRequestData = null;
         }
         
         return;
      }
      
      if (mIsMultiplePlayerInstanceServerConnected && mCachedClientMessagesData != null)
      {
         if (mClientMessagesFrequencyStat.Hit (getTimer ())
         {
            SendMultiplePlayerClientMessagesToInstanceServer (mCachedClientMessagesData);
            
            ClearCachedClientMessages ();
         }
      }
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
            messagesData.position = 0;
            var messagesNumBytes:int = messagesData.readInt ();
            //if (messagesNumBytes != messagesData.length)
            //   throw new Error ();
               
            var serverDataFormatVersion:int = messagesData.readShort ();
            var numMessages:int = messagesData.readShort ();
            
            for (var msgIndex:int = 0; msgIndex < numMessages; ++ msgIndex)
            {
               var serverMessageType:int = messagesData.readShort ();
               
               switch (serverMessageType)
               {
                  case MultiplePlayerDefine.ServerMessageType_InstanceClosed:
                     OnInstanceClosed (messagesData, serverDataFormatVersion);
                     break;
                  case MultiplePlayerDefine.ServerMessageType_InstanceServerInfo:
                     OnInstanceServerInfo (messagesData, serverDataFormatVersion);
                     break;
                  case MultiplePlayerDefine.ServerMessageType_InstanceInfo:
                     OnInstanceInfo (messagesData, serverDataFormatVersion);
                     break;
                  case MultiplePlayerDefine.ServerMessageType_InstanceChannelMessage:
                     OnInstanceChannelMessage (messagesData, serverDataFormatVersion);
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
            
         //UpdateMultiplePlayerInstanceInfoText ();
      }
   }
   
   private function OnInstanceClosed (messagesData:ByteArray, serverDataFormatVersion:int):void
   {
      var instanceId:String = messagesData.readUTF ();
      
      if (mMultiplePlayerInstance != null && mMultiplePlayerInstance.mID == instanceId)
      {
         mMultiplePlayerInstance = null;
      } 
   }
   
   private function OnInstanceServerInfo (messagesData:ByteArray, serverDataFormatVersion:int):void
   {
      mMultiplePlayerInstance = null;
      
      mIsMultiplePlayerInstanceServerConnected = false;
      mMultiplePlayerInstanceServerAddress = messagesData.readUTF ();
      mMultiplePlayerInstanceServerPort = messageData.readShort () & 0xFFFF;
      mMultiplePlayerInstanceID = messagesData.readUTF ();
      mMultiplePlayerConnectionID = messagesData.readUTF ();
      
      ConnectToInstanceServer ();
   }
   
   private function OnInstanceInfo (messagesData:ByteArray, serverDataFormatVersion:int):void
   {
      mMultiplePlayerInstance = new Object ();
      
      // ...
   }
   
   private function OnInstanceChannelMessage (messagesData:ByteArray, serverDataFormatVersion:int):void
   {
      //mWorldDesignProperties.OnMultiplePlayerServerMessage ("OnGameInstanceSeatsInfoChanged");
   }
   
//======================================================
// client -> server
//======================================================
   
   private var mMultiplePlayerInstance:Object = null;
   
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
         
      }
   }
   
   private function SendMultiplePlayerClientMessagesToInstanceServer (messagesData:ByteArray):void
   {
      if (mParamsFromEditor != null)
      {
         mParamsFromEditor.OnMultiplePlayerClientMessagesToInstanceServer (messagesData, this);
      }
      else
      {
      }
   }
   
   // instance server
   private var mMultiplePlayerInstanceServerAddress:String = null;
   private var mMultiplePlayerInstanceServerPort:int = 0;
   private var mMultiplePlayerInstanceID:String = "";
   private var mMultiplePlayerConnectionID:String = "";
   private var mIsMultiplePlayerInstanceServerConnected:Boolean = false;
   private var mMultiplePlayerInstanceServerSocket:Socket = null;
   
   private function ConnectToInstanceServer ():void
   {
      if (mParamsFromEditor != null)
      {
         mIsMultiplePlayerInstanceServerConnected = true;
         
         OnInstanceServerConnected ();
      }
      else
      {
         
      }
   }
   
   public function OnInstanceServerConnected (event:Event = null):void
   {
      mClientMessagesFrequencyStat.Reset ();
      ClearCachedClientMessages ();
      
      SyncMultiplePlayerInstaneInfo ();
   }
   
//======================================================
// 
//======================================================
   
   private function SyncMultiplePlayerInstaneInfo ():void
   {
      if (! mIsMultiplePlayerInstanceServerConnected)
         return;
      
      // ...
      
      mCachedClientMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_Register);
      mCachedClientMessagesData.writeUTF (mMultiplePlayerInstanceID);
      mCachedClientMessagesData.writeUTF (mMultiplePlayerConnectionID);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
//======================================================
// callbacks for world (be careful of compatibility problems)
//======================================================
   
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
      instanceDefine.mChannelDefines = new Array (MultiplePlayerDefine.MaxNumberOfMutiplePlayerInstanceChannels);
      
      MultiplePlayer_ReplaceInstanceChannelDefine ({mInstanceDefine: instanceDefine, 
                                                    mChannelIndex: 0, 
                                                    mChannelDefine: MultiplePlayer_CreateInstanceChannelDefine ({
                                                       mChannelMode: MultiplePlayerDefine.MultiplePlayerInstaneMode_Free,
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
         if (params.mChannelIndex < 0 && params.mChannelIndex >= MultiplePlayerDefine.MaxNumberOfMutiplePlayerInstanceChannels)
            break;
         
         instacneDefine.mChannelDefines [params.mChannelIndex] = params.mChannelDefine;
         
         succeeded = true;
      }
      while (false);
      
      return {mResult: succeeded};
   }

   //========================
   
   private var mJoinInstanceFrequencyStat:FrequencyStat = new FrequencyStat (3, 60000); // most 3 times in one minute
   
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
         
         var password:String = params.mPassword;
         var passwordData:ByteArray = String2ByteArray (password);
         
         //
         
         var instanceDefineData:ByteArray = MultiplePlayerInstanceDefine2ByteArray (instanceDefine);
         
         // ...
         
         var messageData:ByteArray = new ByteArray ();
         
         WriteMultiplePlayerMessagesHeader (messageData, 0);
         
         messageData.writeShort (MultiplePlayerDefine.ClientMessageType_CreateInstance);
         messageData.writeUTF (mMultiplePlayerConnectionID);
         messageData.writeInt (instanceDefineData.length);
         messageData.writeBytes (instanceDefineData);
         
         WriteMultiplePlayerMessagesHeader (messageData, 1);
         
         // ...
         
         mCurrentJointInstanceRequestData = messageData;
         
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
         
         WriteMultiplePlayerMessagesHeader (messageData, 0);
         
         messageData.writeShort (MultiplePlayerDefine.ClientMessageType_JoinRandomInstance);
         messageData.writeUTF (mMultiplePlayerConnectionID);
         messageData.writeInt (instanceDefineData.length);
         messageData.writeBytes (instanceDefineData);
         
         WriteMultiplePlayerMessagesHeader (messageData, 1);
         
         // ...
         
         mCurrentJointInstanceRequestData = messageData;
         
         cached = true;
      }
      while (false);
      
      return {mResult: cached};
   }
   
   //protected function MultiplePlayer_JoinSpecifiedInstance (params:Object):Object
   //{
   //}
   
   //=================
   
   private var mClientMessagesFrequencyStat:FrequencyStat = new FrequencyStat (20, 60000); // most 20 times in one minute
   
   private var mCachedClientMessagesData:ByteArray = null;
   private var mNumCachedClientMessages:int = 0;
   
   protected function MultiplePlayer_SendChannelMessage (params:Object):Object
   {
      if (  (! mIsMultiplePlayerInstanceServerConnected)
            || mMultiplePlayerInstance == null 
            || mMultiplePlayerInstance.mIsStarted == false
            || mMultiplePlayerInstance.mPlayerSeatIndex < 0
            )
      {
         return;
      }
      
      // ...
      
      var channelIndex:int = params.mChannelIndex;
      var messageData:ByteArray = params.mMessageData;
      
      mCachedClientMessagesData.writeShort (MultiplePlayerDefine.ClientMessageType_ChannelMessage);
      mCachedClientMessagesData.writeByte (channelIndex);
      mCachedClientMessagesData.writeInt (messageData.length);
      mCachedClientMessagesData.writeBytes (messageData, 0, messageData.length);
      
      // ...
      
      UpdateCachedClientMessagesHeader ();
   }
   
//======================================================
// 
//======================================================
   
   private function WriteMultiplePlayerMessagesHeader (messagesData:ByteArray, numMessages:int):void
   {
      if (messagesData == null)
         return;
      
      messagesData.position = 0;

      messagesData.writeShort (MultiplePlayerDefine.MessageDataFormatVersion);
      messagesData.writeInt (messagesData.length); // the whole length 
      messagesData.writeShort (numMessages);
   }
   
   priate function ClearCachedClientMessages ():void
   {
      mCachedClientMessagesData.length = 0;
      mNumCachedClientMessages = 0;
      
      WriteMultiplePlayerMessagesHeader (mCachedClientMessagesData, mNumCachedClientMessages);
   }
   
   priate function UpdateCachedClientMessagesHeader ():void
   {
      ++ mNumCachedClientMessages;
      
      var posBackup:int = mCachedClientMessagesData.position;
      
      WriteMultiplePlayerMessagesHeader (mCachedClientMessagesData, mNumCachedClientMessages);
      
      mCachedClientMessagesData.position = posBackup;
   }
   
   // before calling this function, make sure instanceDefine is validated.
   private function MultiplePlayerInstanceDefine2ByteArray (instanceDefine:Object):ByteArray
   {
      var enabledChannelIndexes:Array = new Array (MultiplePlayerDefine.MaxNumberOfMutiplePlayerInstanceChannels);
      var numEnabledChannles:int = 0;
      
      var channelIndex:int;
      var channelDefine:Object;
      for (channelIndex = 0; channelIndex < MultiplePlayerDefine.MaxNumberOfMutiplePlayerInstanceChannels; ++ channelIndex)
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
   
   