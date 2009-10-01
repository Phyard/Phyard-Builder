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

//#include "b2PairManager.h"
//#include "b2BroadPhase.h"

//#include <algorithm>

// Thomas Wang's hash, see: http://www.concentric.net/~Ttwang/tech/inthash.htm
// This assumes proxyId1 and proxyId2 are 16-bit.
//inline uint32 Hash(uint32 proxyId1, uint32 proxyId2)
public static function Hash(proxyId1:int, proxyId2:int):int
{
	var key:int = (proxyId2 << 16) | proxyId1;
	key = ~key + (key << 15);
	key = key ^ (key >> 12);
	key = key + (key << 2);
	key = key ^ (key >> 4);
	key = key * 2057;
	key = key ^ (key >> 16);
	return key;
}

//inline bool Equals(const b2Pair& pair, int32 proxyId1, int32 proxyId2)
public static function EqualsPair (pair:b2Pair, proxyId1:int, proxyId2:int):Boolean
{
	return pair.proxyId1 == proxyId1 && pair.proxyId2 == proxyId2;
}

//inline bool Equals(const b2BufferedPair& pair1, const b2BufferedPair& pair2)
public static function EqualsTwoPairs(pair1:b2BufferedPair, pair2:b2BufferedPair):Boolean
{
	return pair1.proxyId1 == pair2.proxyId1 && pair1.proxyId2 == pair2.proxyId2;
}

// For sorting.
//inline bool operator < (const b2BufferedPair& pair1, const b2BufferedPair& pair2)
public static function CompareTwoPairs (pair1:b2BufferedPair, pair2:b2BufferedPair):Boolean
{
	if (pair1.proxyId1 < pair2.proxyId1)
	{
		return true;
	}

	if (pair1.proxyId1 == pair2.proxyId1)
	{
		return pair1.proxyId2 < pair2.proxyId2;
	}

	return false;
}

public function b2PairManager()
{
	var i:int;
	
	//b2Assert(b2IsPowerOfTwo(b2_tableCapacity) == true);
	//b2Assert(b2_tableCapacity >= b2_maxPairs);
	for (i = 0; i < b2_tableCapacity; ++i)
	{
		m_hashTable[i] = b2_nullPair;
	}
	m_freePair = 0;
	for (i = 0; i < b2_maxPairs; ++i)
	{
		m_pairs[i].proxyId1 = b2_nullProxy;
		m_pairs[i].proxyId2 = b2_nullProxy;
		m_pairs[i].userData = null;
		m_pairs[i].status = 0;
		m_pairs[i].next = (i + 1);
	}
	m_pairs[b2_maxPairs-1].next = b2_nullPair;
	m_pairCount = 0;
	m_pairBufferCount = 0;
}

//void b2PairManager::Initialize(b2BroadPhase* broadPhase, b2PairCallback* callback)
public function Initialize(broadPhase:b2BroadPhase_SweepAndPrune, callback:b2BroadPhaseMonitor):void
{
	m_broadPhase = broadPhase;
	m_callback = callback;
}

public function FindWithHashCode(proxyId1:int, proxyId2:int, hash:int):b2Pair
{
	var index:int = m_hashTable[hash];

	while (index != b2_nullPair && EqualsPair (m_pairs[index], proxyId1, proxyId2) == false)
	{
		index = m_pairs[index].next;
	}

	if (index == b2_nullPair)
	{
		return null;
	}

	//b2Assert(index < b2_maxPairs);

	return m_pairs [index];
}

public function Find(proxyId1:int, proxyId2:int):b2Pair
{
	//if (proxyId1 > proxyId2) b2Swap(proxyId1, proxyId2);
	if (proxyId1 > proxyId2) var temp:int = proxyId1; proxyId1 = proxyId2; proxyId2 = temp;

	var hash:int = Hash(proxyId1, proxyId2) & b2_tableMask;

	return FindWithHashCode (proxyId1, proxyId2, hash);
}

// Returns existing pair or creates a new one.
public function AddPair(proxyId1:int, proxyId2:int):b2Pair
{
	//if (proxyId1 > proxyId2) b2Swap(proxyId1, proxyId2);
	if (proxyId1 > proxyId2) var temp:int = proxyId1; proxyId1 = proxyId2; proxyId2 = temp;

	var hash:int = Hash(proxyId1, proxyId2) & b2_tableMask;

	var pair:b2Pair = FindWithHashCode (proxyId1, proxyId2, hash);
	if (pair != null)
	{
		return pair;
	}

	//b2Assert(m_pairCount < b2_maxPairs && m_freePair != b2_nullPair);

	var pairIndex:int = m_freePair;
	pair = m_pairs [pairIndex];
	m_freePair = pair.next;

	pair.proxyId1 = proxyId1;
	pair.proxyId2 = proxyId2;
	pair.status = 0;
	pair.userData = null;
	pair.next = m_hashTable[hash];

	m_hashTable[hash] = pairIndex;

	++m_pairCount;

	return pair;
}

