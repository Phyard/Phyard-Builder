
package common {
   
   public class MultiplePlayerDefine
   {  
      public static const Length_PlayerConnID          :int = 16; // uuid
      public static const Length_InstanceID            :int = 16; // uuid
      public static const Length_InstanceDefineHashKey :int = 32; // sha256 hash
      
      // todo: the followings are not checked on client side yet.
            
      public static const MaxPlayerNameLength:int = 26; // player name is stored as as UTF with 2 bytes length header
      
      public static const MaxInstanceDefineDataLength:int =  2000;
      public static const MinInstanceFullGameIdLength:int =  8;
      public static const MaxInstanceFullGameIdLength:int =  127;
      public static const MinDesignAuthorNameLength  :int =  3;
      public static const MaxDesignAuthorNameLength  :int =  32; // it is 16 on phyard.com now
      
//===========================================================================
//  when changing these values, please consider compatibility 
//===========================================================================
      
      //
      
      public static const MaxTurnTimeoutInPractice:int = 1800; // half an hour
      public static const MaxTurnTimeoutX8InPractice:int = (MaxTurnTimeoutInPractice << 3);
      
      //
      
      public static const MinNumberOfInstanceSeats:int = 2;
      public static const MaxNumberOfInstanceSeats:int = 4;
      
      public static const MaxNumberOfInstanceChannels:int = 8;
      
      //
      
      public static const InstanceChannelMode_Free:int = 0; // don't change the value, see RegisterCoreDeclaration (CoreFunctionIds.ID_CreateNewGameInstanceChannelDefine)
      public static const InstanceChannelMode_Chess:int = 1;
      public static const InstanceChannelMode_WeGo:int = 2;
      public static const MaxInstanceChannelMode:int = InstanceChannelMode_WeGo;
      //public static const InstanceChannelMode_WeGoNoHolding:int = 3;
      //public static const InstanceChannelMode_Vote:int = 4;
      
      // channel seat policy
      
      //public static const PolicyOfInitialChannelSeatsEnabledStatus_DisableAll:int = 0;
      //public static const PolicyOfInitialChannelSeatsEnabledStatus_EnableAll:int = 1;
      //public static const PolicyOfInitialChannelSeatsEnabledStatus_RandomOne:int = 2;
      //public static const PolicyOfInitialChannelSeatsEnabledStatus_Alternative:int = 3;
      
      //public static const PolicyOfNextChannelSeatsEnabledStatus_DoNothing:int = 0;
      //public static const PolicyOfNextChannelSeatsEnabledStatus_NextOne:int = 1;
      
      //public static const PolicyOfChannelMessageForwarding_Instant:int = 0;
      //public static const PolicyOfChannelMessageForwarding_WeGo:int = 1;
      
//===========================================================================
// 
//===========================================================================
      
      public static const MaxMessageDataLengthToHoldReally:int = 127; // not 128 is for server convenience, one byte for length header.
                                                                      // The max possible value is 255.
      
      public static const MessageEncryptionMethod_DoNothing:int = 0;
      public static const MessageEncryptionMethod_SwapRollShift:int = 1;
      
//===========================================================================
// server messages
//===========================================================================
      
      public static const ServerMessageHeadString:String = "COIN"; // don't change
      
      // public static const ServerMessageDataFormatVersion:int = 0;
         // server messages don't have a format.
         // server may return different message formats or types on different client message data formats
      
      public static const ServerMessageType_Ping:int                    = 0x0000;
      public static const ServerMessageType_Pong:int                    = 0x0100;
      
      public static const ServerMessageType_Error:int                   = 0x0500;
      
      public static const ServerMessageType_InstanceServerInfo:int             = 0x1000;
      
      public static const ServerMessageType_QueuingInfo:int                    = 0x3000;

      //public static const ServerMessageType_LoggedOff:int                      = 0x4000; // use SetPlayerStatus (not_connected) instead
      
      public static const ServerMessageType_InstanceConstInfo:int              = 0x5000;
      public static const ServerMessageType_MySeatIndex:int                    = 0x5100;
      public static const ServerMessageType_InstancePlayingInfo:int            = 0x5200;
      public static const ServerMessageType_InstanceCurrentPhase:int           = 0x5300;
      public static const ServerMessageType_SeatBasicInfo:int                  = 0x5400;
      public static const ServerMessageType_SeatDynamicInfo:int                = 0x5500;
      public static const ServerMessageType_AllChannelsConstInfo:int           = 0x5600;
      public static const ServerMessageType_ChannelDynamicInfo:int             = 0x5700;
      public static const ServerMessageType_ChannelSeatInfo:int                = 0x5800;
      
      public static const ServerMessageType_ChannelMessage:int                 = 0x6000;
      public static const ServerMessageType_ChannelMessageEncrpted:int         = 0x6100;
      public static const ServerMessageType_ChannelMessageEncrptionCiphers:int = 0x6200;
      
      public static const ServerMessageType_PlayerStatus:int                   = 0x9000;
      
//===========================================================================
// client messages
//===========================================================================
      
      public static const ClientMessageHeadString:String = "PLAY"; // don't change. for server convenience to differentiate between play messagea and http message.
      
      public static const ClientMessageDataFormatVersion:int = 0x0000; // next 0x0010
      
      public static const ClientMessageType_Ping:int = 0x00;
      public static const ClientMessageType_Pong:int = 0x01;
      
      //public static const ClientMessageType_CreateNewInstanceRequest:int      = 0x10; // todo
      public static const ClientMessageType_JoinRandomInstanceRequest:int     = 0x11;
      //public static const ClientMessageType_JoinInstanceByIdRequest:int       = 0x12; // todo
      //public static const ClientMessageType_GetWaitingInstancesRequest:int    = 0x13; // todo
      
      public static const ClientMessageType_LoginInstanceServer:int         = 0x30;
      //public static const ClientMessageType_LogoutInstanceServer:int         = 0x31; // todo
      public static const ClientMessageType_JoinRandomInstance:int          = 0x32;
      //public static const ClientMessageType_LeaveCurrentInstance:int         = 0x33; // todo
      
      public static const ClientMessageType_ChannelMessage:int              = 0x60;
      public static const ClientMessageType_ChannelMessageWithEncrption:int = 0x61;
      
      public static const ClientMessageType_Signal_ChangeInstancePhase:int      = 0x70;
      
//===========================================================================
// error numbers
//===========================================================================
      
      public static const ErrorCode_NoErrors                 :int = 0;
      public static const ErrorCode_Unknown                  :int = 1;

      public static const ErrorCode_NetworkNotAvaiable       :int = 101;
      public static const ErrorCode_ServerIsBusy             :int = 102;
      public static const ErrorCode_JoinedTooManyInstances   :int = 103;
      public static const ErrorCode_SpamUser                 :int = 104;
      
      public static const ErrorCode_UnsupportedDataFormat    :int = 160; // notify users to upgrade app.
      public static const ErrorCode_BadData                  :int = 161;
      public static const ErrorCode_TooLargeData             :int = 162;
      public static const ErrorCode_TooManyMessages          :int = 163;
      public static const ErrorCode_TooFrequentSendings      :int = 164;
      
      public static const ErrorCode_UnknownMessageType       :int = 170;
      public static const ErrorCode_UnknownSignalType        :int = 171;
      
//===========================================================================
// ...
//===========================================================================

      // the 2 are only useful on server side.
      //public static const PlayerStatus_Free:int       = 0; // socket not connected.
      //public static const PlayerStatus_Pending:int    = 1; // socket connected, but not logged in yet. Not visible to designers.
                                                             
      public static const PlayerStatus_NotConnected:int = 0; // for client side only <=> server side free + server side pending
      public static const PlayerStatus_Wandering:int    = 10;
      public static const PlayerStatus_Queuing:int      = 30;
      public static const PlayerStatus_Joined:int       = 50;
      
//===========================================================================
// ...
//===========================================================================
      
      public static const InstancePhase_Inactive:int = 0;
      public static const InstancePhase_Idling:int   = 60;
      public static const InstancePhase_Waiting:int  = 80;
      public static const InstancePhase_Playing:int  = 100;
      
      public static const InstancePhase_Invalid:int = 255;
      
      public static function IsValidInstancePhase (phase:int):Boolean
      {
         return phase == InstancePhase_Inactive
             || phase == InstancePhase_Idling
             || phase == InstancePhase_Waiting
             || phase == InstancePhase_Playing
             ;
      }
      
   }
}