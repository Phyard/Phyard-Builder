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

//#include <Box2D/Dynamics/b2World.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Dynamics/b2Island.h>
//#include <Box2D/Dynamics/Joints/b2PulleyJoint.h>
//#include <Box2D/Dynamics/Contacts/b2Contact.h>
//#include <Box2D/Dynamics/Contacts/b2ContactSolver.h>
//#include <Box2D/Collision/b2Collision.h>
//#include <Box2D/Collision/b2BroadPhase.h>
//#include <Box2D/Collision/Shapes/b2CircleShape.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>
//#include <new>

//public function b2World(gravity:b2Vec2, doSleep:Boolean)
public function b2World(worldDef:b2WorldDef = null)
{
	if (worldDef == null)
	{
		worldDef = new b2WorldDef ();
	}

	m_destructionListener = null;
	m_debugDraw = null;

	m_bodyList = null;
	m_jointList = null;

	m_bodyCount = 0;
	m_jointCount = 0;

	m_warmStarting = true;
	m_continuousPhysics = true;

	m_allowSleep = worldDef.doSleep;
	//m_gravity = gravity;
	m_gravity.x = worldDef.gravity.x;
	m_gravity.y = worldDef.gravity.y;

	m_flags = 0;

	m_inv_dt0 = 0.0;

	m_contactManager = new b2ContactManager (worldDef.collisionBroadPhase);
	m_contactManager.m_allocator = m_blockAllocator;
}

//b2World::~b2World()
public function Destructor ():void
{
}

public function SetDestructionListener(listener:b2DestructionListener):void
{
	m_destructionListener = listener;
}

public function GetDestructionListener():b2DestructionListener
{
	return m_destructionListener;
}

public function SetContactFilter(filter:b2ContactFilter):void
{
	m_contactManager.m_contactFilter = filter;
}

public function GetContactFilter():b2ContactFilter
{
	return m_contactManager.m_contactFilter;
}

public function SetContactListener(listener:b2ContactListener):void
{
	m_contactManager.m_contactListener = listener;
}

public function GetContactListener():b2ContactListener
{
	return m_contactManager.m_contactListener;
}

public function SetDebugDraw(debugDraw:b2DebugDraw):void
{
	m_debugDraw = debugDraw;
}

public function CreateBody(def:b2BodyDef):b2Body
{
	//b2Assert(IsLocked() == false);
	if (IsLocked())
	{
		return null;
	}

	//void* mem = m_blockAllocator.Allocate(sizeof(b2Body));
	//b2Body* b = new (mem) b2Body(def, this);
	var b:b2Body = new b2Body(def, this);

	// Add to world doubly linked list.
	b.m_prev = null;
	b.m_next = m_bodyList;
	if (m_bodyList)
	{
		m_bodyList.m_prev = b;
	}
	m_bodyList = b;
	++m_bodyCount;

	return b;
}

public function DestroyBody(b:b2Body):void
{
	//b2Assert(m_bodyCount > 0);
	//b2Assert(IsLocked() == false);
	if (IsLocked())
	{
		return;
	}

	// Delete the attached joints.
	var je:b2JointEdge = b.m_jointList;
	while (je != null)
	{
		var je0:b2JointEdge = je;
		je = je.next;

		if (m_destructionListener != null)
		{
			m_destructionListener.SayGoodbye_Joint (je0.joint);
		}

		DestroyJoint(je0.joint);
	}
	b.m_jointList = null;

	// Delete the attached contacts.
	var ce:b2ContactEdge = b.m_contactList;
	while (ce != null)
	{
		var ce0:b2ContactEdge = ce;
		ce = ce.next;
		m_contactManager.Destroy(ce0.contact);
	}
	b.m_contactList = null;

	// Delete the attached fixtures. This destroys broad-phase proxies.
	var f:b2Fixture = b.m_fixtureList;
	while (f != null)
	{
		var f0:b2Fixture = f;
		f = f.m_next;

		if (m_destructionListener)
		{
			m_destructionListener.SayGoodbye_Fixture (f0);
		}
		f0.Destroy(m_blockAllocator, m_contactManager.m_broadPhase);
		//f0->~b2Fixture();
		f0._b2Fixture ();
		//m_blockAllocator.Free(f0, sizeof(b2Fixture));
	}
	b.m_fixtureList = null;
	b.m_fixtureCount = 0;

	// Remove world body list.
	if (b.m_prev)
	{
		b.m_prev.m_next = b.m_next;
	}

	if (b.m_next)
	{
		b.m_next.m_prev = b.m_prev;
	}

	if (b == m_bodyList)
	{
		m_bodyList = b.m_next;
	}

	--m_bodyCount;
	//b->~b2Body();
	b._b2Body ();
	//m_blockAllocator.Free(b, sizeof(b2Body));
}

