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

public static function b2World_FromWorldDefine (worldDef:b2WorldDef):b2World
{
	var world:b2World = new b2World (null, false, false);
	world.Create (worldDef);
	
	return world;
}

public function b2World(gravity:b2Vec2, doSleep:Boolean, createNow:Boolean = true)
{
	if (! createNow)
		return;
	
	var worldDef:b2WorldDef = new b2WorldDef ();
	if (gravity != null)
	{
		worldDef.gravity.x = gravity.x;
		worldDef.gravity.y = gravity.y;
	}
	worldDef.doSleep = doSleep;
	
	Create (worldDef);
}

private function Create (worldDef:b2WorldDef = null):void
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

	//>> hacking
	b2_maxTranslation = worldDef.maxTranslation;
	b2_maxTranslationSquared = worldDef.maxTranslation * worldDef.maxTranslation;
	//<<

	m_flags = e_clearForces;

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
		
		//>> patch, if is possible the 2 bodies of a joint are the same body., 
		// which means there are 2 same joints in the joint list of a body
		// this block doesn't exist in v++ version
		var prev_je:b2JointEdge = je0;
		var next_je:b2JointEdge = prev_je.next;
		while (next_je != null)
		{
			if (next_je.joint == je0.joint)
			{
				prev_je.next = next_je.next;
				break;
			}
			
			prev_je = next_je;
			next_je = prev_je.next;
		}
		//<<
		
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
		f0.DestroyProxy(m_contactManager.m_broadPhase);
		f0.Destroy(m_blockAllocator);
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

	var bodyA:b2Body = def.bodyA;
	var bodyB:b2Body = def.bodyB;

	// If the joint prevents collisions, then flag any contacts for filtering.
	if (def.collideConnected == false)
	{
		var edge:b2ContactEdge = bodyB.GetContactList();
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
	bodyA.SetAwake(true);
	bodyB.SetAwake(true);

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
		var edge:b2ContactEdge = bodyB.GetContactList();
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
	//var island:b2Island = new b2Island (m_bodyCount,
	//									m_contactManager.m_contactCount,
	//									m_jointCount,
	//									m_stackAllocator,
	//									//m_contactManager.m_contactListener
	//									m_contactManager.m_contactPostSolveListener
	//									);
	var island:b2Island = GetIsland (m_jointCount, m_contactManager.m_contactCount);

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
		if (seed.m_flags & b2Body.e_islandFlag)
		{
			continue;
		}

		if (seed.IsAwake() == false || seed.IsActive() == false)
		{
			continue;
		}

		// The seed can be dynamic or kinematic.
		if (seed.GetType() == b2Body.b2_staticBody)
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
			//b2Assert(b->IsActive() == true);
			island.AddBody (b);

			// Make sure the body is awake.
			b.SetAwake(true);

			// To keep islands as small as possible, we don't
			// propagate islands across static bodies.
			if (b.GetType() == b2Body.b2_staticBody)
			{
				continue;
			}

			// Search all contacts connected to this body.
			for (var ce:b2ContactEdge = b.m_contactList; ce != null; ce = ce.next)
			{
				var contact:b2Contact = ce.contact;
				
				// Has this contact already been added to an island?
				if (contact.m_flags & b2Contact.e_islandFlag)
				{
					continue;
				}

				// Is this contact solid and touching?
				if (contact.IsEnabled() == false ||
					contact.IsTouching() == false)
				{
					continue;
				}

				// Skip sensors.
				var sensorA:Boolean = contact.m_fixtureA.m_isSensor;
				var sensorB:Boolean = contact.m_fixtureB.m_isSensor;
				if (sensorA || sensorB)
				{
					continue;
				}

				island.AddContact (contact);
				contact.m_flags |= b2Contact.e_islandFlag;

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

				var other2:b2Body = je.other;

				// Don't simulate joints connected to inactive bodies.
				if (other2.IsActive() == false)
				{
					continue;
				}

				island.AddJoint (je.joint);
				je.joint.m_islandFlag = true;

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
			if (b2.GetType() == b2Body.b2_staticBody)
			{
				b2.m_flags &= ~b2Body.e_islandFlag;
			}
		}
	}

	//m_stackAllocator.Free(stack);

	// Synchronize fixtures, check for out of range bodies.
	for (b = m_bodyList; b != null; b = b.GetNext())
	{
		// If a body was not in an island then it did not move.
		if ((b.m_flags & b2Body.e_islandFlag) == 0) 
		{
			continue;
		}

		if (b.GetType() == b2Body.b2_staticBody)
		{
			continue;
		}

		// Update fixtures (for broad-phase).
		b.SynchronizeFixtures();
	}

	// Look for new contacts.
	m_contactManager.FindNewContacts();
}

