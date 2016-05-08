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

//#ifndef B2_GEAR_JOINT_H
//#define B2_GEAR_JOINT_H

package Box2D.Dynamics.Joints
{
	//#include <Box2D/Dynamics/Joints/b2Joint.h>
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2Body;

	//class b2RevoluteJoint;
	//class b2PrismaticJoint;

	/// Gear joint definition. This definition requires two existing
	/// revolute or prismatic joints (any combination will work).
	/// The provided joints must attach a dynamic body to a static body.
	//public class b2GearJointDef extends b2JointDef
	//{
		//@see b2GearJointDef.as
	//};

	/// A gear joint is used to connect two joints together. Either joint
	/// can be a revolute or prismatic joint. You specify a gear ratio
	/// to bind the motions together:
	/// coordinate1 + ratio * coordinate2 = constant
	/// The ratio can be negative or positive. If one joint is a revolute joint
	/// and the other joint is a prismatic joint, then the ratio will have units
	/// of length or units of 1/length.
	/// @warning The revolute and prismatic joints must be attached to
	/// fixed bodies (which must be body1 on those joints).
	public class b2GearJoint extends b2Joint
	{
		include "b2GearJoint.cpp";

	//public:
		//b2Vec2 GetAnchorA() const;
		//b2Vec2 GetAnchorB() const;

		//b2Vec2 GetReactionForce(float32 inv_dt) const;
		//float32 GetReactionTorque(float32 inv_dt) const;

		/// Get the gear ratio.
		//float32 GetRatio() const;

		/// Set/Get the gear ratio.
		//void SetRatio(float32 ratio);
		//float32 GetRatio() const;

	//protected:

		//b2GearJoint(const b2GearJointDef* data);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);
		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_ground1:b2Body;
		public var m_ground2:b2Body;

		// One of these is NULL.
		public var m_revolute1:b2RevoluteJoint;
		public var m_prismatic1:b2PrismaticJoint;

		// One of these is NULL.
		public var m_revolute2:b2RevoluteJoint;
		public var m_prismatic2:b2PrismaticJoint;

		public var m_groundAnchor1:b2Vec2 = new b2Vec2 ();
		public var m_groundAnchor2:b2Vec2 = new b2Vec2 ();

		public var m_localAnchor1:b2Vec2 = new b2Vec2 ();
		public var m_localAnchor2:b2Vec2 = new b2Vec2 ();

		public var m_J:b2Jacobian = new b2Jacobian ();

		public var m_constant:Number;
		public var m_ratio:Number;

		// Effective mass
		public var m_mass:Number;

		// Impulse for accumulation/warm starting.
		public var m_impulse:Number;
	} //class
} // package
//#endif
