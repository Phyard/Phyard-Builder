package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Sweep;
	
	public class b2SeparationFunction
	{
		//enum Type
		//{
			public static const e_points:int = 0;
			public static const e_faceA:int =1;
			public static const e_faceB:int = 2;
		//};

		// TODO_ERIN might not need to return the separation

		private static var xfA:b2Transform = new b2Transform ();
		private static var xfB:b2Transform = new b2Transform ();
		private static var pointA:b2Vec2 = new b2Vec2 ();
		private static var pointB:b2Vec2 = new b2Vec2 ();
		private static var normal:b2Vec2 = new b2Vec2 ();
		
		private static var axisA:b2Vec2 = new b2Vec2 ();
		private static var axisB:b2Vec2 = new b2Vec2 ();
		
		private static var tempV:b2Vec2 = new b2Vec2 ();

		public function Initialize(cache:b2SimplexCache,
			proxyA:b2DistanceProxy, sweepA:b2Sweep,
			proxyB:b2DistanceProxy, sweepB:b2Sweep):Number
		{
			m_proxyA = proxyA;
			m_proxyB = proxyB;
			var count:int = cache.count;
			//b2Assert(0 < count && count < 3);

			m_sweepA = sweepA;
			m_sweepB = sweepB;

			m_sweepA.GetTransform(xfA, 0.0);
			m_sweepB.GetTransform(xfB, 0.0);

			var s:Number;

			if (count == 1)
			{
				m_type = e_points;
				var localPointA:b2Vec2 = m_proxyA.GetVertex(cache.indexA[0]); //.Clone ();
				var localPointB:b2Vec2 = m_proxyB.GetVertex(cache.indexB[0]); // Clone ();
				b2Math.b2Mul_TransformAndVector2_Output(xfA, localPointA, pointA);
				b2Math.b2Mul_TransformAndVector2_Output(xfB, localPointB, pointB);
				//m_axis = pointB - pointA;
				m_axis.x = pointB.x - pointA.x;
				m_axis.y = pointB.y - pointA.y;
				s = m_axis.Normalize();
				return s;
			}
			else if (cache.indexA[0] == cache.indexA[1])
			{
				// Two points on B and one on A.
				m_type = e_faceB;
				var localPointB1:b2Vec2 = proxyB.GetVertex(cache.indexB[0]); //.Clone ();
				var localPointB2:b2Vec2 = proxyB.GetVertex(cache.indexB[1]); //.Clone ();

				tempV.x = localPointB2.x - localPointB1.x;
				tempV.y = localPointB2.y - localPointB1.y;
				b2Math.b2Cross_Vector2AndScalar_Output (tempV, 1.0, m_axis);
				m_axis.Normalize();
				b2Math.b2Mul_Matrix22AndVector2_Output (xfB.R, m_axis, normal);

				m_localPoint.x = 0.5 * (localPointB1.x + localPointB2.x); //.Clone ();
				m_localPoint.y = 0.5 * (localPointB1.y + localPointB2.y); //.Clone ();
				b2Math.b2Mul_TransformAndVector2_Output (xfB, m_localPoint, pointB);

				localPointA = proxyA.GetVertex(cache.indexA[0]);
				b2Math.b2Mul_TransformAndVector2_Output(xfA, localPointA, pointA);

				tempV.x = pointA.x - pointB.x;
				tempV.y = pointA.y - pointB.y;
				s = b2Math.b2Dot2 (tempV, normal);
				if (s < 0.0)
				{
					//m_axis = -m_axis;
					m_axis.x = -m_axis.x;
					m_axis.y = -m_axis.y;
					s = -s;
				}
				return s;
			}
			else
			{
				// Two points on A and one or two points on B.
				m_type = e_faceA;
				var localPointA1:b2Vec2 = m_proxyA.GetVertex(cache.indexA[0]); //.Clone ();
				var localPointA2:b2Vec2 = m_proxyA.GetVertex(cache.indexA[1]); //.Clone ();
				
				tempV.x = localPointA2.x - localPointA1.x;
				tempV.y = localPointA2.y - localPointA1.y;
				b2Math.b2Cross_Vector2AndScalar_Output(tempV, 1.0, m_axis);
				m_axis.Normalize();
				b2Math.b2Mul_Matrix22AndVector2_Output (xfA.R, m_axis, normal);

				m_localPoint.x = 0.5 * (localPointA1.x + localPointA2.x);
				m_localPoint.y = 0.5 * (localPointA1.y + localPointA2.y);
				b2Math.b2Mul_TransformAndVector2_Output (xfA, m_localPoint, pointA);

				localPointB = m_proxyB.GetVertex(cache.indexB[0]); //.Clone ();
				b2Math.b2Mul_TransformAndVector2_Output (xfB, localPointB, pointB);

				tempV.x = pointB.x - pointA.x;
				tempV.y = pointB.y - pointA.y;
				s = b2Math.b2Dot2 (tempV, normal);
				if (s < 0.0)
				{
					//m_axis = -m_axis;
					m_axis.x = -m_axis.x;
					m_axis.y = -m_axis.y;
					s = -s;
				}
				return s;
			}
		}

		public function FindMinSeparation (output:b2FindMinSeparationOutput, t:Number):void
		{
			m_sweepA.GetTransform(xfA, t);
			m_sweepB.GetTransform(xfB, t);

			var indexA:int;
			var indexB:int;
			var separation:Number;

			var localPointA:b2Vec2;
			var localPointB:b2Vec2

			switch (m_type)
			{
			case e_points:
				{
					b2Math.b2MulT_Matrix22AndVector2_Output (xfA.R,  m_axis, axisA);
					tempV.x = -m_axis.x;
					tempV.y = -m_axis.y;
					b2Math.b2MulT_Matrix22AndVector2_Output (xfB.R, tempV, axisB);

					indexA = m_proxyA.GetSupport(axisA);
					indexB = m_proxyB.GetSupport(axisB);

					localPointA = m_proxyA.GetVertex(indexA); //.Clone ()
					localPointB = m_proxyB.GetVertex(indexB); //.Clone ()

					b2Math.b2Mul_TransformAndVector2_Output (xfA, localPointA, pointA);
					b2Math.b2Mul_TransformAndVector2_Output (xfB, localPointB, pointB);

					tempV.x = pointB.x - pointA.x;
					tempV.y = pointB.y - pointA.y;
					separation = b2Math.b2Dot2 (tempV, m_axis);
					//return separation;
				}
				break;

			case e_faceA:
				{
					b2Math.b2Mul_Matrix22AndVector2_Output (xfA.R, m_axis, normal);
					b2Math.b2Mul_TransformAndVector2_Output (xfA, m_localPoint, pointA);

					tempV.x = -normal.x;
					tempV.y = -normal.y;
					b2Math.b2MulT_Matrix22AndVector2_Output (xfB.R, tempV, axisB);
					
					indexA = -1;
					indexB = m_proxyB.GetSupport (axisB);

					localPointB = m_proxyB.GetVertex(indexB); //.Clone ()
					b2Math.b2Mul_TransformAndVector2_Output (xfB, localPointB, pointB);

					tempV.x = pointB.x - pointA.x;
					tempV.y = pointB.y - pointA.y;
					separation = b2Math.b2Dot2 (tempV, normal);
					//return separation;
				}
				break;

			case e_faceB:
				{
					b2Math.b2Mul_Matrix22AndVector2_Output(xfB.R, m_axis, normal);
					b2Math.b2Mul_TransformAndVector2_Output (xfB, m_localPoint, pointB);

					tempV.x = -normal.x;
					tempV.y = -normal.y;
					b2Math.b2MulT_Matrix22AndVector2_Output (xfA.R, tempV, axisA);

					indexB = -1;
					indexA = m_proxyA.GetSupport(axisA);

					localPointA = m_proxyA.GetVertex(indexA); //.Clone ()
					b2Math.b2Mul_TransformAndVector2_Output (xfA, localPointA, pointA);

					tempV.x = pointA.x - pointB.x;
					tempV.y = pointA.y - pointB.y;
					separation = b2Math.b2Dot2 (tempV, normal);
					//return separation;
				}
				break;

			default:
				//b2Assert(false);
				indexA = -1;
				indexB = -1;
				//return 0.0f;
				separation = 0.0;
				
				break;
			}
			
			output.separation = separation;
			output.indexA = indexA;
			output.indexB = indexB;
		}

		public function Evaluate(indexA:int, indexB:int, t:Number):Number
		{
			m_sweepA.GetTransform (xfA, t);
			m_sweepB.GetTransform (xfB, t);

			var separation:Number;

			var localPointA:b2Vec2;
			var localPointB:b2Vec2;

			switch (m_type)
			{
			case e_points:
				{
					b2Math.b2MulT_Matrix22AndVector2_Output (xfA.R,  m_axis, axisA);
					tempV.x = -m_axis.x;
					tempV.y = -m_axis.y;
					b2Math.b2MulT_Matrix22AndVector2_Output (xfB.R, tempV, axisB);

					localPointA = m_proxyA.GetVertex(indexA); //.Clone ()
					localPointB = m_proxyB.GetVertex(indexB); //.Clone ()

					b2Math.b2Mul_TransformAndVector2_Output (xfA, localPointA, pointA);
					b2Math.b2Mul_TransformAndVector2_Output (xfB, localPointB, pointB);
					
					tempV.x = pointB.x - pointA.x;
					tempV.y = pointB.y - pointA.y;
					separation = b2Math.b2Dot2 (tempV, m_axis);

					return separation;
				}

			case e_faceA:
				{
					b2Math.b2Mul_Matrix22AndVector2_Output (xfA.R, m_axis, normal);
					b2Math.b2Mul_TransformAndVector2_Output (xfA, m_localPoint, pointA);

					tempV.x = -normal.x;
					tempV.y = -normal.y;
					b2Math.b2MulT_Matrix22AndVector2_Output (xfB.R, tempV, axisB);

					localPointB = m_proxyB.GetVertex(indexB); //.Clone ()
					b2Math.b2Mul_TransformAndVector2_Output (xfB, localPointB, pointB);

					tempV.x = pointB.x - pointA.x;
					tempV.y = pointB.y - pointA.y;
					separation = b2Math.b2Dot2 (tempV, normal);
					return separation;
				}

			case e_faceB:
				{
					b2Math.b2Mul_Matrix22AndVector2_Output (xfB.R, m_axis, normal);
					b2Math.b2Mul_TransformAndVector2_Output (xfB, m_localPoint, pointB);

					tempV.x = -normal.x;
					tempV.y = -normal.y;
					b2Math.b2MulT_Matrix22AndVector2_Output (xfA.R, tempV, axisA);

					localPointA = m_proxyA.GetVertex(indexA); //.Clone ()
					b2Math.b2Mul_TransformAndVector2_Output (xfA, localPointA, pointA);

					tempV.x = pointA.x - pointB.x;
					tempV.y = pointA.y - pointB.y;
					separation = b2Math.b2Dot2 (tempV, normal);
					return separation;
				}

			default:
				//b2Assert(false);
				return 0.0;
			}
		}

		public var m_proxyA:b2DistanceProxy;
		public var m_proxyB:b2DistanceProxy;
		public var m_sweepA:b2Sweep,  // = new b2Sweep ();
					m_sweepB:b2Sweep; // = new b2Sweep ();
		public var m_type:int;
		public var m_localPoint:b2Vec2 = new b2Vec2 ();
		public var m_axis:b2Vec2 = new b2Vec2 ();
	} // class
} // package
