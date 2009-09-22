
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   import Box2D.b2WorldPool;
   
   import Box2dEx.Helper.b2eWorldAABBQueryCallback;
   
   public class SelectionEngine 
   {
      
//=================================================================
//   
//=================================================================
      
      public var _b2World:b2World; // used within package
      
      public function SelectionEngine (lowerPoint:Point, upperPoint:Point, world_hints:Object):void
      {
         var worldAABB:b2AABB = new b2AABB();
         worldAABB.lowerBound.Set(lowerPoint.x, lowerPoint.y);
         worldAABB.upperBound.Set(upperPoint.x, upperPoint.y);
         
         //var gravity:b2Vec2 = new b2Vec2(0.0, 9.8 * 2);
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.0, 9.8 * 2);
         var doSleep:Boolean = true;
         
         var world_def:b2WorldDef = new b2WorldDef (world_hints.mPhysicsShapesPotentialMaxCount, world_hints.mPhysicsShapesPopulationDensityLevel);
         
         //_b2World = new b2World(worldAABB, gravity, doSleep);
         //_b2World = CreateB2World (worldAABB, gravity, doSleep);
         _b2World = b2WorldPool.AllocB2World (worldAABB, gravity, doSleep, world_def);
      }
      
      public function Destroy ():void
      {
         //DestroyB2World ();
         b2WorldPool.ReleaseB2World (_b2World);
         
         _b2World = null;
      }
      
      public function CreateProxyGeneral ():SelectionProxy 
      {
         return new SelectionProxy (this);
      }
      
      public function CreateProxyCircle ():SelectionProxyCircle 
      {
         return new SelectionProxyCircle (this);
      }
      
      public function CreateProxyPolygon ():SelectionProxyPolygon 
      {
         return new SelectionProxyPolygon (this);
      }
      
      public function CreateProxyRectangle ():SelectionProxyRectangle 
      {
         return new SelectionProxyRectangle (this);
      }
      
//======================================================================================
//   select
//======================================================================================
      
      public function GetObjectsIntersectWithRegion (x1:Number, y1:Number, x2:Number, y2:Number):Array
      {
         var centerX:Number = (x1 + x2) * 0.5;
         var centerY:Number = (y1 + y2) * 0.5;
         var halfWidth:Number = (x2 - x1) * 0.5; if (halfWidth < 0) halfWidth = - halfWidth;
         var halfHeight:Number = (y2 - y1) * 0.5; if (halfHeight < 0) halfHeight = - halfHeight;
         
       // ...
         var oldContactListener:b2ContactListener = _b2World.GetContactListener ();
         
         var selProxyRect:_SelectionProxyRectangleForRegionSelection = new _SelectionProxyRectangleForRegionSelection (this);
         selProxyRect.RebuildRectangle (0, centerX, centerY, halfWidth, halfHeight);
         var tempContactListener:_ContactListenerForRegionSelection = new _ContactListenerForRegionSelection (selProxyRect._b2Body);
         _b2World.SetContactListener (tempContactListener);
         _b2World.Step (0, 1, 1);
         selProxyRect.Destroy ();
         
         _b2World.SetContactListener (oldContactListener);
         
         var objectArray:Array = tempContactListener.mIntersectedBodies;
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            var selProxy:SelectionProxy = ((objectArray [i] as b2Body).GetUserData ()) as SelectionProxy;
            objectArray [i] = selProxy.mUserData;
         }
         
         return objectArray;
      }
      
      
      public function GetObjectsAtPoint (pointX:Number, pointY:Number):Array
      {
         var fixtures:Array = b2eWorldAABBQueryCallback.GetFixturesContainPoint (_b2World, b2Vec2.b2Vec2_From2Numbers (pointX, pointY));
         var num_fixtures:int = fixtures.length;
         var fixture:b2Fixture;
         var body:b2Body;
         
         var objectArray:Array = new Array ();
         
         for (var i:int = 0; i < num_fixtures; ++ i)
         {
            fixture = fixtures [i]
            body = fixture.GetBody();
            var selProxy:SelectionProxy = body.GetUserData () as SelectionProxy;
            
            if (selProxy.IsSelectable ())
            {
               objectArray.push (selProxy.mUserData);
            }
         }
         
         return objectArray;
      }
      
      
      
   }
}