public function CreateJoint(def:b2JointDef):b2Joint
{
	//b2Assert(IsLocked() == false);
	if (IsLocked())
	{
		return null;
	}

	var j:b2Joint = b2Joint.Create(def, m_blockAllocator);

	// Connect to the world list.
	j.m_prev = null;
	j.m_next = m_jointList;
	if (m_jointList)
	{
		m_jointList.m_prev = j;
	}
	m_jointList = j;
	++m_jointCount;

	// Connect to the bodies' doubly linked lists.
	j.m_edgeA.joint = j;
	j.m_edgeA.other = j.m_bodyB;
	j.m_edgeA.prev = null;
	j.m_edgeA.next = j.m_bodyA.m_jointList;
	if (j.m_bodyA.m_jointList) j.m_bodyA.m_jointList.prev = j.m_edgeA;
	j.m_bodyA.m_jointList = j.m_edgeA;

	j.m_edgeB.joint = j;
	j.m_edgeB.other = j.m_bodyA;
	j.m_edgeB.prev = null;
	j.m_edgeB.next = j.m_bodyB.m_jointList;
	if (j.m_bodyB.m_jointList) j.m_bodyB.m_jointList.prev = j.m_edgeB;
	j.m_bodyB.m_jointList = j.m_edgeB;

	var bodyA:b2Body = def.body1;
	var bodyB:b2Body = def.body2;

	var staticA:Boolean = bodyA.IsStatic();
	var staticB:Boolean = bodyB.IsStatic();

	// If the joint prevents collisions, then flag any contacts for filtering.
	if (def.collideConnected == false && (staticA == false || staticB == false))
	{
		// Ensure we iterate over contacts on a dynamic body (usually have less contacts
		// than a static body). Ideally we will have a contact count on both bodies.
		if (staticB)
		{
			//b2Swap(bodyA, bodyB);
			var temp:b2Body = bodyA;
			bodyA = bodyB;
			bodyB = temp;
		}

		var edge:b2ContactEdge = bodyB.GetConactList();
		while (edge != null)
		{
			if (edge.other == bodyA)
			{
				// Flag the contact for filtering at the next time step (where either
				// body is awake).
				edge.contact.FlagForFiltering();
			}

			edge = edge.next;
		}
	}

	// Note: creating a joint doesn't wake the bodies.

	return j;
}

