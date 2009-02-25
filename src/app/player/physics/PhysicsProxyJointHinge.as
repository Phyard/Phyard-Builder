
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Vec2;
   
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   
   public class PhysicsProxyJointHinge extends PhysicsProxyJoint
   {
      
      public function PhysicsProxyJointHinge (phyEngine:PhysicsEngine, 
                                        proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody, 
                                        anchorPhysicsPosX:Number, anchorPhysicsPosY:Number, 
                                        params:Object):void
      {
         super (phyEngine, proxyBody1, proxyBody2);
         
         var hingeJointDef:b2RevoluteJointDef = new b2RevoluteJointDef ();
         
         var body1:b2Body = proxyBody1 == null ? mPhysicsEngine._b2World.GetGroundBody () : proxyBody1._b2Body;
         var body2:b2Body = proxyBody2 == null ? mPhysicsEngine._b2World.GetGroundBody () : proxyBody2._b2Body;
         
         hingeJointDef.Initialize(body1, body2, new b2Vec2 (anchorPhysicsPosX, anchorPhysicsPosY));
         
         hingeJointDef.collideConnected = params.mCollideConnected;
         
         hingeJointDef.enableLimit = params.mEnableLimits;
         hingeJointDef.lowerAngle = params.mLowerAngle;
         hingeJointDef.upperAngle = params.mUpperAngle;
         
         hingeJointDef.enableMotor = params.mEnableMotor;
         hingeJointDef.motorSpeed = params.mMotorSpeed;
         if (params.mMaxMotorTorque < 0)
            hingeJointDef.maxMotorTorque = 0;
         else if (params.mMaxMotorTorque < 0x7FFFFFFF)
            hingeJointDef.maxMotorTorque = int(params.mMaxMotorTorque); // to be compatible with earlier versions ( version < v1.04 )
         else
            hingeJointDef.maxMotorTorque = params.mMaxMotorTorque;
         
         _b2Joint = mPhysicsEngine._b2World.CreateJoint(hingeJointDef) as b2RevoluteJoint;
         
         _b2Joint.SetUserData (this);
         
         // ...
         
         //var distanceJointDef:b2DistanceJointDef = new b2DistanceJointDef ();
         //
         //distanceJointDef.Initialize(body1, body2, new b2Vec2 (anchorPhysicsPosX, anchorPhysicsPosY), new b2Vec2 (anchorPhysicsPosX, anchorPhysicsPosY));
         //
         //distanceJointDef.collideConnected = params.mCollideConnected;
         //
         //mPhysicsEngine._b2World.CreateJoint(distanceJointDef);
      }
      
      public function IsLimitsEnabled ():Boolean
      {
         return (_b2Joint as b2RevoluteJoint).IsLimitEnabled ();
      }
      
      public function GetLowerLimit ():Number
      {
         return (_b2Joint as b2RevoluteJoint).GetLowerLimit ();
      }
      
      public function GetUpperLimit ():Number
      {
         return (_b2Joint as b2RevoluteJoint).GetUpperLimit ();
      }
      
      public function IsMotorEnabled ():Boolean
      {
         return (_b2Joint as b2RevoluteJoint).IsMotorEnabled ();
      }
      
      public function GetMotorSpeed ():Number
      {
         return (_b2Joint as b2RevoluteJoint).GetMotorSpeed ();
      }
      
      public function SetMotorSpeed (speed:Number):void
      {
         (_b2Joint as b2RevoluteJoint).SetMotorSpeed (speed);
      }
      
      public function GetJointAngle ():Number
      {
         return (_b2Joint as b2RevoluteJoint).GetJointAngle ();
      }
   }
   
}


