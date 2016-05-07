package 
{
   import flash.display.Sprite;
   
   import editor.EditorPlugin;
   
   public class Main extends Sprite
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         return EditorPlugin.Call (name, params);
      }
   }
}
