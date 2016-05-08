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

//#include <Box2D/Collision/Shapes/b2EdgeShape.h>
//#include <new>
//using namespace std;

public function Set(v1:b2Vec2, v2:b2Vec2):void
{
	m_vertex1.CopyFrom (v1);
	m_vertex2.CopyFrom (v2);
	m_hasVertex0 = false;
	m_hasVertex3 = false;
}

override public function Clone(allocator:b2BlockAllocator = null):b2Shape
{
	//void* mem = allocator->Allocate(sizeof(b2EdgeShape));
	//b2EdgeShape* clone = new (mem) b2EdgeShape;
	//*clone = *this;
	//return clone;

	var clone:b2EdgeShape = new b2EdgeShape ();
	clone.m_type = m_type;
	clone.m_radius = m_radius;

	clone.m_vertex1.CopyFrom (m_vertex1);
	clone.m_vertex2.CopyFrom (m_vertex2);
	clone.m_vertex0.CopyFrom (m_vertex0);
	clone.m_vertex3.CopyFrom (m_vertex3);
	clone.m_hasVertex0 = m_hasVertex0;
	clone.m_hasVertex3 = m_hasVertex3;

	return clone;
}

override public function GetChildCount():int
{
	return 1;
}

override public function TestPoint(xf:b2Transform, p:b2Vec2):Boolean
{
	//B2_NOT_USED(xf);
	//B2_NOT_USED(p);
	return false;
}

// p = p1 + t * d
// v = v1 + s * e
// p1 + t * d = v1 + s * e
// s * e - t * d = p1 - v1
override public function RayCast(output:b2RayCastOutput, input:b2RayCastInput, xf:b2Transform, childIndex:int):Boolean
{
	//B2_NOT_USED(childIndex);

	var tempV:b2Vec2 = new b2Vec2 ();

	var p1:b2Vec2 = new b2Vec2 ();
	var p2:b2Vec2 = new b2Vec2 ();
	var d:b2Vec2 = new b2Vec2 ();
	var v1:b2Vec2 = new b2Vec2 ();
	var v2:b2Vec2 = new b2Vec2 ();
	var e:b2Vec2 = new b2Vec2 ();
	var normal:b2Vec2 = new b2Vec2 ();
	var q:b2Vec2 = new b2Vec2 ();
	var r:b2Vec2 = new b2Vec2 ();

	// Put the ray into the edge's frame of reference.
	//b2Vec2 p1 = b2MulT(xf.R, input.p1 - xf.position);
	tempV.x = input.p1.x - xf.position.x;
	tempV.y = input.p1.y - xf.position.y;
	b2Math.b2MulT_Matrix22AndVector2_Output (xf.R, tempV, p1);
	//b2Vec2 p2 = b2MulT(xf.R, input.p2 - xf.position);
	tempV.x = input.p2.x - xf.position.x;
	tempV.y = input.p2.y - xf.position.y;
	b2Math.b2MulT_Matrix22AndVector2_Output (xf.R, tempV, p2);
	//b2Vec2 d = p2 - p1;
	d.x = p2.x - p1.x;
	d.y = p2.y - p1.y;

	//b2Vec2 v1 = m_vertex1;
	v1.CopyFrom (m_vertex1);
	//b2Vec2 v2 = m_vertex2;
	v2.CopyFrom (m_vertex2);
	//b2Vec2 e = v2 - v1;
	e.x = v2.x - v1.x;
	e.y = v2.y - v1.y;
	//b2Vec2 normal(e.y, -e.x);
	normal.Set(e.y, -e.x);
	normal.Normalize();

	// q = p1 + t * d
	// dot(normal, q - v1) = 0
	// dot(normal, p1 - v1) + t * dot(normal, d) = 0
	//float32 numerator = b2Dot(normal, v1 - p1);
	tempV.x = v1.x - p1.x;
	tempV.y = v1.y - p1.y;
	var numerator:Number = b2Math.b2Dot2 (normal, tempV);
	var denominator:Number = b2Math.b2Dot2 (normal, d);

	if (denominator == 0.0)
	{
		return false;
	}

	var t:Number = numerator / denominator;
	//if (t < 0.0 || 1.0 < t) // r141
	if (t < 0.0 || input.maxFraction < t) // changed in r200
	{
		return false;
	}

	//b2Vec2 q = p1 + t * d;
	q.x = p1.x + t * d.x;
	q.y = p1.y + t * d.y;

	// q = v1 + s * r
	// s = dot(q - v1, r) / dot(r, r)
	//b2Vec2 r = v2 - v1;
	r.x = v2.x - v1.x;
	r.y = v2.y - v1.y;
	var rr:Number = b2Math.b2Dot2 (r, r);
	if (rr == 0.0)
	{
		return false;
	}

	//float32 s = b2Dot(q - v1, r) / rr;
	tempV.x = q.x - v1.x;
	tempV.y = q.y - v1.y;
	var s:Number = b2Math.b2Dot2 (tempV, r) / rr;
	if (s < 0.0 || 1.0 < s)
	{
		return false;
	}

	output.fraction = t;
	if (numerator > 0.0)
	{
		//output->normal = -normal;
		output.normal.x = -normal.x;
		output.normal.y = -normal.y;
	}
	else
	{
		//output->normal = normal;
		output.normal.x = normal.x;
		output.normal.y = normal.y;
	}
	return true;
}

private static var v1:b2Vec2 = new b2Vec2 ();
private static var v2:b2Vec2 = new b2Vec2 ();
private static var lower:b2Vec2 = new b2Vec2 ();
private static var upper:b2Vec2 = new b2Vec2 ();

override public function ComputeAABB(aabb:b2AABB, xf:b2Transform, childIndex:int):void
{
	//B2_NOT_USED(childIndex);

	//b2Vec2 v1 = b2Mul(xf, m_vertex1);
	b2Math.b2Mul_TransformAndVector2_Output (xf, m_vertex1, v1);
	//b2Vec2 v2 = b2Mul(xf, m_vertex2);
	b2Math.b2Mul_TransformAndVector2_Output (xf, m_vertex2, v2);

	//b2Vec2 lower = b2Min(v1, v2);
	b2Math.b2Min_Vector2_Output (v1, v2, lower);
	//b2Vec2 upper = b2Max(v1, v2);
	b2Math.b2Max_Vector2_Output (v1, v2, upper);

	//b2Vec2 r(m_radius, m_radius);
	//aabb->lowerBound = lower - r;
	//aabb->upperBound = upper + r;
	aabb.lowerBound.x = lower.x - m_radius;
	aabb.lowerBound.y = lower.y - m_radius;
	aabb.upperBound.x = upper.x + m_radius;
	aabb.upperBound.y = upper.y + m_radius;
}

override public function ComputeMass(massData:b2MassData, density:Number):void
{
	//B2_NOT_USED(density);

	massData.mass = 0.0;
	//massData->center = 0.5f * (m_vertex1 + m_vertex2);
	massData.center.x = 0.5 * (m_vertex1.x + m_vertex2.x);
	massData.center.y = 0.5 * (m_vertex1.y + m_vertex2.y);
	massData.I = 0.0;
}
