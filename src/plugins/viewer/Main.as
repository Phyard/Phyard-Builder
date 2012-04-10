package 
{
   import flash.display.Sprite;
   
   import viewer.ViewerPlugin;
   
   public class Main extends Sprite
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         return ViewerPlugin.Call (name, params);
      }
   }
}
