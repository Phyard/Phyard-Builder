
package common {
   
   import flash.utils.ByteArray;
   import flash.geom.Point;
   import flash.system.Capabilities;
   
   import editor.world.World;
   
   import editor.entity.Scene;
   
   import editor.entity.Entity;
   
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeImageModule;
   import editor.entity.EntityShapeImageModuleButton;
   
   import editor.entity.EntityVectorShape;
   import editor.entity.EntityVectorShapeArea;
   import editor.entity.EntityVectorShapePath;
   import editor.entity.EntityVectorShapeCircle;
   import editor.entity.EntityVectorShapeRectangle;
   import editor.entity.EntityVectorShapePolygon;
   import editor.entity.EntityVectorShapePolyline;
   import editor.entity.EntityVectorShapeText;
   import editor.entity.EntityVectorShapeTextButton;
   import editor.entity.EntityVectorShapeGravityController;
   
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointSpring;
   import editor.entity.EntityJointWeld;
   import editor.entity.EntityJointDummy;
   
   import editor.entity.SubEntityJointAnchor;
   
   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   import editor.entity.EntityUtilityPowerSource;
   
   //import editor.entity.EntityCollisionCategory;
   import editor.ccat.CollisionCategory;
   import editor.ccat.CollisionCategoryManager;
   
   import editor.image.AssetImage;
   import editor.image.AssetImageManager;
   import editor.image.AssetImageBitmapModule;
   import editor.image.AssetImagePureModule;
   import editor.image.AssetImagePureModuleManager;
   import editor.image.AssetImageCompositeModule;
   import editor.image.AssetImageCompositeModuleManager;
   import editor.image.AssetImageShapeModule;
   import editor.image.AssetImageNullModule;
   import editor.image.AssetImageDivision;
   import editor.image.AssetImageModule;
   import editor.image.AssetImageModuleInstance;
   import editor.image.AssetImageModuleInstanceManager;
   
   import common.shape.VectorShape;
   import common.shape.VectorShapePath;
   import common.shape.VectorShapeArea;
   import common.shape.VectorShapeCircle;
   import common.shape.VectorShapeRectangle;
   import common.shape.VectorShapePolygon;
   import common.shape.VectorShapePolyline;
   import common.shape.VectorShapeText;
   
   import editor.image.vector.VectorShapeForEditing;
   import editor.image.vector.VectorShapeCircleForEditing;
   import editor.image.vector.VectorShapeRectangleForEditing;
   import editor.image.vector.VectorShapePolygonForEditing;
   import editor.image.vector.VectorShapePolylineForEditing;
   import editor.image.vector.VectorShapeTextForEditing;
   
   import editor.sound.AssetSound;
   import editor.sound.AssetSoundManager;
   
   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityInputEntityScriptFilter;
   import editor.trigger.entity.EntityInputEntityPairScriptFilter;
   import editor.trigger.entity.EntityAction;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_TimerWithPrePostHandling;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_MouseGesture;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   import editor.trigger.entity.EntityEventHandler_JointReachLimit;
   import editor.trigger.entity.EntityEventHandler_ModuleLoopToEnd;
   import editor.trigger.entity.EntityEventHandler_GameLostOrGotFocus;
   
   //import editor.trigger.entity.EntityFunction;
   import editor.codelib.AssetFunction;
   import editor.codelib.CodeLibManager;
   
   import editor.trigger.VariableSpace;
   import editor.trigger.VariableInstance;
   
   import editor.EditorContext;
   
   import common.trigger.define.FunctionDefine;
   //import common.trigger.define.VariableSpaceDefine;
   
   import common.trigger.ValueSpaceTypeDefine;
   
   import common.trigger.CoreEventIds;
   
   public class DataFormat
   {
      
      
      
//===========================================================================
//   
//===========================================================================
      
      // create a world define from a editor world.
      // the created word define can be used to create either a player world or a editor world
      
      public static function EditorWorld2WorldDefine (editorWorld:World, currentScene:Scene = null, forSceneUndoPoint:Boolean = false):WorldDefine
      {
         if (editorWorld == null)
            return null;
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // basic
         {
            worldDefine.mVersion = Version.VersionNumber;
            
            worldDefine.mAuthorName = editorWorld.GetAuthorName ();
            worldDefine.mAuthorHomepage = editorWorld.GetAuthorHomepage ();
            
            //>>from v1.02
            worldDefine.mShareSourceCode = editorWorld.IsShareSourceCode ();
            worldDefine.mPermitPublishing = editorWorld.IsPermitPublishing ();
            //<<
            
            if (forSceneUndoPoint) // from v2.02
            {
               // assert (currentScene != null)
               worldDefine.mCurrentSceneId = currentScene.GetSceneIndex ();
            }
         }
         
         // scenes
         
         var numScenes:int = editorWorld.GetNumScenes ();
         
         for (var sceneId:int = 0; sceneId < numScenes; ++ sceneId)
         {
            var scene:Scene = editorWorld.GetSceneByIndex (sceneId);
            
            if (forSceneUndoPoint)
            {
               worldDefine.mSceneDefines.push (Scene2Define (editorWorld, scene, currentScene != scene));
            }
            else if (currentScene == null || currentScene == scene)
            {
               worldDefine.mSceneDefines.push (Scene2Define (editorWorld, scene));
            }
         }
         
         // ...
         worldDefine.mSimpleGlobalAssetDefines = forSceneUndoPoint; // from v2.01
         
         //>>from v1.58
         // image modules
         //{
            var assetImageManager:AssetImageManager = editorWorld.GetAssetImageManager ();
            var pureModuleManager:AssetImagePureModuleManager = editorWorld.GetAssetImagePureModuleManager ();
            var assembledModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageAssembledModuleManager ();
            var sequencedModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageSequencedModuleManager ();
            
            var numImages:int = assetImageManager.GetNumAssets ();
            for (var imageId:int = 0; imageId < numImages; ++ imageId)
            {
               var imageAsset:AssetImage = assetImageManager.GetAssetByAppearanceId (imageId) as AssetImage;
               
               if (forSceneUndoPoint)
               {
                  worldDefine.mImageDefines.push ({mKey: imageAsset.GetKey ()});
               }
               else
               {
                  var imageDefine:Object = new Object ();
                  
                  //>>from v2.01
                  imageDefine.mKey = imageAsset.GetKey ();
                  imageDefine.mTimeModified = imageAsset.GetTimeModified ();
                  //<<
                  
                  imageDefine.mName = imageAsset.GetName ();
                  imageDefine.mFileData = imageAsset.CloneBitmapFileData ();
                  
                  worldDefine.mImageDefines.push (imageDefine);
               }
            }
            
            var numDivisions:int = pureModuleManager.GetNumAssets ();
            for (var divisionId:int = 0; divisionId < numDivisions; ++ divisionId)
            {
               var imageDivison:AssetImageDivision = (pureModuleManager.GetAssetByAppearanceId (divisionId) as AssetImagePureModule).GetImageDivisionPeer ();
               
               if (forSceneUndoPoint)
               {
                  worldDefine.mPureImageModuleDefines.push ({mKey: imageDivison.GetKey ()});
               }
               else
               {
                  var divisionDefine:Object = new Object ();
                  
                  //>>from v2.01
                  divisionDefine.mKey = imageDivison.GetKey ();
                  divisionDefine.mTimeModified = imageDivison.GetTimeModified ();
                  //<<
                  
                  divisionDefine.mImageIndex = imageDivison.GetAssetImageId ();
                  divisionDefine.mLeft = imageDivison.GetLeft ();
                  divisionDefine.mTop = imageDivison.GetTop ();
                  divisionDefine.mRight = imageDivison.GetRight ();
                  divisionDefine.mBottom = imageDivison.GetBottom ();
                  
                  worldDefine.mPureImageModuleDefines.push (divisionDefine);
               }
            }
            
            var numAssembledModules:int = assembledModuleManager.GetNumAssets ();
            for (var assembledModuleId:int = 0; assembledModuleId < numAssembledModules; ++ assembledModuleId)
            {
               var assembledModule:AssetImageCompositeModule = assembledModuleManager.GetAssetByAppearanceId (assembledModuleId) as AssetImageCompositeModule;
               
               if (forSceneUndoPoint)
               {
                  worldDefine.mAssembledModuleDefines.push ({mKey: assembledModule.GetKey ()});
               }
               else
               {
                  var assembledModuleDefine:Object = new Object ();
                  
                  //>>from v2.01
                  assembledModuleDefine.mKey = assembledModule.GetKey ();
                  assembledModuleDefine.mTimeModified = assembledModule.GetTimeModified ();
                  //<<
                  
                  assembledModuleDefine.mModulePartDefines = ModuleInstances2Define (editorWorld, assembledModule.GetModuleInstanceManager (), false);
                  
                  worldDefine.mAssembledModuleDefines.push (assembledModuleDefine);
               }
            }
   
            var numSequencedModules:int = sequencedModuleManager.GetNumAssets ();
            for (var sequencedModuleId:int = 0; sequencedModuleId < numSequencedModules; ++ sequencedModuleId)
            {
               var sequencedModule:AssetImageCompositeModule = sequencedModuleManager.GetAssetByAppearanceId (sequencedModuleId) as AssetImageCompositeModule;
               
               if (forSceneUndoPoint)
               {
                  worldDefine.mSequencedModuleDefines.push ({mKey: sequencedModule.GetKey ()});
               }
               else
               {
                  var sequencedModuleDefine:Object = new Object ();
                  
                  //>>from v2.01
                  sequencedModuleDefine.mKey = sequencedModule.GetKey ();
                  sequencedModuleDefine.mTimeModified = sequencedModule.GetTimeModified ();
                  //<<
                  
                  //>>from v2.02
                  sequencedModuleDefine.mSettingFlags = sequencedModule.GetSettingFlags ();
                  //<<
                  
                  sequencedModuleDefine.mModuleSequenceDefines = ModuleInstances2Define (editorWorld, sequencedModule.GetModuleInstanceManager (), true);
                  
                  worldDefine.mSequencedModuleDefines.push (sequencedModuleDefine);
               }
            }
         //}
         //<<
         
         //>>from v1.59
         // sounds
         //{
            var assetSoundManager:AssetSoundManager = editorWorld.GetAssetSoundManager ();
            
            var numSounds:int = assetSoundManager.GetNumAssets ();
            for (var soundId:int = 0; soundId < numSounds; ++ soundId)
            {
               var soundAsset:AssetSound = assetSoundManager.GetAssetByAppearanceId (soundId) as AssetSound;
               
               if (forSceneUndoPoint)
               {
                  worldDefine.mSoundDefines.push ({mKey: soundAsset.GetKey ()});
               }
               else
               {
                  var soundDefine:Object = new Object ();
                  
                  //>>from v2.01
                  soundDefine.mKey = soundAsset.GetKey ();
                  soundDefine.mTimeModified = soundAsset.GetTimeModified ();
                  //<<
                  soundDefine.mName = soundAsset.GetName ();
                  soundDefine.mAttributeBits = soundAsset.GetSoundAttributeBits ();
                  soundDefine.mNumSamples = soundAsset.GetSoundNumSamples ();
                  soundDefine.mFileData = soundAsset.CloneSoundFileData ();
                  
                  worldDefine.mSoundDefines.push (soundDefine);
               }
            }
         //}
         //<<
         
         return worldDefine;
      }
      
      public static function Scene2Define (editorWorld:World, scene:Scene, onlyStoreKey:Boolean = false):SceneDefine
      {
         var sceneDefine:SceneDefine = new SceneDefine ();
         
         //>>from v2.0
         sceneDefine.mKey  = scene.GetKey ();
         if (onlyStoreKey)
            return sceneDefine;
         sceneDefine.mName = scene.GetName ();
         //<< 
         
         // ...
         
         // settings
         {
            //>>from v1.51
            sceneDefine.mSettings.mViewerUiFlags = scene.GetViewerUiFlags ();
            sceneDefine.mSettings.mPlayBarColor = scene.GetPlayBarColor ();
            sceneDefine.mSettings.mViewportWidth = scene.GetViewportWidth ();
            sceneDefine.mSettings.mViewportHeight = scene.GetViewportHeight ();
            sceneDefine.mSettings.mZoomScale = scene.GetZoomScale ();
            //<<
            
            //>>from v1.04
            sceneDefine.mSettings.mCameraCenterX = scene.GetCameraCenterX ();
            sceneDefine.mSettings.mCameraCenterY = scene.GetCameraCenterY ();
            sceneDefine.mSettings.mWorldLeft = scene.GetWorldLeft ();
            sceneDefine.mSettings.mWorldTop = scene.GetWorldTop ();
            sceneDefine.mSettings.mWorldWidth = scene.GetWorldWidth ();
            sceneDefine.mSettings.mWorldHeight = scene.GetWorldHeight ();
            sceneDefine.mSettings.mBackgroundColor = scene.GetBackgroundColor ();
            sceneDefine.mSettings.mBuildBorder = scene.IsBuildBorder ();
            sceneDefine.mSettings.mBorderColor = scene.GetBorderColor ();
            //<<
            
            //>>added from v1.06
            //>>removed from v1.08
            scene.StatisticsPhysicsShapes ();
            sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount = scene.GetPhysicsShapesPotentialMaxCount ();
            sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel = scene.GetPhysicsShapesPopulationDensityLevel ();
            //<<
            //<<
            
            //>>from v1.08
            sceneDefine.mSettings.mIsInfiniteWorldSize = scene.IsInfiniteSceneSize ();
            
            sceneDefine.mSettings.mBorderAtTopLayer = scene.IsBorderAtTopLayer ();
            sceneDefine.mSettings.mWorldBorderLeftThickness = scene.GetWorldBorderLeftThickness ();
            sceneDefine.mSettings.mWorldBorderTopThickness = scene.GetWorldBorderTopThickness ();
            sceneDefine.mSettings.mWorldBorderRightThickness = scene.GetWorldBorderRightThickness ();
            sceneDefine.mSettings.mWorldBorderBottomThickness = scene.GetWorldBorderBottomThickness ();
            
            sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude = scene.GetDefaultGravityAccelerationMagnitude ();
            sceneDefine.mSettings.mDefaultGravityAccelerationAngle     = scene.GetDefaultGravityAccelerationAngle ();
            
            sceneDefine.mSettings.mRightHandCoordinates   = scene.GetCoordinateSystem ().IsRightHand ();
            sceneDefine.mSettings.mCoordinatesOriginX     = scene.GetCoordinateSystem ().GetOriginX ();
            sceneDefine.mSettings.mCoordinatesOriginY     = scene.GetCoordinateSystem ().GetOriginY ();
            sceneDefine.mSettings.mCoordinatesScale       = scene.GetCoordinateSystem ().GetScale ();
            
            sceneDefine.mSettings.mIsCiRulesEnabled = scene.IsCiRulesEnabled ();
            //<<
            
            //>>from v1.55
            sceneDefine.mSettings.mAutoSleepingEnabled = scene.IsAutoSleepingEnabled ();
            sceneDefine.mSettings.mCameraRotatingEnabled = scene.IsCameraRotatingEnabled ();
            //<<
            
            //>>from v1.60
            sceneDefine.mSettings.mInitialSpeedX = scene.GetInitialSpeedX ();
            sceneDefine.mSettings.mPreferredFPS = scene.GetPreferredFPS ();
            sceneDefine.mSettings.mPauseOnFocusLost = scene.IsPauseOnFocusLost ();
            
            sceneDefine.mSettings.mPhysicsSimulationEnabled = scene.IsPhysicsSimulationEnabled ();
            sceneDefine.mSettings.mPhysicsSimulationStepTimeLength = scene.GetPhysicsSimulationStepTimeLength ();
            sceneDefine.mSettings.mPhysicsSimulationQuality = scene.GetPhysicsSimulationQuality ();
            sceneDefine.mSettings.mCheckTimeOfImpact = scene.IsCheckTimeOfImpact ();
            //<<
         }
         
         var numEntities:int = scene.GetNumAssets ();
         var appearId:int;
         var createId:int;
         var editorEntity:Entity;
         //var arraySortedByCreationId:Array = new Array ();
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            editorEntity = scene.GetAssetByCreationId (createId) as Entity;
            
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = Define.EntityType_Unkonwn; // default
            
            entityDefine.mPosX = editorEntity.GetPositionX ();
            entityDefine.mPosY = editorEntity.GetPositionY ();
            entityDefine.mRotation = editorEntity.GetRotation ();
            //>>from v1.58
            entityDefine.mScale = editorEntity.GetScale ();
            entityDefine.mIsFlipped = editorEntity.IsFlipped ();
            //<<
            entityDefine.mIsVisible = editorEntity.IsVisible ();
            
            //>>from v1.08
            entityDefine.mAlpha = editorEntity.GetAlpha ();
            entityDefine.mIsEnabled = editorEntity.IsEnabled ();
            //<<
            
            if (editorEntity is EntityUtility)
            {
               //>>from v1.05
                if (editorEntity is EntityUtilityCamera)
               {
                  entityDefine.mEntityType = Define.EntityType_UtilityCamera;
                  
                  var camera:EntityUtilityCamera = editorEntity as EntityUtilityCamera;
                  
                  //>>from v.108
                  entityDefine.mFollowedTarget = camera.GetFollowedTarget ();
                  entityDefine.mFollowingStyle = camera.GetFollowingStyle ();
                  //<<
               }
               //<<
               //>>from v1.10
               else if (editorEntity is EntityUtilityPowerSource)
               {
                  entityDefine.mEntityType = Define.EntityType_UtilityPowerSource;
                  
                  var powerSource:EntityUtilityPowerSource = editorEntity as EntityUtilityPowerSource;
                  
                  entityDefine.mPowerSourceType = powerSource.GetPowerSourceType ();
                  entityDefine.mPowerMagnitude = powerSource.GetPowerMagnitude ();
                  entityDefine.mKeyboardEventId = powerSource.GetKeyboardEventId ();
                  entityDefine.mKeyCodes = powerSource.GetKeyCodes ();
               }
               //<<
            }
            else if (editorEntity is EntityLogic) // from v1.07
            {
               var entityIndexArray:Array;
               
               if (editorEntity is EntityBasicCondition)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicCondition;
                  
                  var basicCondition:EntityBasicCondition = editorEntity as EntityBasicCondition;
                  
                  basicCondition.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, basicCondition.GetCodeSnippet ());
               }
               else if (editorEntity is EntityTask)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicTask;
                  
                  var task:EntityTask = editorEntity as EntityTask;
                  entityIndexArray = scene.AssetArray2AssetCreationIdArray (task.GetEntityAssigners ());
                  
                  entityDefine.mInputAssignerCreationIds = entityIndexArray;
               }
               else if (editorEntity is EntityConditionDoor)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicConditionDoor;
                  
                  var conditionDoor:EntityConditionDoor = editorEntity as EntityConditionDoor;
                  
                  entityDefine.mIsAnd = conditionDoor.IsAnd ();
                  entityDefine.mIsNot = conditionDoor.IsNot ();
                  TriggerFormatHelper.ConditionAndTargetValueArray2EntityDefineProperties (scene, conditionDoor.GetInputConditions (), entityDefine);
               }
               else if (editorEntity is EntityInputEntityAssigner)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityAssigner;
                  
                  var entityAssigner:EntityInputEntityAssigner = editorEntity as EntityInputEntityAssigner;
                  entityIndexArray = scene.AssetArray2AssetCreationIdArray (entityAssigner.GetInputEntities ());
                  
                  entityDefine.mSelectorType = entityAssigner.GetSelectorType ();
                  entityDefine.mNumEntities = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds = entityIndexArray;
               }
               else if (editorEntity is EntityInputEntityPairAssigner)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityPairAssigner;
                  
                  var pairAssigner:EntityInputEntityPairAssigner = editorEntity as EntityInputEntityPairAssigner;
                  
                  entityDefine.mPairingType = pairAssigner.GetPairingType ();
                  
                  var pairEntities:Array = pairAssigner.GetInputPairEntities ();
                  entityIndexArray = scene.AssetArray2AssetCreationIdArray (pairEntities [0]);
                  
                  entityDefine.mNumEntities1 = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds1 = entityIndexArray;
                  
                  entityIndexArray = scene.AssetArray2AssetCreationIdArray (pairEntities [1]);
                  
                  entityDefine.mNumEntities2 = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds2 = entityIndexArray;
               }
               else if (editorEntity is EntityEventHandler)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicEventHandler;
                  
                  var eventHandler:EntityEventHandler = editorEntity as EntityEventHandler;
                  entityIndexArray = scene.AssetArray2AssetCreationIdArray (eventHandler.GetEntityAssigners ());
                  
                  entityDefine.mEventId = eventHandler.GetEventId ();
                  
                  entityDefine.mInputConditionEntityCreationId = scene.GetAssetCreationId (eventHandler.GetInputConditionEntity () as Entity);
                  entityDefine.mInputConditionTargetValue = eventHandler.GetInputConditionTargetValue ();
                  
                  entityDefine.mInputAssignerCreationIds = entityIndexArray;
                  
                  //>>v1.08
                  entityDefine.mExternalActionEntityCreationId = scene.GetAssetCreationId (eventHandler.GetExternalAction ());
                  
                  if (editorEntity is EntityEventHandler_Timer)
                  {
                     var timerEventHandler:EntityEventHandler_Timer = eventHandler as EntityEventHandler_Timer;
                     
                     entityDefine.mRunningInterval = timerEventHandler.GetRunningInterval ();
                     entityDefine.mOnlyRunOnce = timerEventHandler.IsOnlyRunOnce ();
                     
                     //>>1.56
                     if (editorEntity is EntityEventHandler_TimerWithPrePostHandling)
                     {
                        var timerEventHandlerWithPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = eventHandler as EntityEventHandler_TimerWithPrePostHandling;
                        
                        timerEventHandlerWithPrePostHandling.GetPreCodeSnippet ().ValidateCallings ();
                        entityDefine.mPreFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, timerEventHandlerWithPrePostHandling.GetPreCodeSnippet (), false);
                        
                        timerEventHandlerWithPrePostHandling.GetPostCodeSnippet ().ValidateCallings ();
                        entityDefine.mPostFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, timerEventHandlerWithPrePostHandling.GetPostCodeSnippet (), false);
                     }
                     //<<
                  }
                  else if (editorEntity is EntityEventHandler_Keyboard)
                  {
                     var keyboardEventHandler:EntityEventHandler_Keyboard = eventHandler as EntityEventHandler_Keyboard;
                     
                     entityDefine.mKeyCodes = keyboardEventHandler.GetKeyCodes ();
                  }
                  else if (editorEntity is EntityEventHandler_MouseGesture)
                  {
                     var gestureEventHandler:EntityEventHandler_MouseGesture = eventHandler as EntityEventHandler_MouseGesture;
                     
                     entityDefine.mGestureIDs = gestureEventHandler.GetGestureIDs ();
                  }
                  else if (editorEntity is EntityEventHandler_Mouse)
                  {
                     var mouseEventHandler:EntityEventHandler_Mouse = eventHandler as EntityEventHandler_Mouse;
                  }
                  else if (editorEntity is EntityEventHandler_Contact)
                  {
                     var contactEventHandler:EntityEventHandler_Contact = eventHandler as EntityEventHandler_Contact;
                  }
                  else if (editorEntity is EntityEventHandler_JointReachLimit)
                  {
                     var jointReachLimitEventHandler:EntityEventHandler_JointReachLimit = eventHandler as EntityEventHandler_JointReachLimit;
                  }
                  else if (editorEntity is EntityEventHandler_ModuleLoopToEnd)
                  {
                     var moduleLoopToEndEventHandler:EntityEventHandler_ModuleLoopToEnd = eventHandler as EntityEventHandler_ModuleLoopToEnd;
                  }
                  else if (editorEntity is EntityEventHandler_GameLostOrGotFocus)
                  {
                     var gameLostOrGotFocusEventHandler:EntityEventHandler_GameLostOrGotFocus = eventHandler as EntityEventHandler_GameLostOrGotFocus;
                  }
                  //<<
                  
                  eventHandler.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, eventHandler.GetCodeSnippet ());
               }
               else if (editorEntity is EntityAction)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicAction;
                  
                  var action:EntityAction = editorEntity as EntityAction;
                  
                  action.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, action.GetCodeSnippet ());
               }
               //>>from v1.56
               else if (editorEntity is EntityInputEntityScriptFilter)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityFilter;
                  
                  var entityFilter:EntityInputEntityScriptFilter = editorEntity as EntityInputEntityScriptFilter;
                  
                  entityFilter.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, entityFilter.GetCodeSnippet ());
               }
               else if (editorEntity is EntityInputEntityPairScriptFilter)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityPairFilter;
                  
                  var entityPairFilter:EntityInputEntityPairScriptFilter = editorEntity as EntityInputEntityPairScriptFilter;
                  
                  entityPairFilter.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, entityPairFilter.GetCodeSnippet ());
               }
               //<<
            }
            else if (editorEntity is EntityVectorShape)
            {
               var vectorShape:EntityVectorShape = editorEntity as EntityVectorShape;
               
               //>>from v1.02
               entityDefine.mDrawBorder = vectorShape.IsDrawBorder ();
               entityDefine.mDrawBackground = vectorShape.IsDrawBackground ();
               //<<
               
               //>>from v1.04
               entityDefine.mBorderColor = vectorShape.GetBorderColor ();
               entityDefine.mBorderThickness = vectorShape.GetBorderThickness ();
               entityDefine.mBackgroundColor = vectorShape.GetFilledColor ();
               entityDefine.mTransparency = vectorShape.GetTransparency ();
               //<<
               
               //>>from v1.05
               entityDefine.mBorderTransparency = vectorShape.GetBorderTransparency ();
               //<<
               
               if (vectorShape.IsBasicVectorShapeEntity ())
               {
                  //>> move up from v1.04
                  entityDefine.mAiType = vectorShape.GetAiType ();
                  //<<
                  
                  //
                  RetrieveShapePhysicsProperties (entityDefine, vectorShape);
                  
                  //
                  
                  var vectorShapeData:VectorShape = vectorShape.GetVectorShape () as VectorShape;
                  
                  if (vectorShapeData is VectorShapePath)
                  {
                     //>>from v1.05
                     if (editorEntity is EntityVectorShapePolyline)
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapePolyline;
                        
                        entityDefine.mCurveThickness = (vectorShape as EntityVectorShapePolyline).GetCurveThickness ();
                        
                        //>> from v1.08
                        entityDefine.mIsRoundEnds = (vectorShape as EntityVectorShapePolyline).IsRoundEnds ();
                        //<<
                        //>> from v1.57
                        entityDefine.mIsClosed = (vectorShape as EntityVectorShapePolyline).IsClosed ();
                        //<<
                        
                        entityDefine.mLocalPoints = (vectorShape as EntityVectorShapePolyline).GetLocalVertexPoints ();
                     }
                     //<<
                  }
                  else if (vectorShapeData is VectorShapeArea)
                  {
                     if (editorEntity is EntityVectorShapeCircle)
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeCircle;
                        
                        entityDefine.mRadius = (vectorShape as EntityVectorShapeCircle).GetRadius ();
                        
                        entityDefine.mAppearanceType = (vectorShape as EntityVectorShapeCircle).GetAppearanceType ();
                     }
                     else if (editorEntity is EntityVectorShapeRectangle)
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeRectangle;
                        
                        entityDefine.mHalfWidth = (vectorShape as EntityVectorShapeRectangle).GetHalfWidth ();
                        entityDefine.mHalfHeight = (vectorShape as EntityVectorShapeRectangle).GetHalfHeight ();
                        
                        //from v1.08
                        entityDefine.mIsRoundCorners = (vectorShape as EntityVectorShapeRectangle).IsRoundCorners ();
                        //<<
                     }
                     //>>from v1.04
                     else if (editorEntity is EntityVectorShapePolygon)
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapePolygon;
                        
                        entityDefine.mLocalPoints = (vectorShape as EntityVectorShapePolygon).GetLocalVertexPoints ();
                     }
                     //<<
               
                     //>> from v1.60
                     entityDefine.mBodyTextureDefine = DataFormat2.Texture2TextureDefine (editorWorld.GetImageModuleIndex (vectorShapeData.GetBodyTextureModule () as AssetImageModule),
                                                                                              vectorShapeData.GetBodyTextureTransform ());
                     //<<
                  }
               }
               else // not physics entity
               {
                  //>>from v1.02
                  if (editorEntity is EntityVectorShapeText)
                  {
                     entityDefine.mText = (vectorShape as EntityVectorShapeText).GetText ();
                     
                     entityDefine.mHalfWidth = (vectorShape as EntityVectorShapeRectangle).GetHalfWidth ();
                     entityDefine.mHalfHeight = (vectorShape as EntityVectorShapeRectangle).GetHalfHeight ();
                     
                     entityDefine.mWordWrap = (vectorShape as EntityVectorShapeText).IsWordWrap ();
                     
                     //from v1.08
                     entityDefine.mAdaptiveBackgroundSize = (vectorShape as EntityVectorShapeText).IsAdaptiveBackgroundSize ();
                     entityDefine.mTextColor = (vectorShape as EntityVectorShapeText).GetTextColor ();
                     entityDefine.mFontSize = (vectorShape as EntityVectorShapeText).GetFontSize ();
                     entityDefine.mIsBold = (vectorShape as EntityVectorShapeText).IsBold ();
                     entityDefine.mIsItalic = (vectorShape as EntityVectorShapeText).IsItalic ();
                     //<<
                     
                     //from v1.09
                     entityDefine.mTextAlign = (vectorShape as EntityVectorShapeText).GetTextAlign ();
                     entityDefine.mIsUnderlined = (vectorShape as EntityVectorShapeText).IsUnderlined ();
                     //<<
                     
                     // from v1.08
                     if (editorEntity is EntityVectorShapeTextButton) 
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeTextButton;
                        
                        entityDefine.mUsingHandCursor = (vectorShape as EntityVectorShapeTextButton).UsingHandCursor ();
                        
                        var mouseOverShape:EntityVectorShape = (vectorShape as EntityVectorShapeTextButton).GetMouseOverShape ();
                        
                        entityDefine.mDrawBackground_MouseOver = mouseOverShape.IsDrawBackground ();
                        entityDefine.mBackgroundColor_MouseOver = mouseOverShape.GetFilledColor ();
                        entityDefine.mBackgroundTransparency_MouseOver = mouseOverShape.GetTransparency ();
                        
                        entityDefine.mDrawBorder_MouseOver = mouseOverShape.IsDrawBorder ();
                        entityDefine.mBorderColor_MouseOver = mouseOverShape.GetBorderColor ();
                        entityDefine.mBorderThickness_MouseOver = mouseOverShape.GetBorderThickness ();
                        entityDefine.mBorderTransparency_MouseOver = mouseOverShape.GetBorderTransparency ();
                     }
                     //<<
                     else
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeText;
                     }
                  }
                  else if (editorEntity is EntityVectorShapeGravityController)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeGravityController;
                     
                     entityDefine.mRadius = (vectorShape as EntityVectorShapeCircle).GetRadius ();
                     
                     // removed from v1.05
                     /////entityDefine.mIsInteractive = (vectorShape as EntityVectorShapeGravityController).IsInteractive ();
                     
                     // added in v1,05
                     entityDefine.mInteractiveZones = (vectorShape as EntityVectorShapeGravityController).GetInteractiveZones ();
                     entityDefine.mInteractiveConditions = (vectorShape as EntityVectorShapeGravityController).mInteractiveConditions;
                     
                     // ...
                     entityDefine.mInitialGravityAcceleration = (vectorShape as EntityVectorShapeGravityController).GetInitialGravityAcceleration ();
                     entityDefine.mInitialGravityAngle = (vectorShape as EntityVectorShapeGravityController).GetInitialGravityAngle ();
                     
                     //>> from v1,08
                     entityDefine.mMaximalGravityAcceleration = (vectorShape as EntityVectorShapeGravityController).GetMaximalGravityAcceleration ();
                     //<<
                  }
                  //<<
               }
            }
            //>> from v1.58
            else if (editorEntity is EntityShape)
            {
               var shape:EntityShape = editorEntity as EntityShape;
               
               if (editorEntity is EntityShapeImageModule)
               {
                  entityDefine.mEntityType = Define.EntityType_ShapeImageModule;
                  
                  RetrieveShapePhysicsProperties (entityDefine, editorEntity as EntityShapeImageModule);
                  
                  entityDefine.mModuleIndex = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModule).GetAssetImageModule ());
               }
               else if (editorEntity is EntityShapeImageModuleButton)
               {
                  entityDefine.mEntityType = Define.EntityType_ShapeImageModuleButton;
                  
                  RetrieveShapePhysicsProperties (entityDefine, editorEntity as EntityShapeImageModuleButton);
                  
                  entityDefine.mModuleIndexUp = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseUp ());
                  entityDefine.mModuleIndexOver = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseOver ());
                  entityDefine.mModuleIndexDown = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseDown ());
               }
            }
            //<<
            else if (editorEntity is EntityJoint)
            {
               var joint:EntityJoint = (editorEntity as EntityJoint);
               
               entityDefine.mCollideConnected = joint.mCollideConnected;
               
               //>>from v1.02
               entityDefine.mConnectedShape1Index = joint.GetConnectedShape1Index ();
               entityDefine.mConnectedShape2Index = joint.GetConnectedShape2Index ();
               //<<
               
               //>>from v1.08
               entityDefine.mBreakable = joint.IsBreakable ();
               //<<
               
               if (editorEntity is EntityJointHinge)
               {
                  var hinge:EntityJointHinge = editorEntity as EntityJointHinge;
                  
                  entityDefine.mEntityType = Define.EntityType_JointHinge;
                  entityDefine.mAnchorEntityIndex = scene.GetAssetCreationId ( hinge.GetAnchor () );
                  
                  entityDefine.mEnableLimits = hinge.IsLimitsEnabled ();
                  entityDefine.mLowerAngle = hinge.GetLowerLimit ();
                  entityDefine.mUpperAngle = hinge.GetUpperLimit ();
                  entityDefine.mEnableMotor = hinge.mEnableMotor;
                  entityDefine.mMotorSpeed = hinge.mMotorSpeed;
                  entityDefine.mBackAndForth = hinge.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorTorque = hinge.GetMaxMotorTorque ();
                  //<<
               }
               else if (editorEntity is EntityJointSlider)
               {
                  var slider:EntityJointSlider = editorEntity as EntityJointSlider;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSlider;
                  entityDefine.mAnchor1EntityIndex = scene.GetAssetCreationId ( slider.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = scene.GetAssetCreationId ( slider.GetAnchor2 () );
                  
                  entityDefine.mEnableLimits = slider.IsLimitsEnabled ();
                  entityDefine.mLowerTranslation = slider.GetLowerLimit ();
                  entityDefine.mUpperTranslation = slider.GetUpperLimit ();
                  entityDefine.mEnableMotor = slider.mEnableMotor;
                  entityDefine.mMotorSpeed = slider.mMotorSpeed;
                  entityDefine.mBackAndForth = slider.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorForce = slider.GetMaxMotorForce ();
                  //<<
               }
               else if (editorEntity is EntityJointDistance)
               {
                  var distanceJoint:EntityJointDistance = editorEntity as EntityJointDistance;
                  
                  entityDefine.mEntityType = Define.EntityType_JointDistance;
                  entityDefine.mAnchor1EntityIndex = scene.GetAssetCreationId ( distanceJoint.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = scene.GetAssetCreationId ( distanceJoint.GetAnchor2 () );
                  
                  //>>from v1.08
                  entityDefine.mBreakDeltaLength = distanceJoint.GetBreakDeltaLength ();
                  //<<
               }
               else if (editorEntity is EntityJointSpring)
               {
                  var spring:EntityJointSpring = editorEntity as EntityJointSpring;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSpring;
                  entityDefine.mAnchor1EntityIndex = scene.GetAssetCreationId ( spring.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = scene.GetAssetCreationId ( spring.GetAnchor2 () );
                  
                  entityDefine.mStaticLengthRatio = spring.GetStaticLengthRatio ();
                  //entityDefine.mFrequencyHz = spring.GetFrequencyHz ();
                  entityDefine.mSpringType = spring.GetSpringType ();
                  entityDefine.mDampingRatio = spring.mDampingRatio;
                  
                  //>>from v1.08
                  entityDefine.mFrequencyDeterminedManner = spring.GetFrequencyDeterminedManner ();
                  entityDefine.mFrequency = spring.GetFrequency ();
                  entityDefine.mSpringConstant = spring.GetSpringConstant ();
                  entityDefine.mBreakExtendedLength = spring.GetBreakExtendedLength ();
                  //<<
               }
               else if (editorEntity is EntityJointWeld)
               {
                  var weld:EntityJointWeld = editorEntity as EntityJointWeld;
                  
                  entityDefine.mEntityType = Define.EntityType_JointWeld;
                  entityDefine.mAnchorEntityIndex = scene.GetAssetCreationId ( weld.GetAnchor () );
               }
               else if (editorEntity is EntityJointDummy)
               {
                  var dummy:EntityJointDummy = editorEntity as EntityJointDummy;
                  
                  entityDefine.mEntityType = Define.EntityType_JointDummy;
                  entityDefine.mAnchor1EntityIndex = scene.GetAssetCreationId ( dummy.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = scene.GetAssetCreationId ( dummy.GetAnchor2 () );
               }
               
               if (joint != null)
               {
                  joint.UpdateJointPosition ();
               }
            }
            else if (editorEntity is SubEntityJointAnchor)
            {
               entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            
            sceneDefine.mEntityDefines.push (entityDefine);
            
            //arraySortedByCreationId.push ({entity:editorEntity, creationId:editorEntity.GetCreationOrderId ()});
         }
         
         // 
         //arraySortedByCreationId.sortOn ("creationId", Array.NUMERIC);
         //for (var arrayIndex:int = 0; arrayIndex < arraySortedByCreationId.length; ++ arrayIndex)
         //{
         //   editorEntity = arraySortedByCreationId [arrayIndex].entity;
         //   sceneDefine.mEntityAppearanceOrder.push (editorEntity.GetEntityIndex ());
         //}
         
         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
            editorEntity = scene.GetAssetByAppearanceId (appearId) as Entity;
            sceneDefine.mEntityAppearanceOrder.push (editorEntity.GetCreationOrderId ());
         }
         
         // 
         var brotherGroupArray:Array = scene.GetBrotherGroups ();
         var groupId:int;
         var brotherId:int;
         var brotherGroup:Array;
         
         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;
            
            if (brotherGroup == null)
            {
               trace ("brotherGroup == null");
               continue;
            }
            if (brotherGroup.length == 0)
            {
               trace ("blacnk group");
               continue;
            }
            if (brotherGroup.length < 2)
            {
               trace ("one entity group, id = " + scene.GetAssetCreationId (brotherGroup [brotherId] as Entity));
               continue;
            }
            
            var brotherIDs:Array = new Array (brotherGroup.length);
            for (brotherId = 0; brotherId < brotherGroup.length; ++ brotherId)
            {
               editorEntity = brotherGroup [brotherId] as Entity;
               brotherIDs [brotherId] = scene.GetAssetCreationId (editorEntity);
            }
            sceneDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         //>>fromv1.02
         // collision category
         {
            var numCats:int = scene.GetCollisionCategoryManager ().GetNumCollisionCategories ();
            
            for (var ccId:int = 0; ccId < numCats; ++ ccId)
            {
               var collisionCategory:CollisionCategory = scene.GetCollisionCategoryManager ().GetCollisionCategoryByIndex (ccId);
               
               var ccDefine:Object = new Object ();
               
               //>>from v2.01
               ccDefine.mKey = collisionCategory.GetKey ();
               ccDefine.mTimeModified = collisionCategory.GetTimeModified ();
               //<<
               
               ccDefine.mName = collisionCategory.GetCategoryName ();
               ccDefine.mCollideInternally = collisionCategory.IsCollideInternally ();
               ccDefine.mPosX = collisionCategory.GetPositionX ();
               ccDefine.mPosY = collisionCategory.GetPositionY ();
               
               sceneDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            sceneDefine.mDefaultCollisionCategoryIndex = scene.GetCollisionCategoryManager ().GetCollisionCategoryIndex (scene.GetCollisionCategoryManager ().GetDefaultCollisionCategory ());
            
            var ccFriendPairs:Array = scene.GetCollisionCategoryManager ().GetCollisionCategoryFriendPairs ();
            for (var pairId:int = 0; pairId < ccFriendPairs.length; ++ pairId)
            {
               var friendPair:Object = ccFriendPairs [pairId];
               
               var pairDefine:Object = new Object ();
               
               pairDefine.mCollisionCategory1Index = scene.GetCollisionCategoryManager ().GetCollisionCategoryIndex (friendPair.mCategory1);
               pairDefine.mCollisionCategory2Index = scene.GetCollisionCategoryManager ().GetCollisionCategoryIndex (friendPair.mCategory2);
               
               sceneDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         //<<
         
         //>>from v1.52
         // global variables and custom entity properties
         //{
            //>> from v1.57
            TriggerFormatHelper.VariableSpace2VariableDefines (scene, scene.GetCodeLibManager ().GetSessionVariableSpace (), sceneDefine.mSessionVariableDefines, true);
            //<<
            
            TriggerFormatHelper.VariableSpace2VariableDefines (scene, scene.GetCodeLibManager ().GetGlobalVariableSpace (), sceneDefine.mGlobalVariableDefines, true);
            
            TriggerFormatHelper.VariableSpace2VariableDefines (scene, scene.GetCodeLibManager ().GetEntityVariableSpace (), sceneDefine.mEntityPropertyDefines, true);
         //}
         //<< 
         
         //from v1.53
         // custom functions
         //{
            // packages
            
            // package variables
            
            // functions 
            
            var numFunctions:int = scene.GetCodeLibManager().GetNumFunctions ();
            for (var functionId:int = 0; functionId < numFunctions; ++ functionId)
            {
               var functionAsset:AssetFunction = scene.GetCodeLibManager().GetFunctionByIndex (functionId);
               
               functionAsset.GetCodeSnippet ().ValidateCallings ();
               var functionDefine:FunctionDefine = TriggerFormatHelper.Function2FunctionDefine (scene, functionAsset.GetCodeSnippet ());
               
               //>>from v2.01
               functionDefine.mKey = functionAsset.GetKey ();
               functionDefine.mTimeModified = functionAsset.GetTimeModified ();
               //<<
               
               functionDefine.mName = functionAsset.GetName ();
               functionDefine.mPosX = functionAsset.GetPositionX ();
               functionDefine.mPosY = functionAsset.GetPositionY ();
               
               //>>v1.56
               functionDefine.mDesignDependent = functionAsset.IsDesignDependent ();
               //<<
               
               sceneDefine.mFunctionDefines.push (functionDefine);
            }
         //}
         //<<
         
         // ...
         
         return sceneDefine;
      }
      
      public static function RetrieveShapePhysicsProperties (entityDefine:Object, entityShape:EntityShape):void
      {
         //>>from v1.04
         entityDefine.mIsPhysicsEnabled = entityShape.IsPhysicsEnabled ();
         /////entityDefine.mIsSensor = entityShape.mIsSensor; // move down from v1.05
         //<<
         
         //if (entityDefine.mIsPhysicsEnabled)  // always true before v1.04
         {
            //>>from v1.02
            entityDefine.mCollisionCategoryIndex = entityShape.GetCollisionCategoryIndex ();
            //<<
            
            //>> removed here, move up from v1.04
            /////entityDefine.mAiType = Define.GetShapeAiType (entityShape.GetFilledColor ()); // move up from v1.04
            //<<
            
            entityDefine.mIsStatic = entityShape.IsStatic ();
            entityDefine.mIsBullet = entityShape.mIsBullet;
            entityDefine.mDensity = entityShape.mDensity;
            entityDefine.mFriction = entityShape.mFriction;
            entityDefine.mRestitution = entityShape.mRestitution;
            
            // add in v1,04, move here from above since v1.05
            entityDefine.mIsSensor = entityShape.mIsSensor;
            
            //>>from v1.05
            entityDefine.mIsHollow = entityShape.IsHollow ();
            //<<
            
            //>>from v1.08
            entityDefine.mBuildBorder = entityShape.IsBuildBorder ();
            entityDefine.mIsSleepingAllowed = entityShape.IsAllowSleeping ();
            entityDefine.mIsRotationFixed = entityShape.IsFixRotation ();
            entityDefine.mLinearVelocityMagnitude = entityShape.GetLinearVelocityMagnitude ();
            entityDefine.mLinearVelocityAngle = entityShape.GetLinearVelocityAngle ();
            entityDefine.mAngularVelocity = entityShape.GetAngularVelocity ();
            //<<
         }
      }
      
      public static function ModuleInstances2Define (editorWorld:World, moduleInstanceManager:AssetImageModuleInstanceManager, forSequencedModule:Boolean):Array
      {
         var moduleInstanceDefines:Array = new Array ();
         
         var numModuleInstances:int = moduleInstanceManager.GetNumAssets ();
         for (var instanceId:int = 0; instanceId < numModuleInstances; ++ instanceId)
         {
            var moduleInstance:AssetImageModuleInstance = moduleInstanceManager.GetAssetByAppearanceId (instanceId) as AssetImageModuleInstance;
      
            var moduleInstanceDefine:Object = new Object ();
            
            moduleInstanceDefine.mVisible = moduleInstance.IsVisible ();
            moduleInstanceDefine.mAlpha = moduleInstance.GetAlpha ();
            moduleInstanceDefine.mPosX = moduleInstance.GetPositionX ();
            moduleInstanceDefine.mPosY = moduleInstance.GetPositionY ();
            moduleInstanceDefine.mScale = moduleInstance.GetScale ();
            moduleInstanceDefine.mIsFlipped = moduleInstance.IsFlipped ();
            moduleInstanceDefine.mRotation = moduleInstance.GetRotation ();
            
            if (forSequencedModule)
               moduleInstanceDefine.mModuleDuration = moduleInstance.GetDuration ();
            
            var imageModule:AssetImageModule = moduleInstance.GetAssetImageModule ();
            ModuleInstance2Define (moduleInstanceDefine, editorWorld, imageModule);
            
            moduleInstanceDefines.push (moduleInstanceDefine);
         }
         
         return moduleInstanceDefines;
      }
      
      public static function ModuleInstance2Define (moduleInstanceDefine:Object, editorWorld:World, imageModule:AssetImageModule):Object
      {
         moduleInstanceDefine.mModuleType = Define.EntityType_Unkonwn; // default, may be modified in following branches.
         
         if (imageModule is AssetImageShapeModule)
         {
            var vectorShape:VectorShape = (imageModule as AssetImageShapeModule).GetVectorShape () as VectorShape;
            
            moduleInstanceDefine.mShapeAttributeBits = vectorShape.GetAttributeBits ();
            moduleInstanceDefine.mShapeBodyOpacityAndColor = vectorShape.GetBodyOpacityAndColor (); // argb
            
            if (vectorShape is VectorShapePath)
            {
               var pathVectorShape:VectorShapePath = vectorShape as VectorShapePath;
               
               moduleInstanceDefine.mShapePathThickness = pathVectorShape.GetPathThickness ();
               
               if (vectorShape is VectorShapePolyline)
               {
                  var polylineShape:VectorShapePolyline = pathVectorShape as VectorShapePolyline;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapePolyline;
                  
                  moduleInstanceDefine.mPolyLocalPoints = polylineShape.GetLocalVertexPoints ();
               }
            }
            else if (vectorShape is VectorShapeArea)
            {
               var areaVectorShape:VectorShapeArea = vectorShape as VectorShapeArea;
               
               moduleInstanceDefine.mShapeBorderOpacityAndColor = areaVectorShape.GetBorderOpacityAndColor (); // argb
               moduleInstanceDefine.mShapeBorderThickness = areaVectorShape.GetBorderThickness ();
               
               if (vectorShape is VectorShapeCircle)
               {
                  var circleShape:VectorShapeCircle = areaVectorShape as VectorShapeCircle;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapeCircle;
                  
                  moduleInstanceDefine.mCircleRadius = circleShape.GetRadius ();
               }
               else if (vectorShape is VectorShapePolygon)
               {
                  var polygonShape:VectorShapePolygon = areaVectorShape as VectorShapePolygon;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapePolygon;
                  
                  moduleInstanceDefine.mPolyLocalPoints = polygonShape.GetLocalVertexPoints ();
               }
               else if (vectorShape is VectorShapeRectangle)
               {
                  var rectangleShape:VectorShapeRectangle = areaVectorShape as VectorShapeRectangle;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapeRectangle;
                  
                  moduleInstanceDefine.mRectHalfWidth = rectangleShape.GetHalfWidth ();
                  moduleInstanceDefine.mRectHalfHeight = rectangleShape.GetHalfHeight ();
                  
                  //if (vectorShape is VectorShapeText)
                  //{
                  //   moduleInstanceDefine.mModuleType = Define.EntityType_ShapeText;
                  //   
                  //   var textShape:VectorShapeText = vectorShape as VectorShapeText;
                  //}
                  //
                  //Text Shape 最好还是不从Rectangle继承下来。以后可以选择多种气泡背景，Rectangle只是其中之一。
                  //原点可以选在网格9个位置
               }
               
               //>> from v1.60
               moduleInstanceDefine.mBodyTextureDefine = DataFormat2.Texture2TextureDefine (editorWorld.GetImageModuleIndex (areaVectorShape.GetBodyTextureModule () as AssetImageModule),
                                                                                        areaVectorShape.GetBodyTextureTransform ());
               //<<
            }
         }
         else if (imageModule is AssetImageNullModule)
         {
            //moduleInstanceDefine.mModuleType = Define.EntityType_Unkonwn;
         }
         else
         {
            moduleInstanceDefine.mModuleType = Define.EntityType_ShapeImageModule;
            
            moduleInstanceDefine.mModuleIndex = editorWorld.GetImageModuleIndex (imageModule);
         }
         
         return moduleInstanceDefine;
      }
      
//==============================================================
//
//==============================================================
      
      public static function ModuleInstanceDefinesToModuleInstances (moduleInstanceDefines:Array, imageModuleRefIndex_CorrectionTable:Array, editorWorld:World, moduleInstanceManager:AssetImageModuleInstanceManager, forSequencedModule:Boolean):void
      {
         for each (var moduleInstanceDefine:Object in moduleInstanceDefines)
         {
            var moduleInstance:AssetImageModuleInstance = moduleInstanceManager.CreateImageModuleInstance (
                                                           ModuleInstanceDefineToModuleInstance (moduleInstanceDefine, imageModuleRefIndex_CorrectionTable, editorWorld)
                                                        );
             
            moduleInstance.SetVisible (moduleInstanceDefine.mVisible);
            moduleInstance.SetAlpha (moduleInstanceDefine.mAlpha);
            moduleInstance.SetPosition (moduleInstanceDefine.mPosX, moduleInstanceDefine.mPosY);
            moduleInstance.SetScale (moduleInstanceDefine.mScale);
            moduleInstance.SetFlipped (moduleInstanceDefine.mIsFlipped);
            moduleInstance.SetRotation (moduleInstanceDefine.mRotation);
            
            if (forSequencedModule)
            {
               moduleInstance.SetDuration (moduleInstanceDefine.mModuleDuration);
            }
            
            // ...
            moduleInstance.UpdateAppearance ();
            moduleInstance.UpdateSelectionProxy ();
         }
      }
      
      public static function ModuleInstanceDefineToModuleInstance (moduleInstanceDefine:Object, imageModuleRefIndex_CorrectionTable:Array, editorWorld:World):AssetImageModule
      {
         var imageModule:AssetImageModule = null;
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            var vectorShape:VectorShape = null;
            
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
            {
               var pathVectorShape:VectorShapePath = null;
               
               // polyline
               //{
                  var polylineShape:VectorShapePolylineForEditing = new VectorShapePolylineForEditing ();
                  
                  polylineShape.SetLocalVertexPoints (moduleInstanceDefine.mPolyLocalPoints);
                  
                  pathVectorShape = polylineShape as VectorShapePath;
               //}
               
               if (pathVectorShape != null)
               {
                  pathVectorShape.SetPathThickness (moduleInstanceDefine.mShapePathThickness);
               }
               
               vectorShape = pathVectorShape;
            }
            else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle
                  || moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon
                  || moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle
               )
            {
               var areaVectorShape:VectorShapeArea = null;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  var circleShape:VectorShapeCircleForEditing = new VectorShapeCircleForEditing ();
                  
                  circleShape.SetRadius (moduleInstanceDefine.mCircleRadius);
                  
                  areaVectorShape = circleShape as VectorShapeArea;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  var polygonShape:VectorShapePolygonForEditing = new VectorShapePolygonForEditing ();
                  
                  polygonShape.SetLocalVertexPoints (moduleInstanceDefine.mPolyLocalPoints);
                  
                  areaVectorShape = polygonShape as VectorShapeArea;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  var rectangleShape:VectorShapeRectangleForEditing = new VectorShapeRectangleForEditing ();
                  
                  rectangleShape.SetHalfWidth (moduleInstanceDefine.mRectHalfWidth);
                  rectangleShape.SetHalfHeight (moduleInstanceDefine.mRectHalfHeight);
                  
                  areaVectorShape = rectangleShape as VectorShapeArea;
               }

               if (areaVectorShape != null)
               {
                  areaVectorShape.SetBorderOpacityAndColor (moduleInstanceDefine.mShapeBorderOpacityAndColor); // argb
                  areaVectorShape.SetBorderThickness (moduleInstanceDefine.mShapeBorderThickness);
                  
                  //>> from v1.60
                  SetShapeBodyTexture (editorWorld, areaVectorShape, moduleInstanceDefine.mBodyTextureDefine, imageModuleRefIndex_CorrectionTable);
                  //<<
               }
               
               vectorShape = areaVectorShape;
            }

            
            if (vectorShape != null)
            {
               vectorShape.SetAttributeBits (moduleInstanceDefine.mShapeAttributeBits);
               vectorShape.SetBodyOpacityAndColor (moduleInstanceDefine.mShapeBodyOpacityAndColor); // argb

               imageModule = new AssetImageShapeModule (vectorShape as VectorShapeForEditing);
            }
         }
         else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
         {
            if (moduleInstanceDefine.mModuleIndex >= 0)
            {
               moduleInstanceDefine.mModuleIndex = imageModuleRefIndex_CorrectionTable [moduleInstanceDefine.mModuleIndex];
               imageModule = editorWorld.GetImageModuleByIndex (moduleInstanceDefine.mModuleIndex);
            }
         }
         
         if (imageModule == null)
            imageModule = new AssetImageNullModule ();
      
         return imageModule;
      }
      
      public static function SetShapeEntityBodyTexture (editorWorld:World, areaVectorShapeEntity:EntityVectorShapeArea, textureDefine:Object, imageModuleRefIndex_CorrectionTable:Array):void
      {
         if (textureDefine.mModuleIndex >= 0)
         {
            textureDefine.mModuleIndex = imageModuleRefIndex_CorrectionTable [textureDefine.mModuleIndex];
            
            areaVectorShapeEntity.SetBodyTextureModule (editorWorld.GetImageModuleByIndex (textureDefine.mModuleIndex) as AssetImageBitmapModule);
            areaVectorShapeEntity.SetBodyTextureTransform (new Transform2D (textureDefine.mPosX, textureDefine.mPosY, 
                                                     textureDefine.mScale, textureDefine.mIsFlipped, textureDefine.mRotation));
         }
      }
      
      public static function SetShapeBodyTexture (editorWorld:World, areaVectorShape:VectorShapeArea, textureDefine:Object, imageModuleRefIndex_CorrectionTable:Array):void
      {
         if (textureDefine.mModuleIndex >= 0)
         {
            textureDefine.mModuleIndex = imageModuleRefIndex_CorrectionTable [textureDefine.mModuleIndex];
            
            areaVectorShape.SetBodyTextureModule (editorWorld.GetImageModuleByIndex (textureDefine.mModuleIndex) as AssetImageBitmapModule);
            areaVectorShape.SetBodyTextureTransform (new Transform2D (textureDefine.mPosX, textureDefine.mPosY, 
                                                     textureDefine.mScale, textureDefine.mIsFlipped, textureDefine.mRotation));
         }
      }
      
      public static function SetShapePhysicsProperties (shape:EntityShape, entityDefine:Object, ccatRefIndex_CorrectionTable:Array):void
      {
         //>>from v1.04
         shape.SetPhysicsEnabled (entityDefine.mIsPhysicsEnabled);
         /////shape.mIsSensor = entityDefine.mIsSensor; // move down from v1.05
         //<<
         
         if (entityDefine.mIsPhysicsEnabled) // always true before v1.04
         {
            //>>from v1.02
            if (entityDefine.mCollisionCategoryIndex >= 0)
               shape.SetCollisionCategoryIndex (ccatRefIndex_CorrectionTable [int(entityDefine.mCollisionCategoryIndex)]);
            else
               shape.SetCollisionCategoryIndex (entityDefine.mCollisionCategoryIndex);
            //<<
            
            shape.SetStatic (entityDefine.mIsStatic);
            shape.mIsBullet = entityDefine.mIsBullet;
            shape.mDensity = entityDefine.mDensity;
            shape.mFriction = entityDefine.mFriction;
            shape.mRestitution = entityDefine.mRestitution;
            
            // add in v1,04, move here from above from v1.05
            shape.mIsSensor = entityDefine.mIsSensor;
            
            //>>from v1.05
            shape.SetHollow (entityDefine.mIsHollow);
            //<<
            
            //>>from v1.08
            shape.SetBuildBorder (entityDefine.mBuildBorder);
            shape.SetAllowSleeping (entityDefine.mIsSleepingAllowed);
            shape.SetFixRotation (entityDefine.mIsRotationFixed);
            shape.SetLinearVelocityMagnitude (entityDefine.mLinearVelocityMagnitude);
            shape.SetLinearVelocityAngle (entityDefine.mLinearVelocityAngle);
            shape.SetAngularVelocity (entityDefine.mAngularVelocity);
            //<<
         }
      }
      
      public static function WorldDefine2EditorWorld (isNewWorldToLoadAll:Boolean, editorWorld:editor.world.World, worldDefine:WorldDefine,
                                                      /*isNewWorldToLoadAll:Boolean*/scene:Scene = null, 
                                                      adjustPrecisionsInWorldDefine:Boolean = true, 
                                                      mergeVariablesWithSameNames:Boolean = false,
                                                      policyOnConflictingGlobalAssets:int = 0, // 0: determined by modified time. 1: keep current. 2: override. 3: create new
                                                      policyOnConflictingSceneAssets:int = 0   // 0: determined by modified time. 1: keep current. 2: override. 3: create new
                                                      ):Array
      {
         if (! worldDefine.mSimpleGlobalAssetDefines) // from v2.01, many fields may be missed.
         {
            // from v1,03
            DataFormat2.FillMissedFieldsInWorldDefine (worldDefine);
            if (adjustPrecisionsInWorldDefine)
               DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         }
         
         // ...
         
         if (isNewWorldToLoadAll)
         {
            //editorWorld = new editor.world.World ();
            
            // basic
            {
               editorWorld.SetAuthorName (worldDefine.mAuthorName);
               editorWorld.SetAuthorHomepage (worldDefine.mAuthorHomepage);
               
               editorWorld.SetShareSourceCode (worldDefine.mShareSourceCode);
               editorWorld.SetPermitPublishing (worldDefine.mPermitPublishing);
            }
         }
         
         // ...
         
         var toUseNewData:Boolean;
         
         //>> from v1.58
         // iamge modules
         //{
            var assetImageManager:AssetImageManager = editorWorld.GetAssetImageManager ();
            var pureModuleManager:AssetImagePureModuleManager = editorWorld.GetAssetImagePureModuleManager ();
            var assembledModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageAssembledModuleManager ();
            var sequencedModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageSequencedModuleManager ();
            
            //var oldNumImageModules:int = assetImageManager.GetNumAssets ();
            //var oldNumImageDivisions:int = pureModuleManager.GetNumAssets ();
            //var oldNumAssembledModules:int = assembledModuleManager.GetNumAssets ();
            //var oldNumSequencedModules:int = sequencedModuleManager.GetNumAssets ();
            
            var imageId:int;
            var divisionId:int;
            var assembledModuleId:int;
            var sequencedModuleId:int;
            
            var imageDefine:Object;
            var divisionDefine:Object;
            var assembledModuleDefine:Object;
            var sequencedModuleDefine:Object;
            
            var imageAsset:AssetImage;
            var pureModule:AssetImagePureModule;
               var imageDivision:AssetImageDivision;
            var assembledModule:AssetImageCompositeModule;
            var sequencedModule:AssetImageCompositeModule;
            
            var deltaNumImageModules:int = worldDefine.mImageDefines.length;
            var deltaNumImageDivisions:int = worldDefine.mPureImageModuleDefines.length;
            var deltaNumAssembledModules:int = worldDefine.mAssembledModuleDefines.length;
            var deltaNumSequencedModules:int = worldDefine.mSequencedModuleDefines.length;
            
            var imageModuleRefIndex_CorrectionTable:Array = new Array (deltaNumImageModules + deltaNumImageDivisions + deltaNumAssembledModules + deltaNumSequencedModules);;
            var moduleId:int = 0;
            
            // 
            for (imageId = 0; imageId < deltaNumImageModules; ++ imageId)
            {
               imageDefine = worldDefine.mImageDefines [imageId];
               
               // mKey & mTimeModified are from v2.01

               imageAsset = assetImageManager.GetAssetByKey (imageDefine.mKey) as AssetImage;
               
               if (worldDefine.mSimpleGlobalAssetDefines) // from v2.01 for undo scene
               {
                  toUseNewData = false;
               }
               else if (imageAsset == null) // before v2.01
               {
                  toUseNewData = true;
                  
                  imageAsset = assetImageManager.CreateImage (imageDefine.mKey);
               }
               else if (policyOnConflictingGlobalAssets == 3) // always create new
               {
                  toUseNewData = true;
                  
                  imageAsset = assetImageManager.CreateImage (null);
               }
               else if (policyOnConflictingGlobalAssets == 2) // override
               {
                  toUseNewData = true;
               }
               else if (policyOnConflictingGlobalAssets == 1) // skip
               {
                  toUseNewData = false;
               }
               else // if (policyOnConflictingGlobalAssets == 0) // auto
               {
                  toUseNewData = imageDefine.mTimeModified > imageAsset.GetTimeModified ();
               }
               
               if (toUseNewData)
               {
                  imageAsset.OnLoadLocalImageFinished (imageDefine.mFileData, imageDefine.mName);
                  
                  imageAsset.SetTimeModified (imageDefine.mTimeModified);
               }
               
               if (imageAsset != null)
                  imageDefine.mKey = imageAsset.GetKey ();
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = editorWorld.GetImageModuleIndex (imageAsset);
            }
            
            //
            for (divisionId = 0; divisionId < deltaNumImageDivisions; ++ divisionId)
            { 
               divisionDefine = worldDefine.mPureImageModuleDefines [divisionId];
               
               // mKey & mTimeModified are from v2.01
               
               if (divisionDefine.mImageIndex < 0) // generally should not
               {
                  pureModule = null;
               }
               else
               {
                  divisionDefine.mImageIndex = imageModuleRefIndex_CorrectionTable [divisionDefine.mImageIndex];
                  
                  pureModule = pureModuleManager.GetAssetByKey (divisionDefine.mKey) as AssetImagePureModule;
                  
                  if (worldDefine.mSimpleGlobalAssetDefines) // from v2.01 for undo scene
                  {
                     toUseNewData = false;
                  }
                  else if (pureModule == null || policyOnConflictingGlobalAssets == 3) // before v2.01
                  {
                     //toUseNewData = true;
                     toUseNewData = false;
                     
                     imageDivision = (assetImageManager.GetAssetByAppearanceId (divisionDefine.mImageIndex) as AssetImage)
                                                .GetAssetImageDivisionManager ().CreateImageDivision (
                                                   pureModule != null ? null : divisionDefine.mKey, 
                                                   divisionDefine.mLeft, divisionDefine.mTop, divisionDefine.mRight, divisionDefine.mBottom,
                                                   false, pureModuleManager
                                                );
                     imageDivision.SetTimeModified (divisionDefine.mTimeModified);
                     pureModule = imageDivision.GetImagePureModulePeer ();
                  }
                  //else if (policyOnConflictingGlobalAssets == 3) // always create new (move to above)
                  //{
                  //}
                  //>> !!! generally impossible
                  else if (editorWorld.GetImageModuleByIndex (divisionDefine.mImageIndex) != pureModule.GetImageDivisionPeer ().GetAssetImage ())
                  {
                     toUseNewData = false;
                  }
                  //<<<
                  else if (policyOnConflictingGlobalAssets == 2) // override
                  {
                     toUseNewData = true;
                  }
                  else if (policyOnConflictingGlobalAssets == 1) // skip
                  {
                     toUseNewData = false;
                  }
                  else // if (policyOnConflictingGlobalAssets == 0) // auto
                  {
                     toUseNewData = divisionDefine.mTimeModified > pureModule.GetTimeModified ();
                  }
                  
                  if (toUseNewData)
                  {
                     imageDivision = pureModule.GetImageDivisionPeer ();
                     imageDivision.SetRegion (divisionDefine.mLeft, divisionDefine.mTop, divisionDefine.mRight, divisionDefine.mBottom);
                     
                     imageDivision.SetTimeModified (divisionDefine.mTimeModified);
                  }
               }
               
               if (pureModule!= null)
                  divisionDefine.mKey = pureModule.GetKey ();
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = editorWorld.GetImageModuleIndex (pureModule);
            }
            
            for (assembledModuleId = 0; assembledModuleId < deltaNumAssembledModules; ++ assembledModuleId)
            {
               assembledModuleDefine = worldDefine.mAssembledModuleDefines [assembledModuleId];
               
               // mKey & mTimeModified are from v2.01

               assembledModule = assembledModuleManager.GetAssetByKey (assembledModuleDefine.mKey) as AssetImageCompositeModule;
               
               if (worldDefine.mSimpleGlobalAssetDefines) // from v2.01 for undo scene
               {
                  toUseNewData = false;
               }
               else if (assembledModule == null) // from v2.01
               {
                  toUseNewData = true;
                  
                  assembledModule = assembledModuleManager.CreateImageCompositeModule (assembledModuleDefine.mKey);
               }
               else if (policyOnConflictingGlobalAssets == 3) // always create new
               {
                  toUseNewData = true;
                  
                  assembledModule = assembledModuleManager.CreateImageCompositeModule (null);
               }
               else if (policyOnConflictingGlobalAssets == 2) // 
               {
                  toUseNewData = true;
                  
                  assembledModule.GetModuleInstanceManager ().DestroyAllAssets ();
               }
               else if (policyOnConflictingGlobalAssets == 1)
               {
                  toUseNewData = false;
               }
               else // if (policyOnConflictingGlobalAssets == 0)
               {
                  toUseNewData = assembledModuleDefine.mTimeModified > assembledModule.GetTimeModified ();
                  
                  if (toUseNewData)
                  {
                     assembledModule.GetModuleInstanceManager ().DestroyAllAssets ();
                  }
               }
               
               assembledModuleDefine.mToLoadNewData = toUseNewData;
               
               if (assembledModule != null)
                  assembledModuleDefine.mKey = assembledModule.GetKey ();
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = editorWorld.GetImageModuleIndex (assembledModule);
            }
            
            for (sequencedModuleId = 0; sequencedModuleId < deltaNumSequencedModules; ++ sequencedModuleId)
            {
               sequencedModuleDefine = worldDefine.mSequencedModuleDefines [sequencedModuleId];
               
               // mKey & mTimeModified are from v2.01

               sequencedModule = sequencedModuleManager.GetAssetByKey (sequencedModuleDefine.mKey) as AssetImageCompositeModule;
               
               if (worldDefine.mSimpleGlobalAssetDefines) // from v2.01 for undo scene
               {
                  toUseNewData = false;
               }
               else if (sequencedModule == null) // before v2.01
               {
                  toUseNewData = true;
                  
                  sequencedModule = sequencedModuleManager.CreateImageCompositeModule (sequencedModuleDefine.mKey);
               }
               else if (policyOnConflictingGlobalAssets == 3) // always create new
               {
                  toUseNewData = true;
                  
                  sequencedModule = sequencedModuleManager.CreateImageCompositeModule (null);
               }
               else if (policyOnConflictingGlobalAssets == 2) // override
               {
                  toUseNewData = true;
                  
                  sequencedModule.GetModuleInstanceManager ().DestroyAllAssets ();
               }
               else if (policyOnConflictingGlobalAssets == 1) // skip
               {
                  toUseNewData = false;
               }
               else // if (policyOnConflictingGlobalAssets == 0) // auto
               {
                  toUseNewData = sequencedModuleDefine.mTimeModified > sequencedModule.GetTimeModified ();
                  
                  if (toUseNewData)
                  {
                     sequencedModule.GetModuleInstanceManager ().DestroyAllAssets ();
                  }
               }
               
               sequencedModuleDefine.mToLoadNewData = toUseNewData;
               
               if (sequencedModule != null)
                  sequencedModuleDefine.mKey = sequencedModule.GetKey ();
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = editorWorld.GetImageModuleIndex (sequencedModule);
            }
            
            for (assembledModuleId = 0; assembledModuleId < deltaNumAssembledModules; ++ assembledModuleId)
            {
               assembledModuleDefine = worldDefine.mAssembledModuleDefines [assembledModuleId];
               
               if (assembledModuleDefine.mToLoadNewData)
               {
                  assembledModule = assembledModuleManager.GetAssetByKey (assembledModuleDefine.mKey) as AssetImageCompositeModule;
   
                  ModuleInstanceDefinesToModuleInstances (assembledModuleDefine.mModulePartDefines, imageModuleRefIndex_CorrectionTable, editorWorld, assembledModule.GetModuleInstanceManager (), false);
                  
                  assembledModule.SetTimeModified (assembledModuleDefine.mTimeModified);
                  
                  assembledModule.UpdateAppearance ();
               }
            }
   
            for (sequencedModuleId = 0; sequencedModuleId < deltaNumSequencedModules; ++ sequencedModuleId)
            {
               sequencedModuleDefine = worldDefine.mSequencedModuleDefines [sequencedModuleId];
               
               if (sequencedModuleDefine.mToLoadNewData)
               {
                  sequencedModule = sequencedModuleManager.GetAssetByKey (sequencedModuleDefine.mKey) as AssetImageCompositeModule;
                  
                  //>>from v2.02
                  sequencedModule.SetSettingFlags (sequencedModuleDefine.mSettingFlags);
                  //<<
   
                  ModuleInstanceDefinesToModuleInstances (sequencedModuleDefine.mModuleSequenceDefines, imageModuleRefIndex_CorrectionTable, editorWorld, sequencedModule.GetModuleInstanceManager (), true);
                  
                  sequencedModule.SetTimeModified (sequencedModuleDefine.mTimeModified);
                  
                  sequencedModule.UpdateAppearance ();
               }
            }
         //}
         //<<
         
         //>>from v1.59
         // sounds
         //{
            var assetSoundManager:AssetSoundManager = editorWorld.GetAssetSoundManager ();

            //var beginningSoundIndex:int = assetSoundManager.GetNumAssets ();
   
            var soundRefIndex_CorrectionTable:Array = new Array (worldDefine.mSoundDefines.length);
      
            for (var soundId:int = 0; soundId < worldDefine.mSoundDefines.length; ++ soundId)
            {
               var soundDefine:Object = worldDefine.mSoundDefines [soundId];
               
               // mKey & mTimeModified are from v2.01

               var soundAsset:AssetSound = assetSoundManager.GetAssetByKey (soundDefine.mKey) as AssetSound;
               
               if (worldDefine.mSimpleGlobalAssetDefines) // from v2.01 for undo scene
               {
                  toUseNewData = false;
               }
               else if (soundAsset == null) // before v2.01
               {
                  toUseNewData = true;
                  
                  soundAsset = assetSoundManager.CreateSound (soundDefine.mKey);
               }
               else if (policyOnConflictingGlobalAssets == 3) // always create new
               {
                  toUseNewData = true;
                  
                  soundAsset = assetSoundManager.CreateSound (null);
               }
               else if (policyOnConflictingGlobalAssets == 2) // override
               {
                  toUseNewData = true;
               }
               else if (policyOnConflictingGlobalAssets == 1) // skip
               {
                  toUseNewData = false;
               }
               else // if (policyOnConflictingGlobalAssets == 0) .. auto
               {
                  toUseNewData = soundDefine.mTimeModified > soundAsset.GetTimeModified ();
               }
               
               if (toUseNewData)
               {
                  soundAsset.SetName (soundDefine.mName);
                  soundAsset.SetSoundAttributeBits (soundDefine.mAttributeBits);
                  soundAsset.SetSoundNumSamples (soundDefine.mNumSamples);
                  soundAsset.SetSoundFileData (soundDefine.mFileData);
                  soundAsset.SetTimeModified (soundDefine.mTimeModified);
   
                  soundAsset.UpdateAppearance ();
               }
               
               if (soundAsset != null)
                  soundDefine.mKey = soundAsset.GetKey ();
               
               soundRefIndex_CorrectionTable [soundId] = editorWorld.GetSoundIndex (soundAsset);
            }
         //}
         //<<

         // scenes
         
         var sceneRefIndex_CorrectionTable:Array = new Array (worldDefine.mSceneDefines.length);
         
         var newCreatedScenes:Array = null;
         
         var sceneId:int;
         var sceneDefine:SceneDefine;
         
         if (scene != null) // uodo scene or import into scene
         {
            //sceneRefIndex_CorrectionTable [0] = editorWorld.GetNumScenes ();
            sceneRefIndex_CorrectionTable [worldDefine.mCurrentSceneId] = scene.GetSceneIndex ();

            for (sceneId = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
            {
               if (sceneId != worldDefine.mCurrentSceneId)
               {
                  sceneDefine = worldDefine.mSceneDefines [sceneId];
                  
                  var tempScene:Scene = editorWorld.GetSceneByKey (sceneDefine.mKey);
                  sceneRefIndex_CorrectionTable [sceneId] = (tempScene == null ? - 1 : tempScene.GetSceneIndex ());
               }
            }
            
            //sceneDefine = worldDefine.mSceneDefines [0];
            sceneDefine = worldDefine.mSceneDefines [worldDefine.mCurrentSceneId];

            // worldDefine.mSimpleGlobalAssetDefines == true means uodo scene
            SceneDefine2Scene (editorWorld, sceneDefine, worldDefine.mSimpleGlobalAssetDefines, scene, mergeVariablesWithSameNames, policyOnConflictingSceneAssets, 
                               imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable); // here editorWorld.GetNumScenes () will make the scene references as null
         }
         else // load world or import scenes
         {
            //var beginningSceneIndex:int = editorWorld.GetNumScenes ();
            
            newCreatedScenes = new Array ();
            
            var newSceneId:int;
            var newScene:Scene;
            
            for (sceneId = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
            {
               sceneDefine = worldDefine.mSceneDefines [sceneId];
               newSceneId = editorWorld.CreateNewScene (sceneDefine.mKey, sceneDefine.mName); // for versions ealier than v2.00, sceneDefine.mKey is undefined
               newScene = editorWorld.GetSceneByIndex (newSceneId);
               
               sceneDefine.mKey = newScene.GetKey ();
               
               sceneRefIndex_CorrectionTable [sceneId] = newSceneId;
            }
            
            for (sceneId = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
            {
               sceneDefine = worldDefine.mSceneDefines [sceneId];
               
               newSceneId = sceneRefIndex_CorrectionTable [sceneId];
               newScene   = editorWorld.GetSceneByIndex (newSceneId);
               
               try
               {
                  SceneDefine2Scene (editorWorld, worldDefine.mSceneDefines [sceneId], true, newScene, /*mergeVariablesWithSameNames*/false, policyOnConflictingSceneAssets, 
                                  imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  
                  newCreatedScenes.push (newScene);
               }
               catch (error:Error)
               {
                  if (Capabilities.isDebugger)
                     throw error;
                  
                  // editorWorld.DeleteSceneByIndex (newSceneId, false); // move to bwlow to avoid scene index mis-align
                  
                  newCreatedScenes.push (null);
                  
                  EditorContext.mPauseCreateShapeProxy = false; // !!!
               }
            }
            
            for (sceneId = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
            {
               newSceneId = sceneRefIndex_CorrectionTable [sceneId];
               if (newCreatedScenes [sceneId] == null)
               {
                  sceneRefIndex_CorrectionTable [sceneId] = -1;
                  editorWorld.DeleteSceneByIndex (newSceneId, false);
               }
            }
            
            if (isNewWorldToLoadAll && editorWorld.GetNumScenes () > 1)
            {
               editorWorld.DeleteSceneByIndex (0, false);
            }
            
            editorWorld.UpdateSceneListDataProvider ();
         }
         
         // ...
         
         //return editorWorld;
         return newCreatedScenes;
      }
      
      public static function SceneDefine2Scene (editorWorld:World, sceneDefine:SceneDefine, isNewSceneToLoadAll:Boolean, scene:Scene, 
                                                mergeVariablesWithSameNames:Boolean, 
                                                policyOnConflictingSceneAssets:int, // 0: determined by modified time. 1: keep current. 2: override. 3: create new
                                                imageModuleRefIndex_CorrectionTable:Array, soundRefIndex_CorrectionTable:Array, sceneRefIndex_CorrectionTable:Array):void
      {
         //
         
         //if (isNewWorldToLoadAll)
         if (isNewSceneToLoadAll)
         {
            // settings
            {
               //>>from v1.51
               scene.SetViewerUiFlags (sceneDefine.mSettings.mViewerUiFlags);
               scene.SetPlayBarColor (sceneDefine.mSettings.mPlayBarColor);
               scene.SetViewportWidth (sceneDefine.mSettings.mViewportWidth);
               scene.SetViewportHeight (sceneDefine.mSettings.mViewportHeight);
               scene.SetZoomScale (sceneDefine.mSettings.mZoomScale);
               //<<
               
               scene.SetScale (scene.GetZoomScale ());
               
               //>> from v1.04
               scene.SetCameraCenterX (sceneDefine.mSettings.mCameraCenterX);
               scene.SetCameraCenterY (sceneDefine.mSettings.mCameraCenterY);
               scene.SetWorldLeft (sceneDefine.mSettings.mWorldLeft);
               scene.SetWorldTop (sceneDefine.mSettings.mWorldTop);
               scene.SetWorldWidth (sceneDefine.mSettings.mWorldWidth);
               scene.SetWorldHeight (sceneDefine.mSettings.mWorldHeight);
               scene.SetBackgroundColor (sceneDefine.mSettings.mBackgroundColor);
               scene.SetBuildBorder (sceneDefine.mSettings.mBuildBorder);
               scene.SetBorderColor (sceneDefine.mSettings.mBorderColor);
               //<<
               
               
               //>> [v1.06, v1.08)
               //sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount;
               //sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel;
               //<<
               
               //>>from v1.08
               scene.SetInfiniteSceneSize (sceneDefine.mSettings.mIsInfiniteWorldSize);
               
               scene.SetBorderAtTopLayer (sceneDefine.mSettings.mBorderAtTopLayer);
               scene.SetWorldBorderLeftThickness (sceneDefine.mSettings.mWorldBorderLeftThickness);
               scene.SetWorldBorderTopThickness (sceneDefine.mSettings.mWorldBorderTopThickness);
               scene.SetWorldBorderRightThickness (sceneDefine.mSettings.mWorldBorderRightThickness);
               scene.SetWorldBorderBottomThickness (sceneDefine.mSettings.mWorldBorderBottomThickness);
               
               scene.SetDefaultGravityAccelerationMagnitude (sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude);
               scene.SetDefaultGravityAccelerationAngle (sceneDefine.mSettings.mDefaultGravityAccelerationAngle);
               
               scene.RebuildCoordinateSystem (
                     sceneDefine.mSettings.mCoordinatesOriginX,
                     sceneDefine.mSettings.mCoordinatesOriginY,
                     sceneDefine.mSettings.mCoordinatesScale,
                     sceneDefine.mSettings.mRightHandCoordinates
                  );
               
               scene.SetCiRulesEnabled (sceneDefine.mSettings.mIsCiRulesEnabled);
               //<<
               
               //>>from v1.55
               scene.SetAutoSleepingEnabled (sceneDefine.mSettings.mAutoSleepingEnabled);
               scene.SetCameraRotatingEnabled (sceneDefine.mSettings.mCameraRotatingEnabled);
               //<<
            
               //>>from v1.60
               scene.SetInitialSpeedX (sceneDefine.mSettings.mInitialSpeedX);
               scene.SetPreferredFPS (sceneDefine.mSettings.mPreferredFPS);
               scene.SetPauseOnFocusLost (sceneDefine.mSettings.mPauseOnFocusLost);
               
               scene.SetPhysicsSimulationEnabled (sceneDefine.mSettings.mPhysicsSimulationEnabled);
               scene.SetPhysicsSimulationStepTimeLength (sceneDefine.mSettings.mPhysicsSimulationStepTimeLength);
               scene.SetPhysicsSimulationQuality (sceneDefine.mSettings.mPhysicsSimulationQuality);
               scene.SetCheckTimeOfImpact (sceneDefine.mSettings.mCheckTimeOfImpact);
               //<<
            }
         }
         
         // ...
         
         var toUseNewData:Boolean;
         
         // collision category
         
         //>> from v1.02
         //{
            var ccatManager:CollisionCategoryManager = scene.GetCollisionCategoryManager ();
            
            //var beginningCollisionCategoryIndex:int = scene.GetCollisionCategoryManager ().GetNumCollisionCategories ();
            
            var collisionCategory:CollisionCategory;
            
            var ccatRefIndex_CorrectionTable:Array = new Array (sceneDefine.mCollisionCategoryDefines.length);
            
            for (var ccId:int = 0; ccId < sceneDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = sceneDefine.mCollisionCategoryDefines [ccId];
               
               // mKey and mTimeModified are from v2.01
               
               collisionCategory = ccatManager.GetAssetByKey (ccDefine.mKey) as CollisionCategory;
               
               if (collisionCategory == null) // before v2.01
               {
                  toUseNewData = true;
                  
                  collisionCategory = ccatManager.CreateCollisionCategory (ccDefine.mKey, ccDefine.mName);
               }
               else if (policyOnConflictingSceneAssets == 3) // always create new 
               {
                  toUseNewData = true;
                  
                  collisionCategory = ccatManager.CreateCollisionCategory (null, ccDefine.mName);
               }
               else if (policyOnConflictingSceneAssets == 2) // override 
               {
                  toUseNewData = true;
               }
               else if (policyOnConflictingSceneAssets == 1) // skip 
               {
                  toUseNewData = false;
               }
               else // if (policyOnConflictingSceneAssets == 0) // auto
               {
                  toUseNewData = ccDefine.mTimeModified > collisionCategory.GetTimeModified ();
               }
               
               if (toUseNewData)
               {
                  collisionCategory.SetCollideInternally (ccDefine.mCollideInternally);
                  collisionCategory.SetPosition (ccDefine.mPosX, ccDefine.mPosY);
                  
                  collisionCategory.SetTimeModified (ccDefine.mTimeModified);
                  
                  collisionCategory.UpdateAppearance ();
                  collisionCategory.UpdateSelectionProxy ();
               }
               
               if (collisionCategory != null)
                  ccDefine.mKey = collisionCategory.GetKey ();
               
               ccatRefIndex_CorrectionTable [ccId] = ccatManager.GetCollisionCategoryIndex (collisionCategory);
            }
            
            //if (isNewWorldToLoadAll)
            if (isNewSceneToLoadAll)
            {
               if (sceneDefine.mDefaultCollisionCategoryIndex >= 0)
                  sceneDefine.mDefaultCollisionCategoryIndex = ccatRefIndex_CorrectionTable [sceneDefine.mDefaultCollisionCategoryIndex];
               
               collisionCategory = scene.GetCollisionCategoryManager ().GetCollisionCategoryByIndex (sceneDefine.mDefaultCollisionCategoryIndex);
               if (collisionCategory != null)
                  collisionCategory.SetAsDefaultCategory (true);
            }
            
            for (var pairId:int = 0; pairId < sceneDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = sceneDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               ////scene.CreateEntityCollisionCategoryFriendLink (pairDefine.mCollisionCategory1Index, pairDefine.mCollisionCategory2Index);
               //scene.CreateCollisionCategoryFriendLink (beginningCollisionCategoryIndex + pairDefine.mCollisionCategory1Index,
               //                                           beginningCollisionCategoryIndex + pairDefine.mCollisionCategory2Index);
               // maybe not perfect
               scene.CreateCollisionCategoryFriendLink (ccatRefIndex_CorrectionTable [pairDefine.mCollisionCategory1Index],
                                                        ccatRefIndex_CorrectionTable [pairDefine.mCollisionCategory2Index]);
            }
         //}
         //<<
         
         //>> todo: move function creations here from the below
         //<<
         
         // entities
         
         var beginningEntityIndex:int = scene.GetNumAssets ();
         
         var appearId:int;
         var createId:int;
         var entityDefine:Object;
         var entity:Entity;
         var vectorShape:EntityVectorShape;
         var shape:EntityShape;
         var anchorDefine:Object;
         var joint:EntityJoint;
         var utility:EntityUtility;
         var logic:EntityLogic;
         
         var numEntities:int = sceneDefine.mEntityDefines.length;
         
         scene.SetCreationAssetArrayLocked (true);
         
         EditorContext.mPauseCreateShapeProxy = true;
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = sceneDefine.mEntityDefines [createId];
            
            entity = null;
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               utility = null;
               
               //>>from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  var camera:EntityUtilityCamera = scene.CreateEntityUtilityCamera ();
                  
                  //>>from v.108
                  camera.SetFollowedTarget (entityDefine.mFollowedTarget);
                  camera.SetFollowingStyle (entityDefine.mFollowingStyle);
                  //<<
                  
                  entity = utility = camera;
               }
               //<<
               //>>from v1.10
               else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
               {
                  var power_source:EntityUtilityPowerSource = scene.CreateEntityUtilityPowerSource ();
                  
                  power_source.SetPowerSourceType (entityDefine.mPowerSourceType);
                  power_source.SetPowerMagnitude (entityDefine.mPowerMagnitude);
                  power_source.SetKeyboardEventId (entityDefine.mKeyboardEventId)
                  power_source.SetKeyCodes (entityDefine.mKeyCodes);
                  
                  entity = utility = power_source;
               }
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               logic = null;
               
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  entity = logic = scene.CreateEntityCondition ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  entity = logic = scene.CreateEntityTask ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  entity = logic = scene.CreateEntityConditionDoor ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  entity = logic = scene.CreateEntityInputEntityAssigner ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  entity = logic = scene.CreateEntityInputEntityPairAssigner ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                        entity = logic = scene.CreateEntityEventHandler_Timer (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        entity = logic = scene.CreateEntityEventHandler_TimerWithPrePostHandling (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        entity = logic = scene.CreateEntityEventHandler_Keyboard (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnMouseGesture:
                        entity = logic = scene.CreateEntityEventHandler_MouseGesture (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnPhysicsShapeMouseDown:
                     case CoreEventIds.ID_OnPhysicsShapeMouseUp:
                     case CoreEventIds.ID_OnEntityMouseClick:
                     case CoreEventIds.ID_OnEntityMouseDown:
                     case CoreEventIds.ID_OnEntityMouseUp:
                     case CoreEventIds.ID_OnEntityMouseMove:
                     case CoreEventIds.ID_OnEntityMouseEnter:
                     case CoreEventIds.ID_OnEntityMouseOut:
                     case CoreEventIds.ID_OnWorldMouseClick:
                     case CoreEventIds.ID_OnWorldMouseDown:
                     case CoreEventIds.ID_OnWorldMouseUp:
                     case CoreEventIds.ID_OnWorldMouseMove:
                        entity = logic = scene.CreateEntityEventHandler_Mouse (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting:
                     case CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting:
                     case CoreEventIds.ID_OnTwoPhysicsShapesEndContacting:
                        entity = logic = scene.CreateEntityEventHandler_Contact (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnJointReachLowerLimit:
                     case CoreEventIds.ID_OnJointReachUpperLimit:
                        entity = logic = scene.CreateEntityEventHandler_JointReachLimit (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnSequencedModuleLoopToEnd:
                        entity = logic = scene.CreateEntityEventHandler_ModuleLoopToEnd (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnGameActivated:
                     case CoreEventIds.ID_OnGameDeactivated:
                        entity = logic = scene.CreateEntityEventHandler_GameLostOrGotFocus (entityDefine.mEventId);
                        break;
                     default:
                        entity = logic = scene.CreateEntityEventHandler (entityDefine.mEventId);
                        break;
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  entity = logic = scene.CreateEntityAction ();
               }
               //>>1.56
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  entity = logic = scene.CreateEntityInputEntityScriptFilter ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  entity = logic = scene.CreateEntityInputEntityPairScriptFilter ();
               }
               //<<
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               vectorShape = null;
               
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  if ( Define.IsBasicPathVectorShapeEntity (entityDefine.mEntityType) )
                  {
                     //>>from v1.05
                     if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                     {
                        var polyline:EntityVectorShapePolyline = scene.CreateEntityVectorShapePolyline ();
                        
                        polyline.SetCurveThickness (entityDefine.mCurveThickness);
                        
                        //>> from v1.08
                        polyline.SetRoundEnds (entityDefine.mIsRoundEnds);
                        //<<
                        
                        //>> from v1.57
                        polyline.SetClosed (entityDefine.mIsClosed);
                        //<<
                        
                        // commented off, do it in the 2nd round below
                        //   polyline.SetPosition (entityDefine.mPosX, entityDefine.mPosY); // the position and rotation are set again below, 
                        //   polyline.SetRotation (entityDefine.mRotation);                 // but the SetLocalVertexPoints needs position and rotation set before
                        //polyline.SetLocalVertexPoints (entityDefine.mLocalPoints);
                        
                        entity = vectorShape = polyline;
                     }
                     //<<
                  }
                  else if ( Define.IsBasicAreaVectorShapeEntity (entityDefine.mEntityType) )
                  {
                     if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                     {
                        var circle:EntityVectorShapeCircle = scene.CreateEntityVectorShapeCircle ();
                        circle.SetAppearanceType (entityDefine.mAppearanceType);
                        circle.SetRadius (entityDefine.mRadius);
                        
                        entity = vectorShape = circle;
                     }
                     else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                     {
                        var rect:EntityVectorShapeRectangle = scene.CreateEntityVectorShapeRectangle ();
                        rect.SetHalfWidth (entityDefine.mHalfWidth);
                        rect.SetHalfHeight (entityDefine.mHalfHeight);
                        
                        //from v1.08
                        rect.SetRoundCorners (entityDefine.mIsRoundCorners);
                        //<<
                        
                        entity = vectorShape = rect;
                     }
                     //>> from v1.04
                     else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                     {
                        var polygon:EntityVectorShapePolygon = scene.CreateEntityVectorShapePolygon ();
                        
                        // commented off, do it in the 2nd round below
                        //   polygon.SetPosition (entityDefine.mPosX, entityDefine.mPosY); // the position and rotation are set again below, 
                        //   polygon.SetRotation (entityDefine.mRotation);                 // but the SetLocalVertexPoints needs position and rotation set before
                        //polygon.SetLocalVertexPoints (entityDefine.mLocalPoints);
                        
                        entity = vectorShape = polygon;
                     }
                     //<<

                     //>> from v1.60
                     SetShapeEntityBodyTexture (editorWorld, vectorShape as EntityVectorShapeArea, entityDefine.mBodyTextureDefine, imageModuleRefIndex_CorrectionTable);
                     //<<      
                  }
                  
                  if (vectorShape != null)
                  {
                     vectorShape.SetAiType (entityDefine.mAiType);
                     
                     //
                     SetShapePhysicsProperties (vectorShape, entityDefine, ccatRefIndex_CorrectionTable);
                  }
               }
               else // not physics vectorShape
               {
                  //>> v1.02
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText || entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                  {
                     var text:EntityVectorShapeText;
                     
                     // from v1.08
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                     {
                        var textButton:EntityVectorShapeTextButton = scene.CreateEntityVectorShapeTextButton ();
                        
                        textButton.SetUsingHandCursor (entityDefine.mUsingHandCursor);
                        
                        var mouseOverShape:EntityVectorShape = textButton.GetMouseOverShape ();
                        
                        mouseOverShape.SetDrawBackground (entityDefine.mDrawBackground_MouseOver);
                        mouseOverShape.SetFilledColor (entityDefine.mBackgroundColor_MouseOver);
                        mouseOverShape.SetTransparency (entityDefine.mBackgroundTransparency_MouseOver);
                        
                        mouseOverShape.SetDrawBorder (entityDefine.mDrawBorder_MouseOver);
                        mouseOverShape.SetBorderColor (entityDefine.mBorderColor_MouseOver);
                        mouseOverShape.SetBorderThickness (entityDefine.mBorderThickness_MouseOver);
                        mouseOverShape.SetBorderTransparency (entityDefine.mBorderTransparency_MouseOver);
                        
                        text = textButton;
                     }
                     //<<
                     else
                     {
                        text = scene.CreateEntityVectorShapeText ();
                     }
                     
                     text.SetText (entityDefine.mText);
                     text.SetWordWrap (entityDefine.mWordWrap);
                     
                     //from v1.08
                     text.SetAdaptiveBackgroundSize (entityDefine.mAdaptiveBackgroundSize);
                     text.SetTextColor (entityDefine.mTextColor);
                     text.SetFontSize (entityDefine.mFontSize);
                     text.SetBold (entityDefine.mIsBold);
                     text.SetItalic (entityDefine.mIsItalic);
                     //<<
                     
                     //from v1.09
                     text.SetTextAlign (entityDefine.mTextAlign);
                     text.SetUnderlined (entityDefine.mIsUnderlined);
                     //<<
                     
                     text.SetHalfWidth (entityDefine.mHalfWidth);
                     text.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     entity = vectorShape = text;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     var gController:EntityVectorShapeGravityController = scene.CreateEntityVectorShapeGravityController ();
                     
                     gController.SetRadius (entityDefine.mRadius)
                     
                     // removed from v1.05
                     /////gController.SetInteractive (entityDefine.mIsInteractive)
                     
                     // added in v1.05
                     gController.SetInteractiveZones (entityDefine.mInteractiveZones);
                     gController.mInteractiveConditions = entityDefine.mInteractiveConditions
                     
                     // ...
                     gController.SetInitialGravityAcceleration (entityDefine.mInitialGravityAcceleration)
                     gController.SetInitialGravityAngle (entityDefine.mInitialGravityAngle)
                     
                     //>> from v1,08
                     gController.SetMaximalGravityAcceleration (entityDefine.mMaximalGravityAcceleration);
                     //<<
                     
                     entity = vectorShape = gController;
                  }
                  //<<
               }
               
               if (vectorShape != null)
               {
                  //>>v1.02
                  vectorShape.SetDrawBorder (entityDefine.mDrawBorder);
                  vectorShape.SetDrawBackground (entityDefine.mDrawBackground);
                  //<<
                  
                  //>>from v1.04
                  vectorShape.SetBorderColor (entityDefine.mBorderColor);
                  vectorShape.SetBorderThickness (entityDefine.mBorderThickness);
                  vectorShape.SetFilledColor (entityDefine.mBackgroundColor);
                  vectorShape.SetTransparency (entityDefine.mTransparency);
                  //<<
                  
                  //>>from v1.05
                  vectorShape.SetBorderTransparency (entityDefine.mBorderTransparency);
                  //<<
               }
            }
            //>> from v1.58
            else if (Define.IsShapeEntity (entityDefine.mEntityType))
            {
               shape = null;
               
               if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
               {
                  var imageModuleShape:EntityShapeImageModule = scene.CreateEntityShapeImageModule ();
                  
                  if (entityDefine.mModuleIndex >= 0)
                     entityDefine.mModuleIndex = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndex];
                  
                  imageModuleShape.SetAssetImageModuleByIndex (entityDefine.mModuleIndex, editorWorld);
                  
                  SetShapePhysicsProperties (imageModuleShape, entityDefine, ccatRefIndex_CorrectionTable);
                  
                  entity = shape = imageModuleShape;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
               {
                  var imageModuleShapeButton:EntityShapeImageModuleButton = scene.CreateEntityShapeImageModuleButton ();
                  
                  if (entityDefine.mModuleIndexUp >= 0)
                     entityDefine.mModuleIndexUp = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndexUp];
                  if (entityDefine.mModuleIndexOver >= 0)
                     entityDefine.mModuleIndexOver = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndexOver];
                  if (entityDefine.mModuleIndexDown >= 0)
                     entityDefine.mModuleIndexDown = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndexDown];
                  
                  imageModuleShapeButton.SetAssetImageModuleForMouseUpByIndex (entityDefine.mModuleIndexUp, editorWorld);
                  imageModuleShapeButton.SetAssetImageModuleForMouseOverByIndex (entityDefine.mModuleIndexOver, editorWorld);
                  imageModuleShapeButton.SetAssetImageModuleForMouseDownByIndex (entityDefine.mModuleIndexDown, editorWorld);
                  
                  SetShapePhysicsProperties (imageModuleShapeButton, entityDefine, ccatRefIndex_CorrectionTable);
                  
                  entity = shape = imageModuleShapeButton;
               }
            }
            //<<
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = null;
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  var hinge:EntityJointHinge = scene.CreateEntityJointHinge ();
                  
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchorEntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (hinge.GetAnchor ());
                  anchorDefine.mEntity = hinge.GetAnchor ();
                  
                  hinge.SetLimitsEnabled (entityDefine.mEnableLimits);
                  hinge.SetLimits (entityDefine.mLowerAngle, entityDefine.mUpperAngle);
                  hinge.mEnableMotor = entityDefine.mEnableMotor;
                  hinge.mMotorSpeed = entityDefine.mMotorSpeed;
                  hinge.mBackAndForth = entityDefine.mBackAndForth;
                  
                  //>>v1.04
                  hinge.SetMaxMotorTorque (entityDefine.mMaxMotorTorque);
                  //<<
                  
                  entity = joint = hinge;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  var slider:EntityJointSlider = scene.CreateEntityJointSlider ();
                  
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (slider.GetAnchor1 ());
                  anchorDefine.mEntity = slider.GetAnchor1 ();
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (slider.GetAnchor2 ());
                  anchorDefine.mEntity = slider.GetAnchor2 ();
                  
                  slider.SetLimitsEnabled (entityDefine.mEnableLimits);
                  slider.SetLimits (entityDefine.mLowerTranslation, entityDefine.mUpperTranslation);
                  slider.mEnableMotor = entityDefine.mEnableMotor;
                  slider.mMotorSpeed = entityDefine.mMotorSpeed;
                  slider.mBackAndForth = entityDefine.mBackAndForth;
                  
                  //>>v1.04
                  slider.SetMaxMotorForce (entityDefine.mMaxMotorForce);
                  //<<
                  
                  entity = joint = slider;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  var distanceJoint:EntityJointDistance = scene.CreateEntityJointDistance ();
                  
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (distanceJoint.GetAnchor1 ());
                  anchorDefine.mEntity = distanceJoint.GetAnchor1 ();
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (distanceJoint.GetAnchor2 ());
                  anchorDefine.mEntity = distanceJoint.GetAnchor2 ();
                  
                  //>>from v1.08
                  distanceJoint.SetBreakDeltaLength (entityDefine.mBreakDeltaLength);
                  //<<
                  
                  entity = joint = distanceJoint;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  var spring:EntityJointSpring = scene.CreateEntityJointSpring ();
                  
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (spring.GetAnchor1 ());
                  anchorDefine.mEntity = spring.GetAnchor1 ();
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (spring.GetAnchor2 ());
                  anchorDefine.mEntity = spring.GetAnchor2 ();
                  
                  spring.SetStaticLengthRatio (entityDefine.mStaticLengthRatio);
                  //spring.SetFrequencyHz (entityDefine.mFrequencyHz);
                  spring.SetSpringType (entityDefine.mSpringType);
                  
                  spring.mDampingRatio = entityDefine.mDampingRatio;
                  
                  //>>from v1.08
                  spring.SetFrequencyDeterminedManner (entityDefine.mFrequencyDeterminedManner);
                  spring.SetFrequency (entityDefine.mFrequency);
                  spring.SetSpringConstant (entityDefine.mSpringConstant);
                  spring.SetBreakExtendedLength (entityDefine.mBreakExtendedLength);
                  //<<
                  
                  entity = joint = spring;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  var weld:EntityJointWeld = scene.CreateEntityJointWeld ();
                  
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchorEntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (hinge.GetAnchor ());
                  anchorDefine.mEntity = weld.GetAnchor ();
                  
                  entity = joint = weld;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  var dummy:EntityJointDummy = scene.CreateEntityJointDummy ();
                  
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (spring.GetAnchor1 ());
                  anchorDefine.mEntity = dummy.GetAnchor1 ();
                  anchorDefine = sceneDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = scene.getChildIndex (spring.GetAnchor2 ());
                  anchorDefine.mEntity = dummy.GetAnchor2 ();
                  
                  entity = joint = dummy;
               }
               
               if (joint != null)
               {
                  joint.mCollideConnected = entityDefine.mCollideConnected ;
                  
                  //>>from v1.08
                  joint.SetBreakable (entityDefine.mBreakable);
                  //<<
               }
            }
            else if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
            {
               //entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            else
            {
               //entityDefine.mEntityType = Define.EntityType_Unkonwn;
            }
            
            if (entity != null)
            {
               entityDefine.mEntity = entity;
               
               entity.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
               //>>from v1.58
               entity.SetScale (entityDefine.mScale)
               entity.SetFlipped (entityDefine.mIsFlipped)
               //<<
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               //>>from v1.08
               entity.SetAlpha (entityDefine.mAlpha);
               entity.SetEnabled (entityDefine.mIsEnabled);
               //<<
            }
            else
            {
               //trace ("!!! entity is null, id = " + createId);
            }
         }
         
         // remove entities then readd them by appearance id order
         //>>>
         while (scene.numChildren > beginningEntityIndex)
            scene.removeChildAt (beginningEntityIndex);
         
         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
//trace ("appearId = " + appearId + ", createId = " + createId + ", entityDefine = " + sceneDefine.mEntityDefines [createId]);
            createId = sceneDefine.mEntityAppearanceOrder [appearId];
            entityDefine = sceneDefine.mEntityDefines [createId];
            scene.addChild (entityDefine.mEntity);
         }
         //<<<
         
         scene.SetCreationAssetArrayLocked (false);
         
         //>>> add entities by creation id order
         // from version 0x0107)
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = sceneDefine.mEntityDefines [createId];
            entity = entityDefine.mEntity;
            
            scene.AddAssetToCreationArray (entity);
         }
         //<<<
         
         EditorContext.mPauseCreateShapeProxy = false;
         
         //>>> load custom variables
         // from v1.52
         // memo: when variables support uuid later, how to handle the problem of 2 variables with different types but with the same uuid
         var beginningSessionVariableIndex:int = scene.GetCodeLibManager ().GetSessionVariableSpace ().GetNumVariableInstances ();
         var beginningGlobalVariableIndex:int = scene.GetCodeLibManager ().GetGlobalVariableSpace ().GetNumVariableInstances ();
         var beginningEntityVariableIndex:int = scene.GetCodeLibManager ().GetEntityVariableSpace ().GetNumVariableInstances ();
         if (sceneDefine.mSessionVariableDefines.length > 0)
         {
            if (mergeVariablesWithSameNames)
               scene.GetCodeLibManager ().GetSessionVariableSpace ().BeginMergeVariablesWithSameNamesInCreatingVariables (); // important
            TriggerFormatHelper.VariableDefines2VariableSpace (scene, sceneDefine.mSessionVariableDefines, scene.GetCodeLibManager ().GetSessionVariableSpace (), true);
         }
         if (sceneDefine.mGlobalVariableDefines.length > 0)
         {
            if (mergeVariablesWithSameNames)
               scene.GetCodeLibManager ().GetGlobalVariableSpace ().BeginMergeVariablesWithSameNamesInCreatingVariables (); // important
            TriggerFormatHelper.VariableDefines2VariableSpace (scene, sceneDefine.mGlobalVariableDefines, scene.GetCodeLibManager ().GetGlobalVariableSpace (), true);
         }
         if (sceneDefine.mEntityPropertyDefines.length > 0)
         {
            if (mergeVariablesWithSameNames)
               scene.GetCodeLibManager ().GetEntityVariableSpace ().BeginMergeVariablesWithSameNamesInCreatingVariables ();
            TriggerFormatHelper.VariableDefines2VariableSpace (scene, sceneDefine.mEntityPropertyDefines, scene.GetCodeLibManager ().GetEntityVariableSpace (), true);
         }
         //scene.GetCodeLibManager ().NotifySessionVariableSpaceModified ();
         //scene.GetCodeLibManager ().NotifyGlobalVariableSpaceModified ();
         //scene.GetCodeLibManager ().NotifyEntityVariableSpaceModified ();
         //<<<
         
         //>>> load custom functions
         // from v1.53
         scene.GetCodeLibManager().SetDelayUpdateFunctionMenu (true);
         
         var codelibManager:CodeLibManager = scene.GetCodeLibManager ();
         
         //var beginningCustomFunctionIndex:int = scene.GetCodeLibManager().GetNumFunctions ();
         
         var functionRefIndex_CorrectionTable:Array = new Array (sceneDefine.mFunctionDefines.length);
         
         var functionId:int;
         var functionAsset:AssetFunction;
         var functionDefine:FunctionDefine;
         
         for (functionId = 0; functionId < sceneDefine.mFunctionDefines.length; ++ functionId)
         {
            functionDefine = sceneDefine.mFunctionDefines [functionId] as FunctionDefine;
            
            // mKey and mTimeModified are from v2.01
            
            functionAsset = codelibManager.GetAssetByKey (functionDefine.mKey) as AssetFunction;
            
            if (functionAsset == null) // before v2.01
            {
               toUseNewData = true;
               
               functionAsset = codelibManager.CreateFunction (functionDefine.mKey);
            }
            else if (policyOnConflictingSceneAssets == 3) // always create new 
            {
               toUseNewData = true;
               
               functionAsset = codelibManager.CreateFunction (null);
            }
            else if (policyOnConflictingSceneAssets == 2) // override
            {
               toUseNewData = true;
               
               functionAsset.Reset ();
            }
            else if (policyOnConflictingSceneAssets == 1) // skip
            {
               toUseNewData = false;
            }
            else // if (policyOnConflictingSceneAssets == 0) // auto
            {
               toUseNewData = functionDefine.mTimeModified > functionAsset.GetTimeModified ();
               
               if (toUseNewData)
               {
                  functionAsset.Reset ();
               }
            }
            
            functionDefine.mToLoadNewData = toUseNewData;
            if (functionDefine.mToLoadNewData)
            {
               //>>added from v1.56, become meaningless from v2.00 
               functionAsset.SetDesignDependent (functionDefine.mDesignDependent);
               //<<
            
               TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, functionDefine, functionAsset.GetCodeSnippet (), functionAsset.GetCodeSnippet ().GetOwnerFunctionDefinition (), true ,false);
               functionAsset.GetFunctionDefinition ().SybchronizeDeclarationWithDefinition ();
            }
            
            if (functionAsset != null)
               functionDefine.mKey = functionAsset.GetKey ();
            
            functionRefIndex_CorrectionTable [functionId] = functionAsset.GetFunctionIndex (); // codelibManager.GetFunctionIndex (functionAsset);
         }
         
         for (functionId = 0; functionId < sceneDefine.mFunctionDefines.length; ++ functionId)
         {
            functionDefine = sceneDefine.mFunctionDefines [functionId] as FunctionDefine;
            
            if (functionDefine.mToLoadNewData)
            {
               //functionAsset = scene.GetCodeLibManager ().GetFunctionByIndex (functionId + beginningCustomFunctionIndex);
               functionAsset = codelibManager.GetAssetByKey (functionDefine.mKey) as AssetFunction;
               
               functionAsset.SetFunctionName (functionDefine.mName);
               functionAsset.SetPosition (functionDefine.mPosX, functionDefine.mPosY);
               
               functionAsset.UpdateAppearance ();
               functionAsset.UpdateSelectionProxy ();
               
               TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, functionDefine.mCodeSnippetDefine, true, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
               TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, functionDefine, functionAsset.GetCodeSnippet (), functionAsset.GetCodeSnippet ().GetOwnerFunctionDefinition (), false, true);
               
               functionAsset.SetTimeModified (functionDefine.mTimeModified);
            }
         }
         scene.GetCodeLibManager().SetDelayUpdateFunctionMenu (false);
         scene.GetCodeLibManager().UpdateFunctionMenu ();
         //<<<
         
         // modify, 2nd round
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = sceneDefine.mEntityDefines [createId];
            entity = entityDefine.mEntity;
            
            if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  //>> from v1.04
                  if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     polygon = entityDefine.mEntity as EntityVectorShapePolygon;
                     polygon.SetLocalVertexPoints (entityDefine.mLocalPoints);
                  }
                  //<<
                  //>>from v1.05
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     polyline = entityDefine.mEntity as  EntityVectorShapePolyline;
                     polyline.SetLocalVertexPoints (entityDefine.mLocalPoints);
                  }
                  //<<
               }
            }
            else if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
            {
               //trace ("entityDefine.mPosX = " + entityDefine.mPosX + ", entityDefine.mPosY = " + entityDefine.mPosY);
               
               entity = entityDefine.mEntity as Entity;
               entity.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
               //>>from v1.58
               entity.SetScale (entityDefine.mScale);
               entity.SetFlipped (entityDefine.mIsFlipped);
               //<<
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
               
               entity.GetMainAsset ().UpdateAppearance ();
               
               //scene.addChildAt (entity, appearId);
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = entityDefine.mEntity as EntityJoint;
               
               // from v1.02
               if (entityDefine.mConnectedShape1Index >= 0)
                  entityDefine.mConnectedShape1Index += beginningEntityIndex;
               
               joint.SetConnectedShape1Index (entityDefine.mConnectedShape1Index);
               
               if (entityDefine.mConnectedShape2Index >= 0)
                  entityDefine.mConnectedShape2Index += beginningEntityIndex;
               
               joint.SetConnectedShape2Index (entityDefine.mConnectedShape2Index);
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  var condition:EntityBasicCondition = entityDefine.mEntity as EntityBasicCondition;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, entityDefine.mFunctionDefine, condition.GetCodeSnippet (), condition.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  var task:EntityTask = entityDefine.mEntity as EntityTask;
                  
                  ShiftEntityRefIndexes (entityDefine.mInputAssignerCreationIds, beginningEntityIndex);
                  task.SetEntityAssignersByCreationIds (entityDefine.mInputAssignerCreationIds);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  var conditionDoor:EntityConditionDoor = entityDefine.mEntity as EntityConditionDoor;
                  conditionDoor.SetAsAnd (entityDefine.mIsAnd);
                  conditionDoor.SetAsNot (entityDefine.mIsNot);
                  ShiftEntityRefIndexes (entityDefine.mInputConditionEntityCreationIds, beginningEntityIndex);
                  conditionDoor.SetInputConditionsByCreationIds (entityDefine.mInputConditionEntityCreationIds, entityDefine.mInputConditionTargetValues);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  var entityAssigner:EntityInputEntityAssigner = entityDefine.mEntity as EntityInputEntityAssigner;
                  
                  entityAssigner.SetSelectorType (entityDefine.mSelectorType);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds, beginningEntityIndex);
                  entityAssigner.SetInputEntitiesByCreationIds (entityDefine.mEntityCreationIds);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  var pairAsigner:EntityInputEntityPairAssigner = entityDefine.mEntity as EntityInputEntityPairAssigner;
                  
                  pairAsigner.SetPairingType (entityDefine.mPairingType);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds1, beginningEntityIndex);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds2, beginningEntityIndex);
                  pairAsigner.SetInputPairEntitiesByCreationdIds (entityDefine.mEntityCreationIds1, entityDefine.mEntityCreationIds2);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  var eventHandler:EntityEventHandler = entityDefine.mEntity as EntityEventHandler;
                  
                  if (entityDefine.mInputConditionEntityCreationId >= 0)
                     entityDefine.mInputConditionEntityCreationId += beginningEntityIndex;
                  
                  eventHandler.SetInputConditionByCreationId (entityDefine.mInputConditionEntityCreationId, entityDefine.mInputConditionTargetValue);
                  ShiftEntityRefIndexes (entityDefine.mInputAssignerCreationIds, beginningEntityIndex);
                  eventHandler.SetEntityAssignersByCreationIds (entityDefine.mInputAssignerCreationIds);

                  //>> from v1.08, if (sceneDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mExternalActionEntityCreationId >= 0)
                        entityDefine.mExternalActionEntityCreationId += beginningEntityIndex;
                     
                     eventHandler.SetExternalActionByCreationId (entityDefine.mExternalActionEntityCreationId);
                     
                     if (eventHandler is EntityEventHandler_Timer)
                     {
                        var timerEventHandler:EntityEventHandler_Timer = eventHandler as EntityEventHandler_Timer;
                        
                        timerEventHandler.SetRunningInterval (entityDefine.mRunningInterval);
                        timerEventHandler.SetOnlyRunOnce (entityDefine.mOnlyRunOnce);
                        
                        //>>from v1.56
                        if (eventHandler is EntityEventHandler_TimerWithPrePostHandling)
                        {
                           // the block is move down, see below. For need local variaible space of the main code snippet
                        }
                        //<<
                     }
                     else if (eventHandler is EntityEventHandler_Keyboard)
                     {
                        var keyboardEventHandler:EntityEventHandler_Keyboard = eventHandler as EntityEventHandler_Keyboard;
                        
                        keyboardEventHandler.SetKeyCodes (entityDefine.mKeyCodes);
                     }
                     else if (eventHandler is EntityEventHandler_MouseGesture)
                     {
                        var gestureEventHandler:EntityEventHandler_MouseGesture = eventHandler as EntityEventHandler_MouseGesture;
                        
                        gestureEventHandler.SetGestureIDs (entityDefine.mGestureIDs);
                     }
                     else if (eventHandler is EntityEventHandler_Mouse)
                     {
                        var mouseEventHandler:EntityEventHandler_Mouse = eventHandler as EntityEventHandler_Mouse;
                     }
                     else if (eventHandler is EntityEventHandler_Contact)
                     {
                        var contactEventHandler:EntityEventHandler_Contact = eventHandler as EntityEventHandler_Contact;
                     }
                     else if (eventHandler is EntityEventHandler_JointReachLimit)
                     {
                        var jointReachLimitEventHandler:EntityEventHandler_JointReachLimit = eventHandler as EntityEventHandler_JointReachLimit;
                     }
                     else if (eventHandler is EntityEventHandler_ModuleLoopToEnd)
                     {
                        var moduleLoopToEndEventHandler:EntityEventHandler_ModuleLoopToEnd = eventHandler as EntityEventHandler_ModuleLoopToEnd;
                     }
                     else if (eventHandler is EntityEventHandler_GameLostOrGotFocus)
                     {
                        var gameLostOrGotFocusEventHandler:EntityEventHandler_GameLostOrGotFocus = eventHandler as EntityEventHandler_GameLostOrGotFocus;
                     }
                  }
                  //<<
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, entityDefine.mFunctionDefine, eventHandler.GetCodeSnippet (), eventHandler.GetCodeSnippet ().GetOwnerFunctionDefinition ());
                  
                  //>>from v1.56
                  if (eventHandler is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timerEventHandlerWithPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = eventHandler as EntityEventHandler_TimerWithPrePostHandling;
            
                     if (entityDefine.mPreFunctionDefine != undefined)
                     {
                        TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, entityDefine.mPreFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                        TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, entityDefine.mPreFunctionDefine, timerEventHandlerWithPrePostHandling.GetPreCodeSnippet (), timerEventHandlerWithPrePostHandling.GetPreCodeSnippet ().GetOwnerFunctionDefinition (), true, true, eventHandler.GetEventHandlerDefinition ().GetLocalVariableSpace ());
                     }
                     
                     if (entityDefine.mPostFunctionDefine != undefined)
                     {
                        TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, entityDefine.mPostFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                        TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, entityDefine.mPostFunctionDefine, timerEventHandlerWithPrePostHandling.GetPostCodeSnippet (), timerEventHandlerWithPrePostHandling.GetPostCodeSnippet ().GetOwnerFunctionDefinition (), true, true, eventHandler.GetEventHandlerDefinition ().GetLocalVariableSpace ());
                     }
                  }
                  //<<
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  var action:EntityAction = entityDefine.mEntity as EntityAction;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, entityDefine.mFunctionDefine, action.GetCodeSnippet (), action.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  var entityFilter:EntityInputEntityScriptFilter = entityDefine.mEntity as EntityInputEntityScriptFilter;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, entityDefine.mFunctionDefine, entityFilter.GetCodeSnippet (), entityFilter.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  var entityPairFilter:EntityInputEntityPairScriptFilter = entityDefine.mEntity as EntityInputEntityPairScriptFilter;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (scene, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, ccatRefIndex_CorrectionTable, beginningGlobalVariableIndex, beginningEntityVariableIndex, functionRefIndex_CorrectionTable, beginningSessionVariableIndex, imageModuleRefIndex_CorrectionTable, soundRefIndex_CorrectionTable, sceneRefIndex_CorrectionTable);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (scene, entityDefine.mFunctionDefine, entityPairFilter.GetCodeSnippet (), entityPairFilter.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
            }
            
            // ...
            if (entity != null)
            {
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
            }
         }
         
         var groupId:int;
         var brotherId:int;
         var brotherIds:Array;
         var entities:Array;
         
         for (groupId = 0; groupId < sceneDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIds = sceneDefine.mBrotherGroupDefines [groupId] as Array;
            
            ShiftEntityRefIndexes (brotherIds, beginningEntityIndex);
            
            for (brotherId = 0; brotherId < brotherIds.length; ++ brotherId)
            {
               entityDefine = sceneDefine.mEntityDefines [brotherIds [brotherId]];
               
               brotherIds [brotherId] = brotherIds [brotherId];
            }
            
            scene.MakeBrothersByCreationIds (brotherIds);
         }
         
         // important
         if (mergeVariablesWithSameNames)
         {
            if (sceneDefine.mSessionVariableDefines.length > 0)
            {
               scene.GetCodeLibManager ().GetSessionVariableSpace ().EndMergeVariablesWithSameNamesInCreatingVariables ();
            }
            if (sceneDefine.mGlobalVariableDefines.length > 0)
            {
               scene.GetCodeLibManager ().GetGlobalVariableSpace ().EndMergeVariablesWithSameNamesInCreatingVariables ();
            }
            if (sceneDefine.mEntityPropertyDefines.length > 0)
            {
               scene.GetCodeLibManager ().GetEntityVariableSpace ().EndMergeVariablesWithSameNamesInCreatingVariables ();
            }
         }
      }
      
      public static function ShiftEntityRefIndexes (entityIndexes:Array, idShiftedValue:int):void
      {
         if (entityIndexes != null)
         {
            var num:int = entityIndexes.length;
            var id:int;
            for (var i:int = 0; i < num; ++ i)
            {
               id = entityIndexes [i];
               
               if (id >= 0)
                  entityIndexes [i] = id + idShiftedValue;
            }
         }
      }
      
      public static function Xml2WorldDefine (worldXml:XML):WorldDefine
      {
         if (worldXml == null || worldXml.localName() != "World")
            return null;
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // basic
         {
            worldDefine.mVersion = parseInt (worldXml.@version, 16);
            worldDefine.mAuthorName = worldXml.@author_name;
            worldDefine.mAuthorHomepage = worldXml.@author_homepage;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               worldDefine.mShareSourceCode = parseInt (worldXml.@share_source_code) != 0;
               worldDefine.mPermitPublishing = parseInt (worldXml.@permit_publishing) != 0;
            }
            else
            {
               // ...
            }
         }
         
         var element:XML;
         
         // scenes

         if (worldDefine.mVersion >= 0x0200)
         {
            for each (element in worldXml.Scenes.Scene)
            {
               worldDefine.mSceneDefines.push (XmlElement2SceneDefine (worldDefine, element));
            }
         }
         else
         {
            worldDefine.mSceneDefines.push (XmlElement2SceneDefine (worldDefine, worldXml));
         }
         
         // image modules
         
         if (worldDefine.mVersion >= 0x0158)
         {
            for each (element in worldXml.Images.Image)
            {
               var imageDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  imageDefine.mKey = element.@key;
                  imageDefine.mTimeModified = ParseTimeString (element.@time_modified);
               }
               
               imageDefine.mName = element.@name;
               
               var imageFileDataBase64:String = element.text () [0];
               if (imageFileDataBase64 == null)
               {
                  imageDefine.mFileData = null;
               }
               else
               {
                  imageFileDataBase64 = imageFileDataBase64.replace (DataFormat3.Base64CharsRegExp, "");
                  imageDefine.mFileData = DataFormat3.DecodeString2ByteArray (imageFileDataBase64);
               }
               
               worldDefine.mImageDefines.push (imageDefine);
            }
            
            for each (element in worldXml.ImageDivisions.ImageDivision)
            {
               var divisionDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  divisionDefine.mKey = element.@key;
                  divisionDefine.mTimeModified = ParseTimeString (element.@time_modified);
               }
               
               divisionDefine.mImageIndex = parseInt (element.@image_index);
               divisionDefine.mLeft = parseInt (element.@left);
               divisionDefine.mTop = parseInt (element.@top);
               divisionDefine.mRight = parseInt (element.@right);
               divisionDefine.mBottom = parseInt (element.@bottom);
               
               worldDefine.mPureImageModuleDefines.push (divisionDefine);
            }
            
            for each (element in worldXml.AssembledModules.AssembledModule)
            {
               var assembledModuleDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  assembledModuleDefine.mKey = element.@key;
                  assembledModuleDefine.mTimeModified = ParseTimeString (element.@time_modified);
               }
               
               assembledModuleDefine.mModulePartDefines = XmlElements2ModuleInstanceDefines (worldDefine.mVersion, element.ModulePart, false);
               
               worldDefine.mAssembledModuleDefines.push (assembledModuleDefine);
            }
            
            for each (element in worldXml.SequencedModules.SequencedModule)
            {
               var sequencedModuleDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  sequencedModuleDefine.mKey = element.@key;
                  sequencedModuleDefine.mTimeModified = ParseTimeString (element.@time_modified);
               }
               
               if (worldDefine.mVersion >= 0x0202)
               {
                  sequencedModuleDefine.mSettingFlags = parseInt (element.@setting_flags);
               }
               
               sequencedModuleDefine.mModuleSequenceDefines = XmlElements2ModuleInstanceDefines (worldDefine.mVersion, element.ModuleSequence, true);
               
               worldDefine.mSequencedModuleDefines.push (sequencedModuleDefine);
            }
         }
         
         // sounds
         
         if (worldDefine.mVersion >= 0x0159)
         {
            for each (element in worldXml.Sounds.Sound)
            {
               var soundDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  soundDefine.mKey = element.@key;
                  soundDefine.mTimeModified = ParseTimeString (element.@time_modified);
               }
               
               soundDefine.mName = element.@name;
               soundDefine.mAttributeBits = parseInt (element.@attribute_bits);
               soundDefine.mNumSamples = parseInt (element.@sample_count);
               
               var soundFileDataBase64:String = element.text () [0];
               if (soundFileDataBase64 == null)
               {
                  soundDefine.mFileData = null;
               }
               else
               {
                  soundFileDataBase64 = soundFileDataBase64.replace (DataFormat3.Base64CharsRegExp, "");
                  soundDefine.mFileData = DataFormat3.DecodeString2ByteArray (soundFileDataBase64);
               }
               
               worldDefine.mSoundDefines.push (soundDefine);
            }
         }
         
         return worldDefine;
      }
      
      public static function ParseTimeString (timeText:String):Number
      {
         if (timeText == null || timeText.length < 3 || timeText.length > 14 || timeText.substring (0, 2).toLowerCase () != "0x")
            return 0;
         
         timeText = timeText.substring (2);
         if (timeText.length <= 6)
         {
            return parseInt (timeText, 16);
         }
         else
         {
            var time1:Number = parseInt (timeText.substring (0, timeText.length - 6), 16);
            var time2:Number = parseInt (timeText.substring (timeText.length - 6), 16);
            
            return time1 * 0x1000000 + time2;
         }
      }
      
      public static function XmlElement2SceneDefine (worldDefine:WorldDefine, sceneXML:XML):Object
      {
         var sceneDefine:SceneDefine = new SceneDefine;
         
         var element:XML;
         
         // ...
         
         if (worldDefine.mVersion >= 0x0200)
         {
            sceneDefine.mKey = sceneXML.@key;
            sceneDefine.mName = sceneXML.@name;
         }
         
         // settings
         if (worldDefine.mVersion >= 0x0104)
         {
            for each (element in sceneXML.Settings.Setting)
            {
               //>>from v1.51
               if (element.@name == "ui_flags")
                  sceneDefine.mSettings.mViewerUiFlags = parseInt (element.@value);
               else if (element.@name == "play_bar_color")
                  sceneDefine.mSettings.mPlayBarColor = parseInt ( (element.@value).substr (2), 16);
               else if (element.@name == "viewport_width")
                  sceneDefine.mSettings.mViewportWidth = parseInt (element.@value)
               else if (element.@name == "viewport_height")
                  sceneDefine.mSettings.mViewportHeight = parseInt (element.@value)
               else if (element.@name == "zoom_scale")
                  sceneDefine.mSettings.mZoomScale = parseFloat (element.@value);
               //<<
               
               else if (element.@name == "camera_center_x")
                  sceneDefine.mSettings.mCameraCenterX = parseInt (element.@value);
               else if (element.@name == "camera_center_y")
                  sceneDefine.mSettings.mCameraCenterY = parseInt (element.@value);
               else if (element.@name == "world_left")
                  sceneDefine.mSettings.mWorldLeft = parseInt (element.@value);
               else if (element.@name == "world_top")
                  sceneDefine.mSettings.mWorldTop  = parseInt (element.@value);
               else if (element.@name == "world_width")
                  sceneDefine.mSettings.mWorldWidth  = parseInt (element.@value);
               else if (element.@name == "world_height")
                  sceneDefine.mSettings.mWorldHeight = parseInt (element.@value);
               else if (element.@name == "background_color")
                  sceneDefine.mSettings.mBackgroundColor  = parseInt ( (element.@value).substr (2), 16);
               else if (element.@name == "build_border")
                  sceneDefine.mSettings.mBuildBorder  = parseInt (element.@value) != 0;
               else if (element.@name == "border_color")
                  sceneDefine.mSettings.mBorderColor = parseInt ( (element.@value).substr (2), 16);
               
               //>>from v1.06 to v1.08 (not include 1.08)
               else if (element.@name == "physics_shapes_potential_max_count")
                  sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount = parseInt (element.@value);
               else if (element.@name == "physics_shapes_population_density_level")
                  sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel = parseInt (element.@value);
               //<<
               
               //>>from v1.08
               else if (element.@name == "infinite_scene_size")
                  sceneDefine.mSettings.mIsInfiniteWorldSize = parseInt (element.@value) != 0;
               
               else if (element.@name == "border_at_top_layer")
                  sceneDefine.mSettings.mBorderAtTopLayer = parseInt (element.@value) != 0;
               else if (element.@name == "border_left_thinckness")
                  sceneDefine.mSettings.mWorldBorderLeftThickness = parseFloat (element.@value);
               else if (element.@name == "border_top_thinckness")
                  sceneDefine.mSettings.mWorldBorderTopThickness = parseFloat (element.@value);
               else if (element.@name == "border_right_thinckness")
                  sceneDefine.mSettings.mWorldBorderRightThickness = parseFloat (element.@value);
               else if (element.@name == "border_bottom_thinckness")
                  sceneDefine.mSettings.mWorldBorderBottomThickness = parseFloat (element.@value);
               
               else if (element.@name == "gravity_acceleration_magnitude")
                  sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude = parseFloat (element.@value);
               else if (element.@name == "gravity_acceleration_angle")
                  sceneDefine.mSettings.mDefaultGravityAccelerationAngle = parseFloat (element.@value);
               
               else if (element.@name == "right_hand_coordinates")
                  sceneDefine.mSettings.mRightHandCoordinates = parseInt (element.@value) != 0;
               else if (element.@name == "coordinates_origin_x")
                  sceneDefine.mSettings.mCoordinatesOriginX = parseFloat (element.@value);
               else if (element.@name == "coordinates_origin_y")
                  sceneDefine.mSettings.mCoordinatesOriginY = parseFloat (element.@value);
               else if (element.@name == "coordinates_scale")
                  sceneDefine.mSettings.mCoordinatesScale = parseFloat (element.@value);
               
               else if (element.@name == "ci_rules_enabled")
                  sceneDefine.mSettings.mIsCiRulesEnabled = parseInt (element.@value) != 0;
               //<<
               
               //>>from v1.55
               else if (element.@name == "auto_sleeping_enabled")
                  sceneDefine.mSettings.mAutoSleepingEnabled = parseInt (element.@value) != 0;
               else if (element.@name == "camera_rotating_enabled")
                  sceneDefine.mSettings.mCameraRotatingEnabled = parseInt (element.@value) != 0;
               //<<
               
               //>>from v1.60
               else if (element.@name == "initial_speedx")
                  sceneDefine.mSettings.mInitialSpeedX = parseInt (element.@value);
               else if (element.@name == "preferred_fps")
                  sceneDefine.mSettings.mPreferredFPS = parseFloat (element.@value);
               else if (element.@name == "pause_on_focus_lost")
                  sceneDefine.mSettings.mPauseOnFocusLost = parseInt (element.@value) != 0;
               
               else if (element.@name == "physics_simulation_enabled")
                  sceneDefine.mSettings.mPhysicsSimulationEnabled = parseInt (element.@value) != 0;
               else if (element.@name == "physics_simulation_time_step")
                  sceneDefine.mSettings.mPhysicsSimulationStepTimeLength = parseFloat (element.@value);
               else if (element.@name == "physics_simulation_quality")
                  sceneDefine.mSettings.mPhysicsSimulationQuality = parseInt ( (element.@value).substr (2), 16);
               else if (element.@name == "physics_simulation_check_toi")
                  sceneDefine.mSettings.mCheckTimeOfImpact = parseInt (element.@value) != 0;
               //<<
               
               else
                  trace ("Unkown setting: " + element.@name);
            }
         }
         
         // must be loaded before loading codesnippets in entities.
         if (worldDefine.mVersion >= 0x0153)
         {
            var functionDefine:FunctionDefine;
            
            for each (element in sceneXML.CustomFunctions.Function)
            {
               functionDefine = new FunctionDefine ();
               
               TriggerFormatHelper.Xml2FunctionDefine (element, functionDefine, true, true, null);
               
               sceneDefine.mFunctionDefines.push (functionDefine);
            }
            
            var functionId:int = 0;
            for each (element in sceneXML.CustomFunctions.Function)
            {
               functionDefine = sceneDefine.mFunctionDefines [functionId ++];
               
               TriggerFormatHelper.Xml2FunctionDefine (element, functionDefine, true, false, sceneDefine.mFunctionDefines);
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  functionDefine.mKey = element.@key;
                  functionDefine.mTimeModified = ParseTimeString (element.@time_modified);
               }
               
               functionDefine.mName = element.@name;
               functionDefine.mPosX = parseFloat (element.@x);
               functionDefine.mPosY = parseFloat (element.@y);
               if (worldDefine.mVersion >= 0x0156)
               {
                  functionDefine.mDesignDependent = parseInt (element.@design_dependent) != 0;
               }
            }
         }
         
         var appearId:int;
         var createId:int;
         
         for each (element in sceneXML.Entities.Entity)
         {
            var entityDefine:Object = XmlElement2EntityDefine (element, worldDefine, sceneDefine);
            
            sceneDefine.mEntityDefines.push (entityDefine);
         }
         
         // ...
         // worldDefine.mVersion >= 0x0107
         if (sceneXML.EntityAppearingOrder != undefined)
         {
            IndicesString2IntegerArray (sceneXML.EntityAppearingOrder.@entity_indices, sceneDefine.mEntityAppearanceOrder);
         }
         
         // ...
         
         var groupId:int;
         var brotherGroup:Array;
         var brotherIDs:Array;
         
         for each (element in sceneXML.BrotherGroups.BrotherGroup)
         {
            brotherIDs = IndicesString2IntegerArray (element.@brother_indices);
            
            sceneDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            for each (element in sceneXML.CollisionCategories.CollisionCategory)
            {
               var ccDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  ccDefine.mKey = element.@key;
                  ccDefine.mTimeModified = ParseTimeString (element.@time_modified);
               }
               
               ccDefine.mName = element.@name;
               ccDefine.mCollideInternally = parseInt (element.@collide_internally) != 0;
               ccDefine.mPosX = parseFloat (element.@x);
               ccDefine.mPosY = parseFloat (element.@y);
               
               sceneDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            sceneDefine.mDefaultCollisionCategoryIndex = parseInt (sceneXML.CollisionCategories.@default_category_index);
            
            for each (element in sceneXML.CollisionCategoryFriendPairs.CollisionCategoryFriendPair)
            {
               var pairDefine:Object = new Object ();
               
               pairDefine.mCollisionCategory1Index = parseInt (element.@category1_index);
               pairDefine.mCollisionCategory2Index = parseInt (element.@category2_index);
               
               sceneDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         
         // custom variables
         
         if (worldDefine.mVersion >= 0x0152)
         {
            //>> v1.52 only
            //var variableSpaceDefine:VariableSpaceDefine;
            //
            //for each (element in sceneXML.GlobalVariables.VariablePackage)
            //{
            //   variableSpaceDefine = TriggerFormatHelper.VariableSpaceXml2Define (element);
            //   variableSpaceDefine.mSpaceType = ValueSpaceTypeDefine.ValueSpace_Global;
            //   sceneDefine.mGlobalVariableSpaceDefines.push (variableSpaceDefine);
            //}
            
            //for each (element in sceneXML.EntityProperties.VariablePackage)
            //{
            //   variableSpaceDefine = TriggerFormatHelper.VariableSpaceXml2Define (element);
            //   variableSpaceDefine.mSpaceType = ValueSpaceTypeDefine.ValueSpace_Entity;
            //   sceneDefine.mEntityPropertySpaceDefines.push (variableSpaceDefine);
            //}
            
            if (worldDefine.mVersion == 0x0152)
            {
               TriggerFormatHelper.VariablesXml2Define (sceneXML.GlobalVariables.VariablePackage [0], sceneDefine.mGlobalVariableDefines, true);
               TriggerFormatHelper.VariablesXml2Define (sceneXML.EntityProperties.VariablePackage [0], sceneDefine.mEntityPropertyDefines, true);
            }
            else
            {
               if (worldDefine.mVersion >= 0x0157)
               {
                  TriggerFormatHelper.VariablesXml2Define (sceneXML.SessionVariables [0], sceneDefine.mSessionVariableDefines, true);
               }
               
               TriggerFormatHelper.VariablesXml2Define (sceneXML.GlobalVariables [0], sceneDefine.mGlobalVariableDefines, true);
               TriggerFormatHelper.VariablesXml2Define (sceneXML.EntityProperties [0], sceneDefine.mEntityPropertyDefines, true);
            }
         }
         
         return sceneDefine;
      }
      
      public static function XmlElements2ModuleInstanceDefines (worldVersion:int, xmlElements:XMLList, forSequencedModule:Boolean):Array
      {
         var moduleInstanceDefines:Array = new Array ();
         
         for each (var element:XML in xmlElements)
         {
            var moduleInstanceDefine:Object = new Object ();
            
            moduleInstanceDefine.mPosX = parseFloat (element.@x);
            moduleInstanceDefine.mPosY = parseFloat (element.@y);
            moduleInstanceDefine.mScale = parseFloat(element.@scale);
            moduleInstanceDefine.mIsFlipped = parseInt (element.@flipped) != 0;
            moduleInstanceDefine.mRotation = parseFloat (element.@r);
            moduleInstanceDefine.mVisible = parseInt (element.@visible) != 0;
            moduleInstanceDefine.mAlpha = parseFloat (element.@alpha);
            
            if (forSequencedModule)
            {
               moduleInstanceDefine.mModuleDuration = parseFloat (element.@duration);
            }
            
            XmlElement2ModuleInstanceDefine (worldVersion, moduleInstanceDefine, element);
            
            moduleInstanceDefines.push (moduleInstanceDefine);
         }
         
         return moduleInstanceDefines;
      }
      
      public static function XmlElement2ModuleInstanceDefine (worldVersion:int, moduleInstanceDefine:Object, element:XML):void
      {
         moduleInstanceDefine.mModuleType = element.@module_type;
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            moduleInstanceDefine.mShapeAttributeBits = parseInt (element.@shape_attribute_bits);
            moduleInstanceDefine.mShapeBodyOpacityAndColor = element.@shape_body_argb == undefined ? 0x0 : uint (parseInt ( (element.@shape_body_argb).substr (2), 16));
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapePathThickness = parseFloat (element.@shape_path_thickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  moduleInstanceDefine.mPolyLocalPoints = XmlElement2LocalVertices (element);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapeBorderOpacityAndColor = element.@shape_border_argb == undefined ? 0x0 : uint (parseInt ( (element.@shape_border_argb).substr (2), 16));
               moduleInstanceDefine.mShapeBorderThickness = parseFloat (element.@shape_border_thickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  moduleInstanceDefine.mCircleRadius = parseFloat (element.@circle_radius);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  moduleInstanceDefine.mRectHalfWidth = parseFloat (element.@rect_half_width);
                  moduleInstanceDefine.mRectHalfHeight = parseFloat (element.@rect_half_height);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  moduleInstanceDefine.mPolyLocalPoints = XmlElement2LocalVertices (element);
               }
               
               if (worldVersion >= 0x0160)
               {
                  moduleInstanceDefine.mBodyTextureDefine = Xml2TextureDefine (element.BodyTexture);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               moduleInstanceDefine.mModuleIndex = parseInt (element.@module_index);
            }
         }
         else // ...
         {
         }
      }
      
      public static function Xml2TextureDefine (textureElement:Object):Object
      {
         var textureDefine:Object = new Object ();
         
         textureDefine.mModuleIndex = parseInt (textureElement.@module_index);
         if (textureDefine.mModuleIndex >= 0)
         {
            textureDefine.mPosX = parseFloat (textureElement.@x);
            textureDefine.mPosY = parseFloat (textureElement.@y);
            textureDefine.mScale = parseFloat(textureElement.@scale);
            textureDefine.mIsFlipped = parseInt (textureElement.@flipped) != 0;
            textureDefine.mRotation = parseFloat (textureElement.@r);
         }
         
         return textureDefine;
      }
      
      public static function Xml2ShapePhysicsProperties (entityDefine:Object, element:XML, worldDefine:WorldDefine):void
      {
         if (worldDefine.mVersion >= 0x0104)
         {
            entityDefine.mIsPhysicsEnabled = parseInt (element.@enable_physics) != 0;
            
            // move down from v1.05
            /////entityDefine.mIsSensor = parseInt (element.@is_sensor) != 0; 
         }
         else
         {
            entityDefine.mIsPhysicsEnabled = true; // always true before v1.04
            // entityDefine.mIsSensor will be filled in FillMissedFieldsInWorldDefine
         }
         
         if (entityDefine.mIsPhysicsEnabled)
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mCollisionCategoryIndex = element.@collision_category_index;
            }
            
            entityDefine.mIsStatic = parseInt (element.@is_static) != 0;
            entityDefine.mIsBullet = parseInt (element.@is_bullet) != 0;
            entityDefine.mDensity = parseFloat (element.@density);
            entityDefine.mFriction = parseFloat (element.@friction);
            entityDefine.mRestitution = parseFloat (element.@restitution);
            
            if (worldDefine.mVersion >= 0x0104)
            {
               // add in v1,04, move here from above from v1.05
               entityDefine.mIsSensor = parseInt (element.@is_sensor) != 0
            }
            
            if (worldDefine.mVersion >= 0x0105)
            {
               entityDefine.mIsHollow = parseInt (element.@is_hollow) != 0;
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mBuildBorder = parseInt (element.@build_border) != 0;
               entityDefine.mIsSleepingAllowed = parseInt (element.@sleeping_allowed) != 0;
               entityDefine.mIsRotationFixed = parseInt (element.@rotation_fixed) != 0;
               entityDefine.mLinearVelocityMagnitude = parseFloat (element.@linear_velocity_magnitude);
               entityDefine.mLinearVelocityAngle = parseFloat (element.@linear_velocity_angle);
               entityDefine.mAngularVelocity = parseFloat (element.@angular_velocity);
            }
         }
      }
      
      public static function XmlElement2LocalVertices (element:XML):Array
      {
         var points:Array = new Array ();
         for each (var elementLocalVertex:XML in element.LocalVertices.Vertex)
         {
            points.push (new Point (parseFloat (elementLocalVertex.@x), parseFloat (elementLocalVertex.@y)));
         }
         
         return points;
      }
      
      public static function IndicesString2IntegerArray (indicesStr:String, idArray:Array = null):Array
      {
         if (idArray == null)
            idArray = new Array ();
         
         if (indicesStr == null || indicesStr.length == 0)
            return idArray;
         
         var indexStrArray:Array = indicesStr.split (/,/);
         
         var index:int;
         for (var i:int = 0; i < indexStrArray.length; ++ i)
         {
            index = parseInt (indexStrArray [i]);;
            if (isNaN (index))
               index = -1;
            
            idArray.push (index);
         }
         
         return idArray;
      }
      
      public static function XmlElement2EntityDefine (element:XML, worldDefine:WorldDefine, sceneDefine:SceneDefine):Object
      {
         var elementLocalVertex:XML;
         
         var entityDefine:Object = new Object ();
         
         entityDefine.mEntityType = parseInt (element.@entity_type);
         entityDefine.mPosX = parseFloat (element.@x);
         entityDefine.mPosY = parseFloat (element.@y);
         if (worldDefine.mVersion >= 0x0158)
         {
            entityDefine.mScale = parseFloat (element.@scale);
            entityDefine.mIsFlipped = parseInt (element.@flipped) != 0;
         }
         entityDefine.mRotation = parseFloat (element.@r);
         entityDefine.mIsVisible = parseInt (element.@visible) != 0;
         
         if (worldDefine.mVersion >= 0x0108)
         {
            entityDefine.mAlpha = parseFloat (element.@alpha);;
            entityDefine.mIsEnabled = parseInt (element.@active) != 0;
         }
         
         if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
         {
            //>>from v1.05
            if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
            {
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mFollowedTarget = parseFloat (element.@followed_target);
                  entityDefine.mFollowingStyle = parseFloat (element.@following_style);
               }
            }
            //<<
            //>>from v1.10
            else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
            {
               entityDefine.mPowerSourceType = parseInt (element.@power_source_type);
               entityDefine.mPowerMagnitude = parseFloat (element.@power_magnitude);
               entityDefine.mKeyboardEventId = parseInt (element.@keyboard_event_id);
               entityDefine.mKeyCodes = IndicesString2IntegerArray (element.@key_codes);
            }
            //<<
         }
         else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
         {
            if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
               else
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, false, sceneDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
            {
               entityDefine.mInputAssignerCreationIds = IndicesString2IntegerArray (element.@assigner_indices);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
            {
               entityDefine.mIsAnd = parseInt (element.@is_and) != 0;
               entityDefine.mIsNot = parseInt (element.@is_not) != 0;
               
               TriggerFormatHelper.CondtionListXml2EntityDefineProperties (element.Conditions, entityDefine);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
            {
               entityDefine.mSelectorType = parseInt (element.@selector_type);
               entityDefine.mEntityCreationIds = IndicesString2IntegerArray (element.@entity_indices);
               entityDefine.mNumEntities = entityDefine.mEntityCreationIds.length;
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
            {
               entityDefine.mPairingType = parseInt (element.@pairing_type);
               entityDefine.mEntityCreationIds1 = IndicesString2IntegerArray (element.@entity_indices1);
               entityDefine.mNumEntities1 = entityDefine.mEntityCreationIds1.length;
               entityDefine.mEntityCreationIds2 = IndicesString2IntegerArray (element.@entity_indices2);
               entityDefine.mNumEntities2 = entityDefine.mEntityCreationIds2.length;
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
            {
               entityDefine.mEventId = parseInt (element.@event_id);
               entityDefine.mInputConditionEntityCreationId = parseInt (element.@input_condition_entity_index);
               entityDefine.mInputConditionTargetValue = parseInt (element.@input_condition_target_value);
               entityDefine.mInputAssignerCreationIds = IndicesString2IntegerArray (element.@assigner_indices);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mExternalActionEntityCreationId = parseInt (element.@external_action_entity_index);
               }
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        entityDefine.mRunningInterval = parseFloat (element.@running_interval);
                        entityDefine.mOnlyRunOnce = parseInt (element.@only_run_once) != 0;
                        
                        if (worldDefine.mVersion >= 0x0156)
                        {
                           if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                           {
                              entityDefine.mPreFunctionDefine = new FunctionDefine ();
                              TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mPreFunctionDefine, false, true, sceneDefine.mFunctionDefines, false, element.PreHandlingCodeSnippet [0]);
                              
                              entityDefine.mPostFunctionDefine = new FunctionDefine ();
                              TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mPostFunctionDefine, false, true, sceneDefine.mFunctionDefines, false, element.PostHandlingCodeSnippet [0]);
                           }
                        }
                        
                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        entityDefine.mKeyCodes = IndicesString2IntegerArray (element.@key_codes);
                        break;
                     case CoreEventIds.ID_OnMouseGesture:
                        entityDefine.mGestureIDs = IndicesString2IntegerArray (element.@gesture_ids);
                        break;
                     default:
                        break;
                  }
               }
               
               entityDefine.mFunctionDefine = new FunctionDefine ();
               if (worldDefine.mVersion >= 0x0153)
               {
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
               }
               else
               {
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, false, sceneDefine.mFunctionDefines);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
               else
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, false, sceneDefine.mFunctionDefines);
            }
            //>>from v1.56
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
            }
            //<<     
         }
         else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mDrawBorder = parseInt (element.@draw_border) != 0;
               entityDefine.mDrawBackground = parseInt (element.@draw_background) != 0;
            }
            
            if (worldDefine.mVersion >= 0x0104)
            {
               entityDefine.mBorderColor = parseInt ( (element.@border_color).substr (2), 16);
               entityDefine.mBorderThickness = parseInt (element.@border_thickness);
               entityDefine.mBackgroundColor = parseInt ( (element.@background_color).substr (2), 16);
               
               if (worldDefine.mVersion >= 0x0107)
                  entityDefine.mTransparency = parseInt (element.@background_opacity);
               else
                  entityDefine.mTransparency = parseInt (element.@transparency);
            }
            
            if (worldDefine.mVersion >= 0x0105)
            {
               if (worldDefine.mVersion >= 0x0107)
                  entityDefine.mBorderTransparency = parseInt (element.@border_opacity);
               else
                  entityDefine.mBorderTransparency = parseInt (element.@border_transparency);
            }
            
            if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
            {
               entityDefine.mAiType = parseInt (element.@ai_type);
               
               //...
               Xml2ShapePhysicsProperties (entityDefine, element, worldDefine);
               
               // ...
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  entityDefine.mRadius = parseFloat (element.@radius);
                  entityDefine.mAppearanceType = parseInt (element.@appearance_type);
               
                  if (worldDefine.mVersion >= 0x0160)
                  {
                     entityDefine.mBodyTextureDefine = Xml2TextureDefine (element.BodyTexture);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mIsRoundCorners = parseInt (element.@round_corners) != 0;
                  }
                  
                  entityDefine.mHalfWidth = parseFloat (element.@half_width);
                  entityDefine.mHalfHeight = parseFloat (element.@half_height);
               
                  if (worldDefine.mVersion >= 0x0160)
                  {
                     entityDefine.mBodyTextureDefine = Xml2TextureDefine (element.BodyTexture);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
               {
                  entityDefine.mLocalPoints = XmlElement2LocalVertices (element);
               
                  if (worldDefine.mVersion >= 0x0160)
                  {
                     entityDefine.mBodyTextureDefine = Xml2TextureDefine (element.BodyTexture);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
               {
                  entityDefine.mCurveThickness = parseInt (element.@curve_thickness);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mIsRoundEnds = parseInt (element.@round_ends) != 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0157)
                  {
                     entityDefine.mIsClosed = parseInt (element.@closed) != 0;
                  }
                  
                  entityDefine.mLocalPoints = XmlElement2LocalVertices (element);
               }
            }
            else
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText 
                  || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                  )
               {
                  entityDefine.mText = element.@text;
                  if (worldDefine.mVersion < 0x0108)
                     entityDefine.mWordWrap = parseInt (element.@autofit_width) != 0;
                  else
                     entityDefine.mWordWrap = parseInt (element.@word_wrap) != 0;
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mAdaptiveBackgroundSize = parseInt (element.@adaptive_background_size) != 0;
                     entityDefine.mTextColor = element.@text_color == undefined ? 0x0 : parseInt ( (element.@text_color).substr (2), 16);
                     entityDefine.mFontSize = parseInt (element.@font_size);
                     entityDefine.mIsBold = parseInt (element.@bold) != 0;
                     entityDefine.mIsItalic = parseInt (element.@italic) != 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0109)
                  {
                     entityDefine.mTextAlign = parseInt (element.@align) != 0;;
                     entityDefine.mIsUnderlined = parseInt (element.@underlined) != 0;;
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton) 
                     {
                        entityDefine.mUsingHandCursor = parseInt (element.@using_hand_cursor) != 0;
                        
                        entityDefine.mDrawBackground_MouseOver = parseInt (element.@draw_background_on_mouse_over) != 0;
                        entityDefine.mBackgroundColor_MouseOver = parseInt ( (element.@background_color_on_mouse_over).substr (2), 16);
                        entityDefine.mBackgroundTransparency_MouseOver = parseInt (element.@background_opacity_on_mouse_over);
                        
                        entityDefine.mDrawBorder_MouseOver = parseInt (element.@draw_border_on_mouse_over) != 0;
                        entityDefine.mBorderColor_MouseOver = parseInt ( (element.@border_color_on_mouse_over).substr (2), 16);
                        entityDefine.mBorderThickness_MouseOver = parseInt (element.@border_thickness_on_mouse_over);
                        entityDefine.mBorderTransparency_MouseOver = parseInt (element.@border_opacity_on_mouse_over);
                     }
                  }
                  
                  entityDefine.mHalfWidth = parseFloat (element.@half_width);
                  entityDefine.mHalfHeight = parseFloat (element.@half_height);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
               {
                  entityDefine.mRadius = parseFloat (element.@radius);
                  
                  if (worldDefine.mVersion >= 0x0105)
                  {
                     entityDefine.mInteractiveZones = parseInt (element.@interactive_zones, 2);
                     
                     entityDefine.mInteractiveConditions = parseInt (element.@interactive_conditions, 2);
                  }
                  else
                  {
                     // mIsInteractive is removed from v1.05.
                     // in FillMissedFieldsInWorldDefine (), mIsInteractive will be converted to mInteractiveZones
                     entityDefine.mIsInteractive = parseInt (element.@is_interactive) != 0;
                  }
                  
                  entityDefine.mInitialGravityAcceleration = parseFloat (element.@initial_gravity_acceleration);
                  entityDefine.mInitialGravityAngle = parseFloat (element.@initial_gravity_angle);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mMaximalGravityAcceleration = parseFloat (element.@maximal_gravity_acceleration);
                  }
               }
            }
         }
         //>> from v1.58
         else if (Define.IsShapeEntity (entityDefine.mEntityType))
         {
            if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
            {
               Xml2ShapePhysicsProperties (entityDefine, element, worldDefine);
               
               entityDefine.mModuleIndex = parseInt (element.@module_index);
            }
            else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
            {
               Xml2ShapePhysicsProperties (entityDefine, element, worldDefine);
               
               entityDefine.mModuleIndexUp = parseInt (element.@module_index_up);
               entityDefine.mModuleIndexOver = parseInt (element.@module_index_over);
               entityDefine.mModuleIndexDown = parseInt (element.@module_index_down);
            }
         }
         //<<
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            // 
            if (worldDefine.mVersion < 0x0104)
            {
               entityDefine.mCollideConnected = ("true" == String (element.@collide_connected));
            }
            else
            {
               entityDefine.mCollideConnected = parseInt (element.@collide_connected) != 0;
            }
            
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mConnectedShape1Index = parseInt (element.@connected_shape1_index);
               entityDefine.mConnectedShape2Index = parseInt (element.@connected_shape2_index);
            }
            else
            {
               // ...
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mBreakable = parseInt (element.@breakable) != 0;
            }
            
            if (entityDefine.mEntityType == Define.EntityType_JointHinge)
            {
               entityDefine.mAnchorEntityIndex = parseInt (element.@anchor_index);
               
               entityDefine.mEnableLimits = parseInt (element.@enable_limits) != 0;
               entityDefine.mLowerAngle = parseFloat (element.@lower_angle);
               entityDefine.mUpperAngle = parseFloat (element.@upper_angle);
               entityDefine.mEnableMotor = parseInt (element.@enable_motor) != 0;
               entityDefine.mMotorSpeed = parseFloat (element.@motor_speed);
               entityDefine.mBackAndForth = parseInt (element.@back_and_forth) != 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  entityDefine.mMaxMotorTorque = parseFloat (element.@max_motor_torque);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               entityDefine.mEnableLimits = parseInt (element.@enable_limits) != 0;
               entityDefine.mLowerTranslation = parseFloat (element.@lower_translation);
               entityDefine.mUpperTranslation = parseFloat (element.@upper_translation);
               entityDefine.mEnableMotor = parseInt (element.@enable_motor) != 0;
               entityDefine.mMotorSpeed = parseFloat (element.@motor_speed);
               entityDefine.mBackAndForth = parseInt (element.@back_and_forth) != 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  entityDefine.mMaxMotorForce = parseFloat (element.@max_motor_force);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mBreakDeltaLength = parseFloat (element.@break_delta_length);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               entityDefine.mStaticLengthRatio = parseFloat (element.@static_length_ratio);
               //entityDefine.mFrequencyHz = parseFloat (element.@frequency_hz);
               entityDefine.mSpringType = parseFloat (element.@spring_type);
               
               entityDefine.mDampingRatio = parseFloat (element.@damping_ratio);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mFrequencyDeterminedManner = parseInt (element.@frequency_determined_manner);
                  entityDefine.mFrequency = parseFloat (element.@frequency);
                  entityDefine.mSpringConstant = parseFloat (element.@spring_constant);
                  entityDefine.mBreakExtendedLength = parseFloat (element.@break_extended_length);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
            {
               entityDefine.mAnchorEntityIndex = parseInt (element.@anchor_index);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
            }
         }
         
         return entityDefine;
      }
      
