
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class PhysicsProxyJointDistance extends PhysicsProxyJoint
   {
      
      public function PhysicsProxyJointDistance (phyEngine:PhysicsEngine, proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody, 
                                        anchorPhysicsPosX1:Number, anchorPhysicsPosY1:Number, anchorPhysicsPosX2:Number, anchorPhysicsPosY2:Number, 
                                        params:Object):void
      {
         super (phyEngine, proxyBody1, proxyBody2);
         
         var distanceJointDef:b2DistanceJointDef = new b2DistanceJointDef ();
         
         var body1:b2Body = proxyBody1 == null ? mPhysicsEngine._b2World.GetGroundBody () : proxyBody1._b2Body;
         var body2:b2Body = proxyBody2 == null ? mPhysicsEngine._b2World.GetGroundBody () : proxyBody2._b2Body;
         
         distanceJointDef.Initialize(body1, body2, new b2Vec2 (anchorPhysicsPosX1, anchorPhysicsPosY1), new b2Vec2 (anchorPhysicsPosX2, anchorPhysicsPosY2));
         distanceJointDef.collideConnected = true;
         
         _b2Joint = mPhysicsEngine._b2World.CreateJoint(distanceJointDef) as b2DistanceJoint;
         
         _b2Joint.SetUserData (this);
      }
      
      
   }
   
}
