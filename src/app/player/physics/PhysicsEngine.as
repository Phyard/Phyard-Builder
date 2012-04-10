
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Common.b2Vec2;
   import Box2D.Collision.b2AABB;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2ContactManager;
   
   import Box2D.Dynamics.b2ContactFilter;
   import Box2D.Dynamics.b2ContactListener;
   import Box2D.Dynamics.b2DestructionListener;
   
   import Box2D.Common.b2BlockAllocator;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointDef;
   import Box2dEx.Joint.b2eDummyJoint;
   import Box2dEx.Joint.b2eDummyJointDef;
   
   import Box2D.Common.b2Settings;
   
   import Box2D.b2WorldPool;
   
   import Box2dEx.Helper.b2eWorldAABBQueryCallback;
   import Box2dEx.Helper.b2eWorldRayCastCallback;
   import Box2dEx.Helper.b2eRayCastIntersection;
   
   import player.entity.EntityShape;
   
   public class PhysicsEngine
   {
      
//=================================================================
//   
//=================================================================
      
      internal var _b2World:b2World; // used within package
      internal var _b2GroundBody:b2Body;
      
      private var mPhysicsSimulationEnabled:Boolean;
      private var mCheckTimeOfImpact:Boolean;
      
      private var mContactListener:_ContactListener;
      private var mContactFilter:_ContactFilter;
      
      public function PhysicsEngine (pixelsPerMeter:Number, simulationEnabled:Boolean, checkTimeOfImpact:Boolean, autoSleepingEnabled:Boolean):void
      {
         mPhysicsSimulationEnabled = simulationEnabled;
         mCheckTimeOfImpact = checkTimeOfImpact;
         
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0, 0);
         
         _b2World = b2WorldPool.AllocB2World (gravity, autoSleepingEnabled, pixelsPerMeter);
         _b2World.SetContinuousPhysics (mCheckTimeOfImpact);
         
         _b2GroundBody = _b2World.CreateBody(new b2BodyDef());
         
         mContactListener = new _ContactListener ();
         _b2World.SetContactListener(mContactListener);
         
         mContactFilter = new _ContactFilter ();
         _b2World.SetContactFilter (mContactFilter);
         
         //_b2World.SetContactPreSolveListener (new _ContactPreSolveListener ());
         //_b2World.SetContactPostSolveListener (new _ContactPostSolveListener ());
         
         b2World.SetCustomJointCreateAndDestroyFunction (CreateCustomJoint, DestroyCustomJoint);
         
         //b2World.SetMixFrictionFunction (MixFriction_Fun);
      }
      
      public function SetShapeCollideFilterFunctions (shouldCollide:Function):void
      {
         mContactFilter.SetFilterFunctions (shouldCollide);
      }
      
      public function SetShapeContactEventHandlingFunctions (contactBeginFunc:Function, contactEndFunc:Function):void
      {
         mContactListener.SetHandlingFunctions (contactBeginFunc, contactEndFunc);
      }
      
      public static function CreateCustomJoint (def:b2JointDef, allocator:b2BlockAllocator = null):b2Joint
      {
         var joint:b2Joint = null;

         if (def is b2eDummyJointDef)
         {
            joint = new b2eDummyJoint (def as b2eDummyJointDef);
         }
         
         return joint;
      }
      
      public static function DestroyCustomJoint (joint:b2Joint, allocator:b2BlockAllocator = null):void
      {
         //joint->~b2Joint();
         joint.Destructor ();
         
         if (joint is b2eDummyJoint)
         {
            
         }
      }
      
      public static function MixFriction_Fun (friction1:Number, friction2:Number):Number
      {
         var f12:Number = friction1 * friction2;
         var f:Number = Math.sqrt (Math.abs (f12));
         return f12 >= 0 ? f : -f;
      }
      