public function DestroyJoint(j:b2Joint):void
{
	//b2Assert(IsLocked() == false);
	if (IsLocked())
	{
		return;
	}

	var collideConnected:Boolean = j.m_collideConnected;

	// Remove from the doubly linked list.
	if (j.m_prev)
	{
		j.m_prev.m_next = j.m_next;
	}

	if (j.m_next)
	{
		j.m_next.m_prev = j.m_prev;
	}

	if (j == m_jointList)
	{
		m_jointList = j.m_next;
	}

	// Disconnect from island graph.
	var bodyA:b2Body = j.m_bodyA;
	var bodyB:b2Body = j.m_bodyB;

	// Wake up connected bodies.
	bodyA.WakeUp();
	bodyB.WakeUp();

	// Remove from body 1.
	if (j.m_edgeA.prev)
	{
		j.m_edgeA.prev.next = j.m_edgeA.next;
	}

	if (j.m_edgeA.next)
	{
		j.m_edgeA.next.prev = j.m_edgeA.prev;
	}

	if (j.m_edgeA == bodyA.m_jointList)
	{
		bodyA.m_jointList = j.m_edgeA.next;
	}

	j.m_edgeA.prev = null;
	j.m_edgeA.next = null;

	// Remove from body 2
	if (j.m_edgeB.prev != null)
	{
		j.m_edgeB.prev.next = j.m_edgeB.next;
	}

	if (j.m_edgeB.next != null)
	{
		j.m_edgeB.next.prev = j.m_edgeB.prev;
	}

	if (j.m_edgeB == bodyB.m_jointList)
	{
		bodyB.m_jointList = j.m_edgeB.next;
	}

	j.m_edgeB.prev = null;
	j.m_edgeB.next = null;

	b2Joint.Destroy(j, m_blockAllocator);

	//b2Assert(m_jointCount > 0);
	--m_jointCount;

	// If the joint prevents collisions, then flag any contacts for filtering.
	if (collideConnected == false)
	{
		var edge:b2ContactEdge = bodyB.GetConactList();
		while (edge != null)
		{
			if (edge.other == bodyA)
			{
				// Flag the contact for filtering at the next time step (where either
				// body is awake).
				edge.contact.FlagForFiltering();
			}

			edge = edge.next;
		}
	}
}

// Find islands, integrate and solve constraints, solve position constraints
public function Solve(step:b2TimeStep):void
{
	var b:b2Body;
	var c:b2Contact;
	var j:b2Joint;
	
	var i:int;
	
	// Size the island for the worst case.
	var island:b2Island = new b2Island (m_bodyCount,
										m_contactManager.m_contactCount,
										m_jointCount,
										m_stackAllocator,
										m_contactManager.m_contactListener);

	// Clear all the island flags.
	for (b = m_bodyList; b != null; b = b.m_next)
	{
		b.m_flags &= ~b2Body.e_islandFlag;
	}
	for (c = m_contactManager.m_contactList; c != null; c = c.m_next)
	{
		c.m_flags &= ~b2Contact.e_islandFlag;
	}
	for (j = m_jointList; j != null; j = j.m_next)
	{
		j.m_islandFlag = false;
	}

	// Build and simulate all awake islands.
	var stackSize:int = m_bodyCount;
	//b2Body** stack = (b2Body**)m_stackAllocator.Allocate(stackSize * sizeof(b2Body*));
	var stack:Array = new Array (stackSize);
	for (var seed:b2Body = m_bodyList; seed != null; seed = seed.m_next)
	{
		if (seed.m_flags & (b2Body.e_islandFlag | b2Body.e_sleepFlag))
		{
			continue;
		}

		if (seed.IsStatic())
		{
			continue;
		}

		// Reset island and stack.
		island.Clear();
		var stackCount:int = 0;
		stack[stackCount++] = seed;
		seed.m_flags |= b2Body.e_islandFlag;

		// Perform a depth first search (DFS) on the constraint graph.
		while (stackCount > 0)
		{
			// Grab the next body off the stack and add it to the island.
			b = stack[--stackCount];
			island.AddBody (b);

			// Make sure the body is awake.
			b.m_flags &= ~b2Body.e_sleepFlag;

			// To keep islands as small as possible, we don't
			// propagate islands across static bodies.
			if (b.IsStatic())
			{
				continue;
			}

			// Search all contacts connected to this body.
			for (var ce:b2ContactEdge = b.m_contactList; ce != null; ce = ce.next)
			{
				// Has this contact already been added to an island?
				if (ce.contact.m_flags & b2Contact.e_islandFlag)
				{
					continue;
				}

				// Is this contact solid and touching?
				if (ce.contact.IsSolid() == false || ce.contact.IsTouching() == false)
				{
					continue;
				}

				island.AddContact (ce.contact);
				ce.contact.m_flags |= b2Contact.e_islandFlag;

				var other1:b2Body = ce.other;

				// Was the other body already added to this island?
				if (other1.m_flags & b2Body.e_islandFlag)
				{
					continue;
				}

				//b2Assert(stackCount < stackSize);
				stack[stackCount++] = other1;
				other1.m_flags |= b2Body.e_islandFlag;
			}

			// Search all joints connect to this body.
			for (var je:b2JointEdge = b.m_jointList; je != null; je = je.next)
			{
				if (je.joint.m_islandFlag == true)
				{
					continue;
				}

				island.AddJoint (je.joint);
				je.joint.m_islandFlag = true;

				var other2:b2Body = je.other;
				if (other2.m_flags & b2Body.e_islandFlag)
				{
					continue;
				}

				//b2Assert(stackCount < stackSize);
				stack[stackCount++] = other2;
				other2.m_flags |= b2Body.e_islandFlag;
			}
		}

		island.Solve(step, m_gravity, m_allowSleep);

		// Post solve cleanup.
		for (i = 0; i < island.m_bodyCount; ++i)
		{
			// Allow static bodies to participate in other islands.
			var b2:b2Body = island.m_bodies[i];
			if (b2.IsStatic())
			{
				b2.m_flags &= ~b2Body.e_islandFlag;
			}
		}
	}

	//m_stackAllocator.Free(stack);

	// Synchronize fixtures, check for out of range bodies.
	for (b = m_bodyList; b != null; b = b.GetNext())
	{
		if (b.m_flags & b2Body.e_sleepFlag)
		{
			continue;
		}

		if (b.IsStatic())
		{
			continue;
		}

		// Update fixtures (for broad-phase).
		b.SynchronizeFixtures();
	}

	// Look for new contacts.
	m_contactManager.FindNewContacts();
}

