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

//#ifndef B2_SHAPE_H
//#define B2_SHAPE_H

package Box2D.Collision.Shapes
{
	//#include <Box2D/Common/b2BlockAllocator.h>
	//#include <Box2D/Common/b2Math.h>
	//#include <Box2D/Collision/b2Collision.h>
	
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Collision.b2RayCastInput;
	import Box2D.Collision.b2AABB;

	/// This holds the mass data computed for a shape.
	//struct b2MassData
	//{
		//@see b2MassData.as
	//};

	/// A shape is used for collision detection. You can create a shape however you like.
	/// Shapes used for simulation in b2World are created automatically when a b2Fixture
	/// is created.
	public class b2Shape
	{
	//public:
	
		//enum Type
		//{
			public static const e_unknown:int= -1;
			public static const e_circle:int = 0;
			public static const e_polygon:int = 1;
			public static const e_typeCount:int = 2;
		//};
		
		public function b2Shape() { m_type = e_unknown; }
		//virtual ~b2Shape() {}
		public function _b2Shape():void {}

		/// Clone the concrete shape using the provided allocator.
		//virtual b2Shape* Clone(b2BlockAllocator* allocator) const = 0;
		public function Clone(allocator:b2BlockAllocator = null):b2Shape {return null;}

		/// Get the type of this shape. You can use this to down cast to the concrete shape.
		/// @return the shape type.
		//Type GetType() const;

		/// Test a point for containment in this shape. This only works for convex shapes.
		/// @param xf the shape world transform.
		/// @param p a point in world coordinates.
		//virtual bool TestPoint(const b2Transform& xf, const b2Vec2& p) const = 0;
		public function TestPoint(xf:b2Transform, p:b2Vec2):Boolean {return false;}

		/// Cast a ray against this shape.
		/// @param output the ray-cast results.
		/// @param input the ray-cast input parameters.
		/// @param transform the transform to be applied to the shape.
		//virtual void RayCast(b2RayCastOutput* output, const b2RayCastInput& input, const b2Transform& transform) const = 0;
		public function RayCast(output:b2RayCastOutput, input:b2RayCastInput, transform:b2Transform):Boolean {return false;}

		/// Given a transform, compute the associated axis aligned bounding box for this shape.
		/// @param aabb returns the axis aligned box.
		/// @param xf the world transform of the shape.
		//virtual void ComputeAABB(b2AABB* aabb, const b2Transform& xf) const = 0;
		public function ComputeAABB(aabb:b2AABB, xf:b2Transform):void {}

		/// Compute the mass properties of this shape using its dimensions and density.
		/// The inertia tensor is computed about the local origin, not the centroid.
		/// @param massData returns the mass data for this shape.
		/// @param density the density in kilograms per meter squared.
		//virtual void ComputeMass(b2MassData* massData, float32 density) const = 0;
		public function ComputeMass(massData:b2MassData, density:Number):void {}
		
		//Type m_type;
		public var m_type:int;
		public var m_radius:Number;
	//};

		public function GetType():int
		{
			return m_type;
		}
		
//***********************************************************************
// hackings
//***********************************************************************
		
		// call by b2Body
		// this function should  NOT change the world position
		public function MoveLocalPosition (dx:Number, dy:Number):void
		{
			// to override
		}
		
	} // class
} // package
//#endif
