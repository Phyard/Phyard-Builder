
package Box2dEx.Helper {
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.b2RayCastCallback;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Fixture;
   
   public class b2eWorldRayCastCallback implements b2RayCastCallback
   {
      public static function GetFixturesIntersectWithLineSegment (world:b2World, point1:b2Vec2, point2:b2Vec2):Array
      {
         var callback:b2eWorldRayCastCallback = new b2eWorldRayCastCallback ();
         world.RayCast (callback, point1, point2);
         
         var hits:Array = GetHits ();
         
         var intersected_fixtures:Array = new Array (hits.length);
         for (var i:int = 0; i < hits.length; ++ i)
         {
            intersected_fixtures [i] = hits [i][0];
         }
         
         return intersected_fixtures;
      }

//=================================================================
// 
//=================================================================

      protected var mMaxHits:int;
      protected var mNumHits:int;
      protected var mHits:Array;

      public function b2eWorldRayCastCallback (maxHits:int = 0)
      {
         mMaxHits = maxHits;
         mNumHits = 0;
         mHits = new Array ();
      }

      public function GetHits ():Array
      {
         return mHits;
      }

      /// Called for each fixture found in the query. You control how the ray proceeds
      /// by returning a float that indicates the fractional length of the ray. By returning
      /// 0, you set the ray length to zero. By returning the current fraction, you proceed
      /// to find the closest point. By returning 1, you continue with the original ray
      /// clipping.
      /// @param fixture the fixture hit by the ray
      /// @param point the point of initial intersection
      /// @param normal the normal vector at the point of intersection
      /// @return 0 to terminate, fraction to clip the ray for
      /// closest hit, 1 to continue
      public function ReportFixture (fixture:b2Fixture, point:b2Vec2,
                              normal:b2Vec2, fraction:Number):Number
      {
         mHits.push ([fixture, point, normal, fraction]);
         ++ mNumHits;
         
         return (mMaxHits <= 0 || mNumHits < mMaxHits) ? 1 : 0;
      }

   } // class
} // pacakge