// Find TOI contacts and solve them.
public function SolveTOI(step:b2TimeStep):void
{
	var b:b2Body;
	var c:b2Contact;
	var j:b2Joint;
	
	var s1:b2Fixture;
	var s2:b2Fixture;
	var b1:b2Body;
	var b2:b2Body;
	
	var i:int;
	
	// Reserve an island and a queue for TOI island solution.
	var island:b2Island = new b2Island (m_bodyCount,
										b2Settings.b2_maxTOIContactsPerIsland,
										b2Settings.b2_maxTOIJointsPerIsland,
										m_stackAllocator,
										m_contactManager.m_contactListener);

	//Simple one pass queue
	//Relies on the fact that we're only making one pass
	//through and each body can only be pushed/popped once.
	//To push: 
	//  queue[queueStart+queueSize++] = newElement;
	//To pop: 
	//	poppedElement = queue[queueStart++];
	//  --queueSize;
	var queueCapacity:int = m_bodyCount;
	//b2Body** queue = (b2Body**)m_stackAllocator.Allocate(queueCapacity* sizeof(b2Body*));
	var queue:Array = new Array (queueCapacity);

	for (b = m_bodyList; b != null; b = b.m_next)
	{
		b.m_flags &= ~b2Body.e_islandFlag;
		b.m_sweep.t0 = 0.0;
	}

	for (c = m_contactManager.m_contactList; c != null; c = c.m_next)
	{
		// Invalidate TOI
		c.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
	}

	for (j = m_jointList; j != null; j = j.m_next)
	{
		j.m_islandFlag = false;
	}

	// Find TOI events and solve them.
	for (;;)
	{
		// Find the first TOI.
		var minContact:b2Contact = null;
		var minTOI:Number = 1.0;

		for (c = m_contactManager.m_contactList; c != null; c = c.m_next)
		{
			// Can this contact generate a solid TOI contact?
			if (c.IsSolid() == false || c.IsContinuous() == false)
			{
				continue;
			}

			// TODO_ERIN keep a counter on the contact, only respond to M TOIs per contact.

			var toi:Number = 1.0;
			if (c.m_flags & b2Contact.e_toiFlag)
			{
				// This contact has a valid cached TOI.
				toi = c.m_toi;
			}
			else
			{
				// Compute the TOI for this contact.
				s1 = c.GetFixtureA();
				s2 = c.GetFixtureB();
				b1 = s1.GetBody();
				b2 = s2.GetBody();

				if ((b1.IsStatic() || b1.IsSleeping()) && (b2.IsStatic() || b2.IsSleeping()))
				{
					continue;
				}

				// Put the sweeps onto the same time interval.
				var t0:Number = b1.m_sweep.t0;

				if (b1.m_sweep.t0 < b2.m_sweep.t0)
				{
					t0 = b2.m_sweep.t0;
					b1.m_sweep.Advance(t0);
				}
				else if (b2.m_sweep.t0 < b1.m_sweep.t0)
				{
					t0 = b1.m_sweep.t0;
					b2.m_sweep.Advance(t0);
				}

				//b2Assert(t0 < 1.0f);

				// Compute the time of impact.
				toi = c.ComputeTOI(b1.m_sweep, b2.m_sweep);

				//b2Assert(0.0f <= toi && toi <= 1.0f);

				// If the TOI is in range ...
				if (0.0 < toi && toi < 1.0)
				{
					// Interpolate on the actual range.
					toi = Math.min((1.0 - toi) * t0 + toi, 1.0);
				}


				c.m_toi = toi;
				c.m_flags |= b2Contact.e_toiFlag;
			}

			if (b2Settings.B2_FLT_EPSILON < toi && toi < minTOI)
			{
				// This is the minimum TOI found so far.
				minContact = c;
				minTOI = toi;
			}
		}

		if (minContact == null || 1.0 - 100.0 * b2Settings.B2_FLT_EPSILON < minTOI)
		{
			// No more TOI events. Done!
			break;
		}
		
		// Advance the bodies to the TOI.
		s1 = minContact.GetFixtureA();
		s2 = minContact.GetFixtureB();
		b1 = s1.GetBody();
		b2 = s2.GetBody();

		var backup1:b2Sweep = b1.m_sweep.Clone ();
		var backup2:b2Sweep = b2.m_sweep.Clone ();

		b1.Advance(minTOI);
		b2.Advance(minTOI);

		// The TOI contact likely has some new contact points.
		minContact.Update(m_contactManager.m_contactListener);
		minContact.m_flags &= ~b2Contact.e_toiFlag;

		// Is the contact solid?
		if (minContact.IsSolid() == false)
		{
			// Restore the sweeps.
			//b1->m_sweep = backup1;
			//b2->m_sweep = backup2;
			b1.m_sweep.CopyFrom (backup1);
			b2.m_sweep.CopyFrom (backup2);
			b1.SynchronizeTransform();
			b2.SynchronizeTransform();
			continue;
		}

		// Did numerical issues prevent a contact point from being generated?
		if (minContact.IsTouching() == false)
		{
			// Give up on this TOI.
			continue;
		}

		// Build the TOI island. We need a dynamic seed.
		var seed:b2Body = b1;
		if (seed.IsStatic())
		{
			seed = b2;
		}

		// Reset island and queue.
		island.Clear();

		var queueStart:int = 0; // starting index for queue
		var queueSize:int = 0;  // elements in queue
		queue[queueStart + queueSize++] = seed;
		seed.m_flags |= b2Body.e_islandFlag;

		// Perform a breadth first search (BFS) on the contact/joint graph.
		while (queueSize > 0)
		{
			// Grab the next body off the stack and add it to the island.
			b = queue[queueStart++];
			--queueSize;

			island.AddBody (b);

			// Make sure the body is awake.
			b.m_flags &= ~b2Body.e_sleepFlag;

			// To keep islands as small as possible, we don't
			// propagate islands across static bodies.
			if (b.IsStatic())
			{
				continue;
			}

			// Search all contacts connected to this body.
			for (var cEdge:b2ContactEdge = b.m_contactList; cEdge != null; cEdge = cEdge.next)
			{
				// Does the TOI island still have space for contacts?
				if (island.m_contactCount == island.m_contactCapacity)
				{
					continue;
				}

				// Has this contact already been added to an island?
				if (cEdge.contact.m_flags & b2Contact.e_islandFlag)
				{
					continue;
				}

				// Skip separate, sensor, or disabled contacts.
				if (cEdge.contact.IsSolid() == false || cEdge.contact.IsTouching() == false)
				{
					continue;
				}

				island.AddContact (cEdge.contact);
				cEdge.contact.m_flags |= b2Contact.e_islandFlag;

				// Update other body.
				var other1:b2Body = cEdge.other;

				// Was the other body already added to this island?
				if (other1.m_flags & b2Body.e_islandFlag)
				{
					continue;
				}

				// March forward, this can do no harm since this is the min TOI.
				if (other1.IsStatic() == false)
				{
					other1.Advance(minTOI);
					other1.WakeUp();
				}

				//b2Assert(queueStart + queueSize < queueCapacity);
				queue[queueStart + queueSize] = other1;
				++queueSize;
				other1.m_flags |= b2Body.e_islandFlag;
			}

			for (var jEdge:b2JointEdge = b.m_jointList; jEdge != null; jEdge = jEdge.next)
			{
				if (island.m_jointCount == island.m_jointCapacity)
				{
					continue;
				}

				if (jEdge.joint.m_islandFlag == true)
				{
					continue;
				}

				island.AddJoint (jEdge.joint);

				jEdge.joint.m_islandFlag = true;

				var other2:b2Body = jEdge.other;

				if (other2.m_flags & b2Body.e_islandFlag)
				{
					continue;
				}

				if (!other2.IsStatic())
				{
					other2.Advance(minTOI);
					other2.WakeUp();
				}

				//b2Assert(queueStart + queueSize < queueCapacity);
				queue[queueStart + queueSize] = other2;
				++queueSize;
				other2.m_flags |= b2Body.e_islandFlag;
			}
		}

		var subStep:b2TimeStep = new b2TimeStep ();
		subStep.warmStarting = false;
		subStep.dt = (1.0 - minTOI) * step.dt;
		subStep.inv_dt = 1.0 / subStep.dt;
		subStep.dtRatio = 0.0;
		subStep.velocityIterations = step.velocityIterations;
		subStep.positionIterations = step.positionIterations;

		island.SolveTOI(subStep);

		// Post solve cleanup.
		for (i = 0; i < island.m_bodyCount; ++i)
		{
			// Allow bodies to participate in future TOI islands.
			b = island.m_bodies[i];
			b.m_flags &= ~b2Body.e_islandFlag;

			if (b.m_flags & b2Body.e_sleepFlag)
			{
				continue;
			}

			if (b.IsStatic())
			{
				continue;
			}

			// Update fixtures (for broad-phase).
			b.SynchronizeFixtures();

			// Invalidate all contact TOIs associated with this body. Some of these
			// may not be in the island because they were not touching.
			for (var ce:b2ContactEdge = b.m_contactList; ce != null; ce = ce.next)
			{
				ce.contact.m_flags &= ~b2Contact.e_toiFlag;
			}
		}

		for (i = 0; i < island.m_contactCount; ++i)
		{
			// Allow contacts to participate in future TOI islands.
			c = island.m_contacts[i];
			c.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
		}

		for (i = 0; i < island.m_jointCount; ++i)
		{
			// Allow joints to participate in future TOI islands.
			j = island.m_joints[i];
			j.m_islandFlag = false;
		}

		// Commit fixture proxy movements to the broad-phase so that new contacts are created.
		// Also, some contacts can be destroyed.
		m_contactManager.FindNewContacts();
	}

	//m_stackAllocator.Free(queue);
}

