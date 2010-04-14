
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   import Box2D.Common.*;
   
   public class _ContactPreSolveListener implements b2ContactPreSolveListener
   {
      private var _OnPreSolve:Function;
      
      public function _ContactPreSolveListener ()
      {
      }
      
//=======================================================
// v.2.10
//
//=======================================================

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

   }
 }

