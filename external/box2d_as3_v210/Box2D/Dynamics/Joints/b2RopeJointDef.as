package Box2D.Dynamics.Joints
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.b2Vec2;
	
	/// Rope joint definition. This requires two body anchor points and
	/// a maximum lengths.
	/// Note: by default the connected objects will not collide.
	/// see collideConnected in b2JointDef.
	public class b2RopeJointDef extends b2JointDef
	{
		public function b2RopeJointDef()
		{
			type = b2Joint.e_ropeJoint;
			localAnchorA.Set(-1.0, 0.0);
			localAnchorB.Set(1.0, 0.0);
			maxLength = 0.0;
		}

		/// The local anchor point relative to bodyA's origin.
		public var localAnchorA:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to bodyB's origin.
		public var localAnchorB:b2Vec2 = new b2Vec2 ();

		/// The maximum length of the rope.
		/// Warning: this must be larger than b2_linearSlop or
		/// the joint will have no effect.
		public var maxLength:Number;
	} // class
} // package
