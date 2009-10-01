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

//#include "b2BroadPhase.h"
//#include <algorithm>

//#include <cstring>

// Notes:
// - we use bound arrays instead of linked lists for cache coherence.
// - we use quantized integral values for fast compares.
// - we use short indices rather than pointers to save memory.
// - we use a stabbing count for fast overlap queries (less than order N).
// - we also use a time stamp on each proxy to speed up the registration of
//   overlap query results.
// - where possible, we compare bound indices instead of values to reduce
//   cache misses (TODO_ERIN).
// - no broadphase is perfect and neither is this one: it is not great for huge
//   worlds (use a multi-SAP instead), it is not great for large objects.

//bool b2BroadPhase::s_validate = false;

//struct b2BoundValues
//{
	//@see b2BoundValues.as
//};

//static int32 BinarySearch(b2Bound* bounds, int32 count, uint16 value)
public static function BinarySearch(bounds:Array, count:int, value:int):int
{
	var low:int = 0;
	var high:int = count - 1;
	while (low <= high)
	{
		var mid:int = (low + high) >> 1;
		if (bounds[mid].value > value)
		{
			high = mid - 1;
		}
		else if (bounds[mid].value < value)
		{
			low = mid + 1;
		}
		else
		{
			return mid;
		}
	}
	
	return low;
}

public function b2BroadPhase_SweepAndPrune (worldAABB:b2AABB, callback:b2BroadPhaseMonitor)
{
	m_pairManager.Initialize(this, callback);

	//b2Assert(worldAABB.IsValid());
	m_worldAABB.CopyFrom (worldAABB);
	m_proxyCount = 0;

	//b2Vec2 d = worldAABB.upperBound - worldAABB.lowerBound;
	//m_quantizationFactor.x = float32(B2BROADPHASE_MAX) / d.x;
	//m_quantizationFactor.y = float32(B2BROADPHASE_MAX) / d.y;
	var dx:Number = worldAABB.upperBound.x - worldAABB.lowerBound.x;
	var dy:Number = worldAABB.upperBound.y - worldAABB.lowerBound.y;
	m_quantizationFactor.x = Number(B2BROADPHASE_MAX) / dx;
	m_quantizationFactor.y = Number(B2BROADPHASE_MAX) / dy;

	for (var i:int = 0; i < b2_maxProxies - 1; ++i)
	{
		m_proxyPool[i].SetNext(i + 1);
		m_proxyPool[i].timeStamp = 0;
		m_proxyPool[i].overlapCount = b2_invalid;
		m_proxyPool[i].userData = null;
	}
	m_proxyPool[b2_maxProxies-1].SetNext(b2PairManager.b2_nullProxy);
	m_proxyPool[b2_maxProxies-1].timeStamp = 0;
	m_proxyPool[b2_maxProxies-1].overlapCount = b2_invalid;
	m_proxyPool[b2_maxProxies-1].userData = null;
	m_freeProxy = 0;

	m_timeStamp = 1;
	m_queryResultCount = 0;
}

//b2BroadPhase::~b2BroadPhase()
public function _b2BroadPhase_SweepAndPrune():void
{
}

// This one is only used for validation.
public function TestOverlapProxies (p1:b2Proxy, p2:b2Proxy):Boolean
{
	for (var axis:int = 0; axis < 2; ++axis)
	{
		var bounds:b2Bound = m_bounds[axis] as b2Bound;

		//b2Assert(p1->lowerBounds[axis] < 2 * m_proxyCount);
		//b2Assert(p1->upperBounds[axis] < 2 * m_proxyCount);
		//b2Assert(p2->lowerBounds[axis] < 2 * m_proxyCount);
		//b2Assert(p2->upperBounds[axis] < 2 * m_proxyCount);

		if (bounds[p1.lowerBounds[axis]].value > bounds[p2.upperBounds[axis]].value)
			return false;

		if (bounds[p1.upperBounds[axis]].value < bounds[p2.lowerBounds[axis]].value)
			return false;
	}

	return true;
}

override public function TestOverlap(proxyIdA:int, proxyIdB:int):Boolean
{
	return TestOverlapProxies (GetProxy (proxyIdA), GetProxy (proxyIdB));
}

public function TestOverlap_BoundValuesAndProxy (b:b2BoundValues, p:b2Proxy):Boolean
{
	for (var axis:int = 0; axis < 2; ++axis)
	{
		var bounds:b2Bound = m_bounds[axis] as b2Bound;

		//b2Assert(p->lowerBounds[axis] < 2 * m_proxyCount);
		//b2Assert(p->upperBounds[axis] < 2 * m_proxyCount);

		if (b.lowerValues[axis] > bounds[p.upperBounds[axis]].value)
			return false;

		if (b.upperValues[axis] < bounds[p.lowerBounds[axis]].value)
			return false;
	}

	return true;
}

