
package Box2D.Common
{
	/// A 2D column vector with 3 elements.
	//struct b2Vec3
	public class b2Vec3
	{
		// this funciton doesn't exist in the c++ version
		public function Clone ():b2Vec3
		{
			var vec3:b2Vec3 = new b2Vec3 ();
			vec3.CopyFrom (this);			
			return vec3;			
		}
		
		// this funciton doesn't exist in the c++ version
		public function CopyFrom (another:b2Vec3):void
		{
			x = another.x; y = another.y; z = another.z;	
		}
		
		/// Default constructor does nothing (for performance).
		public function b2Vec3() {}

		/// Construct using coordinates.
		//b2Vec3(float32 x, float32 y, float32 z) : x(x), y(y), z(z) {}
		public static function b2Vec3_From3Numbers(x_:Number, y_:Number, z_:Number):b2Vec3
		{
			var vec3:b2Vec3 = new b2Vec3 ();
			vec3.Set (x_, y_, z_);
			
			return vec3;
		}

		/// Set this vector to all zeros.
		public function SetZero():void { x = 0.0; y = 0.0; z = 0.0; }

		/// Set this vector to some specified coordinates.
		public function Set(x_:Number, y_:Number, z_:Number):void { x = x_; y = y_; z = z_; }
		
		//this function doesn't exist in the c++ version
		public function Set_FromVector(vec3:b2Vec3):void { x = vec3.x; y = vec3.y; z = vec3.z; }

		/// Negate this vector.
		//b2Vec3 operator -() const { b2Vec3 v; v.Set(-x, -y, -z); return v; }
		public function GetNegative ():b2Vec3
		{
			var v:b2Vec3 = new b2Vec3 (); v.Set(-x, -y, -z); return v;
		}

		/// Add a vector to this vector.
		//void operator += (const b2Vec3& v)
		//{
		//	x += v.x; y += v.y; z += v.z;
		//}
		public function AddWith (v:b2Vec3):void
		{
			x += v.x; y += v.y; z += v.z;
		}

		/// Subtract a vector from this vector.
		//void operator -= (const b2Vec3& v)
		//{
		//	x -= v.x; y -= v.y; z -= v.z;
		//}
		public function SubtractWith (v:b2Vec3):void
		{
			x -= v.x; y -= v.y; z -= v.z;
		}

		/// Multiply this vector by a scalar.
		//void operator *= (float32 s)
		//{
		//	x *= s; y *= s; z *= s;
		//}
		public function Scale (s:Number):void
		{
			x *= s; y *= s; z *= s;
		}

		public var x:Number, y:Number, z:Number;
		
	} // class
} // package
