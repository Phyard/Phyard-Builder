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

//#include <Box2D/Collision/b2Collision.h>
//#include <Box2D/Collision/Shapes/b2CircleShape.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>

//private static var d:b2Vec2 = new b2Vec2 ();
private static var p1:b2Vec2 = new b2Vec2 ();
private static var p2:b2Vec2 = new b2Vec2 ();
private static var c:b2Vec2 = new b2Vec2 ();
private static var cLocal:b2Vec2 = new b2Vec2 ();
private static var temp1:b2Vec2 = new b2Vec2 ();
private static var temp2:b2Vec2 = new b2Vec2 ();

public static function b2CollideCircles(
	manifold:b2Manifold,
	circle1:b2CircleShape, xf1:b2Transform,
circle2:b2CircleShape, xf2:b2Transform):void
{
	manifold.m_pointCount = 0;

	b2Math.b2Mul_TransformAndVector2_Output (xf1, circle1.m_p, p1);
	b2Math.b2Mul_TransformAndVector2_Output (xf2, circle2.m_p, p2);

	d.x = p2.x - p1.x;
	d.y = p2.y - p1.y;
	var distSqr:Number = b2Math.b2Dot2 (d, d);
	var radius:Number = circle1.m_radius + circle2.m_radius;
	if (distSqr > radius * radius)
	{
		return;
	}

	manifold.m_type = b2Manifold.e_circles;
	manifold.m_localPoint.CopyFrom (circle1.m_p);
	manifold.m_localPlaneNormal.SetZero();
	manifold.m_pointCount = 1;

	(manifold.m_points[0] as b2ManifoldPoint).m_localPoint.CopyFrom ( circle2.m_p);
	//(manifold.m_points[0] as b2ManifoldPoint).m_id.key = 0;
	(manifold.m_points[0] as b2ManifoldPoint).m_id = 0;
}

