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

//#include <Box2D/Dynamics/Contacts/b2ContactSolver.h>
//#include <Box2D/Dynamics/Contacts/b2Contact.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Dynamics/b2World.h>
//#include <Box2D/Common/b2StackAllocator.h>

//#define B2_DEBUG_SOLVER 0

//b2ContactSolver::b2ContactSolver(const b2TimeStep& step, b2Contact** contacts, int32 contactCount, b2StackAllocator* allocator)
public function b2ContactSolver(step:b2TimeStep, contacts:Array, contactCount:int, allocator:b2StackAllocator)
{
	var i:int;
	var j:int;
	
	var tempVa:b2Vec2 = new b2Vec2 ();
	var tempVb:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
		
	//m_step = step;
	m_step.CopyFrom (step);
	m_allocator = allocator;

	m_constraintCount = contactCount;
	//m_constraints = (b2ContactConstraint*)m_allocator->Allocate(m_constraintCount * sizeof(b2ContactConstraint));
	m_constraints = new Array (m_constraintCount);

	for (i = 0; i < m_constraintCount; ++i)
	{	
		// ...
		var contact:b2Contact = contacts[i] as b2Contact;

		var fixtureA:b2Fixture = contact.m_fixtureA;
		var fixtureB:b2Fixture = contact.m_fixtureB;
		var shapeA:b2Shape = fixtureA.GetShape();
		var shapeB:b2Shape = fixtureB.GetShape();
		var radiusA:Number = shapeA.m_radius;
		var radiusB:Number = shapeB.m_radius;
		var bodyA:b2Shape = fixtureA.GetBody();
		var bodyB:b2Body = fixtureB.GetBody();
		var manifold:b2Manifold = contact.GetManifold();

		var friction:Number = b2Setting.b2MixFriction (fixtureA.GetFriction(), fixtureB.GetFriction());
		var restitution:Number = b2Setting.b2MixRestitution(fixtureA.GetRestitution(), fixtureB.GetRestitution());

		var vA:b2Vec2 = bodyA.m_linearVelocity; // .Clone ()
		var vB:b2Vec2 = bodyB.m_linearVelocity; // .Clone ()
		var wA:Number = bodyA.m_angularVelocity;
		var wB:Number = bodyB.m_angularVelocity;

		//b2Assert(manifold->m_pointCount > 0);

		var worldManifold:b2WorldManifold = new b2WorldManifold ();
		worldManifold.Initialize(manifold, bodyA.m_xf, radiusA, bodyB.m_xf, radiusB);

		var cc:b2ContactConstraint = new b2ContactConstraint ();
		m_constraints [i] = cc; // in c++ version, all constraints have created when constraints array is created.
		cc.bodyA = bodyA;
		cc.bodyB = bodyB;
		cc.manifold = manifold;
		cc.normal.CopyFrom (worldManifold.m_normal);
		cc.pointCount = manifold.m_pointCount;
		cc.friction = friction;
		cc.restitution = restitution;

		cc.localPlaneNormal.CopyFrom (manifold.m_localPlaneNormal);
		cc.localPoint.CopyFrom (manifold.m_localPoint);
		cc.radius = radiusA + radiusB;
		cc.type = manifold.m_type;

		for (j = 0; j < cc.pointCount; ++j)
		{
			var cp:b2ManifoldPoint = manifold.m_points [j];
			var ccp:b2ContactConstraintPoint = cc.points [j];

			ccp.normalImpulse = cp.m_normalImpulse;
			ccp.tangentImpulse = cp.m_tangentImpulse;

			ccp.localPoint.CopyFrom (cp.m_localPoint);

			//ccp->rA = worldManifold.m_points[j] - bodyA->m_sweep.c;
			//ccp->rB = worldManifold.m_points[j] - bodyB->m_sweep.c;
			b2Math.b2Subtract_Vector2_Output (worldManifold.m_points[j], bodyA.m_sweep.c, ccp.rA);
			b2Math.b2Subtract_Vector2_Output (worldManifold.m_points[j], bodyB.m_sweep.c, ccp.rB);

			var rnA:Number  = b2Math.b2Cross2 (ccp.rA, cc.normal);
			var rnB:Number = b2Math.b2Cross2 (ccp.rB, cc.normal);
			rnA *= rnA;
			rnB *= rnB;

			var kNormal:Number = bodyA.m_invMass + bodyB.m_invMass + bodyA.m_invI * rnA + bodyB.m_invI * rnB;

			//b2Assert(kNormal > B2_FLT_EPSILON);
			ccp.normalMass = 1.0 / kNormal;

			var kEqualized:Number = bodyA.m_mass * bodyA.m_invMass + bodyB.m_mass * bodyB.m_invMass;
			kEqualized += bodyA.m_mass * bodyA.m_invI * rnA + bodyB.m_mass * bodyB.m_invI * rnB;

			//b2Assert(kEqualized > B2_FLT_EPSILON);
			ccp.equalizedMass = 1.0 / kEqualized;

			var tangent:b2Vec2 = b2Math.b2Cross_Vector2AndScalar (cc.normal, 1.0f);

			var rtA:Number = b2Math.b2Cross2 (ccp.rA, tangent);
			var rtB:Number = b2Math.b2Cross2 (ccp.rB, tangent);
			rtA *= rtA;
			rtB *= rtB;

			var kTangent:Number = bodyA.m_invMass + bodyB.m_invMass + bodyA.m_invI * rtA + bodyB.m_invI * rtB;

			//b2Assert(kTangent > B2_FLT_EPSILON);
			ccp.tangentMass = 1.0 /  kTangent;

			// Setup a velocity bias for restitution.
			ccp.velocityBias = 0.0;
			//float32 vRel = b2Math.b2Dot2(cc->normal, vB + b2Math.b2Cross2(wB, ccp->rB) - vA - b2Math.b2Cross2(wA, ccp->rA));
			b2Math.b2Cross_ScalarAndVector2_Output (wB, ccp.rB, tempVb); 
			b2Math.b2Cross_ScalarAndVector2_Output (wA, ccp.rA, tempVa); 
			tempV.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);
			var vRel:Number = b2Math.b2Dot2 (cc.normal, tempV);
			if (vRel < -b2_velocityThreshold)
			{
				ccp.velocityBias = -cc.restitution * vRel;
			}
		}

		// If we have two points, then prepare the block solver.
		if (cc.pointCount == 2)
		{
			var ccp1:b2ContactConstraintPoint = cc.points [0];
			var ccp2:b2ContactConstraintPoint = cc.points [1];
			
			var invMassA:Number = bodyA.m_invMass;
			var invIA:Number = bodyA.m_invI;
			var invMassB:Number = bodyB.m_invMass;
			var invIB:Number = bodyB.m_invI;

			var rn1A:Number = b2Math.b2Cross2(ccp1.rA, cc.normal);
			var rn1B:Number = b2Math.b2Cross2(ccp1.rB, cc.normal);
			var rn2A:Number = b2Math.b2Cross2(ccp2.rA, cc.normal);
			var rn2B:Number = b2Math.b2Cross2(ccp2.rB, cc.normal);

			var k11:Number = invMassA + invMassB + invIA * rn1A * rn1A + invIB * rn1B * rn1B;
			var k22:Number = invMassA + invMassB + invIA * rn2A * rn2A + invIB * rn2B * rn2B;
			var k12:Number = invMassA + invMassB + invIA * rn1A * rn2A + invIB * rn1B * rn2B;

			// Ensure a reasonable condition number.
			const k_maxConditionNumber:Number = 100.0;
			if (k11 * k11 < k_maxConditionNumber * (k11 * k22 - k12 * k12))
			{
				// K is safe to invert.
				cc.K.col1.Set (k11, k12);
				cc.K.col2.Set (k12, k22);
				//cc->normalMass = cc->K.GetInverse();
				cc.normalMass = cc.K.GetInverse(); // in c++ version, here is CopyFrom ()
			}
			else
			{
				// The constraints are redundant, just use one.
				// TODO_ERIN use deepest?
				cc.pointCount = 1;
			}
		}
	}
}

