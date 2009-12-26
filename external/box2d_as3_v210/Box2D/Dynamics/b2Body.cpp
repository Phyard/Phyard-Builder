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
	//b2Assert(bd->position.IsValid());
	//b2Assert(bd->linearVelocity.IsValid());
	//b2Assert(b2IsValid(bd->angle));
	//b2Assert(b2IsValid(bd->angularVelocity));
	//b2Assert(b2IsValid(bd->inertiaScale) && bd->inertiaScale >= 0.0f);
	//b2Assert(b2IsValid(bd->angularDamping) && bd->angularDamping >= 0.0f);
	//b2Assert(b2IsValid(bd->linearDamping) && bd->linearDamping >= 0.0f);

	m_flags = 0;

	if (bd.bullet)
	{
		m_flags |= e_bulletFlag;
	}
	if (bd.fixedRotation)
	{
		m_flags |= e_fixedRotationFlag;
	}
	if (bd.allowSleep)
	{
		m_flags |= e_autoSleepFlag;
	}
	if (bd.awake)
	{
		m_flags |= e_awakeFlag;
	}
	if (bd.active)
	{
		m_flags |= e_activeFlag;
	}

	m_world = world;

	//m_xf.position = bd.position;
	m_xf.position.x = bd.position.x;
	m_xf.position.y = bd.position.y;
	m_xf.R.SetFromAngle(bd.angle);

	m_sweep.localCenter.SetZero();
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

	m_force.SetZero();
	m_torque = 0.0;

	m_sleepTime = 0.0;

	m_type = bd.type;

	if (m_type == b2_dynamicBody)
	{
		m_mass = 1.0;
		m_invMass = 1.0;
	}
	else
	{
		m_mass = 0.0;
		m_invMass = 0.0;
	}
	
	m_I = 0.0;
	m_invI = 0.0;

	m_inertiaScale = bd.inertiaScale;

	m_userData = bd.userData;

	m_fixtureList = null;
	m_fixtureCount = 0;
}

//b2Body::~b2Body()
public function _b2Body ():void
{
	// shapes and joints are destroyed in b2World::Destroy
}

//void b2Body::SetType(b2BodyType type)
public function SetType(type:int):void
{
	if (m_type == type)
	{
		return;
	}

	m_type = type;

	//ResetMassData();
	OnMassDataChanged ();

	if (m_type == b2_staticBody)
	{
		m_linearVelocity.SetZero();
		m_angularVelocity = 0.0;
	}

	SetAwake(true);

	m_force.SetZero();
	m_torque = 0.0;

	// Since the body type changed, we need to flag contacts for filtering.
	for (var ce:b2ContactEdge = m_contactList; ce != null; ce = ce.next)
	{
		ce.contact.FlagForFiltering();
	}
}

public function CreateFixture(def:b2FixtureDef):b2Fixture
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return null;
	}

	//b2BlockAllocator* allocator = &m_world->m_blockAllocator;

	//void* memory = allocator->Allocate(sizeof(b2Fixture));
	//b2Fixture* fixture = new (memory) b2Fixture;
	//fixture->Create(allocator, broadPhase, this, m_xf, def);
	var fixture:b2Fixture = new b2Fixture ();
	fixture.Create(null, this, m_xf, def);

	if (m_flags & e_activeFlag)
	{
		var broadPhase:b2BroadPhase = m_world.m_contactManager.m_broadPhase;
		fixture.CreateProxy(broadPhase, m_xf);
	}

	fixture.m_next = m_fixtureList;
	m_fixtureList = fixture;
	++m_fixtureCount;

	fixture.m_body = this;

	// Adjust mass properties if needed.
	if (fixture.m_density > 0.0)
	{
		//ResetMassData();
		OnMassDataChanged ();
	}
	
	// Let the world know we have a new fixture. This will cause new contacts
	// to be created at the beginning of the next time step.
	m_world.m_flags |= b2World.e_newFixture;

	return fixture;
}

