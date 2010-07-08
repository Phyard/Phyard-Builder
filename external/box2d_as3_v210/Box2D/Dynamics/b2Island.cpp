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

//#include <Box2D/Dynamics/b2Island.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Dynamics/b2World.h>
//#include <Box2D/Dynamics/Contacts/b2Contact.h>
//#include <Box2D/Dynamics/Contacts/b2ContactSolver.h>
//#include <Box2D/Dynamics/Joints/b2Joint.h>
//#include <Box2D/Common/b2StackAllocator.h>

/*
Position Correction Notes
=========================
I tried the several algorithms for position correction of the 2D revolute joint.
I looked at these systems:
- simple pendulum (1m diameter sphere on massless 5m stick) with initial angular velocity of 100 rad/s.
- suspension bridge with 30 1m long planks of length 1m.
- multi-link chain with 30 1m long links.

Here are the algorithms:

Baumgarte - A fraction of the position error is added to the velocity error. There is no
separate position solver.

Pseudo Velocities - After the velocity solver and position integration,
the position error, Jacobian, and effective mass are recomputed. Then
the velocity constraints are solved with pseudo velocities and a fraction
of the position error is added to the pseudo velocity error. The pseudo
velocities are initialized to zero and there is no warm-starting. After
the position solver, the pseudo velocities are added to the positions.
This is also called the First Order World method or the Position LCP method.

Modified Nonlinear Gauss-Seidel (NGS) - Like Pseudo Velocities except the
position error is re-computed for each constraint and the positions are updated
after the constraint is solved. The radius vectors (aka Jacobians) are
re-computed too (otherwise the algorithm has horrible instability). The pseudo
velocity states are not needed because they are effectively zero at the beginning
of each iteration. Since we have the current position error, we allow the
iterations to terminate early if the error becomes smaller than b2_linearSlop.

Full NGS or just NGS - Like Modified NGS except the effective mass are re-computed
each time a constraint is solved.

Here are the results:
Baumgarte - this is the cheapest algorithm but it has some stability problems,
especially with the bridge. The chain links separate easily close to the root
and they jitter as they struggle to pull together. This is one of the most common
methods in the field. The big drawback is that the position correction artificially
affects the momentum, thus leading to instabilities and false bounce. I used a
bias factor of 0.2. A larger bias factor makes the bridge less stable, a smaller
factor makes joints and contacts more spongy.

Pseudo Velocities - the is more stable than the Baumgarte method. The bridge is
stable. However, joints still separate with large angular velocities. Drag the
simple pendulum in a circle quickly and the joint will separate. The chain separates
easily and does not recover. I used a bias factor of 0.2. A larger value lead to
the bridge collapsing when a heavy cube drops on it.

Modified NGS - this algorithm is better in some ways than Baumgarte and Pseudo
Velocities, but in other ways it is worse. The bridge and chain are much more
stable, but the simple pendulum goes unstable at high angular velocities.

Full NGS - stable in all tests. The joints display good stiffness. The bridge
still sags, but this is better than infinite forces.

Recommendations
Pseudo Velocities are not really worthwhile because the bridge and chain cannot
recover from joint separation. In other cases the benefit over Baumgarte is small.

Modified NGS is not a robust method for the revolute joint due to the violent
instability seen in the simple pendulum. Perhaps it is viable with other constraint
types, especially scalar constraints where the effective mass is a scalar.

This leaves Baumgarte and Full NGS. Baumgarte has small, but manageable instabilities
and is very fast. I don't think we can escape Baumgarte, especially in highly
demanding cases where high constraint fidelity is not needed.

Full NGS is robust and easy on the eyes. I recommend this as an option for
higher fidelity simulation and certainly for suspension bridges and long chains.
Full NGS might be a good choice for ragdolls, especially motorized ragdolls where
joint separation can be problematic. The number of NGS iterations can be reduced
for better performance without harming robustness much.

Each joint in a can be handled differently in the position solver. So I recommend
a system where the user can select the algorithm on a per joint basis. I would
probably default to the slower Full NGS and let the user select the faster
Baumgarte method in performance critical scenarios.
*/