//b2ContactSolver::~b2ContactSolver()
public function Destructor ():void
{
	//m_allocator->Free(m_constraints);
}

public function InitVelocityConstraints(step:b2TimeStep):void
{
	var i:int;
	var j:int;
	
	var P:b2Vec2 = new b2Vec2 ();
	
	// Warm start.
	for (i = 0; i < m_constraintCount; ++i)
	{
		var c:b2ContactConstraint = m_constraints [i];

		var bodyA:b2Body = c.bodyA;
		var bodyB:b2Body = c.bodyB;
		var invMassA:Number = bodyA.m_invMass;
		var invIA:Number = bodyA.m_invI;
		var invMassB:Number = bodyB.m_invMass;
		var invIB:Number = bodyB.m_invI;
		var normal:b2Vec2 = c.normal; // .Clone ()
		var tangent:b2Vec2 = b2Math.b2Cross2(normal, 1.0); // .Clone ()

		if (step.warmStarting)
		{
			for (j = 0; j < c.pointCount; ++j)
			{
				var ccp:b2ContactConstraintPoint = c.points [j];
				ccp.normalImpulse *= step.dtRatio;
				ccp.tangentImpulse *= step.dtRatio;
				//b2Vec2 P = ccp->normalImpulse * normal + ccp->tangentImpulse * tangent;
				P.Set (	ccp.normalImpulse * normal.x + ccp.tangentImpulse * tangent.x, 
						ccp.normalImpulse * normal.y + ccp.tangentImpulse * tangent.y);
				bodyA.m_angularVelocity -= invIA * b2Math.b2Cross2 (ccp.rA, P);
				//bodyA->m_linearVelocity -= invMassA * P;
				bodyA.m_linearVelocity.x -= invMassA * P.x;
				bodyA.m_linearVelocity.y -= invMassA * P.y;
				bodyB.m_angularVelocity += invIB * b2Math.b2Cross2 (ccp.rB, P);
				//bodyB->m_linearVelocity += invMassB * P;
				bodyB.m_linearVelocity.x += invMassB * P.x;
				bodyB.m_linearVelocity.y += invMassB * P.y;
			}
		}
		else
		{
			for (j = 0; j < c.pointCount; ++j)
			{
				var ccp:b2ContactConstraintPoint = c.points [j];
				ccp.normalImpulse = 0.0;
				ccp.tangentImpulse = 0.0;
			}
		}
	}
}

