
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   import Box2D.Common.*;
   
   public class _ContactListener implements b2ContactListener
   {
      private var mPhysicsEngine:PhysicsEngine;
      
      public function _ContactListener (phyEngine:PhysicsEngine)
      {
         mPhysicsEngine = phyEngine;
      }
      
      private var mNumPoints:int = 0;
      private var mNumPoints_Add:int;
      private var mNumPoints_Persist:int;
      private var mNumPoints_Remove:int;
      
      public function Reset ():void
      {
         //trace ("------------ mNumPoints = " + mNumPoints + " | " + (mNumPoints_Persist + mNumPoints_Add - mNumPoints_Remove));
         //trace ("mNumPoints_Add = " + mNumPoints_Add);
         //trace ("mNumPoints_Persist = " + mNumPoints_Persist);
         //trace ("mNumPoints_Remove = " + mNumPoints_Remove);
         
         mNumPoints_Add = 0;
         mNumPoints_Persist = 0;
         mNumPoints_Remove = 0;
      }
      
//=======================================================
// v.2.10
//
//=======================================================

      /// Called when two fixtures begin to touch.
      public function BeginContact(contact:b2Contact):void 
      {
         if (mPhysicsEngine._OnShapeContactStarted != null)
            mPhysicsEngine._OnShapeContactStarted (contact.GetFixtureA ().GetUserData () as PhysicsProxyShape, contact.GetFixtureB ().GetUserData () as PhysicsProxyShape);
      }

      /// Called when two fixtures cease to touch.
      public function EndContact(contact:b2Contact):void 
      {
         if (mPhysicsEngine._OnShapeContactFinished != null)
            mPhysicsEngine._OnShapeContactFinished (contact.GetFixtureA ().GetUserData () as PhysicsProxyShape, contact.GetFixtureB ().GetUserData () as PhysicsProxyShape);
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

