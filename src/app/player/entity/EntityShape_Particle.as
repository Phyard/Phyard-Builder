package player.entity {
   
   import player.world.World;   
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShape_Particle extends EntityShapeCircle
   {
      private var mLifeDuration:Number = 1.2; // seconds
      private var mLife:Number = 0.0;
      
      // ...
      
      public function EntityShape_Particle (world:World, lifeDuration:Number)
      {
         super (world);
         
         mAiTypeChangeable = false;
         
         mLifeDuration = lifeDuration;
         mLife = 0.0;
         SetVisible (false);
         
         SetShapeAiType (Define.ShapeAiType_BombParticle);
         SetRadius (mWorld.GetCoordinateSystem ().D2P_Length (0.5));//1.0));
         
         SetPhysicsEnabled (true);
         SetFriction (0.0);
         SetRestitution (0.8);
         SetStatic (false);
         SetAsBullet (true);
         
         SetAppearanceType (Define.EntityType_ShapeCircle);
         SetDrawBorder (false);
         SetFilledColor (0x0);
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         super.UpdateInternal (dt);
         
         mLife += dt;
         
         SetVisible (mLife > 0);
         
         if (mLife > mLifeDuration)
         {
            Destroy ();
         }
         else
         {
            SetAlpha ((mLifeDuration - mLife) / mLifeDuration);
            
            mBody.mPhysicsProxyBody.AddForceAtPoint (- mMass * mWorld.GetCurrentGravityAccelerationX (), - mMass * mWorld.GetCurrentGravityAccelerationY (), mPositionX, mPositionY);
         }
      }
      
   }
}
