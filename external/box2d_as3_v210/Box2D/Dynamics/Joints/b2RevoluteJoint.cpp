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

//#include <Box2D/Dynamics/Joints/b2RevoluteJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// Point-to-point constraint
// C = p2 - p1
// Cdot = v2 - v1
//      = v2 + cross(w2, r2) - v1 - cross(w1, r1)
// J = [-I -r1_skew I r2_skew ]
// Identity used:
// w k % (rx i + ry j) = w * (-ry i + rx j)

// Motor constraint
// Cdot = w2 - w1
// J = [0 0 -1 0 0 1]
// K = invI1 + invI2

//void b2RevoluteJointDef::Initialize(b2Body* b1, b2Body* b2, const b2Vec2& anchor)
//{
//	body1 = b1;
//	body2 = b2;
//	localAnchor1 = body1->GetLocalPoint(anchor);
//	localAnchor2 = body2->GetLocalPoint(anchor);
//	referenceAngle = body2->GetAngle() - body1->GetAngle();
//}

public function b2RevoluteJoint(def:b2RevoluteJointDef)
//: b2Joint(def)
{
	super (def);
	
	m_localAnchor1.CopyFrom (def.localAnchorA);
	m_localAnchor2.CopyFrom (def.localAnchorB);
	m_referenceAngle = def.referenceAngle;

	m_impulse.SetZero();
	m_motorImpulse = 0.0;

	m_lowerAngle = def.lowerAngle;
	m_upperAngle = def.upperAngle;
	m_maxMotorTorque = def.maxMotorTorque;
	m_motorSpeed = def.motorSpeed;
	m_enableLimit = def.enableLimit;
	m_enableMotor = def.enableMotor;
	m_limitState = e_inactiveLimit;
}

private static var r1:b2Vec2 = new b2Vec2 ();
private static var r2:b2Vec2 = new b2Vec2 ();
private static var tempV:b2Vec2 = new b2Vec2 ();
private static var P:b2Vec2 = new b2Vec2 ();

private static var v1:b2Vec2 = new b2Vec2 ();
private static var v2:b2Vec2 = new b2Vec2 ();
private static var Cdot1:b2Vec2 = new b2Vec2 ();
private static var CdotVec3:b2Vec3 = new b2Vec3 ();
private static var CdotVec2:b2Vec2 = new b2Vec2 ();

private static var CVec2:b2Vec2 = new b2Vec2 ();
private static var impulse:b2Vec2 = new b2Vec2 ();
private static var u:b2Vec2 = new b2Vec2 ();

private static var K1:b2Mat22 = new b2Mat22 ();
private static var K2:b2Mat22 = new b2Mat22 ();
private static var K3:b2Mat22 = new b2Mat22 ();
private static var K:b2Mat22 = new b2Mat22 ();


