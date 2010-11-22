/*
* Copyright (c) 2006-2010 Erin Catto http://www.gphysics.com
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

//#ifndef B2_ROPE_JOINT_H
//#define B2_ROPE_JOINT_H

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

	/// Rope joint definition. This requires two body anchor points and
	/// a maximum lengths.
	/// Note: by default the connected objects will not collide.
	/// see collideConnected in b2JointDef.
	//struct b2RopeJointDef : public b2JointDef
	//{
		//@see b2RopeJointDef.as
	//};

	/// A rope joint enforces a maximum distance between two points
	/// on two bodies. It has no other effect.
	/// Warning: if you attempt to change the maximum length during
	/// the simulation you will get some non-physical behavior.
	/// A model that would allow you to dynamically modify the length
	/// would have some sponginess, so I chose not to implement it
	/// that way. See b2DistanceJoint if you want to dynamically
	/// control length.
	public class b2RopeJoint extends b2Joint
	{
		include "b2RopeJoint.cpp";

	//public:
		//b2Vec2 GetAnchorA() const;
		//b2Vec2 GetAnchorB() const;

		//b2Vec2 GetReactionForce(float32 inv_dt) const;
		//float32 GetReactionTorque(float32 inv_dt) const;

		/// Get the maximum length of the rope.
		//float32 GetMaxLength() const;

		//b2LimitState GetLimitState() const;

	//protected:

		//friend class b2Joint;
		//b2RopeJoint(const b2RopeJointDef* data);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);
		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_localAnchorA:b2Vec2 = new b2Vec2 ();
		public var m_localAnchorB:b2Vec2 = new b2Vec2 ();

		public var m_maxLength:int;
		public var m_length:int;

		// Jacobian info
		public var m_u:b2Vec2 = new b2Vec2 (), m_rA:b2Vec2 = new b2Vec2 (), m_rB:b2Vec2 = new b2Vec2 ();

		// Effective mass
		public var m_mass:Number;

		// Impulses for accumulation/warm starting.
		public var m_impulse:Number;

		//b2LimitState m_state;
		public var m_state:int;
	}
}
//#endif
