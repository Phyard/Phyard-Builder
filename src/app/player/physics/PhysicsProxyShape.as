
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.b2Vec2;
   import Box2D.Common.b2Settings;
   
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2EdgeShape;
   
   import Box2D.Collision.Shapes.b2MassData;
   
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2FixtureDef;
   
   import Box2D.Collision.Shapes.b2Polygon;
   
   import player.entity.EntityShape;
   
   import common.Transform2D;
   
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
      
      public function FlagForFilteringForAllContacts ():void
      {
         mProxyBody._b2Body.FlagForFilteringForAllContacts ();
      }
      
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
      
      public function SetFriction (friction:Number):void
      {
         var fixture:b2Fixture;
         for (var i:int = 0; i < _b2Fixtures.length; ++ i)
         {
            fixture = _b2Fixtures [i] as b2Fixture;
            fixture.SetFriction (friction);
         }
         
         mProxyBody._b2Body.SetAwake (true);
      }
      
      public function SetRestitution (restitution:Number):void
      {
         var fixture:b2Fixture;
         for (var i:int = 0; i < _b2Fixtures.length; ++ i)
         {
            fixture = _b2Fixtures [i] as b2Fixture;
            fixture.SetRestitution (restitution);
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
         for (i = num - 1; i >= 0; -- i)
         {
            fixture = _b2Fixtures [i] as b2Fixture;
            
            if (fixture.m_density == 0.0)
            {
               continue;
            }
            
            fixture.GetMassData(massData);
            
            centerX += massData.center.x;
            centerY += massData.center.y;
            
            mass += massData.mass;
            centroidX += massData.mass * massData.center.x;
            centroidY += massData.mass * massData.center.y;
            inertia += massData.I;
         }
         
         var invMass:Number;
         if (mass > 0)
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
         mEntityShape.SetCentroidInBodySpace (centroidX, centroidY);
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
      
      // since v2.06, params values for this fucntions are all pixel unit. The transform should transform the values into physics unit.
      public function AddCircle (transform:Transform2D, radius:Number, buildInterior:Boolean, buildBorder:Boolean, borderThickness:Number):void
      {
         if ( (! buildBorder) && (! buildInterior))
            return;
         
         var isStatic:Boolean = mEntityShape.IsStatic (); // here not use body.IsStatic () is to avoid freezing when calling AttachShape and SetStatic APIs
         
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
               
               // todo: if scale along axis is added later, the calculation will be some complex
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
                  
                  var numSegments:int = 50; // Math.PI * 2.0 * radius / segmentLength;
                  var localPoints:Array = new Array (numSegments);
                  var dAngle:Number = Math.PI * 2.0 / numSegments;
                  var angle:Number = 0.0;
                  
                  for (var i:int = 0; i < numSegments; ++ i)
                  {
                     localPoints [i] = new Point (radius * Math.cos (angle), radius * Math.sin (angle));
                     
                     angle += dAngle;
                  }
                  
                  var localVertexes:Array = TransformPolyPoints2Vertexes (transform, localPoints, false);
                  
                  CreatePolyline (isStatic, fixture_def, localVertexes, halfBorderThickness * transform.mScale, true, true, true);
                  
                  return;
               }
            }
         }
         else if (! buildInterior)
         {
            return;
         }
         
         // transformed to body local
         
         var vec:b2Vec2 = new b2Vec2 ();
         vec.x = transform.mOffsetX;
         vec.y = transform.mOffsetY;
         radius *= transform.mScale;

         // ...
         
         var circle_shape:b2CircleShape = new b2CircleShape ();
         circle_shape.m_radius = radius;
         
         circle_shape.m_p.Set (vec.x, vec.y);
         
         fixture_def.shape = circle_shape;
         
         // ...
         var fixture:b2Fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
         _b2Fixtures.push (fixture);
      }
      
      // since v2.06, transform should transform the values into physics unit.
      private static function TransformPolyPoints2Vertexes (transform:Transform2D, points:Array, assureCW:Boolean):Array
      {
         if (assureCW && transform.mFlipped)
         {
            points = points.reverse (); // to keep CW order
         }
         
         var tempPoint:Point = new Point ();
         var vertexes:Array = new Array (points.length);
         
         for (var i:int = 0; i < points.length; ++ i)
         {
            transform.TransformPoint (points [i] as Point, tempPoint);
            
            var vertex:b2Vec2 = new b2Vec2 ();
            vertex.x = tempPoint.x;
            vertex.y = tempPoint.y;
            vertexes [i] = vertex;
         }
         
         return vertexes;
      }
      
      // since v2.06, params values for this fucntions are all pixel unit. The transform should transform the values into physics unit.
      public function AddPolyline (transform:Transform2D, localPoints:Array, buildInterior:Boolean, curveThickness:Number, roundEnds:Boolean, closed:Boolean):void
      {
         if (! buildInterior)
            return;
         
         var isStatic:Boolean = mEntityShape.IsStatic (); // here not use body.IsStatic () is to avoid freezing when calling AttachShape and SetStatic APIs
         
         // ...
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
         var localVertexes:Array = TransformPolyPoints2Vertexes (transform, localPoints, false);
         
         CreatePolyline (isStatic, fixture_def, localVertexes, 0.5 * curveThickness * transform.mScale, closed, true, roundEnds);
      }
      
      // params values for this fucntions is physics unit.
      private function CreatePolyline (isStatic:Boolean, fixture_def:b2FixtureDef, inputBodyLocalVertexes:Array, halfCurveThickness:Number, isClosed:Boolean, isRoundJoints:Boolean, isRoundEnds:Boolean):void
      {
         var vertexCount:int = inputBodyLocalVertexes.length;
         if (vertexCount < 1)
            return;
         
         // todo: if "scale along axis" is added later, the calculation will be some complex
         halfCurveThickness *= mEntityShape.GetScale (); // from v1.56
         
         // remvoe too short lines
         
         var bodyLocalVertexes:Array = new Array ();
         
         var vertex1:b2Vec2;
         var vertex2:b2Vec2;
         var vertexId2:int;
         var dx:Number;
         var dy:Number;
         
         vertex1 = inputBodyLocalVertexes [0];
         vertexId2 = 1;
         
         bodyLocalVertexes.push (vertex1);
         for (; vertexId2 < vertexCount; ++ vertexId2)
         {
            vertex2 = inputBodyLocalVertexes [vertexId2];
            dx = vertex2.x - vertex1.x;
            dy = vertex2.y - vertex1.y;
            
            if (dx > - b2Settings.b2_epsilon && dx < b2Settings.b2_epsilon && dy > - b2Settings.b2_epsilon && dy < b2Settings.b2_epsilon)
               continue; // ignore too short lines
            
            vertex1 = vertex2;
            
            bodyLocalVertexes.push (vertex1);
         }
         
         // ok, begin
         
         vertexCount = bodyLocalVertexes.length;
         // vertexCount must be larger than 0
         
         var fixture:b2Fixture;
         var polygon_shape:b2PolygonShape;
         
         if (halfCurveThickness + halfCurveThickness < b2Settings.b2_epsilon) // zero thickness
         {
            var edgeShape:b2EdgeShape = new b2EdgeShape ();
            polygon_shape = new b2PolygonShape ();
            
            if (vertexCount <= 2) // 1 or 2
            {
               // isClosed = false; // force closed
               
               vertex1 = bodyLocalVertexes [0];
               vertex2 = bodyLocalVertexes [vertexCount -1]; // vertex 0 or 1
               if (isStatic)
               {
                  edgeShape.Set (vertex1, vertex2);
                  fixture_def.shape = edgeShape;
                  
                  //trace ("edgeShape");
               }
               else
               {
                  polygon_shape.SetAsEdge (vertex1, vertex2);
                  fixture_def.shape = polygon_shape;
                  
                  //trace ("polygon_shape");
               }
               
               // ...
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            }
            else // vertexCount >= 3
            {
               var vertex0:b2Vec2;
               var vertex3:b2Vec2;
               var vertexId3:int;
               var endVertexId3:int;
               
               if (isClosed)
               {
                  vertex2 = bodyLocalVertexes [vertexCount - 1];
                  vertex1 = bodyLocalVertexes [vertexCount - 2];
                  vertex0 = bodyLocalVertexes [vertexCount - 3];
                  
                  vertexId3 = 0;
                  endVertexId3 = vertexCount;
               }
               else
               {
                  vertex2 = bodyLocalVertexes [1];
                  vertex1 = bodyLocalVertexes [0];
                  vertex0 = null;
                  
                  vertexId3 = 2;
                  endVertexId3 = vertexCount + 1;
               }
               
               for (; vertexId3 < endVertexId3; ++ vertexId3)
               {
                  vertex3 = bodyLocalVertexes [vertexId3]; // here, in actionscript, bodyLocalVertexes [vertexCount] will return null, in c++, error instead
                  
                  if (isStatic)
                  {
                     edgeShape.Set (vertex1, vertex2);
                     if (vertex0 == null)
                     {
                        edgeShape.m_hasVertex0 = false;
                     }
                     else
                     {
                        edgeShape.m_hasVertex0 = true;
                        edgeShape.m_vertex0 = vertex0;
                     }
                     if (vertex3 == null)
                     {
                        edgeShape.m_hasVertex3 = false;
                     }
                     else
                     {
                        edgeShape.m_hasVertex3 = true;
                        edgeShape.m_vertex3 = vertex3;
                     }
                     fixture_def.shape = edgeShape;
                  }
                  else
                  {
                     polygon_shape.SetAsEdge (vertex1, vertex2);
                     fixture_def.shape = polygon_shape;
                  }
                  
                  // ...
                  fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
                  _b2Fixtures.push (fixture);
                  
                  // ...
                  vertex0 = vertex1;
                  vertex1 = vertex2;
                  vertex2 = vertex3;
               }
            }
         }
         else // simulate non-zero thickness lines with rectangles, by creating a circle at every line joint.
         {
            if (isClosed)
               isRoundEnds = isRoundJoints; // force round ends
            
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
            polygon_shape = new b2PolygonShape ();
            
            vertex1 = firstVertex;
            
            for (; vertexId2 < vertexCount; ++ vertexId2)
            {
               vertex2 = bodyLocalVertexes [vertexId2];
               dx = vertex2.x - vertex1.x;
               dy = vertex2.y - vertex1.y;
               
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
      
      // since v2.06, params values for this fucntions are all pixel unit. The transform should transform the values into physics unit.
      public function AddPolygon (transform:Transform2D, localPoints:Array, buildInterior:Boolean, buildBorder:Boolean, borderThickness:Number):void
      {
         if ( (! buildBorder) && (! buildInterior))
            return;
         
         var isStatic:Boolean = mEntityShape.IsStatic (); // here not use body.IsStatic () is to avoid freezing when calling AttachShape and SetStatic APIs
         
         // ...
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
      // ...
         
         var localVertexes:Array = TransformPolyPoints2Vertexes (transform, localPoints, false);
         
         var vertexCount:int = localVertexes.length;
         
         var numDecomposedPolygons:int;
         var decomposedPolygons:Array = new Array ();
         
         var xPositions:Array = new Array (vertexCount);
         var yPositions:Array = new Array (vertexCount);
         
         var vertex:b2Vec2;
         
         for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId) 
         {
            vertex = localVertexes [vertexId];
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
                  CreatePolyline (isStatic, fixture_def, localVertexes, 0.5 * borderThickness* transform.mScale, true, true, true);
               }
            }
         }
         else if (buildBorder)
         {
            CreatePolyline (isStatic, fixture_def, localVertexes, 0.5 * borderThickness* transform.mScale, true, true, true);
         }
      }
      
      // since v2.06, params values for this fucntions are all pixel unit. The transform should transform the values into physics unit.
      public function AddRectangle (transform:Transform2D, halfWidth:Number, halfHeight:Number, buildInterior:Boolean, buildBorder:Boolean, borderThickness:Number, roundCorners:Boolean = false):void
      {
         if ( (! buildBorder) && (! buildInterior))
            return;
         
         var isStatic:Boolean = mEntityShape.IsStatic (); // here not use body.IsStatic () is to avoid freezing when calling AttachShape and SetStatic APIs
         
         // ...
         
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         fixture_def.density     = mEntityShape.GetDensity ();
         fixture_def.friction    = mEntityShape.GetFriction ();
         fixture_def.restitution = mEntityShape.GetRestitution ();
         fixture_def.isSensor    = mEntityShape.IsSensor ();
         
         fixture_def.userData = this;
         
      // ...
         
         var p0:Point = new Point ();
         var p1:Point = new Point ();
         var p2:Point = new Point ();
         var p3:Point = new Point ();
         var localPoints:Array = [p0, p1, p2, p3];
         var bodyLocalVertexes:Array;
         var polygon_shape:b2PolygonShape = new b2PolygonShape ();
         var halfBorderThickness:Number = 0.5 * borderThickness;
         
         fixture_def.shape = polygon_shape;
         
         var fixture:b2Fixture;
         
         if (buildInterior)
         {
            var extend:Boolean = buildBorder && ((! roundCorners) || borderThickness < b2Settings.b2_epsilon);
            
            var halfWidth_b :Number = halfWidth;
            var halfHeight_b:Number = halfHeight;
            
            if (extend)
            {
               halfWidth_b  += halfBorderThickness;
               halfHeight_b += halfBorderThickness;
            }
            
            if (halfWidth >= Half_B2_FLT_EPSILON && halfHeight >= Half_B2_FLT_EPSILON)
            {
               p0.x = - halfWidth_b; p0.y = - halfHeight_b;
               p1.x =   halfWidth_b; p1.y = - halfHeight_b;
               p2.x =   halfWidth_b; p2.y =   halfHeight_b;
               p3.x = - halfWidth_b; p3.y =   halfHeight_b;
               
               bodyLocalVertexes = TransformPolyPoints2Vertexes (transform, localPoints, true);
         
               // ...
               polygon_shape.Set (bodyLocalVertexes, 4);
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
               
               if (extend)
               {
                  buildBorder = false; // avoid entering the below block
               }
            }
            else
            {
               buildInterior = false; // force building polyline for zero-thickness border below
            }
         }
         
         if (buildBorder)
         {
            if ( roundCorners || ( (! buildInterior) &&  borderThickness < b2Settings.b2_epsilon) )
            {
               p0.x = - halfWidth; p0.y = - halfHeight;
               p1.x =   halfWidth; p1.y = - halfHeight;
               p2.x =   halfWidth; p2.y =   halfHeight;
               p3.x = - halfWidth; p3.y =   halfHeight;
               
               bodyLocalVertexes = TransformPolyPoints2Vertexes (transform, localPoints, false);
               
               CreatePolyline (isStatic, fixture_def, bodyLocalVertexes, halfBorderThickness * transform.mScale, true, roundCorners, roundCorners);
            }
            else
            {
               // top border
               
               p0.x = - halfWidth - halfBorderThickness; p0.y = - halfHeight - halfBorderThickness;
               p1.x =   halfWidth + halfBorderThickness; p1.y = - halfHeight - halfBorderThickness;
               p2.x =   halfWidth + halfBorderThickness; p2.y = - halfHeight + halfBorderThickness;
               p3.x = - halfWidth - halfBorderThickness; p3.y = - halfHeight + halfBorderThickness;
               
               bodyLocalVertexes = TransformPolyPoints2Vertexes (transform, localPoints, true);
            
               polygon_shape.Set (bodyLocalVertexes, 4);
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            
               // bottom border
               
               p0.x = - halfWidth - halfBorderThickness; p0.y = halfHeight - halfBorderThickness;
               p1.x =   halfWidth + halfBorderThickness; p1.y = halfHeight - halfBorderThickness;
               p2.x =   halfWidth + halfBorderThickness; p2.y = halfHeight + halfBorderThickness;
               p3.x = - halfWidth - halfBorderThickness; p3.y = halfHeight + halfBorderThickness;
               
               bodyLocalVertexes = TransformPolyPoints2Vertexes (transform, localPoints, true);
            
               polygon_shape.Set (bodyLocalVertexes, 4);
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            
               // left border
               
               p0.x = - halfWidth - halfBorderThickness; p0.y = - halfHeight - halfBorderThickness;
               p1.x = - halfWidth + halfBorderThickness; p1.y = - halfHeight - halfBorderThickness;
               p2.x = - halfWidth + halfBorderThickness; p2.y =   halfHeight + halfBorderThickness;
               p3.x = - halfWidth - halfBorderThickness; p3.y =   halfHeight + halfBorderThickness;
               
               bodyLocalVertexes = TransformPolyPoints2Vertexes (transform, localPoints, true);
            
               polygon_shape.Set (bodyLocalVertexes, 4);
               fixture = mProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (fixture);
            
               // right border
               
               p0.x = halfWidth - halfBorderThickness; p0.y = - halfHeight - halfBorderThickness;
               p1.x = halfWidth + halfBorderThickness; p1.y = - halfHeight - halfBorderThickness;
               p2.x = halfWidth + halfBorderThickness; p2.y =   halfHeight + halfBorderThickness;
               p3.x = halfWidth - halfBorderThickness; p3.y =   halfHeight + halfBorderThickness;
               
               bodyLocalVertexes = TransformPolyPoints2Vertexes (transform, localPoints, true);
            
               polygon_shape.Set (bodyLocalVertexes, 4);
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
