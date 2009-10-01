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
      /*
      private static var s_b2WorldInfoArray:Array = new Array ();
      private static var s_NumUsedB2Worlds:int = 0;
      
      public static function AllocB2World (worldAABB:b2AABB, gravity:b2Vec2, doSleep:Boolean, worldDef:b2eWorldDef):b2World
      {
         var object:Object = null;
         var b2world:b2World = null;
         var i:int;
         
         // try to find an old unused one
         
         if (worldDef == null)
            worldDef = new b2WorldDef ();
         
         for (i = s_NumUsedB2Worlds; i < s_b2WorldInfoArray.length; ++ i)
         {
            object = s_b2WorldInfoArray [i];
            b2world = object.mB2World;
            
            if (worldDef.EqualsWith (b2world.m_worldDef))
               break;
         }
         
         if (i < s_b2WorldInfoArray.length)
         {
            object = s_b2WorldInfoArray [i];
            
            b2world = object.mB2World;
            
            if (Compile::Is_Debugging)
            {
               trace ("b2World #" + object.mB2WorldID + " is reused. (" + b2world.m_worldDef.b2_maxProxies + ", " + b2world.m_worldDef.b2_maxPairs + ")");
            }
            
            if (i > s_NumUsedB2Worlds)
            {
               s_b2WorldInfoArray [i] = s_b2WorldInfoArray [s_NumUsedB2Worlds];
               s_b2WorldInfoArray [s_NumUsedB2Worlds] = object;
            }
            
            ++ s_NumUsedB2Worlds;
            
            b2world.SetContactListener     (object.mB2ContactListener_old);
            b2world.SetDestructionListener (object.mB2DestructionListener_old);
            b2world.SetContactFilter       (object.mB2ContactFilter_old);
            
            b2world.Reset (worldAABB, gravity, doSleep);
         }
         else
         {
            b2world = new b2World(worldAABB, gravity, doSleep, worldDef);
            
            object = new Object ();
            object.mB2World                   = b2world;
            object.mB2WorldID                 = s_b2WorldInfoArray.length;
            object.mB2ContactListener_old     = b2world.m_contactListener;
            object.mB2DestructionListener_old = b2world.m_destructionListener;
            object.mB2ContactFilter_old       = b2world.m_contactFilter;
            
            if (s_NumUsedB2Worlds < s_b2WorldInfoArray.length)
            {
               s_b2WorldInfoArray.push (s_b2WorldInfoArray [s_NumUsedB2Worlds]);
               s_b2WorldInfoArray [s_NumUsedB2Worlds] = object;
            }
            else
            {
               s_b2WorldInfoArray.push (object);
            }
            ++ s_NumUsedB2Worlds;
            
            if (Compile::Is_Debugging)
            {
               trace ("b2World #" + object.mB2WorldID + " is created. worldDef = " + worldDef.b2_maxProxies + ", " + worldDef.b2_maxPairs);
            }
         }
         
         return b2world;
      }
      
      public static function ReleaseB2World (b2world:b2World):void
      {
         var object:Object = null;
         var i:int;
         for (i = 0; i < s_b2WorldInfoArray.length; ++ i)
         {
            object = s_b2WorldInfoArray [i];
            if (object.mB2World == b2world)
               break;
         }
         
         if (object != null)
         {
            if (i >= s_b2WorldInfoArray.length)
            {
               trace ("i >= s_b2WorldInfoArray.length");
               return;
            }
            
            if (i >= s_NumUsedB2Worlds)
            {
               trace ("i >= s_NumUsedB2Worlds (" + s_NumUsedB2Worlds + ")");
               return;
            }
            
            -- s_NumUsedB2Worlds;
            
            s_b2WorldInfoArray [i] = s_b2WorldInfoArray [s_NumUsedB2Worlds];
            s_b2WorldInfoArray [s_NumUsedB2Worlds] = object;
            
            if (Compile::Is_Debugging)
            {
               trace ("b2World #" + object.mB2WorldID + " is released. s_NumUsedB2Worlds = " + s_NumUsedB2Worlds);
            }
            
            b2world.SetContactListener     (object.mB2ContactListener_old);
            b2world.SetDestructionListener (object.mB2DestructionListener_old);
            b2world.SetContactFilter       (object.mB2ContactFilter_old);
         }
      }
      */
      
      public static function AllocB2World (worldAABB:b2AABB, gravity:b2Vec2, doSleep:Boolean, _worldDef:b2eWorldDef):b2World
      {
         var worldDef:b2WorldDef = new b2WorldDef ();
         worldDef.gravity.CopyFrom (gravity);
         worldDef.doSleep = doSleep;
         worldDef.collisionBroadPhase = new b2eBroadPhase_SweepAndPrune ();
         var b2world:b2World = new b2World(null);
         
         b2eWorldHelper.CreateGroundBody (b2world);
         
         return b2world;
      }
      
      public static function ReleaseB2World (b2world:b2World):void
      {
      }
      
   }
}