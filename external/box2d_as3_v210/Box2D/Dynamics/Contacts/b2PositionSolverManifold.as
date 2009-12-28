package Box2D.Dynamics.Contacts
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Collision.b2Manifold;
	
	public class b2PositionSolverManifold
	{
	   private static var pointA:b2Vec2 = new b2Vec2 ();
	   private static var pointB:b2Vec2 = new b2Vec2 ();
	   private static var planePoint:b2Vec2 = new b2Vec2 ();
	   private static var clipPoint:b2Vec2 = new b2Vec2 ();
	
		public function Initialize(cc:b2ContactConstraint):void
		{
			var i:int;
			
			//b2Assert(cc->pointCount > 0);

			switch (cc.type)
			{
			case b2Manifold.e_circles:
				{
					cc.bodyA.GetWorldPoint_Output(cc.localPoint, pointA);
					cc.bodyB.GetWorldPoint_Output( (cc.points[0] as b2ContactConstraintPoint).localPoint, pointB);
					if (b2Math.b2DistanceSquared(pointA, pointB) > b2Settings.b2_epsilon * b2Settings.b2_epsilon)
					{
						//m_normal = pointB - pointA;
						m_normal.x = pointB.x - pointA.x;
						m_normal.y = pointB.y - pointA.y;
						m_normal.Normalize();
					}
					else
					{
						m_normal.Set(1.0, 0.0);
					}

					(m_points[0] as b2Vec2).Set (0.5 * (pointA.x + pointB.x), 0.5 * (pointA.y + pointB.y));
					//m_separations[0] = b2Math.b2Dot2(pointB - pointA, m_normal) - cc->radius;
					pointB.x -= pointA.x;
					pointB.y -= pointA.y;
					m_separations[0] = b2Math.b2Dot2 (pointB, m_normal) - cc.radius;
				}
				break;

			case b2Manifold.e_faceA:
				{
					cc.bodyA.GetWorldVector_Output (cc.localPlaneNormal, m_normal);
					cc.bodyA.GetWorldPoint_Output (cc.localPoint, planePoint);

					for (i = 0; i < cc.pointCount; ++i)
					{
						cc.bodyB.GetWorldPoint_Output ( (cc.points[i] as b2ContactConstraintPoint).localPoint, clipPoint);
						//m_separations[i] = b2Math.b2Dot2(clipPoint - planePoint, m_normal) - cc->radius;
						//m_points[i] = clipPoint;
						(m_points[i] as b2Vec2).CopyFrom (clipPoint);
						clipPoint.x -= planePoint.x;
						clipPoint.y -= planePoint.y;
						m_separations[i] = b2Math.b2Dot2 (clipPoint, m_normal) - cc.radius;
					}
				}
				break;

			case b2Manifold.e_faceB:
				{
					cc.bodyB.GetWorldVector_Output (cc.localPlaneNormal, m_normal); // in fact, can direct reference
					cc.bodyB.GetWorldPoint_Output(cc.localPoint, planePoint);

					for (i = 0; i < cc.pointCount; ++i)
					{
						cc.bodyA.GetWorldPoint_Output ((cc.points[i] as b2ContactConstraintPoint).localPoint, clipPoint);
						//m_separations[i] = b2Math.b2Dot2(clipPoint - planePoint, m_normal) - cc->radius;
						//m_points[i] = clipPoint;
						(m_points[i] as b2Vec2).CopyFrom (clipPoint);
						clipPoint.x -= planePoint.x;
						clipPoint.y -= planePoint.y;
						m_separations[i] = b2Math.b2Dot2 (clipPoint, m_normal) - cc.radius;
					}

					// Ensure normal points from A to B
					//m_normal = -m_normal;
					m_normal.x = -m_normal.x;
					m_normal.y = -m_normal.y;
				}
				break;
			}
		}
		
		public function b2PositionSolverManifold ()
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; ++ i)
			{
				m_points [i] = new b2Vec2 ();
				//m_separations [i] = 0.0;
			}
		}

		public var m_normal:b2Vec2 = new b2Vec2 ();
		public var m_points:Array = new Array (b2Settings.b2_maxManifoldPoints);
		public var m_separations:Array = new Array (b2Settings.b2_maxManifoldPoints);
	} // class
} // package
