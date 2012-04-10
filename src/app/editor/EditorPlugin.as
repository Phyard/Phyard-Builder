package editor
{
   public class EditorPlugin
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         var anEditor:Editor;
         
         switch (name)
         {
            case "NewEditor":
               anEditor = new Editor ();
               anEditor.SetParamsFromUniEditor (params); 
               return anEditor;
            default:
            {
               return null;
            }
         }
      }
   }
}
