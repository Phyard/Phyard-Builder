/*
* Copyright (c) 2009 Erin Catto http://www.box2d.org
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
	node.leafCount = 0;
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
	node.leafCount = 1;

	InsertLeaf(proxyId);

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

private static var mParentAABB:b2AABB = new b2AABB ();

public function InsertLeaf(leaf:int):void
{
	++m_insertionCount;

	if (m_root == b2_nullNode)
	{
		m_root = leaf;
		m_nodes[m_root].parent = b2_nullNode;
		return;
	}

	// Find the best sibling for this node
	var newLeafNode:b2DynamicTreeNode = m_nodes[leaf] as b2DynamicTreeNode;
	var leafAABB:b2AABB = newLeafNode.aabb; // .Clone ();
	var sibling:int = m_root;
	var siblingNode:b2DynamicTreeNode = m_nodes[sibling] as b2DynamicTreeNode;
	while (siblingNode.IsLeaf() == false)
	{
		var child1:int = siblingNode.child1;
		var child2:int = siblingNode.child2;

		// Expand the node's AABB.
		siblingNode.aabb.Combine(leafAABB);
		siblingNode.leafCount += 1;

		var siblingArea:Number = siblingNode.aabb.GetPerimeter();
		var parentAABB:b2AABB = mParentAABB;
		parentAABB.CombineTwo(siblingNode.aabb, leafAABB);
		var parentArea:Number = parentAABB.GetPerimeter();
		var cost1:Number = 2.0 * parentArea;

		var inheritanceCost:Number = 2.0 * (parentArea - siblingArea);

		var oldArea:Number;
		var newArea:Number;

		var cost2:Number;
		var childNode1:b2DynamicTreeNode = m_nodes[child1] as b2DynamicTreeNode;
		if (childNode1.IsLeaf())
		{
			mTempAABB.CombineTwo(leafAABB, childNode1.aabb);
			cost2 = mTempAABB.GetPerimeter() + inheritanceCost;
		}
		else
		{
			mTempAABB.CombineTwo(leafAABB, childNode1.aabb);
			oldArea = childNode1.aabb.GetPerimeter();
			newArea = mTempAABB.GetPerimeter();
			cost2 = (newArea - oldArea) + inheritanceCost;
		}

		var cost3:Number;
		var childNode2:b2DynamicTreeNode = m_nodes[child2] as b2DynamicTreeNode;
		if (childNode2.IsLeaf())
		{
			mTempAABB.CombineTwo(leafAABB, childNode2.aabb);
			cost3 = mTempAABB.GetPerimeter() + inheritanceCost;
		}
		else
		{
			mTempAABB.CombineTwo(leafAABB, childNode2.aabb);
			oldArea = childNode2.aabb.GetPerimeter();
			newArea = mTempAABB.GetPerimeter();
			cost3 = newArea - oldArea + inheritanceCost;
		}

		// Descend according to the minimum cost.
		if (cost1 < cost2 && cost1 < cost3)
		{
			break;
		}

		// Expand the node's AABB to account for the new leaf.
		siblingNode.aabb.Combine(leafAABB);

		// Descend
		if (cost2 < cost3)
		{
			sibling = child1;
		}
		else
		{
			sibling = child2;
		}

		siblingNode = m_nodes[sibling] as b2DynamicTreeNode;
	}

	// Create a new parent for the siblings.
	var oldParent:Number = siblingNode.parent;
	var newParent:Number = AllocateNode();
	var newParentNode:b2DynamicTreeNode = m_nodes[newParent] as b2DynamicTreeNode;
	newParentNode.parent = oldParent;
	newParentNode.userData = null;
	newParentNode.aabb.CombineTwo(leafAABB, siblingNode.aabb);
	newParentNode.leafCount = siblingNode.leafCount + 1;

	if (oldParent != b2_nullNode)
	{
		// The sibling was not the root.
		var oldParentNode:b2DynamicTreeNode = m_nodes[oldParent] as b2DynamicTreeNode;
		if (oldParentNode.child1 == sibling)
		{
			oldParentNode.child1 = newParent;
		}
		else
		{
			oldParentNode.child2 = newParent;
		}

		newParentNode.child1 = sibling;
		newParentNode.child2 = leaf;
		siblingNode.parent = newParent;
		newLeafNode.parent = newParent;
	}
	else
	{
		// The sibling was the root.
		newParentNode.child1 = sibling;
		newParentNode.child2 = leaf;
		siblingNode.parent = newParent;
		newLeafNode.parent = newParent;
		m_root = newParent;
	}
}

public function RemoveLeaf(leaf:int):void
{
	if (leaf == m_root)
	{
		m_root = b2_nullNode;
		return;
	}

	var parent:int = (m_nodes[leaf] as b2DynamicTreeNode).parent;
	var nodeParent:b2DynamicTreeNode = m_nodes[parent] as b2DynamicTreeNode;
	var grandParent:int = nodeParent.parent;
	var sibling:int;
	if (nodeParent.child1 == leaf)
	{
		sibling = nodeParent.child2;
	}
	else
	{
		sibling = nodeParent.child1;
	}

	var nodeSibling:b2DynamicTreeNode = m_nodes[sibling] as b2DynamicTreeNode;
	if (grandParent != b2_nullNode)
	{
		// Destroy parent and connect sibling to grandParent.
		var nodeGrandParent:b2DynamicTreeNode = m_nodes[grandParent] as b2DynamicTreeNode;
		if (nodeGrandParent.child1 == parent)
		{
			nodeGrandParent.child1 = sibling;
		}
		else
		{
			nodeGrandParent.child2 = sibling;
		}
		nodeSibling.parent = grandParent;
		FreeNode(parent);

		// Adjust ancestor bounds.
		parent = grandParent;
		while (parent != b2_nullNode)
		{
			//b2AABB oldAABB = m_nodes[parent].aabb; // seems not used in c++
			nodeParent = m_nodes[parent] as b2DynamicTreeNode;
			nodeParent.aabb.CombineTwo((m_nodes[nodeParent.child1] as b2DynamicTreeNode).aabb, (m_nodes[nodeParent.child2] as b2DynamicTreeNode).aabb);

			//b2Assert(m_nodes[parent].leafCount > 0);
			nodeParent.leafCount -= 1;

			parent = nodeParent.parent;
		}
	}
	else
	{
		m_root = sibling;
		nodeSibling.parent = b2_nullNode;
		FreeNode(parent);
	}
}

public function Rebalance(iterations:int):void
{
	if (m_root == b2_nullNode)
	{
		return;
	}

	// Rebalance the tree by removing and re-inserting leaves.
	for (var i:int = 0; i < iterations; ++i)
	{
		var node:int = m_root;
		var treeNode:b2DynamicTreeNode = m_nodes[node] as b2DynamicTreeNode;

		var bit:uint = 0;
		while (treeNode.IsLeaf() == false)
		{
			//int32* children = &m_nodes[node].child1;
		//
		//	// Child selector based on a bit in the path
		//	int32 selector = (m_path >> bit) & 1;
		//
		//	// Select the child nod
		//	node = children[selector];
		//
		//	// Keep bit between 0 and 31 because m_path has 32 bits
		//	// bit = (bit + 1) % 31
		//	bit = (bit + 1) & 0x1F;

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

private function CountLeaves(nodeId:int):int
{
	if (nodeId == b2_nullNode)
	{
		return 0;
	}

	//b2Assert(0 <= nodeId && nodeId < m_nodeCapacity);
	var node:b2DynamicTreeNode = m_nodes [nodeId];

	if (node.IsLeaf())
	{
		//b2Assert(node->leafCount == 1);
		return 1;
	}

	var count1:int = CountLeaves(node.child1);
	var count2:int = CountLeaves(node.child2);
	var count:int = count1 + count2;
	//b2Assert(count == node->leafCount);
	return count;
}

public function Validate():void
{
	CountLeaves(m_root);
}
