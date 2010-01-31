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

private static var tempVa:b2Vec2 = new b2Vec2 ();
private static var tempVb:b2Vec2 = new b2Vec2 ();
private static var tempV:b2Vec2 = new b2Vec2 ();
private static var tangent:b2Vec2 = new b2Vec2 ();
private static var mWorldManifold:b2WorldManifold = new b2WorldManifold ();
public static var m_ConstraintsArray:Array = new Array ();


public function b2ContactSolver(contacts:Array, contactCount:int, allocator:b2StackAllocator, impulseRatio:Number)
{
	var i:int;
	var j:int;
	var cc:b2ContactConstraint;
	
	//m_step = step;
	m_allocator = allocator;

	m_constraintCount = contactCount;
	//m_constraints = (b2ContactConstraint*)m_allocator->Allocate(m_constraintCount * sizeof(b2ContactConstraint));
	//>>hacking
	if (m_ConstraintsArray.length < m_constraintCount)
	{
		var oldCount:int = m_ConstraintsArray.length;
		m_ConstraintsArray.length = m_constraintCount;
		
		for (i = oldCount; i < m_constraintCount; ++ i)
		{
			cc = new b2ContactConstraint ();
			m_ConstraintsArray [i] = cc;
		}
	}
	m_constraints = m_ConstraintsArray;
	//<<

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
		var bodyA:b2Body = fixtureA.GetBody();
		var bodyB:b2Body = fixtureB.GetBody();
		var manifold:b2Manifold = contact.GetManifold();

		var friction:Number = b2Settings.b2MixFriction (fixtureA.GetFriction(), fixtureB.GetFriction());
		var restitution:Number = b2Settings.b2MixRestitution(fixtureA.GetRestitution(), fixtureB.GetRestitution());

		var vA:b2Vec2 = bodyA.m_linearVelocity; // .Clone ()
		var vB:b2Vec2 = bodyB.m_linearVelocity; // .Clone ()
		var wA:Number = bodyA.m_angularVelocity;
		var wB:Number = bodyB.m_angularVelocity;

		//b2Assert(manifold->pointCount > 0);

		var worldManifold:b2WorldManifold = mWorldManifold; //new b2WorldManifold ();
		worldManifold.Initialize(manifold, bodyA.m_xf, radiusA, bodyB.m_xf, radiusB);

		cc = m_constraints [i];
		cc.bodyA = bodyA;
		cc.bodyB = bodyB;
		cc.manifold = manifold;
		cc.normal.CopyFrom (worldManifold.normal);
		cc.pointCount = manifold.pointCount;
		cc.friction = friction;

		//cc.localNormal.CopyFrom (manifold.localNormal);
		cc.localNormal = manifold.localNormal; // hacking
		//cc.localPoint.CopyFrom (manifold.localPoint);
		cc.localPoint = manifold.localPoint; // hacking
		cc.radius = radiusA + radiusB;
		cc.type = manifold.type;

		for (j = 0; j < cc.pointCount; ++j)
		{
			var cp:b2ManifoldPoint = manifold.points [j];
			var ccp:b2ContactConstraintPoint = cc.points [j];

			ccp.normalImpulse = impulseRatio * cp.normalImpulse;
			ccp.tangentImpulse = impulseRatio * cp.tangentImpulse;

			//ccp.localPoint.CopyFrom (cp.m_localPoint);
			ccp.localPoint = cp.localPoint;

			//ccp->rA = worldManifold.m_points[j] - bodyA->m_sweep.c;
			//ccp->rB = worldManifold.m_points[j] - bodyB->m_sweep.c;
			b2Math.b2Subtract_Vector2_Output (worldManifold.points[j], bodyA.m_sweep.c, ccp.rA);
			b2Math.b2Subtract_Vector2_Output (worldManifold.points[j], bodyB.m_sweep.c, ccp.rB);

			var rnA:Number  = b2Math.b2Cross2 (ccp.rA, cc.normal);
			var rnB:Number = b2Math.b2Cross2 (ccp.rB, cc.normal);
			rnA *= rnA;
			rnB *= rnB;

			var kNormal:Number = bodyA.m_invMass + bodyB.m_invMass + bodyA.m_invI * rnA + bodyB.m_invI * rnB;

			//b2Assert(kNormal > b2_epsilon);
			ccp.normalMass = 1.0 / kNormal;

			b2Math.b2Cross_Vector2AndScalar_Output (cc.normal, 1.0, tangent);

			var rtA:Number = b2Math.b2Cross2 (ccp.rA, tangent);
			var rtB:Number = b2Math.b2Cross2 (ccp.rB, tangent);
			rtA *= rtA;
			rtB *= rtB;

			var kTangent:Number = bodyA.m_invMass + bodyB.m_invMass + bodyA.m_invI * rtA + bodyB.m_invI * rtB;

			//b2Assert(kTangent > b2_epsilon);
			ccp.tangentMass = 1.0 /  kTangent;

			// Setup a velocity bias for restitution.
			ccp.velocityBias = 0.0;
			//float32 vRel = b2Math.b2Dot2(cc->normal, vB + b2Math.b2Cross2(wB, ccp->rB) - vA - b2Math.b2Cross2(wA, ccp->rA));
			b2Math.b2Cross_ScalarAndVector2_Output (wB, ccp.rB, tempVb); 
			b2Math.b2Cross_ScalarAndVector2_Output (wA, ccp.rA, tempVa); 
			tempV.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);
			var vRel:Number = b2Math.b2Dot2 (cc.normal, tempV);
			if (vRel < -b2Settings.b2_velocityThreshold)
			{
				ccp.velocityBias = -restitution * vRel;
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

private static var mP:b2Vec2 = new b2Vec2 ();

public function WarmStart():void
{
	var i:int;
	var j:int;
	
	var P:b2Vec2 = mP;//new b2Vec2 ();
	
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
		var tangent:b2Vec2 = b2Math.b2Cross_Vector2AndScalar (normal, 1.0); // .Clone ()

		var ccp:b2ContactConstraintPoint;

		for (j = 0; j < c.pointCount; ++j)
		{
			ccp = c.points [j];
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
}

private static var vA:b2Vec2 = new b2Vec2 ();
private static var vB:b2Vec2 = new b2Vec2 ();
//private static var tempVa:b2Vec2 = new b2Vec2 ();
//private static var tempVb:b2Vec2 = new b2Vec2 ();
private static var dv:b2Vec2 = new b2Vec2 ();
private static var dv1:b2Vec2 = new b2Vec2 ();
private static var dv2:b2Vec2 = new b2Vec2 ();
private static var P:b2Vec2 = new b2Vec2 ();
private static var P1:b2Vec2 = new b2Vec2 ();
private static var P2:b2Vec2 = new b2Vec2 ();
private static var a:b2Vec2 = new b2Vec2 ();
private static var b:b2Vec2 = new b2Vec2 ();
private static var x:b2Vec2 = new b2Vec2 ();
private static var d:b2Vec2 = new b2Vec2 ();

public function SolveVelocityConstraints():void
{
	var i:int;
	var j:int;
	
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
		vB.CopyFrom (bodyB.m_linearVelocity);
		var invMassA:Number = bodyA.m_invMass;
		var invIA:Number = bodyA.m_invI;
		var invMassB:Number = bodyB.m_invMass;
		var invIB:Number = bodyB.m_invI;
		var normal:b2Vec2 = c.normal; // .Clone () // hacking
		//var tangent:b2Vec2 = b2Math.b2Cross_Vector2AndScalar (normal, 1.0); 
		b2Math.b2Cross_Vector2AndScalar_Output (normal, 1.0, tangent); 
		var friction:Number = c.friction;

		//b2Assert(c->pointCount == 1 || c->pointCount == 2);

		var ccp:b2ContactConstraintPoint;
		var lambda:Number;
		var newImpulse:Number;

		// Solve tangent constraints
		for (j = 0; j < c.pointCount; ++j)
		{
			ccp = c.points [j];

			// Relative velocity at contact
			//b2Vec2 dv = vB + b2Math.b2Cross2(wB, ccp->rB) - vA - b2Math.b2Cross2(wA, ccp->rA);
			b2Math.b2Cross_ScalarAndVector2_Output (wB, ccp.rB, tempVb);
			b2Math.b2Cross_ScalarAndVector2_Output (wA, ccp.rA, tempVa);
			dv.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);

			// Compute tangent force
			var vt:Number = b2Math.b2Dot2 (dv, tangent);
			lambda = ccp.tangentMass * (-vt);

			// b2Clamp the accumulated force
			var maxFriction:Number = friction * ccp.normalImpulse;
			newImpulse = b2Math.b2Clamp_Number (ccp.tangentImpulse + lambda, -maxFriction, maxFriction);
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
			ccp = c.points [0];

			// Relative velocity at contact
			//b2Vec2 dv = vB + b2Math.b2Cross2(wB, ccp->rB) - vA - b2Math.b2Cross2(wA, ccp->rA);
			b2Math.b2Cross_ScalarAndVector2_Output (wB, ccp.rB, tempVb);
			b2Math.b2Cross_ScalarAndVector2_Output (wA, ccp.rA, tempVa);
			dv.Set (vB.x + tempVb.x - vA.x - tempVa.x, vB.y + tempVb.y - vA.y - tempVa.y);

			// Compute normal impulse
			var vn:Number = b2Math.b2Dot2 (dv, normal);
			lambda = -ccp.normalMass * (vn - ccp.velocityBias);

			// b2Clamp the accumulated impulse
			newImpulse = Math.max (ccp.normalImpulse + lambda, 0.0);
			lambda = newImpulse - ccp.normalImpulse;

			// Apply contact impulse
			//b2Vec2 P = lambda * normal;
			P.Set (lambda * normal.x, lambda * normal.y);
			//vA -= invMassA * P;
			vA.x -= invMassA * P.x;
			vA.y -= invMassA * P.y;
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
			var vn1:Number = b2Math.b2Dot2 (dv1, normal);
			var vn2:Number = b2Math.b2Dot2 (dv2, normal);

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
				b2Math.b2Mul_Matrix22AndVector2_Output (c.normalMass, b, x);
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
				// Case 3: vn2 = 0 and x1 = 0
				//
				// vn1 = a11 * 0 + a12 * x2' + b1' 
				//   0 = a21 * 0 + a22 * x2' + b2'
				//
				x.x = 0.0;
				x.y = - cp2.normalMass * b.y;
				vn1 = c.K.col2.x * x.y + b.x;
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

		bodyA.m_linearVelocity.x = vA.x;
		bodyA.m_linearVelocity.y = vA.y;
		bodyA.m_angularVelocity = wA;
		bodyB.m_linearVelocity.x = vB.x;
		bodyB.m_linearVelocity.y = vB.y;
		bodyB.m_angularVelocity = wB;
	}
}

public function StoreImpulses():void
{
	var i:int;
	var j:int;
	var mp:b2ManifoldPoint;
	var ccp:b2ContactConstraintPoint;
	var c:b2ContactConstraint;
	var m:b2Manifold;
	
	for (i = 0; i < m_constraintCount; ++i)
	{
		c = m_constraints [i];
		m = c.manifold;

		for (j = 0; j < c.pointCount; ++j)
		{
			mp  = m.points[j];
			ccp = c.points[j];
			
			mp.normalImpulse  = ccp.normalImpulse;
			mp.tangentImpulse = ccp.tangentImpulse;
		}
	}
}

//struct b2PositionSolverManifold
//{
	//@see b2PositionSolverManifold.as
//};

private static var rA:b2Vec2 = new b2Vec2 ();
private static var rB:b2Vec2 = new b2Vec2 ();

private static var sPositionSolverManifold:b2PositionSolverManifold = new b2PositionSolverManifold ();

// Sequential solver.
public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	var i:int;
	var j:int;
	var minSeparation:Number = 0.0;
	
	//var rA:b2Vec2 = new b2Vec2 ();
	//var rB:b2Vec2 = new b2Vec2 ();
	var rC:b2Vec2;
	
	//var P:b2Vec2 = new b2Vec2 ();
	var tF:Number;
	
	for (i = 0; i < m_constraintCount; ++i)
	{
		var c:b2ContactConstraint = m_constraints [i];
		var bodyA:b2Body = c.bodyA;
		var bodyB:b2Body = c.bodyB;

		var invMassA:Number = bodyA.m_mass * bodyA.m_invMass;
		var invIA:Number = bodyA.m_mass * bodyA.m_invI;
		var invMassB:Number = bodyB.m_mass * bodyB.m_invMass;
		var invIB:Number = bodyB.m_mass * bodyB.m_invI;

		// Solve normal constraints
		for (j = 0; j < c.pointCount; ++j)
		{
			//b2PositionSolverManifold psm;
			var psm:b2PositionSolverManifold = sPositionSolverManifold; // hacking
			psm.Initialize(c, j);
			var normal:b2Vec2 = psm.normal; // .Clone ()

			var point:b2Vec2 = psm.point; // .Clone ()
			var separation:Number = psm.separation;

			rC = bodyA.m_sweep.c;
			rA.Set (point.x - rC.x, point.y - rC.y);
			rC = bodyB.m_sweep.c;
			rB.Set (point.x - rC.x, point.y - rC.y);

			// Track max constraint error.
			minSeparation = Math.min (minSeparation, separation);

			// Prevent large corrections and allow slop.
			var C:Number = b2Math.b2Clamp_Number (baumgarte * (separation + b2Settings.b2_linearSlop), - b2Settings.b2_maxLinearCorrection, 0.0);

			// Compute the effective mass.
			var rnA:Number = b2Math.b2Cross2 (rA, normal);
			var rnB:Number = b2Math.b2Cross2 (rB, normal);
			var K:Number = invMassA + invMassB + invIA * rnA * rnA + invIB * rnB * rnB;

			// Compute normal impulse
			var impulse:Number = K > 0.0 ? - C / K : 0.0;

			P.Set (impulse * normal.x, impulse * normal.y);
			//bodyA->m_sweep.c -= invMassA * P;
			rC = bodyA.m_sweep.c;
			rC.x -= invMassA * P.x;
			rC.y -= invMassA * P.y;
			bodyA.m_sweep.a -= invIA * b2Math.b2Cross2 (rA, P);
			bodyA.SynchronizeTransform ();

			//bodyB->m_sweep.c += invMassB * P;
			rC = bodyB.m_sweep.c;
			rC.x += invMassB * P.x;
			rC.y += invMassB * P.y;			
			bodyB.m_sweep.a += invIB * b2Math.b2Cross2 (rB, P);
			bodyB.SynchronizeTransform ();
		}
	}

	// We can't expect minSpeparation >= -b2_linearSlop because we don't
	// push the separation above -b2_linearSlop.
	return minSeparation >= -1.5 * b2Settings.b2_linearSlop;
}

//#endif
