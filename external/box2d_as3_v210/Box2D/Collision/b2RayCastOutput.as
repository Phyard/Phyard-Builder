package Box2D.Collision
{
	import Box2D.Common.b2Vec2;
	
	/// Ray-cast output data.
	public class b2RayCastOutput
	{
		public var normal:b2Vec2 = new b2Vec2 ();
		public var fraction:Number;
		public var hit:Boolean;
	} // class
} // package
