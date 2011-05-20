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

//#ifndef B2_LINE_JOINT_H
//#define B2_LINE_JOINT_H

package Box2D.Dynamics.Joints
{
	//#include <Box2D/Dynamics/Joints/b2Joint.h>
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Mat22;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2Body;

	/// Line joint definition. This requires defining a line of
	/// motion using an axis and an anchor point. The definition uses local
	/// anchor points and a local axis so that the initial configuration
	/// can violate the constraint slightly. The joint translation is zero
	/// when the local anchor points coincide in world space. Using local
	/// anchors and a local axis helps when saving and loading a game.
	//struct b2LineJointDef : public b2JointDef
	//{
		//@see b2LineJointDef.as
	//};

	/// A line joint. This joint provides two degrees of freedom: translation
	/// along an axis fixed in body1 and rotation in the plane. You can use a
	/// joint limit to restrict the range of motion and a joint motor to drive
	/// the motion or to model joint friction.
	public class b2LineJoint extends b2Joint
	{
		include "b2LineJoint.cpp";

	//public:
		//b2Vec2 GetAnchorA() const;
		//b2Vec2 GetAnchorB() const;

		//b2Vec2 GetReactionForce(float32 inv_dt) const;
		//float32 GetReactionTorque(float32 inv_dt) const;

		/// Get the current joint translation, usually in meters.
		//float32 GetJointTranslation() const;

		/// Get the current joint translation speed, usually in meters per second.
		//float32 GetJointSpeed() const;

		/// Is the joint limit enabled?
		//bool IsLimitEnabled() const;

		/// Enable/disable the joint limit.
		//void EnableLimit(bool flag);

		/// Get the lower joint limit, usually in meters.
		//float32 GetLowerLimit() const;

		/// Get the upper joint limit, usually in meters.
		//float32 GetUpperLimit() const;

		/// Set the joint limits, usually in meters.
		//void SetLimits(float32 lower, float32 upper);

		/// Is the joint motor enabled?
		//bool IsMotorEnabled() const;

		/// Enable/disable the joint motor.
		//void EnableMotor(bool flag);

		/// Set the motor speed, usually in meters per second.
		//void SetMotorSpeed(float32 speed);

		/// Get the motor speed, usually in meters per second.
		//float32 GetMotorSpeed() const;

		/// Set/Get the maximum motor force, usually in N.
		//void SetMaxMotorForce(float32 force);
		//float32 GetMaxMotorForce() const;

		/// Get the current motor force given the inverse time step, usually in N.
		//float32 GetMotorForce(float32 inv_dt) const;


	//protected:

		//b2LineJoint(const b2LineJointDef* def);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);
		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_localAnchor1:b2Vec2 = new b2Vec2 ();
		public var m_localAnchor2:b2Vec2 = new b2Vec2 ();
		public var m_localXAxis1:b2Vec2 = new b2Vec2 ();
		public var m_localYAxis1:b2Vec2 = new b2Vec2 ();

		public var m_axis:b2Vec2 = new b2Vec2 (), m_perp:b2Vec2 = new b2Vec2 ();
		public var m_s1:Number, m_s2:Number;
		public var m_a1:Number, m_a2:Number;

		public var m_K:b2Mat22 = new b2Mat22 ();
		public var m_impulse:b2Vec2 = new b2Vec2 ();

		public var m_motorMass:Number;			// effective mass for motor/limit translational constraint.
		public var m_motorImpulse:Number;

		public var m_lowerTranslation:Number;
		public var m_upperTranslation:Number;
		public var m_maxMotorForce:Number
		public var m_motorSpeed:Number;

		public var m_enableLimit:Boolean;
		public var m_enableMotor:Boolean;
		//b2LimitState m_limitState;
		public var m_limitState:int;
	//};

		public function GetMotorSpeed():Number
		{
			return m_motorSpeed;
		}

		public function GetMaxMotorForce():Number
		{
			return m_maxMotorForce;
		}

//***********************************************************************
// hackings
//***********************************************************************

		// call by b2Body
		override public function OnBodyLocalCenterChanged (dx:Number, dy:Number, jointEdge:b2JointEdge):void
		{
			if (jointEdge == m_edgeA)
			{
				m_localAnchor1.x += dx;
				m_localAnchor1.y += dy;
			}
			else if (jointEdge == m_edgeB)
			{
				m_localAnchor2.x += dx;
				m_localAnchor2.y += dy;
			}
		}

	} // class
} // pacakge
//#endif
