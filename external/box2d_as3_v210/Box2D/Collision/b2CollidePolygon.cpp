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

//#include <Box2D/Collision/b2Collision.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>

// Find the separation between poly1 and poly2 for a give edge normal on poly1.
public static function b2EdgeSeparation(poly1:b2PolygonShape, xf1:b2Transform, edge1:int,
							  poly2:b2PolygonShape, xf2:b2Transform):Number
{
	var count1:int = poly1.m_vertexCount;
	//const b2Vec2* vertices1 = poly1->m_vertices;
	//const b2Vec2* normals1 = poly1->m_normals;
	var vertices1:Array = poly1.m_vertices;
	var normals1:Array = poly1.m_normals;

	var count2:int = poly2.m_vertexCount;
	//const b2Vec2* vertices2 = poly2->m_vertices;
	var vertices2:Array = poly2.m_vertices;

	//b2Assert(0 <= edge1 && edge1 < count1);

	// Convert normal from poly1's frame into poly2's frame.
	var normal1World:b2Vec2 = b2Math.b2Mul_Matrix22AndVector2 (xf1.R, normals1[edge1]);
	var normal1:b2Vec2 = b2Math.b2MulTrans_Matrix22AndVector2 (xf2.R, normal1World);

	// Find support vertex on poly2 for -normal.
	var index:int = 0;
	var minDot:Number = b2Settings.B2_FLT_MAX;

	for (var i:int = 0; i < count2; ++i)
	{
		var dot:Number = b2Math.b2Dot2(vertices2[i], normal1);
		if (dot < minDot)
		{
			minDot = dot;
			index = i;
		}
	}

	var v1:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (xf1, vertices1[edge1]);
	var v2:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (xf2, vertices2[index]);
	//var separation:Number = b2Math.b2Dot2(v2 - v1, normal1World);
	v2.SubtractWith (v1);
	var separation:Number = b2Math.b2Dot2(v2, normal1World);

	return separation;
}

// Find the max separation between poly1 and poly2 using edge normals from poly1.
//static float32 b2FindMaxSeparation(int32* edgeIndex,
//								 const b2PolygonShape* poly1, const b2Transform& xf1,
//								 const b2PolygonShape* poly2, const b2Transform& xf2)
public static function b2FindMaxSeparation(maxSeparation:b2Separation, //int32* edgeIndex,
								 poly1:b2PolygonShape, xf1:b2Transform,
								 poly2:b2PolygonShape, xf2:b2Transform):void
{
	var count1:int = poly1.m_vertexCount;
	//const b2Vec2* normals1 = poly1->m_normals;
	var normals1:Array = poly1.m_normals;

	// Vector pointing from the centroid of poly1 to the centroid of poly2.
	//b2Vec2 d = b2Mul(xf2, poly2->m_centroid) - b2Mul(xf1, poly1->m_centroid);
	//b2Vec2 dLocal1 = b2MulT(xf1.R, d);
	var d:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (xf2, poly2.m_centroid);
	var dLocal1:b2Vec2 = b2Math.b2Mul_TransformAndVector2 (xf1, poly1.m_centroid);
	d.SubtractWith (dLocal1);
	b2Math.b2MulTrans_Matrix22AndVector2_Output (xf1.R, d, dLocal1);

	// Find edge normal on poly1 that has the largest projection onto d.
	var edge:int = 0;
	var maxDot:Number = - b2Settings.B2_FLT_MAX;
	for (var i:int = 0; i < count1; ++i)
	{
		var dot:Number = b2Math.b2Dot2 (normals1[i], dLocal1);
		if (dot > maxDot)
		{
			maxDot = dot;
			edge = i;
		}
	}

	// Get the separation for the edge normal.
	var s:Number = b2EdgeSeparation(poly1, xf1, edge, poly2, xf2);

	// Check the separation for the previous edge normal.
	var prevEdge:int = edge - 1 >= 0 ? edge - 1 : count1 - 1;
	var sPrev:Number = b2EdgeSeparation (poly1, xf1, prevEdge, poly2, xf2);

	// Check the separation for the next edge normal.
	var nextEdge:int = edge + 1 < count1 ? edge + 1 : 0;
	var sNext:Number = b2EdgeSeparation (poly1, xf1, nextEdge, poly2, xf2);

	// Find the best edge and the search direction.
	var bestEdge:int;
	var bestSeparation:Number;
	var increment:int;
	if (sPrev > s && sPrev > sNext)
	{
		increment = -1;
		bestEdge = prevEdge;
		bestSeparation = sPrev;
	}
	else if (sNext > s)
	{
		increment = 1;
		bestEdge = nextEdge;
		bestSeparation = sNext;
	}
	else
	{
		//*edgeIndex = edge;
		//return s;
		
		maxSeparation.edge = edge;
		maxSeparation.separation = s;
		
		//return output;
		return;
	}

	// Perform a local search for the best edge normal.
	for ( ; ; )
	{
		if (increment == -1)
			edge = bestEdge - 1 >= 0 ? bestEdge - 1 : count1 - 1;
		else
			edge = bestEdge + 1 < count1 ? bestEdge + 1 : 0;

		s = b2EdgeSeparation(poly1, xf1, edge, poly2, xf2);

		if (s > bestSeparation)
		{
			bestEdge = edge;
			bestSeparation = s;
		}
		else
		{
			break;
		}
	}

	//*edgeIndex = bestEdge;
	//return bestSeparation;

	maxSeparation.edge = bestEdge;
	maxSeparation.separation = bestSeparation;
	
	//return output;
}

