package 
{
   import flash.display.Sprite;
   
   import viewer.Viewer;
   
   public class Main extends Sprite
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         switch (name)
         {
            case "NewViewer":
               return new Viewer (params);
               break;
            default:
            {
               return null;
            }
         }
      }
   }
}