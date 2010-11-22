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
//#include <Box2D/Collision/Shapes/b2EdgeShape.h>
//#include <Box2D/Collision/Shapes/b2LoopShape.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>
//#include <Box2D/Collision/b2TimeOfImpact.h>

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
	m_subStepping = false;

	m_stepComplete = true;


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
	// Some shapes allocate using b2Alloc.
	//b2Body* b = m_bodyList;
	//while (b)
	//{
	//	b2Body* bNext = b->m_next;
	//
	//	b2Fixture* f = b->m_fixtureList;
	//	while (f)
	//	{
	//		b2Fixture* fNext = f->m_next;
	//		f->m_proxyCount = 0;
	//		f->Destroy(&m_blockAllocator);
	//		f = fNext;
	//	}
	//
	//	b = bNext;
	//}
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

		b.m_jointList = je;
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
		f0.DestroyProxies(m_contactManager.m_broadPhase);
		f0.Destroy(m_blockAllocator);
		//f0->~b2Fixture();
		f0._b2Fixture ();
		//m_blockAllocator.Free(f0, sizeof(b2Fixture));

		b.m_fixtureList = f;
		b.m_fixtureCount -= 1;
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
	var island:b2Island = GetIsland (m_bodyCount, m_jointCount, m_contactManager.m_contactCount);

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
private static var sBackupSweep1:b2Sweep = new b2Sweep ();
private static var sBackupSweep2:b2Sweep = new b2Sweep ();
private static var sBackupSweep:b2Sweep = new b2Sweep ();
private static var sSubTimeStep:b2TimeStep = new b2TimeStep ();