public static function b2FindIncidentEdge(c:b2ClipVertexSegment, //b2ClipVertex c[2],
							 poly1:b2PolygonShape, xf1:b2Transform, edge1:int,
							 poly2:b2PolygonShape, xf2:b2Transform):void
{
	var count1:int = poly1.m_vertexCount;
	//const * normals1 = poly1->m_normals;
	var normals1:Array = poly1.m_normals;

	var count2:int = poly2.m_vertexCount;
	//const b2Vec2* vertices2 = poly2->m_vertices;
	//const b2Vec2* normals2 = poly2->m_normals;
	var vertices2:Array = poly2.m_vertices;
	var normals2:Array = poly2.m_normals;

	//b2Assert(0 <= edge1 && edge1 < count1);

	// Get the normal of the reference edge in poly2's frame.
	//b2Vec2 normal1 = b2MulT(xf2.R, b2Mul(xf1.R, normals1[edge1]));
	var normal1:b2Vec2 = b2Math.b2MulTrans_Matrix22AndVector2 (xf2.R, b2Math.b2Mul_Matrix22AndVector2 (xf1.R, normals1[edge1]));

	// Find the incident edge on poly2.
	var index:int = 0;
	var minDot:Number = b2Settings.B2_FLT_MAX;
	for (var i:int = 0; i < count2; ++i)
	{
		var dot:Number = b2Math.b2Dot2 (normal1, normals2[i]);
		if (dot < minDot)
		{
			minDot = dot;
			index = i;
		}
	}

	// Build the clip vertices for the incident edge.
	var i1:int = index;
	var i2:int = i1 + 1 < count2 ? i1 + 1 : 0;

	//c[0].v = b2Mul(xf2, vertices2[i1]);
	//c[0].id.features.referenceEdge = (uint8)edge1;
	//c[0].id.features.incidentEdge = (uint8)i1;
	//c[0].id.features.incidentVertex = 0;
	var c0:b2ClipVertex = c.GetClipVertexById (0);
	b2Math.b2Mul_TransformAndVector2_Output (xf2, vertices2[i1], c0.v);
	c0.id.SetFeatures (edge1, i1, 0);

	//c[1].v = b2Mul(xf2, vertices2[i2]);
	//c[1].id.features.referenceEdge = (uint8)edge1;
	//c[1].id.features.incidentEdge = (uint8)i2;
	//c[1].id.features.incidentVertex = 1;
	var c1:b2ClipVertex = c.GetClipVertexById (1);
	b2Math.b2Mul_TransformAndVector2_Output (xf2, vertices2[i2], c1.v);
	c1.id.SetFeatures (edge1, i2, 1);
}

// Find edge normal of max separation on A - return if separating axis is found
// Find edge normal of max separation on B - return if separation axis is found
// Choose reference edge as min(minA, minB)
// Find incident edge
// Clip

