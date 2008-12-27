
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class PhysicsProxyBody extends PhysicsProxy
   {
      
      public var _b2Body:b2Body = null; // used internally
      
      public function PhysicsProxyBody (phyEngine:PhysicsEngine, physicsX:Number = 0, physicsY:Number = 0, rotation:Number = 0, params:Object = null):void
      {
         super (phyEngine);
         
         var bodyDef:b2BodyDef = new b2BodyDef ();
         bodyDef.position.Set (physicsX, physicsY);
         bodyDef.angle = rotation;
         _b2Body = mPhysicsEngine._b2World.CreateBody (bodyDef);
         
         _b2Body.SetUserData (this);
      }
      
      
      override public function Destroy ():void
      {
         if (_b2Body != null)
            mPhysicsEngine._b2World.DestroyBody (_b2Body);
      }
      
      public function NotifyDestroyed ():void
      {
         _b2Body = null;
      }
      
      public function UpdateMass ():void
      {
         if (_b2Body != null)
            _b2Body.SetMassFromShapes();
      }
      
      public function GetPosition ():Point
      {
         var point:Point = new Point ();
         
         if (_b2Body != null)
         {
            var vec2:b2Vec2 = _b2Body.GetPosition ();
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
      
      public function GetRotation ():Number
      {
         if (_b2Body != null)
            return _b2Body.GetAngle ();
         else
            return 0;
      }
      
      public function IsStatic ():Boolean
      {
         if (_b2Body != null)
            return _b2Body.m_mass == 0;
         else
            return true;
      }
      
      public function SetBullet (bullet:Boolean):void
      {
         if (_b2Body != null)
         {
            _b2Body.SetBullet (bullet);
            
            trace ("SetBullet: " + bullet);
         }
      }
      
//=================================================================
//    
//=================================================================
      
      
      
   }
   
}
