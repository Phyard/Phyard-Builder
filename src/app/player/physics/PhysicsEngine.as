
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.b2Vec2;
   import Box2D.Collision.b2AABB;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2ContactManager;
   
   import Box2D.Dynamics.b2ContactFilter;
   import Box2D.Dynamics.b2ContactListener;
   import Box2D.Dynamics.b2DestructionListener;
   
   import Box2D.Common.b2Settings;
   
   import Box2D.b2WorldPool;
   
   import Box2dEx.Helper.b2eWorldAABBQueryCallback;
   import Box2dEx.Helper.b2eWorldHelper;
   
   import player.entity.EntityShape;
   
   public class PhysicsEngine
   {
      
//=================================================================
//   
//=================================================================
      
      internal var _b2World:b2World; // used within package
      internal var _b2GroundBody:b2Body;
      
      private var mContactListener:_ContactListener;
      private var mContactFilter:_ContactFilter;
      
      public function PhysicsEngine ():void
      {
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0, 0);
         
         _b2World = b2WorldPool.AllocB2World (gravity);
         _b2GroundBody = _b2World.CreateBody(new b2BodyDef());
         
         mContactListener = new _ContactListener ();
         _b2World.SetContactListener(mContactListener);
         
         mContactFilter = new _ContactFilter ();
         _b2World.SetContactFilter (mContactFilter);
      }
      
      public function SetShapeCollideFilterFunctions (shouldCollide:Function):void
      {
         mContactFilter.SetFilterFunctions (shouldCollide);
      }
      
      public function SetShapeContactEventHandlingFunctions (contactBeginFunc:Function, contactEndFunc:Function):void
      {
         mContactListener.SetHandlingFunctions (contactBeginFunc, contactEndFunc);
      }
      
//=================================================================
//   
//=================================================================
      
      public function Update (escapedTime:Number):void
      {
         //(_b2World.m_contactListener as _ContactListener).Reset ();
         //_b2World.Step (escapedTime, 30); // v2.01
         _b2World.Step (escapedTime, 8, 3, true); // v2.10
      }
      
//=================================================================
//   
//=================================================================
      
      public function Destroy ():void
      {
         if (_b2World != null)
         {
            if (_b2World.GetBodyCount () > 0)
            {
               _b2World.DestroyBody (_b2World.GetBodyList ());
            }
            
            b2WorldPool.ReleaseB2World (_b2World);
            
            _b2World = null;
            _b2GroundBody = null;
         }
      }
      
//=================================================================
//   
//=================================================================
      
      public function SetGravity (magnitude:Number, angle:Number):void
      {
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (magnitude * Math.cos (angle), magnitude * Math.sin (angle));
         
         _b2World.SetGravity (gravity);
      }
      
      public function SetGravityByVector (gx:Number, gy:Number):void
      {
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (gx, gy);
         
         _b2World.SetGravity (gravity);
      }
      
      public function WakeUpAllBodies ():void
      {
         _b2World.WakeUpAllBodies ();
      }
      
      public function GetActiveMovableBodiesCount (excludeBodiesConnectedWithJoints:Boolean = false):uint
      {
         var count:int = 0;
         for (var b:b2Body = _b2World.m_bodyList; b != null; b = b.m_next)
         {
            if ( b.IsStatic () )
               continue;
            
            if (excludeBodiesConnectedWithJoints && b.m_jointList != null)
               continue;
            
            if ( ! b.IsAwake () )
               continue;
            
            ++ count;
         }
         
         return count;
      }
      
      public function FlagForFilteringForAllContacts ():void
      {
         _b2World.FlagForFilteringForAllContacts ();
      }
      
//=================================================================
//   
//=================================================================
      
      // now, the physics package contains some references of entity package, such as PhysicsProxyBody.mEntityBody, PhysicsProxyShape.mEntityShape, PhysicsProxyJoint.mEntityJoint.
      // So this is not a perfect encapsulation. But over-encapsulating will bring some inefficiences. ...
      
      public function GetShapesAtPoint (physicsWorldX:Number, physicsWorldY:Number):Array
      {
         var vertex:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (physicsWorldX,physicsWorldY);
         
         var fixtures:Array = b2eWorldAABBQueryCallback.GetFixturesContainPoint (_b2World, vertex);
         
         var shapes:Array = new Array ();
         
         var entityShape:EntityShape;
         for (var i:int = 0; i < fixtures.length; ++ i)
         {
            entityShape = ((fixtures [i] as b2Fixture).GetUserData () as PhysicsProxyShape).GetEntityShape ();
            if (shapes.indexOf (entityShape) < 0)
            {
               shapes.push (entityShape);
            }
         }
         
         return shapes;
      }
      
   }
   
}
