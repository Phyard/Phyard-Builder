
var packageNames = JavaImporter();

packageNames.importPackage(Packages.com.meme.editor.model.sprite2d);
packageNames.importPackage(Packages.com.meme.editor.level);
packageNames.importPackage(Packages.com.meme.editor.level.define);
packageNames.importPackage(Packages.com.meme.editor.property);
packageNames.importPackage(Packages.com.meme.io.editor);
packageNames.importPackage(Packages.com.meme.io.helper);
packageNames.importPackage(Packages.com.meme.io.packager);
packageNames.importPackage(Packages.com.meme.util);
packageNames.importPackage(Packages.java.lang);
packageNames.importPackage(Packages.java.io);
packageNames.importPackage(Packages.java.util);
packageNames.importPackage(Packages.java.awt.image);


var kFileType_Image    = new String ("ImageFile");
var kFileType_Sprite2d = new String ("Sprite2dFile");
var kFileType_Define   = new String ("DefineFile");
var kFileType_Level    = new String ("LevelFile");
var kFileType_Sound    = new String ("SoundFile");


var _ResBaseDir;
var _ResCompiledDir;  
var _GameMode = new String ("Adventure");



var _LevelFilesToBePacked = [
];

var _SoundFilesToBePacked = [
];

var _ImageFilesToBePacked = [

];

var _SpriteFilesToBePacked = [
];


