package player.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import com.tapirgames.util.DisplayObjectUtil;
   
   import player.physics.PhysicsEngine;
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   
   import player.entity.Entity;
   import player.entity.EntityVoid;
   import player.entity.ShapeContainer;
   import player.entity.EntityShape;
   import player.entity.EntityShapeCircle;
   import player.entity.EntityShapeRectangle;
   import player.entity.EntityShapePolygon;
   import player.entity.EntityShapePolyline;
   import player.entity.EntityShapeText;
   import player.entity.EntityShapeGravityController;
   import player.entity.EntityJoint;
   import player.entity.EntityJointHinge;
   import player.entity.EntityJointSlider;
   import player.entity.EntityJointDistance;
   import player.entity.EntityJointSpring;
   import player.entity.EntityUtilityCamera;
   
   import player.entity.EntityParticle;
   
   import player.mode.Mode;
   import player.mode.ModeMoveWorldScene;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class World extends Sprite
   {
      public static const DefaultWorldWidth :int = Define.DefaultWorldWidth; 
      public static const DefaultWorldHeight:int = Define.DefaultWorldHeight;
      public static const WorldBorderThinknessLR:int = Define.WorldBorderThinknessLR;
      public static const WorldBorderThinknessTB:int = Define.WorldBorderThinknessTB;
      
      
   // ...
      public var mPhysicsEngine:PhysicsEngine; // used internally
      
      public var mParticleManager:ParticleManager;
      
   // ...
      //protected var mEditorEntityArray:Array = new Array ();
      
   // ...
      
      private var mVersion:int = 0x0;
      private var mAuthorName:String = "";
      private var mAuthorHonepage:String = "";
      private var mShareSourceCode:Boolean = false;
      private var mPermitPublishing:Boolean = false;
      
      private var mDefaultCollisionCategories:Object = null;
      private var mCollisionCategories:Array = new Array ();
      private var mNumCustomCollisionCategories:uint = 0;
      
      private var mWorldLeft:int = 0;
      private var mWorldTop:int = 0;
      private var mWorldWidth:int = Define.DefaultWorldWidth;
      private var mWorldHeight:int = Define.DefaultWorldHeight;
      
      private var mBackgroundColor:uint = 0xDDDDA0;
      private var mBuildBorder:Boolean = true;
      private var mBorderColor:uint = Define.ColorStaticObject;
      
      // the values for camera will not be scaled 
      private var mCameraWidth:Number = Define.DefaultWorldWidth;
      private var mCameraHeight:Number = Define.DefaultWorldHeight;
      private var mCameraCenterX:Number = Define.DefaultWorldWidth * 0.5;
      private var mCameraCenterY:Number = Define.DefaultWorldHeight * 0.5;
      
      private var mZoomScale:Number = 1.0;
      
      public function World (worldDefine:Object)
      {
      // basic
         mVersion = worldDefine.mVersion;
         
         SetAuthorName (worldDefine.mAuthorName);
         SetAuthorHomepage (worldDefine.mAuthorHomepage);
         
         //if (mVersion >= 0x0102)
         //{
            SetShareSourceCode (worldDefine.mShareSourceCode);
            SetPermitPublishing (worldDefine.mPermitPublishing);
         //}
         //else
         //{
         //   // default
         //}
         
      // settings
         //if (mVersion >= 0x0104)
         //{
            SetCameraCenterX (worldDefine.mSettings.mCameraCenterX);
            SetCameraCenterY (worldDefine.mSettings.mCameraCenterY);
            SetWorldLeft  (worldDefine.mSettings.mWorldLeft);
            SetWorldTop (worldDefine.mSettings.mWorldTop);
            SetWorldWidth  (worldDefine.mSettings.mWorldWidth);
            SetWorldHeight (worldDefine.mSettings.mWorldHeight);
            SetBackgroundColor (worldDefine.mSettings.mBackgroundColor);
            SetBuildBorder (worldDefine.mSettings.mBuildBorder);
            SetBorderColor (worldDefine.mSettings.mBorderColor);
         //}
         //else
         //{
         //   // default
         //}
         
         //from v0106
         var world_hints:Object = new Object ();
         world_hints.mPhysicsShapesPotentialMaxCount = ValueAdjuster.AdjustPhysicsShapesPotentialMaxCount (worldDefine.mSettings.mPhysicsShapesPotentialMaxCount);
         world_hints.mPhysicsShapesPopulationDensityLevel = ValueAdjuster.AdjustPhysicsShapesPopulationDensityLevel (worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel);
         
         
         
      // building
         
         // the aabb setting will affect some queries in box2d
         if (mVersion >= 0x104)
         {
            var marginX:int = mWorldWidth * 0.5;
            var marginY:int = mWorldHeight * 0.5;
            if (marginX > 1000)
               marginX = 1000;
            if (marginY > 1000)
               marginY = 1000;
            
            mPhysicsEngine = new PhysicsEngine (
                  new Point (0, Define.DefaultGravityAcceleration), 
                  new Point (mWorldLeft - marginX, mWorldTop - marginY), 
                  new Point (mWorldLeft + mWorldWidth + marginX, mWorldTop + mWorldHeight + marginY), 
                  worldDefine.mCollisionCategoryDefines.length + 1, 
                  false,
                  world_hints);
         }
         else if (mVersion >= 0x101)
         {
            mPhysicsEngine = new PhysicsEngine (
                  new Point (0, Define.DefaultGravityAcceleration), 
                  new Point (-DefaultWorldWidth * 0.5, -DefaultWorldHeight * 0.5), 
                  new Point (DefaultWorldWidth * 1.5, DefaultWorldHeight * 1.5), 
                  worldDefine.mCollisionCategoryDefines.length + 1, 
                  false,
                  world_hints);
         }
         else
         {
            mPhysicsEngine = new PhysicsEngine (
                  new Point (0, Define.DefaultGravityAcceleration), 
                  new Point (-100000.0, -100000.0), 
                  new Point (100000.0, 100000.0), 
                  0, 
                  true,
                  world_hints);
         }
         
         mPhysicsEngine.SetJointRemovedCallback (OnJointRemoved);
         mPhysicsEngine.SetShapeRemovedCallback (OnShapeRemoved);
         mPhysicsEngine.SetShapeContaceCallbacks (OnShapeContactStarted, OnShapeContactContinued, OnShapeContactFinished, OnShapeContactResult);
         mPhysicsEngine.SetGetBodyIndexCallback (GetBodyIndex);
         mPhysicsEngine.SetGetShapeIndexCallback (GetShapeIndex);
         
      // 
         
         mParticleManager = new ParticleManager (this);
         
      // create borders
         
         CreateBackgroundAndBorders ();
         
      //
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
//=============================================================
//    
//=============================================================
      
      public function GetVersion ():int
      {
         return mVersion;
      }
      
      public function SetAuthorName (name:String):void
      {
         mAuthorName = name;
      }
      
      public function SetAuthorHomepage (url:String):void
      {
         mAuthorHonepage = url;
      }
      
      public function GetAuthorName ():String
      {
         return mAuthorName;
      }
      
      public function GetAuthorHomepage ():String
      {
         return mAuthorHonepage;
      }
      
      public function SetShareSourceCode (share:Boolean):void
      {
         mShareSourceCode = share;
      }
      
      public function IsShareSourceCode ():Boolean
      {
         return mShareSourceCode;
      }
      
      public function SetPermitPublishing (permit:Boolean):void
      {
         mPermitPublishing = permit;
      }
      
      public function IsPermitPublishing ():Boolean
      {
         return mPermitPublishing;
      }
      
      public function SetWorldLeft (left:int):void
      {
         mWorldLeft = left;
      }
      
      public function GetWorldLeft ():int
      {
         return mWorldLeft;
      }
      
      public function SetWorldTop (top:int):void
      {
         mWorldTop = top;
      }
      
      public function GetWorldTop ():int
      {
         return mWorldTop;
      }
      
      public function SetWorldWidth (ww:int):void
      {
         mWorldWidth = ww;
      }
      
      public function GetWorldWidth ():int
      {
         return mWorldWidth;
      }
      
      public function SetWorldHeight (wh:int):void
      {
         mWorldHeight = wh;
      }
      
      public function GetWorldHeight ():int
      {
         return mWorldHeight;
      }
      
      public function SetCameraCenterX (centerX:Number):void
      {
         mCameraCenterX = centerX;
      }
      
      public function GetCameraCenterX ():Number
      {
         return mCameraCenterX;
      }
      
      public function SetCameraCenterY (centerY:Number):void
      {
         mCameraCenterY = centerY;
      }
      
      public function GetCameraCenterY ():Number
      {
         return mCameraCenterY;
      }
      
      public function SetCameraWidth (cw:Number):void
      {
         mCameraWidth = cw;
      }
      
      public function SetCameraHeight (ch:Number):void
      {
         mCameraHeight = ch;
      }
      
      public function SetBackgroundColor (bgColor:uint):void
      {
         mBackgroundColor = bgColor;
      }
      
      public function GetBackgroundColor ():uint
      {
         return mBackgroundColor;
      }
      
      public function SetBorderColor (bgColor:uint):void
      {
         mBorderColor = bgColor;
      }
      
      public function GetBorderColor ():uint
      {
         return mBorderColor;
      }
      
      public function SetBuildBorder (buildBorder:Boolean):void
      {
         mBuildBorder = buildBorder;
      }
      
      public function IsBuildBorder ():Boolean
      {
         return mBuildBorder;
      }
      
      public function GetZoomScale ():Number
      {
         return mZoomScale;
      }
      
      public function SetZoomScale (zoomScale:Number):void
      {
         var oldViewCenterX:Number = x + mCameraCenterX * scaleX;
         var oldViewCenterY:Number = y + mCameraCenterY * scaleY;
         
         mZoomScale = zoomScale;
         
         scaleX = zoomScale;
         scaleY = zoomScale;
         
         x = oldViewCenterX - mCameraCenterX * scaleX;
         y = oldViewCenterY - mCameraCenterY * scaleY;
         
         MoveWorldScene (0, 0);
      }
      
//=============================================================
//   
//=============================================================
      
      public function GetPhysicsEngine ():PhysicsEngine
      {
         return mPhysicsEngine;
      }
      
      public function Destroy ():void
      {
         if (mPhysicsEngine != null)
            mPhysicsEngine.Destroy ();
      }
      
//=============================================================
//   
//=============================================================
      
      private function CreateBackgroundAndBorders ():void
      {
         var bgSprite:Sprite = new Sprite ();
         bgSprite.graphics.clear ();
         bgSprite.graphics.beginFill(mBackgroundColor);
         bgSprite.graphics.drawRect (mWorldLeft, mWorldTop, mWorldWidth, mWorldHeight);
         bgSprite.graphics.endFill ();
         addChild (bgSprite);
         
         if (mBuildBorder)
         {
            var borderContainerParams:Object = new Object ();
            borderContainerParams.mContainsPhysicsShapes = true;
            borderContainerParams.mPosX = mWorldLeft + mWorldWidth * 0.5;
            borderContainerParams.mPosY = mWorldTop + mWorldHeight * 0.5;
            
            var borderContainer:ShapeContainer = CreateShapeContainer (borderContainerParams, true);
            CreateBorder (borderContainer, mWorldLeft + mWorldWidth * 0.5, mWorldTop + WorldBorderThinknessTB * 0.5 - 0.5, mWorldWidth, WorldBorderThinknessTB);
            CreateBorder (borderContainer, mWorldLeft + mWorldWidth * 0.5, mWorldTop + mWorldHeight - WorldBorderThinknessTB * 0.5, mWorldWidth, WorldBorderThinknessTB);
            CreateBorder (borderContainer, mWorldLeft + WorldBorderThinknessLR * 0.5 - 0.5, mWorldTop + mWorldHeight * 0.5, WorldBorderThinknessLR, mWorldHeight);
            CreateBorder (borderContainer, mWorldLeft + mWorldWidth - WorldBorderThinknessLR * 0.5, mWorldTop + mWorldHeight * 0.5, WorldBorderThinknessLR, mWorldHeight);
         }
      }
      
      private function CreateBorder (borderContainer:ShapeContainer, posX:Number, posY:Number, rectW:Number, rectH:Number):void
      {
         var shapeParams:Object = new Object ();
         shapeParams.mEntityType = Define.EntityType_ShapeRectangle;
         shapeParams.mHalfWidth = rectW * 0.5;
         shapeParams.mHalfHeight = rectH * 0.5;
         shapeParams.mPosX = posX;
         shapeParams.mPosY = posY;
         shapeParams.mRotation = 0;
         shapeParams.mAiType = Define.ShapeAiType_Unknown;
         shapeParams.mIsStatic = true;
         shapeParams.mIsVisible = true;
         shapeParams.mIsBullet = true;
         shapeParams.mDensity = 0;
         shapeParams.mFriction = 0.1;
         shapeParams.mRestitution = 0.2;
         
         shapeParams.mCollisionCategoryIndex = Define.CollisionCategoryId_HiddenCategory;
         
         shapeParams.mDrawBorder = false;
         shapeParams.mDrawBackground = true;
         
         shapeParams.mBorderColor = mBorderColor;
         shapeParams.mBorderThickness = 1;
         shapeParams.mBackgroundColor = mBorderColor;
         shapeParams.mTransparency = 100;
         
         shapeParams.mIsPhysicsEnabled = true;
         shapeParams.mIsSensor = false;
         shapeParams.mIsHollow = false;
         
         CreateEntityShapeRectangle (borderContainer, shapeParams);
      }
      
//=============================================================
//   collision category
//=============================================================
      
      public function CreateCollisionCategory (ccDefine:Object):void
      {
         mPhysicsEngine.CreateCollisionCategory (ccDefine);
      }
      
      public function CreateCollisionCategoryFriendLink (category1Index:int, category2Index:int):void
      {
         mPhysicsEngine.CreateCollisionCategoryFriendLink (category1Index, category2Index);
      }
      
//=============================================================
//   update
//=============================================================
      
      public function Update (escapedTime1:Number, speedX:int):void
      {
         //var dt:Number = escapedTime1 * 0.5;
         
         var dt:Number = Define.WorldStepTimeInterval * 0.5;
         
         if (mVersion >= 0x102)
         {
            if (escapedTime1 == 0)
               dt = 0;
         }
         
         var k:uint;
         var i:uint;
         var displayObject:Object;
         
         // from v1.03, to remove the randomness
         
         if (mVersion >= 0x103)
         {
            for (k = 0; k < speedX; ++ k)
            {
               mParticleManager.Update (dt);
               mPhysicsEngine.Update (dt);
               
               if (k == speedX - 1)
                  ClearReport ();
               
               for (i=0; i < numChildren; ++ i)
               {
                  displayObject = getChildAt (i);
                  if (displayObject is Entity)
                  {
                     (displayObject as Entity).Update (dt);
                  }
               }
            }
         }
         else
         {
            for (k = 0; k < speedX; ++ k)
            {
               mParticleManager.Update (dt);
               mPhysicsEngine.Update (dt);
            }
            
            dt *= speedX;
            
            ClearReport ();
            
            for (i=0; i < numChildren; ++ i)
            {
               displayObject = getChildAt (i);
               if (displayObject is Entity)
               {
                  (displayObject as Entity).Update (dt);
               }
            }
         }
      }
      
      private var mPuzzleSolved:Boolean = false;
      private var mNumToBeInfecteds:int = 0;
      private var mNumDontInfecteds:int = 0;
      private var mNumIntectedToBeInfecteds:int = 0;
      private var mNumInfectedDontInfects:int = 0;
      
      public function ClearReport ():void
      {
         mPuzzleSolved = true;
         
         mNumToBeInfecteds = 0;
         mNumDontInfecteds = 0;
         mNumIntectedToBeInfecteds = 0;
         mNumInfectedDontInfects = 0;
      }
      
      public function ReportShapeStatus (origionalShapeAiType:int, currentShapeAiType:int):void
      {
         if (origionalShapeAiType == Define.ShapeAiType_Uninfected)
         {
            mNumToBeInfecteds ++ ;
            
            if (currentShapeAiType == Define.ShapeAiType_Infected)
            {
               mNumIntectedToBeInfecteds ++;
            }
         }
         
         if (origionalShapeAiType == Define.ShapeAiType_DontInfect)
         {
            mNumDontInfecteds ++;
            
            if (currentShapeAiType == Define.ShapeAiType_Infected)
            {
               mNumInfectedDontInfects ++;
            }
         }
         
         mPuzzleSolved = mNumToBeInfecteds != 0 && (mNumIntectedToBeInfecteds == mNumToBeInfecteds) && (mNumInfectedDontInfects == 0);
      }
      
      public function IsPuzzleSolved ():Boolean
      {
         return mPuzzleSolved;
      }
      
//=============================================================
//   editor entities
//=============================================================
      
      //public function RegisterEditorEntity (index:int, entity:Entity):void
      //{
      //   mEditorEntityArray [index] = entity;
      //}
      
//=============================================================
//   shape container
//=============================================================
      
      
      public function CreateShapeContainer (params:Object, containsPhyShapes:Boolean, static:Boolean = true):ShapeContainer
      {
         var shapeContainer:ShapeContainer = new ShapeContainer (this);
         if (containsPhyShapes)
         {
            params.mIsStatic = true; // temp
            shapeContainer.BuildFromParams (params);
         }
         
         addChild (shapeContainer);
            
         return shapeContainer;
      }
      
      public function UpdateShapeMasses ():void
      {
         for (var i:uint=0; i < numChildren; ++ i)
         {
            var displayBoject:Object = getChildAt (i);
            if (displayBoject is ShapeContainer)
            {
               (displayBoject as ShapeContainer).UpdateMass ();
            }
         }
      }
      
      // call this function before any joint is created
      public function UpdateShapeLayers ():void
      {
         var containerParams:Array = new Array ();
         var i:int;
         for (i = 0; i < numChildren; ++ i)
         {
            var child:Object = getChildAt (i);
            if (child is ShapeContainer)
            {
               var container:ShapeContainer = child as ShapeContainer;
               var maxEntityId:int = container.GetMaxChildEntityId ();
               
               var params:Object = new Object ();
               params.mLayerIndex = maxEntityId;
               params.mShapeContainer = container;
               
               containerParams.push (params);
            }
         }
         
         if (containerParams.length < 2)
            return;
         
         for (i = 0; i < containerParams.length; ++ i)
         {
            removeChild (containerParams[i].mShapeContainer);
         }
         
         containerParams.sortOn("mLayerIndex", Array.NUMERIC);
         
         for (i = 0; i < containerParams.length; ++ i)
         {
            addChild (containerParams[i].mShapeContainer);
         }
      }
      
//=============================================================
//   shapes & joints
//=============================================================
      
      private var mWorldEntities:Array = new Array ();
      
      public function CreateVoidEntity ():EntityVoid
      {
         var voidEntity:EntityVoid = new EntityVoid (this);
         
         //mEditorEntityArray.push (voidEntity);
         
         return voidEntity;
      }
      
      public function CreateEntityShapeCircle (shapeContainer:ShapeContainer, params:Object):EntityShapeCircle
      {
         //SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var shapeCircle:EntityShapeCircle = new EntityShapeCircle (this, shapeContainer);
         shapeCircle.BuildFromParams (params);
         
         return shapeCircle;
      }
      
      public function CreateEntityShapeRectangle (shapeContainer:ShapeContainer, params:Object):EntityShapeRectangle
      {
         //SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var shapeRect:EntityShapeRectangle = new EntityShapeRectangle (this, shapeContainer);
         shapeRect.BuildFromParams (params);
         
         return shapeRect;
      }
      
      public function CreateEntityShapePolygon (shapeContainer:ShapeContainer, params:Object):EntityShapePolygon
      {
         //SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var shapePolygon:EntityShapePolygon = new EntityShapePolygon (this, shapeContainer);
         shapePolygon.BuildFromParams (params);
         
         return shapePolygon;
      }
      
      public function CreateEntityShapePolyline (shapeContainer:ShapeContainer, params:Object):EntityShapePolyline
      {
         //SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var shapePolyline:EntityShapePolyline = new EntityShapePolyline (this, shapeContainer);
         shapePolyline.BuildFromParams (params);
         
         return shapePolyline;
      }
      
      public function CreateEntityShapeText (shapeContainer:ShapeContainer, params:Object):EntityShapeText
      {
         var shapeText:EntityShapeText = new EntityShapeText (this, shapeContainer);
         shapeText.BuildFromParams (params);
         
         return shapeText;
      }
      
      public function CreateEntityShapeGravityController (shapeContainer:ShapeContainer, params:Object):EntityShapeGravityController
      {
         var gController:EntityShapeGravityController = new EntityShapeGravityController(this, shapeContainer);
         gController.BuildFromParams (params);
         
         return gController;
      }
      
      public function CreateEntityJointHinge (params:Object):EntityJointHinge
      {
         var jointHinge:EntityJointHinge = new EntityJointHinge (this);
         jointHinge.BuildFromParams (params);
         
         var index:int = jointHinge.GetRecommendedChildIndex ();
         
         if (index < 0)
            addChild (jointHinge);
         else
            addChildAt (jointHinge, index + 1);
         
         return jointHinge;
      }
      
      public function CreateEntityJointSlider (params:Object):EntityJointSlider
      {
         var jointSlider:EntityJointSlider = new EntityJointSlider (this);
         jointSlider.BuildFromParams (params);
         
         var index:int = jointSlider.GetRecommendedChildIndex ();
         
         if (index < 0)
            addChild (jointSlider);
         else
            addChildAt (jointSlider, index + 1);
         
         return jointSlider;
      }
      
      public function CreateEntityJointDistance (params:Object):EntityJointDistance
      {
         var jointDistance:EntityJointDistance = new EntityJointDistance (this);
         jointDistance.BuildFromParams (params);
         
         var index:int = jointDistance.GetRecommendedChildIndex ();
         
         if (index < 0)
            addChild (jointDistance);
         else
            addChildAt (jointDistance, index + 1);
         
         return jointDistance;
      }
      
      public function CreateEntityJointSpring (params:Object):EntityJointSpring
      {
         var jointSpring:EntityJointSpring = new EntityJointSpring (this);
         jointSpring.BuildFromParams (params);
         
         var index:int = jointSpring.GetRecommendedChildIndex ();
         
         if (index < 0)
            addChild (jointSpring);
         else
            addChildAt (jointSpring, index + 1);
         
         return jointSpring;
      }
      
      public function CreateUtilityCamera (shapeContainer:ShapeContainer, params:Object):EntityUtilityCamera
      {
         var utilityCamera:EntityUtilityCamera = new EntityUtilityCamera (this, shapeContainer);
         utilityCamera.BuildFromParams (params);
         
         return utilityCamera;
      }
      
//=============================================================
//   dynamic creating
//=============================================================
      
      public function CreateEntityParticle (params:Object):EntityParticle
      {
         params.mIsStatic = false;
         
         var particle:EntityParticle = new EntityParticle (this);
         particle.BuildFromParams (params);
         
         addChild (particle);
         
         return particle;
      }
      
      
      
//=============================================================
//   PhysicsEngine callbacks 
//=============================================================
      
      private function GetBodyIndex (proxyBody:PhysicsProxyBody):int
      {
         if (proxyBody == null)
            return -1;
            
         var container:ShapeContainer = proxyBody.GetUserData () as ShapeContainer;
         if (container == null || ! contains (container) )
            return -1;
         
         return getChildIndex (container);
      }
      
      private function GetShapeIndex (proxyShape:PhysicsProxyShape):int
      {
         if (proxyShape == null)
            return -1;
            
         var shape:EntityShape = proxyShape.GetUserData () as EntityShape;
         if (shape == null)
            return -1;
         
         return shape.GetEntityId ();
      }
      
      private function OnJointRemoved (proxyJoint:PhysicsProxyJoint):void
      {
         var joint:EntityJoint = proxyJoint.GetUserData () as EntityJoint;
         
         removeChild (joint);
         
         // !!! b2Joint has already been destroyed before entering this function
         //joint.Destroy ();
      }
      
      private function OnShapeRemoved (proxyShape:PhysicsProxyShape):void
      {
      }
      
      private function OnShapeContactStarted (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         InfectShapes (proxyShape1, proxyShape2);
         
         RegisterFieldShape (proxyShape1, proxyShape2);
      }
      
      private function OnShapeContactContinued (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         InfectShapes (proxyShape1, proxyShape2);
      }
      
      private function OnShapeContactFinished (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         UnregisterFieldShape (proxyShape1, proxyShape2);
      }
      
      private function OnShapeContactResult (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
      }
      
  //--------------------
      
      private function RegisterFieldShape (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         //var shape1:EntityShape = proxyShape1.GetUserData () as EntityShape;
         //var shape2:EntityShape = proxyShape2.GetUserData () as EntityShape;
         //
         //var isField1:Boolean = shape1.IsField ();
         //var isField2:Boolean = shape2.IsField ();
         //
         //if (isField1 && ! isField2)
         //{
         //   shape1.RegisterInFieldShape (shape2)
         //}
         //
         //if (isField2 && ! isField1)
         //{
         //   shape2.RegisterInFieldShape (shape1)
         //}
      }
      
      private function UnregisterFieldShape (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         //var shape1:EntityShape = proxyShape1.GetUserData () as EntityShape;
         //var shape2:EntityShape = proxyShape2.GetUserData () as EntityShape;
         //
         //var isField1:Boolean = shape1.IsField ();
         //var isField2:Boolean = shape2.IsField ();
         //
         //if (isField1 && ! isField2)
         //{
         //   shape1.UnregisterInFieldShape (shape2)
         //}
         //
         //if (isField2 && ! isField1)
         //{
         //   shape2.UnregisterInFieldShape (shape1)
         //}
      }
      
      private function InfectShapes (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         var shape1:EntityShape = proxyShape1.GetUserData () as EntityShape;
         var shape2:EntityShape = proxyShape2.GetUserData () as EntityShape;
         
         var infectable1:Boolean = Define.IsInfectableShape (shape1.GetShapeAiType ());
         var infectable2:Boolean = Define.IsInfectableShape (shape2.GetShapeAiType ());
         
         var infected1:Boolean = Define.IsInfectedShape (shape1.GetShapeAiType ());
         var infected2:Boolean = Define.IsInfectedShape (shape2.GetShapeAiType ());
         
         if (infected1 && ! infected2 && infectable2)
         {
            shape2.SetShapeAiType (Define.ShapeAiType_Infected);
            shape2.RebuildAppearance ();
         }
         
         if (infected2 && ! infected1 && infectable1)
         {
            shape1.SetShapeAiType (Define.ShapeAiType_Infected);
            shape1.RebuildAppearance ();
         }
      }
      
      protected function RemoveBombsAndRemovableShapes (event:MouseEvent):Boolean
      {
         var levelPoint:Point = globalToLocal (new Point (event.stageX, event.stageY));
         
         var shapeArray:Array = mPhysicsEngine.GetProxyShapesAtPoint (levelPoint.x, levelPoint.y);
         
         var shapeId:int;
         var shape:EntityShape;
         var container:ShapeContainer;
         
         var breakableShapes:Array = new Array ();
         
         var bombDefines:Array = new Array ();
         
         for (shapeId = 0; shapeId < shapeArray.length; ++ shapeId)
         {
            shape = (shapeArray [shapeId] as PhysicsProxyShape).GetUserData () as EntityShape;
            
            if ( Define.IsBreakableShape (shape.GetShapeAiType ()) )
            {
               // all breakable shapes in teh container will be removed
               
               container = shape.GetParentContainer ();
               
               for (var i:int = 0; i < container.numChildren; ++ i)
               {
                  var child:EntityShape = container.getChildAt (i) as EntityShape;
                  if ( child != null && Define.IsBreakableShape (child.GetShapeAiType ()) )
                  {
                     if ( breakableShapes.indexOf (child) < 0 )
                        breakableShapes.push (child);
                  }
               }
            }
            
            if ( Define.IsBombShape (shape.GetShapeAiType ()) )
            {
               if ( breakableShapes.indexOf (shape) < 0 )
               {
                  breakableShapes.push (shape);
                  
                  // bomb params
                  
                  container = shape.GetParentContainer ();
                  
                  var bombDefine:Object = new Object ();
                  bombDefines.push (bombDefine);
                  
                  //var bombPos:Point = container.GetPosition ().add (shape.GetLocalPosition ());
                  var bombPos:Point = DisplayObjectUtil.LocalToLocal (container, this, shape.GetLocalPosition ());
                  var bombSize:Number = Define.DefaultBombSquareSideLength;
                  
                  if (shape is EntityShapeCircle)
                  {
                     bombSize = (shape as EntityShapeCircle).GetRadius () * 2.0;
                  }
                  else if (shape is EntityShapeRectangle)
                  {
                     bombSize = (shape as EntityShapeRectangle).GetWidth ();
                     if (bombSize > (shape as EntityShapeRectangle).GetHeight ())
                        bombSize = (shape as EntityShapeRectangle).GetHeight ();
                  }
                  
                  bombDefine.mPosX = bombPos.x;
                  bombDefine.mPosY = bombPos.y;
                  bombDefine.mRadius = bombSize * 0.5;
               }
            }
         }
         
         var hasEntityBeenRemoved:Boolean = (breakableShapes.length > 0);
         
         while (breakableShapes.length > 0)
         {
            shape = breakableShapes[0] as EntityShape;
            container = shape.GetParentContainer ();
            
            container.removeChild (shape);
            shape.Destroy ();
            
            breakableShapes.splice (0, 1);
            
            if (container.numChildren == 0)
            {
               container.Destroy ();
            }
            else if (! container.ContainsPhysicsEntities ())
            {
               container.DestroyPhysicsProxy ();
            }
         }
         
         for (var bombId:int = 0; bombId < bombDefines.length; ++ bombId)
         {
            bombDefine = bombDefines [bombId];
            
            mParticleManager.AddBomb (bombDefine.mPosX,
                                      bombDefine.mPosY,
                                      bombDefine.mRadius
                                      );
         }
         
         return hasEntityBeenRemoved;
      }
      
//=============================================================
//   
//=============================================================
      
      public function MoveWorldSceneTo (wx:Number, wy:Number):void
      {
         MoveWorldScene (mCameraCenterX - wx, mCameraCenterY - wy);
      }
      
      public function MoveWorldScene (dx:Number, dy:Number):void
      {
         // assume no scales and rotation for world
         
         var leftInView:Number;
         var topInView:Number;
         
         var worldViewWidth :Number = mWorldWidth  * scaleX;
         var worldViewHeight:Number = mWorldHeight * scaleY;
         
         if (worldViewWidth < mCameraWidth)
         {
            mCameraCenterX = mWorldLeft + mWorldWidth * 0.5;
            leftInView = (mWorldLeft - mCameraCenterX) * scaleX + mCameraWidth * 0.5;
         }
         else
         {
            mCameraCenterX -= dx;
            leftInView =(mWorldLeft - mCameraCenterX) * scaleX + mCameraWidth * 0.5;
            
            if (leftInView > 0)
               leftInView = 0;
            if (leftInView + worldViewWidth < mCameraWidth)
               leftInView = mCameraWidth - worldViewWidth;
            
            mCameraCenterX = mWorldLeft + (mCameraWidth * 0.5 - leftInView) / scaleX;
         }
         
         if (worldViewHeight < mCameraHeight)
         {
            mCameraCenterY = mWorldTop + mWorldHeight * 0.5;
            topInView = (mWorldTop - mCameraCenterY) * scaleY + mCameraHeight * 0.5;
         }
         else
         {
            mCameraCenterY -= dy;
            topInView = (mWorldTop - mCameraCenterY) * scaleY + mCameraHeight * 0.5;
            
            if (topInView > 0)
               topInView = 0;
            if (topInView + worldViewHeight < mCameraHeight)
               topInView = mCameraHeight - worldViewHeight;
            
            mCameraCenterY = mWorldTop + (mCameraHeight * 0.5 - topInView) / scaleY;
         }
         
         x = leftInView - mWorldLeft * scaleX;
         y = topInView  - mWorldTop  * scaleY;
      }
      
//=============================================================
//   
//=============================================================
      
      private var mCurrentMode:Mode = null;
      
      public function SetCurrentMode (mode:Mode):void
      {
         if (mCurrentMode != null)
            mCurrentMode.Destroy ();
         
         mCurrentMode = mode;
         
         if (mCurrentMode != null)
            mCurrentMode.Initialize ();
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         // ...
         //stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
         
         //
         MoveWorldScene (0, 0);
      }
      
      private function OnRemovedFromStage (event:Event):void 
      {
         // must remove this listeners, to avoid memory leak
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         
         removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         removeEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         removeEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         //stage.removeEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      }
      
      public function OnMouseDown (event:MouseEvent):void
      {
         //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
         //   return;
         
         SetCurrentMode (new ModeMoveWorldScene (this));
         
         if (mCurrentMode != null)
            mCurrentMode.OnMouseDown (event.stageX, event.stageY);
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
         //   return;
         
         if (mCurrentMode != null)
            mCurrentMode.OnMouseMove (event.stageX, event.stageY, event.buttonDown);
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
         //   return;
         
         if (mCurrentMode != null)
            mCurrentMode.OnMouseUp (event.stageX, event.stageY);
         
         RemoveBombsAndRemovableShapes (event);
      }
      
      public function OnMouseOut (event:MouseEvent):void
      {
         //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
         //   return;
         
         var point:Point = new Point (event.stageX, event.stageY);
         var rect:Rectangle = new Rectangle (0, 0, stage.stageWidth, stage.stageHeight);
         
         //trace ("point = " + point);
         
         var isOut:Boolean = ! rect.containsPoint (point);
         
         if ( ! isOut )
            return;
         
         SetCurrentMode (null);
      }
      
      public function OnMouseWheel (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
      }
   }
}
