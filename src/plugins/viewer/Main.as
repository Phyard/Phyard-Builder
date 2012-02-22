package 
{
   import flash.display.Sprite;
   
   import viewer.Viewer;
   import viewer.SkinDefault;
   
   public class Main extends Sprite
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
