
package Box2D.Common
{
	/// A 2D column vector.
	//struct b2Vec2
	public class b2Vec2
	{
		// this funciton doesn't exist in the c++ version
		public function Clone ():b2Vec2
		{
			var vec2:b2Vec2 = new b2Vec2 ();
			vec2.CopyFrom (this);
			return vec2;
		}
		
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2Vec2):void
		{
			x = another.x;
			y = another.y;
		}
		
		/// Default constructor does nothing (for performance).
		public function b2Vec2() {}

		/// Construct using coordinates.
		//b2Vec2(float32 x, float32 y) : x(x), y(y) {}
		public static function b2Vec2_From2Numbers (x_:Number, y_:Number):b2Vec2 
		{
			var vec2:b2Vec2 = new b2Vec2 ();
			vec2.Set (x_, y_);
			
			return vec2;
		}

		/// Set this vector to all zeros.
		public function SetZero():void { x = 0.0; y = 0.0; }

		/// Set this vector to some specified coordinates.
		public function Set(x_:Number, y_:Number):void { x = x_; y = y_; }
		
		// this function doesn't exist in the c++ version
		//public function Set_FromVector(vec2:b2Vec2):void { x = vec2.x; y = vec2.y; }

		/// Negate this vector.
		//b2Vec2 operator -() const { b2Vec2 v; v.Set(-x, -y); return v; }
		public function GetNegative ():b2Vec2
		{
			var v:b2Vec2 = new b2Vec2 (); v.Set(-x, -y); return v;
		}
		
		/// Read from and indexed element.
		//float32 operator () (int32 i) const
		//{
		//	return (&x)[i];
		//}

		/// Write to an indexed element.
		//float32& operator () (int32 i)
		//{
		//	return (&x)[i];
		//}

		/// Add a vector to this vector.
		//void operator += (const b2Vec2& v)
		//{
		//	x += v.x; y += v.y;
		//}
		public function AddWith (v:b2Vec2):void
		{
			x += v.x; y += v.y;
		}
				
		/// Subtract a vector from this vector.
		//void operator -= (const b2Vec2& v)
		//{
		//	x -= v.x; y -= v.y;
		//}
		public function SubtractWith (v:b2Vec2):void
		{
			x -= v.x; y -= v.y;
		}

		/// Multiply this vector by a scalar.
		//void operator *= (float32 a)
		//{
		//	x *= a; y *= a;
		//}
		public function Scale (a:Number):void
		{
			x *= a; y *= a;
		}

		/// Get the length of this vector (the norm).
		public function Length():Number
		{
			//return b2Math.b2Sqrt(x * x + y * y);
			return Math.sqrt(x * x + y * y);
		}

		/// Get the length squared. For performance, use this instead of
		/// b2Vec2::Length (if possible).
		public function LengthSquared():Number
		{
			return x * x + y * y;
		}

		/// Convert this vector into a unit vector. Returns the length.
		public function Normalize():Number
		{
			var length:Number = Length();
			if (length < b2Settings.B2_FLT_EPSILON)
			{
				return 0.0;
			}
			var invLength:Number = 1.0 / length;
			x *= invLength;
			y *= invLength;

			return length;
		}

		/// Does this vector contain finite coordinates?
		public function IsValid():Boolean
		{
			return b2Math.b2IsValid(x) && b2Math.b2IsValid(y);
		}

		public var x:Number, y:Number;
		
	} // class
} // package
