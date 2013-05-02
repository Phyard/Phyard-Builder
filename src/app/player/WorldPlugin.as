package player
{
   import player.world.World;
   import player.design.Global;
   
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
                  mWorldVersion : Version.VersionNumber,
                  //WorldFormat_HexString2ByteArray : DataFormat2.HexString2ByteArray, // from v1.00 to v1.55 (excluding 1.55)
                  WorldFormat_ByteArray2WorldDefine : DataFormat2.ByteArray2WorldDefine, // from v1.00
                  WorldFormat_WorldDefine2Xml : DataFormat2.WorldDefine2Xml,  // from v1.02
                  WorldFormat_WorldDefine2PlayerWorld : DataFormat2.WorldDefine2PlayerWorld, // from v1.00
                  
                  "" : null
               };
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
                  mHasSounds : Global.HasSounds (), // from v1.59
                  mInitialSoundEnabled : Global.IsSoundEnabled (), // from v1.59
                  SetSoundEnabled : Global.SetSoundEnabled, // from v1.59
                  
                  GetPreferredFPS : world.GetPreferredFPS, // from v1.60
                  IsPauseOnFocusLost : world.IsPauseOnFocusLost, // from v1.60 
                  
                  RegisterGestureEvent : world.RegisterGestureEvent, // from v1.60
                  
                  "" : null
               };
            case "SetUiParams":
               world = params.mWorld as World;
               
               Global.UI_RestartPlay = params.OnClickRestart as Function;
               Global.UI_IsPlaying = params.IsPlaying as Function;
               Global.UI_SetPlaying = params.SetPlaying as Function;
               Global.UI_GetSpeedX = params.GetPlayingSpeedX as Function;
               Global.UI_SetSpeedX = params.SetPlayingSpeedX as Function;
               Global.UI_GetZoomScale = params.GetZoomScale as Function;
               Global.UI_SetZoomScale = params.SetZoomScale as Function; // from v1.53, SetScale has a 2nd param: changeScaleSmoothly, default value is true
               Global.UI_IsSoundEnabled = params.IsSoundEnabled as Function; // from v1.59
               Global.UI_SetSoundEnabled = params.SetSoundEnabled as Function; // from v1.59
               
               Global.Viewer_mLibCapabilities = params.mLibCapabilities; // from v1.60
                           //IsAccelerometerSupported:Function; // from v1.60
                           //GetAcceleration:Function; // from v1.60
               Global._GetDebugString = params.GetDebugString as Function; // from v1.60
               
               Global.Viewer_SetMouseGestureSupported = params.SetMouseGestureSupported as Function; // from v1.60
               
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
