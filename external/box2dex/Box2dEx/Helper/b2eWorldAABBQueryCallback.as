
package Box2dEx.Helper {
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.b2QueryCallback;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Collision.b2AABB;
   
   public class b2eWorldAABBQueryCallback implements b2QueryCallback
   {
      public static function GetFixturesIntersectWithAABB (world:b2World, aabb:b2AABB, maxHits:int = 0):Array
      {
         var callback:b2eWorldAABBQueryCallback = new b2eWorldAABBQueryCallback (maxHits);
         
         world.QueryAABB (callback, aabb);
         
         return callback.GetHits (); // .slice ()
      }

      public static function GetFixturesContainPoint (world:b2World, point:b2Vec2, maxHits:int = 0):Array
      {
         const kWindowSize:Number = 0.0; // 3.0;
         var aabb:b2AABB = new b2AABB ();
         aabb.lowerBound.Set (point.x - kWindowSize, point.y - kWindowSize);
         aabb.upperBound.Set (point.x + kWindowSize, point.y + kWindowSize);
         
         var callback:b2eWorldAABBQueryCallback = new b2eWorldAABBQueryCallback (maxHits, point);
         
         world.QueryAABB (callback, aabb);
         
         return callback.GetHits (); // .slice ()
      }

//================================================================================
// 
//================================================================================

      protected var mMaxHits:int;
      protected var mNumHits:int;
      protected var mHits:Array;
      
      protected var mContainedPoint:b2Vec2 = null;

      public function b2eWorldAABBQueryCallback(maxHits:int = 0, containedPoint:b2Vec2 = null)
      {
         mMaxHits = maxHits;
         mNumHits = 0;
         mHits = new Array ();
         
         if (containedPoint != null)
         {
            mContainedPoint = containedPoint.Clone ();
         }
      }

      public function GetHits ():Array
      {
         return mHits;
      }

      /// Called for each fixture found in the query AABB.
      /// @return false to terminate the query.
      public function ReportFixture(fixture:b2Fixture):Boolean
      {
         if (mContainedPoint != null && ! fixture.TestPoint(mContainedPoint))
         {
            return true;
         }
         
      trace ("333");
         mHits.push (fixture);
         ++ mNumHits;
         
        return mMaxHits <= 0 || mNumHits < mMaxHits;
      }

   } // class
} // pacakge
