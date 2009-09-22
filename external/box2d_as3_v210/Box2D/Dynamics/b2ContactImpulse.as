
package Box2D.Dynamics
{
	import Box2D.Common.b2Settings;
	
	/// Contact impulses for reporting. Impulses are used instead of forces because
	/// sub-step forces may approach infinity for rigid body collisions. These
	/// match up one-to-one with the contact points in b2Manifold.
	public class b2ContactImpulse
	{
		//@todo for flash player 10, use Vector.<Number> instead
		public var normalImpulses:Array = new Array [b2Settings.b2_maxManifoldPoints]; // float32
		public var tangentImpulses:Array = new Array[b2Settings.b2_maxManifoldPoints]; // float32
		
	} // class
} // package