//void b2BroadPhase::ComputeBounds(uint16* lowerValues, uint16* upperValues, const b2AABB& aabb)
public function ComputeBounds(lowerValues:Array, upperValues:Array, aabb:b2AABB):void
{
	//b2Assert(aabb.upperBound.x >= aabb.lowerBound.x);
	//b2Assert(aabb.upperBound.y >= aabb.lowerBound.y);

	//b2Vec2 minVertex = b2Clamp(aabb.lowerBound, m_worldAABB.lowerBound, m_worldAABB.upperBound);
	//b2Vec2 maxVertex = b2Clamp(aabb.upperBound, m_worldAABB.lowerBound, m_worldAABB.upperBound);
	var minVertex_x:Number = b2Math.b2Clamp_Number (aabb.lowerBound.x, m_worldAABB.lowerBound.x, m_worldAABB.upperBound.x);
	var minVertex_y:Number = b2Math.b2Clamp_Number (aabb.lowerBound.y, m_worldAABB.lowerBound.y, m_worldAABB.upperBound.y);
	var maxVertex_x:Number = b2Math.b2Clamp_Number (aabb.upperBound.x, m_worldAABB.lowerBound.x, m_worldAABB.upperBound.x);
	var maxVertex_y:Number = b2Math.b2Clamp_Number (aabb.upperBound.y, m_worldAABB.lowerBound.y, m_worldAABB.upperBound.y);

	// Bump lower bounds downs and upper bounds up. This ensures correct sorting of
	// lower/upper bounds that would have equal values.
	// TODO_ERIN implement fast float to uint16 conversion.
	//lowerValues[0] = (uint16)(m_quantizationFactor.x * (minVertex.x - m_worldAABB.lowerBound.x)) & (B2BROADPHASE_MAX - 1);
	//upperValues[0] = (uint16)(m_quantizationFactor.x * (maxVertex.x - m_worldAABB.lowerBound.x)) | 1;
	lowerValues[0] = (m_quantizationFactor.x * (minVertex_x - m_worldAABB.lowerBound.x)) & (B2BROADPHASE_MAX - 1);
	upperValues[0] = (m_quantizationFactor.x * (maxVertex_x - m_worldAABB.lowerBound.x)) | 1;

	//lowerValues[1] = (uint16)(m_quantizationFactor.y * (minVertex.y - m_worldAABB.lowerBound.y)) & (B2BROADPHASE_MAX - 1);
	//upperValues[1] = (uint16)(m_quantizationFactor.y * (maxVertex.y - m_worldAABB.lowerBound.y)) | 1;
	lowerValues[1] = (m_quantizationFactor.y * (minVertex_y - m_worldAABB.lowerBound.y)) & (B2BROADPHASE_MAX - 1);
	upperValues[1] = (m_quantizationFactor.y * (maxVertex_y - m_worldAABB.lowerBound.y)) | 1;
}

public function IncrementTimeStamp():void
{
	if (m_timeStamp == B2BROADPHASE_MAX)
	{
		for (var i:int = 0; i < b2_maxProxies; ++i)
		{
			m_proxyPool[i].timeStamp = 0;
		}
		m_timeStamp = 1;
	}
	else
	{
		++m_timeStamp;
	}
}

public function IncrementOverlapCount(proxyId:int):void
{
	//b2Proxy* proxy = m_proxyPool + proxyId;
	var proxy:b2Proxy = m_proxyPool [proxyId];
	if (proxy.timeStamp < m_timeStamp)
	{
		proxy.timeStamp = m_timeStamp;
		proxy.overlapCount = 1;
	}
	else
	{
		proxy.overlapCount = 2;
		//b2Assert(m_queryResultCount < b2_maxProxies);
		m_queryResults[m_queryResultCount] = proxyId;
		++m_queryResultCount;
	}
}

//void b2BroadPhase::Query(int32* lowerQueryOut, int32* upperQueryOut,
//					   uint16 lowerValue, uint16 upperValue,
//					   b2Bound* bounds, int32 boundCount, int32 axis)
public function QueryBounds (//int32* lowerQueryOut, int32* upperQueryOut,
					   lowerValue:uint, upperValue:uint,
					   bounds:Array, boundCount:int, axis:int):Array
{
	var lowerQuery:int = BinarySearch(bounds, boundCount, lowerValue);
	var upperQuery:int = BinarySearch(bounds, boundCount, upperValue);

	// Easy case: lowerQuery <= lowerIndex(i) < upperQuery
	// Solution: search query range for min bounds.
	for (var i1:int = lowerQuery; i1 < upperQuery; ++i1)
	{
		if (bounds[i1].IsLower())
		{
			IncrementOverlapCount(bounds[i1].proxyId);
		}
	}

	// Hard case: lowerIndex(i) < lowerQuery < upperIndex(i)
	// Solution: use the stabbing count to search down the bound array.
	if (lowerQuery > 0)
	{
		var i2:int = lowerQuery - 1;
		var s:int = bounds[i2].stabbingCount;

		// Find the s overlaps.
		while (s)
		{
			//b2Assert(i2 >= 0);

			if (bounds[i2].IsLower())
			{
				var proxy:b2Proxy = m_proxyPool [bounds[i2].proxyId];
				if (lowerQuery <= proxy.upperBounds[axis])
				{
					IncrementOverlapCount(bounds[i2].proxyId);
					--s;
				}
			}
			--i2;
		}
	}

	//*lowerQueryOut = lowerQuery;
	//*upperQueryOut = upperQuery;
	return [lowerQuery, upperQuery];
}

