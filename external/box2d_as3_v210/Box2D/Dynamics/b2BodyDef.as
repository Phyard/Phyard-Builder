package Box2D.Dynamics
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Common.b2Vec2;
	
	/// A body definition holds all the data needed to construct a rigid body.
	/// You can safely re-use body definitions. Shapes are added to a body after construction.
	//struct b2BodyDef
	public class b2BodyDef
	{
		/// This constructor sets the body definition default values.
		public function b2BodyDef()
		{
			userData = null;
			position.Set(0.0, 0.0);
			angle = 0.0;
			linearVelocity.Set(0.0, 0.0);
			angularVelocity = 0.0;
			linearDamping = 0.0;
			angularDamping = 0.0;
			allowSleep = true;
			awake = true;
			fixedRotation = false;
			bullet = false;
			type = b2Body.b2_staticBody;
			active = true;
			inertiaScale = 1.0;
		}

		/// The body type: static, kinematic, or dynamic.
		/// Note: if a dynamic body would have zero mass, the mass is set to one.
		//b2BodyType type;
		public var type:int;

		/// The world position of the body. Avoid creating bodies at the origin
		/// since this can lead to many overlapping shapes.
		public var position:b2Vec2 = new b2Vec2 ();

		/// The world angle of the body in radians.
		public var angle:Number;

		/// The linear velocity of the body in world co-ordinates.
		public var linearVelocity:b2Vec2 = new b2Vec2 ();

		/// The angular velocity of the body.
		public var angularVelocity:Number;

		/// Linear damping is use to reduce the linear velocity. The damping parameter
		/// can be larger than 1.0f but the damping effect becomes sensitive to the
		/// time step when the damping parameter is large.
		public var linearDamping:Number;

		/// Angular damping is use to reduce the angular velocity. The damping parameter
		/// can be larger than 1.0f but the damping effect becomes sensitive to the
		/// time step when the damping parameter is large.
		public var angularDamping:Number;

		/// Set this flag to false if this body should never fall asleep. Note that
		/// this increases CPU usage.
		public var allowSleep:Boolean;

		/// Is this body initially awake or sleeping?
		public var awake:Boolean;

		/// Should this body be prevented from rotating? Useful for characters.
		public var fixedRotation:Boolean;

		/// Is this a fast moving body that should be prevented from tunneling through
		/// other moving bodies? Note that all bodies are prevented from tunneling through
		/// static bodies.
		/// @warning You should use this flag sparingly since it increases processing time.
		public var bullet:Boolean;

		/// Does this body start out active?
		public var active:Boolean;

		/// Use this to store application specific body data.
		public var userData:Object;

		/// Experimental: scales the inertia tensor.
		public var inertiaScale:Number;

	} // class
} // package
