package viewer
{  
   public class ViewerPlugin
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         var theViewer:Viewer;
         
         switch (name)
         {
            case "GetViewerClass":
               return Viewer;
            case "NewViewer":
               return new Viewer (params);
            case "GetViewerStaticProperties":
               return {
                  IsTouchScreen : Viewer.IsTouchScreen, 
                  CreateExitAppButton : Viewer.CreateExitAppButton, 
                  CreatePlayButton : Viewer.CreatePlayButton, 
                  CreateBackButton : Viewer.CreateBackButton, 
                  CreateSoundOnButton : Viewer.CreateSoundOnButton, 
                  CreateSoundOffButton : Viewer.CreateSoundOffButton, 
                  CreateLockIcon : Viewer.CreateLockIcon, 
                  SetSoundEnabled : Viewer.SetSoundEnabled, 
                  IsSoundEnabled : Viewer.IsSoundEnabled, 
                  CreateSoundOnButton : Viewer.CreateSoundOnButton, 
                  
                  "" : null
               };
            case "GetViewerProperties":
               theViewer = params.mViewer as Viewer;
               
               return {
                  OnBackKeyDown : theViewer.OnBackKeyDown,
                  Destroy : theViewer.Destroy,
                  
                  "" : null
               };
            default:
            {
               return null;
            }
         }
		 
       // NOTE:
       // 1. interface names should not be duplicated with WorldPlugin
		 // 2. when add new interfaces, please sync them to LibViewerWorldForIOS
      }
   }
}
