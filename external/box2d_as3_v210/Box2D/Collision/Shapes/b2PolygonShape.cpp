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

//#include <Box2D/Collision/Shapes/b2PolygonShape.h>
//#include <new>

override public function Clone(allocator:b2BlockAllocator = null):b2Shape
{
	//void* mem = allocator->Allocate(sizeof(b2PolygonShape));
	//b2PolygonShape* clone = new (mem) b2PolygonShape;
	//*clone = *this;
	//return clone;
	
	var clone:b2PolygonShape = new b2PolygonShape ();
	
	clone.m_type = m_type;
	clone.m_radius = m_radius;
	
	clone.m_centroid.CopyFrom (m_centroid);
	clone.m_vertexCount = m_vertexCount;
	for (var i:int = 0; i < m_vertexCount; ++ i)
	{
		(clone.m_vertices [i] as b2Vec2).CopyFrom (m_vertices [i] as b2Vec2);
		(clone.m_normals [i] as b2Vec2).CopyFrom (m_normals [i] as b2Vec2);
	}
	
	return clone;
}

//public function SetAsBox(hx:Number, hy:Number):void
//{
//	m_vertexCount = 4;
//	m_vertices[0].Set(-hx, -hy);
//	m_vertices[1].Set( hx, -hy);
//	m_vertices[2].Set( hx,  hy);
//	m_vertices[3].Set(-hx,  hy);
//	m_normals[0].Set(0.0f, -1.0f);
//	m_normals[1].Set(1.0f, 0.0f);
//	m_normals[2].Set(0.0f, 1.0f);
//	m_normals[3].Set(-1.0f, 0.0f);
//	m_centroid.SetZero();
//}

public function SetAsBox(hx:Number, hy:Number, center:b2Vec2 = null, angle:Number = 0.0):void
{
	var tempV:b2Vec2 = new b2Vec2 ();

	if (center == null)
	{
		center = b2Vec2.b2Vec2_From2Numbers (0.0, 0.0);
	}
	
	m_vertexCount = 4;
	(m_vertices[0] as b2Vec2).Set(-hx, -hy);
	(m_vertices[1] as b2Vec2).Set( hx, -hy);
	(m_vertices[2] as b2Vec2).Set( hx,  hy);
	(m_vertices[3] as b2Vec2).Set(-hx,  hy);
	(m_normals[0] as b2Vec2).Set(0.0, -1.0);
	(m_normals[1] as b2Vec2).Set(1.0, 0.0);
	(m_normals[2] as b2Vec2).Set(0.0, 1.0);
	(m_normals[3] as b2Vec2).Set(-1.0, 0.0);
	m_centroid = center;

	var xf:b2Transform = new b2Transform ();
	xf.position.CopyFrom (center);
	xf.R.SetFromAngle (angle);

	// Transform vertices and normals.
	for (var i:int = 0; i < m_vertexCount; ++ i)
	{
		//m_vertices[i] = b2Mul(xf, m_vertices[i]);
		b2Math.b2Mul_TransformAndVector2_Output (xf, m_vertices[i] as b2Vec2, tempV);
		(m_vertices[i] as b2Vec2).CopyFrom (tempV);
		//m_normals[i] = b2Mul(xf.R, m_normals[i]);
		b2Math.b2Mul_Matrix22AndVector2_Output (xf.R, m_normals[i] as b2Vec2, tempV);
		(m_normals[i] as b2Vec2).CopyFrom (tempV);
	}
}

public function SetAsEdge(v1:b2Vec2, v2:b2Vec2):void
{
	var tempV:b2Vec2 = new b2Vec2 ();

	m_vertexCount = 2;
	(m_vertices[0] as b2Vec2).CopyFrom (v1);
	(m_vertices[1] as b2Vec2).CopyFrom (v2);
	//m_centroid = 0.5f * (v1 + v2);
	m_centroid.x = 0.5 * (v1.x + v2.x);
	m_centroid.y = 0.5 * (v1.y + v2.y);
	//m_normals[0] = b2Math.b2Cross2(v2 - v1, 1.0f);
	tempV.x = v2.x - v1.x;
	tempV.y = v2.y - v1.y;
	b2Math.b2Cross_Vector2AndScalar_Output (tempV, 1.0, m_normals[0] as b2Vec2);
	(m_normals[0] as b2Vec2).Normalize();
	//m_normals[1] = -m_normals[0];
	(m_normals[1] as b2Vec2).x = - (m_normals[0] as b2Vec2).x;
	(m_normals[1] as b2Vec2).y = - (m_normals[0] as b2Vec2).y;
}

