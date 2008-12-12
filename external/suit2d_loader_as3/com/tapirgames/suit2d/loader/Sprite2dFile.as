package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   import com.tapirgames.util.UrlUtil;
   import com.tapirgames.util.ResourceManager;
   
   import flash.display.BitmapData;
   
   public class Sprite2dFile 
   {
      public var mFilePath:String;
      public var mModuleImages:Array;
      public var mPureModuleGroups:Array;
      public var mCompositedModuleGroups:Array;
      public var mAnimatedModuleGroups:Array;
      public var mTilePalettes:Array;
      public var mTiled2dBackgrounds:Array;
      
      public function Sprite2dFile (filePath:String)
      {
         mFilePath = filePath;
      }
      
      public function GetAnimatedModuleGroup (animModelIndex:uint):Array
      {
         return mAnimatedModuleGroups [animModelIndex];
      }
      
      public function GetTiled2dBackground (backgroundIndex:uint):Tiled2dBackground
      {
         return mTiled2dBackgrounds [backgroundIndex];
      }
      
      public function Load (dataSrc:ByteArray):void
      {
         
         // module images
         mModuleImages = LoadModuleImages (dataSrc, mFilePath);
         
         // pure module groups
         mPureModuleGroups = LoadPureModuleGroups (dataSrc);
         
         // composited module groups
         mCompositedModuleGroups = LoadModuleGroups (dataSrc, false);
         
         // animated module groups
         mAnimatedModuleGroups = LoadModuleGroups (dataSrc, true);
         
         // tile palettes
         mTilePalettes = LoadGridModuleGroups (dataSrc, true);
         
         // tiled2d backgrounds      
         var tiled2dBackgroundsCount:int = dataSrc.readShort ();
         
         trace ("tile2d background count: " + tiled2dBackgroundsCount);
         
         mTiled2dBackgrounds = new Array (tiled2dBackgroundsCount);
         
         for (var tiled2dBackgroundID:int = 0; tiled2dBackgroundID < tiled2dBackgroundsCount; ++ tiled2dBackgroundID)
         {
            var cellRows:int = dataSrc.readShort ();
            var cellCols:int = dataSrc.readShort ();
            var cellWidth:int = dataSrc.readShort ();
            var cellHeight:int = dataSrc.readShort ();
            
            var tiled2dLayers:Array = LoadGridModuleGroups (dataSrc, false);
            var tiled2dBackground:Tiled2dBackground = new Tiled2dBackground (cellRows, cellCols, cellWidth, cellHeight, tiled2dLayers);
            
            mTiled2dBackgrounds [tiled2dBackgroundID] = tiled2dBackground;
         }
         
         // eval module refs
         EvalModuleRefs (mCompositedModuleGroups);
         EvalModuleRefs (mAnimatedModuleGroups);
         EvalModuleRefs (mTilePalettes);
      }
      
      public function EvalModuleRefs (moduleGroups:Array):void
      {
         //trace ("EvalModuleRefs --");
         
         var _tempInfo:Array = moduleGroups._tempInfo;
         moduleGroups._tempInfo = null;
         if (_tempInfo == null)
            return;
         
         for (var groupID:int = 0; groupID < moduleGroups.length; ++ groupID)
         {
            var modules:Array = moduleGroups [groupID];
            
            var _groupTempInfo:Array = _tempInfo [groupID];
            
            for (var moduleID:int = 0; moduleID < modules.length; ++ moduleID)
            {
               var object:Object = modules [moduleID];
               
               var _moduleTempInfo:Object = _groupTempInfo [moduleID];
               
               if (object is Tiled2dModule)
               {
                  var tm:Tiled2dModule = object as Tiled2dModule
                  EvalModuleRef (tm.mModuleRef, _moduleTempInfo.groupID, _moduleTempInfo.moduleIndex);
               }
               else if (object is CompositedModule)
               {
                  var cm:CompositedModule = object as CompositedModule;
                  
                  for (var partID:int = 0; partID < cm.mModuleParts.length; ++ partID)
                  {
                     var _partTempInfo:Object = (_moduleTempInfo as Array) [partID];
                     
                     EvalModuleRef (cm.mModuleParts[partID], _partTempInfo.groupID, _partTempInfo.moduleIndex);
                  }
               }
               else if (object is AnimatedModule)
               {
                  var am:AnimatedModule = object as AnimatedModule;

                  for (var seqID:int = 0; seqID < am.mModuleSequences.length; ++ seqID)
                  {
                     var _seqTempInfo:Object = (_moduleTempInfo as Array) [seqID];

                     EvalModuleRef (am.mModuleSequences[seqID], _seqTempInfo.groupID, _seqTempInfo.moduleIndex);
                  }
               }
            }
         }
      }

   
      public function EvalModuleRef (moduleRef:ModuleRef, groupID:int, moduleIndex:int):void
      {
         if (moduleRef == null)
            return;
            
         var groupSetID:int = groupID >> 12;
         var realGroupID:int = groupID & 0xFFF;
         
         var moduleGroup:Array;
         
         switch (groupSetID)
         {
            case 0:
               moduleGroup = mPureModuleGroups [realGroupID];
               break;
            case 1:
               moduleGroup = mCompositedModuleGroups [realGroupID];
               break;
            case 2:
               moduleGroup = mAnimatedModuleGroups [realGroupID];
               break;
            case 3:
               moduleGroup = mTilePalettes [realGroupID];
               break;
            defalut:
               return null;
         }
         
         //trace ("realGroupID = " + realGroupID + ", moduleIndex = " + moduleIndex + ", moduleGroup [moduleIndex] = " + moduleGroup [moduleIndex]);
         moduleRef.mModule = moduleGroup [moduleIndex];
      }
      
      public function LoadModuleImages (dataSrc:ByteArray, spriteFilePath:String):Array
      {
         // module images
         var moduleImagesCount:int = dataSrc.readShort ();
         
         var moduleImages:Array = new Array (moduleImagesCount);
         
         trace ("module image count: " + moduleImagesCount);
         
         for (var imageID:int = 0; imageID < moduleImagesCount; ++ imageID)
         {
            var imageFilePath:String = dataSrc.readUTF ();
            
            imageFilePath = UrlUtil.GetFullFilePath (imageFilePath, spriteFilePath);
            
            trace ("  image " + imageID + ": " + imageFilePath);
            
            moduleImages [imageID] = new ModuleImage (ResourceManager.GetResource (imageFilePath) as BitmapData);
         }
         
         return moduleImages;
      }
      
      public function LoadPureModuleGroups (dataSrc:ByteArray):Array
      {
         var pureModuleGroupsCount:int = dataSrc.readShort ();
         
         var pureModuleGroups:Array = new Array (pureModuleGroupsCount);
         
         //trace ("pure module group count: " + pureModuleGroupsCount);
         
         for (var pureModuleGroupID:int = 0; pureModuleGroupID < pureModuleGroupsCount; ++ pureModuleGroupID)
         {
            var moduleImageID:int = dataSrc.readShort ();
            var modulesCount:int = dataSrc.readShort ();
            
            //trace ("  " + pureModuleGroupID + ") image id: " + moduleImageID + ", modules count: " + modulesCount);
            
            var pureModules:Array = new Array (modulesCount);
            
            for (var moduleID:int = 0; moduleID < modulesCount; ++ moduleID)
            {
               var moduleX:int = dataSrc.readShort ();
               var moduleY:int = dataSrc.readShort ();
               var moduleW:int = dataSrc.readShort ();
               var moduleH:int = dataSrc.readShort ();
               
               //trace ("    " + moduleID + ": " + moduleX + ", " + moduleY + ", " + moduleW + ", " + moduleH);
               
               var pureModule:PureModule = new PureModule (moduleX, moduleY, moduleW, moduleH);
               pureModule.SetModuleImage (moduleImageID < 0 ? null : mModuleImages [moduleImageID]);
               
               pureModules [moduleID] = pureModule;
            }
            
            pureModuleGroups [pureModuleGroupID] = pureModules;
         }
         
         return pureModuleGroups;
      }
      
      public function LoadModuleGroups (dataSrc:ByteArray, isAnimatedModule:Boolean):Array
      {
         var dataPointer:int = dataSrc.position;
         
         var moduleGroupsCount:int = dataSrc.readShort ();
         
         //trace ( (isAnimatedModule ? "animated" : "composited") + " module group count: " + moduleGroupsCount);
         
         var moduleGroups:Array = new Array (moduleGroupsCount);
         
         var _tempInfo:Array = new Array (moduleGroupsCount);
         
         moduleGroups._tempInfo = _tempInfo;
         
         for (var moduleGroupID:int = 0; moduleGroupID < moduleGroupsCount; ++ moduleGroupID)
         {
            var modulesCount:int = dataSrc.readShort ();
            
            var modules:Array = new Array (modulesCount);
            
            _tempInfo [moduleGroupID] = new Array (modulesCount);
            
            trace ("  " + moduleGroupID + ") module count: " + modulesCount );
            
            for (var moduleID:int = 0; moduleID < modulesCount; ++ moduleID)
            {
               var modulePartsCount:int = dataSrc.readShort ();
               
               var moduleParts:Array = new Array (modulePartsCount);
               
               _tempInfo [moduleGroupID][moduleID] = new Array (modulePartsCount);
               
               var moduleRefGroupIDs:Array = new Array (modulePartsCount);
               var moduleRefModuleIDs:Array = new Array (modulePartsCount);
               
               //trace ("  module part count: " + modulePartsCount);
               
               for (var modulePartID:int = 0; modulePartID < modulePartsCount; ++ modulePartID)
               {
                  var groupID:int = dataSrc.readShort ();
                  
                  var moduleIndex:int = -1;
                  
                  //trace ("     " + modulePartID + ") group id: " + groupID );
                  
                  var modulePart:ModulePart = null;
                  
                  if (groupID < 0)
                     ;
                  else
                  {
                     moduleIndex = dataSrc.readShort ();
                     var flagAndPaletteID:int = dataSrc.readShort ();
                     var offsetX:int = dataSrc.readShort ();
                     var offsetY:int = dataSrc.readShort ();
                     
                     if (isAnimatedModule)
                     {
                        var duration:int = dataSrc.readShort ();
                        modulePart = new ModuleSequence (null, flagAndPaletteID, offsetX, offsetY, duration);
                     }
                     else
                     {
                        modulePart = new ModulePart (null, flagAndPaletteID, offsetX, offsetY);
                     }
                     
                     //trace ("        module id: " + moduleIndex + ", offsetX: " + offsetX + ", offsetY: " + offsetY + ", flagAndPalette: " + flagAndPaletteID);
                     
                     moduleRefModuleIDs [modulePartID] = moduleIndex;
                  }
                  
                  moduleParts [modulePartID] = modulePart;
                  
                  _tempInfo [moduleGroupID][moduleID][modulePartID] = {groupID:groupID, moduleIndex:moduleIndex};
               }
               
               if (isAnimatedModule)
                  modules [moduleID] = new AnimatedModule (moduleParts);
               else
                  modules [moduleID] = new CompositedModule (moduleParts);
               
               modules.groupIDs  = moduleRefGroupIDs;
               modules.moduleIDs = moduleRefModuleIDs;
            }
            
            moduleGroups [moduleGroupID] = modules;
         }
         
         return moduleGroups;
      }
      
      public function LoadGridModuleGroups (dataSrc:ByteArray, isPalette:Boolean):Array
      {
         var gridGroupsCount:int = dataSrc.readShort ();
         
         var gridModuleGroups:Array = new Array (gridGroupsCount);
         
         var _tempInfo:Array = new Array (gridGroupsCount);
         
         if (isPalette)
            gridModuleGroups._tempInfo = _tempInfo;         
         
         trace ("grid group count: " + gridGroupsCount);
         
         for (var gridGroupID:int = 0; gridGroupID < gridGroupsCount; ++ gridGroupID)
         {
            var cellRows:int = dataSrc.readShort ();
            var cellCols:int = dataSrc.readShort ();
            var cellWidth:int = dataSrc.readShort ();
            var cellHeight:int = dataSrc.readShort ();
            
            var cellsCount:int = cellRows * cellCols;
            
            //trace ("     grid params: " + cellRows + ", " + cellCols + ", " + cellWidth + ", " + cellHeight);
            
            var modules:Array = new Array (cellsCount);
            
            if (isPalette)
               _tempInfo [gridGroupID] = new Array (cellsCount);
            
            for (var cellID:int=0; cellID < cellsCount; ++ cellID)
            {
               var moduleRef:ModuleRef = null;
               
               var groupID:int = dataSrc.readShort ();
               var moduleIndex:int = -1;
               
               //trace ("     " + cellID + ") group id: " + groupID);
               
               if (groupID < 0)
                  ;
               else
               {
                  moduleIndex = dataSrc.readShort ();
                  var flagAndPaletteID:int = dataSrc.readShort ();
                  
                  //trace ("        module id: " + moduleIndex + ", flagAndPalette: " + flagAndPaletteID);
                  
                  moduleRef = new ModuleRef (null, flagAndPaletteID);
               }
               
               if (isPalette)
               {
                  modules [cellID] = new Tiled2dModule (moduleRef, cellID);
                  _tempInfo [gridGroupID][cellID] = {groupID:groupID, moduleIndex:moduleIndex};
               }
               else
               {
                  modules [cellID] = moduleRef; //new Tiled2dModule (moduleRef);
                  EvalModuleRef (moduleRef, groupID, moduleIndex);
               }
            }
            
            gridModuleGroups [gridGroupID] = modules;
         }
         
         return gridModuleGroups;
      }
   }
}