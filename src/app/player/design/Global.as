package player.design
{
   import flash.geom.Point;   
   
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   import player.trigger.FunctionDefinition_Custom;

   import player.entity.Entity;
   
   import player.module.*;
   import player.image.*;
   
   import player.sound.Sound;
   
   import com.tapirgames.util.RandomNumberGenerator;
   import com.tapirgames.util.MersenneTwisterRNG;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.define.FunctionDefine;
   
   import common.TriggerFormatHelper2;
   
   import common.shape.*;
   
   import common.CoordinateSystem;
   
   import common.Transform2D;
   import common.Define;
   
   public class Global
   {
      public static var sTheGlobal:Global = null;
      
      public static var mCurrentWorld:World = null;
      
      // these variables are static, which mmeans there can only be one player instance running at the same time.
      
      public static var mRegisterVariableSpace_Boolean:VariableSpace;
      public static var mRegisterVariableSpace_String :VariableSpace;
      public static var mRegisterVariableSpace_Number :VariableSpace;
      public static var mRegisterVariableSpace_Entity :VariableSpace;
      public static var mRegisterVariableSpace_CollisionCategory:VariableSpace;
      public static var mRegisterVariableSpace_Array:VariableSpace;
      
      public static var mRandomNumberGenerators:Array;
      
      public static var mSessionVariableSpace:VariableSpace;
      
      //public static var mGlobalVariableSpaces:Array;
      public static var mGlobalVariableSpace:VariableSpace;
      
      //public static var mEntityVariableSpaces:Array;
      public static var mEntityVariableSpace:VariableSpace;
      
      public static var mCustomFunctionDefinitions:Array;
      
      public static var mImageBitmaps:Array; //
      public static var mImageBitmapDivisions:Array; //
      public static var mAssembledModules:Array;
      public static var mSequencedModules:Array;

      public static var mSounds:Array; //
      
   // callbacks from viewer
      
      public static var UI_OnLoadScene:Function;
      public static var UI_RestartPlay:Function;
      public static var UI_IsPlaying:Function;
      public static var UI_SetPlaying:Function;
      public static var UI_GetSpeedX:Function;
      public static var UI_SetSpeedX:Function;
      public static var UI_GetZoomScale:Function;
      public static var UI_SetZoomScale:Function;
      public static var UI_IsSoundEnabled:Function;
      public static var UI_SetSoundEnabled:Function;
      public static var Viewer_IsAccelerometerSupported;
      public static var Viewer_GetAcceleration;
      public static var _GetDebugString;
      public static var Viewer_SetMouseGestureSupported;
      
//==============================================================================
// temp for playing in editor.
//==============================================================================

   public static function ClearAll ():void
   {
      sTheGlobal = null;
      
      mSessionVariableSpace = null;
      mGlobalVariableSpace = null;
      mEntityVariableSpace = null;
      
      mRegisterVariableSpace_Boolean = null;
      mRegisterVariableSpace_String = null;
      mRegisterVariableSpace_Number = null;
      mRegisterVariableSpace_Entity = null;
      mRegisterVariableSpace_CollisionCategory = null;
      mRegisterVariableSpace_Array = null;
      
      mImageBitmaps = null;
      mImageBitmapDivisions = null;
      mAssembledModules = null;
      mSequencedModules = null;
      
      mSounds = null;
      
      mRandomNumberGenerators = null;
      
      Sound.StopAllSounds ();
   }

//==============================================================================
// static values
//==============================================================================
      
      public static function InitGlobalData (isRestartLevel:Boolean, dontReloadGlobalAssets:Boolean):void
      {
         //
         sTheGlobal = new Global ();
         
         if (! isRestartLevel)
         {
            mSessionVariableSpace = null;
         }
         mGlobalVariableSpace = null;
         mEntityVariableSpace = null;
         
         //
         TriggerEngine.InitializeConstData ();
         
         //
         mRegisterVariableSpace_Boolean           = CreateRegisterVariableSpace (false);
         mRegisterVariableSpace_String            = CreateRegisterVariableSpace (null);
         mRegisterVariableSpace_Number            = CreateRegisterVariableSpace (0);
         mRegisterVariableSpace_Entity            = CreateRegisterVariableSpace (null);
         mRegisterVariableSpace_CollisionCategory = CreateRegisterVariableSpace (null);
         mRegisterVariableSpace_Array             = CreateRegisterVariableSpace (null);
         
         //
         //if (! isRestartLevel) // before v2.00
         if (! dontReloadGlobalAssets) // from v2.00
         {
            mImageBitmaps         = null;
            mImageBitmapDivisions = null;
            
            mSounds = null; 
         }
         mAssembledModules     = null;
         mSequencedModules     = null;
         
         //
         Sound.StopAllSounds ();
         
         //
         mRandomNumberGenerators = new Array (Define.NumRngSlots);
         
         //
         UI_RestartPlay = null;
         UI_IsPlaying = null;
         UI_SetPlaying = null;
         UI_GetSpeedX = null;
         UI_SetSpeedX = null;
         UI_GetZoomScale = null;
         UI_SetZoomScale = null;
         UI_IsSoundEnabled = null;
         UI_SetSoundEnabled = null;
         
         //
         Entity.sLastSpecialId = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
      }
      
      public static function SetCurrentWorld (world:World):void
      {
         mCurrentWorld = world;
      }
      
      public static function GetCurrentWorld ():World
      {
         return mCurrentWorld;
      }
      
      protected static function CreateRegisterVariableSpace (initValueObject:Object):VariableSpace
      {
         var vs:VariableSpace = new VariableSpace (Define.NumRegistersPerVariableType);
         
         for (var i:int = 0; i < Define.NumRegistersPerVariableType; ++ i)
            vs.GetVariableAt (i).SetValueObject (initValueObject);
         
         return vs;
      }
      
      public static function GetRegisterVariableSpace (valueType:int):VariableSpace
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return mRegisterVariableSpace_Boolean;
            case ValueTypeDefine.ValueType_String:
               return mRegisterVariableSpace_String;
            case ValueTypeDefine.ValueType_Number:
               return mRegisterVariableSpace_Number;
            case ValueTypeDefine.ValueType_Entity:
               return mRegisterVariableSpace_Entity;
            case ValueTypeDefine.ValueType_CollisionCategory:
               return mRegisterVariableSpace_CollisionCategory;
            case ValueTypeDefine.ValueType_Array:
               return mRegisterVariableSpace_Array;
            default:
               return null;
         }
      }
      
      //public static function InitCustomVariables (globalVarialbeSpaceDefines:Array, entityVarialbeSpaceDefines:Array):void // v1.52 only
      public static function InitCustomVariables (globalVarialbeDefines:Array, entityVarialbeDefines:Array, sessionVariableDefines:Array):void // sessionVariableDefines added from v1.57
      {
         //>> v1.52 only
         //var numSpaces:int;
         //
         //numSpaces = globalVarialbeSpaceDefines.length;
         //mGlobalVariableSpaces = new Array (numSpaces);
         //
         //for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
         //{
         //   mGlobalVariableSpaces [spaceId] = TriggerFormatHelper2.VariableSpaceDefine2VariableSpace (mCurrentWorld, globalVarialbeSpaceDefines [spaceId] as VariableSpaceDefine);
         //}
         //
         //numSpaces = entityVarialbeSpaceDefines.length;
         //mEntityVariableSpaces = new Array (numSpaces);
         //
         //for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
         //{
         //   mEntityVariableSpaces [spaceId] = TriggerFormatHelper2.VariableSpaceDefine2VariableSpace (mCurrentWorld, entityVarialbeSpaceDefines [spaceId] as VariableSpaceDefine);
         //}
         //<<
         
         if (mSessionVariableSpace == null) // for restart, this is false
         {
            mSessionVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, sessionVariableDefines);
         }
         else
         {
            // reevaluate placed-in-editor entities and ccats
            // nullify non-placed-in-editor entities and ccats
            // potiential decision: discard session variables since a later version, use Game_Data_Save API alikes instead. 

            TriggerFormatHelper2.ValidateVariableSpaceInitialValues (mCurrentWorld, mSessionVariableSpace/*, sessionVariableDefines*/);
         }
         mGlobalVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, globalVarialbeDefines);
         mEntityVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, entityVarialbeDefines);
      }
      
      public static function GetSessionVariableSpace ():VariableSpace
      {
         return mSessionVariableSpace;
      }
      
      public static function GetGlobalVariableSpace ():VariableSpace
      {
         //>> v1.52 only
         //if (spaceId < 0 || spaceId >= mGlobalVariableSpaces.length)
         //   return null;
         //
         //return mGlobalVariableSpaces [spaceId] as VariableSpace;
         //<<
         
         return mGlobalVariableSpace;
      }
      
      //>> v1.52 only
      //// propertyValues should not be null
      //public static function InitEntityPropertyValues (proeprtySpaces:Array):void
      //{
      //   var numSpaces:int = mEntityVariableSpaces.length;
      //   
      //   proeprtySpaces.length = numSpaces;
      //   for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
      //   {
      //      proeprtySpaces [spaceId] = (mEntityVariableSpaces [spaceId] as VariableSpace).CloneSpace ();
      //   }
      //}
      //<<
      
      public static function CloneEntityPropertyInitialValues ():VariableSpace
      {
         return mEntityVariableSpace.CloneSpace ();
      }
      
      public static function GetDefaultEntityPropertyValue (propertyId:int):Object
      {
         var vi:VariableInstance = mEntityVariableSpace.GetVariableAt (propertyId);
         return vi == null ? null : vi.GetValueObject ();
      }
      
      public static function CreateCustomFunctionDefinitions (functionDefines:Array):void
      {
         var numFunctions:int = functionDefines.length;
         mCustomFunctionDefinitions = new Array (numFunctions);
         
         for (var functionId:int = 0; functionId < numFunctions; ++ functionId)
         {
            mCustomFunctionDefinitions [functionId] = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (functionDefines [functionId] as FunctionDefine, null);
         }
      }
      
      public static function GetCustomFunctionDefinition (functionId:int):FunctionDefinition_Custom
      {
         if (functionId < 0 || functionId >= mCustomFunctionDefinitions.length)
            return null;
         
         return mCustomFunctionDefinitions [functionId] as FunctionDefinition_Custom;
      }
      
      public static function CreateImageModules (imageDefines:Array, pureImageModuleDefines:Array, assembledModuleDefines:Array, sequencedModuleDefines:Array):void
      {
         var needLoadImages:Boolean = false;
         var imageId:int;
         var image:ImageBitmap;
         
         if (mImageBitmaps == null)
         {
            needLoadImages = true;
            
            mImageBitmaps         = new Array (imageDefines.length);
            
            for (imageId = 0; imageId < imageDefines.length; ++ imageId)
            {
               image = new ImageBitmap ();
               image.SetId (imageId);
               mImageBitmaps [imageId] = image;
            }
         }

         if (mImageBitmapDivisions == null)
         {
            mImageBitmapDivisions = new Array (pureImageModuleDefines.length);

            for (var divisionId:int = 0; divisionId < pureImageModuleDefines.length; ++ divisionId)
            {
               var divisionDefine:Object = pureImageModuleDefines [divisionId];
               
               var imageDivision:ImageBitmapDivision = new ImageBitmapDivision (mImageBitmaps [divisionDefine.mImageIndex] as ImageBitmap, 
                                                       divisionDefine.mLeft, divisionDefine.mTop, divisionDefine.mRight, divisionDefine.mBottom);
               imageDivision.SetId (imageDefines.length + divisionId);
               mImageBitmapDivisions [divisionId] = imageDivision;
            }
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

         mAssembledModules     = new Array (assembledModuleDefines.length);

         var assembledModuleId:int;
         for (assembledModuleId = 0; assembledModuleId < assembledModuleDefines.length; ++ assembledModuleId)
         {
            mAssembledModules [assembledModuleId] = new AssembledModule ();
            (mAssembledModules [assembledModuleId] as AssembledModule).SetId (imageDefines.length + pureImageModuleDefines.length + assembledModuleId);
         }

         mSequencedModules     = new Array (sequencedModuleDefines.length);

         var sequencedModuleId:int;
         for (sequencedModuleId = 0; sequencedModuleId < sequencedModuleDefines.length; ++ sequencedModuleId)
         {
            mSequencedModules [sequencedModuleId] = new SequencedModule ();
            (mSequencedModules [sequencedModuleId] as SequencedModule) .SetId (imageDefines.length + pureImageModuleDefines.length + assembledModuleDefines.length + sequencedModuleId);
         }

         for (assembledModuleId = 0; assembledModuleId < assembledModuleDefines.length; ++ assembledModuleId)
         {
            var assembledModuleDefine:Object = assembledModuleDefines [assembledModuleId];

            var moduleParts:Array = CreateModulePartsOrSequences (assembledModuleDefine.mModulePartDefines, false);
            
            (mAssembledModules [assembledModuleId] as AssembledModule).SetModuleParts (moduleParts);
         }

         for (sequencedModuleId = 0; sequencedModuleId < sequencedModuleDefines.length; ++ sequencedModuleId)
         {
            var sequencedModuleDefine:Object = sequencedModuleDefines [sequencedModuleId];

            var moduleSequences:Array = CreateModulePartsOrSequences (sequencedModuleDefine.mModuleSequenceDefines, true);
            
            (mSequencedModules [sequencedModuleId] as SequencedModule).SetModuleSequences (moduleSequences);
            //sequencedModuleDefine.mIsLooped
         }
      }
      
      protected static function CreateModulePartsOrSequences (moduleInstanceDefines:Array, forSequencedModule:Boolean):Array
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
            var transformInPhysics:Transform2D = new Transform2D (
                                                         GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mPosX), 
                                                         GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mPosY), 
                                                         moduleInstanceDefine.mScale, moduleInstanceDefine.mIsFlipped != 0, 
                                                         GetCurrentWorld ().GetCoordinateSystem ().D2P_RotationRadians (moduleInstanceDefine.mRotation)
                                                      );
            
            var modulePart:ModulePart;
            if (forSequencedModule)
            {
               modulePartsOrSequences [miId] = new ModuleSequence (module, transform, transformInPhysics, moduleInstanceDefine.mVisible != 0, moduleInstanceDefine.mAlpha, 
                                                                   moduleInstanceDefine.mModuleDuration);
            }
            else
            {
               modulePartsOrSequences [miId] = new ModulePart (module, transform, transformInPhysics, moduleInstanceDefine.mVisible != 0, moduleInstanceDefine.mAlpha);
            }
         }
         
         return modulePartsOrSequences;
      }
      
      protected static function GetModuleFromDefine (moduleInstanceDefine:Object):Module
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
                  polylineShape.SetLocalVertexPointsInPhysics (DisplayPoints2PhysicsPoints (moduleInstanceDefine.mPolyLocalPoints));
                  
                  vectorShape = pathShape = polylineShape;
               }
               
               if (pathShape != null)
               {
                  pathShape.SetPathThickness (moduleInstanceDefine.mShapePathThickness);
                  pathShape.SetPathThicknessInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mShapePathThickness));
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               var areaShape:VectorShapeArea = null;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  var circleShape:VectorShapeCircleForPlaying = new VectorShapeCircleForPlaying ();
                  circleShape.SetRadius (moduleInstanceDefine.mCircleRadius);
                  circleShape.SetRadiusInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mCircleRadius));
                  
                  vectorShape = areaShape = circleShape;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  var rectShape:VectorShapeRectangleForPlaying = new VectorShapeRectangleForPlaying ();
                  rectShape.SetHalfWidth  (moduleInstanceDefine.mRectHalfWidth);
                  rectShape.SetHalfWidthInPhysics  (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mRectHalfWidth));
                  rectShape.SetHalfHeight (moduleInstanceDefine.mRectHalfHeight);
                  rectShape.SetHalfHeightInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mRectHalfHeight));
                  
                  vectorShape = areaShape = rectShape;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  var polygonShape:VectorShapePolygonForPlaying = new VectorShapePolygonForPlaying ();
                  polygonShape.SetLocalVertexPoints (moduleInstanceDefine.mPolyLocalPoints);
                  polygonShape.SetLocalVertexPointsInPhysics (DisplayPoints2PhysicsPoints (moduleInstanceDefine.mPolyLocalPoints));
                  
                  vectorShape = areaShape = polygonShape;
               }
               
               if (areaShape != null)
               {
                  areaShape.SetBorderOpacityAndColor (moduleInstanceDefine.mShapeBorderOpacityAndColor);
                  areaShape.SetBorderThickness (moduleInstanceDefine.mShapeBorderThickness);
                  areaShape.SetBorderThicknessInPhysics (GetCurrentWorld ().GetCoordinateSystem ().D2P_Length (moduleInstanceDefine.mShapeBorderThickness));
                  
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
      
      public static function CreateSounds (soundDefines:Array):void
      {
         Sound.UpdateSoundVolume ();
         
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
      
      protected static function DisplayPoints2PhysicsPoints (displayPoints:Array):Array
      {
         var coorinateSyatem:CoordinateSystem = GetCurrentWorld ().GetCoordinateSystem ();
         
         var displayPoint:Point;
         var physicsPoint:Point;

         var vertexCount:int = displayPoints.length;
         var physicsPoints:Array = new Array (vertexCount);

         for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId)
         {
            displayPoint = displayPoints [vertexId] as Point;

            var physicsPoint = new Point ();
            physicsPoint.x = coorinateSyatem.D2P_LinearDeltaX (displayPoint.x);
            physicsPoint.y = coorinateSyatem.D2P_LinearDeltaY (displayPoint.y);
            
            physicsPoints [vertexId] = physicsPoint;
         }
         
         return physicsPoints;
      }
      
      protected static function OnLoadImageDone (image:ImageBitmap):void
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
         
         CheckWorldBuildingStatus ();
      }
      
      protected static function OnLoadImageError (image:ImageBitmap):void
      {
         GetCurrentWorld ().SetBuildingStatus (-1);
      }
      
      protected static function OnLoadSoundDone (sound:Sound):void
      {  
         CheckWorldBuildingStatus ();
      }
      
      protected static function OnLoadSoundError (sound:Sound):void
      {
         //GetCurrentWorld ().SetBuildingStatus (-1);
         CheckWorldBuildingStatus ();
      }
      
      public static function CheckWorldBuildingStatus ():void
      {
         var pending:Boolean = false;
         
         var status:int;
         
         for (var imageId:int = 0; imageId < mImageBitmaps.length; ++ imageId)
         {
            var image:ImageBitmap = mImageBitmaps [imageId] as ImageBitmap;
            status = image.GetStatus ();
            
            if (status < 0)
            {
               GetCurrentWorld ().SetBuildingStatus (-1);
               return;
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
            GetCurrentWorld ().SetBuildingStatus (0);
         }
         else
         {  
            GetCurrentWorld ().UpdateImageModuleAppearances ();
            
            GetCurrentWorld ().SetBuildingStatus (1);
         }
      }
      
      public static function GetImageModuleByGlobalIndex (moduleId:int):Module
      {
         // todo: create an Array for better performance
         
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
      
      public static function HasSounds ():Boolean
      {
         return mSounds != null && mSounds.length > 0;
      }
      
      public static function GetSoundByIndex (soundIndex:int):Sound
      {
         if (soundIndex >= 0 && soundIndex < mSounds.length)
         {
            return mSounds [soundIndex] as Sound;
         }
         
         return null;
      }
      
      public static function CreateRandomNumberGenerator (rngSlot:int, rngMethod:int):void
      {
         if (rngSlot < 0 || rngSlot >= Define.NumRngSlots)
            throw new Error ("Invalid RNG slot " + rngSlot);
         
         if (rngMethod < 0 || rngMethod >= Define.NumRngMethods)
            throw new Error ("Invalid RNG method " + rngMethod);
         
         if (rngMethod == 0)
         {
            mRandomNumberGenerators [rngSlot] = new MersenneTwisterRNG ();
         }
      }
      
      public static function GetRandomNumberGenerator (rngSlot:int):RandomNumberGenerator
      {
         return mRandomNumberGenerators [rngSlot];
      }
      
//==============================================================================
// sound
//==============================================================================
      
      private static var mIsSoundsEnabled:Boolean = true;
      
      public static function IsSoundEnabled ():Boolean
      {
         return mIsSoundsEnabled;
      }
      
      public static function SetSoundEnabled (enabled:Boolean):void
      {
         if (mIsSoundsEnabled != enabled)
         {
            mIsSoundsEnabled = enabled;
            
            //if (! mIsSoundsEnabled)
            //{
            //   Sound.StopAllSounds ();
            //}

            Sound.SetSoundVolume (mIsSoundsEnabled ? 1.0 : 0.0);
         }
      }
      
//==============================================================================
// instance
//==============================================================================
      
      public function Global ()
      {
      }
   }
}