override public function CreateProxy(aabb:b2AABB, userData:Object):int
{
	//b2Assert(m_proxyCount < b2_maxProxies);
	//b2Assert(m_freeProxy != b2_nullProxy);

	var proxyId:int = m_freeProxy;
	var proxy1:b2Proxy = m_proxyPool [proxyId];
	m_freeProxy = proxy1.GetNext();

	proxy1.overlapCount = 0;
	proxy1.userData = userData;

	var boundCount:int = 2 * m_proxyCount;

	//uint16 lowerValues[2], upperValues[2];
	var lowerValues:Array = [0, 0], upperValues:Array = [0, 0];
	ComputeBounds(lowerValues, upperValues, aabb);
	
	var index:int;
	
	for (var axis:int = 0; axis < 2; ++axis)
	{
		var bounds:Array = m_bounds[axis];
		//int32 lowerIndex, upperIndex;
		//Query(&lowerIndex, &upperIndex, lowerValues[axis], upperValues[axis], bounds, boundCount, axis);
		var output:Array = QueryBounds (lowerValues[axis], upperValues[axis], bounds, boundCount, axis);
		var lowerIndex:int = output [0], upperIndex:int = output [1];
		
		//memmove(bounds + upperIndex + 2, bounds + upperIndex, (boundCount - upperIndex) * sizeof(b2Bound));
		//memmove(bounds + lowerIndex + 1, bounds + lowerIndex, (upperIndex - lowerIndex) * sizeof(b2Bound));
		//>>>>>>
		var bound_0:b2Bound = bounds [boundCount];
		var bound_1:b2Bound = bounds [boundCount + 1];
		for (index = boundCount + 1; index >= upperIndex + 2; -- index)
		{
		   bounds [index] = bounds[index - 2];
		}
		for (index = upperIndex; index > lowerIndex; -- index)
		{
		   bounds [index] = bounds[index - 1];
		}

		bounds[lowerIndex    ] = bound_0;
		bounds[upperIndex + 1] = bound_1;
		//<<<<<<

		// The upper index has increased because of the lower bound insertion.
		++upperIndex;

		// Copy in the new bounds.
		bounds[lowerIndex].value = lowerValues[axis];
		bounds[lowerIndex].proxyId = proxyId;
		bounds[upperIndex].value = upperValues[axis];
		bounds[upperIndex].proxyId = proxyId;

		bounds[lowerIndex].stabbingCount = lowerIndex == 0 ? 0 : bounds[lowerIndex-1].stabbingCount;
		bounds[upperIndex].stabbingCount = bounds[upperIndex-1].stabbingCount;

		//var index:int;
		
		// Adjust the stabbing count between the new bounds.
		for (index = lowerIndex; index < upperIndex; ++index)
		{
			++bounds[index].stabbingCount;
		}

		// Adjust the all the affected bound indices.
		for (index = lowerIndex; index < boundCount + 2; ++index)
		{
			var proxy2:b2Proxy = m_proxyPool [bounds[index].proxyId];
			if (bounds[index].IsLower())
			{
				proxy2.lowerBounds[axis] = index;
			}
			else
			{
				proxy2.upperBounds[axis] = index;
			}
		}
	}

	++m_proxyCount;

	//b2Assert(m_queryResultCount < b2_maxProxies);

	// Create pairs if the AABB is in range.
	for (var i:int = 0; i < m_queryResultCount; ++i)
	{
		//b2Assert(m_queryResults[i] < b2_maxProxies);
		//b2Assert(m_proxyPool[m_queryResults[i]].IsValid());

		m_pairManager.AddBufferedPair(proxyId, m_queryResults[i]);
	}

	m_pairManager.Commit();

	if (s_validate)
	{
		Validate();
	}

	// Prepare for next query.
	m_queryResultCount = 0;
	IncrementTimeStamp();

	return proxyId;
}

