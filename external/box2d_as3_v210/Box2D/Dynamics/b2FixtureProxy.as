
package Box2D.Dynamics
{
	import Box2D.Collision.b2AABB;
	
	public class b2FixtureProxy
	{
		public var aabb:b2AABB = new b2AABB ();
		public var fixture:b2Fixture;
		public var childIndex:int;
		public var proxyId:int;
	}
} // package
