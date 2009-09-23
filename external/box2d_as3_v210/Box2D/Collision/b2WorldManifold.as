package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	
	/// This is used to compute the current state of a contact manifold.
	public class b2WorldManifold
	{
		/// Evaluate the manifold with supplied transforms. This assumes
		/// modest motion from the original state. This does not change the
		/// point count, impulses, etc. The radii must come from the shapes
		/// that generated the manifold.
		//void Initialize(const b2Manifold* manifold,
		//				const b2Transform& xfA, float32 radiusA,
		//				const b2Transform& xfB, float32 radiusB);

		public var m_normal:b2Vec2 = new b2Vec2 ();						///< world vector pointing from A to B
		public var m_points:Array  = new Array (b2Settings.b2_maxManifoldPoints);	///< world contact point (point of intersection)
		
		// this contrustor doesn't exist in the c++ version
		public function b2WorldManifold ()
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++ i)
			{
				m_points [i] = new b2Vec2 ();
			}
		}
		
		public function Initialize(manifold:b2Manifold,
								  xfA:b2Transform, radiusA:Number,
								  xfB:b2Transform, radiusB:Number):void
		{
			if (manifold.m_pointCount == 0)
			{
				return;
			}
			
			var tempV:b2Vec2 = new b2Vec2 ();
			
			var i:int;
			var normal:b2Vec2;
			var planePoint:b2Vec2;
			var clipPoint:b2Vec2;
			
			var cAx:Number;
			var cAy:Number;
			var cBx:Number;
			var cBy:Number;
			
			var temp:Number;

			switch (manifold.m_type)
			{
			case b2Manifold.e_circles:
				{
					var pointA:b2Vec2 = b2Math.b2Mul_TransformAndVector2(xfA, manifold.m_localPoint);
					var pointB:b2Vec2 = b2Math.b2Mul_TransformAndVector2(xfB, manifold.m_points[0].m_localPoint);
					normal = b2Vec2.b2Vec2_From2Numbers (1.0, 0.0);
					if (b2Math.b2DistanceSquared(pointA, pointB) > b2Settings.B2_FLT_EPSILON * b2Settings.B2_FLT_EPSILON)
					{
						//normal = pointB - pointA;
						normal.x = pointB.x - pointA.x;
						normal.y = pointB.y - pointA.y;
						normal.Normalize();
					}

					//m_normal = normal;
					m_normal.x = normal.x;
					m_normal.y = normal.y;

					//b2Vec2 cA = pointA + radiusA * normal;
					//b2Vec2 cB = pointB - radiusB * normal;
					//m_points[0] = 0.5f * (cA + cB);
					cAx = pointA.x + radiusA * normal.x;
					cAy = pointA.y + radiusA * normal.y;
					cBx = pointB.x - radiusB * normal.x;
					cBy = pointB.y - radiusB * normal.y;
					m_points[0].x = 0.5 * (cAx + cBx);
					m_points[0].y = 0.5 * (cAy + cBy);
				}
				break;

			case b2Manifold.e_faceA:
				{
					normal = b2Math.b2Mul_Matrix22AndVector2(xfA.R, manifold.m_localPlaneNormal);
					planePoint = b2Math.b2Mul_TransformAndVector2(xfA, manifold.m_localPoint);

					// Ensure normal points from A to B.
					//m_normal = normal;
					m_normal.x = normal.x;
					m_normal.y = normal.y;
					
					for (i = 0; i < manifold.m_pointCount; ++i)
					{
						//b2Vec2 clipPoint = b2Mul(xfB, manifold->m_points[i].m_localPoint);
						//b2Vec2 cA = clipPoint + (radiusA - b2Math.b2Dot2(clipPoint - planePoint, normal)) * normal;
						//b2Vec2 cB = clipPoint - radiusB * normal;
						//m_points[i] = 0.5f * (cA + cB);
						clipPoint = b2Math.b2Mul_TransformAndVector2(xfB, manifold.m_points[i].m_localPoint);
						tempV.x = clipPoint.x - planePoint.x;
						tempV.y = clipPoint.y - planePoint.y;
						temp = (radiusA - b2Math.b2Dot2(tempV, normal));
						cAx = clipPoint.x + temp * normal.x;
						cAy = clipPoint.y + temp * normal.y;
						cBx = clipPoint.x - radiusB * normal.x;
						cBy = clipPoint.y - radiusB * normal.y;
						m_points[i].x = 0.5 * (cAx + cBx);
						m_points[i].y = 0.5 * (cAy + cBy);
					}
				}
				break;

			case b2Manifold.e_faceB:
				{
					normal = b2Math.b2Mul_Matrix22AndVector2(xfB.R, manifold.m_localPlaneNormal);
					planePoint = b2Math.b2Mul_TransformAndVector2(xfB, manifold.m_localPoint);

					// Ensure normal points from A to B.
					//m_normal = -normal;
					m_normal.x = -normal.x;
					m_normal.y = -normal.y;

					for (i = 0; i < manifold.m_pointCount; ++i)
					{
						//b2Vec2 clipPoint = b2Mul(xfA, manifold->m_points[i].m_localPoint);
						//b2Vec2 cA = clipPoint - radiusA * normal;
						//b2Vec2 cB = clipPoint + (radiusB - b2Math.b2Dot2(clipPoint - planePoint, normal)) * normal;
						//m_points[i] = 0.5f * (cA + cB);
						clipPoint = b2Math.b2Mul_TransformAndVector2(xfA, manifold.m_points[i].m_localPoint);
						cAx = clipPoint.x - radiusA * normal.x;
						cAy = clipPoint.y - radiusA * normal.y;
						tempV.x = clipPoint.x - planePoint.x;
						tempV.y = clipPoint.y - planePoint.y;
						temp = (radiusB - b2Math.b2Dot2(tempV, normal));
						cBx = clipPoint.x + temp * normal.x;
						cBy = clipPoint.y + temp * normal.y;
						m_points[i].x = 0.5 * (cAx + cBx);
						m_points[i].y = 0.5 * (cAy + cBy);
					}
				}
				break;
			}
		}
	} // class
} // package
