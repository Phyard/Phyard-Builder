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

//#ifndef B2_PRISMATIC_JOINT_H
//#define B2_PRISMATIC_JOINT_H

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

	/// Prismatic joint definition. This requires defining a line of
	/// motion using an axis and an anchor point. The definition uses local
	/// anchor points and a local axis so that the initial configuration
	/// can violate the constraint slightly. The joint translation is zero
	/// when the local anchor points coincide in world space. Using local
	/// anchors and a local axis helps when saving and loading a game.
	//struct b2PrismaticJointDef : public b2JointDef
	//{
		//@see b2PrismaticJointDef.as
	//};

	/// A prismatic joint. This joint provides one degree of freedom: translation
	/// along an axis fixed in body1. Relative rotation is prevented. You can
	/// use a joint limit to restrict the range of motion and a joint motor to
	/// drive the motion or to model joint friction.
	public class b2PrismaticJoint extends b2Joint
	{
		include "b2PrismaticJoint.cpp";
		
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

		/// Set the maximum motor force, usually in N.
		//void SetMaxMotorForce(float32 force);

		/// Get the current motor force, usually in N.
		//float32 GetMotorForce() const;

	//protected:

		//b2PrismaticJoint(const b2PrismaticJointDef* def);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);
		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_localAnchor1:b2Vec2 = new b2Vec2 ();
		public var m_localAnchor2:b2Vec2 = new b2Vec2 ();
		public var m_localXAxis1:b2Vec2 = new b2Vec2 ();
		public var m_localYAxis1:b2Vec2 = new b2Vec2 ();
		public var m_refAngle:Number;

		public var m_axis:b2Vec2 = new b2Vec2 (), m_perp:b2Vec2 = new b2Vec2 ();
		public var m_s1:Number, m_s2:Number;
		public var m_a1:Number, m_a2:Number;

		public var m_K:b2Mat33 = new b2Mat33 ();
		public var m_impulse:b2Vec3 = new b2Vec3 ();

		public var m_motorMass:Number;			// effective mass for motor/limit translational constraint.
		public var m_motorImpulse:Number;

		public var m_lowerTranslation:Number;
		public var m_upperTranslation:Number;
		public var m_maxMotorForce:Number;
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
		
//***********************************************************************
// hackings
//***********************************************************************
		
		// call by b2Body
		// this function should  NOT change the world position
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

		override protected function NotifyBodyChanged (oldBody:b2Body, isBodyA:Boolean):void
		{
			var worldAnchor:b2Vec2;
			
			if (isBodyA)
			{
				worldAnchor = oldBody.GetWorldPoint(m_localAnchor1);
				m_localAnchor1.CopyFrom (m_bodyA.GetLocalPoint (worldAnchor));
				m_refAngle -= m_bodyA.GetAngle () - oldBody.GetAngle ();
				
				var worldAxis:b2Vec2 = oldBody.GetWorldVector (m_localXAxis1);
				m_localXAxis1.CopyFrom (m_bodyA.GetLocalVector (worldAxis));
				b2Math.b2Cross_ScalarAndVector2_Output (1.0, m_localXAxis1, m_localYAxis1);
			}
			else
			{
				worldAnchor = oldBody.GetWorldPoint(m_localAnchor2);
				m_localAnchor2.CopyFrom (m_bodyB.GetLocalPoint (worldAnchor));
				m_refAngle += m_bodyB.GetAngle () - oldBody.GetAngle ();
			}
		}

	} // class
} // pacakge
//#endif
