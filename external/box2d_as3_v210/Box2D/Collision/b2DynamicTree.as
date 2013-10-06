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

//#ifndef B2_DYNAMIC_TREE_H
//#define B2_DYNAMIC_TREE_H

package Box2D.Collision
{
	//#include <Box2D/Collision/b2Collision.h>
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Settings;
	//import Box2D.Common.b2GrowableStack;

	/// A dynamic AABB tree broad-phase, inspired by Nathanael Presson's btDbvt.

	// moved into b2Collision class
	//#define b2_nullNode (-1)

	/// A node in the dynamic tree. The client does not interact with this directly.
	//struct b2DynamicTreeNode
	//{
		//@see b2DynamicTreeNode.as
	//};

	/// A dynamic tree arranges data in a binary tree to accelerate
	/// queries such as volume queries and ray casts. Leafs are proxies
	/// with an AABB. In the tree we expand the proxy AABB by b2_fatAABBFactor
	/// so that the proxy AABB is bigger than the client object. This allows the client
	/// object to move by small amounts without triggering a tree update.
	///
	/// Nodes are pooled and relocatable, so we use node indices rather than pointers.
	public class b2DynamicTree
	{
		include "b2DynamicTree.cpp";

		public static const b2_nullNode:int = -1;

	//public:

		/// Constructing the tree initializes the node pool.
		//b2DynamicTree();

		/// Destroy the tree, freeing the node pool.
		//~b2DynamicTree();

		/// Create a proxy. Provide a tight fitting AABB and a userData pointer.
		//int32 CreateProxy(const b2AABB& aabb, void* userData);

		/// Destroy a proxy. This asserts if the id is invalid.
		//void DestroyProxy(int32 proxyId);

		/// Move a proxy with a swepted AABB. If the proxy has moved outside of its fattened AABB,
		/// then the proxy is removed from the tree and re-inserted. Otherwise
		/// the function returns immediately.
		/// @return true if the proxy was re-inserted.
		//bool MoveProxy(int32 proxyId, const b2AABB& aabb1, const b2Vec2& displacement);

		/// Perform some iterations to re-balance the tree.
		//void Rebalance(int32 iterations);

		/// Get proxy user data.
		/// @return the proxy user data or 0 if the id is invalid.
		//void* GetUserData(int32 proxyId) const;

		/// Get the fat AABB for a proxy.
		//const b2AABB& GetFatAABB(int32 proxyId) const;

		/// Compute the height of the binary tree in O(N) time. Should not be
		/// called often.
		//int32 ComputeHeight() const;

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

		//void Validate() const;

	//private:

		//int32 AllocateNode();
		//void FreeNode(int32 node);

		//void InsertLeaf(int32 node);
		//void RemoveLeaf(int32 node);

		//int32 ComputeHeight(int32 nodeId) const;

		//int32 CountLeaves(int32 nodeId) const;

		private var m_root:int;

		private var m_nodes:Array; // b2DynamicTreeNode*;
		private var m_nodeCount:int;
		private var m_nodeCapacity:int;

		private var m_freeList:int;

		/// This is used incrementally traverse the tree for re-balancing.
		private var m_path:uint;

		private var m_insertionCount:int;
	//};

	//inline

		public function GetUserData(proxyId:int):Object
		{
			//b2Assert(0 <= proxyId && proxyId < m_nodeCapacity);
			return (m_nodes[proxyId] as b2DynamicTreeNode).userData;
		}

		public function GetFatAABB(proxyId:int):b2AABB
		{
			//b2Assert(0 <= proxyId && proxyId < m_nodeCapacity);
			return (m_nodes[proxyId] as b2DynamicTreeNode).aabb;
		}

		//template <typename T>
		//inline void b2DynamicTree::Query(T* callback, const b2AABB& aabb) const
		public function Query(callback:b2QueryCallbackOwner, aabb:b2AABB):void
		{
			//b2GrowableStack<int32, 256> stack;
         //var stack:b2GrowableStack = new b2GrowableStack (256); // bug!!!, crash on iOS. Ill on PC.
         //var stack:b2GrowableStack = new b2GrowableStack (0); // Still crash on iOS
                                                   // [update] see the comment in b2GrowableStack.as to check why the crash. 
         var stack:Array = new Array ();
			stack.push(m_root);

         //while (stack.GetCount() > 0)
         while (stack.length > 0)
			{
				var nodeId:int = int (stack.pop());
				if (nodeId == b2_nullNode)
				{
					continue;
				}

				//const b2DynamicTreeNode* node = m_nodes + nodeId;
				const node:b2DynamicTreeNode = m_nodes [nodeId];

				if (b2Collision.b2TestOverlap(node.aabb, aabb))
				{
					if (node.IsLeaf())
					{
						var proceed:Boolean = callback.QueryCallback(nodeId);
						if (proceed == false)
						{
							return;
						}
					}
					else
					{
						stack.push(node.child1);
						stack.push(node.child2);
					}
				}
			}
		}

		//template <typename T>
		//inline void b2DynamicTree::RayCast(T* callback, const b2RayCastInput& input) const
		public function RayCast(callback:b2RayCastCallbackOwner, input:b2RayCastInput):void
		{
			//b2Vec2 p1 = input.p1;
			//b2Vec2 p2 = input.p2;
			//b2Vec2 r = p2 - p1;
			var p1:b2Vec2 = input.p1; //.Clone ()
			var p2:b2Vec2 = input.p2; //.Clone ()
			var r:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (p2.x - p1.x, p2.y - p1.y);
			//b2Assert(r.LengthSquared() > 0.0f);
			r.Normalize();

			// v is perpendicular to the segment.
			//b2Vec2 v = b2Math.b2Cross2(1.0f, r);
			//b2Vec2 abs_v = b2Abs(v);
			var v:b2Vec2 = b2Math.b2Cross_ScalarAndVector2 (1.0, r);
			var abs_v:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (v.x >= 0 ? v.x : -v.x, v.y >= 0 ? v.y : -v.y);

			// Separating axis for segment (Gino, p80).
			// |dot(v, p1 - c)| > dot(|v|, h)

			var maxFraction:Number = input.maxFraction;

			// Build a bounding box for the segment.
			var segmentAABB:b2AABB = new b2AABB ();
			//{
				//b2Vec2 t = p1 + maxFraction * (p2 - p1);
				//segmentAABB.lowerBound = b2Min(p1, t);
				//segmentAABB.upperBound = b2Max(p1, t);
				var t1:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (p1.x + maxFraction * (p2.x - p1.x), p1.y + maxFraction * (p2.y - p1.y));
				segmentAABB.lowerBound.Set (p1.x < t1.x ? p1.x : t1.x, p1.y < t1.y ? p1.y : t1.y);
				segmentAABB.upperBound.Set (p1.x > t1.x ? p1.x : t1.x, p1.y > t1.y ? p1.y : t1.y);
			//}

			//b2GrowableStack<int32, 256> stack;
         //var stack:b2GrowableStack = new b2GrowableStack (256); // bug!!!, crash on iOS. Ill on PC.
         //var stack:b2GrowableStack = new b2GrowableStack (0); // Still crash on iOS
         var stack:Array = new Array ();
			stack.push(m_root);

         //while (stack.GetCount() > 0)
         while (stack.length > 0)
			{
				var nodeId:int = int (stack.pop());
				if (nodeId == b2_nullNode)
				{
					continue;
				}

				//const b2DynamicTreeNode* node = m_nodes + nodeId;
				var node:b2DynamicTreeNode = m_nodes [nodeId];

				if (b2Collision.b2TestOverlap(node.aabb, segmentAABB) == false)
				{
					continue;
				}

				// Separating axis for segment (Gino, p80).
				// |dot(v, p1 - c)| > dot(|v|, h)
				var c:b2Vec2 = node.aabb.GetCenter(); //.Clone ()
				var h:b2Vec2 = node.aabb.GetExtents(); //.Clone ()
				var separation:Number = Math.abs (b2Math.b2Dot2(v, b2Math.b2Subtract_Vector2 (p1, c))) - b2Math.b2Dot2(abs_v, h);
				if (separation > 0.0)
				{
					continue;
				}

				if (node.IsLeaf())
				{
					var subInput:b2RayCastInput = new b2RayCastInput ();
					subInput.p1.CopyFrom (input.p1);
					subInput.p2.CopyFrom (input.p2);
					subInput.maxFraction = maxFraction;

					var value:Number = callback.RayCastCallback(subInput, nodeId);

					if (value == 0.0)
					{
						// The client has terminated the ray cast.
						return;
					}

					if (value > 0.0)
					{
						// Update segment bounding box.
						maxFraction = value;
						//b2Vec2 t = p1 + maxFraction * (p2 - p1);
						//segmentAABB.lowerBound = b2Min(p1, t);
						//segmentAABB.upperBound = b2Max(p1, t);
						var t2:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (p1.x + maxFraction * (p2.x - p1.x), p1.y + maxFraction * (p2.y - p1.y));
						segmentAABB.lowerBound.Set (p1.x < t2.x ? p1.x : t2.x, p1.y < t2.y ? p1.y : t2.y);
						segmentAABB.upperBound.Set (p1.x > t2.x ? p1.x : t2.x, p1.y > t2.y ? p1.y : t2.y);
					}
				}
				else
				{
					stack.push(node.child1);
					stack.push(node.child2);
				}
			}
		}
	} // class
} // package
//#endif
