package Box2D.Dynamics.Contacts
{
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Settings;
	import Box2D.Dynamics.b2Body;
	
	public class b2TOIConstraint
	{
		public var localPoints:Array = new Array (b2Settings.b2_maxManifoldPoints);
		public var localNormal:b2Vec2 = new b2Vec2 ();
		public var localPoint:b2Vec2 = new b2Vec2 ();
		//b2Manifold::Type type;
		public var type:int;
		public var radius:Number;
		public var pointCount:int;
		public var bodyA:b2Body;
		public var bodyB:b2Body;
		
		public function b2TOIConstraint ()
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++ i)
			{
				localPoints [i] = new b2Vec2 ();
			}
		}
	}
}
