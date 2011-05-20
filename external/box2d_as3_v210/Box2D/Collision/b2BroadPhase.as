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

//#ifndef B2_BROAD_PHASE_H
//#define B2_BROAD_PHASE_H

package Box2D.Collision
{

	//#include <Box2D/Common/b2Settings.h>
	//#include <Box2D/Collision/b2Collision.h>
	//#include <Box2D/Collision/b2DynamicTree.h>
	//#include <algorithm>
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;

	//struct b2Pair
	//{
		//@see b2Pair.as
	//};

	/// The broad-phase is used for computing pairs and performing volume queries and ray casts.
	/// This broad-phase does not persist pairs. Instead, this reports potentially new pairs.
	/// It is up to the client to consume the new pairs and to track subsequent overlap.
	public class b2BroadPhase // implements b2QueryCallbackOwner
	{
		include "b2BroadPhase.cpp"

	//public:

		//enum
		//{
			public static const e_nullProxy:int = -1;
		//};

		//b2BroadPhase();
		//~b2BroadPhase();

		/// Create a proxy with an initial AABB. Pairs are not reported until
		/// UpdatePairs is called.
		//int32 CreateProxy(const b2AABB& aabb, void* userData);

		/// Destroy a proxy. It is up to the client to remove any pairs.
		//void DestroyProxy(int32 proxyId);

		/// Call MoveProxy as many times as you like, then when you are done
		/// call UpdatePairs to finalized the proxy pairs (for your time step).
		//void MoveProxy(int32 proxyId, const b2AABB& aabb, const b2Vec2& displacement);

      /// Call to trigger a re-processing of it's pairs on the next call to UpdatePairs.
      //void TouchProxy(int32 proxyId);
   
		/// Get the fat AABB for a proxy.
		//const b2AABB& GetFatAABB(int32 proxyId) const;

		/// Get user data from a proxy. Returns NULL if the id is invalid.
		//void* GetUserData(int32 proxyId);

		/// Test overlap of fat AABBs.
		//bool TestOverlap(int32 proxyIdA, int32 proxyIdB) const;

		/// Get the number of proxies.
		//int32 GetProxyCount() const;

		/// Update the pairs. This results in pair callbacks. This can only add pairs.
		//template <typename T>
		//void UpdatePairs(T* callback);

		/// Query an AABB for overlapping proxies. The callback class
		/// is called for each proxy that overlaps the supplied AABB.
		//template <typename T>
		//void Query(T* callback, const b2AABB& aabb) const;

		/// Ray-cast against the proxies in the tree. This relies on the callback
		/// to perform a exact ray-cast in the case were the proxy contains a shape.
		/// The callback also performs the any collision filtering. This has performance
		/// roughly equal to k * log(n), where k is the number of collisions and n is the
		/// number of proxies in the tree.
		/// @param input the ray-cast input data. The ray extends from p1 to p1 + maxFraction * (p2 - p1).
		/// @param callback a callback class that is called for each proxy that is hit by the ray.
		//template <typename T>
		//void RayCast(T* callback, const b2RayCastInput& input) const;

		/// Compute the height of the embedded tree.
		//int32 ComputeHeight() const;

	//private:

		//friend class b2DynamicTree;

		//void BufferMove(int32 proxyId);
		//void UnBufferMove(int32 proxyId);

		//void QueryCallback(int32 proxyId);

	//incline

		public function GetUserData(proxyId:int):Object
		{
			return null;
		}

		public function TestOverlap(proxyIdA:int, proxyIdB:int):Boolean
		{
			return false;
		}

		//inline const b2AABB& b2BroadPhase::GetFatAABB(int32 proxyId) const
		public function GetFatAABB(proxyId:int):b2AABB
		{
			return null;
		}

		public function GetProxyCount():int
		{
			return 0;
		}

		public function ComputeHeight():int
		{
			return 0;
		}

		//template <typename T>
		//void b2BroadPhase::UpdatePairs(T* callback)
		public function UpdatePairs(callback:b2BroadPhaseMonitor):void
		{
		}

		//template <typename T>
		//inline void b2BroadPhase::Query(T* callback, const b2AABB& aabb) const
		//@notice: best to add a new class QueryCallback
		public function Query(callback:b2QueryCallbackOwner, aabb:b2AABB):void
		{
		}

		//template <typename T>
		//inline void b2BroadPhase::RayCast(T* callback, const b2RayCastInput& input) const
		public function RayCast(callback:b2RayCastCallbackOwner, input:b2RayCastInput):void
		{
		}
	} // class
} // package
//#endif
