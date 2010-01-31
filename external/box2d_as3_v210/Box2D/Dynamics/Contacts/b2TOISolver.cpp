/*
* Copyright (c) 2006-2010 Erin Catto http://www.gphysics.com
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

//#include <Box2D/Dynamics/Contacts/b2TOISolver.h>
//#include <Box2D/Dynamics/Contacts/b2Contact.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Common/b2StackAllocator.h>

//struct b2TOIConstraint
//{
	//@see b2TOIConstraint.as
//};

public function b2TOISolver(allocator:b2StackAllocator = null)
{
	m_allocator = allocator;
	m_constraints = null;
	m_count = 0;
	m_toiBody = null;
}

public function _b2TOISolver():void
{
	Clear();
}

public function Clear():void
{
	//if (m_allocator && m_constraints)
	//{
	//	m_allocator->Free(m_constraints);
	//	m_constraints = NULL;
	//}
}

public function Initialize(contacts:Array, count:int, toiBody:b2Body):void
{
	Clear();

	m_count = count;
	m_toiBody = toiBody;

	//m_constraints = (b2TOIConstraint*) m_allocator->Allocate(m_count * sizeof(b2TOIConstraint));
	
	//>>hacking
	var oldCount:int;
	if (m_constraints == null)
	{
		oldCount = 0;
		m_constraints = new Array ();
	}
	else
	{
		oldCount = m_constraints.length;
	}
	
	if (m_count > oldCount)
	{
		m_constraints.length = m_count;
		
		for (var k:int = oldCount; k < m_count; ++ k)
		{
			m_constraints [k] = new b2TOIConstraint ();
		}
	}
	//<<

	for (var i:int = 0; i < m_count; ++i)
	{
		var contact:b2Contact = contacts[i];

		var fixtureA:b2Fixture = contact.GetFixtureA();
		var fixtureB:b2Fixture = contact.GetFixtureB();
		var shapeA:b2Shape = fixtureA.GetShape();
		var shapeB:b2Shape = fixtureB.GetShape();
		var radiusA:Number = shapeA.m_radius;
		var radiusB:Number = shapeB.m_radius;
		var bodyA:b2Body = fixtureA.GetBody();
		var bodyB:b2Body = fixtureB.GetBody();
		var manifold:b2Manifold = contact.GetManifold();

		//b2Assert(manifold->pointCount > 0);

		var constraint:b2TOIConstraint = m_constraints [i];
		constraint.bodyA = bodyA;
		constraint.bodyB = bodyB;
		constraint.localNormal.CopyFrom (manifold.localNormal);
		constraint.localPoint.CopyFrom (manifold.localPoint);
		constraint.type = manifold.type;
		constraint.pointCount = manifold.pointCount;
		constraint.radius = radiusA + radiusB;

		for (var j:int = 0; j < constraint.pointCount; ++j)
		{
			var cp:b2ManifoldPoint = manifold.points [j];
			constraint.localPoints[j] .CopyFrom (cp.localPoint);
		}
	}
}

//struct b2TOISolverManifold
//{
	//@see b2TOISolverManifold.as
//};

private static var sTOISolverManifold:b2TOISolverManifold = new b2TOISolverManifold ();

private static var rA:b2Vec2 = new b2Vec2 ();
private static var rB:b2Vec2 = new b2Vec2 ();
private static var P:b2Vec2 = new b2Vec2 ();

// Push out the toi body to provide clearance for further simulation.
public function Solve(baumgarte:Number):Boolean
{
	var minSeparation:Number = 0.0;

	for (var i:int = 0; i < m_count; ++i)
	{
		var c:b2TOIConstraint = m_constraints [i];
		var bodyA:b2Body = c.bodyA;
		var bodyB:b2Body = c.bodyB;

		var massA:Number = bodyA.m_mass;
		var massB:Number = bodyB.m_mass;

		// Only the TOI body should move.
		if (bodyA == m_toiBody)
		{
			massB = 0.0;
		}
		else
		{
			massA = 0.0;
		}

		var invMassA:Number = massA * bodyA.m_invMass;
		var invIA:Number = massA * bodyA.m_invI;
		var invMassB:Number = massB * bodyB.m_invMass;
		var invIB:Number = massB * bodyB.m_invI;

		// Solve normal constraints
		for (var j:int = 0; j < c.pointCount; ++j)
		{
			//b2TOISolverManifold psm;
			var psm:b2TOISolverManifold = sTOISolverManifold;
			psm.Initialize(c, j);
			//b2Vec2 normal = psm.normal;
			var normal:b2Vec2 = psm.normal; //.Clone () // hacking

			//b2Vec2 point = psm.point;
			var point:b2Vec2 = psm.point; // .Clone ()
			var separation:Number = psm.separation;

			//b2Vec2 rA = point - bodyA.m_sweep.c;
			rA.x = point.x - bodyA.m_sweep.c.x;
			rA.y = point.y - bodyA.m_sweep.c.y;
			//b2Vec2 rB = point - bodyB.m_sweep.c;
			rB.x = point.x - bodyB.m_sweep.c.x;
			rB.y = point.y - bodyB.m_sweep.c.y;

			// Track max constraint error.
			minSeparation = Math.min (minSeparation, separation);

			// Prevent large corrections and allow slop.
			var C:Number = b2Math.b2Clamp_Number (baumgarte * (separation + b2Settings.b2_linearSlop), -b2Settings.b2_maxLinearCorrection, 0.0);

			// Compute the effective mass.
			var rnA:Number = b2Math.b2Cross2 (rA, normal);
			var rnB:Number = b2Math.b2Cross2 (rB, normal);
			var K:Number = invMassA + invMassB + invIA * rnA * rnA + invIB * rnB * rnB;

			// Compute normal impulse
			var impulse:Number = K > 0.0 ? - C / K : 0.0;

			//b2Vec2 P = impulse * normal;
			P.x = impulse * normal.x;
			P.y = impulse * normal.y;

			//bodyA->m_sweep.c -= invMassA * P;
			bodyA.m_sweep.c.x -= invMassA * P.x;
			bodyA.m_sweep.c.y -= invMassA * P.y;
			bodyA.m_sweep.a -= invIA * b2Math.b2Cross2 (rA, P);
			bodyA.SynchronizeTransform();

			//bodyB->m_sweep.c += invMassB * P;
			bodyB.m_sweep.c.x += invMassB * P.x;
			bodyB.m_sweep.c.y += invMassB * P.y;
			bodyB.m_sweep.a += invIB * b2Math.b2Cross2 (rB, P);
			bodyB.SynchronizeTransform();
		}
	}

	// We can't expect minSpeparation >= -b2_linearSlop because we don't
	// push the separation above -b2_linearSlop.
	return minSeparation >= -1.5 * b2Settings.b2_linearSlop;
}
