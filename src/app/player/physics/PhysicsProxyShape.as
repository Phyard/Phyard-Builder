
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.b2Vec2;
   import Box2D.Common.b2Settings;
   
   //import Box2D.Collision.Shapes.b2CircleDef;
   //import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2MassData;
   
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
      
//==============================================================================
// commands
//==============================================================================
      
      public function SetSensor (sensor:Boolean):void
      {
         var fixture:b2Fixture;
         for (var i:int = 0; i < _b2Fixtures.length; ++ i)
         {
            fixture = _b2Fixtures [i] as b2Fixture;
            fixture.SetSensor (sensor);
         }
         
         mProxyBody._b2Body.SetAwake (true);
      }
      
      public function UpdateMass ():void
      {
         var mass:Number = 0.0;
         var inertia:Number = 0.0;
         var centroidX:Number = 0.0;
         var centroidY:Number = 0.0;
         
         var centerX:Number = 0.0;
         var centerY:Number = 0.0;
         
         var massData:b2MassData = new b2MassData ();
         var i:int;
         var num:int = _b2Fixtures.length;
         var fixture:b2Fixture;
         for (i = 0; i < num; ++ i)
         {
            fixture = _b2Fixtures [i] as b2Fixture;
            
            fixture.GetMassData(massData);
            
            centerX += massData.center.x;
            centerY += massData.center.y;
            
            mass += massData.mass;
            centroidX += massData.mass * massData.center.x;
            centroidY += massData.mass * massData.center.y;
            inertia += massData.I;
         }
         
         var invMass:Number;
         if (mMass > 0)
         {
            invMass = 1.0 / mass;
            centroidX = centroidX * invMass;
            centroidY = centroidY * invMass;
         }
         else if (num > 0)
         {
            invMass = 1.0 / Number(num);
            centroidX = centerX * invMass;
            centroidY = centerY * invMass;
         }
         
         mEntityShape.SetMass (mass);
         mEntityShape.SetInertia (inertia);
         mEntityShape.SetCentroid (centroidX, centroidY);
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
      
      private static const Half_B2_FLT_EPSILON:Number = b2Settings.b2_epsilon * 0.5;
      
      public function AddCircle (shapeLocalCenterX:Number, shapeLocalCenterY:Number, radius:Number, buildInterior:Boolean, buildBorder:Boolean, borderThickness:Number):void
      {
         if ( (! buildBorder) && (! buildInterior))
            return;
         
      // ...
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
      // ...
         
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
               if (innerRadius < b2Settings.b2_epsilon)
               {
                  radius = outerRadius;
               }
               else
               {
                  // use polyline instead
                  
                  var numSegments:int = 50; //Math.PI * 2.0 * radius;
                  var shapeLocalPoints:Array = new Array (numSegments);
                  var dAngle:Number = Math.PI * 2.0 / numSegments;
                  var angle:Number = 0.0;
                  
                  for (var i:int = 0; i < numSegments; ++ i)
                  {
                     shapeLocalPoints [i] = new Point (radius * Math.cos (angle), radius * Math.sin (angle));
                     
                     angle += dAngle;
                  }
                  
                  var bodyLocalVertexes:Array = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
                  
                  CreatePolyline (fixture_def, bodyLocalVertexes, halfBorderThickness, true, true, true);
                  
                  return;
               }
            }
         }
         else if (! buildInterior)
         {
            return;
         }
         
         // shape local to world
         
         var rot:Number = mEntityShape.GetRotation ();
         
         var cos:Number = Math.cos (rot);
         var sin:Number = Math.sin (rot);
         
         var vec:b2Vec2 = new b2Vec2 ();
         vec.x = mEntityShape.GetPositionX () + cos * shapeLocalCenterX - sin * shapeLocalCenterY;
         vec.y = mEntityShape.GetPositionY () + sin * shapeLocalCenterX + cos * shapeLocalCenterY;
         
         // world to body local
         
         vec = mProxyBody._b2Body.GetLocalPoint (vec);
         
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
         
         CreatePolyline (fixture_def, bodyLocalVertexes, 0.5 * curveThickness, false, true, roundEnds);
      }
      
      // close_and_round: 0 means closed, 1 means not closed but round, -1 means not close and not round
      private function CreatePolyline (fixture_def:b2FixtureDef, bodyLocalVertexes:Array, halfCurveThickness:Number, isClosed:Boolean, isRoundJoints:Boolean, isRoundEnds:Boolean):void
      {
         var vertexCount:int = bodyLocalVertexes.length;
         if (vertexCount < 1)
            return;
         
         if (isClosed)
            isRoundEnds = isRoundJoints;
         
         var vertex1:b2Vec2;
         var vertex2:b2Vec2;
         var vertexId2:int;
         var dx:Number;
         var dy:Number;
         var fixture:b2Fixture;
         
         var polygon_shape:b2PolygonShape = new b2PolygonShape ();
         
         if (halfCurveThickness + halfCurveThickness < b2Settings.b2_epsilon)
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
               
               if (dx > - b2Settings.b2_epsilon && dx < b2Settings.b2_epsilon && dy > - b2Settings.b2_epsilon && dy < b2Settings.b2_epsilon)
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
            var firstVertex:b2Vec2;
            
            if (isClosed)
            {
               firstVertex = bodyLocalVertexes [vertexCount - 1];
               vertexId2 = 0;
               buildCircle = isRoundJoints;
               
               isRoundEnds = false; // some tricky here, just to avoid entering the "if (isRoundEnds)" clause in the end
            }
            else
            {
               firstVertex = bodyLocalVertexes [0];
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
            
            vertex1 = firstVertex;
            
            for (; vertexId2 < vertexCount; ++ vertexId2)
            {
               vertex2 = bodyLocalVertexes [vertexId2];
               dx = vertex2.x - vertex1.x;
               dy = vertex2.y - vertex1.y;
               
               if (dx > - b2Settings.b2_epsilon && dx < b2Settings.b2_epsilon && dy > - b2Settings.b2_epsilon && dy < b2Settings.b2_epsilon)
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
                  buildCircle = isRoundJoints;
               }
               
               // ..
               vertex1 = vertex2;
            }
            
            // for polyline, the circle for the last vertex hasn't been built.
            // for polygon, isRoundEnds is alrady set false above 
            if (isRoundEnds
               || firstVertex == vertex1 // at least, create something
               )
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
         
         numDecomposedPolygons = b2Polygon.DecomposeConvex(polygon, decomposedPolygons, vertexCount - 2);
         
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
               if (borderThickness >= b2Settings.b2_epsilon)
               {
                  CreatePolyline (fixture_def, bodyLocalVertexes, 0.5 * borderThickness, true, true, true);
               }
            }
         }
         else if (buildBorder)
         {
            CreatePolyline (fixture_def, bodyLocalVertexes, 0.5 * borderThickness, true, true, true);
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
         
         if (buildInterior)
         {
            var extend:Boolean = buildBorder && (! roundCorners);
            
            var halfWidth_b :Number = halfWidth;
            var halfHeight_b:Number = halfHeight;
            
            if (extend)
            {
               halfWidth_b  += halfBorderThickness;
               halfHeight_b += halfBorderThickness;
            }
            
            if (halfWidth >= Half_B2_FLT_EPSILON && halfHeight >= Half_B2_FLT_EPSILON)
            {
               tx = - halfWidth_b; ty = - halfHeight_b; p = p0; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               tx =   halfWidth_b; ty = - halfHeight_b; p = p1; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               tx =   halfWidth_b; ty =   halfHeight_b; p = p2; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               tx = - halfWidth_b; ty =   halfHeight_b; p = p3; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
               
               bodyLocalVertexes = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
               
               // ...
               polygon_shape.Set (bodyLocalVertexes, 4);
               
               fixture_def.shape = polygon_shape;
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               if (extend)
               {
                  buildBorder = false; // avoiding entering the below block
               }
            }
         }
         
         if (buildBorder)
         {
            tx = - halfWidth; ty = - halfHeight; p = p0; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx =   halfWidth; ty = - halfHeight; p = p1; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx =   halfWidth; ty =   halfHeight; p = p2; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            tx = - halfWidth; ty =   halfHeight; p = p3; p.x = shapeLocalCenterX + tx * cos - ty * sin; p.y = shapeLocalCenterY + tx * sin + ty * cos;
            
            if (roundCorners)
            {
               bodyLocalVertexes = ShapeLocalPoints2BodyLocalVertexes (shapeLocalPoints);
               
               CreatePolyline (fixture_def, bodyLocalVertexes, halfBorderThickness, true, roundCorners, roundCorners);
            }
            else
            {
               p = p0; 
               var p0a:Point = new Point (p.x - halfBorderThickness, p.y - halfBorderThickness);
               var p0b:Point = new Point (p.x + halfBorderThickness, p.y - halfBorderThickness);
               var p0c:Point = new Point (p.x + halfBorderThickness, p.y + halfBorderThickness);
               var p0d:Point = new Point (p.x - halfBorderThickness, p.y + halfBorderThickness);
               
               p = p1; 
               var p1a:Point = new Point (p.x - halfBorderThickness, p.y - halfBorderThickness);
               var p1b:Point = new Point (p.x + halfBorderThickness, p.y - halfBorderThickness);
               var p1c:Point = new Point (p.x + halfBorderThickness, p.y + halfBorderThickness);
               var p1d:Point = new Point (p.x - halfBorderThickness, p.y + halfBorderThickness);
               
               p = p2; 
               var p2a:Point = new Point (p.x - halfBorderThickness, p.y - halfBorderThickness);
               var p2b:Point = new Point (p.x + halfBorderThickness, p.y - halfBorderThickness);
               var p2c:Point = new Point (p.x + halfBorderThickness,p.y + halfBorderThickness);
               var p2d:Point = new Point (p.x - halfBorderThickness, p.y + halfBorderThickness);
               
               p = p3; 
               var p3a:Point = new Point (p.x - halfBorderThickness, p.y - halfBorderThickness);
               var p3b:Point = new Point (p.x + halfBorderThickness, p.y - halfBorderThickness);
               var p3c:Point = new Point (p.x + halfBorderThickness, p.y + halfBorderThickness);
               var p3d:Point = new Point (p.x - halfBorderThickness, p.y + halfBorderThickness);
               
               bodyLocalVertexes = ShapeLocalPoints2BodyLocalVertexes ([p0a, p0b, p0c, p0d, p1a, p1b, p1c, p1d, p2a, p2b, p2c, p2d, p3a, p3b, p3c, p3d]);
               
               var v0a:b2Vec2 = bodyLocalVertexes [0];
               var v0b:b2Vec2 = bodyLocalVertexes [1];
               //var v0c:b2Vec2 = bodyLocalVertexes [2];
               var v0d:b2Vec2 = bodyLocalVertexes [3];
               var v1a:b2Vec2 = bodyLocalVertexes [4];
               var v1b:b2Vec2 = bodyLocalVertexes [5];
               var v1c:b2Vec2 = bodyLocalVertexes [6];
               //var v1d:b2Vec2 = bodyLocalVertexes [7];
               //var v2a:b2Vec2 = bodyLocalVertexes [8];
               var v2b:b2Vec2 = bodyLocalVertexes [9];
               var v2c:b2Vec2 = bodyLocalVertexes [10];
               var v2d:b2Vec2 = bodyLocalVertexes [11];
               var v3a:b2Vec2 = bodyLocalVertexes [12];
               //var v3b:b2Vec2 = bodyLocalVertexes [13];
               var v3c:b2Vec2 = bodyLocalVertexes [14];
               var v3d:b2Vec2 = bodyLocalVertexes [15];
               
               fixture_def.shape = polygon_shape;
               
               // top border
               
               polygon_shape.Set ([v0a, v1b, v1c, v0d], 4);
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               // bottom border
               
               polygon_shape.Set ([v3a, v2b, v2c, v3d], 4);
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               // left border
               
               polygon_shape.Set ([v0a, v0b, v3c, v3d], 4);
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               // right border
               
               polygon_shape.Set ([v1a, v1b, v2c, v2d], 4);
               
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            }
         }
      }
      
//=============================================================================
// 
//=============================================================================
   }
}