// The normal points from 1 to 2
public static function b2CollidePolygons(manifold:b2Manifold,
					  polyA:b2PolygonShape, xfA:b2Transform,
					  polyB:b2PolygonShape, xfB:b2Transform):void
{
	manifold.m_pointCount = 0;
	var totalRadius:Number = polyA.m_radius + polyB.m_radius;

	//var edgeA:int = 0;
	var maxSeparation:b2Separation = new b2Separation ();
	//var separationA:Number = b2FindMaxSeparation(&edgeA, polyA, xfA, polyB, xfB);
	b2FindMaxSeparation(maxSeparation/*&edgeA*/, polyA, xfA, polyB, xfB);
	var separationA:Number = maxSeparation.separation;
	if (separationA > totalRadius)
		return;
	var edgeA:int = maxSeparation.edge;

	//var edgeB:int = 0;
	//float32 separationB = b2FindMaxSeparation(&edgeB, polyB, xfB, polyA, xfA);
	b2FindMaxSeparation(maxSeparation /*&edgeB*/, polyB, xfB, polyA, xfA);
	var separationB:Number = maxSeparation.separation;
	if (separationB > totalRadius)
		return;
	var edgeB:int = maxSeparation.edge;

	var poly1:b2PolygonShape;	// reference polygon
	var poly2:b2PolygonShape;	// incident polygon
	//b2Transform xf1, xf2;
	// notice: in c++ version, the 2 are values instead of references/pointers
   var xf1:b2Transform, xf2:b2Transform;
	var edge1:int;		// reference edge
	//uint8 flip;
	var flip:uint;
	const k_relativeTol:Number = 0.98;
	const k_absoluteTol:Number = 0.001;

	if (separationB > k_relativeTol * separationA + k_absoluteTol)
	{
		poly1 = polyB;
		poly2 = polyA;
		xf1 = xfB;
		xf2 = xfA;
		edge1 = edgeB;
		manifold.m_type = b2Manifold.e_faceB;
		flip = 1;
	}
	else
	{
		poly1 = polyA;
		poly2 = polyB;
		xf1 = xfA;
		xf2 = xfB;
		edge1 = edgeA;
		manifold.m_type = b2Manifold.e_faceA;
		flip = 0;
	}

	//b2ClipVertex incidentEdge[2];
	var incidentEdge:b2ClipVertexSegment = new b2ClipVertexSegment ();
	b2FindIncidentEdge(incidentEdge, poly1, xf1, edge1, poly2, xf2);

	var count1:int = poly1.m_vertexCount;
	//const b2Vec2* vertices1 = poly1->m_vertices;
	var vertices1:Array = poly1.m_vertices;

	//b2Vec2 v11 = vertices1[edge1];
	//b2Vec2 v12 = edge1 + 1 < count1 ? vertices1[edge1+1] : vertices1[0];
	// notice: can't use reference
	var v11:b2Vec2 = (vertices1[edge1] as b2Vec2).Clone ();
	var v12:b2Vec2 = edge1 + 1 < count1 ? (vertices1[edge1+1] as b2Vec2).Clone (): (vertices1[0] as b2Vec2).Clone ();

	//b2Vec2 localTangent = v12 - v11;
	var localTangent:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (v12.x - v11.x, v12.y - v11.y);
	localTangent.Normalize();
	
	//b2Vec2 localNormal = b2Math.b2Cross2(localTangent, 1.0f);
	//b2Vec2 planePoint = 0.5f * (v11 + v12);
	var localNormal:b2Vec2 = b2Math.b2Cross_Vector2AndScalar (localTangent, 1.0);
	var planePoint:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.5 * (v11.x + v12.x), 0.5 * (v11.y + v12.y));

	//b2Vec2 tangent = b2Mul(xf1.R, localTangent);
	//b2Vec2 normal = b2Math.b2Cross2(tangent, 1.0f);
	var tangent:b2Vec2 = b2Math.b2Mul_Matrix22AndVector2 (xf1.R, localTangent);
	var normal:b2Vec2  = b2Math.b2Cross_Vector2AndScalar (tangent, 1.0);
	
	v11 = b2Math.b2Mul_TransformAndVector2 (xf1, v11);
	v12 = b2Math.b2Mul_TransformAndVector2 (xf1, v12);

	// Face offset.
	var frontOffset:Number = b2Math.b2Dot2 (normal, v11);

	// Side offsets, extended by polytope skin thickness.
	var sideOffset1:Number = - b2Math.b2Dot2 (tangent, v11) + totalRadius;
	var sideOffset2:Number = b2Math.b2Dot2(tangent, v12) + totalRadius;

	// Clip incident edge against extruded edge1 side edges.
	//b2ClipVertex clipPoints1[2];
	//b2ClipVertex clipPoints2[2];
	var clipPoints1:b2ClipVertexSegment = new b2ClipVertexSegment ();
	var clipPoints2:b2ClipVertexSegment = new b2ClipVertexSegment ();
	var np:int;

	// Clip to box side 1
	//np = b2ClipSegmentToLine (clipPoints1, incidentEdge, -tangent, sideOffset1);
	np = b2ClipSegmentToLine (clipPoints1, incidentEdge, tangent.GetNegative (), sideOffset1);
	if (np < 2)
		return;

	// Clip to negative box side 1
	np = b2ClipSegmentToLine(clipPoints2, clipPoints1,  tangent, sideOffset2);
	if (np < 2)
	{
		return;
	}

	// Now clipPoints2 contains the clipped points.
	//manifold->m_localPlaneNormal = localNormal;
	//manifold->m_localPoint = planePoint;
	manifold.m_localPlaneNormal.CopyFrom (localNormal);
	manifold.m_localPoint.CopyFrom (planePoint);

	var pointCount:int = 0;
	for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++i)
	{
		var separation:Number = b2Math.b2Dot2 (normal, clipPoints2.GetClipVertexById (i).v) - frontOffset;

		if (separation <= totalRadius)
		{
			//b2ManifoldPoint* cp = manifold->m_points + pointCount;
			//cp->m_localPoint = b2MulT(xf2, clipPoints2[i].v);
			//cp->m_id = clipPoints2[i].id;
			//cp->m_id.features.flip = flip;
			var cp:b2ManifoldPoint = manifold.m_points [pointCount];
			b2Math.b2MulTrans_TransformAndVector2_Output (xf2, clipPoints2.GetClipVertexById(i).v, cp.m_localPoint)
			cp.m_id.CopyFrom (clipPoints2.GetClipVertexById (i).id);
			cp.m_id.SetFlip (flip);
			++pointCount;
		}
	}

	manifold.m_pointCount = pointCount;
}
