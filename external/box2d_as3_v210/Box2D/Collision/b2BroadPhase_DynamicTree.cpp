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

//#include <Box2D/Collision/b2BroadPhase.h>
//#include <cstring>

public function b2BroadPhase_DynamicTree()
{
	var i:int;
	
	m_proxyCount = 0;

	m_pairCapacity = 16
	m_pairCount = 0;
	//m_pairBuffer = (b2Pair*)b2Alloc(m_pairCapacity * sizeof(b2Pair));

	m_pairBuffer = new Array (m_pairCapacity);
	for (i = 0; i < m_pairCapacity; ++ i)
	{
		m_pairBuffer [i] = new b2Pair ();
	}

	m_moveCapacity = 16;
	m_moveCount = 0;
	//m_moveBuffer = (int32*)b2Alloc(m_moveCapacity * sizeof(int32));
	m_moveBuffer = new Array (m_moveCapacity);
	//for (i = 0; i < m_moveCapacity; ++ i)
	//	m_moveBuffer [i] = int (e_nullProxy); 
}

//b2BroadPhase::~b2BroadPhase()
//b2BroadPhase::~b2BroadPhase()
public function _b2BroadPhase_DynamicTree ():void
{
	//b2Free(m_moveBuffer);
	//b2Free(m_pairBuffer);
}

override public function CreateProxy(aabb:b2AABB, userData:Object):int
{
	var proxyId:int = m_tree.CreateProxy(aabb, userData);
	++m_proxyCount;
	BufferMove(proxyId);
	return proxyId;
}

override public function DestroyProxy(proxyId:int):void
{
	UnBufferMove(proxyId);
	--m_proxyCount;
	m_tree.DestroyProxy(proxyId);
}

override public function MoveProxy(proxyId:int, aabb:b2AABB, displacement:b2Vec2):void
{
	var buffer:Boolean = m_tree.MoveProxy(proxyId, aabb, displacement);
	if (buffer)
	{
		BufferMove(proxyId);
	}
}

public function BufferMove(proxyId:int):void
{
	if (m_moveCount == m_moveCapacity)
	{
		//int32* oldBuffer = m_moveBuffer;
		//m_moveCapacity *= 2;
		//m_moveBuffer = (int32*)b2Alloc(m_moveCapacity * sizeof(int32));
		//memcpy(m_moveBuffer, oldBuffer, m_moveCount * sizeof(int32));
		//b2Free(oldBuffer);
		var oldCapacity:int = m_moveCapacity;
		m_moveCapacity *= 2;
		m_moveBuffer.length = m_moveCapacity;
		//for (var i:int = oldCapacity; i < m_moveCapacity; ++ i)
		//	m_moveBuffer [i] = int (e_nullProxy); 
	}

	m_moveBuffer[m_moveCount] = proxyId;
	++m_moveCount;
}

public function UnBufferMove(proxyId:int):void
{
	for (var i:int = 0; i < m_moveCount; ++i)
	{
		if (m_moveBuffer[i] == proxyId)
		{
			m_moveBuffer[i] = e_nullProxy;
			return;
		}
	}
}

// This is called from b2DynamicTree::Query when we are gathering pairs.
public function QueryCallback(proxyId:int):Boolean
{
	// A proxy cannot form a pair with itself.
	if (proxyId == m_queryProxyId)
	{
		return true;
	}

	// Grow the pair buffer as needed.
	if (m_pairCount == m_pairCapacity)
	{
		var oldCapacity:int = m_pairCapacity;
		m_pairCapacity *= 2;
		m_pairBuffer.length = m_pairCapacity;
		for (var i:int = oldCapacity; i < m_pairCapacity; ++ i)
		{
			m_pairBuffer [i] = new b2Pair ();
		}
	}

	var pair:b2Pair = m_pairBuffer[m_pairCount];
	pair.proxyIdA = Math.min (proxyId, m_queryProxyId);
	pair.proxyIdB = Math.max (proxyId, m_queryProxyId);
	++m_pairCount;
	
	return true;
}
