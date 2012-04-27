
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Common.b2Vec2;
   import Box2D.Common.b2Settings;
   
   import player.entity.EntityBody;
   
   public class PhysicsProxyBody extends PhysicsProxy
   {
      internal var _b2Body:b2Body = null; // used internally
      
      internal var mEntityBody:EntityBody;
      
      public function PhysicsProxyBody (phyEngine:PhysicsEngine, entityBody:EntityBody):void
      {
         super (phyEngine);
         
         var bodyDef:b2BodyDef = new b2BodyDef ();
         bodyDef.position.Set (entityBody.GetPositionX (), entityBody.GetPositionY ());
         bodyDef.angle = entityBody.GetRotation ();
         
         _b2Body = mPhysicsEngine._b2World.CreateBody (bodyDef);
         
         _b2Body.SetUserData (this);
      }
      
      public function GetEntityBody ():EntityBody
      {
         return mEntityBody;
      }
      
      override public function Destroy ():void
      {
         if (_b2Body != null)
         {
            mPhysicsEngine._b2World.DestroyBody (_b2Body);
            
            _b2Body = null;
         }
      }
      
//======================================================================================================
// following functions assume _b2Body != null
//======================================================================================================
      
      public function SetAutoUpdateMass (auto:Boolean):void
      {
         _b2Body.SetAutoUpdateMass (auto);
      }
      
      public function SetViewZeroMassAsStatic (asStatic:Boolean):void
      {
         _b2Body.SetViewZeroMassAsStatic (asStatic);
      }
      
      public function ResetMass ():void
      {
         _b2Body.ResetMassData ();
      }
      
      public function GetMass ():Number
      {
         return _b2Body.GetMass ();
      }
      
      public function GetInertia ():Number
      {
         return _b2Body.GetInertia ();
      }
      
      public function GetPositionX ():Number
      {
        return _b2Body.GetPosition ().x;
      }
      
      public function GetPositionY ():Number
      {
         return _b2Body.GetPosition ().y;
      }
      
      internal function get _physicsPos ():b2Vec2
      {
         return _b2Body.GetPosition ();
      }
      
      public function SetLinearVelocity (vx:Number, vy:Number):void
      {
        _b2Body.SetLinearVelocity (b2Vec2.b2Vec2_From2Numbers (vx, vy));
      }
      
      public function GetLinearVelocityX ():Number
      {
        return _b2Body.GetLinearVelocity ().x;
      }
      
      public function GetLinearVelocityY ():Number
      {
         return _b2Body.GetLinearVelocity ().y;
      }
      
      public function GetRotation ():Number
      {
         return _b2Body.GetAngle ();
      }
      
      public function SetAngularVelocity (av:Number):void
      {
         _b2Body.SetAngularVelocity (av);
      }
      
      public function GetAngularVelocity ():Number
      {
         return _b2Body.GetAngularVelocity ();
      }
      
      public function SetPositionAndRotation (posX:Number, posY:Number, rotation:Number):void
      {
         _b2Body.SetTransform (b2Vec2.b2Vec2_From2Numbers (posX, posY), rotation);
      }
      
      public function CoincideWithCentroid ():Boolean//Point
      {
         return _b2Body.CoincideWithCentroid ();
         
         //var vec:b2Vec2 = _b2Body.CoincideWithCentroid ();
         //if (vec == null)
         //   return null;
         //
         //return new Point (vec.x, vec.y);
      }
      
      public function SetStatic (static:Boolean):void
      {
         _b2Body.SetType (static ? b2Body.b2_staticBody : b2Body.b2_dynamicBody);
         //_b2Body.SetType (static ? b2Body.b2_kinematicBody : b2Body.b2_dynamicBody); // still not collision checking between static and sensors
      }
      
      public function IsStatic ():Boolean
      {
         return _b2Body.GetType () == b2Body.b2_staticBody;
      }
      
      public function SetAsBullet (bullet:Boolean):void
      {
         _b2Body.SetBullet (bullet);
      }
      
      public function IsBullet (bullet:Boolean):Boolean
      {
         return _b2Body.IsBullet ();
      }
      
      public function SetAllowSleeping (allowSleeping:Boolean):void
      {
         _b2Body.SetSleepingAllowed (allowSleeping);
      }
      
      public function IsAllowSleep ():Boolean
      {
         return _b2Body.IsSleepingAllowed ();
      }
      
      public function SetSleeping (sleeping:Boolean):void
      {
         _b2Body.SetAwake (! sleeping);
      }
      
      public function IsSleeping ():Boolean
      {
         return ! _b2Body.IsAwake ();
      }
      
      public function SetFixRotation (fixRotation:Boolean):void
      {
         _b2Body.SetFixedRotation (fixRotation);
      }
      
      public function IsFixRotation ():Boolean
      {
         return _b2Body.IsFixedRotation ();
      }
      
      public function ClearVelocities ():void
      {
         _b2Body.ClearVelocities ();
      }
      
      public function ClearPowers ():void
      {
         _b2Body.ClearPowers ();
      }
      
      public function GetAccForceX ():Number
      {
         return _b2Body.GetAccForce ().x;
      }
      
      public function GetAccForceY ():Number
      {
         return _b2Body.GetAccForce ().y;
      }
      
      public function GetAccTorque ():Number
      {
         return _b2Body.GetAccTorque ();
      }
      
      public function AddForceAtPoint (worldForceX:Number, worldForceY:Number, worldX:Number, worldY:Number):void
      {
         _b2Body.ApplyForce (
                  b2Vec2.b2Vec2_From2Numbers (worldForceX, worldForceY),
                  b2Vec2.b2Vec2_From2Numbers (worldX, worldY)
               );
      }

      public function AddTorque (torque:Number):void
      {
         _b2Body.ApplyTorque (torque);
      }

      public function AddLinearImpulseAtPoint (worldLinearImpulseX:Number, worldLinearImpulseY:Number, worldX:Number, worldY:Number):void
      {
         _b2Body.ApplyLinearImpulse (
                  b2Vec2.b2Vec2_From2Numbers (worldLinearImpulseX, worldLinearImpulseY),
                  b2Vec2.b2Vec2_From2Numbers (worldX, worldY)
               );
      }

      public function AddAngularImpulse (angularImpulse:Number):void
      {
         _b2Body.ApplyAngularImpulse (angularImpulse);
      }

   }
}
