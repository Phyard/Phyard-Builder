package Box2D.Dynamics.Joints
{
	import Box2D.Dynamics.b2Body;

	/// A joint edge is used to connect bodies and joints together
	/// in a joint graph where each body is a node and each joint
	/// is an edge. A joint edge belongs to a doubly linked list
	/// maintained in each attached body. Each joint has two joint
	/// nodes, one for each attached body.
	public class b2JointEdge
	{
		public var other:b2Body;			///< provides quick access to the other body attached.
		public var joint:b2Joint;			///< the joint
		public var prev:b2JointEdge;		///< the previous joint edge in the body's joint list
		public var next:b2JointEdge;		///< the next joint edge in the body's joint list
	} // class
} // package
