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

//#include <Box2D/Dynamics/Contacts/b2Contact.h>
//#include <Box2D/Dynamics/Contacts/b2CircleContact.h>
//#include <Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.h>
//#include <Box2D/Dynamics/Contacts/b2PolygonContact.h>
//#include <Box2D/Dynamics/Contacts/b2ContactSolver.h>

//#include <Box2D/Collision/b2Collision.h>
//#include <Box2D/Collision/b2TimeOfImpact.h>
//#include <Box2D/Collision/Shapes/b2Shape.h>
//#include <Box2D/Common/b2BlockAllocator.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Dynamics/b2World.h>

public static var s_registers:Array = new Array (e_typeCount);
public static var s_initialized:Boolean = false;

public static function InitializeRegisters():void
{
	// this for-clause doesn't exist in the c++ version
	for (var i:int = 0; i < e_typeCount; ++ i)
	{
		s_registers = new Array (e_typeCount);
	}
	
	AddType(b2CircleContact::Create, b2CircleContact::Destroy, b2Shape::e_circle, b2Shape::e_circle);
	AddType(b2PolygonAndCircleContact::Create, b2PolygonAndCircleContact::Destroy, b2Shape::e_polygon, b2Shape::e_circle);
	AddType(b2PolygonContact::Create, b2PolygonContact::Destroy, b2Shape::e_polygon, b2Shape::e_polygon);
}

public static function AddType(createFcn:Function, destoryFcn:Function,
						type1:int, type2:int):void
{
	//b2Assert(b2Shape::e_unknown < type1 && type1 < b2Shape::e_typeCount);
	//b2Assert(b2Shape::e_unknown < type2 && type2 < b2Shape::e_typeCount);
	
	s_registers[type1][type2].createFcn = createFcn;
	s_registers[type1][type2].destroyFcn = destoryFcn;
	s_registers[type1][type2].primary = true;

	if (type1 != type2)
	{
		s_registers[type2][type1].createFcn = createFcn;
		s_registers[type2][type1].destroyFcn = destoryFcn;
		s_registers[type2][type1].primary = false;
	}
}

public function Create(fixtureA:b2Fixture, fixtureB:b2Fixture, allocator:b2BlockAllocator):void
{
	if (s_initialized == false)
	{
		InitializeRegisters();
		s_initialized = true;
	}

	var type1:int = fixtureA.GetType();
	var type2:int = fixtureB.GetType();

	//b2Assert(b2Shape::e_unknown < type1 && type1 < b2Shape::e_typeCount);
	//b2Assert(b2Shape::e_unknown < type2 && type2 < b2Shape::e_typeCount);
	
	var createFcn:Function = s_registers[type1][type2].createFcn;
	if (createFcn)
	{
		if (s_registers[type1][type2].primary)
		{
			return createFcn(fixtureA, fixtureB, allocator);
		}
		else
		{
			return createFcn(fixtureB, fixtureA, allocator);
		}
	}
	else
	{
		return null;
	}
}

public function Destroy(contact:b2Contact, allocator:b2BlockAllocator):void
{
	//b2Assert(s_initialized == true);

	if (contact.m_manifold.m_pointCount > 0)
	{
		contact.GetFixtureA().GetBody().WakeUp();
		contact.GetFixtureB().GetBody().WakeUp();
	}

	var typeA:int = contact.GetFixtureA().GetType();
	var typeB:int = contact.GetFixtureB().GetType();

	//b2Assert(b2Shape::e_unknown < typeA && typeB < b2Shape::e_typeCount);
	//b2Assert(b2Shape::e_unknown < typeA && typeB < b2Shape::e_typeCount);

	var destroyFcn:Function = s_registers[typeA][typeB].destroyFcn;
	destroyFcn(contact, allocator);
}

