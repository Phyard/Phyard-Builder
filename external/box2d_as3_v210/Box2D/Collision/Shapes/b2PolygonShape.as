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

//#ifndef B2_POLYGON_SHAPE_H
//#define B2_POLYGON_SHAPE_H

package Box2D.Collision.Shapes
{
	//#include <Box2D/Collision/Shapes/b2Shape.h>
	
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Mat22;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Collision.b2RayCastInput;

	/// A convex polygon. It is assumed that the interior of the polygon is to
	/// the left of each edge.
	public class b2PolygonShape extends b2Shape
	{
		include "b2PolygonShape.cpp";
		
	//public:
		//b2PolygonShape();

		/// Implement b2Shape.
		//b2Shape* Clone(b2BlockAllocator* allocator) const;

		/// Copy vertices. This assumes the vertices define a convex polygon.
		/// It is assumed that the exterior is the the right of each edge.
		//void Set(const b2Vec2* vertices, int32 vertexCount);

		/// Build vertices to represent an axis-aligned box.
		/// @param hx the half-width.
		/// @param hy the half-height.
		//void SetAsBox(float32 hx, float32 hy);

		/// Build vertices to represent an oriented box.
		/// @param hx the half-width.
		/// @param hy the half-height.
		/// @param center the center of the box in local coordinates.
		/// @param angle the rotation of the box in local coordinates.
		//void SetAsBox(float32 hx, float32 hy, const b2Vec2& center, float32 angle);

		/// Set this as a single edge.
		//void SetAsEdge(const b2Vec2& v1, const b2Vec2& v2);

		/// @see b2Shape::TestPoint
		//bool TestPoint(const b2Transform& transform, const b2Vec2& p) const;

		/// Implement b2Shape.
		//void RayCast(b2RayCastOutput* output, const b2RayCastInput& input, const b2Transform& transform) const;

		/// @see b2Shape::ComputeAABB
		//void ComputeAABB(b2AABB* aabb, const b2Transform& transform) const;

		/// @see b2Shape::ComputeMass
		//void ComputeMass(b2MassData* massData, float32 density) const;

		/// Get the supporting vertex index in the given direction.
		//int32 GetSupport(const b2Vec2& d) const;

		/// Get the supporting vertex in the given direction.
		//const b2Vec2& GetSupportVertex(const b2Vec2& d) const;

		/// Get the vertex count.
		//int32 GetVertexCount() const { return m_vertexCount; }

		/// Get a vertex by index.
		//const b2Vec2& GetVertex(int32 index) const;

		public var m_centroid:b2Vec2 = new b2Vec2 ();
		public var m_vertices:Array = new Array (b2Settings.b2_maxPolygonVertices);
		public var m_normals:Array = new Array (b2Settings.b2_maxPolygonVertices);
		public var m_vertexCount:int;
	//};

	// inline

		public function b2PolygonShape()
		{
			for (var i:int = 0; i < b2Settings.b2_maxPolygonVertices; ++ i)
			{
				m_vertices [i] = new b2Vec2 ();
				m_normals  [i] = new b2Vec2 ();
			}
			
			m_type = e_polygon;
			m_radius = b2Settings.b2_polygonRadius;
			m_vertexCount = 0;
			m_centroid.SetZero();
		}

		public function GetSupport(d:b2Vec2):int
		{
			var bestIndex:int = 0;
			var bestValue:Number = b2Math.b2Dot2 (m_vertices[0], d);
			for (var i:int = 1; i < m_vertexCount; ++i)
			{
				var value:Number = b2Math.b2Dot2 (m_vertices[i], d);
				if (value > bestValue)
				{
					bestIndex = i;
					bestValue = value;
				}
			}

			return bestIndex;
		}

		public function GetSupportVertex(d:b2Vec2):b2Vec2
		{
			var bestIndex:int = 0;
			var bestValue:Number = b2Math.b2Dot2 (m_vertices[0], d);
			for (var i:int = 1; i < m_vertexCount; ++i)
			{
				var value:Number = b2Math.b2Dot2 (m_vertices[i], d);
				if (value > bestValue)
				{
					bestIndex = i;
					bestValue = value;
				}
			}

			return (m_vertices[bestIndex] as b2Vec2).Clone ();
		}

		public function GetVertex(index:int):b2Vec2
		{
			//b2Assert(0 <= index && index < m_vertexCount);
			return (m_vertices[index] as b2Vec2).Clone ();
		}
		
//***********************************************************************
// hackings
//***********************************************************************
		
		// call by b2Body
		// this function should  NOT change the world position
		override public function MoveLocalPosition (dx:Number, dy:Number):void
		{
			m_centroid.x += dx;
			m_centroid.y += dy;
			
			for (var i:int = 0; i < m_vertexCount; ++ i)
			{
				var vertex:b2Vec2 = m_vertices [i];
				vertex.x += dx;
				vertex.y += dy;
			}
		}
		
	} // class
} // package
//#endif