//b2Fixture* b2Body::CreateFixture(const b2Shape* shape, float32 density)
public function CreateFixture_FromShape (shape:b2Shape, density:Number = 0.0):b2Fixture
{
	var def:b2FixtureDef = new b2FixtureDef ();
	def.shape = shape;
	def.density = density;

	return CreateFixture(def);
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
	
	if (m_flags & e_activeFlag)
	{
		//b2Assert(fixture->m_proxyId != b2BroadPhase::e_nullProxy);
		var broadPhase:b2BroadPhase = m_world.m_contactManager.m_broadPhase;
		fixture.DestroyProxy(broadPhase);
	}
	else
	{
		//b2Assert(fixture->m_proxyId == b2BroadPhase::e_nullProxy);
	}
	
	fixture.Destroy(null);
	fixture.m_body = null;
	fixture.m_next = null;
	//fixture->~b2Fixture();
	fixture._b2Fixture ();
	//allocator->Free(fixture, sizeof(b2Fixture));

	--m_fixtureCount;

	// Adjust mass properties if needed.
	//ResetMassData();
	OnMassDataChanged ();
}


public function ResetMassData():void
{
	// Compute mass data from shapes. Each shape has its own density.
	m_mass = 0.0;
	m_invMass = 0.0;
	m_I = 0.0;
	m_invI = 0.0;
	m_sweep.localCenter.SetZero();

	// Static and kinematic bodies have zero mass.
	if (m_type == b2_staticBody || m_type == b2_kinematicBody)
	{
		return;
	}

	//b2Assert(m_type == b2_dynamicBody);

	// Accumulate mass over all fixtures.
	var center:b2Vec2 = b2Math.b2Vec2_zero.Clone ();

	for (var f:b2Fixture = m_fixtureList; f != null; f = f.m_next)
	{
		if (f.m_density == 0.0)
		{
			continue;
		}

		var massData:b2MassData = new b2MassData ();
		f.GetMassData(massData);
		
		m_mass += massData.mass;
		//center += massData.mass * massData.center;
		center.x += massData.mass * massData.center.x;
		center.y += massData.mass * massData.center.y;
		m_I += massData.I;
	}

	// Compute center of mass.
	if (m_mass > 0.0)
	{
		m_invMass = 1.0 / m_mass;
		//center *= m_invMass;
		center.x *= m_invMass;
		center.y *= m_invMass;
	}
	else
	{
		// Force all dynamic bodies to have a positive mass.
		m_mass = 1.0;
		m_invMass = 1.0;
	}

	if (m_I > 0.0 && (m_flags & e_fixedRotationFlag) == 0)
 	{
		// Center the inertia about the center of mass.
		m_I -= m_mass * b2Math.b2Dot2 (center, center);
		m_I *= m_inertiaScale;
		//b2Assert(m_I > 0.0f);
		m_invI = 1.0 / m_I;
	}
	else
	{
		m_I = 0.0;
		m_invI = 0.0;
	}

	// Move center of mass.
	var oldCenter:b2Vec2 = m_sweep.c.Clone();
	//m_sweep.localCenter = center;
	m_sweep.localCenter.x = center.x;
	m_sweep.localCenter.y = center.y;
	//m_sweep.c0 = m_sweep.c = b2Mul(m_xf, m_sweep.localCenter);
	var tempV:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (m_xf, m_sweep.localCenter);
	m_sweep.c0.x = m_sweep.c.x = tempV.x;
	m_sweep.c0.y = m_sweep.c.y = tempV.y;

	// Update center of mass velocity.
	//m_linearVelocity += b2Cross(m_angularVelocity, m_sweep.c - oldCenter);
	b2Math.b2Subtract_Vector2_Output (m_sweep.c, oldCenter, tempV);
	tempV = b2Math.b2Cross_ScalarAndVector2 (m_angularVelocity, tempV);
	m_linearVelocity.x += tempV.x;
	m_linearVelocity.y += tempV.y;
}

