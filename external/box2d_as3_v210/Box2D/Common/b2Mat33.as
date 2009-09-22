
package Box2D.Common
{
	/// A 3-by-3 matrix. Stored in column-major order.
	//struct b2Mat33
	public class b2Mat33
	{
		/// The default constructor does nothing (for performance).
		public function b2Mat33() {}

		/// Construct this matrix using columns.
		public static function b2Mat33_From3Vectors(c1:b2Vec3, c2:b2Vec3, c3:b2Vec3):b2Mat33
		{
			var mat33:b2Mat33 = new b2Mat33
			mat33.col1.Set_FromVector (c1);
			mat33.col2.Set_FromVector (c2);
			mat33.col3.Set_FromVector (c3);
			
			return mat33;
		}

		/// Set this matrix to all zeros.
		public function SetZero():void
		{
			col1.SetZero();
			col2.SetZero();
			col3.SetZero();
		}

		/// Solve A * x = b, where b is a column vector. This is more efficient
		/// than computing the inverse in one-shot cases.
		public function Solve33(b:b2Vec3):b2Vec3
		{
			var det:Number = b2Math.b2Dot3 (col1, b2Math.b2Cross3 (col2, col3));
			//b2Assert(det != 0.0f);
			det = 1.0 / det;
			var x:b2Vec3 = new b2Vec3 ();
			x.x = det * b2Math.b2Dot3 (b, b2Math.b2Cross3 (col2, col3));
			x.y = det * b2Math.b2Dot3 (col1, b2Math.b2Cross3 (b, col3));
			x.z = det * b2Math.b2Dot3 (col1, b2Math.b2Cross3 (col2, b));
			return x;
		}

		/// Solve A * x = b, where b is a column vector. This is more efficient
		/// than computing the inverse in one-shot cases. Solve only the upper
		/// 2-by-2 matrix equation.
		public function Solve22(b:b2Vec2):b2Vec2
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

		public var col1:b2Vec3 = new b2Vec3 (), col2:b2Vec3 = new b2Vec3 (), col3:b2Vec3 = new b2Vec3 ();
		
	} // class
} // package
