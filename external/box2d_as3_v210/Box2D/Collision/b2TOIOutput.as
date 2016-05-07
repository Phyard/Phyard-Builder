package Box2D.Collision
{
	import Box2D.Common.b2Sweep;
	
	/// Input parameters for b2TimeOfImpact
	public class b2TOIOutput
	{
		//enum State
		//{
			public static const e_unknown:int = 0;
			public static const e_failed:int = 1;
			public static const e_overlapped:int = 2;
			public static const e_touching:int = 3;
			public static const e_separated:int = 4;
		//};

		//State state;
		public var state:int;
		public var t:Number;
	} // class
} // package
