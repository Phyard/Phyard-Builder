
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2PrismaticJoint;
   import Box2D.Dynamics.Joints.b2PrismaticJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Vec2;
   
   
   public class PhysicsProxyJointSlider extends PhysicsProxyJoint
   {
      
      public function PhysicsProxyJointSlider (phyEngine:PhysicsEngine, proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody, 
                                        anchorPhysicsPosX1:Number, anchorPhysicsPosY1:Number, anchorPhysicsPosX2:Number, anchorPhysicsPosY2:Number, 
                                        params:Object):void
      {
         super (phyEngine, proxyBody1, proxyBody2);
         
         var prismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef ();
         
         var body1:b2Body = proxyBody1 == null ? mPhysicsEngine._b2World.GetGroundBody () : proxyBody1._b2Body;
         var body2:b2Body = proxyBody2 == null ? mPhysicsEngine._b2World.GetGroundBody () : proxyBody2._b2Body;
         
         var axis:b2Vec2 = new b2Vec2 (anchorPhysicsPosX2 - anchorPhysicsPosX1, anchorPhysicsPosY2 - anchorPhysicsPosY1);
         axis.Normalize ();
         
         prismaticJointDef.Initialize(body1, body2, new b2Vec2 (anchorPhysicsPosX1, anchorPhysicsPosY1), axis);
         
         prismaticJointDef.collideConnected = params.mCollideConnected;
         
         prismaticJointDef.enableLimit      = params.mEnableLimits;
         prismaticJointDef.lowerTranslation = params.mLowerTranslation;
         prismaticJointDef.upperTranslation = params.mUpperTranslation;
         
         prismaticJointDef.enableMotor   = params.mEnableMotor;
         prismaticJointDef.motorSpeed    = params.mMotorSpeed;
         prismaticJointDef.maxMotorForce = 100000000;
         
         _b2Joint = mPhysicsEngine._b2World.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
         
         _b2Joint.SetUserData (this);
      }
      
      public function IsLimitsEnabled ():Boolean
      {
         return (_b2Joint as b2PrismaticJoint).IsLimitEnabled ();
      }
      
      public function GetLowerLimit ():Number
      {
         return (_b2Joint as b2PrismaticJoint).GetLowerLimit ();
      }
      
      public function GetUpperLimit ():Number
      {
         return (_b2Joint as b2PrismaticJoint).GetUpperLimit ();
      }
      
      public function IsMotorEnabled ():Boolean
      {
         return (_b2Joint as b2PrismaticJoint).IsMotorEnabled ();
      }
      
      public function GetMotorSpeed ():Number
      {
         return (_b2Joint as b2PrismaticJoint).GetMotorSpeed ();
      }
      
      public function SetMotorSpeed (speed:Number):void
      {
         (_b2Joint as b2PrismaticJoint).SetMotorSpeed (speed);
      }
      
      public function GetJointTranslation ():Number
      {
         return (_b2Joint as b2PrismaticJoint).GetJointTranslation ();
      }

      
      
   }
}
