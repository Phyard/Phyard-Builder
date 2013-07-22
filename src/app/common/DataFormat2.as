
package common {

   import flash.utils.ByteArray;
   import flash.geom.Point;
   
   import com.tapirgames.util.TextUtil;
   
   import player.WorldPlugin;
   
   import player.design.Global;
   import player.world.World;

   import player.entity.EntityBody;

   import player.entity.Entity;

   import player.entity.EntityVoid;

   import player.entity.EntityShape;
   import player.entity.EntityShapeCircle;
   import player.entity.EntityShapeRectangle;
   import player.entity.EntityShapePolygon;
   import player.entity.EntityShapePolyline;

   import player.entity.EntityShapeImageModuleGeneral;
   import player.entity.EntityShapeImageModuleButton;

   import player.entity.EntityJoint;
   import player.entity.EntityJointHinge;
   import player.entity.EntityJointSlider;
   import player.entity.EntityJointDistance;
   import player.entity.EntityJointSpring;
   import player.entity.EntityJointWeld;
   import player.entity.EntityJointDummy;

   import player.entity.SubEntityJointAnchor;

   import player.entity.EntityShape_Text;
   import player.entity.EntityShape_TextButton;
   import player.entity.EntityShape_Camera;
   import player.entity.EntityShape_PowerSource;
   import player.entity.EntityShape_GravityController;
   import player.entity.EntityShape_CircleBomb;
   import player.entity.EntityShape_RectangleBomb;

   import player.trigger.entity.EntityLogic;
   import player.trigger.entity.EntityBasicCondition;
   import player.trigger.entity.EntityTask;
   import player.trigger.entity.EntityConditionDoor;
   import player.trigger.entity.EntityInputEntityAssigner;
   import player.trigger.entity.EntityInputEntityFilter;
   import player.trigger.entity.EntityAction;
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.entity.EntityEventHandler_Timer;
   import player.trigger.entity.EntityEventHandler_Keyboard;
   import player.trigger.entity.EntityEventHandler_Gesture;

   import player.trigger.data.ListElement_EventHandler;

   import player.trigger.FunctionDefinition_Custom;

   import common.trigger.define.FunctionDefine;
   import common.trigger.define.CodeSnippetDefine;
   //import common.trigger.define.VariableSpaceDefine;

   import common.trigger.ValueSpaceTypeDefine;

   import common.trigger.CoreEventIds;
   
   import common.Define;

   public class DataFormat2
   {
      public static function Texture2TextureDefine(textureModuleIndex:int, textureTransform:Transform2D):Object
      {
         var textureDefine:Object = new Object ();
         
         textureDefine.mModuleIndex = textureModuleIndex;
         if (textureModuleIndex >= 0)
         {
            textureDefine.mPosX = textureTransform == null ? 0.0 : textureTransform.mOffsetX;
            textureDefine.mPosY = textureTransform == null ? 0.0 : textureTransform.mOffsetY;
            textureDefine.mScale = textureTransform == null ? 1.0 : textureTransform.mScale;
            textureDefine.mIsFlipped = textureTransform == null ? false : textureTransform.mFlipped;
            textureDefine.mRotation = textureTransform == null ? 0.0 : textureTransform.mRotation;
         }
         
         return textureDefine;
      }
      
      public static function CorrectEntityRefIndexes (entityIndexes:Array, correctionTable:Array):void
      {
         if (entityIndexes != null && correctionTable != null)
         {
            var numCorrections:int = correctionTable.length;
            
            var num:int = entityIndexes.length;
            var id:int;
            for (var i:int = 0; i < num; ++ i)
            {
               id = entityIndexes [i];
               
               if (id >= 0)
               {
                  if (id < numCorrections)
                     entityIndexes [i] = correctionTable [id];
                  else
                     entityIndexes [i] = -1;
               }
            }
         }
      }

//===========================================================================
// define -> world
//===========================================================================

      public static function CreateEntityInstance (playerWorld:World, entityDefine:Object):Entity
      {
         var entity:Entity = null;

         switch (entityDefine.mEntityType)
         {
         // basic shapes

            case Define.EntityType_ShapeCircle:
               if (entityDefine.mAiType == Define.ShapeAiType_Bomb)
                  entity = new EntityShape_CircleBomb (playerWorld);
               else
                  entity = new EntityShapeCircle (playerWorld);
               break;
            case Define.EntityType_ShapeRectangle:
               if (entityDefine.mAiType == Define.ShapeAiType_Bomb)
                  entity = new EntityShape_RectangleBomb (playerWorld);
               else
                  entity = new EntityShapeRectangle (playerWorld);
               break;
            case Define.EntityType_ShapePolygon:
               entity = new EntityShapePolygon (playerWorld);
               break;
            case Define.EntityType_ShapePolyline:
               entity = new EntityShapePolyline (playerWorld);
               break;

         // preset shapes

            case Define.EntityType_ShapeText:
               entity = new EntityShape_Text (playerWorld);
               break;
            case Define.EntityType_ShapeTextButton:
               entity = new EntityShape_TextButton (playerWorld);
               break;
            case Define.EntityType_UtilityCamera:
               entity = new EntityShape_Camera (playerWorld);
               break;
            case Define.EntityType_UtilityPowerSource:
               entity = new EntityShape_PowerSource (playerWorld);
               break;
            case Define.EntityType_ShapeGravityController:
               entity = new EntityShape_GravityController (playerWorld);
               break;

         // module shape
         
            case Define.EntityType_ShapeImageModule:
               entity = new EntityShapeImageModuleGeneral (playerWorld);
               break;
            case Define.EntityType_ShapeImageModuleButton:
               entity = new EntityShapeImageModuleButton (playerWorld);
               break;

         // basic joints

            case Define.EntityType_JointHinge:
               entity = new EntityJointHinge (playerWorld);
               break;
            case Define.EntityType_JointSlider:
               entity = new EntityJointSlider (playerWorld);
               break;
            case Define.EntityType_JointDistance:
               entity = new EntityJointDistance (playerWorld);
               break;
            case Define.EntityType_JointSpring:
               entity = new EntityJointSpring (playerWorld);
               break;
            case Define.EntityType_JointWeld:
               entity = new EntityJointWeld (playerWorld);
               break;
            case Define.EntityType_JointDummy:
               entity = new EntityJointDummy (playerWorld);
               break;

         // joint anchor

            case Define.SubEntityType_JointAnchor:
               entity = new SubEntityJointAnchor (playerWorld);
               break;

         // logic componnets

            case Define.EntityType_LogicCondition:
               entity = new EntityBasicCondition (playerWorld);
               break;
            case Define.EntityType_LogicTask:
               entity = new EntityTask (playerWorld);
               break;
            case Define.EntityType_LogicConditionDoor:
               entity = new EntityConditionDoor (playerWorld);
               break;
            case Define.EntityType_LogicInputEntityAssigner:
               entity = new EntityInputEntityAssigner (playerWorld, false);
               break;
            case Define.EntityType_LogicInputEntityPairAssigner:
               entity = new EntityInputEntityAssigner (playerWorld, true);
               break;
            case Define.EntityType_LogicInputEntityFilter:
               entity = new EntityInputEntityFilter (playerWorld, false);
               break;
            case Define.EntityType_LogicInputEntityPairFilter:
               entity = new EntityInputEntityFilter (playerWorld, true);
               break;
            case Define.EntityType_LogicAction:
               entity = new EntityAction (playerWorld);
               break;
            case Define.EntityType_LogicEventHandler:
               var eventId:int = entityDefine.mEventId;
               switch (eventId)
               {
                  case CoreEventIds.ID_OnWorldTimer:
                  case CoreEventIds.ID_OnEntityTimer:
                  case CoreEventIds.ID_OnEntityPairTimer:
                     entity = new EntityEventHandler_Timer (playerWorld);
                     break;
                  case CoreEventIds.ID_OnWorldKeyDown:
                  case CoreEventIds.ID_OnWorldKeyUp:
                  case CoreEventIds.ID_OnWorldKeyHold:
                     entity = new EntityEventHandler_Keyboard (playerWorld);
                     break;
                  case CoreEventIds.ID_OnMouseGesture:
                     entity = new EntityEventHandler_Gesture (playerWorld);
                     break;
                  default:
                     entity = new EntityEventHandler (playerWorld);
                     break;
               }
               break;
            default:
            {
               trace ("unknown entity type: " + entityDefine.mEntityType);
               break;
            }
         }

         return entity;
      }
      
      // playerWorld != null for cloning shape or merging scene, otherwise for loading from stretch
      // - isMergingScene is true for merging scene, otherwise for cloning shape
      // 
      // todo: support multiple scenes
      // 
      // for Viewer, the prototype is WorldDefine2PlayerWorld (defObject:Object) for all versions of World
      // see Viewer.as to get why here use Object instead of WorldDefine
      public static function WorldDefine2PlayerWorld (defObject:Object, playerWorld:World = null, isMergingScene:Boolean = false):World
      {
         var worldDefine:WorldDefine = defObject as WorldDefine;

         var isLoaingFromStretch:Boolean = (playerWorld == null); // false for importing

         //trace ("WorldDefine2PlayerWorld");

         if (isLoaingFromStretch)
         {
            isMergingScene = false; // forcely
         }
         
         if (isLoaingFromStretch || isMergingScene)
         {
            FillMissedFieldsInWorldDefine (worldDefine, worldDefine.mCurrentSceneId);
            if (worldDefine.mVersion >= 0x0103)
            {
               AdjustNumberValuesInWorldDefine (worldDefine, true, worldDefine.mCurrentSceneId);
            }
         }

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************
         
         if (worldDefine.mCurrentSceneId < 0 || worldDefine.mCurrentSceneId >= worldDefine.mSceneDefines.length)
            worldDefine.mCurrentSceneId = 0;
         
         var sceneDefine:SceneDefine = worldDefine.mSceneDefines [worldDefine.mCurrentSceneId];
         
         // sceneDefine.mName
         
   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************

         // worldDefine.mVersion >= 0x0107
         if (sceneDefine.mEntityAppearanceOrder.length != sceneDefine.mEntityDefines.length)
         {
            throw new Error ("numCreationOrderIds != numEntities");// ! " + sceneDefine.mEntityAppearanceOrder.length + " / " + sceneDefine.mEntityDefines.length);
            return null;
         }

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************

         var extraInfos:Object = new Object (); // this is introduced along with the MergeScene API

         if (isLoaingFromStretch)
         {
            //
            Global.InitGlobalData (worldDefine.mForRestartLevel, worldDefine.mDontReloadGlobalAssets);
            Global.mWorldDefine = worldDefine;
            
            //
            playerWorld = new World (sceneDefine) ; //worldDefine);
            playerWorld.SetCurrentSceneId (worldDefine.mCurrentSceneId);
            extraInfos.mBeinningCCatIndex = 0;
            playerWorld.CreateCollisionCategories (sceneDefine.mCollisionCategoryDefines, sceneDefine.mCollisionCategoryFriendLinkDefines); //worldDefine.mCollisionCategoryDefines, worldDefine.mCollisionCategoryFriendLinkDefines);
            playerWorld.SetBasicInfos (worldDefine);
            Global.SetCurrentWorld (playerWorld);
            
            // ...
            WorldPlugin.Call ("SetViewerParams", worldDefine.mViewerParams);
            worldDefine.mViewerParams = null;
         }
         else if (isMergingScene)
         {
            extraInfos.mBeinningCCatIndex = playerWorld.GetNumCollisionCategories () - 1; // "-1" is to ignore the hidden one
            playerWorld.CreateCollisionCategories (sceneDefine.mCollisionCategoryDefines, sceneDefine.mCollisionCategoryFriendLinkDefines, isMergingScene); //worldDefine.mCollisionCategoryDefines, worldDefine.mCollisionCategoryFriendLinkDefines);
         }
         // else // Clone Shapes

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************

         var numEntities:int = sceneDefine.mEntityAppearanceOrder.length;
         var entityDefineArray:Array = sceneDefine.mEntityDefines;
         var brotherGroupArray:Array = sceneDefine.mBrotherGroupDefines;
         var createId:int;
         var appearId:int;
         var entityDefine:Object;
         var entity:Entity;
         var shape:EntityShape;
         var joint:EntityJoint;
         var logic:EntityLogic;

         var groupId:int;
         var brotherGroup:Array;
         var body:EntityBody;

   //*********************************************************************************************************************************
   // create entity instances by the visual layer order
   //*********************************************************************************************************************************

         // for history reason, entities are packaged by children order in editor world.
         // so the appearId is also the appearance order id

         // instance entities by appearance layer order, entities can register their visual elements in constructor

         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
            createId = sceneDefine.mEntityAppearanceOrder [appearId];
            entityDefine = entityDefineArray [createId];
            
            entityDefine.mLoadingTimeInfos = new Object (); // from v2.00

            // >> starts from version 1.01
            // >> deprecated from v1.56
            //entityDefine.mWorldDefine = worldDefine; // ? sceneDefine
            // <<

            //>>from v1.07
            entityDefine.mAppearanceOrderId = appearId;
            entityDefine.mCreationOrderId = createId;
            //<<

            //entityDefine.mBodyId = -1; // seems useless now. ?

            entity = CreateEntityInstance (playerWorld, entityDefine);

            if (entity == null)
            {
               trace ("entity is not instanced!");
            }
            else
            {
               //entityDefine.mEntity = entity;
               entityDefine.mLoadingTimeInfos.mEntity = entity;
            }
         }

      // register entities by order of creation id
      
         var creationIdCorrectionTable:Array = new Array (numEntities); // ! important
         extraInfos.mEntityIdCorrectionTable = creationIdCorrectionTable;

         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = entityDefineArray [createId];
            //entity = entityDefine.mEntity;
            entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;

            if (entity != null) // shouldn't
            {
               if (isLoaingFromStretch)
               {
                  entity.Register (entityDefine.mCreationOrderId, entityDefine.mAppearanceOrderId);
               }
               else // clone shape or merge scene
               {
                  entity.Register (-1, -1);
                  
                  // comment off for it seems it is useless
                  //if (! isMergingScene) // clone shape
                  //{
                  //   entityDefine.mCreationOrderId = entity.GetCreationId ();
                  //}
               }
               
               creationIdCorrectionTable [createId] = entity.GetCreationId ();
            }
            else // impossible
            {
               creationIdCorrectionTable [createId] = -1;
            }
         }

      // init custom variables / correct entity refernce ids

         if (isLoaingFromStretch) // the following half is drawing feet for snakes // && (! worldDefine.mDontReloadGlobalAssets))
         {
            Global.InitWorldCustomVariables (worldDefine.mWorldVariableDefines, worldDefine.mGameSaveVariableDefines);
         }
         
         // these are the default values for isLoaingFromStretch and cloning shape, not for isMergingScene
         extraInfos.mSessionVariableIdMappingTable = null;
         extraInfos.mBeinningSessionVariableIndex = 0;
         extraInfos.mBeinningGlobalVariableIndex = 0;
         extraInfos.mBeinningCustomEntityVariableIndex = 0;
               
         if (isLoaingFromStretch || isMergingScene)
         {
            if (isMergingScene)
            {
               if (worldDefine.mForRestartLevel)
                  extraInfos.mSessionVariableIdMappingTable = new Array (sceneDefine.mSessionVariableDefines.length);
               extraInfos.mBeinningSessionVariableIndex = Global.GetSessionVariableSpace ().GetNumVariables ();
               extraInfos.mBeinningGlobalVariableIndex = Global.GetGlobalVariableSpace ().GetNumVariables ();
               extraInfos.mBeinningCustomEntityVariableIndex = Global.GetCustomEntityVariableSpace ().GetNumVariables ();
            }
            
            //Global.InitSceneCustomVariables (worldDefine.mGlobalVariableSpaceDefines, worldDefine.mEntityPropertySpaceDefines); // v1.52 only
            //Global.InitSceneCustomVariables (worldDefine.mGlobalVariableDefines, worldDefine.mEntityPropertyDefines, worldDefine.mSessionVariableDefines); // before v2.00
            extraInfos.mSessionVariableMappingTable = Global.InitSceneCustomVariables (
                                        sceneDefine.mGlobalVariableDefines, worldDefine.mCommonGlobalVariableDefines, 
                                        sceneDefine.mEntityPropertyDefines, worldDefine.mCommonEntityPropertyDefines, 
                                        sceneDefine.mSessionVariableDefines, extraInfos.mSessionVariableIdMappingTable,
                                        isMergingScene);
            
            // append the missed new custom variables for old entities
            // (merged with foloowing "init entity custom properties" block)
            //if (isMergingScene && Global.GetCustomEntityVariableSpace ().GetNumVariables () > extraInfos.mBeinningCustomEntityVariableIndex)
            //{
            //   playerWorld.OnCustomEntityVariablesAppended ();
            //} 
         }
         // following is moved to joint.Create (createStageId:int, entityDefine:Object, extraInfos:Object)
         //else // clone shape
         //{
         //   for (createId = 0; createId < numEntities; ++ createId)
         //   {
         //      entityDefine = entityDefineArray [createId];
         //      //entity = entityDefine.mEntity;
         //      entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;
         //
         //      if (Define.IsPhysicsJointEntity (entityDefine.mEntityType))
         //      {
         //         if (entityDefine.mConnectedShape1Index >= 0)
         //         {
         //            //entityDefine.mConnectedShape1Index = ((entityDefineArray [entityDefine.mConnectedShape1Index] as Object).mLoadingTimeInfos.mEntity as Entity).GetCreationId ();
         //            entityDefine.mConnectedShape1Index = ((entityDefineArray [entityDefine.mConnectedShape1Index] as Object).mLoadingTimeInfos.mEntity as Entity).GetCreationId ();
         //         }
         //         if (entityDefine.mConnectedShape2Index >= 0)
         //         {
         //            //entityDefine.mConnectedShape2Index = ((entityDefineArray [entityDefine.mConnectedShape2Index] as Object).mEntity as Entity).GetCreationId ();
         //            entityDefine.mConnectedShape2Index = ((entityDefineArray [entityDefine.mConnectedShape2Index] as Object).mLoadingTimeInfos.mEntity as Entity).GetCreationId ();
         //         }
         //
         //         // here, entityDefine.mAnchorEntityIndex is ignored, the reason is for shape-cloning, all joint defines must have mAnchor1EntityIndex and mAnchor2EntityIndex, and the values must be >= 0
         //         
         //         //entityDefine.mAnchor1EntityIndex = ((entityDefineArray [entityDefine.mAnchor1EntityIndex] as Object).mEntity as Entity).GetCreationId ();
         //         entityDefine.mAnchor1EntityIndex = ((entityDefineArray [entityDefine.mAnchor1EntityIndex] as Object).mLoadingTimeInfos.mEntity as Entity).GetCreationId ();
         //         //entityDefine.mAnchor2EntityIndex = ((entityDefineArray [entityDefine.mAnchor2EntityIndex] as Object).mEntity as Entity).GetCreationId ();
         //         entityDefine.mAnchor2EntityIndex = ((entityDefineArray [entityDefine.mAnchor2EntityIndex] as Object).mLoadingTimeInfos.mEntity as Entity).GetCreationId ();
         //      }
         //   }
         //}
         
         if (extraInfos.mSessionVariableIdMappingTable == null)
         {
            extraInfos.mSessionVariableIdMappingTable = new Array (sceneDefine.mSessionVariableDefines.length);
            for (var variableIndex:int = sceneDefine.mSessionVariableDefines.length - 1; variableIndex >= 0; -- variableIndex)
            {
               extraInfos.mSessionVariableIdMappingTable [variableIndex] = variableIndex + extraInfos.mBeinningSessionVariableIndex;
            }
         }
         
      // init entity custom properties
         //for (createId = 0; createId < numEntities; ++ createId)
         //{
         //   entityDefine = entityDefineArray [createId];
         //   //entity = entityDefine.mEntity;
         //   entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;
         //
         //   if (entity != null)
         //   {
         //      entity.InitCustomPropertyValues ();
         //   }
         //   
         //   // ! for other runtime craeted entities, InitCustomPropertyValues should be called manually.
         //}
         playerWorld.OnNumCustomEntityVariablesChanged (); // for both new and old entities

      // custom functions
         
         extraInfos.mBeginningCustomFunctionIndex = 0;

         if (isLoaingFromStretch || isMergingScene)
         {
            var oldNumCustomFunctions:int = Global.GetNumCustomFunctions ();
            
            if (isMergingScene)
            {
               extraInfos.mBeginningCustomFunctionIndex = oldNumCustomFunctions;
            }

            Global.CreateCustomFunctionDefinitions (sceneDefine.mFunctionDefines, isMergingScene);

            var numFunctions:int = sceneDefine.mFunctionDefines.length;
            for (var functionId:int = 0; functionId < numFunctions; ++ functionId)
            {
               var functionDefine:FunctionDefine = sceneDefine.mFunctionDefines [functionId] as FunctionDefine;
               var codeSnippetDefine:CodeSnippetDefine = (functionDefine.mCodeSnippetDefine as CodeSnippetDefine).Clone (); // ! clone is important
               codeSnippetDefine.DisplayValues2PhysicsValues (playerWorld.GetCoordinateSystem ());

               var customFunction:FunctionDefinition_Custom = Global.GetCustomFunctionDefinition (functionId + oldNumCustomFunctions);
               customFunction.SetDesignDependent (functionDefine.mDesignDependent); // useless
               customFunction.SetCodeSnippetDefine (codeSnippetDefine, extraInfos);
            }
         }
         else // Adjust Cloned Entities Z Order
         {
            for (createId = 0; createId < numEntities; ++ createId)
            {
               entityDefine = entityDefineArray [createId];
               //entity = entityDefine.mEntity as Entity;
               entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;
               var cloneFromEntity:Entity = entityDefine.mCloneFromEntity as Entity;

               if (entity != null && cloneFromEntity != null)
               {
                  entity.AdjustAppearanceOrder (cloneFromEntity, true);
               }
            }
         }
         
      // modules and sounds
         
         if (isLoaingFromStretch)
         {
            Global.CreateImageModules (worldDefine.mImageDefines, worldDefine.mPureImageModuleDefines, worldDefine.mAssembledModuleDefines, worldDefine.mSequencedModuleDefines);
            Global.CreateSounds (worldDefine.mSoundDefines);
            //Global.CheckWorldBuildingStatus (); // bug, EntityModule.mModuleIndex is not set yet. Moved to the end now.
         }

   //*********************************************************************************************************************************
   // create
   //*********************************************************************************************************************************

         for (var createStageId:int = 0; createStageId < Define.kNumCreateStages; ++ createStageId)
         {
            for (createId = 0; createId < numEntities; ++ createId)
            {
               entityDefine = entityDefineArray [createId];
               //entity = entityDefine.mEntity;
               entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;

               if (entity != null)
               {
                  entity.Create (createStageId, entityDefine, extraInfos);
               }
            }
         }

   //*********************************************************************************************************************************
   // register event handlers for entities
   //*********************************************************************************************************************************

         if (isLoaingFromStretch)
         {
            // moved to world.Init () now
            //playerWorld.RegisterEventHandlersForEntity (true); // for all entities placed in editor
         }
         else
         {
            // now, do it at the places where runtime-created entities are created.
            //for (createId = 0; createId < numEntities; ++ createId)
            //{
            //   entityDefine = entityDefineArray [createId];
            //   //entity = entityDefine.mEntity; // if this name changed, remember also change it in CloneShape ()
            //   entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;
            //
            //   if (entity != null)
            //   {
            //      playerWorld.RegisterEventHandlersForEntity (true, entity);
            //   }
            //}
         }

   //*********************************************************************************************************************************
   // create body for shapes, the created bodies have not build physics yet.
   // all bodies and entities_in_editor will also be registerd
   //*********************************************************************************************************************************

         var bortherId:int;

         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;

            body = new EntityBody (playerWorld);

            for (bortherId = 0; bortherId < brotherGroup.length; ++ bortherId)
            {
               createId = brotherGroup [bortherId];
               entityDefine = entityDefineArray [createId];
               //entity = entityDefine.mEntity;
               entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;

               if (entity is EntityShape)
               {
                  //entityDefine.mBody = body;
                  entityDefine.mLoadingTimeInfos.mBody = body;
               }
            }
         }

         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = entityDefineArray [createId];
            //entity = entityDefine.mEntity;
            entity = entityDefine.mLoadingTimeInfos.mEntity as Entity;

            if (entity is EntityShape)
            {
               shape = entity as EntityShape;

               //body = entityDefine.mBody;
               body = entityDefine.mLoadingTimeInfos.mBody;

               if (body == null) // for solo shapes
               {
                  body = new EntityBody (playerWorld);
                  //entityDefine.mBody = body;
                  entityDefine.mLoadingTimeInfos.mBody = body;
               }

               playerWorld.RegisterEntity (body);

               shape.SetBody (body);
            }
         }
         
   //*********************************************************************************************************************************
   // clear loading time infos
   //*********************************************************************************************************************************
         
         // for shape clone API, doesn't apply the clear action
         if (isLoaingFromStretch || isMergingScene)
         {
            for (createId = 0; createId < numEntities; ++ createId)
            {
               entityDefine = entityDefineArray [createId];
               entityDefine.mLoadingTimeInfos = undefined;
            }
         }

   //*********************************************************************************************************************************
   //
   //*********************************************************************************************************************************
         
         if (isLoaingFromStretch)
         {
            //Global.CheckWorldBuildingStatus (); // bug! playerWorld.mInitialized == false now, so UpdateImageModuleAppearances will do nothing.
         }
         else
         {
         }
         
         // removed from here, for many functions such as Global.SetPlaying are not registerd yet.
         // now will be called in Viewer.
         //playerWorld.Initialize ();

         return playerWorld;
      }
      
