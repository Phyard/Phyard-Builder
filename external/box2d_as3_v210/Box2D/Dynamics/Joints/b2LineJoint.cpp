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

//#include <Box2D/Dynamics/Joints/b2LineJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// Linear constraint (point-to-line)
// d = p2 - p1 = x2 + r2 - x1 - r1
// C = dot(perp, d)
// Cdot = dot(d, cross(w1, perp)) + dot(perp, v2 + cross(w2, r2) - v1 - cross(w1, r1))
//      = -dot(perp, v1) - dot(cross(d + r1, perp), w1) + dot(perp, v2) + dot(cross(r2, perp), v2)
// J = [-perp, -cross(d + r1, perp), perp, cross(r2,perp)]
//
// K = J * invM * JT
//
// J = [-a -s1 a s2]
// a = perp
// s1 = cross(d + r1, a) = cross(p2 - x1, a)
// s2 = cross(r2, a) = cross(p2 - x2, a)


// Motor/Limit linear constraint
// C = dot(ax1, d)
// Cdot = = -dot(ax1, v1) - dot(cross(d + r1, ax1), w1) + dot(ax1, v2) + dot(cross(r2, ax1), v2)
// J = [-ax1 -cross(d+r1,ax1) ax1 cross(r2,ax1)]

// Block Solver
// We develop a block solver that includes the joint limit. This makes the limit stiff (inelastic) even
// when the mass has poor distribution (leading to large torques about the joint anchor points).
//
// The Jacobian has 3 rows:
// J = [-uT -s1 uT s2] // linear
//     [-vT -a1 vT a2] // limit
//
// u = perp
// v = axis
// s1 = cross(d + r1, u), s2 = cross(r2, u)
// a1 = cross(d + r1, v), a2 = cross(r2, v)

// M * (v2 - v1) = JT * df
// J * v2 = bias
//
// v2 = v1 + invM * JT * df
// J * (v1 + invM * JT * df) = bias
// K * df = bias - J * v1 = -Cdot
// K = J * invM * JT
// Cdot = J * v1 - bias
//
// Now solve for f2.
// df = f2 - f1
// K * (f2 - f1) = -Cdot
// f2 = invK * (-Cdot) + f1
//
// Clamp accumulated limit impulse.
// lower: f2(2) = max(f2(2), 0)
// upper: f2(2) = min(f2(2), 0)
//
// Solve for correct f2(1)
// K(1,1) * f2(1) = -Cdot(1) - K(1,2) * f2(2) + K(1,1:2) * f1
//                = -Cdot(1) - K(1,2) * f2(2) + K(1,1) * f1(1) + K(1,2) * f1(2)
// K(1,1) * f2(1) = -Cdot(1) - K(1,2) * (f2(2) - f1(2)) + K(1,1) * f1(1)
// f2(1) = invK(1,1) * (-Cdot(1) - K(1,2) * (f2(2) - f1(2))) + f1(1)
//
// Now compute impulse to be applied:
// df = f2 - f1

//void b2LineJointDef::Initialize(b2Body* b1, b2Body* b2, const b2Vec2& anchor, const b2Vec2& axis)
//{
//	body1 = b1;
//	body2 = b2;
//	localAnchor1 = body1->GetLocalPoint(anchor);
//	localAnchor2 = body2->GetLocalPoint(anchor);
//	localAxis1 = body1->GetLocalVector(axis);
//}

public function b2LineJoint (def:b2LineJointDef)
//: b2Joint(def)
{
	super (def);

	m_localAnchor1.CopyFrom (def.localAnchorA);
	m_localAnchor2.CopyFrom (def.localAnchorB);
	m_localXAxis1.CopyFrom (def.localAxisA);
	m_localYAxis1.CopyFrom (b2Math.b2Cross_ScalarAndVector2 (1.0, m_localXAxis1));

	m_impulse.SetZero();
	m_motorMass = 0.0;
	m_motorImpulse = 0.0;

	m_lowerTranslation = def.lowerTranslation;
	m_upperTranslation = def.upperTranslation;
	m_maxMotorForce = def.maxMotorForce;
	m_motorSpeed = def.motorSpeed;
	m_enableLimit = def.enableLimit;
	m_enableMotor = def.enableMotor;
	m_limitState = e_inactiveLimit;

	m_axis.SetZero();
	m_perp.SetZero();
}

