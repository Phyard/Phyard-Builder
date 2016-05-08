package Box2D.Dynamics.Contacts
{
	import Box2D.Dynamics.b2Body;

	public class b2ContactEdge
	{
		public var other:b2Body;			///< provides quick access to the other body attached.
		public var contact:b2Contact;		///< the contact
		public var prev:b2ContactEdge;	///< the previous contact edge in the body's contact list
		public var next:b2ContactEdge;	///< the next contact edge in the body's contact list
	} // class
} // package
