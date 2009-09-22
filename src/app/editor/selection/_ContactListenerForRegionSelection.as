
package editor.selection {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   //import Box2D.Common.*;
   import Box2D.Common.*;
   
   public class _ContactListenerForRegionSelection implements b2ContactListener
   {
      public var mIntersectedBodies:Array;
      
      private var mCollideWithBody:b2Body;
      
      public function _ContactListenerForRegionSelection (b2body:b2Body)
      {
         mCollideWithBody = b2body;
         
         mIntersectedBodies = new Array ();
      }
      
//======================================================
// v2.01
//======================================================
      /*
      private function CollectContactBody (point:b2ContactPoint):void
      {
          var body1:b2Body = point.shape1.GetBody();
          var body2:b2Body = point.shape2.GetBody();
         
         if (body1 == mCollideWithBody && mIntersectedBodies.indexOf (body2) < 0)
            mIntersectedBodies.push (body2);
         if (body2 == mCollideWithBody && mIntersectedBodies.indexOf (body1) < 0)
            mIntersectedBodies.push (body1);
      }
      
      /// Called when a contact point is added. This includes the geometry
      /// and the forces.
      override public function Add(point:b2ContactPoint) : void
      {
         CollectContactBody (point);
      }
      
      /// Called when a contact point persists. This includes the geometry
      /// and the forces.
      override public function Persist(point:b2ContactPoint) : void
      {
         CollectContactBody (point);
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
      */
      
//=======================================================
// v.2.10
//
//=======================================================

      /// Called when two fixtures begin to touch.
      public function BeginContact(contact:b2Contact):void 
      {
          var body1:b2Body = contact.m_fixtureA.GetBody();
          var body2:b2Body = contact.m_fixtureB.GetBody();
         
         if (body1 == mCollideWithBody && mIntersectedBodies.indexOf (body2) < 0)
            mIntersectedBodies.push (body2);
         if (body2 == mCollideWithBody && mIntersectedBodies.indexOf (body1) < 0)
            mIntersectedBodies.push (body1);
      }

      /// Called when two fixtures cease to touch.
      public function EndContact(contact:b2Contact):void 
      {
         // ...
      }

      /// This is called after a contact is updated. This allows you to inspect a
      /// contact before it goes to the solver. If you are careful, you can modify the
      /// contact manifold (e.g. disable contact).
      /// A copy of the old manifold is provided so that you can detect changes.
      /// Note: this is called only for awake bodies.
      /// Note: this is called even when the number of contact points is zero.
      /// Note: this is not called for sensors.
      /// Note: if you set the number of contact points to zero, you will not
      /// get an EndContact callback. However, you may get a BeginContact callback
      /// the next step.
      public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void 
      {
      }

      /// This lets you inspect a contact after the solver is finished. This is useful
      /// for inspecting impulses.
      /// Note: the contact manifold does not include time of impact impulses, which can be
      /// arbitrarily large if the sub-step is small. Hence the impulse is provided explicitly
      /// in a separate data structure.
      /// Note: this is only called for contacts that are touching, solid, and awake.
      public function PostSolve(contact:b2Contact, impulseb:b2ContactImpulse):void 
      {
      }
   }
 }

