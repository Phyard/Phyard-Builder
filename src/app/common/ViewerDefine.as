
package common {
   
   public class ViewerDefine
   {

      public static const AboutUrl:String = "http://www.phyard.com";


      
      public static const DefaultPlayerSkinPlayBarHeight:int = 20;
      public static const DefaultPlayerWidth:int = 500; //600; 
      public static const DefaultPlayerHeight:int = 500; //600; 
      
      
      
      // there are 32 bits for the flags (this flags are added from v1.51)
      public static const PlayerUiFlag_UseDefaultSkin:int               = 1 << 0;
      public static const PlayerUiFlag_ShowSpeedAdjustor:int            = 1 << 1;
      public static const PlayerUiFlag_ShowScaleAdjustor:int            = 1 << 2;
      public static const PlayerUiFlag_ShowHelpButton:int               = 1 << 3;
      public static const PlayerUiFlag_ShowSoundController:int          = 1 << 4; // add from v1.59
      public static const PlayerUiFlag_UseCustomLevelFinishedDialog:int = 1 << 5; // add from v2.02
      public static const PlayerUiFlag_AdaptiveViewportSize:int         = 1 << 7;
      public static const PlayerUiFlag_UseOverlaySkin:int               = 1 << 8; // add from v1.59
                                                                 // bit 9-15 are reserved for skin type
      
      // not include v1.51
      public static const PlayerUiFlags_BeforeV0151:int = PlayerUiFlag_UseDefaultSkin 
                                                        | PlayerUiFlag_ShowSpeedAdjustor
                                                        | PlayerUiFlag_ShowScaleAdjustor 
                                                        | PlayerUiFlag_ShowHelpButton
                                                        ;
      // 
      public static const DefaultPlayerUiFlags:int = PlayerUiFlag_UseDefaultSkin
                                                        | PlayerUiFlag_ShowSoundController
                                                        | PlayerUiFlag_UseOverlaySkin
                                                        ;
      
      public static const MaxWorldZoomScale:Number = 32.0;
      public static const MinWorldZoomScale:Number = 1.0 / 32.0;
      
   }
}
