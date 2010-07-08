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

//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Dynamics/Contacts/b2Contact.h>
//#include <Box2D/Collision/Shapes/b2CircleShape.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>
//#include <Box2D/Collision/b2BroadPhase.h>
//#include <Box2D/Collision/b2Collision.h>
//#include <Box2D/Common/b2BlockAllocator.h>


public function b2Fixture()
{
	m_userData = null;
	m_body = null;
	m_next = null;
	m_proxyId = b2BroadPhase.e_nullProxy;
	m_shape = null;
	m_density = 0.0;
}

//b2Fixture::~b2Fixture()
public function _b2Fixture ():void
{
	//b2Assert(m_shape == NULL);
	//b2Assert(m_proxyId == b2BroadPhase::e_nullProxy);
}

public function Create(allocator:b2BlockAllocator, body:b2Body, xf:b2Transform, def:b2FixtureDef):void
{
	m_userData = def.userData;
	m_friction = def.friction;
	m_restitution = def.restitution;

	m_body = body;
	m_next = null;

	m_filter = def.filter;

	m_isSensor = def.isSensor;

	m_shape = def.shape.Clone(allocator);

	m_density = def.density;
}

public function Destroy(allocator:b2BlockAllocator):void
{
	// The proxy must be destroyed before calling this.
	//b2Assert(m_proxyId == b2BroadPhase::e_nullProxy);

	// Free the child shape.
	switch (m_shape.m_type)
	{
	case b2Shape.e_circle:
		{
			var cs:b2CircleShape = m_shape as b2CircleShape;
			//s->~b2CircleShape();
			//allocator->Free(s, sizeof(b2CircleShape));
		}
		break;

	case b2Shape.e_polygon:
		{
			var ps:b2PolygonShape = m_shape as b2PolygonShape;
			//s->~b2PolygonShape();
			//allocator->Free(s, sizeof(b2PolygonShape));
		}
		break;

	default:
		//b2Assert(false);
		break;
	}

	m_shape = null;
}

public function CreateProxy(broadPhase:b2BroadPhase, xf:b2Transform):void
{
	//b2Assert(m_proxyId == b2BroadPhase::e_nullProxy);

	// Create proxy in the broad-phase.
	m_shape.ComputeAABB(m_aabb, xf);
	m_proxyId = broadPhase.CreateProxy(m_aabb, this);
}

public function DestroyProxy(broadPhase:b2BroadPhase):void
{
	if (m_proxyId == b2BroadPhase.e_nullProxy)
	{
		return;
	}

	// Destroy proxy in the broad-phase.
	broadPhase.DestroyProxy(m_proxyId);
	m_proxyId = b2BroadPhase.e_nullProxy;
}

private static var aabb1:b2AABB = new b2AABB ();
private static var aabb2:b2AABB= new b2AABB ();
private static var displacement:b2Vec2 = new b2Vec2 ();
public function Synchronize(broadPhase:b2BroadPhase, transform1:b2Transform, transform2:b2Transform):void
{
	if (m_proxyId == b2BroadPhase.e_nullProxy)
	{	
		return;
	}

	// Compute an AABB that covers the swept shape (may miss some rotation effect).
	//var aabb1:b2AABB = new b2AABB (), aabb2:b2AABB= new b2AABB ();
	m_shape.ComputeAABB(aabb1, transform1);
	m_shape.ComputeAABB(aabb2, transform2);
	
	m_aabb.CombineTwo(aabb1, aabb2);

	//var displacement:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (transform2.position.x - transform1.position.x, transform2.position.y - transform1.position.y);
	displacement.x = transform2.position.x - transform1.position.x;
	displacement.y = transform2.position.y - transform1.position.y;

	broadPhase.MoveProxy(m_proxyId, m_aabb, displacement);
}

public function SetFilterData(filter:b2Filter):void
{
	m_filter = filter;

	if (m_body == null)
	{
		return;
	}

	// Flag associated contacts for filtering.
	var edge:b2ContactEdge = m_body.GetContactList();
	while (edge != null)
	{
		var contact:b2Contact = edge.contact;
		var fixtureA:b2Fixture = contact.GetFixtureA();
		var fixtureB:b2Fixture = contact.GetFixtureB();
		if (fixtureA == this || fixtureB == this)
		{
			contact.FlagForFiltering();
		}
		
		edge = edge.next;
	}
}

public function SetSensor(sensor:Boolean):void
{
	m_isSensor = sensor;
}

