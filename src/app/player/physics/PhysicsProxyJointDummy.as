
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2DistanceJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.b2Vec2;
   
   import Box2dEx.Joint.b2eDummyJoint;
   import Box2dEx.Joint.b2eDummyJointDef;
   
   import player.entity.SubEntityJointAnchor;
   
   public class PhysicsProxyJointDummy extends PhysicsProxyJoint
   {
      internal var _b2eDummyJoint:b2eDummyJoint = null;
      
      public function PhysicsProxyJointDummy (phyEngine:PhysicsEngine):void
      {
         super (phyEngine);
      }
      
      override public function Destroy ():void
      {
         if (_b2eDummyJoint != null)
         {
            mPhysicsEngine._b2World.DestroyJoint (_b2eDummyJoint);
            
            _b2eDummyJoint = null;
         }
      }
      
      override internal function GetB2joint ():b2Joint
      {
         return _b2eDummyJoint;
      }
      
//========================================================================
//    build
//========================================================================
      
      public function BuildDummy (
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
         var dummyJointDef:b2eDummyJointDef = new b2eDummyJointDef ();
         
         dummyJointDef.bodyA = body1;
         dummyJointDef.bodyB = body2;
         body1.GetLocalPoint_Output (b2Vec2.b2Vec2_From2Numbers (anchor1.GetPositionX (), anchor1.GetPositionY ()), dummyJointDef.localAnchorA);
         body2.GetLocalPoint_Output (b2Vec2.b2Vec2_From2Numbers (anchor2.GetPositionX (), anchor2.GetPositionY ()), dummyJointDef.localAnchorB);
         
         dummyJointDef.collideConnected = collideConnected;
         
         _b2eDummyJoint = mPhysicsEngine._b2World.CreateJoint(dummyJointDef) as b2eDummyJoint;
         
         _b2eDummyJoint.SetUserData (this);
      }
      
//========================================================================
// 
//========================================================================
      
   }
   
}
