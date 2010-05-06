package Box2D.Collision
{
	import Box2D.Common.b2Vec2;
	
	/// Ray-cast output data. The ray hits at p1 + fraction * (p2 - p1), where p1 and p2
	/// come from b2RayCastInput.
	public class b2RayCastOutput
	{
		public var normal:b2Vec2 = new b2Vec2 ();
		public var fraction:Number;
	} // class
} // package
