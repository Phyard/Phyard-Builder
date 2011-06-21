package 
{
   import flash.display.Sprite;
   
   import Editor;
   
   public class Main extends Sprite
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         switch (name)
         {
            case "NewEditor":
               var editor:Editor = new Editor ();
               editor.SetParamsFromUniEditor (params);
               break;
            default:
            {
               return null;
            }
         }
      }
   }
}