override public function InitVelocityConstraints(step:b2TimeStep):void
{
	//var r1:b2Vec2 = new b2Vec2 ();
	//var r2:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();
	//var P:b2Vec2 = new b2Vec2 ();
	
	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;
	
	if (m_enableMotor || m_enableLimit)
	{
		// You cannot create a rotation limit between bodies that
		// both have fixed rotation.
		//b2Assert(b1->m_invI > 0.0f || b2->m_invI > 0.0f);
	}

	// Compute the effective mass matrix.
	//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
	//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

	// J = [-I -r1_skew I r2_skew]
	//     [ 0       -1 0       1]
	// r_skew = [-ry; rx]

	// Matlab
	// K = [ m1+r1y^2*i1+m2+r2y^2*i2,  -r1y*i1*r1x-r2y*i2*r2x,          -r1y*i1-r2y*i2]
	//     [  -r1y*i1*r1x-r2y*i2*r2x, m1+r1x^2*i1+m2+r2x^2*i2,           r1x*i1+r2x*i2]
	//     [          -r1y*i1-r2y*i2,           r1x*i1+r2x*i2,                   i1+i2]

	var m1:Number = b1.m_invMass, m2:Number = b2.m_invMass;
	var i1:Number = b1.m_invI, i2:Number = b2.m_invI;

	m_mass.col1.x = m1 + m2 + r1.y * r1.y * i1 + r2.y * r2.y * i2;
	m_mass.col2.x = -r1.y * r1.x * i1 - r2.y * r2.x * i2;
	m_mass.col3.x = -r1.y * i1 - r2.y * i2;
	m_mass.col1.y = m_mass.col2.x;
	m_mass.col2.y = m1 + m2 + r1.x * r1.x * i1 + r2.x * r2.x * i2;
	m_mass.col3.y = r1.x * i1 + r2.x * i2;
	m_mass.col1.z = m_mass.col3.x;
	m_mass.col2.z = m_mass.col3.y;
	m_mass.col3.z = i1 + i2;

	m_motorMass = i1 + i2;
	if (m_motorMass > 0.0)
	{
		m_motorMass = 1.0 / m_motorMass;
	}

	if (m_enableMotor == false)
	{
		m_motorImpulse = 0.0;
	}

	if (m_enableLimit)
	{
		var jointAngle:Number = b2.m_sweep.a - b1.m_sweep.a - m_referenceAngle;
	
		if (Math.abs(m_upperAngle - m_lowerAngle) < 2.0 * b2Settings.b2_angularSlop)
		{
			m_limitState = b2Joint.e_equalLimits;
		}
		else if (jointAngle <= m_lowerAngle)
		{
			if (m_limitState != e_atLowerLimit)
			{
				m_impulse.z = 0.0;
			}
			m_limitState = e_atLowerLimit;
		}
		else if (jointAngle >= m_upperAngle)
		{
			if (m_limitState != e_atUpperLimit)
			{
				m_impulse.z = 0.0;
			}
			m_limitState = e_atUpperLimit;
		}
		else
		{
			m_limitState = e_inactiveLimit;
			m_impulse.z = 0.0;
		}
	}
	else
	{
		m_limitState = e_inactiveLimit;
	}

	if (step.warmStarting)
	{
		// Scale impulses to support a variable time step.
		//m_impulse *= step.dtRatio;
		m_impulse.x *= step.dtRatio;
		m_impulse.y *= step.dtRatio;
		m_impulse.z *= step.dtRatio;
		m_motorImpulse *= step.dtRatio;

		P.Set (m_impulse.x, m_impulse.y);

		//b1->m_linearVelocity -= m1 * P;
		b1.m_linearVelocity.x -= m1 * P.x;
		b1.m_linearVelocity.y -= m1 * P.y;
		b1.m_angularVelocity -= i1 * (b2Math.b2Cross2 (r1, P) + m_motorImpulse + m_impulse.z);

		//b2->m_linearVelocity += m2 * P;
		b2.m_linearVelocity.x += m2 * P.x;
		b2.m_linearVelocity.y += m2 * P.y;
		b2.m_angularVelocity += i2 * (b2Math.b2Cross2 (r2, P) + m_motorImpulse + m_impulse.z);
	}
	else
	{
		m_impulse.SetZero();
		m_motorImpulse = 0.0;
	}
}

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	//var v1:b2Vec2 = new b2Vec2 ();
	//var v2:b2Vec2 = new b2Vec2 ();
	//var r1:b2Vec2 = new b2Vec2 ();
	//var r2:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();
	
	//var P:b2Vec2 = new b2Vec2 ();
	//var Cdot1:b2Vec2 = new b2Vec2 ();
	
	//var CdotVec3:b2Vec3 = new b2Vec3 ();
	var impulseVec3:b2Vec3;
	
	//var CdotVec2:b2Vec2 = new b2Vec2 ();
	var impulseVec2:b2Vec2;
	var reduce:b2Vec2;

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;
	
	v1.CopyFrom (b1.m_linearVelocity);
	var w1:Number = b1.m_angularVelocity;
	v2.CopyFrom (b2.m_linearVelocity);
	var w2:Number = b2.m_angularVelocity;

	var m1:Number = b1.m_invMass, m2:Number = b2.m_invMass;
	var i1:Number = b1.m_invI, i2:Number = b2.m_invI;

	// Solve motor constraint.
	if (m_enableMotor && m_limitState != b2Joint.e_equalLimits)
	{
		var Cdot:Number = w2 - w1 - m_motorSpeed;
		var impulse:Number = m_motorMass * (-Cdot);
		var oldImpulse:Number = m_motorImpulse;
		var maxImpulse:Number = step.dt * m_maxMotorTorque;
		m_motorImpulse = b2Math.b2Clamp_Number (m_motorImpulse + impulse, -maxImpulse, maxImpulse);
		impulse = m_motorImpulse - oldImpulse;

		w1 -= i1 * impulse;
		w2 += i2 * impulse;
	}

	// Solve limit constraint.
	if (m_enableLimit && m_limitState != e_inactiveLimit)
	{
		//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
		//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

		// Solve point-to-point constraint
		//b2Vec2 Cdot1 = v2 + b2Math.b2Cross2(w2, r2) - v1 - b2Math.b2Cross2(w1, r1);
		b2Math.b2Cross_ScalarAndVector2_Output (w2, r2, Cdot1);
		b2Math.b2Cross_ScalarAndVector2_Output (w1, r1, tempV);
		Cdot1.x += v2.x - v1.x - tempV.x;
		Cdot1.y += v2.y - v1.y - tempV.y;
		var Cdot2:Number = w2 - w1;
		//b2Vec3 Cdot(Cdot1.x, Cdot1.y, Cdot2);
		CdotVec3.Set (-Cdot1.x, -Cdot1.y, -Cdot2);

		//b2Vec3 impulse = m_mass.Solve33(-Cdot);
		impulseVec3 = m_mass.Solve33(CdotVec3); // nocitce: CdotVec3 has already been nagetived.
		var newImpulse:Number;
		var reduced:b2Vec2;

		if (m_limitState == b2Joint.e_equalLimits)
		{
			//m_impulse += impulse;
			m_impulse.x += impulseVec3.x;
			m_impulse.y += impulseVec3.y;
			m_impulse.z += impulseVec3.z;
		}
		else if (m_limitState == e_atLowerLimit)
		{
			newImpulse = m_impulse.z + impulseVec3.z;
			
			if (newImpulse < 0.0)
			{
            //b2Vec2 rhs = -Cdot1 + m_impulse.z * b2Vec2(m_mass.col3.x, m_mass.col3.y);
            //b2Vec2 reduced = m_mass.Solve22(rhs);
            tempV.x = -Cdot1.x +  m_impulse.z * m_mass.col3.x;
            tempV.y = -Cdot1.y +  m_impulse.z * m_mass.col3.y;
            reduced = m_mass.Solve22 (tempV);
				
				impulseVec3.x = reduced.x;
				impulseVec3.y = reduced.y;
				impulseVec3.z = -m_impulse.z;
				m_impulse.x += reduced.x;
				m_impulse.y += reduced.y;
				m_impulse.z = 0.0;
			}
			else
			{
			   //m_impulse += impulse;
			   m_impulse.x += impulseVec3.x;
			   m_impulse.y += impulseVec3.y;
			   m_impulse.z += impulseVec3.z;
			}
		}
		else if (m_limitState == e_atUpperLimit)
		{
			newImpulse = m_impulse.z + impulseVec3.z;
			if (newImpulse > 0.0)
			{
            //b2Vec2 rhs = -Cdot1 + m_impulse.z * b2Vec2(m_mass.col3.x, m_mass.col3.y);
            //b2Vec2 reduced = m_mass.Solve22(rhs);
				tempV.x = -Cdot1.x + m_impulse.z * m_mass.col3.x;
				tempV.y = -Cdot1.y + m_impulse.z * m_mass.col3.y;
				reduced = m_mass.Solve22 (tempV);
				
				impulseVec3.x = reduced.x;
				impulseVec3.y = reduced.y;
				impulseVec3.z = -m_impulse.z;
				m_impulse.x += reduced.x;
				m_impulse.y += reduced.y;
				m_impulse.z = 0.0;
			}
         else
         {
            //m_impulse += impulse;
            m_impulse.x += impulseVec3.x;
            m_impulse.y += impulseVec3.y;
            m_impulse.z += impulseVec3.z;
         }
		}

		//b2Vec2 P(impulse.x, impulse.y);
		P.Set (impulseVec3.x, impulseVec3.y);

		//v1 -= m1 * P;
		v1.x -= m1 * P.x;
		v1.y -= m1 * P.y;
		w1 -= i1 * (b2Math.b2Cross2 (r1, P) + impulseVec3.z);

		//v2 += m2 * P;
		v2.x += m2 * P.x;
		v2.y += m2 * P.y;
		w2 += i2 * (b2Math.b2Cross2 (r2, P) + impulseVec3.z);
	}
	else
	{
		//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
		//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

		// Solve point-to-point constraint
		//b2Vec2 Cdot = v2 + b2Math.b2Cross2(w2, r2) - v1 - b2Math.b2Cross2(w1, r1);
		b2Math.b2Cross_ScalarAndVector2_Output (w2, r2, CdotVec2);
		b2Math.b2Cross_ScalarAndVector2_Output (w1, r1, tempV);
		CdotVec2.x += v2.x - v1.x - tempV.x;
		CdotVec2.y += v2.y - v1.y - tempV.y;
		//b2Vec2 impulse = m_mass.Solve22(-Cdot);
		tempV.x = - CdotVec2.x;
		tempV.y = - CdotVec2.y;
		impulseVec2 = m_mass.Solve22 (tempV);

		m_impulse.x += impulseVec2.x;
		m_impulse.y += impulseVec2.y;

		//v1 -= m1 * impulse;
		v1.x -= m1 * impulseVec2.x;
		v1.y -= m1 * impulseVec2.y;
		w1 -= i1 * b2Math.b2Cross2 (r1, impulseVec2);

		//v2 += m2 * impulse;
		v2.x += m2 * impulseVec2.x;
		v2.y += m2 * impulseVec2.y;
		w2 += i2 * b2Math.b2Cross2 (r2, impulseVec2);
	}

	b1.m_linearVelocity.CopyFrom (v1);
	b1.m_angularVelocity = w1;
	b2.m_linearVelocity.CopyFrom (v2);
	b2.m_angularVelocity = w2;
}

