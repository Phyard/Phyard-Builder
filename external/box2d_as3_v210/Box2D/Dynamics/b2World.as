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

//#ifndef B2_WORLD_H
//#define B2_WORLD_H

package Box2D.Dynamics
{

	//#include <Box2D/Common/b2Math.h>
	//#include <Box2D/Common/b2BlockAllocator.h>
	//#include <Box2D/Common/b2StackAllocator.h>
	//#include <Box2D/Dynamics/b2ContactManager.h>
	//#include <Box2D/Dynamics/b2WorldCallbacks.h>
	
	import flash.utils.getTimer;
	
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Sweep;
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Common.b2StackAllocator;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.Contacts.b2TOISolver;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2RayCastInput;
	import Box2D.Collision.b2TOIInput;
	import Box2D.Collision.b2TOIOutput;
	import Box2D.Collision.b2TimeOfImpact;
	
	import Box2D.Dynamics.b2Body;
	
	//struct b2AABB;
	//struct b2BodyDef;
	//struct b2JointDef;
	//struct b2TimeStep;
	//class b2Body;
	//class b2Fixture;
	//class b2Joint;
	
	/// The world class manages all physics entities, dynamic simulation,
	/// and asynchronous queries. The world also contains efficient memory
	/// management facilities.
	public class b2World
	{
		include "b2World.cpp";
		
	//public:
		/// Construct a world object.
		/// @param gravity the world gravity vector.
		/// @param doSleep improve performance by not simulating inactive bodies.
		//b2World(const b2Vec2& gravity, bool doSleep);

		/// Destruct the world. All physics entities are destroyed and all heap memory is released.
		//~b2World();

		/// Register a destruction listener.
		//void SetDestructionListener(b2DestructionListener* listener);

		/// Register a contact filter to provide specific control over collision.
		/// Otherwise the default filter is used (b2_defaultFilter).
		//void SetContactFilter(b2ContactFilter* filter);

		/// Register a contact event listener
		//void SetContactListener(b2ContactListener* listener);

		/// Register a routine for debug drawing. The debug draw functions are called
		/// inside the b2World::Step method, so make sure your renderer is ready to
		/// consume draw commands when you call Step().
		//void SetDebugDraw(b2DebugDraw* debugDraw);

		/// Create a rigid body given a definition. No reference to the definition
		/// is retained.
		/// @warning This function is locked during callbacks.
		//b2Body* CreateBody(const b2BodyDef* def);

		/// Destroy a rigid body given a definition. No reference to the definition
		/// is retained. This function is locked during callbacks.
		/// @warning This automatically deletes all associated shapes and joints.
		/// @warning This function is locked during callbacks.
		//void DestroyBody(b2Body* body);

		/// Create a joint to constrain bodies together. No reference to the definition
		/// is retained. This may cause the connected bodies to cease colliding.
		/// @warning This function is locked during callbacks.
		//b2Joint* CreateJoint(const b2JointDef* def);

		/// Destroy a joint. This may cause the connected bodies to begin colliding.
		/// @warning This function is locked during callbacks.
		//void DestroyJoint(b2Joint* joint);

		/// Take a time step. This performs collision detection, integration,
		/// and constraint solution.
		/// @param timeStep the amount of time to simulate, this should not vary.
		/// @param velocityIterations for the velocity constraint solver.
		/// @param positionIterations for the position constraint solver.
		//void Step(	float32 timeStep,
		//			int32 velocityIterations,
		//			int32 positionIterations,
		//			bool resetForces);

		/// Call this after you are done with time steps to clear the forces. You normally
		/// call this after each call to Step, unless you are performing sub-steps. By default,
		/// forces will be automatically cleared, so you don't need to call this function.
		/// @see SetAutoClearForces
		//void ClearForces();

		/// Call this to draw shapes and other debug draw data.
		//void DrawDebugData();

		/// Query the world for all fixtures that potentially overlap the
		/// provided AABB.
		/// @param callback a user implemented callback class.
		/// @param aabb the query box.
		//void QueryAABB(b2QueryCallback* callback, const b2AABB& aabb) const;

		/// Ray-cast the world for all fixtures in the path of the ray. Your callback
		/// controls whether you get the closest point, any point, or n-points.
		/// The ray-cast ignores shapes that contain the starting point.
		/// @param callback a user implemented callback class.
		/// @param point1 the ray starting point
		/// @param point2 the ray ending point
		//void RayCast(b2RayCastCallback* callback, const b2Vec2& point1, const b2Vec2& point2) const;

		/// Get the world body list. With the returned body, use b2Body::GetNext to get
		/// the next body in the world list. A NULL body indicates the end of the list.
		/// @return the head of the world body list.
		//b2Body* GetBodyList();

		/// Get the world joint list. With the returned joint, use b2Joint::GetNext to get
		/// the next joint in the world list. A NULL joint indicates the end of the list.
		/// @return the head of the world joint list.
		//b2Joint* GetJointList();

		/// Get the world contact list. With the returned contact, use b2Contact::GetNext to get
		/// the next contact in the world list. A NULL contact indicates the end of the list.
		/// @return the head of the world contact list.
		/// @warning contacts are 
		//b2Contact* GetContactList();

		/// Enable/disable warm starting. For testing.
		//void SetWarmStarting(bool flag) { m_warmStarting = flag; }

		/// Enable/disable continuous physics. For testing.
		//void SetContinuousPhysics(bool flag) { m_continuousPhysics = flag; }

		/// Get the number of broad-phase proxies.
		//int32 GetProxyCount() const;

		/// Get the number of bodies.
		//int32 GetBodyCount() const;

		/// Get the number of joints.
		//int32 GetJointCount() const;

		/// Get the number of contacts (each may have 0 or more contact points).
		//int32 GetContactCount() const;

		/// Change the global gravity vector.
		//void SetGravity(const b2Vec2& gravity);
		
		/// Get the global gravity vector.
		//b2Vec2 GetGravity() const;

		/// Is the world locked (in the middle of a time step).
		//bool IsLocked() const;

		/// Set flag to control automatic clearing of forces after each time step.
		//void SetAutoClearForces(bool flag);

		/// Get the flag that controls automatic clearing of forces after each time step.
		//bool GetAutoClearForces() const;

	//private:

		// m_flags
		//enum
		//{
			public static const e_newFixture:int	= 0x0001;
			public static const e_locked:int		   = 0x0002;
			public static const e_clearForces:int	= 0x0004;
		//};

		//friend class b2Body;
		//friend class b2ContactManager;
		//friend class b2Controller;

		//void Solve(const b2TimeStep& step);
		//void SolveTOI();
		//void SolveTOI(b2Body* body);

		//void DrawJoint(b2Joint* joint);
		//void DrawShape(b2Fixture* shape, const b2Transform& xf, const b2Color& color);

		public var m_blockAllocator:b2BlockAllocator = new b2BlockAllocator ();
		public var m_stackAllocator:b2StackAllocator = new b2StackAllocator ();

		public var m_flags:int;

		public var m_contactManager:b2ContactManager; // = new b2ContactManager ();

		public var m_bodyList:b2Body;
		public var m_jointList:b2Joint;

		public var m_bodyCount:int;
		public var m_jointCount:int;

		public var m_gravity:b2Vec2 = new b2Vec2 ();
		public var m_allowSleep:Boolean;

		public var m_destructionListener:b2DestructionListener;
		public var m_debugDraw:b2DebugDraw;

		// This is used to compute the time step ratio to
		// support a variable time step.
		public var m_inv_dt0:Number;

		// This is for debugging the solver.
		public var m_warmStarting:Boolean;

		// This is for debugging the solver.
		public var m_continuousPhysics:Boolean;
	//};

		public function GetBodyList():b2Body
		{
			return m_bodyList;
		}

		public function GetJointList():b2Joint
		{
			return m_jointList;
		}

		public function GetContactList():b2Contact
		{
			return m_contactManager.m_contactList;
		}

		public function GetBodyCount():int
		{
			return m_bodyCount;
		}

		public function GetJointCount():int
		{
			return m_jointCount;
		}

		public function GetContactCount():int
		{
			return m_contactManager.m_contactCount;
		}

		public function SetGravity(gravity:b2Vec2):void
		{
			m_gravity.CopyFrom (gravity);
		}

		public function GetGravity():b2Vec2
		{
			//@notice: in c++ version, the return is a value type instead of reference
			//return b2Vec2.b2Vec2_From2Numbers (m_gravity.x, m_gravity.y);
			return m_gravity;
		}

		public function IsLocked():Boolean
		{
			return (m_flags & e_locked) == e_locked;
		}
		
//====================================================================================
// hacking
//====================================================================================
		
		private var mIsland:b2Island = null;
		
		private function GetIsland (jointCount:int, contactCount:int):b2Island
		{
			var bodyCount:int = m_bodyCount;
			
			if (bodyCount < 128)
				bodyCount = 128;
			
			if (contactCount < b2Settings.b2_maxTOIContactsPerIsland)
				contactCount = b2Settings.b2_maxTOIContactsPerIsland;
			
			if (mIsland != null)
			{
				var toCreateNewIsland:Boolean = false;
				
				if (bodyCount > mIsland.m_bodyCapacity)
				{
					bodyCount = bodyCount + bodyCount;
					toCreateNewIsland = true;
				}
				
				if (jointCount > mIsland.m_jointCapacity)
				{
					jointCount = jointCount + jointCount;
					toCreateNewIsland = true;
				}
				
				if (contactCount > mIsland.m_contactCapacity)
				{
					contactCount = contactCount + contactCount;
					toCreateNewIsland = true;
				}
				
				if (toCreateNewIsland)
					mIsland = null;
			}
			
			if (mIsland == null)
			{
				mIsland = new b2Island (bodyCount, contactCount, jointCount,
										m_stackAllocator,
										m_contactManager.m_contactPostSolveListener //m_contactManager.m_contactListener
										);
			}
			else
			{
				mIsland.m_listener = m_contactManager.m_contactPostSolveListener;
				
				mIsland.Clear ();
			}
			
			return mIsland;
		}
		
		public function WakeUpAllBodies ():void
		{
			var b:b2Body = m_bodyList;

			while (b != null)
			{
				b.SetAwake (true);
				b = b.m_next;
			}
		}
		
		public function FlagForFilteringForAllContacts ():void
		{
			for (var c:b2Contact = m_contactManager.m_contactList; c != null; c = c.m_next)
			{
				c.FlagForFiltering ();
			}
		}

		public function SetContactPreSolveListener(listener:b2ContactPreSolveListener):void
		{
			m_contactManager.m_contactPreSolveListener = listener;
		}

		public function GetContactPreSolveListener():b2ContactPreSolveListener
		{
			return m_contactManager.m_contactPreSolveListener;
		}

		public function SetContactPostSolveListener(listener:b2ContactPostSolveListener):void
		{
			m_contactManager.m_contactPostSolveListener = listener;
		}

		public function GetContactPostSolveListener():b2ContactPostSolveListener
		{
			return m_contactManager.m_contactPostSolveListener;
		}

		public function SetAutoClearForces(flag:Boolean):void
		{
			if (flag)
			{
				m_flags |= e_clearForces;
			}
			else
			{
				m_flags &= ~e_clearForces;
			}
		}

		/// Get the flag that controls automatic clearing of forces after each time step.
		public function GetAutoClearForces():Boolean
		{
			return (m_flags & e_clearForces) == e_clearForces;
		}

	} // class
} // package
//#endif
