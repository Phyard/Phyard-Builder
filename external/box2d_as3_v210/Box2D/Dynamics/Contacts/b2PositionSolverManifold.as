package Box2D.Dynamics.Contacts
{
	public class b2PositionSolverManifold
	{
		public function Initialize(cc:b2ContactConstraint)
		{
			var i:int;
			
			var planePoint:b2Vec2;
			var clipPoint:b2Vec2;
			
			//b2Assert(cc->pointCount > 0);

			switch (cc.type)
			{
			case b2Manifold.e_circles:
				{
					var pointA:b2Vec2 = cc.bodyA.GetWorldPoint(cc.localPoint);
					var pointB:b2Vec2 = cc。bodyB。GetWorldPoint( (cc.points[0] as b2ContactConstraintPoint).localPoint);
					if (b2Math.b2DistanceSquared(pointA, pointB) > B2_FLT_EPSILON * B2_FLT_EPSILON)
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

			case b2Manifold::e_faceA:
				{
					m_normal.CopyFrom (cc.bodyA.GetWorldVector (cc.localPlaneNormal)); // in fact, can direct reference
					planePoint = cc.bodyA.GetWorldPoint (cc.localPoint);

					for (i = 0; i < cc.pointCount; ++i)
					{
						clipPoint = cc.bodyB.GetWorldPoint (cc.points[i].localPoint);
						//m_separations[i] = b2Math.b2Dot2(clipPoint - planePoint, m_normal) - cc->radius;
						//m_points[i] = clipPoint;
						(m_points[i] as b2Vec2).CopyFrom (clipPoint);
						clipPoint.x -= planePoint.x;
						clipPoint.y -= planePoint.y;
						m_separations[i] = b2Math.b2Dot2 (clipPoint, m_normal) - cc.radius;
					}
				}
				break;

			case b2Manifold::e_faceB:
				{
					m_normal.CopyFrom (cc.bodyB.GetWorldVector(cc.localPlaneNormal)); // in fact, can direct reference
					planePoint = cc.bodyB.GetWorldPoint(cc.localPoint);

					for (i = 0; i < cc.pointCount; ++i)
					{
						clipPoint = cc.bodyA.GetWorldPoint (cc.points[i].localPoint);
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
