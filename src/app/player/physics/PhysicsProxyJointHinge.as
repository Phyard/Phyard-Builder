
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.b2Vec2;
   
   import player.entity.SubEntityJointAnchor;
   
   public class PhysicsProxyJointHinge extends PhysicsProxyJoint
   {
      internal var _b2RevoluteJoint:b2RevoluteJoint = null;
      
      public function PhysicsProxyJointHinge (phyEngine:PhysicsEngine):void
      {
         super (phyEngine);
      }
      
      override public function Destroy ():void
      {
         if (_b2RevoluteJoint != null)
         {
            mPhysicsEngine._b2World.DestroyJoint (_b2RevoluteJoint);
            
            _b2RevoluteJoint = null;
         }
      }
      
      override internal function GetB2joint ():b2Joint
      {
         return _b2RevoluteJoint;
      }
      
//========================================================================
//    build
//========================================================================
      
      public function BuildHinge (
                  anchor1:SubEntityJointAnchor, anchor2:SubEntityJointAnchor, collideConnected:Boolean, 
                  enableLimits:Boolean, lowerAngle:Number, upperAngle:Number, 
                  enableMotor:Boolean, motorSpeed:Number, maxMotorTorque:Number
               ):void
      {
         // ..
         var proxyShape1:PhysicsProxyShape = anchor1.GetShape () == null ? null : anchor1.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         var proxyShape2:PhysicsProxyShape = anchor2.GetShape () == null ? null : anchor2.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         
         // ...
         var body1:b2Body = proxyShape1 == null ? mPhysicsEngine._b2GroundBody : proxyShape1.mProxyBody._b2Body;
         var body2:b2Body = proxyShape2 == null ? mPhysicsEngine._b2GroundBody : proxyShape2.mProxyBody._b2Body;
         
         // ...
         var hingeJointDef:b2RevoluteJointDef = new b2RevoluteJointDef ();
         
         hingeJointDef.bodyA = body1;
         hingeJointDef.bodyB = body2;
         hingeJointDef.localAnchorA = body1.GetLocalPoint(b2Vec2.b2Vec2_From2Numbers (anchor1.GetPositionX (), anchor1.GetPositionY ()));
         hingeJointDef.localAnchorB = body2.GetLocalPoint(b2Vec2.b2Vec2_From2Numbers (anchor2.GetPositionX (), anchor2.GetPositionY ()));
         hingeJointDef.referenceAngle = body2.GetAngle() - body1.GetAngle();
         
         hingeJointDef.collideConnected = collideConnected;
         
         hingeJointDef.enableLimit = enableLimits;
         hingeJointDef.lowerAngle = lowerAngle;
         hingeJointDef.upperAngle = upperAngle;
         
         hingeJointDef.enableMotor = enableMotor;
         hingeJointDef.motorSpeed = motorSpeed;
         hingeJointDef.maxMotorTorque = maxMotorTorque;
         
         _b2RevoluteJoint = mPhysicsEngine._b2World.CreateJoint(hingeJointDef) as b2RevoluteJoint;
         
         _b2RevoluteJoint.SetUserData (this);
      }
      
//========================================================================
// 
//========================================================================
      
      public function GetJointAngle ():Number
      {
         return _b2RevoluteJoint.GetJointAngle ();
      }
      
      public function SetMotorSpeed (motorSpeed:Number):void
      {
         _b2RevoluteJoint.SetMotorSpeed (motorSpeed);
      }
   }
   
}


