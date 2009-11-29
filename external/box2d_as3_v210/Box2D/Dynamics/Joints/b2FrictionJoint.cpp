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

//#include <Box2D/Dynamics/Joints/b2FrictionJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// Point-to-point constraint
// Cdot = v2 - v1
//      = v2 + cross(w2, r2) - v1 - cross(w1, r1)
// J = [-I -r1_skew I r2_skew ]
// Identity used:
// w k % (rx i + ry j) = w * (-ry i + rx j)

// Angle constraint
// Cdot = w2 - w1
// J = [0 0 -1 0 0 1]
// K = invI1 + invI2

//void b2FrictionJointDef::Initialize(b2Body* bA, b2Body* bB, const b2Vec2& anchor)
//{
//	bodyA = bA;
//	bodyB = bB;
//	localAnchorA = bodyA->GetLocalPoint(anchor);
//	localAnchorB = bodyB->GetLocalPoint(anchor);
//}

public function b2FrictionJoint(def:b2FrictionJointDef)
//: b2Joint(def)
{
	super (def);

	m_localAnchorA.CopyFrom (def.localAnchorA);
	m_localAnchorB.CopyFrom (def.localAnchorB);

	m_linearImpulse.SetZero();
	m_angularImpulse = 0.0;

	m_maxForce = def.maxForce;
	m_maxTorque = def.maxTorque;
}

