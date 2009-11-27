
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   import Box2D.Common.*;
   
   public class _ContactListener implements b2ContactListener
   {
      private var _OnShapeContactStarted:Function;
      private var _OnShapeContactFinished:Function;
      
      public function _ContactListener ()
      {
         SetHandlingFunctions (null, null);
      }
      
      public function SetHandlingFunctions (onBegin:Function, onEnd:Function):void
      {
         if(onBegin == null)
            _OnShapeContactStarted = OnBegin_Default;
         else
            _OnShapeContactStarted = onBegin;
         
         if (onEnd == null)
            _OnShapeContactFinished = OnEnd_Default;
         else
            _OnShapeContactFinished = onEnd;
      }
      
      private function OnBegin_Default (shape1:PhysicsProxyShape, shape2:PhysicsProxyShape):void
      {
      }
      
      private function OnEnd_Default (shape1:PhysicsProxyShape, shape2:PhysicsProxyShape):void
      {
      }
      
      
//=======================================================
// v.2.10
//
//=======================================================

      /// Called when two fixtures begin to touch.
      public function BeginContact(contact:b2Contact):void 
      {
         _OnShapeContactStarted (contact.GetFixtureA ().GetUserData () as PhysicsProxyShape, contact.GetFixtureB ().GetUserData () as PhysicsProxyShape);
      }

      /// Called when two fixtures cease to touch.
      public function EndContact(contact:b2Contact):void 
      {
         _OnShapeContactFinished (contact.GetFixtureA ().GetUserData () as PhysicsProxyShape, contact.GetFixtureB ().GetUserData () as PhysicsProxyShape);
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