override public function InitVelocityConstraints(step:b2TimeStep):void
{
	var r1:b2Vec2 = new b2Vec2 ();
	var r2:b2Vec2 = new b2Vec2 ();
	var d:b2Vec2 = new b2Vec2 ();
	var P:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	m_localCenterA.CopyFrom (b1.GetLocalCenter());
	m_localCenterB.CopyFrom (b2.GetLocalCenter());

	var xf1:b2Transform = b1.GetTransform(); //.Clone ()
	var xf2:b2Transform = b2.GetTransform(); //.Clone ()

	// Compute the effective masses.
	//b2Vec2 r1 = b2Mul(xf1.R, m_localAnchor1 - m_localCenterA);
	b2Math.b2Subtract_Vector2_Output (m_localAnchor1, m_localCenterA, tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (xf1.R, tempV, r1);
	//b2Vec2 r2 = b2Mul(xf2.R, m_localAnchor2 - m_localCenterB);
	b2Math.b2Subtract_Vector2_Output ( m_localAnchor2, m_localCenterB, tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (xf2.R, tempV, r2);
	//b2Vec2 d = b2->m_sweep.c + r2 - b1->m_sweep.c - r1;
	d.x = b2.m_sweep.c.x + r2.x - b1.m_sweep.c.x - r1.x;
	d.y = b2.m_sweep.c.y + r2.y - b1.m_sweep.c.y - r1.y;

	m_invMassA = b1.m_invMass;
	m_invIA = b1.m_invI;
	m_invMassB = b2.m_invMass;
	m_invIB = b2.m_invI;

	// Compute motor Jacobian and effective mass.
	{
		//m_axis = b2Mul(xf1.R, m_localXAxis1);
		b2Math.b2Mul_Matrix22AndVector2_Output (xf1.R, m_localXAxis1, m_axis);
		//m_a1 = b2Math.b2Cross2(d + r1, m_axis);
		tempV.x = d.x + r1.x;
		tempV.y = d.y + r1.y;
		m_a1 = b2Math.b2Cross2 (tempV, m_axis);
		m_a2 = b2Math.b2Cross2 (r2, m_axis);

		m_motorMass = m_invMassA + m_invMassB + m_invIA * m_a1 * m_a1 + m_invIB * m_a2 * m_a2;
		if (m_motorMass > b2Settings.b2_epsilon)
		{
			m_motorMass = 1.0 / m_motorMass;
		}
		else
		{
			m_motorMass = 0.0;
		}
	}

	// Prismatic constraint.
	{
		//m_perp = b2Mul(xf1.R, m_localYAxis1);
		b2Math.b2Mul_Matrix22AndVector2_Output (xf1.R, m_localYAxis1, m_perp);

		//m_s1 = b2Math.b2Cross2(d + r1, m_perp);
		tempV.x = d.x + r1.x;
		tempV.y = d.y + r1.y;
		m_s1 = b2Math.b2Cross2 (tempV, m_perp);
		m_s2 = b2Math.b2Cross2 (r2, m_perp);

		var m1:Number = m_invMassA, m2:Number = m_invMassB;
		var i1:Number = m_invIA, i2:Number = m_invIB;

		var k11:Number = m1 + m2 + i1 * m_s1 * m_s1 + i2 * m_s2 * m_s2;
		var k12:Number = i1 * m_s1 * m_a1 + i2 * m_s2 * m_a2;
		var k22:Number = m1 + m2 + i1 * m_a1 * m_a1 + i2 * m_a2 * m_a2;

		m_K.col1.Set(k11, k12);
		m_K.col2.Set(k12, k22);
	}

	// Compute motor and limit terms.
	if (m_enableLimit)
	{
		var jointTranslation:Number = b2Math.b2Dot2 (m_axis, d);
		if (Math.abs (m_upperTranslation - m_lowerTranslation) < 2.0 * b2Settings.b2_linearSlop)
		{
			m_limitState = b2Joint.e_equalLimits;
		}
		else if (jointTranslation <= m_lowerTranslation)
		{
			if (m_limitState != e_atLowerLimit)
			{
				m_limitState = b2Joint.e_atLowerLimit;
				m_impulse.y = 0.0;
			}
		}
		else if (jointTranslation >= m_upperTranslation)
		{
			if (m_limitState != e_atUpperLimit)
			{
				m_limitState = b2Joint.e_atUpperLimit;
				m_impulse.y = 0.0;
			}
		}
		else
		{
			m_limitState = b2Joint.e_inactiveLimit;
			m_impulse.y = 0.0;
		}
	}
	else
	{
		m_limitState = b2Joint.e_inactiveLimit;
	}

	if (m_enableMotor == false)
	{
		m_motorImpulse = 0.0;
	}

	if (step.warmStarting)
	{
		// Account for variable time step.
		//m_impulse *= step.dtRatio;
		m_impulse.x *= step.dtRatio;
		m_impulse.y *= step.dtRatio;
		m_motorImpulse *= step.dtRatio;

		var tF:Number = m_motorImpulse + m_impulse.y;
		//b2Vec2 P = m_impulse.x * m_perp + (m_motorImpulse + m_impulse.y) * m_axis;
		//float32 L1 = m_impulse.x * m_s1 + (m_motorImpulse + m_impulse.y) * m_a1;
		//float32 L2 = m_impulse.x * m_s2 + (m_motorImpulse + m_impulse.y) * m_a2;
		P.x = m_impulse.x * m_perp.x + tF * m_axis.x;
		P.y = m_impulse.x * m_perp.y + tF * m_axis.y;
		var L1:Number = m_impulse.x * m_s1 + tF * m_a1;
		var L2:Number = m_impulse.x * m_s2 + tF * m_a2;

		//b1->m_linearVelocity -= m_invMassA * P;
		b1.m_linearVelocity.x -= m_invMassA * P.x;
		b1.m_linearVelocity.y -= m_invMassA * P.y;
		b1.m_angularVelocity -= m_invIA * L1;

		//b2->m_linearVelocity += m_invMassB * P;
		b2.m_linearVelocity.x += m_invMassB * P.x;
		b2.m_linearVelocity.y += m_invMassB * P.y;
		b2.m_angularVelocity += m_invIB * L2;
	}
	else
	{
		m_impulse.SetZero();
		m_motorImpulse = 0.0;
	}
}

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	var v1:b2Vec2 = new b2Vec2 ();
	var v2:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var CdotVec2:b2Vec2 = new b2Vec2 ();
	var P:b2Vec2 = new b2Vec2 ();
	var f1:b2Vec2 = new b2Vec2 ();
	var dfVec2:b2Vec2;// = new b2Vec2 ();

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	v1.CopyFrom (b1.m_linearVelocity);
	var w1:Number = b1.m_angularVelocity;
	v2.CopyFrom (b2.m_linearVelocity);
	var w2:Number = b2.m_angularVelocity;

	var L1:Number;
	var L2:Number;

	// Solve linear motor constraint.
	if (m_enableMotor && m_limitState != b2Joint.e_equalLimits)
	{
		//float32 Cdot = b2Dot(m_axis, v2 - v1) + m_a2 * w2 - m_a1 * w1;
		tempV.x = v2.x - v1.x;
		tempV.y = v2.y - v1.y;
		var Cdot:Number = b2Math.b2Dot2(m_axis, tempV) + m_a2 * w2 - m_a1 * w1;
		var impulse:Number = m_motorMass * (m_motorSpeed - Cdot);
		var oldImpulse:Number = m_motorImpulse;
		var maxImpulse:Number = step.dt * m_maxMotorForce;
		m_motorImpulse = b2Math.b2Clamp_Number (m_motorImpulse + impulse, -maxImpulse, maxImpulse);
		impulse = m_motorImpulse - oldImpulse;

		//b2Vec2 P = impulse * m_axis;
		P.x = impulse * m_axis.x;
		P.y = impulse * m_axis.y;
		L1 = impulse * m_a1;
		L2 = impulse * m_a2;

		//v1 -= m_invMassA * P;
		v1.x -= m_invMassA * P.x;
		v1.y -= m_invMassA * P.y;
		w1 -= m_invIA * L1;

		//v2 += m_invMassB * P;
		v2.x += m_invMassB * P.x;
		v2.y += m_invMassB * P.y;
		w2 += m_invIB * L2;
	}

	//float32 Cdot1 = b2Math.b2Dot2(m_perp, v2 - v1) + m_s2 * w2 - m_s1 * w1;
	tempV.x = v2.x - v1.x;
	tempV.y = v2.y - v1.y;
	var Cdot1:Number = b2Math.b2Dot2 (m_perp, tempV) + m_s2 * w2 - m_s1 * w1;

	if (m_enableLimit && m_limitState != e_inactiveLimit)
	{
		// Solve prismatic and limit constraint in block form.
		//float32 Cdot2 = b2Math.b2Dot2(m_axis, v2 - v1) + m_a2 * w2 - m_a1 * w1;
		tempV.x = v2.x - v1.x;
		tempV.y = v2.y - v1.y;
		var Cdot2:Number  = b2Math.b2Dot2(m_axis, tempV) + m_a2 * w2 - m_a1 * w1;
		//b2Vec2 Cdot(Cdot1, Cdot2);
		CdotVec2.Set (Cdot1, Cdot2); // this verialbe can totally replace by tempV

		//b2Vec2 f1 = m_impulse;
		f1.CopyFrom (m_impulse);
		//b2Vec2 df =  m_K.Solve(-Cdot);
		tempV.x = - CdotVec2.x;
		tempV.y = - CdotVec2.y;
		dfVec2 =  m_K.Solve(tempV);
		//m_impulse += df;
		m_impulse.x += dfVec2.x;
		m_impulse.y += dfVec2.y;

		if (m_limitState == e_atLowerLimit)
		{
			m_impulse.y = Math.max (m_impulse.y, 0.0);
		}
		else if (m_limitState == e_atUpperLimit)
		{
			m_impulse.y = Math.min (m_impulse.y, 0.0);
		}

		// f2(1) = invK(1,1) * (-Cdot(1) - K(1,2) * (f2(2) - f1(2))) + f1(1)
		var b:Number = -Cdot1 - (m_impulse.y - f1.y) * m_K.col2.x;
		var f2r:Number;
		if (m_K.col1.x != 0.0)
		{
			f2r = b / m_K.col1.x + f1.x;
		}
		else
		{
			f2r = f1.x;
		}
		m_impulse.x = f2r;

		//df = m_impulse - f1;
		dfVec2.x = m_impulse.x - f1.x;
		dfVec2.y = m_impulse.y - f1.y;

		//b2Vec2 P = df.x * m_perp + df.y * m_axis;
		P.x = dfVec2.x * m_perp.x + dfVec2.y * m_axis.x;
		P.y = dfVec2.x * m_perp.y + dfVec2.y * m_axis.y;
		L1 = dfVec2.x * m_s1 + dfVec2.y * m_a1;
		L2 = dfVec2.x * m_s2 + dfVec2.y * m_a2;

		//v1 -= m_invMassA * P;
		v1.x -= m_invMassA * P.x;
		v1.y -= m_invMassA * P.y;
		w1 -= m_invIA * L1;

		//v2 += m_invMassB * P;
		v2.x += m_invMassB * P.x;
		v2.y += m_invMassB * P.y;
		w2 += m_invIB * L2;
	}
	else
	{
		// Limit is inactive, just solve the prismatic constraint in block form.
		var df:Number;
		if (m_K.col1.x != 0.0)
		{
			df = - Cdot1 / m_K.col1.x;
		}
		else
		{
			df = 0.0;
		}
		m_impulse.x += df;

		//b2Vec2 P = df * m_perp;
		P.x = df * m_perp.x;
		P.y = df * m_perp.y;
		L1 = df * m_s1;
		L2 = df * m_s2;

		//v1 -= m_invMassA * P;
		v1.x -= m_invMassA * P.x;
		v1.y -= m_invMassA * P.y;
		w1 -= m_invIA * L1;

		//v2 += m_invMassB * P;
		v2.x += m_invMassB * P.x;
		v2.y += m_invMassB * P.y;
		w2 += m_invIB * L2;
	}

	b1.m_linearVelocity.CopyFrom (v1);
	b1.m_angularVelocity = w1;
	b2.m_linearVelocity.CopyFrom (v2);
	b2.m_angularVelocity = w2;
}

override public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	var c1:b2Vec2 = new b2Vec2 ();
	var c2:b2Vec2 = new b2Vec2 ();
	var d:b2Vec2 = new b2Vec2 ();
	var P:b2Vec2 = new b2Vec2 ();
	var r1:b2Vec2 = new b2Vec2 ();
	var r2:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var impulse:b2Vec2 = new b2Vec2 ();

	var R1:b2Mat22 = new b2Mat22 ();
	var R2:b2Mat22 = new b2Mat22 ();

	//B2_NOT_USED(baumgarte);

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	c1.CopyFrom (b1.m_sweep.c);
	var a1:Number = b1.m_sweep.a;

	c2.CopyFrom (b2.m_sweep.c);
	var a2:Number = b2.m_sweep.a;

	// Solve linear limit constraint.
	var linearError:Number = 0.0, angularError:Number = 0.0;
	var active:Boolean = false;
	var C2:Number = 0.0;

	//b2Mat22 R1(a1), R2(a2);
	R1.SetFromAngle (a1);
	R2.SetFromAngle (a2);

	//b2Vec2 r1 = b2Mul(R1, m_localAnchor1 - m_localCenterA);
	tempV.x = m_localAnchor1.x - m_localCenterA.x;
	tempV.y = m_localAnchor1.y - m_localCenterA.y;
	b2Math.b2Mul_Matrix22AndVector2_Output (R1, tempV, r1);
	//b2Vec2 r2 = b2Mul(R2, m_localAnchor2 - m_localCenterB);
	tempV.x = m_localAnchor2.x - m_localCenterB.x;
	tempV.y = m_localAnchor2.y - m_localCenterB.y;
	b2Math.b2Mul_Matrix22AndVector2_Output (R2, tempV, r2);
	//b2Vec2 d = c2 + r2 - c1 - r1;
	d.x = c2.x + r2.x - c1.x - r1.x;
	d.y = c2.y + r2.y - c1.y - r1.y;

	if (m_enableLimit)
	{
		//m_axis = b2Mul(R1, m_localXAxis1);
		b2Math.b2Mul_Matrix22AndVector2_Output (R1, m_localXAxis1, m_axis);

		//m_a1 = b2Math.b2Cross2(d + r1, m_axis);
		tempV.x = d.x + r1.x;
		tempV.y = d.y + r1.y;
		m_a1 = b2Math.b2Cross2 (tempV, m_axis);
		m_a2 = b2Math.b2Cross2 (r2, m_axis);

		var translation:Number = b2Math.b2Dot2(m_axis, d);
		if (Math.abs (m_upperTranslation - m_lowerTranslation) < 2.0 * b2Settings.b2_linearSlop)
		{
			// Prevent large angular corrections
			C2 = b2Math.b2Clamp_Number (translation, - b2Settings.b2_maxLinearCorrection, b2Settings.b2_maxLinearCorrection);
			linearError = Math.abs (translation);
			active = true;
		}
		else if (translation <= m_lowerTranslation)
		{
			// Prevent large linear corrections and allow some slop.
			C2 = b2Math.b2Clamp_Number (translation - m_lowerTranslation + b2Settings.b2_linearSlop, - b2Settings.b2_maxLinearCorrection, 0.0);
			linearError = m_lowerTranslation - translation;
			active = true;
		}
		else if (translation >= m_upperTranslation)
		{
			// Prevent large linear corrections and allow some slop.
			C2 = b2Math.b2Clamp_Number (translation - m_upperTranslation - b2Settings.b2_linearSlop, 0.0, b2Settings.b2_maxLinearCorrection);
			linearError = translation - m_upperTranslation;
			active = true;
		}
	}

	//m_perp = b2Mul(R1, m_localYAxis1);
	b2Math.b2Mul_Matrix22AndVector2_Output (R1, m_localYAxis1, m_perp);

	//m_s1 = b2Math.b2Cross2 (d + r1, m_perp);
	tempV.x = d.x + r1.x;
	tempV.y = d.y + r1.y;
	m_s1 = b2Math.b2Cross2 (tempV, m_perp);
	m_s2 = b2Math.b2Cross2 (r2, m_perp);

	//b2Vec2 impulse;
	var C1:Number;
	C1 = b2Math.b2Dot2 (m_perp, d);

	linearError = Math.max (linearError, Math.abs (C1));
	angularError = 0.0;

		var m1:Number, m2:Number;
		var i1:Number, i2:Number;
		var k11:Number;

	if (active)
	{
		m1 = m_invMassA; m2 = m_invMassB;
		i1 = m_invIA;    i2 = m_invIB;

		    k11        = m1 + m2 + i1 * m_s1 * m_s1 + i2 * m_s2 * m_s2;
		var k12:Number = i1 * m_s1 * m_a1 + i2 * m_s2 * m_a2;
		var k22:Number = m1 + m2 + i1 * m_a1 * m_a1 + i2 * m_a2 * m_a2;

		m_K.col1.Set(k11, k12);
		m_K.col2.Set(k12, k22);

		//b2Vec2 C;
		//C.x = C1;
		//C.y = C2;
		//
		//impulse = m_K.Solve(-C);
		tempV.x = - C1;
		tempV.y = - C2;
		impulse = m_K.Solve(tempV); // CopyFrom ()
	}
	else
	{
		m1 = m_invMassA; m2 = m_invMassB;
		i1 = m_invIA;    i2 = m_invIB;

		k11 = m1 + m2 + i1 * m_s1 * m_s1 + i2 * m_s2 * m_s2;

		var impulse1:Number;
		if (k11 != 0.0)
		{
			impulse1 = - C1 / k11;
		}
		else
		{
			impulse1 = 0.0;
		}
		impulse.x = impulse1;
		impulse.y = 0.0;
	}

	//b2Vec2 P = impulse.x * m_perp + impulse.y * m_axis;
	P.x = impulse.x * m_perp.x + impulse.y * m_axis.x;
	P.y = impulse.x * m_perp.y + impulse.y * m_axis.y;
	var L1:Number = impulse.x * m_s1 + impulse.y * m_a1;
	var L2:Number = impulse.x * m_s2 + impulse.y * m_a2;

	//c1 -= m_invMassA * P;
	c1.x -= m_invMassA * P.x;
	c1.y -= m_invMassA * P.y;
	a1 -= m_invIA * L1;
	//c2 += m_invMassB * P;
	c2.x += m_invMassB * P.x;
	c2.y += m_invMassB * P.y;
	a2 += m_invIB * L2;

	// TODO_ERIN remove need for this.
	b1.m_sweep.c.CopyFrom (c1);
	b1.m_sweep.a = a1;
	b2.m_sweep.c.CopyFrom (c2);
	b2.m_sweep.a = a2;
	b1.SynchronizeTransform();
	b2.SynchronizeTransform();

	return linearError <= b2Settings.b2_linearSlop && angularError <= b2Settings.b2_angularSlop;
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
	//return inv_dt * (m_impulse.x * m_perp + (m_motorImpulse + m_impulse.y) * m_axis);
	return b2Vec2.b2Vec2_From2Numbers (
		inv_dt * (m_impulse.x * m_perp.x + (m_motorImpulse + m_impulse.y) * m_axis.x),
		inv_dt * (m_impulse.x * m_perp.y + (m_motorImpulse + m_impulse.y) * m_axis.y)
		);
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	//B2_NOT_USED(inv_dt);
	return 0.0;
}

