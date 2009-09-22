
package Box2dEx.Helper {
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.b2QueryCallback;
   import Box2D.Dynamics.b2RayCastCallback;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   
   public class b2eWorldHelper
   {
      public static function WakeUpAllBodies (world:b2World):void
      {
         var b:b2Body = world.m_bodyList;
         
         while (b != null)
         {
            b.WakeUp ();
            b = b.m_next;
         }
      }

      public static function GetFixturesContainPoint (world:b2World, displayX:Number, displayY:Number, setMaxShapeIndex:Boolean = false):Array
      {
         return null;
      }

      public static function GetFixturesIntersectWithAABB (world:b2World, displayX:Number, displayY:Number):Array
      {
         return null;
      }

   }
}