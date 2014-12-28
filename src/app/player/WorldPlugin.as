package player
{
   import player.world.World;
   import player.world.Global;
   
   import common.DataFormat2;
   import common.Version;
   
   public class WorldPlugin
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         var world:World;
         
         switch (name)
         {
            case "GetStaticProperties":
               return {
                  mWorldVersion : Version.VersionNumber, // version of the world plugin, not the world file format
                  //WorldFormat_HexString2ByteArray : DataFormat2.HexString2ByteArray, // from v1.00 to v1.55 (excluding 1.55). Now is put in DataFormat3.
                  WorldFormat_ByteArray2WorldDefine : DataFormat2.ByteArray2WorldDefine, // from v1.00
                  WorldFormat_WorldDefine2Xml : DataFormat2.WorldDefine2Xml,  // from v1.02, for "copy source code"
                  WorldFormat_WorldDefine2PlayerWorld : DataFormat2.WorldDefine2PlayerWorld, // from v1.00
                  
                  "" : null
               };
            case "SetViewerParams":
               world = params.mWorld as World;
               
               //Global._GetDebugString = params.GetDebugString as Function; // from v1.60
               /*Global.sTheGlobal*/world._GetDebugString = /*Global.sTheGlobal*/world.GetDebugString;
               
               /*Global.sTheGlobal*/world.Viewer_SetMouseGestureSupported = params.SetMouseGestureSupported as Function; // from v1.60
               
               /*Global.sTheGlobal*/world.Viewer_mLibCapabilities = params.mLibCapabilities; // from v1.60
                           //IsAccelerometerSupported:Function; // from v1.60
                           //GetAcceleration:Function; // from v1.60
                           //GetScreenResolution:Function; // from v2.03
                           //GetScreenDPI:Function; // from v2.03
                           //IsMultitouchSupported:Function; // from v2.10
               
               /*Global.sTheGlobal*/world.Viewer_OnLoadScene = params.OnLoadScene as Function; // from v2.00
                                                                  // useless since v2.03.
                                                                  // for v2.05 is the main version for v2.00-v2.05,
                                                                  // this can't be removed safely. (edit at 2.08: can't? or can?)
               
               /*Global.sTheGlobal*/world.Viewer_mLibSound = params.mLibSound; // from v2.02
               
               /*Global.sTheGlobal*/world.Viewer_mLibGraphics = params.mLibGraphics; // from v2.03
               
               /*Global.sTheGlobal*/world.Viewer_mLibAppp = params.mLibApp; // v2.03
                                                        //.OpenURL              // v2.03
                                                        //.IsCurrentViewer      // v2.08
                                                        //.GetAppWindowPadding  // v2.09
                                                        //.SetAppWindowPadding  // v2.09
                                                        //.GetAppRootURL        // v2.09
               
               /*Global.sTheGlobal*/world.Viewer_mLibCookie = params.mLibCookie; // from v2.03
               
               /*Global.sTheGlobal*/world.Viewer_mLibServices = params.mLibService; // from v2.03
                                                        //.GetAdvertisementProxy   // v2.08
               
               break;
            case "GetWorldProperties":
               world = params.mWorld as World;
               
               return {
                  mAuthorName : world.GetAuthorName (), // from v1.00
                  mAuthorHomepage : world.GetAuthorHomepage (), // from v1.00
                  
                  mIsPermitPublishing : world.IsPermitPublishing (), // from v1.02
                  mIsShareSourceCode : world.IsShareSourceCode (), // from v1.02
                  
                  GetZoomScale : world.GetZoomScale, // from v1.04
                  SetZoomScale : world.SetZoomScale, // from v1.04
                  
                  //GetViewportWidth : world.GetViewportWidth, // from v1.50
                  //GetViewportHeight : world.GetViewportHeight, // from v1.50
                  GetViewportWidth : world.GetPreferredViewportWidth, // from v1.59
                  GetViewportHeight : world.GetPreferredViewportHeight, // from v1.59
                  GetViewerUiFlags : world.GetViewerUiFlags, // from v1.50
                  GetPlayBarColor : world.GetPlayBarColor, // from v1.50
                  GetBackgroundColor : world.GetBackgroundColor, // from v2.03, (temporarily return the current scene bg color)
                  
                  Initialize : world.Initialize, // from v1.52 (beforev1.52, initialize is called in plugin)
                  Destroy : world.Destroy, // from v1.00
                  Update : world.Update, // from v1.00
                  
                  SetSingleStepMode : world.SetSingleStepMode, // from v1.52
                  
                  SetPaused : world.SetPaused, // from v1.07
                  SetInteractiveEnabledWhenPaused : world.SetInteractiveEnabledWhenPaused, // from v1.07
                  
                  IsLevelSuccessed : world.IsLevelSuccessed, // from v1.07
                  
                  SetCacheSystemEvent : world.SetCacheSystemEvent, // from v1.50
                  
                  GetBuildingStatus : world.GetBuildingStatus, // from v1.58
                  
                  SetRealViewportSize : world.SetRealViewportSize, // from v1.59
                  
                  mInitialSpeedX : world.GetInitialSpeedX (), // from v1.59
                  mInitialZoomScale : world.GetZoomScale (), // from v1.59
                  mHasSounds : Global.sTheGlobal.HasSounds (), // from v1.59
                  //mInitialSoundEnabled : Global.IsSoundEnabled (), // from v1.59 to v2.02 (seems never used in Viewer)
                  //SetSoundEnabled : Global.SetSoundEnabled, // from v1.59 to v2.02 (become useless in Viewer from v2.02)
                  
                  GetPreferredFPS : world.GetPreferredFPS, // from v1.60
                  IsPauseOnFocusLost : world.IsPauseOnFocusLost, // from v1.60
                  
                  RegisterGestureEvent : world.RegisterGestureEvent, // from v1.60
                  
                  OnViewerEvent : world.OnViewerEvent, // from v2.00. (to fix the missing mouse events caused by overlapping gesture shapes)
                  
                  OnViewerDestroyed : Global.OnViewerDestroyed, // from v2.02
                  OnSystemBackEvent: world.OnSystemBackEvent, // from v2.02
                  
                  HasRestartLevelRequest : world.HasRestartLevelRequest, // from v2.03
                  GetDelayToLoadSceneIndex : world.GetDelayToLoadSceneIndex, // from v2.03
                  
                  GetSceneSwitchingStyle : world.GetSceneSwitchingStyle, // from v2.04
                  
                  GetWorldCrossStagesData : world.GetWorldCrossStagesData, // from v2.06
                  
                  OnMultiplePlayerEvent : world.OnMultiplePlayerEvent, // from v2.06
                  
                  SupportMoreMouseEvents : world.IsSupportMoreMouseEvents, // from v2.08
                  
                  //SetViewportStretchScale : world.SetViewportStretchScale, // from v2.08, removed at v2.09
                  
                  SetViewportBoundsInDevicePixels : world.SetViewportBoundsInDevicePixels, // from v2.09
                  
                  "" : null
               };
            case "SetUiParams":
               world = params.mWorld as World;
               
               /*Global*/world.UI_RestartPlay = params.OnClickRestart as Function; // useless since v2.03
               /*Global*/world.UI_IsPlaying = params.IsPlaying as Function;
               /*Global*/world.UI_SetPlaying = params.SetPlaying as Function;
               /*Global*/world.UI_GetSpeedX = params.GetPlayingSpeedX as Function;
               /*Global*/world.UI_SetSpeedX = params.SetPlayingSpeedX as Function;
               /*Global*/world.UI_GetZoomScale = params.GetZoomScale as Function;
               /*Global*/world.UI_SetZoomScale = params.SetZoomScale as Function; // from v1.53, SetScale has a 2nd param: changeScaleSmoothly, default value is true
               /*Global*/world.UI_IsSoundEnabled = params.IsSoundEnabled as Function; // from v1.59 (really used from v2.02)
               /*Global*/world.UI_SetSoundEnabled = params.SetSoundEnabled as Function; // from v1.59 (really used from v2.02)
               /*Global*/world.UI_GetSoundVolume = params.GetSoundVolume as Function; // from v2.03 (not really used now)
               /*Global*/world.UI_SetSoundVolume = params.SetSoundVolume as Function; // from v2.03 (not really used now)
               
               break;
            default:
            {
               break;
            }
         }
         
         return null;
      }
   }
}
