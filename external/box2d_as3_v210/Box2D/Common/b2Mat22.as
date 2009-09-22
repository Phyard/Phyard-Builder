
package Box2D.Common
{
	/// A 2-by-2 matrix. Stored in column-major order.
	public class b2Mat22
	{
		// this funciton doesn't exist in the c++ version
		public function Clone ():b2Mat22
		{
			var mat22:b2Mat22 = new b2Mat22 ();
			mat22.CopyFrom (this);
			return mat22;
		}
		
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2Mat22):void
		{
			col1.CopyFrom (another.col1);
			col2.CopyFrom (another.col2);
		}
		
		/// The default constructor does nothing (for performance).
		public function b2Mat22() {}

		/// Construct this matrix using columns.
		//b2Mat22(const b2Vec2& c1, const b2Vec2& c2)
		public static function b2Mat22_From2Vectors(c1:b2Vec2, c2:b2Vec2):b2Mat22
		{
			var mat22:b2Mat22 = new b2Mat22 ();
			mat22.Set (c1, c2);
			
			return mat22;
		}

		/// Construct this matrix using scalars.
		//b2Mat22(float32 a11, float32 a12, float32 a21, float32 a22)
		public static function b2Mat22_From4Numbers(a11:Number, a12:Number, a21:Number, a22:Number):b2Mat22
		{
			var mat22:b2Mat22 = new b2Mat22 ();
			mat22.col1.x = a11; mat22.col1.y = a21;
			mat22.col2.x = a12; mat22.col2.y = a22;
			
			return mat22;
		}

		/// Construct this matrix using an angle. This matrix becomes
		/// an orthonormal rotation matrix.
		//explicit b2Mat22(float32 angle)
		public static function b2Mat22_FromAngle(angle:Number):b2Mat22
		{
			// TODO_ERIN compute sin+cos together.
			//var c:Number = cosf(angle), s:Number = sinf(angle);
			var c:Number = Math.cos (angle), s:Number = Math.sin (angle);
			
			var mat22:b2Mat22 = new b2Mat22 ();
			mat22.col1.x = c; mat22.col2.x = -s;
			mat22.col1.y = s; mat22.col2.y = c;
			
			return mat22;
		}

		/// Initialize this matrix using columns.
		public function Set(c1:b2Vec2, c2:b2Vec2):void
		{
			col1.Set (c1.x, c1.y);
			col2.Set (c2.x, c2.y);
		}

		/// Initialize this matrix using an angle. This matrix becomes
		/// an orthonormal rotation matrix.
		//void Set(float32 angle)
		public function SetFromAngle(angle:Number):void
		{
			//var c:Number = cosf(angle), s:Number = sinf(angle);
			var c:Number = Math.cos (angle), s:Number = Math.sin (angle);
			col1.x = c; col2.x = -s;
			col1.y = s; col2.y = c;
		}
		
		// this function doesn't exist in the c++ version
		public function SetFromMatrix (mat22:b2Mat22):void
		{
			Set (mat22.col1, mat22.col2);
		}

		/// Set this to the identity matrix.
		public function SetIdentity():void
		{
			col1.x = 1.0; col2.x = 0.0;
			col1.y = 0.0; col2.y = 1.0;
		}

		/// Set this matrix to all zeros.
		public function SetZero():void
		{
			col1.x = 0.0; col2.x = 0.0;
			col1.y = 0.0; col2.y = 0.0;
		}

		/// Extract the angle from this matrix (assumed to be
		/// a rotation matrix).
		public function GetAngle():Number
		{
			//return b2Math.b2Atan2(col1.y, col1.x);
			return Math.atan2 (col1.y, col1.x);
		}

		public function GetInverse():b2Mat22
		{
			var a:Number = col1.x, b:Number = col2.x, c:Number = col1.y, d:Number = col2.y;
			var B:b2Mat22 = new b2Mat22 ();
			var det:Number = a * d - b * c;
			//b2Assert(det != 0.0f);
			det = 1.0 / det;
			B.col1.x =  det * d;	B.col2.x = -det * b;
			B.col1.y = -det * c;	B.col2.y =  det * a;
			return B;
		}

		/// Solve A * x = b, where b is a column vector. This is more efficient
		/// than computing the inverse in one-shot cases.
		public function Solve(b:b2Vec2):b2Vec2
		{
			var a11:Number = col1.x, a12:Number = col2.x, a21:Number = col1.y, a22:Number = col2.y;
			var det:Number = a11 * a22 - a12 * a21;
			//b2Assert(det != 0.0f);
			det = 1.0 / det;
			var x:b2Vec2 = new b2Vec2 ();
			x.x = det * (a22 * b.x - a12 * b.y);
			x.y = det * (a11 * b.y - a21 * b.x);
			return x;
		}

		public var col1:b2Vec2 = new b2Vec2 (), col2:b2Vec2 = new b2Vec2 ();
		
	} // class
} // package
