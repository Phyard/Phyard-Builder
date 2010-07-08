
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

	} // class
} // package
