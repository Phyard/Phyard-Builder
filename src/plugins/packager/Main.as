package 
{
   import flash.display.Sprite;
   
   import packager.PackagerPlugin;
   
   public class Main extends Sprite
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         return PackagerPlugin.Call (name, params);
      }
   }
}
