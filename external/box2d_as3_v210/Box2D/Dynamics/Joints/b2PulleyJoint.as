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

//#ifndef B2_PULLEY_JOINT_H
//#define B2_PULLEY_JOINT_H

package Box2D.Dynamics.Joints
{

	//#include <Box2D/Dynamics/Joints/b2Joint.h>
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Dynamics.b2TimeStep;;
	import Box2D.Dynamics.b2Body;

	// moved into b2PulleyJoint class
	//const float32 b2_minPulleyLength = 2.0f;

	/// Pulley joint definition. This requires two ground anchors,
	/// two dynamic body anchor points, max lengths for each side,
	/// and a pulley ratio.
	//struct b2PulleyJointDef : public b2JointDef
	//{
		//@see b2PulleyJointDef.as
	//};

	/// The pulley joint is connected to two bodies and two fixed ground points.
	/// The pulley supports a ratio such that:
	/// length1 + ratio * length2 <= constant
	/// Yes, the force transmitted is scaled by the ratio.
	/// The pulley also enforces a maximum length limit on both sides. This is
	/// useful to prevent one side of the pulley hitting the top.
	public class b2PulleyJoint extends b2Joint
	{
		include "b2PulleyJoint.cpp";
		
		public static const b2_minPulleyLength:Number = 2.0;
		
	//public:
		//b2Vec2 GetAnchorA() const;
		//b2Vec2 GetAnchorB() const;

		//b2Vec2 GetReactionForce(float32 inv_dt) const;
		//float32 GetReactionTorque(float32 inv_dt) const;

		/// Get the first ground anchor.
		//b2Vec2 GetGroundAnchorA() const;

		/// Get the second ground anchor.
		//b2Vec2 GetGroundAnchorB() const;

		///// Get the current length of the segment attached to body1.
		//float32 GetLength1() const;

		/// Get the current length of the segment attached to body2.
		//float32 GetLength2() const;

		/// Get the pulley ratio.
		//float32 GetRatio() const;

	//protected:

		//b2PulleyJoint(const b2PulleyJointDef* data);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);
		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_groundAnchor1:b2Vec2 = new b2Vec2 ();
		public var m_groundAnchor2:b2Vec2 = new b2Vec2 ();
		public var m_localAnchor1:b2Vec2 = new b2Vec2 ();
		public var m_localAnchor2:b2Vec2 = new b2Vec2 ();

		public var m_u1:b2Vec2 = new b2Vec2 ();
		public var m_u2:b2Vec2 = new b2Vec2 ();
		
		public var m_constant:Number;
		public var m_ratio:Number;
		
		public var m_maxLength1:Number;
		public var m_maxLength2:Number;

		// Effective masses
		public var m_pulleyMass:Number;
		public var m_limitMass1:Number;
		public var m_limitMass2:Number;

		// Impulses for accumulation/warm starting.
		public var m_impulse:Number;
		public var m_limitImpulse1:Number;
		public var m_limitImpulse2:Number;

		//b2LimitState m_state;
		//b2LimitState m_limitState1;
		//b2LimitState m_limitState2;
		public var m_state:int;
		public var m_limitState1:int;
		public var m_limitState2:int;
		
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

	} // class
} // package
//#endif
