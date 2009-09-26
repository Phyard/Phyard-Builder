
package Box2D.Collision
{
	import Box2D.Common.b2Vec2;
	
	public class b2SimplexVertex
	{
		public function Clone ():b2SimplexVertex
		{
			var clone:b2SimplexVertex = new b2SimplexVertex ();
			clone.CopyFrom (this);
			
			return clone;
		}
		
		public function CopyFrom (another:b2SimplexVertex):void
		{
			wA.CopyFrom (another.wA);
			wB.CopyFrom (another.wB);
			w.CopyFrom (another.w);
			
			a = another.a;
			indexA = another.indexA;
			indexB = another.indexB;
		}
		
		public var wA:b2Vec2 = new b2Vec2 ();		// support point in proxyA
		public var wB:b2Vec2 = new b2Vec2 ();		// support point in proxyB
		public var w:b2Vec2 = new b2Vec2 ();		// wB - wA
		public var a:Number;		// barycentric coordinate for closest point
		public var indexA:int;	// wA index
		public var indexB:int;	// wB index
	} // class
} // package
