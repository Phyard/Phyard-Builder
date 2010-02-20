
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.Joints.b2WeldJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.b2Vec2;
   
   import player.entity.SubEntityJointAnchor;
   
   public class PhysicsProxyJointWeld extends PhysicsProxyJoint
   {
      internal var _b2WeldJoint:b2WeldJoint = null;
      
      public function PhysicsProxyJointWeld (phyEngine:PhysicsEngine):void
      {
         super (phyEngine);
      }
      
      override public function Destroy ():void
      {
         if (_b2WeldJoint != null)
         {
            mPhysicsEngine._b2World.DestroyJoint (_b2WeldJoint);
            
            _b2WeldJoint = null;
         }
      }
      
      override internal function GetB2joint ():b2Joint
      {
         return _b2WeldJoint;
      }
      
//========================================================================
//    build
//========================================================================
      
      public function BuildWeld (
                  anchor1:SubEntityJointAnchor, anchor2:SubEntityJointAnchor, collideConnected:Boolean
               ):void
      {
         // ..
         var proxyShape1:PhysicsProxyShape = anchor1.GetShape () == null ? null : anchor1.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         var proxyShape2:PhysicsProxyShape = anchor2.GetShape () == null ? null : anchor2.GetShape ().GetPhysicsProxy () as PhysicsProxyShape;
         
         // ...
         var body1:b2Body = proxyShape1 == null ? mPhysicsEngine._b2GroundBody : proxyShape1.mProxyBody._b2Body;
         var body2:b2Body = proxyShape2 == null ? mPhysicsEngine._b2GroundBody : proxyShape2.mProxyBody._b2Body;
         
         // ...
         var weldJointDef:b2WeldJointDef = new b2WeldJointDef ();
         
         weldJointDef.bodyA = body1;
         weldJointDef.bodyB = body2;
         body1.GetLocalPoint_Output (b2Vec2.b2Vec2_From2Numbers (anchor1.GetPositionX (), anchor1.GetPositionY ()), weldJointDef.localAnchorA);
         body2.GetLocalPoint_Output (b2Vec2.b2Vec2_From2Numbers (anchor2.GetPositionX (), anchor2.GetPositionY ()), weldJointDef.localAnchorB);
         weldJointDef.referenceAngle = body2.GetAngle() - body1.GetAngle();
         
         weldJointDef.collideConnected = collideConnected;
         
         _b2WeldJoint = mPhysicsEngine._b2World.CreateJoint(weldJointDef) as b2WeldJoint;
         
         _b2WeldJoint.SetUserData (this);
      }
      
//========================================================================
// 
//========================================================================
      
   }
   
}


