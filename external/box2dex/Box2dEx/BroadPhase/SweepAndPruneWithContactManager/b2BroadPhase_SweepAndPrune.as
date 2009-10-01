
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

package Box2dEx.BroadPhase.SweepAndPrune
{
	import Box2D.Common.*;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2BroadPhase;
	import Box2D.Collision.b2BroadPhaseMonitor;
	import Box2D.Collision.b2QueryCallbackOwner;
	import Box2D.Collision.b2RayCastCallbackOwner;
	import Box2D.Collision.b2RayCastInput;

	/*
	This broad phase uses the Sweep and Prune algorithm as described in:
	Collision Detection in Interactive 3D Environments by Gino van den Bergen
	Also, some ideas, such as using integral values for fast compares comes from
	Bullet (http:/www.bulletphysics.com).
	*/

	//#include "../Common/b2Settings.h"
	//#include "b2Collision.h"
	//#include "b2PairManager.h"
	//#include <climits>

	//#ifdef TARGET_FLOAT32_IS_FIXED
	//#define	B2BROADPHASE_MAX	(USHRT_MAX/2)
	//#else
	//#define	B2BROADPHASE_MAX	USHRT_MAX
	//
	//#endif

	//const uint16 b2_invalid = B2BROADPHASE_MAX;
	//const uint16 b2_nullEdge = B2BROADPHASE_MAX;
	//struct b2BoundValues;

	//struct b2Bound
	//{
		//@see b2Bound.as
	//};

	//struct b2Proxy
	//{
		//@see b2Proxy.as
	//};

	//typedef float32 (*SortKeyFunc)(void* shape);

	public class b2BroadPhase_SweepAndPrune extends b2BroadPhase
	{
		include "b2BroadPhase_SweepAndPrune.cpp";
		
		public static const B2BROADPHASE_MAX:int = 0x7FFFFFFF; //0xFFFFFFFF; // USHRT_MAX // 0xffff
		public static const b2_invalid:int = -1;
		public static const b2_nullEdge:int = -1;
		
		public static const b2_maxProxies:int = 512; // to change to a member variable

	//public:
		//b2BroadPhase(const b2AABB& worldAABB, b2PairCallback* callback);
		//~b2BroadPhase();

		// Use this to see if your proxy is in range. If it is not in range,
		// it should be destroyed. Otherwise you may get O(m^2) pairs, where m
		// is the number of proxies that are out of range.
		//bool InRange(const b2AABB& aabb) const;

		// Create and destroy proxies. These call Flush first.
		//uint16 CreateProxy(const b2AABB& aabb, void* userData);
		//void DestroyProxy(int32 proxyId);

		// Call MoveProxy as many times as you like, then when you are done
		// call Commit to finalized the proxy pairs (for your time step).
		//void MoveProxy(int32 proxyId, const b2AABB& aabb);
		//void Commit();

		// Get a single proxy. Returns NULL if the id is invalid.
		//b2Proxy* GetProxy(int32 proxyId);

		// Query an AABB for overlapping proxies, returns the user data and
		// the count, up to the supplied maximum count.
		//int32 Query(const b2AABB& aabb, void** userData, int32 maxCount);

		// Query a segment for overlapping proxies, returns the user data and
		// the count, up to the supplied maximum count.
		// If sortKey is provided, then it is a function mapping from proxy userDatas to distances along the segment (between 0 & 1)
		// Then the returned proxies are sorted on that, before being truncated to maxCount
		// The sortKey of a proxy is assumed to be larger than the closest point inside the proxy along the segment, this allows for early exits
		// Proxies with a negative sortKey are discarded
		//int32 QuerySegment(const b2Segment& segment, void** userData, int32 maxCount, SortKeyFunc sortKey);

		//void Validate();
		//void ValidatePairs();

	//private:
		//void ComputeBounds(uint16* lowerValues, uint16* upperValues, const b2AABB& aabb);

		//bool TestOverlap(b2Proxy* p1, b2Proxy* p2);
		//bool TestOverlap(const b2BoundValues& b, b2Proxy* p);

		//void Query(int32* lowerIndex, int32* upperIndex, uint16 lowerValue, uint16 upperValue,
		//			b2Bound* bounds, int32 boundCount, int32 axis);
		//void IncrementOverlapCount(int32 proxyId);
		//void IncrementTimeStamp();
		//void AddProxyResult(uint16 proxyId, b2Proxy* proxy, int32 maxCount, SortKeyFunc sortKey);

	//public:
		//friend class b2PairManager;

		public var m_pairManager:b2PairManager = new b2PairManager ();

		//b2Proxy m_proxyPool[b2_maxProxies];
		public var m_proxyPool:Array;
		//uint16 m_freeProxy;
		public var m_freeProxy:int;

		//b2Bound m_bounds[2][2*b2_maxProxies];
		public var m_bounds:Array;

		//uint16 m_queryResults[b2_maxProxies];
		public var m_queryResults:Array;
		//float32 m_querySortKeys[b2_maxProxies];
		public var m_querySortKeys:Array;
		//int32 m_queryResultCount;
		public var m_queryResultCount:int;

		public var m_worldAABB:b2AABB = new b2AABB ();
		public var m_quantizationFactor:b2Vec2 = new b2Vec2 ();
		//int32 m_proxyCount;
		public var m_proxyCount:int;
		//uint16 m_timeStamp;
		public var m_timeStamp:uint;

		//static bool s_validate;
		public var s_validate:Boolean = false; // it is static in c++, which will make some prolbems when multi instances coexist.
	//};

	// inline

		public function InRange(aabb:b2AABB):Boolean
		{
			//b2Vec2 d = b2Max(aabb.lowerBound - m_worldAABB.upperBound, m_worldAABB.lowerBound - aabb.upperBound);
			//return b2Max(d.x, d.y) < 0.0f;
			
			var dx:Number = aabb.lowerBound.x - m_worldAABB.upperBound.x;
			var dy:Number = m_worldAABB.lowerBound.y - aabb.upperBound.y;
			
			return dx < 0.0 && dy < 0.0;
		}

		public function GetProxy(proxyId:int):b2Proxy
		{
			if (proxyId == b2PairManager.b2_nullProxy || (m_proxyPool[proxyId] as b2Proxy).IsValid() == false)
			{
				return null;
			}

			return m_proxyPool [proxyId];
		}
		
		override public function GetUserData(proxyId:int):Object
		{
			return GetProxy (proxyId);
		}
	} // class
} // package
//#endif
