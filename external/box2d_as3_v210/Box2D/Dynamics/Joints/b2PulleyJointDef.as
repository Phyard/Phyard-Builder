package Box2D.Dynamics.Joints
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.b2Vec2;
	
	/// Pulley joint definition. This requires two ground anchors,
	/// two dynamic body anchor points, max lengths for each side,
	/// and a pulley ratio.
	public class b2PulleyJointDef extends b2JointDef
	{
		public function b2PulleyJointDef()
		{
			type = b2Joint.e_pulleyJoint;
			groundAnchorA.Set(-1.0, 1.0);
			groundAnchorB.Set(1.0, 1.0);
			localAnchorA.Set(-1.0, 0.0);
			localAnchorB.Set(1.0, 0.0);
			lengthA = 0.0;
			maxLengthA = 0.0;
			lengthB = 0.0;
			maxLengthB = 0.0;
			ratio = 1.0;
			collideConnected = true;
		}

		/// Initialize the bodies, anchors, lengths, max lengths, and ratio using the world anchors.
		//void Initialize(b2Body* bodyA, b2Body* bodyB,
		//				const b2Vec2& groundAnchor1, const b2Vec2& groundAnchor2,
		//				const b2Vec2& anchor1, const b2Vec2& anchor2,
		//				float32 ratio);

		/// The first ground anchor in world coordinates. This point never moves.
		public var groundAnchorA:b2Vec2 = new b2Vec2 ();

		/// The second ground anchor in world coordinates. This point never moves.
		public var groundAnchorB:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to body1's origin.
		public var localAnchorA:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to body2's origin.
		public var localAnchorB:b2Vec2 = new b2Vec2 ();

		/// The a reference length for the segment attached to body1.
		public var lengthA:Number;

		/// The maximum length of the segment attached to body1.
		public var maxLengthA:Number;

		/// The a reference length for the segment attached to body2.
		public var lengthB:Number;

		/// The maximum length of the segment attached to body2.
		public var maxLengthB:Number;

		/// The pulley ratio, used to simulate a block-and-tackle.
		public var ratio:Number;
		
		// ...
		public function Initialize(b1:b2Body, b2:b2Body,
						ga1:b2Vec2, ga2:b2Vec2,
						anchor1:b2Vec2, anchor2:b2Vec2,
						r:Number):void
		{
			bodyA = b1;
			bodyB = b2;
			groundAnchorA.CopyFrom (ga1);
			groundAnchorB.CopyFrom (ga2);
			bodyA.GetLocalPoint_Output(anchor1, localAnchorA);
			bodyB.GetLocalPoint_Output(anchor2, localAnchorB);
			//b2Vec2 d1 = anchor1 - ga1;
			var d1:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (anchor1.x - ga1.x, anchor1.y - ga1.y)
			lengthA = d1.Length();
			//b2Vec2 d2 = anchor2 - ga2;
			var d2:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (anchor2.x - ga2.x, anchor2.y - ga2.y);
			lengthB = d2.Length();
			ratio = r;
			//b2Assert(ratio > b2_epsilon);
			var C:Number = lengthA + ratio * lengthB;
			maxLengthA = C - ratio * b2PulleyJoint.b2_minPulleyLength;
			maxLengthB = (C - b2PulleyJoint.b2_minPulleyLength) / ratio;
		}
	} // class
} // package
