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

public static var s_registers:Array = null;
public static var s_initialized:Boolean = false;

public static function InitializeRegisters():void
{
	// this for-clause doesn't exist in the c++ version
	s_registers = new Array (b2Shape.e_typeCount);
	for (var i:int = 0; i < b2Shape.e_typeCount; ++ i)
	{
		s_registers [i] = new Array (b2Shape.e_typeCount);
		for (var j:int = 0; j < b2Shape.e_typeCount; ++ j)
		{
			s_registers [i][j] = new b2ContactRegister ();
		}
	}

	AddType(b2CircleContact.Create, b2CircleContact.Destroy, b2Shape.e_circle, b2Shape.e_circle);
	AddType(b2PolygonAndCircleContact.Create, b2PolygonAndCircleContact.Destroy, b2Shape.e_polygon, b2Shape.e_circle);
	AddType(b2PolygonContact.Create, b2PolygonContact.Destroy, b2Shape.e_polygon, b2Shape.e_polygon);
	AddType(b2EdgeAndCircleContact.Create, b2EdgeAndCircleContact.Destroy, b2Shape.e_edge, b2Shape.e_circle);
	AddType(b2EdgeAndPolygonContact.Create, b2EdgeAndPolygonContact.Destroy, b2Shape.e_edge, b2Shape.e_polygon);
	AddType(b2LoopAndCircleContact.Create, b2LoopAndCircleContact.Destroy, b2Shape.e_loop, b2Shape.e_circle);
	AddType(b2LoopAndPolygonContact.Create, b2LoopAndPolygonContact.Destroy, b2Shape.e_loop, b2Shape.e_polygon);
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

public static function Create(fixtureA:b2Fixture, indexA:int, fixtureB:b2Fixture, indexB:int, allocator:b2BlockAllocator = null):b2Contact
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

	var cr:b2ContactRegister = s_registers[type1][type2] as b2ContactRegister;
	var createFcn:Function = cr.createFcn;
	if (createFcn != null)
	{
		if (cr.primary)
		{
			return createFcn(fixtureA, indexA, fixtureB, indexB, allocator);
		}
		else
		{
			return createFcn(fixtureB, indexB, fixtureA, indexA, allocator);
		}
	}
	else
	{
		return null;
	}
}

public static function Destroy(contact:b2Contact, allocator:b2BlockAllocator = null):void
{
	//b2Assert(s_initialized == true);

	if (contact.m_manifold.pointCount > 0)
	{
		contact.GetFixtureA().GetBody().SetAwake(true);
		contact.GetFixtureB().GetBody().SetAwake(true);
	}

	//>> hacking
	contact.m_manifold.mNextManifoldInPool = mManifoldPool;
	mManifoldPool = contact.m_manifold;
	contact.m_manifold = null;
	//<<

	var typeA:int = contact.GetFixtureA().GetType();
	var typeB:int = contact.GetFixtureB().GetType();

	//b2Assert(b2Shape::e_unknown < typeA && typeB < b2Shape::e_typeCount);
	//b2Assert(b2Shape::e_unknown < typeA && typeB < b2Shape::e_typeCount);

	var destroyFcn:Function = (s_registers[typeA][typeB] as b2ContactRegister).destroyFcn;
	destroyFcn(contact, allocator);
}

private static var mManifoldPool:b2Manifold = null; // b2Manifold pool

public function b2Contact(fA:b2Fixture, indexA:int, fB:b2Fixture, indexB:int)
{
	m_flags = e_enabledFlag;

	m_fixtureA = fA;
	m_fixtureB = fB;

	m_indexA = indexA;
	m_indexB = indexB;

	//hacking
	if (mManifoldPool == null)
	{
		m_manifold = new b2Manifold ();
	}
	else
	{
		m_manifold = mManifoldPool;
		mManifoldPool = mManifoldPool.mNextManifoldInPool;
		m_manifold.mNextManifoldInPool = null;
	}
	//<<

	m_manifold.pointCount = 0;

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

	m_toiCount = 0;
}

private static var mOldManifold:b2Manifold = new b2Manifold ();

// Update the contact manifold and touching status.
// Note: do not assume the fixture AABBs are overlapping or are valid.