override public function InitVelocityConstraints(step:b2TimeStep):void
{
	var rA:b2Vec2 = new b2Vec2 ();
	var rB:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var P:b2Vec2 = new b2Vec2 ();
	
	var bA:b2Body = m_bodyA;
	var bB:b2Body = m_bodyB;

	// Compute the effective mass matrix.
	//b2Vec2 rA = b2Mul(bA->GetTransform().R, m_localAnchorA - bA->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorA, bA.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bA.GetTransform().R, tempV, rA);
	//b2Vec2 rB = b2Mul(bB->GetTransform().R, m_localAnchorB - bB->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorB, bB.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bB.GetTransform().R, tempV, rB);

	// J = [-I -r1_skew I r2_skew]
	//     [ 0       -1 0       1]
	// r_skew = [-ry; rx]

	// Matlab
	// K = [ mA+r1y^2*iA+mB+r2y^2*iB,  -r1y*iA*r1x-r2y*iB*r2x,          -r1y*iA-r2y*iB]
	//     [  -r1y*iA*r1x-r2y*iB*r2x, mA+r1x^2*iA+mB+r2x^2*iB,           r1x*iA+r2x*iB]
	//     [          -r1y*iA-r2y*iB,           r1x*iA+r2x*iB,                   iA+iB]

	var mA:Number = bA.m_invMass, mB:Number = bB.m_invMass;
	var iA:Number = bA.m_invI, iB:Number = bB.m_invI;

	var K1:b2Mat22 = new b2Mat22 ();
	K1.col1.x = mA + mB;	K1.col2.x = 0.0;
	K1.col1.y = 0.0;		K1.col2.y = mA + mB;

	var K2:b2Mat22 = new b2Mat22 ();
	K2.col1.x =  iA * rA.y * rA.y;	K2.col2.x = -iA * rA.x * rA.y;
	K2.col1.y = -iA * rA.x * rA.y;	K2.col2.y =  iA * rA.x * rA.x;

	var K3:b2Mat22 = new b2Mat22 ();
	K3.col1.x =  iB * rB.y * rB.y;	K3.col2.x = -iB * rB.x * rB.y;
	K3.col1.y = -iB * rB.x * rB.y;	K3.col2.y =  iB * rB.x * rB.x;

	//b2Mat22 K = K1 + K2 + K3;
	var K:b2Mat22 = new b2Mat22 ();
	K.col1.x = K1.col1.x + K2.col1.x + K3.col1.x;	K.col2.x = K1.col2.x + K2.col2.x + K3.col2.x;
	K.col1.y = K1.col1.y + K2.col1.y + K3.col1.y;	K.col2.y = K1.col2.y + K2.col2.y + K3.col2.y;
	m_linearMass = K.GetInverse();

	m_angularMass = iA + iB;
	if (m_angularMass > 0.0)
	{
		m_angularMass = 1.0 / m_angularMass;
	}

	if (step.warmStarting)
	{
		// Scale impulses to support a variable time step.
		//m_linearImpulse *= step.dtRatio;
		m_linearImpulse.x *= step.dtRatio;
		m_linearImpulse.y *= step.dtRatio;
		m_angularImpulse *= step.dtRatio;

		//b2Vec2 P(m_linearImpulse.x, m_linearImpulse.y);
		P.Set (m_linearImpulse.x, m_linearImpulse.y);

		//bA->m_linearVelocity -= mA * P;
		bA.m_linearVelocity.x -= mA * P.x;
		bA.m_linearVelocity.y -= mA * P.y;
		bA.m_angularVelocity -= iA * (b2Math.b2Cross2(rA, P) + m_angularImpulse);

		//bB->m_linearVelocity += mB * P;
		bB.m_linearVelocity.x += mB * P.x;
		bB.m_linearVelocity.y += mB * P.y;
		bB.m_angularVelocity += iB * (b2Math.b2Cross2(rB, P) + m_angularImpulse);
	}
	else
	{
		m_linearImpulse.SetZero();
		m_angularImpulse = 0.0;
	}
}

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	//B2_NOT_USED(step);

	var vA:b2Vec2 = new b2Vec2 ();
	var vB:b2Vec2 = new b2Vec2 ();
	var rA:b2Vec2 = new b2Vec2 ();
	var rB:b2Vec2 = new b2Vec2 ();
	var Cdot:b2Vec2 = new b2Vec2 ();
	var impulse:b2Vec2 = new b2Vec2 ();
	var oldImpulse:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();

	var bA:b2Body = m_bodyA;
	var bB:b2Body = m_bodyB;

	vA.CopyFrom (bA.m_linearVelocity);
	var wA:Number = bA.m_angularVelocity;
	vB.CopyFrom (bB.m_linearVelocity);
	var wB:Number = bB.m_angularVelocity;

	var mA:Number = bA.m_invMass, mB:Number = bB.m_invMass;
	var iA:Number = bA.m_invI, iB:Number = bB.m_invI;

	//b2Vec2 rA = b2Mul(bA->GetTransform().R, m_localAnchorA - bA->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorA, bA.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bA.GetTransform().R, tempV, rA);
	//b2Vec2 rB = b2Mul(bB->GetTransform().R, m_localAnchorB - bB->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorB, bB.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bB.GetTransform().R, tempV, rB);

	// Solve angular friction
	{
		var CdotF:Number = wB - wA;
		var impulseF:Number = -m_angularMass * CdotF;

		var oldImpulseF:Number = m_angularImpulse;
		var maxImpulseF:Number = step.dt * m_maxTorque;
		m_angularImpulse = b2Math.b2Clamp_Number (m_angularImpulse + impulse, -maxImpulseF, maxImpulseF);
		impulseF = m_angularImpulse - oldImpulseF;

		wA -= iA * impulseF;
		wB += iB * impulseF;
	}

	// Solve linear friction
	{
		//b2Vec2 Cdot = vB + b2Cross(wB, rB) - vA - b2Cross(wA, rA);
		Cdot.x = vB.x - vA.x;
		Cdot.y = vB.y - vA.y;
		b2Math.b2Cross_ScalarAndVector2_Output (wB, rB, tempV);
		Cdot.x += tempV.x;
		Cdot.y += tempV.y;
		b2Math.b2Cross_ScalarAndVector2_Output (wA, rA, tempV);
		Cdot.x -= tempV.x;
		Cdot.y -= tempV.y;

		//b2Vec2 impulse = -b2Mul(m_linearMass, Cdot);
		b2Math.b2Mul_Matrix22AndVector2_Output (m_linearMass, Cdot, impulse);
		//b2Vec2 oldImpulse = m_linearImpulse;
		oldImpulse.CopyFrom ( m_linearImpulse);
		//m_linearImpulse += impulse;
		m_linearImpulse.x += impulse.x;
		m_linearImpulse.y += impulse.y;

		var maxImpulse:Number = step.dt * m_maxForce;

		if (m_linearImpulse.LengthSquared() > maxImpulse * maxImpulse)
		{
			m_linearImpulse.Normalize();
			//m_linearImpulse *= maxImpulse;
			m_linearImpulse.x *= maxImpulse;
			m_linearImpulse.y *= maxImpulse;
		}

		//impulse = m_linearImpulse - oldImpulse;
		impulse.x = m_linearImpulse.x - oldImpulse.x;
		impulse.y = m_linearImpulse.y - oldImpulse.y;

		//vA -= mA * impulse;
		vA.x -= mA * impulse.x;
		vA.y -= mA * impulse.y;
		wA -= iA * b2Math.b2Cross2 (rA, impulse);

		//vB += mB * impulse;
		vB.x += mB * impulse.x;
		vB.y += mB * impulse.y;
		wB += iB * b2Math.b2Cross2 (rB, impulse);
	}

	//bA->m_linearVelocity = vA;
	bA.m_linearVelocity.x = vA.x;
	bA.m_linearVelocity.y = vA.y;
	bA.m_angularVelocity = wA;
	//bB->m_linearVelocity = vB;
	bB.m_linearVelocity.x = vB.x;
	bB.m_linearVelocity.y = vB.y;
	bB.m_angularVelocity = wB;
}

override public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	//B2_NOT_USED(baumgarte);

	return true;
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
	//return inv_dt * m_linearImpulse;
	return b2Vec2.b2Vec2_From2Numbers (inv_dt * m_linearImpulse.x, inv_dt * m_linearImpulse.y);
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	return inv_dt * m_angularImpulse;
}
