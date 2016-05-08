package Box2D.Collision
{
	public class b2EPAxis
	{
		//enum Type
		//{
			public static const e_unknown:int = 0;
			public static const e_edgeA:int = 1;
			public static const e_edgeB:int = 2;
		//};

		//Type type;
		public var type:int;
		public var index:int;
		public var separation:Number;
	}
}
