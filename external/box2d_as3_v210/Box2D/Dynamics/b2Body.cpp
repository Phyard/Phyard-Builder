/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
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

//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Dynamics/b2World.h>
//#include <Box2D/Dynamics/Contacts/b2Contact.h>
//#include <Box2D/Dynamics/Joints/b2Joint.h>

public function b2Body(bd:b2BodyDef, world:b2World)
{
	m_flags = 0;

	if (bd.isBullet)
	{
		m_flags |= e_bulletFlag;
	}
	if (bd.fixedRotation)
	{
		m_flags |= e_fixedRotationFlag;
	}
	if (bd.allowSleep)
	{
		m_flags |= e_allowSleepFlag;
	}
	if (bd.isSleeping)
	{
		m_flags |= e_sleepFlag;
	}

	m_world = world;

	//m_xf.position = bd.position;
	m_xf.position.x = bd.position.x;
	m_xf.position.y = bd.position.y;
	m_xf.R.SetFromAngle(bd.angle);

	//m_sweep.localCenter = bd.massData.center;
	m_sweep.localCenter.x = bd.massData.center.x;
	m_sweep.localCenter.y = bd.massData.center.y;
	m_sweep.t0 = 1.0;
	m_sweep.a0 = m_sweep.a = bd.angle;
	//m_sweep.c0 = m_sweep.c = b2Mul(m_xf, m_sweep.localCenter);
	b2Math.b2Mul_TransformAndVector2_Output (m_xf, m_sweep.localCenter, m_sweep.c);
	m_sweep.c0.x = m_sweep.c.x;
	m_sweep.c0.y = m_sweep.c.y;

	m_jointList = null;
	m_contactList = null;
	m_prev = null;
	m_next = null;

	//m_linearVelocity = bd.linearVelocity;
	m_linearVelocity.x = bd.linearVelocity.x;
	m_linearVelocity.y = bd.linearVelocity.y;
	m_angularVelocity = bd.angularVelocity;

	m_linearDamping = bd.linearDamping;
	m_angularDamping = bd.angularDamping;

	m_force.Set(0.0, 0.0);
	m_torque = 0.0;

	m_linearVelocity.SetZero();
	m_angularVelocity = 0.0;

	m_sleepTime = 0.0;

	m_invMass = 0.0;
	m_I = 0.0;
	m_invI = 0.0;

	m_mass = bd.massData.mass;

	if (m_mass > 0.0)
	{
		m_invMass = 1.0 / m_mass;
	}

	m_I = bd.massData.I;
	
	if (m_I > 0.0 && (m_flags & b2Body.e_fixedRotationFlag) == 0)
	{
		m_invI = 1.0 / m_I;
	}

	if (m_invMass == 0.0 && m_invI == 0.0)
	{
		m_type = e_staticType;
	}
	else
	{
		m_type = e_dynamicType;
	}

	m_userData = bd.userData;

	m_fixtureList = null;
	m_fixtureCount = 0;
}

//b2Body::~b2Body()
public function _b2Body ():void
{
	// shapes and joints are destroyed in b2World::Destroy
}

public function CreateFixture(def:b2FixtureDef):b2Fixture
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return null;
	}

	//b2BlockAllocator* allocator = &m_world->m_blockAllocator;
	var broadPhase:b2BroadPhase = m_world.m_contactManager.m_broadPhase;

	//void* mem = allocator->Allocate(sizeof(b2Fixture));
	//b2Fixture* fixture = new (mem) b2Fixture;
	//fixture->Create(allocator, broadPhase, this, m_xf, def);
	var fixture:b2Fixture = new b2Fixture;
	fixture.Create(null, broadPhase, this, m_xf, def);

	fixture.m_next = m_fixtureList;
	m_fixtureList = fixture;
	++m_fixtureCount;

	fixture.m_body = this;

	// Let the world know we have a new fixture.
	m_world.m_flags |= b2World.e_newFixture;

	return fixture;
}

