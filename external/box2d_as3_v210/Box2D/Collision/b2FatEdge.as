package Box2D.Collision
{
	import Box2D.Common.b2Vec2;

	// Edge shape plus more stuff.
	public class b2FatEdge
	{
		public var v0:b2Vec2 = new b2Vec2 (), v1:b2Vec2 = new b2Vec2 (), v2:b2Vec2 = new b2Vec2 (), v3:b2Vec2 = new b2Vec2 ();
		public var normal:b2Vec2 = new b2Vec2 ();
		public var hasVertex0:Boolean, hasVertex3:Boolean;
	}
}