public function Step(dt:Number, velocityIterations:int, positionIterations:int):void
{
	var height:int;
	height = m_contactManager.m_broadPhase.ComputeHeight();

	// If new fixtures were added, we need to find the new contacts.
	if (m_flags & e_newFixture)
	{
		m_contactManager.FindNewContacts();
		m_flags &= ~e_newFixture;
	}

	m_flags |= e_locked;

	var step:b2TimeStep = new b2TimeStep ();
	step.dt = dt;
	step.velocityIterations	= velocityIterations;
	step.positionIterations = positionIterations;
	if (dt > 0.0)
	{
		step.inv_dt = 1.0 / dt;
	}
	else
	{
		step.inv_dt = 0.0;
	}

	step.dtRatio = m_inv_dt0 * dt;

	step.warmStarting = m_warmStarting;

//var t1:Number = getTimer ();

	// Update contacts. This is where some contacts are destroyed.
	m_contactManager.Collide();

//var t2:Number = getTimer ();
//trace ("dt Collide = " + (t2 - t1));
//t1 = getTimer ();

	// Integrate velocities, solve velocity constraints, and integrate positions.
	if (step.dt > 0.0)
	{
		Solve(step);
	}

//t2 = getTimer ();
//trace ("dt Solve = " + (t2 - t1));
//t1 = getTimer ();

	// Handle TOI events.
	if (m_continuousPhysics && step.dt > 0.0)
	{
		SolveTOI(step);
	}

//t2 = getTimer ();
//trace ("dt Solve toi = " + (t2 - t1));
//t1 = getTimer ();

	if (step.dt > 0.0)
	{
		m_inv_dt0 = step.inv_dt;
	}

	m_flags &= ~e_locked;
}

