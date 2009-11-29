/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
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

//#include <Box2D/Dynamics/Joints/b2MouseJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// p = attached point, m = mouse point
// C = p - m
// Cdot = v
//      = v + cross(w, r)
// J = [I r_skew]
// Identity used:
// w k % (rx i + ry j) = w * (-ry i + rx j)

public function b2MouseJoint(def:b2MouseJointDef)
//: b2Joint(def)
{
	super (def);

	//b2Assert(def->target.IsValid());
	//b2Assert(b2IsValid(def->maxForce) && def->maxForce >= 0.0f);
	//b2Assert(b2IsValid(def->frequencyHz) && def->frequencyHz >= 0.0f);
	//b2Assert(b2IsValid(def->dampingRatio) && def->dampingRatio >= 0.0f);
	
	m_target.CopyFrom (def.target);
	//m_localAnchor = b2MulT(m_bodyB->GetTransform(), m_target);
	b2Math.b2MulT_TransformAndVector2_Output (m_bodyB.GetTransform(), m_target, m_localAnchor);

	m_maxForce = def.maxForce;
	m_impulse.SetZero();

	m_frequencyHz = def.frequencyHz;
	m_dampingRatio = def.dampingRatio;

	m_beta = 0.0;
	m_gamma = 0.0;
}

public function SetTarget(target:b2Vec2):void
{
	if (m_bodyB.IsAwake() == false)
	{
		m_bodyB.SetAwake(true);
	}
	m_target.CopyFrom (target);
}

public function GetTarget():b2Vec2
{
	return m_target;
}

public function SetMaxForce(force:Number):void
{
	m_maxForce = force;
}

public function GetMaxForce():Number
{
	return m_maxForce;
}

public function SetFrequency(hz:Number):void
{
	m_frequencyHz = hz;
}

public function GetFrequency():Number
{
	return m_frequencyHz;
}

public function SetDampingRatio(ratio:Number):void
{
	m_dampingRatio = ratio;
}

public function GetDampingRatio():Number
{
	return m_dampingRatio;
}

