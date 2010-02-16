package player.world {
   
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
   import flash.events.FocusEvent;
   
   import flash.utils.Dictionary;
   
   import player.physics.PhysicsEngine;
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   
   import player.design.Global;
   import player.design.Design;
   
   import player.entity.EntityBody;
   
   import player.entity.Entity;
   import player.entity.EntityVoid;
   
   import player.entity.EntityShape;
   import player.entity.EntityShapeCircle;
   import player.entity.EntityShapeRectangle;
   import player.entity.EntityShapePolygon;
   import player.entity.EntityShapePolyline;
   
   import player.entity.EntityShape_Text;
   import player.entity.EntityShape_GravityController;
   import player.entity.EntityShape_Camera;
   import player.entity.EntityShape_Particle;
   import player.entity.EntityShape_CircleBomb;
   import player.entity.EntityShape_RectangleBomb;
   
   import player.entity.EntityShape_WorldBorder;
   
   import player.entity.EntityJoint;
   import player.entity.EntityJointHinge;
   import player.entity.EntityJointSlider;
   import player.entity.EntityJointDistance;
   import player.entity.EntityJointSpring;
   
   import player.trigger.entity.ScriptHolder;
   import player.trigger.entity.EntityBasicCondition;
   import player.trigger.entity.EntityTask;
   import player.trigger.entity.EntityAction;
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.entity.EntityEventHandler_Timer;
   import player.trigger.entity.EntityEventHandler_Keyboard;
   import player.trigger.entity.EntityConditionDoor;
   import player.trigger.entity.EntityInputEntityAssigner;
   
   import player.trigger.IPropertyOwner;
   
   import player.trigger.data.ShapeContactInfo;
   import player.trigger.data.ListElement_EventHandler;
   
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Direct;
   
   import player.mode.Mode;
   import player.mode.ModeMoveWorldScene;
   
   import common.CoordinateSystem;
   
   import common.trigger.CoreEventIds;
   import common.trigger.IdPool;
   import common.trigger.ValueDefine;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.KeyCodes;
   
   public class World extends Sprite implements IPropertyOwner
   {
   // includes
      
      include "../trigger/CoreFunctionDefinitions_World.as";
      include "World_CameraAndView.as";
      include "World_SystemEventHandling.as";
      include "World_ParticleManager.as";
      include "World_ColorInfectionRelated.as";
      include "World_ContactEventHandling.as";
      include "World_KeyboardEventHandling.as";
      include "World_GeneralEventHandling.as";
      include "World_Misc.as";
      
   // 
      
      public static const DefaultWorldWidth :int = Define.DefaultWorldWidth; 
      public static const DefaultWorldHeight:int = Define.DefaultWorldHeight;
      public static const WorldBorderThinknessLR:int = Define.WorldBorderThinknessLR;
      public static const WorldBorderThinknessTB:int = Define.WorldBorderThinknessTB;
      
   // ...
      
      private var mVersion:int = 0x0;
      private var mAuthorName:String = "";
      private var mAuthorHonepage:String = "";
      private var mShareSourceCode:Boolean = false;
      private var mPermitPublishing:Boolean = false;
      
   // ...
      
      private var mNumEntitiesInEditor:int;
      private var mEntityArrayOrderByCreationId:Array;
      private var mEntityArrayOrderByAppearanceId:Array;
      
   // ...
      
      private var mCoordinateSystem:CoordinateSystem;
      
//==============================================================================
// construct
//==============================================================================
      
      public function World (worldDefine:Object)
      {
      // basic
         
         mVersion          = worldDefine.mVersion;
         mAuthorName       = worldDefine.mAuthorName;
         mAuthorHonepage   = worldDefine.mAuthorHomepage;
         mShareSourceCode  = worldDefine.mShareSourceCode;
         mPermitPublishing = worldDefine.mPermitPublishing;
         
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
         
      // ...
         
         mNumEntitiesInEditor = worldDefine.mEntityDefines.length;
         mEntityArrayOrderByCreationId   = new Array (mNumEntitiesInEditor);
         mEntityArrayOrderByAppearanceId = new Array (mNumEntitiesInEditor);
         
      // ...
         
         SetCiRulesEnabled (worldDefine.mSettings.mIsCiRulesEnabled);
         
      // ...
         
         mFunc_StepUpdate = Update_FixedStepInterval_SpeedX;
         
      // 
         
         ParticleManager_Initialize ();
         
      // ...
         var coordinates_scale:Number = worldDefine.mSettings.mCoordinatesScale;
         if (coordinates_scale <= 0)
            coordinates_scale = 1.0;
         mCoordinateSystem = new CoordinateSystem (worldDefine.mSettings.mCoordinatesOriginX, worldDefine.mSettings.mCoordinatesOriginY, coordinates_scale, worldDefine.mSettings.mRightHandCoordinates);
         
         mDefaultGravityAccelerationMagnitude = mCoordinateSystem.D2P_LinearAccelerationMagnitude (worldDefine.mSettings.mDefaultGravityAccelerationMagnitude);
         mDefaultGravityAccelerationAngle = mCoordinateSystem.D2P_RotationRadians (worldDefine.mSettings.mDefaultGravityAccelerationAngle * Define.kDegrees2Radians);
         
         CreatePhysicsEngine ();
         
         CreateCollisionCategories (worldDefine.mCollisionCategoryDefines, worldDefine.mCollisionCategoryFriendLinkDefines);
         
      // ...
         
         CreateGraphicsLayers ();
         
      // ...
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
//==============================================================================
// 
//==============================================================================
      
      public function GetVersion ():int
      {
         return mVersion;
      }
      
      public function GetAuthorName ():String
      {
         return mAuthorName;
      }
      
      public function GetAuthorHomepage ():String
      {
         return mAuthorHonepage;
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
      
      public function RegisterEntity (entity:Entity):void
      {
         if (entity is EntityBody)
         {
            mEntityListBody.AddEntity (entity);
         }
         else
         {
            mEntityList.AddEntity (entity);
            
            if (entity.IsDefinedInEditor ())
            {
               mEntityArrayOrderByCreationId   [entity.GetCreationId ()  ] = entity;
               mEntityArrayOrderByAppearanceId [entity.GetAppearanceId ()] = entity;
            }
         }
      }
      
      public function UnregisterEntity (entity:Entity):void
      {
         if (entity.mEntityList == null)
            return;
         
         entity.mEntityList.RemoveEntity (entity);
         
         // an entity defined in editor will never removed from the 2 arrays to make the reference in api callings always be accessable.
         if (! entity.IsDefinedInEditor ())
         {
            mEntityArrayOrderByCreationId   [entity.GetCreationId ()  ] = null;
            mEntityArrayOrderByAppearanceId [entity.GetAppearanceId ()] = null;
         }
      }
      
      public function GetNumEntitiesInEditor ():int
      {
         return mNumEntitiesInEditor;
      }
      
      public function GetEntityByCreationId (createId:int):Entity
      {
         if (createId >= 0)
         {
            return mEntityArrayOrderByCreationId [createId];
         }
         else
         {
            return null;
         }
      }
      
      public function GetEntityByAppearanceId (appearanceId:int):Entity
      {
         if (appearanceId >= 0)
         {
            return mEntityArrayOrderByAppearanceId [appearanceId];
         }
         else
         {
            return null;
         }
      }
      
//==============================================================================
//   some world data
//==============================================================================
      
      private var mNumSimulatedSteps:int = 0;
      
      public function GetSimulatedSteps ():int
      {
         return mNumSimulatedSteps;
      }
      
      private var mLevelSimulatedTime:Number = 0.0;
      
      public function GetLevelMilliseconds ():Number
      {
         return mLevelSimulatedTime * 1000.0;
      }
      
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
      
      private var mIsPaused:Boolean = false;
      
      public function SetPaused (paused:Boolean):void
      {
         mIsPaused = paused;
      }
      
//=============================================================
//   init
//=============================================================
      
      public function Initialize ():void
      {
         var entity:Entity;
         var tail:Entity;
         
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
         mLevelSimulatedTime = 0.0;
         
      //------------------------------------
      // on level to init
      //------------------------------------
         
         HandleEventById (CoreEventIds.ID_OnWorldBeforeInitializing);
         
      //------------------------------------
      // init camera
      //------------------------------------
         
         MoveCameraCenterTo_DisplayPoint (mCameraCenterX, mCameraCenterY);
         
      //------------------------------------
      // init physics
      //------------------------------------
         
         InitPhysics ();
         
         mNumSimulatedSteps = 0;
         
      //------------------------------------
      // ai init
      //------------------------------------
         
         mEntityList.InitEntities ();
         
      //-----------------------------
      // update camera
      //-----------------------------
         
         UpdateCamera ();
         
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
      // system dispatchs mouse, keyboard and other events
      //-----------------------------
         
         // ...
      }
      
//=============================================================
//   SynchonizeWithPhysics
//=============================================================
      
      private function SynchonizeWithPhysics ():void
      {
         mEntityListBody.SynchronizeEntitiesWithPhysicsProxies ();
         
         mEntityList.SynchronizeEntitiesWithPhysicsProxies ();
      }

//=============================================================
//   update
//=============================================================
      
      private var mFunc_StepUpdate:Function = null;
      
      public function Update (escapedTime:Number, speedX:int):void
      {
      //-----------------------------
      // remove the delay removeds
      //-----------------------------
         
         DelayRemoveDisplayObjectFromContentLayer ();
            
      //-----------------------------
      // update
      //-----------------------------
         
         if (mFunc_StepUpdate != null)
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
      // system dispatchs mouse, keyboard and other events
      //-----------------------------
         
         // ...
      }
      
      public function Update_FixedStepInterval_SpeedX (escapedTime1:Number, speedX:int):void
      {
         var entity:Entity;
         var tail:Entity;
         
      // ...
         
         var dt:Number = Define.WorldStepTimeInterval * 0.5;
         
         if (escapedTime1 == 0)
            dt = 0;
         
         var k:uint;
         var i:uint;
         var displayObject:Object;
         
         for (k = 0; k < speedX; ++ k)
         {
         //-----------------------------
         // on level to update
         //-----------------------------
            
            HandleEventById (CoreEventIds.ID_OnLWorldBeforeUpdating);
            
         //-----------------------------
         // update physics
         //-----------------------------
            
            UpdatePhysics (dt);
            
            mLastSimulatedStepInterval = dt;
            mLastSimulatedStepInterval_Inv = dt == 0 ? 0 : 1.0 / dt;
            
            ++ mNumSimulatedSteps;
            mLevelSimulatedTime += dt;
            
         //-----------------------------
         // ai update
         //-----------------------------
            
            mEntityList.UpdateEntities (dt);
            
            ParticleManager_Update (dt);
            
         //-----------------------------
         // update camera
         //-----------------------------
            
            UpdateCamera ();
            
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
         }
      }
      
//=============================================================
//   paint
//=============================================================

      public function Repaint ():void
      {
         if (mBackgroundNeedRepaint)
         {
            mBackgroundNeedRepaint = false;
            RepaintBackground ();
         }
         
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
            RepaintFadeMaskSprite ();
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

      private function RepaintBackground ():void
      {
         mBackgroundSprite.graphics.clear ();
         mBackgroundSprite.graphics.beginFill(mBackgroundColor);
         //mBackgroundSprite.graphics.drawRect (mWorldLeft, mWorldTop, mWorldWidth, mWorldHeight); // sometimes, it is too large to build
         mBackgroundSprite.graphics.drawRect (- 0.5 * Define.DefaultPlayerWidth, - 0.5 * Define.DefaultPlayerHeight, Define.DefaultPlayerWidth, Define.DefaultPlayerHeight); // at larget ennough one, the backgorynd sprite will be always put in screen center, and the scale will not chagned
         mBackgroundSprite.graphics.endFill ();
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

      private function RepaintFadeMaskSprite ():void
      {
         mFadeMaskSprite.graphics.clear ();
         mFadeMaskSprite.graphics.beginFill(mCameraFadeColor);
         mFadeMaskSprite.graphics.drawRect (- 0.5 * mViewportWidth, - 0.5 * mViewportHeight, mViewportWidth, mViewportHeight); // at larget ennough one, the mask sprite will be always put in screen center, and the scale will not chagned
         mFadeMaskSprite.graphics.endFill ();
      }

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
                  
                  border.SetBody (mBorderBody);
                  
                  border.SetPositionX  (mCoordinateSystem.D2P_PositionX (info [1]));
                  border.SetPositionY  (mCoordinateSystem.D2P_PositionY (info [2]));
                  border.SetHalfWidth  (mCoordinateSystem.D2P_Length (info [3]));
                  border.SetHalfHeight (mCoordinateSystem.D2P_Length (info [4]));
                  border.UpdatelLocalPosition ();
                  
                  border.SetFilledColor (mBorderColor);
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

      //
      public function Destroy ():void
      {
         // todo
         
         // 
         if (mPhysicsEngine != null)
            mPhysicsEngine.Destroy ();
      }
      
//====================================================================================================
//   physics 
//====================================================================================================

      // the 2 are both physics values
      private var mDefaultGravityAccelerationMagnitude:Number;
      private var mDefaultGravityAccelerationAngle:Number;
      
      private var mCurrentGravityAccelerationX:Number;
      private var mCurrentGravityAccelerationY:Number;
      
      // particles use the last step gravity to ...
      private var mLastStepGravityAccelerationX:Number;
      private var mLastStepGravityAccelerationY:Number;
      
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
         
         mPhysicsEngine = new PhysicsEngine ();
         
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
         
      // build proxy shapes
         
         mEntityList.BuildShapePhysics ();
         
      // update body mass, coincide bodies with centroid
         
         mEntityListBody.OnBodyPhysicsShapeListChanged ();
         mEntityListBody.AddShapeMomentums ();
         
      // build joints
         
         mEntityList.ConfirmConnectedShapes ();
         mEntityList.BuildJointPhysics ();
         
      // sycronize with physics, should before HandleShapeContactEvents
         
         SynchonizeWithPhysics (); // need it?
         
      // handle contact events
         
         HandleShapeContactEvents ();
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
         
         SynchonizeWithPhysics ();
         
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
      private function CreateCollisionCategories (collisionCategoryDefines:Array, collisionCategoryFriendLinkDefines:Array):void
      {
         var ccat:CollisionCategory;
         
         if (collisionCategoryDefines == null)
         {
            mCollisionCategories = new Array (1);
         }
         else
         {
            mCollisionCategories = new Array (1 + collisionCategoryDefines.length);
            var catId:int;
            var catArrayIndex:int;
            for (catArrayIndex = 1; catArrayIndex <= collisionCategoryDefines.length; ++ catArrayIndex)
            {
               catId = catArrayIndex - 1;
               ccat = new CollisionCategory ();
               ccat.mCategoryIndex = catId;
               ccat.mArrayIndex = catArrayIndex;
               ccat.SetTableLength (mCollisionCategories.length);
               mCollisionCategories [catArrayIndex] = ccat;
               
               BreakOrCreateCollisionCategoryFriendLink (ccat, ccat, (collisionCategoryDefines [catId]).mCollideInternally);
            }
         }
         
         // the hidden one
         ccat = new CollisionCategory ();
         ccat.mCategoryIndex = -1;
         ccat.mArrayIndex = 0;
         ccat.SetTableLength (mCollisionCategories.length);
         mCollisionCategories [0] = ccat;
         BreakOrCreateCollisionCategoryFriendLink (ccat, ccat, true);
         
         // friends
         if (collisionCategoryFriendLinkDefines != null)
         {
            var link_def:Object;
            for (var j:int = 0; j < collisionCategoryFriendLinkDefines.length; ++ j)
            {
               link_def =  collisionCategoryFriendLinkDefines [j];
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
      
      public function GetCollisionCategoryById (ccatId:int):CollisionCategory
      {
         ++ ccatId; // ccatIndex = ccatId + 1
         if (ccatId < 0 || ccatId >= mCollisionCategories.length)
            return mCollisionCategories [0] // the hidden category
         else
            return mCollisionCategories [ccatId];
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
      
//==========================================================
// temp. will removed from a later version
//==========================================================
      
      public function IsLevelSuccessed ():Boolean
      {
         return Global.GetCurrentDesign ().IsLevelSuccessed ();
      }
      
      public function IsLevelFailed ():Boolean
      {
         return Global.GetCurrentDesign ().IsLevelFailed ();
      }
      
      public function IsLevelUnfinished ():Boolean
      {
         return Global.GetCurrentDesign ().IsLevelUnfinished ();
      }
      
   }
}