override public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	//var r1:b2Vec2 = new b2Vec2 ();
	//var r2:b2Vec2 = new b2Vec2 ();
	//var CVec2:b2Vec2 = new b2Vec2 ();
	//var impulse:b2Vec2 = new b2Vec2 ();
	//var u:b2Vec2 = new b2Vec2 ();
	//var tempV:b2Vec2 = new b2Vec2 ();
	
	// TODO_ERIN block solve with limit.

	//B2_NOT_USED(baumgarte);

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;
	
	var angularError:Number = 0.0;
	var positionError:Number = 0.0;

	// Solve angular limit constraint.
	if (m_enableLimit && m_limitState != e_inactiveLimit)
	{
		var angle:Number = b2.m_sweep.a - b1.m_sweep.a - m_referenceAngle;
	
		var limitImpulse:Number = 0.0;
		
		var C:Number;

		if (m_limitState == b2Joint.e_equalLimits)
		{
			// Prevent large angular corrections
			C = b2Math.b2Clamp_Number (angle - m_lowerAngle, - b2Settings.b2_maxAngularCorrection, b2Settings.b2_maxAngularCorrection);
			limitImpulse = -m_motorMass * C;
			angularError = Math.abs (C);
		}
		else if (m_limitState == e_atLowerLimit)
		{
			C = angle - m_lowerAngle;
			angularError = -C;

			// Prevent large angular corrections and allow some slop.
			C = b2Math.b2Clamp_Number (C + b2Settings.b2_angularSlop, - b2Settings.b2_maxAngularCorrection, 0.0);
			limitImpulse = -m_motorMass * C;
		}
		else if (m_limitState == e_atUpperLimit)
		{
			C = angle - m_upperAngle;
			angularError = C;

			// Prevent large angular corrections and allow some slop.
			C = b2Math.b2Clamp_Number (C - b2Settings.b2_angularSlop, 0.0, b2Settings.b2_maxAngularCorrection);
			limitImpulse = -m_motorMass * C;
		}

		b1.m_sweep.a -= b1.m_invI * limitImpulse;
		b2.m_sweep.a += b2.m_invI * limitImpulse;

		b1.SynchronizeTransform();
		b2.SynchronizeTransform();
	}

	// Solve point-to-point constraint.
	//{
		//b2Vec2 r1 = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r1);
		//b2Vec2 r2 = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r2);

		//b2Vec2 C = b2->m_sweep.c + r2 - b1->m_sweep.c - r1;
		CVec2.x = b2.m_sweep.c.x + r2.x - b1.m_sweep.c.x - r1.x;
		CVec2.y = b2.m_sweep.c.y + r2.y - b1.m_sweep.c.y - r1.y;
		positionError = CVec2.Length();

		var invMass1:Number = b1.m_invMass, invMass2:Number = b2.m_invMass;
		var invI1:Number = b1.m_invI, invI2:Number = b2.m_invI;

		// Handle large detachment.
		const k_allowedStretch:Number = 10.0 * b2Settings.b2_linearSlop;
		if (CVec2.LengthSquared() > k_allowedStretch * k_allowedStretch)
		{
			// Use a particle solution (no rotation).
			u.CopyFrom (CVec2); u.Normalize();
			var m:Number = invMass1 + invMass2;
			if (m > 0.0)
			{
				m = 1.0 / m;
			}
			//b2Vec2 impulse = m * (-C);
			impulse.x = m * (-CVec2.x);
			impulse.y = m * (-CVec2.y);
			const k_beta:Number = 0.5;
			//b1->m_sweep.c -= k_beta * invMass1 * impulse;
			b1.m_sweep.c.x -= k_beta * invMass1 * impulse.x;
			b1.m_sweep.c.y -= k_beta * invMass1 * impulse.y;
			//b2->m_sweep.c += k_beta * invMass2 * impulse;
			b2.m_sweep.c.x += k_beta * invMass2 * impulse.x;
			b2.m_sweep.c.y += k_beta * invMass2 * impulse.y;

			//C = b2->m_sweep.c + r2 - b1->m_sweep.c - r1;
			CVec2.x = b2.m_sweep.c.x + r2.x - b1.m_sweep.c.x - r1.x;
			CVec2.y = b2.m_sweep.c.y + r2.y - b1.m_sweep.c.y - r1.y;
		}
		
		//var K1:b2Mat22 = new b2Mat22 ();
		//var K2:b2Mat22 = new b2Mat22 ();
		//var K3:b2Mat22 = new b2Mat22 ();
		//var K:b2Mat22 = new b2Mat22 ();

		//b2Mat22 K1;
		K1.col1.x = invMass1 + invMass2;	K1.col2.x = 0.0;
		K1.col1.y = 0.0;					K1.col2.y = invMass1 + invMass2;

		//b2Mat22 K2;
		K2.col1.x =  invI1 * r1.y * r1.y;	K2.col2.x = -invI1 * r1.x * r1.y;
		K2.col1.y = -invI1 * r1.x * r1.y;	K2.col2.y =  invI1 * r1.x * r1.x;

		//b2Mat22 K3;
		K3.col1.x =  invI2 * r2.y * r2.y;	K3.col2.x = -invI2 * r2.x * r2.y;
		K3.col1.y = -invI2 * r2.x * r2.y;	K3.col2.y =  invI2 * r2.x * r2.x;

		//b2Mat22 K = K1 + K2 + K3;
		K.col1.x = K1.col1.x + K2.col1.x + K3.col1.x;	K.col2.x = K1.col2.x + K2.col2.x + K3.col2.x;
		K.col1.y = K1.col1.y + K2.col1.y + K3.col1.y;	K.col2.y = K1.col2.y + K2.col2.y + K3.col2.y;
		//b2Vec2 impulse = K.Solve(-C);
		tempV.x = - CVec2.x; tempV.y = - CVec2.y;
		var impulseVec2:b2Vec2 = K.Solve (tempV);

		//b1->m_sweep.c -= b1->m_invMass * impulse;
		b1.m_sweep.c.x -= b1.m_invMass * impulseVec2.x;
		b1.m_sweep.c.y -= b1.m_invMass * impulseVec2.y;
		b1.m_sweep.a -= b1.m_invI * b2Math.b2Cross2 (r1, impulseVec2);

		//b2->m_sweep.c += b2->m_invMass * impulse;
		b2.m_sweep.c.x += b2.m_invMass * impulseVec2.x;
		b2.m_sweep.c.y += b2.m_invMass * impulseVec2.y;
		b2.m_sweep.a += b2.m_invI * b2Math.b2Cross2 (r2, impulseVec2);

		b1.SynchronizeTransform();
		b2.SynchronizeTransform();
	//}
	
	return positionError <= b2Settings.b2_linearSlop && angularError <= b2Settings.b2_angularSlop;
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
	//b2Vec2 P(m_impulse.x, m_impulse.y);
	//return inv_dt * P;
	return b2Vec2.b2Vec2_From2Numbers (inv_dt * m_impulse.x, inv_dt * m_impulse.y);
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	return inv_dt * m_impulse.z;
}

