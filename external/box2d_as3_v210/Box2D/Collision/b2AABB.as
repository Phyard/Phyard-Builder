
package Box2D.Collision
{
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Settings;
	
	/// An axis aligned bounding box.
	public class b2AABB
	{
		// this function doesn't exist in the c++ version
		public function Clone ():b2AABB
		{
			var aabb:b2AABB = new b2AABB ();
			aabb.CopyFrom (this);
			
			return aabb;
		}
		
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2AABB):void
		{
			lowerBound.CopyFrom (another.lowerBound);
			upperBound.CopyFrom (another.upperBound);
		}
		
		/// Verify that the bounds are sorted.
		//bool IsValid() const;

		/// Get the center of the AABB.
		public function GetCenter():b2Vec2
		{
			//return 0.5f * (lowerBound + upperBound);
			
			return b2Vec2.b2Vec2_From2Numbers (0.5 * (lowerBound.x + upperBound.x), 0.5 * (lowerBound.y + upperBound.y));
		}

		public function GetCenter_Output (outputV:b2Vec2):void
		{
			outputV.x = 0.5 * (lowerBound.x + upperBound.x);
			outputV.y = 0.5 * (lowerBound.y + upperBound.y);
		}

		/// Get the extents of the AABB (half-widths).
		public function GetExtents():b2Vec2
		{
			//return 0.5f * (upperBound - lowerBound);
			
			return b2Vec2.b2Vec2_From2Numbers (0.5 * (upperBound.x - lowerBound.x), 0.5 * (upperBound.y - lowerBound.y));
		}

		public function GetExtents_Output (outputV:b2Vec2):void
		{
			outputV.x = 0.5 * (upperBound.x - lowerBound.x);
			outputV.y = 0.5 * (upperBound.y - lowerBound.y);
		}

		/// Combine two AABBs into this one.
		public function Combine(aabb1:b2AABB, aabb2:b2AABB):void
		{
			//lowerBound = b2Min(aabb1.lowerBound, aabb2.lowerBound);
			//upperBound = b2Max(aabb1.upperBound, aabb2.upperBound);
			
			b2Math.b2Min_Vector2_Output (aabb1.lowerBound, aabb2.lowerBound, lowerBound);
			b2Math.b2Max_Vector2_Output (aabb1.upperBound, aabb2.upperBound, upperBound);
		}

		/// Does this aabb contain the provided AABB.
		public function Contains(aabb:b2AABB):Boolean
		{
			var result:Boolean = true;
			result = result && lowerBound.x <= aabb.lowerBound.x;
			result = result && lowerBound.y <= aabb.lowerBound.y;
			result = result && aabb.upperBound.x <= upperBound.x;
			result = result && aabb.upperBound.y <= upperBound.y;
			return result;
		}

		//void RayCast(b2RayCastOutput* output, const b2RayCastInput& input) const;

		public var lowerBound:b2Vec2 = new b2Vec2 ();	///< the lower vertex
		public var upperBound:b2Vec2 = new b2Vec2 ();	///< the upper vertex
		
		public function IsValid():Boolean
		{
			//b2Vec2 d = upperBound - lowerBound;
			//bool valid = d.x >= 0.0f && d.y >= 0.0f;
			var dx:Number = upperBound.x - lowerBound.x;
			var dy:Number = upperBound.y - lowerBound.y;
			var valid:Boolean = dx >= 0.0 && dy >= 0.0;
			valid = valid && lowerBound.IsValid() && upperBound.IsValid();
			return valid;
		}
		
		// From Real-time Collision Detection, p179.
		public function RayCast(output:b2RayCastOutput, input:b2RayCastInput):Boolean
		{
			var tmin:Number = - b2Settings.b2_maxFloat;
			var tmax:Number = b2Settings.b2_maxFloat;

			//b2Vec2 p = input.p1;
			//b2Vec2 d = input.p2 - input.p1;
			//b2Vec2 absD = b2Abs(d);
			var p   :Array = [input.p1.x             , input.p1.y             ];
			var d   :Array = [input.p2.x - input.p1.x, input.p2.y - input.p1.y];
			var absD:Array = [d.x < 0 ? - d.x : d.x  , d.y < 0 ? - d.y : d.y  ];

			//b2Vec2 normal;
			var normal:Array = [0.0, 0.0];
			
			var lower_i:Number;
			var upper_i:Number;

			for (var i:int = 0; i < 2; ++i)
			{
				if (i == 0)
				{
					lower_i = lowerBound.x;
					upper_i = upperBound.x;
				}
				else
				{
					lower_i = lowerBound.y;
					upper_i = upperBound.y;
				}
				
				if (absD[i] < b2Settings.b2_epsilon)
				{
					// Parallel.
					if (p[i] < lower_i || upper_i < p[i])
					{
						return false;
					}
				}
				else
				{
					var inv_d:Number = 1.0 / d[i];
					var t1:Number = (lower_i - p[i]) * inv_d;
					var t2:Number = (upper_i - p[i]) * inv_d;

					// Sign of the normal vector.
					var s:Number = -1.0;

					if (t1 > t2)
					{
						//b2Swap(t1, t2);
						var temp:Number = t1;
						t1 = t2;
						t2 = temp;
						s = 1.0;
					}

					// Push the min up
					if (t1 > tmin)
					{
						//normal.SetZero();
						normal[0] = 0.0;
						normal[1] = 0.0;
						normal[i] = s;
						tmin = t1;
					}

					// Pull the max down
					//tmax = b2Min(tmax, t2);
					tmax = tmax < t2 ? tmax : t2;

					if (tmin > tmax)
					{
						return false;
					}
				}
			}

			// Does the ray start inside the box?
			// Does the ray intersect beyond the max fraction?
			if (tmin < 0.0 || input.maxFraction < tmin)
			{
				return false;
			}

			// Intersection.
			output.fraction = tmin;
			output.normal.Set (normal [0], normal[1]);
			
			return true;
		}
	} // class
} // package
