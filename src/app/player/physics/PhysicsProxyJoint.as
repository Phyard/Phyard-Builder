
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   
   import player.entity.EntityJoint;
   import player.entity.EntityShape;
   
   public class PhysicsProxyJoint extends PhysicsProxy
   {
      public function PhysicsProxyJoint (phyEngine:PhysicsEngine):void
      {
         super (phyEngine);
      }
      
      internal function GetB2joint ():b2Joint
      {
         return null; // to override
      }
      
      public function ReconncetShape (shape:EntityShape, isShapeA:Boolean):void
      {
         var joint:b2Joint = GetB2joint ();
         if (joint == null)
            return;
         
         var proxyShape:PhysicsProxyShape = shape == null ? null : shape.GetPhysicsProxy () as PhysicsProxyShape;
         var body:b2Body = proxyShape == null ? mPhysicsEngine._b2GroundBody : proxyShape.mProxyBody._b2Body;
         
         joint.ChangeJointBody (body, isShapeA);
      }
      
//==================================================================
//
//==================================================================
      
      /// Get the anchor point on body1 in world coordinates.
      public function GetAnchorPoint1():Point
      {
         var b2joint:b2Joint = GetB2joint ();
         var vec:b2Vec2 = b2joint.GetAnchorA ();
         
         return new Point (vec.x, vec.y);
      }

      /// Get the anchor point on body2 in world coordinates.
      public function GetAnchorPoint2():Point
      {
         var b2joint:b2Joint = GetB2joint ();
         var vec:b2Vec2 = b2joint.GetAnchorB ();
         
         return new Point (vec.x, vec.y);
      }
   }
   
}