public function SolveVelocityConstraints():void
{
	var i:int;
	var j:int;
	
	var vA:b2Vec2 = new b2Vec2 ();
	var vB:b2Vec2 = new b2Vec2 ();
	var tempVa:b2Vec2 = new b2Vec2 ();
	var tempVb:b2Vec2 = new b2Vec2 ();
	var dv:b2Vec2 = new b2Vec2 ();
	var dv1:b2Vec2 = new b2Vec2 ();
	var dv2:b2Vec2 = new b2Vec2 ();
	var P:b2Vec2 = new b2Vec2 ();
	var P1:b2Vec2 = new b2Vec2 ();
	var P2:b2Vec2 = new b2Vec2 ();
	var a:b2Vec2 = new b2Vec2 ();
	var b:b2Vec2 = new b2Vec2 ();
	var x:b2Vec2 = new b2Vec2 ();
	var d:b2Vec2 = new b2Vec2 ();
	
	for (i = 0; i < m_constraintCount; ++i)
	{
		var c:b2ContactConstraint = m_constraints [i];
		var bodyA:b2Body = c.bodyA;
		var bodyB:b2Body = c.bodyB;
		var wA:Number = bodyA.m_angularVelocity;
		var wB:Number = bodyB.m_angularVelocity;
		//b2Vec2 vA = bodyA->m_linearVelocity;
		//b2Vec2 vB = bodyB->m_linearVelocity;
		vA.CopyFrom (bodyA.m_linearVelocity);
		vB.CopyFrom ( = bodyB.m_linearVelocity);
		var invMassA:Number = bodyA.m_invMass;
		var invIA:Number = bodyA.m_invI;
		var invMassB:Number = bodyB.m_invMass;
		var invIB:Number = bodyB.m_invI;
		var normal:b2Vec2 = c.normal; // .Clone ()
		var tangent:b2Vec2 = b2Math.b2Cross_Vector2AndScalar (normal, 1.0f); 
		var friction:Number = c.friction;

		//b2Assert(c->pointCount == 1 || c->pointCount == 2);

		// Solve tangent constraints
		for (j = 0; j < c.pointCount; ++j)
		{
			var ccp:b2ContactConstraintPoint = c.points [j];

			// Relative velocity at contact
			//b2Vec2 dv = vB + b2Math.b2Cross2(wB, ccp->rB) - vA - b2Math.b2Cross2(wA, ccp->rA);
			b2Math.b2Cross_ScalarAndVector2_Output (wB, ccp.rB, tempVb);
			b2Math.b2Cross_ScalarAndVector2_Output (wA, ccp.rA, tempVa);
			dv.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);

			// Compute tangent force
			var vt:Number = b2Math.b2Dot2 (dv, tangent);
			var lambda:Number = ccp.tangentMass * (-vt);

			// b2Clamp the accumulated force
			var maxFriction:Number = friction * ccp.normalImpulse;
			var newImpulse:Number = b2Math.b2Clamp_Number (ccp.tangentImpulse + lambda, -maxFriction, maxFriction);
			lambda = newImpulse - ccp.tangentImpulse;

			// Apply contact impulse
			//b2Vec2 P = lambda * tangent;
			P.Set (lambda * tangent.x, lambda * tangent.y);

			//vA -= invMassA * P;
			vA.x -= invMassA * P.x;
			vA.y -= invMassA * P.y;
			wA -= invIA * b2Math.b2Cross2 (ccp.rA, P);

			//vB += invMassB * P;
			vB.x += invMassB * P.x;
			vB.y += invMassB * P.y;
			wB += invIB * b2Math.b2Cross2 (ccp.rB, P);

			ccp.tangentImpulse = newImpulse;
		}

		// Solve normal constraints
		if (c.pointCount == 1)
		{
			var ccp:b2ContactConstraintPoint = c.points [0];

			// Relative velocity at contact
			//b2Vec2 dv = vB + b2Math.b2Cross2(wB, ccp->rB) - vA - b2Math.b2Cross2(wA, ccp->rA);
			b2Math.b2Cross_ScalarAndVector2_Output (wB, ccp.rB, tempVb);
			b2Math.b2Cross_ScalarAndVector2_Output (wA, ccp.rA, tempVa);
			dv.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);

			// Compute normal impulse
			var vn:Number = b2Math.b2Dot2 (dv, normal);
			var lambda:Number = -ccp.normalMass * (vn - ccp.velocityBias);

			// b2Clamp the accumulated impulse
			var newImpulse:Number = Math.max (ccp->normalImpulse + lambda, 0.0);
			lambda = newImpulse - ccp.normalImpulse;

			// Apply contact impulse
			//b2Vec2 P = lambda * normal;
			P.Set (lambda * normal.x, lambda * normal.y);
			//vA -= invMassA * P;
			vA.x -= invMassA * P.x;
			vA.y-= invMassA * P.y;
			wA -= invIA * b2Math.b2Cross2 (ccp.rA, P);

			//vB += invMassB * P;
			vB.x += invMassB * P.x;
			vB.y += invMassB * P.y;
			wB += invIB * b2Math.b2Cross2 (ccp.rB, P);
			ccp.normalImpulse = newImpulse;
		}
		else
		{
			// Block solver developed in collaboration with Dirk Gregorius (back in 01/07 on Box2D_Lite).
			// Build the mini LCP for this contact patch
			//
			// vn = A * x + b, vn >= 0, , vn >= 0, x >= 0 and vn_i * x_i = 0 with i = 1..2
			//
			// A = J * W * JT and J = ( -n, -r1 x n, n, r2 x n )
			// b = vn_0 - velocityBias
			//
			// The system is solved using the "Total enumeration method" (s. Murty). The complementary constraint vn_i * x_i
			// implies that we must have in any solution either vn_i = 0 or x_i = 0. So for the 2D contact problem the cases
			// vn1 = 0 and vn2 = 0, x1 = 0 and x2 = 0, x1 = 0 and vn2 = 0, x2 = 0 and vn1 = 0 need to be tested. The first valid
			// solution that satisfies the problem is chosen.
			// 
			// In order to account of the accumulated impulse 'a' (because of the iterative nature of the solver which only requires
			// that the accumulated impulse is clamped and not the incremental impulse) we change the impulse variable (x_i).
			//
			// Substitute:
			// 
			// x = x' - a
			// 
			// Plug into above equation:
			//
			// vn = A * x + b
			//    = A * (x' - a) + b
			//    = A * x' + b - A * a
			//    = A * x' + b'
			// b' = b - A * a;

			var cp1:b2ContactConstraintPoint = c.points [0];
			var cp2:b2ContactConstraintPoint = c.points [1];

			//b2Vec2 a(cp1->normalImpulse, cp2->normalImpulse);
			a.Set (cp1.normalImpulse, cp2.normalImpulse);
			//b2Assert(a.x >= 0.0f && a.y >= 0.0f);

			// Relative velocity at contact
			//b2Vec2 dv1 = vB + b2Math.b2Cross2(wB, cp1->rB) - vA - b2Math.b2Cross2(wA, cp1->rA);
			//b2Vec2 dv2 = vB + b2Math.b2Cross2(wB, cp2->rB) - vA - b2Math.b2Cross2(wA, cp2->rA);
			b2Math.b2Cross_ScalarAndVector2_Output (wB, cp1.rB, tempVb);
			b2Math.b2Cross_ScalarAndVector2_Output (wA, cp1.rA, tempVa);
			dv1.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);
			b2Math.b2Cross_ScalarAndVector2_Output (wB, cp2.rB, tempVb)
			b2Math.b2Cross_ScalarAndVector2_Output (wA, cp2.rA, tempVa)
			dv2.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);

			// Compute normal velocity
			var vn1:float32 = b2Math.b2Dot2 (dv1, normal);
			var vn2:float32 = b2Math.b2Dot2 (dv2, normal);

			//b2Vec2 b;
			//b.x = vn1 - cp1->velocityBias;
			//b.y = vn2 - cp2->velocityBias;
			//b -= b2Mul(c->K, a);
			b2Math.b2Mul_Matrix22AndVector2_Output (c.K, a, b);
			b.x = vn1 - cp1.velocityBias - b.x;
			b.y = vn2 - cp2.velocityBias - b.y;

			const k_errorTol:Number = 1e-3;
			//B2_NOT_USED(k_errorTol);

			for (;;)
			{
				//
				// Case 1: vn = 0
				//
				// 0 = A * x' + b'
				//
				// Solve for x':
				//
				// x' = - inv(A) * b'
				//
				//b2Vec2 x = - b2Mul(c->normalMass, b);
				b2Math.b2Mul_Matrix22AndVector2_Output (c->normalMass, b, x);
				x.x = -x.x;
				x.y = -x.y;

				if (x.x >= 0.0 && x.y >= 0.0)
				{
					// Resubstitute for the incremental impulse
					//b2Vec2 d = x - a;
					d.x = x.x - a.x;
					d.y = x.y - a.y;

					// Apply incremental impulse
					//b2Vec2 P1 = d.x * normal;
					P1.x = d.x * normal.x;
					P1.y = d.x * normal.y;
					//b2Vec2 P2 = d.y * normal;
					P2.x = d.y * normal.x;
					P2.y = d.y * normal.y;
					//vA -= invMassA * (P1 + P2);
					vA.x -= invMassA * (P1.x + P2.x);
					vA.y -= invMassA * (P1.y + P2.y);
					wA -= invIA * (b2Math.b2Cross2 (cp1.rA, P1) + b2Math.b2Cross2 (cp2.rA, P2));

					//vB += invMassB * (P1 + P2);
					vB.x += invMassB * (P1.x + P2.x);
					vB.y += invMassB * (P1.y + P2.y);
					wB += invIB * (b2Math.b2Cross2 (cp1.rB, P1) + b2Math.b2Cross2 (cp2.rB, P2));

					// Accumulate
					cp1.normalImpulse = x.x;
					cp2.normalImpulse = x.y;

//#if B2_DEBUG_SOLVER == 1
//					// Postconditions
//					dv1 = vB + b2Math.b2Cross2(wB, cp1->rB) - vA - b2Math.b2Cross2(wA, cp1->rA);
//					dv2 = vB + b2Math.b2Cross2(wB, cp2->rB) - vA - b2Math.b2Cross2(wA, cp2->rA);
//
//					// Compute normal velocity
//					vn1 = b2Math.b2Dot2(dv1, normal);
//					vn2 = b2Math.b2Dot2(dv2, normal);
//
//					b2Assert(b2Abs(vn1 - cp1->velocityBias) < k_errorTol);
//					b2Assert(b2Abs(vn2 - cp2->velocityBias) < k_errorTol);
//#endif
					break;
				}

				//
				// Case 2: vn1 = 0 and x2 = 0
				//
				//   0 = a11 * x1' + a12 * 0 + b1' 
				// vn2 = a21 * x1' + a22 * 0 + b2'
				//
				x.x = - cp1.normalMass * b.x;
				x.y = 0.0;
				vn1 = 0.0;
				vn2 = c.K.col1.y * x.x + b.y;

				if (x.x >= 0.0 && vn2 >= 0.0)
				{
					// Resubstitute for the incremental impulse
					//b2Vec2 d = x - a;
					d.x = x.x - a.x;
					d.y = x.y - a.y;

					// Apply incremental impulse
					//b2Vec2 P1 = d.x * normal;
					P1.x = d.x * normal.x;
					P1.y = d.x * normal.y;
					//b2Vec2 P2 = d.y * normal;
					P2.x = d.y * normal.x;
					P2.y = d.y * normal.y;
					//vA -= invMassA * (P1 + P2);
					vA.x -= invMassA * (P1.x + P2.x);
					vA.y -= invMassA * (P1.y + P2.y);
					wA -= invIA * (b2Math.b2Cross2 (cp1.rA, P1) + b2Math.b2Cross2 (cp2.rA, P2));

					//vB += invMassB * (P1 + P2);
					vB.x += invMassB * (P1.x + P2.x);
					vB.y += invMassB * (P1.y + P2.y);
					wB += invIB * (b2Math.b2Cross2 (cp1.rB, P1) + b2Math.b2Cross2 (cp2.rB, P2));

					// Accumulate
					cp1.normalImpulse = x.x;
					cp2.normalImpulse = x.y;

//#if B2_DEBUG_SOLVER == 1
//					// Postconditions
//					dv1 = vB + b2Math.b2Cross2(wB, cp1->rB) - vA - b2Math.b2Cross2(wA, cp1->rA);
//
//					// Compute normal velocity
//					vn1 = b2Math.b2Dot2(dv1, normal);
//
//					b2Assert(b2Abs(vn1 - cp1->velocityBias) < k_errorTol);
//#endif
					break;
				}


				//
				// Case 3: wB = 0 and x1 = 0
				//
				// vn1 = a11 * 0 + a12 * x2' + b1' 
				//   0 = a21 * 0 + a22 * x2' + b2'
				//
				x.x = 0.0;
				x.y = - cp2->normalMass * b.y;
				vn1 = c->K.col2.x * x.y + b.x;
				vn2 = 0.0;

				if (x.y >= 0.0 && vn1 >= 0.0)
				{
					// Resubstitute for the incremental impulse
					//b2Vec2 d = x - a;
					d.x = x.x - a.x;
					d.y = x.y - a.y;

					// Apply incremental impulse
					//b2Vec2 P1 = d.x * normal;
					P1.x = d.x * normal.x;
					P1.y = d.x * normal.y;
					//b2Vec2 P2 = d.y * normal;
					P2.x = d.y * normal.x;
					P2.y = d.y * normal.y;
					//vA -= invMassA * (P1 + P2);
					vA.x -= invMassA * (P1.x + P2.x);
					vA.y -= invMassA * (P1.y + P2.y);
					wA -= invIA * (b2Math.b2Cross2 (cp1.rA, P1) + b2Math.b2Cross2 (cp2.rA, P2));

					//vB += invMassB * (P1 + P2);
					vB.x += invMassB * (P1.x + P2.x);
					vB.y += invMassB * (P1.y + P2.y);
					wB += invIB * (b2Math.b2Cross2 (cp1.rB, P1) + b2Math.b2Cross2 (cp2.rB, P2));

					// Accumulate
					cp1.normalImpulse = x.x;
					cp2.normalImpulse = x.y;

//#if B2_DEBUG_SOLVER == 1
//					// Postconditions
//					dv2 = vB + b2Math.b2Cross2(wB, cp2->rB) - vA - b2Math.b2Cross2(wA, cp2->rA);
//
//					// Compute normal velocity
//					vn2 = b2Math.b2Dot2(dv2, normal);
//
//					b2Assert(b2Abs(vn2 - cp2->velocityBias) < k_errorTol);
//#endif
					break;
				}

				//
				// Case 4: x1 = 0 and x2 = 0
				// 
				// vn1 = b1
				// vn2 = b2;
				x.x = 0.0;
				x.y = 0.0;
				vn1 = b.x;
				vn2 = b.y;

				if (vn1 >= 0.0 && vn2 >= 0.0 )
				{
					// Resubstitute for the incremental impulse
					//b2Vec2 d = x - a;
					d.x = x.x - a.x;
					d.y = x.y - a.y;

					// Apply incremental impulse
					//b2Vec2 P1 = d.x * normal;
					P1.x = d.x * normal.x;
					P1.y = d.x * normal.y;
					//b2Vec2 P2 = d.y * normal;
					P2.x = d.y * normal.x;
					P2.y = d.y * normal.y;
					//vA -= invMassA * (P1 + P2);
					vA.x -= invMassA * (P1.x + P2.x);
					vA.y -= invMassA * (P1.y + P2.y);
					wA -= invIA * (b2Math.b2Cross2(cp1.rA, P1) + b2Math.b2Cross2(cp2.rA, P2));

					//vB += invMassB * (P1 + P2);
					vB.x += invMassB * (P1.x + P2.x);
					vB.y += invMassB * (P1.y + P2.y);
					wB += invIB * (b2Math.b2Cross2(cp1.rB, P1) + b2Math.b2Cross2(cp2.rB, P2));

					// Accumulate
					cp1.normalImpulse = x.x;
					cp2.normalImpulse = x.y;

					break;
				}

				// No solution, give up. This is hit sometimes, but it doesn't seem to matter.
				break;
			}
		}

		bodyA.m_linearVelocity.CopyFrom (vA);
		bodyA.m_angularVelocity = wA;
		bodyB.m_linearVelocity.CopyFrom (vB);
		bodyB.m_angularVelocity = wB;
	}
}

