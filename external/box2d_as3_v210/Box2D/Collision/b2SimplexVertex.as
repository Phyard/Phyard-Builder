
package Box2D.Collision
{
	public class b2SimplexVertex
	{
		public var wA:b2Vec2 = new b2Vec2 ();		// support point in proxyA
		public var wB:b2Vec2 = new b2Vec2 ();		// support point in proxyB
		public var w:b2Vec2 = new b2Vec2 ();		// wB - wA
		public var a:Number;		// barycentric coordinate for closest point
		public var indexA:int;	// wA index
		public var indexB:int;	// wB index
	} // class
} // package
