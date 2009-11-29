package Box2D.Dynamics.Joints
{
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	
	public class b2Jacobian
	{
		public var linearA:b2Vec2 = new b2Vec2 ();
		public var angularA:Number;
		public var linearB:b2Vec2 = new b2Vec2 ();
		public var angularB:Number;

		//void SetZero();
		//void Set(const b2Vec2& x1, float32 a1, const b2Vec2& x2, float32 a2);
		//float32 Compute(const b2Vec2& x1, float32 a1, const b2Vec2& x2, float32 a2);
		
		public function SetZero():void
		{
			linearA.SetZero(); angularA = 0.0;
			linearB.SetZero(); angularB = 0.0;
		}

		public function Set(x1:b2Vec2, a1:Number, x2:b2Vec2, a2:Number):void
		{
			linearA.CopyFrom (x1); angularA = a1;
			linearB.CopyFrom (x2); angularB = a2;
		}

		public function Compute(x1:b2Vec2, a1:Number, x2:b2Vec2, a2:Number):Number
		{
			return b2Math.b2Dot2 (linearA, x1) + angularA * a1 + b2Math.b2Dot2 (linearB, x2) + angularB * a2;
		}
	} // class
} // package