//struct b2WorldQueryWrapper
//{
	//@see b2WorldQueryWrapper.as
//};

public function QueryAABB(callback:b2QueryCallback, aabb:b2AABB):void
{
	var wrapper:b2WorldQueryWrapper = new b2WorldQueryWrapper ();
	wrapper.broadPhase = m_contactManager.m_broadPhase;
	wrapper.callback = callback;
	m_contactManager.m_broadPhase.Query(wrapper, aabb);
}

//struct b2WorldRayCastWrapper
//{
	//@see b2WorldRayCastWrapper.as
//};

public function RayCast(callback:b2RayCastCallback, point1:b2Vec2, point2:b2Vec2):void
{
	var wrapper:b2WorldRayCastWrapper = new b2WorldRayCastWrapper ();
	wrapper.broadPhase = m_contactManager.m_broadPhase;
	wrapper.callback = callback;
	var input:b2RayCastInput = new b2RayCastInput ();
	input.maxFraction = 1.0;
	input.p1 = point1;
	input.p2 = point2;
	m_contactManager.m_broadPhase.RayCast(wrapper, input);
}

public function DrawShape(fixture:b2Fixture, xf:b2Transform, color:b2Color):void
{
	/*
	b2Color coreColor(0.9f, 0.6f, 0.6f);

	switch (fixture->GetType())
	{
	case b2Shape::e_circle:
		{
			b2CircleShape* circle = (b2CircleShape*)fixture->GetShape();

			b2Vec2 center = b2Mul(xf, circle->m_p);
			float32 radius = circle->m_radius;
			b2Vec2 axis = xf.R.col1;

			m_debugDraw->DrawSolidCircle(center, radius, axis, color);
		}
		break;

	case b2Shape::e_polygon:
		{
			b2PolygonShape* poly = (b2PolygonShape*)fixture->GetShape();
			int32 vertexCount = poly->m_vertexCount;
			b2Assert(vertexCount <= b2Settings.b2_maxPolygonVertices);
			b2Vec2 vertices[b2Settings.b2_maxPolygonVertices];

			for (int32 i = 0; i < vertexCount; ++i)
			{
				vertices[i] = b2Mul(xf, poly->m_vertices[i]);
			}

			m_debugDraw->DrawSolidPolygon(vertices, vertexCount, color);
		}
		break;
	}
	*/
}

