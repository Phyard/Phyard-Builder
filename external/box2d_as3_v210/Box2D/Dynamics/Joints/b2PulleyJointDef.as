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
			groundAnchor1.Set(-1.0, 1.0);
			groundAnchor2.Set(1.0, 1.0);
			localAnchor1.Set(-1.0, 0.0);
			localAnchor2.Set(1.0, 0.0);
			length1 = 0.0;
			maxLength1 = 0.0;
			length2 = 0.0;
			maxLength2 = 0.0;
			ratio = 1.0;
			collideConnected = true;
		}

		/// Initialize the bodies, anchors, lengths, max lengths, and ratio using the world anchors.
		//void Initialize(b2Body* body1, b2Body* body2,
		//				const b2Vec2& groundAnchor1, const b2Vec2& groundAnchor2,
		//				const b2Vec2& anchor1, const b2Vec2& anchor2,
		//				float32 ratio);

		/// The first ground anchor in world coordinates. This point never moves.
		public var groundAnchor1:b2Vec2 = new b2Vec2 ();

		/// The second ground anchor in world coordinates. This point never moves.
		public var groundAnchor2:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to body1's origin.
		public var localAnchor1:b2Vec2 = new b2Vec2 ();

		/// The local anchor point relative to body2's origin.
		public var localAnchor2:b2Vec2 = new b2Vec2 ();

		/// The a reference length for the segment attached to body1.
		public var length1:Number;

		/// The maximum length of the segment attached to body1.
		public var maxLength1:Number;

		/// The a reference length for the segment attached to body2.
		public var length2:Number;

		/// The maximum length of the segment attached to body2.
		public var maxLength2:Number;

		/// The pulley ratio, used to simulate a block-and-tackle.
		public var ratio:Number;
		
		// ...
		public function Initialize(b1:b2Body, b2:b2Body,
						ga1:b2Vec2, ga2:b2Vec2,
						anchor1:b2Vec2, anchor2:b2Vec2,
						r:Number):void
		{
			body1 = b1;
			body2 = b2;
			groundAnchor1.CopyFrom (ga1);
			groundAnchor2.CopyFrom (ga2);
			localAnchor1.CopyFrom (body1.GetLocalPoint(anchor1));
			localAnchor2.CopyFrom (body2.GetLocalPoint(anchor2));
			//b2Vec2 d1 = anchor1 - ga1;
			var d1:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (anchor1.x - ga1.x, anchor1.y - ga1.y)
			length1 = d1.Length();
			//b2Vec2 d2 = anchor2 - ga2;
			var d2:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (anchor2.x - ga2.x, anchor2.y - ga2.y);
			length2 = d2.Length();
			ratio = r;
			//b2Assert(ratio > B2_FLT_EPSILON);
			var C:Number = length1 + ratio * length2;
			maxLength1 = C - ratio * b2PulleyJoint.b2_minPulleyLength;
			maxLength2 = (C - b2PulleyJoint.b2_minPulleyLength) / ratio;
		}
	} // class
} // package
