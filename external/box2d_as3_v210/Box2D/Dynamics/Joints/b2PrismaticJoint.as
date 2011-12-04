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

		/// Get the current motor force given the inverse time step, usually in N.
		//float32 GetMotorForce(float32 inv_dt) const;

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
		
      override public function NotifyAnchorPositionChanged (newWorldX:Number, newWorldY:Number, isAnchorA:Boolean):void
      {
         worldAnchor.x = newWorldX; worldAnchor.y = newWorldY;
         
         if (isAnchorA)
         {
            m_bodyA.GetLocalPoint_Output (worldAnchor, m_localAnchor1);
         }
         else
         {
            m_bodyB.GetLocalPoint_Output (worldAnchor, m_localAnchor2);
         }
      }

		private static var worldAnchor:b2Vec2 = new b2Vec2 ();;
		private static var worldAxis:b2Vec2 = new b2Vec2 ();
		override protected function NotifyBodyChanged (oldBody:b2Body, isBodyA:Boolean):void
		{
			if (isBodyA)
			{
				oldBody.GetWorldPoint_Output (m_localAnchor1, worldAnchor);
				m_bodyA.GetLocalPoint_Output (worldAnchor, m_localAnchor1);
				m_refAngle -= m_bodyA.GetAngle () - oldBody.GetAngle ();

				oldBody.GetWorldVector_Output (m_localXAxis1, worldAxis);
				m_bodyA.GetLocalVector_Output (worldAxis, m_localXAxis1);
				b2Math.b2Cross_ScalarAndVector2_Output (1.0, m_localXAxis1, m_localYAxis1);
			}
			else
			{
				oldBody.GetWorldPoint_Output (m_localAnchor2, worldAnchor);
				m_bodyB.GetLocalPoint_Output (worldAnchor, m_localAnchor2);
				m_refAngle += m_bodyB.GetAngle () - oldBody.GetAngle ();
			}
		}
      
      override public function CopyRuntimeInfosFrom (fromJoint:b2Joint):void
      {
         var fromPrismaticJoint:b2PrismaticJoint = fromJoint as b2PrismaticJoint;
         
         m_refAngle = fromPrismaticJoint.m_refAngle - (fromPrismaticJoint.m_bodyB.GetAngle() - fromPrismaticJoint.m_bodyA.GetAngle());
         //m_limitState = fromRevoluteJoint.m_limitState; // comment off for avoiding missing events
         m_impulse.CopyFrom (fromPrismaticJoint.m_impulse);
         m_motorImpulse = fromPrismaticJoint.m_motorImpulse;
         
         m_localAnchor1.CopyFrom (fromPrismaticJoint.m_localAnchor1); // maybe not correct
         m_localAnchor2.CopyFrom (fromPrismaticJoint.m_localAnchor2); // maybe not correct
      }
		
		// a very bad implementation
		override public function OnFlipped (pointX:Number, pointY:Number, normalXX2:Number, normalYY2:Number, normalXY2:Number):void
		{
		   // assume bodies and shapes and anchor points are all flipped already.
		   // NotifyAnchorPositionChanged is already called, but anchorB was set wrongly.
		   
	      var tempVec:b2Vec2 = new b2Vec2 ();
		   
		   // ...
		   
		   m_bodyA.GetWorldPoint_Output (m_localAnchor1, tempVec);
		   m_bodyB.GetLocalPoint_Output (tempVec, m_localAnchor2);
		   
		   // ...
		   
		   m_bodyA.GetWorldVector_Output (m_localXAxis1, tempVec);
		   var flippedX:Number = tempVec.x - normalXX2 * tempVec.x - normalXY2 * tempVec.y;
         var flippedY:Number = tempVec.y - normalXY2 * tempVec.x - normalYY2 * tempVec.y;
         tempVec.x = flippedX;
         tempVec.y = flippedY;
         m_bodyA.GetLocalVector_Output (tempVec, m_localXAxis1);
         b2Math.b2Cross_ScalarAndVector2_Output (1.0, m_localXAxis1, m_localYAxis1);
		}
      
	} // class
} // pacakge
//#endif