public function DrawJoint(joint:b2Joint):void
{
	/*
	b2Body* b1 = joint->GetBody1();
	b2Body* b2 = joint->GetBody2();
	const b2Transform& xf1 = b1->GetTransform();
	const b2Transform& xf2 = b2->GetTransform();
	b2Vec2 x1 = xf1.position;
	b2Vec2 x2 = xf2.position;
	b2Vec2 p1 = joint->GetAnchor1();
	b2Vec2 p2 = joint->GetAnchor2();

	b2Color color(0.5f, 0.8f, 0.8f);

	switch (joint->GetType())
	{
	case e_distanceJoint:
		m_debugDraw->DrawSegment(p1, p2, color);
		break;

	case e_pulleyJoint:
		{
			b2PulleyJoint* pulley = (b2PulleyJoint*)joint;
			b2Vec2 s1 = pulley->GetGroundAnchor1();
			b2Vec2 s2 = pulley->GetGroundAnchor2();
			m_debugDraw->DrawSegment(s1, p1, color);
			m_debugDraw->DrawSegment(s2, p2, color);
			m_debugDraw->DrawSegment(s1, s2, color);
		}
		break;

	case e_mouseJoint:
		// don't draw this
		break;

	default:
		m_debugDraw->DrawSegment(x1, p1, color);
		m_debugDraw->DrawSegment(p1, p2, color);
		m_debugDraw->DrawSegment(x2, p2, color);
	}
	*/
}

