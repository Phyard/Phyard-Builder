package Box2dEx.BroadPhase.SweepAndPrune
{
	public class b2eProxy
	{
		//uint16 GetNext() const { return lowerBounds[0]; }
		//void SetNext(uint16 next) { lowerBounds[0] = next; }
		//bool IsValid() const { return overlapCount != b2_invalid; }
		//
		//uint16 lowerBounds[2], upperBounds[2];
		//uint16 overlapCount;
		//uint16 timeStamp;
		//void* userData;
		
		public function GetNext():int { return timeStamp; }
		public function SetNext(next:int):void { timeStamp = next; }
		public function IsValid():Boolean { return overlapCount != b2eBroadPhase_SweepAndPrune.b2_invalid; }

		public var lowerBounds:Array = [0, 0], upperBounds:Array = [0, 0];
		public var overlapCount:int;
		public var timeStamp:int;
		public var userData:Object;
	} // class
} // pacakge
