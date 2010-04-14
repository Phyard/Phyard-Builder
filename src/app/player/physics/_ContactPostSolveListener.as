
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   import Box2D.Common.*;
   
   public class _ContactPostSolveListener implements b2ContactPostSolveListener
   {
      private var _OnPostSolve:Function;
      
      public function _ContactPostSolveListener ()
      {
      }
      
//=======================================================
// v.2.10
//
//=======================================================

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