public function DrawDebugData():void
{
	/*
	if (m_debugDraw == NULL)
	{
		return;
	}

	uint32 flags = m_debugDraw->GetFlags();

	if (flags & b2DebugDraw::e_shapeBit)
	{
		for (b2Body* b = m_bodyList; b; b = b->GetNext())
		{
			const b2Transform& xf = b->GetTransform();
			for (b2Fixture* f = b->GetFixtureList(); f; f = f->GetNext())
			{
				if (b->IsStatic())
				{
					DrawShape(f, xf, b2Color(0.5f, 0.9f, 0.5f));
				}
				else if (b->IsSleeping())
				{
					DrawShape(f, xf, b2Color(0.5f, 0.5f, 0.9f));
				}
				else
				{
					DrawShape(f, xf, b2Color(0.9f, 0.9f, 0.9f));
				}
			}
		}
	}

	if (flags & b2DebugDraw::e_jointBit)
	{
		for (b2Joint* j = m_jointList; j; j = j->GetNext())
		{
			if (j->GetType() != e_mouseJoint)
			{
				DrawJoint(j);
			}
		}
	}

	if (flags & b2DebugDraw::e_pairBit)
	{
		// TODO_ERIN
	}

	if (flags & b2DebugDraw::e_aabbBit)
	{
		b2Color color(0.9f, 0.3f, 0.9f);
		b2BroadPhase* bp = &m_contactManager.m_broadPhase;

		for (b2Body* b = m_bodyList; b; b = b->GetNext())
		{
			for (b2Fixture* f = b->GetFixtureList(); f; f = f->GetNext())
			{
				b2AABB aabb = bp->GetFatAABB(f->m_proxyId);
				b2Vec2 vs[4];
				vs[0].Set(aabb.lowerBound.x, aabb.lowerBound.y);
				vs[1].Set(aabb.upperBound.x, aabb.lowerBound.y);
				vs[2].Set(aabb.upperBound.x, aabb.upperBound.y);
				vs[3].Set(aabb.lowerBound.x, aabb.upperBound.y);

				m_debugDraw->DrawPolygon(vs, 4, color);
			}
		}
	}

	if (flags & b2DebugDraw::e_centerOfMassBit)
	{
		for (b2Body* b = m_bodyList; b; b = b->GetNext())
		{
			b2Transform xf = b->GetTransform();
			xf.position = b->GetWorldCenter();
			m_debugDraw->DrawXForm(xf);
		}
	}
	*/
}

public function GetProxyCount():int
{
	return m_contactManager.m_broadPhase.GetProxyCount();
}
