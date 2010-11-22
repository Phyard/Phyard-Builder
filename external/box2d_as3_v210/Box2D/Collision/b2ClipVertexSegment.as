package Box2D.Collision
{
	//notice: this class doesn't exit in the c++ version
	
	/// Used for computing contact manifolds.
	public class b2ClipVertexSegment
	{
		public var clipVertex0:b2ClipVertex = new b2ClipVertex ();
		public var clipVertex1:b2ClipVertex = new b2ClipVertex ();
		
		public function b2ClipVertexSegment ()
		{
		}
		
		public function GetClipVertexById (id:int):b2ClipVertex
		{
			if (id == 0) return clipVertex0;
			if (id == 1) return clipVertex1;
			return null;
		}
		
	} // class
} // package
