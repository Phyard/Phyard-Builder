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

// The pair manager is used by the broad-phase to quickly add/remove/find pairs
// of overlapping proxies. It is based closely on code provided by Pierre Terdiman.
// http://www.codercorner.com/IncrementalSAP.txt

//#ifndef B2_PAIR_MANAGER_H
//#define B2_PAIR_MANAGER_H

package Box2dEx.BroadPhase.SweepAndPrune
{
		
	//#include "../Common/b2Settings.h"
	//#include "../Common/b2Math.h"

	//#include <climits>

	import Box2D.Collision.b2BroadPhaseMonitor;
	import Box2D.Collision.b2QueryCallbackOwner;
	import Box2D.Collision.b2RayCastCallbackOwner;
	import Box2D.Collision.b2RayCastInput;
	
	//class b2BroadPhase;
	//struct b2Proxy;

	//const uint16 b2_nullPair = USHRT_MAX;
	//const uint16 b2_nullProxy = USHRT_MAX;
	//const int32 b2_tableCapacity = b2_maxPairs;	// must be a power of two
	//const int32 b2_tableMask = b2_tableCapacity - 1;

	//struct b2Pair
	//{
		//@see b2Pair.as
	//};

	//struct b2BufferedPair
	//{
		//@see b2BufferedPair.as
	//};

	// @see b2BroadPhaseMonitor class in core api
	//class b2PairCallback
	//{
	//public:
	//	virtual ~b2PairCallback() {}
	//
	//	// This should return the new pair user data. It is ok if the
	//	// user data is null.
	//	virtual void* PairAdded(void* proxyUserData1, void* proxyUserData2) = 0;
	//
	//	// This should free the pair's user data. In extreme circumstances, it is possible
	//	// this will be called with null pairUserData because the pair never existed.
	//	virtual void PairRemoved(void* proxyUserData1, void* proxyUserData2, void* pairUserData) = 0;
	//};

	public class b2PairManager
	{
		include "b2PairManager.cpp";
		
		public static const b2_maxPairs:int = (8 * b2BroadPhase_SweepAndPrune.b2_maxProxies); // to change to a member variable
		
		public static const b2_nullPair:int = -1;
		public static const b2_nullProxy:int = -1;
		public static const b2_tableCapacity:int = b2_maxPairs;	// must be a power of two
		public static const b2_tableMask:int = b2_tableCapacity - 1;

	//public:
		//b2PairManager();

		//void Initialize(b2BroadPhase* broadPhase, b2PairCallback* callback);

		//void AddBufferedPair(int32 proxyId1, int32 proxyId2);
		//void RemoveBufferedPair(int32 proxyId1, int32 proxyId2);

		//void Commit();

	//private:
		//b2Pair* Find(int32 proxyId1, int32 proxyId2);
		//b2Pair* Find(int32 proxyId1, int32 proxyId2, uint32 hashValue);

		//b2Pair* AddPair(int32 proxyId1, int32 proxyId2);
		//void* RemovePair(int32 proxyId1, int32 proxyId2);

		//void ValidateBuffer();
		//void ValidateTable();

	//public:
		public var m_broadPhase:b2BroadPhase_SweepAndPrune;
		//b2PairCallback *m_callback;
		public var m_callback:b2BroadPhaseMonitor;
		//b2Pair m_pairs[b2_maxPairs];
		public var m_pairs:Array;
		//uint16 m_freePair;
		public var m_freePair:int;
		//int32 m_pairCount;
		public var m_pairCount:int;

		//b2BufferedPair m_pairBuffer[b2_maxPairs];
		public var m_pairBuffer:Array;
		//int32 m_pairBufferCount;
		public var m_pairBufferCount:int;

		//uint16 m_hashTable[b2_tableCapacity];
		public var m_hashTable:Array;
	} // class
} // package
//#endif
