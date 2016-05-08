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
	   private static var tempV:b2Vec2 = new b2Vec2 ();
	
		public function Initialize(cc:b2ContactConstraint, index:int):void
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
						//normal = pointB - pointA;
						normal.x = pointB.x - pointA.x;
						normal.y = pointB.y - pointA.y;
						normal.Normalize();
					}
					else
					{
						normal.Set(1.0, 0.0);
					}

					//point = 0.5f * (pointA + pointB);
					point.x = 0.5 * (pointA.x + pointB.x);
					point.y = 0.5 * (pointA.y + pointB.y);
					//separation = b2Dot(pointB - pointA, normal) - cc->radiusA - cc->radiusB;
					tempV.x = pointB.x - pointA.x;
					tempV.y = pointB.y - pointA.y;
					separation = b2Math.b2Dot2 (tempV, normal) - cc.radiusA - cc.radiusB;
				}
				break;

			case b2Manifold.e_faceA:
				{
					cc.bodyA.GetWorldVector_Output (cc.localNormal, normal);
					cc.bodyA.GetWorldPoint_Output (cc.localPoint, planePoint);

					cc.bodyB.GetWorldPoint_Output (cc.points[index].localPoint, clipPoint);
					tempV.x = clipPoint.x - planePoint.x;
					tempV.y = clipPoint.y - planePoint.y;
					separation = b2Math.b2Dot2(tempV, normal) - cc.radiusA - cc.radiusB;
					point.x = clipPoint.x;
					point.y = clipPoint.y;
				}
				break;

			case b2Manifold.e_faceB:
				{
					cc.bodyB.GetWorldVector_Output (cc.localNormal, normal); // in fact, can direct reference
					cc.bodyB.GetWorldPoint_Output(cc.localPoint, planePoint);

					cc.bodyA.GetWorldPoint_Output (cc.points[index].localPoint, clipPoint);
					tempV.x = clipPoint.x - planePoint.x;
					tempV.y = clipPoint.y - planePoint.y;
					separation = b2Math.b2Dot2 (tempV, normal) - cc.radiusA - cc.radiusB;
					point.x = clipPoint.x;
					point.y = clipPoint.y;

					// Ensure normal points from A to B
					//normal = -normal;
					normal.x = -normal.x;
					normal.y = -normal.y;
				}
				break;
			}
		}

		public var normal:b2Vec2 = new b2Vec2 ();
		public var point:b2Vec2 = new b2Vec2 ();
		public var separation:Number;
	} // class
} // package