//static b2Vec2 ComputeCentroid(const b2Vec2* vs, int32 count)
public static function ComputeCentroid(vs:Array, count:int):b2Vec2
{
	//b2Assert(count >= 2);

	//b2Vec2 c; c.Set(0.0f, 0.0f);
	var c:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.0, 0.0);
	var area:Number = 0.0;

	if (count == 2)
	{
		//c = 0.5f * (vs[0] + vs[1]);
		b2Math.b2Add_Vector2_Output (vs[0] as b2Vec2, vs[1] as b2Vec2, c)
		c.x *= 0.5;
		c.y *= 0.5;
		return c;
	}

	// pRef is the reference point for forming triangles.
	// It's location doesn't change the result (except for rounding error).
	//b2Vec2 pRef(0.0f, 0.0f);
	var pRef:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.0, 0.0);
	
//#if 0
//	// This code would put the reference point inside the polygon.
//	for (int32 i = 0; i < count; ++i)
//	{
//		pRef += vs[i];
//	}
//	pRef *= 1.0f / count;
//#endif

	const inv3:Number = 1.0 / 3.0;
	
	var e1:b2Vec2 = new b2Vec2 ();
	var e2:b2Vec2 = new b2Vec2 ();
	var tempF:Number;

	for (var i:int = 0; i < count; ++i)
	{
		// Triangle vertices.
		//b2Vec2 p1 = pRef;
		//b2Vec2 p2 = vs[i];
		//b2Vec2 p3 = i + 1 < count ? vs[i+1] : vs[0];
		var p1:b2Vec2 = pRef; // .Clone ()
		var p2:b2Vec2 = vs[i] as b2Vec2; // .Clone ()
		var p3:b2Vec2 = i + 1 < count ? vs[i+1] as b2Vec2 : vs[0] as b2Vec2; // .Clone ()

		//b2Vec2 e1 = p2 - p1;
		e1.x = p2.x - p1.x;
		e1.y = p2.y - p1.y;
		//b2Vec2 e2 = p3 - p1;
		e2.x = p3.x - p1.x;
		e2.y = p3.y - p1.y;

		var D:Number = b2Math.b2Cross2 (e1, e2);

		var triangleArea:Number = 0.5 * D;
		area += triangleArea;

		// Area weighted centroid
		//c += triangleArea * inv3 * (p1 + p2 + p3);
		tempF = triangleArea * inv3;
		c.x += tempF * (p1.x + p2.x + p3.x);
		c.y += tempF * (p1.y + p2.y + p3.y);
	}

	// Centroid
	//b2Assert(area > B2_FLT_EPSILON);
	//c *= 1.0f / area;
	tempF = 1.0 / area;
	c.x *= tempF;
	c.y *= tempF;
	return c;
}

