
package Box2D.Collision
{
	/// Output for b2Distance.
	public  b2DistanceOutput
	{
		public var pointA:b2Vec2 = new b2Vec2 ();		///< closest point on shapeA
		public var pointB:b2Vec2 = new b2Vec2 ();		///< closest point on shapeB
		public var distance:Number;
		public var iterations:int;	///< number of GJK iterations used
	} // class
} // package
