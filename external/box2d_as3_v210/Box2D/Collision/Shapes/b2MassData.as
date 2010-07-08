package Box2D.Collision.Shapes
{
	import Box2D.Common.b2Vec2;
	
	/// This holds the mass data computed for a shape.
	public class b2MassData
	{
		/// The mass of the shape, usually in kilograms.
		public var mass:Number;

		/// The position of the shape's centroid relative to the shape's origin.
		public var center:b2Vec2 = new b2Vec2 ();

		/// The rotational inertia of the shape about the local origin.
		public var I:Number;
	} // class
} // package
