/*
* Copyright (c) 2006-2010 Erin Catto http://www.gphysics.com
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

//#ifndef B2_TOI_SOLVER_H
//#define B2_TOI_SOLVER_H

package Box2D.Dynamics.Contacts
{
	//#include <Box2D/Common/b2Math.h>

	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2StackAllocator;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2ManifoldPoint;
	import Box2D.Collision.Shapes.b2Shape;

	//class b2Contact;
	//class b2Body;
	//struct b2TOIConstraint;
	//class b2StackAllocator;

	/// This is a pure position solver for a single movable body in contact with
	/// multiple non-moving bodies.
	public class b2TOISolver
	{
		include "b2TOISolver.cpp";
		
	//public:
		//b2TOISolver(b2StackAllocator* allocator);
		//~b2TOISolver();

		//void Initialize(b2Contact** contacts, int32 contactCount, b2Body* toiBody);
		//void Clear();

		// Perform one solver iteration. Returns true if converged.
		//bool Solve(float32 baumgarte);

	//private:

		//b2TOIConstraint* m_constraints;
		private var m_constraints:Array = null;
		private var m_count:int;
		private var m_toiBody:b2Body;
		private var m_allocator:b2StackAllocator;
	}
}
//#endif