//====================================================================================
//
//====================================================================================

      public static function WorldDefine2Xml (worldDefine:WorldDefine):XML
      {
         // from v1,03
         FillMissedFieldsInWorldDefine (worldDefine);
         DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);

         // ...
         var xml:XML = <World />;

         var element:XML;

         // basic
         {
            xml.@app_id  = "COIN";
            xml.@version = uint(worldDefine.mVersion).toString (16);
            if (worldDefine.mVersion >= 0x0203)
            {
               xml.@key = worldDefine.mKey;
            }
            xml.@author_name = worldDefine.mAuthorName;
            xml.@author_homepage = worldDefine.mAuthorHomepage;

            if (worldDefine.mVersion >= 0x0102)
            {
               xml.@share_source_code = worldDefine.mShareSourceCode ? 1 : 0;
               xml.@permit_publishing = worldDefine.mPermitPublishing ? 1 : 0;
            }
         }
         
         // scenes

         if (worldDefine.mVersion >= 0x0200)
         {
            xml.Scenes = <Scenes />;
            for (var sceneId:int = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
            {  
               xml.Scenes.appendChild (SceneDefine2XmlElement (worldDefine, worldDefine.mSceneDefines [sceneId], null));
            }
         }
         else
         {
            SceneDefine2XmlElement (worldDefine, worldDefine.mSceneDefines [0], xml);
         }
                  
         // scene common variables
         
         if (worldDefine.mVersion >= 0x0203)
         {
            xml.WorldVariables = <WorldVariables />;
            xml.DataSaveVariables = <DataSaveVariables />;
            xml.CommonSceneGlobalVariables = <CommonSceneGlobalVariables />;
            xml.CommonSceneEntityProperties = <CommonSceneEntityProperties />;
            
            TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mGameSaveVariableDefines, xml.DataSaveVariables [0], true, true);
            TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mWorldVariableDefines, xml.WorldVariables [0], true, false);
            TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mCommonGlobalVariableDefines, xml.CommonSceneGlobalVariables [0], true, false);
            TriggerFormatHelper2.VariablesDefine2Xml (worldDefine.mCommonEntityPropertyDefines, xml.CommonSceneEntityProperties [0], true, false);
         }
         
         // image modules
         
         if (worldDefine.mVersion >= 0x0158)
         {
            xml.Images = <Images />;
            xml.ImageDivisions = <ImageDivisions />;
            xml.AssembledModules = <AssembledModules />;
            xml.SequencedModules = <SequencedModules />;
            
            for (var imageId:int = 0; imageId < worldDefine.mImageDefines.length; ++ imageId)
            {
               var imageDefine:Object = worldDefine.mImageDefines [imageId];
               
               if (imageDefine.mFileData == null || imageDefine.mFileData.length == 0)
               {
                  element = <Image/>;
               }
               else
               {
                  var imageFileDataBase64:String = DataFormat3.EncodeByteArray2String (imageDefine.mFileData);
                  element = <Image>{imageFileDataBase64}</Image>;
               }
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  element.@key = imageDefine.mKey;
                  element.@time_modified = TimeValue2HexString (imageDefine.mTimeModified);
               }
               
               element.@name = imageDefine.mName;
               //element.@file_data = imageDefine.mFileData;
               
               xml.Images.appendChild (element);
            }

            for (var divisionId:int = 0; divisionId < worldDefine.mPureImageModuleDefines.length; ++ divisionId)
            {
               var divisionDefine:Object = worldDefine.mPureImageModuleDefines [divisionId];

               element = <ImageDivision />;
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  element.@key = divisionDefine.mKey;
                  element.@time_modified = TimeValue2HexString (divisionDefine.mTimeModified);
               }
               
               element.@image_index = divisionDefine.mImageIndex;
               element.@left = divisionDefine.mLeft;
               element.@top = divisionDefine.mTop;
               element.@right = divisionDefine.mRight;
               element.@bottom = divisionDefine.mBottom;
               
               xml.ImageDivisions.appendChild (element);
            }

            for (var assembledModuleId:int = 0; assembledModuleId < worldDefine.mAssembledModuleDefines.length; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];

               element = <AssembledModule />;
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  element.@key = assembledModuleDefine.mKey;
                  element.@time_modified = TimeValue2HexString (assembledModuleDefine.mTimeModified);
               }
               
               ModuleInstanceDefines2XmlElements (worldDefine.mVersion, assembledModuleDefine.mModulePartDefines, element, "ModulePart", false);
               
               xml.AssembledModules.appendChild (element);
            }

            for (var sequencedModuleId:int = 0; sequencedModuleId < worldDefine.mSequencedModuleDefines.length; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];

               element = <SequencedModule />;
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  element.@key = sequencedModuleDefine.mKey;
                  element.@time_modified = TimeValue2HexString (sequencedModuleDefine.mTimeModified);
               }
               
               //element.@looped = sequencedModuleDefine.mIsLooped ? 1 : 0;
               
               
               if (worldDefine.mVersion >= 0x0202)
               {
                  element.@setting_flags = sequencedModuleDefine.mSettingFlags;
               }
               
               ModuleInstanceDefines2XmlElements (worldDefine.mVersion, sequencedModuleDefine.mModuleSequenceDefines, element, "ModuleSequence", true);
               
               xml.SequencedModules.appendChild (element);
            }
         }
         
         // sounds
         
         if (worldDefine.mVersion >= 0x0159)
         {
            xml.Sounds = <Sounds />;
            
            for (var soundId:int = 0; soundId < worldDefine.mSoundDefines.length; ++ soundId)
            {
               var soundDefine:Object = worldDefine.mSoundDefines [soundId];
               
               if (soundDefine.mFileData == null || soundDefine.mFileData.length == 0)
               {
                  element = <Sound/>;
               }
               else
               {
                  var soundFileDataBase64:String = DataFormat3.EncodeByteArray2String (soundDefine.mFileData);
                  element = <Sound>{soundFileDataBase64}</Sound>;
               }
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  element.@key = soundDefine.mKey;
                  element.@time_modified = TimeValue2HexString (soundDefine.mTimeModified);
               }
               
               element.@name = soundDefine.mName;
               element.@attribute_bits = soundDefine.mAttributeBits;
               element.@sample_count = soundDefine.mNumSamples;
               //element.@file_data = soundDefine.mFileData;
               
               xml.Sounds.appendChild (element);
            }
         }

         return xml;
      }
      
      private static const TimeValueFillZeroes:Array = ["000000", "00000", "0000", "000", "00", "0"];
      public static function TimeValue2HexString (time:Number):String
      {
         var time1:int = int (time / 0x1000000) & 0xFFFFFF;
         var time2:int = time & 0xFFFFFF;
         
         var str1:String = time1.toString (16);
         if (str1.length < 6)
            str1 = TimeValueFillZeroes [str1.length] + str1;
         
         var str2:String = time2.toString (16);
         if (str2.length < 6)
            str2 = TimeValueFillZeroes [str2.length] + str2;
         
         return "0x" + str1 + str2;
      }
      
      public static function SceneDefine2XmlElement (worldDefine:WorldDefine, sceneDefine:SceneDefine, xml:XML):XML
      {
         if (xml == null)
            xml = <Scene />;
         
         var element:XML;
         
         // ...
         
         if (worldDefine.mVersion >= 0x0200)
         {
            xml.@key  = sceneDefine.mKey  == null ? "" : sceneDefine.mKey;
            xml.@name = sceneDefine.mName == null ? "" : sceneDefine.mName;
         }
         
         // ...
         
         xml.Settings = <Settings />
         var Setting:Object;

         // settings
         if (worldDefine.mVersion >= 0x0151)
         {
            element = IntSetting2XmlElement ("ui_flags", sceneDefine.mSettings.mViewerUiFlags);
            xml.Settings.appendChild (element);
            element = IntSetting2XmlElement ("play_bar_color", sceneDefine.mSettings.mPlayBarColor, true);
            xml.Settings.appendChild (element);
            element = IntSetting2XmlElement ("viewport_width", sceneDefine.mSettings.mViewportWidth);
            xml.Settings.appendChild (element);
            element = IntSetting2XmlElement ("viewport_height", sceneDefine.mSettings.mViewportHeight);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("zoom_scale", sceneDefine.mSettings.mZoomScale, true);
            xml.Settings.appendChild (element);
         }

         if (worldDefine.mVersion >= 0x0104)
         {
            element = IntSetting2XmlElement ("camera_center_x", sceneDefine.mSettings.mCameraCenterX);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("camera_center_y", sceneDefine.mSettings.mCameraCenterY);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("world_left", sceneDefine.mSettings.mWorldLeft);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("world_top", sceneDefine.mSettings.mWorldTop);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("world_width", sceneDefine.mSettings.mWorldWidth);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("world_height", sceneDefine.mSettings.mWorldHeight);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("background_color", sceneDefine.mSettings.mBackgroundColor, true);
            xml.Settings.appendChild (element);

            element = BoolSetting2XmlElement ("build_border", sceneDefine.mSettings.mBuildBorder);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("border_color", sceneDefine.mSettings.mBorderColor, true);
            xml.Settings.appendChild (element);
         }

         if (worldDefine.mVersion >= 0x0106 && worldDefine.mVersion < 0x0108)
         {
            element = IntSetting2XmlElement ("physics_shapes_potential_max_count", sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount);
            xml.Settings.appendChild (element);

            element = IntSetting2XmlElement ("physics_shapes_population_density_level", sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel);
            xml.Settings.appendChild (element);
         }

         if (worldDefine.mVersion >= 0x0108)
         {
            element = BoolSetting2XmlElement ("infinite_scene_size", sceneDefine.mSettings.mIsInfiniteWorldSize);
            xml.Settings.appendChild (element);

            element = BoolSetting2XmlElement ("border_at_top_layer", sceneDefine.mSettings.mBorderAtTopLayer);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_left_thinckness", sceneDefine.mSettings.mWorldBorderLeftThickness);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_top_thinckness", sceneDefine.mSettings.mWorldBorderTopThickness);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_right_thinckness", sceneDefine.mSettings.mWorldBorderRightThickness);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("border_bottom_thinckness", sceneDefine.mSettings.mWorldBorderBottomThickness);
            xml.Settings.appendChild (element);

            element = FloatSetting2XmlElement ("gravity_acceleration_magnitude", sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("gravity_acceleration_angle", sceneDefine.mSettings.mDefaultGravityAccelerationAngle);
            xml.Settings.appendChild (element);

            element = BoolSetting2XmlElement ("right_hand_coordinates", sceneDefine.mSettings.mRightHandCoordinates);
            xml.Settings.appendChild (element);

            element = FloatSetting2XmlElement ("coordinates_origin_x", sceneDefine.mSettings.mCoordinatesOriginX, true);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("coordinates_origin_y", sceneDefine.mSettings.mCoordinatesOriginY, true);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("coordinates_scale", sceneDefine.mSettings.mCoordinatesScale, true);
            xml.Settings.appendChild (element);

            element = BoolSetting2XmlElement ("ci_rules_enabled", sceneDefine.mSettings.mIsCiRulesEnabled);
            xml.Settings.appendChild (element);
         }

         if (worldDefine.mVersion >= 0x0155)
         {
            element = BoolSetting2XmlElement ("auto_sleeping_enabled", sceneDefine.mSettings.mAutoSleepingEnabled);
            xml.Settings.appendChild (element);
            element = BoolSetting2XmlElement ("camera_rotating_enabled", sceneDefine.mSettings.mCameraRotatingEnabled);
            xml.Settings.appendChild (element);
         }

         if (worldDefine.mVersion >= 0x0160)
         {
            element = IntSetting2XmlElement ("initial_speedx", sceneDefine.mSettings.mInitialSpeedX);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("preferred_fps", sceneDefine.mSettings.mPreferredFPS);
            xml.Settings.appendChild (element);
            element = BoolSetting2XmlElement ("pause_on_focus_lost", sceneDefine.mSettings.mPauseOnFocusLost);
            xml.Settings.appendChild (element);
            
            element = BoolSetting2XmlElement ("physics_simulation_enabled", sceneDefine.mSettings.mPhysicsSimulationEnabled);
            xml.Settings.appendChild (element);
            element = FloatSetting2XmlElement ("physics_simulation_time_step", sceneDefine.mSettings.mPhysicsSimulationStepTimeLength);
            xml.Settings.appendChild (element);
            element = IntSetting2XmlElement ("physics_simulation_quality", sceneDefine.mSettings.mPhysicsSimulationQuality, true);
            xml.Settings.appendChild (element);
            element = BoolSetting2XmlElement ("physics_simulation_check_toi", sceneDefine.mSettings.mCheckTimeOfImpact);
            xml.Settings.appendChild (element);
         }

         // precreate some nodes

         xml.Entities = <Entities />

         if (worldDefine.mVersion >= 0x0107)
            xml.EntityAppearingOrder = <EntityAppearingOrder />;

         xml.BrotherGroups = <BrotherGroups />

         if (worldDefine.mVersion >= 0x0102)
         {
            xml.CollisionCategories = <CollisionCategories />;
            xml.CollisionCategoryFriendPairs = <CollisionCategoryFriendPairs />;
         }

         if (worldDefine.mVersion >= 0x0152)
         {
            if (worldDefine.mVersion >= 0x0157)
            {
               xml.SessionVariables = <SessionVariables />;
            }
            
            xml.GlobalVariables = <GlobalVariables />;
            xml.EntityProperties = <EntityProperties />;
         }

         if (worldDefine.mVersion >= 0x0153)
            xml.CustomFunctions = <CustomFunctions />;

         //

         if (worldDefine.mVersion >= 0x0153)
         {
            for (var functionId:int = 0; functionId < sceneDefine.mFunctionDefines.length; ++ functionId)
            {
               var functionDefine:FunctionDefine = sceneDefine.mFunctionDefines [functionId] as FunctionDefine;

               element = <Function />;
               TriggerFormatHelper2.FunctionDefine2Xml (functionDefine, element, true, true, sceneDefine.mFunctionDefines);

               if (worldDefine.mVersion >= 0x0201)
               {
                  element.@key = functionDefine.mKey;
                  element.@time_modified = TimeValue2HexString (functionDefine.mTimeModified);
               }
               
               element.@name = functionDefine.mName;
               element.@x = functionDefine.mPosX;
               element.@y = functionDefine.mPosY;
               if (worldDefine.mVersion >= 0x0156)
               {
                  element.@design_dependent = functionDefine.mDesignDependent ? 1 : 0;
               }

               xml.CustomFunctions.appendChild (element);
            }
         }

         // entities ...

         var appearId:int;
         var createId:int;

         var numEntities:int = sceneDefine.mEntityDefines.length;

         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = sceneDefine.mEntityDefines [createId];
            element = EntityDefine2XmlElement (entityDefine, worldDefine, sceneDefine, createId);

            xml.Entities.appendChild (element);
         }

         // ...
         if (worldDefine.mVersion >= 0x0107)
         {
            xml.EntityAppearingOrder.@entity_indices = IntegerArray2IndicesString (sceneDefine.mEntityAppearanceOrder);
         }

         // ...

         var groupId:int;
         var brotherIDs:Array;
         var idsStr:String;

         for (groupId = 0; groupId < sceneDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = sceneDefine.mBrotherGroupDefines [groupId];

            element = <BrotherGroup />;
            element.@num_brothers = brotherIDs.length;
            element.@brother_indices = IntegerArray2IndicesString (brotherIDs);
            
            xml.BrotherGroups.appendChild (element);
         }

         // collision category

         if (worldDefine.mVersion >= 0x0102)
         {
            for (var ccId:int = 0; ccId < sceneDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = sceneDefine.mCollisionCategoryDefines [ccId];

               element = <CollisionCategory />;
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  element.@key = ccDefine.mKey;
                  element.@time_modified = TimeValue2HexString (ccDefine.mTimeModified);
               }
               
               element.@name = ccDefine.mName;
               element.@collide_internally = ccDefine.mCollideInternally ? 1 : 0;
               element.@x = ccDefine.mPosX;
               element.@y = ccDefine.mPosY;

               xml.CollisionCategories.appendChild (element);
            }

            xml.CollisionCategories.@default_category_index = sceneDefine.mDefaultCollisionCategoryIndex;

            for (var pairId:int = 0; pairId < sceneDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = sceneDefine.mCollisionCategoryFriendLinkDefines [pairId];

               element = <CollisionCategoryFriendPair />;
               element.@category1_index = pairDefine.mCollisionCategory1Index;
               element.@category2_index = pairDefine.mCollisionCategory2Index;
               
               xml.CollisionCategoryFriendPairs.appendChild (element);
            }
         }

         // custom variables

         if (worldDefine.mVersion >= 0x0152)
         {
            // v1.52 only
            //for (var globalSpaceId:int = 0; globalSpaceId < sceneDefine.mGlobalVariableSpaceDefines.length; ++ globalSpaceId)
            //{
            //   element = TriggerFormatHelper2.VariableSpaceDefine2Xml (sceneDefine.mGlobalVariableSpaceDefines [globalSpaceId]);
            //   xml.GlobalVariables.appendChild (element);
            //}
            //
            //for (var propertySpaceId:int = 0; propertySpaceId < sceneDefine.mEntityPropertySpaceDefines.length; ++ propertySpaceId)
            //{
            //   element = TriggerFormatHelper2.VariableSpaceDefine2Xml (sceneDefine.mEntityPropertySpaceDefines [propertySpaceId]);
            //   xml.EntityProperties.appendChild (element);
            //}
            //<<

            if (worldDefine.mVersion == 0x0152)
            {
               xml.GlobalVariables.VariablePackage = <VariablePackage />;
               //xml.GlobalVariables.VariablePackage.@name = "";
               //xml.GlobalVariables.VariablePackage.@package_id = 0;
               //xml.GlobalVariables.VariablePackage.@parent_package_id = -1;
               TriggerFormatHelper2.VariablesDefine2Xml (sceneDefine.mGlobalVariableDefines, xml.GlobalVariables.VariablePackage[0], true, false);

               xml.EntityProperties.VariablePackage = <VariablePackage />;
               //xml.EntityProperties.VariablePackage.@name = "";
               //xml.EntityProperties.VariablePackage.@package_id = 0;
               //xml.EntityProperties.VariablePackage.@parent_package_id = -1;
               TriggerFormatHelper2.VariablesDefine2Xml (sceneDefine.mEntityPropertyDefines, xml.EntityProperties.VariablePackage [0], true, false);
            }
            else
            {
               if (worldDefine.mVersion >= 0x0157)
               {
                  TriggerFormatHelper2.VariablesDefine2Xml (sceneDefine.mSessionVariableDefines, xml.SessionVariables [0], true, false);
               }
               TriggerFormatHelper2.VariablesDefine2Xml (sceneDefine.mGlobalVariableDefines, xml.GlobalVariables [0], true, false);
               TriggerFormatHelper2.VariablesDefine2Xml (sceneDefine.mEntityPropertyDefines, xml.EntityProperties [0], true, false);
            }
         }
         
         // ...
         
         return xml;
      }
      
      public static function ModuleInstanceDefines2XmlElements (worldVersion:int, moduleInstanceDefines:Array, parentElement:XML, childElementName:String, forSequencedModule:Boolean):void
      {
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId]; 
            
            var element:XML = <TempName />; // new XML (); // weird as3
            element.setName (childElementName);
            
            element.@x = moduleInstanceDefine.mPosX;
            element.@y = moduleInstanceDefine.mPosY;
            element.@scale = moduleInstanceDefine.mScale;
            element.@flipped = moduleInstanceDefine.mIsFlipped ? 1 : 0;
            element.@r = moduleInstanceDefine.mRotation;
            element.@visible = moduleInstanceDefine.mVisible ? 1 : 0;
            element.@alpha = moduleInstanceDefine.mAlpha;
            
            if (forSequencedModule)
            {
               element.@duration = moduleInstanceDefine.mModuleDuration;
            }
            
            ModuleInstanceDefine2XmlElement (worldVersion, moduleInstanceDefine, element);
            
            parentElement.appendChild (element);
         }
      }
      
      public static function ModuleInstanceDefine2XmlElement (worldVersion:int, moduleInstanceDefine:Object, element:XML):void
      {
         element.@module_type = moduleInstanceDefine.mModuleType;
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            element.@shape_attribute_bits = moduleInstanceDefine.mShapeAttributeBits;
            element.@shape_body_argb = UInt2ColorString (moduleInstanceDefine.mShapeBodyOpacityAndColor);
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               element.@shape_path_thickness = moduleInstanceDefine.mShapePathThickness;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  LocalVertices2XmlElement (moduleInstanceDefine.mPolyLocalPoints, element);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               element.@shape_border_argb = UInt2ColorString (moduleInstanceDefine.mShapeBorderOpacityAndColor);
               element.@shape_border_thickness = moduleInstanceDefine.mShapeBorderThickness;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  element.@circle_radius = moduleInstanceDefine.mCircleRadius;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  element.@rect_half_width = moduleInstanceDefine.mRectHalfWidth;
                  element.@rect_half_height = moduleInstanceDefine.mRectHalfHeight;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  LocalVertices2XmlElement (moduleInstanceDefine.mPolyLocalPoints, element);
               }
               
               if (worldVersion >= 0x0160)
               {
                  element.BodyTexture = <BodyTexture />;
                  
                  TextureDefine2Xml (element.BodyTexture, moduleInstanceDefine.mBodyTextureDefine);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               element.@module_index = moduleInstanceDefine.mModuleIndex;
            }
         }
         else // ...
         {
         }
      }
      
      public static function TextureDefine2Xml (textureElement:Object, textureDefine:Object):void
      {
         textureElement.@module_index = textureDefine.mModuleIndex;
         if (textureDefine.mModuleIndex >= 0)
         {
            textureElement.@x = textureDefine.mPosX;
            textureElement.@y = textureDefine.mPosY;
            textureElement.@scale = textureDefine.mScale;
            textureElement.@flipped = textureDefine.mIsFlipped ? 1 : 0;
            textureElement.@r = textureDefine.mRotation;
         }
      }
      
      public static function ShapePhysicsProperties2Xml (element:XML, entityDefine:Object, worldDefine:WorldDefine):void
      {
         if (worldDefine.mVersion >= 0x0104)
         {
            element.@enable_physics = entityDefine.mIsPhysicsEnabled ? 1 : 0;

            // move down from v1.05
            /////element.@is_sensor = entityDefine.mIsSensor ? 1 : 0;
         }

         if (entityDefine.mIsPhysicsEnabled)  // always true before v1.04
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               element.@collision_category_index = entityDefine.mCollisionCategoryIndex;
            }

            element.@is_static = entityDefine.mIsStatic ? 1 : 0;
            element.@is_bullet = entityDefine.mIsBullet ? 1 : 0;
            element.@density = entityDefine.mDensity;
            element.@friction = entityDefine.mFriction;
            element.@restitution = entityDefine.mRestitution;

            if (worldDefine.mVersion >= 0x0104)
            {
               // add in v1,04, move here from above from v1.05
               element.@is_sensor = entityDefine.mIsSensor ? 1 : 0;
            }

            if (worldDefine.mVersion >= 0x0105)
            {
               element.@is_hollow = entityDefine.mIsHollow ? 1 : 0;
            }

            if (worldDefine.mVersion >= 0x0108)
            {
               element.@build_border = entityDefine.mBuildBorder ? 1 : 0;
               element.@sleeping_allowed = entityDefine.mIsSleepingAllowed ? 1 : 0;
               element.@rotation_fixed = entityDefine.mIsRotationFixed ? 1 : 0;
               element.@linear_velocity_magnitude = entityDefine.mLinearVelocityMagnitude;
               element.@linear_velocity_angle = entityDefine.mLinearVelocityAngle;
               element.@angular_velocity = entityDefine.mAngularVelocity;
            }
         }
      }

      public static function UInt2ColorString (intValue:uint):String
      {
         var strValue:String;
         strValue = "0x";
         var b:int;

         b = (intValue >> 24) & 0xFF;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);

         b = (intValue & 0x00FF0000) >> 16;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);

         b = (intValue & 0x0000FF00) >>  8;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);

         b = (intValue & 0x000000FF) >>  0;
         if (b < 16)
         {
            strValue += "0";
            strValue += (b).toString (16);
         }
         else
            strValue += (b).toString (16);

         return strValue;
      }

      private static function IntSetting2XmlElement (settingName:String, settingValue:int, isColor:Boolean = false):XML
      {
         var strValue:String;
         if (isColor)
            strValue = UInt2ColorString (settingValue);
         else
            strValue = "" + settingValue;

         return Setting2XmlElement (settingName, strValue);
      }

      private static function BoolSetting2XmlElement (settingName:String, settingValue:Boolean):XML
      {
         return Setting2XmlElement (settingName, settingValue ? "1" : "0");
      }

      private static function FloatSetting2XmlElement (settingName:String, settingValue:Number, isDouble:Boolean = false):XML
      {
         var strValue:String;
         if (isDouble)
            strValue = "" + ValueAdjuster.Number2Precision (settingValue, 12)
         else
            strValue = "" + ValueAdjuster.Number2Precision (settingValue, 6)

         return Setting2XmlElement (settingName, strValue);
      }

      private static function Setting2XmlElement (settingName:String, settingValue:String):XML
      {
         if ( ! (settingValue is String) )
            settingValue = settingValue.toString ();

         var element:XML = <Setting />;
         element.@name = settingName;
         element.@value = settingValue;

         return element;
      }

      public static function EntityDefine2XmlElement (entityDefine:Object, worldDefine:WorldDefine, sceneDefine:SceneDefine, createId:int):XML
      {
         var vertexId:int;
         var i:int;
         var num:int;
         var creation_ids:Array;

         var element:XML = <Entity />;
         element.@id = createId; // for debug using only
         element.@entity_type = entityDefine.mEntityType;
         element.@x = entityDefine.mPosX;
         element.@y = entityDefine.mPosY;
         //>>from v1.58
         element.@scale = entityDefine.mScale;
         element.@flipped = entityDefine.mIsFlipped ? 1 : 0;
         //<<
         element.@r = entityDefine.mRotation;
         element.@visible = entityDefine.mIsVisible ? 1 : 0;

         //>>from v1.08
         element.@alpha = entityDefine.mAlpha;
         element.@enabled = entityDefine.mIsEnabled ? 1 : 0;
         //<<

         if (worldDefine.mVersion >= 0x0108)
         {
            element.@alpha = entityDefine.mAlpha;
            element.@active = entityDefine.mIsEnabled ? 1 : 0;
         }

         if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
         {
            // from v1.05
            if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
            {
               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@followed_target = entityDefine.mFollowedTarget;
                  element.@following_style = entityDefine.mFollowingStyle;
               }
            }
            //<<
            //>>from v1.10
            else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
            {
               element.@power_source_type = entityDefine.mPowerSourceType;
               element.@power_magnitude = entityDefine.mPowerMagnitude;
               element.@keyboard_event_id = entityDefine.mKeyboardEventId;
               element.@key_codes = IntegerArray2IndicesString (entityDefine.mKeyCodes);
            }
            //<<
         }
         else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
         {
            if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
            {
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, sceneDefine.mFunctionDefines);
               else
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, false, sceneDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
            {
               element.@assigner_indices = IntegerArray2IndicesString (entityDefine.mInputAssignerCreationIds);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
            {
               element.@is_and = entityDefine.mIsAnd ? 1 : 0;
               element.@is_not = entityDefine.mIsNot ? 1 : 0;

               element.Conditions = <Conditions />;

               var target_values:Array = entityDefine.mInputConditionTargetValues;
               creation_ids = entityDefine.mInputConditionEntityCreationIds;
               num = creation_ids.length;
               if (num > target_values.length)
                  num = target_values.length;
               var elementCondition:XML;
               for (i = 0; i < num; ++ i)
               {
                  elementCondition = <Condition />;
                  elementCondition.@entity_index = creation_ids [i];
                  elementCondition.@target_value = target_values [i];

                  element.Conditions.appendChild (elementCondition);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
            {
               element.@selector_type = entityDefine.mSelectorType;
               element.@entity_indices = IntegerArray2IndicesString (entityDefine.mEntityCreationIds);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
            {
               element.@pairing_type = entityDefine.mPairingType;
               element.@entity_indices1 =  IntegerArray2IndicesString (entityDefine.mEntityCreationIds1);
               element.@entity_indices2 =  IntegerArray2IndicesString (entityDefine.mEntityCreationIds2);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
            {
               element.@event_id = entityDefine.mEventId;
               element.@input_condition_entity_index = entityDefine.mInputConditionEntityCreationId;
               element.@input_condition_target_value = entityDefine.mInputConditionTargetValue;
               element.@assigner_indices = IntegerArray2IndicesString (entityDefine.mInputAssignerCreationIds);

               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@external_action_entity_index = entityDefine.mExternalActionEntityCreationId;
               }

               if (worldDefine.mVersion >= 0x0108)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        element.@running_interval = entityDefine.mRunningInterval;
                        element.@only_run_once = entityDefine.mOnlyRunOnce ? 1 : 0;

                        if (worldDefine.mVersion >= 0x0156)
                        {
                           if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                           {
                              var preHandlingCodeSnippetXML:XML = <PreHandlingCodeSnippet/>
                              TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mPreFunctionDefine as FunctionDefine, element, false, true, sceneDefine.mFunctionDefines, false, preHandlingCodeSnippetXML);
                              var postHandlingCodeSnippetXML:XML = <PostHandlingCodeSnippet/>
                              TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mPostFunctionDefine as FunctionDefine, element, false, true, sceneDefine.mFunctionDefines, false, postHandlingCodeSnippetXML);
                           }
                        }

                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        element.@key_codes = IntegerArray2IndicesString (entityDefine.mKeyCodes);
                        break;
                     case CoreEventIds.ID_OnMouseGesture:
                        element.@gesture_ids = IntegerArray2IndicesString (entityDefine.mGestureIDs);
                        break;
                     default:
                        break;
                  }
               }

               if (worldDefine.mVersion >= 0x0153)
               {
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, sceneDefine.mFunctionDefines);
               }
               else
               {
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, false, sceneDefine.mFunctionDefines);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
            {
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, sceneDefine.mFunctionDefines);
               else
                  TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, false, sceneDefine.mFunctionDefines);
            }
            //>>from v1.56
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
            {
               TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, sceneDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
            {
               TriggerFormatHelper2.FunctionDefine2Xml (entityDefine.mFunctionDefine as FunctionDefine, element, false, true, sceneDefine.mFunctionDefines);
            }
            //<<
         }
         else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               element.@draw_border = entityDefine.mDrawBorder ? 1 : 0;
               element.@draw_background = entityDefine.mDrawBackground ? 1 : 0;
            }

            if (worldDefine.mVersion >= 0x0104)
            {
               element.@border_color = UInt2ColorString (entityDefine.mBorderColor);
               element.@border_thickness = entityDefine.mBorderThickness;
               element.@background_color = UInt2ColorString (entityDefine.mBackgroundColor);

               if (worldDefine.mVersion >= 0x0107)
                  element.@background_opacity = entityDefine.mTransparency;
               else
                  element.@transparency = entityDefine.mTransparency;
            }

            if (worldDefine.mVersion >= 0x0105)
            {
               if (worldDefine.mVersion >= 0x0107)
                  element.@border_opacity = entityDefine.mBorderTransparency;
               else
                  element.@border_transparency = entityDefine.mBorderTransparency;
            }

            if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
            {
               element.@ai_type = entityDefine.mAiType;
               
               // ...
               ShapePhysicsProperties2Xml (element, entityDefine, worldDefine);
               
               // ...
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  element.@radius = entityDefine.mRadius;
                  element.@appearance_type = entityDefine.mAppearanceType;
               
                  if (worldDefine.mVersion >= 0x0160)
                  {
                     element.BodyTexture = <BodyTexture />;
                     
                     TextureDefine2Xml (element.BodyTexture, entityDefine.mBodyTextureDefine);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     element.@round_corners = entityDefine.mIsRoundCorners ? 1 : 0;
                  }

                  element.@half_width = entityDefine.mHalfWidth;
                  element.@half_height = entityDefine.mHalfHeight;
               
                  if (worldDefine.mVersion >= 0x0160)
                  {
                     element.BodyTexture = <BodyTexture />;
                     
                     TextureDefine2Xml (element.BodyTexture, entityDefine.mBodyTextureDefine);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
               {
                  LocalVertices2XmlElement (entityDefine.mLocalPoints, element);
               
                  if (worldDefine.mVersion >= 0x0160)
                  {
                     element.BodyTexture = <BodyTexture />;
                     
                     TextureDefine2Xml (element.BodyTexture, entityDefine.mBodyTextureDefine);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
               {
                  element.@curve_thickness = entityDefine.mCurveThickness;

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     element.@round_ends = entityDefine.mIsRoundEnds ? 1 : 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0157)
                  {
                     element.@closed = entityDefine.mIsClosed ? 1 : 0
                  }

                  LocalVertices2XmlElement (entityDefine.mLocalPoints, element);
               }
            }
            else // not physics shape
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText
                  || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                  )
               {
                  element.@text = entityDefine.mText;
                  if (worldDefine.mVersion < 0x0108)
                  {
                     //element.@autofit_width = entityDefine.mWordWrap ? 1 : 0;
                     element.@autofit_width = (entityDefine.mFlags1 & TextUtil.TextFlag_WordWrap) == TextUtil.TextFlag_WordWrap ? 1 : 0;
                  }
                  else if (worldDefine.mVersion < 0x0204)
                  {
                     //element.@word_wrap = entityDefine.mWordWrap ? 1 : 0;
                     element.@word_wrap = (entityDefine.mFlags1 & TextUtil.TextFlag_WordWrap) == TextUtil.TextFlag_WordWrap ? 1 : 0;
                  }
                  else
                  {
                     element.@flags1 = entityDefine.mFlags1;
                  }

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (worldDefine.mVersion < 0x0204)
                     {
                        element.@adaptive_background_size = entityDefine.mAdaptiveBackgroundSize ? 1 : 0;
                     }
                     else
                     {
                        element.@flags2 = entityDefine.mFlags2;
                     }
                     element.@text_color = UInt2ColorString (entityDefine.mTextColor);
                     element.@font_size = entityDefine.mFontSize;
                     element.@bold = entityDefine.mIsBold ? 1 : 0;
                     element.@italic = entityDefine.mIsItalic ? 1 : 0;
                  }

                  if (worldDefine.mVersion >= 0x0109)
                  {
                     element.@align = entityDefine.mTextAlign ;
                     element.@underlined = entityDefine.mIsUnderlined ? 1 : 0;
                  }

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                     {
                        element.@using_hand_cursor = entityDefine.mUsingHandCursor ? 1 : 0;

                        element.@draw_background_on_mouse_over = entityDefine.mDrawBackground_MouseOver ? 1 : 0;
                        element.@background_color_on_mouse_over = UInt2ColorString (entityDefine.mBackgroundColor_MouseOver);
                        element.@background_opacity_on_mouse_over = entityDefine.mBackgroundTransparency_MouseOver;

                        element.@draw_border_on_mouse_over = entityDefine.mDrawBorder_MouseOver ? 1 : 0;
                        element.@border_color_on_mouse_over = UInt2ColorString (entityDefine.mBorderColor_MouseOver);
                        element.@border_thickness_on_mouse_over = entityDefine.mBorderThickness_MouseOver;
                        element.@border_opacity_on_mouse_over = entityDefine.mBorderTransparency_MouseOver;
                     }
                  }

                  element.@half_width = entityDefine.mHalfWidth;
                  element.@half_height = entityDefine.mHalfHeight;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
               {
                  element.@radius = entityDefine.mRadius;

                  if (worldDefine.mVersion >= 0x0105)
                  {
                     element.@interactive_zones = ( int(entityDefine.mInteractiveZones) ).toString(2);
                     element.@interactive_conditions = ( int(entityDefine.mInteractiveConditions) ).toString(2);
                  }
                  else
                  {
                     element.@interactive = entityDefine.mIsInteractive ? 1 : 0;
                  }

                  element.@initial_gravity_acceleration = entityDefine.mInitialGravityAcceleration;
                  element.@initial_gravity_angle = entityDefine.mInitialGravityAngle;

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     element.@maximal_gravity_acceleration = entityDefine.mMaximalGravityAcceleration;
                  }
               }
            }
         }
         //>> from v1.58
         else if (Define.IsShapeEntity (entityDefine.mEntityType))
         {
            if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
            {
               ShapePhysicsProperties2Xml (element, entityDefine, worldDefine);
               
               element.@module_index = entityDefine.mModuleIndex;
            }
            else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
            {
               ShapePhysicsProperties2Xml (element, entityDefine, worldDefine);
               
               element.@module_index_up = entityDefine.mModuleIndexUp;
               element.@module_index_over = entityDefine.mModuleIndexOver;
               element.@module_index_down = entityDefine.mModuleIndexDown;
            }
         }
         //<<
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            element.@collide_connected = entityDefine.mCollideConnected ? 1 : 0;

            if (worldDefine.mVersion >= 0x0102)
            {
               element.@connected_shape1_index = entityDefine.mConnectedShape1Index;
               element.@connected_shape2_index = entityDefine.mConnectedShape2Index;
            }

            if (worldDefine.mVersion >= 0x0108)
            {
               element.@breakable = entityDefine.mBreakable ? 1 : 0;
            }

            if (entityDefine.mEntityType == Define.EntityType_JointHinge)
            {
               element.@anchor_index = entityDefine.mAnchorEntityIndex;

               element.@enable_limits = entityDefine.mEnableLimits ? 1 : 0;
               element.@lower_angle = entityDefine.mLowerAngle;
               element.@upper_angle = entityDefine.mUpperAngle;
               element.@enable_motor = entityDefine.mEnableMotor ? 1 : 0;
               element.@motor_speed = entityDefine.mMotorSpeed;
               element.@back_and_forth = entityDefine.mBackAndForth ? 1 : 0;

               if (worldDefine.mVersion >= 0x0104)
                  element.@max_motor_torque = entityDefine.mMaxMotorTorque;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;

               element.@enable_limits = entityDefine.mEnableLimits ? 1 : 0;
               element.@lower_translation = entityDefine.mLowerTranslation;
               element.@upper_translation = entityDefine.mUpperTranslation;
               element.@enable_motor = entityDefine.mEnableMotor ? 1 : 0;
               element.@motor_speed = entityDefine.mMotorSpeed;
               element.@back_and_forth = entityDefine.mBackAndForth ? 1: 0;

               if (worldDefine.mVersion >= 0x0104)
                  element.@max_motor_force = entityDefine.mMaxMotorForce;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;

               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@break_delta_length = entityDefine.mBreakDeltaLength;
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;

               element.@static_length_ratio = entityDefine.mStaticLengthRatio;
               //element.@frequency_hz = entityDefine.mFrequencyHz;
               element.@spring_type = entityDefine.mSpringType;

               element.@damping_ratio = entityDefine.mDampingRatio;

               if (worldDefine.mVersion >= 0x0108)
               {
                  element.@frequency_determined_manner = entityDefine.mFrequencyDeterminedManner;
                  element.@frequency = entityDefine.mFrequency;
                  element.@spring_constant = entityDefine.mSpringConstant;
                  element.@break_extended_length = entityDefine.mBreakExtendedLength;
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
            {
               element.@anchor_index = entityDefine.mAnchorEntityIndex;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
            }
         }

         return element;
      }
      
      public static function LocalVertices2XmlElement (localPoints:Array, parentElement:XML):void
      {
         parentElement.LocalVertices = <LocalVertices />
         
         if (localPoints != null)
         {
            for (var vertexId:int = 0; vertexId < localPoints.length; ++ vertexId)
            {
               var elementLocalVertex:XML = <Vertex />;
               
               var point:Point = localPoints [vertexId] as Point;
               elementLocalVertex.@x = point.x;
               elementLocalVertex.@y = point.y;
   
               parentElement.LocalVertices.appendChild (elementLocalVertex);
            }
         }
      }

      public static function IntegerArray2IndicesString (ids:Array):String
      {
         if (ids == null)
            return "";

         var num:int = ids.length;
         if (num < 1)
            return "";

         var indicesStr:String = "" + ids [0];
         for (var i:int = 1; i < num; ++ i)
         {
            indicesStr += ",";
            indicesStr += ids [i];
         }

         return indicesStr;
      }
      
