package player.entity {
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;

   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;
   
   import common.Define;
   
   public class EntityShape_Particle extends EntityShapeCircle
   {
      private var mLifeDuration:Number = 1.2; // seconds
      private var mLife:Number = 0.0;
      private var mApplyAntiGravity:Boolean = true;
      
      // ...
      
      public function EntityShape_Particle (world:World, lifeDuration:Number)
      {
         super (world);
         
         mAiTypeChangeable = false;
         
         mLifeDuration = lifeDuration;
         mLife = 0.0;
         SetVisible (false);
         
         SetShapeAiType (-1); //Define.ShapeAiType_BombParticle);
         SetRadius (mWorld.GetCoordinateSystem ().D2P_Length (0.5));//1.0));
         
         SetPhysicsEnabled (true);
         SetFriction (0.0);
         SetRestitution (0.8);
         SetStatic (false);
         SetAsBullet (true);
         
         SetAppearanceType (Define.EntityType_ShapeCircle);
         SetDrawBorder (false);
         SetFilledColor (0x0);
         SetAlpha (0.0);
      }
      
      public function SetAffectedByGravity (affected:Boolean):void
      {
         mApplyAntiGravity = affected;
      }
      
      override public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         // do nothing. Currently, registering event handlers for particles are not support
         //super.RegisterEventHandler (eventId, eventHandler);
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         super.UpdateInternal (dt);
         
         mLife += dt;
         
         if (mLifeDuration > 0.0)
         {
            if (mLife > mLifeDuration)
            {
               mWorld.NotifyParticleDestroy ();
               Destroy ();
               return;
            }
            else
            {
               SetAlpha ((mLifeDuration - mLife) / mLifeDuration);
            }
         }
         else
         {
            SetAlpha (1.0);
         }
         
         if (mApplyAntiGravity)
         {
            mBody.ApplyForceAtPoint (- mMass * mWorld.GetLastStepGravityAccelerationX (), - mMass * mWorld.GetLastStepGravityAccelerationY (), GetPositionX (), GetPositionY ());
         }
      }
   }
}
