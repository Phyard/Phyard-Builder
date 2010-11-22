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

//#ifndef B2_JOINT_H
//#define B2_JOINT_H

package Box2D.Dynamics.Joints
{
	//#include <Box2D/Common/b2Math.h>
	
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2ContactEdge;

	//class b2Body;
	//class b2Joint;
	//struct b2TimeStep;
	//class b2BlockAllocator;

	// moved into class b2Joint
	//enum b2JointType
	//{
	//	e_unknownJoint,
	//	e_revoluteJoint,
	//	e_prismaticJoint,
	//	e_distanceJoint,
	//	e_pulleyJoint,
	//	e_mouseJoint,
	//	e_gearJoint,
	//	e_lineJoint,
	//	e_fixedJoint
	//};

	// moved into class b2Joint
	//enum b2LimitState
	//{
	//	e_inactiveLimit,
	//	e_atLowerLimit,
	//	e_atUpperLimit,
	//	e_equalLimits
	//};

	//struct b2Jacobian
	//{
		//@see b2Jacobian.as
	//};

	/// A joint edge is used to connect bodies and joints together
	/// in a joint graph where each body is a node and each joint
	/// is an edge. A joint edge belongs to a doubly linked list
	/// maintained in each attached body. Each joint has two joint
	/// nodes, one for each attached body.
	//struct b2JointEdge
	//{
		//@see b2JointEdge.as
	//};

	/// Joint definitions are used to construct joints.
	//struct b2JointDef
	//{
		//@see b2JointDef.as
	//};

	/// The base joint class. Joints are used to constraint two bodies together in
	/// various fashions. Some joints also feature limits and motors.
	public class b2Joint
	{
		include "b2Joint.cpp";
		
		//enum b2JointType
		//{
			public static const e_unknownJoint:int = 0;
			public static const e_revoluteJoint:int = 1;
			public static const e_prismaticJoint:int = 2;
			public static const e_distanceJoint:int = 3;
			public static const e_pulleyJoint:int = 4;
			public static const e_mouseJoint:int = 5;
			public static const e_gearJoint:int = 6;
			public static const e_lineJoint:int = 7;
			public static const e_weldJoint:int = 8;
			public static const e_frictionJoint:int = 9;
			public static const e_ropeJoint:int = 10;
		//};

		//enum b2LimitState
		//{
			public static const e_inactiveLimit:int = 0;
			public static const e_atLowerLimit:int = 1;
			public static const e_atUpperLimit:int = 2;
			public static const e_equalLimits:int = 3;
		//};
		
	//public:

		/// Get the type of the concrete joint.
		//b2JointType GetType() const;

		/// Get the first body attached to this joint.
		//b2Body* GetBodyA();

		/// Get the second body attached to this joint.
		//b2Body* GetBodyB();

		/// Get the anchor point on body1 in world coordinates.
		//virtual b2Vec2 GetAnchorA() const = 0;
		public function GetAnchorA():b2Vec2 {return null;}

		/// Get the anchor point on body2 in world coordinates.
		//virtual b2Vec2 GetAnchorB() const = 0;
		public function GetAnchorB():b2Vec2 {return null;}

		/// Get the reaction force on body2 at the joint anchor in Newtons.
		//virtual b2Vec2 GetReactionForce(float32 inv_dt) const = 0;
		public function GetReactionForce (inv_dt:Number):b2Vec2 {return null;}

		/// Get the reaction torque on body2 in N*m.
		//virtual float32 GetReactionTorque(float32 inv_dt) const = 0;
		public function GetReactionTorque (inv_dt:Number):Number {return 0.0;}

		/// Get the next joint the world joint list.
		//b2Joint* GetNext();
		//const b2Joint* GetNext() const;

		/// Get the user data pointer.
		//void* GetUserData() const;

		/// Set the user data pointer.
		//void SetUserData(void* data);

		/// Short-cut function to determine if either body is inactive.
		//bool IsActive() const;

	//protected:
		//friend class b2World;
		//friend class b2Body;
		//friend class b2Island;

		//static b2Joint* Create(const b2JointDef* def, b2BlockAllocator* allocator);
		//static void Destroy(b2Joint* joint, b2BlockAllocator* allocator);

		//b2Joint(const b2JointDef* def);
		//virtual ~b2Joint() {}
		public function Destructor ():void {}

		//virtual void InitVelocityConstraints(const b2TimeStep& step) = 0;
		public function InitVelocityConstraints(step:b2TimeStep):void {}
		
		//virtual void SolveVelocityConstraints(const b2TimeStep& step) = 0;
		public function SolveVelocityConstraints(step:b2TimeStep):void {}

		// This returns true if the position errors are within tolerance.
		//virtual bool SolvePositionConstraints(float32 baumgarte) = 0;
		public function SolvePositionConstraints(baumgarte:Number):Boolean {return false;}

		//b2JointType m_type;
		public var m_type:int;
		public var m_prev:b2Joint;
		public var m_next:b2Joint;
		public var m_edgeA:b2JointEdge = new b2JointEdge ();
		public var m_edgeB:b2JointEdge = new b2JointEdge ();
		public var m_bodyA:b2Body;
		public var m_bodyB:b2Body;

		public var m_islandFlag:Boolean;
		public var m_collideConnected:Boolean;

		public var m_userData:Object;

		// Cache here per time step to reduce cache misses.
		// TODO_ERIN will be wrong if the mass changes.
		public var m_localCenterA:b2Vec2 = new b2Vec2 (), m_localCenterB:b2Vec2 = new b2Vec2 ();
		public var m_invMassA:Number, m_invIA:Number;
		public var m_invMassB:Number, m_invIB:Number;
	//};

	// incline

		//inline void b2Jacobian::SetZero()
		//{
		//	linear1.SetZero(); angular1 = 0.0f;
		//	linear2.SetZero(); angular2 = 0.0f;
		//}

		//inline void b2Jacobian::Set(const b2Vec2& x1, float32 a1, const b2Vec2& x2, float32 a2)
		//{
		//	linear1 = x1; angular1 = a1;
		//	linear2 = x2; angular2 = a2;
		//}

		//inline float32 b2Jacobian::Compute(const b2Vec2& x1, float32 a1, const b2Vec2& x2, float32 a2)
		//{
		//	return b2Dot(linear1, x1) + angular1 * a1 + b2Dot(linear2, x2) + angular2 * a2;
		//}

		//inline b2JointType b2Joint::GetType() const
		public function GetType():int
		{
			return m_type;
		}

		public function GetBodyA():b2Body
		{
			return m_bodyA;
		}

		public function GetBodyB():b2Body
		{
			return m_bodyB;
		}

		public function GetNext():b2Joint
		{
			return m_next;
		}

		//inline const b2Joint* b2Joint::GetNext() const
		//{
		//	return m_next;
		//}

		public function GetUserData():Object
		{
			return m_userData;
		}

		public function SetUserData(data:Object):void
		{
			m_userData = data;
		}

//***********************************************************************
// hackings
//***********************************************************************
		
		// call by b2Body
		public function OnBodyLocalCenterChanged (dx:Number, dy:Number, jointEdge:b2JointEdge):void
		{
			// to override
		}
		
		final public function ChangeJointBody (newBody:b2Body, isBodyA:Boolean):void
		{
			if (m_collideConnected == false)
			{
				FlagConnectedContactsForFiltering ()
			}

			var oldBody:b2Body;
			var edge:b2JointEdge;
			
			if (isBodyA)
			{
				oldBody = m_bodyA;
				if (oldBody == newBody)
					return;
				
				edge = m_edgeA;
				m_bodyA = newBody;
				m_edgeB.other = newBody;
			}
			else
			{
				oldBody = m_bodyB;
				if (oldBody == newBody)
					return;
				
				edge = m_edgeB;
				m_bodyB = newBody;
				m_edgeA.other = newBody;
			}

			oldBody.SetAwake(true);
			newBody.SetAwake(true);

		// remove self from old body joint list

			// Remove from body 1.
			if (edge.prev != null)
			{
				edge.prev.next = edge.next;
			}

			if (edge.next != null)
			{
				edge.next.prev = edge.prev;
			}

			if (edge == oldBody.m_jointList)
			{
				oldBody.m_jointList = edge.next;
			}

		// add self to new body joint list

			edge.next = newBody.m_jointList;
			if (newBody.m_jointList != null) newBody.m_jointList.prev = edge;
			newBody.m_jointList = edge;

			if (m_collideConnected == false)
			{
				FlagConnectedContactsForFiltering ();
			}

		// more tot do ...

			NotifyBodyChanged (oldBody, isBodyA);
		}

		protected function NotifyBodyChanged (oldBody:b2Body, isBodyA:Boolean):void
		{
			// to override
		}

		public function FlagConnectedContactsForFiltering ():void
		{
			var edge:b2ContactEdge = m_bodyB.GetContactList();
			while (edge != null)
			{
				if (edge.other == m_bodyA)
				{
					// Flag the contact for filtering at the next time step (where either
					// body is awake).
					edge.contact.FlagForFiltering();
				}

				edge = edge.next;
			}
		}
		
		public static var mCustomJointCreateFunction:Function = null;
		public static var mCustomJointDestroyFunction:Function = null;
		
	} // class
} // package
//#endif
