package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	
	public class b2SeparationFunction
	{
		//enum Type
		//{
			public static const e_points:int = 0;
			public static const e_faceA:int =1;
			public static const e_faceB:int = 2;
		//};

		public function Initialize(cache:b2SimplexCache,
			proxyA:b2DistanceProxy, transformA:b2Transform,
			proxyB:b2DistanceProxy, transformB:b2Transform):void
		{
			m_proxyA = proxyA;
			m_proxyB = proxyB;
			var count:int = cache.count;
			//b2Assert(0 < count && count < 3);

			var pointA:b2Vec2;
			var pointB:b2Vec2;
			var localPointA:b2Vec2;
			var localPointA1:b2Vec2;
			var localPointA2:b2Vec2;
			var localPointB:b2Vec2;
			var localPointB1:b2Vec2;
			var localPointB2:b2Vec2;
			var normal:b2Vec2;
			var s:Number;
			var sgn:Number;

			if (count == 1)
			{
				m_type = e_points;
				//b2Vec2 localPointA = m_proxyA->GetVertex(cache->indexA[0]);
				//b2Vec2 localPointB = m_proxyB->GetVertex(cache->indexB[0]);
				pointA = b2Math.b2Mul_TransformAndVector2(transformA, m_proxyA.GetVertex(cache.indexA[0]));
				pointB = b2Math.b2Mul_TransformAndVector2(transformB, m_proxyB.GetVertex(cache.indexB[0]));
				//m_axis = pointB - pointA;
				m_axis.x = pointB.x - pointA.x;
				m_axis.y = pointB.y - pointA.y;
				m_axis.Normalize();
			}
			else if (cache.indexB[0] == cache.indexB[1])
			{
				// Two points on A and one on B
				m_type = e_faceA;
				//b2Vec2 localPointA1 = m_proxyA->GetVertex(cache->indexA[0]);
				//b2Vec2 localPointA2 = m_proxyA->GetVertex(cache->indexA[1]);
				//b2Vec2 localPointB = m_proxyB->GetVertex(cache->indexB[0]);
				//m_localPoint = 0.5f * (localPointA1 + localPointA2);
				//m_axis = b2Math.b2Cross2(localPointA2 - localPointA1, 1.0f);
				//m_axis.Normalize();
				//
				//b2Vec2 normal = b2Mul(transformA.R, m_axis);
				//b2Vec2 pointA = b2Mul(transformA, m_localPoint);
				//b2Vec2 pointB = b2Mul(transformB, localPointB);
				//
				//float32 s = b2Math.b2Dot2(pointB - pointA, normal);
				
				localPointA1 = m_proxyA.GetVertex(cache.indexA[0]).Clone ();
				localPointA2 = m_proxyA.GetVertex(cache.indexA[1]).Clone ();
				m_localPoint.x = 0.5 * (localPointA1.x + localPointA2.x);
				m_localPoint.y = 0.5 * (localPointA1.y + localPointA2.y);
				localPointA2.Subtract (localPointA1);
				b2Math.b2Cross_Vector2AndScalar_Output (localPointA2, 1.0, m_axis);
				m_axis.Normalize();

				pointB = localPointA2; b2Math.b2Mul_TransformAndVector2_Output (transformB, m_proxyB.GetVertex(cache.indexB[0]), pointB);
				pointA = localPointA1; b2Math.b2Mul_TransformAndVector2_Output (transformA, m_localPoint, pointA);
				pointB.Subtract (pointA); 
				// localPointA1 is not used now
				normal = localPointA1; b2Math.b2Mul_Matrix22AndVector2_Output (transformA.R, m_axis, normal);

				s = b2Math.b2Dot2 (pointB, normal);

				if (s < 0.0)
				{
					//m_axis = -m_axis;
					m_axis.x = -m_axis.x;
					m_axis.y = -m_axis.y;
				}
			}
			else if (cache.indexA[0] == cache.indexA[1])
			{
				// Two points on B and one on A.
				m_type = e_faceB;
				//b2Vec2 localPointA = proxyA->GetVertex(cache->indexA[0]);
				//b2Vec2 localPointB1 = proxyB->GetVertex(cache->indexB[0]);
				//b2Vec2 localPointB2 = proxyB->GetVertex(cache->indexB[1]);
				//m_localPoint = 0.5f * (localPointB1 + localPointB2);
				//m_axis = b2Math.b2Cross2(localPointB2 - localPointB1, 1.0f);
				//m_axis.Normalize();
				//
				//b2Vec2 normal = b2Mul(transformB.R, m_axis);
				//b2Vec2 pointB = b2Mul(transformB, m_localPoint);
				//b2Vec2 pointA = b2Mul(transformA, localPointA);
				//
				//float32 s = b2Math.b2Dot2(pointA - pointB, normal);
				
				localPointB1 = proxyB.GetVertex(cache.indexB[0]).Clone ();
				localPointB2 = proxyB.GetVertex(cache.indexB[1]).Clone ();
				//m_localPoint = 0.5 * (localPointB1 + localPointB2);
				m_localPoint.Set (0.5 * (localPointB1.x + localPointB2.x), 0.5 * (localPointB1.y + localPointB2.y));
				localPointB2.Subtract (localPointB1);
				b2Math.b2Cross_Vector2AndScalar_Output (localPointB2, 1.0, m_axis);
				m_axis.Normalize();

				pointB = localPointB2; b2Math.b2Mul_TransformAndVector2_Output (transformB, m_localPoint, pointB);
				pointA = localPointB1; b2Math.b2Mul_TransformAndVector2_Output (transformA, proxyA.GetVertex(cache.indexA[0]), pointA);
				pointA.Subtract (pointB);
				// localPointB2 is not used now
				normal = localPointB2; b2Math.b2Mul_Matrix22AndVector2_Output (transformB.R, m_axis, normal);

				s = b2Math.b2Dot2(pointA, normal);
				if (s < 0.0)
				{
					//m_axis = -m_axis;
					m_axis.x = -m_axis.x;
					m_axis.y = -m_axis.y;
				}
			}
			else
			{
				// Two points on B and two points on A.
				// The faces are parallel.
				//var localPointA1:b2Vec2 = m_proxyA->GetVertex(cache->indexA[0]).Clone ();
				//var localPointA2:b2Vec2 = m_proxyA->GetVertex(cache->indexA[1]).Clone ();
				//var localPointB1:b2Vec2 = m_proxyB->GetVertex(cache->indexB[0]).Clone ();
				//var localPointB2:b2Vec2 = m_proxyB->GetVertex(cache->indexB[1]).Clone ();
				//
				//b2Vec2 pA = b2Mul(transformA, localPointA1);
				//b2Vec2 dA = b2Mul(transformA.R, localPointA2 - localPointA1);
				//b2Vec2 pB = b2Mul(transformB, localPointB1);
				//b2Vec2 dB = b2Mul(transformB.R, localPointB2 - localPointB1);
				//
				//float32 a = b2Math.b2Dot2(dA, dA);
				//float32 e = b2Math.b2Dot2(dB, dB);
				//b2Vec2 r = pA - pB;
				//float32 c = b2Math.b2Dot2(dA, r);
				//float32 f = b2Math.b2Dot2(dB, r);
				//
				//float32 b = b2Math.b2Dot2(dA, dB);
				//float32 denom = a * e - b * b;

				localPointA1 = m_proxyA.GetVertex(cache.indexA[0]).Clone ();
				localPointA2 = m_proxyA.GetVertex(cache.indexA[1]).Clone ();
				localPointB1 = m_proxyB.GetVertex(cache.indexB[0]).Clone ();
				localPointB2 = m_proxyB.GetVertex(cache.indexB[1]).Clone ();
				
				localPointA2.Subtract (localPointA1);
				localPointB2.Subtract (localPointB1);
				
				var pA:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (transformA, localPointA1);
				var dA:b2Vec2 = b2Math.b2Mul_Matrix22AndVector2 (transformA.R, localPointA2);
				var pB:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (transformB, localPointB1);
				var dB:b2Vec2 = b2Math.b2Mul_Matrix22AndVector2 (transformB.R, localPointB2);

				var a:Number = b2Math.b2Dot2 (dA, dA);
				var e:Number = b2Math.b2Dot2 (dB, dB);
				var r:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (pA.x - pB.x, pA.y - pB.y);
				var c:Number = b2Math.b2Dot2 (dA, r);
				var f:Number = b2Math.b2Dot2 (dB, r);

				var b:Number = b2Math.b2Dot2(dA, dB);
				var denom:Number = a * e - b * b;

				s = 0.0;
				if (denom != 0.0)
				{
					s = b2Math.b2Clamp_Number ((b * f - c * e) / denom, 0.0, 1.0);
				}

				var t:Number = (b * s + f) / e;

				if (t < 0.0)
				{
					t = 0.0;
					s = b2Math.b2Clamp_Number (-c / a, 0.0, 1.0);
				}
				else if (t > 1.0)
				{
					t = 1.0;
					s = b2Math.b2Clamp_Number ((b - c) / a, 0.0, 1.0);
				}

				//b2Vec2 localPointA = localPointA1 + s * (localPointA2 - localPointA1);
				//b2Vec2 localPointB = localPointB1 + t * (localPointB2 - localPointB1);

				localPointA = pA; localPointA.x = localPointA1.x + s * localPointA2.x; localPointA.y = localPointA1.y + s * localPointA2.y;
				localPointB = pB; localPointB.x = localPointB1.x + t * localPointB2.x; localPointB.y = localPointB1.y + t * localPointB2.y;

				if (s == 0.0 || s == 1.0)
				{
					m_type = e_faceB;
					//m_axis = b2Math.b2Cross2(localPointB2 - localPointB1, 1.0f);
					b2Math.b2Cross_Vector2AndScalar_Output (localPointB2, 1.0, m_axis);
					m_axis.Normalize();

					//m_localPoint = localPointB;
					m_localPoint.x = localPointB.x;
					m_localPoint.y = localPointB.y;

					//b2Vec2 normal = b2Mul(transformB.R, m_axis);
					//b2Vec2 pointA = b2Mul(transformA, localPointA);
					//b2Vec2 pointB = b2Mul(transformB, localPointB);
					
					normal = r ;  b2Math.b2Mul_Matrix22AndVector2_Output (transformB.R, m_axis, normal);
					pointA = dA;  b2Math.b2Mul_TransformAndVector2_Output (transformA, localPointA, pointA);
					pointB = dB;  b2Math.b2Mul_TransformAndVector2_Output (transformB, localPointB, pointB);

					//float32 sgn = b2Math.b2Dot2(pointA - pointB, normal);
					
					pointA.Subtract (pointB);
					sgn = b2Math.b2Dot2 (pointA, normal);
					if (sgn < 0.0)
					{
						//m_axis = -m_axis;
						m_axis.x = -m_axis.x;
						m_axis.y = -m_axis.y;
					}
				}
				else
				{
					m_type = e_faceA;
					//m_axis = b2Math.b2Cross2(localPointA2 - localPointA1, 1.0f);
					b2Math.b2Cross_Vector2AndScalar_Output (localPointA2, 1.0, m_axis);
					m_axis.Normalize();

					m_localPoint.x = localPointA.x;
					m_localPoint.y = localPointA.y;

					//b2Vec2 normal = b2Mul(transformA.R, m_axis);
					//b2Vec2 pointA = b2Mul(transformA, localPointA);
					//b2Vec2 pointB = b2Mul(transformB, localPointB);

					normal = r ;  b2Math.b2Mul_Matrix22AndVector2_Output (transformA.R, m_axis, normal);
					pointA = dA;  b2Math.b2Mul_TransformAndVector2_Output (transformA, localPointA, pointA);
					pointB = dB;  b2Math.b2Mul_TransformAndVector2_Output (transformB, localPointB, pointB);

					//float32 sgn = b2Math.b2Dot2(pointB - pointA, normal);
					pointB.Subtract (pointA);
					sgn = b2Math.b2Dot2(pointB, normal);
					if (sgn < 0.0)
					{
						//m_axis = -m_axis;
						m_axis.x = -m_axis.x;
						m_axis.y = -m_axis.y;
					}
				}
			}
		}

		public function Evaluate(transformA:b2Transform, transformB:b2Transform):Number
		{
			var axisA:b2Vec2;
			var axisB:b2Vec2;
			var pointA:b2Vec2;
			var pointB:b2Vec2;
			var normal:b2Vec2;
			var _normal:b2Vec2;
			var separation:Number;

			switch (m_type)
			{
			case e_points:
				{
					//b2Vec2 axisA = b2MulT(transformA.R,  m_axis);
					//b2Vec2 axisB = b2MulT(transformB.R, -m_axis);
					//b2Vec2 localPointA = m_proxyA->GetSupportVertex(axisA);
					//b2Vec2 localPointB = m_proxyB->GetSupportVertex(axisB);
					//b2Vec2 pointA = b2Mul(transformA, localPointA);
					//b2Vec2 pointB = b2Mul(transformB, localPointB);
					//float32 separation = b2Math.b2Dot2(pointB - pointA, m_axis);
					
					axisA = b2Math.b2MulTrans_Matrix22AndVector2 (transformA.R,  m_axis);
					axisB = b2Math.b2MulTrans_Matrix22AndVector2 (transformB.R,  m_axis.GetNegative ());
					pointA = axisA; b2Math.b2Mul_TransformAndVector2_Output (transformA, m_proxyA.GetSupportVertex(axisA), pointA);
					pointB = axisB; b2Math.b2Mul_TransformAndVector2_Output (transformB, m_proxyB.GetSupportVertex(axisB), pointB);
					pointB.Subtract (pointA);
					separation = b2Math.b2Dot2 (pointB, m_axis);
					return separation;
				}

			case e_faceA:
				{
					//b2Vec2 normal = b2Mul(transformA.R, m_axis);
					//b2Vec2 pointA = b2Mul(transformA, m_localPoint);
					//
					//b2Vec2 axisB = b2MulT(transformB.R, -normal);
					//
					//b2Vec2 localPointB = m_proxyB->GetSupportVertex(axisB);
					//b2Vec2 pointB = b2Mul(transformB, localPointB);
					//
					//float32 separation = b2Math.b2Dot2(pointB - pointA, normal);
					
					normal = b2Math.b2Mul_Matrix22AndVector2 (transformA.R, m_axis);
					_normal = normal.GetNegative ();
					axisB = b2Math.b2MulTrans_Matrix22AndVector2 (transformB.R, _normal);

					pointB = _normal; b2Math.b2Mul_TransformAndVector2_Output (transformB, m_proxyB.GetSupportVertex(axisB), pointB);

					pointA = axisB; b2Math.b2Mul_TransformAndVector2_Output (transformA, m_localPoint, pointA);
					pointB.Subtract (pointA);
					
					separation = b2Math.b2Dot2 (pointB, normal);
					
					return separation;
				}

			case e_faceB:
				{
					//b2Vec2 normal = b2Mul(transformB.R, m_axis);
					//b2Vec2 pointB = b2Mul(transformB, m_localPoint);
					//
					//b2Vec2 axisA = b2MulT(transformA.R, -normal);
					//
					//b2Vec2 localPointA = m_proxyA->GetSupportVertex(axisA);
					//b2Vec2 pointA = b2Mul(transformA, localPointA);
					//
					//float32 separation = b2Math.b2Dot2(pointA - pointB, normal);
					
					normal = b2Math.b2Mul_Matrix22AndVector2 (transformB.R, m_axis);
					_normal = normal.GetNegative ();
					axisA = b2Math.b2MulTrans_Matrix22AndVector2 (transformA.R, _normal);

					pointA = _normal; b2Math.b2Mul_TransformAndVector2_Output (transformA, m_proxyA.GetSupportVertex(axisA), pointA);

					pointB = axisA; b2Math.b2Mul_TransformAndVector2_Output (transformB, m_localPoint, pointB);
					pointA.Subtract (pointB);

					separation = b2Math.b2Dot2(pointA, normal);
					
					return separation;
				}

			default:
				//b2Assert(false);
				return 0.0;
			}
		}

		public var m_proxyA:b2DistanceProxy;
		public var m_proxyB:b2DistanceProxy;
		public var m_type:int;
		public var m_localPoint:b2Vec2 = new b2Vec2 ();
		public var m_axis:b2Vec2 = new b2Vec2 ();
	} // class
} // package
