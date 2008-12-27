
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class SelectionEngine 
   {
      
      public var _b2World:b2World; // used within package
      
      public function SelectionEngine ():void
      {
         var worldAABB:b2AABB = new b2AABB();
         worldAABB.lowerBound.Set(-100000.0, -100000.0);
         worldAABB.upperBound.Set(100000.0, 100000.0);
         
         var gravity:b2Vec2 = new b2Vec2(0.0, 9.8 * 2);
         var doSleep:Boolean = true;
         
         _b2World = new b2World(worldAABB, gravity, doSleep);
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
         var oldContactListener:b2ContactListener = _b2World.m_contactListener;
         
         var selProxyRect:_SelectionProxyRectangleForRegionSelection = new _SelectionProxyRectangleForRegionSelection (this);
         selProxyRect.RebuildRectangle (0, centerX, centerY, halfWidth, halfHeight);
         var tempContactListener:_ContactListenerForRegionSelection = new _ContactListenerForRegionSelection (selProxyRect._b2Body);
         _b2World.SetContactListener (tempContactListener);
         _b2World.Step (0, 1);
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
         var windowSize:Number = 3.0;
         
         var aabb:b2AABB = new b2AABB ();
         aabb.lowerBound.Set (pointX - windowSize, pointY - windowSize);
         aabb.upperBound.Set (pointX + windowSize, pointY + windowSize);
         
         var maxCount:uint = 16;
         var shapes:Array = new Array (maxCount); 
         
         var count:int = _b2World.Query(aabb, shapes, maxCount);
         
         var vertex:b2Vec2 = new b2Vec2 ();
         vertex.Set(pointX, pointY);
         
         var objectArray:Array = new Array ();
         
         for (var i:int = 0; i < count; ++ i)
         {
            var body:b2Body = shapes[i].GetBody();
            var selProxy:SelectionProxy = body.GetUserData () as SelectionProxy;
            
            if (selProxy.IsSelectable () && shapes[i].TestPoint(body.GetXForm(), vertex))
            {
               objectArray.push (selProxy.mUserData);
            }
         }
         
         return objectArray;
      }
      
      
      
   }
}