//b2Fixture* b2Body::CreateFixture(const b2Shape* shape, float32 density)
public function CreateFixture_FromShape (shape:b2Shape, density:Number = 0.0):b2Fixture
{
	//b2Assert(m_world.IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return null;
	}

	//b2BlockAllocator* allocator = &m_world->m_blockAllocator;
	var broadPhase:b2BroadPhase = m_world.m_contactManager.m_broadPhase;

	var def:b2FixtureDef;
	def.shape = shape;
	def.density = density;

	//void* mem = allocator->Allocate(sizeof(b2Fixture));
	//b2Fixture* fixture = new (mem) b2Fixture;
	//fixture->Create(allocator, broadPhase, this, m_xf, &def);
	var fixture:b2Fixture = new b2Fixture ();
	fixture.Create(null, broadPhase, this, m_xf, def);

	fixture.m_next = m_fixtureList;
	m_fixtureList = fixture;
	++m_fixtureCount;

	fixture.m_body = this;

	// Let the world know we have a new fixture.
	m_world.m_flags |= b2World::e_newFixture;

	return fixture;
}

public function DestroyFixture(fixture:b2Fixture):void
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return;
	}

	//b2Assert(fixture->m_body == this);

	// Remove the fixture from this body's singly linked list.
	//b2Assert(m_fixtureCount > 0);
	
	var prev:b2Fixture = null; 
	var node:b2Fixture = m_fixtureList; 
	var found:Boolean = false;
	while (node != null)
	{
		if (node == fixture)
		{
			//@notice: in c++ version, it is more elgent than the as version here
			if (prev == null)
			{
				m_fixtureList = fixture.m_next;
			}
			else
			{
				prev.m_next = fixture.m_next;
			}
			found = true;
			break;
		}

		prev = node;
		node = node.m_next;
	}

	// You tried to remove a shape that is not attached to this body.
	//b2Assert(found);
	if (!found) return; // no this line in c++ version

	// Destroy any contacts associated with the fixture.
	var edge:b2ContactEdge = m_contactList;
	while (edge != null)
	{
		var c:b2Contact = edge.contact;
		edge = edge.next;

		var fixtureA:b2Fixture = c.GetFixtureA();
		var fixtureB:b2Fixture = c.GetFixtureB();

		if (fixture == fixtureA || fixture == fixtureB)
		{
			// This destroys the contact and removes it from
			// this body's contact list.
			m_world.m_contactManager.Destroy(c);
		}
	}

	var allocator:b2BlockAllocator = m_world.m_blockAllocator;
	var broadPhase:b2BroadPhase = m_world.m_contactManager.m_broadPhase;
	fixture.Destroy(null, broadPhase);
	fixture.m_body = null;
	fixture.m_next = null;
	//fixture->~b2Fixture();
	fixture._b2Fixture ();
	//allocator->Free(fixture, sizeof(b2Fixture));

	--m_fixtureCount;
}

// TODO_ERIN adjust linear velocity and torque to account for movement of center.
public function SetMassData(massData:b2MassData):void
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return;
	}

	m_invMass = 0.0;
	m_I = 0.0;
	m_invI = 0.0;

	m_mass = massData.mass;

	if (m_mass > 0.0)
	{
		m_invMass = 1.0 / m_mass;
	}

	m_I = massData.I;

	if (m_I > 0.0 && (m_flags & b2Body.e_fixedRotationFlag) == 0)
	{
		m_invI = 1.0 / m_I;
	}

	// Move center of mass.
	//m_sweep.localCenter = massData.center;
	m_sweep.localCenter.x = massData.center.x;
	m_sweep.localCenter.y = massData.center.y;
	//m_sweep.c0 = m_sweep.c = b2Mul(m_xf, m_sweep.localCenter);
	b2Math.b2Mul_TransformAndVector2_Output(m_xf, m_sweep.localCenter, m_sweep.c);
	m_sweep.c0.x = m_sweep.c.x;
	m_sweep.c0.y = m_sweep.c.y;

	var oldType:int = m_type;
	if (m_invMass == 0.0 && m_invI == 0.0)
	{
		m_type = e_staticType;
	}
	else
	{
		m_type = e_dynamicType;
	}

	// If the body type changed, we need to flag contacts for filtering.
	if (oldType != m_type)
	{
		for (var ce:b2ContactEdge = m_contactList; ce != null; ce = ce.next)
		{
			ce.contact.FlagForFiltering();
		}
	}
}

