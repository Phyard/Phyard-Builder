
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
   
   import editor.EditorContext;
   
   import common.Transform2D;
   
   public class SelectionProxy 
   {
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mUserData:Object = null; // used within package
      
      public var _b2Body:b2Body = null; // used within package
      
      protected var mPointSelectable:Boolean = true;
      protected var mRegionSelectable:Boolean = true;
      
      public function SelectionProxy (selEngine:SelectionEngine):void
      {
         mSelectionEngine = selEngine;
      }
      
      public function SetUserData (userData:Object):void
      {
         mUserData = userData;
      }
      
      // either point selection or regions selection
      public function SetSelectable (pointSelectable:Boolean, regionSelectable:Boolean):void
      {
         mPointSelectable = pointSelectable;
         mRegionSelectable = regionSelectable;
         
         if (_b2Body == null)
            return;
         
      //
         var fixture:b2Fixture = _b2Body.m_fixtureList;
         
         while (fixture != null)
         {
            fixture.m_filter.categoryBits = GetCategoryBits ();
            fixture.m_filter.maskBits = GetMaskBits ();
            
            fixture = fixture.m_next;
         }
      }
      
      public function IsSelectable ():Boolean
      {
         return mPointSelectable || mRegionSelectable;
      }
      
      public function IsPointSelectable ():Boolean
      {
         return mPointSelectable;
      }
      
      public function IsRegionSelectable ():Boolean
      {
         return mRegionSelectable;
      }
      
      // _SelectionProxyForRegionSelection will override this
      public function GetCategoryBits ():int
      {
         // 1 << 0 is for _SelectionProxyForRegionSelection
         
         if (IsPointSelectable () && IsRegionSelectable ())
            return 1 << 1;
         else if (IsRegionSelectable ())
            return 1 << 2;
         else if (IsPointSelectable ())
            return 1 << 3;
         else
            return 1 << 4;
      }
      
      // _SelectionProxyForRegionSelection will override this
      public function GetMaskBits ():int
      {
         // 0xFFFFFFFE is for _SelectionProxyForRegionSelection
         
         return IsRegionSelectable () ? 1 : 0;
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
               //GraphicsUtil.DrawEllipse (visualShape, - radius, - radius, radius + radius, radius + radius, 0x0, 1, false);
               GraphicsUtil.DrawCircle (visualShape, 0, 0, radius, 0x0, 1, false);
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
// append shapes (with transforms)
//==========================================================================
      
      public function Rebuild (centerX:Number = 0, centerY:Number = 0, rotation:Number = 0):void
      {
         Rebuild_b2Body (centerX, centerY, rotation);
      }
      
      protected function CreateFixture (fixture_def:b2FixtureDef):void
      { 
         fixture_def.filter.categoryBits = GetCategoryBits ();
         fixture_def.filter.maskBits = GetMaskBits ();
         
         fixture_def.userData = this;
         
         _b2Body.CreateFixture (fixture_def);
      }
      
      public function AddCircleShape (radius:Number, transform:Transform2D = null):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
            return;
         
         var centerX:Number = 0.0;
         var centerY:Number = 0.0;
         
         if (transform != null)
         {
            radius *= transform.mScale;
            centerX = transform.mOffsetX;
            centerY = transform.mOffsetY;
            // transofrm.mFlipped and transform.mRotation has no effects on creating circle shapes
         }
         
         var circle_shape:b2CircleShape = new b2CircleShape ();
         
         circle_shape.m_radius = radius;
         circle_shape.m_p.Set(centerX, centerY);
            
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         fixture_def.shape = circle_shape;
         
         CreateFixture (fixture_def);
      }
      
      private static function TransformPolyPoints (transform:Transform2D, points:Array, assureCW:Boolean):void
      {
         var point:Point;
         var i:int;

         // todo: optimize
         
         if (assureCW && transform.mFlipped)
         {
            points = points.reverse (); // to keep CW order
         }
         
         for (i = 0; i < points.length; ++ i)
         {
            point = points [i];
            transform.TransformPoint (point, point);
         }
      }
      
      public function AddConvexPolygonShape (localPoints:Array, transform:Transform2D = null):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
            return;
         
         var vertexCount:uint = localPoints.length;
         
         if (vertexCount < 3)
            return;
         
         if (transform != null)
         {
            TransformPolyPoints (transform, localPoints, true);
         }

         var localVertices:Array = new Array (localPoints.length);
         var point:Point;
         var i:int;

         for (i = 0; i < localPoints.length; ++ i)
         {
            point = localPoints [i];
            localVertices [i] = b2Vec2.b2Vec2_From2Numbers (point.x, point.y);
         }

         var polygon_shape:b2PolygonShape = new b2PolygonShape ();
         polygon_shape.Set (localVertices, localVertices.length);
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         fixture_def.shape = polygon_shape;
         
         CreateFixture (fixture_def);
      }
      
      public function AddConcavePolygonShape (localPoints:Array, transform:Transform2D = null):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
            return;
         
         var vertexCount:uint = localPoints.length;
         
         if (vertexCount < 3)
            return;
         
         if (transform != null)
         {
            TransformPolyPoints (transform, localPoints, false);
         }
         
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
            
            CreateFixture (fixture_def);
         }
      }
      
      public function AddLineSegmentShape (localX1:Number, localY1:Number, localX2:Number, localY2:Number, thinkness:Number = 1.0, transform:Transform2D = null):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
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
         
         AddConvexPolygonShape ([p1, p2, p3, p4], transform);
      }
      
      public function AddRectangleShapeHalfWH (halfWidth:Number, halfHeight:Number, transform:Transform2D = null):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
            return;
         
         var p1:Point = new Point (- halfWidth, - halfHeight);
         var p2:Point = new Point (+ halfWidth, - halfHeight);
         var p3:Point = new Point (+ halfWidth, + halfHeight);
         var p4:Point = new Point (- halfWidth, + halfHeight);
         
         AddConvexPolygonShape ([p1, p2, p3, p4], transform);
      }
      
      public function AddRectangleShape (left:Number, top:Number, width:Number, height:Number, transform:Transform2D = null):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
            return;
         
         var right:Number = left + width;
         var bottom:Number = top + height;
         
         var p1:Point = new Point (left, top);
         var p2:Point = new Point (right, top);
         var p3:Point = new Point (right, bottom);
         var p4:Point = new Point (left, bottom);
         
         AddConvexPolygonShape ([p1, p2, p3, p4], transform);
      }
      
