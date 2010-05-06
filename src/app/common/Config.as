
package common {
   
   public class Config
   {
      // the version number is a hex number, but there is no 0x010A, only 0x0110
      public static const VersionNumber:int = 0x0150;
      
      public static const EnablePageAnalytics:Boolean = false;
      
      public static const GoogleAnalyticsID:String = "UA-7090833-1";
      
      public static const VirtualPageName_EditorJustLoaded:String = "/editor_start";
      public static const VirtualPageName_EditorTimePrefix:String = "/editor_time";
      
      public static const VirtualPageName_PlayerJustLoaded:String = "/player_start";
      public static const VirtualPageName_PlayerTimePrefix:String = "/player_time";
   }
}