public function SetMassData (massData:b2MassData):void
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return;
	}

	if (m_type != b2_dynamicBody)
	{
		return;
	}

	m_invMass = 0.0;
	m_I = 0.0;
	m_invI = 0.0;

	m_mass = massData.mass;

	if (m_mass <= 0.0)
	{
		m_mass = 1.0;
	}

	m_invMass = 1.0 / m_mass;

	if (massData.I > 0.0 && (m_flags & e_fixedRotationFlag) == 0)
	{
		m_I = massData.I - m_mass * b2Math.b2Dot2 (massData.center, massData.center);
		m_invI = 1.0 / m_I;
	}

	// Move center of mass.
	var oldCenter:b2Vec2 = m_sweep.c.Clone ();
	//m_sweep.localCenter = massData->center;
	m_sweep.localCenter.x = massData.center.x;
	m_sweep.localCenter.y = massData.center.y;
	//m_sweep.c0 = m_sweep.c = b2Mul(m_xf, m_sweep.localCenter);
	var tempV:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (m_xf, m_sweep.localCenter);
	m_sweep.c0.x = m_sweep.c.x = tempV.x;
	m_sweep.c0.y = m_sweep.c.y = tempV.y;

	// Update center of mass velocity.
	//m_linearVelocity += b2Cross(m_angularVelocity, m_sweep.c - oldCenter);
	b2Math.b2Subtract_Vector2_Output (m_sweep.c, oldCenter, tempV);
	tempV = b2Math.b2Cross_ScalarAndVector2 (m_angularVelocity, tempV);
	m_linearVelocity.x += tempV.x;
	m_linearVelocity.y += tempV.y;
}

public function ShouldCollide(other:b2Body):Boolean
{
	// At least one body should be dynamic.
	if (m_type != b2_dynamicBody && other.m_type != b2_dynamicBody)
	{
		return false;
	}

	// Does a joint prevent collision?
	for (var jn:b2JointEdge = m_jointList; jn != null; jn = jn.next)
	{
		if (jn.other == other)
		{
			if (jn.joint.m_collideConnected == false)
			{
				return false;
			}
		}
	}

	return true;
}

public function SetTransform(position:b2Vec2, angle:Number):void
{
	//b2Assert(m_world->IsLocked() == false);
	if (m_world.IsLocked() == true)
	{
		return;
	}

	m_xf.R.SetFromAngle (angle);
	if (position != null) // hacking
	{
		//m_xf.position = position;
		m_xf.position.x = position.x;
		m_xf.position.y = position.y;
	}

	NotifyTransformChangedManually (angle);
}
// some hacking here
private function NotifyTransformChangedManually (angle:Number):void
{
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

public function SetActive (flag:Boolean):void
{
	if (flag == IsActive())
	{
		return;
	}

	var broadPhase:b2BroadPhase;
	var f:b2Fixture;
	
	if (flag)
	{
		m_flags |= e_activeFlag;

		// Create all proxies.
		broadPhase = m_world.m_contactManager.m_broadPhase;
		for (f = m_fixtureList; f != null; f = f.m_next)
		{
			f.CreateProxy(broadPhase, m_xf);
		}

		// Contacts are created the next time step.
	}
	else
	{
		m_flags &= ~e_activeFlag;

		// Destroy all proxies.
		broadPhase = m_world.m_contactManager.m_broadPhase;
		for (f = m_fixtureList; f = null; f = f.m_next)
		{
			f.DestroyProxy(broadPhase);
		}

		// Destroy the attached contacts.
		var ce:b2ContactEdge = m_contactList;
		while (ce != null)
		{
			var ce0:b2ContactEdge = ce;
			ce = ce.next;
			m_world.m_contactManager.Destroy(ce0.contact);
		}
		m_contactList = null;
	}
}