//void b2PolygonShape::Set(const b2Vec2* vertices, int32 count)
public function Set(vertices:Array, count:int):void
{
	var i:int;
	var i1:int;
	var i2:int;
	var edge:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	
	//b2Assert(2 <= count && count <= b2Settings.b2_maxPolygonVertices);
	m_vertexCount = count;

	// Copy vertices.
	for (i = 0; i < m_vertexCount; ++i)
	{
		(m_vertices[i] as b2Vec2).CopyFrom (vertices[i] as b2Vec2);
	}

	// Compute normals. Ensure the edges have non-zero length.
	for (i = 0; i < m_vertexCount; ++i)
	{
		i1 = i;
		i2 = i + 1 < m_vertexCount ? i + 1 : 0;
		//b2Vec2 edge = m_vertices[i2] - m_vertices[i1];
		b2Math.b2Subtract_Vector2_Output (m_vertices[i2] as b2Vec2, m_vertices[i1] as b2Vec2, edge);
		//b2Assert(edge.LengthSquared() > B2_FLT_EPSILON * B2_FLT_EPSILON);
		//m_normals[i] = b2Math.b2Cross2(edge, 1.0f);
		b2Math.b2Cross_Vector2AndScalar_Output (edge, 1.0, tempV);
		m_normals[i].Normalize();
	}

//#ifdef _DEBUG
//	// Ensure the polygon is convex and the interior
//	// is to the left of each edge.
//	for (int32 i = 0; i < m_vertexCount; ++i)
//	{
//		int32 i1 = i;
//		int32 i2 = i + 1 < m_vertexCount ? i + 1 : 0;
//		b2Vec2 edge = m_vertices[i2] - m_vertices[i1];
//
//		for (int32 j = 0; j < m_vertexCount; ++j)
//		{
//			// Don't check vertices on the current edge.
//			if (j == i1 || j == i2)
//			{
//				continue;
//			}
//			
//			b2Vec2 r = m_vertices[j] - m_vertices[i1];
//
//			// Your polygon is non-convex (it has an indentation) or
//			// has colinear edges.
//			float32 s = b2Math.b2Cross2(edge, r);
//			b2Assert(s > 0.0f);
//		}
//	}
//#endif

	// Compute the polygon centroid.
	//m_centroid = ComputeCentroid(m_vertices, m_vertexCount);
	m_centroid.CopyFrom (ComputeCentroid(m_vertices, m_vertexCount));
}

override public function TestPoint(xf:b2Transform, p:b2Vec2):Boolean
{
	var tempV:b2Vec2 = new b2Vec2 ();
	var pLocal:b2Vec2 = new b2Vec2 ();
	
	//b2Vec2 pLocal = b2MulT(xf.R, p - xf.position);
	tempV.x = p.x - xf.position.x;
	tempV.y = p.y - xf.position.y;
	b2Math.b2MulTrans_Matrix22AndVector2_Output (xf.R, tempV, pLocal);

	for (var i:int = 0; i < m_vertexCount; ++i)
	{
		//float32 dot = b2Math.b2Dot2(m_normals[i], pLocal - m_vertices[i]);
		tempV = m_vertices[i] as b2Vec2;
		tempV.x = pLocal.x - tempV.x;
		tempV.y = pLocal.y - tempV.y;
		var dot:Number = b2Math.b2Dot2 (m_normals[i] as b2Vec2, tempV);
		if (dot > 0.0)
		{
			return false;
		}
	}

	return true;
}

