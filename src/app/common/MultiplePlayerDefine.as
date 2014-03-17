
package common {
   
   public class MultiplePlayerDefine
   {
   
//===========================================================================
//  when changing these values, please consider compatibility 
//===========================================================================
      
      //
      
      public static const MaxAllowedStringLength:int = 100; // the length head for string is a short. Null string will be treated as blank string.
      
      //
      
      public static const MaxTurnTimeoutInPractice:int = 1800; // half an hour
      
      //
      
      public static const MinNumberOfMutiplePlayerInstanceSeats:int = 2;
      public static const MaxNumberOfMutiplePlayerInstanceSeats:int = 4;
      
      public static const MaxNumberOfMutiplePlayerInstanceChannels:int = 8;
      public static const MaxNumberOfMutiplePlayerInstanceVotings:int = 8;
      
      // channel seat policy
      
      public static const PolicyOfInitialChannelSeatsEnabledStatus_DisableAll:int = 0;
      public static const PolicyOfInitialChannelSeatsEnabledStatus_EnableAll:int = 1;
      public static const PolicyOfInitialChannelSeatsEnabledStatus_RandomOne:int = 2;
      public static const PolicyOfInitialChannelSeatsEnabledStatus_Alternative:int = 3;
      
      public static const PolicyOfNextChannelSeatsEnabledStatus_DoNothing:int = 0;
      public static const PolicyOfNextChannelSeatsEnabledStatus_NextOne:int = 1;
      
      public static const PolicyOfChannelMessageForwarding_Instant:int = 0;
      public static const PolicyOfChannelMessageForwarding_WeGo:int = 1;
      
//===========================================================================
// 
//===========================================================================
      
      
      
   }
}
