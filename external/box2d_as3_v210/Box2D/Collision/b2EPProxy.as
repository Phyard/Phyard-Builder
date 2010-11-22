package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Vec2;

	// This lets us treate and edge shape and a polygon in the same
	// way in the SAT collider.
	public class b2EPProxy
	{
		//b2Vec2 vertices[b2_maxPolygonVertices];
		//b2Vec2 normals[b2_maxPolygonVertices];
		public var vertices:Array;
		public var normals:Array;
		public var centroid:b2Vec2 = new b2Vec2 ();
		public var count:int;

		public function b2EPProxy ()
		{
			vertices = new Array (b2Settings.b2_maxPolygonVertices);
			normals = new Array (b2Settings.b2_maxPolygonVertices);
			for (var i:int = 0; i < b2Settings.b2_maxPolygonVertices; ++ i)
			{
				vertices [i] = new b2Vec2 ();
				normals [i] = new b2Vec2 ();
			}
		}
	}
}
