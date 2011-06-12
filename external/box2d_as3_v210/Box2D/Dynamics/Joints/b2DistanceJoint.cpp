/*
* Copyright (c) 2006-2007 Erin Catto http://www.box2d.org
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

//#include <Box2D/Dynamics/Joints/b2DistanceJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// 1-D constrained system
// m (v2 - v1) = lambda
// v2 + (beta/h) * x1 + gamma * lambda = 0, gamma has units of inverse mass.
// x2 = x1 + h * v2

// 1-D mass-damper-spring system
// m (v2 - v1) + h * d * v2 + h * k *

// C = norm(p2 - p1) - L
// u = (p2 - p1) / norm(p2 - p1)
// Cdot = dot(u, v2 + cross(w2, r2) - v1 - cross(w1, r1))
// J = [-u -cross(r1, u) u cross(r2, u)]
// K = J * invM * JT
//   = invMass1 + invI1 * cross(r1, u)^2 + invMass2 + invI2 * cross(r2, u)^2

//void b2DistanceJointDef::Initialize(b2Body* b1, b2Body* b2,
//									const b2Vec2& anchor1, const b2Vec2& anchor2)
//{
//	body1 = b1;
//	body2 = b2;
//	localAnchor1 = body1->GetLocalPoint(anchor1);
//	localAnchor2 = body2->GetLocalPoint(anchor2);
//	b2Vec2 d = anchor2 - anchor1;
//	length = d.Length();
//}

public function b2DistanceJoint (def:b2DistanceJointDef)
//: b2Joint(def)
{
	super (def);

	m_localAnchor1.CopyFrom (def.localAnchorA);
	m_localAnchor2.CopyFrom (def.localAnchorB);
	m_length = def.length;
	m_frequencyHz = def.frequencyHz;
	m_dampingRatio = def.dampingRatio;
	m_impulse = 0.0;
	m_gamma = 0.0;
	m_bias = 0.0;

	//hacking
	//>>
	mSpringConstant = def.springConstant;
	//<
}

private static var r1:b2Vec2 = new b2Vec2 ();
private static var r2:b2Vec2 = new b2Vec2 ();
private static var tempV:b2Vec2 = new b2Vec2 ();
private static var P:b2Vec2 = new b2Vec2 ();

private static var v1:b2Vec2 = new b2Vec2 ();
private static var v2:b2Vec2 = new b2Vec2 ();
private static var d:b2Vec2 = new b2Vec2 ();

override public function InitVelocityConstraints (step:b2TimeStep):void
{
	//var r1:b2Vec2 = new b2Vec2 ();
	//var r2:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();
	//var P:b2Vec2 = new b2Vec2 ();

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	// Compute the effective mass matrix.
	//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
	//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);
	//m_u = b2->m_sweep.c + r2 - b1->m_sweep.c - r1;
	m_u.x = b2.m_sweep.c.x + r2.x - b1.m_sweep.c.x - r1.x;
	m_u.y = b2.m_sweep.c.y + r2.y - b1.m_sweep.c.y - r1.y;

	// Handle singularity.
	var length:Number = m_u.Length();
	if (length > b2Settings.b2_linearSlop)
	{
		//m_u *= 1.0 / length;
		var invLength:Number = 1.0 / length;
		m_u.x *= invLength;
		m_u.y *= invLength;
	}
	else
	{
		m_u.Set(0.0, 0.0);
	}

	var cr1u:Number = b2Math.b2Cross2 (r1, m_u);
	var cr2u:Number = b2Math.b2Cross2 (r2, m_u);
	var invMass:Number = b1.m_invMass + b1.m_invI * cr1u * cr1u + b2.m_invMass + b2.m_invI * cr2u * cr2u;

	m_mass = invMass != 0.0 ? 1.0 / invMass : 0.0;

	//>> hacking
	var C:Number;
	var omega:Number;
	var d:Number;
	var k:Number;
	if (mSpringConstant > 0.0)
	{
		C = length - m_length;

		// Spring stiffness
		k = mSpringConstant;

		omega = Math.sqrt (k / m_mass);

		// Damping coefficient
		d = 2.0 * m_mass * m_dampingRatio * omega;

		// magic formulas
		m_gamma = step.dt * (d + step.dt * k);
		m_gamma = m_gamma != 0.0 ? 1.0 / m_gamma : 0.0;
		m_bias = C * step.dt * k * m_gamma;

		m_mass = invMass + m_gamma;
		m_mass = m_mass != 0.0 ? 1.0 / m_mass : 0.0;
	}
	else
	//<< end hacking
	if (m_frequencyHz > 0.0)
	{
		C = length - m_length;

		// Frequency
		omega = 2.0 * b2Settings.b2_pi * m_frequencyHz;

		// Damping coefficient
		d = 2.0 * m_mass * m_dampingRatio * omega;

		// Spring stiffness
		k = m_mass * omega * omega;

		// magic formulas
		m_gamma = step.dt * (d + step.dt * k);
		m_gamma = m_gamma != 0.0 ? 1.0 / m_gamma : 0.0;
		m_bias = C * step.dt * k * m_gamma;

		m_mass = invMass + m_gamma;
		m_mass = m_mass != 0.0 ? 1.0 / m_mass : 0.0;
	}

	if (step.warmStarting)
	{
		// Scale the impulse to support a variable time step.
		m_impulse *= step.dtRatio;

		//b2Vec2 P = m_impulse * m_u;
		P.x = m_impulse * m_u.x;
		P.y = m_impulse * m_u.y;
		//b1->m_linearVelocity -= b1->m_invMass * P;
		b1.m_linearVelocity.x -= b1.m_invMass * P.x;
		b1.m_linearVelocity.y -= b1.m_invMass * P.y;
		b1.m_angularVelocity -= b1.m_invI * b2Math.b2Cross2 (r1, P);
		//b2->m_linearVelocity += b2->m_invMass * P;
		b2.m_linearVelocity.x += b2.m_invMass * P.x;
		b2.m_linearVelocity.y += b2.m_invMass * P.y;
		b2.m_angularVelocity += b2.m_invI * b2Math.b2Cross2 (r2, P);
	}
	else
	{
		m_impulse = 0.0;
	}
}

override public function SolveVelocityConstraints (step:b2TimeStep):void
{
	//var r1:b2Vec2 = new b2Vec2 ();
	//var r2:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();
	//var P:b2Vec2 = new b2Vec2 ();
	//var v1:b2Vec2 = new b2Vec2 ();
	//var v2:b2Vec2 = new b2Vec2 ();

	//B2_NOT_USED(step);

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
	//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

	// Cdot = dot(u, v + cross(w, r))
	//b2Vec2 v1 = b1->m_linearVelocity + b2Math.b2Cross2(b1->m_angularVelocity, r1);
	b2Math.b2Cross_ScalarAndVector2_Output (b1.m_angularVelocity, r1, tempV);
	b2Math.b2Add_Vector2_Output (b1.m_linearVelocity, tempV, v1);
	//b2Vec2 v2 = b2->m_linearVelocity + b2Math.b2Cross2(b2->m_angularVelocity, r2);
	b2Math.b2Cross_ScalarAndVector2_Output (b2.m_angularVelocity, r2, tempV);
	b2Math.b2Add_Vector2_Output (b2.m_linearVelocity, tempV, v2);
	//float32 Cdot = b2Math.b2Dot2(m_u, v2 - v1);
	b2Math.b2Subtract_Vector2_Output (v2, v1, tempV);
	var Cdot:Number = b2Math.b2Dot2 (m_u, tempV);

	var impulse:Number = -m_mass * (Cdot + m_bias + m_gamma * m_impulse);
	m_impulse += impulse;

	//b2Vec2 P = m_impulse * m_u;
	P.x = impulse * m_u.x;
	P.y = impulse * m_u.y;
	//b1->m_linearVelocity -= b1->m_invMass * P;
	b1.m_linearVelocity.x -= b1.m_invMass * P.x;
	b1.m_linearVelocity.y -= b1.m_invMass * P.y;
	b1.m_angularVelocity -= b1.m_invI * b2Math.b2Cross2 (r1, P);
	//b2->m_linearVelocity += b2->m_invMass * P;
	b2.m_linearVelocity.x += b2.m_invMass * P.x;
	b2.m_linearVelocity.y += b2.m_invMass * P.y;
	b2.m_angularVelocity += b2.m_invI * b2Math.b2Cross2 (r2, P);
}

override public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	//var r1:b2Vec2 = new b2Vec2 ();
	//var r2:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();
	//var d:b2Vec2 = new b2Vec2 ();
	//var P:b2Vec2 = new b2Vec2 ();

	//B2_NOT_USED(baumgarte);

	//hacking
	//>>
	if (mSpringConstant > 0.0)
	{
		// There is no position correction for soft distance constraints.
		return true;
	}
	else
	//<< end hacking
	if (m_frequencyHz > 0.0)
	{
		// There is no position correction for soft distance constraints.
		return true;
	}

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
	//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

	//b2Vec2 d = b2->m_sweep.c + r2 - b1->m_sweep.c - r1;
	d.x = b2.m_sweep.c.x + r2.x - b1.m_sweep.c.x - r1.x;
	d.y = b2.m_sweep.c.y + r2.y - b1.m_sweep.c.y - r1.y;

	var length:Number = d.Normalize();
	var C:Number = length - m_length;
	C = b2Math.b2Clamp_Number (C, - b2Settings.b2_maxLinearCorrection, b2Settings.b2_maxLinearCorrection);

	var impulse:Number = -m_mass * C;
	//m_u = d;
	m_u.CopyFrom (d);
	P.Set (impulse * m_u.x, impulse * m_u.y);

	//b1->m_sweep.c -= b1->m_invMass * P;
	b1.m_sweep.c.x -= b1.m_invMass * P.x;
	b1.m_sweep.c.y -= b1.m_invMass * P.y;
	b1.m_sweep.a -= b1.m_invI * b2Math.b2Cross2 (r1, P);
	//b2->m_sweep.c += b2->m_invMass * P;
	b2.m_sweep.c.x += b2.m_invMass * P.x;
	b2.m_sweep.c.y += b2.m_invMass * P.y;
	b2.m_sweep.a += b2.m_invI * b2Math.b2Cross2 (r2, P);

	b1.SynchronizeTransform();
	b2.SynchronizeTransform();

	//return b2Abs(C) < b2Settings.b2_linearSlop;
	return - b2Settings.b2_linearSlop < C && C < b2Settings.b2_linearSlop;
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
