/*
* Copyright (c) 2006-2010 Erin Catto http://www.gphysics.com
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

//#include <Box2D/Collision/Shapes/b2LoopShape.h>
//#include <Box2D/Collision/Shapes/b2EdgeShape.h>
//#include <new>
//#include <cstring>
//using namespace std;

//b2LoopShape::~b2LoopShape()
public function _b2LoopShape():void
{
	//b2Free(m_vertices);
	m_vertices = null;
	m_count = 0;
}

//void b2LoopShape::Create(const b2Vec2* vertices, int32 count)
public function Create(vertices:Array, count:int):void
{
	//b2Assert(m_vertices == NULL && m_count == 0);
	//b2Assert(count >= 2);
	m_count = count;
	//m_vertices = (b2Vec2*)b2Alloc(count * sizeof(b2Vec2));
	//memcpy(m_vertices, vertices, m_count * sizeof(b2Vec2));
	m_vertices = new Array (m_count);
	for (var i:int = 0; i < m_count; ++ i)
	{
		var cloneV:b2Vec2 = new b2Vec2 ();
		m_vertices [i] = cloneV;
		
		var v:b2Vec2 = vertices [i] as b2Vec2;
		cloneV.x = v.x;
		cloneV.y = v.y;
	}
}

override public function Clone(allocator:b2BlockAllocator = null):b2Shape
{
	//void* mem = allocator->Allocate(sizeof(b2LoopShape));
	//b2LoopShape* clone = new (mem) b2LoopShape;
	//clone->Create(m_vertices, m_count);
	//return clone;

	var clone:b2LoopShape = new b2LoopShape ();
	clone.m_type = m_type;
	clone.m_radius = m_radius;

	clone.Create (m_vertices, m_count);

	return clone;
}

override public function GetChildCount():int
{
	return m_count;
}

public function GetChildEdge(edge:b2EdgeShape, index:int):void
{
	//b2Assert(2 <= m_count);
	//b2Assert(0 <= index && index < m_count);
	edge.m_type = b2Shape.e_edge;
	edge.m_radius = m_radius;
	edge.m_hasVertex0 = true;
	edge.m_hasVertex3 = true;

	var i0:int = index - 1 >= 0 ? index - 1 : m_count - 1;
	var i1:int = index;
	var i2:int = index + 1 < m_count ? index + 1 : 0;
	var i3:int = index + 2;
	while (i3 >= m_count)
	{
		i3 -= m_count;
	}

	edge.m_vertex0.CopyFrom (m_vertices[i0] as b2Vec2); // maybe can use ref
	edge.m_vertex1.CopyFrom (m_vertices[i1] as b2Vec2); // maybe can use ref
	edge.m_vertex2.CopyFrom (m_vertices[i2] as b2Vec2); // maybe can use ref
	edge.m_vertex3.CopyFrom (m_vertices[i3] as b2Vec2); // maybe can use ref
}

override public function TestPoint(xf:b2Transform, p:b2Vec2):Boolean
{
	//B2_NOT_USED(xf);
	//B2_NOT_USED(p);
	return false;
}

override public function RayCast(output:b2RayCastOutput, input:b2RayCastInput, xf:b2Transform, childIndex:int):Boolean
{
	//b2Assert(childIndex < m_count);

	var edgeShape:b2EdgeShape = new b2EdgeShape ();

	var i1:int = childIndex;
	var i2:int = childIndex + 1;
	if (i2 == m_count)
	{
		i2 = 0;
	}

	edgeShape.m_vertex1.CopyFrom (m_vertices[i1] as b2Vec2); // maybe can use ref
	edgeShape.m_vertex2.CopyFrom (m_vertices[i2] as b2Vec2); // maybe can use ref

	return edgeShape.RayCast(output, input, xf, 0);
}

private static var v1:b2Vec2 = new b2Vec2 ();
private static var v2:b2Vec2 = new b2Vec2 ();

override public function ComputeAABB(aabb:b2AABB, xf:b2Transform, childIndex:int):void
{
	//b2Assert(childIndex < m_count);

	var i1:int = childIndex;
	var i2:int = childIndex + 1;
	if (i2 == m_count)
	{
		i2 = 0;
	}

	//b2Vec2 v1 = b2Mul(xf, m_vertices[i1]);
	b2Math.b2Mul_TransformAndVector2_Output (xf, m_vertices[i1] as b2Vec2, v1);
	//b2Vec2 v2 = b2Mul(xf, m_vertices[i2]);
	b2Math.b2Mul_TransformAndVector2_Output (xf, m_vertices[i2] as b2Vec2, v2);

	//aabb->lowerBound = b2Min(v1, v2);
	b2Math.b2Min_Vector2_Output (v1, v2, aabb.lowerBound);
	//aabb->upperBound = b2Max(v1, v2);
	b2Math.b2Max_Vector2_Output (v1, v2, aabb.upperBound);
}

override public function ComputeMass(massData:b2MassData, density:Number):void
{
	//B2_NOT_USED(density);

	massData.mass = 0.0;
	massData.center.SetZero();
	massData.I = 0.0;
}
