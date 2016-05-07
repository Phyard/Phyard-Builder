/*
* Copyright (c) 2007-2009 Erin Catto http://www.box2d.org
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

//#include <Box2D/Collision/b2Collision.h>



public static function b2GetPointStates(
						//b2PointState state1[b2_maxManifoldPoints], b2PointState state2[b2_maxManifoldPoints],
						state1:Array, state2:Array,
						manifold1:b2Manifold, manifold2:b2Manifold
						):void
{
	var i:int;
	var j:int;
	//var id:b2ContactID;
	var id:uint;

	for (i = 0; i < b2Settings.b2_maxManifoldPoints; ++i)
	{
		state1[i] = b2_nullState;
		state2[i] = b2_nullState;
	}

	// Detect persists and removes.
	for (i = 0; i < manifold1.pointCount; ++i)
	{
		//id = (manifold1.m_points[i] as b2ManifoldPoint).m_id.Clone ();
		id = (manifold1.points[i] as b2ManifoldPoint).id;

		state1[i] = b2_removeState;

		for (j = 0; j < manifold2.pointCount; ++j)
		{
			//if ((manifold2.m_points[j] as b2ManifoldPoint).m_id.key == id.key)
			if ((manifold2.points[j] as b2ManifoldPoint).id == id)
			{
				state1[i] = b2_persistState;
				break;
			}
		}
	}

	// Detect persists and adds.
	for (i = 0; i < manifold2.pointCount; ++i)
	{
		//id = (manifold2.m_points[i] as b2ManifoldPoint).m_id.Clone ();
		id = (manifold2.points[i] as b2ManifoldPoint).id;

		state2[i] = b2_addState;

		for (j = 0; j < manifold1.pointCount; ++j)
		{
			//if ((manifold1.m_points[j] as b2ManifoldPoint).m_id.key == id.key)
			if ((manifold1.points[j] as b2ManifoldPoint).id == id)
			{
				state2[i] = b2_persistState;
				break;
			}
		}
	}
}

// Collision Detection in Interactive 3D Environments by Gino van den Bergen
// From Section 3.4.1
// x = mu1 * p1 + mu2 * p2
// mu1 + mu2 = 1 && mu1 >= 0 && mu2 >= 0
// mu1 = 1 - mu2;
// x = (1 - mu2) * p1 + mu2 * p2
//   = p1 + mu2 * (p2 - p1)
// x = s + a * r (s := start, r := end - start)
// s + a * r = p1 + mu2 * d (d := p2 - p1)
// -a * r + mu2 * d = b (b := s - p1)
// [-r d] * [a; mu2] = b
// Cramer's rule:
// denom = det[-r d]
// a = det[b d] / denom
// mu2 = det[-r b] / denom
//bool b2Segment::TestSegment(float32* lambda, b2Vec2* normal, const b2Segment& segment, float32 maxLambda) const
//{
//	b2Vec2 s = segment.p1;
//	b2Vec2 r = segment.p2 - s;
//	b2Vec2 d = p2 - p1;
//	b2Vec2 n = b2Math.b2Cross2(d, 1.0f);
//
//	const float32 k_slop = 100.0f * B2_FLT_EPSILON;
//	float32 denom = -b2Dot(r, n);
//
//	// Cull back facing collision and ignore parallel segments.
//	if (denom > k_slop)
//	{
//		// Does the segment intersect the infinite line associated with this segment?
//		b2Vec2 b = s - p1;
//		float32 a = b2Math.b2Dot2(b, n);
//
//		if (0.0f <= a && a <= maxLambda * denom)
//		{
//			float32 mu2 = -r.x * b.y + r.y * b.x;
//b2Manifold
//			// Does the segment intersect this segment?
//			if (-k_slop * denom <= mu2 && mu2 <= denom * (1.0f + k_slop))
//			{
//				a /= denom;
//				n.Normalize();
//				*lambda = a;
//				*normal = n;
//				return true;
//			}
//		}
//	}
//
//	return false;
//}

// From Real-time Collision Detection, p179.
//void b2AABB::RayCast(b2RayCastOutput* output, const b2RayCastInput& input) const
//{
//	float32 tmin = - b2Settings.B2_FLT_MAX;
//	float32 tmax = b2Settings.B2_FLT_MAX;
//
//	output->hit = false;
//
//	b2Vec2 p = input.p1;
//	b2Vec2 d = input.p2 - input.p1;
//	b2Vec2 absD = b2Abs(d);
//
//	b2Vec2 normal;
//
//	for (int32 i = 0; i < 2; ++i)
//	{
//		if (absD(i) < b2Settings.B2_FLT_EPSILON)
//		{
//			// Parallel.
//			if (p(i) < lowerBound(i) || upperBound(i) < p(i))
//			{
//				return;
//			}
//		}
//		else
//		{
//			float32 inv_d = 1.0f / d(i);
//			float32 t1 = (lowerBound(i) - p(i)) * inv_d;
//			float32 t2 = (upperBound(i) - p(i)) * inv_d;
//
//			// Sign of the normal vector.
//			float32 s = -1.0f;
//
//			if (t1 > t2)
//			{
//				b2Swap(t1, t2);
//				s = 1.0f;
//			}
//
//			// Push the min up
//			if (t1 > tmin)
//			{
//				normal.SetZero();
//				normal(i) = s;
//				tmin = t1;
//			}
//
//			// Pull the max down
//			tmax = b2Min(tmax, t2);
//
//			if (tmin > tmax)
//			{
//				return;
//			}
//		}
//	}
//
//	// Does the ray start inside the box?
//	// Does the ray intersect beyond the max fraction?
//	if (tmin < 0.0f || input.maxFraction < tmin)
//	{
//		return;
//	}
//
//	// Intersection.
//	output->fraction = tmin;
//	output->normal = normal;
//	output->hit = true;
//}

// Sutherland-Hodgman clipping.
//public static function b2ClipSegmentToLine(b2ClipVertex vOut[2], const b2ClipVertex vIn[2],
//						const b2Vec2& normal, float32 offset, int32 vertexIndexA):int
public static function b2ClipSegmentToLine(vOut:b2ClipVertexSegment, vIn:b2ClipVertexSegment,
						normal:b2Vec2, offset:Number, vertexIndexA:int):int
{
	var vIn0:b2ClipVertex = vIn.clipVertex0;
	var vIn1:b2ClipVertex = vIn.clipVertex1;

	// Start with no output points
	var numOut:int = 0;

	// Calculate the distance of end points to the line
	var distance0:Number = b2Math.b2Dot2 (normal, vIn0.v) - offset;
	var distance1:Number = b2Math.b2Dot2 (normal, vIn1.v) - offset;

	// If the points are behind the plane
	if (distance0 <= 0.0) vOut.GetClipVertexById (numOut++).CopyFrom (vIn0);
	if (distance1 <= 0.0) vOut.GetClipVertexById (numOut++).CopyFrom (vIn1);

	// If the points are on different sides of the plane
	if (distance0 * distance1 < 0.0)
	{
		var vOut_numOut:b2ClipVertex = vOut.GetClipVertexById (numOut);

		// Find intersection point of edge and plane
		var interp:Number = distance0 / (distance0 - distance1);
		//vOut[numOut].v = vIn[0].v + interp * (vIn[1].v - vIn[0].v);
		vOut_numOut.v.x = vIn0.v.x + interp * (vIn1.v.x - vIn0.v.x);
		vOut_numOut.v.y = vIn0.v.y + interp * (vIn1.v.y - vIn0.v.y);

		// VertexA is hitting edgeB.
		//vOut[numOut].id.cf.indexA = vertexIndexA;
		//vOut[numOut].id.cf.indexB = vIn[0].id.cf.indexB;
		//vOut[numOut].id.cf.typeA = b2ContactFeature::e_vertex;
		//vOut[numOut].id.cf.typeB = b2ContactFeature::e_face;
		vOut_numOut.id = b2ContactID.ContactID_FromFeature (
												vertexIndexA,
												b2ContactID.ContactID_IndexB (vIn0.id),
												b2ContactID.b2ContactFeature_e_vertex,
												b2ContactID.b2ContactFeature_e_face
											);

		++numOut;
	}

	return numOut;
}

private static var mSimplexCache:b2SimplexCache = new b2SimplexCache ();
private static var mDistanceInput:b2DistanceInput = new b2DistanceInput ();
   private static var mDistanceProxyA:b2DistanceProxy = new b2DistanceProxy ();
   private static var mDistanceProxyB:b2DistanceProxy = new b2DistanceProxy ();
private static var mDistanceOutput:b2DistanceOutput = new b2DistanceOutput ();

//bool b2TestOverlap(const b2Shape* shapeA, int32 indexA,
//							const b2Shape* shapeB, int32 indexB,
//							const b2Transform& xfA, const b2Transform& xfB)
public static function b2TestOverlap_Shapes (shapeA:b2Shape, indexA:int,
															shapeB:b2Shape, indexB:int,
															xfA:b2Transform, xfB:b2Transform):Boolean
{
	var input:b2DistanceInput = mDistanceInput; //new b2DistanceInput ();
	input.proxyA = mDistanceProxyA;
	input.proxyB = mDistanceProxyB;
	input.proxyA.Set(shapeA, indexA);
	input.proxyB.Set(shapeB, indexB);
	//input.transformA.CopyFrom (xfA);
	//input.transformB.CopyFrom (xfB);
	input.transformA = xfA;
	input.transformB = xfB;
	input.useRadii = true;

	var cache:b2SimplexCache = mSimplexCache; //new b2SimplexCache ();
	cache.count = 0;

	var output:b2DistanceOutput = mDistanceOutput; //new b2DistanceOutput ();

	b2Distance.b2Distance_ (output, cache, input);

	return output.distance < 10.0 * b2Settings.b2_epsilon;
}
