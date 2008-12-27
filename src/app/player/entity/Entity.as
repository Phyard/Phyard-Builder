
package player.entity {
   
   import flash.display.Sprite;
   
   import player.world.World;
   
   import player.physics.PhysicsProxy;
   
   public class Entity extends Sprite
   {
      
      protected var mWorld:World;
      
      public var mPhysicsProxy:PhysicsProxy = null;
      
      public function Entity (world:World)
      {
         mWorld = world;
      }
      
      public function Update (dt:Number):void
      {
      }
      
      public function Destroy ():void
      {
         if (mPhysicsProxy != null)
            mPhysicsProxy.Destroy ();
      }
      
      public function SetRotation (rot:Number):void
      {
         rotation = (rot * 180.0 / Math.PI) % 360;
      }
      
      
//=============================================================
//   
//=============================================================
      
      public function RebuildAppearance ():void
      {
      }
      
      public function BuildPhysicsProxy (params:Object):void
      {
      }
      
      
   }
}
