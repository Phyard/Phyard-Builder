package player.entity {
   
   import flash.geom.Point;
   import flash.display.Sprite;
   
   import flash.events.MouseEvent;
   
   import player.world.World;
   import player.world.CollisionCategory;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Direct
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;
   
   import common.Define;
   import common.trigger.CoreEventIds;
   
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
         
         SetBorderThickness (mWorld.GetCoordinateSystem ().D2P_Length (1.0));
         
         SetCollisionCategoryById (Define.CollisionCategoryId_HiddenCategory); // default
         
         mPhysicsShapePotentially = false; // to override
         
         mWorld.GetEntityLayer ().addChild (mAppearanceObjectsContainer);
         
         mWorld.RegisterShapeAiType (mOriginalAiType, mAiType);
      }
      
      public function IsVisualShape ():Boolean
      {
         return true;
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
               SetBorderThickness (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mBorderThickness));
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
            
            //>> from v1.08
            if (entityDefine.mBuildBorder != undefined)
               SetBuildBorder (entityDefine.mBuildBorder)
            
            if (entityDefine.mLinearVelocityMagnitude != undefined && entityDefine.mLinearVelocityAngle != undefined)
            {
               SetLinearVelocity (mWorld.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (entityDefine.mLinearVelocityMagnitude), 
                                 mWorld.GetCoordinateSystem ().D2P_RotationRadians (entityDefine.mLinearVelocityAngle * Define.kDegrees2Radians));
            }
            if (entityDefine.mAngularVelocity != undefined)
               SetAngularVelocity (mWorld.GetCoordinateSystem ().D2P_RotationRadians (entityDefine.mAngularVelocity * Define.kDegrees2Radians));
            
            //if (entityDefine.mLinearDamping != undefined)
            //   SetLinearDamping (entityDefine.mLinearDamping);
            //if (entityDefine.mAngularDamping != undefined)
            //   SetAngularDamping (entityDefine.mAngularDamping);
            
            if (entityDefine.mIsSleepingAllowed != undefined)
               SetSleepingAllowed (entityDefine.mIsSleepingAllowed);
            if (entityDefine.mIsRotationFixed != undefined)
               SetRotationFixed (entityDefine.mIsRotationFixed);
            //<<
            
            if (Define.IsBreakableShape (mAiType) && mAlpha > 0.8)
            {
               SetAlpha (0.8);
            }
         }
         else if (createStageId == 2)
         {
            UpdatelLocalPosition ();
            
            if (mAiType == Define.ShapeAiType_Bomb)
            {
               mAiTypeChangeable = false;
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
      
      protected var mSleepingAllowed:Boolean = true;
      
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
      
      // here, for shapes, the SetVelocity will not not change the mass of the body of shape,
      // also not call shape.UpdateLocalPosition.
      // Those functions must be called mannually if needed.
      
      public function SetLinearVelocityX (vx:Number):void
      {
         mLinearVelocityX = vx;
      }
      
      public function GetLinearVelocityX ():Number
      {
         UpdateVelocityAndWorldCentroid ();
         
         return mLinearVelocityX;
      }
      
      public function SetLinearVelocityY (vy:Number):void
      {
         mLinearVelocityY = vy;
      }
      
      public function GetLinearVelocityY ():Number
      {
         UpdateVelocityAndWorldCentroid ();
         
         return mLinearVelocityY;
      }
      
      public function SetLinearVelocity (magnitude:Number, angle:Number):void
      {
         SetLinearVelocityX (magnitude *  Math.cos (angle));
         SetLinearVelocityY (magnitude *  Math.sin (angle));
      }
      
      public function SetAngularVelocity (av:Number):void
      {
         mAngularVelocity = av;
      }
      
      public function GetAngularVelocity ():Number
      {
         UpdateVelocityAndWorldCentroid ();
         
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
      
      public function SetSleepingAllowed (allowSleeping:Boolean):void
      {
         mSleepingAllowed = allowSleeping;
      }
      
      public function IsSleepingAllowed ():Boolean
      {
         return mSleepingAllowed;
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
//   mouse event handlers
//=============================================================
      
      private var mPhyicsShapeMouseDownEventHandlerList:ListElement_EventHandler = null;
      private var mPhyicsShapeMouseUpEventHandlerList:ListElement_EventHandler = null;
      private var mMouseClickEventHandlerList:ListElement_EventHandler = null;
      private var mMouseDownEventHandlerList:ListElement_EventHandler = null;
      private var mMouseUpEventHandlerList:ListElement_EventHandler = null;
      private var mMouseMoveEventHandlerList:ListElement_EventHandler = null;
      private var mMouseEnterEventHandlerList:ListElement_EventHandler = null;
      private var mMouseOutEventHandlerList:ListElement_EventHandler = null;
      
      override public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         switch (eventId)
         {
            case CoreEventIds.ID_OnPhysicsShapeMouseDown:
               mPhyicsShapeMouseDownEventHandlerList = RegisterEventHandlerToList (mPhyicsShapeMouseDownEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnPhysicsShapeMouseUp:
               mPhyicsShapeMouseUpEventHandlerList = RegisterEventHandlerToList (mPhyicsShapeMouseUpEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseClick:
               mMouseClickEventHandlerList = RegisterEventHandlerToList (mMouseClickEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseDown:
               mMouseDownEventHandlerList = RegisterEventHandlerToList (mMouseDownEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseUp:
               mMouseUpEventHandlerList = RegisterEventHandlerToList (mMouseUpEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseMove:
               mMouseMoveEventHandlerList = RegisterEventHandlerToList (mMouseMoveEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseEnter:
               mMouseEnterEventHandlerList = RegisterEventHandlerToList (mMouseEnterEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityMouseOut:
               mMouseOutEventHandlerList = RegisterEventHandlerToList (mMouseOutEventHandlerList, eventHandler);
               break;
            default:
               break;
         }
      }
      
   // for physics shapes
      
      public function OnPhysicsShapeMouseDown(valueSourceList:ValueSource):void
      {
         var listElement:ListElement_EventHandler = mPhyicsShapeMouseDownEventHandlerList;
         
         while (listElement != null)
         {
            listElement.mEventHandler.HandleEvent (valueSourceList);
            
            listElement = listElement.mNextListElement;
         }
      }
      
      public function OnPhysicsShapeMousUp(valueSourceList:ValueSource):void
      {
         var listElement:ListElement_EventHandler = mPhyicsShapeMouseUpEventHandlerList;
         
         while (listElement != null)
         {
            listElement.mEventHandler.HandleEvent (valueSourceList);
            
            listElement = listElement.mNextListElement;
         }
      }
      
   // ...
      
      protected function OnMouseClick (event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseClickEventHandlerList);
      }
      
      protected function OnMouseDown(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseDownEventHandlerList);
      }
      
      protected function OnMouseUp(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseUpEventHandlerList);
      }
      
      protected function OnMouseMove(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseMoveEventHandlerList);
      }
      
      protected function OnMouseEnter (event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseEnterEventHandlerList);
      }
      
      protected function OnMouseOut(event:MouseEvent):void
      {
         HandleMouseEvent (event, mMouseOutEventHandlerList);
      }
      
      private function HandleMouseEvent (event:MouseEvent, listElement:ListElement_EventHandler):void
      {
         var valueSourceList:ValueSource_Direct = mWorld.MouseEvent2ValueSourceList (event);
         
         valueSourceList.mValueObject = this;
         
         while (listElement != null)
         {
            listElement.mEventHandler.HandleEvent (valueSourceList);
            
            listElement = listElement.mNextListElement;
         }
      }
      
   // these function will be override by some subclasses. Subclasses should call add/removeEventListener in their class body.
      
      protected function GetMouseClickListener ():Function
      {
         return mMouseClickEventHandlerList == null ? null : OnMouseClick;
      }
      
      protected function GetMouseDownListener ():Function
      {
         return mMouseDownEventHandlerList == null ? null : OnMouseDown;
      }
      
      protected function GetMouseUpListener ():Function
      {
         return mMouseUpEventHandlerList == null ? null : OnMouseUp;
      }
      
      protected function GetMouseMoveListener ():Function
      {
         return mMouseMoveEventHandlerList == null ? null : OnMouseMove;
      }
      
      protected function GetMouseEnterListener ():Function
      {
         return mMouseEnterEventHandlerList == null ? null : OnMouseEnter;
      }
      
      protected function GetMouseOutListener ():Function
      {
         return mMouseOutEventHandlerList == null ? null : OnMouseOut;
      }
      
//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         DelayUpdateAppearance ();
         
         mAppearanceObjectsContainer.mouseChildren = false;
         if (GetMouseClickListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.CLICK, GetMouseClickListener ());
         if (GetMouseDownListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_DOWN, GetMouseDownListener ());
         if (GetMouseUpListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_UP, GetMouseUpListener ());
         if (GetMouseMoveListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_MOVE, GetMouseMoveListener ());
         if (GetMouseEnterListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_OVER, GetMouseEnterListener ());
         if  (GetMouseOutListener () != null)
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_OUT, GetMouseOutListener ());
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override public function DestroyEntity ():void
      {
         var body:EntityBody = mBody;
         
         super.DestroyEntity ();
         
         body.OnPhysicsShapeListChanged (IsPhysicsShape ());
      }
      
      override protected function DestroyInternal ():void
      {
         mWorld.UnregisterShapeAiType (mOriginalAiType, mAiType);
         
         mWorld.GetEntityLayer ().removeChild (mAppearanceObjectsContainer);
         
         BreakAllJoints ();
         
         SetBody (null);
         
         if (GetMouseClickListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.CLICK, GetMouseClickListener ());
         if (GetMouseDownListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_DOWN, GetMouseDownListener ());
         if (GetMouseUpListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_UP, GetMouseUpListener ());
         if (GetMouseMoveListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_MOVE, GetMouseMoveListener ());
         if (GetMouseEnterListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_OVER, GetMouseEnterListener ());
         if  (GetMouseOutListener () != null)
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_OUT, GetMouseOutListener ());
      }
      
//=============================================================
//   update position rotation
//=============================================================
      
      override public function SynchronizeWithPhysicsProxy ():void
      {
         //if (mBody != null) // should no be null
         {
            mPositionX = mBody.mPositionX + mLocalPositionX * mBody.mCosRotation - mLocalPositionY * mBody.mSinRotation;
            mPositionY = mBody.mPositionY + mLocalPositionX * mBody.mSinRotation + mLocalPositionY * mBody.mCosRotation;
            mRotation  = (mBody.mRotation + mRelativeRotation) % Define.kPI_x_2;
         }
         
         mAppearanceObjectsContainer.x = mWorld.GetCoordinateSystem ().P2D_PositionX (mPositionX);
         mAppearanceObjectsContainer.y = mWorld.GetCoordinateSystem ().P2D_PositionY (mPositionY);
         mAppearanceObjectsContainer.rotation = mWorld.GetCoordinateSystem ().P2D_RotationRadians (mRotation) * Define.kRadians2Degrees;
      }
      
//=============================================================
//   mass, interia, centroid
//=============================================================
      
      internal var mMass:Number = 0.0;
      internal var mInertia:Number = 0.0;
      
      // the local centroid position in body space
      internal var mLocalCentroidX:Number = 0.0;
      internal var mLocalCentroidY:Number = 0.0;
      
   // the following setter functions should be only called by mProxyShape
      
      public function SetMass (mass:Number):void
      {
         mMass = mass;
      }
      
      public function SetInertia (inertia:Number):void
      {
         mInertia = inertia;
      }
      
      public function SetCentroid (centroidX:Number, centroidY:Number):void
      {
         mLocalCentroidX = centroidX;
         mLocalCentroidY = centroidY;
      }
      
      public function UpdateMassAndInertiaAndCentroid ():void
      {
         if (mPhysicsProxy != null)
         {
            mProxyShape.UpdateMass ();
         }
         else
         {
            mMass = 0.0;
            mInertia = 0.0;
            mLocalCentroidX = mLocalPositionX;
            mLocalCentroidY = mLocalPositionY;
         }
      }
      
//=============================================================
//   update velocity
//=============================================================
      
      // ..
      internal var mWorldCentroidX:Number = 0.0;
      internal var mWorldCentroidY:Number = 0.0;
      
      // for judging if this condition is evaluated already in current step.
      private var mLastVelocityUpdatedStep:int = -1;
      
      internal function UpdateWorldCentroid ():void
      {
         mBody.SynchronizeVelocityWithPhysicsProxy ();
         
         var worldLocalCentroidX:Number = mLocalCentroidX * mBody.mCosRotation - mLocalCentroidY * mBody.mSinRotation;
         var worldLocalCentroidY:Number = mLocalCentroidX * mBody.mSinRotation + mLocalCentroidY * mBody.mCosRotation;
         
         mWorldCentroidX = mBody.mPositionX + worldLocalCentroidX;
         mWorldCentroidY = mBody.mPositionY + worldLocalCentroidY;
      }
      
      internal function UpdateVelocityAndWorldCentroid (forcely:Boolean = false):void
      {
         var worldSimulateSteps:int = mWorld.GetSimulatedSteps ();
         if (mLastVelocityUpdatedStep < worldSimulateSteps || forcely)
         {
            mLastVelocityUpdatedStep = worldSimulateSteps;
            
            mBody.SynchronizeVelocityWithPhysicsProxy ();
            
            var worldLocalCentroidX:Number = mLocalCentroidX * mBody.mCosRotation - mLocalCentroidY * mBody.mSinRotation;
            var worldLocalCentroidY:Number = mLocalCentroidX * mBody.mSinRotation + mLocalCentroidY * mBody.mCosRotation;
            
            mAngularVelocity = mBody.mAngularVelocity;
            mLinearVelocityX = mBody.mLinearVelocityX - mAngularVelocity * worldLocalCentroidY;
            mLinearVelocityY = mBody.mLinearVelocityY + mAngularVelocity * worldLocalCentroidX;
            
            mWorldCentroidX = mBody.mPositionX + worldLocalCentroidX;
            mWorldCentroidY = mBody.mPositionY + worldLocalCentroidY;
         }
      }
      
      // call this function after calling mBody.OnPhysicsShapeListChanged () so that mBody.mPosition is the centroid of mBody.
      internal function AddMomentumToBody ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         if (IsStatic ())
            return;
         
         var momentumX:Number = mMass * mLinearVelocityX;
         var momentumY:Number = mMass * mLinearVelocityY;
         mBody.mPhysicsProxyBody.AddLinearImpulseAtPoint (momentumX, momentumY, mWorldCentroidX, mWorldCentroidY);
         
         if (IsRotationFixed ())
         {
            mBody.mPhysicsProxyBody.AddAngularImpulse ((mWorldCentroidX - mBody.mPositionX) * momentumY - (mWorldCentroidY - mBody.mPositionY) * momentumX);
         }
         else
         {
            mBody.mPhysicsProxyBody.AddAngularImpulse (mInertia * mAngularVelocity + (mWorldCentroidX - mBody.mPositionX) * momentumY - (mWorldCentroidY - mBody.mPositionY) * momentumX);
         }
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
               
               // here not rebuild physics automatically.
            }
            
            UpdatelLocalPosition ();
         }
      }
      
      public function UpdatelLocalPosition ():void
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
//   step accumulated values, before world.Step (), these accumlated values will be applied on body
//=============================================================
      
      // need knowing mass
      private var mAccumulatedForce:Number = 0.0;
      private var mAccumulatedTorque:Number = 0.0;
      
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
      