public function b2Contact(fA:b2Fixture, fB:b2Fixture)
{
	m_flags = 0;

	if (fA.IsSensor() || fB.IsSensor())
	{
		m_flags |= e_sensorFlag;
	}

	var bodyA:b2Body = fA.GetBody();
	var bodyB:b2Body = fB.GetBody();

	if (bodyA.IsStatic() || bodyA.IsBullet() || bodyB.IsStatic() || bodyB.IsBullet())
	{
		m_flags |= e_continuousFlag;
	}
	else
	{
		m_flags &= ~e_continuousFlag;
	}

	m_fixtureA = fA;
	m_fixtureB = fB;

	m_manifold.m_pointCount = 0;

	m_prev = null;
	m_next = null;

	m_nodeA.contact = null;
	m_nodeA.prev = null;
	m_nodeA.next = null;
	m_nodeA.other = null;

	m_nodeB.contact = null;
	m_nodeB.prev = null;
	m_nodeB.next = null;
	m_nodeB.other = null;
}

public function Update(listener:b2ContactListener):void
{
	//b2Manifold oldManifold = m_manifold;
	var oldManifold:b2Manifold = m_manifold.Clone ();

	// Re-enable this contact.
	m_flags &= ~e_disabledFlag;

	if (b2Collision.b2TestOverlap(m_fixtureA.m_aabb, m_fixtureB.m_aabb))
	{
		Evaluate();
	}
	else
	{
		m_manifold.m_pointCount = 0;
	}

	var bodyA:b2Body = m_fixtureA.GetBody();
	var bodyB:b2Body = m_fixtureB.GetBody();

	var oldCount:int = oldManifold.m_pointCount;
	var newCount:int = m_manifold.m_pointCount;

	if (newCount == 0 && oldCount > 0)
	{
		bodyA.WakeUp();
		bodyB.WakeUp();
	}

	// Slow contacts don't generate TOI events.
	if (bodyA.IsStatic() || bodyA.IsBullet() || bodyB.IsStatic() || bodyB.IsBullet())
	{
		m_flags |= e_continuousFlag;
	}
	else
	{
		m_flags &= ~e_continuousFlag;
	}

	// Match old contact ids to new contact ids and copy the
	// stored impulses to warm start the solver.
	for (var i:int = 0; i < m_manifold.m_pointCount; ++i)
	{
		//b2ManifoldPoint* mp2 = m_manifold.m_points + i;
		var mp2:b2ManifoldPoint = m_manifold.m_points [i] as b2ManifoldPoint;
		mp2.m_normalImpulse = 0.0;
		mp2.m_tangentImpulse = 0.0;
		var id2:b2ContactID = mp2.m_id.Clone ();

		for (var j:int = 0; j < oldManifold.m_pointCount; ++j)
		{
			//b2ManifoldPoint* mp1 = oldManifold.m_points + j;
			var mp1:b2ManifoldPoint = oldManifold.m_points [j] as b2ManifoldPoint;

			if (mp1.m_id.key == id2.key)
			{
				mp2.m_normalImpulse = mp1.m_normalImpulse;
				mp2.m_tangentImpulse = mp1.m_tangentImpulse;
				break;
			}
		}
	}

	if (newCount > 0)
	{
		m_flags |= e_touchingFlag;
	}
	else
	{
		m_flags &= ~e_touchingFlag;
	}

	if (oldCount == 0 && newCount > 0)
	{
		listener.BeginContact(this);
	}

	if (oldCount > 0 && newCount == 0)
	{
		listener.EndContact(this);
	}

	if ((m_flags & e_sensorFlag) == 0)
	{
		listener.PreSolve(this, oldManifold);
	}
}

public function ComputeTOI(sweepA:b2Sweep, sweepB:b2Sweep):Number
{
	var input:b2TOIInput = new b2TOIInput ();
	input.proxyA.Set(m_fixtureA.GetShape());
	input.proxyB.Set(m_fixtureB.GetShape());
	input.sweepA.CopyFrom (sweepA);
	input.sweepB.CopyFrom (sweepB);
	input.tolerance = b2_linearSlop;

	return b2TimeOfImpact(input);
}
