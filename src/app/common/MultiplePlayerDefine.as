
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
      
      public static cosnt InstaneChannelMode_Free:int = 0;
      public static cosnt InstaneChannelMode_Chess:int = 1;
      public static cosnt InstaneChannelMode_WeGo:int = 2;
      
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
// messages
//===========================================================================
         
      public static const MessageDataFormatVersion:int = 0;
            // the server response data format version must (try to) be the same as client request.
            // so, to keep good compatibility:
            // 1. focce multiple player game to run on phyard.
            // 2. don't support download standlone app now.
            // 3. reserve some flag bits and zero tail byte
   
//===========================================================================
// server messages
//===========================================================================
         
      public static const ServerMessageType_Ping:int = 0;
      public static const ServerMessageType_Pong:int = 1;
      
      public static const ServerMessageType_Error:int = 100;
      
      public static const ServerMessageType_InstanceServerInfo:int = 1000;
      public static const ServerMessageType_InstanceInfo:int = 1100;
      public static const ServerMessageType_InstanceSeatsInfo:int = 1200;
      public static const ServerMessageType_InstanceChannelsInfo:int = 1300;
      public static const ServerMessageType_InstanceClosed:int = 1400;
      public static const ServerMessageType_InstanceChannelMessage:int = 2000;
      
//===========================================================================
// client messages
//===========================================================================
         
      public static const ClientMessageType_Ping:int = 0;
      public static const ClientMessageType_Pong:int = 1;
      
      public static const ClientMessageType_CreateInstance:int = 1100;
      public static const ClientMessageType_JoinRandomInstance:int = 1130;
      public static const ClientMessageType_JoinInstanceById:int = 1160;
      public static const ClientMessageType_ExitCurrentInstance:int = 1300;
      
      public static const ClientMessageType_Register:int = 3100;
      
      public static const ClientMessageType_ChannelMessage:int = 3000;
      
//===========================================================================
// client messages
//===========================================================================
      
      public static const ErrorCode_NoErrors:int = 0;
      public static const ErrorCode_Unknown:int = 1;
      public static const ErrorCode_UnsupportedDataFormat:int = 100;
      
//===========================================================================
// ...
//===========================================================================
      
      public static const InstancePhase_Pending:int = 0;
      public static const InstancePhase_Playing:int = 1;
      public static const InstancePhase_Clsoed:int = 2;
      
   }
}
