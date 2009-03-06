
var _DataPath = "E:/- custom color infection packages/tapir_ColorInfection3";

var _ImportedPackages = JavaImporter();

_ImportedPackages.importPackage(Packages.java.lang);
_ImportedPackages.importPackage(Packages.java.io);
_ImportedPackages.importPackage(Packages.java.util);

_ImportedPackages.importPackage(Packages.com.meme.io.helper);
_ImportedPackages.importPackage(Packages.com.meme.util);

with (_ImportedPackages)
{
   load (_DataPath + "/config.txt");
   
//=================================================================================
   
   var _OutputDir = null;
   
   for (var argID=0; argID < arguments.length; argID ++)
   {
      var pos = arguments[argID].indexOf ("=");
      if (pos < 0)
      {
      }
      else
      {
        var paramName  = arguments[argID].substring (0, pos);
        var paramValue = arguments[argID].substring (pos + 1);
        
        if (paramName.equals ("output_dir"))
        {
           _OutputDir = FileUtil.getCanonicalPathFileName (paramValue);
		   
            println ("_OutputDir=" + _OutputDir);
        }
      }
   }
   
   if (_OutputDir == null)
   {
      println ("_OutputDir is null !");
      exit ();
   }

//=================================================================================
   
   var binFilePackager = new BinaryFilePackager (FileUtil.getFullPathFilename ("data.bin", _OutputDir));
   
   binFilePackager.writeUTF (_GameTitle);
   
   binFilePackager.beginDataBlcoksWithOffsetTable (_LevelFilesToBePacked.length);
   
   for (var fileID=0; fileID < _LevelFilesToBePacked.length; ++ fileID)
   {
      binFilePackager.beginDataBlock ();
      
      var levelFilePath = FileUtil.getFullPathFilename (_LevelFilesToBePacked [fileID], _DataPath + "/levels");
      binFilePackager.writeFile (levelFilePath);
      
      binFilePackager.endDataBlcok ();
   }
   
   binFilePackager.endDataBlcoksWithOffsetTable ();
   
   binFilePackager.close ();

}