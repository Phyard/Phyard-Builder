package Box2D.Collision
{
	//notice: this class doesn't exit in the c++ version
	
	/// Used for computing contact manifolds.
	public class b2ClipVertexSegment
	{
		public var cv1:b2ClipVertex = new b2ClipVertex ();
		public var cv2:b2ClipVertex = new b2ClipVertex ();
		
		public function b2ClipVertexSegment ()
		{
		}
		
		public function GetClipVertexById (id:int):b2ClipVertex
		{
			if (id == 0) return cv1;
			if (id == 0) return cv2;
			return null;
		}
		
	} // class
} // package
