
package Box2D.Dynamics
{
	
	/// Callback class for AABB queries.
	/// See b2World::Query
	//public class b2QueryCallback
	public interface b2QueryCallback
	{
		/// Called for each fixture found in the query AABB.
		/// @return false to terminate the query.
		//public function ReportFixture(fixture:b2Fixture):Boolean {return false;}
		function ReportFixture(fixture:b2Fixture):Boolean;
			
	} // class
} // package
