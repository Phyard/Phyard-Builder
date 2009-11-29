
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   
   import player.entity.EntityJoint;
   
   public class PhysicsProxyJoint extends PhysicsProxy
   {
      public function PhysicsProxyJoint (phyEngine:PhysicsEngine):void
      {
         super (phyEngine);
      }
      
      internal function GetB2joint ():b2Joint
      {
         return null;
      }
      
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