//===================================================================================
// 
//===================================================================================

      public static function ByteArray2WorldDefine (byteArray:ByteArray):WorldDefine
      {
         //trace ("ByteArray2WorldDefine");

         var worldDefine:WorldDefine = new WorldDefine ();

         // COlor INfection
         byteArray.readByte (); // "C".charCodeAt (0);
         byteArray.readByte (); // "O".charCodeAt (0);
         byteArray.readByte (); // "I".charCodeAt (0);
         byteArray.readByte (); // "N".charCodeAt (0);

         // basic settings
         {
            worldDefine.mVersion = byteArray.readShort ();
            if (worldDefine.mVersion >= 0x0203)
            {
               worldDefine.mKey = byteArray.readUTF ();
            }
            worldDefine.mAuthorName = byteArray.readUTF ();
            worldDefine.mAuthorHomepage = byteArray.readUTF ();

            if (worldDefine.mVersion < 0x0102)
            {
               // the 3 bytes are removed since v1.02
               // hex
               byteArray.readByte (); // "H".charCodeAt (0);
               byteArray.readByte (); // "E".charCodeAt (0);
               byteArray.readByte (); // "X".charCodeAt (0);
            }

            if (worldDefine.mVersion >= 0x0102)
            {
               worldDefine.mShareSourceCode = byteArray.readByte () != 0;
               worldDefine.mPermitPublishing = byteArray.readByte () != 0;
            }
         }
         
         // scenes

         if (worldDefine.mVersion >= 0x0200)
         {
            var numScenes:int = byteArray.readShort ();
            for (var sceneId:int = 0; sceneId < numScenes; ++ sceneId)
            {  
               worldDefine.mSceneDefines.push (ByteArray2SceneDefine (byteArray, worldDefine, sceneId));
            }
         }
         else
         {
            worldDefine.mSceneDefines.push (ByteArray2SceneDefine (byteArray, worldDefine, 0));
         }
                  
         // scene common variables
         
         if (worldDefine.mVersion >= 0x0203)
         {
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, worldDefine.mGameSaveVariableDefines, true, true);
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, worldDefine.mWorldVariableDefines, true, false);
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, worldDefine.mCommonGlobalVariableDefines, true, false);
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, worldDefine.mCommonEntityPropertyDefines, true, false);
         }
         
         // modules
         
         if (worldDefine.mVersion >= 0x0158)
         {
            var numImages:int = byteArray.readShort ();
            for (var imageId:int = 0; imageId < numImages; ++ imageId)
            {
               var imageDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  imageDefine.mKey = byteArray.readUTF ();
                  imageDefine.mTimeModified = ReadTimeValue (byteArray);
               }
               
               imageDefine.mName = byteArray.readUTF ();
               
               var imageFileSize:int = byteArray.readInt ();
               if (imageFileSize == 0)
               {
                  imageDefine.mFileData = null;
               }
               else
               {
                  imageDefine.mFileData = new ByteArray ();
                  imageDefine.mFileData.length = imageFileSize;
                  byteArray.readBytes (imageDefine.mFileData, 0, imageDefine.mFileData.length);
               }
               
               worldDefine.mImageDefines.push (imageDefine);
            }

            var numDivisons:int = byteArray.readShort ();
            for (var divisionId:int = 0; divisionId < numDivisons; ++ divisionId)
            {
               var divisionDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  divisionDefine.mKey = byteArray.readUTF ();
                  divisionDefine.mTimeModified = ReadTimeValue (byteArray);
               }

               divisionDefine.mImageIndex = byteArray.readShort ();
               divisionDefine.mLeft = byteArray.readShort ();
               divisionDefine.mTop = byteArray.readShort ();
               divisionDefine.mRight = byteArray.readShort ();
               divisionDefine.mBottom = byteArray.readShort ();
               
               worldDefine.mPureImageModuleDefines.push (divisionDefine);
            }

            var numAssembledModules:int = byteArray.readShort ();
            for (var assembledModuleId:int = 0; assembledModuleId < numAssembledModules; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  assembledModuleDefine.mKey = byteArray.readUTF ();
                  assembledModuleDefine.mTimeModified = ReadTimeValue (byteArray);
               }

               assembledModuleDefine.mModulePartDefines = ReadModuleInstanceDefinesFromBinFile (worldDefine.mVersion, byteArray, false);
               
               worldDefine.mAssembledModuleDefines.push (assembledModuleDefine);
            }

            var numSequencedModules:int = byteArray.readShort ();
            for (var sequencedModuleId:int = 0; sequencedModuleId < numSequencedModules; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  sequencedModuleDefine.mKey = byteArray.readUTF ();
                  sequencedModuleDefine.mTimeModified = ReadTimeValue (byteArray);
               }

               if (worldDefine.mVersion >= 0x0202)
               {
                  sequencedModuleDefine.mSettingFlags = byteArray.readShort ();
               }
               
               sequencedModuleDefine.mModuleSequenceDefines = ReadModuleInstanceDefinesFromBinFile (worldDefine.mVersion, byteArray, true);
               
               worldDefine.mSequencedModuleDefines.push (sequencedModuleDefine);
            }
         }
         
         // sounds
         
         if (worldDefine.mVersion >= 0x0159)
         {
            var numSounds:int = byteArray.readShort ();
            for (var soundId:int = 0; soundId < numSounds; ++ soundId)
            {
               var soundDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  soundDefine.mKey = byteArray.readUTF ();
                  soundDefine.mTimeModified = ReadTimeValue (byteArray);
               }
               
               soundDefine.mName = byteArray.readUTF ();
               soundDefine.mAttributeBits = byteArray.readInt ();
               soundDefine.mNumSamples = byteArray.readInt ();
               
               var soundFileSize:int = byteArray.readInt ();
               if (soundFileSize == 0)
               {
                  soundDefine.mFileData = null;
               }
               else
               {
                  soundDefine.mFileData = new ByteArray ();
                  soundDefine.mFileData.length = soundFileSize;
                  byteArray.readBytes (soundDefine.mFileData, 0, soundDefine.mFileData.length);
               }
               
               worldDefine.mSoundDefines.push (soundDefine);
            }
         }

         // ...
         return worldDefine;
      }
      
      public static function ReadTimeValue (byteArray:ByteArray):Number
      {
         var v1:Number = byteArray.readUnsignedShort ();
         var v2:Number = byteArray.readUnsignedShort ();
         var v3:Number = byteArray.readUnsignedShort ();
         
         return (v1 * 0x10000 + v2) * 0x10000 + v3;
      }
      
      public static function ByteArray2SceneDefine (byteArray:ByteArray, worldDefine:WorldDefine, sceneIndex:int):SceneDefine
      {
         var sceneDefine:SceneDefine = new SceneDefine ();
         
         // ...
         
         if (worldDefine.mVersion >= 0x0200)
         {
            sceneDefine.mKey = byteArray.readUTF ();
            sceneDefine.mName = byteArray.readUTF ();
         }
         
         // ...

         // more settings
         {
            if (worldDefine.mVersion >= 0x0151)
            {
               sceneDefine.mSettings.mViewerUiFlags = byteArray.readInt ();
               sceneDefine.mSettings.mPlayBarColor  = byteArray.readUnsignedInt ();
               sceneDefine.mSettings.mViewportWidth  = byteArray.readShort ();
               sceneDefine.mSettings.mViewportHeight  = byteArray.readShort ();
               sceneDefine.mSettings.mZoomScale = byteArray.readFloat ();
            }

            if (worldDefine.mVersion >= 0x0104)
            {
               sceneDefine.mSettings.mCameraCenterX = byteArray.readInt ();
               sceneDefine.mSettings.mCameraCenterY = byteArray.readInt ();
               sceneDefine.mSettings.mWorldLeft = byteArray.readInt ();
               sceneDefine.mSettings.mWorldTop  = byteArray.readInt ();
               sceneDefine.mSettings.mWorldWidth  = byteArray.readInt ();
               sceneDefine.mSettings.mWorldHeight = byteArray.readInt ();
               sceneDefine.mSettings.mBackgroundColor  = byteArray.readUnsignedInt ();
               sceneDefine.mSettings.mBuildBorder  = byteArray.readByte () != 0;
               sceneDefine.mSettings.mBorderColor = byteArray.readUnsignedInt ();
            }

            if (worldDefine.mVersion >= 0x0106 && worldDefine.mVersion < 0x0108)
            {
               sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount = byteArray.readInt ();
               sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel = byteArray.readShort ();
            }

            if (worldDefine.mVersion >= 0x0108)
            {
               sceneDefine.mSettings.mIsInfiniteWorldSize = byteArray.readByte () != 0;

               sceneDefine.mSettings.mBorderAtTopLayer = byteArray.readByte () != 0;
               sceneDefine.mSettings.mWorldBorderLeftThickness = byteArray.readFloat ();
               sceneDefine.mSettings.mWorldBorderTopThickness = byteArray.readFloat ();
               sceneDefine.mSettings.mWorldBorderRightThickness = byteArray.readFloat ();
               sceneDefine.mSettings.mWorldBorderBottomThickness = byteArray.readFloat ();

               sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude = byteArray.readFloat ();
               sceneDefine.mSettings.mDefaultGravityAccelerationAngle = byteArray.readFloat ();

               sceneDefine.mSettings.mRightHandCoordinates = byteArray.readByte () != 0;
               sceneDefine.mSettings.mCoordinatesOriginX = byteArray.readDouble ();
               sceneDefine.mSettings.mCoordinatesOriginY = byteArray.readDouble ();
               sceneDefine.mSettings.mCoordinatesScale = byteArray.readDouble ();

               sceneDefine.mSettings.mIsCiRulesEnabled = byteArray.readByte () != 0;
            }

            if (worldDefine.mVersion >= 0x0155)
            {
               sceneDefine.mSettings.mAutoSleepingEnabled = byteArray.readByte () != 0;
               sceneDefine.mSettings.mCameraRotatingEnabled = byteArray.readByte () != 0;
            }

            if (worldDefine.mVersion >= 0x0160)
            {
               sceneDefine.mSettings.mInitialSpeedX = byteArray.readByte ();
               sceneDefine.mSettings.mPreferredFPS = byteArray.readFloat ();
               sceneDefine.mSettings.mPauseOnFocusLost = byteArray.readByte () != 0;
               
               sceneDefine.mSettings.mPhysicsSimulationEnabled = byteArray.readByte () != 0;
               sceneDefine.mSettings.mPhysicsSimulationStepTimeLength = byteArray.readFloat ();
               sceneDefine.mSettings.mPhysicsSimulationQuality = byteArray.readUnsignedInt ();
               sceneDefine.mSettings.mCheckTimeOfImpact = byteArray.readByte () != 0;
            }
         }

         // collision category

         if (worldDefine.mVersion >= 0x0102)
         {
            var numCategories:int = byteArray.readShort ();

            //trace ("numCategories = " + numCategories);

            for (var ccId:int = 0; ccId < numCategories; ++ ccId)
            {
               var ccDefine:Object = new Object ();
               
               if (worldDefine.mVersion >= 0x0201)
               {
                  ccDefine.mKey = byteArray.readUTF ();
                  ccDefine.mTimeModified = ReadTimeValue (byteArray);
               }

               ccDefine.mName = byteArray.readUTF ();
               ccDefine.mCollideInternally = byteArray.readByte () != 0;
               ccDefine.mPosX = byteArray.readFloat ();
               ccDefine.mPosY = byteArray.readFloat ();

               sceneDefine.mCollisionCategoryDefines.push (ccDefine);
            }

            sceneDefine.mDefaultCollisionCategoryIndex = byteArray.readShort ();

            //trace ("sceneDefine.mDefaultCollisionCategoryIndex = " + sceneDefine.mDefaultCollisionCategoryIndex);

            var numPairs:int = byteArray.readShort ();

            //trace ("numPairs = " + numPairs);

            for (var pairId:int = 0; pairId < numPairs; ++ pairId)
            {
               var pairDefine:Object = new Object ();
               pairDefine.mCollisionCategory1Index = byteArray.readShort ();
               pairDefine.mCollisionCategory2Index = byteArray.readShort ();

               sceneDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         
         // functions

         if (worldDefine.mVersion >= 0x0153)
         {
            var functionId:int;
            var functionDefine:FunctionDefine;

            var numFunctions:int = byteArray.readShort ();

            for (functionId = 0; functionId < numFunctions; ++ functionId)
            {
               functionDefine = new FunctionDefine ();

               TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, functionDefine, true, true, null);

               sceneDefine.mFunctionDefines.push (functionDefine);
            }

            for (functionId = 0; functionId < numFunctions; ++ functionId)
            {
               functionDefine = sceneDefine.mFunctionDefines [functionId];

               if (worldDefine.mVersion >= 0x0201)
               {
                  functionDefine.mKey = byteArray.readUTF ();
                  functionDefine.mTimeModified = ReadTimeValue (byteArray);
               }
               
               functionDefine.mName = byteArray.readUTF ();
               functionDefine.mPosX = byteArray.readFloat ();
               functionDefine.mPosY = byteArray.readFloat ();
               if (worldDefine.mVersion >= 0x0156)
               {
                  functionDefine.mDesignDependent = byteArray.readByte () != 0;
               }

               TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, functionDefine, true, false, sceneDefine.mFunctionDefines);
            }
         }

         // entities

         var numEntities:int = byteArray.readShort ();

         //trace ("numEntities = " + numEntities);

         var appearId:int;
         var createId:int;
         var vertexId:int;
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = new Object ();

            entityDefine.mEntityType = byteArray.readShort ();

            //trace ("appearId = " + appearId + ", mEntityType = " + entityDefine.mEntityType);

            if (worldDefine.mVersion >= 0x0103)
            {
               entityDefine.mPosX = byteArray.readDouble ();
               entityDefine.mPosY = byteArray.readDouble ();
            }
            else
            {
               entityDefine.mPosX = byteArray.readFloat ();
               entityDefine.mPosY = byteArray.readFloat ();
            }
            if (worldDefine.mVersion >= 0x0158)
            {
               entityDefine.mScale = byteArray.readFloat ();
               entityDefine.mIsFlipped = byteArray.readByte () != 0;
            }
            entityDefine.mRotation = byteArray.readFloat ();
            entityDefine.mIsVisible = byteArray.readByte () != 0;

            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mAlpha = byteArray.readFloat ();
               entityDefine.mIsEnabled = byteArray.readByte () != 0;
            }

            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               // from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mFollowedTarget = byteArray.readByte ();
                     entityDefine.mFollowingStyle = byteArray.readByte ();
                  }
               }
               //<<
               //>>from v1.10
               else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
               {
                  entityDefine.mPowerSourceType = byteArray.readByte ();
                  entityDefine.mPowerMagnitude = byteArray.readFloat ();
                  entityDefine.mKeyboardEventId = byteArray.readShort ();
                  entityDefine.mKeyCodes = ReadShortArrayFromBinFile (byteArray);
               }
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, sceneDefine.mFunctionDefines);
                  else
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, false, sceneDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  entityDefine.mInputAssignerCreationIds = ReadShortArrayFromBinFile (byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  entityDefine.mIsAnd = byteArray.readByte () != 0;
                  entityDefine.mIsNot = byteArray.readByte () != 0;

                  var num:int = byteArray.readShort ();
                  entityDefine.mNumInputConditions = num;
                  entityDefine.mInputConditionEntityCreationIds = new Array (num);
                  entityDefine.mInputConditionTargetValues = new Array (num);

                  for (i = 0; i < num; ++ i)
                  {
                     entityDefine.mInputConditionEntityCreationIds [i] = byteArray.readShort ();
                     entityDefine.mInputConditionTargetValues [i] = byteArray.readByte ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  entityDefine.mSelectorType = byteArray.readByte ();
                  entityDefine.mEntityCreationIds = ReadShortArrayFromBinFile (byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  entityDefine.mPairingType = byteArray.readByte ();
                  entityDefine.mEntityCreationIds1 = ReadShortArrayFromBinFile (byteArray);
                  entityDefine.mEntityCreationIds2 = ReadShortArrayFromBinFile (byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  entityDefine.mEventId = byteArray.readShort ();
                  entityDefine.mInputConditionEntityCreationId = byteArray.readShort ();
                  entityDefine.mInputConditionTargetValue = byteArray.readByte ();
                  entityDefine.mInputAssignerCreationIds = ReadShortArrayFromBinFile (byteArray);

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mExternalActionEntityCreationId = byteArray.readShort ();
                  }

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     switch (entityDefine.mEventId)
                     {
                        case CoreEventIds.ID_OnWorldTimer:
                        case CoreEventIds.ID_OnEntityTimer:
                        case CoreEventIds.ID_OnEntityPairTimer:
                           entityDefine.mRunningInterval = byteArray.readFloat ();
                           entityDefine.mOnlyRunOnce = byteArray.readByte () != 0;

                           if (worldDefine.mVersion >= 0x0156)
                           {
                              if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                              {
                                 entityDefine.mPreFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, sceneDefine.mFunctionDefines, false);
                                 entityDefine.mPostFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, sceneDefine.mFunctionDefines, false);
                              }
                           }

                           break;
                        case CoreEventIds.ID_OnWorldKeyDown:
                        case CoreEventIds.ID_OnWorldKeyUp:
                        case CoreEventIds.ID_OnWorldKeyHold:
                           entityDefine.mKeyCodes = ReadShortArrayFromBinFile (byteArray);
                           break;
                        case CoreEventIds.ID_OnMouseGesture:
                           entityDefine.mGestureIDs = ReadShortArrayFromBinFile (byteArray);
                           break;
                        default:
                           break;
                     }
                  }

                  if (worldDefine.mVersion >= 0x0153)
                  {
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, sceneDefine.mFunctionDefines);
                  }
                  else
                  {
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, false, sceneDefine.mFunctionDefines);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, sceneDefine.mFunctionDefines);
                  else
                     entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, false, sceneDefine.mFunctionDefines);
               }
               //>>from v1.56
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, sceneDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  entityDefine.mFunctionDefine = TriggerFormatHelper2.LoadFunctionDefineFromBinFile (byteArray, null, false, true, sceneDefine.mFunctionDefines);
               }
               //<<
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  entityDefine.mDrawBorder = byteArray.readByte ();
                  entityDefine.mDrawBackground = byteArray.readByte ();
               }

               if (worldDefine.mVersion >= 0x0104)
               {
                  entityDefine.mBorderColor = byteArray.readUnsignedInt ();
                  entityDefine.mBorderThickness = byteArray.readByte ();
                  entityDefine.mBackgroundColor = byteArray.readUnsignedInt ();
                  entityDefine.mTransparency = byteArray.readByte ();
               }

               if (worldDefine.mVersion >= 0x0105)
               {
                  entityDefine.mBorderTransparency = byteArray.readByte ();
               }

               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  // ...
                  ReadShapePhysicsPropertiesAndAiType (entityDefine, byteArray, worldDefine, true);
                  
                  // ...
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entityDefine.mRadius = byteArray.readFloat ();
                     entityDefine.mAppearanceType = byteArray.readByte ();
                     
                     if (worldDefine.mVersion >= 0x0160)
                     {
                        entityDefine.mBodyTextureDefine = ReadTextureDefineFromBinFile (byteArray);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        entityDefine.mIsRoundCorners = byteArray.readByte () != 0
                     }

                     entityDefine.mHalfWidth = byteArray.readFloat ();
                     entityDefine.mHalfHeight = byteArray.readFloat ();
                     
                     if (worldDefine.mVersion >= 0x0160)
                     {
                        entityDefine.mBodyTextureDefine = ReadTextureDefineFromBinFile (byteArray);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     entityDefine.mLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
                     
                     if (worldDefine.mVersion >= 0x0160)
                     {
                        entityDefine.mBodyTextureDefine = ReadTextureDefineFromBinFile (byteArray);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     entityDefine.mCurveThickness = byteArray.readByte ();

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        entityDefine.mIsRoundEnds = byteArray.readByte () != 0;
                     }
                  
                     if (worldDefine.mVersion >= 0x0157)
                     {
                        entityDefine.mIsClosed = byteArray.readByte () != 0;
                     }

                     entityDefine.mLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
                  }
               }
               else // not physis shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText
                     || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                     )
                  {
                     entityDefine.mText = byteArray.readUTF ();
                     //entityDefine.mWordWrap = byteArray.readByte (); // before v2.04
                     entityDefine.mFlags1 = byteArray.readByte (); // since v2.04

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        //entityDefine.mAdaptiveBackgroundSize = byteArray.readByte () != 0; // before v2.04
                        entityDefine.mFlags2 = byteArray.readByte (); // since v2.04
                        entityDefine.mTextColor = byteArray.readUnsignedInt ();
                        entityDefine.mFontSize = byteArray.readShort ();
                        entityDefine.mIsBold  = byteArray.readByte () != 0;
                        entityDefine.mIsItalic = byteArray.readByte () != 0;
                     }

                     if (worldDefine.mVersion >= 0x0109)
                     {
                        entityDefine.mTextAlign = byteArray.readByte ();
                        entityDefine.mIsUnderlined = byteArray.readByte () != 0;
                     }

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                        {
                           entityDefine.mUsingHandCursor = byteArray.readByte () != 0;

                           entityDefine.mDrawBackground_MouseOver = byteArray.readByte () != 0;
                           entityDefine.mBackgroundColor_MouseOver = byteArray.readUnsignedInt ();
                           entityDefine.mBackgroundTransparency_MouseOver = byteArray.readByte ();

                           entityDefine.mDrawBorder_MouseOver = byteArray.readByte () != 0;
                           entityDefine.mBorderColor_MouseOver = byteArray.readUnsignedInt ();
                           entityDefine.mBorderThickness_MouseOver = byteArray.readByte ();
                           entityDefine.mBorderTransparency_MouseOver = byteArray.readByte ();
                        }
                     }

                     entityDefine.mHalfWidth = byteArray.readFloat ();
                     entityDefine.mHalfHeight = byteArray.readFloat ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     entityDefine.mRadius = byteArray.readFloat ();

                     if (worldDefine.mVersion >= 0x0105)
                     {
                        entityDefine.mInteractiveZones = byteArray.readByte ();
                        entityDefine.mInteractiveConditions = byteArray.readShort ();
                     }
                     else
                     {
                        // mIsInteractive is removed from v1.05.
                        // in FillMissedFieldsInWorldDefine (), mIsInteractive will be converted to mInteractiveZones
                        entityDefine.mIsInteractive = byteArray.readByte ();
                     }

                     entityDefine.mInitialGravityAcceleration = byteArray.readFloat ();
                     entityDefine.mInitialGravityAngle = byteArray.readShort ();

                     if (worldDefine.mVersion >= 0x0108)
                     {
                        entityDefine.mMaximalGravityAcceleration = byteArray.readFloat ();
                     }
                  }
               }
            }
            //>> from v1.58
            else if (Define.IsShapeEntity (entityDefine.mEntityType))
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
               {
                  ReadShapePhysicsPropertiesAndAiType (entityDefine, byteArray, worldDefine, false);
                  
                  entityDefine.mModuleIndex = byteArray.readShort ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
               {
                  ReadShapePhysicsPropertiesAndAiType (entityDefine, byteArray, worldDefine, false);
                  
                  entityDefine.mModuleIndexUp = byteArray.readShort ();
                  entityDefine.mModuleIndexOver = byteArray.readShort ();
                  entityDefine.mModuleIndexDown = byteArray.readShort ();
               }
            }
            //<<
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               entityDefine.mCollideConnected = byteArray.readByte ();

               if (worldDefine.mVersion >= 0x0104)
               {
                  entityDefine.mConnectedShape1Index = byteArray.readShort ();
                  entityDefine.mConnectedShape2Index = byteArray.readShort ();
               }
               else if (worldDefine.mVersion >= 0x0102) // ??!! why bytes?
               {
                  entityDefine.mConnectedShape1Index = byteArray.readByte ();
                  entityDefine.mConnectedShape2Index = byteArray.readByte ();
               }

               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mBreakable = byteArray.readByte ();
               }

               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mAnchorEntityIndex = byteArray.readShort ();

                  entityDefine.mEnableLimits = byteArray.readByte ();
                  entityDefine.mLowerAngle = byteArray.readFloat ();
                  entityDefine.mUpperAngle = byteArray.readFloat ();
                  entityDefine.mEnableMotor = byteArray.readByte ();
                  entityDefine.mMotorSpeed = byteArray.readFloat ();
                  entityDefine.mBackAndForth = byteArray.readByte ();

                  if (worldDefine.mVersion >= 0x0104)
                  {
                     entityDefine.mMaxMotorTorque = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();

                  entityDefine.mEnableLimits = byteArray.readByte ();
                  entityDefine.mLowerTranslation = byteArray.readFloat ();
                  entityDefine.mUpperTranslation = byteArray.readFloat ();
                  entityDefine.mEnableMotor = byteArray.readByte ();
                  entityDefine.mMotorSpeed = byteArray.readFloat ();
                  entityDefine.mBackAndForth = byteArray.readByte ();

                  if (worldDefine.mVersion >= 0x0104)
                  {
                     entityDefine.mMaxMotorForce = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mBreakDeltaLength = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();

                  entityDefine.mStaticLengthRatio = byteArray.readFloat ();
                  //entityDefine.mFrequencyHz = byteArray.readFloat ();
                  entityDefine.mSpringType = byteArray.readByte ();

                  entityDefine.mDampingRatio = byteArray.readFloat ();

                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mFrequencyDeterminedManner = byteArray.readByte ();
                     entityDefine.mFrequency = byteArray.readFloat ();
                     entityDefine.mSpringConstant = byteArray.readFloat ();
                     entityDefine.mBreakExtendedLength = byteArray.readFloat ();
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  entityDefine.mAnchorEntityIndex = byteArray.readShort ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
               }
            }

            sceneDefine.mEntityDefines.push (entityDefine);
         }

         // ...

         if (worldDefine.mVersion >= 0x0107)
         {
            var numOrderIds:int = byteArray.readShort (); // should == numEntities
            for (var i:int = 0; i < numOrderIds; ++ i)
            {
               sceneDefine.mEntityAppearanceOrder.push (byteArray.readShort ());
            }
         }

         // ...

         var numGroups:int = byteArray.readShort ();
         var groupId:int;

         for (groupId = 0; groupId < numGroups; ++ groupId)
         {
            var brotherIDs:Array = ReadShortArrayFromBinFile (byteArray);

            sceneDefine.mBrotherGroupDefines.push (brotherIDs);
         }

         // custom variables
         if (worldDefine.mVersion >= 0x0152)
         {
            if (worldDefine.mVersion >= 0x0157)
            {
               TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, sceneDefine.mSessionVariableDefines, true, false, "/session/" + sceneIndex);
            }
            
            //var numSpaces:int;
            //var spaceId:int;
            //var variableSpaceDefine:VariableSpaceDefine;

            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.readShort (); // numSpaces
               byteArray.readUTF (); // space name
               byteArray.readShort (); // parent id
            }
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, sceneDefine.mGlobalVariableDefines, true, false);

            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.readShort (); // numSpaces
               byteArray.readUTF (); // space name
               byteArray.readShort (); // parent id
            }
            TriggerFormatHelper2.LoadVariableDefinesFromBinFile (byteArray, sceneDefine.mEntityPropertyDefines, true, false);
         }
         
         // ...
         
         return sceneDefine;
      }
      
      public static function ReadShapePhysicsPropertiesAndAiType (entityDefine:Object, byteArray:ByteArray, worldDefine:WorldDefine, readAiType:Boolean):void
      {
         if (worldDefine.mVersion >= 0x0105)
         {
            if (readAiType)
               entityDefine.mAiType = byteArray.readByte ();
            
            entityDefine.mIsPhysicsEnabled = byteArray.readByte ();

            // the 2 lines are added in v1,04, and moved down from v1.05
            /////entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
            /////entityDefine.mIsSensor = byteArray.readByte ();
         }
         else if (worldDefine.mVersion >= 0x0104)
         {
            if (readAiType)
               entityDefine.mAiType = byteArray.readByte ();
            
            entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
            entityDefine.mIsPhysicsEnabled = byteArray.readByte ();
            entityDefine.mIsSensor = byteArray.readByte ();
         }
         else
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
            }

            if (readAiType)
               entityDefine.mAiType = byteArray.readByte ();

            entityDefine.mIsPhysicsEnabled = true;
            // entityDefine.mIsSensor = true; // will be set in FillMissedFieldsInWorldDefine
         }

         if (entityDefine.mIsPhysicsEnabled)
         {
            entityDefine.mIsStatic = byteArray.readByte ();
            entityDefine.mIsBullet = byteArray.readByte ();
            entityDefine.mDensity = byteArray.readFloat ();
            entityDefine.mFriction = byteArray.readFloat ();
            entityDefine.mRestitution = byteArray.readFloat ();

            if (worldDefine.mVersion >= 0x0105)
            {
               // the 2 lines are added in v1,04, and moved here from above from v1.05
               entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
               entityDefine.mIsSensor = byteArray.readByte ();

               // ...
               entityDefine.mIsHollow = byteArray.readByte ();
            }

            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mBuildBorder = byteArray.readByte () != 0;
               entityDefine.mIsSleepingAllowed = byteArray.readByte () != 0;
               entityDefine.mIsRotationFixed = byteArray.readByte () != 0;
               entityDefine.mLinearVelocityMagnitude = byteArray.readFloat ();
               entityDefine.mLinearVelocityAngle = byteArray.readFloat ();
               entityDefine.mAngularVelocity = byteArray.readFloat ();
            }
         }
      }
         
      public static function ReadModuleInstanceDefinesFromBinFile (worldVersion:int, byteArray:ByteArray, forSequencedModule:Boolean):Array
      {
         var numModuleInstances:int = byteArray.readShort ();
         var moduleInstanceDefines:Array= new Array (numModuleInstances);
         
         for (var miId:int = 0; miId < numModuleInstances; ++ miId)
         {
            var moduleInstanceDefine:Object = new Object ();
            moduleInstanceDefines [miId] = moduleInstanceDefine;
            
            moduleInstanceDefine.mPosX = byteArray.readFloat ();
            moduleInstanceDefine.mPosY = byteArray.readFloat ();
            moduleInstanceDefine.mScale = byteArray.readFloat ();
            moduleInstanceDefine.mIsFlipped = byteArray.readByte () != 0;
            moduleInstanceDefine.mRotation = byteArray.readFloat ();
            moduleInstanceDefine.mVisible = byteArray.readByte () != 0;
            moduleInstanceDefine.mAlpha = byteArray.readFloat ();
            
            if (forSequencedModule)
            {
               moduleInstanceDefine.mModuleDuration = byteArray.readFloat ();
            }
            
            ReadModuleInstanceDefineFromBinFile (worldVersion, byteArray, moduleInstanceDefine);
         }
         
         return moduleInstanceDefines;
      }
      
      public static function ReadModuleInstanceDefineFromBinFile (worldVersion:int, byteArray:ByteArray, moduleInstanceDefine:Object):void
      {
         moduleInstanceDefine.mModuleType = byteArray.readShort ();
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            moduleInstanceDefine.mShapeAttributeBits = byteArray.readUnsignedInt ();
            moduleInstanceDefine.mShapeBodyOpacityAndColor = byteArray.readUnsignedInt ();
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapePathThickness = byteArray.readFloat ();
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  moduleInstanceDefine.mPolyLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapeBorderOpacityAndColor = byteArray.readUnsignedInt ();
               moduleInstanceDefine.mShapeBorderThickness = byteArray.readFloat ();
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  moduleInstanceDefine.mCircleRadius = byteArray.readFloat ();
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  moduleInstanceDefine.mRectHalfWidth = byteArray.readFloat ();
                  moduleInstanceDefine.mRectHalfHeight = byteArray.readFloat ();
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  moduleInstanceDefine.mPolyLocalPoints = ReadLocalVerticesFromBinFile (byteArray);
               }
               
               if (worldVersion >= 0x0160)
               {
                  moduleInstanceDefine.mBodyTextureDefine = ReadTextureDefineFromBinFile (byteArray);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               moduleInstanceDefine.mModuleIndex = byteArray.readShort ();
            }
         }
         else // ...
         {
         }
      }
      
      public static function ReadTextureDefineFromBinFile (byteArray:ByteArray):Object
      {
         var textureDefine:Object = new Object ();
         
         textureDefine.mModuleIndex = byteArray.readShort ();
         if (textureDefine.mModuleIndex >= 0)
         {
            textureDefine.mPosX = byteArray.readFloat ();
            textureDefine.mPosY = byteArray.readFloat ();
            textureDefine.mScale = byteArray.readFloat ();
            textureDefine.mIsFlipped = byteArray.readByte () != 0;
            textureDefine.mRotation = byteArray.readFloat ();
         }
         
         return textureDefine;
      }
      
      public static function ReadLocalVerticesFromBinFile (byteArray:ByteArray):Array
      {
         var numPoints:int = byteArray.readShort ();
         var localPoints:Array = new Array (numPoints);
         
         if (numPoints == 0)
         {
         }
         else
         {
            for (var vertexId:int = 0; vertexId < localPoints.length; ++ vertexId)
            {
               var point:Point = new Point ();
               localPoints [vertexId] = point;
               
               point.x = byteArray.readFloat ();
               point.y = byteArray.readFloat ();
            }
         }
         
         return localPoints;
      }

      public static function ReadShortArrayFromBinFile (binFile:ByteArray):Array
      {
         var num:int = binFile.readShort ();

         var shortArray:Array = new Array (num);

         for (var i:int = 0; i < num; ++ i)
         {
            shortArray [i] = binFile.readShort ();
         }

         return shortArray;
      }

