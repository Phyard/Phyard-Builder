package viewer
{  
   public class ViewerPlugin
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         //var theViewer:Viewer;
         
         switch (name)
         {
            case "GetViewerClass":
               return Viewer;
            case "NewViewer":
               return new Viewer (params);
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
