
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.b2Vec2;
   
   import player.entity.SubEntityJointAnchor;
   
   public class PhysicsProxyJointDistance extends PhysicsProxyJoint
   {
      internal var _b2DistanceJoint:b2DistanceJoint = null;
      
      public function PhysicsProxyJointDistance (phyEngine:PhysicsEngine):void
      {
         super (phyEngine);
      }
      
      
      override public function Destroy ():void
      {
         if (_b2DistanceJoint != null)
         {
            mPhysicsEngine._b2World.DestroyJoint (_b2DistanceJoint);
            
            _b2DistanceJoint = null;
         }
      }
      
      override internal function GetB2joint ():b2Joint
      {
         return _b2DistanceJoint;
      }
      
//========================================================================
//    build
//========================================================================
      
      public function BuildDistance (
                  anchor1:SubEntityJointAnchor, anchor2:SubEntityJointAnchor, collideConnected:Boolean, 
                  staticLengthRatio:Number = 1.0, frequencyHz:Number = 0.0, dampingRatio:Number = 0.0
               ):void
      {
         // ..
         var proxyShape1:PhysicsProxyShape = anchor1.GetShape () == null ? null : anchor1.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         var proxyShape2:PhysicsProxyShape = anchor2.GetShape () == null ? null : anchor2.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         
         // ...
         var body1:b2Body = proxyShape1 == null ? mPhysicsEngine._b2GroundBody : proxyShape1.mProxyBody._b2Body;
         var body2:b2Body = proxyShape2 == null ? mPhysicsEngine._b2GroundBody : proxyShape2.mProxyBody._b2Body;
         
         // ...
         var distanceJointDef:b2DistanceJointDef = new b2DistanceJointDef ();
         
         distanceJointDef.bodyA = body1;
         distanceJointDef.bodyB = body2;
         distanceJointDef.localAnchorA = body1.GetLocalPoint(b2Vec2.b2Vec2_From2Numbers (anchor1.GetPositionX (), anchor1.GetPositionY ()));
         distanceJointDef.localAnchorB = body2.GetLocalPoint(b2Vec2.b2Vec2_From2Numbers (anchor2.GetPositionX (), anchor2.GetPositionY ()));
         distanceJointDef.length = b2Vec2.b2Vec2_From2Numbers (anchor2.GetPositionX () - anchor1.GetPositionX (), anchor2.GetPositionY () - anchor1.GetPositionY ()).Length ();
         
         distanceJointDef.collideConnected = collideConnected;
         
         distanceJointDef.length *= staticLengthRatio;
         distanceJointDef.frequencyHz = frequencyHz;
         distanceJointDef.dampingRatio = dampingRatio;
         
         _b2DistanceJoint = mPhysicsEngine._b2World.CreateJoint(distanceJointDef) as b2DistanceJoint;
         
         _b2DistanceJoint.SetUserData (this);
      }
      
//========================================================================
// 
//========================================================================
      
      public function GetStaticLength ():Number
      {
         return _b2DistanceJoint.GetLength ();
      }
      
      public function GetCurrentLength ():Number
      {
         var anchor1:b2Vec2 = _b2DistanceJoint.GetAnchorA ();
         var anchor2:b2Vec2 = _b2DistanceJoint.GetAnchorB ();
         
         var dx:Number = anchor2.x - anchor1.x;
         var dy:Number = anchor2.y - anchor1.y;
         
         return Math.sqrt (dx * dx + dy * dy);
      }
      
   }
   
}
