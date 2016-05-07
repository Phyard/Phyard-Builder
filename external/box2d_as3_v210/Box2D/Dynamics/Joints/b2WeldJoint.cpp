/*
* Copyright (c) 2006-2009 Erin Catto http://www.box2d.org
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

//#include <Box2D/Dynamics/Joints/b2WeldJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// Point-to-point constraint
// C = p2 - p1
// Cdot = v2 - v1
//      = v2 + cross(w2, r2) - v1 - cross(w1, r1)
// J = [-I -r1_skew I r2_skew ]
// Identity used:
// w k % (rx i + ry j) = w * (-ry i + rx j)

// Angle constraint
// C = angle2 - angle1 - referenceAngle
// Cdot = w2 - w1
// J = [0 0 -1 0 0 1]
// K = invI1 + invI2

//void b2WeldJointDef::Initialize(b2Body* bA, b2Body* bB, const b2Vec2& anchor)
//{
//	bodyA = bA;
//	bodyB = bB;
//	localAnchorA = bodyA->GetLocalPoint(anchor);
//	localAnchorB = bodyB->GetLocalPoint(anchor);
//	referenceAngle = bodyB->GetAngle() - bodyA->GetAngle();
//}

public function b2WeldJoint(def:b2WeldJointDef)
//: b2Joint(def)
{
	super (def);

	m_localAnchorA.CopyFrom (def.localAnchorA);
	m_localAnchorB.CopyFrom (def.localAnchorB);
	m_referenceAngle = def.referenceAngle;

	m_impulse.SetZero();
}

private static var rA:b2Vec2 = new b2Vec2 ();
private static var rB:b2Vec2 = new b2Vec2 ();
private static var tempV:b2Vec2 = new b2Vec2 ();
private static var P:b2Vec2 = new b2Vec2 ();

private static var vA:b2Vec2 = new b2Vec2 ();
private static var vB:b2Vec2 = new b2Vec2 ();
private static var Cdot1:b2Vec2 = new b2Vec2 ();
private static var Cdot:b2Vec3 = new b2Vec3 ();

private static var C1:b2Vec2 = new b2Vec2 ();
private static var C:b2Vec3 = new b2Vec3 ();

override public function InitVelocityConstraints (step:b2TimeStep):void
{
	//var rA:b2Vec2 = new b2Vec2 ();
	//var rB:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();
	//var P:b2Vec2 = new b2Vec2 ();

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

	m_mass.col1.x = mA + mB + rA.y * rA.y * iA + rB.y * rB.y * iB;
	m_mass.col2.x = -rA.y * rA.x * iA - rB.y * rB.x * iB;
	m_mass.col3.x = -rA.y * iA - rB.y * iB;
	m_mass.col1.y = m_mass.col2.x;
	m_mass.col2.y = mA + mB + rA.x * rA.x * iA + rB.x * rB.x * iB;
	m_mass.col3.y = rA.x * iA + rB.x * iB;
	m_mass.col1.z = m_mass.col3.x;
	m_mass.col2.z = m_mass.col3.y;
	m_mass.col3.z = iA + iB;

	if (step.warmStarting)
	{
		// Scale impulses to support a variable time step.
		//m_impulse *= step.dtRatio;
		m_impulse.x *= step.dtRatio;
		m_impulse.y *= step.dtRatio;
		m_impulse.z *= step.dtRatio;

		//b2Vec2 P(m_impulse.x, m_impulse.y);
		P.Set (m_impulse.x, m_impulse.y);

		//bA->m_linearVelocity -= mA * P;
		bA.m_linearVelocity.x -= mA * P.x;
		bA.m_linearVelocity.y -= mA * P.y;
		bA.m_angularVelocity -= iA * (b2Math.b2Cross2(rA, P) + m_impulse.z);

		//bB->m_linearVelocity += mB * P;
		bB.m_linearVelocity.x += mB * P.x;
		bB.m_linearVelocity.y += mB * P.y;
		bB.m_angularVelocity += iB * (b2Math.b2Cross2(rB, P) + m_impulse.z);
	}
	else
	{
		m_impulse.SetZero();
	}
}

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	//B2_NOT_USED(step);

	//var vA:b2Vec2 = new b2Vec2 ();
	//var vB:b2Vec2 = new b2Vec2 ();
	//var rA:b2Vec2 = new b2Vec2 ();
	//var rB:b2Vec2 = new b2Vec2 ();
	//var Cdot1:b2Vec2 = new b2Vec2 ();
	//var Cdot:b2Vec3 = new b2Vec3 ();
	//var P:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();

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

	// Solve point-to-point constraint
	//b2Vec2 Cdot1 = vB + b2Cross(wB, rB) - vA - b2Cross(wA, rA);
	Cdot1.x = vB.x - vA.x;
	Cdot1.y = vB.y - vA.y;
	b2Math.b2Cross_ScalarAndVector2_Output (wB, rB, tempV);
	Cdot1.x += tempV.x;
	Cdot1.y += tempV.y;
	b2Math.b2Cross_ScalarAndVector2_Output (wA, rA, tempV);
	Cdot1.x -= tempV.x;
	Cdot1.y -= tempV.y;
	var Cdot2:Number = wB - wA;
	//b2Vec3 Cdot(Cdot1.x, Cdot1.y, Cdot2);
	Cdot.Set  (-Cdot1.x, -Cdot1.y, -Cdot2); // here already negatived, so below will not

	//b2Vec3 impulse = m_mass.Solve33(-Cdot);
	var impulse:b2Vec3 = m_mass.Solve33(Cdot); // here not negatived, see above
	//m_impulse += impulse;
	m_impulse.x += impulse.x;
	m_impulse.y += impulse.y;
	m_impulse.z += impulse.z;

	//b2Vec2 P(impulse.x, impulse.y);
	P.Set (impulse.x, impulse.y);

	//vA -= mA * P;
	vA.x -= mA * P.x;
	vA.y -= mA * P.y;
	wA -= iA * (b2Math.b2Cross2 (rA, P) + impulse.z);

	//vB += mB * P;
	vB.x += mB * P.x;
	vB.y += mB * P.y;
	wB += iB * (b2Math.b2Cross2 (rB, P) + impulse.z);

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

	//var rA:b2Vec2 = new b2Vec2 ();
	//var rB:b2Vec2 = new b2Vec2 ();
	//var C1:b2Vec2 = new b2Vec2 ();
	//var C:b2Vec3 = new b2Vec3 ();
	//var P:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();

	var bA:b2Body = m_bodyA;
	var bB:b2Body = m_bodyB;

	var mA:Number = bA.m_invMass, mB:Number = bB.m_invMass;
	var iA:Number = bA.m_invI, iB:Number = bB.m_invI;

	//b2Vec2 rA = b2Mul(bA->GetTransform().R, m_localAnchorA - bA->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorA, bA.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bA.GetTransform().R, tempV, rA);
	//b2Vec2 rB = b2Mul(bB->GetTransform().R, m_localAnchorB - bB->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchorB, bB.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (bB.GetTransform().R, tempV, rB);

	//b2Vec2 C1 =  bB->m_sweep.c + rB - bA->m_sweep.c - rA;
	C1.x = bB.m_sweep.c.x + rB.x - bA.m_sweep.c.x - rA.x;
	C1.y = bB.m_sweep.c.y + rB.y - bA.m_sweep.c.y - rA.y;
	var C2:Number = bB.m_sweep.a - bA.m_sweep.a - m_referenceAngle;

	// Handle large detachment.
	const k_allowedStretch:Number = 10.0 * b2Settings.b2_linearSlop;
	var positionError:Number = C1.Length();
	//float32 angularError = b2Abs(C2);
	var angularError:Number = Math.abs (C2);
	if (positionError > k_allowedStretch)
	{
		iA *= 1.0;
		iB *= 1.0;
	}

	m_mass.col1.x = mA + mB + rA.y * rA.y * iA + rB.y * rB.y * iB;
	m_mass.col2.x = -rA.y * rA.x * iA - rB.y * rB.x * iB;
	m_mass.col3.x = -rA.y * iA - rB.y * iB;
	m_mass.col1.y = m_mass.col2.x;
	m_mass.col2.y = mA + mB + rA.x * rA.x * iA + rB.x * rB.x * iB;
	m_mass.col3.y = rA.x * iA + rB.x * iB;
	m_mass.col1.z = m_mass.col3.x;
	m_mass.col2.z = m_mass.col3.y;
	m_mass.col3.z = iA + iB;

	//b2Vec3 C(C1.x, C1.y, C2);
	C.Set (-C1.x, -C1.y, -C2); // here already negatived, so will not below

	//b2Vec3 impulse = m_mass.Solve33(-C);
	var impulse:b2Vec3 = m_mass.Solve33(C); // not negatived, see above

	//b2Vec2 P(impulse.x, impulse.y);
	P.Set (impulse.x, impulse.y);

	//bA->m_sweep.c -= mA * P;
	bA.m_sweep.c.x -= mA * P.x;
	bA.m_sweep.c.y -= mA * P.y;
	bA.m_sweep.a -= iA * (b2Math.b2Cross2 (rA, P) + impulse.z);

	//bB->m_sweep.c += mB * P;
	bB.m_sweep.c.x += mB * P.x;
	bB.m_sweep.c.y += mB * P.y;
	bB.m_sweep.a += iB * (b2Math.b2Cross2 (rB, P) + impulse.z);

	bA.SynchronizeTransform();
	bB.SynchronizeTransform();

	return positionError <= b2Settings.b2_linearSlop && angularError <= b2Settings.b2_angularSlop;
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
	//b2Vec2 P(m_impulse.x, m_impulse.y);
	//return inv_dt * P;
	return b2Vec2.b2Vec2_From2Numbers (inv_dt * m_impulse.x, inv_dt * m_impulse.y);
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	return inv_dt * m_impulse.z;
}
