
package player.physics {
   import flash.utils.ByteArray;

   //import Box2D.Collision.b2ContactPoint;
   //import Box2D.Collision.Shapes.b2Shape;
   //import Box2D.Dynamics.Contacts.b2ContactResult;
   //import Box2D.Collision.Shapes.b2FilterData;
   
   import Box2D.Dynamics.b2ContactFilter;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2Filter;
   
   public class _ContactFilter extends b2ContactFilter
   {
      private var _ShouldCollide:Function;
      
      public function _ContactFilter ()
      {
         
      }
      
      public function SetFilterFunctions (shouldCollide:Function):void
      {
         if (shouldCollide != null)
            _ShouldCollide = shouldCollide;
         else
            _ShouldCollide = ShouldCollide_Default;
      }
      
      private function ShouldCollide_Default (shape1:PhysicsProxyShape, shape2:PhysicsProxyShape):Boolean
      {
         return true;
      }
      
//==========================================================
// v2.10
//==========================================================
      
      /// Return true if contact calculations should be performed between these two shapes.
      /// @warning for performance reasons this is only called when the AABBs begin to overlap.
      override public function ShouldCollide(fixtureA:b2Fixture, fixtureB:b2Fixture):Boolean
      {
         return _ShouldCollide (fixtureA.GetUserData () as PhysicsProxyShape, fixtureB.GetUserData () as PhysicsProxyShape);
      }
   }
 }

