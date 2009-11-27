
package editor.selection {
   
   import flash.geom.Point;
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   
   import Box2D.b2WorldPool;
   
   import Box2dEx.Helper.b2eWorldAABBQueryCallback;
   
   import com.tapirgames.util.GraphicsUtil;
   
   public class SelectionEngine 
   {
      
//=================================================================
//   
//=================================================================
      
      public var _b2World:b2World; // used within package
      
      public function SelectionEngine ():void
      {
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.0, 9.8 * 2);
         
         _b2World = b2WorldPool.AllocB2World (gravity);
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
      
      // for debug
      public var mContactsInLastRegionSelecting:Array = null
      
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
         _b2World.Step (0, 0, 0);
         selProxyRect.Destroy ();
         
         _b2World.SetContactListener (oldContactListener);
         
         var objectArray:Array = tempContactListener.mIntersectedBodies;
         mContactsInLastRegionSelecting = tempContactListener.mContacts;
         
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
      
      // for debug
      public function RepaintContactsInLastRegionSelecting (container:Sprite):void
      {
         if (mContactsInLastRegionSelecting == null)
            return;
         
         for (var i0:int = 0; i0 < mContactsInLastRegionSelecting.length; ++ i0)
         {
            var contact:b2Contact = mContactsInLastRegionSelecting [i0];
            var fixture:b2Fixture = contact.m_fixtureA;
            if (fixture.GetBody ().GetUserData () is _SelectionProxyRectangleForRegionSelection)
               fixture = contact.m_fixtureB;
            
            var physicsBody:b2Body = fixture.GetBody ();
            var physicsShape:b2Shape = fixture.GetShape ();
            
            var bodyContainer:Sprite = new Sprite ();
            var visualShape:Shape = new Shape ();
            container.addChild (bodyContainer);
            bodyContainer.addChild (visualShape);
            
            bodyContainer.x = physicsBody.GetPosition ().x;
            bodyContainer.y = physicsBody.GetPosition ().y;
            bodyContainer.rotation = (physicsBody.GetAngle () * 180.0 / Math.PI) % 360.0;
            
            if (physicsShape is b2CircleShape)
            {
               var circlePhysicsShape:b2CircleShape = physicsShape as b2CircleShape;
               visualShape.x = circlePhysicsShape.m_p.x;
               visualShape.y = circlePhysicsShape.m_p.y;
               var radius:Number = circlePhysicsShape.m_radius;
               GraphicsUtil.DrawEllipse (visualShape, - radius, - radius, radius + radius, radius + radius, 0xFF0000, 2, false);
            }
            else if (physicsShape is b2PolygonShape)
            {
               var polygonPhysicsShape:b2PolygonShape = physicsShape as b2PolygonShape;
               var localPoints:Array = new Array (polygonPhysicsShape.m_vertexCount);
               for (var i:int = 0; i < polygonPhysicsShape.m_vertexCount; ++ i)
               {
                  var vertex:b2Vec2 = polygonPhysicsShape.m_vertices [i] as b2Vec2;
                  localPoints [i] = new Point (vertex.x, vertex.y);
                  
                  var i2:int = i + 1;
                  if (i2 >= polygonPhysicsShape.m_vertexCount) i2 = 0;
                  var vertex2:b2Vec2 = polygonPhysicsShape.m_vertices [i2] as b2Vec2;
                  var cx:Number = 0.5 * (vertex.x + vertex2.x);
                  var cy:Number = 0.5 * (vertex.y + vertex2.y);
                  var normal:b2Vec2 = polygonPhysicsShape.m_normals [i] as b2Vec2;
                  var nx:Number = normal.x * 10;
                  var ny:Number = normal.y * 10;
                  
                  GraphicsUtil.DrawLine (visualShape, cx, cy, cx + nx, cy + ny, 0xFF0000, 2);
               }
               GraphicsUtil.DrawPolygon (visualShape, localPoints, 0xFF0000, 2, false);
            }
         }
      }

      
   }
}
