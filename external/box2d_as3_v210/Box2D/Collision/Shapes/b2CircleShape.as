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

//#ifndef B2_CIRCLE_SHAPE_H
//#define B2_CIRCLE_SHAPE_H

package Box2D.Collision.Shapes
{
	//#include <Box2D/Collision/Shapes/b2Shape.h>
	
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Collision.b2RayCastInput;

	/// A circle shape.
	public class b2CircleShape extends b2Shape
	{
		include "b2CircleShape.cpp";
		
	//public:
		//b2CircleShape();

		/// Implement b2Shape.
		//b2Shape* Clone(b2BlockAllocator* allocator) const;

		/// Implement b2Shape.
		//bool TestPoint(const b2Transform& transform, const b2Vec2& p) const;

		/// Implement b2Shape.
		//bool RayCast(b2RayCastOutput* output, const b2RayCastInput& input, const b2Transform& transform) const;

		/// @see b2Shape::ComputeAABB
		//void ComputeAABB(b2AABB* aabb, const b2Transform& transform) const;

		/// @see b2Shape::ComputeMass
		//void ComputeMass(b2MassData* massData, float32 density) const;

		/// Get the supporting vertex index in the given direction.
		//int32 GetSupport(const b2Vec2& d) const;

		/// Get the supporting vertex in the given direction.
		//const b2Vec2& GetSupportVertex(const b2Vec2& d) const;

		/// Get the vertex count.
		//int32 GetVertexCount() const { return 1; }

		/// Get a vertex by index. Used by b2Distance.
		//const b2Vec2& GetVertex(int32 index) const;

		/// Position
		public var m_p:b2Vec2 = new b2Vec2 ();
	//};
	// inline

		public function b2CircleShape()
		{
			m_type = e_circle;
			m_radius = 0.0;
			m_p.SetZero();
		}

		public function GetSupport(d:b2Vec2):int
		{
			//B2_NOT_USED(d);
			return 0;
		}

		public function GetSupportVertex(d:b2Vec2):b2Vec2
		{
			//B2_NOT_USED(d);
			return m_p;
		}

		public function GetVertex(index:int):b2Vec2
		{
			//B2_NOT_USED(index);
			//b2Assert(index == 0);
			//return m_p;
			return m_p.Clone ();
		}
		
//***********************************************************************
// hackings
//***********************************************************************
		
		// call by b2Body
		// this function should  NOT change the world position
		override public function MoveLocalPosition (dx:Number, dy:Number):void
		{
			m_p.x += dx;
			m_p.y += dy;
		}
		
	} // class
} // package
//#endif
