
package Box2D.Common
{
	/// A transform contains translation and rotation. It is used to represent
	/// the position and orientation of rigid frames.
	//struct b2Transform
	public class b2Transform
	{
		// this function doesn't exist in the c++ version
		public function Clone ():b2Transform
		{
			var t:b2Transform = new b2Transform ();
			t.CopyFrom (this);
			
			return t;
		}
		
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2Transform):void
		{
			position.CopyFrom (another.position);
			R.CopyFrom (another.R);
		}
		
		/// The default constructor does nothing (for performance).
		public function b2Transform() {}

		/// Initialize using a position vector and a rotation matrix.
		public static function b2Transform_FromTranslateAndRotationMatrix(position_:b2Vec2, R_:b2Mat22):b2Transform
		{
			var transform:b2Transform = new b2Transform ();
			transform.position.CopyFrom (position_);
			transform.R.SetFromMatrix (R_)
			
			return transform;
		}

		/// Set this to the identity transform.
		public function SetIdentity():void
		{
			position.SetZero();
			R.SetIdentity();
		}

		/// Set this based on the position and angle.
		public function Set(p:b2Vec2, angle:Number):void
		{
			position.CopyFrom (p);
			R.SetFromAngle(angle);
		}

		/// Calculate the angle that the rotation matrix represents.
		public function GetAngle():Number
		{
			//return b2Math.b2Atan2(R.col1.y, R.col1.x);
			return Math.atan2 (R.col1.y, R.col1.x);
		}

		public var position:b2Vec2 = new b2Vec2 ();
		public var R:b2Mat22 = new b2Mat22 ();
		
	} // class
} // package
