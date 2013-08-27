package player.design
{
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.system.Capabilities;
   
   import player.world.World;
   import player.world.EntityList;
   
   import player.trigger.TriggerEngine;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   import player.trigger.CoreClasses;
   import player.trigger.ClassDefinition;
   import player.trigger.ClassDefinition_Custom;
   import player.trigger.FunctionDefinition_Custom;
   
   import player.trigger.CoreFunctionDefinitions;

   import player.entity.Entity;
   
   import player.module.*;
   import player.image.*;
   
   import player.sound.Sound;
   
   import com.tapirgames.util.RandomNumberGenerator;
   import com.tapirgames.util.MersenneTwisterRNG;
   
   import common.trigger.ValueSpaceTypeDefine;

   import common.trigger.CoreClassIds;
   
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
   
   public class Global
   {
      public static var sTheGlobal:Global = null;
      
      public static var mCurrentWorld:World = null;
      
      public static var mWorldDefine:Object = null;
                  // currently for MergeScene purpose
      
      // these variables are static, which mmeans there can only be one player instance running at the same time.
      
      public static var mRegisterVariableSpace_Boolean:VariableSpace;
      public static var mRegisterVariableSpace_String :VariableSpace;
      public static var mRegisterVariableSpace_Number :VariableSpace;
      public static var mRegisterVariableSpace_Entity :VariableSpace;
      public static var mRegisterVariableSpace_CollisionCategory:VariableSpace;
      public static var mRegisterVariableSpace_Array:VariableSpace;
      
      public static var mRandomNumberGenerators:Array;
      
      public static var mWorldVariableSpace:VariableSpace;
      public static var mGameSaveVariableSpace:VariableSpace;
         private static var mGameSaveVariableSpace_WithInitialValues:VariableSpace;
      
      public static var mSessionVariableSpace:VariableSpace;
      
      //public static var mGlobalVariableSpaces:Array;
      public static var mGlobalVariableSpace:VariableSpace;
      public static var mCommonGlobalVariableSpace:VariableSpace;
      
      //public static var mEntityVariableSpaces:Array;
      public static var mEntityVariableSpace:VariableSpace;
      public static var mCommonEntityVariableSpace:VariableSpace;
      
      public static var mCustomClassDefinitions:Array;
      
      public static var mCustomFunctionDefinitions:Array;
      
      private static var mNumTotalModules:int = 0;
      public static var mImageBitmaps:Array; //
      public static var mImageBitmapDivisions:Array; //
      public static var mAssembledModules:Array;
      public static var mSequencedModules:Array;

      public static var mSounds:Array; //
      
   // callbacks from viewer
      
      public static var UI_RestartPlay:Function;
      public static var UI_IsPlaying:Function;
      public static var UI_SetPlaying:Function;
      public static var UI_GetSpeedX:Function;
      public static var UI_SetSpeedX:Function;
      public static var UI_GetZoomScale:Function;
      public static var UI_SetZoomScale:Function;
      public static var UI_IsSoundEnabled:Function;
      public static var UI_SetSoundEnabled:Function;
      public static var UI_GetSoundVolume:Function; // v2.03 (not really used now)
      public static var UI_SetSoundVolume:Function; // v2.03 (not really used now)
      public static var Viewer_mLibCapabilities:Object;
               //IsAccelerometerSupported:Function; // v1.60
               //GetAcceleration:Function; // v1.60
               //GetScreenResolution:Function; // from v2.03
               //GetScreenDPI:Function; // from v2.03
               //OpenURL:Function; // from v2.03
      public static var _GetDebugString:Function;
      public static var Viewer_SetMouseGestureSupported:Function;
      public static var Viewer_OnLoadScene:Function; // v2.00-v2.03
      public static var Viewer_mLibSound:Object;
               //PlaySound:Function; // v2.02. (before v2.02, sound lib is included in world instead of viewer)
               //StopAllInLevelSounds:Function; // v2.02
               //StopCrossLevelsSound:Function; // v2.02
      public static var Viewer_mLibGraphics:Object; // v2.03
               //LoadImageFromBytes:Function; // v2.03
      public static var Viewer_mLibAppp:Object; // v2.03
               //IsNativeApp:Function; // v2.03
               //OnExitApp:Function; // v2.03
      public static var Viewer_mLibCookie:Object; // v2.03
               //WriteGameSaveData:Function; // v2.03
               //LoadGameSaveData:Function; // v2.03
               //ClearGameSaveData:Function; // v2.03
      public static var Viewer_mLibServices:Object; // v2.03
               //WriteGameSaveData:Function; // v2.03
      
//==============================================================================
// temp for playing in editor.
//==============================================================================

   // todo: in non-editing situations, for one-level game package, maybe only turning off sounds is ok enough.
   // the params:Object parameter is reserved for this intention. 
   
   public static function OnViewerDestroyed (params:Object = null):void
   {
      sTheGlobal = null;
      
      mSceneLookupTableByKey = null;
      mCurrentWorld = null;
      mWorldDefine = null;
      
      CoreFunctionDefinitions.Initialize (null);
      
      mRegisterVariableSpace_Boolean = null;
      mRegisterVariableSpace_String = null;
      mRegisterVariableSpace_Number = null;
      mRegisterVariableSpace_Entity = null;
      mRegisterVariableSpace_CollisionCategory = null;
      mRegisterVariableSpace_Array = null;
      
      mSessionVariableSpace = null;
      mGlobalVariableSpace = null;
      mCommonGlobalVariableSpace = null;
      mEntityVariableSpace = null;
      mCommonEntityVariableSpace = null;
      
      mCustomClassDefinitions = null;
      
      mCustomFunctionDefinitions = null;
      
      mRandomNumberGenerators = null;
      
      mImageBitmaps = null;
      mImageBitmapDivisions = null;
      mAssembledModules = null;
      mSequencedModules = null;
      
      mSounds = null;
      
   // callbacks from viewer
      
      UI_RestartPlay = null;
      UI_IsPlaying = null;
      UI_SetPlaying = null;
      UI_GetSpeedX = null;
      UI_SetSpeedX = null;
      UI_GetZoomScale = null;
      UI_SetZoomScale = null;
      UI_IsSoundEnabled = null;
      UI_SetSoundEnabled = null;
      Viewer_mLibCapabilities = null;
      _GetDebugString = null;
      Viewer_SetMouseGestureSupported = null;
      Viewer_OnLoadScene = null;
      Viewer_mLibSound = null;
      Viewer_mLibGraphics = null;
      Viewer_mLibAppp = null;
      Viewer_mLibCookie = null;
      Viewer_mLibServices = null;
   }
   
//==============================================================================
// 
//==============================================================================
   
   public static function MergeScene (levelIndex):void
   {
      var world:World = Global.GetCurrentWorld ();
      var worldEntityList:EntityList = world.GetEntityList ();
      var worldEntityBodyList:EntityList = world.GetEntityBodyList ();
   
      worldEntityList.MarkLastTail ();
      worldEntityBodyList.MarkLastTail ();
      
      Global.mWorldDefine.mCurrentSceneId = levelIndex;
      DataFormat2.WorldDefine2PlayerWorld (Global.mWorldDefine, world, true);
      
      world.BuildEntityPhysics (true);
      var mergedEntities:Array = worldEntityList.GetEntitiesFromLastMarkedTail ();
   
      worldEntityList.UnmarkLastTail ();
      worldEntityBodyList.UnmarkLastTail ();

      world.RegisterEventHandlersForRuntimeCreatedEntities (true, mergedEntities);
      EntityList.OnCreated_RuntimeCreatedEntities (mergedEntities);
      if (world.ShouldInitRuntimeCteatedEntitiesManually ())
      {
         world.RegisterEventHandlersForRuntimeCreatedEntities (false, mergedEntities);
         EntityList.InitEntities_RuntimeCreatedEntities (mergedEntities);
      }
   }
   
   public static function GetSavedData ():ByteArray
   {
      try
      {
         var binData:ByteArray = new ByteArray ();
         binData.writeShort (0); // data format version
         
         var alreadySavedArrayLookupTable:Dictionary = new Dictionary ();
         
         var numVariables:int = mGameSaveVariableSpace.GetNumVariables ();
         binData.writeInt (numVariables);
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {
            var variableInstance:VariableInstance = mGameSaveVariableSpace.GetVariableAt (variableId);
            
//if (mDebugString == null) mDebugString = "";
//mDebugString = mDebugString + "\n" + "variableId = " + variableId + ", key = " + variableInstance.GetKey ();            
            binData.writeUTF (variableInstance.GetKey ());
            
            WriteTypeAndValue (binData, variableInstance.GetValueType (), variableInstance.GetValueObject (), alreadySavedArrayLookupTable);
         }
         
         return binData;
      }
      catch (error:Error)
      {
         trace ("GetSavedData error: " + error.getStackTrace ());
         
         if (Capabilities.isDebugger)
            throw error;
      }
      
      return null;
   }
   
   private static function WriteTypeAndValue (binData:ByteArray, type:int, value:Object, alreadySavedArrayLookupTable:Dictionary):void
   {
      switch (type)
      {
         case CoreClassIds.ValueType_Boolean:
            binData.writeShort (CoreClassIds.ValueType_Boolean);
            binData.writeByte (Boolean (value) ? 1 : 0);
            break;
         case CoreClassIds.ValueType_Number:
            binData.writeShort (CoreClassIds.ValueType_Number);
            binData.writeDouble (Number (value));
            break;
         case CoreClassIds.ValueType_String:
            binData.writeShort (CoreClassIds.ValueType_String);
            var text:String = value as String;
            binData.writeInt (text == null ? -1 : text.length);
            if (text != null)
            {
               binData.writeUTFBytes (text);
            }
            break;
         case CoreClassIds.ValueType_Array:
            var valuesArray:Array = value as Array;
            if (alreadySavedArrayLookupTable [valuesArray] == true)
            {
               binData.writeShort (CoreClassIds.ValueType_Void);
            }
            else
            {
               alreadySavedArrayLookupTable [valuesArray] = true;

               binData.writeShort (CoreClassIds.ValueType_Array);
               binData.writeInt (valuesArray == null ? -1 : valuesArray.length);
               if (valuesArray != null)
               {
                  //for each (var arrValue:Object in valuesArray) // fant! bug: undefined value is not iterated.
                  for (var i:int = 0; i < valuesArray.length; ++ i)
                  {
                     var arrValue:Object = valuesArray [i];
                     
                     if (arrValue is Boolean)
                     {
                        WriteTypeAndValue (binData, CoreClassIds.ValueType_Boolean, arrValue, alreadySavedArrayLookupTable);
                     }
                     else if (arrValue is Number)
                     {
                        WriteTypeAndValue (binData, CoreClassIds.ValueType_Number, arrValue, alreadySavedArrayLookupTable);
                     }
                     else if (arrValue is String)
                     {
                        WriteTypeAndValue (binData, CoreClassIds.ValueType_String, arrValue, alreadySavedArrayLookupTable);
                     }
                     else if (arrValue is Array)
                     {
                        WriteTypeAndValue (binData, CoreClassIds.ValueType_Array, arrValue, alreadySavedArrayLookupTable);
                     }
                     else
                     {
                        WriteTypeAndValue (binData, CoreClassIds.ValueType_Void, null, alreadySavedArrayLookupTable);
                     }
                  }
               }
            }
            break;
         default:
         {
            binData.writeShort (CoreClassIds.ValueType_Void);
            break;
         }
      }      
   }
   
   public static function SetSavedData (savedData:ByteArray):void
   {
      if (savedData == null)
         return;
      
      var savedVariables:Array = null;
      var numSavedVariables:int;
      var savedVariableId:int;
      
      try
      {
         savedData.position = 0;
         var dataFormatVersion:int = savedData.readShort ();
         
         numSavedVariables = savedData.readInt ();
         savedVariables = new Array (numSavedVariables);
         for (savedVariableId = 0; savedVariableId < numSavedVariables; ++ savedVariableId)
         {
            var key:String = savedData.readUTF ();
            
            var value:Object = ReadNextVariableValue (savedData);

            savedVariables [savedVariableId] = {mKey: key, mValue: value};
         }
      }
      catch (error:Error)
      {
         trace ("GetSavedData error: " + error.getStackTrace ());
         
         if (Capabilities.isDebugger)
            throw error;
         
         savedVariables = null;
      }
      
      if (savedVariables != null)
      {
         var variableInstance:VariableInstance;
         
         var variableLookupTable:Dictionary = new Dictionary ();
         var numVariables:int = mGameSaveVariableSpace.GetNumVariables ();
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {
            variableInstance = mGameSaveVariableSpace.GetVariableAt (variableId);
            variableLookupTable [variableInstance.GetKey ()] = variableInstance;
         }
         
         for (savedVariableId = 0; savedVariableId < numSavedVariables; ++ savedVariableId)
         {
            var savedVariable:Object = savedVariables [savedVariableId];
            
            variableInstance = variableLookupTable [savedVariable.mKey];
            if (variableInstance != null)
            {
               variableInstance.SetValueObject (savedVariable.mValue);
            }
         }
      }
   }
   
   private static function ReadNextVariableValue (savedData:ByteArray):Object
   {
      var type:int = savedData.readShort ();

      switch (type)
      {
         case CoreClassIds.ValueType_Boolean:
            return savedData.readByte () != 0;
         case CoreClassIds.ValueType_Number:
            return savedData.readDouble ();
         case CoreClassIds.ValueType_String:
            var strLen:int = savedData.readInt ();
            if (strLen < 0)
               return null;
            else
            {
               return savedData.readUTFBytes (strLen);
            }
         case CoreClassIds.ValueType_Array:
            var arrLen:int = savedData.readInt ();
            if (arrLen < 0)
               return null;
            else
            {
               var valuesArray:Array = new Array (arrLen);
               for (var i:int = 0; i < arrLen; ++ i)
               {
                  valuesArray [i] = ReadNextVariableValue (savedData);
               }
            }
            return valuesArray ;
         default:
         {
            return null;
         }
      } 
   }
   
   private static var mDebugString:String = null;
   public static function GetDebugString ():String
   {
      return mDebugString;
   }
   
//==============================================================================
// scenes
//==============================================================================
      
      public static var mSceneLookupTableByKey:Dictionary = null;
      
      public static function GetSceneByKey (key:String):int
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
      
      public static function GetNumScenes ():int
      {
         return mWorldDefine == null ? 0 : mWorldDefine.mSceneDefines.length;
      }
      
      public static function IsInvalidScene (levelIndex:int):Boolean
      {
         return isNaN (levelIndex) || levelIndex < 0 || levelIndex >= Global.GetNumScenes ();
      }
      
      public static function GetSceneDefine (sceneIndex:int):SceneDefine
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
      
      public static function InitGlobalData (isRestartLevel:Boolean, dontReloadGlobalAssets:Boolean):void
      {
         //
         sTheGlobal = new Global ();
         
         if (!dontReloadGlobalAssets)
         {
            mSceneLookupTableByKey = null;
            
            mWorldVariableSpace = null;
            mGameSaveVariableSpace = null;
            mGameSaveVariableSpace_WithInitialValues = null;
         }
         
         if (! isRestartLevel)
         {
            mSessionVariableSpace = null;
         }
         mGlobalVariableSpace = null;
         mCommonGlobalVariableSpace = null;
         mEntityVariableSpace = null;
         mCommonEntityVariableSpace = null;
         
         mCustomClassDefinitions = null;
         
         mCustomFunctionDefinitions = null;
         
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
            mAssembledModules     = null;
            mSequencedModules     = null;
            
            mSounds = null;
         }
         mAssembledModules     = null;
         mSequencedModules     = null;
         
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
         Viewer_mLibCapabilities = null;
         _GetDebugString = null;
         Viewer_SetMouseGestureSupported = null;
         Viewer_OnLoadScene = null;
         Viewer_mLibSound = null;
         Viewer_mLibGraphics = null;
         Viewer_mLibAppp = null;
         Viewer_mLibCookie = null;
         Viewer_mLibServices = null;
         
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
      
      public static function CreateOrResetCoreFunctionDefinitions ():void
      {
         if (mCurrentWorld == null)
            throw new Error ();
         
         CoreFunctionDefinitions.Initialize (mCurrentWorld);
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
            case CoreClassIds.ValueType_Boolean:
               return mRegisterVariableSpace_Boolean;
            case CoreClassIds.ValueType_String:
               return mRegisterVariableSpace_String;
            case CoreClassIds.ValueType_Number:
               return mRegisterVariableSpace_Number;
            case CoreClassIds.ValueType_Entity:
               return mRegisterVariableSpace_Entity;
            case CoreClassIds.ValueType_CollisionCategory:
               return mRegisterVariableSpace_CollisionCategory;
            case CoreClassIds.ValueType_Array:
               return mRegisterVariableSpace_Array;
            default:
               return null;
         }
      }
      
      public static function InitWorldCustomVariables (worldVarialbeSpaceDefines:Array, gameSaveVarialbeSpaceDefines:Array):void
      {
         if (mWorldVariableSpace == null)
         {
            mWorldVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/null, worldVarialbeSpaceDefines, null, 0); // 0 is meaningless
         }
         else // switch/restart level
         {
            TriggerFormatHelper2.ValidateVariableSpaceInitialValues (mCurrentWorld, mWorldVariableSpace, worldVarialbeSpaceDefines, true, false);            
         }
         
         if (mGameSaveVariableSpace == null)
         {
            mGameSaveVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/null, gameSaveVarialbeSpaceDefines, null, 0); // 0 is meaningless
            mGameSaveVariableSpace_WithInitialValues = mGameSaveVariableSpace.CloneSpace ();
         }
         else // switch/restart level
         {
            TriggerFormatHelper2.ValidateVariableSpaceInitialValues (mCurrentWorld, mGameSaveVariableSpace, gameSaveVarialbeSpaceDefines, true, false);
         }
      }
      
      //public static function InitSceneCustomVariables (globalVarialbeSpaceDefines:Array, entityVarialbeSpaceDefines:Array):void // v1.52 only
      public static function InitSceneCustomVariables (globalVarialbeDefines:Array, commonGlobalVarialbeDefines:Array, entityVarialbeDefines:Array, commonEntityVarialbeDefines:Array, 
                                                      sessionVariableDefines:Array, sessionVariableIndexMappingTable:Array,  // sessionVariableDefines added from v1.57
                                                      isMerging:Boolean/* = false*/,
                                                      customClassIdShiftOffset:int):void // customClassIdShiftOffset added from v2.05
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
         
         if (mSessionVariableSpace == null) // load from stretch
         {
            mSessionVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, sessionVariableDefines, null, customClassIdShiftOffset, true);
         }
         else // restart level or merge level
         {
            if (isMerging)
            {
               // todo: for session, should use the CreatePnlyOnNotExist policy.
               mSessionVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, sessionVariableDefines, mSessionVariableSpace, customClassIdShiftOffset, true, sessionVariableIndexMappingTable);
            }
            else
            {
               // reevaluate placed-in-editor entities and ccats
               // nullify non-placed-in-editor entities and ccats
               // potiential decision: discard session variables since a later version, use Game_Data_Save API alikes instead. 
   
               TriggerFormatHelper2.ValidateVariableSpaceInitialValues (mCurrentWorld, mSessionVariableSpace, sessionVariableDefines, false, true);
            }
         }
         
         mGlobalVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, globalVarialbeDefines, isMerging ? mGlobalVariableSpace : null, customClassIdShiftOffset);
         mEntityVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, entityVarialbeDefines, isMerging ? mEntityVariableSpace : null, customClassIdShiftOffset);
         if (! isMerging)
         {
            mCommonGlobalVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, commonGlobalVarialbeDefines, null, customClassIdShiftOffset);
            mCommonEntityVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, commonEntityVarialbeDefines, null, customClassIdShiftOffset);
         }
      }
      
      public static function GetWorldVariableSpace ():VariableSpace
      {
         return mWorldVariableSpace;
      }
      
      public static function GetGameSaveVariableSpace ():VariableSpace
      {
         return mGameSaveVariableSpace;
      }
      
      public static function ResetGameSaveVariableSpace ():void
      {
         if (mGameSaveVariableSpace_WithInitialValues != null) // shouldn't
         {
            mGameSaveVariableSpace = mGameSaveVariableSpace_WithInitialValues.CloneSpace ();
         }
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
      
      public static function GetCommonGlobalVariableSpace ():VariableSpace
      {
         return mCommonGlobalVariableSpace;
      }
      
      public static function GetCustomEntityVariableSpace ():VariableSpace
      {
         return mEntityVariableSpace;
      }
      
      public static function GetCommonCustomEntityVariableSpace ():VariableSpace
      {
         return mCommonEntityVariableSpace;
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
      
      //public static function CloneEntityPropertyInitialValues ():VariableSpace
      //{
      //   return mEntityVariableSpace.CloneSpace ();
      //}
      
      public static function GetDefaultEntityPropertyValue (spaceId:int, propertyId:int):Object
      {
         var vi:VariableInstance;
         
         if (spaceId == ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
            vi = mCommonEntityVariableSpace.GetVariableAt (propertyId);
         else // if (spaceId == ValueSpaceTypeDefine.ValueSpace_EntityProperties) or 0
            vi = mEntityVariableSpace.GetVariableAt (propertyId);
         
         return vi == null ? null : vi.GetValueObject ();
      }
      
      // custom classes
      
      public static function InitCustomClassDefinitions (classDefines:Array, isMerging:Boolean):void
      {
         var numNewClasses:int = classDefines.length;
         var numOldClasses:int = mCustomClassDefinitions == null ? 0 : mCustomClassDefinitions.length;
         if (isMerging)
         {
            mCustomClassDefinitions.length = numOldClasses + numNewClasses;
         }
         else
         {
            mCustomClassDefinitions = new Array (numNewClasses);
         }
         
         var classId:int;
         var newClassId:int;
         for (classId = 0; classId < numNewClasses; ++ classId)
         {
            newClassId = numOldClasses + classId;
            mCustomClassDefinitions [newClassId] = new ClassDefinition_Custom (newClassId);
         }

         for (classId = 0; classId < numNewClasses; ++ classId)
         {
            var classDefine:ClassDefine = classDefines [classId] as ClassDefine;
            
            newClassId = numOldClasses + classId;
            var customClass:ClassDefinition_Custom = Global.GetCustomClassDefinition (newClassId);
            customClass.SetPropertyVariableSpaceTemplate (TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, classDefine.mPropertyVariableDefines, null, numOldClasses));
         }
      }
      
      public static function GetNumCustomClasses ():int
      {
         return mCustomClassDefinitions == null ? 0 : mCustomClassDefinitions.length;
      }
      
      public static function GetCustomClassDefinition (classId:int):ClassDefinition_Custom
      {
         if (classId < 0 || mCustomClassDefinitions == null || classId >= mCustomClassDefinitions.length)
            return null;
         
         return mCustomClassDefinitions [classId] as ClassDefinition_Custom;
      }
      
      // custom functions
      
      public static function CreateCustomFunctionDefinitions (functionDefines:Array, isMerging:Boolean, customClassIdShiftOffset:int):void
      {
         var numOldFunctions:int = mCustomFunctionDefinitions == null ? 0 : mCustomFunctionDefinitions.length;
         var numNewFunctions:int = functionDefines.length;
         if (isMerging)
         {
            mCustomFunctionDefinitions.length = numOldFunctions + numNewFunctions;
         }
         else
         {
            mCustomFunctionDefinitions = new Array (numNewFunctions);
         }
         
         for (var functionId:int = 0; functionId < numNewFunctions; ++ functionId)
         {
            mCustomFunctionDefinitions [numOldFunctions + functionId] = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (mCurrentWorld, functionDefines [functionId] as FunctionDefine, null, customClassIdShiftOffset);
         }
      }
      
      public static function GetNumCustomFunctions ():int
      {
         return mCustomFunctionDefinitions == null ? 0 : mCustomFunctionDefinitions.length;
      }
      
      public static function GetCustomFunctionDefinition (functionId:int):FunctionDefinition_Custom
      {
         if (functionId < 0 || mCustomFunctionDefinitions == null || functionId >= mCustomFunctionDefinitions.length)
            return null;
         
         return mCustomFunctionDefinitions [functionId] as FunctionDefinition_Custom;
      }
      
      public static function CreateImageModules (imageDefines:Array, pureImageModuleDefines:Array, assembledModuleDefines:Array, sequencedModuleDefines:Array):void
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
         
         for (assembledModuleId = 0; assembledModuleId < assembledModuleDefines.length; ++ assembledModuleId)
         {
            (mAssembledModules [assembledModuleId] as AssembledModule).AdjustModulePartsTransformInPhysics (GetCurrentWorld ().GetCoordinateSystem ());
         }
         
         for (sequencedModuleId = 0; sequencedModuleId < sequencedModuleDefines.length; ++ sequencedModuleId)
         {
            (mSequencedModules [sequencedModuleId] as SequencedModule).AdjustModuleSequencesTransformInPhysics (GetCurrentWorld ().GetCoordinateSystem ());
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
         
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
      }
      
      protected static function OnLoadImageError (image:ImageBitmap):void
      {
         //GetCurrentWorld ().SetBuildingStatus (-1);
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
      }
      
      protected static function OnLoadSoundDone (sound:Sound):void
      {  
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
      }
      
      protected static function OnLoadSoundError (sound:Sound):void
      {
         //GetCurrentWorld ().SetBuildingStatus (-1);
         //CheckWorldBuildingStatus (); // now called in World.GetBuildingStatus ()
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
            GetCurrentWorld ().SetBuildingStatus (0);
         }
         else
         {  
            //GetCurrentWorld ().UpdateImageModuleAppearances (); // bug for repainting module buttons
            
            GetCurrentWorld ().SetBuildingStatus (1);
         }
      }
      
      public static function ValiddateModuleIndex (index:int):int
      {
         if (isNaN (index) || index < 0 || index >= mNumTotalModules)
            return -1;
         
         return index;
      }
      
      public static function GetImageModuleByGlobalIndex (moduleId:int):Module
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
// instance
//==============================================================================
      
      public function Global ()
      {
      }
   }
}
