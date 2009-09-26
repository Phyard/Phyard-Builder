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
	import Box2D.Dynamics.b2ContactManager;

	//struct b2Pair
	//{
		//@see b2Pair.as
	//};

	/// The broad-phase is used for computing pairs and performing volume queries and ray casts.
	/// This broad-phase does not persist pairs. Instead, this reports potentially new pairs.
	/// It is up to the client to consume the new pairs and to track subsequent overlap.
	public class b2BroadPhase implements b2QueryCallbackOwner
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

		private var m_tree:b2DynamicTree = new b2DynamicTree ();

		private var m_proxyCount:int;

		//int32* m_moveBuffer;
		private var m_moveBuffer:Array;
		private var m_moveCapacity:int;
		private var m_moveCount:int;

		//b2Pair* m_pairBuffer;
		private var m_pairBuffer:Array;
		private var m_pairCapacity:int;
		private var m_pairCount:int;

		private var m_queryProxyId:int;

	//incline

		/// This is used to sort pairs.
		//inline bool b2PairLessThan(const b2Pair& pair1, const b2Pair& pair2)
		public static function b2PairLessThan(pair1:b2Pair, pair2:b2Pair):int
		{
			//if (pair1.proxyIdA < pair2.proxyIdA)
			//{
			//	return true;
			//}
			//
			//if (pair1.proxyIdA == pair2.proxyIdA)
			//{
			//	return pair1.proxyIdB < pair2.proxyIdB;
			//}
			//
			//return false;

			if (pair1.proxyIdA < pair2.proxyIdA)
			{
				return -1;
			}

			if (pair1.proxyIdA == pair2.proxyIdA)
			{
				return pair1.proxyIdB < pair2.proxyIdB ? -1 : 1;
			}

			return 1;
		}

		public function GetUserData(proxyId:int):Object
		{
			return m_tree.GetUserData(proxyId);
		}

		public function TestOverlap(proxyIdA:int, proxyIdB:int):Boolean
		{
			var aabbA:b2AABB = m_tree.GetFatAABB(proxyIdA);
			var aabbB:b2AABB = m_tree.GetFatAABB(proxyIdB);
			return b2Collision.b2TestOverlap(aabbA, aabbB);
		}

		//inline const b2AABB& b2BroadPhase::GetFatAABB(int32 proxyId) const
		public function GetFatAABB(proxyId:int):b2AABB
		{
			return m_tree.GetFatAABB(proxyId);
		}

		public function GetProxyCount():int
		{
			return m_proxyCount;
		}

		public function ComputeHeight():int
		{
			//return m_tree.ComputeHeight();
			return m_tree.ComputeTreeHeight ();
		}

		//template <typename T>
		//void b2BroadPhase::UpdatePairs(T* callback)
		public function UpdatePairs(callback:b2ContactManager):void
		{
			var i:int = 0;

			// Reset pair buffer
			m_pairCount = 0;
			m_pairBuffer = new Array (); // !!! different with c++ version

			// Perform tree queries for all moving proxies.
			for (i = 0; i < m_moveCount; ++i)
			{
				m_queryProxyId = m_moveBuffer[i];
				if (m_queryProxyId == e_nullProxy)
				{
					continue;
				}

				// We have to query the tree with the fat AABB so that
				// we don't fail to create a pair that may touch later.
				//const b2AABB& fatAABB = m_tree.GetFatAABB(m_queryProxyId);
				var fatAABB:b2AABB = m_tree.GetFatAABB(m_queryProxyId);

				// Query tree, create pairs and add them pair buffer.
				m_tree.Query(this, fatAABB);
			}

			// Reset move buffer
			m_moveCount = 0;

			// Sort the pair buffer to expose duplicates.
			//std::sort(m_pairBuffer, m_pairBuffer + m_pairCount, b2PairLessThan);
			m_pairBuffer.sort (b2PairLessThan);
			
			// Send the pairs back to the client.
			i = 0;
			while (i < m_pairCount)
			{
				//b2Pair* primaryPair = m_pairBuffer + i;
				var primaryPair:b2Pair = m_pairBuffer [i];
				var userDataA:Object = m_tree.GetUserData(primaryPair.proxyIdA);
				var userDataB:Object = m_tree.GetUserData(primaryPair.proxyIdB);

				callback.AddPair(userDataA, userDataB);
				++i;

				// Skip any duplicate pairs.
				while (i < m_pairCount)
				{
					//b2Pair* pair = m_pairBuffer + i;
					var pair:b2Pair = m_pairBuffer [i];
					if (pair.proxyIdA != primaryPair.proxyIdA || pair.proxyIdB != primaryPair.proxyIdB)
					{
						break;
					}
					++i;
				}
			}
		}

		//template <typename T>
		//inline void b2BroadPhase::Query(T* callback, const b2AABB& aabb) const
		//@notice: best to add a new class QueryCallback
		public function Query(callback:b2QueryCallbackOwner, aabb:b2AABB):void
		{
			m_tree.Query(callback, aabb);
		}

		//template <typename T>
		//inline void b2BroadPhase::RayCast(T* callback, const b2RayCastInput& input) const
		public function RayCast(callback:b2RayCastCallbackOwner, input:b2RayCastInput):void
		{
			m_tree.RayCast(callback, input);
		}
	} // class
} // package
//#endif
