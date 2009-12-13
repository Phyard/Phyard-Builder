
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Common.b2Vec2;
   import Box2D.Common.b2Settings;
   
   import Box2dEx.Helper.b2eBodyHelper;
   
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
         
         _b2Body = mPhysicsEngine._b2World.CreateBody (bodyDef);b2eBodyHelper;
         
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
      
      public function ResetMass ():void
      {
         _b2Body.ResetMassData ();
      }
      
      public function SetDisplayPosition (posX:Number, posY:Number):void
      {
         _b2Body.SetPosition (posX, posY);
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
      
      public function GetLinearVelocityX ():Number
      {
        return _b2Body.GetLinearVelocity ().x;
      }
      
      public function GetLinearVelocityY ():Number
      {
         return _b2Body.GetLinearVelocity ().y;
      }
      
      public function CoincideWithCentroid ():void
      {
         _b2Body.CoincideWithCentroid ();
      }
      
      public function SetRotation (rotation:Number):void
      {
         _b2Body.SetTransform (null, rotation);
      }
      
      public function GetRotation ():Number
      {
         return _b2Body.GetAngle ();
      }
      
      public function GetAngularVelocity ():Number
      {
         return _b2Body.GetAngularVelocity ();
      }
      
      public function SetPositionAndRotation (posX:Number, posY:Number, rotation:Number):void
      {
         _b2Body.SetTransform (b2Vec2.b2Vec2_From2Numbers (posX, posY), rotation);
      }
      
      public function SetStatic (setStatic:Boolean):void
      {
         _b2Body.SetStatic (setStatic);
      }
      
      public function IsStatic ():Boolean
      {
         return _b2Body.IsStatic ();
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
      
      public function SetFixRotation (fixRotation:Boolean):void
      {
         _b2Body.SetFixedRotation (fixRotation);
      }
      
      public function IsFixRotation ():Boolean
      {
         return _b2Body.IsFixedRotation ();
      }
      
   }
   
}
