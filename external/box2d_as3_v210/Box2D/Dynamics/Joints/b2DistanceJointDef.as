package Box2D.Dynamics.Joints
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.b2Vec2;
	
	/// Distance joint definition. This requires defining an
	/// anchor point on both bodies and the non-zero length of the
	/// distance joint. The definition uses local anchor points
	/// so that the initial configuration can violate the constraint
	/// slightly. This helps when saving and loading a game.
	/// @warning Do not use a zero or short length.
	public class b2DistanceJointDef extends b2JointDef
	{
		public function b2DistanceJointDef ()
		{
			type = b2Joint.e_distanceJoint;
			localAnchor1.Set(0.0, 0.0);
			localAnchor2.Set(0.0, 0.0);
			length = 1.0;
			frequencyHz = 0.0;
			dampingRatio = 0.0;
		}

		/// Initialize the bodies, anchors, and length using the world
		/// anchors.
		//void Initialize(b2Body* body1, b2Body* body2,
		//				const b2Vec2& anchor1, const b2Vec2& anchor2);

		/// The local anchor point relative to body1's origin.
		public var localAnchor1:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to body2's origin.
		public var localAnchor2:b2Vec2 = new b2Vec2 ();

		/// The equilibrium length between the anchor points.
		public var length:Number;

		/// The response speed.
		public var frequencyHz:Number;

		/// The damping ratio. 0 = no damping, 1 = critical damping.
		public var dampingRatio:Number;
		
		// ...
		public function Initialize(b1:b2Body, b2:b2Body,
											anchor1:b2Vec2, anchor2:b2Vec2):void
		{
			body1 = b1;
			body2 = b2;
			localAnchor1.CopyFrom (body1.GetLocalPoint(anchor1));
			localAnchor2.CopyFrom (body2.GetLocalPoint(anchor2));
			var d:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (anchor2.x - anchor1.x, anchor2.y - anchor1.y);
			length = d.Length();
		}
	} // class
} // package