//======================================================================================
// 
//======================================================================================
      
      public static function WorldDefine2ByteArray (worldDefine:WorldDefine):ByteArray
      {
         // from v1,03
         DataFormat2.FillMissedFieldsInWorldDefine (worldDefine);
         if (worldDefine.mVersion >= 0x0103)
         {
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         }
         
         //
         var byteArray:ByteArray = new ByteArray ();
         //byteArray.length = 1000000;
         
         // COlor INfection
         byteArray.writeByte ("C".charCodeAt (0));
         byteArray.writeByte ("O".charCodeAt (0));
         byteArray.writeByte ("I".charCodeAt (0));
         byteArray.writeByte ("N".charCodeAt (0));
         
         // basic
         {
            // version, author
            byteArray.writeShort (worldDefine.mVersion);
            byteArray.writeUTF (worldDefine.mAuthorName);
            byteArray.writeUTF (worldDefine.mAuthorHomepage);
            
            // removed since v1.02
            if (worldDefine.mVersion < 0x0102)
            {
               // hex
               byteArray.writeByte ("H".charCodeAt (0));
               byteArray.writeByte ("E".charCodeAt (0));
               byteArray.writeByte ("X".charCodeAt (0));
            }
            
            if (worldDefine.mVersion >= 0x0102)
            {
               byteArray.writeByte (worldDefine.mShareSourceCode ? 1 : 0);
               byteArray.writeByte (worldDefine.mPermitPublishing ? 1 : 0);
            }
         }
         
         // scenes

         if (worldDefine.mVersion >= 0x0200)
         {
            byteArray.writeShort (worldDefine.mSceneDefines.length);
            for (var sceneId:int = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
            {  
               SceneDefine2ByteArray (worldDefine, worldDefine.mSceneDefines [sceneId], byteArray);
            }
         }
         else
         {
            SceneDefine2ByteArray (worldDefine, worldDefine.mSceneDefines [0], byteArray);
         }
         
         // modules
         
         if (worldDefine.mVersion >= 0x0158)
         {
            byteArray.writeShort (worldDefine.mImageDefines.length);
            for (var imageId:int = 0; imageId < worldDefine.mImageDefines.length; ++ imageId)
            {
               var imageDefine:Object = worldDefine.mImageDefines [imageId];
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  byteArray.writeUTF (imageDefine.mKey == null ? "" : imageDefine.mKey);
                  WriteTimeValue (byteArray, imageDefine.mTimeModified);
               }
               
               byteArray.writeUTF (imageDefine.mName == null ? "" : imageDefine.mName);
               
               if (imageDefine.mFileData == null || imageDefine.mFileData.length == 0)
               {
                  byteArray.writeInt (0);
               }
               else
               {
                  byteArray.writeInt (imageDefine.mFileData.length);
                  byteArray.writeBytes (imageDefine.mFileData, 0, imageDefine.mFileData.length);
               }
            }

            byteArray.writeShort (worldDefine.mPureImageModuleDefines.length);
            for (var divisionId:int = 0; divisionId < worldDefine.mPureImageModuleDefines.length; ++ divisionId)
            {
               var divisionDefine:Object = worldDefine.mPureImageModuleDefines [divisionId];
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  byteArray.writeUTF (divisionDefine.mKey == null ? "" : divisionDefine.mKey);
                  WriteTimeValue (byteArray, divisionDefine.mTimeModified);
               }

               byteArray.writeShort (divisionDefine.mImageIndex);
               byteArray.writeShort (divisionDefine.mLeft);
               byteArray.writeShort (divisionDefine.mTop);
               byteArray.writeShort (divisionDefine.mRight);
               byteArray.writeShort (divisionDefine.mBottom);
            }

            byteArray.writeShort (worldDefine.mAssembledModuleDefines.length);
            for (var assembledModuleId:int = 0; assembledModuleId < worldDefine.mAssembledModuleDefines.length; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  byteArray.writeUTF (assembledModuleDefine.mKey == null ? "" : assembledModuleDefine.mKey);
                  WriteTimeValue (byteArray, assembledModuleDefine.mTimeModified);
               }

               WriteModuleInstanceDefinesIntoBinFile (worldDefine.mVersion, byteArray, assembledModuleDefine.mModulePartDefines, false);
            }

            byteArray.writeShort (worldDefine.mSequencedModuleDefines.length);
            for (var sequencedModuleId:int = 0; sequencedModuleId < worldDefine.mSequencedModuleDefines.length; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  byteArray.writeUTF (sequencedModuleDefine.mKey == null ? "" : sequencedModuleDefine.mKey);
                  WriteTimeValue (byteArray, sequencedModuleDefine.mTimeModified);
               }

               if (worldDefine.mVersion >= 0x0202)
               {
                  byteArray.writeShort (sequencedModuleDefine.mSettingFlags);
               }

               WriteModuleInstanceDefinesIntoBinFile (worldDefine.mVersion, byteArray, sequencedModuleDefine.mModuleSequenceDefines, true);
            }
         }
         
         // sounds
         
         if (worldDefine.mVersion >= 0x0159)
         {
            byteArray.writeShort (worldDefine.mSoundDefines.length);
            for (var soundId:int = 0; soundId < worldDefine.mSoundDefines.length; ++ soundId)
            {
               var soundDefine:Object = worldDefine.mSoundDefines [soundId];
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  byteArray.writeUTF (soundDefine.mKey == null ? "" : soundDefine.mKey);
                  WriteTimeValue (byteArray, soundDefine.mTimeModified);
               }
               
               byteArray.writeUTF (soundDefine.mName == null ? "" : soundDefine.mName);
               byteArray.writeInt (soundDefine.mAttributeBits);
               byteArray.writeInt (soundDefine.mNumSamples);
               
               if (soundDefine.mFileData == null || soundDefine.mFileData == 0)
               {
                  byteArray.writeInt (0);
               }
               else
               {
                  byteArray.writeInt (soundDefine.mFileData.length);
                  byteArray.writeBytes (soundDefine.mFileData, 0, soundDefine.mFileData.length);
               }
            }
         }
         
         // ...
         //byteArray.length = byteArray.position;
         return byteArray;
      }
      
      public static function WriteTimeValue (byteArray:ByteArray, time:Number):void
      {
         var v3:Number = time & 0xFFFF;
         time /= 0x10000;
         var v2:Number = time & 0xFFFF;
         time /= 0x10000;
         var v1:Number = time & 0xFFFF;
         
         byteArray.writeShort (v1);
         byteArray.writeShort (v2);
         byteArray.writeShort (v3);
      }
      
      public static function SceneDefine2ByteArray (worldDefine:WorldDefine, sceneDefine:SceneDefine, byteArray:ByteArray):void
      {
         
         // ...
         
         if (worldDefine.mVersion >= 0x0200)
         {
            byteArray.writeUTF (sceneDefine.mKey  == null ? "" : sceneDefine.mKey);
            byteArray.writeUTF (sceneDefine.mName == null ? "" : sceneDefine.mName);
         }
         
         // settings
         {
            if (worldDefine.mVersion >= 0x0151)
            {
               byteArray.writeInt (sceneDefine.mSettings.mViewerUiFlags);
               byteArray.writeUnsignedInt (sceneDefine.mSettings.mPlayBarColor);
               byteArray.writeShort (sceneDefine.mSettings.mViewportWidth);
               byteArray.writeShort (sceneDefine.mSettings.mViewportHeight);
               byteArray.writeFloat (sceneDefine.mSettings.mZoomScale);
            }
            
            if (worldDefine.mVersion >= 0x0104)
            {
               byteArray.writeInt (sceneDefine.mSettings.mCameraCenterX);
               byteArray.writeInt (sceneDefine.mSettings.mCameraCenterY);
               byteArray.writeInt (sceneDefine.mSettings.mWorldLeft);
               byteArray.writeInt (sceneDefine.mSettings.mWorldTop);
               byteArray.writeInt (sceneDefine.mSettings.mWorldWidth);
               byteArray.writeInt (sceneDefine.mSettings.mWorldHeight);
               byteArray.writeUnsignedInt (sceneDefine.mSettings.mBackgroundColor);
               byteArray.writeByte (sceneDefine.mSettings.mBuildBorder ? 1 : 0);
               byteArray.writeUnsignedInt (sceneDefine.mSettings.mBorderColor);
            }
            
            if (worldDefine.mVersion >= 0x0106 && worldDefine.mVersion < 0x0108)
            {
               byteArray.writeInt (sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount);
               byteArray.writeShort (sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel);
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeByte (sceneDefine.mSettings.mIsInfiniteWorldSize ? 1 : 0);
               
               byteArray.writeByte (sceneDefine.mSettings.mBorderAtTopLayer ? 1 : 0);
               byteArray.writeFloat (sceneDefine.mSettings.mWorldBorderLeftThickness);
               byteArray.writeFloat (sceneDefine.mSettings.mWorldBorderTopThickness);
               byteArray.writeFloat (sceneDefine.mSettings.mWorldBorderRightThickness);
               byteArray.writeFloat (sceneDefine.mSettings.mWorldBorderBottomThickness);
               
               byteArray.writeFloat (sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude);
               byteArray.writeFloat (sceneDefine.mSettings.mDefaultGravityAccelerationAngle);
               
               byteArray.writeByte (sceneDefine.mSettings.mRightHandCoordinates ? 1 : 0);
               byteArray.writeDouble (sceneDefine.mSettings.mCoordinatesOriginX);
               byteArray.writeDouble (sceneDefine.mSettings.mCoordinatesOriginY);
               byteArray.writeDouble (sceneDefine.mSettings.mCoordinatesScale);
               
               byteArray.writeByte (sceneDefine.mSettings.mIsCiRulesEnabled ? 1 : 0);
            }
            
            if (worldDefine.mVersion >= 0x0155)
            {
               byteArray.writeByte (sceneDefine.mSettings.mAutoSleepingEnabled ? 1 : 0);
               byteArray.writeByte (sceneDefine.mSettings.mCameraRotatingEnabled ? 1 : 0);
            }
            
            if (worldDefine.mVersion >= 0x0160)
            {
               byteArray.writeByte (sceneDefine.mSettings.mInitialSpeedX);
               byteArray.writeFloat (sceneDefine.mSettings.mPreferredFPS);
               byteArray.writeByte (sceneDefine.mSettings.mPauseOnFocusLost ? 1 : 0);
               
               byteArray.writeByte (sceneDefine.mSettings.mPhysicsSimulationEnabled ? 1 : 0);
               byteArray.writeFloat (sceneDefine.mSettings.mPhysicsSimulationStepTimeLength);
               byteArray.writeUnsignedInt (sceneDefine.mSettings.mPhysicsSimulationQuality);
               byteArray.writeByte (sceneDefine.mSettings.mCheckTimeOfImpact ? 1 : 0);
            }
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            byteArray.writeShort (sceneDefine.mCollisionCategoryDefines.length);
            for (var ccId:int = 0; ccId < sceneDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = sceneDefine.mCollisionCategoryDefines [ccId];
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  byteArray.writeUTF (ccDefine.mKey == null ? "" : ccDefine.mKey);
                  WriteTimeValue (byteArray, ccDefine.mTimeModified);
               }
               
               byteArray.writeUTF (ccDefine.mName);
               byteArray.writeByte (ccDefine.mCollideInternally ? 1 : 0);
               byteArray.writeFloat (ccDefine.mPosX);
               byteArray.writeFloat (ccDefine.mPosY);
            }
            
            byteArray.writeShort (sceneDefine.mDefaultCollisionCategoryIndex);
            
            byteArray.writeShort (sceneDefine.mCollisionCategoryFriendLinkDefines.length);
            for (var pairId:int = 0; pairId < sceneDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = sceneDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               byteArray.writeShort (pairDefine.mCollisionCategory1Index);
               byteArray.writeShort (pairDefine.mCollisionCategory2Index);
            }
         }
         
         // custom functions
         
         if (worldDefine.mVersion >= 0x0153)
         {
            var functionId:int;
            var functionDefine:FunctionDefine;
            
            byteArray.writeShort (sceneDefine.mFunctionDefines.length);
            
            for (functionId = 0; functionId < sceneDefine.mFunctionDefines.length; ++ functionId)
            {
               functionDefine = sceneDefine.mFunctionDefines [functionId] as FunctionDefine;
               
               TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, functionDefine, true, true, null);
            }
            
            for (functionId = 0; functionId < sceneDefine.mFunctionDefines.length; ++ functionId)
            {
               functionDefine = sceneDefine.mFunctionDefines [functionId] as FunctionDefine;
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  byteArray.writeUTF (functionDefine.mKey == null ? "" : functionDefine.mKey);
                  WriteTimeValue (byteArray, functionDefine.mTimeModified);
               }
               
               byteArray.writeUTF (functionDefine.mName);
               byteArray.writeFloat (functionDefine.mPosX);
               byteArray.writeFloat (functionDefine.mPosY);
               
               if (worldDefine.mVersion >= 0x0156)
               {
                  byteArray.writeByte (functionDefine.mDesignDependent ? 1 : 0);
               }
               
               TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, functionDefine, true, false, sceneDefine.mFunctionDefines);
            }
         }
         
         // entities ...
         
         var appearId:int;
         var createId:int;
         var vertexId:int;
         
         var i:int;
         
         var numEntities:int = sceneDefine.mEntityDefines.length;
         
         byteArray.writeShort (sceneDefine.mEntityDefines.length);
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = sceneDefine.mEntityDefines [createId];
            
            byteArray.writeShort (entityDefine.mEntityType);
            if (worldDefine.mVersion >= 0x0103)
            {
               byteArray.writeDouble (entityDefine.mPosX);
               byteArray.writeDouble (entityDefine.mPosY);
            }
            else
            {
               byteArray.writeFloat (entityDefine.mPosX);
               byteArray.writeFloat (entityDefine.mPosY);
            }
            if (worldDefine.mVersion >= 0x0158)
            {
               byteArray.writeFloat (entityDefine.mScale);
               byteArray.writeByte (entityDefine.mIsFlipped ? 1 : 0);
            }
            byteArray.writeFloat (entityDefine.mRotation);
            byteArray.writeByte (entityDefine.mIsVisible ? 1 : 0);
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeFloat (entityDefine.mAlpha);
               byteArray.writeByte (entityDefine.mIsEnabled ? 1 : 0);
            }
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               // from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeByte (entityDefine.mFollowedTarget);
                     byteArray.writeByte (entityDefine.mFollowingStyle);
                  }
               }
               //<<
               //>>from v1.10
               else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
               {
                  byteArray.writeByte (entityDefine.mPowerSourceType);
                  byteArray.writeFloat (entityDefine.mPowerMagnitude);
                  byteArray.writeShort (entityDefine.mKeyboardEventId);
                  WriteShortArrayIntoBinFile (entityDefine.mKeyCodes, byteArray);
               }
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
                  else
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, false, sceneDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  WriteShortArrayIntoBinFile (entityDefine.mInputAssignerCreationIds, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  byteArray.writeByte (entityDefine.mIsAnd ? 1 : 0);
                  byteArray.writeByte (entityDefine.mIsNot ? 1 : 0);
                  
                  var target_values:Array = entityDefine.mInputConditionTargetValues;
                  var creation_ids:Array = entityDefine.mInputConditionEntityCreationIds;
                  var num:int = creation_ids.length;
                  if (num > target_values.length)
                     num = target_values.length;
                  
                  byteArray.writeShort (num);
                  for (i = 0; i < num; ++ i)
                  {
                     byteArray.writeShort (creation_ids [i]);
                     byteArray.writeByte (target_values [i]);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  byteArray.writeByte (entityDefine.mSelectorType);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  byteArray.writeByte (entityDefine.mPairingType);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds1, byteArray);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds2, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  byteArray.writeShort (entityDefine.mEventId);
                  byteArray.writeShort (entityDefine.mInputConditionEntityCreationId);
                  byteArray.writeByte (entityDefine.mInputConditionTargetValue);
                  WriteShortArrayIntoBinFile (entityDefine.mInputAssignerCreationIds, byteArray);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeShort (entityDefine.mExternalActionEntityCreationId);
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     switch (entityDefine.mEventId)
                     {
                        case CoreEventIds.ID_OnWorldTimer:
                        case CoreEventIds.ID_OnEntityTimer:
                        case CoreEventIds.ID_OnEntityPairTimer:
                           byteArray.writeFloat (entityDefine.mRunningInterval);
                           byteArray.writeByte (entityDefine.mOnlyRunOnce ? 1 : 0);
                           
                           if (worldDefine.mVersion >= 0x0156)
                           {
                              if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                              {
                                 TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mPreFunctionDefine, false, true, sceneDefine.mFunctionDefines, false);
                                 TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mPostFunctionDefine, false, true, sceneDefine.mFunctionDefines, false);
                              }
                           }
                           
                           break;
                        case CoreEventIds.ID_OnWorldKeyDown:
                        case CoreEventIds.ID_OnWorldKeyUp:
                        case CoreEventIds.ID_OnWorldKeyHold:
                           WriteShortArrayIntoBinFile (entityDefine.mKeyCodes, byteArray);
                           break;
                        case CoreEventIds.ID_OnMouseGesture:
                           WriteShortArrayIntoBinFile (entityDefine.mGestureIDs, byteArray);
                           break;
                        default:
                           break;
                     }
                  }
                  
                  if (worldDefine.mVersion >= 0x0153)
                  {
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
                  }
                  else
                  {
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, false, sceneDefine.mFunctionDefines);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
                  else
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, false, sceneDefine.mFunctionDefines);
               }
               //>>from v1.56
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, sceneDefine.mFunctionDefines);
               }
               //<<  
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  byteArray.writeByte (entityDefine.mDrawBorder);
                  byteArray.writeByte (entityDefine.mDrawBackground);
               }
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  byteArray.writeUnsignedInt (entityDefine.mBorderColor);
                  byteArray.writeByte (entityDefine.mBorderThickness);
                  byteArray.writeUnsignedInt (entityDefine.mBackgroundColor);
                  byteArray.writeByte (entityDefine.mTransparency);
               }
               
               if (worldDefine.mVersion >= 0x0105)
               {
                  byteArray.writeByte (entityDefine.mBorderTransparency);
               }
               
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  // ...
                  WriteShapePhysicsPropertiesAndAiType (byteArray, entityDefine, worldDefine, true);
                  
                  // ...
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     byteArray.writeFloat (entityDefine.mRadius);
                     byteArray.writeByte (entityDefine.mAppearanceType);
                     
                     if (worldDefine.mVersion >= 0x0160)
                     {
                        WriteTextureDefine (byteArray, entityDefine.mBodyTextureDefine);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mIsRoundCorners ? 1 : 0);
                     }
                     
                     byteArray.writeFloat (entityDefine.mHalfWidth);
                     byteArray.writeFloat (entityDefine.mHalfHeight);
                     
                     if (worldDefine.mVersion >= 0x0160)
                     {
                        WriteTextureDefine (byteArray, entityDefine.mBodyTextureDefine);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     WriteLocalVerticesIntoBinFile (byteArray, entityDefine.mLocalPoints);
                     
                     if (worldDefine.mVersion >= 0x0160)
                     {
                        WriteTextureDefine (byteArray, entityDefine.mBodyTextureDefine);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     byteArray.writeByte (entityDefine.mCurveThickness);
                  
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mIsRoundEnds ? 1 : 0);
                     }
                  
                     if (worldDefine.mVersion >= 0x0157)
                     {
                        byteArray.writeByte (entityDefine.mIsClosed ? 1 : 0);
                     }
                     
                     WriteLocalVerticesIntoBinFile (byteArray, entityDefine.mLocalPoints);
                  }
               }
               else // not physics entity
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText 
                     || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                     )
                  {
                     byteArray.writeUTF (entityDefine.mText);
                     byteArray.writeByte (entityDefine.mWordWrap ? 1 : 0);
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mAdaptiveBackgroundSize ? 1 : 0);
                        byteArray.writeUnsignedInt (entityDefine.mTextColor);
                        byteArray.writeShort (entityDefine.mFontSize);
                        byteArray.writeByte (entityDefine.mIsBold ? 1 : 0);
                        byteArray.writeByte (entityDefine.mIsItalic ? 1 : 0);
                     }
                     
                     if (worldDefine.mVersion >= 0x0109)
                     {
                        byteArray.writeByte (entityDefine.mTextAlign);
                        byteArray.writeByte (entityDefine.mIsUnderlined ? 1 : 0);
                     }
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton) 
                        {
                           byteArray.writeByte (entityDefine.mUsingHandCursor ? 1 : 0);
                           
                           byteArray.writeByte (entityDefine.mDrawBackground_MouseOver ? 1 : 0);
                           byteArray.writeUnsignedInt (entityDefine.mBackgroundColor_MouseOver);
                           byteArray.writeByte (entityDefine.mBackgroundTransparency_MouseOver);
                           
                           byteArray.writeByte (entityDefine.mDrawBorder_MouseOver ? 1 : 0);
                           byteArray.writeUnsignedInt (entityDefine.mBorderColor_MouseOver);
                           byteArray.writeByte (entityDefine.mBorderThickness_MouseOver);
                           byteArray.writeByte (entityDefine.mBorderTransparency_MouseOver);
                        }
                     }
                     
                     byteArray.writeFloat (entityDefine.mHalfWidth);
                     byteArray.writeFloat (entityDefine.mHalfHeight);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     byteArray.writeFloat (entityDefine.mRadius);
                     
                     if (worldDefine.mVersion >= 0x0105)
                     {
                        byteArray.writeByte (entityDefine.mInteractiveZones);
                        byteArray.writeShort (entityDefine.mInteractiveConditions);
                     }
                     else
                     {
                        byteArray.writeByte (entityDefine.mIsInteractive);
                     }
                     
                     byteArray.writeFloat (entityDefine.mInitialGravityAcceleration);
                     byteArray.writeShort (entityDefine.mInitialGravityAngle);
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeFloat (entityDefine.mMaximalGravityAcceleration);
                     }
                  }
               }
            }
            //>> from v1.58
            else if (Define.IsShapeEntity (entityDefine.mEntityType))
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
               {
                  WriteShapePhysicsPropertiesAndAiType (byteArray, entityDefine, worldDefine, false);
                  
                  byteArray.writeShort (entityDefine.mModuleIndex);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
               {
                  WriteShapePhysicsPropertiesAndAiType (byteArray, entityDefine, worldDefine, false);
                  
                  byteArray.writeShort (entityDefine.mModuleIndexUp);
                  byteArray.writeShort (entityDefine.mModuleIndexOver);
                  byteArray.writeShort (entityDefine.mModuleIndexDown);
               }
            }
            //<<
            else if (Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               byteArray.writeByte (entityDefine.mCollideConnected);
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  byteArray.writeShort (entityDefine.mConnectedShape1Index);
                  byteArray.writeShort (entityDefine.mConnectedShape2Index);
               }
               else if (worldDefine.mVersion >= 0x0102) // ??!! why bytes
               {
                  byteArray.writeByte (entityDefine.mConnectedShape1Index);
                  byteArray.writeByte (entityDefine.mConnectedShape2Index);
               }
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  byteArray.writeByte (entityDefine.mBreakable ? 1 : 0);
               }
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  byteArray.writeShort (entityDefine.mAnchorEntityIndex);
                  
                  byteArray.writeByte (entityDefine.mEnableLimits);
                  byteArray.writeFloat (entityDefine.mLowerAngle);
                  byteArray.writeFloat (entityDefine.mUpperAngle);
                  byteArray.writeByte (entityDefine.mEnableMotor);
                  byteArray.writeFloat (entityDefine.mMotorSpeed);
                  byteArray.writeByte (entityDefine.mBackAndForth);
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     byteArray.writeFloat (entityDefine.mMaxMotorTorque);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  byteArray.writeByte (entityDefine.mEnableLimits);
                  byteArray.writeFloat (entityDefine.mLowerTranslation);
                  byteArray.writeFloat (entityDefine.mUpperTranslation);
                  byteArray.writeByte (entityDefine.mEnableMotor);
                  byteArray.writeFloat (entityDefine.mMotorSpeed);
                  byteArray.writeByte (entityDefine.mBackAndForth);
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     byteArray.writeFloat (entityDefine.mMaxMotorForce);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeFloat (entityDefine.mBreakDeltaLength);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  byteArray.writeFloat (entityDefine.mStaticLengthRatio);
                  //byteArray.writeFloat (entityDefine.mFrequencyHz);
                  byteArray.writeByte (entityDefine.mSpringType);
                  
                  byteArray.writeFloat (entityDefine.mDampingRatio);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeByte (entityDefine.mFrequencyDeterminedManner);
                     byteArray.writeFloat (entityDefine.mFrequency);
                     byteArray.writeFloat (entityDefine.mSpringConstant);
                     byteArray.writeFloat (entityDefine.mBreakExtendedLength);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  byteArray.writeShort (entityDefine.mAnchorEntityIndex);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
               }
            }
         }
         
         // ...
         if (worldDefine.mVersion >= 0x0107)
         {
            WriteShortArrayIntoBinFile (sceneDefine.mEntityAppearanceOrder, byteArray);
         }
         
         // ...
         
         var groupId:int;
         var brotherIDs:Array;
         
         byteArray.writeShort (sceneDefine.mBrotherGroupDefines.length);
         
         for (groupId = 0; groupId < sceneDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = sceneDefine.mBrotherGroupDefines [groupId] as Array;
            
            WriteShortArrayIntoBinFile (brotherIDs, byteArray);
         }
         
         // custom variables
         if (worldDefine.mVersion >= 0x0152)
         {
            if (worldDefine.mVersion >= 0x0157)
            {
               TriggerFormatHelper.WriteVariableDefinesIntoBinFile (byteArray, sceneDefine.mSessionVariableDefines, true);
            }
            
            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.writeShort (1); // num global variable packages
               byteArray.writeUTF ("");//variableSpaceDefine.mName);
               byteArray.writeShort (-1);//variableSpaceDefine.mParentPackageId);
            }
            TriggerFormatHelper.WriteVariableDefinesIntoBinFile (byteArray, sceneDefine.mGlobalVariableDefines, true);
            
            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.writeShort (1); // num entity property packages
               byteArray.writeUTF ("");//variableSpaceDefine.mName);
               byteArray.writeShort (-1);//variableSpaceDefine.mParentPackageId);
            }
            TriggerFormatHelper.WriteVariableDefinesIntoBinFile (byteArray, sceneDefine.mEntityPropertyDefines, true);
         }
      }
      
      public static function WriteShapePhysicsPropertiesAndAiType (byteArray:ByteArray, entityDefine:Object, worldDefine:WorldDefine, writeAiType:Boolean):void
      {
         if (worldDefine.mVersion >= 0x0105) 
         {
            if (writeAiType)
               byteArray.writeByte (entityDefine.mAiType);
            
            byteArray.writeByte (entityDefine.mIsPhysicsEnabled);
            
            // the 2 lines are added in v1,04, and moved down from v1.05
            /////byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
            /////byteArray.writeByte (entityDefine.mIsSensor)
         }
         else if (worldDefine.mVersion >= 0x0104)
         {
            // changed the order of mAiType and mCollisionCategoryIndex, 
            // add mIsPhysicsEnabled and mIsSensor
            
            if (writeAiType)
               byteArray.writeByte (entityDefine.mAiType);
            
            byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
            byteArray.writeByte (entityDefine.mIsPhysicsEnabled);
            byteArray.writeByte (entityDefine.mIsSensor)
         }
         else 
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
            }
            
            if (writeAiType)
               byteArray.writeByte (entityDefine.mAiType);
            
            //entityDefine.mIsPhysicsEnabled = true; // already set in FillMissedFieldsInWorldDefine
         }
         
         if (entityDefine.mIsPhysicsEnabled) // always true before v1.05
         {
            byteArray.writeByte (entityDefine.mIsStatic);
            byteArray.writeByte (entityDefine.mIsBullet);
            byteArray.writeFloat (entityDefine.mDensity);
            byteArray.writeFloat (entityDefine.mFriction);
            byteArray.writeFloat (entityDefine.mRestitution);
            
            if (worldDefine.mVersion >= 0x0105)
            {
               // the 2 lines are added in v1,04, and moved here from above from v1.05
               byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
               byteArray.writeByte (entityDefine.mIsSensor)
               
               // ...
               byteArray.writeByte (entityDefine.mIsHollow);
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeByte (entityDefine.mBuildBorder ? 1 : 0);
               byteArray.writeByte (entityDefine.mIsSleepingAllowed ? 1 : 0);
               byteArray.writeByte (entityDefine.mIsRotationFixed) ? 1 : 0;
               byteArray.writeFloat (entityDefine.mLinearVelocityMagnitude);
               byteArray.writeFloat (entityDefine.mLinearVelocityAngle);
               byteArray.writeFloat (entityDefine.mAngularVelocity);
            }
         }
      }
         
      public static function WriteModuleInstanceDefinesIntoBinFile (worldVersion:int, byteArray:ByteArray, moduleInstanceDefines:Array, forSequencedModule:Boolean):void
      {
         byteArray.writeShort (moduleInstanceDefines.length);
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId];
            
            byteArray.writeFloat (moduleInstanceDefine.mPosX);
            byteArray.writeFloat (moduleInstanceDefine.mPosY);
            byteArray.writeFloat (moduleInstanceDefine.mScale);
            byteArray.writeByte (moduleInstanceDefine.mIsFlipped ? 1 : 0);
            byteArray.writeFloat (moduleInstanceDefine.mRotation);
            byteArray.writeByte (moduleInstanceDefine.mVisible ? 1 : 0);
            byteArray.writeFloat (moduleInstanceDefine.mAlpha);
            
            if (forSequencedModule)
            {
               byteArray.writeFloat (moduleInstanceDefine.mModuleDuration);
            }
            
            WriteModuleInstanceDefineIntoBinFile (worldVersion, byteArray, moduleInstanceDefine);
         }
      }
      
      public static function WriteModuleInstanceDefineIntoBinFile (worldVersion:int, byteArray:ByteArray, moduleInstanceDefine:Object):void
      {
         byteArray.writeShort (moduleInstanceDefine.mModuleType);
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            byteArray.writeUnsignedInt (moduleInstanceDefine.mShapeAttributeBits);
            byteArray.writeUnsignedInt (moduleInstanceDefine.mShapeBodyOpacityAndColor);
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               byteArray.writeFloat (moduleInstanceDefine.mShapePathThickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  WriteLocalVerticesIntoBinFile (byteArray, moduleInstanceDefine.mPolyLocalPoints);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               byteArray.writeUnsignedInt (moduleInstanceDefine.mShapeBorderOpacityAndColor);
               byteArray.writeFloat (moduleInstanceDefine.mShapeBorderThickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  byteArray.writeFloat (moduleInstanceDefine.mCircleRadius);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  byteArray.writeFloat (moduleInstanceDefine.mRectHalfWidth);
                  byteArray.writeFloat (moduleInstanceDefine.mRectHalfHeight);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  WriteLocalVerticesIntoBinFile (byteArray, moduleInstanceDefine.mPolyLocalPoints);
               }
               
               if (worldVersion >= 0x0160)
               {
                  WriteTextureDefine (byteArray, moduleInstanceDefine.mBodyTextureDefine);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               byteArray.writeShort (moduleInstanceDefine.mModuleIndex);
            }
         }
         else // ...
         {
         }
      }
      
      public static function WriteTextureDefine (byteArray:ByteArray, textureDefine:Object):void
      {
         byteArray.writeShort (textureDefine.mModuleIndex);
         if (textureDefine.mModuleIndex >= 0)
         {
            byteArray.writeFloat (textureDefine.mPosX);
            byteArray.writeFloat (textureDefine.mPosY);
            byteArray.writeFloat (textureDefine.mScale);
            byteArray.writeByte (textureDefine.mIsFlipped ? 1 : 0);
            byteArray.writeFloat (textureDefine.mRotation);
         }
      }
      
      public static function WriteLocalVerticesIntoBinFile (byteArray:ByteArray, localPoints:Array):void
      {
         if (localPoints == null || localPoints.length == 0)
         {
            byteArray.writeShort (0);
         }
         else
         {
            byteArray.writeShort (localPoints.length);
            for (var vertexId:int = 0; vertexId < localPoints.length; ++ vertexId)
            {
               var point:Point = localPoints [vertexId] as Point;
               byteArray.writeFloat (point.x);
               byteArray.writeFloat (point.y);
            }
         }
      }
      
      public static function WriteShortArrayIntoBinFile (shortArray:Array, binFile:ByteArray):void
      {
         if (shortArray == null)
         {
            binFile.writeShort (0);
            return;
         }
         
         binFile.writeShort (shortArray.length);
         
         for (var i:int = 0; i < shortArray.length; ++ i)
         {
            binFile.writeShort (shortArray [i]);
         }
      }
      
      public static function WorldDefine2HexString (worldDefine:WorldDefine):String
      {
         return ByteArray2HexString (WorldDefine2ByteArray (worldDefine) );
      }
      
      public static function ByteArray2HexString (byteArray:ByteArray):String
      {
         if (byteArray == null)
            return null;
         
         var arrayLength:int = byteArray.length;
         var stringLength:int = arrayLength * 2;
         
         var hexString:String = "";
         var n1:int;
         var n2:int;
         
         for (var bi:int = 0; bi < arrayLength; ++ bi)
         {
            hexString = hexString + MakeHexStringFromByte (byteArray [bi]);
         }
         
         if (hexString.length != arrayLength * 2)
            trace ("hexString.length != arrayLength * 2");
         
         return En (hexString);
      }
      
      public static function MakeHexStringFromByte (byteValue:int):String
      {
         //if (byteValue < -128 || byteValue > 127)
         if (byteValue < 0 || byteValue > 255)
         {
            return "??";
         }
         
         var n1:int = (byteValue & 0xF0) >> 4;
         var n2:int = (byteValue & 0x0F);
         
         return DataFormat3.Value2Char (n1) + DataFormat3.Value2Char (n2);
      }
      
      public static function En (str:String):String
      {
         var enStr:String = "";
         
         var index:int = 0;
         var code:int;
         var num:int;
         while (index < str.length)
         {
            code = str.charCodeAt (index);
            num = 1;
            ++ index;
            while (num < 4 && index < str.length && str.charCodeAt (index) == code)
            {
               ++ num;
               ++ index;
            }
            
            enStr = enStr + DataFormat3.Value2Char (DataFormat3.Char2Value (code), num);
         }
         
         return enStr;
      }

//====================================================================================================================
//==================================== new playcode with base64 ======================================================
//====================================================================================================================

      public static function WorldDefine2PlayCode_Base64 (worldDefine:WorldDefine):String
      {
         var byteArray:ByteArray = WorldDefine2ByteArray (worldDefine);
         byteArray.compress ();
         return DataFormat3.EncodeByteArray2String (byteArray);
      }

   }
}