override public function DestroyProxy(proxyId:int):void
{
	//b2Assert(0 < m_proxyCount && m_proxyCount <= b2_maxProxies);
	var proxy1:b2Proxy = m_proxyPool [proxyId];
	//b2Assert(proxy->IsValid());

	var boundCount:int = 2 * m_proxyCount;

	var index:int;
	
	for (var axis:int = 0; axis < 2; ++axis)
	{
		var bounds:Array = m_bounds[axis];

		var lowerIndex:int = proxy1.lowerBounds[axis];
		var upperIndex:int = proxy1.upperBounds[axis];
		var lowerValue:int = bounds[lowerIndex].value;
		var upperValue:int = bounds[upperIndex].value;

		//memmove(bounds + lowerIndex, bounds + lowerIndex + 1, (upperIndex - lowerIndex - 1) * sizeof(b2Bound));
		//memmove(bounds + upperIndex-1, bounds + upperIndex + 1, (boundCount - upperIndex - 1) * sizeof(b2Bound));
		//>>>>>>
		var bound_0:b2Bound = bounds [lowerIndex];
		var bound_1:b2Bound = bounds [upperIndex];
		for (index = lowerIndex; index < upperIndex - 1; ++ index)
		{
		   bounds [index] = bounds[index + 1];
		}
		for (index = upperIndex - 1; index < boundCount - 2; ++ index)
		{
		   bounds [index] = bounds[index + 2];
		}

		bounds[boundCount - 2] = bound_0;
		bounds[boundCount - 1] = bound_1;
		//<<<<<<

		

		//var index:int;
		
		// Fix bound indices.
		for (index = lowerIndex; index < boundCount - 2; ++index)
		{
			var proxy2:b2Proxy = m_proxyPool [bounds[index].proxyId];
			if (bounds[index].IsLower())
			{
				proxy2.lowerBounds[axis] = index;
			}
			else
			{
				proxy2.upperBounds[axis] = index;
			}
		}

		// Fix stabbing count.
		for (index = lowerIndex; index < upperIndex - 1; ++index)
		{
			--bounds[index].stabbingCount;
		}

		// Query for pairs to be removed. lowerIndex and upperIndex are not needed.
		//Query(&lowerIndex, &upperIndex, lowerValue, upperValue, bounds, boundCount - 2, axis);
		var output:Array = QueryBounds (lowerValue, upperValue, bounds, boundCount - 2, axis);
	}

	//b2Assert(m_queryResultCount < b2_maxProxies);

	for (var i:int = 0; i < m_queryResultCount; ++i)
	{
		//b2Assert(m_proxyPool[m_queryResults[i]].IsValid());
		m_pairManager.RemoveBufferedPair(proxyId, m_queryResults[i]);
	}

	m_pairManager.Commit();

	// Prepare for next query.
	m_queryResultCount = 0;
	IncrementTimeStamp();

	// Return the proxy to the pool.
	proxy1.userData = null;
	proxy1.overlapCount = b2_invalid;
	proxy1.lowerBounds[0] = b2_invalid;
	proxy1.lowerBounds[1] = b2_invalid;
	proxy1.upperBounds[0] = b2_invalid;
	proxy1.upperBounds[1] = b2_invalid;

	proxy1.SetNext(m_freeProxy);
	m_freeProxy = proxyId;
	--m_proxyCount;

	if (s_validate)
	{
		Validate();
	}
}

