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

//#ifndef B2_CONTACT_H
//#define B2_CONTACT_H

package Box2D.Dynamics.Contacts
{

	//#include <Box2D/Common/b2Math.h>
	//#include <Box2D/Collision/b2Collision.h>
	//#include <Box2D/Collision/Shapes/b2Shape.h>
	//#include <Box2D/Dynamics/Contacts/b2Contact.h>
	//#include <Box2D/Dynamics/b2Fixture.h>
	
	import Box2D.Common.b2Math;
	import Box2D.Collision.b2Collision;
	import Box2D.Collision.b2Shape;
	import Box2D.Dynamics.b2Contact;
	import Box2D.Dynamics.b2Fixture;

	//class b2Body;
	//class b2Contact;
	//class b2Fixture;
	//class b2World;
	//class b2BlockAllocator;
	//class b2StackAllocator;
	//class b2ContactListener;

	//typedef b2Contact* b2ContactCreateFcn(b2Fixture* fixtureA, b2Fixture* fixtureB, b2BlockAllocator* allocator);
	//typedef void b2ContactDestroyFcn(b2Contact* contact, b2BlockAllocator* allocator);

	//struct b2ContactRegister
	//{
		//@see b2ContactRegister.as
	//};

	/// A contact edge is used to connect bodies and contacts together
	/// in a contact graph where each body is a node and each contact
	/// is an edge. A contact edge belongs to a doubly linked list
	/// maintained in each attached body. Each contact has two contact
	/// nodes, one for each attached body.
	//struct b2ContactEdge
	//{
		//@see b2ContactEdge.as
	//};

	/// The class manages contact between two shapes. A contact exists for each overlapping
	/// AABB in the broad-phase (except if filtered). Therefore a contact object may exist
	/// that has no contact points.
	public class b2Contact
	{
		include "b2Contact.cpp";
		
	//public:

		/// Get the contact manifold. Do not set the point count to zero. Instead
		/// call Disable.
		//b2Manifold* GetManifold();

		/// Get the world manifold.
		//void GetWorldManifold(b2WorldManifold* worldManifold) const;

		/// Is this contact solid? Returns false if the shapes are separate,
		/// sensors, or the contact has been disabled.
		/// @return true if this contact should generate a response.
		//bool IsSolid() const;

		/// Is this contact touching.
		//bool IsTouching() const;

		/// Does this contact generate TOI events for continuous simulation?
		//bool IsContinuous() const;

		/// Change this to be a sensor or non-sensor contact.
		//void SetAsSensor(bool sensor);

		/// Disable this contact. This can be used inside the pre-solve
		/// contact listener. The contact is only disabled for the current
		/// time step (or sub-step in continuous collisions).
		//void Disable();

		/// Get the next contact in the world's contact list.
		//b2Contact* GetNext();

		/// Get the first fixture in this contact.
		//b2Fixture* GetFixtureA();

		/// Get the second fixture in this contact.
		//b2Fixture* GetFixtureB();

		/// Flag this contact for filtering. Filtering will occur the next time step.
		//void FlagForFiltering();

		//--------------- Internals Below -------------------
	//protected:
		//friend class b2ContactManager;
		//friend class b2World;
		//friend class b2ContactSolver;

		// m_flags
		//enum
		//{
			// This contact should not participate in Solve
			// The contact equivalent of sensors
			public static const e_sensorFlag:int		= 0x0001;
			// Generate TOI events
			public static const e_continuousFlag:int	= 0x0002;
			// Used when crawling contact graph when forming islands.
			public static const e_islandFlag:int		= 0x0004;
			// Used in SolveTOI to indicate the cached toi value is still valid.
			public static const e_toiFlag:int			= 0x0008;
			// Set when the shapes are touching.
			public static const e_touchingFlag:int		= 0x0010;
			// Disabled (by user)
			public static const e_disabledFlag:int		= 0x0020;
			// This contact needs filtering because a fixture filter was changed.
			public static const e_filterFlag:int		= 0x0040;
		//};

		//static void AddType(b2ContactCreateFcn* createFcn, b2ContactDestroyFcn* destroyFcn,
		//					b2Shape::Type typeA, b2Shape::Type typeB);
		//static void InitializeRegisters();
		//static b2Contact* Create(b2Fixture* fixtureA, b2Fixture* fixtureB, b2BlockAllocator* allocator);
		//static void Destroy(b2Contact* contact, b2Shape::Type typeA, b2Shape::Type typeB, b2BlockAllocator* allocator);
		//static void Destroy(b2Contact* contact, b2BlockAllocator* allocator);

		//b2Contact() : m_fixtureA(NULL), m_fixtureB(NULL) {}
		//b2Contact(b2Fixture* fixtureA, b2Fixture* fixtureB);
		//virtual ~b2Contact() {}
		public function Destructor ():void {}

		//void Update(b2ContactListener* listener);
		//virtual void Evaluate() = 0;

		//float32 ComputeTOI(const b2Sweep& sweepA, const b2Sweep& sweepB) const;

		//static b2ContactRegister s_registers[b2Shape::e_typeCount][b2Shape::e_typeCount];
		//static bool s_initialized;

		public var m_flags:int;

		// World pool and list pointers.
		public var m_prev:b2Contact;
		public var m_next:b2Contact;

		// Nodes for connecting bodies.
		public var m_nodeA:b2ContactEdge = new b2ContactEdge ();
		public var m_nodeB:b2ContactEdge = new b2ContactEdge ();

		public var m_fixtureA:b2Fixture;
		public var m_fixtureB:b2Fixture;

		public var m_manifold:b2Manifold = new b2Manifold ();

		public var m_toi:Number;
	//};
	
	// inline
	
		public function GetManifold():b2Manifold
		{
			return m_manifold;
		}

		public function GetWorldManifold(worldManifold:b2WorldManifold):void
		{
			var bodyA:b2Body= m_fixtureA.GetBody();
			var bodyB:b2Body = m_fixtureB.GetBody();
			var shapeA:b2Shape = m_fixtureA.GetShape();
			var shapeB:b2Shape = m_fixtureB.GetShape();

			worldManifold.Initialize(m_manifold, bodyA.GetTransform(), shapeA.m_radius, bodyB.GetTransform(), shapeB.m_radius);
		}

		public function IsSolid():Boolean
		{
			var nonSolid:uint = e_sensorFlag | e_disabledFlag;
			return (m_flags & nonSolid) == 0;
		}

		public function SetAsSensor(sensor:Boolean):void
		{
			if (sensor)
			{
				m_flags |= e_sensorFlag;
			}
			else
			{
				m_flags &= ~e_sensorFlag;
			}
		}

		public function Disable():void
		{
			m_flags |= e_disabledFlag;
		}

		public function IsTouching():Boolean
		{
			return (m_flags & e_touchingFlag) != 0;
		}

		public function IsContinuous():Boolean
		{
			return (m_flags & e_continuousFlag) != 0;
		}

		public function GetNext():b2Contact
		{
			return m_next;
		}

		public function GetFixtureA():b2Fixture
		{
			return m_fixtureA;
		}

		public function GetFixtureB():b2Fixture
		{
			return m_fixtureB;
		}

		public function FlagForFiltering():void
		{
			m_flags |= e_filterFlag;
		}
	} // class
} // package
//#endif