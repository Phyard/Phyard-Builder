package Box2D.Dynamics.Joints
{
	import Box2D.Dynamics.b2Body;
	
	/// Joint definitions are used to construct joints.
	public class b2JointDef
	{
		public function b2JointDef()
		{
			type = b2Joint.e_unknownJoint;
			userData = null;
			bodyA = null;
			bodyB = null;
			collideConnected = false;
		}

		/// The joint type is set automatically for concrete joint types.
		//b2JointType type;
		public var type:int;

		/// Use this to attach application specific data to your joints.
		public var userData:Object;

		/// The first attached body.
		public var bodyA:b2Body;

		/// The second attached body.
		public var bodyB:b2Body;

		/// Set this flag to true if the attached bodies should collide.
		public var collideConnected:Boolean;
		
	} // class
} // package
