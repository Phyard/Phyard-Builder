
package Box2D.Dynamics
{
	import Box2D.Common.b2Vec2;
	
	/// Callback class for ray casts.
	/// See b2World::RayCast
	//public class b2RayCastCallback
	public interface b2RayCastCallback
	{
		/// Called for each fixture found in the query. You control how the ray cast
		/// proceeds by returning a float:
		/// return -1: ignore this fixture and continue
		/// return 0: terminate the ray cast
		/// return fraction: clip the ray to this point
		/// return 1: don't clip the ray and continue
		/// @param fixture the fixture hit by the ray
		/// @param point the point of initial intersection
		/// @param normal the normal vector at the point of intersection
		/// @return -1 to filter, 0 to terminate, fraction to clip the ray for
		/// closest hit, 1 to continue
		//public function ReportFixture(	fixture:b2Fixture, point:b2Vec2,
		//								normal:b2Vec2, fraction:Number):Number {return 0.0;}
		function ReportFixture(	fixture:b2Fixture, point:b2Vec2,
										normal:b2Vec2, fraction:Number):Number;
			
	} // class
} // package
