
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

   }
 }