// TODO_ERIN adjust linear velocity and torque to account for movement of center.
public function SetMassFromShapes():void
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return;
	}

	// Compute mass data from shapes. Each shape has its own density.
	m_mass = 0.0;
	m_invMass = 0.0;
	m_I = 0.0;
	m_invI = 0.0;

	var center:b2Vec2 = b2Math.b2Vec2_zero.Clone ();
	for (var f:b2Fixture = m_fixtureList; f; f = f.m_next)
	{
		var massData:b2MassData = new b2MassData ();
		f.ComputeMass(massData);
		m_mass += massData.mass;
		//center += massData.mass * massData.center;
		center.x += massData.mass * massData.center.x;
		center.y += massData.mass * massData.center.y;
		m_I += massData.I;
	}

	// Compute center of mass, and shift the origin to the COM.
	if (m_mass > 0.0)
	{
		m_invMass = 1.0 / m_mass;
		center.x *= m_invMass;
		center.y *= m_invMass;
	}

	if (m_I > 0.0 && (m_flags & e_fixedRotationFlag) == 0)
	{
		// Center the inertia about the center of mass.
		m_I -= m_mass * b2Math.b2Dot2 (center, center);
		//b2Assert(m_I > 0.0f);
		m_invI = 1.0 / m_I;
	}
	else
	{
		m_I = 0.0;
		m_invI = 0.0;
	}

	// Move center of mass.
	//m_sweep.localCenter = center;
	m_sweep.localCenter.x = center.x;
	m_sweep.localCenter.y = center.y;
	//m_sweep.c0 = m_sweep.c = b2Mul(m_xf, m_sweep.localCenter);
	b2Math.b2Mul_TransformAndVector2_Output(m_xf, m_sweep.localCenter, m_sweep.c);
	m_sweep.c0.x = m_sweep.c.x;
	m_sweep.c0.y = m_sweep.c.y;

	var oldType:int = m_type;
	if (m_invMass == 0.0 && m_invI == 0.0)
	{
		m_type = e_staticType;
	}
	else
	{
		m_type = e_dynamicType;
	}

	// If the body type changed, we need to flag contacts for filtering.
	if (oldType != m_type)
	{
		for (var ce:b2ContactEdge = m_contactList; ce != null; ce = ce.next)
		{
			ce.contact.FlagForFiltering();
		}
	}
}

public function IsConnected(other:b2Body):Boolean
{
	for (var jn:b2JointEdge = m_jointList; jn != null; jn = jn.next)
	{
		if (jn.other == other)
		{
			return jn.joint.m_collideConnected == false;
		}
	}

	return false;
}

public function SetTransform(position:b2Vec2, angle:Number):void
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return;
	}

	m_xf.R.SetFromAngle (angle);
	//m_xf.position = position;
	m_xf.position.x = position.x;
	m_xf.position.y = position.y;

	//m_sweep.c0 = m_sweep.c = b2Mul(m_xf, m_sweep.localCenter);
	b2Math.b2Mul_TransformAndVector2_Output(m_xf, m_sweep.localCenter, m_sweep.c);
	m_sweep.c0.x = m_sweep.c.x;
	m_sweep.c0.y = m_sweep.c.y;
	m_sweep.a0 = m_sweep.a = angle;

	var broadPhase:b2BroadPhase = m_world.m_contactManager.m_broadPhase;
	for (var f:b2Fixture = m_fixtureList; f != null; f = f.m_next)
	{
		f.Synchronize(broadPhase, m_xf, m_xf);
	}

	m_world.m_contactManager.FindNewContacts();
}

public function SynchronizeFixtures():void
{
	var xf1:b2Transform = new b2Transform ();
	xf1.R.SetFromAngle (m_sweep.a0);
	//xf1.position = m_sweep.c0 - b2Mul(xf1.R, m_sweep.localCenter);
	var temp:b2Vec2 = b2Math.b2Mul_Matrix22AndVector2 (xf1.R, m_sweep.localCenter);
	xf1.position.x = m_sweep.c0.x - temp.x;
	xf1.position.y = m_sweep.c0.y - temp.y;

	var broadPhase:b2BroadPhase = m_world.m_contactManager.m_broadPhase;
	for (var f:b2Fixture = m_fixtureList; f != null; f = f.m_next)
	{
		f.Synchronize(broadPhase, xf1, m_xf);
	}
}