/*
Cache Performance

The Box2D solvers are dominated by cache misses. Data structures are designed
to increase the number of cache hits. Much of misses are due to random access
to body data. The constraint structures are iterated over linearly, which leads
to few cache misses.

The bodies are not accessed during iteration. Instead read only data, such as
the mass values are stored with the constraints. The mutable data are the constraint
impulses and the bodies velocities/positions. The impulses are held inside the
constraint structures. The body velocities/positions are held in compact, temporary
arrays to increase the number of cache hits. Linear and angular velocity are
stored in a single array since multiple arrays lead to multiple misses.
*/

/*
2D Rotation

R = [cos(theta) -sin(theta)]
    [sin(theta) cos(theta) ]

thetaDot = omega

Let q1 = cos(theta), q2 = sin(theta).
R = [q1 -q2]
    [q2  q1]

q1Dot = -thetaDot * q2
q2Dot = thetaDot * q1

q1_new = q1_old - dt * w * q2
q2_new = q2_old + dt * w * q1
then normalize.

This might be faster than computing sin+cos.
However, we can compute sin+cos of the same angle fast.
*/

public static const linTolSqr:Number = b2Settings.b2_linearSleepTolerance * b2Settings.b2_linearSleepTolerance;
public static const angTolSqr:Number = b2Settings.b2_angularSleepTolerance * b2Settings.b2_angularSleepTolerance;

public static const k_toiBaumgarte:Number = 0.75;



public function b2Island(
	bodyCapacity:int,
	contactCapacity:int,
	jointCapacity:int,
	allocator:b2StackAllocator,
	listener:b2ContactListener
	//listener:b2ContactPostSolveListener // hacking
	)
{
	m_bodyCapacity = bodyCapacity;
	m_contactCapacity = contactCapacity;
	m_jointCapacity	 = jointCapacity;
	m_bodyCount = 0;
	m_contactCount = 0;
	m_jointCount = 0;

	m_allocator = allocator;
	m_listener = listener;

	//m_bodies = (b2Body**)m_allocator->Allocate(bodyCapacity * sizeof(b2Body*));
	//m_contacts = (b2Contact**)m_allocator->Allocate(contactCapacity	 * sizeof(b2Contact*));
	//m_joints = (b2Joint**)m_allocator->Allocate(jointCapacity * sizeof(b2Joint*));
	m_bodies = new Array (bodyCapacity);
	m_contacts = new Array (contactCapacity);
	m_joints = new Array (jointCapacity);

	// as3: below 2 lines is not commented of in c++ version 
	//m_velocities = (b2Velocity*)m_allocator->Allocate(m_bodyCapacity * sizeof(b2Velocity));
	//m_positions = (b2Position*)m_allocator->Allocate(m_bodyCapacity * sizeof(b2Position));
}

//b2Island::~b2Island()
public function Destructor ():void
{
	// Warning: the order should reverse the constructor order.
	//m_allocator->Free(m_positions);
	//m_allocator->Free(m_velocities);
	//m_allocator->Free(m_joints);
	m_bodies = null;
	m_contacts = null;
	m_joints = null;
	
	//m_allocator->Free(m_contacts);
	//m_allocator->Free(m_bodies);
}