// Removes a pair. The pair must exist.
public function RemovePair(proxyId1:int, proxyId2:int):Object
{
	//b2Assert(m_pairCount > 0);

	//if (proxyId1 > proxyId2) b2Swap(proxyId1, proxyId2);
	if (proxyId1 > proxyId2) var temp:int = proxyId1; proxyId1 = proxyId2; proxyId2 = temp;

	var hash:int = Hash(proxyId1, proxyId2) & b2_tableMask;

	//uint16* node = &m_hashTable[hash];
	//while (*node != b2_nullPair)
	//{
	//	if (Equals(m_pairs[*node], proxyId1, proxyId2))
	//	{
	//		uint16 index = *node;
	//		*node = m_pairs[*node].next;
	//		
	//		b2Pair* pair = m_pairs + index;
	//		void* userData = pair->userData;
	//
	//		// Scrub
	//		pair->next = m_freePair;
	//		pair->proxyId1 = b2_nullProxy;
	//		pair->proxyId2 = b2_nullProxy;
	//		pair->userData = NULL;
	//		pair->status = 0;
	//
	//		m_freePair = index;
	//		--m_pairCount;
	//		return userData;
	//	}
	//	else
	//	{
	//		node = &m_pairs[*node].next;
	//	}
	//}
	var pairIndex:int = m_hashTable[hash];
	while (pairIndex != b2_nullPair)
	{
		if (EqualsPair (m_pairs[pairIndex], proxyId1, proxyId2))
		{
			m_hashTable[hash] = m_pairs[pairIndex].next;
			
			var pair:b2Pair = m_pairs [pairIndex];
			var userData:Object = pair.userData;

			// Scrub
			pair.next = m_freePair;
			pair.proxyId1 = b2_nullProxy;
			pair.proxyId2 = b2_nullProxy;
			pair.userData = null;
			pair.status = 0;

			m_freePair = pairIndex;
			--m_pairCount;
			return userData;
		}
		else
		{
			pairIndex = m_pairs[pairIndex].next;
		}
	}

	//b2Assert(false);
	return null;
}

/*
As proxies are created and moved, many pairs are created and destroyed. Even worse, the same
pair may be added and removed multiple times in a single time step of the physics engine. To reduce
traffic in the pair manager, we try to avoid destroying pairs in the pair manager until the
end of the physics step. This is done by buffering all the RemovePair requests. AddPair
requests are processed immediately because we need the hash table entry for quick lookup.

All user user callbacks are delayed until the buffered pairs are confirmed in Commit.
This is very important because the user callbacks may be very expensive and client logic
may be harmed if pairs are added and removed within the same time step.

Buffer a pair for addition.
We may add a pair that is not in the pair manager or pair buffer.
We may add a pair that is already in the pair manager and pair buffer.
If the added pair is not a new pair, then it must be in the pair buffer (because RemovePair was called).
*/
public function AddBufferedPair(id1:int, id2:int):void
{
	//b2Assert(id1 != b2_nullProxy && id2 != b2_nullProxy);
	//b2Assert(m_pairBufferCount < b2_maxPairs);

	var pair:b2Pair = AddPair(id1, id2);

	// If this pair is not in the pair buffer ...
	if (pair.IsBuffered() == false)
	{
		// This must be a newly added pair.
		//b2Assert(pair->IsFinal() == false);

		// Add it to the pair buffer.
		pair.SetBuffered();
		m_pairBuffer[m_pairBufferCount].proxyId1 = pair.proxyId1;
		m_pairBuffer[m_pairBufferCount].proxyId2 = pair.proxyId2;
		++m_pairBufferCount;

		//b2Assert(m_pairBufferCount <= m_pairCount);
	}

	// Confirm this pair for the subsequent call to Commit.
	pair.ClearRemoved();

	//if (b2BroadPhase::s_validate)
	if (m_broadPhase.s_validate)
	{
		ValidateBuffer();
	}
}

// Buffer a pair for removal.
public function RemoveBufferedPair(id1:int, id2:int):void
{
	//b2Assert(id1 != b2_nullProxy && id2 != b2_nullProxy);
	//b2Assert(m_pairBufferCount < b2_maxPairs);

	var pair:b2Pair = Find(id1, id2);

	if (pair == null)
	{
		// The pair never existed. This is legal (due to collision filtering).
		return;
	}

	// If this pair is not in the pair buffer ...
	if (pair.IsBuffered() == false)
	{
		// This must be an old pair.
		//b2Assert(pair->IsFinal() == true);

		pair.SetBuffered();
		m_pairBuffer[m_pairBufferCount].proxyId1 = pair.proxyId1;
		m_pairBuffer[m_pairBufferCount].proxyId2 = pair.proxyId2;
		++m_pairBufferCount;

		//b2Assert(m_pairBufferCount <= m_pairCount);
	}

	pair.SetRemoved();

	//if (b2BroadPhase::s_validate)
	if (m_broadPhase.s_validate)
	{
		ValidateBuffer();
	}
}

