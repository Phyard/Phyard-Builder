package player.world {

   import flash.system.IME;

   import flash.utils.ByteArray;

   import flash.utils.Dictionary;

   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;

   import flash.events.EventPhase;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.ui.KeyLocation;
   import flash.events.FocusEvent;

   import flash.utils.Dictionary;

   import flash.ui.Mouse;

   import player.physics.PhysicsEngine;
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;

   import player.design.Global;

   import player.entity.Entity;
   import player.entity.EntityVoid;
   import player.entity.EntityBody;
   import player.entity.EntityShape;
   import player.entity.EntityShape_Particle;
   import player.entity.EntityShape_CircleBomb;
   import player.entity.EntityShape_RectangleBomb;
   import player.entity.EntityShape_WorldBorder;

   import player.trigger.entity.ScriptHolder;
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.entity.EntityEventHandler_Timer;
   import player.trigger.entity.EntityEventHandler_Keyboard;
   import player.trigger.entity.EntityEventHandler_Gesture;
   import player.trigger.entity.EntitySelector;

   import player.trigger.data.ShapeContactInfo;
   import player.trigger.data.ListElement_EntityShape;
   import player.trigger.data.ListElement_EventHandler;
   import player.trigger.data.ListElement_EntitySelector;

   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;

   import player.mode.Mode;
   import player.mode.ModeMoveWorldScene;

   import common.CoordinateSystem;

   import common.trigger.CoreEventIds;
   import common.trigger.IdPool;
   import common.trigger.ValueDefine;

   import common.Define;
   import common.ValueAdjuster;
   
   import common.KeyCodes;
   import common.GestureIDs;

   import common.DataFormat2;

   public class World extends Sprite
   {
   // includes

      include "../trigger/CoreFunctionDefinitions_World.as";
      include "World_CameraAndView.as";
      include "World_SystemEventHandling.as";
      include "World_ParticleManager.as";
      include "World_ColorInfectionRelated.as";
      include "World_Task.as";
      include "World_ContactEventHandling.as";
      include "World_KeyboardEventHandling.as";
      include "World_GestureEventHandling.as";
      include "World_GeneralEventHandling.as";
      include "World_Misc.as";

   //

      public static const DefaultWorldWidth :int = Define.DefaultWorldWidth;
      public static const DefaultWorldHeight:int = Define.DefaultWorldHeight;
      public static const WorldBorderThinknessLR:int = Define.WorldBorderThinknessLR;
      public static const WorldBorderThinknessTB:int = Define.WorldBorderThinknessTB;

   // ...

      private var mVersion:int = 0x0;
      private var mWorldKey:String = "";
      private var mAuthorName:String = "";
      private var mAuthorHomepage:String = "";
      private var mShareSourceCode:Boolean = false;
      private var mPermitPublishing:Boolean = false;
      
   // ...
      
      private var mCurrentSceneId:int;
   
      private var mSceneKey:String;
      private var mSceneName:String;
   
   // ...

      private var mNumEntitiesInEditor:int;
      private var mEntityArrayOrderByCreationId:Array;
      private var mEntityArrayOrderByAppearanceId:Array;

      private var mNextEntityCreationId:int; // initially equals the value of mNumEntitiesInEditor.
         // if the UniqueID (replace creation id or not) is introduced later,
         // 1. it is best to limit the max UniqueID in editor with a not too large number, such as 65536.
         //     This is to make rooms for rumtime created ids.
         // 2. set the initial value as mMaxEntityUniqueIdInEditor

   // ...

      private var mCoordinateSystem:CoordinateSystem;

//==============================================================================
// construct
//==============================================================================

      // todo:
      //   World -> Scene
      //   worldDefine -> sceneDefine

      public function World (worldDefine:Object)
      {
         // basic
         //
         //mVersion          = worldDefine.mVersion;
         //mAuthorName       = worldDefine.mAuthorName;
         //mAuthorHomepage   = worldDefine.mAuthorHomepage;
         //mShareSourceCode  = worldDefine.mShareSourceCode;
         //mPermitPublishing = worldDefine.mPermitPublishing;
         
         // ...
         
         mSceneKey  = worldDefine.mKey;
         mSceneName = worldDefine.mName;
         
         // ...
         
         mInitialSpeedX = worldDefine.mSettings.mInitialSpeedX;
         mPreferredFPS = worldDefine.mSettings.mPreferredFPS;
         mPauseOnFocusLost = worldDefine.mSettings.mPauseOnFocusLost;
         
         mPhysicsSimulationEnabled = worldDefine.mSettings.mPhysicsSimulationEnabled;
         mPhysicsSimulationQuality = worldDefine.mSettings.mPhysicsSimulationQuality;
         mCheckTimeOfImpact = worldDefine.mSettings.mCheckTimeOfImpact;
         mPhysicsSimulationStepTimeLength = worldDefine.mSettings.mPhysicsSimulationStepTimeLength;

         // ...

         mViewerUiFlags = worldDefine.mSettings.mViewerUiFlags;
         mPlayBarColor = worldDefine.mSettings.mPlayBarColor;

         mPreferredViewportWidth = worldDefine.mSettings.mViewportWidth;
         mPreferredViewportHeight = worldDefine.mSettings.mViewportHeight;
         SetRealViewportSize (mPreferredViewportWidth, mPreferredViewportHeight);
         mZoomScale = worldDefine.mSettings.mZoomScale;

         mCameraRotatingEnabled = worldDefine.mSettings.mCameraRotatingEnabled;

         // ...

         SetBackgroundColor (worldDefine.mSettings.mBackgroundColor);
         SetBorderColor (worldDefine.mSettings.mBorderColor);

         mIsInfiniteWorldSize = worldDefine.mSettings.mIsInfiniteWorldSize;

         // these values are in pixel unit

         mWorldBorderLeftThickness = worldDefine.mSettings.mWorldBorderLeftThickness;
         mWorldBorderTopThickness = worldDefine.mSettings.mWorldBorderTopThickness;
         mWorldBorderRightThickness = worldDefine.mSettings.mWorldBorderRightThickness;
         mWorldBorderBottomThickness = worldDefine.mSettings.mWorldBorderBottomThickness;
         mBuildBorder = worldDefine.mSettings.mBuildBorder;
         mIsBorderAtTopLayer = worldDefine.mSettings.mBorderAtTopLayer;

         if (mIsInfiniteWorldSize)
         {
            mBuildBorder = false; // force false

            mWorldLeft   = - 0x7FFFFFFF;
            mWorldTop    = - 0x7FFFFFFF;
            mWorldWidth  = uint (0xFFFFFFFF);
            mWorldHeight = uint (0xFFFFFFFF);
         }
         else
         {
            mWorldLeft = worldDefine.mSettings.mWorldLeft;
            mWorldTop = worldDefine.mSettings.mWorldTop;
            mWorldWidth = worldDefine.mSettings.mWorldWidth;
            mWorldHeight = worldDefine.mSettings.mWorldHeight;
         }

         mCameraCenterX = worldDefine.mSettings.mCameraCenterX;
         mCameraCenterY = worldDefine.mSettings.mCameraCenterY;
         mCameraAngle = 0;

      // ...

         mNumEntitiesInEditor = worldDefine.mEntityDefines.length;
         mEntityArrayOrderByCreationId   = new Array (mNumEntitiesInEditor);
         mEntityArrayOrderByAppearanceId = new Array (mNumEntitiesInEditor);

         mNextEntityCreationId = mNumEntitiesInEditor;

      // ...

         SetCiRulesEnabled (worldDefine.mSettings.mIsCiRulesEnabled);

      // ...

         mFunc_StepUpdate = Update_FixedStepInterval_SpeedX;

      // ...

         ParticleManager_Initialize ();

      // ...
         var coordinates_scale:Number = worldDefine.mSettings.mCoordinatesScale;
         if (coordinates_scale <= 0)
            coordinates_scale = 1.0;
         mCoordinateSystem = new CoordinateSystem (worldDefine.mSettings.mCoordinatesOriginX, worldDefine.mSettings.mCoordinatesOriginY, coordinates_scale, worldDefine.mSettings.mRightHandCoordinates);

         mDefaultGravityAccelerationMagnitude = mCoordinateSystem.D2P_LinearAccelerationMagnitude (worldDefine.mSettings.mDefaultGravityAccelerationMagnitude);
         mDefaultGravityAccelerationAngle = mCoordinateSystem.D2P_RotationRadians (worldDefine.mSettings.mDefaultGravityAccelerationAngle * Define.kDegrees2Radians);

         mAutoSleepingEnabled = worldDefine.mSettings.mAutoSleepingEnabled;

         CreatePhysicsEngine ();

      // ...

         CreateGraphicsLayers ();

      // ...

         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
//==============================================================================
//
//==============================================================================

      protected var mBuildingStatus:int = 0;
         // from v1.58
         // =0 - building
         // >0 - succeeded
         // <0 - failed
      
      public function GetBuildingStatus ():int
      {
         return mBuildingStatus;
      }
      
      public function SetBuildingStatus (status:int):void
      {
         mBuildingStatus = status; 
      }
      
      public function UpdateImageModuleAppearances ():void
      {
         if (mInitialized)
         {
            mEntityList.UpdateImageModuleAppearances ();
            
            Repaint ();
         }
      }

//==============================================================================
//
//==============================================================================
      
      // temp function
      public function SetBasicInfos (worldDefine:Object):void
      {
         mVersion          = worldDefine.mVersion;
         mWorldKey         = worldDefine.mKey;
         mAuthorName       = worldDefine.mAuthorName;
         mAuthorHomepage   = worldDefine.mAuthorHomepage;
         mShareSourceCode  = worldDefine.mShareSourceCode;
         mPermitPublishing = worldDefine.mPermitPublishing;
      }

      public function GetVersion ():int
      {
         return mVersion;
      }
      
      public function GetWorldKey ():String
      {
         return mWorldKey;
      }

      public function GetAuthorName ():String
      {
         return mAuthorName;
      }

      public function GetAuthorHomepage ():String
      {
         return mAuthorHomepage;
      }

      public function IsShareSourceCode ():Boolean
      {
         return mShareSourceCode;
      }

      public function IsPermitPublishing ():Boolean
      {
         return mPermitPublishing;
      }

      public function GetCoordinateSystem ():CoordinateSystem
      {
         return mCoordinateSystem;
      }

//==============================================================================
// 
//==============================================================================
      
      public function GetSceneKey ():String
      {
         return mSceneKey;
      }
      
      public function GetSceneName ():String
      {
         return mSceneName;
      }
      
      public function GetCurrentSceneId ():int
      {
         return mCurrentSceneId;
      }
      
      public function SetCurrentSceneId (sceneId:int):void
      {
         mCurrentSceneId = sceneId;
      }

//==============================================================================
// as property owner
//==============================================================================

      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }

      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }

//==============================================================================
// some interfaces for entities
//==============================================================================

      private var mEntityList:EntityList = new EntityList (); // include entities in editor and dynamicly created entities
      private var mEntityListBody:EntityList = new EntityList ();
      // when adding new list, check the references of the old lists

      private var mDynamicCrreatedEntities:Dictionary = new Dictionary (); // no incuding entity bodies

      public function GetEntityList ():EntityList
      {
         return mEntityList;
      }

      public function GetEntityBodyList ():EntityList
      {
         return mEntityListBody;
      }

      public function RegisterEntity (entity:Entity):void
      {
         if (entity is EntityBody)
         {
            mEntityListBody.AddEntity (entity);
         }
         else
         {
            mEntityList.AddEntity (entity);

            //if (entity.IsDefinedInEditor ())
            var creationId:int = entity.GetCreationId ();
            if (creationId >= 0 && creationId < mNumEntitiesInEditor)
            {
               mEntityArrayOrderByCreationId [creationId] = entity;
            }
            else // runtime created
            {
               var nextId:int = mNextEntityCreationId ++;
               entity.SetCreationId (nextId);

               mDynamicCrreatedEntities [nextId] = entity;
            }
            
            //var appearanceId:int = entity.GetAppearanceId ();
            //if (appearanceId >= 0 && appearanceId < mNumEntitiesInEditor)
            //{
            //   mEntityArrayOrderByAppearanceId [appearanceId] = entity;
            //}
         }
      }

      public function UnregisterEntity (entity:Entity):void
      {
         if (entity.mEntityList == null)
            return;

         if (entity is EntityBody)
         {
            // == entity.mEntityList.RemoveEntity (entity);
            mEntityListBody.RemoveEntity (entity);
         }
         else
         {
            // == entity.mEntityList.RemoveEntity (entity);
            //mEntityList.RemoveEntity (entity);
            mCreationIdsToDelete_ThisStep.push (entity.GetCreationId ());
               // reasons for delay deleting:
               // - avoid null parameter sent to contact event handlers
               // - aoivd entity link table being broken in callings of ForEachEntity api

            // an entity defined in editor will never removed from the 2 arrays to make the reference in api callings always be accessable.
            //if (entity.IsDefinedInEditor ())
            //var creationId:int = entity.GetCreationId ();
            //if (creationId >= 0 && creationId < mNumEntitiesInEditor)
            //{
            //   //mEntityArrayOrderByCreationId   [entity.GetCreationId ()  ] = null;
            //   //mEntityArrayOrderByAppearanceId [entity.GetAppearanceId ()] = null;
            //}
            //else
            //{
            //   //delete mDynamicCrreatedEntities [creationId]; // will be delayed for on step
            //}
         }
      }

      public function GetNumEntitiesInEditor ():int
      {
         return mNumEntitiesInEditor;
      }

      public function GetEntityByCreateOrderId (createId:int, supportRuntimeCreatedEntity:Boolean):Entity
      {
         if (createId < 0)
         {
            return null;
         }
         else if (createId < mNumEntitiesInEditor)
         {
            return mEntityArrayOrderByCreationId [createId] as Entity;
         }
         else if (supportRuntimeCreatedEntity)
         {
            return mDynamicCrreatedEntities [createId] as Entity;
         }
         else
         {
            return null;
         }
      }

      //public function GetEntityByAppearanceId (appearanceId:int):Entity
      //{
      //   if (appearanceId >= 0 && appearanceId < mNumEntitiesInEditor)
      //   {
      //      return mEntityArrayOrderByAppearanceId [appearanceId] as Entity;
      //   }
      //   else
      //   {
      //      return null;
      //   }
      //}

      // for physics-potential shapes

      private var mPeekContactProxyId:int = 0;
      private var mFreeContactProxyIds:Array = new Array (); // recycled

      // some destroy contact events will be handled with one step delayed. So:
      private var mFreeContactProxyIds_ThisStep:Array = new Array ();
      private var mFreeContactProxyIds_LastStep:Array = new Array ();

      // for the same reason, to make shape contact events handlers always get 2 non-null shape parameters:
      private var mCreationIdsToDelete_ThisStep:Array = new Array ();
      private var mCreationIdsToDelete_LastStep:Array = new Array ();

      public function ApplyContactProxyId ():int
      {
         if (mFreeContactProxyIds.length > 0)
         {
            return mFreeContactProxyIds.pop () as int;
         }
         else if (mPeekContactProxyId < 0xFFFF) // max valid value
         {
            return mPeekContactProxyId ++;
         }
         else
         {
            return -1; // invalid
         }
      }

      public function ReleaseContactProxyId (proxyId:int):void
      {
         mFreeContactProxyIds_ThisStep.push (proxyId);
      }

      private function ConfirmFreedContactProxyIds ():void
      {
         if (mFreeContactProxyIds_LastStep.length > 0)
         {
            mFreeContactProxyIds = mFreeContactProxyIds.concat (mFreeContactProxyIds_LastStep);
            mFreeContactProxyIds_LastStep = mFreeContactProxyIds_ThisStep;
            mFreeContactProxyIds_ThisStep = new Array ();
         }
         else if (mFreeContactProxyIds_ThisStep.length > 0)
         {
            var oldIds_LastStep:Array = mFreeContactProxyIds_LastStep;
            mFreeContactProxyIds_LastStep = mFreeContactProxyIds_ThisStep;
            mFreeContactProxyIds_ThisStep = oldIds_LastStep;
         }

         // destroyed runtime-created entity ids

         if (mCreationIdsToDelete_LastStep.length > 0)
         {
            for each (var creationId:int in mCreationIdsToDelete_LastStep)
            {
               var entity:Entity;
               if (creationId >= 0 && creationId < mNumEntitiesInEditor)
               {
                  entity = mEntityArrayOrderByCreationId [creationId] as Entity;

                  // an entity defined in editor will never removed from the 2 arrays to make the reference in api callings always be accessable.
                  //mEntityArrayOrderByCreationId   [entity.GetCreationId ()  ] = null;
                  //mEntityArrayOrderByAppearanceId [entity.GetAppearanceId ()] = null;

                  // from v1.56, entities placed in editor will not be removed from list to make task aggregators work correctly.
                  //if (entity != null) // should not
                  //{
                  //   mEntityList.RemoveEntity (entity);
                  //}
               }
               else
               {
                  entity = mDynamicCrreatedEntities [creationId] as Entity;

                  delete mDynamicCrreatedEntities [creationId];

                  if (entity != null) // should not
                  {
                     mEntityList.RemoveEntity (entity);
                  }
               }
            }

            mCreationIdsToDelete_LastStep = mCreationIdsToDelete_ThisStep;
            mCreationIdsToDelete_ThisStep = new Array ();
         }
         else if (mCreationIdsToDelete_ThisStep.length > 0)
         {
            var oldCreationIds_LastStep:Array = mCreationIdsToDelete_LastStep;
            mCreationIdsToDelete_LastStep = mCreationIdsToDelete_ThisStep;
            mCreationIdsToDelete_ThisStep = oldCreationIds_LastStep;
         }
      }
      
      public function OnNumCustomEntityVariablesChanged ():void
      {
         mEntityList.OnNumCustomEntityVariablesChanged ();
      }

//==============================================================================
//   some world data
//==============================================================================

   // ...

      private var mNumSimulatedSteps:int = 0;

      public function GetSimulatedSteps ():int
      {
         return mNumSimulatedSteps;
      }

   // ...

      private var mStepStage:int = 0;

      public function IncStepStage ():void
      {
         ++ mStepStage;
      }

      public function GetStepStage ():int
      {
         return mStepStage;
      }

   // ...

      private var mLevelSimulatedTime:Number = 0.0;

      public function GetLevelMilliseconds ():Number
      {
         return mLevelSimulatedTime * 1000.0;
      }

   // ...

      private var mLastSimulatedStepInterval:Number = 0.0;

      public function GetLastSimulatedStepInterval ():Number
      {
         return mLastSimulatedStepInterval;
      }

      private var mLastSimulatedStepInterval_Inv:Number = 0.0;

      public function GetLastSimulatedStepInterval_Inv ():Number
      {
         return mLastSimulatedStepInterval_Inv;
      }

   // ...

      private var mIsPaused:Boolean = false;

      public function SetPaused (paused:Boolean):void
      {
         mIsPaused = paused;
      }

      private var mSingleStepMode:Boolean = false;

      public function SetSingleStepMode (singleStepMode:Boolean):void
      {
         mSingleStepMode = singleStepMode;
      }

   // ...

//=============================================================
//   some params
//=============================================================

      private var mInitialSpeedX:int;
            
      private var mPreferredFPS:Number;
      private var mPauseOnFocusLost:Boolean;      
      
      public function GetInitialSpeedX ():int
      {
         return mInitialSpeedX;
      }
      
      public function GetPreferredFPS ():Number
      {
         return mPreferredFPS;
      }
      
      public function IsPauseOnFocusLost ():Boolean
      {
         return mPauseOnFocusLost;
      }

//=============================================================
//   init
//=============================================================

      private var mShouldInitRuntimeCteatedEntitiesManually:Boolean = false;

      public function ShouldInitRuntimeCteatedEntitiesManually ():Boolean
      {
         return mShouldInitRuntimeCteatedEntitiesManually;
      }
      
      private var mInitialized:Boolean = false;

      public function Initialize ():void
      {
         if (mInitialized)
            return;
         
         mInitialized = true;
         
      //------------------------------------
      // init some structures
      //------------------------------------

         InitKeyHoldInfo ();

      //------------------------------------
      // create display layers, borders
      //------------------------------------

         CreateBorders (); // now, the physics has not been built.

      //------------------------------------
      // go ...
      //------------------------------------

         mNumSimulatedSteps = 0;
         mStepStage = 0;
         mLevelSimulatedTime = 0.0;

      //------------------------------------
      // build physics for entities
      //------------------------------------

         // moved up from v1.56. Before v1.56, it is called below.
         // Reason: so that many APIs can be called without problems in OnWorldBeforeInitializing event handlers

         InitPhysics (); // now contacts have not been found yet

      //------------------------------------
      // on level to init
      //------------------------------------

         // register OnEntityCreated event handlers for entities.
         RegisterEventHandlersForEntity (true);
            // currently, OnDestroy etc event handlers are not registered yet. So destroying an entities will not trigger any OnDestroy event handlers.
            // Those event handlers will be registered at following.
            // (why? forget)
            // it seems the reason is to give every entity a chance to modify some properties, so that to change the select result of EntityFilters.
            
         mEntityList.OnCreated ();

      //------------------------------------
      // on level to init
      //------------------------------------

         HandleEventById (CoreEventIds.ID_OnWorldBeforeInitializing);

      //------------------------------------
      // init camera
      //------------------------------------

         InitCamera ();

      //------------------------------------
      // init physics
      //------------------------------------

         //InitPhysics (); // moved up from v1.56

      //------------------------------------
      // init entities
      //------------------------------------

         mShouldInitRuntimeCteatedEntitiesManually = true;

         // register non-OnEntityCreated event handlers for entities. Entity.OnCreated may change some variable values which will affect the registering of non-OnEntityCreated event handlers
         RegisterEventHandlersForEntity (false);

         mEntityList.InitEntities ();

      //------------------------------------
      // on level inited
      //------------------------------------

         HandleEventById (CoreEventIds.ID_OnWorldAfterInitialized);

      //------------------------------------
      // Repaint
      //------------------------------------

         Repaint ();

      //------------------------------------
      // to avoid losing mouse events when remove entity sprites
      //------------------------------------

         mDelayRemoveDisplayObjectFromContentLayer = true;

      //-----------------------------
      // clear system events
      //-----------------------------

         ClearAllCachedSystemEvents ();

      //-----------------------------
      // destroy
      //-----------------------------

         if (mDestroyed)
            DestroyReally ();

      //-----------------------------
      // update camera
      //-----------------------------

         UpdateCamera ();

      //-----------------------------
      // system dispatchs mouse, keyboard and other events
      //-----------------------------
      }

//=============================================================
//   SynchonizeWithPhysics
//=============================================================

      private function SynchonizeWithPhysics (fromLastMarkedTail:Boolean):void
      {
         mEntityListBody.SynchronizeEntitiesWithPhysicsProxies (fromLastMarkedTail);

         mEntityList.SynchronizeEntitiesWithPhysicsProxies (fromLastMarkedTail);
      }

//=============================================================
//   update
//=============================================================

      private var mFunc_StepUpdate:Function = null;

      public function Update (escapedTime:Number, speedX:int):void
      {
         if (mDestroyed)
            return;

      //-----------------------------
      // remove the delay removeds
      //-----------------------------

         DelayRemoveDisplayObjectFromContentLayer ();

      //-----------------------------
      // update
      //-----------------------------

         //if (mFunc_StepUpdate != null) // should not be null
            mFunc_StepUpdate (escapedTime, speedX);

      //-----------------------------
      // repaint
      //-----------------------------

         Repaint ();

      //------------------------------------
      // to avoid losing mouse events when remove entity sprites
      //------------------------------------

         mDelayRemoveDisplayObjectFromContentLayer = true;

      //-----------------------------
      // destroy
      //-----------------------------

         if (mDestroyed)
            DestroyReally ();

      //-----------------------------
      // system dispatchs mouse, keyboard and other events
      //-----------------------------
      }

      public function Update_FixedStepInterval_SpeedX (escapedTime1:Number, speedX:int):void
      {
         //var dt:Number = Define.WorldStepTimeInterval_SpeedX2 * 0.5;
         //var dt:Number = Define.WorldStepTimeInterval_SpeedX1; // before v1.60. (1.0 / 30 * 0.5)
         var dt:Number = mPhysicsSimulationStepTimeLength;

         if (escapedTime1 == 0)
            dt = 0;

         var k:uint;
         var i:uint;
         var displayObject:Object;

         //-----------------------------
         // delay handle system events
         // In flash, only valid when k==0 in fact
         //-----------------------------

         HandleAllCachedSystemEvents ();
         ClearAllCachedSystemEvents ();

         for (k = 0; k < speedX; ++ k)
         {
         //-----------------------------
         // on level to update
         //-----------------------------

            HandleEventById (CoreEventIds.ID_OnWorldBeforeUpdating);

         //-----------------------------
         // update physics
         //-----------------------------

            UpdatePhysics (dt);

            mLastSimulatedStepInterval = dt;
            mLastSimulatedStepInterval_Inv = dt == 0 ? 0 : 1.0 / dt;

            ++ mNumSimulatedSteps;
            mStepStage = 0;
            mLevelSimulatedTime += dt;

         //-----------------------------
         // ai update
         //-----------------------------

            mEntityList.UpdateEntities (dt);

            ParticleManager_Update (dt);

         //------------------------------------
         // handle key-hold eventgs
         //------------------------------------

            HandleKeyHoldEvents ();

         //-----------------------------
         // handle timer events
         //-----------------------------

            HandleTimerEvents ();

         //-----------------------------
         // on level updated
         //-----------------------------

            HandleEventById (CoreEventIds.ID_OnWorldAfterUpdated);

         //-----------------------------
         // update camera
         //-----------------------------

            UpdateCamera ();

         //-----------------------------
         // system dispatchs mouse, keyboard and other events
         //-----------------------------
         }
      }
      
      public function UpdateShapeContactStatusInfos ():void
      {
         UpdatePhysics (0.0);
      }

//=============================================================
//   paint
//=============================================================

      public function Repaint ():void
      {
         if (mBackgroundNeedRepaint)
         {
            mBackgroundNeedRepaint = false;
            RepaintViewSizeSprite (mBackgroundSprite, mBackgroundColor);
         }

         // mouse visibity

         if (mMouseVisible || mBackgroundSprite.mouseX < 0 || mBackgroundSprite.mouseY < 0 || mBackgroundSprite.mouseX > mRealViewportWidth || mBackgroundSprite.mouseY > mRealViewportHeight)
            Mouse.show ();
         else
            Mouse.hide ();

         // ...

         var next:Entity;
         var entity:Entity = mEntityToDelayUpdateAppearanceListHead;
         mEntityToDelayUpdateAppearanceListHead = null;

         while (entity != null)
         {
            next = entity.mNextEntityToDelayUpdateAppearance;

            entity.UpdateAppearance ();

            entity.mIsAlreadyInDelayUpdateAppearanceList = false;
            entity.mNextEntityToDelayUpdateAppearance = null;

            entity = next;
         }

         if (mCameraFadeMaskNeedRepaint)
         {
            mCameraFadeMaskNeedRepaint = false;
            RepaintViewSizeSprite (mFadeMaskSprite, mCameraFadeColor);
         }
      }

   //==================================
   // buffer entities to rebuild appearance
   //==================================

      private var mEntityToDelayUpdateAppearanceListHead:Entity = null;

      public function DelayUpdateEntityAppearance (entity:Entity):void
      {
         entity.mNextEntityToDelayUpdateAppearance = mEntityToDelayUpdateAppearanceListHead;
         mEntityToDelayUpdateAppearanceListHead = entity;
      }

   //===============================
   // layers
   //===============================

      private var mBackgroundLayer   :Sprite;
         private var mBackgroundSprite:Sprite;
      private var mContentLayer     :Sprite;
         private var mBorderLayer       :Sprite;
         private var mEntityLayer       :Sprite;
      private var mForegroundLayer   :Sprite;
         private var mFadeMaskSprite     :Sprite;

      private function CreateGraphicsLayers ():void
      {
         mBackgroundLayer    = new Sprite ();
            mBackgroundSprite = new Sprite ();
         mContentLayer    = new Sprite ();
            mBorderLayer        = new Sprite ();
            mEntityLayer        = new Sprite ();
         mForegroundLayer        = new Sprite ();
            mFadeMaskSprite        = new Sprite ();

         addChild (mBackgroundLayer);
         addChild (mContentLayer);
         addChild (mForegroundLayer);

         mBackgroundLayer.addChild (mBackgroundSprite);

         if (mIsBorderAtTopLayer)
         {
            mContentLayer.addChild (mEntityLayer);
            mContentLayer.addChild (mBorderLayer);
         }
         else
         {
            mContentLayer.addChild (mBorderLayer);
            mContentLayer.addChild (mEntityLayer);
         }

         mForegroundLayer.addChild (mFadeMaskSprite);
         mFadeMaskSprite.visible = false;

         // for show/hide mouse api

         mBackgroundSprite.addEventListener(Event.REMOVED_FROM_STAGE, OnBackgroundRemovedFromStage)
      }

      private function RepaintViewSizeSprite (sprite:Sprite, bgColor:uint):void
      {
         sprite.x = 0;
         sprite.y = 0;
         sprite.graphics.clear ();
         sprite.graphics.beginFill(bgColor);
         sprite.graphics.drawRect (0, 0, mRealViewportWidth, mRealViewportHeight); // at larget ennough one, the backgorynd sprite will be always put in screen center, and the scale will not chagned
         sprite.graphics.endFill ();
      }

      private var mMouseVisible:Boolean = true;
      public function SetMouseVisible (mouseVisible:Boolean):void
      {
         mMouseVisible = mouseVisible;
      }

      private function OnBackgroundRemovedFromStage (e:Event):void
      {
         Mouse.show ();
         mBackgroundSprite.removeEventListener(Event.REMOVED_FROM_STAGE, OnBackgroundRemovedFromStage)
      }

   //===============================
   // background
   //===============================

      private var mDrawBackground:Boolean = true; //
      private var mBackgroundColor:uint = 0xDDDDA0;

      private var mBackgroundNeedRepaint:Boolean = true;

      public function SetBackgroundColor (bgColor:uint):void
      {
         if (mBackgroundColor != bgColor)
         {
            mBackgroundColor = bgColor;

            mBackgroundNeedRepaint = true;
         }
      }

      public function GetBackgroundColor ():uint
      {
         return mBackgroundColor;
      }

      // this function
      public function IsContentLayerContains (displayObject:DisplayObject):Boolean
      {
         if (displayObject == null)
            return false;

         while (displayObject != null)
         {
            if (displayObject == mContentLayer)
               return true;

            displayObject = displayObject.parent;
         }

         return false;
      }

   //===============================
   // fade mask sprite
   //===============================

      private var mCameraFadeColor:uint = 0xFFFFFFFF;

      private var mCameraFadeMaskNeedRepaint:Boolean = true;

   //===============================
   // border
   //===============================

      private var mWorldBorderLeftThickness:Number = Define.WorldBorderThinknessLR;
      private var mWorldBorderTopThickness:Number = Define.WorldBorderThinknessTB;
      private var mWorldBorderRightThickness:Number = Define.WorldBorderThinknessLR;
      private var mWorldBorderBottomThickness:Number = Define.WorldBorderThinknessTB;

      private var mBorderBody:EntityBody;
      private var mBorderShapes:Array; // 4 border

      private function CreateBorders ():void
      {
         if (mBuildBorder)
         {
            mBorderBody = new EntityBody (this);
            RegisterEntity (mBorderBody);

            // order: top, bottom, left, right.
            // values: posX, posY, halfWidth, halfHeight
            var shape_info:Array = [
                           [mWorldBorderTopThickness    > 0.0, mWorldLeft + mWorldWidth * 0.5,                              mWorldTop + mWorldBorderTopThickness * 0.5,                   mWorldWidth * 0.5,                mWorldBorderTopThickness * 0.5   ],
                           [mWorldBorderBottomThickness > 0.0, mWorldLeft + mWorldWidth * 0.5,                              mWorldTop + mWorldHeight - mWorldBorderBottomThickness * 0.5, mWorldWidth * 0.5,                mWorldBorderBottomThickness * 0.5],
                           [mWorldBorderLeftThickness   > 0.0, mWorldLeft + mWorldBorderLeftThickness * 0.5,                mWorldTop + mWorldHeight * 0.5,                               mWorldBorderLeftThickness * 0.5,  mWorldHeight * 0.5               ],
                           [mWorldBorderRightThickness  > 0.0, mWorldLeft + mWorldWidth - mWorldBorderRightThickness * 0.5, mWorldTop + mWorldHeight * 0.5,                               mWorldBorderRightThickness * 0.5, mWorldHeight * 0.5               ],
                        ];

            mBorderShapes = new Array (4);

            for (var i:int = 0; i < 4; ++ i)
            {
               var info:Array = shape_info [i];

               if (info [0])
               {
                  var border:EntityShape_WorldBorder = new EntityShape_WorldBorder (this);
                  mBorderShapes [i] = border;

                  RegisterEntity (border);

                  border.InitCustomPropertyValues (); // fixed in v1.56

                  //RegisterEventHandlersForEntity (true, border); // move to World.Init () now

                  border.SetBody (mBorderBody);

                  border.SetPositionX  (mCoordinateSystem.D2P_PositionX (info [1]));
                  border.SetPositionY  (mCoordinateSystem.D2P_PositionY (info [2]));
                  border.SetHalfWidth  (mCoordinateSystem.D2P_Length (info [3]));
                  border.SetHalfHeight (mCoordinateSystem.D2P_Length (info [4]));
                  border.UpdatelLocalTransform ();

                  border.SetFilledColor (mBorderColor);
                  border.SetDrawBorder (false);
                  border.SetBorderThickness (0);
               }
            }
         }
      }

      private var mIsBorderAtTopLayer:Boolean = true;
      private var mBuildBorder:Boolean = false;
      private var mBorderColor:uint = Define.ColorStaticObject;

      private function IsBuildBorder ():Boolean
      {
         return mBuildBorder;
      }

      public function SetBorderColor (borderColor:uint):void
      {
         if (mBorderColor != borderColor)
         {
            mBorderColor = borderColor;

            if (mBorderShapes != null)
            {
               for (var i:int = 0; i < 4; ++ i)
               {
                  var border:EntityShape_WorldBorder = mBorderShapes [i];
                  border.SetFilledColor (mBorderColor);
               }
            }
         }
      }

      public function GetBorderColor ():uint
      {
         return mBorderColor;
      }

   //===============================
   // entity and border layers
   //===============================

      private var mDelayRemoveDisplayObjectFromContentLayer:Boolean = false;

      private var mDisplayObjectsDelayRemovedFromEntityLayer:Array = new Array ();
      private var mDisplayObjectsDelayRemovedFromBorderLayer:Array = new Array ();

      public function DelayRemoveDisplayObjectFromContentLayer ():void
      {
         mDelayRemoveDisplayObjectFromContentLayer = false;

         var i:int;
         var num:int;
         var displayObject:DisplayObject;

         num = mDisplayObjectsDelayRemovedFromEntityLayer.length;
         for (i = 0; i < num; ++ i)
         {
            displayObject = mDisplayObjectsDelayRemovedFromEntityLayer [i] as DisplayObject;
            if (displayObject.parent == mEntityLayer)
               mEntityLayer.removeChild (displayObject);
         }
         mDisplayObjectsDelayRemovedFromEntityLayer.splice (0, num);

         num = mDisplayObjectsDelayRemovedFromBorderLayer.length;
         for (i = 0; i < num; ++ i)
         {
            displayObject = mDisplayObjectsDelayRemovedFromBorderLayer [i] as DisplayObject;
            if (displayObject.parent == mBorderLayer)
               mBorderLayer.removeChild (displayObject);
         }
         mDisplayObjectsDelayRemovedFromBorderLayer.splice (0, num);
      }

      public function AddChildToEntityLayer (displayObject:DisplayObject):void
      {
         mEntityLayer.addChild (displayObject);
      }

      public function RemoveChildFromEntityLayer (displayObject:DisplayObject):void
      {
         if (mDelayRemoveDisplayObjectFromContentLayer)
         {
            mDisplayObjectsDelayRemovedFromEntityLayer.push (displayObject);
         }
         else
         {
            mEntityLayer.removeChild (displayObject);
         }
      }

      public function AddChildToBorderLayer (displayObject:DisplayObject):void
      {
         mBorderLayer.addChild (displayObject);
      }

      public function RemoveChildFromBorderLayer (displayObject:DisplayObject):void
      {
         if (mDelayRemoveDisplayObjectFromContentLayer)
         {
            mDisplayObjectsDelayRemovedFromBorderLayer.push (displayObject);
         }
         else
         {
            mBorderLayer.removeChild (displayObject);
         }
      }

//====================================================================================================
//   destroy
//====================================================================================================

      private var mDestroyed:Boolean = false;

      //
      public function Destroy ():void
      {
         mDestroyed = true;
      }

      public function IsDestroyed ():Boolean
      {
         return mDestroyed;
      }

      private var mDestroyedReally:Boolean = false;

      private function DestroyReally ():void
      {
         if (mDestroyedReally)
            return;

         // todo

         //
         if (mPhysicsEngine != null)
            mPhysicsEngine.Destroy ();

         //
         mDestroyedReally = true;
      }

//====================================================================================================
//   physics
//====================================================================================================

      // the 2 are both physics values
      private var mDefaultGravityAccelerationMagnitude:Number;
      private var mDefaultGravityAccelerationAngle:Number;
      private var mAutoSleepingEnabled:Boolean;
      
      private var mPhysicsSimulationEnabled:Boolean = true;
      private var mPhysicsSimulationStepTimeLength:Number = 1.0 / 30.0;
      private var mPhysicsSimulationQuality:int = 0x00000803; // constructor will call SetPhysicsSimulationIterations to override this
                        // low 8 bits for positionIterations
                        // next 8 bits for velocityIterations
                        // hight 16 bits are reserved.
      private var mCheckTimeOfImpact:Boolean = true;

      private var mCurrentGravityAccelerationX:Number;
      private var mCurrentGravityAccelerationY:Number;

      // particles use the last step gravity to ...
      private var mLastStepGravityAccelerationX:Number;
      private var mLastStepGravityAccelerationY:Number;

      public function GetPhysicsSimulationStepTimeLength ():Number
      {
         return mPhysicsSimulationStepTimeLength;
      }

      public function SetDefaultGravityAccelerationMagnitude (magnitude:Number):void
      {
         mDefaultGravityAccelerationMagnitude = magnitude;
      }

      public function GetDefaultGravityAccelerationMagnitude ():Number
      {
         return mDefaultGravityAccelerationMagnitude;
      }

      public function SetDefaultGravityAccelerationAngle (angle:Number):void
      {
         mDefaultGravityAccelerationAngle = angle;
      }

      public function GetDefaultGravityAccelerationAngle ():Number
      {
         return mDefaultGravityAccelerationAngle;
      }

      public function SetCurrentGravityAcceleration (gaX:Number, gaY:Number):void
      {
         mCurrentGravityAccelerationX = gaX;
         mCurrentGravityAccelerationY = gaY;
      }

      public function GetCurrentGravityAccelerationX ():Number
      {
         return mCurrentGravityAccelerationX;
      }

      public function GetCurrentGravityAccelerationY ():Number
      {
         return mCurrentGravityAccelerationY;
      }

      public function GetLastStepGravityAccelerationX ():Number
      {
         return mLastStepGravityAccelerationX;
      }

      public function GetLastStepGravityAccelerationY ():Number
      {
         return mLastStepGravityAccelerationY;
      }

   //===============================
   // global forces
   //===============================

      private var mGlobalForceX:Number;
      private var mGlobalForceY:Number;

      public function ClearGlobalForces ():void
      {
         mGlobalForceX = 0.0;
         mGlobalForceY = 0.0;
      }

      public function AddGlobalForce (fx:Number, fy:Number):void
      {
         mGlobalForceX += fx;
         mGlobalForceY += fy;
      }

   //===============================
   // create physics
   //===============================

      private var mPhysicsEngine:PhysicsEngine;

      public function GetPhysicsEngine ():PhysicsEngine
      {
         return mPhysicsEngine;
      }

      private function CreatePhysicsEngine ():void
      {
         ClearGlobalForces ();
         SetCurrentGravityAcceleration (mDefaultGravityAccelerationMagnitude * Math.cos (mDefaultGravityAccelerationAngle), mDefaultGravityAccelerationMagnitude * Math.sin (mDefaultGravityAccelerationAngle));

         mPhysicsEngine = new PhysicsEngine (mCoordinateSystem.GetScale (), mPhysicsSimulationEnabled, mCheckTimeOfImpact, mAutoSleepingEnabled);

         mPhysicsEngine.SetSimulationQuality (mPhysicsSimulationQuality);

         mPhysicsEngine.SetShapeCollideFilterFunctions (ShouldTwoShapeCollide);
         mPhysicsEngine.SetShapeContactEventHandlingFunctions (OnShapeContactStarted, OnShapeContactFinished);

         mLastStepGravityAccelerationX = mCurrentGravityAccelerationX;
         mLastStepGravityAccelerationY = mCurrentGravityAccelerationY;
         mPhysicsEngine.SetGravityByVector (mCurrentGravityAccelerationX, mCurrentGravityAccelerationY);
      }   

   //===============================
   // init physics
   //===============================

      private function InitPhysics ():void
      {
      // clear contact info

         mNumContactInfos = 0;
         mShapeContactInfoHashtable = new Dictionary ();
         mFirstShapeContactInfo = null;
         mShapeContactInfos_StepQueue = new Array ();

      // build physics
         BuildEntityPhysics (false);
     }

     public function BuildEntityPhysics (fromLastMarkedTail:Boolean):void
     {
      // build proxy shapes

         mEntityList.BuildShapePhysics (fromLastMarkedTail);

      // update body mass, coincide bodies with centroid

         mEntityListBody.OnBodyShapeListChanged (fromLastMarkedTail);
         mEntityListBody.AddShapeMomentums (fromLastMarkedTail);

      // build joints

         mEntityList.ConfirmConnectedShapes (fromLastMarkedTail);
         mEntityList.BuildJointPhysics (fromLastMarkedTail);

      // sycronize with physics, should before HandleShapeContactEvents

         SynchonizeWithPhysics (fromLastMarkedTail); // need it?

      // handle contact events. (disabled from v1.56. Two reasons: 1. it is useless in fact. 2. more reasonable)

         // HandleShapeContactEvents ()
      }

   //===============================
   // update physics
   //===============================

      private function UpdatePhysics (dt:Number):void
      {
         mLastStepGravityAccelerationX = mCurrentGravityAccelerationX + mGlobalForceX;
         mLastStepGravityAccelerationY = mCurrentGravityAccelerationY + mGlobalForceY;
         mPhysicsEngine.SetGravityByVector (mCurrentGravityAccelerationX + mGlobalForceX, mCurrentGravityAccelerationY + mGlobalForceY);
         ClearGlobalForces ();

         mPhysicsEngine.Update (dt);

      // sycronize with physics, should before HandleShapeContactEvents

         SynchonizeWithPhysics (false);

      // handle contact events

         HandleShapeContactEvents ();
      }

   //===============================
   // collision category
   //===============================

      private var mCollisionCategories:Array;
      private var mFriendGroups:Array;

      // all custom cateogories are shifted back by one
      // the first is the hidden category
      public function CreateCollisionCategories (collisionCategoryDefines:Array, collisionCategoryFriendLinkDefines:Array, isMerging:Boolean = false):void
      {
         var ccat:CollisionCategory;

         if (collisionCategoryDefines == null)
         {
            if (isMerging)
               return;
            
            mCollisionCategories = new Array (1);
         }
         else
         {
            var catArrayIndex:int;
            var baseIndex:int;
            if (isMerging)
            {
               baseIndex = mCollisionCategories.length;
               mCollisionCategories.length = baseIndex + collisionCategoryDefines.length; // for c/java, more need to do
               
               for (catArrayIndex = 0; catArrayIndex < baseIndex; ++ catArrayIndex)
               {
                  (mCollisionCategories [catArrayIndex] as CollisionCategory).SetTableLength (mCollisionCategories.length); // to enlarge
               }
            }
            else
            {
               baseIndex = 1;
               mCollisionCategories = new Array (1 + collisionCategoryDefines.length);
            }
            
            for (var catId:int = 0; catId < collisionCategoryDefines.length; ++ catId)
            {
               catArrayIndex = catId + baseIndex;

               ccat = new CollisionCategory ();
               ccat.mCategoryIndex = catId;
               ccat.mArrayIndex = catArrayIndex;
               ccat.SetTableLength (mCollisionCategories.length);
               mCollisionCategories [catArrayIndex] = ccat;

               BreakOrCreateCollisionCategoryFriendLink (ccat, ccat, (collisionCategoryDefines [catId]).mCollideInternally);
            }
         }

         // the hidden one
         if (! isMerging)
         {
            ccat = new CollisionCategory ();
            ccat.mCategoryIndex = -1;
            ccat.mArrayIndex = 0;
            ccat.SetTableLength (mCollisionCategories.length);
            mCollisionCategories [0] = ccat;
            BreakOrCreateCollisionCategoryFriendLink (ccat, ccat, true);
         }

         // friends
         if (collisionCategoryFriendLinkDefines != null)
         {
            var link_def:Object;
            for (var linkId:int = 0; linkId < collisionCategoryFriendLinkDefines.length; ++ linkId)
            {
               link_def =  collisionCategoryFriendLinkDefines [linkId];
               BreakOrCreateCollisionCategoryFriendLinkByIds (link_def.mCollisionCategory1Index, link_def.mCollisionCategory2Index, false);
            }
         }
      }

      public function BreakOrCreateCollisionCategoryFriendLinkByIds (category1Index:int, category2Index:int, isBreak:Boolean):void
      {
         ++ category1Index;
         if (category1Index < 0 || category1Index >= mCollisionCategories.length)
            return;

         ++ category2Index;
         if (category2Index < 0 || category2Index >= mCollisionCategories.length)
            return;

         var changed1:Boolean = (mCollisionCategories [category1Index] as CollisionCategory).mEnemyTable [category2Index] != isBreak;
         if (changed1)
            (mCollisionCategories [category1Index] as CollisionCategory).mEnemyTable [category2Index] = isBreak;

         var changed2:Boolean = false;
         if (category2Index != category1Index)
         {
            changed2 = (mCollisionCategories [category2Index] as CollisionCategory).mEnemyTable [category1Index] != isBreak;
            if (changed2)
               (mCollisionCategories [category2Index] as CollisionCategory).mEnemyTable [category1Index] = isBreak;
         }

         if (changed1 || changed2)
            mPhysicsEngine.FlagForFilteringForAllContacts ();
      }

      public function BreakOrCreateCollisionCategoryFriendLink (category1:CollisionCategory, category2:CollisionCategory, isBreak:Boolean):void
      {
         if (category1 == null || category2 == null)
            return;

         var category1Index:int = category1.mArrayIndex;
         var category2Index:int = category2.mArrayIndex;

         var changed1:Boolean = mCollisionCategories [category1Index].mEnemyTable [category2Index] != isBreak;
         if (changed1)
            mCollisionCategories [category1Index].mEnemyTable [category2Index] = isBreak;

         var changed2:Boolean = false;
         if (category2Index != category1Index)
         {
            changed2 = mCollisionCategories [category2Index].mEnemyTable [category1Index] != isBreak;
            if (changed2)
               mCollisionCategories [category2Index].mEnemyTable [category1Index] = isBreak;
         }

         if (changed1 || changed2)
            mPhysicsEngine.FlagForFilteringForAllContacts ();
      }
      
      public function GetNumCollisionCategories ():int
      {
         return mCollisionCategories.length;
      }

      public function GetCollisionCategoryById (ccatId:int):CollisionCategory
      {
         var ccatIndex:int = ccatId + 1
         if (ccatIndex < 0 || ccatIndex >= mCollisionCategories.length)
            return mCollisionCategories [0] // the hidden category
         else
            return mCollisionCategories [ccatIndex];
      }

      private function ShouldTwoShapeCollide (phyShape1:PhysicsProxyShape, phyShape2:PhysicsProxyShape):Boolean
      {
         var shape1:EntityShape = phyShape1.GetEntityShape ();
         var shape2:EntityShape = phyShape2.GetEntityShape ();

         if (shape1.mFriendGroupIndex >= 0 && shape1.mFriendGroupIndex == shape2.mFriendGroupIndex)
         {
            return false;
         }

         var ccat1:CollisionCategory = shape1.mCollisionCategory;
         var ccat2:CollisionCategory = shape2.mCollisionCategory;

         return ccat1.mEnemyTable [ccat2.mArrayIndex];
      }
   }
}