public function FinalizeVelocityConstraints():void
{
	var i:int;
	var j:int;
	var mp:b2ManifoldPoint;
	var ccp:b2ManifoldPoint;
	var c:b2ContactConstraint;
	var m:b2Manifold;
	
	for (i = 0; i < m_constraintCount; ++i)
	{
		c = m_constraints [i];
		m = c.manifold;

		for (j = 0; j < c.pointCount; ++j)
		{
			mp  = m.m_points[j];
			ccp = c.points[j];
			
			mp.m_normalImpulse  = ccp.normalImpulse;
			mp.m_tangentImpulse = ccp.tangentImpulse;
		}
	}
}

//#if 0
//// Sequential solver.
//bool b2ContactSolver::SolvePositionConstraints(float32 baumgarte)
//{
//	float32 minSeparation = 0.0f;
//
//	for (int32 i = 0; i < m_constraintCount; ++i)
//	{
//		b2ContactConstraint* c = m_constraints + i;
//		b2Body* bodyA = c->bodyA;
//		b2Body* bodyB = c->bodyB;
//		float32 invMassA = bodyA->m_mass * bodyA->m_invMass;
//		float32 invIA = bodyA->m_mass * bodyA->m_invI;
//		float32 invMassB = bodyB->m_mass * bodyB->m_invMass;
//		float32 invIB = bodyB->m_mass * bodyB->m_invI;
//
//		b2Vec2 normal = c->normal;
//
//		// Solve normal constraints
//		for (int32 j = 0; j < c->pointCount; ++j)
//		{
//			b2ContactConstraintPoint* ccp = c->points + j;
//
//			b2Vec2 r1 = b2Mul(bodyA->GetXForm().R, ccp->localAnchorA - bodyA->GetLocalCenter());
//			b2Vec2 r2 = b2Mul(bodyB->GetXForm().R, ccp->localAnchorB - bodyB->GetLocalCenter());
//
//			b2Vec2 p1 = bodyA->m_sweep.c + r1;
//			b2Vec2 p2 = bodyB->m_sweep.c + r2;
//			b2Vec2 dp = p2 - p1;
//
//			// Approximate the current separation.
//			float32 separation = b2Math.b2Dot2(dp, normal) + ccp->separation;
//
//			// Track max constraint error.
//			minSeparation = b2Min(minSeparation, separation);
//
//			// Prevent large corrections and allow slop.
//			float32 C = baumgarte * b2Clamp(separation + b2Settings.b2_linearSlop, - b2Settings.b2_maxLinearCorrection, 0.0f);
//
//			// Compute normal impulse
//			float32 impulse = -ccp->equalizedMass * C;
//
//			b2Vec2 P = impulse * normal;
//
//			bodyA->m_sweep.c -= invMassA * P;
//			bodyA->m_sweep.a -= invIA * b2Math.b2Cross2(r1, P);
//			bodyA->SynchronizeTransform();
//
//			bodyB->m_sweep.c += invMassB * P;
//			bodyB->m_sweep.a += invIB * b2Math.b2Cross2(r2, P);
//			bodyB->SynchronizeTransform();
//		}
//	}
//
//	// We can't expect minSpeparation >= -b2_linearSlop because we don't
//	// push the separation above -b2_linearSlop.
//	return minSeparation >= -1.5f * b2Settings.b2_linearSlop;
//}
//
//#elif 1

