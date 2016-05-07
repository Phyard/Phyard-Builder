package Box2D.Collision
{
	import Box2D.Common.b2Vec2;
	
	/// Used for computing contact manifolds.
	public class b2ClipVertex
	{
		// this funciton doesn't exist in the c++ version
		public function Clone ():b2ClipVertex
		{
			var cv:b2ClipVertex = new b2ClipVertex ();
			cv.CopyFrom (this);
			return cv;
		}
		
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2ClipVertex):void
		{
			v.CopyFrom (another.v);
			//id.CopyFrom (another.id);
			id = another.id;
		}
		
		public var v:b2Vec2 = new b2Vec2 ();
		//public var id:b2ContactID = new b2ContactID ();
		// hacking to optimize
		public var id:uint;
	} // class
} // package
