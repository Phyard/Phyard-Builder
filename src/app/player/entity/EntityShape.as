package player.entity {
   
   import flash.geom.Point;
   import flash.display.Sprite;
   
   import flash.events.MouseEvent;
   
   import player.world.World;
   import player.world.CollisionCategory;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   // The shape class includes many types. Generally, if a entity has position and rotation and can be glued with other entities, then the entity can be viewed as a shape.
   // Yes, certainly, for many special shapes, many memeber properties are meaningless.
   
   public class EntityShape extends Entity
   {
      include "EntityShape_APIs.as";
      
//=============================================================
//   
//=============================================================
      
      
      public function EntityShape (world:World)
      {
         super (world);
         
         SetBorderThickness (mWorld.DisplayLength2PhysicsLength (1.0));
         
         SetCollisionCategoryById (Define.CollisionCategoryId_HiddenCategory); // default
         
         mPhysicsShapePotentially = false; // to override
         
         mWorld.GetEntityLayer ().addChild (mAppearanceObjectsContainer);
         
         mWorld.RegisterShapeAiType (mOriginalAiType, mAiType);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            // > from 1.02
            var catId:int;
            if (entityDefine.mCollisionCategoryIndex != undefined)
               catId = entityDefine.mCollisionCategoryIndex;
            else
               catId = Define.CollisionCategoryId_HiddenCategory;
            
            SetCollisionCategoryById (catId);
            //<<
            
            //>>from v1.07
            if (entityDefine.mFriendGroupIndex != undefined)
               mFriendGroupIndex = entityDefine.mFriendGroupIndex;
            //<<
            
            if (entityDefine.mAiType != undefined)
            {
               SetOriginalShapeAiType (entityDefine.mAiType);
               SetShapeAiType (entityDefine.mAiType);
            }
            
            if (entityDefine.mIsPhysicsEnabled != undefined)
               SetPhysicsEnabled (entityDefine.mIsPhysicsEnabled);
            
            if (entityDefine.mDensity != undefined)
               SetDensity (entityDefine.mDensity);
            if (entityDefine.mFriction != undefined)
               SetFriction (entityDefine.mFriction);
            if (entityDefine.mRestitution != undefined)
               SetRestitution (entityDefine.mRestitution);
            
            if (entityDefine.mIsStatic != undefined)
               SetStatic (entityDefine.mIsStatic);
            if (entityDefine.mIsBullet != undefined)
               SetAsBullet (entityDefine.mIsBullet);
            
            // >> from v1.02
            if (entityDefine.mDrawBorder != undefined)
               SetDrawBorder (entityDefine.mDrawBorder);
            if (entityDefine.mDrawBackground != undefined)
               SetDrawBackground (entityDefine.mDrawBackground);
            
            if (entityDefine.mIsSensor != undefined)
               SetAsSensor (entityDefine.mIsSensor);
            //<<
            
            // >> from v1.04
            if (entityDefine.mBorderColor != undefined)
               SetBorderColor ( entityDefine.mBorderColor);
            if (entityDefine.mBorderThickness != undefined)
               SetBorderThickness (mWorld.DisplayLength2PhysicsLength (entityDefine.mBorderThickness));
            if (entityDefine.mBackgroundColor != undefined)
               SetFilledColor (entityDefine.mBackgroundColor);
            if (entityDefine.mTransparency != undefined)
               SetTransparency (entityDefine.mTransparency);
            //<<
            
            // >> from v1.05
            if (entityDefine.mBorderTransparency != undefined)
               SetBorderTransparency (entityDefine.mBorderTransparency);
            if (entityDefine.mIsHollow != undefined)
               SetHollow (entityDefine.mIsHollow);
            //<<
            
            //>> from v1.07
            if (entityDefine.mBuildBorder != undefined)
               SetBuildBorder (entityDefine.mBuildBorder)
            if (entityDefine.mAngularVelocity != undefined)
               SetAngularVelocity (entityDefine.mAngularVelocity);
            if (entityDefine.mVelocityX != undefined)
               SetLinearVelocityX (mWorld.DisplayLength2PhysicsLength (entityDefine.mVelocityX));
            if (entityDefine.mVelocityY != undefined)
               SetLinearVelocityY (mWorld.DisplayLength2PhysicsLength (entityDefine.mVelocityY));
            
            if (entityDefine.mLinearDamping != undefined)
               SetLinearDamping (entityDefine.mLinearDamping);
            if (entityDefine.mAngularDamping != undefined)
               SetAngularDamping (entityDefine.mAngularDamping);
            
            if (entityDefine.mAllowSleeping != undefined)
               SetAllowSleeping (entityDefine.mIsAllowSleeping);
            if (entityDefine.mIsRotationFixed != undefined)
               SetRotationFixed (entityDefine.mIsRotationFixed);
            //<<
            
            if (Define.IsBreakableShape (mAiType) && mAlpha > 0.8)
            {
               SetAlpha (0.8);
            }
         }
      }
      
//=============================================================
//   
//=============================================================
      
      public var mCollisionCategory:CollisionCategory;
      public var mFriendGroupIndex:int = -1;
      
      public function SetCollisionCategoryById (ccatId:int):void
      {
         mCollisionCategory = mWorld.GetCollisionCategoryById (ccatId);
         if (mCollisionCategory == null)
            SetCollisionCategoryById (Define.CollisionCategoryId_HiddenCategory);
      }
      
      public function SetCollisionCategory (ccat:CollisionCategory):void
      {
         if (ccat == null)
            SetCollisionCategoryById (Define.CollisionCategoryId_HiddenCategory);
         else
            mCollisionCategory = ccat;
      }
      
      public function GetCollisionCategory ():CollisionCategory
      {
         return mCollisionCategory;
      }
      
//=============================================================
//   
//=============================================================
      
      // for the 3 functions, maybe it is not a good idea to override them.
      // a better design? : 
      // - entity.SetPositionX (x)
      // - entity.SetPositionY (y)
      // - if (entity is EntityShape) (entity as EntityShape).UpdatelLocalPosition ()

      override public function SetPositionX (x:Number):void
      {
         super.SetPositionX (x);
         
         UpdatelLocalPosition ();
      }
      
      override public function SetPositionY (y:Number):void
      {
         super.SetPositionY (y);
         
         UpdatelLocalPosition ();
      }
      
      override public function SetRotation (rot:Number):void
      {
         mRotation = rot;
         
         UpdatelLocalPosition ();
      }

//=============================================================
//   
//=============================================================
      
      protected var mOriginalAiType:int = Define.ShapeAiType_Unknown;
      protected var mAiType:int = Define.ShapeAiType_Unknown;
      
      protected var mIsStatic:Boolean = false;
      protected var mIsBullet:Boolean = false;
      
      protected var mDensity:Number = 1.0;
      protected var mFriction:Number = 0.1;
      protected var mRestitution:Number = 0.2;
      
      //>>from v1.02
      protected var mDrawBorder:Boolean = true;
      protected var mDrawBackground:Boolean = true;
      //<<
      
      //>> form v1.04
      protected var mBorderColor:uint = 0x0;
      protected var mBorderThickness:Number = 1;
      protected var mFilledColor:uint = 0xFFFFFFFF;
      protected var mTransparency:uint = 100;
      //<<
      
      //>> form v1.05
      protected var mBorderTransparency:uint = 100;
      //<<
      
      //>> form v1.04
      protected var mPhysicsEnabled:Boolean = false;
      protected var mIsSensor:Boolean = false;
      //<<
      
      //>> form v1.05
      protected var mIsHollow:Boolean = false; // always == ! mBuildInterior
      //<<
      
      //>> from v1.07
      protected var mBuildInterior:Boolean = true; // always == ! mIsHollow
      protected var mBuildBorder:Boolean = true;
      
      protected var mLinearVelocityX:Number = 0.0;
      protected var mLinearVelocityY:Number = 0.0;
      
      protected var mAngularVelocity:Number = 0.0;
      
      protected var mLinearDamping:Number = 0.0;
      protected var mAngularDamping:Number = 0.0;
      
      protected var mAllowSleeping:Boolean = true;
      
      protected var mRotationFixed:Boolean = false;
      //<<
      
      public function SetOriginalShapeAiType (aiType:int):void
      {
         if (mOriginalAiType != aiType)
         {
            mWorld.ChangeShapeOriginalAiType (mOriginalAiType, aiType, mAiType);
            mOriginalAiType = aiType;
         }
      }
      
      public function SetShapeAiType (aiType:int):void
      {
         if (mAiType != aiType)
         {
            mWorld.ChangeShapeAiType (mOriginalAiType, mAiType, aiType);
            mAiType = aiType;
         }
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetShapeAiType ():int
      {
         return mAiType;
      }
      
      public function SetStatic (static:Boolean):void
      {
         mIsStatic = static;
      }
      
      public function IsStatic ():Boolean
      {
         return mIsStatic;
      }
      
      public function SetAsBullet (bullet:Boolean):void
      {
         mIsBullet = bullet;
      }
      
      public function IsBullet ():Boolean
      {
         return mIsBullet;
      }
      
      public function SetHollow (hollow:Boolean):void
      {
         if (mIsHollow != hollow)
         {
            mIsHollow = hollow;
            mBuildInterior = ! mIsHollow;
         }
      }
      
      public function IsHollow ():Boolean
      {
         return mIsHollow;
      }
      
      public function IsBuildInterior ():Boolean
      {
         return mBuildInterior;
      }
      
      public function SetBuildBorder (buildBorder:Boolean):void
      {
         if (mBuildBorder != buildBorder)
         {
            mBuildBorder = buildBorder;
         }
      }
      
      public function IsBulidBorder ():Boolean
      {
         return mBuildBorder;
      }
      
      public function SetDensity (density:Number):void
      {
         mDensity = density;
      }
      
      public function GetDensity ():Number
      {
         return mDensity;
      }
      
      public function SetFriction (friction:Number):void
      {
         mFriction = friction;
      }
      
      public function GetFriction ():Number
      {
         return mFriction;
      }
      
      public function SetRestitution (restitution:Number):void
      {
         mRestitution = restitution;
      }
      
      public function GetRestitution ():Number
      {
         return mRestitution;
      }
      
      public function SetDrawBackground (draw:Boolean):void
      {
         mDrawBackground = draw;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function IsDrawBackground ():Boolean
      {
         if (mAiType >= 0)
            return true;
         
         return mDrawBackground;
      }
      
      public function SetFilledColor (color:uint):void
      {
         mFilledColor = color;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance ();
      }
      
      public function GetFilledColor ():uint
      {
         if (mAiType >= 0)
            return Define.GetShapeFilledColor (mAiType);
         
         return mFilledColor;
      }
      
      public function SetDrawBorder (drawBorder:Boolean):void
      {
         mDrawBorder = drawBorder;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function IsDrawBorder ():Boolean
      {
         return mDrawBorder;
      }
      
      public function SetBorderColor (color:uint):void
      {
         mBorderColor = color;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetBorderColor ():uint
      {
         if (mAiType >= 0)
            return Define.ColorObjectBorder;
         
         return mBorderColor;
      }
      
      public function SetBorderThickness (thinkness:Number):void
      {
         mBorderThickness = thinkness;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetBorderThickness ():uint
      {
         return mBorderThickness;
      }
      
      // the background transparency
      public function SetTransparency (transparency:uint):void
      {
         mTransparency = transparency;
         
         mNeedUpdateAppearanceProperties = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetTransparency ():uint
      {
         if (mAiType >= 0)
            return 100;
         
         return mTransparency;
      }
      
      public function SetBorderTransparency (transparency:uint):void
      {
         mBorderTransparency = transparency;
         
         mNeedUpdateAppearanceProperties = true;
         DelayUpdateAppearance (); 
      }
      
      public function GetBorderTransparency ():uint
      {
         return mBorderTransparency;
      }
      
      public function SetAsSensor (sensor:Boolean):void
      {
         if (mIsSensor != sensor)
         {
            mIsSensor = sensor;
            
            if (mProxyShape != null)
               mProxyShape.SetSensor (sensor);
         }
      }
      
      public function IsSensor ():Boolean
      {
         return mIsSensor;
      }
      
      public function SetLinearVelocityX (vx:Number):void
      {
         mLinearVelocityX = vx;
      }
      
      public function GetLinearVelocityX ():Number
      {
         return mLinearVelocityX;
      }
      
      public function SetLinearVelocityY (vy:Number):void
      {
         mLinearVelocityY = vy;
      }
      
      public function GetLinearVelocityY ():Number
      {
         return mLinearVelocityY;
      }
      
      public function SetAngularVelocity (av:Number):void
      {
         mAngularVelocity = av;
      }
      
      public function GetAngularVelocity ():Number
      {
         return mAngularVelocity;
      }
      
      public function SetLinearDamping (damping:Number):void
      {
         mLinearDamping = damping;
      }
      
      public function GetLinearDamping ():Number
      {
         return mLinearDamping;
      }
      
      public function SetAngularDamping (damping:Number):void
      {
         mAngularDamping = damping;
      }
      
      public function GetAngularDamping ():Number
      {
         return mAngularDamping;
      }
      
      public function SetAllowSleeping (allowSleeping:Boolean):void
      {
         mAllowSleeping = allowSleeping;
      }
      
      public function IsAllowSleeping ():Boolean
      {
         return mAllowSleeping;
      }
      
      public function SetRotationFixed (fixed:Boolean):void
      {
         mRotationFixed = fixed;
      }
      
      public function IsRotationFixed ():Boolean
      {
         return mRotationFixed;
      }
      
//=============================================================
//   mouse events
//=============================================================
      
      protected function OnMouseUp (event:MouseEvent):void
      {
         //trace ("click on this: " + this);
      }

//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         DelayUpdateAppearance ();
         
         //mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_UP, OnMouseUp, true);
         //mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_UP, OnMouseUp, false);
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override protected function DestroyInternal ():void
      {
         mWorld.UnregisterShapeAiType (mOriginalAiType, mAiType);
         
         mWorld.GetEntityLayer ().removeChild (mAppearanceObjectsContainer);
         
         //mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp, true);
         //mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_UP, OnMouseUp, false);
         
         while (mJointAnchorListHead != null)
         {
            mJointAnchorListHead.mJoint.Destroy ();
         }
         
         if (mBody != null)
         {
            SetBody (null);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      override public function SynchronizeWithPhysicsProxy ():void
      {
         if (mBody != null)
         {
            mPositionX = mBody.mPositionX + mLocalPositionX * mBody.mCosRotation - mLocalPositionY * mBody.mSinRotation;
            mPositionY = mBody.mPositionY + mLocalPositionX * mBody.mSinRotation + mLocalPositionY * mBody.mCosRotation;
            mRotation  = mBody.mRotation + mRelativeRotation;
         }
         
         mAppearanceObjectsContainer.x = mWorld.PhysicsX2DisplayX (mPositionX);
         mAppearanceObjectsContainer.y = mWorld.PhysicsY2DisplayY (mPositionY);
         mAppearanceObjectsContainer.rotation = mRotation * Define.kRadians2Degrees;
      }
      
//=============================================================
//   update
//=============================================================
      
      //override protected function UpdateInternal (dt:Number):void
      //{
      //}
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mNeedUpdateAppearanceProperties:Boolean = true;
      protected var mNeedRebuildAppearanceObjects:Boolean = true;
      
      protected var mAppearanceObjectsContainer:Sprite = new Sprite ();
      
//=============================================================
//   body
//=============================================================
      
      // for a physics shape, the body must not be null
      internal var mBody:EntityBody = null;
      
      internal var mPrevShapeInBody:EntityShape = null;
      internal var mNextShapeInBody:EntityShape = null;
      internal var mPrevPhysicsShapeInBody:EntityShape = null;
      internal var mNextPhysicsShapeInBody:EntityShape = null;
      
      // relative to mBody
      protected var mLocalPositionX:Number;
      protected var mLocalPositionY:Number;
      protected var mRelativeRotation:Number;
      
      public function GetBody ():EntityBody
      {
         return mBody;
      }
      
      public function SetBody (body:EntityBody):void
      {
         if (mBody != body)
         {
            if (mBody != null)
            {
               DestroyPhysicsProxy ();
                  
               mBody.RemoveShape (this);
            }
            
            if (body != null)
            {
               body.AddShape (this);
            }
            
            UpdatelLocalPosition ();
         }
      }
      
      internal function UpdatelLocalPosition ():void
      {
         if (mBody != null)
         {
            var tempX:Number = (mPositionX - mBody.GetPositionX ());
            var tempY:Number = (mPositionY - mBody.GetPositionY ());
            mLocalPositionX =   tempX * mBody.mCosRotation + tempY * mBody.mSinRotation;
            mLocalPositionY = - tempX * mBody.mSinRotation + tempY * mBody.mCosRotation;
            mRelativeRotation  = mRotation  - mBody.GetRotation  ();
         }
      }
      
//=============================================================
//   connected joints
//=============================================================
     
      internal var mJointAnchorListHead:SubEntityJointAnchor = null;
      
      internal function AttachJointAnchor (jointAnchor:SubEntityJointAnchor):void
      {
         if (jointAnchor.mShape != null)
         {
            if (jointAnchor.mShape == this)
               return;
            
            jointAnchor.mShape.DetachJointAnchor (jointAnchor);
         }
         
         jointAnchor.mShape = this;
         
         if (mJointAnchorListHead != null)
            mJointAnchorListHead.mPrevAnchor = jointAnchor;
         
         jointAnchor.mNextAnchor = mJointAnchorListHead;
         mJointAnchorListHead = jointAnchor;
      }
      
      internal function DetachJointAnchor (jointAnchor:SubEntityJointAnchor):void
      {
         if (jointAnchor.mShape != this)
            return;
         
         var prev:SubEntityJointAnchor = jointAnchor.mPrevAnchor;
         var next:SubEntityJointAnchor = jointAnchor.mNextAnchor;
         
         if (prev != null)
         {
            prev.mNextAnchor = next;
         }
         else // (mJointAnchorListHead == jointAnchor)
         {
            mJointAnchorListHead = next;
         }
         
         if (next != null)
         {
            next.mPrevAnchor = prev;
         }
         
         jointAnchor.mShape = null;
      }
      
   //----------------------------------------------------
   //   cos, sin: used by SubEntityJointAnchors
   //----------------------------------------------------
     
      internal var mCosRotation:Number = 1.0;
      internal var mSinRotation:Number = 0.0;
      private  var mLastRotation:Number = 0.0; // last rotation -> sin, cos
      
      internal function UpdateSinCos ():void
      {
         if (mRotation != mLastRotation)
         {
            mLastRotation = mRotation;
            
            mCosRotation = Math.cos (mRotation);
            mSinRotation = Math.sin (mRotation);
         }
      }
      
//=============================================================
//   physics proxy
//=============================================================
     
      protected var mPhysicsShapePotentially:Boolean = false;
      
      protected var mProxyShape:PhysicsProxyShape = null;
      
      //>> from v1.07
      protected var mPhysicsValuesValidFlags:int = 0x7FFFFFFF;
      
      protected static const kValidFlag_LinearVelocity:int = 1 << 0;
      protected static const kValidFlag_AngularVelocity:int = 1 << 0;
      //<<
      
      public function IsPhysicsShape ():Boolean
      {
         return mPhysicsShapePotentially && mPhysicsEnabled;
      }
      
      public function SetPhysicsEnabled (enabled:Boolean):void
      {
         if (mBody == null) // generally, mBody should not be null. It is null only when the shape is not initilized totally.
         {
            mPhysicsEnabled = enabled;
         }
         else
         {
            //var oldIsPhysics:Boolean = IsPhysicsShape ();
            //mPhysicsEnabled = enabled;
            //var newIsPhysics:Boolean = IsPhysicsShape ();
            //
            //if (newIsPhysics != oldIsPhysics)
            //{
            //   mBody.RemoveShape (this);
            //   mBody.AddShape (this);
            //   
            //   // todo, reset mass, if body.isPhysics changes, break/built joints, else if this shape physics enabled is changed, break/built joints
            //}
         }
      }
      
      override public function DestroyPhysicsProxy ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         super.DestroyPhysicsProxy ();
         
         mProxyShape = null;
      }
      
      final public function RebuildShapePhysics ():void
      {
      // ...
         if (mAlreadyDestroyed)
            return;
         
         DestroyPhysicsProxy ();
         
         if (! IsPhysicsShape ())
            return;
         
         //if (mBody == null) // should not be null
         //   return;
         
         if (! mBody.IsPhysicsBuilt ())
         {
            mBody.RebuildBodyPhysics ();
         }
         
         var proxyShape:PhysicsProxyShape = mPhysicsProxy as PhysicsProxyShape;
         
         if (mProxyShape == null)
         {
            mProxyShape = new PhysicsProxyShape (mBody.mPhysicsProxy as PhysicsProxyBody, this);
            //mPhysicsProxy.SetUserData (this);
            
            mPhysicsProxy = mProxyShape;
         }
         
      // ...
         RebuildShapePhysicsInternal ();
      }

      protected function RebuildShapePhysicsInternal ():void
      {
         // to override
      }

//=============================================================
//   some paint function used by subclasses
//=============================================================
     
   
   
   }
}
