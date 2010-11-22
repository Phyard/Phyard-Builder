package Box2D.Dynamics.Contacts
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Mat22;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.b2Manifold;
	
	public class b2ContactConstraint
	{
		public function b2ContactConstraint ()
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++ i)
			{
				points [i] = new b2ContactConstraintPoint ();
			}
		}
		
		//b2ContactConstraintPoint points[b2_maxManifoldPoints];
		public var points:Array = new Array (b2Settings.b2_maxManifoldPoints);
		public var localNormal:b2Vec2 = new b2Vec2 ();
		public var localPoint:b2Vec2 = new b2Vec2 ();
		public var normal:b2Vec2 = new b2Vec2 ();
		public var normalMass:b2Mat22 = new b2Mat22 ();
		public var K:b2Mat22 = new b2Mat22 ();
		public var bodyA:b2Body;
		public var bodyB:b2Body;
		//b2Manifold::Type type;
		public var type:int;
		public var radiusA:Number;
		public var radiusB:Number;
		public var friction:Number;
		public var restitution:Number;
		public var pointCount:int;
		public var manifold:b2Manifold;
	} // class
} // package
