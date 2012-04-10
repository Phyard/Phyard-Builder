
package editor.entity {

   import flash.display.Sprite;

   import editor.world.World;

   import editor.selection.SelectionProxy;
   
   import editor.ccat.CollisionCategory;

   import common.Define;

   public class EntityShape extends WorldEntity
   {
      // physics
        // some physics properties may be specified for shapes instead of bodies.
        // for module shapes, this properties can be set in the module editing dialog.
        // Later, there will be "defalut value" setting for module shapes.

      //>> form v1.04
      protected var mPhysicsEnabled:Boolean = true;
      public var mIsSensor:Boolean = false;
      // collision category
      private var mCollisionCategory:CollisionCategory = null;
      //<<

      protected var mIsStatic:Boolean = false;
      public var mIsBullet:Boolean = false;

      //public var mDensity:Number = 1.0;
      public var mDensity:Number = Define.DefaultShapeDensity; // from v1.08
      public var mFriction:Number = 0.1;
      public var mRestitution:Number = 0.2;

      //>> v1.08
      protected var mLinearVelocityMagnitude:Number = 0;
      protected var mLinearVelocityAngle:Number = 0;
      protected var mAngularVelocity:Number = 0;

      protected var mLinearDamping:Number = 0; // 1.08 加入fileForamt中了？
      protected var mAngularDamping:Number = 0;

      protected var mAllowSleeping:Boolean = true;
      protected var mFixRotation:Boolean = false;
      //<<

      // !!! when open these, remember modify SetPropertiesForClonedEntity
      //public var mLinearDamping:Number = 0.0;
      //public var mAngularDamping:Number = 0.0;
      // allow sleep
      // is sleeping

      // geometry
         // the 2 temp put here.
         // when move them into EntityVectorShape, 
         // OnBatchModifyShapePhysicsProperties needs modification.

      //>> form v1.05
      protected var mIsHollow:Boolean = false;
      //<<

      //>> v1.08
      protected var mBuildBorder:Boolean = true;
      //<<




      //for debug
      protected var mPhysicsShapesLayer:Sprite = null;

//====================================================================
//
//====================================================================

      public function EntityShape (world:World)
      {
         super (world);
      }

      override public function GetVisibleAlpha ():Number
      {
         return 0.39 + GetAlpha () * 0.40;
      }

      override public function GetTypeName ():String
      {
         return "Shape";
      }

      public function IsBasicVectorShapeEntity ():Boolean
      {
         return false;
      }

      public function IsPhysicsCapableShapeEntity ():Boolean
      {
         return true;
      }

//====================================================================
//   clone
//====================================================================

      // to override
      override protected function CreateCloneShell ():Entity
      {
         return null;
      }

      // to override
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var shape:EntityShape = entity as EntityShape;

         shape.SetPhysicsEnabled (mPhysicsEnabled);
         shape.SetStatic ( IsStatic () );
         shape.mIsBullet = mIsBullet;
         shape.mDensity = mDensity;
         shape.mFriction = mFriction;
         shape.mRestitution = mRestitution;
         shape.mIsSensor = mIsSensor;

         // the 2 temp here
         shape.SetHollow (IsHollow ());
         shape.SetBuildBorder (IsBuildBorder ());

         shape.SetCollisionCategoryIndex ( GetCollisionCategoryIndex () );

         shape.SetLinearVelocityMagnitude (GetLinearVelocityMagnitude ());
         shape.SetLinearVelocityAngle (GetLinearVelocityAngle ());
         shape.SetAngularVelocity (GetAngularVelocity ());
         shape.SetLinearDamping (GetLinearDamping ());
         shape.SetAngularDamping (GetAngularDamping ());

         shape.SetAllowSleeping (IsAllowSleeping ());
         shape.SetFixRotation (IsFixRotation ());
      }

//======================================================
// physics
//======================================================

      public function SetPhysicsEnabled (enabled:Boolean):void
      {
         mPhysicsEnabled = enabled;
      }

      public function IsPhysicsEnabled ():Boolean
      {
         return mPhysicsEnabled;
      }

      public function SetStatic (isStatic:Boolean):void
      {
         mIsStatic = isStatic;
      }

      public function IsStatic ():Boolean
      {
         return mIsStatic;
      }

      //public function SetAsField (field:Boolean):void
      //{
      //   mIsField = field;
      //
      //   if (mIsField)
      //   {
      //      SetPhysicsEnabled (true);
      //      SetAsBullet (true);
      //      SetAsSensor (true);
      //   }
      //}
      //
      //public function IsField ():Boolean
      //{
      //   return mIsField;
      //}

      public function SetAsSensor (sensor:Boolean):void
      {
         mIsSensor = sensor;
      }

      public function IsSensor ():Boolean
      {
         return mIsSensor;
      }

      public function SetAsBullet (bullet:Boolean):void
      {
         mIsBullet = bullet;
      }

      public function IsBullet ():Boolean
      {
         return mIsBullet;
      }

      public function SetDensity (density:Number):void
      {
         if (density < 0)
            density = 0.0;

         mDensity = density;
      }

      public function GetDensity ():Number
      {
         return mDensity;
      }

      public function SetFriction (friction:Number):void
      {
         if (mFriction < 0)
            mFriction = 0.0;

         mFriction = friction;
      }

      public function GetFriction ():Number
      {
         return mFriction;
      }

      public function SetRestitution (restitution:Number):void
      {
         if (mRestitution < 0)
            mRestitution = 0.0;

         mRestitution = restitution;
      }

      public function GetRestitution ():Number
      {
         return mRestitution;
      }

      public function SetLinearVelocityMagnitude (speed:Number):void
      {
         if (mLinearVelocityMagnitude < 0)
            mLinearVelocityMagnitude = 0.0;

         mLinearVelocityMagnitude = speed;
      }

      public function GetLinearVelocityMagnitude ():Number
      {
         return mLinearVelocityMagnitude;
      }

      public function SetLinearVelocityAngle (angle:Number):void
      {
         mLinearVelocityAngle = angle % 360.0;
      }

      public function GetLinearVelocityAngle ():Number
      {
         return mLinearVelocityAngle;
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
         if (damping < 0)
            damping = 0;

         mLinearDamping = damping;
      }

      public function GetLinearDamping ():Number
      {
         return mLinearDamping;
      }

      public function SetAngularDamping (damping:Number):void
      {
         if (damping < 0)
            damping = 0;

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

      public function SetFixRotation (fixRotation:Boolean):void
      {
         mFixRotation = fixRotation;
      }

      public function IsFixRotation ():Boolean
      {
         return mFixRotation;
      }

      public function SetHollow (hollow:Boolean):void
      {
         mIsHollow = hollow;
      }

      public function IsHollow ():Boolean
      {
         return mIsHollow;
      }

      public function SetBuildBorder (build:Boolean):void
      {
         mBuildBorder = build;
      }

      public function IsBuildBorder ():Boolean
      {
         return mBuildBorder;
      }

//======================================================
// collision category
//======================================================

      public function GetCollisionCategoryIndex ():int
      {
         var index:int = mWorld.GetCollisionCategoryManager ().GetCollisionCategoryIndex (mCollisionCategory);

         if (index == Define.CCatId_Hidden)
            mCollisionCategory = null;

         return index;
      }

      public function SetCollisionCategoryIndex (index:int):void
      {
         mCollisionCategory = mWorld.GetCollisionCategoryManager ().GetCollisionCategoryByIndex (index);
      }

   }
}
