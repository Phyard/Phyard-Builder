package Box2dEx.BroadPhase.SweepAndPrune
{
	public class b2Pair
	{
		//enum
		//{
			public static const e_pairBuffered:int	= 0x0001;
			public static const e_pairRemoved:int	= 0x0002;
			public static const e_pairFinal:int		= 0x0004;
		//};

		public function SetBuffered():void		{ status |= e_pairBuffered; }
		public function ClearBuffered():void	{ status &= ~e_pairBuffered; }
		public function IsBuffered():Boolean		{ return (status & e_pairBuffered) == e_pairBuffered; }

		public function SetRemoved():void		{ status |= e_pairRemoved; }
		public function ClearRemoved():void		{ status &= ~e_pairRemoved; }
		public function IsRemoved():Boolean		{ return (status & e_pairRemoved) == e_pairRemoved; }

		public function SetFinal():void		{ status |= e_pairFinal; }
		public function IsFinal():Boolean		{ return (status & e_pairFinal) == e_pairFinal; }

		//public var userData:Object; // this is a b2Contact object
		public var proxyId1:int;
		public var proxyId2:int;
		public var next:int;
		public var status:int;
	} // class
} // package