//=================================================================
//   
//=================================================================
      
      private var mVelocityIterations:int = 8;
      private var mPositionIterations:int = 3;
      
      public function SetSimulationQuality (quality:uint):void
      {
         mVelocityIterations = (quality >> 8) & 0xFF;
         mPositionIterations = (quality >> 0) & 0xFF;
      }
      
      public function Update (escapedTime:Number):void
      {
         if (mGravityChanged)
         {
            WakeUpAllBodies ();
            mGravityChanged = false;
         }
         
         if (mPhysicsSimulationEnabled)
         {
            _b2World.Step (escapedTime, mVelocityIterations, mPositionIterations);
         }
         else
         {
            _b2World.Step (0.0, 1, 1);
         }
      }
      
//=================================================================
//   
//=================================================================
      
      public function Destroy ():void
      {
         if (_b2World != null)
         {
            if (_b2World.GetBodyCount () > 0)
            {
               _b2World.DestroyBody (_b2World.GetBodyList ());
            }
            
            b2WorldPool.ReleaseB2World (_b2World);
            
            _b2World = null;
            _b2GroundBody = null;
         }
      }
      
//=================================================================
//   
//=================================================================
      
      public function SetGravity (magnitude:Number, angle:Number):void
      {
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (magnitude * Math.cos (angle), magnitude * Math.sin (angle));
         
         _b2World.SetGravity (gravity);
      }
      
      private var mGravityChanged:Boolean = false;
      public function SetGravityByVector (gx:Number, gy:Number):void
      {
         var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (gx, gy);
         
         _b2World.SetGravity (gravity);
         
         mGravityChanged = true;
      }
      
      public function WakeUpAllBodies ():void
      {
         _b2World.WakeUpAllBodies ();
      }
      
      public function GetActiveMovableBodiesCount (excludeBodiesConnectedWithJoints:Boolean = false):uint
      {
         var count:int = 0;
         for (var b:b2Body = _b2World.m_bodyList; b != null; b = b.m_next)
         {
            if ( b.GetType () != b2Body.b2_dynamicBody )
               continue;
            
            if (excludeBodiesConnectedWithJoints && b.m_jointList != null)
               continue;
            
            if ( ! b.IsAwake () )
               continue;
            
            ++ count;
         }
         
         return count;
      }
      
      public function FlagForFilteringForAllContacts ():void
      {
         _b2World.FlagForFilteringForAllContacts ();
      }
      
