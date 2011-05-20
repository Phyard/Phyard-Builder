/*
* Copyright (c) 2006-2009 Erin Catto http://www.box2d.org
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

//#ifndef B2_CONTACT_MANAGER_H
//#define B2_CONTACT_MANAGER_H

package Box2D.Dynamics
{

	//#include <Box2D/Collision/b2BroadPhase.h>
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Collision.b2BroadPhase;
	import Box2D.Collision.b2BroadPhase_DynamicTree;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;

	import Box2D.Collision.b2BroadPhaseMonitor;

	// Delegate of b2World
	public class b2ContactManager implements b2BroadPhaseMonitor
	{
		include "b2ContactManager.cpp";

	//public:
		//b2ContactManager();

		// Broad-phase callback.
		//void AddPair(void* proxyUserDataA, void* proxyUserDataB);

		//void FindNewContacts();

		//void Destroy(b2Contact* c);

		//void Collide();

		public var m_broadPhase:b2BroadPhase;// = new b2BroadPhase_DynamicTree ();
		public var m_contactList:b2Contact;
		public var m_contactCount:int;
		public var m_contactFilter:b2ContactFilter;
		public var m_contactListener:b2ContactListener;
		public var m_allocator:b2BlockAllocator;

		// hacking
		//public var m_contactPreSolveListener:b2ContactPreSolveListener = null;
		//public var m_contactPostSolveListener:b2ContactPostSolveListener = null;
	} // class
} // pacakge
//#endif