public function Update(listener:b2ContactListener
	//, preSolveLinster:b2ContactPreSolveListener // hacking
	):void
{
	var i:int;
	var j:int;
	var mp2:b2ManifoldPoint;
	var mp1:b2ManifoldPoint;

	//b2Manifold oldManifold = m_manifold;
	//var oldManifold:b2Manifold = m_manifold.Clone ();
	//>> hacking, optimization
	var oldManifold:b2Manifold = mOldManifold;

	//if (preSolveLinster == null)
	//{
	//	oldManifold.pointCount = m_manifold.pointCount;
	//	for (i = 0; i < m_manifold.pointCount; ++i)
	//	{
	//		//b2ManifoldPoint* mp2 = m_manifold.m_points + i;
	//		mp2 = m_manifold.points [i] as b2ManifoldPoint;
	//		mp1 = oldManifold.points [i] as b2ManifoldPoint;
	//		//mp1.m_id.key = mp2.m_id.key;
	//		mp1.id = mp2.id;
	//		mp1.normalImpulse = mp2.normalImpulse;
	//		mp1.tangentImpulse = mp2.tangentImpulse;
	//	}
	//}
	//else
	//{
	oldManifold.CopyFrom (m_manifold);
	//}
	//<<

	// Re-enable this contact.
	m_flags |= e_enabledFlag;

	var sensorA:Boolean = m_fixtureA.IsSensor();
	var sensorB:Boolean = m_fixtureB.IsSensor();
	var sensor:Boolean = sensorA || sensorB;

	var touching:Boolean = false;
	var wasTouching:Boolean = (m_flags & e_touchingFlag) == e_touchingFlag;

	var bodyA:b2Body = m_fixtureA.GetBody();
	var bodyB:b2Body = m_fixtureB.GetBody();
	const xfA:b2Transform = bodyA.GetTransform();
	const xfB:b2Transform = bodyB.GetTransform();

	// Is this contact a sensor?
	if (sensor)
	{
		const shapeA:b2Shape = m_fixtureA.GetShape();
		const shapeB:b2Shape = m_fixtureB.GetShape();
		touching = b2Collision.b2TestOverlap_Shapes (shapeA, m_indexA, shapeB, m_indexB, xfA, xfB);

		// Sensors don't generate manifolds.
		m_manifold.pointCount = 0;
	}
	else
	{
		Evaluate(m_manifold, xfA, xfB);
		touching = m_manifold.pointCount > 0;

		// Match old contact ids to new contact ids and copy the
		// stored impulses to warm start the solver.
		for (i = 0; i < m_manifold.pointCount; ++i)
		{
			//b2ManifoldPoint* mp2 = m_manifold.m_points + i;
			mp2 = m_manifold.points [i] as b2ManifoldPoint;
			mp2.normalImpulse = 0.0;
			mp2.tangentImpulse = 0.0;
			//var id2:b2ContactID = mp2.m_id.Clone ();
			var id2:uint = mp2.id;
			var found:Boolean = false;

			for (j = 0; j < oldManifold.pointCount; ++j)
			{
				//b2ManifoldPoint* mp1 = oldManifold.m_points + j;
				mp1 = oldManifold.points [j] as b2ManifoldPoint;

				//if (mp1.m_id.key == id2.key2)
				if (mp1.id == id2)
				{
					mp2.normalImpulse = mp1.normalImpulse;
					mp2.tangentImpulse = mp1.tangentImpulse;
					found = true;
					break;
				}
			}

			if (found == false)
			{
				mp2.normalImpulse = 0.0;
				mp2.tangentImpulse = 0.0;
			}
		}

		if (touching != wasTouching)
		{
			bodyA.SetAwake(true);
			bodyB.SetAwake(true);
		}
	}

	if (touching)
	{
		m_flags |= e_touchingFlag;
	}
	else
	{
		m_flags &= ~e_touchingFlag;
	}

	if (wasTouching == false && touching == true && listener != null)
	{
		listener.BeginContact(this);
	}

	if (wasTouching == true && touching == false && listener != null)
	{
		listener.EndContact(this);
	}

	if (sensor == false && touching && listener != null)
	{
		//if (preSolveLinster != null) // hacking
		//{
		//	preSolveLinster.PreSolve(this, oldManifold);
		listener.PreSolve(this, oldManifold);
		//}
	}
}