public static function b2CollidePolygonAndCircle(
	manifold:b2Manifold,
	polygon:b2PolygonShape, xf1:b2Transform,
circle:b2CircleShape, xf2:b2Transform):void
{
	manifold.m_pointCount = 0;

	// Compute circle position in the frame of the polygon.
	b2Math.b2Mul_TransformAndVector2_Output (xf2, circle.m_p, c);
	b2Math.b2MulT_TransformAndVector2_Output (xf1, c, cLocal);

	// Find the min separating edge.
	var normalIndex:int = 0;
	var separation:Number = - b2Settings.b2_maxFloat;
	var radius:Number = polygon.m_radius + circle.m_radius;
	var vertexCount:int = polygon.m_vertexCount;
	//const b2Vec2* vertices = polygon->m_vertices;
	//const b2Vec2* normals = polygon->m_normals;
	var vertices:Array = polygon.m_vertices;
	var normals:Array = polygon.m_normals;

	for (var i:int = 0; i < vertexCount; ++i)
	{
		var s:Number = b2Math.b2Dot2 (normals[i], b2Math.b2Subtract_Vector2 (cLocal, vertices[i]));

		if (s > radius)
		{
			// Early out.
			return;
		}

		if (s > separation)
		{
			separation = s;
			normalIndex = i;
		}
	}

	// Vertices that subtend the incident face.
	var vertIndex1:int = normalIndex;
	var vertIndex2:int = vertIndex1 + 1 < vertexCount ? vertIndex1 + 1 : 0;
	var v1:b2Vec2 = vertices[vertIndex1]; //.Clone ()
	var v2:b2Vec2 = vertices[vertIndex2]; //.Clone ()

	// If the center is inside the polygon ...
	if (separation < b2Settings.b2_epsilon)
	{
		manifold.m_pointCount = 1;
		manifold.m_type = b2Manifold.e_faceA;
		manifold.m_localPlaneNormal.CopyFrom (normals[normalIndex]);
		//manifold.m_localPoint = 0.5 * (v1 + v2);
		manifold.m_localPoint.x = 0.5 * (v1.x + v2.x);
		manifold.m_localPoint.y = 0.5 * (v1.y + v2.y);
		(manifold.m_points[0] as b2ManifoldPoint).m_localPoint.CopyFrom (circle.m_p);
		//(manifold.m_points[0] as b2ManifoldPoint).m_id.key = 0;
		(manifold.m_points[0] as b2ManifoldPoint).m_id = 0;
		return;
	}

	// Compute barycentric coordinates
	//var u1:Number = b2Math.b2Dot2 (cLocal - v1, v2 - v1);
	//var u2:Number = b2Math.b2Dot2 (cLocal - v2, v1 - v2);
	
	temp1.x = cLocal.x - v1.x; temp1.y = cLocal.y - v1.y;
	temp2.x = v2.x     - v1.x; temp2.y =  v2.y     - v1.y;
	var u1:Number = b2Math.b2Dot2 (temp1, temp2);
	temp1.x = cLocal.x - v2.x; temp1.y = cLocal.y - v2.y;
	temp2.x =       - temp2.x; temp2.y =       - temp2.y;
	var u2:Number = b2Math.b2Dot2 (temp1, temp2);
	
	if (u1 <= 0.0)
	{
		if (b2Math.b2DistanceSquared(cLocal, v1) > radius * radius)
		{
			return;
		}

		manifold.m_pointCount = 1;
		manifold.m_type = b2Manifold.e_faceA;
		manifold.m_localPlaneNormal.Set (cLocal.x - v1.x, cLocal.y - v1.y)
		manifold.m_localPlaneNormal.Normalize();
		manifold.m_localPoint.CopyFrom (v1);
		(manifold.m_points[0] as b2ManifoldPoint).m_localPoint.CopyFrom (circle.m_p);
		//(manifold.m_points[0] as b2ManifoldPoint).m_id.key = 0;
		(manifold.m_points[0] as b2ManifoldPoint).m_id = 0;
	}
	else if (u2 <= 0.0)
	{
		if (b2Math.b2DistanceSquared(cLocal, v2) > radius * radius)
		{
			return;
		}

		manifold.m_pointCount = 1;
		manifold.m_type = b2Manifold.e_faceA;
		manifold.m_localPlaneNormal.Set (cLocal.x - v2.x, cLocal.y - v2.y);
		manifold.m_localPlaneNormal.Normalize();
		manifold.m_localPoint.CopyFrom (v2);
		(manifold.m_points[0] as b2ManifoldPoint).m_localPoint.CopyFrom (circle.m_p);
		//(manifold.m_points[0] as b2ManifoldPoint).m_id.key = 0;
		(manifold.m_points[0] as b2ManifoldPoint).m_id = 0;
	}
	else
	{
		//b2Vec2 faceCenter = 0.5f * (v1 + v2);
		//float32 separation = b2Math.b2Dot2(cLocal - faceCenter, normals[vertIndex1]);
		var faceCenter:b2Vec2 = temp1;
		faceCenter.x = 0.5 * (v1.x + v2.x);
		faceCenter.y = 0.5 * (v1.y + v2.y);
		temp2.x = cLocal.x - faceCenter.x;
		temp2.y = cLocal.y - faceCenter.y;
		separation = b2Math.b2Dot2 (temp2, normals[vertIndex1]);
		if (separation > radius)
		{
			return;
		}

		manifold.m_pointCount = 1;
		manifold.m_type = b2Manifold.e_faceA;
		manifold.m_localPlaneNormal.CopyFrom (normals[vertIndex1]);
		manifold.m_localPoint.CopyFrom (faceCenter);
		(manifold.m_points[0] as b2ManifoldPoint).m_localPoint.CopyFrom (circle.m_p);
		//(manifold.m_points[0] as b2ManifoldPoint).m_id.key = 0;
		(manifold.m_points[0] as b2ManifoldPoint).m_id = 0;
	}
}
