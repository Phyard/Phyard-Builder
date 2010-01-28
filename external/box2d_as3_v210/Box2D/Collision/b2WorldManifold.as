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

		public var normal:b2Vec2 = new b2Vec2 ();						///< world vector pointing from A to B
		public var points:Array  = new Array (b2Settings.b2_maxManifoldPoints);	///< world contact point (point of intersection)
		
		// this contrustor doesn't exist in the c++ version
		public function b2WorldManifold ()
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++ i)
			{
				points [i] = new b2Vec2 ();
			}
		}
		
		private static var tempV:b2Vec2 = new b2Vec2 ();
		private static var pointA:b2Vec2 = new b2Vec2 ();
		private static var pointB:b2Vec2 = new b2Vec2 ();
		//private static var normal:b2Vec2 = new b2Vec2 ();
		private static var planePoint:b2Vec2 = new b2Vec2 ();
		private static var clipPoint:b2Vec2 = new b2Vec2 ();
		
		public function Initialize(manifold:b2Manifold,
								  xfA:b2Transform, radiusA:Number,
								  xfB:b2Transform, radiusB:Number):void
		{
			if (manifold.pointCount == 0)
			{
				return;
			}
			
			//var tempV:b2Vec2 = new b2Vec2 ();
			
			var i:int;
			//var normal:b2Vec2;
			//var planePoint:b2Vec2;
			//var clipPoint:b2Vec2;
			
			var cAx:Number;
			var cAy:Number;
			var cBx:Number;
			var cBy:Number;
			
			var temp:Number;

			switch (manifold.type)
			{
			case b2Manifold.e_circles:
				{
					normal.x = 1.0;
					normal.y = 0.0;
					b2Math.b2Mul_TransformAndVector2_Output (xfA, manifold.localPoint, pointA);
					b2Math.b2Mul_TransformAndVector2_Output (xfB, (manifold.points[0] as b2ManifoldPoint).localPoint, pointB);
					//normal = b2Vec2.b2Vec2_From2Numbers (1.0, 0.0);
					if (b2Math.b2DistanceSquared(pointA, pointB) > b2Settings.b2_epsilon * b2Settings.b2_epsilon)
					{
						//normal = pointB - pointA;
						normal.x = pointB.x - pointA.x;
						normal.y = pointB.y - pointA.y;
						normal.Normalize();
					}

					//b2Vec2 cA = pointA + radiusA * normal;
					//b2Vec2 cB = pointB - radiusB * normal;
					//m_points[0] = 0.5f * (cA + cB);
					cAx = pointA.x + radiusA * normal.x;
					cAy = pointA.y + radiusA * normal.y;
					cBx = pointB.x - radiusB * normal.x;
					cBy = pointB.y - radiusB * normal.y;
					(points[0] as b2Vec2).x = 0.5 * (cAx + cBx);
					(points[0] as b2Vec2).y = 0.5 * (cAy + cBy);
				}
				break;

			case b2Manifold.e_faceA:
				{
					b2Math.b2Mul_Matrix22AndVector2_Output (xfA.R, manifold.localNormal, normal);
					b2Math.b2Mul_TransformAndVector2_Output (xfA, manifold.localPoint, planePoint);

					for (i = 0; i < manifold.pointCount; ++i)
					{
						//b2Vec2 clipPoint = b2Mul(xfB, manifold->points[i].localPoint);
						//b2Vec2 cA = clipPoint + (radiusA - b2Math.b2Dot2(clipPoint - planePoint, normal)) * normal;
						//b2Vec2 cB = clipPoint - radiusB * normal;
						//m_points[i] = 0.5f * (cA + cB);
						b2Math.b2Mul_TransformAndVector2_Output (xfB, (manifold.points[i] as b2ManifoldPoint).localPoint, clipPoint);
						tempV.x = clipPoint.x - planePoint.x;
						tempV.y = clipPoint.y - planePoint.y;
						temp = (radiusA - b2Math.b2Dot2(tempV, normal));
						cAx = clipPoint.x + temp * normal.x;
						cAy = clipPoint.y + temp * normal.y;
						cBx = clipPoint.x - radiusB * normal.x;
						cBy = clipPoint.y - radiusB * normal.y;
						(points[i] as b2Vec2).x = 0.5 * (cAx + cBx);
						(points[i] as b2Vec2).y = 0.5 * (cAy + cBy);
					}
				}
				break;

			case b2Manifold.e_faceB:
				{
					b2Math.b2Mul_Matrix22AndVector2_Output (xfB.R, manifold.localNormal, normal);
					b2Math.b2Mul_TransformAndVector2_Output (xfB, manifold.localPoint, planePoint);

					for (i = 0; i < manifold.pointCount; ++i)
					{
						//b2Vec2 clipPoint = b2Mul(xfA, manifold->points[i].localPoint);
						//b2Vec2 cB = clipPoint + (radiusB - b2Math.b2Dot2(clipPoint - planePoint, normal)) * normal;
						//b2Vec2 cA = clipPoint - radiusA * normal;
						//m_points[i] = 0.5f * (cA + cB);
						b2Math.b2Mul_TransformAndVector2_Output (xfA, (manifold.points[i] as b2ManifoldPoint).localPoint, clipPoint);
						tempV.x = clipPoint.x - planePoint.x;
						tempV.y = clipPoint.y - planePoint.y;
						temp = (radiusB - b2Math.b2Dot2(tempV, normal));
						cBx = clipPoint.x + temp * normal.x;
						cBy = clipPoint.y + temp * normal.y;
						cAx = clipPoint.x - radiusA * normal.x;
						cAy = clipPoint.y - radiusA * normal.y;
						(points[i] as b2Vec2).x = 0.5 * (cAx + cBx);
						(points[i] as b2Vec2).y = 0.5 * (cAy + cBy);
					}

					// Ensure normal points from A to B.
					//normal = -normal;
					normal.x = -normal.x;
					normal.y = -normal.y;
				}
				break;
			}
		}
	} // class
} // package
