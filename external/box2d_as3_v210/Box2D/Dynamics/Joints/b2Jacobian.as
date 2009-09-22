package Box2D.Dynamics.Joints
{
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	
	public class b2Jacobian
	{
		public var linear1:b2Vec2 = new b2Vec2 ();
		public var angular1:Number;
		public var linear2:b2Vec2 = new b2Vec2 ();
		public var angular2:Number;

		//void SetZero();
		//void Set(const b2Vec2& x1, float32 a1, const b2Vec2& x2, float32 a2);
		//float32 Compute(const b2Vec2& x1, float32 a1, const b2Vec2& x2, float32 a2);
		
		public function SetZero():void
		{
			linear1.SetZero(); angular1 = 0.0;
			linear2.SetZero(); angular2 = 0.0;
		}

		public function Set(x1:b2Vec2, a1:Number, x2:b2Vec2, a2:Number):void
		{
			linear1 = x1; angular1 = a1;
			linear2 = x2; angular2 = a2;
		}

		public function Compute(x1:b2Vec2, a1:Number, x2:b2Vec2, a2:Number):Number
		{
			return b2Math.b2Dot2 (linear1, x1) + angular1 * a1 + b2Math.b2Dot2 (linear2, x2) + angular2 * a2;
		}
	} // class
} // package
