
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   import Box2D.Common.Math.*;
   import Box2D.Common.*;

   import Box2D.Dynamics.b2ContactListener;
   
   public class _ContactListener extends b2ContactListener
   {
      private var mPhysicsEngine:PhysicsEngine;
      
      public function _ContactListener (phyEngine:PhysicsEngine)
      {
         mPhysicsEngine = phyEngine;
      }
      
      /// Called when a contact point is added. This includes the geometry
      /// and the forces.
      override public function Add(point:b2ContactPoint) : void
      {
         var shape1:b2Shape = point.shape1;
         var shape2:b2Shape = point.shape2;
         var userdata1:Object = shape1.GetUserData ();
         var userdata2:Object = shape2.GetUserData ();
         
         mPhysicsEngine.OnShapeCollision (userdata1 as PhysicsProxyShape, userdata2 as PhysicsProxyShape);
      }
      
      /// Called when a contact point persists. This includes the geometry
      /// and the forces.
      override public function Persist(point:b2ContactPoint) : void
      {
         Add (point);
      }
      
      /// Called when a contact point is removed. This includes the last
      /// computed geometry and forces.
      override public function Remove(point:b2ContactPoint) : void
      {
      }
      
      /// Called after a contact point is solved.
      override public function Result(point:b2ContactResult) : void
      {
      }
   }
 }

