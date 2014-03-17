
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
         }
         
         return;
      }
      
      if (mIsMultiplePlayerInstanceServerConnected && mCachedClientMessagesData != null)
      {
         if (mCachedClientMessagesData != null)
         
         SendMultiplePlayerClientMessagesToInstanceServer
      }
   }
   
//======================================================
// server -> client. Will call world callbacks (be careful of compatibility problems)
//======================================================
      
   // server
   public static const MutiplePlayerServerMessageType_Pong:int = 0;
   public static const MutiplePlayerServerMessageType_Error:int = 100;
   public static const MutiplePlayerServerMessageType_ConnectionInfo:int = 1000;
   public static const MutiplePlayerServerMessageType_InstanceInfo:int = 1200;
   public static const MutiplePlayerServerMessageType_ChannelMessage:int = 2000;
   
   //...
   
   private function OnMultiplePlayerServerMessages (messagesData:ByteArray):void
   {
      if (mWorldDesignProperties != null)
      {
         try
         {
            messagesData.position = 0;
            var messagesNumBytes:int = messagesData.readInt ();
            if (messagesNumBytes != messagesData.length)
               throw new Error ();
               
            var serverDataFormatVersion:int = messagesData.readShort ();
            var numMessages:int = messagesData.readShort ();
            
            for (var msgIndex:int = 0; msgIndex < numMessages; ++ msgIndex)
            {
               var numBytes:int = messagesData.readInt ();
               if (numBytes < 0 || messagesData.position + numBytes >= messagesNumBytes)
                  throw new Error ();
               
               var serverMessageData:ByteArray = new ByteArray (numBytes);
               messagesData.readBytes (serverMessageData, 0, numBytes);
               
               HandleMultiplePlayerServerMessage (serverMessageData, serverDataFormatVersion);
            }
         }
         catch (error:Error)
         {
            // on error
         }
            
         //UpdateMultiplePlayerInstanceInfoText ();
      }
   }
   
   private function HandleMultiplePlayerServerMessage (messageData:ByteArray, serverDataFormatVersion:int):void
   {
      messageData.position = 0;
      
      var serverMessageType:int = messageData.readShort ();
      
      switch (serverMessageType)
      {
         case MutiplePlayerServerMessageType_ConnectionInfo:
            // clear cached messages
            //mWorldDesignProperties.OnMultiplePlayerServerMessage ("OnGameInstanceSeatsInfoChanged");
            break;
         case MutiplePlayerServerMessageType_InstanceInfo:
            break;
         case MutiplePlayerServerMessageType_ChannelMessage:
            break;
         default
         {
            break;
         }
      }
   }
   
