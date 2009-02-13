package player.world {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.events.MouseEvent;
   
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
   import player.entity.EntityShapeText;
   import player.entity.EntityShapeGravityController;
   import player.entity.EntityJoint;
   import player.entity.EntityJointHinge;
   import player.entity.EntityJointSlider;
   import player.entity.EntityJointDistance;
   import player.entity.EntityJointSpring;
   
   import player.entity.EntityParticle;
   
   import common.Define;
   
   public class World extends Sprite
   {
      public static const WorldWidth:int = Define.WorldWidth; 
      public static const WorldHeight:int = Define.WorldHeight;
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
      
      public function World (version:int)
      {
         mVersion = version;
         
         // the aabb setting will affect some queries in box2d
         if (mVersion >= 0x101)
         {
            mPhysicsEngine = new PhysicsEngine (
                  new Point (0, Define.DefaultGravityAcceleration), 
                  new Point (-WorldWidth * 0.5, -WorldHeight * 0.5), 
                  new Point (WorldWidth * 1.5, WorldHeight * 1.5), 
                  false);
         }
         else
         {
            mPhysicsEngine = new PhysicsEngine (
                  new Point (0, Define.DefaultGravityAcceleration), 
                  new Point (-100000.0, -100000.0), 
                  new Point (100000.0, 100000.0), 
                  true);
         }
         
         mPhysicsEngine.SetJointRemovedListener (OnJointRemoved);
         mPhysicsEngine.SetShapeRemovedListener (OnShapeRemoved);
         mPhysicsEngine.SetShapeCollisionListener (OnShapeCollision);
         mPhysicsEngine.SetGetBodyIndexCallback (GetBodyIndex);
         mPhysicsEngine.SetGetShapeIndexCallback (GetShapeIndex);
         
      // 
         CreateDefaultCollisionCategory ();
         
         mParticleManager = new ParticleManager (this);
         
      // create borders
         
         CreateBackgroundAndBorders ();
         
      // 
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
      }
      
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
      
      public function GetPhysicsEngine ():PhysicsEngine
      {
         return mPhysicsEngine;
      }
      
      public function Destroy ():void
      {
      }
      
//=============================================================
//   
//=============================================================
      
      private function CreateBackgroundAndBorders ():void
      {
         var bgSprite:Sprite = new Sprite ();
         bgSprite.graphics.clear ();
         bgSprite.graphics.beginFill(0xDDDDA0);
         bgSprite.graphics.drawRect (0, 0, WorldWidth, WorldHeight);
         bgSprite.graphics.endFill ();
         addChild (bgSprite);
         
         
         var borderContainerParams:Object = new Object ();
         borderContainerParams.mContainsPhysicsShapes = true;
         borderContainerParams.mPosX = WorldWidth * 0.5;
         borderContainerParams.mPosY = WorldHeight * 0.5;
         
         var borderContainer:ShapeContainer = CreateShapeContainer (borderContainerParams, true);
         CreateBorder (borderContainer, WorldWidth * 0.5, WorldBorderThinknessTB * 0.5 - 0.5, WorldWidth, WorldBorderThinknessTB);
         CreateBorder (borderContainer, WorldWidth * 0.5, WorldHeight - WorldBorderThinknessTB * 0.5, WorldWidth, WorldBorderThinknessTB);
         CreateBorder (borderContainer, WorldBorderThinknessLR * 0.5 - 0.5, WorldHeight * 0.5, WorldBorderThinknessLR, WorldWidth);
         CreateBorder (borderContainer, WorldWidth - WorldBorderThinknessLR * 0.5, WorldHeight * 0.5, WorldBorderThinknessLR, WorldWidth);
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
         shapeParams.mAiType = Define.ShapeAiType_Static;
         shapeParams.mIsStatic = true;
         shapeParams.mIsVisible = true;
         shapeParams.mIsBullet = true;
         shapeParams.mDensity = 0;
         shapeParams.mFriction = 0.1;
         shapeParams.mRestitution = 0.2;
         
         SetCollisionCategoryParamsForShapeParams (shapeParams, Define.CollisionCategoryId_HiddenCategory);
         
         CreateEntityShapeRectangle (borderContainer, shapeParams);
      }
      
//=============================================================
//   collision category
//=============================================================
      
      public function CreateDefaultCollisionCategory ():void
      {
         if (mDefaultCollisionCategories == null)
         {
            mDefaultCollisionCategories = new Object ();
            
            mDefaultCollisionCategories.mMaskBits = 0xFFFF;
            mDefaultCollisionCategories.mCategoryBits = 0x1;
            mDefaultCollisionCategories.mGroupIndex = 0;
         }
      }
      
      public function GetDefaultCollisionCategory ():Object
      {
         return mDefaultCollisionCategories;
      }
      
      public function CreateCollisionCategory (ccDefine:Object):void
      {
         var numCategories:int = mCollisionCategories.length; // with out the default one
         if (numCategories >= Define.MaxCollisionCategoriesCount)
            return;
         
         var categoryIndex:int = numCategories + 1;
         
         var category:Object = new Object ();
         
         category.mMaskBits = 0xFFFF;
         category.mCategoryBits = 0x1 << categoryIndex;
         category.mGroupIndex = ccDefine.mCollideInternally ? categoryIndex : - categoryIndex;
         
         mCollisionCategories.push (category);
      }
      
      public function GetCollisioonCategory (index:int):Object
      {
         if (index < 0 || index >= mCollisionCategories.length)
            return mDefaultCollisionCategories;
         
         return mCollisionCategories [index];
      }
      
      public function CreateCollisionCategoryFriendLink (category1Index:int, category2Index:int):void
      {
         var category1:Object = GetCollisioonCategory (category1Index);
         var category2:Object = GetCollisioonCategory (category2Index);
         
         category1.mMaskBits &= ~category2.mCategoryBits;
         category2.mMaskBits &= ~category1.mCategoryBits;
      }
      
      public function SetCollisionCategoryParamsForShapeParams (shapeParams:Object, shapeCCid:int):void
      {
         var category:Object = GetCollisioonCategory (shapeCCid);
         
         shapeParams.mMaskBits = category.mMaskBits;
         shapeParams.mCategoryBits = category.mCategoryBits;
         shapeParams.mGroupIndex = category.mGroupIndex;
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
         SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var shapeCircle:EntityShapeCircle = new EntityShapeCircle (this, shapeContainer);
         shapeCircle.BuildFromParams (params);
         
         return shapeCircle;
      }
      
      public function CreateEntityShapeRectangle (shapeContainer:ShapeContainer, params:Object):EntityShapeRectangle
      {
         SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var shapeRect:EntityShapeRectangle = new EntityShapeRectangle (this, shapeContainer);
         shapeRect.BuildFromParams (params);
         
         return shapeRect;
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
      
      private function OnShapeCollision (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
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
      
      protected function OnMouseUp (event:MouseEvent):void
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
      }
      
      
      
   }
}
