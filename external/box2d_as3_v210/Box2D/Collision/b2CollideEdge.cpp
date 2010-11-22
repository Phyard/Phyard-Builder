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
//#include <Box2D/Collision/Shapes/b2EdgeShape.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>

//enum b2EdgeType
//{
	public static const b2_isolated:int = 0;
	public static const b2_concave:int = 1;
	public static const b2_flat:int = 2;
	public static const b2_convex:int = 3;
//};

//private static var tempV:b2Vec2 = new b2Vec2 ();

private static var Q:b2Vec2 = new b2Vec2 ();
private static var e:b2Vec2 = new b2Vec2 ();
private static var d1:b2Vec2 = new b2Vec2 ();
private static var d2:b2Vec2 = new b2Vec2 ();
private static var d3:b2Vec2 = new b2Vec2 ();
private static var e1:b2Vec2 = new b2Vec2 ();
private static var e2:b2Vec2 = new b2Vec2 ();
private static var P3:b2Vec2 = new b2Vec2 ();
private static var n:b2Vec2 = new b2Vec2 ();

// Compute contact points for edge versus circle.
// This accounts for edge connectivity.
public static function b2CollideEdgeAndCircle(manifold:b2Manifold,
							edgeA:b2EdgeShape, xfA:b2Transform,
							circleB:b2CircleShape, xfB:b2Transform):void
{
	manifold.pointCount = 0;

	// Compute circle in frame of edge
	//b2Vec2 Q = b2MulT(xfA, b2Mul(xfB, circleB->m_p));
	b2Math.b2Mul_TransformAndVector2_Output (xfB, circleB.m_p, tempV);
	b2Math.b2MulT_TransformAndVector2_Output(xfA, tempV, Q);

	//b2Vec2 A = edgeA->m_vertex1, B = edgeA->m_vertex2;
	var A:b2Vec2 = edgeA.m_vertex1, B:b2Vec2 = edgeA.m_vertex2; // hacking
	//b2Vec2 e = B - A;
	e.x = B.x - A.x;
	e.y = B.y - A.y;

	// Barycentric coordinates
	//float32 u = b2Dot(e, B - Q);
	tempV.x = B.x - Q.x;
	tempV.y = B.y - Q.y;
	var u:Number = b2Math.b2Dot2 (e, tempV);
	//float32 v = b2Dot(e, Q - A);
	tempV.x = Q.x - A.x;
	tempV.y = Q.y - A.y;
	var v:Number = b2Math.b2Dot2 (e, tempV);

	var radius:Number = edgeA.m_radius + circleB.m_radius;

	// hacking!!! see below and ref b2ContactID.as
	//b2ContactFeature cf;
	//cf.indexB = 0;
	//cf.typeB = b2ContactFeature::e_vertex;

	// Region A
	if (v <= 0.0)
	{
		//b2Vec2 P = A;
		var P1:b2Vec2 = A; // hacking
		//b2Vec2 d = Q - P;
		d1.x = Q.x - P1.x;
		d1.y = Q.y - P1.y;
		var dd1:Number = b2Math.b2Dot2(d1, d1);
		if (dd1 > radius * radius)
		{
			return;
		}

		// Is there an edge connected to A?
		if (edgeA.m_hasVertex0)
		{
			//b2Vec2 A1 = edgeA->m_vertex0;
			var A1:b2Vec2 = edgeA.m_vertex0; //hacking
			//b2Vec2 B1 = A;
			var B1:b2Vec2 = A; // hacking
			//b2Vec2 e1 = B1 - A1;
			e1.x = B1.x - A1.x;
			e1.y = B1.y - A1.y;
			//float32 u1 = b2Dot(e1, B1 - Q);
			tempV.x = B1.x - Q.x;
			tempV.y = B1.y - Q.y;
			var u1:Number = b2Math.b2Dot2 (e1, tempV);

			// Is the circle in Region AB of the previous edge?
			if (u1 > 0.0)
			{
				return;
			}
		}

		//cf.indexA = 0;
		//cf.typeA = b2ContactFeature::e_vertex;
		manifold.pointCount = 1;
		manifold.type = b2Manifold.e_circles;
		manifold.localNormal.SetZero();
		//manifold->localPoint = P;
		manifold.localPoint.x = P1.x;
		manifold.localPoint.y = P1.y;
		
		var mp1:b2ManifoldPoint = manifold.points[0] as b2ManifoldPoint;
		//manifold->points[0].id.key = 0;
		mp1.id = 0; // hacking
		//manifold->points[0].id.cf = cf;
		mp1.id = b2ContactID.ContactID_FromFeature (0, 0, b2ContactID.b2ContactFeature_e_vertex, b2ContactID.b2ContactFeature_e_vertex); // hacking, see above
		//manifold->points[0].localPoint = circleB->m_p;
		mp1.localPoint.x = circleB.m_p.x;
		mp1.localPoint.y = circleB.m_p.y;
		return;
	}
	
	// Region B
	if (u <= 0.0)
	{
		//b2Vec2 P = B;
		var P2:b2Vec2 = B; // hacking
		//b2Vec2 d = Q - P;
		d2.x = Q.x - P2.x;
		d2.y = Q.y - P2.y;
		var dd2:Number = b2Math.b2Dot2(d2, d2);
		if (dd2 > radius * radius)
		{
			return;
		}

		// Is there an edge connected to B?
		if (edgeA.m_hasVertex3)
		{
			//b2Vec2 B2 = edgeA->m_vertex3;
			var B2:b2Vec2 = edgeA.m_vertex3; // hacking
			//b2Vec2 A2 = B;
			var A2:b2Vec2 = B; // hacking
			//b2Vec2 e2 = B2 - A2;
			e2.x = B2.x - A2.x;
			e2.y = B2.y - A2.y;
			//float32 v2 = b2Dot(e2, Q - A2);
			tempV.x =  Q.x - A2.x;
			tempV.y =  Q.y - A2.y;
			var v2:Number = b2Math.b2Dot2 (e2, tempV);

			// Is the circle in Region AB of the next edge?
			if (v2 > 0.0)
			{
				return;
			}
		}

		//cf.indexA = 1;
		//cf.typeA = b2ContactFeature::e_vertex;
		manifold.pointCount = 1;
		manifold.type = b2Manifold.e_circles;
		manifold.localNormal.SetZero();
		//manifold->localPoint = P;
		manifold.localPoint.x = P2.x;
		manifold.localPoint.y = P2.y;
		
		var mp2:b2ManifoldPoint = manifold.points[0] as b2ManifoldPoint;
		//manifold->points[0].id.key = 0;
		mp2.id = 0; // hacking
		//manifold->points[0].id.cf = cf;
		mp2.id = b2ContactID.ContactID_FromFeature (1, 0, b2ContactID.b2ContactFeature_e_vertex, b2ContactID.b2ContactFeature_e_vertex); // hacking, see above
		//manifold->points[0].localPoint = circleB->m_p;
		mp2.localPoint.x = circleB.m_p.x;
		mp2.localPoint.y = circleB.m_p.y;
		return;
	}

	// Region AB
	var den:Number = b2Math.b2Dot2 (e, e);
	//b2Assert(den > 0.0f);
	//b2Vec2 P = (1.0f / den) * (u * A + v * B);
	var u_den:Number = u / den, v_den:Number = v / den;
	P3.x = (u_den * A.x + v_den * B.x);
	P3.y = (u_den * A.y + v_den * B.y);
	//b2Vec2 d = Q - P;
	d3.x = Q.x - P3.x;
	d3.y = Q.y - P3.y;
	var dd3:Number = b2Math.b2Dot2 (d3, d3);
	if (dd3 > radius * radius)
	{
		return;
	}

	//b2Vec2 n(-e.y, e.x);
	n.Set (-e.y, e.x);
	//if (b2Dot(n, Q - A) < 0.0f)
	tempV.x = Q.x - A.x;
	tempV.y = Q.y - A.y;
	if (b2Math.b2Dot2 (n, tempV) < 0.0)
	{
		n.Set(-n.x, -n.y);
	}
	n.Normalize();

	//cf.indexA = 0;
	//cf.typeA = b2ContactFeature::e_face;
	manifold.pointCount = 1;
	manifold.type = b2Manifold.e_faceA;
	manifold.localNormal.x = n.x;
	manifold.localNormal.y = n.y;
	manifold.localPoint.x = A.x;
	manifold.localPoint.y = A.y;
	
	var mp3:b2ManifoldPoint = manifold.points[0] as b2ManifoldPoint;
	//manifold->points[0].id.key = 0;
	mp3.id = 0; // hacking
	//manifold->points[0].id.cf = cf;
	mp3.id = b2ContactID.ContactID_FromFeature (0, 0, b2ContactID.b2ContactFeature_e_face, b2ContactID.b2ContactFeature_e_vertex); // hacking, see above
	//manifold->points[0].localPoint = circleB->m_p;
	mp3.localPoint.x = circleB.m_p.x;
	mp3.localPoint.y = circleB.m_p.y;
}

//struct b2EPAxis
//{
	//@see b2EPAxis.as
//};

// Edge shape plus more stuff.
//struct b2FatEdge
//{
	//@see b2FatEdge.as
//};

// This lets us treate and edge shape and a polygon in the same
// way in the SAT collider.
//struct b2EPProxy
//{
	//@see b2EPProxy.as
//};

// This class collides and edge and a polygon, taking into account edge adjacency.
//struct b2EPCollider
//{
	//@see b2EPCollider.as
//};

// not use the static optimization now, for b2EPCollider.Cunstructor do many works.
//private static var sEPCollider:b2EPCollider = new b2EPCollider

public static function b2CollideEdgeAndPolygon(	manifold:b2Manifold,
								edgeA:b2EdgeShape, xfA:b2Transform,
								polygonB:b2PolygonShape, xfB:b2Transform):void
{
	//b2EPCollider collider(edgeA, xfA, polygonB, xfB);
	var collider:b2EPCollider = new b2EPCollider (edgeA, xfA, polygonB, xfB);
	collider.Collide(manifold);
}
