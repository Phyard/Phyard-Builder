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
			m_localPoint.x = another.m_localPoint.x;
			m_localPoint.y = another.m_localPoint.y;
			m_normalImpulse = another.m_normalImpulse;
			m_tangentImpulse = another.m_tangentImpulse;
			
			//m_id.CopyFrom (another.m_id);
			m_id = another.m_id;
		}
		
		public var m_localPoint:b2Vec2 = new b2Vec2 ();		///< usage depends on manifold type
		public var m_normalImpulse:Number;	///< the non-penetration impulse
		public var m_tangentImpulse:Number;	///< the friction impulse
		//public var m_id:b2ContactID = new b2ContactID ();			///< uniquely identifies a contact point between two shapes
		// hacking to optimize
		public var m_id:uint;
		
	} // class
} // package
