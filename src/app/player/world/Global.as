package player.world
{
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.system.Capabilities;
   
   import player.world.World;
   import player.world.EntityList;
   
   import player.trigger.TriggerEngine;
   import player.trigger.VariableSpace;
   import player.trigger.ClassInstance;
   import player.trigger.VariableInstance;
   import player.trigger.VariableDeclaration;
   import player.trigger.CoreClasses;
   import player.trigger.ClassDefinition;
   import player.trigger.ClassDefinition_Core;
   import player.trigger.ClassDefinition_Custom;
   import player.trigger.FunctionDefinition_Custom;
   
   import player.trigger.CoreFunctionDefinitions;

   import player.entity.Entity;
   
   import player.module.*;
   import player.image.*;
   
   import player.sound.Sound;
   
   //import com.tapirgames.util.RandomNumberGenerator;
   //import com.tapirgames.util.MersenneTwisterRNG;
   
   import common.trigger.ValueSpaceTypeDefine;

   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.ClassDeclaration;
   import common.trigger.CoreClassDeclarations;
   import common.trigger.define.ClassDefine;
   import common.trigger.define.FunctionDefine;
   
   import common.TriggerFormatHelper2;
   
   import common.shape.*;
   
   import common.DataFormat2;

   import common.CoordinateSystem;
   
   import common.SceneDefine;
   
   import common.Transform2D;
   import common.Define;
   
   // todo: merge this class with World
   
   // not all data in this class are global. some are world related.
   public class Global
   {
      public static var sTheGlobal:Global = null;
      
      //public static var mCurrentWorld:World = null;
      
      public /*static*/ var mWorldDefine:Object = null;
                  // currently for MergeScene purpose
      
      //public static var mRandomNumberGenerators:Array;
      
      private static var mNumTotalModules:int = 0;
      public /*static*/ var mImageBitmaps:Array; //
      public /*static*/ var mImageBitmapDivisions:Array; //
      public /*static*/ var mAssembledModules:Array;
      public /*static*/ var mSequencedModules:Array;

      public /*static*/ var mSounds:Array; //
      
   // callbacks from viewer
      
      //>>>>>>> now put in player.World
      //public static var UI_RestartPlay:Function;
      //public static var UI_IsPlaying:Function;
      //public static var UI_SetPlaying:Function;
      //public static var UI_GetSpeedX:Function;
      //public static var UI_SetSpeedX:Function;
      //public static var UI_GetZoomScale:Function;
      //public static var UI_SetZoomScale:Function;
      //public static var UI_IsSoundEnabled:Function;
      //public static var UI_SetSoundEnabled:Function;
      //public static var UI_GetSoundVolume:Function; // v2.03 (not really used now)
      //public static var UI_SetSoundVolume:Function; // v2.03 (not really used now)
      //<<<<<<<<<<
      
      public /*static*/ var Viewer_mLibCapabilities:Object;
               //IsAccelerometerSupported:Function; // v1.60
               //GetAcceleration:Function; // v1.60
               //GetScreenResolution:Function; // from v2.03
               //GetScreenDPI:Function; // from v2.03
               //OpenURL:Function; // from v2.03
      public /*static*/ var _GetDebugString:Function;
      public /*static*/ var Viewer_SetMouseGestureSupported:Function;
      public /*static*/ var Viewer_OnLoadScene:Function; // v2.00-v2.03
      public /*static*/ var Viewer_mLibSound:Object;
               //PlaySound:Function; // v2.02. (before v2.02, sound lib is included in world instead of viewer)
               //StopAllInLevelSounds:Function; // v2.02
               //StopCrossLevelsSound:Function; // v2.02
      public /*static*/ var Viewer_mLibGraphics:Object; // v2.03
               //LoadImageFromBytes:Function; // v2.03
      public /*static*/ var Viewer_mLibAppp:Object; // v2.03
               //IsNativeApp:Function; // v2.03
               //OnExitApp:Function; // v2.03
      public /*static*/ var Viewer_mLibCookie:Object; // v2.03
               //WriteGameSaveData:Function; // v2.03
               //LoadGameSaveData:Function; // v2.03
               //ClearGameSaveData:Function; // v2.03
      public /*static*/ var Viewer_mLibServices:Object; // v2.03
               //SubmitKeyValue:Function; // v2.0?
               //SendGlobalSocketMessage  // v2.06
            
//==============================================================================
// for playing in editor. 
//==============================================================================
   
      // todo: in non-editing situations, for one-level game package, maybe only turning off sounds is ok enough. 
      // the params:Object parameter is reserved for this intention. 
      
      public static function OnViewerDestroyed (params:Object = null):void
      {
         if (sTheGlobal != null)
         {
            sTheGlobal.Destroy (params);
            
            sTheGlobal = null;
         }
      }
      
      public /*static*/ function Destroy (params:Object = null):void
      {
         CoreFunctionDefinitions.Initialize (/*null*/true);
         
         /*
         mSceneLookupTableByKey = null;
         //mCurrentWorld = null;
         mWorldDefine = null;
         */
         
         // moved into world since v2.06
         //mRegisterVariableSpace_Boolean = null;
         //mRegisterVariableSpace_String = null;
         //mRegisterVariableSpace_Number = null;
         //mRegisterVariableSpace_Entity = null;
         //mRegisterVariableSpace_CollisionCategory = null;
         
         //mRegisterVariableSpace_Array = null;
         //
         //mSessionVariableSpace = null;
         //mGlobalVariableSpace = null;
         //mCommonGlobalVariableSpace = null;
         //mEntityVariableSpace = null;
         //mCommonEntityVariableSpace = null;
         //
         //mCustomClassDefinitions = null;
         //
         //mCustomFunctionDefinitions = null;
         
         //mRandomNumberGenerators = null; // should be moved into viewer
         
         /*
         mImageBitmaps = null;
         mImageBitmapDivisions = null;
         mAssembledModules = null;
         mSequencedModules = null;
         
         mSounds = null;
         */
         
      // callbacks from viewer
         
         //UI_RestartPlay = null;
         //UI_IsPlaying = null;
         //UI_SetPlaying = null;
         //UI_GetSpeedX = null;
         //UI_SetSpeedX = null;
         //UI_GetZoomScale = null;
         //UI_SetZoomScale = null;
         //UI_IsSoundEnabled = null;
         //UI_SetSoundEnabled = null;
     
         /*    
         Viewer_mLibCapabilities = null;
         _GetDebugString = null;
         Viewer_SetMouseGestureSupported = null;
         Viewer_OnLoadScene = null;
         Viewer_mLibSound = null;
         Viewer_mLibGraphics = null;
         Viewer_mLibAppp = null;
         Viewer_mLibCookie = null;
         Viewer_mLibServices = null;
         */
      }

//==============================================================================
// 
//==============================================================================
      
      public /*static*/ function Initialize/*InitGlobalData*/ (worldDefine:Object, isRestartLevel:Boolean, dontReloadGlobalAssets:Boolean):void
      {
         //
         mWorldDefine = worldDefine;
         
         //
         CoreClasses.InitCoreClassDefinitions ();
         
         //
         TriggerEngine.InitializeConstData ();
         
         //
         //if (! isRestartLevel) // before v2.00
         if (! dontReloadGlobalAssets) // from v2.00
         {
            mImageBitmaps         = null;
            mImageBitmapDivisions = null;
            mAssembledModules     = null;
            mSequencedModules     = null;
            
            mSounds = null;
         }
         
         // ...
         
         if (! dontReloadGlobalAssets)
         {
            mSceneLookupTableByKey = null;
         }

         //
         //mRandomNumberGenerators = new Array (Define.NumRngSlots);
         
         //
         //UI_RestartPlay = null;
         //UI_IsPlaying = null;
         //UI_SetPlaying = null;
         //UI_GetSpeedX = null;
         //UI_SetSpeedX = null;
         //UI_GetZoomScale = null;
         //UI_SetZoomScale = null;
         //UI_IsSoundEnabled = null;
         //UI_SetSoundEnabled = null;
         
         //
         Viewer_mLibCapabilities = null;
         _GetDebugString = null;
         Viewer_SetMouseGestureSupported = null;
         Viewer_OnLoadScene = null;
         Viewer_mLibSound = null;
         Viewer_mLibGraphics = null;
         Viewer_mLibAppp = null;
         Viewer_mLibCookie = null;
         Viewer_mLibServices = null;
         
         //>>>>>>>>>>>>> moved into world
         // no needs to call this now 
         //Entity.sLastSpecialId = -0x7FFFFFFF - 1; // maybe 0x80000000 is ok 
         //
         //mRegisterVariableSpace_Boolean           = CreateRegisterVariableSpace (false, CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_Boolean));
         //mRegisterVariableSpace_String            = CreateRegisterVariableSpace (null, CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_String));
         //mRegisterVariableSpace_Number            = CreateRegisterVariableSpace (0, CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_Number));
         //mRegisterVariableSpace_Entity            = CreateRegisterVariableSpace (null, CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_Entity));
         //mRegisterVariableSpace_CollisionCategory = CreateRegisterVariableSpace (null, CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_CollisionCategory));
         //mRegisterVariableSpace_Array             = CreateRegisterVariableSpace (null, CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_Array));
         //
         //if (! dontReloadGlobalAssets)
         //{
         //   mWorldVariableSpace = null;
         //   mGameSaveVariableSpace = null;
         //   mGameSaveVariableSpace_WithInitialValues = null;
         //}
         //
         //if (! isRestartLevel)
         //{
         //   mSessionVariableSpace = null;
         //}
         //
         //mGlobalVariableSpace = null;
         //mCommonGlobalVariableSpace = null;
         //mEntityVariableSpace = null;
         //mCommonEntityVariableSpace = null;
         //
         //mCustomClassDefinitions = null;
         //
         //mCustomFunctionDefinitions = null;
         //<<<<<<<<<<<<<<<<<<<<<<<<<<
      }
      
      //public static function SetCurrentWorld (world:World):void
      //{
      //   mCurrentWorld = world;
      //}
      
      //public static function GetCurrentWorld ():World
      //{
      //   return mCurrentWorld;
      //}
   
//==============================================================================
// 
//==============================================================================
   
   private /*static*/ var mDebugString:String = null;
   public /*static*/ function GetDebugString ():String
   {
      return mDebugString;
   }
   
//==============================================================================
// scenes
//==============================================================================
      
      public /*static*/ var mSceneLookupTableByKey:Dictionary = null;
      
      public /*static*/ function GetSceneByKey (key:String):int
      {
         if (mSceneLookupTableByKey == null)
         {
            for (var i:int = 0; i < mWorldDefine.mSceneDefines.length; ++ i)
            {
               mSceneLookupTableByKey [(mWorldDefine.mSceneDefines [i] as SceneDefine).mKey] = i;
            }
         }
         
         var levelIndex:Object = mSceneLookupTableByKey [key];
         return levelIndex == undefined ? -1 : int (levelIndex);
      }
      
      public /*static*/ function GetNumScenes ():int
      {
         return mWorldDefine == null ? 0 : mWorldDefine.mSceneDefines.length;
      }
      
      public /*static*/ function IsInvalidScene (levelIndex:int):Boolean
      {
         return isNaN (levelIndex) || levelIndex < 0 || levelIndex >= Global.sTheGlobal.GetNumScenes ();
      }
      
      public /*static*/ function GetSceneDefine (sceneIndex:int):SceneDefine
      {
         if (mWorldDefine == null)
            return null;
         
         if (IsInvalidScene (sceneIndex))
            return null;
         
         return mWorldDefine.mSceneDefines [sceneIndex] as SceneDefine;
      }
   
//==============================================================================
// static values
//==============================================================================
      
      public /*static*/ function GetClassDefinition (world:World, classType:int, classId:int):ClassDefinition
      {
         if (classType == ClassTypeDefine.ClassType_Custom)
         {
            var aClass:ClassDefinition = world.GetCustomClassDefinition (classId);
            if (aClass != null)
               return aClass;
            
            return CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_Void);
         }
         else // if (classType == ClassTypeDefine.ClassType_Core)
         {
            return CoreClasses.GetCoreClassDefinition (classId);
         }
      }
      
      public /*static*/ function UpdateCoreClassDefaultInitialValues ():void
      {
         for (var classId:int = 0; classId < CoreClassIds.NumCoreClasses; ++ classId)
         {
            var coreDecl:ClassDeclaration = CoreClassDeclarations.GetCoreClassDeclarationById (classId);
            var classDef:ClassDefinition_Core = CoreClasses.GetCoreClassDefinition (classId);
            if (classDef.GetID () == classId)
            {
               classDef.SetDefaultInitialValue (CoreClasses.ValidateInitialDirectValueObject_Define2Object (/*Global.GetCurrentWorld ()*/null, ClassTypeDefine.ClassType_Core, classId, coreDecl.GetDefaultDirectDefineValue ()));
            }
         }
      }
      
      public /*static*/ function CreateOrResetCoreFunctionDefinitions ():void
      {
         //if (mCurrentWorld == null)
         //   throw new Error ();
         
         CoreFunctionDefinitions.Initialize (/*mCurrentWorld*/false);
      }
            
      public /*static*/ function CreateImageModules (imageDefines:Array, pureImageModuleDefines:Array, assembledModuleDefines:Array, sequencedModuleDefines:Array):void
      {
         var needLoadImages:Boolean = false;
         var imageId:int;
         var image:ImageBitmap;
         
         mNumTotalModules = 0;
         
         if (mImageBitmaps == null)
         {
            needLoadImages = true;
            
            mImageBitmaps         = new Array (imageDefines.length);
            
            for (imageId = 0; imageId < imageDefines.length; ++ imageId)
            {
               image = new ImageBitmap ();
               image.SetId (mNumTotalModules ++);
               mImageBitmaps [imageId] = image;
            }
         }
         else
         {
            mNumTotalModules += mImageBitmaps.length;
         }

         if (mImageBitmapDivisions == null)
         {
            mImageBitmapDivisions = new Array (pureImageModuleDefines.length);

            for (var divisionId:int = 0; divisionId < pureImageModuleDefines.length; ++ divisionId)
            {
               var divisionDefine:Object = pureImageModuleDefines [divisionId];
               
               var imageDivision:ImageBitmapDivision = new ImageBitmapDivision (mImageBitmaps [divisionDefine.mImageIndex] as ImageBitmap, 
                                                       divisionDefine.mLeft, divisionDefine.mTop, divisionDefine.mRight, divisionDefine.mBottom);
               imageDivision.SetId (mNumTotalModules ++);
               mImageBitmapDivisions [divisionId] = imageDivision;
            }
         }
         else
         {
            mNumTotalModules += mImageBitmapDivisions.length;
         }
         
         if (needLoadImages)
         {
            for (imageId = 0; imageId < imageDefines.length; ++ imageId)
            {
               var imageDefine:Object = imageDefines [imageId];
               
               image = mImageBitmaps [imageId] as ImageBitmap;
               //imageDefine.mName
               image.SetFileData (imageDefine.mFileData, OnLoadImageDone, OnLoadImageError);
            }
         }
         
         var needLoadAssembledModules:Boolean = false;
         var needLoadSequencedModules:Boolean = false;

         if (mAssembledModules == null)
         {
            needLoadAssembledModules = true;
            
            mAssembledModules     = new Array (assembledModuleDefines.length);
   
            var assembledModuleId:int;
            for (assembledModuleId = 0; assembledModuleId < assembledModuleDefines.length; ++ assembledModuleId)
            {
               mAssembledModules [assembledModuleId] = new AssembledModule ();
               (mAssembledModules [assembledModuleId] as AssembledModule).SetId (mNumTotalModules ++);
            }
         }
         else
         {
            mNumTotalModules += mAssembledModules.length;
         }
         
         if (mSequencedModules == null)
         {
            needLoadSequencedModules = true;
            
            mSequencedModules     = new Array (sequencedModuleDefines.length);
   
            var sequencedModuleId:int;
            for (sequencedModuleId = 0; sequencedModuleId < sequencedModuleDefines.length; ++ sequencedModuleId)
            {
               mSequencedModules [sequencedModuleId] = new SequencedModule ();
               (mSequencedModules [sequencedModuleId] as SequencedModule) .SetId (mNumTotalModules ++);
            }
         }
         else
         {
            mNumTotalModules += mSequencedModules.length;
         }
         
         if (needLoadAssembledModules)
         {
            for (assembledModuleId = 0; assembledModuleId < assembledModuleDefines.length; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = assembledModuleDefines [assembledModuleId];
               
               var moduleParts:Array = CreateModulePartsOrSequences (assembledModuleDefine.mModulePartDefines, false);
               
               (mAssembledModules [assembledModuleId] as AssembledModule).SetModuleParts (moduleParts);
            }
         }

         if (needLoadSequencedModules)
         {
            for (sequencedModuleId = 0; sequencedModuleId < sequencedModuleDefines.length; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = sequencedModuleDefines [sequencedModuleId];
               
               var moduleSequences:Array = CreateModulePartsOrSequences (sequencedModuleDefine.mModuleSequenceDefines, true);
               
               (mSequencedModules [sequencedModuleId] as SequencedModule).SetConstantPhysicsGeom ((sequencedModuleDefine.mSettingFlags & Define.SequencedModule_ConstantPhysicsGeomForAllFrames) == Define.SequencedModule_ConstantPhysicsGeomForAllFrames);
               
               (mSequencedModules [sequencedModuleId] as SequencedModule).SetModuleSequences (moduleSequences);
            }
         }
         
         // ... 
         
         //for (assembledModuleId = 0; assembledModuleId < assembledModuleDefines.length; ++ assembledModuleId)
         //{
         //   (mAssembledModules [assembledModuleId] as AssembledModule).AdjustModulePartsTransformInPhysics (GetCurrentWorld ().GetCoordinateSystem ());
         //}
         
         //for (sequencedModuleId = 0; sequencedModuleId < sequencedModuleDefines.length; ++ sequencedModuleId)
         //{
         //   (mSequencedModules [sequencedModuleId] as SequencedModule).AdjustModuleSequencesTransformInPhysics (GetCurrentWorld ().GetCoordinateSystem ());
         //}
      }
      
      protected /*static*/ function CreateModulePartsOrSequences (moduleInstanceDefines:Array, forSequencedModule:Boolean):Array
      {
         var modulePartsOrSequences:Array = new Array (moduleInstanceDefines.length);
         
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId];
            
            var module:Module = GetModuleFromDefine (moduleInstanceDefine);
            var transform:Transform2D = new Transform2D (moduleInstanceDefine.mPosX, moduleInstanceDefine.mPosY, 
                                                         moduleInstanceDefine.mScale, moduleInstanceDefine.mIsFlipped != 0, 
                                                         moduleInstanceDefine.mRotation
                                                      );
            
            if (forSequencedModule)
            {
               modulePartsOrSequences [miId] = new ModuleSequence (module, transform, 
                                                                   moduleInstanceDefine.mVisible != 0, moduleInstanceDefine.mAlpha, 
                                                                   moduleInstanceDefine.mModuleDuration);
            }
            else
            {
               modulePartsOrSequences [miId] = new ModulePart (module, transform, 
                                                               moduleInstanceDefine.mVisible != 0, moduleInstanceDefine.mAlpha);
            }
         }
         
         return modulePartsOrSequences;
      }
      
      protected /*static*/ function GetModuleFromDefine (moduleInstanceDefine:Object):Module
      {
         var module:Module = null;
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            var vectorShape:VectorShape = null;
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               var pathShape:VectorShapePath = null;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  var polylineShape:VectorShapePolylineForPlaying = new VectorShapePolylineForPlaying ();
                  polylineShape.SetLocalVertexPoints (moduleInstanceDefine.mPolyLocalPoints);
                  //polylineShape.SetLocalVertexPointsInPhysics (DisplayPoints2PhysicsPoints (moduleInstanceDefine.mPolyLocalPoints));
                  
                  vectorShape = pathShape = polylineShape;
               }
               
               if (pathShape != null)
               {
                  pathShape.SetPathThickness (moduleInstanceDefine.mShapePathThickness);
                  //pathShape.SetPathThicknessInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mShapePathThickness));
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               var areaShape:VectorShapeArea = null;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  var circleShape:VectorShapeCircleForPlaying = new VectorShapeCircleForPlaying ();
                  circleShape.SetRadius (moduleInstanceDefine.mCircleRadius);
                  //circleShape.SetRadiusInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mCircleRadius));
                  
                  vectorShape = areaShape = circleShape;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  var rectShape:VectorShapeRectangleForPlaying = new VectorShapeRectangleForPlaying ();
                  rectShape.SetHalfWidth  (moduleInstanceDefine.mRectHalfWidth);
                  //rectShape.SetHalfWidthInPhysics  (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mRectHalfWidth));
                  rectShape.SetHalfHeight (moduleInstanceDefine.mRectHalfHeight);
                  //rectShape.SetHalfHeightInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mRectHalfHeight));
                  
                  vectorShape = areaShape = rectShape;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  var polygonShape:VectorShapePolygonForPlaying = new VectorShapePolygonForPlaying ();
                  polygonShape.SetLocalVertexPoints (moduleInstanceDefine.mPolyLocalPoints);
                  //polygonShape.SetLocalVertexPointsInPhysics (DisplayPoints2PhysicsPoints (moduleInstanceDefine.mPolyLocalPoints));
                  
                  vectorShape = areaShape = polygonShape;
               }
               
               if (areaShape != null)
               {
                  areaShape.SetBorderOpacityAndColor (moduleInstanceDefine.mShapeBorderOpacityAndColor);
                  areaShape.SetBorderThickness (moduleInstanceDefine.mShapeBorderThickness);
                  //areaShape.SetBorderThicknessInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mShapeBorderThickness));
                  
                  //>> from v1.60
                  var bodyTextureDefine:Object = moduleInstanceDefine.mBodyTextureDefine;
                  if (bodyTextureDefine != null && bodyTextureDefine.mModuleIndex >= 0)
                  {
                     areaShape.SetBodyTextureModule (GetImageModuleByGlobalIndex (bodyTextureDefine.mModuleIndex) as ImageBitmap);
                     areaShape.SetBodyTextureTransform (new Transform2D (bodyTextureDefine.mPosX, bodyTextureDefine.mPosY, 
                                                              bodyTextureDefine.mScale, bodyTextureDefine.mIsFlipped, bodyTextureDefine.mRotation));
                  }
                  //<<
               }
            }
            
            if (vectorShape != null)
            {
               vectorShape.SetAttributeBits (moduleInstanceDefine.mShapeAttributeBits);
               vectorShape.SetBodyOpacityAndColor (moduleInstanceDefine.mShapeBodyOpacityAndColor);
               
               return new ImageVectorShape (vectorShape as VectorShapeForPlaying);
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            module = GetImageModuleByGlobalIndex (moduleInstanceDefine.mModuleIndex);
         }
         else // ...
         {
         }
         
         if (module == null)
            module = new Module ();
         
         return module;
      }
      
      public /*static*/ function CreateSounds (soundDefines:Array):void
      {
         if (mSounds == null)
         {
            var soundId:int;
            
            mSounds = new Array (soundDefines.length);
            
            for (soundId = 0; soundId < soundDefines.length; ++ soundId)
            {
               var soundDefine:Object = soundDefines [soundId];
               
               var sound:Sound = new Sound ();
               mSounds [soundId] = sound;
               
               sound.SetId (soundId);
               //soundDefine.mName
               sound.SetAttributeBits (soundDefine.mAttributeBits);
               sound.SetNumSamples (soundDefine.mNumSamples);
               
               // bugs. Must put in a seperated loop.
               //sound.SetFileDataAndLoad (soundDefine.mFileData, OnLoadSoundDone, OnLoadSoundError);
            }
            
            for (soundId = 0; soundId < soundDefines.length; ++ soundId)
            {
               var soundDefine:Object = soundDefines [soundId];
               var sound:Sound = mSounds [soundId] as Sound;
               
               sound.SetFileDataAndLoad (soundDefine.mFileData, OnLoadSoundDone, OnLoadSoundError);
            }
         }
      }
      
      //protected static function DisplayPoints2PhysicsPoints (displayPoints:Array):Array
      //{
      //   var coorinateSyatem:CoordinateSystem = GetCurrentWorld ().GetCoordinateSystem ();
      //   
      //   var displayPoint:Point;
      //   var physicsPoint:Point;
      //
      //   var vertexCount:int = displayPoints.length;
      //   var physicsPoints:Array = new Array (vertexCount);
      //
      //   for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId)
      //   {
      //      displayPoint = displayPoints [vertexId] as Point;
      //
      //      var physicsPoint = new Point ();
      //      physicsPoint.x = coorinateSyatem.D2P_LinearDeltaX (displayPoint.x);
      //      physicsPoint.y = coorinateSyatem.D2P_LinearDeltaY (displayPoint.y);
      //      
      //      physicsPoints [vertexId] = physicsPoint;
      //   }
      //   
      //   return physicsPoints;
      //}
      
      protected /*static*/ function OnLoadImageDone (image:ImageBitmap):void
      {
         for (var divisionId:int = 0; divisionId < mImageBitmapDivisions.length; ++ divisionId)
         {
            var imageDivision:ImageBitmapDivision = mImageBitmapDivisions [divisionId];
            if (imageDivision.GetSourceImage () == image && imageDivision.GetStatus () == 0)
            {
               imageDivision.OnSourceImageRebuilt ();
            }
         }
         
         //...
         
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
      }
      
      protected /*static*/ function OnLoadImageError (image:ImageBitmap):void
      {
         //GetCurrentWorld ().SetBuildingStatus (-1);
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
      }
      
      protected /*static*/ function OnLoadSoundDone (sound:Sound):void
      {  
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
      }
      
      protected /*static*/ function OnLoadSoundError (sound:Sound):void
      {
         //GetCurrentWorld ().SetBuildingStatus (-1);
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
      }
      
      public /*static*/ function CheckWorldBuildingStatus ():int //void
      {
         var pending:Boolean = false;
         
         var status:int;
         
         for (var imageId:int = 0; imageId < mImageBitmaps.length; ++ imageId)
         {
            var image:ImageBitmap = mImageBitmaps [imageId] as ImageBitmap;
            status = image.GetStatus ();
            
            if (status < 0)
            {
               //GetCurrentWorld ().SetBuildingStatus (-1);
               //return;
               return -1;
            }
            
            if (status == 0)
            {
               pending = true;
            }
         }

         for (var soundId:int = 0; soundId < mSounds.length; ++ soundId)
         {
            var sound:Sound = mSounds [soundId] as Sound;
            status = sound.GetStatus ();
            
            // allow sound silient loading failed. for
            // - 1. it will fail when sound data is invalid
            // - 2. loadBytes is not supported on iOS 
            //(but not allow images loading failed)
            //
            //if (status < 0)
            //{
            //   GetCurrentWorld ().SetBuildingStatus (-1);
            //   return;
            //}
            
            if (status == 0)
            {
               pending = true;
            }
         }
         
         if (pending)
         {
            //GetCurrentWorld ().SetBuildingStatus (0);
            return 0;
         }
         else
         {  
            //GetCurrentWorld ().UpdateImageModuleAppearances (); // bug for repainting module buttons
            
            //GetCurrentWorld ().SetBuildingStatus (1);
            return 1;
         }
      }
      
      public /*static*/ function ValiddateModuleIndex (index:int):int
      {
         if (isNaN (index) || index < 0 || index >= mNumTotalModules)
            return -1;
         
         return index;
      }
      
      public /*static*/ function GetImageModuleByGlobalIndex (moduleId:int):Module
      {
         // todo: create an Array for better performance
         
         moduleId = ValiddateModuleIndex (moduleId);
         
         if (moduleId >= 0)
         {
            if (moduleId < mImageBitmaps.length)
               return mImageBitmaps [moduleId] as Module;
            
            moduleId -= mImageBitmaps.length;
            
            if (moduleId < mImageBitmapDivisions.length)
               return mImageBitmapDivisions [moduleId] as Module;
            
            moduleId -= mImageBitmapDivisions.length;
            
            if (moduleId < mAssembledModules.length)
               return mAssembledModules [moduleId] as Module;
            
            moduleId -= mAssembledModules.length;
            
            if (moduleId < mSequencedModules.length)
               return mSequencedModules [moduleId] as Module;
         }
         
         return new Module (); // a dummy module
      }
      
      public /*static*/ function HasSounds ():Boolean
      {
         return mSounds != null && mSounds.length > 0;
      }
      
      public /*static*/ function GetSoundByIndex (soundIndex:int):Sound
      {
         if (soundIndex >= 0 && soundIndex < mSounds.length)
         {
            return mSounds [soundIndex] as Sound;
         }
         
         return null;
      }
   }
}