override public function InitVelocityConstraints(step:b2TimeStep):void
{
	var r:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	
	var K1:b2Mat22 = new b2Mat22 ();
	var K2:b2Mat22 = new b2Mat22 ();
	var K:b2Mat22 = new b2Mat22 ();
	
	var b:b2Body = m_bodyB;

	var mass:Number = b.GetMass();

	// Frequency
	var omega:Number= 2.0 * b2Settings.b2_pi * m_frequencyHz;

	// Damping coefficient
	var d:Number = 2.0 * mass * m_dampingRatio * omega;

	// Spring stiffness
	var k:Number = mass * (omega * omega);

	// magic formulas
	// gamma has units of inverse mass.
	// beta has units of inverse time.
	//b2Assert(d + step.dt * k > b2_epsilon);
	m_gamma = step.dt * (d + step.dt * k);
	if (m_gamma != 0.0)
	{
		m_gamma = 1.0 / m_gamma;
	}
	m_beta = step.dt * k * m_gamma;

	// Compute the effective mass matrix.
	//b2Vec2 r = b2Mul(b->GetTransform().R, m_localAnchor - b->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor, b.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b.GetTransform().R, tempV, r);

	// K    = [(1/m1 + 1/m2) * eye(2) - skew(r1) * invI1 * skew(r1) - skew(r2) * invI2 * skew(r2)]
	//      = [1/m1+1/m2     0    ] + invI1 * [r1.y*r1.y -r1.x*r1.y] + invI2 * [r1.y*r1.y -r1.x*r1.y]
	//        [    0     1/m1+1/m2]           [-r1.x*r1.y r1.x*r1.x]           [-r1.x*r1.y r1.x*r1.x]
	var invMass:Number = b.m_invMass;
	var invI:Number = b.m_invI;

	//b2Mat22 K1;
	K1.col1.x = invMass;	K1.col2.x = 0.0;
	K1.col1.y = 0.0;		K1.col2.y = invMass;

	//b2Mat22 K2;
	K2.col1.x =  invI * r.y * r.y;	K2.col2.x = -invI * r.x * r.y;
	K2.col1.y = -invI * r.x * r.y;	K2.col2.y =  invI * r.x * r.x;

	//b2Mat22 K = K1 + K2;
	K.col1.x = K1.col1.x + K2.col1.x; K.col2.x = K1.col2.x + K2.col2.x;
	K.col1.y = K1.col1.y + K2.col1.y; K.col2.y = K1.col2.y + K2.col2.y;
	K.col1.x += m_gamma;
	K.col2.y += m_gamma;

	m_mass = K.GetInverse();

	//m_C = b->m_sweep.c + r - m_target;
	m_C.x = b.m_sweep.c.x + r.x - m_target.x;
	m_C.y = b.m_sweep.c.y + r.y - m_target.y;

	// Cheat with some damping
	b.m_angularVelocity *= 0.98;

	// Warm starting.
	//m_impulse *= step.dtRatio;
	m_impulse.x *= step.dtRatio;
	m_impulse.y *= step.dtRatio;
	//b->m_linearVelocity += invMass * m_impulse;
	b.m_linearVelocity.x += invMass * m_impulse.x;
	b.m_linearVelocity.y += invMass * m_impulse.y;
	b.m_angularVelocity += invI * b2Math.b2Cross2 (r, m_impulse);
}

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	var r:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var oldImpulse:b2Vec2 = new b2Vec2 ();
	var Cdot:b2Vec2 = new b2Vec2 ();
	var impulse:b2Vec2 = new b2Vec2 ();
	
	var b:b2Body = m_bodyB;

	//b2Vec2 r = b2Mul(b->GetTransform().R, m_localAnchor - b->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor, b.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b.GetTransform().R, tempV, r);

	// Cdot = v + cross(w, r)
	//b2Vec2 Cdot = b->m_linearVelocity + b2Math.b2Cross2(b->m_angularVelocity, r);
	b2Math.b2Cross_ScalarAndVector2_Output (b.m_angularVelocity, r, tempV);
	Cdot.x = b.m_linearVelocity.x + tempV.x;
	Cdot.y = b.m_linearVelocity.y + tempV.y;
	//b2Vec2 impulse = b2Mul(m_mass, -(Cdot + m_beta * m_C + m_gamma * m_impulse));
	tempV.x = -(Cdot.x + m_beta * m_C.x + m_gamma * m_impulse.x);
	tempV.y = -(Cdot.y + m_beta * m_C.y + m_gamma * m_impulse.y);
	b2Math.b2Mul_Matrix22AndVector2_Output (m_mass, tempV, impulse);

	//b2Vec2 oldImpulse = m_impulse;
	oldImpulse.x = m_impulse.x;
	oldImpulse.y = m_impulse.y;
	//m_impulse += impulse;
	m_impulse.x += impulse.x;
	m_impulse.y += impulse.y;
	var maxImpulse:Number = step.dt * m_maxForce;
	if (m_impulse.LengthSquared() > maxImpulse * maxImpulse)
	{
		var tF:Number = maxImpulse / m_impulse.Length();
		m_impulse.x *= tF;
		m_impulse.y *= tF;
	}
	//impulse = m_impulse - oldImpulse;
	impulse.x = m_impulse.x - oldImpulse.x;
	impulse.y = m_impulse.y - oldImpulse.y;

	//b->m_linearVelocity += b->m_invMass * impulse;
	b.m_linearVelocity.x += b.m_invMass * impulse.x;
	b.m_linearVelocity.y += b.m_invMass * impulse.y;
	b.m_angularVelocity += b.m_invI * b2Math.b2Cross2 (r, impulse);
}

override public function GetAnchorA():b2Vec2
{
	return m_target.Clone ();
}

override public function GetAnchorB():b2Vec2
{
	return m_bodyB.GetWorldPoint(m_localAnchor);
}

override public function GetReactionForce(inv_dt:Number):b2Vec2
{
	//return inv_dt * m_impulse;
	return b2Vec2.b2Vec2_From2Numbers (inv_dt * m_impulse.x, inv_dt * m_impulse.y);
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	return inv_dt * 0.0;
}
