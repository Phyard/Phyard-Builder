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

//#ifndef B2_MOUSE_JOINT_H
//#define B2_MOUSE_JOINT_H

package Box2D.Dynamics.Joints
{

	//#include <Box2D/Dynamics/Joints/b2Joint.h>
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Mat22;
	import Box2D.Dynamics.b2Body;

	/// Mouse joint definition. This requires a world target point,
	/// tuning parameters, and the time step.
	//struct b2MouseJointDef : public b2JointDef
	//{
		//@see b2MouseJointDef.as
	//};

	/// A mouse joint is used to make a point on a body track a
	/// specified world point. This a soft constraint with a maximum
	/// force. This allows the constraint to stretch and without
	/// applying huge forces.
	/// NOTE: this joint is not documented in the manual because it was
	/// developed to be used in the testbed. If you want to learn how to
	/// use the mouse joint, look at the testbed.
	public class b2MouseJoint extends b2Joint
	{
		include "b2MouseJoint.cpp";

	//public:

		/// Implements b2Joint.
		//b2Vec2 GetAnchorA() const;

		/// Implements b2Joint.
		//b2Vec2 GetAnchorB() const;

		/// Implements b2Joint.
		//b2Vec2 GetReactionForce(float32 inv_dt) const;

		/// Implements b2Joint.
		//float32 GetReactionTorque(float32 inv_dt) const;

		/// Use this to update the target point.
		//void SetTarget(const b2Vec2& target);
		//const b2Vec2& GetTarget() const;

		/// Set/get the maximum force in Newtons.
		//void SetMaxForce(float32 force);
		//float32 GetMaxForce() const;

		/// Set/get the frequency in Hertz.
		//void SetFrequency(float32 hz);
		//float32 GetFrequency() const;

		/// Set/get the damping ratio (dimensionless).
		//void SetDampingRatio(float32 ratio);
		//float32 GetDampingRatio() const;

	//protected:

		//b2MouseJoint(const b2MouseJointDef* def);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);
		//bool SolvePositionConstraints(float32 baumgarte) { B2_NOT_USED(baumgarte); return true; }

		public var m_localAnchor:b2Vec2 = new b2Vec2 ();
		public var m_target:b2Vec2 = new b2Vec2 ();
		public var m_impulse:b2Vec2 = new b2Vec2 ();

		public var m_mass:b2Mat22 = new b2Mat22 ();		// effective mass for point-to-point constraint.
		public var m_C:b2Vec2 = new b2Vec2 ();				// position error
		public var m_maxForce:Number;
		public var m_frequencyHz:Number;
		public var m_dampingRatio:Number;
		public var m_beta:Number;
		public var m_gamma:Number;

//***********************************************************************
// hackings
//***********************************************************************

		// call by b2Body
		override public function OnBodyLocalCenterChanged (dx:Number, dy:Number, jointEdge:b2JointEdge):void
		{
			if (jointEdge == m_edgeA)
			{
			}
			else if (jointEdge == m_edgeB)
			{
				m_localAnchor.x += dx;
				m_localAnchor.y += dy;
			}
		}

	} // class
} // package
//#endif
//#endif
