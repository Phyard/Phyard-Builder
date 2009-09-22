
package Box2D.Dynamics
{
	import Box2D.Common.b2Vec2;
	
	/// Callback class for ray casts.
	/// See b2World::RayCast
	//public class b2RayCastCallback
	public interface b2RayCastCallback
	{
		/// Called for each fixture found in the query. You control how the ray proceeds
		/// by returning a float that indicates the fractional length of the ray. By returning
		/// 0, you set the ray length to zero. By returning the current fraction, you proceed
		/// to find the closest point. By returning 1, you continue with the original ray
		/// clipping.
		/// @param fixture the fixture hit by the ray
		/// @param point the point of initial intersection
		/// @param normal the normal vector at the point of intersection
		/// @return 0 to terminate, fraction to clip the ray for
		/// closest hit, 1 to continue
		//public function ReportFixture(	fixture:b2Fixture, point:b2Vec2,
		//								normal:b2Vec2, fraction:Number):Number {return 0.0;}
		function ReportFixture(	fixture:b2Fixture, point:b2Vec2,
										normal:b2Vec2, fraction:Number):Number;
			
	} // class
} // package