private static var axis:b2Vec2 = new b2Vec2 ();
public function GetJointTranslation():Number
{
	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	//b2Vec2 p1 = b1->GetWorldPoint(m_localAnchor1);
	//b2Vec2 p2 = b2->GetWorldPoint(m_localAnchor2);
	//b2Vec2 d = p2 - p1;
	//b2Vec2 axis = b1->GetWorldVector(m_localXAxis1);
	//
	//float32 translation = b2Math.b2Dot2(d, axis);

	var p1:b2Vec2 = b1.GetWorldPoint(m_localAnchor1);
	var p2:b2Vec2 = b2.GetWorldPoint(m_localAnchor2);
	p2.x -= p1.x;
	p2.y -= p1.y;
	b1.GetWorldVector_Output (m_localXAxis1, axis);

	var translation:Number = b2Math.b2Dot2 (p2, axis);
	return translation;
}

public function GetJointSpeed():Number
{
	var r1:b2Vec2 = new b2Vec2 ();
	var r2:b2Vec2 = new b2Vec2 ();
	var p1:b2Vec2 = new b2Vec2 ();
	var p2:b2Vec2 = new b2Vec2 ();
	var d:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var tempV1:b2Vec2 = new b2Vec2 ();
	var tempV2:b2Vec2 = new b2Vec2 ();

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
	//b2Vec2 d = p2 - p1;
	d.x = p2.x - p1.x;
	d.y = p2.y - p1.y;
	b1.GetWorldVector_Output (m_localXAxis1, axis);

	//b2Vec2 v1 = b1->m_linearVelocity;
	//b2Vec2 v2 = b2->m_linearVelocity;
	var v1:b2Vec2 = b1.m_linearVelocity; // .Clone ()
	var v2:b2Vec2 = b2.m_linearVelocity; // .Clone ()
	var w1:Number = b1.m_angularVelocity;
	var w2:Number = b2.m_angularVelocity;

	//float32 speed = b2Math.b2Dot2(d, b2Math.b2Cross2(w1, axis)) + b2Dot(axis, v2 + b2Math.b2Cross2(w2, r2) - v1 - b2Math.b2Cross2(w1, r1));
	b2Math.b2Cross_ScalarAndVector2_Output (w1, axis, tempV);
	b2Math.b2Cross_ScalarAndVector2_Output (w2, r2, tempV2);
	b2Math.b2Cross_ScalarAndVector2_Output (w1, r1, tempV1);
	var speed:Number = b2Math.b2Dot2 (d, tempV);
	tempV.x = v2.x + tempV2.x - v1.x - tempV1.x;
	tempV.y = v2.y + tempV2.y - v1.y - tempV1.y;
	speed += b2Math.b2Dot2 (axis, tempV);
	return speed;
}

