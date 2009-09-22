package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Vec2;
	
	/// A manifold for two touching convex shapes.
	/// Box2D supports multiple types of contact:
	/// - clip point versus plane with radius
	/// - point versus point with radius (circles)
	/// The local point usage depends on the manifold type:
	/// -e_circles: the local center of circleA
	/// -e_faceA: the center of faceA
	/// -e_faceB: the center of faceB
	/// Similarly the local normal usage:
	/// -e_circles: not used
	/// -e_faceA: the normal on polygonA
	/// -e_faceB: the normal on polygonB
	/// We store contacts in this way so that position correction can
	/// account for movement, which is critical for continuous physics.
	/// All contact scenarios must be expressed in one of these types.
	/// This structure is stored across time steps, so we keep it small.
	public class b2Manifold
	{
		// this function doesn't exist in the c++ version
		public function Clone ():b2Manifold
		{
			var manifold:b2Manifold = new b2Manifold ();
			
			manifold.CopyFrom (this);
			
			return manifold;
		}
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2Manifold):void
		{
			m_localPlaneNormal.x = another.m_localPlaneNormal.x;
			m_localPlaneNormal.y = another.m_localPlaneNormal.y;
			m_localPoint.x = another.m_localPoint.x;
			m_localPoint.y = another.m_localPoint.y;
			m_type = another.m_type;
			
			m_pointCount = another.m_pointCount;
			for (var i:int = 0; i < m_pointCount; ++ i)
			{
				(m_points [i] as b2ManifoldPoint).CopyFrom (another.m_points [i] as b2ManifoldPoint);
			}
		}
		
		// this function doesn't exist in the c++ version
		public function b2Manifold ()
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++ i)
			{
				m_points [i] = new b2ManifoldPoint ();
			}
		}
		
		//enum Type
		//{
			public static const e_circles:int = 0;
			public static const e_faceA:int = 1;
			public static const e_faceB:int = 2;
		//};

		public var m_points:Array = new Array (b2Settings.b2_maxManifoldPoints);	///< the points of contact
		public var m_localPlaneNormal:b2Vec2 = new b2Vec2 ();						///< not use for Type::e_points
		public var m_localPoint:b2Vec2 = new b2Vec2 ();							///< usage depends on manifold type
		//Type m_type;
		public var m_type:int;
		public var m_pointCount:int;								///< the number of manifold points
		
	} // class
} // package