with (packageNames)
{

  function FileInfo (resFullPath, gamePath, fileType)
   {
      this.resPath  = resFullPath;
      this.gamePath  = gamePath.replace ('\\', '/');
      this.fileType  = fileType;
   }
	
//=================================================================
//
//=================================================================

   
   var _ActorTypeCollector        = new ObjectCollector ();
   var _AppearanceTypeCollector   = new ObjectCollector ();
   var _PropertyTypeCollector     = new ObjectCollector ();
   var _FileTypeCollector         = new ObjectCollector ();
   
   var _ImageFileCollector        = new ObjectCollector ();
   var _Sprite2dFileCollector     = new ObjectCollector ();
   var _DefineFileCollector       = new ObjectCollector ();
   var _LevelFileCollector        = new ObjectCollector ();
   
   var _PackedFileInfoList = new Vector ();

   

   
   function collectActorTypes ()
   {
      _ActorTypeCollector.addObject (ActorFactory.ActorType_General);
   }
   
   function collectAppearanceTypes ()
   {
      _AppearanceTypeCollector.addObject (AppearanceFactory.AppearanceType_Sprite2d);
      _AppearanceTypeCollector.addObject (AppearanceFactory.AppearanceType_Background2d);
      _AppearanceTypeCollector.addObject (AppearanceFactory.AppearanceType_Box2d);
      _AppearanceTypeCollector.addObject (AppearanceFactory.AppearanceType_Circle);
      _AppearanceTypeCollector.addObject (AppearanceFactory.AppearanceType_Line2d);
   }

   function collectPropertyTypes ()
   {
      _PropertyTypeCollector.addObject (PropertyFactory.ValueType_Number);
      _PropertyTypeCollector.addObject (PropertyFactory.ValueType_String);
      _PropertyTypeCollector.addObject (PropertyFactory.ValueType_Items);
      _PropertyTypeCollector.addObject (PropertyFactory.ValueType_EntityRef);
      _PropertyTypeCollector.addObject (PropertyFactory.ValueType_Boolean);
   }

   function collectFileTypes ()
   {
      _FileTypeCollector.addObject (kFileType_Image);
      _FileTypeCollector.addObject (kFileType_Sprite2d);
      _FileTypeCollector.addObject (kFileType_Define);
      _FileTypeCollector.addObject (kFileType_Level);
      _FileTypeCollector.addObject (kFileType_Sound);
   }
   
   function collectPackedFiles ()
   {
      println ("Collect Res Files:");
      
      var fileCollector = FileCache.getFileCollector ();
      
      println ("fileCollector.getObjectsCount () = " + fileCollector.getObjectsCount ());
   
      
     // first, seperated files
     
  	  for (var fileID=0; fileID < _SoundFilesToBePacked.length; fileID ++)
     {
			var binFilename = FileUtil.getFullPathFilename (_SoundFilesToBePacked [fileID], _ResBaseDir);
			var gamePath = _SoundFilesToBePacked [fileID];
         
         var fileinfo = new FileInfo (binFilename, gamePath, kFileType_Sound);
         _PackedFileInfoList.add (fileinfo);
     }
     
  	  for (var fileID=0; fileID < _ImageFilesToBePacked.length; fileID ++)
     {
			var binFilename = FileUtil.getFullPathFilename (_ImageFilesToBePacked [fileID], _ResBaseDir);
			var gamePath = _ImageFilesToBePacked [fileID];
         
         var fileinfo = new FileInfo (binFilename, gamePath, kFileType_Image);
         _PackedFileInfoList.add (fileinfo);
     }
     
     for (var fileID=0; fileID < _SpriteFilesToBePacked.length; fileID ++)
     {
         var fullPathFilename = FileUtil.getFullPathFilename (_SpriteFilesToBePacked [fileID], _ResBaseDir);
         
         FileCache.getSprite2dFile (fullPathFilename);
	      var file = FileUtil.getFile (fullPathFilename);
         var fileAsset = FileCache.getLoadedFileAsset (file);

   		 if (fileAsset instanceof Sprite2dFile) // must be true
   		 {
   		    _Sprite2dFileCollector.addObject (file);
   			
   			var binFilename = file.getCanonicalPath () + ".bin";
   			var gamePath = FileUtil.getRelativePathFilename (file.getCanonicalPath (), _ResBaseDir);

   			writeSprite2dFile (fileAsset, binFilename);

   			var fileinfo = new FileInfo (binFilename, gamePath, kFileType_Sprite2d);			
   			_PackedFileInfoList.add (fileinfo);
   		 }
     }

     // collect other refed by level files
	  
     
	   for (var fileID=0; fileID < fileCollector.getObjectsCount (); fileID ++)
      {
	     var file = fileCollector.getObjectAt(fileID);
	     var fileAsset = FileCache.getLoadedFileAsset (file);
		  if (fileAsset instanceof DefineFile)
		  {
          var defineFile = fileAsset;
			 var binFilename = file.getCanonicalPath () + ".bin";
			 writeDefineBinFile (defineFile, binFilename);
          
          var codeFilePath = FileUtil.getFilenameWithoutExt (file.getCanonicalPath ());
		    codeFilePath = codeFilePath.toUpperCase().substring (0,1) + (codeFilePath.length() > 1 ? codeFilePath.substring (1) : "");
		    codeFilePath = FileUtil.getFullPathFilename ("k" + codeFilePath + ".as", _ResCompiledDir);
          writeDefineCodeFile (defineFile, codeFilePath);
		  }
	  }
     
     
	  for (var fileID=0; fileID < fileCollector.getObjectsCount (); fileID ++)
      {
	     var file = fileCollector.getObjectAt(fileID);
	     var fileAsset = FileCache.getLoadedFileAsset (file);
		 if (fileAsset instanceof BufferedImage)
		 {
		    _ImageFileCollector.addObject (file);
			
			var fullPath = file.getCanonicalPath ();
			var gamePath = FileUtil.getRelativePathFilename (fullPath, _ResBaseDir);
         
         println ("  - " + fullPath);
			
			var fileinfo = new FileInfo (fullPath, gamePath, kFileType_Image);			
			_PackedFileInfoList.add (fileinfo);
		 }
	  }
	  for (var fileID=0; fileID < fileCollector.getObjectsCount (); fileID ++)
      {
	     var file = fileCollector.getObjectAt(fileID);
	     var fileAsset = FileCache.getLoadedFileAsset (file);
		 if (fileAsset instanceof Sprite2dFile)
		 {
		    _Sprite2dFileCollector.addObject (file);
			
			var binFilename = file.getCanonicalPath () + ".bin";
			var gamePath = FileUtil.getRelativePathFilename (file.getCanonicalPath (), _ResBaseDir);
			
			writeSprite2dFile (fileAsset, binFilename);

			var fileinfo = new FileInfo (binFilename, gamePath, kFileType_Sprite2d);			
			_PackedFileInfoList.add (fileinfo);
		 }
	  }
	  for (var fileID=0; fileID < fileCollector.getObjectsCount (); fileID ++)
      {
	     var file = fileCollector.getObjectAt(fileID);
	     var fileAsset = FileCache.getLoadedFileAsset (file);
		 if (fileAsset instanceof DefineFile)
		 {
		    _DefineFileCollector.addObject (file);
			
			var binFilename = file.getCanonicalPath () + ".bin";
			var gamePath = FileUtil.getRelativePathFilename (file.getCanonicalPath (), _ResBaseDir);
			
			//writeDefineBinFile (fileAsset, binFilename);

			var fileinfo = new FileInfo (binFilename, gamePath, kFileType_Define);			
			_PackedFileInfoList.add (fileinfo);
		 }
	  }
	  for (var fileID=0; fileID < fileCollector.getObjectsCount (); fileID ++)
      {
	     var file = fileCollector.getObjectAt(fileID);
	     var fileAsset = FileCache.getLoadedFileAsset (file);
		 if (fileAsset instanceof LevelFile)
		 {
		    _LevelFileCollector.addObject (file);
			
			var binFilename = file.getCanonicalPath () + ".bin";
			var gamePath = FileUtil.getRelativePathFilename (file.getCanonicalPath (), _ResBaseDir);
			
			writeLevelBinFile (fileAsset, binFilename);

			var fileinfo = new FileInfo (binFilename, gamePath, kFileType_Level);			
			_PackedFileInfoList.add (fileinfo);
		 }
	  }
     

   }

   
   function packFiles ()
   {
      println ("Packed Files:");
	  
	   var binFilePackager = new BinaryFilePackager ( FileUtil.getFullPathFilename ("res.bin", _ResCompiledDir) );
      
	   binFilePackager.writeInt (_PackedFileInfoList.size ());
	   
      for (var fileID=0; fileID < _PackedFileInfoList.size (); ++ fileID)
      {
         var fileinfo = _PackedFileInfoList.get(fileID);
         
	      var gamepath = fileinfo.gamePath;
	      var fileType = fileinfo.fileType;
	      var fileTypeID = _FileTypeCollector.getObjectIndex (fileType);
         
         binFilePackager.writeUTF (gamepath);         
         binFilePackager.writeShort (fileTypeID);         
      }
	  
      binFilePackager.beginDataBlcoksWithOffsetTable (_PackedFileInfoList.size ());
      
      for (var fileID=0; fileID < _PackedFileInfoList.size (); ++ fileID)
      {
         var fileinfo = _PackedFileInfoList.get(fileID);
	  
	      var resPath = fileinfo.resPath;
         
	      var gamepath = fileinfo.gamePath;
	      var fileType = fileinfo.fileType;
	      var fileTypeID = _FileTypeCollector.getObjectIndex (fileType);  
         
	      println ("- res file: " + resPath);
	      println ("  - game path: " + gamepath);
	      println ("  - file type: " + fileType + " (" + fileTypeID + ")");
         
         binFilePackager.beginDataBlock ();
         if (fileType.equals (kFileType_Sound))
            ; // now sound files are seperated with game res data package for limitation of ActionScript 3.0
         else
            binFilePackager.writeFile (resPath);
         binFilePackager.endDataBlcok ();
      }
      
      binFilePackager.endDataBlcoksWithOffsetTable ();
      
      binFilePackager.close ();
   }
   
   function copySoundFiles ()
   {
  	  for (var fileID=0; fileID < _SoundFilesToBePacked.length; fileID ++)
     {
			var binFilename     = FileUtil.getFullPathFilename (_SoundFilesToBePacked [fileID], _ResBaseDir);
         var compileFilename = FileUtil.getFullPathFilename (_SoundFilesToBePacked [fileID], _ResCompiledDir);
         
         var binFilePackager = new BinaryFilePackager (compileFilename);
         binFilePackager.writeFile (binFilename);
         binFilePackager.close ();
     }
   }

//=================================================================
// main entry point
//=================================================================

   collectActorTypes ();
   collectAppearanceTypes ();
   collectPropertyTypes ();
   collectFileTypes ();


println ("--------------- parse arguments --------------");

   
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
        
        if (paramName.equals ("suit2d_writer_lib_file"))
        {
            var suit2d_package_lib_file = FileUtil.getCanonicalPathFileName (paramValue);
            
            println ("Load js file: " + suit2d_package_lib_file);
		   
            load (suit2d_package_lib_file);
        }
        else if (paramName.equals ("res_base_dir"))
        {
            _ResBaseDir = FileUtil.getCanonicalPathFileName (paramValue);
		   
            println ("_ResBaseDir=" + _ResBaseDir);
        }
        else if (paramName.equals ("res_compiled_dir"))
        {
            _ResCompiledDir = FileUtil.getCanonicalPathFileName (paramValue);
		   
            println ("_ResCompiledDir=" + _ResCompiledDir);
        }
        else if (paramName.equals ("game_mode"))
        {
           _GameMode = paramValue;
           
            println ("_GameMode=" + _GameMode);
        }
      }
   }
   
println ("--------------- parse files --------------");

   var levelFiles;
   
   /*
   if (_GameMode.equals ("puzzle"))
      levelFiles = _LevelFilesToBePacked_puzzle;
   else if (_GameMode.equals ("domino"))
      levelFiles = _LevelFilesToBePacked_domino;
   else //if (_GameMode.equals ("decathlon"))
      levelFiles = _LevelFilesToBePacked_decathlon;
   */
   
   
   levelFiles = _LevelFilesToBePacked
   

   println ("Level Files:");
   for (var fileID=0; fileID < levelFiles.length; fileID ++)
   {
      println ("- parsing: " + levelFiles [fileID]);
	   FileCache.getLevelFile (FileUtil.getFullPathFilename (levelFiles [fileID], _ResBaseDir));
   }


println ("--------------- collect res files --------------");

   collectPackedFiles ();
   
println ("--------------- package files --------------");

   packFiles ();
   
   copySoundFiles ();
   
}