public function IsLimitEnabled():Boolean
{
	return m_enableLimit;
}

public function EnableLimit(flag:Boolean):void
{
	m_bodyA.SetAwake(true);
	m_bodyB.SetAwake(true);
	m_enableLimit = flag;
}

public function GetLowerLimit():Number
{
	return m_lowerTranslation;
}

public function GetUpperLimit():Number
{
	return m_upperTranslation;
}

public function SetLimits(lower:Number, upper:Number):void
{
	//b2Assert(lower <= upper);
	m_bodyA.SetAwake(true);
	m_bodyB.SetAwake(true);
	m_lowerTranslation = lower;
	m_upperTranslation = upper;
}

public function IsMotorEnabled():Boolean
{
	return m_enableMotor;
}

public function EnableMotor(flag:Boolean):void
{
	m_bodyA.SetAwake(true);
	m_bodyB.SetAwake(true);
	m_enableMotor = flag;
}

public function SetMotorSpeed(speed:Number):void
{
	m_bodyA.SetAwake(true);
	m_bodyB.SetAwake(true);
	m_motorSpeed = speed;
}

public function SetMaxMotorForce(force:Number):void
{
	m_bodyA.SetAwake(true);
	m_bodyB.SetAwake(true);
	m_maxMotorForce = force;
}

public function GetMotorForce(inv_dt:Number):Number
{
	return inv_dt * m_motorImpulse;
}