public function Commit():void
{
	var removeCount:int = 0;

	var proxies:Array = m_broadPhase.m_proxyPool;

	var i:int;
	
	for (i = 0; i < m_pairBufferCount; ++i)
	{
		var pair:b2Pair = Find(m_pairBuffer[i].proxyId1, m_pairBuffer[i].proxyId2);
		//b2Assert(pair->IsBuffered());
		pair.ClearBuffered();

		//b2Assert(pair->proxyId1 < b2_maxProxies && pair->proxyId2 < b2_maxProxies);

		var proxy1:b2Proxy = proxies [pair.proxyId1];
		var proxy2:b2Proxy = proxies [pair.proxyId2];

		//b2Assert(proxy1->IsValid());
		//b2Assert(proxy2->IsValid());

		if (pair.IsRemoved())
		{
			// It is possible a pair was added then removed before a commit. Therefore,
			// we should be careful not to tell the user the pair was removed when the
			// the user didn't receive a matching add.
			if (pair.IsFinal() == true)
			{
				m_callback.PairRemoved(proxy1.userData, proxy2.userData, pair.userData);
			}

			// Store the ids so we can actually remove the pair below.
			m_pairBuffer[removeCount].proxyId1 = pair.proxyId1;
			m_pairBuffer[removeCount].proxyId2 = pair.proxyId2;
			++removeCount;
		}
		else
		{
			//b2Assert(m_broadPhase->TestOverlap(proxy1, proxy2) == true);

			if (pair.IsFinal() == false)
			{
				//pair->userData = m_callback->PairAdded(proxy1->userData, proxy2->userData);
				m_callback.PairAdded(proxy1.userData, proxy2.userData);
				pair.SetFinal();
			}
		}
	}

	for (i = 0; i < removeCount; ++i)
	{
		RemovePair(m_pairBuffer[i].proxyId1, m_pairBuffer[i].proxyId2);
	}

	m_pairBufferCount = 0;

	//if (b2BroadPhase::s_validate)
	if (m_broadPhase.s_validate)
	{
		ValidateTable();
	}
}

public function ValidateBuffer():void
{
//#ifdef _DEBUG
//	b2Assert(m_pairBufferCount <= m_pairCount);
//
//	std::sort(m_pairBuffer, m_pairBuffer + m_pairBufferCount);
//
//	for (int32 i = 0; i < m_pairBufferCount; ++i)
//	{
//		if (i > 0)
//		{
//			b2Assert(Equals(m_pairBuffer[i], m_pairBuffer[i-1]) == false);
//		}
//
//		b2Pair* pair = Find(m_pairBuffer[i].proxyId1, m_pairBuffer[i].proxyId2);
//		b2Assert(pair->IsBuffered());
//
//		b2Assert(pair->proxyId1 != pair->proxyId2);
//		b2Assert(pair->proxyId1 < b2_maxProxies);
//		b2Assert(pair->proxyId2 < b2_maxProxies);
//
//		b2Proxy* proxy1 = m_broadPhase->m_proxyPool + pair->proxyId1;
//		b2Proxy* proxy2 = m_broadPhase->m_proxyPool + pair->proxyId2;
//
//		b2Assert(proxy1->IsValid() == true);
//		b2Assert(proxy2->IsValid() == true);
//	}
//#endif
}

public function ValidateTable():void
{
//#ifdef _DEBUG
//	for (int32 i = 0; i < b2_tableCapacity; ++i)
//	{
//		uint16 index = m_hashTable[i];
//		while (index != b2_nullPair)
//		{
//			b2Pair* pair = m_pairs + index;
//			b2Assert(pair->IsBuffered() == false);
//			b2Assert(pair->IsFinal() == true);
//			b2Assert(pair->IsRemoved() == false);/
//
//			b2Assert(pair->proxyId1 != pair->proxyId2);
//			b2Assert(pair->proxyId1 < b2_maxProxies);
//			b2Assert(pair->proxyId2 < b2_maxProxies);
//
//			b2Proxy* proxy1 = m_broadPhase->m_proxyPool + pair->proxyId1;
//			b2Proxy* proxy2 = m_broadPhase->m_proxyPool + pair->proxyId2;
//
//			b2Assert(proxy1->IsValid() == true);
//			b2Assert(proxy2->IsValid() == true);
//
//			b2Assert(m_broadPhase->TestOverlap(proxy1, proxy2) == true);
//
//			index = pair->next;
//		}
//	}
//#endif
}
