
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class PhysicsProxyJoint extends PhysicsProxy
   {
      
      protected var _b2Joint:b2Joint = null;
      
      protected var mPhysicsProxyBody1:PhysicsProxyBody;
      protected var mPhysicsProxyBody2:PhysicsProxyBody;
      
      public function PhysicsProxyJoint (phyEngine:PhysicsEngine, proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody):void
      {
         super (phyEngine);
         
         mPhysicsProxyBody1 = proxyBody1;
         mPhysicsProxyBody2 = proxyBody2;
      }
      
      
      override public function Destroy ():void
      {
         if (_b2Joint != null)
            mPhysicsEngine._b2World.DestroyJoint (_b2Joint);
      }
      
      public function NotifyDestroyed ():void
      {
         _b2Joint = null;
      }
      
      public function GetBody1 ():PhysicsProxyBody
      {
         return mPhysicsProxyBody1;
      }
      
      public function GetBody2 ():PhysicsProxyBody
      {
         return mPhysicsProxyBody2;
      }
      
      public function GetAnchorPoint1 ():Point
      {
         var point:Point = new Point ();
         
         if (_b2Joint != null)
         {
            var vec2:b2Vec2 = _b2Joint.GetAnchor1();
            point.x = vec2.x;
            point.y = vec2.y;
         }
         else
         {
            point.x = 0;
            point.y = 0;
         }
         
         return point;
      }
      
      public function GetAnchorPoint2 ():Point
      {
         var point:Point = new Point ();
         
         if (_b2Joint != null)
         {
            var vec2:b2Vec2 = _b2Joint.GetAnchor2();
            point.x = vec2.x;
            point.y = vec2.y;
         }
         else
         {
            point.x = 0;
            point.y = 0;
         }
         
         return point;
      }
      
   }
   
}
