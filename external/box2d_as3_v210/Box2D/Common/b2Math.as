/*
* Copyright (c) 2006-2009 Erin Catto http://www.box2d.org
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

//#ifndef B2_MATH_H
//#define B2_MATH_H

package Box2D.Common
{
	//#include <Box2D/Common/b2Settings.h>

	//#include <cmath>
	//#include <cfloat>
	//#include <cstddef>
	//#include <limits>

	public class b2Math
	{
		include "b2Math.cpp";

		/// This function is used to ensure that a floating point number is
		/// not a NaN or infinity.
		public static function b2IsValid(x:Number):Boolean
		{
			//if (x != x)
			//{
			//	// NaN.
			//	return false;
			//}

			//float32 infinity = std::numeric_limits<float32>::infinity();
			//return -infinity < x && x < infinity;

			if (isNaN (x))
			{
				// NaN.
				return false;
			}

			return Number.NEGATIVE_INFINITY < x && x < Number.POSITIVE_INFINITY;
		}

		/// This is a approximate yet fast inverse square-root.
		public static function b2InvSqrt(x:Number):Number
		{
			//union
			//{
			//	float32 x;
			//	int32 i;
			//} convert;

			//convert.x = x;
			//float32 xhalf = 0.5f * x;
			//convert.i = 0x5f3759df - (convert.i >> 1);
			//x = convert.x;
			//x = x * (1.5f - xhalf * x * x);
			//return x;

			return 1.0 / Math.sqrt (x);
		}

		// will be directly replaced by Math.sqrt
		//#define	b2Sqrt(x)	std::sqrt(x)

		// will be directly replaced by Math.atan2
		//#define	b2Atan2(y, x)	std::atan2(y, x)

		// will be directly replaced by Math.abs
		//inline float32 b2Abs(float32 a)
		//{
		//	return a > 0.0f ? a : -a;
		//}

		/// A 2D column vector.
		//struct b2Vec2
		//{
			//@see b2Vec2 class
		//};

		/// A 2D column vector with 3 elements.
		//struct b2Vec3
		//{
			//@see b2Vec3 class
		//};

		/// A 2-by-2 matrix. Stored in column-major order.
		//struct b2Mat22
		//{
			//@see b2Mat22 class
		//};

		/// A 3-by-3 matrix. Stored in column-major order.
		//struct b2Mat33
		//{
			//@see b2Mat33 class
		//};

		/// A transform contains translation and rotation. It is used to represent
		/// the position and orientation of rigid frames.
		//struct b2Transform
		//{
			//@see b2Transform class
		//};

		/// This describes the motion of a body/shape for TOI computation.
		/// Shapes are defined with respect to the body origin, which may
		/// no coincide with the center of mass. However, to support dynamics
		/// we must interpolate the center of mass position.
		//struct b2Sweep
		//{
			//@see b2Sweep class
		//};

		/// Perform the dot product on two vectors.
		//inline float32 b2Dot(const b2Vec2& a, const b2Vec2& b)
		public static function b2Dot2 (a:b2Vec2, b:b2Vec2):Number
		{
			return a.x * b.x + a.y * b.y;
		}

		/// Perform the cross product on two vectors. In 2D this produces a scalar.
		//inline float32 b2Math.b2Cross2(const b2Vec2& a, const b2Vec2& b)
		public static function b2Cross2 (a:b2Vec2, b:b2Vec2):Number
		{
			return a.x * b.y - a.y * b.x;
		}

		/// Perform the cross product on a vector and a scalar. In 2D this produces
		/// a vector.
		//inline b2Vec2 b2Math.b2Cross2(const b2Vec2& a, float32 s)
		public static function b2Cross_Vector2AndScalar (a:b2Vec2, s:Number):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (s * a.y, -s * a.x);
		}

		public static function b2Cross_Vector2AndScalar_Output (a:b2Vec2, s:Number, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (s * a.y, -s * a.x);

			output.x = s * a.y;
			output.y = -s * a.x;
		}

		/// Perform the cross product on a scalar and a vector. In 2D this produces
		/// a vector.
		//inline b2Vec2 b2Math.b2Cross2(float32 s, const b2Vec2& a)
		public static function b2Cross_ScalarAndVector2 (s:Number, a:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (-s * a.y, s * a.x);
		}

		public static function b2Cross_ScalarAndVector2_Output (s:Number, a:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (-s * a.y, s * a.x);

			output.x = -s * a.y;
			output.y = s * a.x;
		}

		/// Multiply a matrix times a vector. If a rotation matrix is provided,
		/// then this transforms the vector from one frame to another.
		//inline b2Vec2 b2Mul(const b2Mat22& A, const b2Vec2& v)
		public static function b2Mul_Matrix22AndVector2 (A:b2Mat22, v:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (A.col1.x * v.x + A.col2.x * v.y, A.col1.y * v.x + A.col2.y * v.y);
		}

		public static function b2Mul_Matrix22AndVector2_Output (A:b2Mat22, v:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (A.col1.x * v.x + A.col2.x * v.y, A.col1.y * v.x + A.col2.y * v.y);

			output.x = A.col1.x * v.x + A.col2.x * v.y;
			output.y = A.col1.y * v.x + A.col2.y * v.y;
		}

		/// Multiply a matrix transpose times a vector. If a rotation matrix is provided,
		/// then this transforms the vector from one frame to another (inverse transform).
		//inline b2Vec2 b2MulT(const b2Mat22& A, const b2Vec2& v)
		public static function b2MulT_Matrix22AndVector2 (A:b2Mat22, v:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (v.x * A.col1.x + v.y * A.col1.y, v.x * A.col2.x + v.y * A.col2.y);
		}

		public static function b2MulT_Matrix22AndVector2_Output (A:b2Mat22, v:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (v.x * A.col1.x + v.y * A.col1.y, v.x * A.col2.x + v.y * A.col2.y);

			output.x = v.x * A.col1.x + v.y * A.col1.y;
			output.y = v.x * A.col2.x + v.y * A.col2.y;
		}

		// this function doesn't exist in the c++ version
		public static function b2MulT_Matrix22AndTwoNumbers (A:b2Mat22, vx:Number, vy:Number):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (vx * A.col1.x + vy * A.col1.y, vx * A.col2.x + vy * A.col2.y);
		}

		public static function b2MulT_Matrix22AndTwoNumbers_Output (A:b2Mat22, vx:Number, vy:Number, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (vx * A.col1.x + vy * A.col1.y, vx * A.col2.x + vy * A.col2.y);

			output.x = vx * A.col1.x + vy * A.col1.y;
			output.y = vx * A.col2.x + vy * A.col2.y;
		}

		/// Add two vectors component-wise.
		//inline b2Vec2 operator + (const b2Vec2& a, const b2Vec2& b)
		//{
		//	return b2Vec2(a.x + b.x, a.y + b.y);
		//}
		public static function b2Add_Vector2 (a:b2Vec2, b:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (a.x + b.x, a.y + b.y);
		}

		public static function b2Add_Vector2_Output (a:b2Vec2, b:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (a.x + b.x, a.y + b.y);

			output.x = a.x + b.x;
			output.y = a.y + b.y;
		}

		/// Subtract two vectors component-wise.
		//inline b2Vec2 operator - (const b2Vec2& a, const b2Vec2& b)
		//{
		//	return b2Vec2(a.x - b.x, a.y - b.y);
		//}
		public static function b2Subtract_Vector2 (a:b2Vec2, b:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (a.x - b.x, a.y - b.y);
		}

		public static function b2Subtract_Vector2_Output (a:b2Vec2, b:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (a.x - b.x, a.y - b.y);

			output.x = a.x - b.x;
			output.y = a.y - b.y;
		}

		//inline b2Vec2 operator * (float32 s, const b2Vec2& a)
		//{
		//	return b2Vec2(s * a.x, s * a.y);
		//}
		public static function b2Mul_ScalarAndVector2 (s:Number, a:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (s * a.x, s * a.y);
		}

		public static function b2Mul_ScalarAndVector2_Output (s:Number, a:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (s * a.x, s * a.y);

			output.x = s * a.x;
			output.y = s * a.y;
		}

		//inline bool operator == (const b2Vec2& a, const b2Vec2& b)
		//{
		//	return a.x == b.x && a.y == b.y;
		//}

		public static function b2Distance2 (a:b2Vec2, b:b2Vec2):Number
		{
			var c:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (a.x - b.x, a.y - b.y);
			return c.Length();
		}

		public static function b2DistanceSquared(a:b2Vec2, b:b2Vec2):Number
		{
			var c:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (a.x - b.x, a.y - b.y);
			return b2Math.b2Dot2 (c, c);
		}

		//inline b2Vec3 operator * (float32 s, const b2Vec3& a)
		//{
		//	return b2Vec3(s * a.x, s * a.y, s * a.z);
		//}
		public static function b2Mul_ScalarAndVector3 (s:Number, a:b2Vec3):b2Vec3
		{
			return b2Vec3.b2Vec3_From3Numbers (s * a.x, s * a.y, s * a.z);
		}

		public static function b2Mul_ScalarAndVector3_Output (s:Number, a:b2Vec3, output:b2Vec3):void
		{
			//return b2Vec3.b2Vec3_From3Numbers (s * a.x, s * a.y, s * a.z);

			output.x = s * a.x;
			output.y = s * a.y;
			output.z = s * a.z;
		}

		/// Add two vectors component-wise.
		//inline b2Vec3 operator + (const b2Vec3& a, const b2Vec3& b)
		//{
		//	return b2Vec3(a.x + b.x, a.y + b.y, a.z + b.z);
		//}
		public static function b2Add_Vector3 (a:b2Vec3, b:b2Vec3):b2Vec3
		{
			return b2Vec3.b2Vec3_From3Numbers (a.x + b.x, a.y + b.y, a.z + b.z);
		}

		public static function b2Add_Vector3_Output (a:b2Vec3, b:b2Vec3, output:b2Vec3):void
		{
			//return b2Vec3.b2Vec3_From3Numbers (a.x + b.x, a.y + b.y, a.z + b.z);

			output.x = a.x + b.x;
			output.y = a.y + b.y;
			output.z = a.z + b.z;
		}

		/// Subtract two vectors component-wise.
		//inline b2Vec3 operator - (const b2Vec3& a, const b2Vec3& b)
		//{
		//	return b2Vec3(a.x - b.x, a.y - b.y, a.z - b.z);
		//}
		public static function b2Subtract_Vector3 (a:b2Vec3, b:b2Vec3):b2Vec3
		{
			return b2Vec3.b2Vec3_From3Numbers (a.x - b.x, a.y - b.y, a.z - b.z);
		}

		public static function b2Subtract_Vector3_Output (a:b2Vec3, b:b2Vec3, output:b2Vec3):void
		{
			//return b2Vec3.b2Vec3_From3Numbers (a.x - b.x, a.y - b.y, a.z - b.z);

			output.x = a.x - b.x;
			output.y = a.y - b.y;
			output.z = a.z - b.z;
		}

		/// Perform the dot product on two vectors.
		//inline float32 b2Dot(const b2Vec3& a, const b2Vec3& b)
		public static function b2Dot3(a:b2Vec3, b:b2Vec3):Number
		{
			return a.x * b.x + a.y * b.y + a.z * b.z;
		}

		/// Perform the cross product on two vectors.
		//inline b2Vec3 b2Math.b2Cross2(const b2Vec3& a, const b2Vec3& b)
		public static function b2Cross3 (a:b2Vec3, b:b2Vec3):b2Vec3
		{
			return b2Vec3.b2Vec3_From3Numbers (a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
		}

		//inline b2Mat22 operator + (const b2Mat22& A, const b2Mat22& B)
		//{
		//	return b2Mat22(A.col1 + B.col1, A.col2 + B.col2);
		//}
		public static function b2Add_Matrix22 (A:b2Mat22, B:b2Mat22):b2Mat22
		{
			return b2Mat22.b2Mat22_From4Numbers (A.col1.x + B.col1.x, A.col2.x + B.col2.x,
												 A.col1.y + B.col1.y, A.col2.y + B.col2.y
												 );
		}

		public static function b2Add_Matrix22_Output (A:b2Mat22, B:b2Mat22, output:b2Mat22):void
		{
			//return b2Mat22.b2Mat22_From4Numbers (A.col1.x + B.col1.x, A.col2.x + B.col2.x,
			//									 A.col1.y + B.col1.y, A.col2.y + B.col2.y
			//									 );

			output.col1.x = A.col1.x + B.col1.x; output.col2.x = A.col2.x + B.col2.x;
			output.col1.y = A.col1.y + B.col1.y; output.col2.x = A.col2.y + B.col2.y;
		}


		// A * B
		//inline b2Mat22 b2Mul(const b2Mat22& A, const b2Mat22& B)
		public static function b2Mul_Matrix22AndMatrix22(A:b2Mat22, B:b2Mat22):b2Mat22
		{
			//return b2Mat22(b2Mul(A, B.col1), b2Mul(A, B.col2));

			return b2Mat22.b2Mat22_From4Numbers (A.col1.x * B.col1.x + A.col2.x * B.col1.y, A.col1.x * B.col2.x + A.col2.x * B.col2.y,
												 A.col1.y * B.col1.x + A.col2.y * B.col1.y, A.col1.y * B.col2.x + A.col2.y * B.col2.y
												 );
		}

		public static function b2Mul_Matrix22AndMatrix22_Output (A:b2Mat22, B:b2Mat22, output:b2Mat22):void
		{
			//return b2Mat22(b2Mul(A, B.col1), b2Mul(A, B.col2));

			//return b2Mat22.b2Mat22_From4Numbers (A.col1.x * B.col1.x + A.col2.x * B.col1.y, A.col1.x * B.col2.x + A.col2.x * B.col2.y,
			//									 A.col1.y * B.col1.x + A.col2.y * B.col1.y, A.col1.y * B.col2.x + A.col2.y * B.col2.y
			//									 );

			output.col1.x = A.col1.x * B.col1.x + A.col2.x * B.col1.y; output.col2.x = A.col1.x * B.col2.x + A.col2.x * B.col2.y;
			output.col1.y = A.col1.y * B.col1.x + A.col2.y * B.col1.y; output.col2.y = A.col1.y * B.col2.x + A.col2.y * B.col2.y;
		}

		// A^T * B
		//inline b2Mat22 b2MulT(const b2Mat22& A, const b2Mat22& B)
		public static function b2MulT_Matrix22AndMatrix22(A:b2Mat22, B:b2Mat22):b2Mat22
		{
			//b2Vec2 c1(b2Dot(A.col1, B.col1), b2Math.b2Dot2(A.col2, B.col1));
			//b2Vec2 c2(b2Dot(A.col1, B.col2), b2Math.b2Dot2(A.col2, B.col2));
			//return b2Mat22(c1, c2);

			return b2Mat22.b2Mat22_From4Numbers (A.col1.x * B.col1.x + A.col1.y * B.col1.y, A.col1.x * B.col2.x + A.col1.y * B.col2.y,
												 A.col2.x * B.col1.x + A.col2.y * B.col1.y, A.col2.x * B.col2.x + A.col2.y * B.col2.y
												 );
		}

		public static function b2MulT_Matrix22AndMatrix22_Output (A:b2Mat22, B:b2Mat22, output:b2Mat22):void
		{
			//b2Vec2 c1(b2Dot(A.col1, B.col1), b2Math.b2Dot2(A.col2, B.col1));
			//b2Vec2 c2(b2Dot(A.col1, B.col2), b2Math.b2Dot2(A.col2, B.col2));
			//return b2Mat22(c1, c2);

			//return b2Mat22.b2Mat22_From4Numbers (A.col1.x * B.col1.x + A.col1.y * B.col1.y, A.col1.x * B.col2.x + A.col1.y * B.col2.y,
			//									 A.col2.x * B.col1.x + A.col2.y * B.col1.y, A.col2.x * B.col2.x + A.col2.y * B.col2.y
			//									 );

			output.col1.x = A.col1.x * B.col1.x + A.col1.y * B.col1.y; output.col2.x = A.col1.x * B.col2.x + A.col1.y * B.col2.y;
			output.col1.y = A.col2.x * B.col1.x + A.col2.y * B.col1.y; output.col2.y = A.col2.x * B.col2.x + A.col2.y * B.col2.y;
		}

		/// Multiply a matrix times a vector.
		//inline b2Vec3 b2Mul (const b2Mat33& A, const b2Vec3& v)
		public static function b2Mul_Matrix33AndVector3 (A:b2Mat33, v:b2Vec3):b2Vec3
		{
			//return v.x * A.col1 + v.y * A.col2 + v.z * A.col3;

			var col1:b2Vec3 = A.col1;
			var col2:b2Vec3 = A.col2;
			var col3:b2Vec3 = A.col3;
			return b2Vec3.b2Vec3_From3Numbers (v.x * col1.x + v.y * col2.x + v.z * col3.x,
											   v.x * col1.y + v.y * col2.y + v.z * col3.y,
											   v.x * col1.z + v.y * col2.z + v.z * col3.z
											   );
		}

		public static function b2Mul_Matrix33AndVector3_Output (A:b2Mat33, v:b2Vec3, output:b2Vec3):void
		{
			//return v.x * A.col1 + v.y * A.col2 + v.z * A.col3;

			var col1:b2Vec3 = A.col1;
			var col2:b2Vec3 = A.col2;
			var col3:b2Vec3 = A.col3;
			//return b2Vec3.b2Vec3_From3Numbers (v.x * col1.x + v.y * col2.x + v.z * col3.x,
			//								   v.x * col1.y + v.y * col2.y + v.z * col3.y,
			//								   v.x * col1.z + v.y * col2.z + v.z * col3.z
			//								   );

			output.x = v.x * col1.x + v.y * col2.x + v.z * col3.x;
			output.y = v.x * col1.y + v.y * col2.y + v.z * col3.y;
			output.z = v.x * col1.z + v.y * col2.z + v.z * col3.z;
		}

		//inline b2Vec2 b2Mul_TransformAndVector2(const b2Transform& T, const b2Vec2& v)
		public static function b2Mul_TransformAndVector2(T:b2Transform, v:b2Vec2):b2Vec2
		{
			var col1:b2Vec2 = T.R.col1;
			var col2:b2Vec2 = T.R.col2;
			return b2Vec2.b2Vec2_From2Numbers (T.position.x + col1.x * v.x + col2.x * v.y, T.position.y + col1.y * v.x + col2.y * v.y);
		}

		public static function b2Mul_TransformAndVector2_Output(T:b2Transform, v:b2Vec2, output:b2Vec2):void
		{
			var col1:b2Vec2 = T.R.col1;
			var col2:b2Vec2 = T.R.col2;
			output.x = T.position.x + col1.x * v.x + col2.x * v.y;
			output.y = T.position.y + col1.y * v.x + col2.y * v.y;
		}

		//inline b2Vec2 b2MulT_TransformAndVector2 (const b2Transform& T, const b2Vec2& v)
		public static function b2MulT_TransformAndVector2 (T:b2Transform, v:b2Vec2):b2Vec2
		{
			//return b2MulT(T.R, v - T.position);

			//return b2MulTrans_Matrix2AndTwoNumbers (T.R, v.x - T.position.x, v.y - T.position.y);

			var vx:Number = v.x - T.position.x;
			var vy:Number = v.y - T.position.y;
			var col1:b2Vec2 = T.R.col1;
			var col2:b2Vec2 = T.R.col2;

			return b2Vec2.b2Vec2_From2Numbers (vx * col1.x + vy * col1.y, vx * col2.x + vy * col2.y);
		}

		public static function b2MulT_TransformAndVector2_Output (T:b2Transform, v:b2Vec2, output:b2Vec2):void
		{
			//return b2MulT(T.R, v - T.position);

			//return b2MulTrans_Matrix2AndTwoNumbers (T.R, v.x - T.position.x, v.y - T.position.y);

			var vx:Number = v.x - T.position.x;
			var vy:Number = v.y - T.position.y;
			var col1:b2Vec2 = T.R.col1;
			var col2:b2Vec2 = T.R.col2;

			output.x = vx * col1.x + vy * col1.y;
			output.y = vx * col2.x + vy * col2.y;
		}

		// v2 = A.R' * (B.R * v1 + B.p - A.p) = (A.R' * B.R) * v1 + (B.p - A.p)
		//inline b2Transform b2MulT(const b2Transform& A, const b2Transform& B)
		public static function b2MulT_TransformAndTransform (A:b2Transform, B:b2Transform):b2Transform
		{
			//b2Transform C;
			//C.R = b2MulT(A.R, B.R);
			//C.position = B.position - A.position;

			var C:b2Transform = new b2Transform ();
			b2MulT_Matrix22AndMatrix22_Output(A.R, B.R, C.R);
			C.position.x = B.position.x - A.position.x;
			C.position.y = B.position.y - A.position.y;
			return C;
		}

		public static function b2MulT_TransformAndTransform_Output (A:b2Transform, B:b2Transform, C:b2Transform):void
		{
			//b2Transform C;
			//C.R = b2MulT(A.R, B.R);
			//C.position = B.position - A.position;

			b2MulT_Matrix22AndMatrix22_Output(A.R, B.R, C.R);
			C.position.x = B.position.x - A.position.x;
			C.position.y = B.position.y - A.position.y;
		}

		//inline b2Vec2 b2Abs(const b2Vec2& a)
		public static function b2Abs_Vector2 (a:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (Math.abs (a.x), Math.abs(a.y));
		}

		public static function b2Abs_Vector2_Output (a:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (Math.abs (a.x), Math.abs(a.y));

			output.x = Math.abs (a.x);
			output.y = Math.abs (a.y);
		}

		public static function b2Abs_Vector2_Self (a:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (Math.abs (a.x), Math.abs(a.y));

			a.x = Math.abs (a.x);
			a.y = Math.abs (a.y);
		}

		//inline b2Mat22 b2Abs(const b2Mat22& A)
		public static function b2Abs_Matrix22 (A:b2Mat22):b2Mat22
		{
			//return b2Mat22(b2Abs(A.col1), b2Abs(A.col2));
			return b2Mat22.b2Mat22_From4Numbers (Math.abs (A.col1.x), Math.abs (A.col2.x),
												 Math.abs (A.col1.y), Math.abs (A.col2.y)
												 );
		}

		public static function b2Abs_Matrix22_Output (A:b2Mat22, output:b2Mat22):void
		{
			//return b2Mat22(b2Abs(A.col1), b2Abs(A.col2));
			//return b2Mat22.b2Mat22_From4Numbers (Math.abs (A.col1.x), Math.abs (A.col2.x),
			//									 Math.abs (A.col1.y), Math.abs (A.col2.y)
			//									 );

			output.col1.x = Math.abs (A.col1.x); output.col2.x = Math.abs (A.col2.x);
			output.col1.y = Math.abs (A.col1.y); output.col2.y = Math.abs (A.col2.y);
		}

		public static function b2Abs_Matrix22_Self (A:b2Mat22):void
		{
			//return b2Mat22(b2Abs(A.col1), b2Abs(A.col2));
			//return b2Mat22.b2Mat22_From4Numbers (Math.abs (A.col1.x), Math.abs (A.col2.x),
			//									 Math.abs (A.col1.y), Math.abs (A.col2.y)
			//									 );

			A.col1.x = Math.abs (A.col1.x); A.col2.x = Math.abs (A.col2.x);
			A.col1.y = Math.abs (A.col1.y); A.col2.y = Math.abs (A.col2.y);
		}

		//template <typename T>
		//inline T b2Min(T a, T b)
		//{
		//	return a < b ? a : b;
		//}
		public static function b2Min_int (a:int, b:int):int
		{
			return a < b ? a : b;
		}

		public static function b2Min_Number (a:Number, b:Number):Number
		{
			return a < b ? a : b;
		}

		//inline b2Vec2 b2Min(const b2Vec2& a, const b2Vec2& b)
		//{
		//	return b2Vec2(b2Min(a.x, b.x), b2Min(a.y, b.y));
		//}

		public static function b2Min_Vector2 (a:b2Vec2, b:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (a.x < b.x ? a.x : b.x, a.y < b.y ? a.y : b.y);
		}

		public static function b2Min_Vector2_Output (a:b2Vec2, b:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (a.x < b.x ? a.x : b.x, a.y < b.y ? a.y : b.y);

			output.x = a.x < b.x ? a.x : b.x;
			output.y = a.y < b.y ? a.y : b.y;
		}

		//template <typename T>
		//inline T b2Max(T a, T b)
		//{
		//	return a > b ? a : b;
		//}
		public static function b2Max_int (a:int, b:int):int
		{
			return a > b ? a : b;
		}

		public static function b2Max_Number (a:Number, b:Number):Number
		{
			return a > b ? a : b;
		}


		//inline b2Vec2 b2Max(const b2Vec2& a, const b2Vec2& b)
		//{
		//	return b2Vec2(b2Max(a.x, b.x), b2Max(a.y, b.y));
		//}
		public static function b2Max_Vector2 (a:b2Vec2, b:b2Vec2):b2Vec2
		{
			return b2Vec2.b2Vec2_From2Numbers (a.x > b.x ? a.x : b.x, a.y > b.y ? a.y : b.y);
		}

		public static function b2Max_Vector2_Output (a:b2Vec2, b:b2Vec2, output:b2Vec2):void
		{
			//return b2Vec2.b2Vec2_From2Numbers (a.x > b.x ? a.x : b.x, a.y > b.y ? a.y : b.y);

			output.x = a.x > b.x ? a.x : b.x;
			output.y = a.y > b.y ? a.y : b.y;
		}


		//template <typename T>
		//inline T b2Clamp(T a, T low, T high)
		//{
		//	return b2Max(low, b2Min(a, high));
		//}
		public static function b2Clamp_int (a:int, low:int, high:int):int
		{
			var temp:int = a < high ? a : high;

			return low > temp ? low : temp;
		}

		public static function b2Clamp_Number (a:Number, low:Number, high:Number):Number
		{
			var temp:Number = a < high ? a : high;

			return low > temp ? low : temp;
		}


		//inline b2Vec2 b2Clamp(const b2Vec2& a, const b2Vec2& low, const b2Vec2& high)
		//{
		//	return b2Max(low, b2Min(a, high));
		//}
		public static function b2Clamp_Vector2 (a:b2Vec2, low:b2Vec2, high:b2Vec2):b2Vec2
		{
			var temp_x:Number = a.x < high.x ? a.x : high.x;
			var temp_y:Number = a.y < high.y ? a.y : high.y;

			return b2Vec2.b2Vec2_From2Numbers (low.x > temp_x ? low.x : temp_x, low.y > temp_y ? low.y : temp_y);
		}

		public static function b2Clamp_Vector2_Output (a:b2Vec2, low:b2Vec2, high:b2Vec2, output:b2Vec2):void
		{
			var temp_x:Number = a.x < high.x ? a.x : high.x;
			var temp_y:Number = a.y < high.y ? a.y : high.y;

			output.x = low.x > temp_x ? low.x : temp_x
			output.y = low.y > temp_y ? low.y : temp_y;
		}

		//template<typename T> inline void b2Swap(T& a, T& b)
		//{
		//	T tmp = a;
		//	a = b;
		//	b = tmp;
		//}

		/// "Next Largest Power of 2
		/// Given a binary integer value x, the next largest power of 2 can be computed by a SWAR algorithm
		/// that recursively "folds" the upper bits into the lower bits. This process yields a bit vector with
		/// the same most significant 1 as x, but all 1's below it. Adding 1 to that value yields the next
		/// largest power of 2. For a 32-bit value:"
		public static function b2NextPowerOfTwo(x:uint):uint
		{
			x |= (x >> 1);
			x |= (x >> 2);
			x |= (x >> 4);
			x |= (x >> 8);
			x |= (x >> 16);
			return x + 1;
		}

		public static function b2IsPowerOfTwo(x:uint):Boolean
		{
			var result:Boolean = x > 0 && (x & (x - 1)) == 0;
			return result;
		}

		//inline void b2Sweep::GetTransform(b2Transform* xf, float32 alpha) const
		//{
			//@see class b2Sweep
		//}

		//inline void b2Sweep::Advance(float32 t)
		//{
			//@see class b2Sweep
		//}

	} // class
} // package
//#endif
