
package editor.selection {
   
   import flash.geom.Point;
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.runtime.Runtime;
   
   public class SelectionProxy 
   {
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mUserData:Object = null; // used within package
      
      public var _b2Body:b2Body = null; // used within package
      
      protected var mSelectable:Boolean = true;
      
      public function SelectionProxy (selEngine:SelectionEngine):void
      {
         mSelectionEngine = selEngine;
      }
      
      public function SetUserData (userData:Object):void
      {
         mUserData = userData;
      }
      
      public function SetSelectable (selectable:Boolean):void
      {
         mSelectable = selectable;
         
         if (_b2Body == null)
            return;
         
      //
         var fixture:b2Fixture = _b2Body.m_fixtureList;
         
         while (fixture != null)
         {
            fixture.m_filter.groupIndex = mSelectable ? 0 : -1;
            
            fixture = fixture.m_next;
         }
      }
      
      public function IsSelectable ():Boolean
      {
         return mSelectable;
      }
      
      protected function Rebuild_b2Body (pointX:Number, pointY:Number, rotation:Number):void
      {
      //
         if (_b2Body != null)
            mSelectionEngine._b2World.DestroyBody (_b2Body);
         
      //
         var bodyDef:b2BodyDef = new b2BodyDef ();
         bodyDef.position.Set (pointX, pointY);
         bodyDef.angle = rotation;
         bodyDef.type = b2Body.b2_dynamicBody;
         _b2Body = mSelectionEngine._b2World.CreateBody (bodyDef);
         
         _b2Body.SetUserData (this);
      }
      
      public function GetProxyShapesCount ():int
      {
         if (_b2Body == null)
            return 0;
         else
            return _b2Body.m_fixtureCount;
      }
      
      
      
      public function Destroy ():void
      {
         if (_b2Body != null)
            mSelectionEngine._b2World.DestroyBody (_b2Body);
      }
      
      public function ContainsPoint (pointX:Number, pointY:Number):Boolean
      {
         if (_b2Body == null)
            return false;
         
      //
         var fixture:b2Fixture = _b2Body.m_fixtureList;
         var point:b2Vec2 = new b2Vec2 ();
         point.Set (pointX, pointY);
         
         while (fixture != null)
         {
            if (fixture.TestPoint (point))
               return true;
            
            fixture = fixture.m_next;
         }
         
         return false;
      }
      
      // for debug
      public function AddPhysicsShapes (container:Sprite):void
      {
         var fixture:b2Fixture = _b2Body.m_fixtureList;
         var physicsShape:b2Shape;
         
         while (fixture != null)
         {
            physicsShape = fixture.GetShape ();
            
            var visualShape:Shape = new Shape ();
            container.addChild (visualShape);
            
            if (physicsShape is b2CircleShape)
            {
               var circlePhysicsShape:b2CircleShape = physicsShape as b2CircleShape;
               visualShape.x = circlePhysicsShape.m_p.x;
               visualShape.y = circlePhysicsShape.m_p.y;
               var radius:Number = circlePhysicsShape.m_radius;
               GraphicsUtil.DrawEllipse (visualShape, - radius, - radius, radius + radius, radius + radius, 0x0, 1, false);
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
                  
                  GraphicsUtil.DrawLine (visualShape, cx, cy, cx + nx, cy + ny);
               }
               GraphicsUtil.DrawPolygon (visualShape, localPoints, 0x0, 1, false);
            }
            
            fixture = fixture.m_next;
         }
      }
      
//==========================================================================
// append shapes
//==========================================================================
      
      public function Rebuild (centerX:Number = 0, centerY:Number = 0, rotation:Number = 0):void
      {
      //
         Rebuild_b2Body (centerX, centerY, rotation);
      }
      
      public function CreateCircleZone (localX:Number, localY:Number, radius:Number):void
      {
         if (Runtime.mPauseCreateShapeProxy)
            return;
         
      //trace ("------------------- circle");
      //
         var circle_shape:b2CircleShape = new b2CircleShape ();
         circle_shape.m_radius = radius;
         circle_shape.m_p.Set(localX, localY);
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         fixture_def.shape = circle_shape;
         fixture_def.filter.groupIndex =  IsSelectable () ? 0 : -1;
         
         _b2Body.CreateFixture (fixture_def);
      }
      
      public function CreateConvexPolygonZone (localPoints:Array):void
      {
         if (Runtime.mPauseCreateShapeProxy)
            return;
         
      //trace ("------------------- rect");
      //
         var localVertices:Array = new Array (localPoints.length);
         var point:Point;
         
         for (var i:int = 0; i < localPoints.length; ++ i)
         {
            point = localPoints [i];
            localVertices [i] = b2Vec2.b2Vec2_From2Numbers (point.x, point.y);
         }
         
         var polygon_shape:b2PolygonShape = new b2PolygonShape ();
         polygon_shape.Set (localVertices, localVertices.length);
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         fixture_def.shape = polygon_shape;
         fixture_def.filter.groupIndex =  IsSelectable () ? 0 : -1;
         
         _b2Body.CreateFixture (fixture_def);
      }
      
      public function CreateConcavePolygonZone (localPoints:Array):void
      {
         if (Runtime.mPauseCreateShapeProxy)
            return;
         
      //trace ("------------------- polygon");
         var vertexCount:uint = localPoints.length;
         
         if (vertexCount < 3)
            return;
         
         var xPositions:Array = new Array (vertexCount);
         var yPositions:Array = new Array (vertexCount);
         
         var i:int;
         var point:Point;
         
         for (i = 0; i < localPoints.length; ++ i) 
         {
            point = localPoints [i];
            xPositions[i] = point.x;
            yPositions[i] = point.y;
         }
         
         // Create the initial poly
         var polygon:b2Polygon = new b2Polygon(xPositions, yPositions, vertexCount);
         
         var decomposedPolygons:Array = new Array ();
         var numDecomposedPolygons:int = b2Polygon.DecomposeConvex(polygon, decomposedPolygons, vertexCount - 2);
         
         for (i = 0; i < numDecomposedPolygons; ++ i) 
         {
            var localVertices:Array = (decomposedPolygons[i] as b2Polygon).GetQuanlifiedVertices ();
            
            var polygon_shape:b2PolygonShape = new b2PolygonShape ();
            polygon_shape.Set (localVertices, localVertices.length);
            
            var fixture_def:b2FixtureDef = new b2FixtureDef ();
            fixture_def.shape = polygon_shape;
            fixture_def.filter.groupIndex =  IsSelectable () ? 0 : -1;
            
            _b2Body.CreateFixture (fixture_def);
         }
      }
      
      public function CreateLineSegmentZone (localX1:Number, localY1:Number, localX2:Number, localY2:Number, thinkness:Number = 1):void
      {
         if (Runtime.mPauseCreateShapeProxy)
            return;
         
         var dx:Number = localX2 - localX1;
         var dy:Number = localY2 - localY1;
         
         if (Math.abs (dx) < b2Settings.b2_epsilon && Math.abs (dy) < b2Settings.b2_epsilon) // will cause strange behaviour
            return;
         
         var rot:Number = Math.atan2 (dy, dx);
         rot += Math.PI * 0.5;
         
         thinkness *= 0.5;
         dx = thinkness * Math.cos (rot);
         dy = thinkness * Math.sin (rot);
         
         var p1:Point = new Point (localX1 + dx, localY1 + dy);
         var p2:Point = new Point (localX1 - dx, localY1 - dy);
         var p3:Point = new Point (localX2 - dx, localY2 - dy);
         var p4:Point = new Point (localX2 + dx, localY2 + dy);
         
         CreateConvexPolygonZone ([p1, p2, p3, p4]);
      }
      
   }
}
