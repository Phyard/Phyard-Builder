
package player.physics {
   
   
   import Box2D.Collision.Shapes.b2CircleDef;
   import Box2D.Common.Math.b2Vec2;
   
   
   public class PhysicsProxyShapeCircle extends PhysicsProxyShape
   {
      public function PhysicsProxyShapeCircle (phyEngine:PhysicsEngine, proxyBody:PhysicsProxyBody, worldPhysicsX:Number, worldPhysicsY:Number, physicsRadius:Number, params:Object = null):void
      {
         super (phyEngine, proxyBody);
         
         _LocalPosition.SetV ( proxyBody._b2Body.GetLocalVector (new b2Vec2 (worldPhysicsX, worldPhysicsY)) );
         
         var circleDef:b2CircleDef = new b2CircleDef ();
         circleDef.localPosition.SetV(_LocalPosition);
         circleDef.radius = physicsRadius;
         
         if (params != null)
         {
            circleDef.density = params.mDensity;
            circleDef.friction = params.mFriction;
            circleDef.restitution = params.mRestitution;
         }
         else
         {
            circleDef.density = 1.0;
            circleDef.friction = 0.1;
            circleDef.restitution = 0.2;
         }
         
         //circleDef.filter.groupIndex = 
         
         _b2Shape = mPhysicsProxyBody._b2Body.CreateShape (circleDef);
         
         _b2Shape.SetUserData (this);
      }
      
      
      
   }
}
