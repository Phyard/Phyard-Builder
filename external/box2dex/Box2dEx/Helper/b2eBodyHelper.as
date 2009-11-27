
package Box2dEx.Helper {
   
   import Box2D.Common.b2Vec2;
   import Box2D.Dynamics.b2QueryCallback;
   import Box2D.Dynamics.b2RayCastCallback;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2BodyDef;
   
   public class b2eBodyHelper
   {
      public static function SetStatic (body:b2Body, static:Boolean):void
      {
         body.SetStatic (static);
      }
      
      public static function SetAutoUpdateMass (body:b2Body, auto:Boolean):void
      {
         body.SetAutoUpdateMass (auto);
      }
      
      public static function CoincideWithCentroid (body:b2Body):void
      {
         body.CoincideWithCentroid ();
      }
      
      public static function SetPosition (body:b2Body, x:Number, y:Number):void
      {
         body.SetPosition (x, y);
      }
      
      public static function SetFixRotation (body:b2Body, fixRotation:Boolean):void
      {
         body.SetFixRotation (fixRotation);
      }
      
      public static function IsFixRotation (body:b2Body):Boolean
      {
         return body.IsFixRotation ();
      }
   }
}