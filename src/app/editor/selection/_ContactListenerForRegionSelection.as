
package editor.selection {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.*;
   import Box2D.Common.Math.*;
   import Box2D.Common.*;
   
   public class _ContactListenerForRegionSelection extends b2ContactListener
   {
      public var mIntersectedBodies:Array;
      
      private var mCollideWithBody:b2Body;
      
      public function _ContactListenerForRegionSelection (b2body:b2Body)
      {
         mCollideWithBody = b2body;
         
         mIntersectedBodies = new Array ();
      }
      
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
   }
 }

