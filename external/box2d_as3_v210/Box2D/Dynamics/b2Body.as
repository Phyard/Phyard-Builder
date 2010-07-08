/*
* Copyright (c) 2006-2009 Erin Catto http://www.gphysics.com
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

//#ifndef B2_BODY_H
//#define B2_BODY_H

package Box2D.Dynamics
{

	//#include <Box2D/Common/b2Math.h>
	//#include <Box2D/Collision/Shapes/b2Shape.h>
	//#include <memory>

	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Sweep;
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Collision.b2BroadPhase;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.Joints.b2JointEdge;

	/// A rigid body. These are created via b2World::CreateBody.
	public class b2Body
	{
		include "b2Body.cpp"; 
		
	//public:
	
		/// Creates a fixture and attach it to this body. Use this function if you need
		/// to set some fixture parameters, like friction. Otherwise you can create the
		/// fixture directly from a shape.
		/// If the density is non-zero, this function automatically updates the mass of the body.
		/// Contacts are not created until the next time step.
		/// @param def the fixture definition.
		/// @warning This function is locked during callbacks.
		//b2Fixture* CreateFixture(const b2FixtureDef* def);

		/// Creates a fixture from a shape and attach it to this body.
		/// This is a convenience function. Use b2FixtureDef if you need to set parameters
		/// like friction, restitution, user data, or filtering.
		/// If the density is non-zero, this function automatically updates the mass of the body.
		/// @param shape the shape to be cloned.
		/// @param density the shape density (set to zero for static bodies).
		/// @warning This function is locked during callbacks.
		//b2Fixture* CreateFixture(const b2Shape* shape, float32 density);

		/// Destroy a fixture. This removes the fixture from the broad-phase and
		/// destroys all contacts associated with this fixture. This will
		/// automatically adjust the mass of the body if the body is dynamic and the
		/// fixture has positive density.
		/// All fixtures attached to a body are implicitly destroyed when the body is destroyed.
		/// @param fixture the fixture to be removed.
		/// @warning This function is locked during callbacks.
		//void DestroyFixture(b2Fixture* fixture);

		/// Set the position of the body's origin and rotation.
		/// This breaks any contacts and wakes the other bodies.
		/// @param position the world position of the body's local origin.
		/// @param angle the world rotation in radians.
		//void SetTransform(const b2Vec2& position, float32 angle);

		/// Get the body transform for the body's origin.
		/// @return the world transform of the body's origin.
		//const b2Transform& GetTransform() const;

		/// Get the world body origin position.
		/// @return the world position of the body's origin.
		//const b2Vec2& GetPosition() const;

		/// Get the angle in radians.
		/// @return the current world rotation angle in radians.
		//float32 GetAngle() const;

		/// Get the world position of the center of mass.
		//const b2Vec2& GetWorldCenter() const;

		/// Get the local position of the center of mass.
		//const b2Vec2& GetLocalCenter() const;

		/// Set the linear velocity of the center of mass.
		/// @param v the new linear velocity of the center of mass.
		//void SetLinearVelocity(const b2Vec2& v);

		/// Get the linear velocity of the center of mass.
		/// @return the linear velocity of the center of mass.
		//b2Vec2 GetLinearVelocity() const;

		/// Set the angular velocity.
		/// @param omega the new angular velocity in radians/second.
		//void SetAngularVelocity(float32 omega);

		/// Get the angular velocity.
		/// @return the angular velocity in radians/second.
		//float32 GetAngularVelocity() const;

		/// Apply a force at a world point. If the force is not
		/// applied at the center of mass, it will generate a torque and
		/// affect the angular velocity. This wakes up the body.
		/// @param force the world force vector, usually in Newtons (N).
		/// @param point the world position of the point of application.
		//void ApplyForce(const b2Vec2& force, const b2Vec2& point);

		/// Apply a torque. This affects the angular velocity
		/// without affecting the linear velocity of the center of mass.
		/// This wakes up the body.
		/// @param torque about the z-axis (out of the screen), usually in N-m.
		//void ApplyTorque(float32 torque);

		/// Apply an impulse at a point. This immediately modifies the velocity.
		/// It also modifies the angular velocity if the point of application
		/// is not at the center of mass. This wakes up the body.
		/// @param impulse the world impulse vector, usually in N-seconds or kg-m/s.
		/// @param point the world position of the point of application.
		//void ApplyLinearImpulse(const b2Vec2& impulse, const b2Vec2& point);

		/// Apply an angular impulse.
		/// @param impulse the angular impulse in units of kg*m*m/s
		//void ApplyAngularImpulse(float32 impulse);

		/// Get the total mass of the body.
		/// @return the mass, usually in kilograms (kg).
		//float32 GetMass() const;

		/// Get the rotational inertia of the body about the local origin.
		/// @return the rotational inertia, usually in kg-m^2.
		//float32 GetInertia() const;

		/// Get the mass data of the body.
		/// @return a struct containing the mass, inertia and center of the body.
		//void GetMassData(b2MassData* data) const;

		/// Set the mass properties to override the mass properties of the fixtures.
		/// Note that this changes the center of mass position.
		/// Note that creating or destroying fixtures can also alter the mass.
		/// This function has no effect if the body isn't dynamic.
		/// @param massData the mass properties.
		//void SetMassData(const b2MassData* data);

		/// This resets the mass properties to the sum of the mass properties of the fixtures.
		/// This normally does not need to be called unless you called SetMassData to override
		/// the mass and you later want to reset the mass.
		//void ResetMassData();

		/// Get the world coordinates of a point given the local coordinates.
		/// @param localPoint a point on the body measured relative the the body's origin.
		/// @return the same point expressed in world coordinates.
		//b2Vec2 GetWorldPoint(const b2Vec2& localPoint) const;

		/// Get the world coordinates of a vector given the local coordinates.
		/// @param localVector a vector fixed in the body.
		/// @return the same vector expressed in world coordinates.
		//b2Vec2 GetWorldVector(const b2Vec2& localVector) const;

		/// Gets a local point relative to the body's origin given a world point.
		/// @param a point in world coordinates.
		/// @return the corresponding local point relative to the body's origin.
		//b2Vec2 GetLocalPoint(const b2Vec2& worldPoint) const;

		/// Gets a local vector given a world vector.
		/// @param a vector in world coordinates.
		/// @return the corresponding local vector.
		//b2Vec2 GetLocalVector(const b2Vec2& worldVector) const;

		/// Get the world linear velocity of a world point attached to this body.
		/// @param a point in world coordinates.
		/// @return the world velocity of a point.
		//b2Vec2 GetLinearVelocityFromWorldPoint(const b2Vec2& worldPoint) const;

		/// Get the world velocity of a local point.
		/// @param a point in local coordinates.
		/// @return the world velocity of a point.
		//b2Vec2 GetLinearVelocityFromLocalPoint(const b2Vec2& localPoint) const;

		/// Get the linear damping of the body.
		//float32 GetLinearDamping() const;

		/// Set the linear damping of the body.
		//void SetLinearDamping(float32 linearDamping);

		/// Get the angular damping of the body.
		//float32 GetAngularDamping() const;

		/// Set the angular damping of the body.
		//void SetAngularDamping(float32 angularDamping);

		/// Set the type of this body. This may alter the mass and velocity.
		//void SetType(b2BodyType type);

		/// Get the type of this body.
		//b2BodyType GetType() const;

		/// Should this body be treated like a bullet for continuous collision detection?
		//void SetBullet(bool flag);

		/// Is this body treated like a bullet for continuous collision detection?
		//bool IsBullet() const;

		/// You can disable sleeping on this body. If you disable sleeping, the
		/// body will be woken.
		//void SetSleepingAllowed(bool flag);

		/// Is this body allowed to sleep
		//bool IsSleepingAllowed() const;

		/// Set the sleep state of the body. A sleeping body has very
		/// low CPU cost.
		/// @param flag set to true to put body to sleep, false to wake it.
		//void SetAwake(bool flag);

		/// Get the sleeping state of this body.
		/// @return true if the body is sleeping.
		//bool IsAwake() const;

		/// Set the active state of the body. An inactive body is not
		/// simulated and cannot be collided with or woken up.
		/// If you pass a flag of true, all fixtures will be added to the
		/// broad-phase.
		/// If you pass a flag of false, all fixtures will be removed from
		/// the broad-phase and all contacts will be destroyed.
		/// Fixtures and joints are otherwise unaffected. You may continue
		/// to create/destroy fixtures and joints on inactive bodies.
		/// Fixtures on an inactive body are implicitly inactive and will
		/// not participate in collisions, ray-casts, or queries.
		/// Joints connected to an inactive body are implicitly inactive.
		/// An inactive body is still owned by a b2World object and remains
		/// in the body list.
		//void SetActive(bool flag);

		/// Get the active state of the body.
		//bool IsActive() const;

		/// Set this body to have fixed rotation. This causes the mass
		/// to be reset.
		//void SetFixedRotation(bool flag);

		/// Does this body have fixed rotation?
		//bool IsFixedRotation() const;

		/// Get the list of all fixtures attached to this body.
		//b2Fixture* GetFixtureList();
		//const b2Fixture* GetFixtureList() const;

		/// Get the list of all joints attached to this body.
		//b2JointEdge* GetJointList();
		//const b2JointEdge* GetJointList() const;

		/// Get the list of all contacts attached to this body.
		/// @warning this list changes during the time step and you may
		/// miss some collisions if you don't use b2ContactListener.
		//b2ContactEdge* GetContactList();
		//const b2ContactEdge* GetContactList() const;

		/// Get the next body in the world's body list.
		//b2Body* GetNext();
		//const b2Body* GetNext() const;

		/// Get the user data pointer that was provided in the body definition.
		//void* GetUserData() const;

		/// Set the user data. Use this to store your application specific data.
		//void SetUserData(void* data);

		/// Get the parent world of this body.
		//b2World* GetWorld();
		//const b2World* GetWorld() const;

	//private:

		/// The body type.
		/// static: zero mass, zero velocity, may be manually moved
		/// kinematic: zero mass, non-zero velocity set by user, moved by solver
		/// dynamic: positive mass, non-zero velocity determined by forces, moved by solver
		//enum b2BodyType
		//{
			public static const b2_staticBody:int = 0;
			public static const b2_kinematicBody:int = 1;
			public static const b2_dynamicBody:int = 2;
		//};

		// m_flags
		//enum
		//{
			public static const e_islandFlag:int			= 0x0001;
			public static const e_awakeFlag:int				= 0x0002;
			public static const e_autoSleepFlag:int		= 0x0004;
			public static const e_bulletFlag:int			= 0x0008;
			public static const e_fixedRotationFlag:int	= 0x0010;
			public static const e_activeFlag:int			= 0x0020;
			public static const e_toiFlag:int				= 0x0040;
		//};

		//b2Body(const b2BodyDef* bd, b2World* world);
		//~b2Body();

		//void SynchronizeFixtures();
		//void SynchronizeTransform();

		// This is used to prevent connected bodies from colliding.
		// It may lie, depending on the collideConnected flag.
		//bool ShouldCollide(const b2Body* other) const;

		//void Advance(float32 t);

		//b2BodyType m_type;
		public var m_type:int;

		public var m_flags:int;

		public var m_islandIndex:int;

		public var m_xf:b2Transform = new b2Transform ();		// the body origin transform
		public var m_sweep:b2Sweep = new b2Sweep ();	// the swept motion for CCD

		public var m_linearVelocity:b2Vec2 = new b2Vec2 ();
		public var m_angularVelocity:Number;

		public var m_force:b2Vec2 = new b2Vec2 ();
		public var m_torque:Number;

		public var m_world:b2World;
		public var m_prev:b2Body;
		public var m_next:b2Body;

		public var m_fixtureList:b2Fixture;
		public var m_fixtureCount:int;

		public var m_jointList:b2JointEdge;
		public var m_contactList:b2ContactEdge;

		public var m_mass:Number, m_invMass:Number;

		// Rotational inertia about the center of mass.
		public var m_I:Number, m_invI:Number;

		public var m_linearDamping:Number;
		public var m_angularDamping:Number;

		public var m_sleepTime:Number;

		public var m_userData:Object;

	// inline
		
		//b2BodyType b2Body::GetType() const
		public function GetType():int
		{
			return m_type;
		}

		public function GetTransform():b2Transform
		{
			return m_xf;
		}

		public function GetPosition():b2Vec2
		{
			return m_xf.position;
		}

		public function GetAngle():Number
		{
			return m_sweep.a;
		}

		public function GetWorldCenter():b2Vec2
		{
			return m_sweep.c;
		}

		public function GetLocalCenter():b2Vec2
		{
			return m_sweep.localCenter;
		}

		public function SetLinearVelocity(v:b2Vec2):void
		{
			if (m_type == b2_staticBody)
			{
				return;
			}

			if (b2Math.b2Dot2 (v,v) > 0.0)
			{
				SetAwake(true);
			}

			//m_linearVelocity = v;
			m_linearVelocity.x = v.x;
			m_linearVelocity.y = v.y;
		}

		public function GetLinearVelocity():b2Vec2
		{
			// notice: in c++ version, a value type is returned
			return m_linearVelocity; // the caller should not modify the return value. ToDo: a safe implemmentation
			//return b2Vec2.b2Vec2_From2Numbers (m_linearVelocity.x, m_linearVelocity.y);
		}

		public function SetAngularVelocity(w:Number):void
		{
			if (m_type == b2_staticBody)
			{
				return;
			}

			if (w * w > 0.0)
			{
				SetAwake(true);
			}

			m_angularVelocity = w;
		}

		public function GetAngularVelocity():Number
		{
			return m_angularVelocity;
		}

		public function GetMass():Number
		{
			return m_mass;
		}

		public function GetInertia():Number
		{
			return m_I + m_mass * b2Math.b2Dot2(m_sweep.localCenter, m_sweep.localCenter);
		}

		public function GetMassData(data:b2MassData):void
		{
			data.mass = m_mass;
			data.I = m_I + m_mass * b2Math.b2Dot2(m_sweep.localCenter, m_sweep.localCenter);
			//data->center = m_sweep.localCenter;
			data.center.x = m_sweep.localCenter.x;
			data.center.y = m_sweep.localCenter.y;
		}

		public function GetWorldPoint(localPoint:b2Vec2):b2Vec2
		{
			//return b2Mul(m_xf, localPoint);
			return b2Math.b2Mul_TransformAndVector2(m_xf, localPoint);
		}

		public function GetWorldPoint_Output(localPoint:b2Vec2, worldPoint:b2Vec2):void
		{
			//return b2Mul(m_xf, localPoint);
			b2Math.b2Mul_TransformAndVector2_Output (m_xf, localPoint, worldPoint);
		}

		public function GetWorldVector(localVector:b2Vec2):b2Vec2
		{
			//return b2Mul(m_xf.R, localVector);
			return b2Math.b2Mul_Matrix22AndVector2(m_xf.R, localVector);
		}

		public function GetWorldVector_Output (localVector:b2Vec2, worldVector:b2Vec2):void
		{
			//return b2Mul(m_xf.R, localVector);
			b2Math.b2Mul_Matrix22AndVector2_Output (m_xf.R, localVector, worldVector);
		}

		public function GetLocalPoint(worldPoint:b2Vec2):b2Vec2
		{
			//return b2MulT(m_xf, worldPoint);
			return b2Math.b2MulT_TransformAndVector2(m_xf, worldPoint);
		}

		public function GetLocalPoint_Output (worldPoint:b2Vec2, localPoint:b2Vec2):void
		{
			//return b2MulT(m_xf, worldPoint);
			b2Math.b2MulT_TransformAndVector2_Output (m_xf, worldPoint, localPoint);
		}

		public function GetLocalVector(worldVector:b2Vec2):b2Vec2
		{
			//return b2MulT(m_xf.R, worldVector);
			return b2Math.b2MulT_Matrix22AndVector2(m_xf.R, worldVector);
		}

		public function GetLocalVector_Output (worldVector:b2Vec2, localVector:b2Vec2):void
		{
			//return b2MulT(m_xf.R, worldVector);
			b2Math.b2MulT_Matrix22AndVector2_Output (m_xf.R, worldVector, localVector);
		}

		public function GetLinearVelocityFromWorldPoint(worldPoint:b2Vec2):b2Vec2
		{
			//return m_linearVelocity + b2Math.b2Cross2(m_angularVelocity, worldPoint - m_sweep.c);
			var temp:b2Vec2 = b2Math.b2Cross_ScalarAndVector2 (m_angularVelocity, b2Math.b2Subtract_Vector2 (worldPoint, m_sweep.c));
			temp.x += m_linearVelocity.x;
			temp.y += m_linearVelocity.y;
			
			return temp;
		}

		public function GetLinearVelocityFromLocalPoint(localPoint:b2Vec2):b2Vec2
		{
			return GetLinearVelocityFromWorldPoint(GetWorldPoint(localPoint));
		}

		public function GetLinearDamping():Number
		{
			return m_linearDamping;
		}

		public function SetLinearDamping(linearDamping:Number):void
		{
			m_linearDamping = linearDamping;
		}

		public function GetAngularDamping():Number
		{
			return m_angularDamping;
		}

		public function SetAngularDamping(angularDamping:Number):void
		{
			m_angularDamping = angularDamping;
		}

		public function SetBullet(flag:Boolean):void
		{
			if (flag)
			{
				m_flags |= e_bulletFlag;
			}
			else
			{
				m_flags &= ~e_bulletFlag;
			}
		}

		public function IsBullet():Boolean
		{
			return (m_flags & e_bulletFlag) == e_bulletFlag;
		}

		public function SetAwake(flag:Boolean):void
		{
			if (flag)
			{
				if ((m_flags & e_awakeFlag) == 0)
				{
					m_flags |= e_awakeFlag;
					m_sleepTime = 0.0;
				}
			}
			else
			{
				m_flags &= ~e_awakeFlag;
				m_sleepTime = 0.0;
				m_linearVelocity.SetZero();
				m_angularVelocity = 0.0;
				m_force.SetZero();
				m_torque = 0.0;
			}
		}

		public function IsAwake():Boolean
		{
			return (m_flags & e_awakeFlag) == e_awakeFlag;
		}

		public function IsActive():Boolean
		{
			return (m_flags & e_activeFlag) == e_activeFlag;
		}

		public function SetFixedRotation(flag:Boolean):void
		{
			if (flag)
			{
				m_flags |= e_fixedRotationFlag;
			}
			else
			{
				m_flags &= ~e_fixedRotationFlag;
			}

			//ResetMassData();
			OnMassDataChanged ();
		}

		public function IsFixedRotation():Boolean
		{
			return (m_flags & e_fixedRotationFlag) == e_fixedRotationFlag;
		}

		public function SetSleepingAllowed(flag:Boolean):void
		{
			if (flag)
			{
				m_flags |= e_autoSleepFlag;
			}
			else
			{
				m_flags &= ~e_autoSleepFlag;
				SetAwake(true);
			}
		}

		public function IsSleepingAllowed():Boolean
		{
			return (m_flags & e_autoSleepFlag) == e_autoSleepFlag;
		}

		public function GetFixtureList():b2Fixture
		{
			return m_fixtureList;
		}
		
		//inline const b2Fixture* b2Body::GetFixtureList() const
		//{
		//	return m_fixtureList;
		//}

		public function GetJointList():b2JointEdge
		{
			return m_jointList;
		}

		//inline const b2JointEdge* b2Body::GetJointList() const
		//{
		//	return m_jointList;
		//}

		public function GetContactList():b2ContactEdge
		{
			return m_contactList;
		}

		//inline const b2ContactEdge* b2Body::GetContactList() const
		//{
		//	return m_contactList;
		//}

		public function GetNext():b2Body
		{
			return m_next;
		}

		//inline const b2Body* b2Body::GetNext() const
		//{
		//	return m_next;
		//}

		public function SetUserData(data:Object):void
		{
			m_userData = data;
		}

		public function GetUserData():Object
		{
			return m_userData;
		}

		public function ApplyForce(force:b2Vec2, point:b2Vec2):void
		{
			if (m_type != b2_dynamicBody)
			{
				return;
			}

			if (IsAwake() == false)
			{
				SetAwake(true);
			}

			//m_force += force;
			m_force.x += force.x;
			m_force.y += force.y;
			//m_torque += b2Math.b2Cross2(point - m_sweep.c, force);
			tempV.x = point.x - m_sweep.c.x;
			tempV.y = point.y - m_sweep.c.y;
			m_torque += b2Math.b2Cross2 (tempV, force);
		}

		public function ApplyTorque(torque:Number):void
		{
			if (m_type != b2_dynamicBody)
			{
				return;
			}

			if (IsAwake() == false)
			{
				SetAwake(true);
			}

			m_torque += torque;
		}

		public function ApplyLinearImpulse(impulse:b2Vec2, point:b2Vec2):void
		{
			if (m_type != b2_dynamicBody)
			{
				return;
			}

			if (IsAwake() == false)
			{
				SetAwake(true);
			}

			//m_linearVelocity += m_invMass * impulse;
			m_linearVelocity.x += m_invMass * impulse.x;
			m_linearVelocity.y += m_invMass * impulse.y;
			//m_angularVelocity += m_invI * b2Math.b2Cross2(point - m_sweep.c, impulse);
			tempV.x = point.x - m_sweep.c.x;
			tempV.y = point.y - m_sweep.c.y;
			m_angularVelocity += m_invI * b2Math.b2Cross2 (tempV, impulse);
		}

		public function ApplyAngularImpulse (impulse:Number):void
		{
			if (m_type != b2_dynamicBody)
			{
				return;
			}

			if (IsFixedRotation ())
			{
				return;
			}

			if (IsAwake() == false)
			{
				SetAwake(true);
			}

			m_angularVelocity += m_invI * impulse;
		}

		public function SynchronizeTransform():void
		{
			m_xf.R.SetFromAngle (m_sweep.a);
			//m_xf.position = m_sweep.c - b2Mul(m_xf.R, m_sweep.localCenter);
			b2Math.b2Mul_Matrix22AndVector2_Output (m_xf.R, m_sweep.localCenter, tempV);
			m_xf.position.x = m_sweep.c.x - tempV.x;
			m_xf.position.y = m_sweep.c.y - tempV.y;
		}

		public function Advance(t:Number):void
		{
			// Advance to the new safe time.
			m_sweep.Advance(t);
			m_sweep.c.CopyFrom (m_sweep.c0);
			m_sweep.a = m_sweep.a0;
			SynchronizeTransform();
		}

		public function GetWorld():b2World
		{
			return m_world;
		}

		//inline const b2World* b2Body::GetWorld() const
		//{
		//	return m_world;
		//}

//******************************************************************************
// hacking
//******************************************************************************
		
		private var mAutoUpdateMass:Boolean = true;
		
		public function SetAutoUpdateMass (auto:Boolean):void
		{
			mAutoUpdateMass = auto;
		}

		public function OnMassDataChanged ():void
		{
			if (mAutoUpdateMass)
				ResetMassData ();
		}

		private var mViewZeroMassAsStatic:Boolean = false;
		
		public function SetViewZeroMassAsStatic (asStatic:Boolean):void
		{
			mViewZeroMassAsStatic = asStatic;
		}

		public function CoincideWithCentroid ():Boolean//b2Vec2
		{
			//b2Assert(m_world->IsLocked() == false);
			if (m_world.IsLocked() == true)
			{
				return false;// null;
			}
			
			var dx:Number = - m_sweep.localCenter.x;
			var dy:Number = - m_sweep.localCenter.y;
			
			var abs_dx:Number = Math.abs (dx);
			var abs_dy:Number = Math.abs (dy);
			
			if (abs_dx < Number.MIN_VALUE && abs_dy < Number.MIN_VALUE)
				return false;// null;
			
			m_xf.position.x = m_sweep.c.x;
			m_xf.position.y = m_sweep.c.y;
			
			m_sweep.localCenter.x = 0.0;
			m_sweep.localCenter.y = 0.0;
			
		// adjust shapes local vertices
			
			var fixture:b2Fixture = m_fixtureList;
			while (fixture != null)
			{
				fixture.GetShape ().OnBodyLocalCenterChanged (dx, dy);
				
				fixture = fixture.m_next;
			}
			
		// adjust local anchor points
			
			var jn:b2JointEdge = m_jointList;
			while (jn != null)
			{
				jn.joint.OnBodyLocalCenterChanged (dx, dy, jn);
				
				jn = jn.next;
			}
			
		// adjust contact m points manifoild local points
			
			var ce:b2ContactEdge = m_contactList;
			while (ce != null)
			{
				ce.contact.OnBodyLocalCenterChanged (dx, dy, this);
				
				ce = ce.next;
			}
			
			// ...
			return true; //new b2Vec2.b2Vec2_From2Numbers (dx, dy);
		}

		public function FlagForFilteringForAllContacts ():void
		{
			// Since the body type changed, we need to flag contacts for filtering.
			for (var ce:b2ContactEdge = m_contactList; ce != null; ce = ce.next)
			{
				ce.contact.FlagForFiltering();
			}
		}

	} // class
} // package
//#endif