override public function MoveProxy(proxyId:int, aabb:b2AABB, displacement:b2Vec2):void
{
	if (proxyId == b2PairManager.b2_nullProxy || b2_maxProxies <= proxyId)
	{
		//b2Assert(false);
		return;
	}

	if (aabb.IsValid() == false)
	{
		//b2Assert(false);
		return;
	}

	var boundCount:int = 2 * m_proxyCount;

	var proxy:b2Proxy = m_proxyPool [proxyId];

	// Get new bound values
	var newValues:b2BoundValues = new b2BoundValues ();
	ComputeBounds(newValues.lowerValues, newValues.upperValues, aabb);

	var axis:int;
	
	// Get old bound values
	var oldValues:b2BoundValues = new b2BoundValues ();
	for (axis = 0; axis < 2; ++axis)
	{
		oldValues.lowerValues[axis] = m_bounds[axis][proxy.lowerBounds[axis]].value;
		oldValues.upperValues[axis] = m_bounds[axis][proxy.upperBounds[axis]].value;
	}

	for (axis = 0; axis < 2; ++axis)
	{
		var bounds:b2Bound = m_bounds[axis];

		var lowerIndex:int = proxy.lowerBounds[axis];
		var upperIndex:int = proxy.upperBounds[axis];

		var lowerValue:int = newValues.lowerValues[axis];
		var upperValue:int = newValues.upperValues[axis];

		var deltaLower:int = lowerValue - bounds[lowerIndex].value;
		var deltaUpper:int = upperValue - bounds[upperIndex].value;

		bounds[lowerIndex].value = lowerValue;
		bounds[upperIndex].value = upperValue;

		//
		// Expanding adds overlaps
		//

		var index:int;
		var bound:b2Bound;
		var prevBound:b2Bound;
		var nextBound:b2Bound;
		var prevProxyId:int;
		var prevProxy:b2Proxy;
		var nextProxyId:int;
		var nextProxy:b2Proxy;
		
		var tValue:int;
		var tProxyId:int;
		var tStabbingCount:int;
		
		// Should we move the lower bound down?
		if (deltaLower < 0)
		{
			index = lowerIndex;
			while (index > 0 && lowerValue < bounds[index-1].value)
			{
				//b2Bound* bound = bounds + index;
				//b2Bound* prevBound = bound - 1;
				bound = bounds [index];
				prevBound = bounds [index - 1];

				prevProxyId = prevBound.proxyId;
				prevProxy = m_proxyPool [prevBound.proxyId];

				++prevBound.stabbingCount;

				if (prevBound.IsUpper() == true)
				{
					if (TestOverlap_BoundValuesAndProxy (newValues, prevProxy))
					{
						m_pairManager.AddBufferedPair(proxyId, prevProxyId);
					}

					++prevProxy.upperBounds[axis];
					++bound.stabbingCount;
				}
				else
				{
					++prevProxy.lowerBounds[axis];
					--bound.stabbingCount;
				}

				--proxy.lowerBounds[axis];
				
				//b2Swap(*bound, *prevBound);
				// if there is no references of the bounds, we can use the simply one
				bounds [index] = prevBound;
				bounds [index - 1] = bound;
				//
				// currently, we use the use safe one:
				//tValue         = bound.value;
				//tProxyId       = bound.proxyId;
				//tStabbingCount = bound.stabbingCount;
				//bound.value         = prevBound.value;
				//bound.proxyId       = prevBound.proxyId;
				//bound.stabbingCount = prevBound.value;
				//prevBound.value         = tValue;
				//prevBound.proxyId       = tProxyId;
				//prevBound.stabbingCount = tStabbingCount;
				
				--index;
			}
		}

		// Should we move the upper bound up?
		if (deltaUpper > 0)
		{
			index = upperIndex;
			while (index < boundCount-1 && bounds[index+1].value <= upperValue)
			{
				//b2Bound* bound = bounds + index;
				//b2Bound* nextBound = bound + 1;
				bound = bounds [index];
				nextBound = bounds [index + 1];
				
				nextProxyId = nextBound.proxyId;
				nextProxy = m_proxyPool [nextProxyId];

				++nextBound.stabbingCount;

				if (nextBound.IsLower() == true)
				{
					if (TestOverlap_BoundValuesAndProxy (newValues, nextProxy))
					{
						m_pairManager.AddBufferedPair(proxyId, nextProxyId);
					}

					--nextProxy.lowerBounds[axis];
					++bound.stabbingCount;
				}
				else
				{
					--nextProxy.upperBounds[axis];
					--bound.stabbingCount;
				}

				++proxy.upperBounds[axis];
				
				//b2Swap(*bound, *nextBound);
				// if there is no references of the bounds, we can use the simply one
				bounds [index] = nextBound;
				bounds [index + 1] = bound;
				//
				// currently, we use the use safe one:
				//tValue         = bound.value;
				//tProxyId       = bound.proxyId;
				//tStabbingCount = bound.stabbingCount;
				//bound.value         = nextBound.value;
				//bound.proxyId       = nextBound.proxyId;
				//bound.stabbingCount = nextBound.value;
				//nextBound.value         = tValue;
				//nextBound.proxyId       = tProxyId;
				//nextBound.stabbingCount = tStabbingCount;

				
				++index;
			}
		}

		//
		// Shrinking removes overlaps
		//

		// Should we move the lower bound up?
		if (deltaLower > 0)
		{
			index = lowerIndex;
			while (index < boundCount-1 && bounds[index+1].value <= lowerValue)
			{
				bound = bounds [index];
				nextBound = bounds [index + 1];

				nextProxyId = nextBound.proxyId;
				nextProxy = m_proxyPool [nextProxyId];

				--nextBound.stabbingCount;

				if (nextBound.IsUpper())
				{
					if (TestOverlap_BoundValuesAndProxy (oldValues, nextProxy))
					{
						m_pairManager.RemoveBufferedPair(proxyId, nextProxyId);
					}

					--nextProxy.upperBounds[axis];
					--bound.stabbingCount;
				}
				else
				{
					--nextProxy.lowerBounds[axis];
					++bound.stabbingCount;
				}

				++proxy.lowerBounds[axis];
				
				//b2Swap(*bound, *nextBound);
				// if there is no references of the bounds, we can use the simply one
				bounds [index] = nextBound;
				bounds [index + 1] = bound;
				//
				// currently, we use the use safe one:
				//tValue         = bound.value;
				//tProxyId       = bound.proxyId;
				//tStabbingCount = bound.stabbingCount;
				//bound.value         = nextBound.value;
				//bound.proxyId       = nextBound.proxyId;
				//bound.stabbingCount = nextBound.value;
				//nextBound.value         = tValue;
				//nextBound.proxyId       = tProxyId;
				//nextBound.stabbingCount = tStabbingCount;
				
				++index;
			}
		}

		// Should we move the upper bound down?
		if (deltaUpper < 0)
		{
			index = upperIndex;
			while (index > 0 && upperValue < bounds[index-1].value)
			{
				bound = bounds [index];
				prevBound = bounds [index - 1];

				prevProxyId = prevBound.proxyId;
				prevProxy = m_proxyPool [prevProxyId];

				--prevBound.stabbingCount;

				if (prevBound.IsLower() == true)
				{
					if (TestOverlap_BoundValuesAndProxy (oldValues, prevProxy))
					{
						m_pairManager.RemoveBufferedPair(proxyId, prevProxyId);
					}

					++prevProxy.lowerBounds[axis];
					--bound.stabbingCount;
				}
				else
				{
					++prevProxy.upperBounds[axis];
					++bound.stabbingCount;
				}

				--proxy.upperBounds[axis];
				
				//b2Swap(*bound, *prevBound);
				// if there is no references of the bounds, we can use the simply one
				bounds [index] = prevBound;
				bounds [index - 1] = bound;
				//
				// currently, we use the use safe one:
				//tValue         = bound.value;
				//tProxyId       = bound.proxyId;
				//tStabbingCount = bound.stabbingCount;
				//bound.value         = prevBound.value;
				//bound.proxyId       = prevBound.proxyId;
				//bound.stabbingCount = prevBound.value;
				//prevBound.value         = tValue;
				//prevBound.proxyId       = tProxyId;
				//prevBound.stabbingCount = tStabbingCount;
				
				--index;
			}
		}
	}

	if (s_validate)
	{
		Validate();
	}
}