//==================================== playcode with hex string ======================================================

      public static function HexString2WorldDefine (hexString:String):WorldDefine
      {
         return ByteArray2WorldDefine (DataFormat3.HexString2ByteArray (hexString));
      }

//==================================== new playcode with base64 ======================================================

      public static function PlayCode2WorldDefine_Base64 (playCode:String):WorldDefine
      {
         var bytesArray:ByteArray = DataFormat3.DecodeString2ByteArray (playCode);
         if (bytesArray == null)
            return null;

         bytesArray.uncompress ();
         return ByteArray2WorldDefine (bytesArray);
      }

//====================================================================================
//
//====================================================================================

      // adjust some float numbers

      // must call FillMissedFieldsInWorldDefine before call this
      public static function AdjustNumberValuesInWorldDefine (worldDefine:WorldDefine, isForPlayer:Boolean = false, specifiedSceneIndex:int = -1):void
      {
         if (! worldDefine.mDontAdjustNumberValues)
         {
            worldDefine.mDontAdjustNumberValues = true;
            
            // scene common variables
            // from v2.03
            //{
               TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (worldDefine.mGameSaveVariableDefines);
               TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (worldDefine.mWorldVariableDefines);
               TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (worldDefine.mCommonGlobalVariableDefines);
               TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (worldDefine.mCommonEntityPropertyDefines);
            //}
            
            //modules
            // from v1.58
            //{
               for (var assembledModuleId:int = 0; assembledModuleId < worldDefine.mAssembledModuleDefines.length; ++ assembledModuleId)
               {
                  var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];
   
                  AdjustNumberValuesInModuleInstanceDefines (worldDefine.mVersion, assembledModuleDefine.mModulePartDefines, false);
               }
               
               for (var sequencedModuleId:int = 0; sequencedModuleId < worldDefine.mSequencedModuleDefines.length; ++ sequencedModuleId)
               {
                  var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];
                  
                  AdjustNumberValuesInModuleInstanceDefines (worldDefine.mVersion, sequencedModuleDefine.mModuleSequenceDefines, true);
               }
            //}
            //
         }
                  
         // scenes
         
         for (var sceneId:int = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
         {
            var sceneDefine:SceneDefine = worldDefine.mSceneDefines [sceneId];

            if (sceneDefine.mDontAdjustNumberValues || (specifiedSceneIndex >= 0 && sceneId != specifiedSceneIndex))
               continue; 
            
            sceneDefine.mDontAdjustNumberValues = true;
            
            // scene settings

            sceneDefine.mSettings.mZoomScale = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mZoomScale, 6);
   
            sceneDefine.mSettings.mWorldBorderLeftThickness = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mWorldBorderLeftThickness, 6);
            sceneDefine.mSettings.mWorldBorderTopThickness = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mWorldBorderTopThickness, 6);
            sceneDefine.mSettings.mWorldBorderRightThickness = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mWorldBorderRightThickness, 6);
            sceneDefine.mSettings.mWorldBorderBottomThickness = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mWorldBorderBottomThickness, 6);
   
            sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude, 6);
            sceneDefine.mSettings.mDefaultGravityAccelerationAngle = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mDefaultGravityAccelerationAngle, 6);
   
            sceneDefine.mSettings.mCoordinatesOriginX = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mCoordinatesOriginX, 12);
            sceneDefine.mSettings.mCoordinatesOriginY = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mCoordinatesOriginY, 12);
            sceneDefine.mSettings.mCoordinatesScale = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mCoordinatesScale, 12);
   
            sceneDefine.mSettings.mPreferredFPS = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mPreferredFPS, 6);
            if (worldDefine.mVersion >= 0x0160)
            {
               // for version earliser than v1.60, it is best not adjust this value
               sceneDefine.mSettings.mPhysicsSimulationStepTimeLength = ValueAdjuster.Number2Precision (sceneDefine.mSettings.mPhysicsSimulationStepTimeLength, 6);
            }
   
            // collision category
   
            if (worldDefine.mVersion >= 0x0102)
            {
               var numCategories:int = sceneDefine.mCollisionCategoryDefines.length;
               for (var ccId:int = 0; ccId < numCategories; ++ ccId)
               {
                  var ccDefine:Object = sceneDefine.mCollisionCategoryDefines [ccId];
   
                  ccDefine.mPosX = ValueAdjuster.Number2Precision (ccDefine.mPosX, 6);
                  ccDefine.mPosY = ValueAdjuster.Number2Precision (ccDefine.mPosY, 6);
               }
            }
   
            // entities
   
            var numEntities:int = sceneDefine.mEntityDefines.length;
   
            var createId:int;
            //var vertexId:int;
   
            var hasGravityControllers:Boolean = false;
   
            for (createId = 0; createId < numEntities; ++ createId)
            {
               var entityDefine:Object = sceneDefine.mEntityDefines [createId];
   
               entityDefine.mPosX = ValueAdjuster.Number2Precision (entityDefine.mPosX, 12);
               entityDefine.mPosY = ValueAdjuster.Number2Precision (entityDefine.mPosY, 12);
               entityDefine.mScale = ValueAdjuster.Number2Precision (entityDefine.mScale, 6);
               entityDefine.mRotation = ValueAdjuster.Number2Precision (entityDefine.mRotation, 6);
   
               entityDefine.mAlpha = ValueAdjuster.Number2Precision (entityDefine.mAlpha, 6);
   
               if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
                  {
                     entityDefine.mPowerMagnitude = ValueAdjuster.Number2Precision (entityDefine.mPowerMagnitude, 6);
                  }
               }
               if ( Define.IsLogicEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
                  {
                     TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
                  {
                     TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
   
                     // from v1.56
                     if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                     {
                        if (entityDefine.mPreFunctionDefine != undefined)
                           TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPreFunctionDefine);
                        if (entityDefine.mPostFunctionDefine != undefined)
                           TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPostFunctionDefine);
                     }
                     //<<
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
                  {
                     TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
                  }
                  //>>from v1.56
                  else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
                  {
                     TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
                  {
                     TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mFunctionDefine);
                  }
                  //<<
               }
               else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
               {
                  if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
                  {
                     // ...
                     AdjustNumberValuesOfShapePhysicsProperties (entityDefine, worldDefine);
                     
                     // ...
                     if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                     {
                        //if (worldDefine.mVersion >= 0x0105 && worldDefine.mVersion < 0x0107) // bug: should be v1,02
                        if (worldDefine.mVersion >= 0x0102 && worldDefine.mVersion < 0x0107)
                        {
                           if (entityDefine.mBorderThickness != 0)
                              entityDefine.mRadius = entityDefine.mRadius - 0.5;
                        }
   
                        entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);
   
                        if (isForPlayer)
                           entityDefine.mRadius = ValueAdjuster.AdjustCircleDisplayRadius (entityDefine.mRadius, worldDefine.mVersion);
                  
                        if (worldDefine.mVersion >= 0x0160)
                        {
                           AdjustNumberValuesInTextureDefine (entityDefine.mBodyTextureDefine);
                        }
                     }
                     else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                     {
                        //if (worldDefine.mVersion >= 0x0105 && worldDefine.mVersion < 0x0107) // bug: should be v1,02
                        if (worldDefine.mVersion >= 0x0102 && worldDefine.mVersion < 0x0107)
                        {
                           if (entityDefine.mBorderThickness != 0)
                           {
                              entityDefine.mHalfWidth = entityDefine.mHalfWidth - 0.5;
                              entityDefine.mHalfHeight = entityDefine.mHalfHeight - 0.5;
                           }
                        }
   
                        entityDefine.mHalfWidth = ValueAdjuster.Number2Precision (entityDefine.mHalfWidth, 6);
                        entityDefine.mHalfHeight = ValueAdjuster.Number2Precision (entityDefine.mHalfHeight, 6);
                  
                        if (worldDefine.mVersion >= 0x0160)
                        {
                           AdjustNumberValuesInTextureDefine (entityDefine.mBodyTextureDefine);
                        }
                     }
                     else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                     {
                        //for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                        //{
                        //   entityDefine.mLocalPoints [vertexId].x = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].x, 6);
                        //   entityDefine.mLocalPoints [vertexId].y = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].y, 6);
                        //}
                        AdjustNumberValuesInPointArray (entityDefine.mLocalPoints);
   
                        if (worldDefine.mVersion < 0x0107)
                        {
                           if (entityDefine.mBorderThickness < 2.0)
                              entityDefine.mBuildBorder = false;
                        }
                  
                        if (worldDefine.mVersion >= 0x0160)
                        {
                           AdjustNumberValuesInTextureDefine (entityDefine.mBodyTextureDefine);
                        }
                     }
                     else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                     {
                        //for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                        //{
                        //   entityDefine.mLocalPoints [vertexId].x = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].x, 6);
                        //   entityDefine.mLocalPoints [vertexId].y = ValueAdjuster.Number2Precision (entityDefine.mLocalPoints [vertexId].y, 6);
                        //}
                        AdjustNumberValuesInPointArray (entityDefine.mLocalPoints);
   
                        if (worldDefine.mVersion < 0x0107)
                        {
                           if (entityDefine.mCurveThickness < 2.0)
                              entityDefine.mIsPhysicsEnabled = false;
                        }
                     }
                  }
                  else // not physis shape
                  {
                     if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                     {
                        entityDefine.mHalfWidth = ValueAdjuster.Number2Precision (entityDefine.mHalfWidth, 6);
                        entityDefine.mHalfHeight = ValueAdjuster.Number2Precision (entityDefine.mHalfHeight, 6);
                     }
                     else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                     {
                        hasGravityControllers = true;
   
                        entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);
   
                        if (worldDefine.mVersion < 0x0108)
                        {
                           entityDefine.mInitialGravityAcceleration = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.P2D_LinearAccelerationMagnitude (entityDefine.mInitialGravityAcceleration);
                        }
   
                        entityDefine.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (entityDefine.mInitialGravityAcceleration, 6);
   
                        entityDefine.mMaximalGravityAcceleration = ValueAdjuster.Number2Precision (entityDefine.mMaximalGravityAcceleration, 6);
                     }
                  }
               }
               //>> from v1.58
               else if (Define.IsShapeEntity (entityDefine.mEntityType))
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
                  {
                     AdjustNumberValuesOfShapePhysicsProperties (entityDefine, worldDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
                  {
                     AdjustNumberValuesOfShapePhysicsProperties (entityDefine, worldDefine);
                  }
               }
               //<<
               else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_JointHinge)
                  {
                     entityDefine.mLowerAngle = ValueAdjuster.Number2Precision (entityDefine.mLowerAngle, 6);
                     entityDefine.mUpperAngle = ValueAdjuster.Number2Precision (entityDefine.mUpperAngle, 6);
   
                     if (worldDefine.mVersion < 0x0107)
                        entityDefine.mMotorSpeed *= (0.1 * Define.kRadians2Degrees); // for a history bug
   
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mMaxMotorTorque = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.P2D_Torque (entityDefine.mMaxMotorTorque);
   
                        // anchor visible
                        sceneDefine.mEntityDefines [entityDefine.mAnchorEntityIndex].mIsVisible = entityDefine.mIsVisible;
                     }
   
                     entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);
                     entityDefine.mMaxMotorTorque = ValueAdjuster.Number2Precision (entityDefine.mMaxMotorTorque, 6);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
                  {
                     entityDefine.mLowerTranslation = ValueAdjuster.Number2Precision (entityDefine.mLowerTranslation, 6);
                     entityDefine.mUpperTranslation = ValueAdjuster.Number2Precision (entityDefine.mUpperTranslation, 6);
                     entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);
   
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mMaxMotorForce = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.P2D_ForceMagnitude (entityDefine.mMaxMotorForce);
   
                        // anchor visilbe
                        sceneDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex].mIsVisible = entityDefine.mIsVisible;
                        sceneDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex].mIsVisible = entityDefine.mIsVisible;
                     }
   
                     entityDefine.mMaxMotorForce = ValueAdjuster.Number2Precision (entityDefine.mMaxMotorForce, 6);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
                  {
                     entityDefine.mBreakDeltaLength = ValueAdjuster.Number2Precision (entityDefine.mBreakDeltaLength, 6);
   
                     if (worldDefine.mVersion < 0x0108)
                     {
                        // anchor visilbe
                        sceneDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex].mIsVisible = entityDefine.mIsVisible;
                        sceneDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex].mIsVisible = entityDefine.mIsVisible;
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
                  {
                     entityDefine.mStaticLengthRatio = ValueAdjuster.Number2Precision (entityDefine.mStaticLengthRatio, 6);
   
                     entityDefine.mDampingRatio = ValueAdjuster.Number2Precision (entityDefine.mDampingRatio, 6);
   
                     entityDefine.mFrequency = ValueAdjuster.Number2Precision (entityDefine.mFrequency, 6);
                     entityDefine.mBreakExtendedLength = ValueAdjuster.Number2Precision (entityDefine.mBreakExtendedLength, 6);
   
                     if (worldDefine.mVersion < 0x0108)
                     {
                        // anchor visilbe
                        sceneDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex].mIsVisible = entityDefine.mIsVisible;
                        sceneDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex].mIsVisible = entityDefine.mIsVisible;
                     }
                  }
               }
            }
   
            // before v1.08, gravity = hasGravityControllers ? theLastGravityController.gravity : world.defaultGravity
            // from   v1.08, gravity = world.defaultGravity + sum (all GravityController.gravity)
            if (worldDefine.mVersion < 0x0108 && hasGravityControllers)
            {
               sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude = 0.0;
            }
   
            // custom variables
            // from v1.52
            //{
                 //>> v1.52 only
                 //var numSpaces:int;
                 //var spaceId:int;
                 //
                 //numSpaces = sceneDefine.mGlobalVariableSpaceDefines.length;
                 //for (spaceId = 0; spaceId < numSpaces; ++ spaceId)
                 //{
                 //    TriggerFormatHelper2.AdjustNumberPrecisionsInVariableSpaceDefine (sceneDefine.mGlobalVariableSpaceDefines [spaceId] as VariableSpaceDefine);
                 //}
                 //
                 //numSpaces = sceneDefine.mEntityPropertySpaceDefines.length;
                 //for (spaceId = 0; spaceId < numSpaces; ++ spaceId)
                 //{
                 //    TriggerFormatHelper2.AdjustNumberPrecisionsInVariableSpaceDefine (sceneDefine.mEntityPropertySpaceDefines [spaceId] as VariableSpaceDefine);
                 //}
                 //<<
   
                 TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (sceneDefine.mSessionVariableDefines);
                 TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (sceneDefine.mGlobalVariableDefines);
                 TriggerFormatHelper2.AdjustNumberPrecisionsInVariableDefines (sceneDefine.mEntityPropertyDefines);
            //}
   
            //custom functions
            // from v1.53
            //{
               for (var functionId:int = 0; functionId < sceneDefine.mFunctionDefines.length; ++ functionId)
               {
                  var functionDefine:FunctionDefine = sceneDefine.mFunctionDefines [functionId];
   
                  functionDefine.mPosX = ValueAdjuster.Number2Precision (functionDefine.mPosX, 6);
                  functionDefine.mPosY = ValueAdjuster.Number2Precision (functionDefine.mPosY, 6);
                  TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (functionDefine);
               }
            //}
         }
      }
      
      public static function AdjustNumberValuesOfShapePhysicsProperties (entityDefine:Object, worldDefine:WorldDefine):void
      {
         if (entityDefine.mIsPhysicsEnabled)
         {
            // from v1.08, a dynamic shape with zero density will not view as a static shape
            if (worldDefine.mVersion < 0x0108 && Number (entityDefine.mDensity) <= 0)
            {
               entityDefine.mIsStatic = true;
            }

            entityDefine.mDensity = ValueAdjuster.Number2Precision (entityDefine.mDensity, 6);
            entityDefine.mFriction = ValueAdjuster.Number2Precision (entityDefine.mFriction, 6);
            entityDefine.mRestitution = ValueAdjuster.Number2Precision (entityDefine.mRestitution, 6);

            entityDefine.mLinearVelocityMagnitude = ValueAdjuster.Number2Precision (entityDefine.mLinearVelocityMagnitude, 6);
            entityDefine.mLinearVelocityAngle = ValueAdjuster.Number2Precision (entityDefine.mLinearVelocityAngle, 6);
            entityDefine.mAngularVelocity = ValueAdjuster.Number2Precision (entityDefine.mAngularVelocity, 6);
         }
      }
      
      public static function AdjustNumberValuesInModuleInstanceDefines (worldVersion:int, moduleInstanceDefines:Array, forSequencedModule:Boolean):void
      {
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId];
            
            moduleInstanceDefine.mAlpha = ValueAdjuster.Number2Precision (moduleInstanceDefine.mAlpha, 6);
            moduleInstanceDefine.mPosX = ValueAdjuster.Number2Precision (moduleInstanceDefine.mPosX, 6); //12); // here, different with entity
            moduleInstanceDefine.mPosY = ValueAdjuster.Number2Precision (moduleInstanceDefine.mPosY, 6); //12);
            moduleInstanceDefine.mScale = ValueAdjuster.Number2Precision (moduleInstanceDefine.mScale, 6);
            moduleInstanceDefine.mRotation = ValueAdjuster.Number2Precision (moduleInstanceDefine.mRotation, 6);
            
            if (forSequencedModule)
               moduleInstanceDefine.mModuleDuration = ValueAdjuster.Number2Precision (moduleInstanceDefine.mModuleDuration, 6);
            
            AdjustNumberValuesInModuleInstanceDefine (worldVersion, moduleInstanceDefine);
         }
      }
      
      public static function AdjustNumberValuesInModuleInstanceDefine (worldVersion:int, moduleInstanceDefine:Object):void
      {
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapePathThickness = ValueAdjuster.Number2Precision (moduleInstanceDefine.mShapePathThickness, 6);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  AdjustNumberValuesInPointArray (moduleInstanceDefine.mPolyLocalPoints);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapeBorderThickness = ValueAdjuster.Number2Precision (moduleInstanceDefine.mShapeBorderThickness, 6);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  moduleInstanceDefine.mCircleRadius = ValueAdjuster.Number2Precision (moduleInstanceDefine.mCircleRadius, 6);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  moduleInstanceDefine.mRectHalfWidth = ValueAdjuster.Number2Precision (moduleInstanceDefine.mRectHalfWidth, 6);
                  moduleInstanceDefine.mRectHalfHeight = ValueAdjuster.Number2Precision (moduleInstanceDefine.mRectHalfHeight, 6);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  AdjustNumberValuesInPointArray (moduleInstanceDefine.mPolyLocalPoints);
               }
               
               //>>from v1.60
               AdjustNumberValuesInTextureDefine (moduleInstanceDefine.mBodyTextureDefine);
               //<<
            }
         }
         //else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         //{
         //   if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
         //   {
         //      moduleInstanceDefine.mModuleIndex = parseInt (element.@module_index);
         //   }
         //}
         //else // ...
         //{
         //}
      }
      
      public static function AdjustNumberValuesInTextureDefine (textureDefine:Object):void
      {
         if (textureDefine.mModuleIndex >= 0)
         {
            textureDefine.mPosX = ValueAdjuster.Number2Precision (textureDefine.mPosX, 6); //12); // here, different with entity
            textureDefine.mPosY = ValueAdjuster.Number2Precision (textureDefine.mPosY, 6); //12);
            textureDefine.mScale = ValueAdjuster.Number2Precision (textureDefine.mScale, 6);
            textureDefine.mRotation = ValueAdjuster.Number2Precision (textureDefine.mRotation, 6);
         }
      }
      
      public static function AdjustNumberValuesInPointArray (points:Array):void
      {
         if (points == null)
            return;
         
         for (var vertexId:int = 0; vertexId < points.length; ++ vertexId)
         {
            var point:Point = points [vertexId];
            point.x = ValueAdjuster.Number2Precision (point.x, 6);
            point.y = ValueAdjuster.Number2Precision (point.y, 6);
         }
      }
      
