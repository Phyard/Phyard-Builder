/*
* Copyright (c) 2006-2009 Erin Catto http://www.gphysics.com
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

//#ifndef B2_COLLISION_H
//#define B2_COLLISION_H

package Box2D.Collision
{

	//#include <Box2D/Common/b2Math.h>
	//#include <climits>
	
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Transform;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;

	/// @file
	/// Structures and functions used for computing contact points, distance
	/// queries, and TOI queries.

	//class b2Shape;
	//class b2CircleShape;
	//class b2PolygonShape;

	// moved to b2ContactID
	//const uint8 b2_nullFeature = UCHAR_MAX;
	
	public class b2Collision
	{
		include "b2Collision.cpp";
		include "b2CollideCircle.cpp";
		include "b2CollidePolygon.cpp";
		
		/// Contact ids to facilitate warm starting.
		//union b2ContactID
		//{
			//@see b2ContactID.as
		//};

		/// A manifold point is a contact point belonging to a contact
		/// manifold. It holds details related to the geometry and dynamics
		/// of the contact points.
		/// The local point usage depends on the manifold type:
		/// -e_circles: the local center of circleB
		/// -e_faceA: the local center of cirlceB or the clip point of polygonB
		/// -e_faceB: the clip point of polygonA
		/// This structure is stored across time steps, so we keep it small.
		/// Note: the impulses are used for internal caching and may not
		/// provide reliable contact forces, especially for high speed collisions.
		//struct b2ManifoldPoint
		//{
			//@see b2ManifoldPoint.as
		//};

		/// A manifold for two touching convex shapes.
		/// Box2D supports multiple types of contact:
		/// - clip point versus plane with radius
		/// - point versus point with radius (circles)
		/// The local point usage depends on the manifold type:
		/// -e_circles: the local center of circleA
		/// -e_faceA: the center of faceA
		/// -e_faceB: the center of faceB
		/// Similarly the local normal usage:
		/// -e_circles: not used
		/// -e_faceA: the normal on polygonA
		/// -e_faceB: the normal on polygonB
		/// We store contacts in this way so that position correction can
		/// account for movement, which is critical for continuous physics.
		/// All contact scenarios must be expressed in one of these types.
		/// This structure is stored across time steps, so we keep it small.
		//struct b2Manifold
		//{
			//@see b2Manifold.as
		//};

		/// This is used to compute the current state of a contact manifold.
		//struct b2WorldManifold
		//{
			//@see b2WorldManifold.as
		//};

		/// This is used for determining the state of contact points.
		//enum b2PointState
		//{
			public static const b2_nullState:int = 0;		///< point does not exist
			public static const b2_addState:int = 1;		///< point was added in the update
			public static const b2_persistState:int = 2;	///< point persisted across the update
			public static const b2_removeState:int = 3;		///< point was removed in the update
		//};

		/// Compute the point states given two manifolds. The states pertain to the transition from manifold1
		/// to manifold2. So state1 is either persist or remove while state2 is either add or persist.
		//void b2GetPointStates(b2PointState state1[b2_maxManifoldPoints], b2PointState state2[b2_maxManifoldPoints],
		//					  const b2Manifold* manifold1, const b2Manifold* manifold2);

		/// Used for computing contact manifolds.
		//struct b2ClipVertex
		//{
			//@see b2ClipVertex.as
		//};

		/// Ray-cast input data.
		//struct b2RayCastInput
		//{
			//@see b2RayCastInput.as
		//};

		/// Ray-cast output data.
		//struct b2RayCastOutput
		//{
			//@see b2RayCastOutput.as
		//};

		/// An axis aligned bounding box.
		//struct b2AABB
		//{
			//@see b2AABB.as
		//};

		/// Compute the collision manifold between two circles.
		//void b2CollideCircles(b2Manifold* manifold,
		//					  const b2CircleShape* circle1, const b2Transform& xf1,
		//					  const b2CircleShape* circle2, const b2Transform& xf2);

		/// Compute the collision manifold between a polygon and a circle.
		//void b2CollidePolygonAndCircle(b2Manifold* manifold,
		//							   const b2PolygonShape* polygon, const b2Transform& xf1,
		//							   const b2CircleShape* circle, const b2Transform& xf2);

		/// Compute the collision manifold between two polygons.
		//void b2CollidePolygons(b2Manifold* manifold,
		//					   const b2PolygonShape* polygon1, const b2Transform& xf1,
		//					   const b2PolygonShape* polygon2, const b2Transform& xf2);

		/// Clipping for contact manifolds.
		//int32 b2ClipSegmentToLine(b2ClipVertex vOut[2], const b2ClipVertex vIn[2],
		//							const b2Vec2& normal, float32 offset);
		//

		/// Determine if two generic shapes overlap.
		//bool b2TestOverlap(const b2Shape* shapeA, const b2Shape* shapeB,
		//					const b2Transform& xfA, const b2Transform& xfB);

		// ---------------- Inline Functions ------------------------------------------

		//moved to b2AABB.as
		//inline bool b2AABB::IsValid() const
		//{
		//	b2Vec2 d = upperBound - lowerBound;
		//	bool valid = d.x >= 0.0f && d.y >= 0.0f;
		//	valid = valid && lowerBound.IsValid() && upperBound.IsValid();
		//	return valid;
		//}

		public static function b2TestOverlap(a:b2AABB, b:b2AABB):Boolean
		{
			//b2Vec2 d1, d2;
			//d1 = b.lowerBound - a.upperBound;
			//d2 = a.lowerBound - b.upperBound;

			//if (d1.x > 0.0f || d1.y > 0.0f)
			//	return false;

			//if (d2.x > 0.0f || d2.y > 0.0f)
			//	return false;

			var d1x:Number = b.lowerBound.x - a.upperBound.x;
			var d1y:Number = b.lowerBound.y - a.upperBound.y;
			var d2x:Number = a.lowerBound.x - b.upperBound.x;
			var d2y:Number = a.lowerBound.y - b.upperBound.y;

			if (d1x > 0.0 || d1y > 0.0)
				return false;

			if (d2x > 0.0 || d2y > 0.0)
				return false;

			return true;
		}
	} // class
} // package
//#endif
