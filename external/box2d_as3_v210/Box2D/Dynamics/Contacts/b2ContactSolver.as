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

//#ifndef B2_CONTACT_SOLVER_H
//#define B2_CONTACT_SOLVER_H

package Box2D.Dynamics.Contacts
{
	//#include <Box2D/Common/b2Math.h>
	//#include <Box2D/Collision/b2Collision.h>
	//#include <Box2D/Dynamics/b2Island.h>

	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2StackAllocator;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Collision.b2ManifoldPoint;

	//class b2Contact;
	//class b2Body;
	//class b2Island;
	//class b2StackAllocator;

	//struct b2ContactConstraintPoint
	//{
		//@see b2ContactConstraintPoint.cpp
	//};

	//struct b2ContactConstraint
	//{
		//@see b2ContactConstraint.cpp
	//};

	public class b2ContactSolver
	{
		include "b2ContactSolver.cpp";
		
	//public:
		//b2ContactSolver(const b2TimeStep& step, b2Contact** contacts, int32 contactCount, b2StackAllocator* allocator);
		//~b2ContactSolver();

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints();
		//void FinalizeVelocityConstraints();

		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_step:b2TimeStep = new b2TimeStep ();
		public var m_allocator:b2StackAllocator;
		//b2ContactConstraint* m_constraints;
		public var m_constraints:Array = m_ConstraintsArray;
		public var m_constraintCount:int = 0;
	} // class
} // package
//#endif
