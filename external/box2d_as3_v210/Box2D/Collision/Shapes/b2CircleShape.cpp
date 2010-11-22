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

//#include <Box2D/Collision/Shapes/b2CircleShape.h>
//#include <new>

override public function Clone(allocator:b2BlockAllocator = null):b2Shape
{
	//void* mem = allocator->Allocate(sizeof(b2CircleShape));
	//b2CircleShape* clone = new (mem) b2CircleShape;
	//*clone = *this;
	//return clone;
	
	var clone:b2CircleShape = new b2CircleShape ();
	
	clone.m_type = m_type;
	clone.m_radius = m_radius;

	clone.m_p.CopyFrom (m_p);
	
	return clone;
}

override public function GetChildCount():int
{
	return 1;
}

override public function TestPoint(transform:b2Transform, p:b2Vec2):Boolean
{
	//b2Vec2 center = transform.position + b2Mul(transform.R, m_p);
	//b2Vec2 d = p - center;
	//return b2Dot(d, d) <= m_radius * m_radius;
	
	var tempV:b2Vec2 = new b2Vec2 ();
	b2Math.b2Mul_Matrix22AndVector2_Output (transform.R, m_p, tempV);
	tempV.x = p.x - transform.position.x - tempV.x;
	tempV.y = p.y - transform.position.y - tempV.y;
	
	return b2Math.b2Dot2 (tempV, tempV) <= m_radius * m_radius;
}

// Collision Detection in Interactive 3D Environments by Gino van den Bergen
// From Section 3.1.2
// x = s + a * r
// norm(x) = radius
override public function RayCast(output:b2RayCastOutput, input:b2RayCastInput, transform:b2Transform, childIndex:int):Boolean
{
	//B2_NOT_USED(childIndex);
	
	var position:b2Vec2 = new b2Vec2 ();
	var s:b2Vec2 = new b2Vec2 ();
	var r:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	
	//b2Vec2 position = transform.position + b2Mul(transform.R, m_p);
	b2Math.b2Mul_Matrix22AndVector2_Output (transform.R, m_p, tempV);
	position.x = transform.position.x + tempV.x;
	position.y = transform.position.y + tempV.y;
	//b2Vec2 s = input.p1 - position;
	s.x = input.p1.x - position.x;
	s.y = input.p1.y - position.y;
	var b:Number = b2Math.b2Dot2 (s, s) - m_radius * m_radius;

	// Solve quadratic equation.
	//b2Vec2 r = input.p2 - input.p1;
	r.x = input.p2.x - input.p1.x;
	r.y = input.p2.y - input.p1.y;
	var c:Number = b2Math.b2Dot2 (s, r);
	var rr:Number = b2Math.b2Dot2 (r, r);
	var sigma :Number= c * c - rr * b;

	// Check for negative discriminant and short segment.
	if (sigma < 0.0 || rr < b2Settings.b2_epsilon)
	{
		return false;
	}

	// Find the point of intersection of the line with the circle.
	//float32 a = -(c + b2Sqrt(sigma));
	var a:Number = -(c + Math.sqrt(sigma));

	// Is the intersection point on the segment?
	if (0.0 <= a && a <= input.maxFraction * rr)
	{
		a /= rr;
		output.fraction = a;
		output.normal.Set (s.x + a * r.x, s.y + a * r.y);
		output.normal.Normalize();
		return true;
	}

	return false;
}

private static var mP:b2Vec2 = new b2Vec2 ();

override public function ComputeAABB(aabb:b2AABB, transform:b2Transform, childIndex:int):void
{
	//B2_NOT_USED(childIndex);
	
	var p:b2Vec2 = mP;//new b2Vec2 ();
	
	//b2Vec2 p = transform.position + b2Mul(transform.R, m_p);
	b2Math.b2Mul_Matrix22AndVector2_Output (transform.R, m_p, p)
	p.x += transform.position.x;
	p.y += transform.position.y;
	
	aabb.lowerBound.Set(p.x - m_radius, p.y - m_radius);
	aabb.upperBound.Set(p.x + m_radius, p.y + m_radius);
}

override public function ComputeMass(massData:b2MassData, density:Number):void
{
	massData.mass = density * b2Settings.b2_pi * m_radius * m_radius;
	massData.center.CopyFrom (m_p);

	// inertia about the local origin
	massData.I = massData.mass * (0.5 * m_radius * m_radius + b2Math.b2Dot2 (m_p, m_p));
}