//======================================================
// client -> server
//======================================================
   
   private static var mNextRequestID:int = 0;

   private var mMultiplePlayerSchedulerServerAddress:String = "http://mpsdl.phyard.com/bapi/"; // binary api calling entry 
   
   private var mMultiplePlayerConnectionID:String = null;
   private var mMultiplePlayerInstanceServerAddress:String = null;
   private var mIsMultiplePlayerInstanceServerConnected:Boolean = false;
   
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
                                                       mTurnTimeoutSeconds: MultiplePlayerDefine.MaxTurnTimeoutInPractice,
                                                       mSeatsInitialEnabledPolicy: MultiplePlayerDefine.PolicyOfInitialChannelSeatsEnabledStatus_EnableAll,
                                                       mSeatsNextEnabledPolicy: MultiplePlayerDefine.PolicyOfNextChannelSeatsEnabledStatus_DoNothing,
                                                       mSeatsMessageForwardingPolicy: MultiplePlayerDefine.PolicyOfChannelMessageForwarding_Instant
                                                    }).mChannelDefine
                                                  })
      
      // ...
      return {mInstanceDefine: instanceDefine};
   }
   
   // inputs
   //    mTurnTimeoutSeconds
   //    mSeatsInitialEnabledPolicy
   //    mSeatsNextEnabledPolicy
   //    mSeatsMessageForwardingPolicy
   // outputs
   //    mChannelDefine
   //       mTurnTimeoutMilliseconds
   //       ...
   protected function MultiplePlayer_CreateInstanceChannelDefine (params:Object):Object
   {
      var channelDefine:Object = new Object ();
      
      channelDefine.mTurnTimeouSeconds = int (Math.round (params.mTurnTimeoutSeconds));
      channelDefine.mSeatsInitialEnabledPolicy = params.mSeatsInitialEnabledPolicy;
      channelDefine.mSeatsNextEnabledPolicy = params.mSeatsNextEnabledPolicy;
      channelDefine.mSeatsMessageForwardingPolicy = params.mSeatsMessageForwardingPolicy;
      
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
         if (params.mChannelIndex >= 0 && params.mChannelIndex < MultiplePlayerDefine.MaxNumberOfMutiplePlayerInstanceChannels)
            break;
         
         instacneDefine.mChannelDefines [params.mChannelIndex] = params.mChannelDefine;
         
         succeeded = true;
      }
      while (false);
      
      return {mResult: succeeded};
   }
   
   // ...
   
   public static const MutiplePlayerClientMessageDataFormatVersion:int = 0;
      
   public static const MutiplePlayerClientMessageType_Ping:int = 0;
   public static const MutiplePlayerClientMessageType_CreateInstance:int = 1100;
   public static const MutiplePlayerClientMessageType_JoinRandomInstance:int = 1130;
   public static const MutiplePlayerClientMessageType_JoinInstanceById:int = 1160;
   public static const MutiplePlayerClientMessageType_ChannelMessage:int = 2000;

   // ...
   
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
         messageData.writeBytes ();
         messageData.write
         
         
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
   
   private var mCachedClientMessagesData:ByteArray = null;
   private var mNumCachedClientMessages:int = 0;
   private var mCursorPosOfNumMessages:int = 0;
   
   protected function MultiplePlayer_SendChannelMessage (params:Object):Object
   {
      if (     mMultiplePlayerInstance == null 
            || mMultiplePlayerInstance.mPlayerClientId == null
            || mMultiplePlayerInstance.mPlayerPosition < 0
            || mMultiplePlayerInstance.mPositionsEnabled == null
            || mMultiplePlayerInstance.mPositionsEnabled [mMultiplePlayerInstance.mPlayerPosition] == false
            )
      {
         return;
      }
      
      // ...
      
      if (mCachedClientMessagesData == null)
      {
         mNumCachedClientMessages = 0;
         
         mCachedClientMessagesData = new ByteArray ();
         
         WriteMessagesHeader (mCachedClientMessagesData, mNumCachedClientMessages);
      }
      
      // ...
      
      var channelIndex:int = params.mChannelIndex;
      var messageData:ByteArray = params.mMessageData;
      
      mCachedClientMessagesData.writeShort (MutiplePlayerClientMessageType_ChannelMessage);
      mCachedClientMessagesData.writeShort (channelIndex);
      mCachedClientMessagesData.writeInt (messageData.length);
      mCachedClientMessagesData.writeBytes (messageData, 0, messageData.length);
      
      ++ mNumCachedClientMessages;
   }
   
//======================================================
// 
//======================================================
   
   private function WriteMultiplePlayerMessagesHeader (messagesData:ByteArray, numMessages:int):void
   {
      if (messagesData == null)
         return;
      
      messagesData.position = 0;
      mCachedClientMessagesData.writeInt (messagesData.length);
      mCachedClientMessagesData.writeShort (MutiplePlayerClientMessageDataFormatVersion);
      mCachedClientMessagesData.writeShort (numMessages);
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
            enabledChannelIndexes [numEnabledChannles ++] = channelDefine;
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
         instanceDefineData.writeInt (channelDefine.mTurnTimeouSeconds);
         instanceDefineData.writeByte (channelDefine.mSeatsInitialEnabledPolicy);
         instanceDefineData.writeByte (channelDefine.mSeatsNextEnabledPolicy);
         instanceDefineData.writeByte (channelDefine.mSeatsMessageForwardingPolicy);
      }
      
      // ...
      
      instanceDefineData.position = 0;
      return instanceDefineData;
   }
   
   // 
   private function String2ByteArray (text:String):ByteArray
   {
      var stringData:ByteArray = new ByteArray ();
      
      stringData.writeInt (0);
      stringData.
      
      stringData.position = 0;
      return stringData;
   }
   
   