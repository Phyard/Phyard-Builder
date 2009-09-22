
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.b2Vec2;
   
   
   public class PhysicsProxyJointDistance extends PhysicsProxyJoint
   {
      
      public function PhysicsProxyJointDistance (phyEngine:PhysicsEngine, proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody, 
                                        anchorPhysicsPosX1:Number, anchorPhysicsPosY1:Number, anchorPhysicsPosX2:Number, anchorPhysicsPosY2:Number, 
                                        params:Object):void
      {
         super (phyEngine, proxyBody1, proxyBody2);
         
         var distanceJointDef:b2DistanceJointDef = new b2DistanceJointDef ();
         
         var body1:b2Body = proxyBody1 == null ? mPhysicsEngine._b2World.m_groundBody : proxyBody1._b2Body;
         var body2:b2Body = proxyBody2 == null ? mPhysicsEngine._b2World.m_groundBody : proxyBody2._b2Body;
         
         distanceJointDef.Initialize(body1, body2, b2Vec2.b2Vec2_From2Numbers (anchorPhysicsPosX1, anchorPhysicsPosY1), b2Vec2.b2Vec2_From2Numbers (anchorPhysicsPosX2, anchorPhysicsPosY2));
         
         distanceJointDef.collideConnected = params.mCollideConnected;
         
         // v2.0
         {
            if ( ! isNaN (params.mStaticLengthRatio) )
            {
               distanceJointDef.length *= params.mStaticLengthRatio;
            }
            if ( ! isNaN (params.mFrequencyHz) )
            {
               distanceJointDef.frequencyHz = params.mFrequencyHz;
            }
            if ( ! isNaN (params.mDampingRatio) )
            {
               distanceJointDef.dampingRatio = params.mDampingRatio;
            }
         }
         
         _b2Joint = mPhysicsEngine._b2World.CreateJoint(distanceJointDef) as b2DistanceJoint;
         
         _b2Joint.SetUserData (this);
      }
      
      public function GetStaticLength ():Number
      {
         return (_b2Joint as b2DistanceJoint).m_length;
      }
      
      public function GetFrequencyHz ():Number
      {
         return (_b2Joint as b2DistanceJoint).m_frequencyHz;
      }
      
   }
   
}
