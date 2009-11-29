package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;

	/// A line segment.
	public class b2Segment
	{
		/// Ray cast against this segment with another segment.
		//bool TestSegment(float32* lambda, b2Vec2* normal, const b2Segment& segment, float32 maxLambda) const;

		public var p1:b2Vec2 = new b2Vec2 ();	///< the starting point
		public var p2:b2Vec2 = new b2Vec2 ();	///< the ending point
		
		//const float32 k_slop = 100.0f * B2_FLT_EPSILON;
		public static const k_slop:Number = 100.0 * b2Settings.b2_epsilon;
		
		//bool TestSegment(float32* lambda, b2Vec2* normal, const b2Segment& segment, float32 maxLambda) const;
		public function TestSegment(segment:b2Segment, maxLambda:Number):b2TestSegmentOutput
		{
			//b2Vec2 s = segment.p1;
			//b2Vec2 r = segment.p2 - s;
			//b2Vec2 d = p2 - p1;
			//b2Vec2 n = b2Math.b2Cross2(d, 1.0f);
			var sx:Number = segment.p1.x;
			var sy:Number = segment.p1.y;
			var rx:Number = segment.p2.x - sx;
			var ry:Number = segment.p2.y - sy;
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			var nx:Number =   dy;
			var ny:Number = - dx;

			//const float32 k_slop = 100.0f * B2_FLT_EPSILON;
			//float32 denom = -b2Dot(r, n);
			var denom:Number = -(rx * nx + ry * ny);

			// Cull back facing collision and ignore parallel segments.
			if (denom > k_slop)
			{
				// Does the segment intersect the infinite line associated with this segment?
				//b2Vec2 b = s - p1;
				//float32 a = b2Math.b2Dot2(b, n);
				var bx:Number = sx - p1.x;
				var by:Number = sy - p1.y;
				var a:Number = bx * nx + by * ny;

				if (0.0 <= a && a <= maxLambda * denom)
				{
					var mu2:Number = -rx * by + ry * bx;

					// Does the segment intersect this segment?
					if (-k_slop * denom <= mu2 && mu2 <= denom * (1.0 + k_slop))
					{
						a /= denom;
						//n.Normalize();
						var invLength:Number = 1.0 // b2Math.b2Sqrt(nx * nx + ny * ny);
						
						var result:b2TestSegmentOutput = new b2TestSegmentOutput ();
						result.lambda = a;
						result.normal.x = nx * invLength;
						result.normal.y = ny * invLength;
						
						return result;
					}
				}
			}

			return null;
		}
	} // class
} // package
