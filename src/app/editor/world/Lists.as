package editor.world {
   
   import flash.ui.Keyboard;
   
   import com.tapirgames.util.TextUtil;
   
   import common.trigger.CoreEventIds;
   import common.trigger.CoreClassIds;
   import common.trigger.ValueDefine;
   
   import common.Define;
   import common.MultiplePlayerDefine;
   import common.KeyCodes;
   import common.AdvertisementDefine;
   
   public class Lists
   {
            
//=============================================================================
// 
//=============================================================================
      
      public static const mLevelStatusList:Array = [
            {label:"Failed", data:ValueDefine.TaskStatus_Failed},
            {label:"Succeeded", data:ValueDefine.TaskStatus_Successed},
            {label:"Unfinished", data:ValueDefine.TaskStatus_Unfinished},
         ];
      
      public static const mLevelBooleanPropertyList:Array = [
            {label:"Invalid", data:Define.LevelProperty_Invalid},
            {label:"Color Blind Mode Enabled?", data:Define.LevelProperty_ColorBlindMode},
            {label:"Enable Button Over State?", data:Define.LevelProperty_EnableButtonOverState},
         ];
      public static const mLevelNumberPropertyList:Array = [
            {label:"Invalid", data:Define.LevelProperty_Invalid},
            {label:"Joint Appearance Color", data:Define.LevelProperty_JointColor},
            {label:"CI Static Color", data:Define.LevelProperty_CiStaticColor},
            {label:"CI Movable Color", data:Define.LevelProperty_CiMovableColor},
            {label:"CI Breakable Color", data:Define.LevelProperty_CiBreakableColor},
            {label:"CI Infected Color", data:Define.LevelProperty_CiInfectedColor},
            {label:"CI Uninfected Color", data:Define.LevelProperty_CiUninfectedColor},
            {label:"CI Dont-Infect Color", data:Define.LevelProperty_CiDontInfectColor},
            {label:"Render Quality", data:Define.LevelProperty_RenderQuality},
         ];
      public static const mLevelStringPropertyList:Array = [
            {label:"Invalid", data:Define.LevelProperty_Invalid},
            {label:"Render Quality", data:Define.LevelProperty_RenderQuality},
         ];
      
      public static const mEntityTaskStatusList:Array = [
            {label:"Failed", data:ValueDefine.LevelStatus_Failed},
            {label:"Succeeded", data:ValueDefine.LevelStatus_Successed},
            {label:"Unfinished", data:ValueDefine.LevelStatus_Unfinished},
         ];
      
      public static const mAiTypeList:Array = [
            {label:"Unknown", data:Define.ShapeAiType_Unknown},
            {label:"Static", data:Define.ShapeAiType_Static},
            {label:"Movable", data:Define.ShapeAiType_Movable},
            {label:"Breakable", data:Define.ShapeAiType_Breakable},
            {label:"Infected", data:Define.ShapeAiType_Infected},
            {label:"Uninfected", data:Define.ShapeAiType_Uninfected},
            {label:"DontInfect", data:Define.ShapeAiType_DontInfect},
         ];
      
      public static const mCircleAppearanceList:Array = [
            {label:"Ball", data:Define.CircleAppearanceType_Ball},
            {label:"Column", data:Define.CircleAppearanceType_Column},
            {label:"Circle", data:Define.CircleAppearanceType_Circle},
         ];
      
      public static const mKeyCodeList:Array = [
            {label:"Escape", data:KeyCodes.Escape},
            {label:"0", data:KeyCodes.Key_0},
            {label:"1", data:KeyCodes.Key_1},
            {label:"2", data:KeyCodes.Key_2},
            {label:"3", data:KeyCodes.Key_3},
            {label:"4", data:KeyCodes.Key_4},
            {label:"5", data:KeyCodes.Key_5},
            {label:"6", data:KeyCodes.Key_6},
            {label:"7", data:KeyCodes.Key_7},
            {label:"8", data:KeyCodes.Key_8},
            {label:"9", data:KeyCodes.Key_9},
            {label:"A", data:KeyCodes.Key_A},
            {label:"B", data:KeyCodes.Key_B},
            {label:"C", data:KeyCodes.Key_C},
            {label:"D", data:KeyCodes.Key_D},
            {label:"E", data:KeyCodes.Key_E},
            {label:"F", data:KeyCodes.Key_F},
            {label:"G", data:KeyCodes.Key_G},
            {label:"H", data:KeyCodes.Key_H},
            {label:"I", data:KeyCodes.Key_I},
            {label:"J", data:KeyCodes.Key_J},
            {label:"K", data:KeyCodes.Key_K},
            {label:"L", data:KeyCodes.Key_L},
            {label:"M", data:KeyCodes.Key_M},
            {label:"N", data:KeyCodes.Key_N},
            {label:"O", data:KeyCodes.Key_O},
            {label:"P", data:KeyCodes.Key_P},
            {label:"Q", data:KeyCodes.Key_Q},
            {label:"R", data:KeyCodes.Key_R},
            {label:"S", data:KeyCodes.Key_S},
            {label:"T", data:KeyCodes.Key_T},
            {label:"U", data:KeyCodes.Key_U},
            {label:"V", data:KeyCodes.Key_V},
            {label:"W", data:KeyCodes.Key_W},
            {label:"X", data:KeyCodes.Key_X},
            {label:"Y", data:KeyCodes.Key_Y},
            {label:"Z", data:KeyCodes.Key_Z},
            {label:"Left", data:Keyboard.LEFT},
            {label:"Right", data:Keyboard.RIGHT},
            {label:"Top", data:Keyboard.UP},
            {label:"Down", data:Keyboard.DOWN},
            {label:"Space", data:Keyboard.SPACE},
            {label:"Backspace", data:Keyboard.BACKSPACE},
            {label:";", data:KeyCodes.Semicolon},
            {label:",", data:KeyCodes.Comma},
            {label:"=", data:KeyCodes.Add},
            {label:"-", data:KeyCodes.Subtract},
            {label:".", data:KeyCodes.Period},
            {label:"/", data:KeyCodes.Slash},
            {label:"\\", data:KeyCodes.BackSlash},
            {label:"' Quote", data:KeyCodes.Quote},
            {label:"` BackQuote", data:KeyCodes.BackQuote},
            {label:"[", data:KeyCodes.SquareBracketLeft},
            {label:"]", data:KeyCodes.SquareBracketRight},
            {label:"Caps Lock", data:Keyboard.CAPS_LOCK},
            {label:"Tab", data:Keyboard.TAB},
            {label:"Enter", data:Keyboard.ENTER},
            {label:"Insert", data:Keyboard.INSERT},
            {label:"Delete", data:Keyboard.DELETE},
            {label:"Home", data:Keyboard.HOME},
            {label:"End", data:Keyboard.END},
            {label:"Page Up", data:Keyboard.PAGE_UP},
            {label:"Page Down", data:Keyboard.PAGE_DOWN},
            {label:"Left Mouse Button", data:KeyCodes.LeftMouseButton},
         ];
      
      public static const mRngMethodList:Array = [
            {label:"Mersenne Twister", data:Define.RngMethod_MersenneTwister},
         ];
      
      public static const mRngIdList:Array = [
            {label:"Random Number Generator Slot 0", data:0},
            {label:"Random Number Generator Slot 1", data:1},
            {label:"Random Number Generator Slot 2", data:2},
            {label:"Random Number Generator Slot 3", data:3},
         ];
      
      public static const mTextFormatList:Array = [
            {label:"Plain", data:TextUtil.TextFormat_Plain},
            {label:"Wiki", data:TextUtil.TextFormat_Wiki},
            {label:"Html", data:TextUtil.TextFormat_Html},
         ];
         
      public static const mSceneSwitchingStyleList:Array = [
            {label:"None", data:Define.SceneSwitchingStyle_None},
            {label:"Fade In", data:Define.SceneSwitchingStyle_FadingIn},
            {label:"Fade Out", data:Define.SceneSwitchingStyle_FadingOut},
            {label:"Fade Out + Fade In", data:Define.SceneSwitchingStyle_FadingOutThenFadingIn},
            {label:"Blend", data:Define.SceneSwitchingStyle_Blend},
         ];
         
      public static const mNumberDetailList:Array = [
            {label:"Byte (8bits integer)", data:CoreClassIds.NumberTypeDetail_Int8Number},
            {label:"Short (16bits integer)", data:CoreClassIds.NumberTypeDetail_Int16Number},
            {label:"Int (32bits integer)", data:CoreClassIds.NumberTypeDetail_Int32Number},
            {label:"Float (32bits float)", data:CoreClassIds.NumberTypeDetail_FloatNumber},
            {label:"Double Float (64bits float)", data:CoreClassIds.NumberTypeDetail_DoubleNumber},
         ];
         
      private static var _mMultiplePlayerInstanceNumberOfPlayersList:Array = null;
      public static function get mMultiplePlayerInstanceNumberOfPlayersList ():Array
      {
         if (_mMultiplePlayerInstanceNumberOfPlayersList == null)
         {
            _mMultiplePlayerInstanceNumberOfPlayersList = new Array (MultiplePlayerDefine.MinNumberOfInstanceSeats - MultiplePlayerDefine.MinNumberOfInstanceSeats);
            
            var index:int = 0;
            for (var numPlayers:int = MultiplePlayerDefine.MinNumberOfInstanceSeats; numPlayers <= MultiplePlayerDefine.MaxNumberOfInstanceSeats; ++ numPlayers)
            {
               _mMultiplePlayerInstanceNumberOfPlayersList [index ++] = {label: "", data: numPlayers};
            }
         }
         
         return _mMultiplePlayerInstanceNumberOfPlayersList;
      }
         
      private static var _mMultiplePlayerInstanceChannelList:Array = null;
      public static function get mMultiplePlayerInstanceChannelList ():Array
      {
         if (_mMultiplePlayerInstanceChannelList == null)
         {
            _mMultiplePlayerInstanceChannelList = new Array (MultiplePlayerDefine.MaxNumberOfInstanceChannels);
            for (var channelIndex:int = 0; channelIndex < MultiplePlayerDefine.MaxNumberOfInstanceChannels; ++ channelIndex)
            {
               _mMultiplePlayerInstanceChannelList [channelIndex] = {label: "Channel", data: channelIndex};
            }
         }
         
         return _mMultiplePlayerInstanceChannelList;
      }
      
      //public static const mPolicyOfInitialChannelSeatsEnabledStatusList:Array = [
      //      {label:"Disable All", data:MultiplePlayerDefine.PolicyOfInitialChannelSeatsEnabledStatus_DisableAll},
      //      {label:"Enable All", data:MultiplePlayerDefine.PolicyOfInitialChannelSeatsEnabledStatus_EnableAll},
      //      {label:"Random One", data:MultiplePlayerDefine.PolicyOfInitialChannelSeatsEnabledStatus_RandomOne},
      //      {label:"Alternative One", data:MultiplePlayerDefine.PolicyOfInitialChannelSeatsEnabledStatus_Alternative},
      //   ];
      //   
      //public static const mPolicyOfNextChannelSeatsEnabledStatusList:Array = [
      //      {label:"Keep Current", data:MultiplePlayerDefine.PolicyOfNextChannelSeatsEnabledStatus_DoNothing},
      //      {label:"Enable Next And Disable Others", data:MultiplePlayerDefine.PolicyOfNextChannelSeatsEnabledStatus_NextOne},
      //   ];
      //   
      //public static const mPolicyOfChannelMessageForwardingList:Array = [
      //      {label:"Forwards Instantly", data:MultiplePlayerDefine.PolicyOfChannelMessageForwarding_Instant},
      //      {label:"Forwards At Round End", data:MultiplePlayerDefine.PolicyOfChannelMessageForwarding_WeGo},
      //   ];
      
      public static const mMultiplePlayerChannelModeList:Array = [
            {label:"Free Mode", data:MultiplePlayerDefine.InstanceChannelMode_Free},
            {label:"Chess Mode", data:MultiplePlayerDefine.InstanceChannelMode_Chess},
            {label:"WeGo Mode", data:MultiplePlayerDefine.InstanceChannelMode_WeGo},
         ];
      
      public static const mMultiplePlayerPlayerStatusList:Array = [
            {label:"Not Connected", data:MultiplePlayerDefine.PlayerStatus_NotConnected},
            {label:"Wandering", data:MultiplePlayerDefine.PlayerStatus_Wandering},
            {label:"Queuing", data:MultiplePlayerDefine.PlayerStatus_Queuing},
            {label:"Joined", data:MultiplePlayerDefine.PlayerStatus_Joined},
         ];
      
      public static const mMultiplePlayerInstancePhaseList:Array = [
            {label:"Unknown", data:MultiplePlayerDefine.InstancePhase_Inactive},
            {label:"Idling", data:MultiplePlayerDefine.InstancePhase_Idling},
            {label:"Waiting", data:MultiplePlayerDefine.InstancePhase_Waiting},
            {label:"Playing", data:MultiplePlayerDefine.InstancePhase_Playing},
         ];
      
       public static var _mShapeCaringAboutEventIdList:Array = null;
       public static function get mShapeCaringAboutEventIdList ():Array
       {
         if (_mShapeCaringAboutEventIdList == null)
         {
            _mShapeCaringAboutEventIdList = new Array (3);
            
            _mShapeCaringAboutEventIdList [0] = {label:"Invalid", data:-1};
            _mShapeCaringAboutEventIdList [1] = {label:CoreEventDeclarationsForPlaying.GetEventDeclarationById (CoreEventIds.ID_OnTwoPhysicsShapesPreSolveContacting).GetName (), data:CoreEventIds.ID_OnTwoPhysicsShapesPreSolveContacting};
            _mShapeCaringAboutEventIdList [2] = {label:CoreEventDeclarationsForPlaying.GetEventDeclarationById (CoreEventIds.ID_OnTwoPhysicsShapesPostSolveContacting).GetName (), data:CoreEventIds.ID_OnTwoPhysicsShapesPostSolveContacting};
         }
         
         return _mShapeCaringAboutEventIdList;
      }
      
      public static const mAdvertisementPositionTypeList:Array = [
            {label:"Left | Top", data:AdvertisementDefine.Position_LeftOrTop},
            {label:"Center | Middle", data:AdvertisementDefine.Position_CenterOrMiddle},
            {label:"Right | Bottom", data:AdvertisementDefine.Position_RightOrBottom},
         ];
      
      public static const mAdvertisementGenderList:Array = [
            {label:"Unknown", data:AdvertisementDefine.Gender_Unknown},
            {label:"Female", data:AdvertisementDefine.Gender_Female},
            {label:"Male", data:AdvertisementDefine.Gender_Male},
         ];
      
      public static const mAdvertisementTypeList:Array = [
            {label:"Invalid", data:AdvertisementDefine.AdType_Invalid},
            {label:"Full Screen", data:AdvertisementDefine.AdType_Interstitial},
            {label:"Smart Banner", data:AdvertisementDefine.AdType_SmartBanner},
            {label:"Small Banner", data:AdvertisementDefine.AdType_Banner},
            {label:"Full Banner", data:AdvertisementDefine.AdType_FullBanner},
            {label:"Large Banner", data:AdvertisementDefine.AdType_LargeBanner},
            {label:"Leadboard", data:AdvertisementDefine.AdType_Leadboard},
            {label:"Medium Rectangle", data:AdvertisementDefine.AdType_MediumRectangle},
            {label:"Wide Skyscraper", data:AdvertisementDefine.AdType_WideSkyscraper},
         ];
   }
}
