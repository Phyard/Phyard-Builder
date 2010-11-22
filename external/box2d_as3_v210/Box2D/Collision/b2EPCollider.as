package Box2D.Collision
{
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Settings;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2EdgeShape

	// This class collides and edge and a polygon, taking into account edge adjacency.
	public class b2EPCollider
	{
		//b2EPCollider(const b2EdgeShape* edgeA, const b2Transform& xfA,
		//			const b2PolygonShape* polygonB_in, const b2Transform& xfB);

		//void Collide(b2Manifold* manifold);

		//void ComputeAdjacency();
		//b2EPAxis ComputeEdgeSeparation();
		//b2EPAxis ComputePolygonSeparation();
		//void FindIncidentEdge(b2ClipVertex c[2], const b2EPProxy* proxy1, int32 edge1, const b2EPProxy* proxy2);

		public var m_edgeA:b2FatEdge = new b2FatEdge ();

		public var m_proxyA:b2EPProxy = new b2EPProxy (), m_proxyB:b2EPProxy = new b2EPProxy ();

		public var m_xf:b2Transform = new b2Transform ();
		public var m_normal0:b2Vec2 = new b2Vec2 (), m_normal2:b2Vec2 = new b2Vec2 ();
		public var m_limit11:b2Vec2 = new b2Vec2 (), m_limit12:b2Vec2 = new b2Vec2 ();
		public var m_limit21:b2Vec2 = new b2Vec2 (), m_limit22:b2Vec2 = new b2Vec2 ();
		public var m_radius:Number;
	//};

		//b2EPCollider::b2EPCollider(const b2EdgeShape* edgeA, const b2Transform& xfA,
		//				const b2PolygonShape* polygonB, const b2Transform& xfB)
		public function b2EPCollider(edgeA:b2EdgeShape, xfA:b2Transform,
						polygonB:b2PolygonShape, xfB:b2Transform)
		{
			//m_xf = b2MulT(xfA, xfB);
			b2Math.b2MulT_TransformAndTransform_Output (xfA, xfB, m_xf);

			// Edge geometry
			//m_edgeA.v0 = edgeA->m_vertex0;
			m_edgeA.v0.x = edgeA.m_vertex0.x;
			m_edgeA.v0.y = edgeA.m_vertex0.y;
			//m_edgeA.v1 = edgeA->m_vertex1;
			m_edgeA.v1.x = edgeA.m_vertex1.x;
			m_edgeA.v1.y = edgeA.m_vertex1.y;
			//m_edgeA.v2 = edgeA->m_vertex2;
			m_edgeA.v2.x = edgeA.m_vertex2.x;
			m_edgeA.v2.y = edgeA.m_vertex2.y;
			//m_edgeA.v3 = edgeA->m_vertex3;
			m_edgeA.v3.x = edgeA.m_vertex3.x;
			m_edgeA.v3.y = edgeA.m_vertex3.y;
			//b2Vec2 e = m_edgeA.v2 - m_edgeA.v1;
			var e:b2Vec2 = new b2Vec2 ();
			e.x = m_edgeA.v2.x - m_edgeA.v1.x;
			e.y = m_edgeA.v2.y - m_edgeA.v1.y;

			// Normal points outwards in CCW order.
			m_edgeA.normal.Set(e.y, -e.x);
			m_edgeA.normal.Normalize();
			m_edgeA.hasVertex0 = edgeA.m_hasVertex0;
			m_edgeA.hasVertex3 = edgeA.m_hasVertex3;

			var aVertex:b2Vec2;
			var aNormal:b2Vec2;

			// Proxy for edge
			//m_proxyA.vertices[0] = m_edgeA.v1;
			aVertex = m_proxyA.vertices[0] as b2Vec2;
			aVertex.x = m_edgeA.v1.x;
			aVertex.y = m_edgeA.v1.y;
			//m_proxyA.vertices[1] = m_edgeA.v2;
			aVertex = m_proxyA.vertices[1] as b2Vec2;
			aVertex.x = m_edgeA.v2.x;
			aVertex.y = m_edgeA.v2.y;
			//m_proxyA.normals[0] = m_edgeA.normal;
			aNormal = m_proxyA.normals[0] as b2Vec2;
			aNormal.x = m_edgeA.normal.x;
			aNormal.y = m_edgeA.normal.y;
			//m_proxyA.normals[1] = -m_edgeA.normal;
			aNormal = m_proxyA.normals[1] as b2Vec2;
			aNormal.x = -m_edgeA.normal.x;
			aNormal.y = -m_edgeA.normal.y;
			//m_proxyA.centroid = 0.5f * (m_edgeA.v1 + m_edgeA.v2);
			m_proxyA.centroid.x = 0.5 * (m_edgeA.v1.x + m_edgeA.v2.x);
			m_proxyA.centroid.y = 0.5 * (m_edgeA.v1.y + m_edgeA.v2.y);
			m_proxyA.count = 2;

			// Proxy for polygon
			m_proxyB.count = polygonB.m_vertexCount;
			//m_proxyB.centroid = b2Mul(m_xf, polygonB->m_centroid);
			b2Math.b2Mul_TransformAndVector2_Output (m_xf, polygonB.m_centroid, m_proxyB.centroid);
			for (var i:int = 0; i < polygonB.m_vertexCount; ++i)
			{
				//m_proxyB.vertices[i] = b2Mul(m_xf, polygonB->m_vertices[i]);
				b2Math.b2Mul_TransformAndVector2_Output (m_xf, polygonB.m_vertices[i] as b2Vec2, m_proxyB.vertices[i] as b2Vec2)
				//m_proxyB.normals[i] = b2Mul(m_xf.R, polygonB->m_normals[i]);
				b2Math.b2Mul_Matrix22AndVector2_Output (m_xf.R, polygonB.m_normals[i] as b2Vec2, m_proxyB.normals[i] as b2Vec2);
			}

			m_radius = 2.0 * b2Settings.b2_polygonRadius;

			m_limit11.SetZero();
			m_limit12.SetZero();
			m_limit21.SetZero();
			m_limit22.SetZero();
		}

		// Collide an edge and polygon. This uses the SAT and clipping to produce up to 2 contact points.
		// Edge adjacency is handle to produce locally valid contact points and normals. This is intended
		// to allow the polygon to slide smoothly over an edge chain.
		//
		// Algorithm
		// 1. Classify front-side or back-side collision with edge.
		// 2. Compute separation
		// 3. Process adjacent edges
		// 4. Classify adjacent edge as convex, flat, null, or concave
		// 5. Skip null or concave edges. Concave edges get a separate manifold.
		// 6. If the edge is flat, compute contact points as normal. Discard boundary points.
		// 7. If the edge is convex, compute it's separation.
		// 8. Use the minimum separation of up to three edges. If the minimum separation
		//    is not the primary edge, return.
		// 9. If the minimum separation is the primary edge, compute the contact points and return.
		public function Collide(manifold:b2Manifold):void
		{
			manifold.pointCount = 0;

			ComputeAdjacency();

			var edgeAxis:b2EPAxis = ComputeEdgeSeparation();

			// If no valid normal can be found than this edge should not collide.
			// This can happen on the middle edge of a 3-edge zig-zag chain.
			if (edgeAxis.type == b2EPAxis.e_unknown)
			{
				return;
			}

			if (edgeAxis.separation > m_radius)
			{
				return;
			}

			var polygonAxis:b2EPAxis = ComputePolygonSeparation();
			if (polygonAxis.type != b2EPAxis.e_unknown && polygonAxis.separation > m_radius)
			{
				return;
			}

			// Use hysteresis for jitter reduction.
			const k_relativeTol:Number = 0.98;
			const k_absoluteTol:Number = 0.001;

			//b2EPAxis primaryAxis;
			var primaryAxis:b2EPAxis;
			if (polygonAxis.type == b2EPAxis.e_unknown)
			{
				primaryAxis = edgeAxis;
			}
			else if (polygonAxis.separation > k_relativeTol * edgeAxis.separation + k_absoluteTol)
			{
				primaryAxis = polygonAxis;
			}
			else
			{
				primaryAxis = edgeAxis;
			}

			var proxy1:b2EPProxy;
			var proxy2:b2EPProxy;
			//b2ClipVertex incidentEdge[2];
			var incidentEdge:b2ClipVertexSegment = new b2ClipVertexSegment ();
			if (primaryAxis.type == b2EPAxis.e_edgeA)
			{
				proxy1 = m_proxyA;
				proxy2 = m_proxyB;
				manifold.type = b2Manifold.e_faceA;
			}
			else
			{
				proxy1 = m_proxyB;
				proxy2 = m_proxyA;
				manifold.type = b2Manifold.e_faceB;
			}

			var edge1:int = primaryAxis.index;

			FindIncidentEdge(incidentEdge, proxy1, primaryAxis.index, proxy2);
			var count1:int = proxy1.count;
			//const b2Vec2* vertices1 = proxy1->vertices;
			var vertices1:Array = proxy1.vertices;

			var iv1:int = edge1;
			var iv2:int = edge1 + 1 < count1 ? edge1 + 1 : 0;

			//b2Vec2 v11 = vertices1[iv1];
			var v11:b2Vec2 = vertices1[iv1] as b2Vec2; // hacking
			//b2Vec2 v12 = vertices1[iv2];
			var v12:b2Vec2 = vertices1[iv2] as b2Vec2; // hacking

			//b2Vec2 tangent = v12 - v11;
			var tangent:b2Vec2 = new b2Vec2 ();
			tangent.x = v12.x - v11.x;
			tangent.y = v12.y - v11.y;
			tangent.Normalize();
			
			//b2Vec2 normal = b2Cross(tangent, 1.0f);
			var normal:b2Vec2 = b2Math.b2Cross_Vector2AndScalar (tangent, 1.0);
			//b2Vec2 planePoint = 0.5f * (v11 + v12);
			var planePoint:b2Vec2 = new b2Vec2 ();
			planePoint.x = 0.5 * (v11.x + v12.x);
			planePoint.y = 0.5 * (v11.y + v12.y);

			// Face offset.
			var frontOffset:Number = b2Math.b2Dot2 (normal, v11);

			// Side offsets, extended by polytope skin thickness.
			var sideOffset1:Number = -b2Math.b2Dot2(tangent, v11) + m_radius;
			var sideOffset2:Number = b2Math.b2Dot2(tangent, v12) + m_radius;

			// Clip incident edge against extruded edge1 side edges.
			//b2ClipVertex clipPoints1[2];
			//b2ClipVertex clipPoints2[2];
			var clipPoints1:b2ClipVertexSegment = new b2ClipVertexSegment ();
			var clipPoints2:b2ClipVertexSegment = new b2ClipVertexSegment ();
			var np:int;

			// Clip to box side 1
			np = b2Collision.b2ClipSegmentToLine(clipPoints1, incidentEdge, tangent.GetNegative (), sideOffset1, iv1);

			if (np < b2Settings.b2_maxManifoldPoints)
			{
				return;
			}

			// Clip to negative box side 1
			np = b2Collision.b2ClipSegmentToLine(clipPoints2, clipPoints1,  tangent, sideOffset2, iv2);

			if (np < b2Settings.b2_maxManifoldPoints)
			{
				return;
			}

			// Now clipPoints2 contains the clipped points.
			if (primaryAxis.type == b2EPAxis.e_edgeA)
			{
				//manifold->localNormal = normal;
				manifold.localNormal.x = normal.x;
				manifold.localNormal.y = normal.y;
				//manifold->localPoint = planePoint;
				manifold.localPoint.x = planePoint.x;
				manifold.localPoint.y = planePoint.y;
			}
			else
			{
				//manifold->localNormal = b2MulT(m_xf.R, normal);
				b2Math.b2MulT_Matrix22AndVector2_Output (m_xf.R, normal, manifold.localNormal);
				//manifold->localPoint = b2MulT(m_xf, planePoint);
				b2Math.b2MulT_TransformAndVector2_Output (m_xf, planePoint, manifold.localPoint);
			}

			var pointCount:int = 0;
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++i)
			{
				var separation:Number;
				
				//separation = b2Dot(normal, clipPoints2[i].v) - frontOffset;
				var clipVertex:b2ClipVertex = clipPoints2.GetClipVertexById (i);
				separation = b2Math.b2Dot2 (normal, clipVertex.v) - frontOffset;

				if (separation <= m_radius)
				{
					var cp:b2ManifoldPoint = manifold.points [pointCount] as b2ManifoldPoint;

					if (primaryAxis.type == b2EPAxis.e_edgeA)
					{
						//cp->localPoint = b2MulT(m_xf, clipPoints2[i].v);
						b2Math.b2MulT_TransformAndVector2_Output (m_xf, clipVertex.v, cp.localPoint);
						//cp->id = clipPoints2[i].id;
						cp.id = clipVertex.id;
					}
					else
					{
						//cp->localPoint = clipPoints2[i].v;
						cp.localPoint.x = clipVertex.v.x;
						cp.localPoint.y = clipVertex.v.y;
						//cp->id.cf.typeA = clipPoints2[i].id.cf.typeB;
						//cp->id.cf.typeB = clipPoints2[i].id.cf.typeA;
						//cp->id.cf.indexA = clipPoints2[i].id.cf.indexB;
						//cp->id.cf.indexB = clipPoints2[i].id.cf.indexA;
						cp.id = clipVertex.id;
					}

					++pointCount;
				}
			}

			manifold.pointCount = pointCount;
		}

		// Compute allowable normal ranges based on adjacency.
		// A normal n is allowable iff:
		// cross(n, n1) >= 0.0f && cross(n2, n) >= 0.0f
		// n points from A to B (edge to polygon)
		public function ComputeAdjacency():void
		{
			//b2Vec2 v0 = m_edgeA.v0;
			//b2Vec2 v1 = m_edgeA.v1;
			//b2Vec2 v2 = m_edgeA.v2;
			//b2Vec2 v3 = m_edgeA.v3;
			var v0:b2Vec2 = m_edgeA.v0; // hacking, ref
			var v1:b2Vec2 = m_edgeA.v1; // hacking, ref
			var v2:b2Vec2 = m_edgeA.v2; // hacking, ref
			var v3:b2Vec2 = m_edgeA.v3; // hacking, ref

			// ...
			var e0:b2Vec2 = new b2Vec2 ();
			var e1:b2Vec2 = new b2Vec2 ();
			var e2:b2Vec2 = new b2Vec2 ();
			var n0:b2Vec2 = new b2Vec2 ();
			var n1:b2Vec2 = new b2Vec2 ();
			var n2:b2Vec2 = new b2Vec2 ();

			var tempV:b2Vec2 = new b2Vec2 ();

			var convex:Boolean;
			var front0:Boolean;
			var front1:Boolean;
			var front2:Boolean;

			// Determine allowable the normal regions based on adjacency.
			// Note: it may be possible that no normal is admissable.
			//b2Vec2 centerB = m_proxyB.centroid;
			var centerB:b2Vec2 = m_proxyB.centroid;
			if (m_edgeA.hasVertex0)
			{
				//b2Vec2 e0 = v1 - v0;
				e0.x = v1.x - v0.x;
				e0.y = v1.y - v0.y;
				//b2Vec2 e1 = v2 - v1;
				e1.x = v2.x - v1.x;
				e1.y = v2.y - v1.y;
				//b2Vec2 n0(e0.y, -e0.x);
				n0.x = e0.y;
				n0.y = -e0.x;
				//b2Vec2 n1(e1.y, -e1.x);
				n1.x = e1.y;
				n1.y = -e1.x;
				n0.Normalize();
				n1.Normalize();

				convex = b2Math.b2Cross2 (n0, n1) >= 0.0;
				//bool front0 = b2Dot(n0, centerB - v0) >= 0.0f;
				tempV.x = centerB.x - v0.x;
				tempV.y = centerB.y - v0.y;
				front0 = b2Math.b2Dot2(n0, tempV) >= 0.0;
				//bool front1 = b2Dot(n1, centerB - v1) >= 0.0f;
				tempV.x = centerB.x - v1.x;
				tempV.y = centerB.y - v1.y;
				front1 = b2Math.b2Dot2 (n1, tempV) >= 0.0;

				if (convex)
				{
					if (front0 || front1)
					{
						m_limit11.x = n1.x;
						m_limit11.y = n1.y;
						m_limit12.x = n0.x;
						m_limit12.y = n0.y;
					}
					else
					{
						m_limit11.x = -n1.x;
						m_limit11.y = -n1.y;
						m_limit12.x = -n0.x;
						m_limit12.y = -n0.y;
					}
				}
				else
				{
					if (front0 && front1)
					{
						m_limit11.x = n0.x;
						m_limit11.y = n0.y;
						m_limit12.x = n1.x;
						m_limit12.y = n1.y;
					}
					else
					{
						m_limit11.x = -n0.x;
						m_limit11.y = -n0.y;
						m_limit12.x = -n1.x;
						m_limit12.y = -n1.y;
					}
				}
			}
			else
			{
				m_limit11.SetZero();
				m_limit12.SetZero();
			}

			if (m_edgeA.hasVertex3)
			{
				//b2Vec2 e1 = v2 - v1;
				e1.x = v2.x - v1.x;
				e1.y = v2.y - v1.y;
				//b2Vec2 e2 = v3 - v2;
				e2.x = v3.x - v2.x;
				e2.y = v3.y - v2.y;
				//b2Vec2 n1(e1.y, -e1.x);
				n1.x = e1.y;
				n1.y = -e1.x;
				//b2Vec2 n2(e2.y, -e2.x);
				n2.x = e2.y;
				n2.y = -e2.x;
				n1.Normalize();
				n2.Normalize();

				convex = b2Math.b2Cross2 (n1, n2) >= 0.0;
				//bool front1 = b2Dot(n1, centerB - v1) >= 0.0f;
				tempV.x = centerB.x - v1.x;
				tempV.y = centerB.y - v1.y;
				front1 = b2Math.b2Dot2 (n1, tempV) >= 0.0;
				//bool front2 = b2Dot(n2, centerB - v2) >= 0.0f;
				tempV.x = centerB.x - v2.x;
				tempV.y = centerB.y - v2.y;
				front2 = b2Math.b2Dot2 (n2, tempV) >= 0.0;

				if (convex)
				{
					if (front1 || front2)
					{
						m_limit21.x = n2.x;
						m_limit21.y = n2.y;
						m_limit22.x = n1.x;
						m_limit22.y = n1.y;
					}
					else
					{
						m_limit21.x = -n2.x;
						m_limit21.y = -n2.y;
						m_limit22.x = -n1.x;
						m_limit22.y = -n1.y;
					}
				}
				else
				{
					if (front1 && front2)
					{
						m_limit21.x = n1.x;
						m_limit21.y = n1.y;
						m_limit22.x = n2.x;
						m_limit22.y = n2.y;
					}
					else
					{
						m_limit21.x = -n1.x;
						m_limit21.y = -n1.y;
						m_limit22.x = -n2.x;
						m_limit22.y = -n2.y;
					}
				}
			}
			else
			{
				m_limit21.SetZero();
				m_limit22.SetZero();
			}
		}

		public function ComputeEdgeSeparation():b2EPAxis
		{
			// EdgeA separation
			var bestAxis:b2EPAxis = new b2EPAxis ();
			bestAxis.type = b2EPAxis.e_unknown;
			bestAxis.index = -1;
			bestAxis.separation = -Number.MAX_VALUE; //FLT_MAX;
			//b2Vec2 normals[2] = {m_edgeA.normal, -m_edgeA.normal};
			var normals:Array = [m_edgeA.normal, m_edgeA.normal.GetNegative ()];

			var axis:b2EPAxis = new b2EPAxis ();

			var tempV:b2Vec2 = new b2Vec2 ();

			for (var i:int = 0; i < 2; ++i)
			{
				//b2Vec2 n = normals[i];
				var n:b2Vec2 = normals[i] as b2Vec2;

				// Adjacency
				var valid1:Boolean = b2Math.b2Cross2 (n, m_limit11) >= -b2Settings.b2_angularSlop && b2Math.b2Cross2 (m_limit12, n) >= -b2Settings.b2_angularSlop;
				var valid2:Boolean = b2Math.b2Cross2 (n, m_limit21) >= -b2Settings.b2_angularSlop && b2Math.b2Cross2 (m_limit22, n) >= -b2Settings.b2_angularSlop;

				if (valid1 == false || valid2 == false)
				{
					continue;
				}
				
				//b2EPAxis axis;
				axis.type = b2EPAxis.e_edgeA;
				axis.index = i;
				axis.separation = Number.MAX_VALUE;

				for (var j:int = 0; j < m_proxyB.count; ++j)
				{
					//float32 s = b2Dot(n, m_proxyB.vertices[j] - m_edgeA.v1);
					var aVertex:b2Vec2 = m_proxyB.vertices[j] as b2Vec2;
					tempV.x = aVertex.x - m_edgeA.v1.x;
					tempV.y = aVertex.y - m_edgeA.v1.y;
					var s:Number = b2Math.b2Dot2 (n, tempV);
					if (s < axis.separation)
					{
						axis.separation = s;
					}
				}

				if (axis.separation > m_radius)
				{
					return axis;
				}

				if (axis.separation > bestAxis.separation)
				{
					bestAxis = axis;
				}
			}

			return bestAxis;
		}

		public function ComputePolygonSeparation():b2EPAxis
		{
			var axis:b2EPAxis = new b2EPAxis ();
			axis.type = b2EPAxis.e_unknown;
			axis.index = -1;
			axis.separation = -Number.MAX_VALUE;

			var n:b2Vec2 = new b2Vec2 ();

			var tempV:b2Vec2 = new b2Vec2 ();
			var refV:b2Vec2;

			for (var i:int = 0; i < m_proxyB.count; ++i)
			{
				//b2Vec2 n = -m_proxyB.normals[i];
				refV = m_proxyB.normals[i] as b2Vec2;
				n.x = -refV.x;
				n.y = -refV.y;

				// Adjacency
				var valid1:Boolean = b2Math.b2Cross2 (n, m_limit11) >= -b2Settings.b2_angularSlop && b2Math.b2Cross2 (m_limit12, n) >= -b2Settings.b2_angularSlop;
				var valid2:Boolean = b2Math.b2Cross2 (n, m_limit21) >= -b2Settings.b2_angularSlop && b2Math.b2Cross2 (m_limit22, n) >= -b2Settings.b2_angularSlop;

				if (valid1 == false && valid2 == false)
				{
					continue;
				}

				refV = m_proxyB.vertices[i] as b2Vec2;

				//float32 s1 = b2Dot(n, m_proxyB.vertices[i] - m_edgeA.v1);
				tempV.x = refV.x - m_edgeA.v1.x;
				tempV.y = refV.y - m_edgeA.v1.y;
				var s1:Number = b2Math.b2Dot2 (n, tempV);
				//float32 s2 = b2Dot(n, m_proxyB.vertices[i] - m_edgeA.v2);
				tempV.x = refV.x - m_edgeA.v2.x;
				tempV.y = refV.y - m_edgeA.v2.y;
				var s2:Number = b2Math.b2Dot2 (n, tempV);
				var s:Number = Math.min (s1, s2);

				if (s > m_radius)
				{
					axis.type = b2EPAxis.e_edgeB;
					axis.index = i;
					axis.separation = s;
				}

				if (s > axis.separation)
				{
					axis.type = b2EPAxis.e_edgeB;
					axis.index = i;
					axis.separation = s;
				}
			}

			return axis;
		}

		//void b2EPCollider::FindIncidentEdge(b2ClipVertex c[2], const b2EPProxy* proxy1, int32 edge1, const b2EPProxy* proxy2)
		public function FindIncidentEdge(c:b2ClipVertexSegment, proxy1:b2EPProxy, edge1:int, proxy2:b2EPProxy):void
		{
			var count1:int = proxy1.count;
			//const b2Vec2* normals1 = proxy1->normals;
			var normals1:Array = proxy1.normals;

			var count2:int = proxy2.count;
			//const b2Vec2* vertices2 = proxy2->vertices;
			var vertices2:Array = proxy2.vertices;
			//const b2Vec2* normals2 = proxy2->normals;
			var normals2:Array = proxy2.normals;

			//b2Assert(0 <= edge1 && edge1 < count1);

			// Get the normal of the reference edge in proxy2's frame.
			//b2Vec2 normal1 = normals1[edge1];
			var normal1:b2Vec2 = normals1[edge1] as b2Vec2;

			// Find the incident edge on proxy2.
			var index:int = 0;
			var minDot:Number = b2Settings.b2_maxFloat;
			for (var i:int = 0; i < count2; ++i)
			{
				var dot:Number = b2Math.b2Dot2 (normal1, normals2[i] as b2Vec2);
				if (dot < minDot)
				{
					minDot = dot;
					index = i;
				}
			}

			// Build the clip vertices for the incident edge.
			var i1:int = index;
			var i2:int = i1 + 1 < count2 ? i1 + 1 : 0;

			var cv:b2Vec2;
			var vertex:b2Vec2;

			//c[0].v = vertices2[i1];
			cv = c.clipVertex0.v;
			vertex = vertices2[i1] as b2Vec2;
			cv.x = vertex.x;
			cv.y = vertex.y;
			//c[0].id.cf.indexA = (uint8)edge1;
			//c[0].id.cf.indexB = (uint8)i1;
			//c[0].id.cf.typeA = b2ContactFeature::e_face;
			//c[0].id.cf.typeB = b2ContactFeature::e_vertex;
			c.clipVertex0.id = b2ContactID.ContactID_FromFeature (edge1 & 0xFF, i1 & 0xFF, b2ContactID.b2ContactFeature_e_face, b2ContactID.b2ContactFeature_e_vertex); // hacking

			//c[1].v = vertices2[i2];
			cv = c.clipVertex1.v;
			vertex = vertices2[i2] as b2Vec2;
			cv.x = vertex.x;
			cv.y = vertex.y;
			//c[1].id.cf.indexA = (uint8)edge1;
			//c[1].id.cf.indexB = (uint8)i2;
			//c[1].id.cf.typeA = b2ContactFeature::e_face;
			//c[1].id.cf.typeB = b2ContactFeature::e_vertex;
			c.clipVertex1.id = b2ContactID.ContactID_FromFeature (edge1 & 0xFF, i2 & 0xFF, b2ContactID.b2ContactFeature_e_face, b2ContactID.b2ContactFeature_e_vertex); // hacking
		}
	} // class
} // package
