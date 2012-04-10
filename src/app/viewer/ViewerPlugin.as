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
      }
   }
}
