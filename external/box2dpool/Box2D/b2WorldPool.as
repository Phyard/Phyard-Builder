package Box2D {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   public class b2WorldPool 
   {
      private static var s_b2WorldInfoArray:Array = new Array ();
      private static var s_NumUsedB2Worlds:int = 0;
      
      public static function AllocB2World (worldAABB:b2AABB, gravity:b2Vec2, doSleep:Boolean):b2World
      {
         var object:Object = null;
         var b2world:b2World = null;
         
         if (s_NumUsedB2Worlds >= s_b2WorldInfoArray.length)
         {
            b2world = new b2World(worldAABB, gravity, doSleep);
            
            object = new Object ();
            object.mB2World                   = b2world;
            object.mB2WorldID                 = s_b2WorldInfoArray.length;
            object.mB2ContactListener_old     = b2world.m_contactListener;
            object.mB2DestructionListener_old = b2world.m_destructionListener;
            object.mB2ContactFilter_old       = b2world.m_contactFilter;
            
            s_b2WorldInfoArray.push (object);
            
            //trace ("b2World #" + object.mB2WorldID + " is created.");
            
            ++ s_NumUsedB2Worlds;
         }
         else
         {
            object = s_b2WorldInfoArray [s_NumUsedB2Worlds];
            
            //trace ("b2World #" + object.mB2WorldID + " is reused.");
            
            ++ s_NumUsedB2Worlds;
            
            b2world = object.mB2World;
            
            b2world.SetContactListener     (object.mB2ContactListener_old);
            b2world.SetDestructionListener (object.mB2DestructionListener_old);
            b2world.SetContactFilter       (object.mB2ContactFilter_old);
            
            b2world.Reset (worldAABB, gravity, doSleep);
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
               trace ("i >= s_NumUsedB2Worlds");
               return;
            }
            
            -- s_NumUsedB2Worlds;
            
            s_b2WorldInfoArray [i] = s_b2WorldInfoArray [s_NumUsedB2Worlds];
            s_b2WorldInfoArray [s_NumUsedB2Worlds] = object;
            
            //trace ("b2World #" + object.mB2WorldID + " is released.");
            
            b2world.SetContactListener     (object.mB2ContactListener_old);
            b2world.SetDestructionListener (object.mB2DestructionListener_old);
            b2world.SetContactFilter       (object.mB2ContactFilter_old);
         }
      }
      
   }
}