public function Commit():void
{
	m_pairManager.Commit();
}

//int32 b2BroadPhase::Query(const b2AABB& aabb, void** userData, int32 maxCount)
//{
//	uint16 lowerValues[2];
//	uint16 upperValues[2];
//	ComputeBounds(lowerValues, upperValues, aabb);
//
//	int32 lowerIndex, upperIndex;
//
//	Query(&lowerIndex, &upperIndex, lowerValues[0], upperValues[0], m_bounds[0], 2*m_proxyCount, 0);
//	Query(&lowerIndex, &upperIndex, lowerValues[1], upperValues[1], m_bounds[1], 2*m_proxyCount, 1);
//
//	b2Assert(m_queryResultCount < b2_maxProxies);
//
//	int32 count = 0;
//	for (int32 i = 0; i < m_queryResultCount && count < maxCount; ++i, ++count)
//	{
//		b2Assert(m_queryResults[i] < b2_maxProxies);
//		b2Proxy* proxy = m_proxyPool + m_queryResults[i];
//		b2Assert(proxy->IsValid());
//		userData[i] = proxy->userData;
//	}
//
//	// Prepare for next query.
//	m_queryResultCount = 0;
//	IncrementTimeStamp();
//
//	return count;
//}
override public function Query(callback:b2QueryCallbackOwner, aabb:b2AABB):void
{
	//uint16 lowerValues[2];
	//uint16 upperValues[2];
	var lowerValues:Array = new Array (2); 
	var upperValues:Array = new Array (2); 
	ComputeBounds(lowerValues, upperValues, aabb);

	//int32 lowerIndex, upperIndex;

	//Query(&lowerIndex, &upperIndex, lowerValues[0], upperValues[0], m_bounds[0], 2*m_proxyCount, 0);
	//Query(&lowerIndex, &upperIndex, lowerValues[1], upperValues[1], m_bounds[1], 2*m_proxyCount, 1);
	QueryBounds (lowerValues[0], upperValues[0], m_bounds[0], 2*m_proxyCount, 0);
	QueryBounds (lowerValues[1], upperValues[1], m_bounds[1], 2*m_proxyCount, 1);

	//b2Assert(m_queryResultCount < b2_maxProxies);

	var count:int = 0;
	for (var i:int = 0; i < m_queryResultCount; ++i)
	{
		//b2Assert(m_queryResults[i] < b2_maxProxies);
		//var proxy:b2Proxy = m_proxyPool [m_queryResults[i]];
		//b2Assert(proxy->IsValid());
		//userData[i] = proxy.userData;
		
		callback.QueryCallback (m_queryResults[i]);
	}

	// Prepare for next query.
	m_queryResultCount = 0;
	IncrementTimeStamp();

	//return count;
}

public function Validate():void
{
	for (var axis:int = 0; axis < 2; ++axis)
	{
		var bounds:b2Bound = m_bounds[axis];

		var boundCount:int = 2 * m_proxyCount;
		var stabbingCount:int = 0;

		for (var i:int = 0; i < boundCount; ++i)
		{
			var bound:b2Bound = bounds [i];
			//b2Assert(i == 0 || bounds[i-1].value <= bound->value);
			//b2Assert(bound->proxyId != b2_nullProxy);
			//b2Assert(m_proxyPool[bound->proxyId].IsValid());

			if (bound.IsLower() == true)
			{
				//b2Assert(m_proxyPool[bound->proxyId].lowerBounds[axis] == i);
				++stabbingCount;
			}
			else
			{
				//b2Assert(m_proxyPool[bound->proxyId].upperBounds[axis] == i);
				--stabbingCount;
			}

			//b2Assert(bound->stabbingCount == stabbingCount);
		}
	}
}

