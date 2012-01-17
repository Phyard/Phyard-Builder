
package Box2dEx.Helper {

   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.b2Fixture;

   public class b2eRayCastIntersection
   {
      public var mFixture:b2Fixture;
      public var mPoint:b2Vec2;
      public var mNormal:b2Vec2;
      public var mFraction:Number;
      public var mIsIncoming:Boolean;
      public var mUserData:Object;
      public function b2eRayCastIntersection (fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number)
      {
         mFixture = fixture;
         mPoint = point;
         mNormal = normal;
         mFraction = fraction;
      }

   } // class
} // pacakge
