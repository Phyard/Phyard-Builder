package 
{
	import viewer.ViewerPlugin;
	import player.WorldPlugin;

   public class Main
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         //var theViewer:Viewer;
         
         switch (name)
         {
            case "GetViewerClass":
            case "NewViewer":
               return ViewerPlugin.Call (name, params);
            default:
            {
               return WorldPlugin.Call (name, params);
            }
         }
      }
   }
}
