package Box2dEx.BroadPhase.SweepAndPrune
{
	public class b2Bound
	{
		public function IsLower():Boolean { return (value & 1) == 0; }
		public function IsUpper():Boolean { return (value & 1) == 1; }

		public var value:int;
		public var proxyId:int;
		public var stabbingCount:int;
	} // class
} // pacakge
