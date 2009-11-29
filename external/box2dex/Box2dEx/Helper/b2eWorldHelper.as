
package Box2dEx.Helper {
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.b2QueryCallback;
   import Box2D.Dynamics.b2RayCastCallback;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2BodyDef;
   
   public class b2eWorldHelper
   {
      public static function WakeUpAllBodies (world:b2World):void
      {
         var b:b2Body = world.m_bodyList;
         
         while (b != null)
         {
            b.SetAwake (true);
            b = b.m_next;
         }
      }
   }
}