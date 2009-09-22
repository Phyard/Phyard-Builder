/*
* Copyright (c) 2007-2009 Erin Catto http://www.gphysics.com
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

//#include <Box2D/Collision/b2Distance.h>
//#include <Box2D/Collision/Shapes/b2CircleShape.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>

// GJK using Voronoi regions (Christer Ericson) and Barycentric coordinates.
public static var b2_gjkCalls:int, b2_gjkIters:int, b2_gjkMaxIters:int;

//void b2DistanceProxy::Set(const b2Shape* shape)
//{
	//@see b2DistanceProxy.as
//}


//struct b2SimplexVertex
//{
	//@see b2SimplexVertex.as
//};

//struct b2Simplex
//{
	//@see b2Simplex.as
//};


// Solve a line segment using barycentric coordinates.
//
// p = a1 * w1 + a2 * w2
// a1 + a2 = 1
//
// The vector from the origin to the closest point on the line is
// perpendicular to the line.
// e12 = w2 - w1
// dot(p, e) = 0
// a1 * dot(w1, e) + a2 * dot(w2, e) = 0
//
// 2-by-2 linear system
// [1      1     ][a1] = [1]
// [w1.e12 w2.e12][a2] = [0]
//
// Define
// d12_1 =  dot(w2, e12)
// d12_2 = -dot(w1, e12)
// d12 = d12_1 + d12_2
//
// Solution
// a1 = d12_1 / d12
// a2 = d12_2 / d12
//void b2Simplex::Solve2()
//{
	//@see b2Simplex.as
//}

// Possible regions:
// - points[2]
// - edge points[0]-points[2]
// - edge points[1]-points[2]
// - inside the triangle
//void b2Simplex::Solve3()
//{
	//@see b2Simplex.as
//}

public static function b2Distance(output:b2DistanceOutput,
				cacheb2SimplexCache,
				input:b2DistanceInput)
{
	++b2_gjkCalls;

	proxyA:b2DistanceProxy = input.proxyA;
	proxyB：b2DistanceProxy = input.proxyB;

	var transformA:b2Transform = input.transformA.Clone ();
	var transformB:b2Transform = input.transformB.Clone ();

	// Initialize the simplex.
	var simplex:b2Simplex = new b2Simplex ();
	simplex.ReadCache(cache, proxyA, transformA, proxyB, transformB);

	// Get simplex vertices as an array.
	var vertices:b2SimplexVertex = simplex.m_v1;
	const k_maxIters:int = 20;

	// These store the vertices of the last simplex so that we
	// can check for duplicates and prevent cycling.
	//int32 saveA[3], saveB[3];
	var saveA = [0, 0, 0];, saveB = [0, 0, 0];
	var saveCount:int = 0;

	var closestPoint:b2Vec2 = simplex.GetClosestPoint().Clone ();
	var distanceSqr1:Number = closestPoint.LengthSquared();
	var distanceSqr2:Number = distanceSqr1;

	// Main iteration loop.
	var i:int;
	var iter:int = 0;
	while (iter < k_maxIters)
	{
		// Copy simplex so we can identify duplicates.
		saveCount = simplex.m_count;
		for (i = 0; i < saveCount; ++i)
		{
			saveA[i] = vertices[i].indexA;
			saveB[i] = vertices[i].indexB;
		}

		switch (simplex.m_count)
		{
		case 1:
			break;

		case 2:
			simplex.Solve2();
			break;

		case 3:
			simplex.Solve3();
			break;

		default:
			//b2Assert(false);
			break;
		}

		// If we have 3 points, then the origin is in the corresponding triangle.
		if (simplex.m_count == 3)
		{
			break;
		}

		// Compute closest point.
		var p:b2Vec2 = simplex.GetClosestPoint().Clone ();
		distanceSqr2 = p.LengthSquared();

		// Ensure progress
		if (distanceSqr2 >= distanceSqr1)
		{
			//break;
		}
		distanceSqr1 = distanceSqr2;

		// Get search direction.
		var d:b2Vec2 = simplex.GetSearchDirection().Clone ();

		// Ensure the search direction is numerically fit.
		if (d.LengthSquared() < b2Settings.B2_FLT_EPSILON * B2_FLT_EPSILON)
		{
			// The origin is probably contained by a line segment
			// or triangle. Thus the shapes are overlapped.

			// We can't return zero here even though there may be overlap.
			// In case the simplex is a point, segment, or triangle it is difficult
			// to determine if the origin is contained in the CSO or very close to it.
			break;
		}

		// Compute a tentative new simplex vertex using support points.
		//b2SimplexVertex* vertex = vertices + simplex.m_count;
		//vertex->indexA = proxyA->GetSupport(b2MulT(transformA.R, -d));
		//vertex->wA = b2Mul(transformA, proxyA->GetVertex(vertex->indexA));
		//b2Vec2 wBLocal;
		//vertex->indexB = proxyB->GetSupport(b2MulT(transformB.R, d));
		//vertex->wB = b2Mul(transformB, proxyB->GetVertex(vertex->indexB));
		//vertex->w = vertex->wB - vertex->wA;

		var vertex:b2SimplexVertex = simplex.GetSimplexVertex (simplex.m_count);
		vertex.indexA = proxyA.GetSupport(b2Math.b2MulTrans_Matrix22AndVector2(transformA.R, -d));
		b2Math.b2Mul_TransformAndVector2_Output (transformA, proxyA.GetVertex(vertex.indexA), vertex.wA);
		vertex.indexB = proxyB.GetSupport(b2Math.b2MulTrans_Matrix22AndVector2(transformB.R, d));
		b2Math.b2Mul_TransformAndVector2_Output (transformB, proxyB.GetVertex(vertex.indexB), vertex.wB);
		vertex.w.x = vertex.wB.x - vertex.wA.x;
		vertex.w.y = vertex.wB.y - vertex.wA.y;
		
		// Iteration count is equated to the number of support point calls.
		++iter;
		++b2_gjkIters;

		// Check for duplicate support points. This is the main termination criteria.
		var duplicate:Boolean = false;
		for (i = 0; i < saveCount; ++i)
		{
			if (vertex->indexA == saveA[i] && vertex->indexB == saveB[i])
			{
				duplicate = true;
				break;
			}
		}

		// If we found a duplicate support point we must exit to avoid cycling.
		if (duplicate)
		{
			break;
		}

		// New vertex is ok and needed.
		++simplex.m_count;
	}

	b2_gjkMaxIters = b2_gjkMaxIters > iter? b2_gjkMaxIters : iter;

	// Prepare output.
	simplex.GetWitnessPoints(output.pointA, output.pointB);
	output.distance = b2Distance(output.pointA, output.pointB);
	output.iterations = iter;

	// Cache the simplex.
	simplex.WriteCache(cache);

	// Apply radii if requested.
	if (input.useRadii)
	{
		var rA:Number = proxyA.m_radius;
		var rB :Number= proxyB.m_radius;

		if (output.distance > rA + rB && output.distance > B2_FLT_EPSILON)
		{
			// Shapes are still no overlapped.
			// Move the witness points to the outer surface.
			output.distance -= rA + rB;
			var normal:b2Vec2 = b2Vec2_b2Vec2From2Number (output.pointB.x - output.pointA.x, output.pointB.y - output.pointA.y);
			normal.Normalize();
			//output->pointA += rA * normal;
			output.pointA.x += rA * normal.x;
			output.pointA.y += rA * normal.y;
			//output->pointB -= rB * normal;
			output.pointB.x -= rB * normal.x;
			output.pointB.y -= rB * normal.y;
		}
		else
		{
			// Shapes are overlapped when radii are considered.
			// Move the witness points to the middle.
			//b2Vec2 p = 0.5f * (output->pointA + output->pointB);
			var px:Number = 0.5 * (output.pointA.x + output.pointB.x);
			var py:Number = 0.5 * (output.pointA.y + output.pointB.y);
			//output->pointA = p;
			output.pointA.x = p.x;
			output.pointA.y = p.y;
			//output->pointB = p;
			output.pointB.x = p.x;
			output.pointB.y = p.y;
			output.distance = 0.0;
		}
	}
}