//==========================================================================
// append shapes (not transformed, old implementation, to be rmeoved)
//==========================================================================
      
      public function CreateCircleZone (localX:Number, localY:Number, radius:Number):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
            return;
         
      //trace ("------------------- circle");
      //
         var circle_shape:b2CircleShape = new b2CircleShape ();
         circle_shape.m_radius = radius;
         circle_shape.m_p.Set(localX, localY);
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         fixture_def.shape = circle_shape;
         
         CreateFixture (fixture_def);
      }
      
      public function CreateConvexPolygonZone (localPoints:Array):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
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
         
         CreateFixture (fixture_def);
      }
      
      public function CreateConcavePolygonZone (localPoints:Array):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
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
            
            CreateFixture (fixture_def);
         }
      }
      
      public function CreateLineSegmentZone (localX1:Number, localY1:Number, localX2:Number, localY2:Number, thinkness:Number = 1):void
      {
         if (EditorContext.mPauseCreateShapeProxy)
            return;
         
         var dx:Number = localX2 - localX1;
         var dy:Number = localY2 - localY1;
         
         if (Math.abs (dx) < b2Settings.b2_epsilon && Math.abs (dy) < b2Settings.b2_epsilon) // will cause strange behaviour
            return;
         
         if (thinkness == 0)
         {
            var edge_shape:b2EdgeShape = new b2EdgeShape ();
            edge_shape.Set (b2Vec2.b2Vec2_From2Numbers (localX1, localY1), b2Vec2.b2Vec2_From2Numbers (localX2, localY2));
            
            var fixture_def:b2FixtureDef = new b2FixtureDef ();
            fixture_def.shape = edge_shape;
            
            CreateFixture (fixture_def);
         }
         else
         {
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
      
//==========================================================================
// for building single shape convenience (to be removed)
//==========================================================================
      
      public function RebuildCircle (centerX:Number, centerY:Number, radius:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (centerX, centerY, rotation);
         
         CreateCircleZone (0, 0, radius * scale);
      }
      
      public function RebuildRectangle (centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (centerX, centerY, flipped ? - rotation : rotation);
         
         halfWidth *= scale;
         halfHeight *= scale;
         
         var p1:Point = new Point (- halfWidth, - halfHeight);
         var p2:Point = new Point (+ halfWidth, - halfHeight);
         var p3:Point = new Point (+ halfWidth, + halfHeight);
         var p4:Point = new Point (- halfWidth, + halfHeight);
         
         CreateConvexPolygonZone ([p1, p2, p3, p4]);
      }
      
      public function RebuildRectangle2 (posX:Number, posY:Number, left:Number, top:Number, width:Number, height:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (posX, posY, flipped ? - rotation : rotation);
         
         width *= scale;
         height *= scale;
         left *= scale;
         top *= scale;
         var right:Number = left + width;
         var bottom:Number = top + height;
         if (flipped)
         {
            var temp:Number = left;
            left = - right;
            right = - temp;
         }
         
         var p1:Point = new Point (left, top);
         var p2:Point = new Point (right, top);
         var p3:Point = new Point (right, bottom);
         var p4:Point = new Point (left, bottom);
         
         CreateConvexPolygonZone ([p1, p2, p3, p4]);
      }
      
      public function RebuildConvexPolygon (centerX:Number, centerY:Number, localPoints:Array, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (centerX, centerY, flipped ? - rotation : rotation);
         
         // todo: scale and flip
         
         CreateConvexPolygonZone (localPoints);
      }
      
      public function RebuildConcavePolygon (centerX:Number, centerY:Number, localPoints:Array, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (centerX, centerY, flipped ? - rotation : rotation);
         
         // todo: scale and flip
         
         CreateConcavePolygonZone (localPoints);
      }
      
      public function RebuildLineSegment (centerX:Number, centerY:Number, localX1:Number, localY1:Number, localX2:Number, localY2:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (centerX, centerY, flipped ? - rotation : rotation);
         
         // todo: scale and flip
         
         CreateLineSegmentZone (localX1, localY1, localX2, localY2);
      }
   }
}
