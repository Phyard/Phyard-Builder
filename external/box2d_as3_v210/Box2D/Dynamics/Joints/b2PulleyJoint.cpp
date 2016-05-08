/*
* Copyright (c) 2007 Erin Catto http://www.box2d.org
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

//#include <Box2D/Dynamics/Joints/b2PulleyJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// Pulley:
// length1 = norm(p1 - s1)
// length2 = norm(p2 - s2)
// C0 = (length1 + ratio * length2)_initial
// C = C0 - (length1 + ratio * length2) >= 0
// u1 = (p1 - s1) / norm(p1 - s1)
// u2 = (p2 - s2) / norm(p2 - s2)
// Cdot = -dot(u1, v1 + cross(w1, r1)) - ratio * dot(u2, v2 + cross(w2, r2))
// J = -[u1 cross(r1, u1) ratio * u2  ratio * cross(r2, u2)]
// K = J * invM * JT
//   = invMass1 + invI1 * cross(r1, u1)^2 + ratio^2 * (invMass2 + invI2 * cross(r2, u2)^2)
//
// Limit:
// C = maxLength - length
// u = (p - s) / norm(p - s)
// Cdot = -dot(u, v + cross(w, r))
// K = invMass + invI * cross(r, u)^2
// 0 <= impulse

//void b2PulleyJointDef::Initialize(b2Body* b1, b2Body* b2,
//				const b2Vec2& ga1, const b2Vec2& ga2,
//				const b2Vec2& anchor1, const b2Vec2& anchor2,
//				float32 r)
//{
//	body1 = b1;
//	body2 = b2;
//	groundAnchor1 = ga1;
//	groundAnchor2 = ga2;
//	localAnchor1 = body1->GetLocalPoint(anchor1);
//	localAnchor2 = body2->GetLocalPoint(anchor2);
//	b2Vec2 d1 = anchor1 - ga1;
//	length1 = d1.Length();
//	b2Vec2 d2 = anchor2 - ga2;
//	length2 = d2.Length();
//	ratio = r;
//	b2Assert(ratio > B2_FLT_EPSILON);
//	float32 C = length1 + ratio * length2;
//	maxLength1 = C - ratio * b2_minPulleyLength;
//	maxLength2 = (C - b2_minPulleyLength) / ratio;
//}

public function b2PulleyJoint(def:b2PulleyJointDef)
//: b2Joint(def)
{
	super (def);

	m_groundAnchor1.CopyFrom (def.groundAnchorA);
	m_groundAnchor2.CopyFrom (def.groundAnchorB);
	m_localAnchor1.CopyFrom (def.localAnchorA);
	m_localAnchor2.CopyFrom (def.localAnchorB);

	//b2Assert(def->ratio != 0.0f);
	m_ratio = def.ratio;

	m_constant = def.lengthA + m_ratio * def.lengthB;

	m_maxLength1 = Math.min (def.maxLengthA, m_constant - m_ratio * b2_minPulleyLength);
	m_maxLength2 = Math.min (def.maxLengthB, (m_constant - b2_minPulleyLength) / m_ratio);

	m_impulse = 0.0;
	m_limitImpulse1 = 0.0;
	m_limitImpulse2 = 0.0;
}

override public function InitVelocityConstraints(step:b2TimeStep):void
{
	var r1:b2Vec2 = new b2Vec2 ();
	var r2:b2Vec2 = new b2Vec2 ();
	var p1:b2Vec2 = new b2Vec2 ();
	var p2:b2Vec2 = new b2Vec2 ();
	var s1:b2Vec2 = new b2Vec2 ();
	var s2:b2Vec2 = new b2Vec2 ();
	var P1:b2Vec2 = new b2Vec2 ();
	var P2:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var tempF:Number;

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
	//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

	//b2Vec2 p1 = b1->m_sweep.c + r1;
	p1.x = b1.m_sweep.c.x + r1.x;
	p1.y = b1.m_sweep.c.y + r1.y;
	//b2Vec2 p2 = b2->m_sweep.c + r2;
	p2.x = b2.m_sweep.c.x + r2.x;
	p2.y = b2.m_sweep.c.y + r2.y;

	//b2Vec2 s1 = m_groundAnchor1;
	//b2Vec2 s2 = m_groundAnchor2;
	s1.CopyFrom (m_groundAnchor1);
	s2.CopyFrom (m_groundAnchor2);

	// Get the pulley axes.
	//m_u1 = p1 - s1;
	m_u1.x = p1.x - s1.x;
	m_u1.y = p1.y - s1.y;
	//m_u2 = p2 - s2;
	m_u2.x = p2.x - s2.x;
	m_u2.y = p2.y - s2.y;

	var length1:Number = m_u1.Length();
	var length2:Number = m_u2.Length();

	if (length1 > b2Settings.b2_linearSlop)
	{
		//m_u1 *= 1.0 / length1;
		tempF = 1.0 / length1;
		m_u1.x *= tempF;
		m_u1.y *= tempF;
	}
	else
	{
		m_u1.SetZero();
	}

	if (length2 > b2Settings.b2_linearSlop)
	{
		//m_u2 *= 1.0 / length2;
		tempF = 1.0 / length2;
		m_u2.x *= tempF;
		m_u2.y *= tempF;
	}
	else
	{
		m_u2.SetZero();
	}

	var C:Number = m_constant - length1 - m_ratio * length2;
	if (C > 0.0)
	{
		m_state = e_inactiveLimit;
		m_impulse = 0.0;
	}
	else
	{
		m_state = e_atUpperLimit;
	}

	if (length1 < m_maxLength1)
	{
		m_limitState1 = e_inactiveLimit;
		m_limitImpulse1 = 0.0;
	}
	else
	{
		m_limitState1 = e_atUpperLimit;
	}

	if (length2 < m_maxLength2)
	{
		m_limitState2 = e_inactiveLimit;
		m_limitImpulse2 = 0.0;
	}
	else
	{
		m_limitState2 = e_atUpperLimit;
	}

	// Compute effective mass.
	var cr1u1:Number = b2Math.b2Cross2 (r1, m_u1);
	var cr2u2:Number = b2Math.b2Cross2 (r2, m_u2);

	m_limitMass1 = b1.m_invMass + b1.m_invI * cr1u1 * cr1u1;
	m_limitMass2 = b2.m_invMass + b2.m_invI * cr2u2 * cr2u2;
	m_pulleyMass = m_limitMass1 + m_ratio * m_ratio * m_limitMass2;
	//b2Assert(m_limitMass1 > b2_epsilon);
	//b2Assert(m_limitMass2 > b2_epsilon);
	//b2Assert(m_pulleyMass > b2_epsilon);
	m_limitMass1 = 1.0 / m_limitMass1;
	m_limitMass2 = 1.0 / m_limitMass2;
	m_pulleyMass = 1.0 / m_pulleyMass;

	if (step.warmStarting)
	{
		// Scale impulses to support variable time steps.
		m_impulse *= step.dtRatio;
		m_limitImpulse1 *= step.dtRatio;
		m_limitImpulse2 *= step.dtRatio;

		// Warm starting.
		//b2Vec2 P1 = -(m_impulse + m_limitImpulse1) * m_u1;
		tempF = -(m_impulse + m_limitImpulse1);
		P1.x = tempF * m_u1.x;
		P1.y = tempF * m_u1.y;
		//b2Vec2 P2 = (-m_ratio * m_impulse - m_limitImpulse2) * m_u2;
		tempF = -m_ratio * m_impulse - m_limitImpulse2;
		P2.x = tempF * m_u2.x;
		P2.y = tempF * m_u2.y;
		//b1->m_linearVelocity += b1->m_invMass * P1;
		b1.m_linearVelocity.x += b1.m_invMass * P1.x;
		b1.m_linearVelocity.y += b1.m_invMass * P1.y;
		b1.m_angularVelocity += b1.m_invI * b2Math.b2Cross2 (r1, P1);
		//b2->m_linearVelocity += b2->m_invMass * P2;
		b2.m_linearVelocity.x += b2.m_invMass * P2.x;
		b2.m_linearVelocity.y += b2.m_invMass * P2.y;
		b2.m_angularVelocity += b2.m_invI * b2Math.b2Cross2 (r2, P2);
	}
	else
	{
		m_impulse = 0.0;
		m_limitImpulse1 = 0.0;
		m_limitImpulse2 = 0.0;
	}
}

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	var r1:b2Vec2 = new b2Vec2 ();
	var r2:b2Vec2 = new b2Vec2 ();
	var v1:b2Vec2 = new b2Vec2 ();
	var v2:b2Vec2 = new b2Vec2 ();
	var P1:b2Vec2 = new b2Vec2 ();
	var P2:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var tempF:Number;

	//B2_NOT_USED(step);

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
	//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

	var Cdot:Number;
	var impulse:Number;
	var oldImpulse:Number;

	if (m_state == e_atUpperLimit)
	{
		//b2Vec2 v1 = b1->m_linearVelocity + b2Math.b2Cross2(b1->m_angularVelocity, r1);
		b2Math.b2Cross_ScalarAndVector2_Output (b1.m_angularVelocity, r1, tempV);
		v1.x = b1.m_linearVelocity.x + tempV.x;
		v1.y = b1.m_linearVelocity.y + tempV.y;
		//b2Vec2 v2 = b2->m_linearVelocity + b2Math.b2Cross2(b2->m_angularVelocity, r2);
		b2Math.b2Cross_ScalarAndVector2_Output (b2.m_angularVelocity, r2, tempV);
		v2.x = b2.m_linearVelocity.x + tempV.x;
		v2.y = b2.m_linearVelocity.y + tempV.y;

		Cdot = - b2Math.b2Dot2 (m_u1, v1) - m_ratio * b2Math.b2Dot2 (m_u2, v2);
		impulse = m_pulleyMass * (-Cdot);
		oldImpulse = m_impulse;
		m_impulse = Math.max (0.0, m_impulse + impulse);
		impulse = m_impulse - oldImpulse;

		//b2Vec2 P1 = -impulse * m_u1;
		tempF = -impulse;
		P1.x = tempF * m_u1.x;
		P1.y = tempF * m_u1.y;
		//b2Vec2 P2 = -m_ratio * impulse * m_u2;
		tempF = -m_ratio * impulse;
		P2.x = tempF * m_u2.x;
		P2.y = tempF * m_u2.y;
		//b1->m_linearVelocity += b1->m_invMass * P1;
		b1.m_linearVelocity.x += b1.m_invMass * P1.x;
		b1.m_linearVelocity.y += b1.m_invMass * P1.y;
		b1.m_angularVelocity += b1.m_invI * b2Math.b2Cross2 (r1, P1);
		//b2->m_linearVelocity += b2->m_invMass * P2;
		b2.m_linearVelocity.x += b2.m_invMass * P2.x;
		b2.m_linearVelocity.y += b2.m_invMass * P2.y;
		b2.m_angularVelocity += b2.m_invI * b2Math.b2Cross2 (r2, P2);
	}

	if (m_limitState1 == e_atUpperLimit)
	{
		//b2Vec2 v1 = b1->m_linearVelocity + b2Math.b2Cross2(b1->m_angularVelocity, r1);
		b2Math.b2Cross_ScalarAndVector2_Output (b1.m_angularVelocity, r1, tempV);
		v1.x = b1.m_linearVelocity.x + tempV.x;
		v1.y = b1.m_linearVelocity.y + tempV.y;

		Cdot = - b2Math.b2Dot2 (m_u1, v1);
		impulse = -m_limitMass1 * Cdot;
		oldImpulse = m_limitImpulse1;
		m_limitImpulse1 = Math.max (0.0, m_limitImpulse1 + impulse);
		impulse = m_limitImpulse1 - oldImpulse;

		//b2Vec2 P1 = -impulse * m_u1;
		tempF = -impulse;
		P1.x = tempF * m_u1.x;
		P1.y = tempF * m_u1.y;
		//b1->m_linearVelocity += b1->m_invMass * P1;
		b1.m_linearVelocity.x += b1.m_invMass * P1.x;
		b1.m_linearVelocity.y += b1.m_invMass * P1.y;
		b1.m_angularVelocity += b1.m_invI * b2Math.b2Cross2 (r1, P1);
	}

	if (m_limitState2 == e_atUpperLimit)
	{
		//b2Vec2 v2 = b2->m_linearVelocity + b2Math.b2Cross2(b2->m_angularVelocity, r2);
		b2Math.b2Cross_ScalarAndVector2_Output (b2.m_angularVelocity, r2, tempV);
		v2.x = b2.m_linearVelocity.x + tempV.x;
		v2.y = b2.m_linearVelocity.y + tempV.y;

		Cdot = - b2Math.b2Dot2 (m_u2, v2);
		impulse = -m_limitMass2 * Cdot;
		oldImpulse = m_limitImpulse2;
		m_limitImpulse2 = Math.max (0.0, m_limitImpulse2 + impulse);
		impulse = m_limitImpulse2 - oldImpulse;

		//b2Vec2 P2 = -impulse * m_u2;
		tempF = -impulse;
		P2.x = tempF * m_u2.x;
		P2.y = tempF * m_u2.y;
		//b2->m_linearVelocity += b2->m_invMass * P2;
		b2.m_linearVelocity += b2.m_invMass * P2.x;
		b2.m_linearVelocity += b2.m_invMass * P2.x;
		b2.m_angularVelocity += b2.m_invI * b2Math.b2Cross2 (r2, P2);
	}
}

override public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	var s1:b2Vec2 = new b2Vec2 ();
	var s2:b2Vec2 = new b2Vec2 ();
	var r1:b2Vec2 = new b2Vec2 ();
	var r2:b2Vec2 = new b2Vec2 ();
	var p1:b2Vec2 = new b2Vec2 ();
	var p2:b2Vec2 = new b2Vec2 ();
	var P1:b2Vec2 = new b2Vec2 ();
	var P2:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var tempF:Number;

	//B2_NOT_USED(baumgarte);

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	s1.CopyFrom (m_groundAnchor1);
	s2.CopyFrom (m_groundAnchor2);

	var linearError:Number = 0.0;

	var length1:Number;
	var length2:Number;
	var C:Number;
	var impulse:Number;

	if (m_state == e_atUpperLimit)
	{
		//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
		//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

		//b2Vec2 p1 = b1->m_sweep.c + r1;
		p1.x = b1.m_sweep.c.x + r1.x;
		p1.y = b1.m_sweep.c.y + r1.y;
		//b2Vec2 p2 = b2->m_sweep.c + r2;
		p2.x = b2.m_sweep.c.x + r2.x;
		p2.y = b2.m_sweep.c.y + r2.y;

		// Get the pulley axes.
		//m_u1 = p1 - s1;
		m_u1.x = p1.x - s1.x;
		m_u1.y = p1.y - s1.y;
		//m_u2 = p2 - s2;
		m_u2.x = p2.x - s2.x;
		m_u2.y = p2.y - s2.y;

		length1 = m_u1.Length();
		length2 = m_u2.Length();

		if (length1 > b2Settings.b2_linearSlop)
		{
			//m_u1 *= 1.0 / length1;
			tempF = 1.0 / length1;
			m_u1.x *= tempF;
			m_u1.y *= tempF;
		}
		else
		{
			m_u1.SetZero();
		}

		if (length2 > b2Settings.b2_linearSlop)
		{
			//m_u2 *= 1.0 / length2;
			tempF = 1.0 / length2;
			m_u2.x *= tempF;
			m_u2.y *= tempF;
		}
		else
		{
			m_u2.SetZero();
		}

		C = m_constant - length1 - m_ratio * length2;
		linearError = Math.max (linearError, -C);

		C = b2Math.b2Clamp_Number (C + b2Settings.b2_linearSlop, - b2Settings.b2_maxLinearCorrection, 0.0);
		impulse = -m_pulleyMass * C;

		//b2Vec2 P1 = -impulse * m_u1;
		tempF = -impulse;
		P1.x = tempF * m_u1.x;
		P1.y = tempF * m_u1.y;
		//b2Vec2 P2 = -m_ratio * impulse * m_u2;
		tempF = -m_ratio * impulse;
		P2.x = tempF * m_u2.x;
		P2.y = tempF * m_u2.y;

		//b1->m_sweep.c += b1->m_invMass * P1;
		b1.m_sweep.c.x += b1.m_invMass * P1.x;
		b1.m_sweep.c.y += b1.m_invMass * P1.y;
		b1.m_sweep.a += b1.m_invI * b2Math.b2Cross2 (r1, P1);
		//b2->m_sweep.c += b2->m_invMass * P2;
		b2.m_sweep.c.x += b2.m_invMass * P2.x;
		b2.m_sweep.c.y += b2.m_invMass * P2.y;
		b2.m_sweep.a += b2.m_invI * b2Math.b2Cross2 (r2, P2);

		b1.SynchronizeTransform();
		b2.SynchronizeTransform();
	}

	if (m_limitState1 == e_atUpperLimit)
	{
		//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
		//b2Vec2 p1 = b1->m_sweep.c + r1;
		p1.x = b1.m_sweep.c.x + r1.x;
		p1.y = b1.m_sweep.c.y + r1.y;

		//m_u1 = p1 - s1;
		m_u1.x = p1.x - s1.x;
		m_u1.y = p1.y - s1.y;
		length1 = m_u1.Length();

		if (length1 > b2Settings.b2_linearSlop)
		{
			//m_u1 *= 1.0 / length1;
			tempF = 1.0 / length1;
			m_u1.x *= tempF;
			m_u1.y *= tempF;
		}
		else
		{
			m_u1.SetZero();
		}

		C = m_maxLength1 - length1;
		linearError = Math.max (linearError, -C);
		C = b2Math.b2Clamp_Number (C + b2Settings.b2_linearSlop, - b2Settings.b2_maxLinearCorrection, 0.0);
		impulse = -m_limitMass1 * C;

		//b2Vec2 P1 = -impulse * m_u1;
		P1.x = -impulse * m_u1.x;
		P1.y = -impulse * m_u1.y;
		//b1->m_sweep.c += b1->m_invMass * P1;
		b1.m_sweep.c.x += b1.m_invMass * P1.x;
		b1.m_sweep.c.y += b1.m_invMass * P1.y;
		b1.m_sweep.a += b1.m_invI * b2Math.b2Cross2 (r1, P1);

		b1.SynchronizeTransform();
	}

	if (m_limitState2 == e_atUpperLimit)
	{
		//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);
		//b2Vec2 p2 = b2->m_sweep.c + r2;
		p2.x = b2.m_sweep.c.x + r2.x;
		p2.y = b2.m_sweep.c.y + r2.y;

		//m_u2 = p2 - s2;
		m_u2.x = p2.x - s2.x;
		m_u2.y = p2.y - s2.y;
		length2 = m_u2.Length();

		if (length2 > b2Settings.b2_linearSlop)
		{
			//m_u2 *= 1.0 / length2;
			tempF = 1.0 / length2;
			m_u2.x *= tempF;
			m_u2.y *= tempF;
		}
		else
		{
			m_u2.SetZero();
		}

		C = m_maxLength2 - length2;
		linearError = Math.max (linearError, -C);
		C = b2Math.b2Clamp_Number (C + b2Settings.b2_linearSlop, - b2Settings.b2_maxLinearCorrection, 0.0);
		impulse = -m_limitMass2 * C;

		//b2Vec2 P2 = -impulse * m_u2;
		P2.x = -impulse * m_u2.x;
		P2.y = -impulse * m_u2.y;
		//b2->m_sweep.c += b2->m_invMass * P2;
		b2.m_sweep.c.x += b2.m_invMass * P2.x;
		b2.m_sweep.c.y += b2.m_invMass * P2.y;
		b2.m_sweep.a += b2.m_invI * b2Math.b2Cross2 (r2, P2);

		b2.SynchronizeTransform();
	}

	return linearError < b2Settings.b2_linearSlop;
}

override public function GetAnchorA():b2Vec2
{
	return m_bodyA.GetWorldPoint(m_localAnchor1);
}

override public function GetAnchorB():b2Vec2
{
	return m_bodyB.GetWorldPoint(m_localAnchor2);
}

override public function GetReactionForce(inv_dt:Number):b2Vec2
{
	//b2Vec2 P = m_impulse * m_u2;
	//return inv_dt * P;

	var tempF:Number = m_impulse * inv_dt;
	return b2Vec2.b2Vec2_From2Numbers (tempF * m_u2.x, tempF * m_u2.y);
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	//B2_NOT_USED(inv_dt);
	return 0.0;
}

public function GetGroundAnchorA():b2Vec2
{
	//return m_groundAnchor1;
	return m_groundAnchor1.Clone ();
}

public function GetGroundAnchorB():b2Vec2
{
	//return m_groundAnchor2;
	return m_groundAnchor2.Clone ();
}

public function GetLength1():Number
{
	var p:b2Vec2 = m_bodyA.GetWorldPoint(m_localAnchor1);
	//b2Vec2 s = m_groundAnchor1;
	//b2Vec2 d = p - s;
	var d:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (p.x - m_groundAnchor1.x, p.y - m_groundAnchor1.y);
	return d.Length();
}

public function GetLength2():Number
{
	var p:b2Vec2 = m_bodyB.GetWorldPoint(m_localAnchor2);
	//b2Vec2 s = m_groundAnchor2;
	//b2Vec2 d = p - s;
	var d:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (p.x - m_groundAnchor2.x, p.y - m_groundAnchor2.y);
	return d.Length();
}

public function GetRatio():Number
{
	return m_ratio;
}
