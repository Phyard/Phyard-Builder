package player.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.utils.Dictionary;
   
   import player.physics.PhysicsEngine;
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   
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
   
   import player.trigger.entity.EntityBasicCondition;
   import player.trigger.entity.EntityTask;
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.entity.EntityConditionDoor;
   import player.trigger.entity.EntityInputEntityAssigner;
   
   import player.trigger.IPropertyOwner;
   
   import player.trigger.data.ShapeContactInfo;
   import player.trigger.data.ListElement_EventHandler;
   
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Direct;
   
   import player.mode.Mode;
   import player.mode.ModeMoveWorldScene;
   
   import common.trigger.CoreEventIds;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class World extends Sprite implements IPropertyOwner
   {
   // includes
      
      include "../trigger/CoreFunctionDefinitions_World.as";
      include "World_UnitScale.as";
      include "World_CameraAndView.as";
      include "World_SystemEventHandling.as";
      include "World_ParticleManager.as";
      include "World_ColorInfectionRules.as";
      include "World_ContactEventHandling.as";
      include "World_GeneralEventHandling.as";
      
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
         
         // these values are in pixel unit
         mWorldLeft = worldDefine.mSettings.mWorldLeft;
         mWorldTop = worldDefine.mSettings.mWorldTop;
         mWorldWidth = worldDefine.mSettings.mWorldWidth;
         mWorldHeight = worldDefine.mSettings.mWorldHeight;
         mCameraCenterX = worldDefine.mSettings.mCameraCenterX;
         mCameraCenterY = worldDefine.mSettings.mCameraCenterY;
         
         SetBackgroundColor (worldDefine.mSettings.mBackgroundColor);
         SetBuildBorder (worldDefine.mSettings.mBuildBorder);
         SetBorderColor (worldDefine.mSettings.mBorderColor);
         
      // ...
         
         mNumEntitiesInEditor = worldDefine.mEntityDefines.length;
         mEntityArrayOrderByCreationId   = new Array (mNumEntitiesInEditor);
         mEntityArrayOrderByAppearanceId = new Array (mNumEntitiesInEditor);
         
      // ...
         
         mFunc_StepUpdate = Update_FixedStepInterval_SpeedX;
         
      // 
         
         ParticleManager_Initialize ();
         
      // ...
         
         CreateCollisionCategories (worldDefine.mCollisionCategoryDefines, worldDefine.mCollisionCategoryFriendLinkDefines);
         
         mNormalGravityAccelerationMagnitude = Define.DefaultGravityAccelerationMagnitude;
         
         SetDisplay2PhysicsLengthScale (0.1);
         
         CreatePhysicsEngine ();
         
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
      
      public function RegisterEntity (entity:Entity):void
      {
      trace ("entity = " + entity + ", id= " + entity.GetCreationId ());
      
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
         
         if (entity.IsDefinedInEditor ())
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
      
//=============================================================
//   init
//=============================================================
      
      public function Initialize ():void
      {
         var entity:Entity;
         var tail:Entity;
         
      //------------------------------------
      // create display layers, borders
      //------------------------------------
         
         CreateBorders (); // now, the physics has not been built.
         
      //------------------------------------
      // go ...
      //------------------------------------
         
         mNumSimulatedSteps = 0;
         
      //------------------------------------
      // on level to init
      //------------------------------------
         
         HandleEvent (CoreEventIds.ID_OnLevelBeginInitialize);
         
      //------------------------------------
      // init physics
      //------------------------------------
         
         InitPhysics ();
         
      //------------------------------------
      // ai init
      //------------------------------------
         
         mEntityList.InitEntities ();
         
      //------------------------------------
      // on level inited
      //------------------------------------
         
         HandleEvent (CoreEventIds.ID_OnLevelEndInitialize);
         
      //------------------------------------
      // Repaint
      //------------------------------------
         
         Repaint ();
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
         if (mFunc_StepUpdate != null)
            mFunc_StepUpdate (escapedTime, speedX);
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
            ++ mNumSimulatedSteps;
            
         //-----------------------------
         // on level to update
         //-----------------------------
            
            HandleEvent (CoreEventIds.ID_OnLevelBeginUpdate);
            
         //-----------------------------
         // update physics
         //-----------------------------
            
            UpdatePhysics (dt);
            
         //-----------------------------
         // ai update
         //-----------------------------
            
            ClearReport ();
            
            mEntityList.UpdateEntities (dt);
            
            ParticleManager_Update (dt);
            
         //-----------------------------
         // on level updated
         //-----------------------------
            
            HandleEvent (CoreEventIds.ID_OnLevelEndUpdate);
         }
         
      //----------------------------------
      // Repaint
      //----------------------------------
         
         Repaint ();
      }
      
//=============================================================
//   paint
//=============================================================

      private function Repaint ():void
      {
         if (mBackgroundNeedRepaint)
         {
            RepaintBackground ();
            
            mBackgroundNeedRepaint = false;
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
      }

   //===============================
   // layers
   //===============================

      private var mBackgroundLayer   :Sprite;
      private var mBorderLayer       :Sprite;
      private var mEntityLayer       :Sprite;

      public function GetEntityLayer ():DisplayObjectContainer
      {
         return mEntityLayer;
      }

      public function GetBorderLayer ():DisplayObjectContainer
      {
         return mBorderLayer;
      }

      private function CreateGraphicsLayers ():void
      {
         mBackgroundLayer    = new Sprite ();
         mBorderLayer        = new Sprite ();
         mEntityLayer        = new Sprite ();
         
         addChild (mBackgroundLayer);
         if (mDrawBorderAboveEntities)
         {
            addChild (mEntityLayer);
            addChild (mBorderLayer);
         }
         else
         {
            addChild (mBorderLayer);
            addChild (mEntityLayer);
         }
      }

   //===============================
   // background
   //===============================

      private var mDrawBackground:Boolean = true;
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

      private var mBackgroundSprite:Sprite = null;
      
      private function RepaintBackground ():void
      {
         if (mBackgroundSprite == null)
         {
            mBackgroundSprite = new Sprite ();
            mBackgroundLayer.addChild (mBackgroundSprite);
         }
         
         mBackgroundSprite.graphics.clear ();
         mBackgroundSprite.graphics.beginFill(mBackgroundColor);
         mBackgroundSprite.graphics.drawRect (mWorldLeft, mWorldTop, mWorldWidth, mWorldHeight);
         mBackgroundSprite.graphics.endFill ();
      }

   //===============================
   // border
   //===============================

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
                           [mWorldLeft + mWorldWidth * 0.5,                          mWorldTop + WorldBorderThinknessTB * 0.5 - 0.5,          mWorldWidth * 0.5,            WorldBorderThinknessTB * 0.5],
                           [mWorldLeft + mWorldWidth * 0.5,                          mWorldTop + mWorldHeight - WorldBorderThinknessTB * 0.5, mWorldWidth * 0.5,            WorldBorderThinknessTB * 0.5],
                           [mWorldLeft + WorldBorderThinknessLR * 0.5 - 0.5,         mWorldTop + mWorldHeight * 0.5,                          WorldBorderThinknessLR * 0.5, mWorldHeight * 0.5          ],
                           [mWorldLeft + mWorldWidth - WorldBorderThinknessLR * 0.5, mWorldTop + mWorldHeight * 0.5,                          WorldBorderThinknessLR * 0.5, mWorldHeight * 0.5          ],
                        ];
            
            mBorderShapes = new Array (4);
            
            for (var i:int = 0; i < 4; ++ i)
            {
               var info:Array = shape_info [i];
               
               var border:EntityShape_WorldBorder = new EntityShape_WorldBorder (this);
               mBorderShapes [i] = border;
               
               RegisterEntity (border);
               
               border.SetBody (mBorderBody);
               
               border.SetPositionX  (DisplayX2PhysicsX (info [0]));
               border.SetPositionY  (DisplayY2PhysicsY (info [1]));
               border.SetHalfWidth  (DisplayLength2PhysicsLength (info [2]));
               border.SetHalfHeight (DisplayLength2PhysicsLength (info [3]));
               
               border.SetFilledColor (mBorderColor);
            }
         }
      }

      private var mDrawBorderAboveEntities:Boolean = true;
      private var mBuildBorder:Boolean = false;
      private var mBorderColor:uint = Define.ColorStaticObject;

      // cant change once set
      private function SetBuildBorder (buildBorder:Boolean):void
      {
         mBuildBorder = buildBorder;
      }

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

   //==================================
   // entities to rebuild appearance
   //==================================

      private var mEntityToDelayUpdateAppearanceListHead:Entity = null;

      public function DelayUpdateEntityAppearance (entity:Entity):void
      {
         entity.mNextEntityToDelayUpdateAppearance = mEntityToDelayUpdateAppearanceListHead;
         mEntityToDelayUpdateAppearanceListHead = entity;
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

   private var mNormalGravityAccelerationMagnitude:Number;
   
   public function GetNormalGravityAccelerationMagnitude ():Number
   {
      return mNormalGravityAccelerationMagnitude;
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
         mPhysicsEngine = new PhysicsEngine (new Point (0, mNormalGravityAccelerationMagnitude)); // temp, the initial gravity will be customed
         
         mPhysicsEngine.SetShapeCollideFilterFunctions (ShouldTwoShapeCollide);
         mPhysicsEngine.SetShapeContactEventHandlingFunctions (OnShapeContactStarted, OnShapeContactFinished);
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
         
         mEntityListBody.UpdateBodyPhysicsProperties ();
         mEntityListBody.CoincideBodiesWithCentroid ();
         
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
            for (var i:int = 1; i <= collisionCategoryDefines.length; ++ i)
            {
               catId = i - 1;
               ccat = new CollisionCategory ();
               ccat.mCategoryIndex = catId;
               ccat.mArrayIndex = i;
               ccat.SetTableLength (mCollisionCategories.length);
               mCollisionCategories [i] = ccat;
               
               if (! (collisionCategoryDefines [catId]).mCollideInternally)
               {
                  CreateCollisionCategoryFriendLink (catId, catId);
               }
            }
         }
         
         // the hidden one
         ccat = new CollisionCategory ();
         ccat.mCategoryIndex = -1;
         ccat.mArrayIndex = 0;
         ccat.SetTableLength (mCollisionCategories.length);
         mCollisionCategories [0] = ccat;
         
         // friends
         if (collisionCategoryFriendLinkDefines != null)
         {
            var link_def:Object;
            for (var j:int = 0; j < collisionCategoryFriendLinkDefines.length; ++ j)
            {
               link_def =  collisionCategoryFriendLinkDefines [j];
               CreateCollisionCategoryFriendLink (link_def.mCollisionCategory1Index, link_def.mCollisionCategory2Index);
            }
         }
      }
      
      public function CreateCollisionCategoryFriendLink (category1Index:int, category2Index:int):void
      {
         ++ category1Index;
         if (category1Index < 0 || category1Index >= mCollisionCategories.length)
            return;
         
         ++ category2Index;
         if (category2Index < 0 || category2Index >= mCollisionCategories.length)
            return;
         
         mCollisionCategories [category1Index].mEnemyTable [category2Index] = false;
         if (category2Index != category1Index)
            mCollisionCategories [category2Index].mEnemyTable [category1Index] = false;
      }
      
      public function BreakCollisionCategoryFriendLink (category1Index:int, category2Index:int):void
      {
         ++ category1Index;
         if (category1Index < 0 || category1Index >= mCollisionCategories.length)
            category1Index = 0;
         
         ++ category2Index;
         if (category2Index < 0 || category2Index >= mCollisionCategories.length)
            category2Index = 0;
         
         mCollisionCategories [category1Index].mEnemyTable [category2Index] = true;
         mCollisionCategories [category2Index].mEnemyTable [category1Index] = true;
      }
      
      public function GetCollisionCategory (ccatId:int):CollisionCategory
      {
         ++ ccatId;
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
         
         trace ("-------\nccat1 = " + ccat1.mCategoryIndex + ", mArrayIndex = " + ccat1.mArrayIndex);
         trace ("ccat2 = " + ccat2.mCategoryIndex + ", mArrayIndex = " + ccat2.mArrayIndex);
         trace ("ccat1.mEnemyTable [ccat2.mArrayIndex] = " + ccat1.mEnemyTable [ccat2.mArrayIndex]);
         
         return ccat1.mEnemyTable [ccat2.mArrayIndex];
      }
      
   }
}