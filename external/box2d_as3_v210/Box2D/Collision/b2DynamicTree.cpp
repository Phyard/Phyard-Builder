/*
* Copyright (c) 2009 Erin Catto http://www.gphysics.com
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

//#include <Box2D/Collision/b2DynamicTree.h>
//#include <cstring>
//#include <cfloat>

public function b2DynamicTree()
{
	m_root = b2_nullNode;

	m_nodeCapacity = 16;
	m_nodeCount = 0;
	//m_nodes = (b2DynamicTreeNode*)b2Alloc(m_nodeCapacity * sizeof(b2DynamicTreeNode));
	//memset(m_nodes, 0, m_nodeCapacity * sizeof(b2DynamicTreeNode));
	m_nodes = new Array (m_nodeCapacity);
	var i:int;
	for (i = 0; i < m_nodeCapacity; ++ i)
	{
		m_nodes [i] = new b2DynamicTreeNode ();
	}

	// Build a linked list for the free list.
	for (i = 0; i < m_nodeCapacity - 1; ++i)
	{
		(m_nodes[i] as b2DynamicTreeNode).next = i + 1;
	}
	(m_nodes[m_nodeCapacity-1] as b2DynamicTreeNode).next = b2_nullNode;
	m_freeList = 0;

	m_path = 0;

	m_insertionCount = 0;
}

//b2DynamicTree::~b2DynamicTree()
public function Destructor ():void
{
	// This frees the entire tree in one shot.
	//b2Free(m_nodes);
}

// Allocate a node from the pool. Grow the pool if necessary.
public function AllocateNode():int
{
	// Expand the node pool as needed.
	if (m_freeList == b2_nullNode)
	{
		//b2Assert(m_nodeCount == m_nodeCapacity);

		// The free list is empty. Rebuild a bigger pool.
		//b2DynamicTreeNode* oldNodes = m_nodes;
		//m_nodeCapacity *= 2;
		//m_nodes = (b2DynamicTreeNode*)b2Alloc(m_nodeCapacity * sizeof(b2DynamicTreeNode));
		//memcpy(m_nodes, oldNodes, m_nodeCount * sizeof(b2DynamicTreeNode));
		//b2Free(oldNodes);
		var oldCapacity:int = m_nodeCapacity;
		m_nodeCapacity *= 2;
		m_nodes.length = m_nodeCapacity;
		var i:int;
		for (i = oldCapacity; i < m_nodeCapacity; ++ i)
		{
			m_nodes [i] = new b2DynamicTreeNode ();
		}

		// Build a linked list for the free list. The parent
		// pointer becomes the "next" pointer.
		for (i = m_nodeCount; i < m_nodeCapacity - 1; ++i)
		{
			(m_nodes[i] as b2DynamicTreeNode).next = i + 1;
		}
		(m_nodes[m_nodeCapacity-1] as b2DynamicTreeNode).next = b2_nullNode;
		m_freeList = m_nodeCount;
	}

	// Peel a node off the free list.
	var nodeId:int = m_freeList;
	m_freeList = (m_nodes[nodeId] as b2DynamicTreeNode).next;
	var node:b2DynamicTreeNode = m_nodes[nodeId] as b2DynamicTreeNode;
	node.parent = b2_nullNode;
	node.child1 = b2_nullNode;
	node.child2 = b2_nullNode;
	++m_nodeCount;
	return nodeId;
}

// Return a node to the pool.
public function FreeNode(nodeId:int):void
{
	//b2Assert(0 <= nodeId && nodeId < m_nodeCapacity);
	//b2Assert(0 < m_nodeCount);
	(m_nodes[nodeId] as b2DynamicTreeNode).next = m_freeList;
	m_freeList = nodeId;
	--m_nodeCount;
}

// Create a proxy in the tree as a leaf node. We return the index
// of the node instead of a pointer so that we can grow
// the node pool.
public function CreateProxy(aabb:b2AABB, userData:Object):int
{
	var proxyId:int = AllocateNode();

	// Fatten the aabb.
	//b2Vec2 r(b2_aabbExtension, b2_aabbExtension);
	//m_nodes[proxyId].aabb.lowerBound = aabb.lowerBound - r;
	//m_nodes[proxyId].aabb.upperBound = aabb.upperBound + r;
	//m_nodes[proxyId].userData = userData;
	var node:b2DynamicTreeNode = m_nodes[proxyId] as b2DynamicTreeNode;
	node.aabb.lowerBound.x = aabb.lowerBound.x - b2Settings.b2_aabbExtension;
	node.aabb.lowerBound.y = aabb.lowerBound.y - b2Settings.b2_aabbExtension;
	node.aabb.upperBound.x = aabb.upperBound.x + b2Settings.b2_aabbExtension;
	node.aabb.upperBound.y = aabb.upperBound.y + b2Settings.b2_aabbExtension;
	node.userData = userData;

	InsertLeaf(proxyId);

	// Rebalance if necessary.
	var iterationCount:int = m_nodeCount >> 4;
	var tryCount:int = 0;
	var height:int = ComputeTreeHeight();
	while (height > 64 && tryCount < 10)
	{
		Rebalance(iterationCount);
		height = ComputeTreeHeight();
		++tryCount;
	}

	return proxyId;
}

public function DestroyProxy(proxyId:int):void
{
	//b2Assert(0 <= proxyId && proxyId < m_nodeCapacity);
	//b2Assert(m_nodes[proxyId].IsLeaf());

	RemoveLeaf(proxyId);
	FreeNode(proxyId);
}

private static var mTempAABB:b2AABB = new b2AABB ();
private static var mTempVec2:b2Vec2 = new b2Vec2 ();
private static var delta1:b2Vec2 = new b2Vec2 ();
private static var delta2:b2Vec2 = new b2Vec2 ();
private static var center:b2Vec2 = new b2Vec2 ();
private static var center1:b2Vec2 = new b2Vec2 ();
private static var center2:b2Vec2 = new b2Vec2 ();

public function MoveProxy(proxyId:int, aabb:b2AABB, displacement:b2Vec2):Boolean
{
	//b2Assert(0 <= proxyId && proxyId < m_nodeCapacity);

	//b2Assert(m_nodes[proxyId].IsLeaf());

	if ((m_nodes[proxyId] as b2DynamicTreeNode).aabb.Contains(aabb))
	{
		return false;
	}

	RemoveLeaf(proxyId);

	// Extend AABB.
	//b2AABB b = aabb;
	//b2Vec2 r(b2_aabbExtension, b2_aabbExtension);
	//b.lowerBound = b.lowerBound - r;
	//b.upperBound = b.upperBound + r;
	//var b:b2AABB = new b2AABB (); // aabb.Clone ();
	var b:b2AABB = mTempAABB;
	b.lowerBound.x = aabb.lowerBound.x - b2Settings.b2_aabbExtension;
	b.lowerBound.y = aabb.lowerBound.y - b2Settings.b2_aabbExtension;
	b.upperBound.x = aabb.upperBound.x + b2Settings.b2_aabbExtension;
	b.upperBound.y = aabb.upperBound.y + b2Settings.b2_aabbExtension;

	// Predict AABB displacement.
	//b2Vec2 d = b2_aabbMultiplier * displacement;
	var d:b2Vec2 = mTempVec2; //new b2Vec2 ();
	d.x = b2Settings.b2_aabbMultiplier * displacement.x;
	d.y = b2Settings.b2_aabbMultiplier * displacement.y;

	if (d.x < 0.0)
	{
		b.lowerBound.x += d.x;
	}
	else
	{
		b.upperBound.x += d.x;
	}

	if (d.y < 0.0)
	{
		b.lowerBound.y += d.y;
	}
	else
	{
		b.upperBound.y += d.y;
	}

	//m_nodes[proxyId].aabb = b;
	(m_nodes[proxyId] as b2DynamicTreeNode).aabb.CopyFrom (b); // maybe reference is also ok

	InsertLeaf(proxyId);
	return true;
}

public function InsertLeaf(leaf:int):void
{
	++m_insertionCount;

	if (m_root == b2_nullNode)
	{
		m_root = leaf;
		(m_nodes[m_root] as b2DynamicTreeNode).parent = b2_nullNode;
		return;
	}

	var node:b2DynamicTreeNode;

	// Find the best sibling for this node.
	(m_nodes[leaf] as b2DynamicTreeNode).aabb.GetCenter_Output (center);
	var sibling:int = m_root;
	if ((m_nodes[sibling] as b2DynamicTreeNode).IsLeaf() == false)
	{
		//var delta1:b2Vec2 = new b2Vec2 ();
		//var delta2:b2Vec2 = new b2Vec2 ();
		do 
		{
			node = m_nodes[sibling] as b2DynamicTreeNode;
			var child1:int = node.child1;
			var child2:int = node.child2;

			//b2Vec2 delta1 = b2Abs(m_nodes[child1].aabb.GetCenter() - center);
			//b2Vec2 delta2 = b2Abs(m_nodes[child2].aabb.GetCenter() - center);
			(m_nodes[child1] as b2DynamicTreeNode).aabb.GetCenter_Output (center1);
			b2Math.b2Subtract_Vector2_Output (center1, center, delta1);
			b2Math.b2Abs_Vector2_Self (delta1);
			(m_nodes[child2] as b2DynamicTreeNode).aabb.GetCenter_Output (center2);
			b2Math.b2Subtract_Vector2_Output (center2, center, delta2);
			b2Math.b2Abs_Vector2_Self (delta2);

			var norm1:Number = delta1.x + delta1.y;
			var norm2:Number = delta2.x + delta2.y;

			if (norm1 < norm2)
			{
				sibling = child1;
			}
			else
			{
				sibling = child2;
			}

		}
		while((m_nodes[sibling] as b2DynamicTreeNode).IsLeaf() == false);
	}

	// Create a parent for the siblings.
	var node1:int = (m_nodes[sibling] as b2DynamicTreeNode).parent;
	var node2:int = AllocateNode();
	node = m_nodes[node2] as b2DynamicTreeNode;
	node.parent = node1;
	node.userData = null;
	node.aabb.Combine((m_nodes[leaf] as b2DynamicTreeNode).aabb, (m_nodes[sibling] as b2DynamicTreeNode).aabb);

	if (node1 != b2_nullNode)
	{
		if ((m_nodes[(m_nodes[sibling] as b2DynamicTreeNode).parent] as b2DynamicTreeNode).child1 == sibling)
		{
			(m_nodes[node1] as b2DynamicTreeNode).child1 = node2;
		}
		else
		{
			(m_nodes[node1] as b2DynamicTreeNode).child2 = node2;
		}
		
		node = m_nodes[node2] as b2DynamicTreeNode
		node.child1 = sibling;
		node.child2 = leaf;
		(m_nodes[sibling] as b2DynamicTreeNode).parent = node2;
		(m_nodes[leaf] as b2DynamicTreeNode).parent = node2;

		var node_a:b2DynamicTreeNode;
		var node_b:b2DynamicTreeNode = node; // m_nodes[node2]
		do 
		{
			node_a = m_nodes[node1] as b2DynamicTreeNode;
			
			if (node_a.aabb.Contains(node_b.aabb))
			{
				break;
			}

			node_a.aabb.Combine((m_nodes[node_a.child1] as b2DynamicTreeNode).aabb, (m_nodes[node_a.child2] as b2DynamicTreeNode).aabb);
			//node2 = node1;
			node_b = node_a;
			node1 = node_a.parent;
		}
		while(node1 != b2_nullNode);
	}
	else
	{
		node = m_nodes[node2] as b2DynamicTreeNode;
		node.child1 = sibling;
		node.child2 = leaf;
		(m_nodes[sibling] as b2DynamicTreeNode).parent = node2;
		(m_nodes[leaf] as b2DynamicTreeNode).parent = node2;
		m_root = node2;
	}
}

public function RemoveLeaf(leaf:int):void
{
	if (leaf == m_root)
	{
		m_root = b2_nullNode;
		return;
	}
	
	var node:b2DynamicTreeNode;

	var node2:int = (m_nodes[leaf] as b2DynamicTreeNode).parent;
	node = m_nodes[node2] as b2DynamicTreeNode;
	var node1:int = node.parent;
	var sibling:int;
	if (node.child1 == leaf)
	{
		sibling = node.child2;
	}
	else
	{
		sibling = node.child1;
	}

	if (node1 != b2_nullNode)
	{
		// Destroy node2 and connect node1 to sibling.
		node = m_nodes[node1] as b2DynamicTreeNode;
		if (node.child1 == node2)
		{
			node.child1 = sibling;
		}
		else
		{
			node.child2 = sibling;
		}
		(m_nodes[sibling] as b2DynamicTreeNode).parent = node1;
		FreeNode(node2);

		// Adjust ancestor bounds.
		var oldAABB:b2AABB = new b2AABB ();
		while (node1 != b2_nullNode)
		{
			node = m_nodes[node1] as b2DynamicTreeNode;
			
			oldAABB.CopyFrom (node.aabb);
			node.aabb.Combine((m_nodes[node.child1] as b2DynamicTreeNode).aabb, (m_nodes[node.child2] as b2DynamicTreeNode).aabb);

			if (oldAABB.Contains(node.aabb))
			{
				break;
			}

			node1 = node.parent;
		}
	}
	else
	{
		m_root = sibling;
		(m_nodes[sibling] as b2DynamicTreeNode).parent = b2_nullNode;
		FreeNode(node2);
	}
}

public function Rebalance(iterations:int):void
{
	if (m_root == b2_nullNode)
	{
		return;
	}

	for (var i:int = 0; i < iterations; ++i)
	{
		var node:int = m_root;
		var treeNode:b2DynamicTreeNode = m_nodes[node] as b2DynamicTreeNode;

		var bit:uint = 0;
		while (treeNode.IsLeaf() == false)
		{
			//int32* children = &m_nodes[node].child1;
			//node = children[(m_path >> bit) & 1];
			//bit = (bit + 1) & (8* sizeof(uint32) - 1);
			node = ((m_path >> bit) & 1) == 0 ? treeNode.child1 : treeNode.child2;
			treeNode = m_nodes[node] as b2DynamicTreeNode;
			bit = (bit + 1) & 31;
		}
		++m_path;

		RemoveLeaf(node);
		InsertLeaf(node);
	}
}

// Compute the height of a sub-tree.
public function ComputeHeight(nodeId:Number):int
{
	if (nodeId == b2_nullNode)
	{
		return 0;
	}

	//b2Assert(0 <= nodeId && nodeId < m_nodeCapacity);
	//b2DynamicTreeNode* node = m_nodes + nodeId;
	var node:b2DynamicTreeNode = m_nodes [nodeId] as b2DynamicTreeNode;
	var height1:int = ComputeHeight(node.child1);
	var height2:int = ComputeHeight(node.child2);
	return 1 + (height1 > height2 ? height1 : height2);
}

//public function ComputeHeight():int
public function ComputeTreeHeight():int
{
	return ComputeHeight(m_root);
}
