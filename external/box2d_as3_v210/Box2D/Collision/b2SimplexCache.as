
package Box2D.Collision
{
	/// Used to warm start b2Distance.
	/// Set count to zero on first call.
	public class b2SimplexCache
	{
		public var metric:Number;		///< length or area
		public var count:int;
		//uint8 indexA[3];	///< vertices on shape A
		//uint8 indexB[3];	///< vertices on shape B
		public var indexA:Array = [0, 0, 0];	///< vertices on shape A
		public var indexB:Array = [0, 0, 0];	///< vertices on shape B
	} // class
} // package