override public function RayCast(callback:b2RayCastCallbackOwner, input:b2RayCastInput):void
{
	// todo: QuerySegment
}

/*
//int32 b2BroadPhase::QuerySegment(const b2Segment& segment, void** userData, int32 maxCount, SortKeyFunc sortKey)
public function QuerySegment (segment:b2Segment, userData:Array, maxCount:int, sortKey:Function):int
{
	var maxLambda:Number = 1.0;

	var dx:Number = (segment.p2.x-segment.p1.x)*m_quantizationFactor.x;
	var dy:Number = (segment.p2.y-segment.p1.y)*m_quantizationFactor.y;

	var sx:int = dx<-b2Settings.B2_FLT_EPSILON ? -1 : (dx>b2Settings.B2_FLT_EPSILON ? 1 : 0);
	var sy:int = dy<-b2Settings.B2_FLT_EPSILON ? -1 : (dy>b2Settings.B2_FLT_EPSILON ? 1 : 0);

	//b2Assert(sx!=0||sy!=0);

	var p1x:Number = (segment.p1.x-m_worldAABB.lowerBound.x)*m_quantizationFactor.x;
	var p1y:Number = (segment.p1.y-m_worldAABB.lowerBound.y)*m_quantizationFactor.y;

	//uint16 startValues[2];
	//uint16 startValues2[2];
	var startValues:Array = new Array (2);
	var startValues2:Array = new Array (2);

	var xIndex:int;
	var yIndex:int;

	var proxyId:int;
	var proxy:b2Proxy;
	
	// TODO_ERIN implement fast float to uint16 conversion.
	startValues[0] =  (p1x) & (B2BROADPHASE_MAX - 1);
	startValues2[0] = (p1x) | 1;

	startValues[1] = (p1y) & (B2BROADPHASE_MAX - 1);
	startValues2[1] = (p1y) | 1;

	//First deal with all the proxies that contain segment.p1
	//int32 lowerIndex;
	//int32 upperIndex;
	var output:Array = Query(startValues[0],startValues2[0],m_bounds[0],2*m_proxyCount,0);
	var lowerIndex:int = output [0];
	var upperIndex:int = output [1];
	if(sx>=0)	xIndex = upperIndex-1;
	else		xIndex = lowerIndex;
	output = Query(startValues[1],startValues2[1],m_bounds[1],2*m_proxyCount,1);
	lowerIndex = output [0];
	upperIndex = output [1];
	if(sy>=0)	yIndex = upperIndex-1;
	else		yIndex = lowerIndex;

	var i:int;

	//If we are using sortKey, then sort what we have so far, filtering negative keys
	if(sortKey != null)
	{
		//Fill keys
		for(i=0;i<m_queryResultCount;i++)
		{
			m_querySortKeys[i] = sortKey(m_proxyPool[m_queryResults[i]].userData);
		}
		//Bubble sort keys
		//Sorting negative values to the top, so we can easily remove them
		i = 0;
		while(i<m_queryResultCount-1)
		{
			var a:Number = m_querySortKeys[i];
			var b:Number = m_querySortKeys[i+1];
			if((a<0)?(b>=0):(a>b&&b>=0))
			{
				m_querySortKeys[i+1] = a;
				m_querySortKeys[i]   = b;
				var tempValue:Number = m_queryResults[i+1];
				m_queryResults[i+1] = m_queryResults[i];
				m_queryResults[i] = tempValue;
				i--;
				if(i==-1) i=1;
			}
			else
			{
				i++;
			}
		}
		//Skim off negative values
		while(m_queryResultCount>0 && m_querySortKeys[m_queryResultCount-1]<0)
			m_queryResultCount--;
	}

	//Now work through the rest of the segment
	for (;;)
	{
		var xProgress:Number = 0.0;
		var yProgress:Number = 0.0;
		//Move on to the next bound
		xIndex += sx>=0?1:-1;
		if(xIndex<0||xIndex>=m_proxyCount*2)
			break;
		if(sx!=0)
			xProgress = (Number(m_bounds[0][xIndex]).value-p1x)/dx;
		//Move on to the next bound
		yIndex += sy>=0?1:-1;
		if(yIndex<0||yIndex>=m_proxyCount*2)
			break;
		if(sy!=0)
			yProgress = (Number(m_bounds[1][yIndex]).value-p1y)/dy;
		for(;;)
		{
			if(sy==0||(sx!=0&&xProgress<yProgress))
			{
				if(xProgress>maxLambda)
					break;

				//Check that we are entering a proxy, not leaving
				if(sx>0?m_bounds[0][xIndex].IsLower():m_bounds[0][xIndex].IsUpper()){
					//Check the other axis of the proxy
					proxyId = m_bounds[0][xIndex].proxyId;
					proxy = m_proxyPool+proxyId;
					if(sy>=0)
					{
						if(proxy.lowerBounds[1]<=yIndex-1&&proxy.upperBounds[1]>=yIndex)
						{
							//Add the proxy
							if(sortKey != null)
							{
								AddProxyResult(proxyId,proxy,maxCount,sortKey);
							}
							else
							{
								m_queryResults[m_queryResultCount] = proxyId;
								++m_queryResultCount;
							}
						}
					}
					else
					{
						if(proxy.lowerBounds[1]<=yIndex&&proxy.upperBounds[1]>=yIndex+1)
						{
							//Add the proxy
							if(sortKey != null)
							{
								AddProxyResult(proxyId,proxy,maxCount,sortKey);
							}
							else
							{
								m_queryResults[m_queryResultCount] = proxyId;
								++m_queryResultCount;
							}
						}
					}
				}

				//Early out
				if(sortKey != null && m_queryResultCount==maxCount && m_queryResultCount>0 && xProgress>m_querySortKeys[m_queryResultCount-1])
					break;

				//Move on to the next bound
				if(sx>0)
				{
					xIndex++;
					if(xIndex==m_proxyCount*2)
						break;
				}
				else
				{
					xIndex--;
					if(xIndex<0)
						break;
				}
				xProgress = (Number (m_bounds[0][xIndex].value) - p1x) / dx;
			}
			else
			{
				if(yProgress>maxLambda)
					break;

				//Check that we are entering a proxy, not leaving
				if(sy>0?m_bounds[1][yIndex].IsLower():m_bounds[1][yIndex].IsUpper()){
					//Check the other axis of the proxy
					proxyId = m_bounds[1][yIndex].proxyId;
					proxy = m_proxyPool+proxyId;
					if(sx>=0)
					{
						if(proxy.lowerBounds[0]<=xIndex-1&&proxy.upperBounds[0]>=xIndex)
						{
							//Add the proxy
							if(sortKey)
							{
								AddProxyResult(proxyId,proxy,maxCount,sortKey);
							}
							else
							{
								m_queryResults[m_queryResultCount] = proxyId;
								++m_queryResultCount;
							}
						}
					}
					else
					{
						if(proxy.lowerBounds[0]<=xIndex&&proxy.upperBounds[0]>=xIndex+1)
						{
							//Add the proxy
							if(sortKey)
							{
								AddProxyResult(proxyId,proxy,maxCount,sortKey);
							}
							else
							{
								m_queryResults[m_queryResultCount] = proxyId;
								++m_queryResultCount;
							}
						}
					}
				}

				//Early out
				if(sortKey && m_queryResultCount==maxCount && m_queryResultCount>0 && yProgress>m_querySortKeys[m_queryResultCount-1])
					break;

				//Move on to the next bound
				if(sy>0)
				{
					yIndex++;
					if(yIndex==m_proxyCount*2)
						break;
				}
				else
				{
					yIndex--;
					if(yIndex<0)
						break;
				}
				yProgress = (Number (m_bounds[1][yIndex].value) - p1y) / dy;
			}
		}

		break;
	}

	var count:int = 0;
	for(i=0;i < m_queryResultCount && count<maxCount; ++i, ++count)
	{
		//b2Assert(m_queryResults[i] < b2_maxProxies);
		var proxy:b2Proxy = m_proxyPool [m_queryResults[i]];
		//b2Assert(proxy->IsValid());
		userData[i] = proxy.userData;
	}

	// Prepare for next query.
	m_queryResultCount = 0;
	IncrementTimeStamp();
	
	return count;

}
*/