//struct b2PositionSolverManifold
//{
	//@see b2PositionSolverManifold.as
//};

// Sequential solver.
public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	var i:int;
	var j:int;
	var minSeparation:Number = 0.0;
	
	var rA:b2Vec2 = new b2Vec2 ();
	var rB:b2Vec2 = new b2Vec2 ();
	var rC:b2Vec2;
	
	var P:b2Vec2 = new b2Vec2 ();
	var tF:Number;
	
	var psm:b2PositionSolverManifold = new b2PositionSolverManifold ();

	for (i = 0; i < m_constraintCount; ++i)
	{
		var c:b2ContactConstraint = m_constraints [i];
		var bodyA:b2Body = c.bodyA;
		var bodyB:b2Body = c.bodyB;

		var invMassA:Number = bodyA.m_mass * bodyA.m_invMass;
		var invIA:Number = bodyA.m_mass * bodyA.m_invI;
		var invMassB:Number = bodyB.m_mass * bodyB.m_invMass;
		var invIB:Number = bodyB.m_mass * bodyB.m_invI;

		//b2PositionSolverManifold psm;
		psm.Initialize(c);
		var normal:b2Vec2 = psm.m_normal; // .Clone ()

		// Solve normal constraints
		for (j = 0; j < c.pointCount; ++j)
		{
			var ccp:b2ContactConstraintPoint = c.points [j];

			var point:b2Vec2 = psm.m_points[j]; // .Clone ()
			var separation:Number = psm.m_separations[j];

			rC = bodyA.m_sweep.c;
			rA.Set (point.x - rC.x, point.y - rC.y);
			rC = bodyB.m_sweep.c;
			rB.Set (point.x - rC.x, point.y - rC.y);

			// Track max constraint error.
			minSeparation = Math.min (minSeparation, separation);

			// Prevent large corrections and allow slop.
			var C:Number = baumgarte * b2Clamp_Number (separation + b2Settings.b2_linearSlop, - b2Settings.b2_maxLinearCorrection, 0.0);

			// Compute normal impulse
			var impulse:Number = -ccp.equalizedMass * C;

			P.Set (impulse * normal.x, impulse * normal.y);

			//bodyA->m_sweep.c -= invMassA * P;
			rC = bodyA.m_sweep.c;
			rC.x -= invMassA * P.x;
			rC.y -= invMassA * P.y;
			bodyA.m_sweep.a -= invIA * b2Math.b2Cross2 (rA, P);
			bodyA.SynchronizeTransform ();

			//bodyB->m_sweep.c += invMassB * P;
			rC = bodyB.m_sweep.c;
			rC.x -= invMassB * P.x;
			rC.y -= invMassB * P.y;			
			bodyB.m_sweep.a += invIB * b2Math.b2Cross2 (rB, P);
			bodyB.SynchronizeTransform ();
		}
	}

	// We can't expect minSpeparation >= -b2_linearSlop because we don't
	// push the separation above -b2_linearSlop.
	return minSeparation >= -1.5 * b2Settings.b2_linearSlop;
}

//#endif
