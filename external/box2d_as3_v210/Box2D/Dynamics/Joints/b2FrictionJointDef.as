package Box2D.Dynamics.Joints
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.b2Vec2;

	/// Friction joint definition.
	public class b2FrictionJointDef extends b2JointDef
	{
		public function b2FrictionJointDef()
		{
			type = b2Joint.e_frictionJoint;
			localAnchorA.SetZero();
			localAnchorB.SetZero();
			maxForce = 0.0;
			maxTorque = 0.0;
		}

		/// Initialize the bodies, anchors, axis, and reference angle using the world
		/// anchor and world axis.
		//void Initialize(b2Body* bodyA, b2Body* bodyB, const b2Vec2& anchor);

		/// The local anchor point relative to bodyA's origin.
		public var localAnchorA:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to bodyB's origin.
		public var localAnchorB:b2Vec2 = new b2Vec2 ();

		/// The maximum friction force in N.
		public var maxForce:Number;

		/// The maximum friction torque in N-m.
		public var maxTorque:Number;

		public function Initialize(bA:b2Body, bB:b2Body, anchor:b2Vec2):void
		{
			bodyA = bA;
			bodyB = bB;
			localAnchorA.CopyFrom (bodyA.GetLocalPoint(anchor));
			localAnchorB.CopyFrom (bodyB.GetLocalPoint(anchor));
		}

	}
}

