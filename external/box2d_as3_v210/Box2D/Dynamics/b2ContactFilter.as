
package Box2D.Dynamics
{
	/// Implement this class to provide collision filtering. In other words, you can implement
	/// this class if you want finer control over contact creation.
	public class b2ContactFilter
	{
		/// Return true if contact calculations should be performed between these two shapes.
		/// @warning for performance reasons this is only called when the AABBs begin to overlap.
		public function ShouldCollide(fixtureA:b2Fixture, fixtureB:b2Fixture):Boolean
		{
			var filterA:b2Filter = fixtureA.GetFilterData();
			var filterB:b2Filter = fixtureB.GetFilterData();

			if (filterA.groupIndex == filterB.groupIndex && filterA.groupIndex != 0)
			{
				return filterA.groupIndex > 0;
			}

			var collide:Boolean = (filterA.maskBits & filterB.categoryBits) != 0 && (filterA.categoryBits & filterB.maskBits) != 0;
			return collide;
		}

		/// Return true if the given shape should be considered for ray intersection
		public function RayCollide(userData:Object, fixture:b2Fixture):Boolean
		{
			// By default, cast userData as a fixture, and then collide if the shapes would collide
			if (userData == null)
			{
				return true;
			}

			return ShouldCollide(userData as b2Fixture,fixture);
		}
		
	} // class
} // package
