package Box2D {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   //import Box2dEx.BroadPhase.SweepAndPrune.b2eBroadPhase_SweepAndPrune;
   
   public class b2WorldPool 
   {
      public static function AllocB2World (gravity:b2Vec2, autoSleepingEnabled:Boolean = true, pixelsPerMeter:Number = 0.0):b2World
      {
         var worldDef:b2WorldDef = new b2WorldDef ();
         
         worldDef.gravity.CopyFrom (gravity);
         worldDef.doSleep = autoSleepingEnabled;
         
         //worldDef.collisionBroadPhase = new b2eBroadPhase_SweepAndPrune ();
         
         if (pixelsPerMeter != 0)
         {
            worldDef.maxTranslation = b2Settings.b2_maxTranslation * 20.0 / pixelsPerMeter; // default pixelsPerMeter is 20.0
         }
         
         var b2world:b2World = b2World.b2World_FromWorldDefine (worldDef);
         
         return b2world;
      }
      
      public static function ReleaseB2World (b2world:b2World):void
      {
         b2world.SetContactFilter   (b2ContactManager.b2_defaultFilter);
         b2world.SetContactListener (b2ContactManager.b2_defaultListener);
      }
      
   }
}