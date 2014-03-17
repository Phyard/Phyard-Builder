
//==============================================================================
// 
//==============================================================================
   
      public /*static*/ var UI_RestartPlay:Function;
      public /*static*/ var UI_IsPlaying:Function;
      public /*static*/ var UI_SetPlaying:Function;
      public /*static*/ var UI_GetSpeedX:Function;
      public /*static*/ var UI_SetSpeedX:Function;
      public /*static*/ var UI_GetZoomScale:Function;
      public /*static*/ var UI_SetZoomScale:Function;
      public /*static*/ var UI_IsSoundEnabled:Function;
      public /*static*/ var UI_SetSoundEnabled:Function;
      public /*static*/ var UI_GetSoundVolume:Function; // v2.03 (not really used now)
      public /*static*/ var UI_SetSoundVolume:Function; // v2.03 (not really used now)
   
//==============================================================================
// 
//==============================================================================
      
      public /*static*/ var Viewer_mLibCapabilities:Object;
               //IsAccelerometerSupported:Function; // v1.60
               //GetAcceleration:Function; // v1.60
               //GetScreenResolution:Function; // from v2.03
               //GetScreenDPI:Function; // from v2.03
               //OpenURL:Function; // from v2.03
      public /*static*/ var _GetDebugString:Function;
      public /*static*/ var Viewer_SetMouseGestureSupported:Function;
      public /*static*/ var Viewer_OnLoadScene:Function; // v2.00-v2.03
      public /*static*/ var Viewer_mLibSound:Object;
               //PlaySound:Function; // v2.02. (before v2.02, sound lib is included in world instead of viewer)
               //StopAllInLevelSounds:Function; // v2.02
               //StopCrossLevelsSound:Function; // v2.02
      public /*static*/ var Viewer_mLibGraphics:Object; // v2.03
               //LoadImageFromBytes:Function; // v2.03
      public /*static*/ var Viewer_mLibAppp:Object; // v2.03
               //IsNativeApp:Function; // v2.03
               //OnExitApp:Function; // v2.03
      public /*static*/ var Viewer_mLibCookie:Object; // v2.03
               //WriteGameSaveData:Function; // v2.03
               //LoadGameSaveData:Function; // v2.03
               //ClearGameSaveData:Function; // v2.03
      public /*static*/ var Viewer_mLibServices:Object; // v2.03
               //SubmitKeyValue:Function; // v2.0?
               //MultiplePlayer_CreateInstanceDefine:Function; // v2.06
               //MultiplePlayer_CreateInstanceChannelDefine:Function; // v2.06
               //MultiplePlayer_ReplaceInstanceChannelDefine:Function; // v2.06
               //MultiplePlayer_JoinNewInstance:Function; // v2.06
               //MultiplePlayer_JoinRandomInstance:Function; // v2.06
               //MultiplePlayer_SendChannelMessage:Function; // v2.06
   
//==============================================================================
// 
//==============================================================================
   
   private /*static*/ var mDebugString:String = null;
   public /*static*/ function GetDebugString ():String
   {
      return mDebugString;
   }
      