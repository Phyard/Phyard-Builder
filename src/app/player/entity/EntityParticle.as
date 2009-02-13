
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
      
      override public function Update (dt:Number):void
      {
         super.Update (dt);
         
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
      
      override public function BuildFromParams (params:Object):void
      {
         var oldValue:PhysicsProxyBody = mPhysicsProxy as PhysicsProxyBody;
         params.mContainsPhysicsShapes = true;
         var paramPosX:Number = params.mPosX;
         var paramPosY:Number = params.mPosY;
         
         super.BuildFromParams (params);
         
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
            
            entityDefine.mAiType = Define.ShapeAiType_BombParticle;
            entityDefine.mIsStatic = false;
            entityDefine.mIsBullet = true;
            entityDefine.mDensity = params.mDenstiy;
            entityDefine.mFriction = 0;
            entityDefine.mRestitution = 0.8;
            
            entityDefine.mRadius = 1.0;
            entityDefine.mAppearanceType = Define.CircleAppearanceType_Ball;
            
            mWorld.SetCollisionCategoryParamsForShapeParams (entityDefine, Define.CollisionCategoryId_HiddenCategory);
            
            var shapeCircle:EntityShapeCircle = new EntityShapeCircle (mWorld, this);
            shapeCircle.BuildFromParams (entityDefine);
            
         // ...cal mass
            this.UpdateMass ();
            
         // ...set velocity
            var linearVel:Point = new Point (params.mSpeed * Math.cos (params.mAngle), params.mSpeed * Math.sin (params.mAngle));
            mWorld.mPhysicsEngine.._PhysicsPoint2DisplayPoint (linearVel);
            
            (mPhysicsProxy as PhysicsProxyBody).SetLinearVelocity (linearVel);
         }
      }
      
      
      
   }
}