private static var sTOIInput:b2TOIInput = new b2TOIInput ();
private static var sTOIOutput:b2TOIOutput = new b2TOIOutput ();
private static var sSweep:b2Sweep = new b2Sweep ();

private static var sContactPointerArray:Array = new Array (b2Settings.b2_maxTOIContacts);
private static var sTOISolver:b2TOISolver = null; // new b2TOISolver (m_stackAllocator);

// Advance a dynamic body to its first time of contact
// and adjust the position to ensure clearance.
public function SolveTOI_Body (body:b2Body):void
{
	// Find the minimum contact.
	var toiContact:b2Contact = null;
	var toi:Number = 1.0;
	var found:Boolean;
	var count:int;
	var iter:int = 0;

	var bullet:Boolean = body.IsBullet();

	var ce:b2ContactEdge;

	var other:b2Body;
	var type:int;
	var contact:b2Contact;
	var fixtureA:b2Fixture;
	var fixtureB:b2Fixture;
	var bodyA:b2Body;
	var bodyB:b2Body;

	// Iterate until all contacts agree on the minimum TOI. We have
	// to iterate because the TOI algorithm may skip some intermediate
	// collisions when objects rotate through each other.
	do
	{
		count = 0;
		found = false;
		for (ce = body.m_contactList; ce != null; ce = ce.next)
		{
			if (ce.contact == toiContact)
			{
				continue;
			}
			
			other = ce.other;
			type = other.GetType();

			// Only bullets perform TOI with dynamic bodies.
			if (bullet == true)
			{
				// Bullets only perform TOI with bodies that have their TOI resolved.
				if ((other.m_flags & b2Body.e_toiFlag) == 0)
				{
					continue;
				}
			}
			else if (type == b2Body.b2_dynamicBody)
			{
				continue;
			}

			// Check for a disabled contact.
			contact = ce.contact;
			if (contact.IsEnabled() == false)
			{
				continue;
			}

			// Prevent infinite looping.
			if (contact.m_toiCount > 10)
			{
				continue;
			}

			fixtureA = contact.m_fixtureA;
			fixtureB = contact.m_fixtureB;

			// Cull sensors.
			if (fixtureA.IsSensor() || fixtureB.IsSensor())
			{
				continue;
			}

			bodyA = fixtureA.m_body;
			bodyB = fixtureB.m_body;

			// Compute the time of impact in interval [0, minTOI]
			var input:b2TOIInput = sTOIInput;
			input.proxyA.Set(fixtureA.GetShape());
			input.proxyB.Set(fixtureB.GetShape());
			input.sweepA = bodyA.m_sweep;
			input.sweepB = bodyB.m_sweep;
			input.tMax = toi;

			var output:b2TOIOutput = sTOIOutput;
			b2TimeOfImpact.b2TimeOfImpact_ (output, input);

			if (output.state == b2TOIOutput.e_touching && output.t < toi)
			{
				toiContact = contact;
				toi = output.t;
				found = true;
			}

			++count;
		}

		++iter;
	} while (found && count > 1 && iter < 50);

	// Advance the body to its safe time.
	var backup:b2Sweep = sSweep;
	backup.CopyFrom (body.m_sweep);
	body.Advance(toi);

	if (toiContact == null)
	{
		return;
	}

	++toiContact.m_toiCount;

	// Update all the valid contacts on this body and build a contact island.
	//b2Contact* contacts[b2_maxTOIContactsPerIsland];
	var contacts:Array = sContactPointerArray;
	
	count = 0;
	for (ce = body.m_contactList; (ce != null) && (count < b2Settings.b2_maxTOIContacts); ce = ce.next)
	{
		other = ce.other;
		type = other.GetType();

		// Only perform correction with static bodies, so the
		// body won't get pushed out of the world.
		if (type != b2Body.b2_staticBody)
		{
			continue;
		}

		// Check for a disabled contact.
		contact = ce.contact;
		if (contact.IsEnabled() == false)
		{
			continue;
		}

		fixtureA = contact.m_fixtureA;
		fixtureB = contact.m_fixtureB;

		// Cull sensors.
		if (fixtureA.IsSensor() || fixtureB.IsSensor())
		{
			continue;
		}

		// The contact likely has some new contact points. The listener
		// gives the user a chance to disable the contact;
		contact.Update(m_contactManager.m_contactListener
							//, m_contactManager.m_contactPreSolveListener
							);

		// Did the user disable the contact?
		if (contact.IsEnabled() == false)
		{
			if (contact == toiContact)
			{
				// Restore the body's sweep.
				body.m_sweep.CopyFrom (backup); // as3: can ref assign?
				body.SynchronizeTransform();

				// Recurse because the TOI has been invalidated.
				SolveTOI_Body (body);
				
				return;
			}

			// Skip this contact.
			continue;
		}

		if (contact.IsTouching() == false)
		{
			continue;
		}

		contacts[count] = contact;
		++count;
	}

	//>> hacking
	if (sTOISolver == null)
		sTOISolver = new b2TOISolver (m_stackAllocator)
	//<<

	// Reduce the TOI body's overlap with the contact island.
	var solver:b2TOISolver = sTOISolver;
	solver.Initialize(contacts, count, body);

	const k_toiBaumgarte:Number = 0.75;
	var solved:Boolean = false;
	for (var i:int = 0; i < 20; ++i)
	{
		var contactsOkay:Boolean = solver.Solve(k_toiBaumgarte);
		
		if (contactsOkay)
		{
			solved = true;
			break;
		}
	}
}

