package Box2D.Dynamics.Joints
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.b2Vec2;
	

	/// Weld joint definition. You need to specify local anchor points
	/// where they are attached and the relative body angle. The position
	/// of the anchor points is important for computing the reaction torque.
	public class b2WeldJointDef extends b2JointDef
	{
		public function b2WeldJointDef()
		{
			type = b2Joint.e_weldJoint;
			localAnchorA.Set(0.0, 0.0);
			localAnchorB.Set(0.0, 0.0);
			referenceAngle = 0.0;
		}

		/// Initialize the bodies, anchors, and reference angle using a world
		/// anchor point.
		//void Initialize(b2Body* body1, b2Body* body2, const b2Vec2& anchor);

		/// The local anchor point relative to body1's origin.
		public var localAnchorA:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to body2's origin.
		public var localAnchorB:b2Vec2 = new b2Vec2 ();

		/// The body2 angle minus body1 angle in the reference state (radians).
		public var referenceAngle:Number;

		public function Initialize(bA:b2Body, bB:b2Body, anchor:b2Vec2):void
		{
			bodyA = bA;
			bodyB = bB;
			bodyA.GetLocalPoint_Output(anchor, localAnchorA);
			bodyB.GetLocalPoint_Output(anchor, localAnchorB);
			referenceAngle = bodyB.GetAngle() - bodyA.GetAngle();
		}

	}
}
