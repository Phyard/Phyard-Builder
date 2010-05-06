package Box2D.Collision
{
	import Box2D.Common.b2Vec2;
	
	/// Ray-cast input data. The ray extends from p1 to p1 + maxFraction * (p2 - p1).
	public class b2RayCastInput
	{
		public var p1:b2Vec2 = new b2Vec2 (), p2:b2Vec2 = new b2Vec2 ();
		public var maxFraction:Number;
	} // class
} // package