// Sequentially solve TOIs for each body. We bring each
// body to the time of contact and perform some position correction.
// Time is not conserved.
public function SolveTOI():void
{
	// Prepare all contacts.
	for (var c:b2Contact = m_contactManager.m_contactList; c != null; c = c.m_next)
	{
		// Enable the contact
		c.m_flags |= b2Contact.e_enabledFlag;

		// Set the number of TOI events for this contact to zero.
		c.m_toiCount = 0;
	}

	var body:b2Body;

	// Initialize the TOI flag.
	for (body = m_bodyList; body != null; body = body.m_next)
	{
		// Kinematic, and static bodies will not be affected by the TOI event.
		// If a body was not in an island then it did not move.
		if ((body.m_flags & b2Body.e_islandFlag) == 0 || body.GetType() == b2Body.b2_kinematicBody || body.GetType() == b2Body.b2_staticBody)
		{
			body.m_flags |= b2Body.e_toiFlag;
		}
		else
		{
			body.m_flags &= ~b2Body.e_toiFlag;
		}
	}

	// Collide non-bullets.
	for (body = m_bodyList; body != null; body = body.m_next)
	{
		if (body.m_flags & b2Body.e_toiFlag)
		{
			continue;
		}

		if (body.IsBullet() == true)
		{
			continue;
		}

		SolveTOI_Body (body);

		body.m_flags |= b2Body.e_toiFlag;
	}

	// Collide bullets.
	for ( body = m_bodyList; body != null; body = body.m_next)
	{
		if (body.m_flags & b2Body.e_toiFlag)
		{
			continue;
		}

		if (body.IsBullet() == false)
		{
			continue;
		}

		SolveTOI_Body (body);

		body.m_flags |= b2Body.e_toiFlag;
	}
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
		SolveTOI();
	}

//t2 = getTimer ();
//trace ("dt Solve toi = " + (t2 - t1));
//t1 = getTimer ();

	if (step.dt > 0.0)
	{
		m_inv_dt0 = step.inv_dt;
	}

	if (m_flags & e_clearForces)
	{
		ClearForces();
	}

	m_flags &= ~e_locked;
}

public function ClearForces():void
{
	for (var body:b2Body = m_bodyList; body != null; body = body.GetNext())
	{
		body.m_force.SetZero();
		body.m_torque = 0.0;
	}
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
}

public function DrawJoint(joint:b2Joint):void
{
}

public function DrawDebugData():void
{
}

public function GetProxyCount():int
{
	return m_contactManager.m_broadPhase.GetProxyCount();
}