//=================================================================
//   
//=================================================================
      
      // now, the physics package contains some references of entity package, such as PhysicsProxyBody.mEntityBody, PhysicsProxyShape.mEntityShape, PhysicsProxyJoint.mEntityJoint.
      // So this is not a perfect encapsulation. But over-encapsulating will bring some inefficiences. ...
      
      public function GetShapesAtPoint (physicsWorldX:Number, physicsWorldY:Number):Array
      {
         var vertex:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (physicsWorldX, physicsWorldY);
         
         var fixtures:Array = b2eWorldAABBQueryCallback.GetFixturesContainPoint (_b2World, vertex);
         
         var shapes:Array = new Array ();
         
         var entityShape:EntityShape;
         for (var i:int = 0; i < fixtures.length; ++ i)
         {
            entityShape = ((fixtures [i] as b2Fixture).GetUserData () as PhysicsProxyShape).GetEntityShape ();
            if (shapes.indexOf (entityShape) < 0)
            {
               shapes.push (entityShape);
            }
         }
         
         return shapes;
      }
      
      // limits: only works for convex shapes with body built  
      private function GetValidIntersectionsWithLineSegment (startPointX:Number, startPointY:Number, endPointX:Number, endPointY:Number):Array
      {
         var incomingIntersections:Array = b2eWorldRayCastCallback.GetIntersectionInfoWithLineSegment (_b2World, 
                                                             b2Vec2.b2Vec2_From2Numbers (startPointX, startPointY), 
                                                             b2Vec2.b2Vec2_From2Numbers (endPointX, endPointY));
         var outcomingIntersections:Array = b2eWorldRayCastCallback.GetIntersectionInfoWithLineSegment (_b2World, 
                                                             b2Vec2.b2Vec2_From2Numbers (endPointX, endPointY), 
                                                             b2Vec2.b2Vec2_From2Numbers (startPointX, startPointY));

         // ...
//trace ("=========================================== (" + startPointX + ", " + startPointY + ") to (" + endPointX + ", " + endPointY + ")");
         
         var shape:EntityShape;
         var intersection:b2eRayCastIntersection;
         for each (intersection in incomingIntersections)
         {
            shape = ((intersection.mFixture as b2Fixture).GetUserData () as PhysicsProxyShape).GetEntityShape ();
            intersection.mUserData = shape;
            intersection.mIsIncoming = true;
//trace ("++ in@" + intersection.mFraction + "," + shape.ToString () + ": " + shape.mTempData);
            
            shape.mTempData = 0;
         }
         for each (intersection in outcomingIntersections)
         {
            shape = ((intersection.mFixture as b2Fixture).GetUserData () as PhysicsProxyShape).GetEntityShape ();
            intersection.mUserData = shape;
            intersection.mIsIncoming = false;
            
            intersection.mFraction = 1.0 - intersection.mFraction;
//trace ("--- out@" + intersection.mFraction + "," + shape.ToString () + ": " + shape.mTempData);
            
            shape.mTempData = 0;
         }

         var allIntersections:Array = incomingIntersections.concat (outcomingIntersections);
         allIntersections.sort (IntersectionComparor);
         
         // ...
         
         if (allIntersections.length > 0)
         {
            var fixturesAtStartVertex:Array = b2eWorldAABBQueryCallback.GetFixturesContainPoint (_b2World, b2Vec2.b2Vec2_From2Numbers (startPointX, startPointY));
            var i:int;
            
            var firstIntersection:b2eRayCastIntersection = allIntersections [0] as b2eRayCastIntersection;
            //if (firstIntersection.mIsIncoming) 
            // box2d has some inaccuracy. A trick to make the result better.
            //{
               var fixturesAtHalfFirstIncomingPoint:Array = b2eWorldAABBQueryCallback.GetFixturesContainPoint (_b2World, 
                                       b2Vec2.b2Vec2_From2Numbers (0.5 * (startPointX + firstIntersection.mPoint.x), 0.5 * (startPointY + firstIntersection.mPoint.y)));
               
               var validFixturesAtStartVertex:Array = new Array ();
               for (i = 0; i < fixturesAtStartVertex.length; ++ i)
               {
                  var fixture:Object = fixturesAtStartVertex [i];
                  if (fixturesAtHalfFirstIncomingPoint.indexOf (fixture) >= 0)
                  {
                     validFixturesAtStartVertex.push (fixture);
                  }
               }
               
               fixturesAtStartVertex = validFixturesAtStartVertex;
            //}
            
            for (i = 0; i < fixturesAtStartVertex.length; ++ i)
            {
               shape = ((fixturesAtStartVertex [i] as b2Fixture).GetUserData () as PhysicsProxyShape).GetEntityShape ();
               
               shape.mTempData = (shape.mTempData as int) + 1;
//trace (">>>" + shape.ToString () + ": " + shape.mTempData);
            }
         }
         
         // ...
//trace ("********");
//var jjj:int = 0;
         
         var validIntersections:Array = new Array ();
         
         for each (intersection in allIntersections)
         {
            shape = intersection.mUserData as EntityShape;

//trace ("intersection#" + jjj + ": " + (intersection.mIsIncoming ? "in@" : "out@") + intersection.mFraction + ", " + shape.ToString () + ": " + shape.mTempData);
            if (intersection.mIsIncoming)
            {
               if (shape.mTempData <= 0) // should not < 0
               {
//trace ("   new in added");
                  validIntersections.push (intersection);
                  shape.mTempData = 0;
               }
               
               shape.mTempData = (shape.mTempData as int) + 1;
            }
            else
            {
               shape.mTempData = (shape.mTempData as int) - 1;
               
               if (shape.mTempData <= 0) // should not < 0 but possible for box2d's inaccuracy
               {
//trace ("   new out added");
                  validIntersections.push (intersection);
                  shape.mTempData = 0;
               }
            }
         }
         
         // ...
         
         return validIntersections;
      }
      
      private static function IntersectionComparor (iA:b2eRayCastIntersection, iB:b2eRayCastIntersection):int
      {
         if (iA.mFraction > iB.mFraction)
            return 1;
         if (iA.mFraction < iB.mFraction)
            return -1;
         return 0;
      }
      
      public function GetFirstIncomingIntersection (startPointX:Number, startPointY:Number, endPointX:Number, endPointY:Number):Array
      {
         var validIntersections:Array = GetValidIntersectionsWithLineSegment (startPointX, startPointY, endPointX, endPointY);
         var dx:Number = endPointX - startPointX;
         var dy:Number = endPointY - startPointY;
         var segmentLength:Number = Math.sqrt (dx * dx + dy * dy);
         
         for each (var intersection:b2eRayCastIntersection in validIntersections)
         {
            if (intersection.mIsIncoming)
            {
               return [intersection.mUserData as EntityShape, 
                       intersection.mPoint.x, intersection.mPoint.y, 
                       intersection.mNormal.x, intersection.mNormal.y, 
                       intersection.mFraction, segmentLength * intersection.mFraction];
            }
         }
         
         return null;
      }
      
      public function GetFirstOutcomingIntersection (startPointX:Number, startPointY:Number, endPointX:Number, endPointY:Number):Array
      {
         var validIntersections:Array = GetValidIntersectionsWithLineSegment (startPointX, startPointY, endPointX, endPointY);
         var dx:Number = endPointX - startPointX;
         var dy:Number = endPointY - startPointY;
         var segmentLength:Number = Math.sqrt (dx * dx + dy * dy);
         
         for each (var intersection:b2eRayCastIntersection in validIntersections)
         {
            if (! intersection.mIsIncoming)
            {
               return [intersection.mUserData as EntityShape, 
                       intersection.mPoint.x, intersection.mPoint.y, 
                       intersection.mNormal.x, intersection.mNormal.y, 
                       intersection.mFraction, segmentLength * intersection.mFraction];
            }
         }
         
         return null;
      }
      
      public function GetIntersectedShapes (startPointX:Number, startPointY:Number, endPointX:Number, endPointY:Number, includingHalfIntersecteds:Boolean):Array
      {
         var validIntersections:Array = GetValidIntersectionsWithLineSegment (startPointX, startPointY, endPointX, endPointY);
         
         var intersection:b2eRayCastIntersection;
         var shape:EntityShape;
         
         for each (intersection in validIntersections)
         {
            shape = intersection.mUserData as EntityShape;
            shape.mTempData = 0;
         }
         
         var intersectedShapes:Array = new Array ();
         
         for each (intersection in validIntersections)
         {
            shape = intersection.mUserData as EntityShape;
            
            var shapeTempData:int = shape.mTempData as int;
            
            if (intersection.mIsIncoming)
            {
               if (shapeTempData < 2)
               {
                  if (includingHalfIntersecteds)
                  {
                     intersectedShapes.push (shape);
                     shape.mTempData = 2;
                  }
                  else
                  {
                     shape.mTempData = 1;
                  }
               }
            }
            else
            {
               if (shapeTempData < 2)
               {
                  if (includingHalfIntersecteds || shapeTempData > 0)
                  {
                     intersectedShapes.push (shape);
                     shape.mTempData = 2;
                  }
               }
            }
         }
         
         return intersectedShapes;
      }
      
      /*
      public function GetIntersectionSegments (startPointX:Number, startPointY:Number, endPointX:Number, endPointY:Number):Array
      {
         var validIntersections:Array = GetValidIntersectionsWithLineSegment (startPointX, startPointY, endPointX, endPointY);
         var dx:Number = endPointX - startPointX;
         var dy:Number = endPointY - startPointY;
         var segmentLength:Number = Math.sqrt (dx * dx + dy * dy);
         
         var intersection:b2eRayCastIntersection;
         
         // ...
         
         for each (intersection : validIntersections)
         {
            shape = intersection.mUserData as EntityShape;
            shape.mUserData1 = null;
            shape.mUserData2 = null;
         }
         
         // ...
         
         var intersectionSegments:Array = new Array ();
         
         for each (intersection : validIntersections)
         {
            shape = intersection.mUserData as EntityShape;
            
            if (intersection.mIsIncoming)
            {
               if (shape.mUserData2 != null) // shape.mUserData1 must also not null
               {
                  // new segment
                  
                  var itstA:b2eRayCastIntersection = shape.mUserData1 as b2eRayCastIntersection;
                  var itstB:b2eRayCastIntersection = shape.mUserData2 as b2eRayCastIntersection;
                  
                  intersectionSegments.push ([shape, 
                                             itstA.mPoint.x, itstA.mPoint.y, itstA.mNormal.x, itstA.mNormal.y, itstA.mFraction, segmentLength * itstA.mFraction,
                                             itstB.mPoint.x, itstB.mPoint.y, itstB.mNormal.x, itstB.mNormal.y, itstB.mFraction, segmentLength * itstB.mFraction]);
                  
                  shape.mUserData1 = null;
                  shape.mUserData2 = null;
               }
               
               if (shape.mUserData1 == null)
               {
                  shape.mUserData1 = intersection;
               }
            }
            else
            {
               if (shape.mUserData1 != null)
               {
                  shape.mUserData2 = intersection;
               }
            }
         }
         
         // ...
         
         for each (intersection : outcomingIntersections)
         {
            shape = intersection.mUserData as EntityShape;
   
            if (! intersection.mIsIncoming)
            {
               if (shape.mUserData2 == intersection)// shape.mUserData1 must not null
               {
                  var itstA:b2eRayCastIntersection = shape.mUserData1 as b2eRayCastIntersection;
                  var itstB:b2eRayCastIntersection = shape.mUserData2 as b2eRayCastIntersection;
                  
                  intersectionSegments.push ([shape, 
                                             itstA.mPoint.x, itstA.mPoint.y, itstA.mNormal.x, itstA.mNormal.y, itstA.mFraction, segmentLength * itstA.mFraction,
                                             itstB.mPoint.x, itstB.mPoint.y, itstB.mNormal.x, itstB.mNormal.y, itstB.mFraction, segmentLength * itstB.mFraction]);
               }
            }
            
            shape.mUserData1 = null;
            shape.mUserData2 = null;
         }
         
         return intersectionSegments;
      }
      */
      
      /*
      public function GetIntersectionsWithLineSegment (startPointX:Number, startPointY:Number, endPointX:Number, endPointY:Number):Array
      {
         var infos:Array = b2eWorldRayCastCallback.GetIntersectionInfoWithLineSegment (_b2World, 
                                                             b2Vec2.b2Vec2_From2Numbers (startPointX, startPointY), 
                                                             b2Vec2.b2Vec2_From2Numbers (endPointX, endPointY));
         
         var infosNonBox2dSpecified:Array = new Array (infos.length);
         if (infos.length > 0)
         {
            var dx:Number = endPointX - startPointX;
            var dy:Number = endPointY - startPointY;
            var segmentLength:Number = Math.sqrt (dx * dx + dy * dy);
            
            for (var i:int = 0; i < infos.length; ++ i)
            {
               var theInfo:Array = infos [i];
               
               var fixture:b2Fixture = theInfo[0] as b2Fixture;
               var point:b2Vec2 = theInfo[1] as b2Vec2;
               var normal:b2Vec2 = theInfo[2] as b2Vec2;
               var fraction:Number = theInfo[3] as Number;
               
               var entityShape:EntityShape = (fixture.GetUserData () as PhysicsProxyShape).GetEntityShape ();
               infosNonBox2dSpecified [i] = [entityShape, point.x, point.y, normal.x, normal.y, fraction, segmentLength * fraction];
            }
         }
         
         return infosNonBox2dSpecified;
      }
      */
      
      
   }
   
}
