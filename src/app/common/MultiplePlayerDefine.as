
package common {
   
   public class MultiplePlayerDefine
   {
   
//===========================================================================
//  when changing these values, please consider compatibility 
//===========================================================================
      
      //
      
      public static const MaxAllowedStringLength:int = 100; // the length head for string is a short. Null string will be treated as blank string.
                                                      // increase 10 each time
      //
      
      public static const MaxTurnTimeoutInPractice:int = 1800; // half an hour
      
      //
      
      public static const MinNumberOfInstanceSeats:int = 2;
      public static const MaxNumberOfInstanceSeats:int = 4;
      
      public static const MaxNumberOfInstanceChannels:int = 8;
      //public static const MaxNumberOfInstanceVotings:int = 8;
      //public static const MaxNumberOfInstanceSignals:int = 8;
      
      //
      
      public static const InstanceChannelMode_Free:int = 0; // don't change the value, see RegisterCoreDeclaration (CoreFunctionIds.ID_CreateNewGameInstanceChannelDefine)
      public static const InstanceChannelMode_Chess:int = 1;
      public static const InstanceChannelMode_WeGo:int = 2;
      
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
// server messages
//===========================================================================
      
      // public static const ServerMessageDataFormatVersion:int = 0;
         // server messages don't have a format.
         // server may return different message formats or types on different client message data formats
      
      public static const ServerMessageType_Ping:int                    = 0x0000;
      public static const ServerMessageType_Pong:int                    = 0x0100;
      
      public static const ServerMessageType_Error:int                   = 0x0500;
      
      public static const ServerMessageType_InstanceServerInfo:int      = 0x1000;
      
      public static const ServerMessageType_InstanceBasicInfo:int       = 0x3000;
      public static const ServerMessageType_InstanceCurrentPhase:int    = 0x3100;
      public static const ServerMessageType_SeatBasicInfo:int           = 0x3200;
      public static const ServerMessageType_SeatDynamicInfo:int         = 0x3300;
      public static const ServerMessageType_AllChannelsConstInfo:int    = 0x3400;
      public static const ServerMessageType_ChannelSeatInfo:int         = 0x3500;
      
      public static const ServerMessageType_ChannelMessage:int          = 0x5000;
      
//===========================================================================
// client messages
//===========================================================================
      
      public static const ClientMessageDataFormatVersion:int = 0;
      
      public static const ClientMessageType_Ping:int = 0x00;
      public static const ClientMessageType_Pong:int = 0x01;
      
      public static const ClientMessageType_CreateInstance:int         = 0x10;
      public static const ClientMessageType_JoinRandomInstance:int     = 0x11;
      public static const ClientMessageType_JoinInstanceById:int       = 0x12; // todo
      public static const ClientMessageType_GetPendingInstances:int    = 0x13; // todo
      
      public static const ClientMessageType_LoginInstanceServer:int    = 0x30;
      public static const ClientMessageType_ExitCurrentInstance:int    = 0x31;
      public static const ClientMessageType_ChannelMessage:int         = 0x32;
      public static const ClientMessageType_SignalRestartInstance:int  = 0x33; // todo
      
//===========================================================================
// client messages
//===========================================================================
      
      public static const ErrorCode_NoErrors:int = 0;
      public static const ErrorCode_Unknown:int = 1;
      public static const ErrorCode_UnsupportedDataFormat:int = 100; // notify users to upgrade app.
      
//===========================================================================
// ...
//===========================================================================
      
      public static const InstancePhase_Inactive:int = 0x00;
      public static const InstancePhase_Pending:int  = 0x10;
      public static const InstancePhase_Playing:int  = 0x20;
      
   }
}