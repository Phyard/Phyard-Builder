
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2PrismaticJoint;
   import Box2D.Dynamics.Joints.b2PrismaticJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.b2Vec2;
   
   import player.entity.SubEntityJointAnchor;
   
   public class PhysicsProxyJointSlider extends PhysicsProxyJoint
   {
      internal var _b2PrismaticJoint:b2PrismaticJoint = null;
      
      public function PhysicsProxyJointSlider (phyEngine:PhysicsEngine):void
      {
         super (phyEngine);
      }
      
      override public function Destroy ():void
      {
         if (_b2PrismaticJoint != null)
         {
            mPhysicsEngine._b2World.DestroyJoint (_b2PrismaticJoint);
            
            _b2PrismaticJoint = null;
            _localAnchor2InBody2 = null;
         }
      }
      
      override internal function GetB2joint ():b2Joint
      {
         return _b2PrismaticJoint;
      }
      
      private var _localAnchor2InBody2:b2Vec2 = null;
      /// Get the anchor point on body2 in world coordinates.
      override public function GetAnchorPoint2():Point
      {
         var vec:b2Vec2 = _b2PrismaticJoint.GetBodyB ().GetWorldPoint(_localAnchor2InBody2);
         
         return new Point (vec.x, vec.y);
      }
      
      override public function ReconncetShape (proxyShape:PhysicsProxyShape, isShapeA:Boolean):void
      {
         if (! isShapeA)
         {
            var body2:b2Body = _b2PrismaticJoint.GetBodyB ();
            
            var worldVec:b2Vec2 = body2.GetWorldPoint(_localAnchor2InBody2);
            
            super.ReconncetShape (proxyShape, isShapeA);
            
            _localAnchor2InBody2 = body2.GetLocalPoint(worldVec);
         }
         else
         {
            super.ReconncetShape (proxyShape, isShapeA);
         }
      }
      
//========================================================================
//    build
//========================================================================
      
      public function BuildSlider (
                  anchor1:SubEntityJointAnchor, anchor2:SubEntityJointAnchor, collideConnected:Boolean, 
                  enableLimits:Boolean, lowerTranslation:Number, upperTranslation:Number, 
                  enableMotor:Boolean, motorSpeed:Number, maxMotorForce:Number
               ):void
      {
         // ..
         var proxyShape1:PhysicsProxyShape = anchor1.GetShape () == null ? null : anchor1.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         var proxyShape2:PhysicsProxyShape = anchor2.GetShape () == null ? null : anchor2.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         
         // ...
         var body1:b2Body = proxyShape1 == null ? mPhysicsEngine._b2GroundBody : proxyShape1.mProxyBody._b2Body;
         var body2:b2Body = proxyShape2 == null ? mPhysicsEngine._b2GroundBody : proxyShape2.mProxyBody._b2Body;
         
         // ...
         var axis:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (anchor2.GetPositionX () - anchor1.GetPositionX (), anchor2.GetPositionY () - anchor1.GetPositionY ());
         axis.Normalize ();
         var vec2:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (anchor1.GetPositionX (), anchor1.GetPositionY ());
         
         _localAnchor2InBody2 = body2.GetLocalPoint(b2Vec2.b2Vec2_From2Numbers (anchor2.GetPositionX (), anchor2.GetPositionY ()));
         
         var prismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef ();
         
         prismaticJointDef.bodyA = body1;
         prismaticJointDef.bodyB = body2;
         prismaticJointDef.localAnchorA = body1.GetLocalPoint(vec2);
         prismaticJointDef.localAnchorB = body2.GetLocalPoint(vec2);
         prismaticJointDef.localAxis1 = body1.GetLocalVector(axis);
         prismaticJointDef.referenceAngle = body2.GetAngle() - body1.GetAngle();
         
         prismaticJointDef.collideConnected = collideConnected;
         
         prismaticJointDef.enableLimit = enableLimits;
         prismaticJointDef.lowerTranslation = lowerTranslation;
         prismaticJointDef.upperTranslation = upperTranslation;
         
         prismaticJointDef.enableMotor = enableMotor;
         prismaticJointDef.motorSpeed = motorSpeed;
         prismaticJointDef.maxMotorForce = maxMotorForce;
         
         _b2PrismaticJoint = mPhysicsEngine._b2World.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
         
         _b2PrismaticJoint.SetUserData (this);
      }
      
//========================================================================
// 
//========================================================================
      
      public function GetJointTranslation ():Number
      {
         return _b2PrismaticJoint.GetJointTranslation ();
      }
      
      public function SetMotorSpeed (morotSpeed:Number):void
      {
         _b2PrismaticJoint.SetMotorSpeed (morotSpeed);
      }
      
   }
}
