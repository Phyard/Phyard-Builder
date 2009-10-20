
package Box2dEx.Helper {
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.b2QueryCallback;
   import Box2D.Dynamics.b2RayCastCallback;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2BodyDef;
   
   public class b2eFixtureHelper
   {
      // to commit this density change, a body.ResetMass () calling is needed
      public static function SetDensity (fixture:b2Fixture, density:Number):void
      {
         fixture.GetShape ().ComputeMass(fixture.GetMassData (), density);
      }
   }
}