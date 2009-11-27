
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.b2Vec2;
   import Box2D.Common.b2Settings;
   
   //import Box2D.Collision.Shapes.b2CircleDef;
   //import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2FixtureDef;
   
   import Box2D.Collision.Shapes.b2Polygon;
   
   import player.entity.EntityShape;
   
   public class PhysicsProxyShape extends PhysicsProxy
   {
      internal var _b2Fixtures:Array = new Array () // for concave polygon and super shape, there may be mroe than one shapes
      
      internal var mEntityShape:EntityShape;
      
      internal var mProxyBody:PhysicsProxyBody = null;
      
      public function PhysicsProxyShape (proxyBody:PhysicsProxyBody, entityShape:EntityShape):void
      {
         super (proxyBody.mPhysicsEngine);
         
         mProxyBody = proxyBody;
         mEntityShape = entityShape;
      }
      
      public function GetEntityShape ():EntityShape
      {
         return mEntityShape;
      }
      
      override public function Destroy ():void
      {
         var fixture:b2Fixture;
         for (var i:int = 0; i < _b2Fixtures.length; ++ i)
         {
            fixture = _b2Fixtures [i] as b2Fixture;
            fixture.GetBody ().DestroyFixture(fixture);
         }
         
         _b2Fixtures.splice (0, _b2Fixtures.length);
      }
      
      
//========================================================================
// 
//========================================================================
      
      //=======
      
      private var mMass:Number;
      private var mInteria:Number;
      private var mInteriaInBody:Number;
      
      private var mCentroidInBody:b2Vec2;
      private var mCentroidInWorld:b2Vec2;
      
//========================================================================
// 
//========================================================================
      
      // !!! this two variables are static, parallel computing is not supported
      // to optimize
      //private static var _b2CircleShape:b2CircleShape = new b2CircleShape ();
      //private static var _b2PolygonShape:b2PolygonShape = new b2PolygonShape ();
      
      private static const Half_B2_FLT_EPSILON:Number = b2Settings.B2_FLT_EPSILON * 0.5;
      
      public function AddCircle (shapeLocalCenterX:Number, shapeLocalCenterY:Number, radius:Number, buildInterior:Boolean, buildBorder:Boolean, borderThickness:Number):void
      {
         if ( (! buildBorder) && (! buildInterior))
            return;
         
         if (buildBorder)
         {
            var halfBorderThickness:Number = borderThickness * 0.5;
            var outerRadius:Number = radius + halfBorderThickness;
            
            if (buildInterior)
            {
               radius = outerRadius;
            }
            else
            {
               var innerRadius:Number = radius - halfBorderThickness;
               if (innerRadius < b2Settings.B2_FLT_EPSILON)
               {
                  radius = outerRadius;
               }
               else if (borderThickness < b2Settings.B2_FLT_EPSILON)
               {
                  // todo: use polyline instead
                  
                  return;
               }
               else
               {
                  // todo: use polygone instead
                  
                  return;
               }
            }
         }
         else if (! buildInterior)
         {
            return;
         }
         
         if (radius < b2Settings.B2_FLT_EPSILON)
            return;
         
      // shape local to world
         
         var rot:Number = mEntityShape.GetRotation ();
         
         var cos:Number = Math.cos (rot);
         var sin:Number = Math.sin (rot);
         
         var vec:b2Vec2 = new b2Vec2 ();
         vec.x = mEntityShape.GetPositionX () + cos * shapeLocalCenterX - sin * shapeLocalCenterY;
         vec.y = mEntityShape.GetPositionY () + sin * shapeLocalCenterX + cos * shapeLocalCenterY;
         
      // world to body local
         
         vec = mProxyBody._b2Body.GetLocalPoint (vec);
         
      // 
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
         // ...
         var circle_shape:b2CircleShape = new b2CircleShape ();
         circle_shape.m_radius = radius;
         
         circle_shape.m_p.Set (vec.x, vec.y);
         
         fixture_def.shape = circle_shape;
         
         // ...
         var fixture:b2Fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
         _b2Fixtures.push (fixture);
      }
      
      private function ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints:Array):Array
      {
         var rot:Number = mEntityShape.GetRotation ();
         
         var cos:Number = Math.cos (rot);
         var sin:Number = Math.sin (rot);
         
         var count:int = shapeLocalPoints.length;
         var bodyLocalVertexes:Array = new Array (count);
         
         var shapePositionX:Number = mEntityShape.GetPositionX ();
         var shapePositionY:Number = mEntityShape.GetPositionY ();
         
         var point:Point;
         var vec:b2Vec2 = new b2Vec2 ();
         
         for (var i:int = 0; i < count; ++ i)
         {
            point = shapeLocalPoints [i];
            vec.x = shapePositionX + cos * point.x - sin * point.y;
            vec.y = shapePositionY + sin * point.x + cos * point.y;
            
            bodyLocalVertexes [i] = mProxyBody._b2Body.GetLocalPoint (vec);
         }
         
         return bodyLocalVertexes;
      }
      
      public function AddPolyline (shapeLocalPoints:Array, curveThickness:Number, roundEnds:Boolean):void
      {
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
         var bodyLocalVertexes:Array = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
         
         CreatePolyline (fixture_def, bodyLocalVertexes, 0.5 * curveThickness, roundEnds ? 1 : -1);
      }
      
      // close_and_round: 0 means closed, 1 means not closed but round, -1 means not close and not round
      private function CreatePolyline (fixture_def:b2FixtureDef, bodyLocalVertexes:Array, halfCurveThickness:Number, close_and_round:int):void
      {
         var vertexCount:int = bodyLocalVertexes.length;
         if (vertexCount < 1)
            return;
         
         var isClosed:Boolean = close_and_round == 0;
         var isRoundEnds :Boolean = close_and_round != -1; // if isClosed is true, isRoundEnds also is true
         
         var vertex1:b2Vec2;
         var vertex2:b2Vec2;
         var vertexId2:int;
         var dx:Number;
         var dy:Number;
         var fixture:b2Fixture;
         
         var polygon_shape:b2PolygonShape = new b2PolygonShape ();
         
         if (halfCurveThickness + halfCurveThickness < b2Settings.B2_FLT_EPSILON)
         {
            if (vertexCount < 2)
               return;
            
            if (isClosed)
            {
               vertex1 = bodyLocalVertexes [vertexCount - 1];
               vertexId2 = 0;
            }
            else
            {
               vertex1 = bodyLocalVertexes [0];
               vertexId2 = 1;
            }
            
            for (; vertexId2 < vertexCount; ++ vertexId2)
            {
               vertex2 = bodyLocalVertexes [vertexId2];
               dx = vertex2.x - vertex1.x;
               dy = vertex2.y - vertex1.y;
               
               if (dx > - b2Settings.B2_FLT_EPSILON && dx < b2Settings.B2_FLT_EPSILON && dy > - b2Settings.B2_FLT_EPSILON && dy < b2Settings.B2_FLT_EPSILON)
                  continue;
               
               polygon_shape.SetAsEdge (vertex1, vertex2);
               
               fixture_def.shape = polygon_shape;
               
               // ...
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               // ...
               vertex1 = vertex2;
            }
         }
         else
         {
            var buildCircle:Boolean;
            
            if (isClosed)
            {
               vertex1 = bodyLocalVertexes [vertexCount - 1];
               vertexId2 = 0;
               buildCircle = true;
               
               isRoundEnds = false; // some tricky here, just to avoid entering the "if (isRoundEnds)" clause in the end
            }
            else
            {
               vertex1 = bodyLocalVertexes [0];
               vertexId2 = 1;
               
               buildCircle = isRoundEnds;
            }
            
            var inv_length:Number;
            var p0:b2Vec2 = new b2Vec2 ();
            var p1:b2Vec2 = new b2Vec2 ();
            var p2:b2Vec2 = new b2Vec2 ();
            var p3:b2Vec2 = new b2Vec2 ();
            var borderRectVertexes:Array = [p0, p1, p2, p3];
            
            var circle_shape:b2CircleShape = new b2CircleShape ();
            
            for (; vertexId2 < vertexCount; ++ vertexId2)
            {
               vertex2 = bodyLocalVertexes [vertexId2];
               dx = vertex2.x - vertex1.x;
               dy = vertex2.y - vertex1.y;
               
               if (dx > - b2Settings.B2_FLT_EPSILON && dx < b2Settings.B2_FLT_EPSILON && dy > - b2Settings.B2_FLT_EPSILON && dy < b2Settings.B2_FLT_EPSILON)
                  continue;
               
               // rotate vector (dx, dy) by 90 degree => (- dy, dx)
               
               inv_length = halfCurveThickness / Math.sqrt (dx * dx + dy * dy);
               
               dx *= inv_length;
               dy *= inv_length;
               
               // the order should be clockwised. NOTE: !!!  (- dy, dx)
               p0.x = vertex1.x - dy;
               p0.y = vertex1.y + dx;
               p1.x = vertex1.x + dy;
               p1.y = vertex1.y - dx;
               p2.x = vertex2.x + dy;
               p2.y = vertex2.y - dx;
               p3.x = vertex2.x - dy;
               p3.y = vertex2.y + dx;
               
               // ...
               
               polygon_shape.Set (borderRectVertexes, 4);
               
               fixture_def.shape = polygon_shape;
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               // ...
               if (buildCircle)
               {
                  circle_shape.m_radius = halfCurveThickness;
                  
                  circle_shape.m_p.Set (vertex1.x, vertex1.y);
                  
                  fixture_def.shape = circle_shape;
                  
                  fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
                  _b2Fixtures.push (fixture);
               }
               else
               {
                  buildCircle = true; // always build circle for non-end vertexes
               }
               
               // ..
               vertex1 = vertex2;
            }
            
            // for polyline, the circle for the last vertex hasn't been built.
            // for polygon, isRoundEnds is alrady set false above 
            if (isRoundEnds)
            {
               circle_shape.m_radius = halfCurveThickness;
               
               circle_shape.m_p.Set (vertex1.x, vertex1.y);
               
               fixture_def.shape = circle_shape;
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            }
         }
      }
      
      public function AddPolygon (shapeLocalPoints:Array, buildInterior:Boolean, buildBorder:Boolean, borderThickness:Number):void
      {
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
      // ...
         
         var bodyLocalVertexes:Array = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
         
         var vertexCount:int = bodyLocalVertexes.length;
         
         var numDecomposedPolygons:int;
         var decomposedPolygons:Array = new Array ();
         
         var xPositions:Array = new Array (vertexCount);
         var yPositions:Array = new Array (vertexCount);
         
         var vertex:b2Vec2;
         
         for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId) 
         {
            vertex = bodyLocalVertexes [vertexId];
            xPositions[vertexId] = vertex.x;
            yPositions[vertexId] = vertex.y;
         }
         
         var polygon:b2Polygon = new b2Polygon(xPositions, yPositions, vertexCount);
         
         var numDecomposedPolygonsL:int = b2Polygon.DecomposeConvex(polygon, decomposedPolygons, vertexCount - 2);
         
         if (numDecomposedPolygons < 1)
            buildInterior = false;
         
      // ...
         
         if (buildInterior)
         {
            var local_vertices:Array;
            var polygon_shape:b2PolygonShape = new b2PolygonShape ();
            var fixture:b2Fixture;
            
            for (var i:int = 0; i < numDecomposedPolygons; ++ i) 
            {
               local_vertices = (decomposedPolygons[i] as b2Polygon).GetQuanlifiedVertices ();
               
               polygon_shape.Set (local_vertices, local_vertices.length);
               
               fixture_def.shape = polygon_shape;
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            }
            
            if (buildBorder)
            {
               if (borderThickness >= b2Settings.B2_FLT_EPSILON)
               {
                  CreatePolyline (fixture_def, bodyLocalVertexes, 0.5 * borderThickness, 0);
               }
            }
         }
         else if (buildBorder)
         {
            CreatePolyline (fixture_def, bodyLocalVertexes, 0.5 * borderThickness, 0);
         }
      }
      
      public function AddRectangle (shapeLocalCenterX:Number, shapeLocalCenterY:Number, shapeLocalRotation:Number, halfWidth:Number, halfHeight:Number, buildInterior:Boolean, buildBorder:Boolean, borderThickness:Number, roundCorners:Boolean = false):void
      {
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
      // ...
         
         var cos:Number = Math.cos (shapeLocalRotation);
         var sin:Number = Math.sin (shapeLocalRotation);
         
         var p0:Point = new Point ();
         var p1:Point = new Point ();
         var p2:Point = new Point ();
         var p3:Point = new Point ();
         var shapeLocalPoints:Array = [p0, p1, p2, p3];
         var tx:Number, ty:Number, p:Point;
         var bodyLocalVertexes:Array;
         var polygon_shape:b2PolygonShape = new b2PolygonShape ();
         var halfBorderThickness:Number = 0.5 * borderThickness;
         
         var fixture:b2Fixture;
         
         if (roundCorners)
         {
            tx = - halfWidth; ty = - halfHeight; p = p0; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx =   halfWidth; ty = - halfHeight; p = p1; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx =   halfWidth; ty =   halfHeight; p = p2; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx = - halfWidth; ty =   halfHeight; p = p3; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            
            bodyLocalVertexes = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
            
            if (halfWidth >= Half_B2_FLT_EPSILON && halfHeight >= Half_B2_FLT_EPSILON)
            {
               // ...
               polygon_shape.Set (bodyLocalVertexes, 4);
               
               fixture_def.shape = polygon_shape;
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               // ...
               CreatePolyline (fixture_def, bodyLocalVertexes, halfBorderThickness, 0);
            }
         }
         else if (buildInterior)
         {
            if (buildBorder)
            {
               halfWidth  += halfBorderThickness;
               halfHeight += halfBorderThickness;
            }
            
            if (halfWidth >= Half_B2_FLT_EPSILON && halfHeight >= Half_B2_FLT_EPSILON)
            {
               tx = - halfWidth; ty = - halfHeight; p = p0; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               tx =   halfWidth; ty = - halfHeight; p = p1; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               tx =   halfWidth; ty =   halfHeight; p = p2; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               tx = - halfWidth; ty =   halfHeight; p = p3; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               
               bodyLocalVertexes = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
               
               // ...
               polygon_shape.Set (bodyLocalVertexes, 4);
               
               fixture_def.shape = polygon_shape;
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            }
         }
         else if (buildBorder)
         {
            tx = - halfWidth; ty = - halfHeight; p = p0; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx =   halfWidth; ty = - halfHeight; p = p1; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx =   halfWidth; ty =   halfHeight; p = p2; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx = - halfWidth; ty =   halfHeight; p = p3; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            
            if (borderThickness < b2Settings.B2_FLT_EPSILON)
            {
               if (halfWidth >= Half_B2_FLT_EPSILON && halfHeight >= Half_B2_FLT_EPSILON)
               {
                  bodyLocalVertexes = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
                  
                  CreatePolyline (fixture_def, bodyLocalVertexes, halfBorderThickness, 0);
               }
            }
            else
            {
               bodyLocalVertexes = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);;
               
               var rot:Number = shapeLocalRotation + mEntityShape.GetRotation () - mProxyBody._b2Body.GetAngle ();
               cos = Math.cos (rot);
               sin = Math.sin (rot);
               tx = halfBorderThickness * cos - halfBorderThickness * sin;
               ty = halfBorderThickness * sin + halfBorderThickness * cos;
               
               var v0:b2Vec2 = bodyLocalVertexes [0];
               var v1:b2Vec2 = bodyLocalVertexes [0];
               var v2:b2Vec2 = bodyLocalVertexes [0];
               var v3:b2Vec2 = bodyLocalVertexes [0];
               
               var vertex0:b2Vec2 = new b2Vec2 ();
               var vertex1:b2Vec2 = new b2Vec2 ();
               var vertex2:b2Vec2 = new b2Vec2 ();
               var vertex3:b2Vec2 = new b2Vec2 ();
               
               var borderRectVertexes:Array = [vertex0, vertex1, vertex2, vertex3];
               
               // left and right
               if (halfWidth >= Half_B2_FLT_EPSILON)
               {
                  // 
                  vertex0.x = v0.x - tx; vertex0.y = v0.y - ty;
                  vertex1.x = v1.x + tx; vertex0.y = v1.y - ty;
                  vertex2.x = v1.x + tx; vertex3.y = v1.y + ty;
                  vertex3.x = v0.x - tx; vertex3.y = v0.y + ty;
                  
                  // ...
                  polygon_shape.Set (borderRectVertexes, 4);
                  
                  fixture_def.shape = polygon_shape;
                  
                  fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
                  _b2Fixtures.push (fixture);
                  
                  // 
                  vertex0.x = v3.x - tx; vertex0.y = v3.y - ty;
                  vertex1.x = v2.x + tx; vertex0.y = v2.y - ty;
                  vertex2.x = v2.x + tx; vertex3.y = v2.y + ty;
                  vertex3.x = v3.x - tx; vertex3.y = v3.y + ty;
                  
                  // ...
                  polygon_shape.Set (borderRectVertexes, 4);
                  
                  fixture_def.shape = polygon_shape;
                  
                  fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
                  _b2Fixtures.push (fixture);
               }
               
               // top and bottom
               if (halfHeight >= Half_B2_FLT_EPSILON)
               {
                  // 
                  vertex0.x = v0.x - tx; vertex0.y = v0.y - ty;
                  vertex1.x = v0.x + tx; vertex1.y = v0.y - ty;
                  vertex2.x = v3.x + tx; vertex0.y = v3.y + ty;
                  vertex3.x = v3.x - tx; vertex1.y = v3.y + ty;
                  
                  // ...
                  polygon_shape.Set (borderRectVertexes, 4);
                  
                  fixture_def.shape = polygon_shape;
                  
                  fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
                  _b2Fixtures.push (fixture);
                  
                  // 
                  vertex0.x = v1.x - tx; vertex0.y = v1.y - ty;
                  vertex1.x = v1.x + tx; vertex1.y = v1.y - ty;
                  vertex2.x = v2.x + tx; vertex0.y = v2.y + ty;
                  vertex3.x = v2.x - tx; vertex1.y = v2.y + ty;
                  
                  // ...
                  polygon_shape.Set (borderRectVertexes, 4);
                  
                  fixture_def.shape = polygon_shape;
                  
                  fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
                  _b2Fixtures.push (fixture);
               }
            }
         }
      }
      
//==============================================================================
// commands
//==============================================================================
      
   }
}
