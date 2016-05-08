
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   import Box2D.Common.*;
   
   import player.trigger.Parameter;
   import player.trigger.Parameter_DirectConstant;
   import player.trigger.CoreClassesHub;
   
   public class _ContactListener extends b2ContactListener
   {
      internal var _OnShapeContactStarted:Function = OnBegin_Default;
      internal var _OnShapeContactFinished:Function = OnEnd_Default;
      internal var _OnShapeCollidePreSolve:Function = null;
         internal var _GetHandlePreSolveCollidingEventData:Function = null; // have to be set
      internal var _OnShapeCollidePostSolved:Function = null;
         internal var _GetHandlePostSolveCollidingEventData:Function = null; // have to be set
      
      public function _ContactListener ()
      {
      }
      
      internal function OnBegin_Default (shape1:PhysicsProxyShape, shape2:PhysicsProxyShape):void
      {
      }
      
      internal function OnEnd_Default (shape1:PhysicsProxyShape, shape2:PhysicsProxyShape):void
      {
      }
      
      
//=======================================================
// v.2.10
//
//=======================================================

      /// Called when two fixtures begin to touch.
      override public function BeginContact(contact:b2Contact):void 
      {
         _OnShapeContactStarted (contact.GetFixtureA ().GetUserData () as PhysicsProxyShape, contact.GetFixtureB ().GetUserData () as PhysicsProxyShape);
      }

      /// Called when two fixtures cease to touch.
      override public function EndContact(contact:b2Contact):void 
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
      override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void 
      {
         if (_OnShapeCollidePreSolve == null)
            return;
         
         var shape1:PhysicsProxyShape = contact.GetFixtureA ().GetUserData () as PhysicsProxyShape;
         var shape2:PhysicsProxyShape = contact.GetFixtureB ().GetUserData () as PhysicsProxyShape;
         
         var data:Object = _GetHandlePreSolveCollidingEventData (shape1, shape2);
         
         if (data == null)
            return;
         
         contact.GetWorldManifold (worldManifold);
         
         var manifold:b2Manifold = contact.GetManifold ();
         b2Collision.b2GetPointStates (state1, state2, oldManifold, manifold);
         
         var count:int = manifold.pointCount;
         
         mColldingSolveEventHandlerValueSource0.mValueObject = shape1.GetEntityShape ();
         mColldingSolveEventHandlerValueSource1.mValueObject = shape2.GetEntityShape ();
         mColldingSolveEventHandlerValueSource2.mValueObject = count;
         
         for (var i:int = 0; i < count; ++i)
         {
            var state:int = state2 [i];
            if (state == b2Collision.b2_addState || state == b2Collision.b2_persistState)
            {
               var p:b2Vec2 = worldManifold.points [i];
               var n:b2Vec2 = worldManifold.normal;
               var mp:b2ManifoldPoint = manifold.points [i];
               //mp.normalImpulse;
               //mp.tangentImpulse;
               //trace ("=================== p = " + p + ", n = " + n + ", np = " + mp.normalImpulse + ", tp = " + mp.tangentImpulse);
               
               mColldingSolveEventHandlerValueSource3.mValueObject = i;
               mColldingSolveEventHandlerValueSource4.mValueObject = p.x;
               mColldingSolveEventHandlerValueSource5.mValueObject = p.y;
               mColldingSolveEventHandlerValueSource6.mValueObject = n.x;
               mColldingSolveEventHandlerValueSource7.mValueObject = n.y;
               
               _OnShapeCollidePreSolve (data, mContactEventHandlerValueSourceList);
            }
            //else
            //{
            //   trace ("=================== ");
            //}
         }
      }
      
      private static var worldManifold:b2WorldManifold = new b2WorldManifold ();
      private static var state1:Array = new Array (b2Settings.b2_maxManifoldPoints);
      private static var state2:Array = new Array (b2Settings.b2_maxManifoldPoints);

      /// This lets you inspect a contact after the solver is finished. This is useful
      /// for inspecting impulses.
      /// Note: the contact manifold does not include time of impact impulses, which can be
      /// arbitrarily large if the sub-step is small. Hence the impulse is provided explicitly
      /// in a separate data structure.
      /// Note: this is only called for contacts that are touching, solid, and awake.
      override public function PostSolve(contact:b2Contact, impulseb:b2ContactImpulse):void 
      {
         if (_OnShapeCollidePostSolved == null)
            return;
         
         var shape1:PhysicsProxyShape = contact.GetFixtureA ().GetUserData () as PhysicsProxyShape;
         var shape2:PhysicsProxyShape = contact.GetFixtureB ().GetUserData () as PhysicsProxyShape;
         
         var data:Object = _GetHandlePostSolveCollidingEventData (shape1, shape2);
         
         if (data == null)
            return;
            
         contact.GetWorldManifold (worldManifold);
         
         var manifold:b2Manifold = contact.GetManifold ();
         
         var count:int = manifold.pointCount;
         
         mColldingSolveEventHandlerValueSource0.mValueObject = shape1.GetEntityShape ();
         mColldingSolveEventHandlerValueSource1.mValueObject = shape2.GetEntityShape ();
         mColldingSolveEventHandlerValueSource2.mValueObject = count;
         
         for (var i:int = 0; i < count; ++i)
         {
            var p:b2Vec2 = worldManifold.points [i];
            var n:b2Vec2 = worldManifold.normal;
            // impulseb.normalImpulses [i]
            // impulseb.tangentImpulses [i]
            
            //var mp:b2ManifoldPoint = manifold.points [i];
            //mp.normalImpulse;
            //mp.tangentImpulse;
            //trace ("+++++++++++++++++++ p = " + p + ", n = " + n + ", np = " + mp.normalImpulse + ", tp = " + mp.tangentImpulse + ", np2 = " + impulseb.normalImpulses [i] + ", tp2 = " + impulseb.tangentImpulses [i]);
            
            mColldingSolveEventHandlerValueSource3.mValueObject = i;
            mColldingSolveEventHandlerValueSource4.mValueObject = p.x;
            mColldingSolveEventHandlerValueSource5.mValueObject = p.y;
            mColldingSolveEventHandlerValueSource6.mValueObject = n.x;
            mColldingSolveEventHandlerValueSource7.mValueObject = n.y;
            mColldingSolveEventHandlerValueSource8.mValueObject = impulseb.normalImpulses [i];
            mColldingSolveEventHandlerValueSource9.mValueObject = impulseb.tangentImpulses [i];
            
            _OnShapeCollidePostSolved (data, mContactEventHandlerValueSourceList);
         }
      }
      
      // moved from World_ContactEventHandling for better performance

      private var mColldingSolveEventHandlerValueSource9:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, null);
      private var mColldingSolveEventHandlerValueSource8:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, mColldingSolveEventHandlerValueSource9);
      private var mColldingSolveEventHandlerValueSource7:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, mColldingSolveEventHandlerValueSource8);
      private var mColldingSolveEventHandlerValueSource6:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, mColldingSolveEventHandlerValueSource7);
      private var mColldingSolveEventHandlerValueSource5:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, mColldingSolveEventHandlerValueSource6);
      private var mColldingSolveEventHandlerValueSource4:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, mColldingSolveEventHandlerValueSource5);
      private var mColldingSolveEventHandlerValueSource3:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, mColldingSolveEventHandlerValueSource4);
      private var mColldingSolveEventHandlerValueSource2:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kNumberClassDefinition,    0, mColldingSolveEventHandlerValueSource3);
      private var mColldingSolveEventHandlerValueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kEntityClassDefinition, null, mColldingSolveEventHandlerValueSource2);
      private var mColldingSolveEventHandlerValueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kEntityClassDefinition, null, mColldingSolveEventHandlerValueSource1);
      private var mContactEventHandlerValueSourceList:Parameter = mColldingSolveEventHandlerValueSource0;

   }
 }