//void b2BroadPhase::AddProxyResult(uint16 proxyId, b2Proxy* proxy, int32 maxCount, SortKeyFunc sortKey)
public function AddProxyResult(proxyId:int, proxy:b2Proxy, maxCount:int, sortKey:Function):void
{
	var key:Number = sortKey(proxy.userData);
	//Filter proxies on positive keys
	if(key<0)
		return;
	//Merge the new key into the sorted list.
	//float32* p = std::lower_bound(m_querySortKeys,m_querySortKeys+m_queryResultCount,key);
	//float32* p = m_querySortKeys;
	//while(*p<key&&p<m_querySortKeys+m_queryResultCount)
	//	p++;
	//var i:int = (int32)(p-m_querySortKeys);
	var i:int = 0;
	while (m_querySortKeys[i] < key && i < m_queryResultCount)
		i++;
	if (maxCount == m_queryResultCount && i == m_queryResultCount)
		return;
	if (maxCount == m_queryResultCount)
		m_queryResultCount--;
	//std::copy_backward
	for (var j:int = m_queryResultCount+1; j > i; --j)
	{
		m_querySortKeys[j] = m_querySortKeys[j-1];
		m_queryResults[j]  = m_queryResults[j-1];
	}
	m_querySortKeys[i] = key;
	m_queryResults[i] = proxyId;
	m_queryResultCount++;
}
