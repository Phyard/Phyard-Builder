/*
* Copyright (c) 2007-2010 Erin Catto http://www.box2d.org
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

//#include <Box2D/Dynamics/Joints/b2RopeJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>


// Limit:
// C = norm(pB - pA) - L
// u = (pB - pA) / norm(pB - pA)
// Cdot = dot(u, vB + cross(wB, rB) - vA - cross(wA, rA))
// J = [-u -cross(rA, u) u cross(rB, u)]
// K = J * invM * JT
//   = invMassA + invIA * cross(rA, u)^2 + invMassB + invIB * cross(rB, u)^2

public function b2RopeJoint(def:b2RopeJointDef)
//: b2Joint(def)
{
	super (def);

	m_localAnchorA.CopyFrom (def.localAnchorA);
	m_localAnchorB.CopyFrom (def.localAnchorB);

	m_maxLength = def.maxLength;

	m_mass = 0.0;
	m_impulse = 0.0;
	m_state = b2Joint.e_inactiveLimit;
	m_length = 0.0;
}

private static var tempV:b2Vec2 = new b2Vec2 ();
private static var P:b2Vec2 = new b2Vec2 ();

override public function InitVelocityConstraints(step:b2TimeStep):void
{
	var bA:b2Body = m_bodyA;
	var bB:b2Body = m_bodyB;

	// Compute the effective mass matrix.
	//m_rA = b2Mul(bA->GetTransform().R, m_localAnchorA - bA->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorA, bA.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bA.GetTransform().R, tempV, m_rA);
	//m_rB = b2Mul(bB->GetTransform().R, m_localAnchorB - bB->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorB, bB.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bB.GetTransform().R, tempV, m_rB);

	// Rope axis
	//m_u = bB->m_sweep.c + m_rB - bA->m_sweep.c - m_rA;
	m_u.x = bB.m_sweep.c.x + m_rB.x - bA.m_sweep.c.x - m_rA.x;
	m_u.y = bB.m_sweep.c.y + m_rB.y - bA.m_sweep.c.y - m_rA.y;

	m_length = m_u.Length();

	var C:Number = m_length - m_maxLength;
	if (C > 0.0)
	{
		m_state = e_atUpperLimit;
	}
	else
	{
		m_state = e_inactiveLimit;
	}

	if (m_length > b2Settings.b2_linearSlop)
	{
		//m_u *= 1.0f / m_length;
		var invLength:Number = 1.0 / length;
		m_u.x *= invLength;
		m_u.y *= invLength;
	}
	else
	{
		m_u.SetZero();
		m_mass = 0.0;
		m_impulse = 0.0;
		return;
	}

	// Compute effective mass.
	var crA:Number = b2Math.b2Cross2(m_rA, m_u);
	var crB:Number = b2Math.b2Cross2(m_rB, m_u);
	var invMass:Number = bA.m_invMass + bA.m_invI * crA * crA + bB.m_invMass + bB.m_invI * crB * crB;

	m_mass = invMass != 0.0 ? 1.0 / invMass : 0.0;

	if (step.warmStarting)
	{
		// Scale the impulse to support a variable time step.
		m_impulse *= step.dtRatio;

		//b2Vec2 P = m_impulse * m_u;
		P.x = m_impulse * m_u.x;
		P.y = m_impulse * m_u.y;
		//bA->m_linearVelocity -= bA->m_invMass * P;
		bA.m_linearVelocity.x -= bA.m_invMass * P.x;
		bA.m_linearVelocity.y -= bA.m_invMass * P.y;
		bA.m_angularVelocity -= bA.m_invI * b2Math.b2Cross2(m_rA, P);
		//bB->m_linearVelocity += bB->m_invMass * P;
		bB.m_linearVelocity.x += bB.m_invMass * P.x;
		bB.m_linearVelocity.y += bB.m_invMass * P.y;
		bB.m_angularVelocity += bB.m_invI * b2Math.b2Cross2(m_rB, P);
	}
	else
	{
		m_impulse = 0.0;
	}
}

private static var vA:b2Vec2 = new b2Vec2 ();
private static var vB:b2Vec2 = new b2Vec2 ();

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	//B2_NOT_USED(step);

	var bA:b2Body = m_bodyA;
	var bB:b2Body = m_bodyB;

	// Cdot = dot(u, v + cross(w, r))
	//b2Vec2 vA = bA->m_linearVelocity + b2Cross(bA->m_angularVelocity, m_rA);
	b2Math.b2Cross_ScalarAndVector2_Output (bA.m_angularVelocity, m_rA, tempV);
	b2Math.b2Add_Vector2_Output (bA.m_linearVelocity, tempV, vA);
	//b2Vec2 vB = bB->m_linearVelocity + b2Cross(bB->m_angularVelocity, m_rB);
	b2Math.b2Cross_ScalarAndVector2_Output (bB.m_angularVelocity, m_rB, tempV);
	b2Math.b2Add_Vector2_Output (bB.m_linearVelocity, tempV, vB);
	//float32 C = m_length - m_maxLength;
	var C:Number = m_length - m_maxLength;
	//float32 Cdot = b2Dot(m_u, vB - vA);
	b2Math.b2Subtract_Vector2_Output (vB, vA, tempV);
	var Cdot:Number = b2Math.b2Dot2 (m_u, tempV);

	// Predictive constraint.
	if (C < 0.0)
	{
		Cdot += step.inv_dt * C;
	}

	var impulse:Number = -m_mass * Cdot;
	var oldImpulse:Number = m_impulse;
	m_impulse = Math.min (0.0, m_impulse + impulse);
	impulse = m_impulse - oldImpulse;

	//b2Vec2 P = impulse * m_u;
	P.x = impulse * m_u.x;
	P.y = impulse * m_u.y;
	//bA->m_linearVelocity -= bA->m_invMass * P;
	bA.m_linearVelocity.x -= bA.m_invMass * P.x;
	bA.m_linearVelocity.y -= bA.m_invMass * P.y;
	bA.m_angularVelocity -= bA.m_invI * b2Math.b2Cross2(m_rA, P);
	//bB->m_linearVelocity += bB->m_invMass * P;
	bB.m_linearVelocity.x += bB.m_invMass * P.x;
	bB.m_linearVelocity.y += bB.m_invMass * P.y;
	bB.m_angularVelocity += bB.m_invI * b2Math.b2Cross2(m_rB, P);
}

private static var rA:b2Vec2 = new b2Vec2 ();
private static var rB:b2Vec2 = new b2Vec2 ();
private static var u:b2Vec2 = new b2Vec2 ();

override public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	//B2_NOT_USED(baumgarte);

	var bA:b2Body = m_bodyA;
	var bB:b2Body = m_bodyB;

	//b2Vec2 rA = b2Mul(bA->GetTransform().R, m_localAnchorA - bA->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorA, bA.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bA.GetTransform().R, tempV, rA);
	//b2Vec2 rB = b2Mul(bB->GetTransform().R, m_localAnchorB - bB->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorB, bB.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bB.GetTransform().R, tempV, rB);

	//b2Vec2 u = bB->m_sweep.c + rB - bA->m_sweep.c - rA;
	u.x = bB.m_sweep.c.x + rB.x - bA.m_sweep.c.x - rA.x;
	u.y = bB.m_sweep.c.y + rB.y - bA.m_sweep.c.y - rA.y;

	var length:Number = u.Normalize();
	var C:Number = length - m_maxLength;

	C =  b2Math.b2Clamp_Number (C, 0.0, b2Settings.b2_maxLinearCorrection);

	var impulse:Number = -m_mass * C;
	//b2Vec2 P = impulse * u;
	P.x = impulse * u.x;
	P.y = impulse * u.y;

	//bA->m_sweep.c -= bA->m_invMass * P;
	bA.m_sweep.c.x -= bA.m_invMass * P.x;
	bA.m_sweep.c.y -= bA.m_invMass * P.y;
	bA.m_sweep.a -= bA.m_invI * b2Math.b2Cross2(rA, P);
	//bB->m_sweep.c += bB->m_invMass * P;
	bB.m_sweep.c.x += bB.m_invMass * P.x;
	bB.m_sweep.c.y += bB.m_invMass * P.y;
	bB.m_sweep.a += bB.m_invI * b2Math.b2Cross2(rB, P);

	bA.SynchronizeTransform();
	bB.SynchronizeTransform();

	return length - m_maxLength < b2Settings.b2_linearSlop;
}

override public function GetAnchorA():b2Vec2
{
	return m_bodyA.GetWorldPoint(m_localAnchorA);
}

override public function GetAnchorB():b2Vec2
{
	return m_bodyB.GetWorldPoint(m_localAnchorB);
}

override public function GetReactionForce(inv_dt:Number):b2Vec2
{
	//b2Vec2 F = (inv_dt * m_impulse) * m_u;
	var tF:Number = inv_dt * m_impulse;
	var F:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (tF * m_u.x, tF * m_u.y);
	return F;
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	//B2_NOT_USED(inv_dt);
	return 0.0;
}

public function GetMaxLength():Number
{
	return m_maxLength;
}

//b2LimitState b2RopeJoint::GetLimitState() const
public function GetLimitState():int
{
	return m_state;
}
