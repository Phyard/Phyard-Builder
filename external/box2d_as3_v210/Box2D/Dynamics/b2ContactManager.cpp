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

//#include <Box2D/Dynamics/b2ContactManager.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Dynamics/b2WorldCallbacks.h>
//#include <Box2D/Dynamics/Contacts/b2Contact.h>

public static var b2_defaultFilter:b2ContactFilter = new b2ContactFilter ();
public static var b2_defaultListener:b2ContactListener = new b2ContactListener ();

public function b2ContactManager(broadPhase:b2BroadPhase)
{
	m_contactList = null;
	m_contactCount = 0;
	m_contactFilter = b2_defaultFilter;
	m_contactListener = b2_defaultListener;
	m_allocator = null;

	if (broadPhase == null)
	{
		broadPhase = new b2BroadPhase_DynamicTree ();
	}
	m_broadPhase = broadPhase;

	//trace ("m_broadPhase: " + m_broadPhase);
}

public function Destroy(c:b2Contact):void
{
	var fixtureA:b2Fixture = c.GetFixtureA();
	var fixtureB:b2Fixture = c.GetFixtureB();
	var bodyA:b2Body = fixtureA.GetBody();
	var bodyB:b2Body = fixtureB.GetBody();

	if (m_contactListener != null && c.IsTouching())
	{
		m_contactListener.EndContact(c);
	}

	// Remove from the world.
	if (c.m_prev != null)
	{
		c.m_prev.m_next = c.m_next;
	}

	if (c.m_next != null)
	{
		c.m_next.m_prev = c.m_prev;
	}

	if (c == m_contactList)
	{
		m_contactList = c.m_next;
	}

	// Remove from body 1
	if (c.m_nodeA.prev)
	{
		c.m_nodeA.prev.next = c.m_nodeA.next;
	}

	if (c.m_nodeA.next)
	{
		c.m_nodeA.next.prev = c.m_nodeA.prev;
	}

	if (c.m_nodeA == bodyA.m_contactList)
	{
		bodyA.m_contactList = c.m_nodeA.next;
	}

	// Remove from body 2
	if (c.m_nodeB.prev)
	{
		c.m_nodeB.prev.next = c.m_nodeB.next;
	}

	if (c.m_nodeB.next)
	{
		c.m_nodeB.next.prev = c.m_nodeB.prev;
	}

	if (c.m_nodeB == bodyB.m_contactList)
	{
		bodyB.m_contactList = c.m_nodeB.next;
	}

	// Call the factory.
	b2Contact.Destroy(c, m_allocator);
	--m_contactCount;
}

// This is the top level collision call for the time step. Here
// all the narrow phase collision is processed for the world
// contact list.
public function Collide():void
{
	// Update awake contacts.
	var c:b2Contact = m_contactList;
	while (c != null)
	{
		var fixtureA:b2Fixture = c.GetFixtureA();
		var fixtureB:b2Fixture = c.GetFixtureB();
		var bodyA:b2Body = fixtureA.GetBody();
		var bodyB:b2Body = fixtureB.GetBody();

		if (bodyA.IsAwake() == false && bodyB.IsAwake() == false)
		{
			c = c.GetNext();
			continue;
		}

		// Is this contact flagged for filtering?
		if (c.m_flags & b2Contact.e_filterFlag)
		{
			// Should these bodies collide?
			if (bodyB.ShouldCollide(bodyA) == false)
			{
				var cNuke2:b2Contact = c;
				c = cNuke2.GetNext();
				Destroy(cNuke2);
				continue;
			}

			// Check user filtering.
			if (m_contactFilter != null && m_contactFilter.ShouldCollide(fixtureA, fixtureB) == false)
			{
				var cNuke3:b2Contact = c;
				c = cNuke3.GetNext();
				Destroy(cNuke3);
				continue;
			}

			// Clear the filtering flag.
			c.m_flags &= ~b2Contact.e_filterFlag;
		}

		var proxyIdA:int = fixtureA.m_proxyId;
		var proxyIdB:int = fixtureB.m_proxyId;
		var overlap:Boolean = m_broadPhase.TestOverlap(proxyIdA, proxyIdB);

		// Here we destroy contacts that cease to overlap in the broad-phase.
		if (overlap == false)
		{
			var cNuke5:b2Contact = c;
			c = cNuke5.GetNext();
			Destroy(cNuke5);
			continue;
		}

		// The contact persists.
		c.Update(m_contactListener);//, m_contactPreSolveListener);
		c = c.GetNext();
	}
}

public function FindNewContacts():void
{
	m_broadPhase.UpdatePairs(this);
}

public function AddPair(proxyUserDataA:Object, proxyUserDataB:Object):void
{
	var fixtureA:b2Fixture = proxyUserDataA as b2Fixture;
	var fixtureB:b2Fixture = proxyUserDataB as b2Fixture;

	var bodyA:b2Body = fixtureA.GetBody();
	var bodyB:b2Body = fixtureB.GetBody();

	// Are the fixtures on the same body?
	if (bodyA == bodyB)
	{
		return;
	}

	// Does a contact already exist?
	var edge:b2ContactEdge = bodyB.GetContactList();
	while (edge != null)
	{
		if (edge.other == bodyA)
		{
			var fA:b2Fixture = edge.contact.GetFixtureA();
			var fB:b2Fixture = edge.contact.GetFixtureB();
			if (fA == fixtureA && fB == fixtureB)
			{
				// A contact already exists.
				return;
			}

			if (fA == fixtureB && fB == fixtureA)
			{
				// A contact already exists.
				return;
			}
		}

		edge = edge.next;
	}

	// Does a joint override collision? Is at least one body dynamic?
	if (bodyB.ShouldCollide(bodyA) == false)
	{
		return;
	}

	// Check user filtering.
	if (m_contactFilter != null && m_contactFilter.ShouldCollide(fixtureA, fixtureB) == false)
	{
		return;
	}

	// Call the factory.
	//b2Contact* c = b2Contact::Create(fixtureA, fixtureB, m_allocator);
	var c:b2Contact = b2Contact.Create(fixtureA, fixtureB, null);

	// Contact creation may swap fixtures.
	fixtureA = c.GetFixtureA();
	fixtureB = c.GetFixtureB();
	bodyA = fixtureA.GetBody();
	bodyB = fixtureB.GetBody();

	// Insert into the world.
	c.m_prev = null;
	c.m_next = m_contactList;
	if (m_contactList != null)
	{
		m_contactList.m_prev = c;
	}
	m_contactList = c;

	// Connect to island graph.

	// Connect to body A
	c.m_nodeA.contact = c;
	c.m_nodeA.other = bodyB;

	c.m_nodeA.prev = null;
	c.m_nodeA.next = bodyA.m_contactList;
	if (bodyA.m_contactList != null)
	{
		bodyA.m_contactList.prev = c.m_nodeA;
	}
	bodyA.m_contactList = c.m_nodeA;

	// Connect to body B
	c.m_nodeB.contact = c;
	c.m_nodeB.other = bodyA;

	c.m_nodeB.prev = null;
	c.m_nodeB.next = bodyB.m_contactList;
	if (bodyB.m_contactList != null)
	{
		bodyB.m_contactList.prev = c.m_nodeB;
	}
	bodyB.m_contactList = c.m_nodeB;

	++m_contactCount;
}
