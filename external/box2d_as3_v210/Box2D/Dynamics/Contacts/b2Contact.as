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
	
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Sweep;
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Collision.b2Collision;
	import Box2D.Collision.b2ContactID;
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2ManifoldPoint;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Collision.b2TimeOfImpact;
	import Box2D.Collision.b2TOIInput;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	//import Box2D.Dynamics.b2ContactPreSolveListener;

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

		/// Get the contact manifold. Do not modify the manifold unless you understand the
		/// internals of Box2D.
		//b2Manifold* GetManifold();
		//const b2Manifold* GetManifold() const;

		/// Get the world manifold.
		//void GetWorldManifold(b2WorldManifold* worldManifold) const;

		/// Is this contact touching?
		//bool IsTouching() const;

		/// Enable/disable this contact. This can be used inside the pre-solve
		/// contact listener. The contact is only disabled for the current
		/// time step (or sub-step in continuous collisions).
		//void SetEnabled(bool flag);

		/// Has this contact been disabled?
		//bool IsEnabled() const;

		/// Get the next contact in the world's contact list.
		//b2Contact* GetNext();
		//const b2Contact* GetNext() const;

		/// Get the first fixture in this contact.
		//b2Fixture* GetFixtureA();
		//const b2Fixture* GetFixtureA() const;

		/// Get the second fixture in this contact.
		//b2Fixture* GetFixtureB();
		//const b2Fixture* GetFixtureB() const;

		/// Flag this contact for filtering. Filtering will occur the next time step.
		//void FlagForFiltering();

		/// Evaluate this contact with your own manifold and transforms.
		//virtual void Evaluate(b2Manifold* manifold, const b2Transform& xfA, const b2Transform& xfB) = 0;
		public function Evaluate(manifold:b2Manifold, xfA:b2Transform, xfB:b2Transform):void {}

	//protected:
		//friend class b2ContactManager;
		//friend class b2World;
		//friend class b2ContactSolver;

		// Flags stored in m_flags
		//enum
		//{
			// Used when crawling contact graph when forming islands.
			public static const e_islandFlag:int		= 0x0001;
			// Set when the shapes are touching.
			public static const e_touchingFlag:int		= 0x0002;
			// This contact can be disabled (by user)
			public static const e_enabledFlag:int		= 0x0004;
			// This contact needs filtering because a fixture filter was changed.
			public static const e_filterFlag:int		= 0x0008;
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

		public var m_manifold:b2Manifold//  = new b2Manifold (); // now use manifold pool to optimize

		public var m_toiCount:int
		//public var m_toi:Number;
	//};
	
	// inline
	
		public function GetManifold():b2Manifold
		{
			return m_manifold;
		}

		//inline const b2Manifold* b2Contact::GetManifold() const
		//{
		//	return &m_manifold;
		//}

		public function GetWorldManifold(worldManifold:b2WorldManifold):void
		{
			var bodyA:b2Body= m_fixtureA.GetBody();
			var bodyB:b2Body = m_fixtureB.GetBody();
			var shapeA:b2Shape = m_fixtureA.GetShape();
			var shapeB:b2Shape = m_fixtureB.GetShape();

			worldManifold.Initialize(m_manifold, bodyA.GetTransform(), shapeA.m_radius, bodyB.GetTransform(), shapeB.m_radius);
		}

		public function SetEnabled(flag:Boolean):void
		{
			if (flag)
			{
				m_flags |= e_enabledFlag;
			}
			else
			{
				m_flags &= ~e_enabledFlag;
			}
		}

		public function IsEnabled():Boolean
		{
			return (m_flags & e_enabledFlag) == e_enabledFlag;
		}

		public function IsTouching():Boolean
		{
			return (m_flags & e_touchingFlag) == e_touchingFlag;
		}

		public function GetNext():b2Contact
		{
			return m_next;
		}

		//inline const b2Contact* b2Contact::GetNext() const
		//{
		//	return m_next;
		//}

		public function GetFixtureA():b2Fixture
		{
			return m_fixtureA;
		}

		//inline const b2Fixture* b2Contact::GetFixtureA() const
		//{
		//	return m_fixtureA;
		//}

		public function GetFixtureB():b2Fixture
		{
			return m_fixtureB;
		}

		//inline const b2Fixture* b2Contact::GetFixtureB() const
		//{
		//	return m_fixtureB;
		//}

		public function FlagForFiltering():void
		{
			m_flags |= e_filterFlag;
		}
		
//***********************************************************************
// hackings
//***********************************************************************
		
		// hacking
		public var mNextManifoldInPool:b2Manifold = null;
		
		// call by b2Body
		public function OnBodyLocalCenterChanged (dx:Number, dy:Number, body:b2Body):void
		{
			if (m_manifold.pointCount <= 0)
				return;
			
			var manifoldPoint:Array = m_manifold.points;
			
			var flip:Boolean = b2ContactID.ContactID_GetFlip (manifoldPoint [0].id) != 0;
			var isBodyA:Boolean = body == m_fixtureA.GetBody ();
			
			var firstBodyIsBodyA:Boolean = (isBodyA != flip);
			
			if (firstBodyIsBodyA)
			{
				m_manifold.localPoint.x += dx;
				m_manifold.localPoint.y += dy;
			}
			else
			{
				for (var i:int = 0; i < m_manifold.pointCount; ++ i)
				{
					manifoldPoint [i].localPoint.x += dx;
					manifoldPoint [i].localPoint.y += dy;
				}
			}
		}
		
	} // class
} // package
//#endif
