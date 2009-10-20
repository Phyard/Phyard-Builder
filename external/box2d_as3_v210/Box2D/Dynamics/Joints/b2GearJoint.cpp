/*
* Copyright (c) 2007 Erin Catto http://www.gphysics.com
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

//#include <Box2D/Dynamics/Joints/b2GearJoint.h>
//#include <Box2D/Dynamics/Joints/b2RevoluteJoint.h>
//#include <Box2D/Dynamics/Joints/b2PrismaticJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2TimeStep.h>

// Gear Joint:
// C0 = (coordinate1 + ratio * coordinate2)_initial
// C = C0 - (cordinate1 + ratio * coordinate2) = 0
// Cdot = -(Cdot1 + ratio * Cdot2)
// J = -[J1 ratio * J2]
// K = J * invM * JT
//   = J1 * invM1 * J1T + ratio * ratio * J2 * invM2 * J2T
//
// Revolute:
// coordinate = rotation
// Cdot = angularVelocity
// J = [0 0 1]
// K = J * invM * JT = invI
//
// Prismatic:
// coordinate = dot(p - pg, ug)
// Cdot = dot(v + cross(w, r), ug)
// J = [ug cross(r, ug)]
// K = J * invM * JT = invMass + invI * cross(r, ug)^2

public function b2GearJoint(def:b2GearJointDef)
//: b2Joint(def)
{
	super (def);
	
	//b2JointType type1 = def->joint1->GetType();
	//b2JointType type2 = def->joint2->GetType();
	var type1:int = def.joint1.GetType();
	var type2:int = def.joint2.GetType();

	//b2Assert(type1 == e_revoluteJoint || type1 == e_prismaticJoint);
	//b2Assert(type2 == e_revoluteJoint || type2 == e_prismaticJoint);
	//b2Assert(def->joint1->GetBody1()->IsStatic());
	//b2Assert(def->joint2->GetBody1()->IsStatic());

	m_revolute1 = null;
	m_prismatic1 = null;
	m_revolute2 = null;
	m_prismatic2 = null;

	var coordinate1:Number, coordinate2:Number;

	m_ground1 = def.joint1.GetBody1();
	m_bodyA = def.joint1.GetBody2();
	if (type1 == e_revoluteJoint)
	{
		m_revolute1 = def.joint1 as b2RevoluteJoint;
		m_groundAnchor1.CopyFrom (m_revolute1.m_localAnchor1);
		m_localAnchor1.CopyFrom (m_revolute1.m_localAnchor2);
		coordinate1 = m_revolute1.GetJointAngle();
	}
	else
	{
		m_prismatic1 = def.joint1 as b2PrismaticJoint;
		m_groundAnchor1.CopyFrom (m_prismatic1.m_localAnchor1);
		m_localAnchor1.CopyFrom (m_prismatic1.m_localAnchor2);
		coordinate1 = m_prismatic1.GetJointTranslation();
	}

	m_ground2 = def.joint2.GetBody1();
	m_bodyB = def.joint2.GetBody2();
	if (type2 == e_revoluteJoint)
	{
		m_revolute2 = def.joint2 as b2RevoluteJoint;
		m_groundAnchor2.CopyFrom (m_revolute2.m_localAnchor1);
		m_localAnchor2.CopyFrom (m_revolute2.m_localAnchor2);
		coordinate2 = m_revolute2.GetJointAngle();
	}
	else
	{
		m_prismatic2 = def.joint2 as b2PrismaticJoint;
		m_groundAnchor2.CopyFrom (m_prismatic2.m_localAnchor1);
		m_localAnchor2.CopyFrom (m_prismatic2.m_localAnchor2);
		coordinate2 = m_prismatic2.GetJointTranslation();
	}

	m_ratio = def.ratio;

	m_constant = coordinate1 + m_ratio * coordinate2;

	m_impulse = 0.0;
}

override public function InitVelocityConstraints(step:b2TimeStep):void
{
	var ug:b2Vec2 = new b2Vec2 ();
	var r:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var tempF:Number;
	
	var g1:b2Body = m_ground1;
	var g2:b2Body = m_ground2;
	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	var K:Number = 0.0;
	m_J.SetZero();

	var crug:Number;

	if (m_revolute1)
	{
		m_J.angular1 = -1.0;
		K += b1.m_invI;
	}
	else
	{
		//b2Vec2 ug = b2Mul(g1->GetTransform().R, m_prismatic1->m_localXAxis1);
		b2Math.b2Mul_Matrix22AndVector2_Output (g1.GetTransform().R, m_prismatic1.m_localXAxis1, ug);
		//b2Vec2 r = b2Mul(b1->GetTransform().R, m_localAnchor1 - b1->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor1, b1.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b1.GetTransform().R, tempV, r);
		crug = b2Math.b2Cross2 (r, ug);
		//m_J.linear1 = -ug;
		m_J.linear1.x = -ug.x;
		m_J.linear1.y = -ug.y;
		m_J.angular1 = -crug;
		K += b1.m_invMass + b1.m_invI * crug * crug;
	}

	if (m_revolute2)
	{
		m_J.angular2 = -m_ratio;
		K += m_ratio * m_ratio * b2.m_invI;
	}
	else
	{
		//b2Vec2 ug = b2Mul(g2->GetTransform().R, m_prismatic2->m_localXAxis1);
		b2Math.b2Mul_Matrix22AndVector2_Output (g2.GetTransform().R, m_prismatic2.m_localXAxis1, ug);
		//b2Vec2 r = b2Mul(b2->GetTransform().R, m_localAnchor2 - b2->GetLocalCenter());
		b2Math.b2Subtract_Vector2_Output (m_localAnchor2, b2.GetLocalCenter(), tempV);
		b2Math.b2Mul_Matrix22AndVector2_Output (b2.GetTransform().R, tempV, r);
		crug = b2Math.b2Cross2 (r, ug);
		//m_J.linear2 = -m_ratio * ug;
		m_J.linear2.x = -m_ratio * ug.x;
		m_J.linear2.y = -m_ratio * ug.y;
		m_J.angular2 = -m_ratio * crug;
		K += m_ratio * m_ratio * (b2.m_invMass + b2.m_invI * crug * crug);
	}

	// Compute effective mass.
	m_mass = K > 0.0 ? 1.0 / K : 0.0;

	if (step.warmStarting)
	{
		// Warm starting.
		//b1->m_linearVelocity += b1->m_invMass * m_impulse * m_J.linear1;
		tempF = b1.m_invMass * m_impulse;
		b1.m_linearVelocity.x += tempF * m_J.linear1.x;
		b1.m_linearVelocity.y += tempF * m_J.linear1.y;
		b1.m_angularVelocity += b1.m_invI * m_impulse * m_J.angular1;
		//b2->m_linearVelocity += b2->m_invMass * m_impulse * m_J.linear2;
		tempF = b2.m_invMass * m_impulse;
		b2.m_linearVelocity.x += tempF * m_J.linear2.x;
		b2.m_linearVelocity.y += tempF * m_J.linear2.y;
		b2.m_angularVelocity += b2.m_invI * m_impulse * m_J.angular2;
	}
	else
	{
		m_impulse = 0.0;
	}
}

override public function SolveVelocityConstraints(step:b2TimeStep):void
{
	var tempF:Number;
	
	//B2_NOT_USED(step);

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	var Cdot:Number = m_J.Compute(	b1.m_linearVelocity, b1.m_angularVelocity,
								b2.m_linearVelocity, b2.m_angularVelocity);

	var impulse:Number = m_mass * (-Cdot);
	m_impulse += impulse;

	//b1->m_linearVelocity += b1->m_invMass * impulse * m_J.linear1;
	tempF = b1.m_invMass * impulse;
	b1.m_linearVelocity.x += tempF * m_J.linear1.x;
	b1.m_linearVelocity.y += tempF * m_J.linear1.y;
	b1.m_angularVelocity += b1.m_invI * impulse * m_J.angular1;
	//b2->m_linearVelocity += b2->m_invMass * impulse * m_J.linear2;
	tempF = b2.m_invMass * impulse;
	b2.m_linearVelocity.x += tempF * m_J.linear2.x;
	b2.m_linearVelocity.y += tempF * m_J.linear2.y;
	b2.m_angularVelocity += b2.m_invI * impulse * m_J.angular2;
}

override public function SolvePositionConstraints(baumgarte:Number):Boolean
{
	var tempF:Number;
	
	//B2_NOT_USED(baumgarte);
	
	var linearError:Number = 0.0;

	var b1:b2Body = m_bodyA;
	var b2:b2Body = m_bodyB;

	var coordinate1:Number, coordinate2:Number;
	if (m_revolute1)
	{
		coordinate1 = m_revolute1.GetJointAngle();
	}
	else
	{
		coordinate1 = m_prismatic1.GetJointTranslation();
	}

	if (m_revolute2)
	{
		coordinate2 = m_revolute2.GetJointAngle();
	}
	else
	{
		coordinate2 = m_prismatic2.GetJointTranslation();
	}

	var C:Number = m_constant - (coordinate1 + m_ratio * coordinate2);

	var impulse:Number = m_mass * (-C);

	//b1->m_sweep.c += b1->m_invMass * impulse * m_J.linear1;
	tempF = b1.m_invMass * impulse;
	b1.m_sweep.c.x += tempF * m_J.linear1.x;
	b1.m_sweep.c.y += tempF * m_J.linear1.y;
	b1.m_sweep.a += b1.m_invI * impulse * m_J.angular1;
	//b2->m_sweep.c += b2->m_invMass * impulse * m_J.linear2;
	tempF = b2.m_invMass * impulse;
	b2.m_sweep.c.x += b2.m_invMass * impulse * m_J.linear2.x;
	b2.m_sweep.c.y += b2.m_invMass * impulse * m_J.linear2.y;
	b2.m_sweep.a += b2.m_invI * impulse * m_J.angular2;

	b1.SynchronizeTransform();
	b2.SynchronizeTransform();

	// TODO_ERIN not implemented
	return linearError < b2Settings.b2_linearSlop;
}

override public function GetAnchor1():b2Vec2
{
	return m_bodyA.GetWorldPoint(m_localAnchor1);
}

override public function GetAnchor2():b2Vec2
{
	return m_bodyB.GetWorldPoint(m_localAnchor2);
}

override public function GetReactionForce(inv_dt:Number):b2Vec2
{
	// TODO_ERIN not tested
	//b2Vec2 P = m_impulse * m_J.linear2;
	//return inv_dt * P;
	
	var tempF:Number = inv_dt * m_impulse;
	return b2Vec2.b2Vec2_From2Numbers (tempF * m_J.linear2.x, tempF * m_J.linear2.y);
}

override public function GetReactionTorque(inv_dt:Number):Number
{
	var r:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	var P:b2Vec2 = new b2Vec2 ();
	
	// TODO_ERIN not tested
	//b2Vec2 r = b2Mul(m_bodyB->GetTransform().R, m_localAnchor2 - m_bodyB->GetLocalCenter());
	b2Math.b2Subtract_Vector2_Output (m_localAnchor2, m_bodyB.GetLocalCenter(), tempV);
	b2Math.b2Mul_Matrix22AndVector2_Output (m_bodyB.GetTransform().R, tempV, r);
	//b2Vec2 P = m_impulse * m_J.linear2;
	P.x = m_impulse * m_J.linear2.x;
	P.y = m_impulse * m_J.linear2.y;
	var L:Number = m_impulse * m_J.angular2 - b2Math.b2Cross2 (r, P);
	return inv_dt * L;
}

public function GetRatio():Number
{
	return m_ratio;
}



