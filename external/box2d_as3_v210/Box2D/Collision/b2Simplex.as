
package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	
	public class b2Simplex
	{
		//this function doesn't exist in the c++ version
		public function GetSimplexVertex (id:int):b2SimplexVertex
		{
			switch (id)
			{
				case 0: return m_v1;
				case 1: return m_v2;
				case 2: return m_v3;
				default: return null;
			}
		}

		public function ReadCache(	cache:b2SimplexCache,
						proxyA:b2DistanceProxy, transformA:b2Transform,
						proxyB:b2DistanceProxy, transformB:b2Transform):void
		{
			//b2Assert(0 <= cache->count && cache->count <= 3);
			
			// Copy data from cache.
			m_count = cache.count;
			//b2SimplexVertex* vertices = &m_v1;
			for (var i:int = 0; i < m_count; ++i)
			{
				//b2SimplexVertex* v = vertices + i;
				var v1:b2SimplexVertex = GetSimplexVertex (i);
				v1.indexA = cache.indexA[i];
				v1.indexB = cache.indexB[i];
				var wALocal1:b2Vec2 = proxyA.GetVertex(v1.indexA);//.Clone ();
				var wBLocal1:b2Vec2 = proxyB.GetVertex(v1.indexB);//.Clone ();
				//v->wA = b2Mul(transformA, wALocal1);
				//v->wB = b2Mul(transformB, wBLocal1);
				//v->w = v->wB - v->wA;
				b2Math.b2Mul_TransformAndVector2_Output (transformA, wALocal1, v1.wA);
				b2Math.b2Mul_TransformAndVector2_Output (transformB, wBLocal1, v1.wB);
				v1.w.x = v1.wB.x - v1.wA.x;
				v1.w.y = v1.wB.y - v1.wA.y;
				v1.a = 0.0;
			}

			// Compute the new simplex metric, if it is substantially different than
			// old metric then flush the simplex.
			if (m_count > 1)
			{
				var metric1:Number = cache.metric;
				var metric2:Number = GetMetric();
				if (metric2 < 0.5 * metric1 || 2.0 * metric1 < metric2 || metric2 < b2Settings.B2_FLT_EPSILON)
				{
					// Reset the simplex.
					m_count = 0;
				}
			}

			// If the cache is empty or invalid ...
			if (m_count == 0)
			{
				//b2SimplexVertex* v = vertices + 0;
				var v2:b2SimplexVertex = m_v1;
				v2.indexA = 0;
				v2.indexB = 0;
				var wALocal2:b2Vec2 = proxyA.GetVertex(0); // Clone ()
				var wBLocal2:b2Vec2 = proxyB.GetVertex(0); // Clone ()
				//v->wA = b2Mul(transformA, wALocal2);
				//v->wB = b2Mul(transformB, wBLocal2);
				//v->w = v->wB - v->wA;
				b2Math.b2Mul_TransformAndVector2_Output (transformA, wALocal2, v2.wA);
				b2Math.b2Mul_TransformAndVector2_Output (transformB, wBLocal2, v2.wB);
				v2.w.x = v2.wB.x - v2.wA.x;
				v2.w.y = v2.wB.y - v2.wA.y;
				m_count = 1;
			}
		}

		public function WriteCache (cache:b2SimplexCache):void
		{
			cache.metric = GetMetric();
			//cache->count = uint16(m_count);
			cache.count = uint(m_count);
			//const b2SimplexVertex* vertices = &m_v1;
			for (var i:int = 0; i < m_count; ++i)
			{
				//cache->indexA[i] = uint8(vertices[i].indexA);
				//cache->indexB[i] = uint8(vertices[i].indexB);
				var v:b2SimplexVertex = GetSimplexVertex (i);
				cache.indexA[i] = uint(v.indexA);
				cache.indexB[i] = uint(v.indexB);
			}
		}

		public function GetSearchDirection():b2Vec2
		{
			switch (m_count)
			{
			case 1:
				//return -m_v1.w;
				return m_v1.w.GetNegative ();

			case 2:
				{
					//b2Vec2 e12 = m_v2.w - m_v1.w;
					//float32 sgn = b2Math.b2Cross2(e12, -m_v1.w);
					var e12:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (m_v2.w.x - m_v1.w.x, m_v2.w.y - m_v1.w.y);
					var sgn:Number = b2Math.b2Cross2 (e12, m_v1.w.GetNegative ());
					if (sgn > 0.0)
					{
						// Origin is left of e12.
						return b2Math.b2Cross_ScalarAndVector2 (1.0, e12);
					}
					else
					{
						// Origin is right of e12.
						return b2Math.b2Cross_Vector2AndScalar (e12, 1.0);
					}
				}

			default:
				//b2Assert(false);
				return b2Math.b2Vec2_zero.Clone ();
			}
		}

		public function GetClosestPoint():b2Vec2
		{
			switch (m_count)
			{
			case 0:
				//b2Assert(false);
				return b2Math.b2Vec2_zero.Clone ();

			case 1:
				return m_v1.w.Clone ();

			case 2:
				//return m_v1.a * m_v1.w + m_v2.a * m_v2.w;
				return b2Vec2.b2Vec2_From2Numbers (m_v1.a * m_v1.w.x + m_v2.a * m_v2.w.x, m_v1.a * m_v1.w.y + m_v2.a * m_v2.w.y);

			case 3:
				return b2Math.b2Vec2_zero.Clone ();

			default:
				//b2Assert(false);
				return b2Math.b2Vec2_zero.Clone ();
			}
		}

		public function GetWitnessPoints(pA:b2Vec2, pB:b2Vec2):void
		{
			switch (m_count)
			{
			case 0:
				//b2Assert(false);
				break;

			case 1:
				//*pA = m_v1.wA;
				//*pB = m_v1.wB;
				pA.x = m_v1.wA.x;
				pA.y = m_v1.wA.y;
				pB.x = m_v1.wB.x;
				pB.y = m_v1.wB.y;
				break;

			case 2:
				//*pA = m_v1.a * m_v1.wA + m_v2.a * m_v2.wA;
				//*pB = m_v1.a * m_v1.wB + m_v2.a * m_v2.wB;
				pA.x = m_v1.a * m_v1.wA.x + m_v2.a * m_v2.wA.x;
				pA.y = m_v1.a * m_v1.wA.y + m_v2.a * m_v2.wA.y;
				pB.x = m_v1.a * m_v1.wB.x + m_v2.a * m_v2.wB.x;
				pB.y = m_v1.a * m_v1.wB.y + m_v2.a * m_v2.wB.y;
				break;

			case 3:
				//*pA = m_v1.a * m_v1.wA + m_v2.a * m_v2.wA + m_v3.a * m_v3.wA;
				//*pB = *pA;
				pA.x = m_v1.a * m_v1.wA.x + m_v2.a * m_v2.wA.x + m_v3.a * m_v3.wA.x;
				pA.y = m_v1.a * m_v1.wA.y + m_v2.a * m_v2.wA.y + m_v3.a * m_v3.wA.y;
				pB.x = pA.x;
				pB.y = pA.y;
				break;

			default:
				//b2Assert(false);
				break;
			}
		}

		public function GetMetric():Number
		{
			switch (m_count)
			{
			case 0:
				//b2Assert(false);
				return 0.0;

			case 1:
				return 0.0;

			case 2:
				return b2Math.b2Distance (m_v1.w, m_v2.w);

			case 3:
				//return b2Math.b2Cross2(m_v2.w - m_v1.w, m_v3.w - m_v1.w);
				return b2Math.b2Cross2(b2Math.b2Subtract_Vector2 (m_v2.w, m_v1.w), b2Math.b2Subtract_Vector2 (m_v3.w, m_v1.w));

			default:
				//b2Assert(false);
				return 0.0;
			}
		}

		//void Solve2();
		//void Solve3();

		public var m_v1:b2SimplexVertex = new b2SimplexVertex (), m_v2:b2SimplexVertex = new b2SimplexVertex (), m_v3:b2SimplexVertex = new b2SimplexVertex ();
		public var m_count:int;
		
		// Solve a line segment using barycentric coordinates.
		//
		// p = a1 * w1 + a2 * w2
		// a1 + a2 = 1
		//
		// The vector from the origin to the closest point on the line is
		// perpendicular to the line.
		// e12 = w2 - w1
		// dot(p, e) = 0
		// a1 * dot(w1, e) + a2 * dot(w2, e) = 0
		//
		// 2-by-2 linear system
		// [1      1     ][a1] = [1]
		// [w1.e12 w2.e12][a2] = [0]
		//
		// Define
		// d12_1 =  dot(w2, e12)
		// d12_2 = -dot(w1, e12)
		// d12 = d12_1 + d12_2
		//
		// Solution
		// a1 = d12_1 / d12
		// a2 = d12_2 / d12
		public function Solve2():void
		{
			var w1:b2Vec2 = m_v1.w; //.Clone ()
			var w2:b2Vec2 = m_v2.w; //.Clone ()
			//b2Vec2 e12 = w2 - w1;
			var e12:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (w2.x - w1.x, w2.y - w1.y);

			// w1 region
			var d12_2:Number = - b2Math.b2Dot2 (w1, e12);
			if (d12_2 <= 0.0)
			{
				// a2 <= 0, so we clamp it to 0
				m_v1.a = 1.0;
				m_count = 1;
				return;
			}

			// w2 region
			var d12_1:Number = b2Math.b2Dot2 (w2, e12);
			if (d12_1 <= 0.0)
			{
				// a1 <= 0, so we clamp it to 0
				m_v2.a = 1.0;
				m_count = 1;
				m_v1.CopyFrom (m_v2);
				return;
			}

			// Must be in e12 region.
			var inv_d12:Number = 1.0 / (d12_1 + d12_2);
			m_v1.a = d12_1 * inv_d12;
			m_v2.a = d12_2 * inv_d12;
			m_count = 2;
		}

		// Possible regions:
		// - points[2]
		// - edge points[0]-points[2]
		// - edge points[1]-points[2]
		// - inside the triangle
		public function Solve3():void
		{
			var w1:b2Vec2 = m_v1.w; //.Clone ()
			var w2:b2Vec2 = m_v2.w; //.Clone ()
			var w3:b2Vec2 = m_v3.w; //.Clone ()

			// Edge12
			// [1      1     ][a1] = [1]
			// [w1.e12 w2.e12][a2] = [0]
			// a3 = 0
			//b2Vec2 e12 = w2 - w1;
			var e12:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (w2.x - w1.x, w2.y - w1.y);
			var w1e12:Number = b2Math.b2Dot2 (w1, e12);
			var w2e12:Number = b2Math.b2Dot2 (w2, e12);
			var d12_1:Number = w2e12;
			var d12_2:Number = -w1e12;

			// Edge13
			// [1      1     ][a1] = [1]
			// [w1.e13 w3.e13][a3] = [0]
			// a2 = 0
			//b2Vec2 e13 = w3 - w1;
			var e13:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (w3.x - w1.x, w3.y - w1.y);
			var w1e13:Number = b2Math.b2Dot2 (w1, e13);
			var w3e13:Number = b2Math.b2Dot2 (w3, e13);
			var d13_1:Number = w3e13;
			var d13_2:Number = -w1e13;

			// Edge23
			// [1      1     ][a2] = [1]
			// [w2.e23 w3.e23][a3] = [0]
			// a1 = 0
			//b2Vec2 e23 = w3 - w2;
			var e23:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (w3.x - w2.x, w3.y - w2.y);
			var w2e23:Number = b2Math.b2Dot2 (w2, e23);
			var w3e23:Number = b2Math.b2Dot2 (w3, e23);
			var d23_1:Number = w3e23;
			var d23_2:Number = -w2e23;
			
			// Triangle123
			var n123:Number = b2Math.b2Cross2(e12, e13);

			var d123_1:Number = n123 * b2Math.b2Cross2 (w2, w3);
			var d123_2:Number = n123 * b2Math.b2Cross2 (w3, w1);
			var d123_3:Number = n123 * b2Math.b2Cross2 (w1, w2);

			// w1 region
			if (d12_2 <= 0.0 && d13_2 <= 0.0)
			{
				m_v1.a = 1.0;
				m_count = 1;
				return;
			}

			// e12
			if (d12_1 > 0.0 && d12_2 > 0.0 && d123_3 <= 0.0)
			{
				var inv_d12:Number = 1.0 / (d12_1 + d12_2);
				m_v1.a = d12_1 * inv_d12;
				m_v2.a = d12_1 * inv_d12;
				m_count = 2;
				return;
			}

			// e13
			if (d13_1 > 0.0 && d13_2 > 0.0 && d123_2 <= 0.0)
			{
				var inv_d13:Number = 1.0 / (d13_1 + d13_2);
				m_v1.a = d13_1 * inv_d13;
				m_v3.a = d13_2 * inv_d13;
				m_count = 2;
				m_v2.CopyFrom (m_v3);
				return;
			}

			// w2 region
			if (d12_1 <= 0.0 && d23_2 <= 0.0)
			{
				m_v2.a = 1.0;
				m_count = 1;
				m_v1.CopyFrom (m_v2);
				return;
			}

			// w3 region
			if (d13_1 <= 0.0 && d23_1 <= 0.0)
			{
				m_v3.a = 1.0;
				m_count = 1;
				m_v1.CopyFrom (m_v3);
				return;
			}

			// e23
			if (d23_1 > 0.0 && d23_2 > 0.0 && d123_1 <= 0.0)
			{
				var inv_d23:Number = 1.0 / (d23_1 + d23_2);
				m_v2.a = d23_1 * inv_d23;
				m_v3.a = d23_2 * inv_d23;
				m_count = 2;
				m_v1.CopyFrom (m_v3);
				return;
			}

			// Must be in triangle123
			var inv_d123:Number = 1.0 / (d123_1 + d123_2 + d123_3);
			m_v1.a = d123_1 * inv_d123;
			m_v2.a = d123_2 * inv_d123;
			m_v3.a = d123_3 * inv_d123;
			m_count = 3;
		}
	}// class
} // package
