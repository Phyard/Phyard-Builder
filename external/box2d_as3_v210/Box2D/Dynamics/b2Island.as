/*
* Copyright (c) 2006-2009 Erin Catto http://www.box2d.org
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

//#ifndef B2_ISLAND_H
//#define B2_ISLAND_H

package Box2D.Dynamics
{
	//#include <Box2D/Common/b2Math.h>
	//#include <Box2D/Dynamics/b2Body.h>
	//#include <Box2D/Dynamics/b2TimeStep.h>

	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Sweep;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2StackAllocator;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactConstraint;
	import Box2D.Dynamics.Contacts.b2ContactConstraintPoint;
	import Box2D.Dynamics.Contacts.b2ContactSolver;
	import Box2D.Dynamics.Contacts.b2ContactSolverDef;
	import Box2D.Dynamics.Joints.b2Joint;

	//class b2Contact;
	//class b2Joint;
	//class b2StackAllocator;
	//class b2ContactListener;
	//struct b2ContactConstraint;

	// the 2 structures seem not used. ?

	/// This is an internal structure.
	//struct b2Position
	//{
	//	b2Vec2 x;
	//	float32 a;
	//};

	/// This is an internal structure.
	//struct b2Velocity
	//{
	//	b2Vec2 v;
	//	float32 w;
	//};

	/// This is an internal class.
	public class b2Island
	{
		include "b2Island.cpp";

	//public:
		//b2Island(int32 bodyCapacity, int32 contactCapacity, int32 jointCapacity,
		//		b2StackAllocator* allocator, b2ContactListener* listener);
		//~b2Island();

		public function Clear():void
		{
			m_bodyCount = 0;
			m_contactCount = 0;
			m_jointCount = 0;
		}

		//void Solve(const b2TimeStep& step, const b2Vec2& gravity, bool allowSleep);

		//void SolveTOI(const b2TimeStep& subStep, const b2Body* bodyA, const b2Body* bodyB);


		public function AddBody (body:b2Body):void
		{
			//b2Assert(m_bodyCount < m_bodyCapacity);
			body.m_islandIndex = m_bodyCount;
			m_bodies[m_bodyCount++] = body;
		}

		public function AddContact (contact:b2Contact):void
		{
			//b2Assert(m_contactCount < m_contactCapacity);
			m_contacts[m_contactCount++] = contact;
		}

		public function AddJoint (joint:b2Joint):void
		{
			//b2Assert(m_jointCount < m_jointCapacity);
			m_joints[m_jointCount++] = joint;
		}

		//void Report(const b2ContactConstraint* constraints);

		public var m_allocator:b2StackAllocator;
		public var m_listener:b2ContactListener;
		//public var m_listener:b2ContactPostSolveListener = null; // hacking

		//b2Body** m_bodies;
		//b2Contact** m_contacts;
		//b2Joint** m_joints;
		public var m_bodies:Array;
		public var m_contacts:Array;
		public var m_joints:Array;

		//b2Position* m_positions;
		//b2Velocity* m_velocities;

		public var m_bodyCount:int;
		public var m_jointCount:int;
		public var m_contactCount:int;

		public var m_bodyCapacity:int;
		public var m_contactCapacity:int;
		public var m_jointCapacity:int;

//====================================================================================
// hacking
//====================================================================================

		public var mWorld:b2World = null;

	} // class
} // package
//#endif
