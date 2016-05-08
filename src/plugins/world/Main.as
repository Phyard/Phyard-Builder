package 
{
   import flash.display.Sprite;
   
   import player.WorldPlugin;
   
   public class Main extends Sprite
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         return WorldPlugin.Call (name, params);
      }
   }
}
