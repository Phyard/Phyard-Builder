/*
* Copyright (c) 2006-2010 Erin Catto http://www.box2d.org
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

//#include <Box2D/Dynamics/Contacts/b2LoopAndPolygonContact.h>
//#include <Box2D/Common/b2BlockAllocator.h>
//#include <Box2D/Dynamics/b2Fixture.h>
//#include <Box2D/Collision/Shapes/b2LoopShape.h>
//#include <Box2D/Collision/Shapes/b2EdgeShape.h>

//#include <new>
//using namespace std;

public static function Create(fixtureA:b2Fixture, indexA:int, fixtureB:b2Fixture, indexB:int, allocator:b2BlockAllocator):b2Contact
{
	//void* mem = allocator->Allocate(sizeof(b2LoopAndPolygonContact));
	//return new (mem) b2LoopAndPolygonContact(fixtureA, indexA, fixtureB, indexB);
	return new b2LoopAndPolygonContact(fixtureA, indexA, fixtureB, indexB);
}

public static function Destroy(contact:b2Contact, allocator:b2BlockAllocator):void
{
	(contact as b2LoopAndPolygonContact)._b2LoopAndPolygonContact();
	//((b2LoopAndPolygonContact*)contact)->~b2LoopAndPolygonContact();
	//allocator->Free(contact, sizeof(b2LoopAndPolygonContact));
}

public function b2LoopAndPolygonContact(fixtureA:b2Fixture, indexA:int, fixtureB:b2Fixture, indexB:int):void
//: b2Contact(fixtureA, indexA, fixtureB, indexB)
{
	super(fixtureA, indexA, fixtureB, indexB);
	//b2Assert(m_fixtureA->GetType() == b2Shape::e_loop);
	//b2Assert(m_fixtureB->GetType() == b2Shape::e_polygon);
}

override public function Evaluate(manifold:b2Manifold, xfA:b2Transform, xfB:b2Transform):void
{
	var loop:b2LoopShape = m_fixtureA.GetShape() as b2LoopShape;
	var edge:b2EdgeShape = new b2EdgeShape ();
	loop.GetChildEdge(edge, m_indexA);
	b2Collision.b2CollideEdgeAndPolygon(	manifold, edge, xfA,
								m_fixtureB.GetShape() as b2PolygonShape, xfB);
}