public function Solve(step:b2TimeStep, gravity:b2Vec2, allowSleep:Boolean):void
{
	var i:int;
	var j:int;
	var b:b2Body;
	var temp:Number;
	var tempContact:b2Contact;
	
	// Integrate velocities and apply damping.
	for (i = 0; i < m_bodyCount; ++i)
	{
		b = m_bodies[i];

		if (b.GetType() != b2Body.b2_dynamicBody)
		{
			continue;
		}

		// Integrate velocities.
		//b.m_linearVelocity += step.dt * (gravity + b->m_invMass * b->m_force);
		b.m_linearVelocity.x += step.dt * (gravity.x + b.m_invMass * b.m_force.x);
		b.m_linearVelocity.y += step.dt * (gravity.y + b.m_invMass * b.m_force.y);
		b.m_angularVelocity += step.dt * b.m_invI * b.m_torque;

		// Apply damping.
		// ODE: dv/dt + c * v = 0
		// Solution: v(t) = v0 * exp(-c * t)
		// Time step: v(t + dt) = v0 * exp(-c * (t + dt)) = v0 * exp(-c * t) * exp(-c * dt) = v * exp(-c * dt)
		// v2 = exp(-c * dt) * v1
		// Taylor expansion:
		// v2 = (1.0f - c * dt) * v1
		//b->m_linearVelocity *= b2Clamp(1.0f - step.dt * b->m_linearDamping, 0.0f, 1.0f);
		temp = b2Math.b2Clamp_Number (1.0 - step.dt * b.m_linearDamping, 0.0, 1.0);
		b.m_linearVelocity.x *= temp;
		b.m_linearVelocity.y *= temp;
		b.m_angularVelocity *= b2Math.b2Clamp_Number (1.0 - step.dt * b.m_angularDamping, 0.0, 1.0);
	}

	// Partition contacts so that contacts with static bodies are solved last.
	var i1:int = -1;
	for (var i2:int = 0; i2 < m_contactCount; ++i2)
	{
		var fixtureA:b2Fixture = m_contacts[i2].GetFixtureA();
		var fixtureB:b2Fixture = m_contacts[i2].GetFixtureB();
		var bodyA:b2Body = fixtureA.GetBody();
		var bodyB:b2Body = fixtureB.GetBody();
		var nonStatic:Boolean = bodyA.GetType() != b2Body.b2_staticBody && bodyB.GetType() != b2Body.b2_staticBody;
		if (nonStatic)
		{
			++i1;
			//b2Swap(m_contacts[i1], m_contacts[i2]);
			tempContact = m_contacts[i1];
			m_contacts[i1] = m_contacts[i2];
			m_contacts[i2] = tempContact;
		}
	}

	// Initialize velocity constraints.
	var contactSolver:b2ContactSolver = new b2ContactSolver (m_contacts, m_contactCount, m_allocator, step.dtRatio);
	contactSolver.WarmStart();
	for (i = 0; i < m_jointCount; ++i)
	{
		(m_joints[i] as b2Joint).InitVelocityConstraints(step);
	}

	// Solve velocity constraints.
	for (i = 0; i < step.velocityIterations; ++i)
	{
		for (j = 0; j < m_jointCount; ++j)
		{
			(m_joints[j] as b2Joint).SolveVelocityConstraints(step);
		}

		contactSolver.SolveVelocityConstraints();
	}

	// Post-solve (store impulses for warm starting).
	contactSolver.StoreImpulses();

	// ...
	var ratio:Number;

	// Integrate positions.
	for (i = 0; i < m_bodyCount; ++i)
	{
		b = m_bodies[i];

		if (b.GetType() == b2Body.b2_staticBody)
			continue;

		// Check for large velocities.
		//b2Vec2 translation = step.dt * b->m_linearVelocity;
		var translation:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (step.dt * b.m_linearVelocity.x, step.dt * b.m_linearVelocity.y);
		
		if (b2Math.b2Dot2(translation, translation) > mWorld.b2_maxTranslationSquared)
		{
			ratio = mWorld.b2_maxTranslation / translation.Length();
			b.m_linearVelocity.x *= ratio;
			b.m_linearVelocity.y *= ratio;
		}

		var rotation:Number = step.dt * b.m_angularVelocity;
		if (rotation * rotation > b2Settings.b2_maxRotationSquared)
		{
			ratio = b2Settings.b2_maxRotation / Math.abs (rotation);
			b.m_angularVelocity *= ratio;
		}

		// Store positions for continuous collision.
		//b->m_sweep.c0 = b->m_sweep.c;
		b.m_sweep.c0.x = b.m_sweep.c.x;
		b.m_sweep.c0.y = b.m_sweep.c.y;
		b.m_sweep.a0 = b.m_sweep.a;

		// Integrate
		//b->m_sweep.c += step.dt * b->m_linearVelocity;
		b.m_sweep.c.x += step.dt * b.m_linearVelocity.x;
		b.m_sweep.c.y += step.dt * b.m_linearVelocity.y;
		b.m_sweep.a += step.dt * b.m_angularVelocity;

		// Compute new transform
		b.SynchronizeTransform();

		// Note: shapes are synchronized later.
	}

	// Iterate over constraints.
	for (i = 0; i < step.positionIterations; ++i)
	{
		var contactsOkay:Boolean = contactSolver.SolvePositionConstraints(b2Settings.b2_contactBaumgarte);

		var jointsOkay:Boolean = true;
		//for (int32 i = 0; i < m_jointCount; ++i)
		for (j = 0; j < m_jointCount; ++j)
		{
			var jointOkay:Boolean = (m_joints[j] as b2Joint).SolvePositionConstraints(b2Settings.b2_contactBaumgarte);
			jointsOkay = jointsOkay && jointOkay;
		}

		if (contactsOkay && jointsOkay)
		{
			// Exit early if the position errors are small.
			break;
		}
	}

	Report(contactSolver.m_constraints);

	if (allowSleep)
	{
		var minSleepTime:Number = b2Settings.b2_maxFloat;

		// the 2 const is move to the top ofthe file
//#ifndef TARGET_FLOAT32_IS_FIXED
//		const float32 linTolSqr = b2_linearSleepTolerance * b2_linearSleepTolerance;
//		const float32 angTolSqr = b2_angularSleepTolerance * b2_angularSleepTolerance;
//#endif

		for (i = 0; i < m_bodyCount; ++i)
		{
			b = m_bodies[i];
			if (b.GetType() == b2Body.b2_staticBody)
			{
				continue;
			}

			if ((b.m_flags & b2Body.e_autoSleepFlag) == 0)
			{
				b.m_sleepTime = 0.0;
				minSleepTime = 0.0;
			}

			if ((b.m_flags & b2Body.e_autoSleepFlag) == 0 ||
				b.m_angularVelocity * b.m_angularVelocity > angTolSqr ||
				b2Math.b2Dot2(b.m_linearVelocity, b.m_linearVelocity) > linTolSqr)
			{
				b.m_sleepTime = 0.0;
				minSleepTime = 0.0;
			}
			else
			{
				b.m_sleepTime += step.dt;
				minSleepTime = Math.min (minSleepTime, b.m_sleepTime);
			}
		}

		if (minSleepTime >= b2Settings.b2_timeToSleep)
		{
			for (i = 0; i < m_bodyCount; ++i)
			{
				b = m_bodies[i];
				b.SetAwake(false);
			}
		}
	}
}

private static var mContactImpulse:b2ContactImpulse = new b2ContactImpulse ();
//void b2Island::Report(const b2ContactConstraint* constraints)
public function Report(constraints:Array):void
{
	if (m_listener == null)
	{
		return;
	}
	
	var i:int, j:int;
	
	var impulse:b2ContactImpulse = mContactImpulse; //new b2ContactImpulse ();
	
	var cc:b2ContactConstraint;
	var ccp:b2ContactConstraintPoint;
	
	for (i = 0; i < m_contactCount; ++i)
	{
		var c:b2Contact = m_contacts[i];

		//const b2ContactConstraint* cc = constraints + i;
		cc = constraints[i];
		
		//@notice: it is best to use a member variable m_impulse
		for (j = 0; j < cc.pointCount; ++j)
		{
			ccp = cc.points[j] as b2ContactConstraintPoint;
			impulse.normalImpulses[j] = ccp.normalImpulse;
			impulse.tangentImpulses[j] = ccp.tangentImpulse;
		}

		m_listener.PostSolve(c, impulse);
	}
}