//============================================================

      // fill some missed fields in earliser versions

      public static function FillMissedFieldsInWorldDefine (worldDefine:WorldDefine, specifiedSceneIndex:int = -1):void
      {
         if (! worldDefine.mDontFillMissedFields)
         {
            worldDefine.mDontFillMissedFields = true;
             
            if (worldDefine.mVersion < 0x0102)
            {
               worldDefine.mShareSourceCode = false;
               worldDefine.mPermitPublishing = false;
            }
            
            // modules
            if (worldDefine.mVersion >= 0x0158)
            {
               for (var assembledModuleId:int = 0; assembledModuleId < worldDefine.mAssembledModuleDefines.length; ++ assembledModuleId)
               {
                  var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];
   
                  FillMissedFieldsInModuleInstanceDefines (worldDefine.mVersion, assembledModuleDefine.mModulePartDefines, false);
               }
               
               for (var sequencedModuleId:int = 0; sequencedModuleId < worldDefine.mSequencedModuleDefines.length; ++ sequencedModuleId)
               {
                  var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];
   
                  if (worldDefine.mVersion < 0x0202)
                  {
                     sequencedModuleDefine.mSettingFlags = 0;
                  }
                  
                  FillMissedFieldsInModuleInstanceDefines (worldDefine.mVersion, sequencedModuleDefine.mModuleSequenceDefines, true);
               }
            }
         }

         for (var sceneId:int = 0; sceneId < worldDefine.mSceneDefines.length; ++ sceneId)
         {
            var sceneDefine:SceneDefine = worldDefine.mSceneDefines [sceneId];
            
            if (sceneDefine.mDontFillMissedFields || (specifiedSceneIndex >= 0 && sceneId != specifiedSceneIndex))
               continue;
            
            sceneDefine.mDontFillMissedFields = true;
            
            // ...
            
            if (worldDefine.mVersion < 0x0200)
            {
               sceneDefine.mKey = null;
               sceneDefine.mName = "Default Scene";
            }
            
            if (worldDefine.mVersion < 0x0151)
            {
               sceneDefine.mSettings.mViewerUiFlags = Define.PlayerUiFlags_BeforeV0151;
               sceneDefine.mSettings.mPlayBarColor = 0x606060;
               sceneDefine.mSettings.mViewportWidth = 600;
               sceneDefine.mSettings.mViewportHeight = 600;
               sceneDefine.mSettings.mZoomScale = 1.0;
            }
   
            if (worldDefine.mVersion < 0x0104)
            {
               sceneDefine.mSettings.mWorldLeft = 0;
               sceneDefine.mSettings.mWorldTop  = 0;
               sceneDefine.mSettings.mWorldWidth = 600;
               sceneDefine.mSettings.mWorldHeight = 600;
               sceneDefine.mSettings.mCameraCenterX = sceneDefine.mSettings.mWorldLeft + 600 * 0.5
               sceneDefine.mSettings.mCameraCenterY = sceneDefine.mSettings.mWorldTop + 600 * 0.5;
               sceneDefine.mSettings.mBackgroundColor = 0xDDDDA0;
               sceneDefine.mSettings.mBuildBorder = true;
               sceneDefine.mSettings.mBorderColor = Define.ColorStaticObject;
            }
   
            if (worldDefine.mVersion < 0x0101)
            {
               sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount = 512;
               sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 8;
            }
            else if (worldDefine.mVersion < 0x0104)
            {
               sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount = 1024;
               sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 8;
            }
            else if (worldDefine.mVersion < 0x0105)
            {
               sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount = 2048;
               sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 8;
            }
            else if (worldDefine.mVersion < 0x0106)
            {
               sceneDefine.mSettings.mPhysicsShapesPotentialMaxCount = 4096;
               sceneDefine.mSettings.mPhysicsShapesPopulationDensityLevel = 4;
            }
   
            if (worldDefine.mVersion < 0x0108)
            {
               sceneDefine.mSettings.mIsInfiniteWorldSize = false;
   
               sceneDefine.mSettings.mBorderAtTopLayer = false;
               sceneDefine.mSettings.mWorldBorderLeftThickness = 10;
               sceneDefine.mSettings.mWorldBorderTopThickness = 20;
               sceneDefine.mSettings.mWorldBorderRightThickness = 10;
               sceneDefine.mSettings.mWorldBorderBottomThickness = 20;
   
               sceneDefine.mSettings.mDefaultGravityAccelerationMagnitude = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.P2D_LinearAccelerationMagnitude (9.8);
               sceneDefine.mSettings.mDefaultGravityAccelerationAngle = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.P2D_RotationDegrees (90);
   
               sceneDefine.mSettings.mRightHandCoordinates = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.IsRightHand ();
               sceneDefine.mSettings.mCoordinatesOriginX = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.GetOriginX ();
               sceneDefine.mSettings.mCoordinatesOriginY = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.GetOriginY ();
               sceneDefine.mSettings.mCoordinatesScale = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.GetScale ();
   
               sceneDefine.mSettings.mIsCiRulesEnabled  = true;
            }
   
            if (worldDefine.mVersion < 0x0155)
            {
               sceneDefine.mSettings.mAutoSleepingEnabled = true;
               sceneDefine.mSettings.mCameraRotatingEnabled = false;
            }
   
            if (worldDefine.mVersion < 0x0160)
            {
               sceneDefine.mSettings.mInitialSpeedX = 2;
               sceneDefine.mSettings.mPreferredFPS = 30;
               sceneDefine.mSettings.mPauseOnFocusLost = false;
               
               sceneDefine.mSettings.mPhysicsSimulationEnabled = true;
               sceneDefine.mSettings.mPhysicsSimulationStepTimeLength = (1.0 / 30) * 0.5;
               sceneDefine.mSettings.mPhysicsSimulationQuality = 0x0803;
               sceneDefine.mSettings.mCheckTimeOfImpact = true;
            }
   
            // collision category
   
            // entities
   
            var numEntities:int = sceneDefine.mEntityDefines.length;
   
            var createId:int;
            var vertexId:int;
   
            for (createId = 0; createId < numEntities; ++ createId)
            {
               var entityDefine:Object = sceneDefine.mEntityDefines [createId];
   
               if (worldDefine.mVersion < 0x0158)
               {
                  entityDefine.mScale = 1.0;
                  entityDefine.mIsFlipped = false;
               }
   
               if (worldDefine.mVersion < 0x0108)
               {
                  entityDefine.mAlpha = 1.0;
                  entityDefine.mIsEnabled = true;
               }
   
               if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
                  {
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mFollowedTarget = Define.Camera_FollowedTarget_Brothers;
                        entityDefine.mFollowingStyle = Define.Camera_FollowingStyle_Default;
                     }
                  }
               }
               else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
               {
                  //if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
                  //{
                  //   TriggerFormatHelper2.FillMissedFieldsInFunctionDefine (entityDefine.mFunctionDefine);
                  //}
                  //if (entityDefine.mEntityType == Define.EntityType_LogicAction)
                  //{
                  //   TriggerFormatHelper2.FillMissedFieldsInFunctionDefine (entityDefine.mFunctionDefine);
                  //}
                  //else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
                  //{
                  //   if (worldDefine.mVersion < 0x0108)
                  //   {
                  //      entityDefine.mExternalActionEntityCreationId = -1;
                  //   }
                  //
                  //   TriggerFormatHelper2.FillMissedFieldsInFunctionDefine (entityDefine.mFunctionDefine);
                  //
                  //   if (worldDefine.mVersion >= 0x0156)
                  //   {
                  //      if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                  //      {
                  //         TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPreFunctionDefine);
                  //         TriggerFormatHelper2.AdjustNumberPrecisionsInFunctionDefine (entityDefine.mPostFunctionDefine);
                  //      }
                  //   }
                  //}
               }
               else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
               {
                  if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
                  {
                     if ( Define.IsBasicPathVectorShapeEntity (entityDefine.mEntityType) )
                     {
                        if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                        {
                           if (worldDefine.mVersion < 0x0108)
                           {
                              entityDefine.mIsRoundEnds = true;
                           }
                           
                           if (worldDefine.mVersion < 0x0157)
                           {
                              entityDefine.mIsClosed = false;
                           }
                        }
                     }
                     else if ( Define.IsBasicAreaVectorShapeEntity (entityDefine.mEntityType) )
                     {
                        if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                        {
                           if (worldDefine.mVersion < 0x0160)
                           {
                              entityDefine.mBodyTextureDefine = new Object ();
                              entityDefine.mBodyTextureDefine.mModuleIndex = -1;
                           }
                        }
                        else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                        {
                           if (worldDefine.mVersion < 0x0108)
                           {
                              entityDefine.mIsRoundCorners = false;
                           }
                           
                           if (worldDefine.mVersion < 0x0160)
                           {
                              entityDefine.mBodyTextureDefine = new Object ();
                              entityDefine.mBodyTextureDefine.mModuleIndex = -1;
                           }
                        }
                        else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                        {
                           if (worldDefine.mVersion < 0x0160)
                           {
                              entityDefine.mBodyTextureDefine = new Object ();
                              entityDefine.mBodyTextureDefine.mModuleIndex = -1;
                           }
                        }
                     }
                  }
                  else // not physis shape
                  {
                     entityDefine.mAiType = Define.ShapeAiType_Unknown;
   
                     if (entityDefine.mEntityType == Define.EntityType_ShapeText
                        || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                        )
                     {
                        if (worldDefine.mVersion < 0x0108)
                        {
                           //entityDefine.mAdaptiveBackgroundSize = false; // before v2.04
                           entityDefine.mFlags2 = 0; // since v2.04
                           entityDefine.mTextColor = 0x0;
                           entityDefine.mFontSize = 10;
                           entityDefine.mIsBold = false;
                           entityDefine.mIsItalic = false;
                        }
   
                        if (worldDefine.mVersion < 0x0109)
                        {
                           entityDefine.mTextAlign = entityDefine.mEntityType == Define.EntityType_ShapeTextButton ? TextUtil.TextAlign_Center : TextUtil.TextAlign_Left;
                           entityDefine.mIsUnderlined = false;
                        }
   
                        if (worldDefine.mVersion < 0x0204)
                        {
                           entityDefine.mTextAlign |= TextUtil.TextAlign_Middle;
                        }
   
                     }
                     else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                     {
                        if (worldDefine.mVersion < 0x0105)
                        {
                           entityDefine.mInteractiveZones = entityDefine.mIsInteractive ? (1 << Define.GravityController_InteractiveZone_AllArea) : 0;
                           entityDefine.mInteractiveConditions = 0;
                        }
   
                        if (worldDefine.mVersion < 0x0108)
                        {
                           entityDefine.mMaximalGravityAcceleration = CoordinateSystem.kDefaultCoordinateSystem_BeforeV0108.P2D_LinearAccelerationMagnitude (9.8);
                        }
                     }
                  }
   
                  // some if(s) put below for the mAiType would be adjust in above code block
   
                  if (worldDefine.mVersion < 0x0102)
                  {
                     entityDefine.mCollisionCategoryIndex = Define.CCatId_Hidden;
   
                     entityDefine.mDrawBorder = (! entityDefine.mIsStatic) || Define.IsBreakableShape (entityDefine.mAiType);
                     entityDefine.mDrawBackground = true;
                  }
   
                  if (worldDefine.mVersion < 0x0104)
                  {
                     entityDefine.mIsPhysicsEnabled = true;
                     entityDefine.mIsSensor = false;
   
                     entityDefine.mBorderColor = 0x0;
                     entityDefine.mBorderThickness = 1;
                     entityDefine.mBackgroundColor = Define.GetShapeFilledColor (entityDefine.mAiType);
                     entityDefine.mTransparency = 100;
                  }
   
                  if (worldDefine.mVersion < 0x0105)
                  {
                     entityDefine.mBorderTransparency = entityDefine.mTransparency;
                     entityDefine.mIsHollow = false;
                  }
   
                  if (worldDefine.mVersion < 0x0108)
                  {
                     entityDefine.mBuildBorder = true;
                     entityDefine.mIsSleepingAllowed = true;
                     entityDefine.mIsRotationFixed = false;
                     entityDefine.mLinearVelocityMagnitude = 0.0;
                     entityDefine.mLinearVelocityAngle = 0.0;
                     entityDefine.mAngularVelocity = 0.0;
                  }
               }
               else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
               {
                  if (worldDefine.mVersion < 0x0108)
                  {
                     entityDefine.mBreakable = false;
                  }
   
                  if (entityDefine.mEntityType == Define.EntityType_JointHinge)
                  {
                     if (worldDefine.mVersion < 0x0104)
                        entityDefine.mMaxMotorTorque = Define.DefaultHingeMotorTorque;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
                  {
                     if (worldDefine.mVersion < 0x0104)
                        entityDefine.mMaxMotorForce = Define.DefaultSliderMotorForce;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
                  {
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mBreakDeltaLength = 0.0;
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
                  {
                     if (worldDefine.mVersion < 0x0108)
                     {
                        entityDefine.mFrequencyDeterminedManner = Define.SpringFrequencyDetermineManner_Preset;
                        entityDefine.mFrequency = 0.0;
                        entityDefine.mSpringConstant = 0.0;
                        entityDefine.mBreakExtendedLength = 0.0;
                     }
                  }
   
                  if (worldDefine.mVersion < 0x0102)
                  {
                     entityDefine.mConnectedShape1Index = Define.EntityId_None;
                     entityDefine.mConnectedShape2Index = Define.EntityId_None;
                  }
               }
            }
   
            // creation order
            if (worldDefine.mVersion < 0x0107 || sceneDefine.mEntityAppearanceOrder.length == 0)
            {
               for (var appearId:int = 0; appearId < numEntities; ++ appearId)
               {
                  sceneDefine.mEntityAppearanceOrder.push (appearId);
               }
            }
   
            // functions
            if (worldDefine.mVersion >= 0x0152)
            {
               for (var functionId:int = 0; functionId < sceneDefine.mFunctionDefines.length; ++ functionId)
               {
                  var functionDefine:FunctionDefine = sceneDefine.mFunctionDefines [functionId] as FunctionDefine;
   
                  if (worldDefine.mVersion < 0x0156)
                  {
                     functionDefine.mDesignDependent = false;
                  }
                  if (worldDefine.mVersion < 0x0200) // for a design mistake, afunction tagged with pure is not sure a real pure function. 
                  {
                     functionDefine.mDesignDependent = true;
                  }
               }
            } // functions
         } // scene
      }
      

      
      public static function FillMissedFieldsInModuleInstanceDefines (worldVersion:int, moduleInstanceDefines:Array, forSequencedModule:Boolean):void
      {
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId];
            
            if (worldVersion < 0x0160)
            {
               if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
               {
                  moduleInstanceDefine.mBodyTextureDefine = new Object ();
                  moduleInstanceDefine.mBodyTextureDefine.mModuleIndex = -1;
               }
            }
         }
      }

   }

}