override public function RayCast(output:b2RayCastOutput, input:b2RayCastInput, xf:b2Transform):void
{
	var p1:b2Vec2 = new b2Vec2 ();
	var p2:b2Vec2 = new b2Vec2 ();
	var d:b2Vec2 = new b2Vec2 ();
	var tempV:b2Vec2 = new b2Vec2 ();
	
	var lower:Number = 0.0, upper:Number = input.maxFraction;

	// Put the ray into the polygon's frame of reference.
	//b2Vec2 p1 = b2MulT(xf.R, input.p1 - xf.position);
	tempV.x = input.p1.x - xf.position.x;
	tempV.y = input.p1.y - xf.position.y;
	b2Math.b2MulTrans_Matrix22AndVector2_Output (xf.R, tempV, p1);
	//b2Vec2 p2 = b2MulT(xf.R, input.p2 - xf.position);
	tempV.x = input.p2.x - xf.position.x;
	tempV.y = input.p2.y - xf.position.y;
	b2Math.b2MulTrans_Matrix22AndVector2_Output (xf.R, tempV, p2);
	//b2Vec2 d = p2 - p1;
	d.x = p2.x - p1.x;
	d.y = p2.y - p1.y;
	var index:int = -1;

	output.hit = false;

	for (var i:int = 0; i < m_vertexCount; ++i)
	{
		// p = p1 + a * d
		// dot(normal, p - v) = 0
		// dot(normal, p1 - v) + a * dot(normal, d) = 0
		//float32 numerator = b2Math.b2Dot2(m_normals[i], m_vertices[i] - p1);
		b2Math.b2Subtract_Vector2_Output (m_vertices[i] as b2Vec2, p1, tempV);
		var numerator:Number = b2Math.b2Dot2 (m_normals[i] as b2Vec2, tempV);
		var denominator:Number = b2Math.b2Dot2 (m_normals[i] as b2Vec2, d);

		if (denominator == 0.0)
		{	
			if (numerator < 0.0)
			{
				return;
			}
		}
		else
		{
			// Note: we want this predicate without division:
			// lower < numerator / denominator, where denominator < 0
			// Since denominator < 0, we have to flip the inequality:
			// lower < numerator / denominator <==> denominator * lower > numerator.
			if (denominator < 0.0 && numerator < lower * denominator)
			{
				// Increase lower.
				// The segment enters this half-space.
				lower = numerator / denominator;
				index = i;
			}
			else if (denominator > 0.0 && numerator < upper * denominator)
			{
				// Decrease upper.
				// The segment exits this half-space.
				upper = numerator / denominator;
			}
		}

		if (upper < lower)
		{
			return;
		}
	}

	//b2Assert(0.0f <= lower && lower <= input.maxFraction);

	if (index >= 0)
	{
		output.hit = true;
		output.fraction = lower;
		//output->normal = b2Mul(xf.R, m_normals[index]);
		b2Math.b2Mul_Matrix22AndVector2_Output (xf.R, m_normals[index] as b2Vec2, output.normal)
		return;
	}
}

override public function ComputeAABB(aabb:b2AABB, xf:b2Transform):void
{
	var lower:b2Vec2 = new b2Vec2 ();
	var upper:b2Vec2 = new b2Vec2 ();
	var v:b2Vec2 = new b2Vec2 ();
	
	//b2Vec2 lower = b2Mul(xf, m_vertices[0]);
	b2Math.b2Mul_TransformAndVector2_Output (xf, m_vertices[0] as b2Vec2, lower);
	//b2Vec2 upper = lower;
	upper.CopyFrom (lower);

	for (var i:int = 1; i < m_vertexCount; ++i)
	{
		//b2Vec2 v = b2Mul(xf, m_vertices[i]);
		b2Math.b2Mul_TransformAndVector2_Output (xf, m_vertices[i] as b2Vec2, v);
		//lower = b2Min(lower, v);
		b2Math.b2Min_Vector2_Output (lower, v, lower);
		//upper = b2Max(upper, v);
		b2Math.b2Max_Vector2_Output (upper, v, upper);
	}

	//b2Vec2 r(m_radius, m_radius);
	//aabb->lowerBound = lower - r;
	aabb.lowerBound.x = lower.x - m_radius;
	aabb.lowerBound.y = lower.y - m_radius;
	//aabb->upperBound = upper + r;
	aabb.upperBound.x = upper.x + m_radius;
	aabb.upperBound.y = upper.y + m_radius;
}

