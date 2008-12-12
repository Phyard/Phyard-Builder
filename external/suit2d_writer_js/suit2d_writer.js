// http://java.sun.com/javase/6/docs/technotes/tools/share/jsdocs/index.html


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



with (packageNames)
{
  
   function writeSprite2dFile (sprite2dFile, filename)
   {
      println ("  - convert sprite file: " + filename);
      
      Sprite2dBinFileWriter.writeSprite2dBinFile (sprite2dFile, filename);
   }

   function writeLevelBinFile (levelFile, filename)
   {
      println ("  - convert level file: " + filename);
      
      var binFilePackager = new BinaryFilePackager (filename);
      
      {
         var defineFilename = levelFile.getDefineFile ().getHostFilename ();
         var relativePath = FileUtil.getRelativePathFilename (defineFilename, levelFile.getHostFilename ());

         var playfieldWidth  = levelFile.getPlayfieldWidth ();
         var playfieldHeight = levelFile.getPlayfieldHeight ();

         var actorSet = levelFile.getActorSet ();

         binFilePackager.writeUTF (relativePath);
         binFilePackager.writeShort (playfieldWidth);
         binFilePackager.writeShort (playfieldHeight);

         binFilePackager.writeShort (actorSet.getChildrenCount());

         for (var actorID = 0; actorID < actorSet.getChildrenCount (); ++ actorID)
         {
            var actor = actorSet.getChildByIndex (actorID);
            writeActor (actor, binFilePackager);
         }

		binFilePackager.writeByte (0);
      }
     
      binFilePackager.close ();
   }
   
   function writeActor (actor, binFilePackager)
   {
		var actorTemplate = actor.getActorTemplate ();
      
      binFilePackager.writeByte (1); //  means: actor data followed
      
      if (actorTemplate.isReserved ())
      {
         binFilePackager.writeByte (1);
      }
      else
      {
         binFilePackager.writeByte (0);         
         binFilePackager.writeShort (actorTemplate.getIndex ());
         
         binFilePackager.writeShort (actor.getPosX ());
         binFilePackager.writeShort (actor.getPosY ());
         binFilePackager.writeShort (actor.getZOrder ());
         binFilePackager.writeFloat (actor.getAngle ());
         binFilePackager.writeFloat (actor.getScaleX ());
         binFilePackager.writeFloat (actor.getScaleY ());
         //binFilePackager.writeBoolean (actor.isFlipX ());
         //binFilePackager.writeBoolean (actor.isFlipY ());
         
         var constomPropertyList = actor.getCostomPropertyList ();
		   writePropertyList (constomPropertyList, binFilePackager);
         
         var appearanceDefines = actorTemplate.getAppearanceDefines ();
         
         // assert appearanceDefines.size () == actor.getAppearancesCount ()         
         binFilePackager.writeByte (actor.getAppearancesCount ());
         
		   for (var appearanceID = 0; appearanceID < actor.getAppearancesCount (); ++ appearanceID)
		   {
		      var appearance = actor.getAppearance (appearanceID);
            var appearanceDefine = appearanceDefines.get (appearanceID);
		      writeAppearance (appearance, appearanceDefine, binFilePackager);
		   }
      }
   }
   
   function writeAppearance (appearance, appearanceDefine, binFilePackager)
   {
		var appearanceName = appearanceDefine.getName (); // == appearance.getName ();
		var appearanceType = appearanceDefine.getType ();
      
		if (appearanceType.equals (AppearanceFactory.AppearanceType_Sprite2d))
		{
         // appearance instanceof Sprite2dAppearance
         var animatedModule = appearance.getAniamation ();
         if (animatedModule == null)
            binFilePackager.writeShort (-1);
         else
            binFilePackager.writeShort (animatedModule.getIndex ());
		}
		else if (appearanceType.equals (AppearanceFactory.AppearanceType_Background2d))
		{
         // appearance instanceof Background2dAppearance
		   var tiled2dBackground = appearance.getBackground ();
         if (tiled2dBackground == null)
            binFilePackager.writeShort (-1);
         else
            binFilePackager.writeShort (tiled2dBackground.getIndex ());
		}
		else if (appearanceType.equals (AppearanceFactory.AppearanceType_Box2d))
		{
         // appearance instanceof Box2dAppearance
		   binFilePackager.writeShort (appearance.getLeft ());
		   binFilePackager.writeShort (appearance.getTop ());
		   binFilePackager.writeShort (appearance.getRight ());
		   binFilePackager.writeShort (appearance.getBottom ());
		}   
   }
   
   
   function writeDefineBinFile (defineFile, filename)
   {
      println ("  - " + filename);
      
      var binFilePackager = new BinaryFilePackager (filename);
	  
      var actorTemplateSet = defineFile.getActorTemplateSet ();
	  
	  binFilePackager.writeShort (actorTemplateSet.getChildrenCount());
	  
	  for (var templateID = 0; templateID < actorTemplateSet.getChildrenCount (); ++ templateID)
	  {
	     var actorTemplate = actorTemplateSet.getChildByIndex (templateID);
		 var propertySet = actorTemplate.getPublicProperties(); 
		 
		 var templateName = actorTemplate.getName ();
		 var instanceActorType = actorTemplate.getActorType ();
		 var instanceActorTypeID = _ActorTypeCollector.getObjectIndex (instanceActorType);
		 var instanceActorDefaultZOrder = actorTemplate.getDefaultZOrder ();
		 
		 binFilePackager.writeUTF (templateName);
		 binFilePackager.writeShort (instanceActorTypeID);
		 binFilePackager.writeShort (instanceActorDefaultZOrder);
		 
		 var templatePropertyDefines = actorTemplate.getTemplatePropertyDefines ();
		 writePropertyDefineBlockList (templatePropertyDefines, binFilePackager);
		 
		 var costomPropertyList = actorTemplate.getCostomPropertyList ();
		 writePropertyList (costomPropertyList, binFilePackager);
		 
		 var instancePropertyDefines = actorTemplate.getInstancePropertyDefines ();
		 writePropertyDefineBlockList (instancePropertyDefines, binFilePackager);
		 
		 var appearanceDefines = actorTemplate.getAppearanceDefines ();
		 
		 binFilePackager.writeByte (appearanceDefines.size ());
		 
		 for (var appearanceDefineID = 0; appearanceDefineID < appearanceDefines.size (); ++ appearanceDefineID)
		 {
		    var appearanceDefine = appearanceDefines.get (appearanceDefineID);
			
			 writeAppearanceDefine (appearanceDefine, defineFile, binFilePackager);
		 }
	  }
	  
	  binFilePackager.close ();
   }
   
   
   function writePropertyDefineBlockList (propertyDefineBlockList, binFilePackager)
   {
      binFilePackager.writeShort ( getPropertyDefinesCountInBlockList (propertyDefineBlockList) );
      
      binFilePackager.writeShort (propertyDefineBlockList.size ());
	   
	   for (var propertyDefineBlockID = 0; propertyDefineBlockID < propertyDefineBlockList.size (); ++ propertyDefineBlockID)
	   {
	      var propertyDefineBlock = propertyDefineBlockList.get (propertyDefineBlockID);
			
	      var propertyDefineBlockName = propertyDefineBlock.getName ();
			
	      binFilePackager.writeUTF (propertyDefineBlockName);
			
	      var propertyDefines = propertyDefineBlock.getPropertyDefines ();
		
		  binFilePackager.writeShort (propertyDefines.size ());
		  
	      for (var propertyDefineID = 0; propertyDefineID < propertyDefines.size (); ++ propertyDefineID)
	      {
		     var propertyDefine = propertyDefines.get (propertyDefineID);
			   
			 var propertyName = propertyDefine.getName ();
			 var propertyType = propertyDefine.getValueType ();
			 var propertyTypeID = _PropertyTypeCollector.getObjectIndex (propertyType);
			 
			 binFilePackager.writeUTF (propertyName);
			 binFilePackager.writeShort (propertyTypeID);
	      }
	   }
   }
   
   function getPropertyDefinesCountInBlockList (propertyDefineBlockList)
   {
      var count = 0;
	   for (var propertyDefineBlockID = 0; propertyDefineBlockID < propertyDefineBlockList.size (); ++ propertyDefineBlockID)
	   {
	      var propertyDefineBlock = propertyDefineBlockList.get (propertyDefineBlockID);
	      var propertyDefines = propertyDefineBlock.getPropertyDefines ();
		
			count += propertyDefines.size ();
	   }
	   
	   return count;
   }
   
   function writeAppearanceDefine (appearanceDefine, defineFile, binFilePackager)
   {
		var appearanceName = appearanceDefine.getName ();
		var appearanceType = appearanceDefine.getType ();
      var appearanceTypeID = _AppearanceTypeCollector.getObjectIndex (appearanceType);
		
		var paramList = appearanceDefine.getParameters ();
		var paramTable = paramList2ParamTable (paramList);
      
      binFilePackager.writeShort (appearanceTypeID);
		
		if (appearanceType.equals (AppearanceFactory.AppearanceType_Sprite2d))
		{
		   var sprite2dFilePath = paramTable.get ("sprite2d_file");
		   var modelName = paramTable.get ("model_name");
		   var animationName = paramTable.get ("animation_name");
         
         var fullFilePath = FileUtil.getFullPathFilename(sprite2dFilePath, defineFile.getHostFilename());
         var sprite2dFile = FileCache.getSprite2dFile (fullFilePath);
         var animatedModuleGroup = sprite2dFile.parseNodePath(modelName);
         var animatedModule = animatedModuleGroup.getChild (animationName);
         
         var relativeFilePath = FileUtil.getRelativePathFilename (fullFilePath, defineFile.getHostFilename());
         
         binFilePackager.writeUTF (relativeFilePath);
         binFilePackager.writeShort (animatedModuleGroup.getIndex ());
         binFilePackager.writeShort (animatedModule.getIndex ());
		}
		else if (appearanceType.equals (AppearanceFactory.AppearanceType_Background2d))
		{
		   var sprite2dFilePath = paramTable.get ("sprite2d_file");
		   var backgroundName = paramTable.get ("background_name");
         
         var fullFilePath = FileUtil.getFullPathFilename(sprite2dFilePath, defineFile.getHostFilename());
         var sprite2dFile = FileCache.getSprite2dFile (fullFilePath);
         var tiled2dBackground = sprite2dFile.getTiledBackgroundSet().getChild (backgroundName);
         
         var relativeFilePath = FileUtil.getRelativePathFilename (fullFilePath, defineFile.getHostFilename());
        
         binFilePackager.writeUTF (relativeFilePath);
         binFilePackager.writeShort (tiled2dBackground.getIndex ());
		}
		else if (appearanceType.equals (AppearanceFactory.AppearanceType_Box2d))
		{
		   var color = paramTable.get ("border_color");
         var colorValue = MiscUtil.parseInt(color, 0);
         
         binFilePackager.writeInt (colorValue);
		}
   }
   
   function paramList2ParamTable (paramList)
   {
      var paramTable = new Hashtable ();
      for (var paramID=0; paramID < paramList.size (); ++ paramID)
	   {
	     var param = paramList.get (paramID);
		  paramTable.put (param.getName (), param.getStringValue ()); 
	   }
     
      return paramTable;
   }
   
   function writePropertyList (propertyList, binFilePackager)
   {
      binFilePackager.writeShort (propertyList.size ());
      for (var propertyID=0; propertyID < propertyList.size (); ++ propertyID)
	  {
	     var property = propertyList.get (propertyID);
	     writeProperty (property, binFilePackager);
	  }
   }
   
   function writeProperty (property, binFilePackager)
   {
      var propertyType = property.getValueType ();
	  var valueComponent = property.getValueComponent ();
	  var propertyValue = property.getValue ();
	  
	  if (propertyType.equals (PropertyFactory.ValueType_Number))
	  {
	     binFilePackager.writeInt (propertyValue.intValue ());
	  }
	  else if (propertyType.equals (PropertyFactory.ValueType_String))
	  {
	     binFilePackager.writeUTF (propertyValue);
	  }
	  else if (propertyType.equals (PropertyFactory.ValueType_Items))
	  {
	     //if (valueComponent.isMultipalSelectionsAllowed ())
		 //{
		 //}
		 //else
		    binFilePackager.writeShort (valueComponent.getSelectedIndex ());
	  }
	  else if (propertyType.equals (PropertyFactory.ValueType_EntityRef))
	  {
	     if (propertyValue == null)
		    binFilePackager.writeShort (-1);
	     else
		    binFilePackager.writeShort (propertyValue.getIndex ());
	  }
	  else if (propertyType.equals (PropertyFactory.ValueType_Boolean))
	  {
	     binFilePackager.writeByte (propertyValue.booleanValue () ? 1 : 0);
	  }
   }
   
   function writeDefineCodeFile (defineFile, filename)
   {
      println ("  - " + filename);
      
      var codeFileWriter = new CodeFileWriter_ActionScript (filename);
      
      {
         var packageName = "game.res";
         var className = FileUtil.getFilenameWithoutExt (filename);
         codeFileWriter.writePackageHead (packageName);
         {
            codeFileWriter.writeClassHead (className);
            {
               writeCollectorObjectIDs (_ActorTypeCollector,      "ActorType_",       codeFileWriter);
               writeCollectorObjectIDs (_AppearanceTypeCollector, "AppearanceType_",  codeFileWriter);
               writeCollectorObjectIDs (_PropertyTypeCollector,   "PropertyType_",    codeFileWriter);
               writeCollectorObjectIDs (_FileTypeCollector,       "FileType_",        codeFileWriter);
            }
            codeFileWriter.writeClassTail (className);
         }
         codeFileWriter.writePackageTail (packageName);
      }
      
      codeFileWriter.close ();
      
      // 
		var codeFilePath = FileUtil.getFullPathFilename ("kTemplate.as", _ResCompiledDir);
      writeTemplateCodeFile (defineFile, codeFilePath);
   }
   
   function writeTemplateCodeFile (defineFile, filename)
   {
      println ("  - " + filename);
      
      var codeFileWriter = new CodeFileWriter_ActionScript (filename);
      
      {
         var packageName = "game.res";
         var className = FileUtil.getFilenameWithoutExt (filename);
         codeFileWriter.writePackageHead (packageName);
         {
            codeFileWriter.writeClassHead (className);
            
            var actorTemplateSet = defineFile.getActorTemplateSet ();
            {
               var _TemplateCollector        = new ObjectCollector ();
               for (var templateID = 0; templateID < actorTemplateSet.getChildrenCount (); ++ templateID)
            	{
                  var actorTemplate = actorTemplateSet.getChildByIndex (templateID);
                  _TemplateCollector.addObject (actorTemplate.getName ());
               }

               writeCollectorObjectIDs (_TemplateCollector,      "TemplateID_",       codeFileWriter);
            }
            
            for (var templateID = 0; templateID < actorTemplateSet.getChildrenCount (); ++ templateID)
            {
               var actorTemplate = actorTemplateSet.getChildByIndex (templateID);
               var templateName = actorTemplate.getName ();
               
               codeFileWriter.writeTextLine ("// --------------- " + templateName);
               codeFileWriter.writeNewLines (1);
               templateName = templateName.replace (" ", "_");
               codeFileWriter.incIndents ();
               {
                  var _TemplatePropertyDefineCollector        = new ObjectCollector ();
                  var templatePropertyDefines = actorTemplate.getTemplatePropertyDefines ();               
            	   for (var propertyDefineBlockID = 0; propertyDefineBlockID < templatePropertyDefines.size (); ++ propertyDefineBlockID)
            	   {
            	      var propertyDefineBlock = templatePropertyDefines.get (propertyDefineBlockID);         			
            	      var propertyDefineBlockName = propertyDefineBlock.getName ();         			
            	      var propertyDefines = propertyDefineBlock.getPropertyDefines ();
            	      for (var propertyDefineID = 0; propertyDefineID < propertyDefines.size (); ++ propertyDefineID)
            	      {
                        var propertyDefine = propertyDefines.get (propertyDefineID);
                        var propertyName = propertyDefine.getName ();
                        propertyName = propertyName.replace (" ", "_");
                        
                        _TemplatePropertyDefineCollector.addObject (propertyName);
            	      }
                  }
                  
                  writeCollectorObjectIDs (_TemplatePropertyDefineCollector,      "TCP_" + actorTemplate.getName () + "_",       codeFileWriter);
                  
                  //
                  var _InstancePropertyDefineCollector        = new ObjectCollector ();
                  var instancePropertyDefines = actorTemplate.getInstancePropertyDefines ();
            	   for (var propertyDefineBlockID = 0; propertyDefineBlockID < instancePropertyDefines.size (); ++ propertyDefineBlockID)
            	   {
            	      var propertyDefineBlock = instancePropertyDefines.get (propertyDefineBlockID);         			
            	      var propertyDefineBlockName = propertyDefineBlock.getName ();         			
            	      var propertyDefines = propertyDefineBlock.getPropertyDefines ();
            	      for (var propertyDefineID = 0; propertyDefineID < propertyDefines.size (); ++ propertyDefineID)
            	      {
                        var propertyDefine = propertyDefines.get (propertyDefineID);
                        var propertyName = propertyDefine.getName ();
                        propertyName = propertyName.replace (" ", "_");
                        
                        _InstancePropertyDefineCollector.addObject (propertyName);
            	      }
                  }
                  
                  writeCollectorObjectIDs (_InstancePropertyDefineCollector,      "ICP_" + actorTemplate.getName () + "_",       codeFileWriter);
                  
                  //
                  var _AppearanceDefineCollector        = new ObjectCollector ();
                  var appearanceDefines = actorTemplate.getAppearanceDefines ();
            	   for (var appearanceDefineID = 0; appearanceDefineID < appearanceDefines.size (); ++ appearanceDefineID)
            	   {
            	      var appearanceDefine = appearanceDefines.get (appearanceDefineID);         			
            	      var appearanceDefineName = appearanceDefine.getName ();
                     appearanceDefineName = appearanceDefineName.replace (" ", "_");
                     _AppearanceDefineCollector.addObject (appearanceDefineName);
                  }
                  
                  writeCollectorObjectIDs (_AppearanceDefineCollector,      "Appearance_" + actorTemplate.getName () + "_",       codeFileWriter);
               }
               codeFileWriter.decIndents ();
            }
            codeFileWriter.writeClassTail (className);
         }
         codeFileWriter.writePackageTail (packageName);
      }
      
      codeFileWriter.close ();
   }
   
   function writeCollectorObjectIDs (collector, prefix, codeFileWriter)
   {
      codeFileWriter.writeTextLine ("// " + prefix);
      for (var objectID = 0; objectID < collector.getObjectsCount (); ++ objectID)
      {
         codeFileWriter.writeConstIntegerVariable (prefix + collector.getObjectAt (objectID), objectID);
      }      
      codeFileWriter.writeNewLines (2);
   }
   

   
}


