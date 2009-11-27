package Box2D {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   import Box2dEx.Helper.b2eWorldHelper;
   import Box2dEx.BroadPhase.SweepAndPrune.b2eBroadPhase_SweepAndPrune;
   
   public class b2WorldPool 
   {
      public static function AllocB2World (gravity:b2Vec2):b2World
      {
         var worldDef:b2WorldDef = new b2WorldDef ();
         
         worldDef.gravity.CopyFrom (gravity);
         worldDef.doSleep = true;
         worldDef.collisionBroadPhase = null;
         //worldDef.collisionBroadPhase = new b2eBroadPhase_SweepAndPrune ();
         
         var b2world:b2World = new b2World(worldDef);
         
         return b2world;
      }
      
      public static function ReleaseB2World (b2world:b2World):void
      {
         b2world.SetContactFilter   (b2ContactManager.b2_defaultFilter);
         b2world.SetContactListener (b2ContactManager.b2_defaultListener);
      }
      
   }
}