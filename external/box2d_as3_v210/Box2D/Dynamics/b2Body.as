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

	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Transform;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2MassData;
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
		/// @param def the fixture definition.
		/// @warning This function is locked during callbacks.
		//b2Fixture* CreateFixture(const b2FixtureDef* def);

		/// Creates a fixture from a shape and attach it to this body.
		/// This is a convenience function. Use b2FixtureDef if you need to set parameters
		/// like friction, restitution, user data, or filtering.
		/// @param shape the shape to be cloned.
		/// @param density the shape density (set to zero for static bodies).
		/// @warning This function is locked during callbacks.
		//b2Fixture* CreateFixture(const b2Shape* shape, float32 density = 0.0f);

		/// Destroy a fixture. This removes the fixture from the broad-phase and
		/// therefore destroys any contacts associated with this fixture. All fixtures
		/// attached to a body are implicitly destroyed when the body is destroyed.
		/// @param fixture the fixture to be removed.
		/// @warning This function is locked during callbacks.
		//void DestroyFixture(b2Fixture* fixture);

		/// Set the mass properties. Note that this changes the center of mass position.
		/// If you are not sure how to compute mass properties, use SetMassFromShapes.
		/// The inertia tensor is assumed to be relative to the center of mass.
		/// You can make the body static by using a zero mass.
		/// @param massData the mass properties.
		//void SetMassData(const b2MassData* data);

		/// Compute the mass properties from the attached fixture. You typically call this
		/// after adding all the fixtures. If you add or remove fixtures later, you may want
		/// to call this again. Note that this changes the center of mass position.
		//void SetMassFromShapes();

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
		//void ApplyImpulse(const b2Vec2& impulse, const b2Vec2& point);

		/// Get the total mass of the body.
		/// @return the mass, usually in kilograms (kg).
		//float32 GetMass() const;

		/// Get the central rotational inertia of the body.
		/// @return the rotational inertia, usually in kg-m^2.
		//float32 GetInertia() const;

		/// Get the mass data of the body.
		/// @return a struct containing the mass, inertia and center of the body.
		//b2MassData GetMassData() const;

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

		/// Is this body treated like a bullet for continuous collision detection?
		//bool IsBullet() const;

		/// Should this body be treated like a bullet for continuous collision detection?
		//void SetBullet(bool flag);

		/// Is this body static (immovable)?
		//bool IsStatic() const;

		/// Is this body dynamic (movable)?
		//bool IsDynamic() const;

		/// Is this body sleeping (not simulating).
		//bool IsSleeping() const;

		/// Is this body allowed to sleep
		//bool IsAllowSleeping() const;

		/// You can disable sleeping on this body.
		//void AllowSleeping(bool flag);

		/// Wake up this body so it will begin simulating.
		//void WakeUp();

		/// Put this body to sleep so it will stop simulating.
		/// This also sets the velocity to zero.
		//void PutToSleep();

		/// Get the list of all fixtures attached to this body.
		//b2Fixture* GetFixtureList();

		/// Get the list of all fixtures attached to this body.
		//const b2Fixture* GetFixtureList() const;

		/// Get the list of all joints attached to this body.
		//b2JointEdge* GetJointList();

		/// Get the list of all contacts attached to this body.
		/// @warning this list changes during the time step and you may
		/// miss some collisions if you don't use b2ContactListener.
		//b2ContactEdge* GetConactList();

		/// Get the next body in the world's body list.
		//b2Body* GetNext();

		/// Get the next body in the world's body list.
		//const b2Body* GetNext() const;

		/// Get the user data pointer that was provided in the body definition.
		//void* GetUserData() const;

		/// Set the user data. Use this to store your application specific data.
		//void SetUserData(void* data);

		/// Get the parent world of this body.
		//b2World* GetWorld();

	//private:

		// m_flags
		//enum
		//{
			public static const e_islandFlag:int			= 0x0001;
			public static const e_sleepFlag:int				= 0x0002;
			public static const e_allowSleepFlag:int		= 0x0004;
			public static const e_bulletFlag:int			= 0x0008;
			public static const e_fixedRotationFlag:int	= 0x0010;
		//};

		// m_type
		//enum
		//{
			public static const e_staticType:int = 0;
			public static const e_dynamicType:int = 1;
			public static const e_maxTypes:int = 2;
		//};



		//b2Body(const b2BodyDef* bd, b2World* world);
		//~b2Body();


		//void SynchronizeFixtures();
		//void SynchronizeTransform();

		// This is used to prevent connected bodies from colliding.
		// It may lie, depending on the collideConnected flag.
		//bool IsConnected(const b2Body* other) const;

		//void Advance(float32 t);

		public var m_flags:int;
		public var m_type:int;

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
		public var m_I:Number, m_invI:Number;

		public var m_linearDamping:Number;
		public var m_angularDamping:Number;

		public var m_sleepTime:Number;

		public var m_userData:Object;

	// inline
		
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
			//m_linearVelocity = v;
			m_linearVelocity.x = v.x;
			m_linearVelocity.y = v.y;
		}

		public function GetLinearVelocity():b2Vec2
		{
			// notice: in c++ version, a value type is returned
			return m_linearVelocity;
			//return b2Vec2.b2Vec2_From2Numbers (m_linearVelocity.x, m_linearVelocity.y);
		}

		public function SetAngularVelocity(w:Number):void
		{
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
			return m_I;
		}

		public function GetMassData():b2MassData
		{
			var massData:b2MassData = new b2MassData ();
			massData.mass = m_mass;
			massData.I = m_I;
			//massData.center = m_sweep.localCenter;
			massData.center.x = m_sweep.localCenter.x;
			massData.center.y = m_sweep.localCenter.y;
			return massData;
		}

		public function GetWorldPoint(localPoint:b2Vec2):b2Vec2
		{
			//return b2Mul(m_xf, localPoint);
			return b2Math.b2Mul_Matrix22AndVector2(m_xf, localPoint);
		}

		public function GetWorldVector(localVector:b2Vec2):b2Vec2
		{
			//return b2Mul(m_xf.R, localVector);
			return b2Math.b2Mul_Matrix22AndVector2(m_xf.R, localVector);
		}

		public function GetLocalPoint(worldPoint:b2Vec2):b2Vec2
		{
			//return b2MulT(m_xf, worldPoint);
			return b2Math.b2MulTrans_Matrix22AndVector2(m_xf, worldPoint);
		}

		public function GetLocalVector(worldVector:b2Vec2):b2Vec2
		{
			//return b2MulT(m_xf.R, worldVector);
			return b2Math.b2MulTrans_Matrix22AndVector2(m_xf.R, worldVector);
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

		public function IsBullet():Boolean
		{
			return (m_flags & e_bulletFlag) == e_bulletFlag;
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

		public function IsStatic():Boolean
		{
			return m_type == e_staticType;
		}

		public function IsDynamic():Boolean
		{
			return m_type == e_dynamicType;
		}

		public function IsSleeping():Boolean
		{
			return (m_flags & e_sleepFlag) == e_sleepFlag;
		}

		public function IsAllowSleeping():Boolean
		{
			return (m_flags & e_allowSleepFlag) == e_allowSleepFlag;
		}

		public function AllowSleeping(flag:Boolean):void
		{
			if (flag)
			{
				m_flags |= e_allowSleepFlag;
			}
			else
			{
				m_flags &= ~e_allowSleepFlag;
				WakeUp();
			}
		}

		public function WakeUp():void
		{
			m_flags &= ~e_sleepFlag;
			m_sleepTime = 0.0;
		}

		public function PutToSleep():void
		{
			m_flags |= e_sleepFlag;
			m_sleepTime = 0.0;
			m_linearVelocity.SetZero();
			m_angularVelocity = 0.0;
			m_force.SetZero();
			m_torque = 0.0;
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

		public function GetConactList():b2ContactEdge
		{
			return m_contactList;
		}

		public function GetNext():b2Body
		{
			return m_next;
		}

		//inline const b2Body* b2Body::GetNext() const
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

		public function ApplyForce(force:b2Vec2, point:b2Vec2):void
		{
			if (IsSleeping())
			{
				WakeUp();
			}
			//m_force += force;
			m_force.x += force.x;
			m_force.y += force.y;
			//m_torque += b2Math.b2Cross2(point - m_sweep.c, force);
			m_torque += b2Math.b2Cross2 (b2Math.b2Subtract_Vector2 (point, m_sweep.c), force);
		}

		public function ApplyTorque(torque:Number):void
		{
			if (IsSleeping())
			{
				WakeUp();
			}
			m_torque += torque;
		}

		public function ApplyImpulse(impulse:b2Vec2, point:b2Vec2):void
		{
			if (IsSleeping())
			{
				WakeUp();
			}
			//m_linearVelocity += m_invMass * impulse;
			m_linearVelocity.x += m_invMass * impulse.x;
			m_linearVelocity.y += m_invMass * impulse.y;
			//m_angularVelocity += m_invI * b2Math.b2Cross2(point - m_sweep.c, impulse);
			m_angularVelocity += m_invI * b2Math.b2Cross2 (b2Math.b2Subtract_Vector2 (point, m_sweep.c), impulse);
		}

		public function SynchronizeTransform():void
		{
			m_xf.R.Set(m_sweep.a);
			//m_xf.position = m_sweep.c - b2Mul(m_xf.R, m_sweep.localCenter);
			var temp:b2Vec2 = b2Math.b2Mul_Matrix22AndVector2(m_xf.R, m_sweep.localCenter);
			m_xf.position.x = m_sweep.c.x - temp.x;
			m_xf.position.y = m_sweep.c.y - temp.y;
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
	} // class
} // package
//#endif
