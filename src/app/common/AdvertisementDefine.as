package common {
   
   public class AdvertisementDefine
   {
      // don't change these values. If they are changed, check common/trigger/CoreFunctionDeflarations

      public static const Gender_Unknown:int = 0;      
      public static const Gender_Male   :int = 1;
      public static const Gender_Female :int = 2;
      
      public static const  Position_CenterOrMiddle:int = 0x40000000;
      public static const  Position_LeftOrTop     :int = 0x40000001;
      public static const  Position_RightOrBottom :int = 0x40000002;
      
      //public static const  Position_Sibling_Left   :int = 0x40000003;
      //public static const  Position_Sibling_Top    :int = 0x40000004;
      //public static const  Position_Sibling_Right  :int = 0x40000005;  
      //public static const  Position_Sibling_Bottom :int = 0x40000006;  
      
      public static const AdType_Invalid        :int = 0;
      public static const AdType_Interstitial   :int = 1;
      public static const AdType_SmartBanner    :int = 2;
      public static const AdType_Banner         :int = 3;
      public static const AdType_FullBanner     :int = 4;
      public static const AdType_LargeBanner    :int = 5;
      public static const AdType_Leadboard      :int = 6;
      public static const AdType_MediumRectangle:int = 7;
      public static const AdType_WideSkyscraper :int = 8;
      
      public static const FunctionName_SetAdGlobalOptions   :String = "SetAdGlobalOptions";
      public static const FunctionName_Pause                :String = "Pause";
      public static const FunctionName_Resume               :String = "Resume";
      public static const FunctionName_DestroyAllAds        :String = "DestroyAllAds";
      public static const FunctionName_GetWindowSizeInPixels:String = "GetWindowSizeInPixels";
      public static const FunctionName_HideAllAds           :String = "HideAllAds";
   
      public static const FunctionName_CreateAd             :String = "CreateAd";
      public static const FunctionName_DestroyAd            :String = "DestroyAd";
      public static const FunctionName_CheckAdValidity      :String = "CheckAdValidity";
      public static const FunctionName_GetAdType            :String = "GetAdType";
      public static const FunctionName_GetAdUnitID          :String = "GetAdUnitID";
      public static const FunctionName_PrepareAd            :String = "PrepareAd";
      public static const FunctionName_IsAdReady            :String = "IsAdReady";
      public static const FunctionName_SetAdPosition        :String = "SetAdPosition";
      public static const FunctionName_GetAdBoundsInPixels  :String = "GetAdBoundsInPixels";
      public static const FunctionName_IsAdVisible          :String = "IsAdVisible";
      public static const FunctionName_ShowAd               :String = "ShowAd";
      public static const FunctionName_HideAd               :String = "HideAd";
   }
}
