
package Box2D.Collision
{
	/// Input for b2Distance.
	/// You have to option to use the shape radii
	/// in the computation. Even 
	public class b2DistanceInput
	{
		public var proxyA:b2DistanceProxy = new b2DistanceProxy ();
		public var proxyB:b2DistanceProxy = new b2DistanceProxy ();
		public var transformA:b2Transform = new b2Transform ();
		public var transformB:b2Transform = new b2Transform ();
		public var useRadii:Boolean;
	} // class
} //package
