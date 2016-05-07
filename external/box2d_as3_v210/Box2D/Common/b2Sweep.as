
package Box2D.Common
{
	/// This describes the motion of a body/shape for TOI computation.
	/// Shapes are defined with respect to the body origin, which may
	/// no coincide with the center of mass. However, to support dynamics
	/// we must interpolate the center of mass position.
	//struct b2Sweep
	public class b2Sweep
	{
		// this function doesn't exist in the c++ version
		public function Clone ():b2Sweep
		{
			var sweep:b2Sweep = new b2Sweep ();
			sweep.CopyFrom (this);
			return sweep;
		}
		
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2Sweep):void
		{
			localCenter.x = another.localCenter.x;
			localCenter.y = another.localCenter.y;
			c0.x = another.c0.x;
			c0.y = another.c0.y;
			c.x = another.c.x;
			c.y = another.c.y;
			a0 = another.a0;
			a = another.a;
			alpha0 = another.alpha0;
		}
		
		private static var mVec2:b2Vec2 = new b2Vec2 ();
		/// Get the interpolated transform at a specific time.
		/// @param beta is a factor in [0,1], where 0 indicates alpha0.
		public function GetTransform(xf:b2Transform, beta:Number):void
		{
			var _beta:Number = 1.0 - beta;
			xf.position.x = _beta * c0.x + beta * c.x;
			xf.position.y = _beta * c0.y + beta * c.y;
			var angle:Number = _beta * a0 + beta * a;
			xf.R.SetFromAngle(angle);

			// Shift to origin
			//xf->position -= b2Mul(xf->R, localCenter);
			var vec2:b2Vec2 = mVec2;
			b2Math.b2Mul_Matrix22AndVector2_Output (xf.R, localCenter, vec2);
			xf.position.x -= vec2.x;
			xf.position.y -= vec2.y;
		}

		/// Advance the sweep forward, yielding a new initial state.
		/// @param alpha the new initial time.
		public function Advance(alpha:Number):void
		{
			//b2Assert(alpha0 < 1.0f);
			var beta:Number = (alpha - alpha0) / (1.0 - alpha0);
			var _beta:Number = 1.0 - beta;
			c0.x = _beta * c0.x + beta * c.x;
			c0.y = _beta * c0.y + beta * c.y;
			a0 = _beta * a0 + beta * a;
			alpha0 = alpha;
		}

		/// Normalize an angle in radians to be between -pi and pi
		public function Normalize():void
		{
			const twoPi:Number = 2.0 * Math.PI;
			var d:Number =  twoPi * Math.floor (a0 / twoPi);
			a0 -= d;
			a -= d;
		}

		public var localCenter:b2Vec2 = new b2Vec2 ();	///< local center of mass position
		public var c0:b2Vec2 = new b2Vec2 (), c:b2Vec2 = new b2Vec2 ();		///< center world positions
		public var a0:Number, a:Number;		///< world angles

		/// Fraction of the current time step in the range [0,1]
		/// c0 and a0 are the positions at alpha0.
		public var alpha0:Number;
		
	} // class
} // package
