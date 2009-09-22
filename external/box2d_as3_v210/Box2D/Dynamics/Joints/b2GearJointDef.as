package Box2D.Dynamics.Joints
{
	/// Gear joint definition. This definition requires two existing
	/// revolute or prismatic joints (any combination will work).
	/// The provided joints must attach a dynamic body to a static body.
	public class b2GearJointDef extends b2JointDef
	{
		public function b2GearJointDef()
		{
			type = b2Joint.e_gearJoint;
			joint1 = null;
			joint2 = null;
			ratio = 1.0;
		}

		/// The first revolute/prismatic joint attached to the gear joint.
		public var joint1:b2Joint;

		/// The second revolute/prismatic joint attached to the gear joint.
		public var joint2:b2Joint;

		/// The gear ratio.
		/// @see b2GearJoint for explanation.
		public var ratio:Number;
	} // class
} // package
