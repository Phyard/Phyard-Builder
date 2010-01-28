package Box2D.Collision
{
	import Box2D.Common.b2Vec2;
	
	/// A manifold point is a contact point belonging to a contact
	/// manifold. It holds details related to the geometry and dynamics
	/// of the contact points.
	/// The local point usage depends on the manifold type:
	/// -e_circles: the local center of circleB
	/// -e_faceA: the local center of cirlceB or the clip point of polygonB
	/// -e_faceB: the clip point of polygonA
	/// This structure is stored across time steps, so we keep it small.
	/// Note: the impulses are used for internal caching and may not
	/// provide reliable contact forces, especially for high speed collisions.
	public class b2ManifoldPoint
	{
		public function Clone ():b2ManifoldPoint
		{
			var mp:b2ManifoldPoint = new b2ManifoldPoint ();
			
			mp.CopyFrom (this);
			
			return mp;
		}
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2ManifoldPoint):void
		{
			localPoint.x = another.localPoint.x;
			localPoint.y = another.localPoint.y;
			normalImpulse = another.normalImpulse;
			tangentImpulse = another.tangentImpulse;
			
			//m_id.CopyFrom (another.m_id);
			id = another.id;
		}
		
		public var localPoint:b2Vec2 = new b2Vec2 ();		///< usage depends on manifold type
		public var normalImpulse:Number;	///< the non-penetration impulse
		public var tangentImpulse:Number;	///< the friction impulse
		//public var id:b2ContactID = new b2ContactID ();			///< uniquely identifies a contact point between two shapes
		// hacking to optimize
		public var id:uint;
		
	} // class
} // package
