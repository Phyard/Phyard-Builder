package packager
{  
   public class PackagerPlugin
   {
      public static function Call (name:String, params:Object = null):Object 
      {
         switch (name)
         {
            case "CreateSwfPackage":
               //var packager:Packager = new Packager (); // shit flex!
               //return packager.PackageNewFileData (params);
               var aPackager:Packager = new Packager ();
               return aPackager.PackageNewFileData (params);
            default:
            {
               return null;
            }
         }
      }
   }
}