// Find TOI contacts and solve them.
public function SolveTOI(step:b2TimeStep):void
{
	//b2Island island(2 * b2_maxTOIContacts, b2_maxTOIContacts, 0, &m_stackAllocator, m_contactManager.m_contactListener);
	var island:b2Island = GetIsland (2 * b2Settings.b2_maxTOIContacts, 0, b2Settings.b2_maxTOIContacts);

	if (m_stepComplete)
	{
		for (var b1:b2Body = m_bodyList; b1 != null; b1 = b1.m_next)
		{
			b1.m_flags &= ~b2Body.e_islandFlag;
			b1.m_sweep.alpha0 = 0.0;
		}

		for (var c1:b2Contact = m_contactManager.m_contactList; c1 != null; c1 = c1.m_next)
		{
			// Invalidate TOI
			c1.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
			c1.m_toiCount = 0;
			c1.m_toi = 1.0;
		}
	}

	var fA:b2Fixture;
	var fB:b2Fixture;
	var bA:b2Body;
	var bB:b2Body;

	// Find TOI events and solve them.
	for (;;)
	{
		// Find the first TOI.
		var minContact:b2Contact = null;
		var minAlpha:Number = 1.0;

		for (var c:b2Contact = m_contactManager.m_contactList; c != null; c = c.m_next)
		{
			// Is this contact disabled?
			if (c.IsEnabled() == false)
			{
				continue;
			}

			// Prevent excessive sub-stepping.
			if (c.m_toiCount > b2Settings.b2_maxSubSteps)
			{
				continue;
			}

			var alpha:Number = 1.0;
			if ( (c.m_flags & b2Contact.e_toiFlag) != 0)
			{
				// This contact has a valid cached TOI.
				alpha = c.m_toi;
			}
			else
			{
				//b2Fixture* fA = c->GetFixtureA();
				//b2Fixture* fB = c->GetFixtureB();
				fA = c.GetFixtureA();
				fB = c.GetFixtureB();

				// Is there a sensor?
				if (fA.IsSensor() || fB.IsSensor())
				{
					continue;
				}

				//b2Body* bA = fA->GetBody();
				//b2Body* bB = fB->GetBody();
				bA = fA.GetBody();
				bB = fB.GetBody();

				//b2BodyType typeA = bA->GetType();
				//b2BodyType typeB = bB->GetType();
				var typeA:int = bA.GetType();
				var typeB:int = bB.GetType();
				//b2Assert(typeA == b2_dynamicBody || typeB == b2_dynamicBody);

				var awakeA:Boolean = bA.IsAwake() && typeA != b2Body.b2_staticBody;
				var awakeB:Boolean = bB.IsAwake() && typeB != b2Body.b2_staticBody;

				// Is at least one body awake?
				if (awakeA == false && awakeB == false)
				{
					continue;
				}

				var collideA:Boolean = bA.IsBullet() || typeA != b2Body.b2_dynamicBody;
				var collideB:Boolean = bB.IsBullet() || typeB != b2Body.b2_dynamicBody;

				// Are these two non-bullet dynamic bodies?
				if (collideA == false && collideB == false)
				{
					continue;
				}

				// Compute the TOI for this contact.
				// Put the sweeps onto the same time interval.
				var alpha0:Number = bA.m_sweep.alpha0;

				if (bA.m_sweep.alpha0 < bB.m_sweep.alpha0)
				{
					alpha0 = bB.m_sweep.alpha0;
					bA.m_sweep.Advance(alpha0);
				}
				else if (bB.m_sweep.alpha0 < bA.m_sweep.alpha0)
				{
					alpha0 = bA.m_sweep.alpha0;
					bB.m_sweep.Advance(alpha0);
				}

				//b2Assert(alpha0 < 1.0f);

				var indexA:int = c.GetChildIndexA();
				var indexB:int = c.GetChildIndexB();

				// Compute the time of impact in interval [0, minTOI]
				//b2TOIInput input;
				var input:b2TOIInput = sTOIInput; // hacking
				input.proxyA.Set(fA.GetShape(), indexA);
				input.proxyB.Set(fB.GetShape(), indexB);
				input.sweepA = bA.m_sweep; // hacking. CopyFrom ()
				input.sweepB = bB.m_sweep; // hacking. CopyFrom ()
				input.tMax = 1.0;

				//b2TOIOutput output;
				var output:b2TOIOutput = sTOIOutput; // hacking
				b2TimeOfImpact.b2TimeOfImpact_(output, input);

				// Beta is the fraction of the remaining portion of the .
				var beta:Number = output.t;
				if (output.state == b2TOIOutput.e_touching)
				{
					alpha = Math.min (alpha0 + (1.0 - alpha0) * beta, 1.0);
				}
				else
				{
					alpha = 1.0;
				}

				c.m_toi = alpha;
				c.m_flags |= b2Contact.e_toiFlag;
			}

			if (alpha < minAlpha)
			{
				// This is the minimum TOI found so far.
				minContact = c;
				minAlpha = alpha;
			}
		}

		if (minContact == null || 1.0 - 10.0 * b2Settings.b2_epsilon < minAlpha)
		{
			// No more TOI events. Done!
			m_stepComplete = true;
			break;
		}

		// Advance the bodies to the TOI.
		//b2Fixture* fA = minContact->GetFixtureA();
		//b2Fixture* fB = minContact->GetFixtureB();
		fA = minContact.GetFixtureA();
		fB = minContact.GetFixtureB();
		//b2Body* bA = fA->GetBody();
		//b2Body* bB = fB->GetBody();
		bA = fA.GetBody();
		bB = fB.GetBody();

		//b2Sweep backup1 = bA->m_sweep;
		//b2Sweep backup2 = bB->m_sweep;
		var backup1:b2Sweep = sBackupSweep1; backup1.CopyFrom (bA.m_sweep); // hacking
		var backup2:b2Sweep = sBackupSweep2; backup2.CopyFrom (bB.m_sweep); // hacking

		bA.Advance(minAlpha);
		bB.Advance(minAlpha);

		// The TOI contact likely has some new contact points.
		minContact.Update(m_contactManager.m_contactListener);
		minContact.m_flags &= ~b2Contact.e_toiFlag;
		++minContact.m_toiCount;

		// Is the contact solid?
		if (minContact.IsEnabled() == false || minContact.IsTouching() == false)
		{
			// Restore the sweeps.
			minContact.SetEnabled(false);
			bA.m_sweep.CopyFrom (backup1);
			bB.m_sweep.CopyFrom (backup2);
			bA.SynchronizeTransform();
			bB.SynchronizeTransform();
			continue;
		}

		bA.SetAwake(true);
		bB.SetAwake(true);

		// Build the island
		island.Clear();
		island.AddBody(bA);
		island.AddBody(bB);
		island.AddContact(minContact);

		bA.m_flags |= b2Body.e_islandFlag;
		bB.m_flags |= b2Body.e_islandFlag;
		minContact.m_flags |= b2Contact.e_islandFlag;

		// Get contacts on bodyA and bodyB.
		//b2Body* bodies[2] = {bA, bB};
		var i:int;
		var body:b2Body;
		for (i = 0; i < 2; ++i)
		{
			//b2Body* body = bodies[i];
			body = (i == 0 ? bA : bB); // hacking
			if (body.m_type == b2Body.b2_dynamicBody)
			{
				for (var ce:b2ContactEdge = body.m_contactList; ce!= null && island.m_bodyCount < b2Settings.b2_maxTOIContacts; ce = ce.next)
				{
					var contact:b2Contact = ce.contact;

					// Has this contact already been added to the island?
					if ((contact.m_flags & b2Contact.e_islandFlag) != 0)
					{
						continue;
					}

					// Only add static, kinematic, or bullet bodies.
					var other:b2Body = ce.other;
					if (other.m_type == b2Body.b2_dynamicBody &&
						body.IsBullet() == false && other.IsBullet() == false)
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

					// Tentatively advance the body to the TOI.
					//b2Sweep backup = other->m_sweep;
					var backup:b2Sweep = sBackupSweep; sBackupSweep.CopyFrom (other.m_sweep); // hacking
					if ((other.m_flags & b2Body.e_islandFlag) == 0)
					{
						other.Advance(minAlpha);
					}

					// Update the contact points
					contact.Update(m_contactManager.m_contactListener);

					// Was the contact disabled by the user?
					if (contact.IsEnabled() == false)
					{
						other.m_sweep.CopyFrom (backup);
						other.SynchronizeTransform();
						continue;
					}

					// Are there contact points?
					if (contact.IsTouching() == false)
					{
						other.m_sweep.CopyFrom (backup)
						other.SynchronizeTransform();
						continue;
					}

					// Add the contact to the island
					contact.m_flags |= b2Contact.e_islandFlag;
					island.AddContact(contact);

					// Has the other body already been added to the island?
					if ((other.m_flags & b2Body.e_islandFlag) != 0)
					{
						continue;
					}
					
					// Add the other body to the island.
					other.m_flags |= b2Body.e_islandFlag;

					if (other.m_type != b2Body.b2_staticBody)
					{
						other.SetAwake(true);
					}

					island.AddBody(other);
				}
			}
		}

		//b2TimeStep subStep;
		var subStep:b2TimeStep = sSubTimeStep; // hacking
		subStep.dt = (1.0 - minAlpha) * step.dt;
		subStep.inv_dt = 1.0 / subStep.dt;
		subStep.dtRatio = 1.0;
		subStep.positionIterations = 20;
		subStep.velocityIterations = step.velocityIterations;
		subStep.warmStarting = false;
		island.SolveTOI(subStep, bA, bB);

		// Reset island flags and synchronize broad-phase proxies.
		//for (int32 i = 0; i < island.m_bodyCount; ++i)
		for (i = 0; i < island.m_bodyCount; ++i)
		{
			//b2Body* body = island.m_bodies[i];
			body = island.m_bodies[i] as b2Body;
			body.m_flags &= ~b2Body.e_islandFlag;

			if (body.m_type != b2Body.b2_dynamicBody)
			{
				continue;
			}

			body.SynchronizeFixtures();

			// Invalidate all contact TOIs on this displaced body.
			for (var ce2:b2ContactEdge = body.m_contactList; ce2 != null; ce2 = ce2.next)
			{
				ce2.contact.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
			}
		}

		// Commit fixture proxy movements to the broad-phase so that new contacts are created.
		// Also, some contacts can be destroyed.
		m_contactManager.FindNewContacts();

		if (m_subStepping)
		{
			m_stepComplete = false;
			break;
		}
	}
}

public function Step(dt:Number, velocityIterations:int, positionIterations:int):void
{
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
	if (m_stepComplete && step.dt > 0.0)
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