override public function ComputeMass(massData:b2MassData, density:Number):void
{
	// Polygon mass, centroid, and inertia.
	// Let rho be the polygon density in mass per unit area.
	// Then:
	// mass = rho * int(dA)
	// centroid.x = (1/mass) * rho * int(x * dA)
	// centroid.y = (1/mass) * rho * int(y * dA)
	// I = rho * int((x*x + y*y) * dA)
	//
	// We can compute these integrals by summing all the integrals
	// for each triangle of the polygon. To evaluate the integral
	// for a single triangle, we make a change of variables to
	// the (u,v) coordinates of the triangle:
	// x = x0 + e1x * u + e2x * v
	// y = y0 + e1y * u + e2y * v
	// where 0 <= u && 0 <= v && u + v <= 1.
	//
	// We integrate u from [0,1-v] and then v from [0,1].
	// We also need to use the Jacobian of the transformation:
	// D = cross(e1, e2)
	//
	// Simplification: triangle centroid = (1/3) * (p1 + p2 + p3)
	//
	// The rest of the derivation is handled by computer algebra.

	var tempV:b2Vec2 = new b2Vec2 ();
	var center:b2Vec2 = new b2Vec2 ();
	var pRef:b2Vec2 = new b2Vec2 ();
	var e1:b2Vec2 = new b2Vec2 ();
	var e2:b2Vec2 = new b2Vec2 ();
	var tempF:Number;
	
	//b2Assert(m_vertexCount >= 2);

	// A line segment has zero mass.
	if (m_vertexCount == 2)
	{
		//massData->center = 0.5f * (m_vertices[0] + m_vertices[1]);
		b2Math.b2Add_Vector2_Output (m_vertices[0] as b2Vec2, m_vertices[1] as b2Vec2, tempV)
		massData.center.x = 0.5 * tempV.x;
		massData.center.y = 0.5 * tempV.y;
		massData.mass = 0.0;
		massData.I = 0.0;
		return;
	}

	//b2Vec2 center; center.Set(0.0f, 0.0f);
	center.Set(0.0, 0.0);
	var area:Number = 0.0;
	var I:Number = 0.0;

	// pRef is the reference point for forming triangles.
	// It's location doesn't change the result (except for rounding error).
	//b2Vec2 pRef(0.0f, 0.0f);
	pRef.Set (0.0, 0.0);
//#if 0
//	// This code would put the reference point inside the polygon.
//	for (int32 i = 0; i < m_vertexCount; ++i)
//	{
//		pRef += m_vertices[i];
//	}
//	pRef *= 1.0f / count;
//#endif

	const k_inv3:Number = 1.0 / 3.0;

	for (var i:int = 0; i < m_vertexCount; ++i)
	{
		// Triangle vertices.
		//b2Vec2 p1 = pRef;
		//b2Vec2 p2 = m_vertices[i];
		//b2Vec2 p3 = i + 1 < m_vertexCount ? m_vertices[i+1] : m_vertices[0];
		var p1:b2Vec2 = pRef; // .CopyFrom ()
		var p2:b2Vec2 = m_vertices[i]; // .CopyFrom ()
		var p3:b2Vec2 = i + 1 < m_vertexCount ? m_vertices[i+1] : m_vertices[0]; // .CopyFrom ()

		//b2Vec2 e1 = p2 - p1;
		e1.x = p2.x - p1.x;
		e1.y = p2.y - p1.y;
		//b2Vec2 e2 = p3 - p1;
		e2.x = p3.x - p1.x;
		e2.y = p3.y - p1.y;

		var D:Number = b2Math.b2Cross2 (e1, e2);

		var triangleArea:Number = 0.5 * D;
		area += triangleArea;

		// Area weighted centroid
		//center += triangleArea * k_inv3 * (p1 + p2 + p3);
		tempF = triangleArea * k_inv3;
		center.x += tempF * (p1.x + p2.x + p3.x);
		center.y += tempF * (p1.y + p2.y + p3.y);

		var px:Number = p1.x, py:Number = p1.y;
		var ex1:Number = e1.x, ey1:Number = e1.y;
		var ex2:Number = e2.x, ey2:Number = e2.y;

		var intx2:Number = k_inv3 * (0.25 * (ex1*ex1 + ex2*ex1 + ex2*ex2) + (px*ex1 + px*ex2)) + 0.5*px*px;
		var inty2:Number = k_inv3 * (0.25 * (ey1*ey1 + ey2*ey1 + ey2*ey2) + (py*ey1 + py*ey2)) + 0.5*py*py;

		I += D * (intx2 + inty2);
	}

	// Total mass
	massData.mass = density * area;

	// Center of mass
	//b2Assert(area > B2_FLT_EPSILON);
	//center *= 1.0f / area;
	tempF = 1.0 / area;
	center.x *= tempF;
	center.y *= tempF;
	massData.center.CopyFrom (center);

	// Inertia tensor relative to the local origin.
	massData.I = density * I;
}