//=============================================================
//   local <-> world, for SubEntityJointAnchors and other general uses
//=============================================================
     
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
      
      internal function LocalPoint2WorldPoint (localX:Number, localY:Number):Point
      {
         return new Point (
               mPositionX + localX * mCosRotation - localY * mSinRotation,
               mPositionY + localX * mSinRotation + localY * mCosRotation
            );
      }
      
      internal function WorldPoint2LocalPoint (worldX:Number, worldlY:Number):Point
      {
         return new Point (
               mPositionX + worldX * mCosRotation + worldlY * mSinRotation,
               mPositionY - worldX * mSinRotation + worldlY * mCosRotation
            );
      }
      
      internal function LocalVector2WorldVector (localVX:Number, localVY:Number):Point
      {
         return new Point (
               localVX * mCosRotation - localVY * mSinRotation,
               localVX * mSinRotation + localVY * mCosRotation
            );
      }
      
      internal function WorldVector2LocalVector (worldVX:Number, worldlVY:Number):Point
      {
         return new Point (
                 worldVX * mCosRotation + worldlVY * mSinRotation,
               - worldVX * mSinRotation + worldlVY * mCosRotation
            );
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
         
         mProxyShape = null;
         
         super.DestroyPhysicsProxy ();
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
         
      // ...
      }

      protected function RebuildShapePhysicsInternal ():void
      {
         // to override
      }

      // when detaching, someinfo must be saved
      internal function SaveShapeStatus ():void
      {
         
      }

//=============================================================
//   some functions
//=============================================================
      
      protected var mAiTypeChangeable:Boolean = true; // if it is false, subclass must overwrite it
      
      final public function IsAiTypeChangeable ():Boolean
      {
         return mAiTypeChangeable;
      }
   }
}
