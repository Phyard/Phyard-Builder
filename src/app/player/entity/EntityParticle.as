
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Define;
   
   public class EntityParticle extends ShapeContainer
   {
      private var mLifeDuration:Number = 1.2; // default, seconds
      private var mLife:Number = 0;
      
      
      public function EntityParticle (world:World)
      {
         super (world);
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         super.UpdateInternal (dt);
         
         mLife += dt;
         
         visible = mLife > 0;
         
         if (mLife > mLifeDuration)
         {
            mWorld.removeChild (this);
            Destroy ();
         }
         else
         {
            alpha = (mLifeDuration - mLife) / mLifeDuration;
         }
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         var oldValue:PhysicsProxyBody = mPhysicsProxy as PhysicsProxyBody;
         params.mContainsPhysicsShapes = true;
         var paramPosX:Number = params.mPosX;
         var paramPosY:Number = params.mPosY;
         
         super.BuildFromParams (params, false);
         
         // params needed:
         // mPosX
         // mPosY
         // mAngle
         // mSpeed
         // mDenstiy
         // mLifeDuration
         
         mLifeDuration = params.mLifeDuration;
         
         visible = false;
         
         if (oldValue == null && mPhysicsProxy != null)
         {
         // ...create shape
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = Define.EntityType_ShapeCircle;
            entityDefine.mPosX = paramPosX; // 
            entityDefine.mPosY = paramPosY; //
            entityDefine.mRotation = 0;
            entityDefine.mIsVisible = true;
            
            entityDefine.mRadius = 1.0;
            entityDefine.mAppearanceType = Define.CircleAppearanceType_Circle;
            
            entityDefine.mDrawBorder = false;
            entityDefine.mBorderColor = 0x0;
            entityDefine.mBorderThickness = 1;
            entityDefine.mBorderTransparency = 100;
            
            entityDefine.mDrawBackground = true;
            entityDefine.mBackgroundColor = 0x0;
            entityDefine.mTransparency = 100;
            
            entityDefine.mAiType = Define.ShapeAiType_BombParticle;
            entityDefine.mIsStatic = false;
            entityDefine.mIsBullet = true;
            entityDefine.mDensity = params.mDenstiy;
            entityDefine.mFriction = 0;
            entityDefine.mRestitution = 0.8;
            
            entityDefine.mCollisionCategoryIndex = Define.CollisionCategoryId_HiddenCategory;
            
            entityDefine.mIsPhysicsEnabled = true;
            entityDefine.mIsSensor = false;
            entityDefine.mIsHollow = false;
            
            entityDefine.mEntityIndexInEditor = -1;
         
        // 
            
            var shapeCircle:EntityShapeCircle = new EntityShapeCircle (mWorld, this);
            shapeCircle.BuildFromParams (entityDefine);
            
         // ...cal mass
            this.UpdateMass ();
            
         // ...set velocity
            var linearVel:Point = new Point (params.mSpeed * Math.cos (params.mAngle), params.mSpeed * Math.sin (params.mAngle));
            mWorld.mPhysicsEngine.._PhysicsVector2DisplayVector (linearVel);
            
            (mPhysicsProxy as PhysicsProxyBody).SetLinearVelocity (linearVel.x, linearVel.y);
         }
      }
      
      
      
   }
}
