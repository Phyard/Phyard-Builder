package Box2D.Dynamics.Contacts
{
	public class b2ContactConstraint
	{
		public function ()
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++ i)
			{
				points [i] = new b2ContactConstraintPoint ();
			}
		}
		
		//b2ContactConstraintPoint points[b2_maxManifoldPoints];
		public var points:Array = new Array (b2Settings.b2_maxManifoldPoints);
		public var localPlaneNormal:b2Vec2 = new b2Vec2 ();
		public var localPoint:b2Vec2 = new b2Vec2 ();
		public var normal:b2Vec2 = new b2Vec2 ();
		public var normalMass:b2Mat22 = new b2Mat22 ();
		public var K:b2Mat22 = new b2Mat22 ();
		public var bodyA:b2Body;
		public var bodyB:b2Body;
		//b2Manifold::Type type;
		public var type:int;
		public var radius:Number;
		public var friction:Number;
		public var restitution:Number;
		public var pointCount:int;
		public var manifold:b2Manifold;
	} // class
} // package
