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

//#ifndef B2_FRICTION_JOINT_H
//#define B2_FRICTION_JOINT_H

package Box2D.Dynamics.Joints
{

	//#include <Box2D/Dynamics/Joints/b2Joint.h>

	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Vec3;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Mat22;
	import Box2D.Common.b2Mat33;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2Body;

	/// Friction joint definition.
	//struct b2FrictionJointDef : public b2JointDef
	//{
		//@see b2FrictionJointDef.as
	//};

	/// Friction joint. This is used for top-down friction.
	/// It provides 2D translational friction and angular friction.
	public class b2FrictionJoint extends b2Joint
	{
		include "b2FrictionJoint.cpp";

	//public:
		//b2Vec2 GetAnchorA() const;
		//b2Vec2 GetAnchorB() const;

		//b2Vec2 GetReactionForce(float32 inv_dt) const;
		//float32 GetReactionTorque(float32 inv_dt) const;

		/// Set the maximum friction force in N.
		//void SetMaxForce(float32 force);

		/// Get the maximum friction force in N.
		//float32 GetMaxForce() const;

		/// Set the maximum friction torque in N*m.
		//void SetMaxTorque(float32 torque);

		/// Get the maximum friction torque in N*m.
		//float32 GetMaxTorque() const;

	//protected:

		//friend class b2Joint;

		//b2FrictionJoint(const b2FrictionJointDef* def);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);
		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_localAnchorA:b2Vec2 = new b2Vec2 ();
		public var m_localAnchorB:b2Vec2 = new b2Vec2 ();

		public var m_linearMass:b2Mat22 = new b2Mat22 ();
		public var m_angularMass:Number;

		public var m_linearImpulse:b2Vec2 = new b2Vec2 ();
		public var m_angularImpulse:Number;

		public var m_maxForce:Number;
		public var m_maxTorque:Number;

//***********************************************************************
// hackings
//***********************************************************************

		// call by b2Body
		override public function OnBodyLocalCenterChanged (dx:Number, dy:Number, jointEdge:b2JointEdge):void
		{
			if (jointEdge == m_edgeA)
			{
				m_localAnchorA.x += dx;
				m_localAnchorA.y += dy;
			}
			else if (jointEdge == m_edgeB)
			{
				m_localAnchorB.x += dx;
				m_localAnchorB.y += dy;
			}
		}

	} // class
} // package

//#endif
