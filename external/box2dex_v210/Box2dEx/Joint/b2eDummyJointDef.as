package Box2dEx.Joint
{
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.b2Body;
	
	import Box2D.Common.b2Vec2;

	public class b2eDummyJointDef extends b2JointDef
	{
		/// The local anchor point relative to body1's origin.
		public var localAnchorA:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to body2's origin.
		public var localAnchorB:b2Vec2 = new b2Vec2 ();

		// ...
		public function b2eDummyJointDef ()
		{
			type = b2Joint.e_unknownJoint;
			localAnchorA.Set(0.0, 0.0);
			localAnchorB.Set(0.0, 0.0);
		}

		// ...
		public function Initialize(b1:b2Body, b2:b2Body,
											anchor1:b2Vec2, anchor2:b2Vec2):void
		{
			bodyA = b1;
			bodyB = b2;
			bodyA.GetLocalPoint_Output (anchor1, localAnchorA);
			bodyB.GetLocalPoint_Output (anchor2, localAnchorB);
		}
		
	} // class
} // package