public function GetJointAngle():Number
{
	//b2Body* b1 = m_bodyA;
	//b2Body* b2 = m_bodyB;
	//return b2->m_sweep.a - b1->m_sweep.a - m_referenceAngle;
	return m_bodyB.m_sweep.a - m_bodyA.m_sweep.a - m_referenceAngle;
}

public function GetJointSpeed():Number
{
	//b2Body* b1 = m_bodyA;
	//b2Body* b2 = m_bodyB;
	//return b2->m_angularVelocity - b1->m_angularVelocity;
	return m_bodyB.m_angularVelocity - m_bodyA.m_angularVelocity;
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

public function GetMotorTorque(inv_dt:Number):Number
{
	return inv_dt * m_motorImpulse;
}

public function SetMotorSpeed(speed:Number):void
{
	m_bodyA.SetAwake(true);
	m_bodyB.SetAwake(true);
	m_motorSpeed = speed;
}

public function SetMaxMotorTorque(torque:Number):void
{
	m_bodyA.SetAwake(true);
	m_bodyB.SetAwake(true);
	m_maxMotorTorque = torque;
}

public function IsLimitEnabled():Boolean
{
	return m_enableLimit;
}

public function EnableLimit(flag:Boolean):void
{
   if (flag != m_enableLimit)
   {
   	m_bodyA.SetAwake(true);
   	m_bodyB.SetAwake(true);
   	m_enableLimit = flag;
   	m_impulse.z = 0.0;
   }
}

public function GetLowerLimit():Number
{
	return m_lowerAngle;
}

public function GetUpperLimit():Number
{
	return m_upperAngle;
}

public function SetLimits(lower:Number, upper:Number):void
{
	//b2Assert(lower <= upper);
	if (lower != m_lowerAngle || upper != m_upperAngle)
   {
   	m_bodyA.SetAwake(true);
   	m_bodyB.SetAwake(true);
   	m_impulse.z = 0.0;
   	m_lowerAngle = lower;
   	m_upperAngle = upper;
	}
}
